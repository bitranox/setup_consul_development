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


function include_dependencies {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    local sudo_command=$(get_sudo_command)
    ${sudo_command} chmod -R +x "${my_dir}"/*.sh
    ${sudo_command} chmod -R +x "${my_dir}"/lib_install/*.sh
    "${my_dir}/000_00_update_myself.sh" "${@}" || exit 0              # exit old instance after update
    source /usr/lib/lib_bash/lib_color.sh
    source /usr/lib/lib_bash/lib_retry.sh
    source /usr/lib/lib_bash/lib_helpers.sh
    source "${my_dir}/lib_install/install_essentials.sh"
}

include_dependencies "${0}" "${@}" # pass own script name and parameters

function remove_unnecessary {
    ### remove Canonical Reporting
    local sudo_command=$(get_sudo_command)
    ${sudo_command} apt-get purge whoopsie -y
    ${sudo_command} apt-get purge libwhoopsie0 -y
    ${sudo_command} apt-get purge libwhoopsie-preferences0 -y
    ${sudo_command} apt-get purge apport -y
    ### Spelling
    ${sudo_command} apt-get purge aspell -y
    ### Bluetooth
    ${sudo_command} apt-get purge blueman -y
    ${sudo_command} apt-get purge bluez -y
    ${sudo_command} apt-get purge bluez-cups -y
    ${sudo_command} apt-get purge bluez-obexd -y
    # CD Brenner
    ${sudo_command} apt-get purge brasero -y
    ${sudo_command} apt-get purge brasero-cdrkit -y
    ${sudo_command} apt-get purge brasero-common -y
    ${sudo_command} apt-get purge cdrdao -y
    ${sudo_command} apt-get purge dvd+rw-tools -y
    ${sudo_command} apt-get purge dvdauthor -y
    ${sudo_command} apt-get purge growisofs -y
    ${sudo_command} apt-get purge libburn4 -y
    # Musik
    ${sudo_command} apt-get purge rhythmbox -y
    ${sudo_command} apt-get purge rhythmbox-data -y
    # Braille für Blinde
    ${sudo_command} apt-get purge brltty -y
    ${sudo_command} apt-get purge libbrlapi0.6 -y
    ${sudo_command} apt-get purge xzoom -y
    # Webcam
    ${sudo_command} apt-get purge cheese -y
    ${sudo_command} apt-get purge cheese-common -y
    # Taschenrechner
    ${sudo_command} apt-get purge dc -y
    # editoren / Terminals
    ${sudo_command} apt-get purge enchant -y
    ${sudo_command} apt-get purge gedit -y
    ${sudo_command} apt-get purge gedit-common -y
    ${sudo_command} apt-get purge pluma-common -y
    ${sudo_command} apt-get purge tilda -y
    ${sudo_command} apt-get purge vim -y
    # Bildbetrachter / Scanner
    ${sudo_command} apt-get purge eog -y
    ${sudo_command} apt-get purge shotwell-common -y
    ${sudo_command} apt-get purge simple-scan -y
    # Sprachausgabe
    ${sudo_command} apt-get purge espeak-ng-data -y
    # Dateibetrachter
    ${sudo_command} apt-get purge evince-common -y
    # video
    ${sudo_command} apt-get purge ffmpegthumbnailer -y
    # gdm3 Gnome Display Manager
    ${sudo_command} apt-get purge gdm3 -y
    # Bildbearbeitung
    ${sudo_command} apt-get purge imagemagick-6.q16 -y
    # Libre Office
    ${sudo_command} apt-get purge libreoffice-common -y
    ${sudo_command} apt-get purge ure -y
    # Dateimanager
    ${sudo_command} apt-get purge nautilus -y
    ${sudo_command} apt-get purge nautilus-data -y
    ${sudo_command} apt-get purge nautilus-extension-gnome-terminal -y
    ${sudo_command} apt-get purge nautilus-sendto -y
    # Bildschirmtastatur
    ${sudo_command} apt-get purge onboard -y
    ${sudo_command} apt-get purge onboard-common -y
    # Dock
    ${sudo_command} apt-get purge plank -y
    # thunderbird
    ${sudo_command} apt-get purge thunderbird -y
    ${sudo_command} apt-get purge transmission-common -y
}

wait_for_enter_warning "Unnötige Programme deinstallieren - Thunderbird, Libre Office, Nautilus und vieles mehr - sind Sie sicher ?"
wait_for_enter_warning "Unnötige Programme und deren Daten werden GELÖSCHT - Thunderbird, Libre Office, Nautilus und vieles mehr - sind Sie GANZ sicher ?"
install_essentials
linux_update
remove_unnecessary
linux_update
banner "Unnötige Programme deinstalliert"

