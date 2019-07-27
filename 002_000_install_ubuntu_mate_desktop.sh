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
    source /usr/local/lib_bash_install/002_000_lib_install_ubuntu_mate_desktop.sh
    source /usr/local/lib_bash_install/900_000_lib_install_basics.sh
}


include_dependencies

wait_for_enter "Installiere Ubuntu Mate Desktop - bitte Lightdm als Default Displaymanager auswählen"
install_ubuntu_mate_desktop_recommended "8GB"   # 8GB Swapsize
wait_for_enter_warning "Ubuntu Mate Desktop installiert${IFS}ein Neustart ist erforderlich, Enter rebootet die Maschine${IFS}offene Dokumente vorher sichern !"
reboot
