#!/bin/bash


sudo_askpass="$(command -v ssh-askpass)"
export SUDO_ASKPASS="${sudo_askpass}"
export NO_AT_BRIDGE=1  # get rid of (ssh-askpass:25930): dbind-WARNING **: 18:46:12.019: Couldn't register with accessibility bus: Did not receive a reply.

# call the update script if not sourced
if [[ "${0}" == "${BASH_SOURCE[0]}" ]] && [[ -d "${BASH_SOURCE%/*}" ]]; then "${BASH_SOURCE%/*}"/install_or_update.sh else "${PWD}"/install_or_update.sh ; fi


function include_dependencies {
    source /usr/local/lib_bash/lib_color.sh
    source /usr/local/lib_bash/lib_retry.sh
    source /usr/local/lib_bash/lib_helpers.sh
    source /usr/local/lib_bash_install/001_000_lib_install_language_packs.sh
    source /usr/local/lib_bash_install/004_000_lib_install_tools.sh
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
