#!/bin/bash

function get_sudo_exists {
    # we need this for travis - there is no sudo command !
    if [[ -f /usr/bin/sudo ]]; then
        echo "True"
    else
        echo "False"
    fi
}

function get_sudo_command_prefix {
    # we need this for travis - there is no sudo command !
    if [[ $(get_sudo_exists) == "True" ]]; then
        local sudo_cmd_prefix="sudo"
        echo ${sudo_cmd_prefix}
    else
        local sudo_cmd_prefix=""
        echo ${sudo_cmd_prefix}
    fi
}


function include_dependencies {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    local sudo_command_prefix=$(get_sudo_command_prefix)
    ${sudo_command_prefix} chmod -R +x "${my_dir}"/*.sh
    ${sudo_command_prefix} chmod -R +x "${my_dir}"/lib_install/*.sh
    source "${my_dir}/000_update_myself.sh"
    source /usr/lib/lib_bash/lib_color.sh
    source /usr/lib/lib_bash/lib_retry.sh
    source /usr/lib/lib_bash/lib_helpers.sh
    source /usr/lib/lib_bash/lib_lxc_helpers.sh
    source "${my_dir}/lib_install/install_essentials.sh"
}

include_dependencies  # we need to do that via a function to have local scope of my_dir

function create_container_disco {
    # parameter: $1 = container_name
    local container_name=$1
    banner "Erzeuge Container ${container_name}"
    lxc stop "${container_name}"
    lxc delete "${container_name}"
    lxc launch ubuntu:disco "${container_name}"
}


container_name="lxc-clean-disco-server"
profile_name="map-lxc-shared"
lxc_user_name="consul"
wait_for_enter "Erzeuge einen sauberen LXC-Container ${container_name}, user=${lxc_user_name}, pwd=consul, DNS Name = ${container_name}.lxd"
create_container_disco "${container_name}"
lxc_reboot "${container_name}"
banner "LXC-Container fertig"
