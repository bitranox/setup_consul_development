#!/bin/bash

function include_dependencies {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    sudo chmod -R +x "${my_dir}"/*.sh
    sudo chmod -R +x "${my_dir}"/lib_bash/*.sh
    sudo chmod -R +x "${my_dir}"/lib_install/*.sh
    source "${my_dir}/lib_bash/lib_color.sh"
    source "${my_dir}/lib_bash/lib_retry.sh"
    source "${my_dir}/lib_bash/lib_helpers.sh"
    source "${my_dir}/lib_install/install_essentials.sh"
    source "${my_dir}/lib_install/linux_update.sh"
}

include_dependencies  # we need to do that via a function to have local scope of my_dir

function create_container_disco {
    # parameter: $1 = container_name
    local container_name=$1
    banner "Erzeuge Container ${container_name}"
    lxc launch ubuntu:disco "${container_name}"
}

function create_lxc_user {
    # parameter: $1 = container_name, $2=user_name
    local container_name=$1
    local user_name=$2
    banner "Container ${container_name}: lege LXC User ${user_name} an - bitte geben Sie das Passwort (Vorschlag) \"consul\" ein"
    lxc exec "${container_name}" -- sh -c "adduser ${user_name}"
    lxc exec "${container_name}" -- sh -c "usermod -aG sudo ${user_name}"
}

function lxc_update {
    # parameter: $1 = container_name
    local container_name=$1
    retry lxc exec "${container_name}" -- sh -c "sudo apt-get update"
    retry lxc exec "${container_name}" -- sh -c "sudo apt-get upgrade -y"
    retry lxc exec "${container_name}" -- sh -c "sudo apt-get dist-upgrade -y"
}

function lxc_reboot {
    # parameter: $1 = container_name
    local container_name=$1
    lxc stop "${container_name}" -f
    lxc start "${container_name}"
}

function install_scripts_on_lxc_container {
    # parameter: $1 = container_name
    local container_name=$1
    banner "Container ${container_name}: lege Install Scripte an"
    retry lxc exec "${container_name}" -- sh -c "sudo rm -Rf ./consul-dev-env-public"
    retry lxc exec "${container_name}" -- sh -c "sudo apt-get install git -y"
    retry lxc exec "${container_name}" -- sh -c "git clone https://github.com/bitranox/consul-dev-env-public.git"
    retry lxc exec "${container_name}" -- sh -c "sudo chmod -R +x ./consul-dev-env-public/bin/*.sh"
}




wait_for_enter "Erzeuge einen sauberen LXC-Container lxc-clean, user=consul, pwd=consul, DNS Name = lxc-clean.lxd"
install_essentials
linux_update
create_container_disco lxc-clean
create_lxc_user lxc-clean consul
install_scripts_on_lxc_container lxc-clean





## make it possible to call functions without source include
# Check if the function exists (bash specific)
if [[ ! -z "$1" ]]
    then
        if declare -f "${1}" > /dev/null
        then
          # call arguments verbatim
          "$@"
        else
          # Show a helpful error
          function_name="${1}"
          library_name="${0}"
          fail "\"${function_name}\" is not a known function name of \"${library_name}\""
        fi
	fi

