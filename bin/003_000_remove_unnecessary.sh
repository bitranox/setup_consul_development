#!/bin/bash

function update_myself {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    "${my_dir}/000_000_update_myself.sh" "${@}" || exit 0              # exit old instance after updates
}

function include_dependencies {
    source /usr/local/lib_bash/lib_color.sh
    source /usr/local/lib_bash/lib_retry.sh
    source /usr/local/lib_bash/lib_helpers.sh
    source /usr/local/lib_bash/lib_install.sh
}

function remove_unnecessary {
    ### remove Canonical Reporting
    $(which sudo) apt-get purge whoopsie -y
    $(which sudo) apt-get purge libwhoopsie0 -y
    $(which sudo) apt-get purge libwhoopsie-preferences0 -y
    $(which sudo) apt-get purge apport -y
    ### Spelling
    $(which sudo) apt-get purge aspell -y
    ### Bluetooth
    $(which sudo) apt-get purge blueman -y
    $(which sudo) apt-get purge bluez -y
    $(which sudo) apt-get purge bluez-cups -y
    $(which sudo) apt-get purge bluez-obexd -y
    # CD Brenner
    $(which sudo) apt-get purge brasero -y
    $(which sudo) apt-get purge brasero-cdrkit -y
    $(which sudo) apt-get purge brasero-common -y
    $(which sudo) apt-get purge cdrdao -y
    $(which sudo) apt-get purge dvd+rw-tools -y
    $(which sudo) apt-get purge dvdauthor -y
    $(which sudo) apt-get purge growisofs -y
    $(which sudo) apt-get purge libburn4 -y
    # Musik
    $(which sudo) apt-get purge rhythmbox -y
    $(which sudo) apt-get purge rhythmbox-data -y
    # Braille für Blinde
    $(which sudo) apt-get purge brltty -y
    $(which sudo) apt-get purge libbrlapi0.6 -y
    $(which sudo) apt-get purge xzoom -y
    # Webcam
    $(which sudo) apt-get purge cheese -y
    $(which sudo) apt-get purge cheese-common -y
    # Taschenrechner
    $(which sudo) apt-get purge dc -y
    # editoren / Terminals
    $(which sudo) apt-get purge enchant -y
    $(which sudo) apt-get purge gedit -y
    $(which sudo) apt-get purge gedit-common -y
    $(which sudo) apt-get purge pluma-common -y
    $(which sudo) apt-get purge tilda -y
    $(which sudo) apt-get purge vim -y
    # Bildbetrachter / Scanner
    $(which sudo) apt-get purge eog -y
    $(which sudo) apt-get purge shotwell-common -y
    $(which sudo) apt-get purge simple-scan -y
    # Sprachausgabe
    $(which sudo) apt-get purge espeak-ng-data -y
    # Dateibetrachter
    $(which sudo) apt-get purge evince-common -y
    # video
    $(which sudo) apt-get purge ffmpegthumbnailer -y
    # gdm3 Gnome Display Manager
    $(which sudo) apt-get purge gdm3 -y
    # Bildbearbeitung
    $(which sudo) apt-get purge imagemagick-6.q16 -y
    # Libre Office
    $(which sudo) apt-get purge libreoffice-common -y
    $(which sudo) apt-get purge ure -y
    # Dateimanager
    $(which sudo) apt-get purge nautilus -y
    $(which sudo) apt-get purge nautilus-data -y
    $(which sudo) apt-get purge nautilus-extension-gnome-terminal -y
    $(which sudo) apt-get purge nautilus-sendto -y
    # Bildschirmtastatur
    $(which sudo) apt-get purge onboard -y
    $(which sudo) apt-get purge onboard-common -y
    # Dock
    $(which sudo) apt-get purge plank -y
    # thunderbird
    $(which sudo) apt-get purge thunderbird -y
    $(which sudo) apt-get purge transmission-common -y
}

update_myself ${0} ${@}  # pass own script name and parameters
include_dependencies
wait_for_enter_warning "Unnötige Programme deinstallieren - Thunderbird, Libre Office, Nautilus und vieles mehr - sind Sie sicher ?"
wait_for_enter_warning "Unnötige Programme und deren Daten werden GELÖSCHT - Thunderbird, Libre Office, Nautilus und vieles mehr - sind Sie GANZ sicher ?"
install_essentials
linux_update
remove_unnecessary
linux_update
banner "Unnötige Programme deinstalliert"

