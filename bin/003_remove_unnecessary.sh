#!/bin/bash

function include_dependencies {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    sudo chmod -R +x "${my_dir}"/*.sh
    sudo chmod -R +x "${my_dir}"/lib_bash/*.sh
    sudo chmod -R +x "${my_dir}"/lib_install/*.sh
    source "${my_dir}/lib_bash/lib_color.sh"
    source "${my_dir}/lib_bash/lib_retry.sh"
    source "${my_dir}/lib_bash/lib_helpers.sh"
    source "${my_dir}/lib_install/install_essentials.sh"
    source "${my_dir}/lib_install/linux_update.sh"
}

include_dependencies  # we need to do that via a function to have local scope of my_dir

function remove_unnecessary {
    ### remove Canonical Reporting
    sudo apt-get purge whoopsie -y
    sudo apt-get purge libwhoopsie0 -y
    sudo apt-get purge libwhoopsie-preferences0 -y
    sudo apt-get purge apport -y
    ### Spelling
    sudo apt-get purge aspell -y
    ### Bluetooth
    sudo apt-get purge blueman -y
    sudo apt-get purge bluez -y
    sudo apt-get purge bluez-cups -y
    sudo apt-get purge bluez-obexd -y
    # CD Brenner
    sudo apt-get purge brasero -y
    sudo apt-get purge brasero-cdrkit -y
    sudo apt-get purge brasero-common -y
    sudo apt-get purge cdrdao -y
    sudo apt-get purge dvd+rw-tools -y
    sudo apt-get purge dvdauthor -y
    sudo apt-get purge growisofs -y
    sudo apt-get purge libburn4 -y
    # Musik
    sudo apt-get purge rhythmbox -y
    sudo apt-get purge rhythmbox-data -y
    # Braille für Blinde
    sudo apt-get purge brltty -y
    sudo apt-get purge libbrlapi0.6 -y
    sudo apt-get purge xzoom -y
    # Webcam
    sudo apt-get purge cheese -y
    sudo apt-get purge cheese-common -y
    # Taschenrechner
    sudo apt-get purge dc -y
    # editoren / Terminals
    sudo apt-get purge emacsen-common -y
    sudo apt-get purge enchant -y
    sudo apt-get purge gedit -y
    sudo apt-get purge gedit-common -y
    sudo apt-get purge pluma-common -y
    sudo apt-get purge tilda -y
    # Bildbetrachter / Scanner
    sudo apt-get purge eog -y
    sudo apt-get purge shotwell-common -y
    sudo apt-get purge simple-scan -y
    # Sprachausgabe
    sudo apt-get purge espeak-ng-data -y
    # Dateibetrachter
    sudo apt-get purge evince-common -y
    # video
    sudo apt-get purge ffmpegthumbnailer -y
    # gdm3 Gnome Display Manager
    sudo apt-get purge gdm3 -y
    # Bildbearbeitung
    sudo apt-get purge imagemagick-6.q16 -y
    # Libre Office
    sudo apt-get purge libreoffice-common -y
    sudo apt-get purge ure -y
    # Dateimanager
    sudo apt-get purge nautilus -y
    sudo apt-get purge nautilus-data -y
    sudo apt-get purge nautilus-extension-gnome-terminal -y
    sudo apt-get purge nautilus-sendto -y
    # Bildschirmtastatur
    sudo apt-get purge onboard -y
    sudo apt-get purge onboard-common -y
    # Dock
    sudo apt-get purge plank -y
    # thunderbird
    sudo apt-get purge thunderbird -y
    sudo apt-get purge transmission-common -y
}

wait_for_enter_warning "Unnötige Programme deinstallieren - Thunderbird, Libre Office, Nautilus und vieles mehr - sind Sie sicher ?"
wait_for_enter_warning "Unnötige Programme und deren Daten werden GELÖSCHT - Thunderbird, Libre Office, Nautilus und vieles mehr - sind Sie GANZ sicher ?"
install_essentials
linux_update
remove_unnecessary
linux_update
wait_for_enter "Unnötige Programme deinstalliert"

## make it possible to call functions without source include
# Check if the function exists (bash specific)
if [[ ! -z "$1" ]]
    then
        if declare -f "${1}" > /dev/null
        then
          # call arguments verbatim
          "$@"
        else
          # Show a helpful error
          function_name="${1}"
          library_name="${0}"
          fail "\"${function_name}\" is not a known function name of \"${library_name}\""
        fi
	fi

