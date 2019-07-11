#!/bin/bash

function update_myself {
    /usr/local/setup_consul_development/install_or_update.sh "${@}" || exit 0              # exit old instance after updates
}


function include_dependencies {
    source /usr/local/lib_bash/lib_color.sh
    source /usr/local/lib_bash/lib_retry.sh
    source /usr/local/lib_bash/lib_helpers.sh
    source /usr/local/lib_bash_install/900_000_lib_install_basics.sh
}

function install_lxd_container_system {
    banner "snap Install LXD"
    # install snap
    retry $(which sudo) apt-get install snap -y
    # install lxd
    retry $(which sudo) snap install lxd
}


function add_user_to_lxd_group {
    banner "LXD Init"
    # add current user to lxd group
    $(which sudo) usermod --append --groups lxd "${USER}"
    # join the group for this session - not as root !
    # init LXD - not as root !
}

update_myself ${0} ${@}  # pass own script name and parameters
include_dependencies
wait_for_enter "Installiere LXD Container System"
install_essentials
linux_update
install_lxd_container_system
add_user_to_lxd_group
wait_for_enter_warning "LXD Container System fertig installiert${IFS}ein Neustart ist erforderlich, Enter rebootet die Maschine${IFS}offene Dokumente vorher sichern !"
reboot
