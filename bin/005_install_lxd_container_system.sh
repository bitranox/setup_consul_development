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

function install_lxd_container_system {
    banner "snap Install LXD"
    # install snap
    retry sudo apt-get install snap -y
    # install lxd
    retry sudo snap install lxd
}


function add_user_to_lxd_group {
    banner "LXD Init"
    # add current user to lxd group
    sudo usermod --append --groups lxd "${USER}"
    # join the group for this session - not as root !
    # init LXD - not as root !
}

wait_for_enter "Installiere LXD Container System"
install_essentials
linux_update
install_lxd_container_system
add_user_to_lxd_group
wait_for_enter_warning "LXD Container System fertig installiert - ein Neustart ist erforderlich, Enter rebootet die Maschine - offene Dokumente vorher sichern !"
reboot


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

