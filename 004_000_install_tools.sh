#!/bin/bash


function update_myself {
    /usr/local/setup_consul_development/install_or_update.sh "${@}" || exit 0              # exit old instance after updates
}

update_myself ${0} ${@}  # pass own script name and parameters


function include_dependencies {
    source /usr/local/lib_bash/lib_color.sh
    source /usr/local/lib_bash/lib_retry.sh
    source /usr/local/lib_bash/lib_helpers.sh
    source /usr/local/lib_bash_install/001_000_install_language_packs.sh
    source /usr/local/lib_bash_install/004_000_install_tools.sh
    source /usr/local/lib_bash_install/900_000_lib_install_basics.sh
}

include_dependencies

wait_for_enter "Notwendige und nützliche Tools werden installiert"
install_essentials
linux_update
install_diverse_tools
install_chrome
install_chrome_remote_desktop
install_language_packs "de_AT"  # @lib_bash_install/900_000_lib_install_basics.sh
banner "Notwendige und nützliche Tools sind installiert"
