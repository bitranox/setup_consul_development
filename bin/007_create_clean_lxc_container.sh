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
    banner "Erzeuge Container"
    retry lxc launch ubuntu:disco lxc-clean
}

function create_lxc_user_consul {
    banner "Lege LXC User 'consul' an - bitte geben Sie das Passwort 'consul' ein"
    lxc exec lxc-clean -- sh -c "adduser consul"
    lxc exec lxc-clean -- sh -c "usermod -aG sudo consul"
}

function lxc_update{
    lxc exec lxc-consul-clean -- sh -c "sudo apt-get update"
    lxc exec lxc-consul-clean -- sh -c "sudo apt-get upgrade -y"
    lxc exec lxc-consul-clean -- sh -c "sudo apt-get dist-upgrade -y"
}

function lxc_reboot{
    lxc stop lxc-clean -f
    lxc start lxc-clean
}

function add_languagepack_de {
    banner "Installiere Languagepack Deutsch"
    lxc_update
    lxc exec lxc-consul-clean -- sh -c "sudo apt-get install language-pack-de -y"
    lxc exec lxc-consul-clean -- sh -c "sudo apt-get install language-pack-de-base -y"
    lxc_reboot
}




wait_for_enter "Erzeuge einen sauberen LXC-Container lxc-clean, user=consul, pwd=consul, DNS Name = lxc-clean.lxd"
install_essentials
linux_update
create_container_disco
create_lxc_user_consul



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

