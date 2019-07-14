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
    source /usr/local/lib_bash_install/001_000_install_language_packs.sh
    source /usr/local/lib_bash_install/900_000_lib_install_basics.sh
}


include_dependencies


wait_for_enter "Installiere deutsche Sprachpakete"
install_essentials                  # @lib_bash_install
linux_update                        # @lib_bash/lib_helpers.sh

banner "Install and Update Language Packs"
install_language_packs "de_AT"  # @lib_bash_install/900_000_lib_install_basics.sh

if [[ "$?" == "0" ]]; then
    banner "deutsche Sprachpakete sind aktuell"
else
    wait_for_enter_warning "deutsche Sprachpakete installiert${IFS}ein Neustart ist erforderlich, Enter rebootet die Maschine${IFS}offene Dokumente vorher sichern !"
    reboot
fi
