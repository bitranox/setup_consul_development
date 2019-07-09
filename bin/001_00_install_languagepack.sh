#!/bin/bash

function get_sudo_exists {
    # we need this for travis - there is no sudo command !
    if [[ -f /usr/bin/sudo ]]; then
        echo "True"
    else
        echo "False"
    fi
}

function get_sudo_command {
    # we need this for travis - there is no sudo command !
    if [[ $(get_sudo_exists) == "True" ]]; then
        local sudo_command="sudo"
        echo ${sudo_command}
    else
        local sudo_command=""
        echo ${sudo_command}
    fi
}

function update_myself {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    "${my_dir}/000_00_update_myself.sh" "${@}" || exit 0              # exit old instance after updates
}

function include_dependencies {
    source /usr/lib/lib_bash/lib_color.sh
    source /usr/lib/lib_bash/lib_retry.sh
    source /usr/lib/lib_bash/lib_helpers.sh
    source /usr/lib/lib_bash/lib_install.sh
}


update_myself ${0} ${@}  # pass own script name and parameters
include_dependencies
wait_for_enter "Installiere deutsche Sprachpakete"
install_essentials                  # @lib_install.sh
linux_update                        # @lib_bash/lib_helpers.sh
install_and_update_language_packs   # @lib_install.sh

if [[ $(($?)) = 0 ]]; then
    banner "deutsche Sprachpakete sind aktuell"
else
    wait_for_enter_warning "deutsche Sprachpakete installiert - ein Neustart ist erforderlich, Enter rebootet die Maschine - offene Dokumente vorher sichern !"
    reboot
fi
