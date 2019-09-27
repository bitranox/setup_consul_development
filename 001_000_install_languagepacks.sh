#!/bin/bash

dbg="False"

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
    source /usr/local/lib_bash_install/900_000_lib_install_basics.sh
}

include_dependencies

linux_update   # on a fresh server install we can not find package dialog without updating first

wait_for_enter "Installiere deutsche Sprachpakete"
debug "${dbg}" "before install_essentials"
install_essentials                  # @lib_bash_install
debug "${dbg}" "before linux updates"
linux_update                        # @lib_bash/lib_helpers.sh

banner_level "Install and Update Language Packs"
install_language_packs "de_AT"  # @lib_bash_install/900_000_lib_install_basics.sh

if [[ "$?" == "0" ]]; then
    banner_level "deutsche Sprachpakete sind aktuell"
else
    wait_for_enter_warning "deutsche Sprachpakete installiert${IFS}ein Neustart ist erforderlich, Enter rebootet die Maschine${IFS}offene Dokumente vorher sichern !"
    reboot
fi
