#!/bin/bash

function update_myself {
    /usr/local/setup_consul_development/install_or_update.sh "${@}" || exit 0              # exit old instance after updates
}

update_myself ${0}

function include_dependencies {
    source /usr/local/lib_bash/lib_color.sh
    source /usr/local/lib_bash/lib_retry.sh
    source /usr/local/lib_bash/lib_helpers.sh
    source /usr/local/lib_bash_install/005_000_install_lxd_container_system.sh
    source /usr/local/lib_bash_install/900_000_lib_install_basics.sh
}


include_dependencies


wait_for_enter "Installiere LXD Container System"
install_essentials
linux_update
install_lxd_container_system        # @lib_bash_install/005_000_install_lxd_container_system.sh
add_user_to_lxd_group "${USER}"     # @lib_bash_install/005_000_install_lxd_container_system.sh
wait_for_enter_warning "LXD Container System fertig installiert${IFS}ein Neustart ist erforderlich, Enter rebootet die Maschine${IFS}offene Dokumente vorher sichern !"
reboot
