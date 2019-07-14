#!/bin/bash


function update_myself {
    /usr/local/setup_consul_development/install_or_update.sh "${@}" || exit 0              # exit old instance after updates
}

if [[ ! -z "$1" ]] && declare -f "${1}" ; then
    update_myself ${0}
else
    update_myself ${0} ${@}  > /dev/null 2>&1  # suppress messages here, not to spoil up answers from functions  when called verbatim
fi


function include_dependencies {
    source /usr/local/lib_bash/lib_color.sh
    source /usr/local/lib_bash/lib_retry.sh
    source /usr/local/lib_bash/lib_helpers.sh
    source /usr/local/lib_bash_install/002_000_install_ubuntu_mate_desktop.sh
    source /usr/local/lib_bash_install/900_000_lib_install_basics.sh
}


include_dependencies


wait_for_enter "Installiere Ubuntu Mate Desktop - bitte Lightdm als Default Displaymanager auswählen"
install_ubuntu_mate_desktop_recommended "8GB"   # 8GB Swapsize
wait_for_enter_warning "Ubuntu Mate Desktop installiert${IFS}ein Neustart ist erforderlich, Enter rebootet die Maschine${IFS}offene Dokumente vorher sichern !"
reboot
