#!/bin/bash

function update_myself {
    /usr/local/setup_consul_development/install_or_update.sh "${@}" || exit 0              # exit old instance after updates
}

update_myself ${0}

function include_dependencies {
    source /usr/local/lib_bash/lib_color.sh
    source /usr/local/lib_bash/lib_retry.sh
    source /usr/local/lib_bash/lib_helpers.sh
    source /usr/local/lib_bash_install/005_000_lib_install_lxd_container_system.sh
    source /usr/local/lib_bash_install/006_000_lib_configure_lxd_container_system.sh
    source /usr/local/lib_bash_install/900_000_lib_install_basics.sh
}


include_dependencies

wait_for_enter "Konfiguriere LXD Container System"
install_essentials
linux_update
add_user_to_lxd_group "${USER}"  # @lib_bash_install/005_000_lib_install_lxd_container_system.sh
lxd_init
set_uids
create_shared_directory
configure_lxd_bridge_zone "lxc"
extend_default_profile
banner "LXD fertig konfiguriert"
