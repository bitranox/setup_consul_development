#!/bin/bash

function update_myself {
    /usr/local/setup_consul_development/install_or_update.sh "${@}" || exit 0              # exit old instance after updates
}


function include_dependencies {
    source /usr/local/lib_bash/lib_color.sh
    source /usr/local/lib_bash/lib_retry.sh
    source /usr/local/lib_bash/lib_helpers.sh
    source /usr/local/lib_bash_install/900_000_lib_install_basics.sh
}

function install_software {
    banner "install needed tools : build-essential, mc, geany, meld, synaptic, x2goclient"
    ### remove Canonical Reporting
    $(which sudo) apt-get purge whoopsie -y
    $(which sudo) apt-get purge libwhoopsie0 -y
    $(which sudo) apt-get purge libwhoopsie-preferences0 -y
    $(which sudo) apt-get purge apport -y
    # essential
    retry $(which sudo) apt-get install net-tools -y
    retry $(which sudo) apt-get install git -y
    # build-essential
    retry $(which sudo) apt-get install build-essential -y
    # midnight commander
    retry $(which sudo) apt-get install mc -y
    # geany Editor
    retry $(which sudo) apt-get purge enchant -y
    retry $(which sudo) apt-get purge gedit -y
    retry $(which sudo) apt-get purge gedit-common -y
    retry $(which sudo) apt-get purge pluma-common -y
    retry $(which sudo) apt-get purge tilda -y
    retry $(which sudo) apt-get purge vim -y
    retry $(which sudo) apt-get install geany -y
    # Meld Vergleichstool
    retry $(which sudo) apt-get install meld -y
    # Paketverwaltung
    retry $(which sudo) apt-get install synaptic -y
    # x2go client
    retry $(which sudo) apt-get install x2goclient -y
}



function install_chrome {
    banner "Install google chrome"
    retry $(which sudo) wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    retry $(which sudo) dpkg -i google-chrome-stable_current_amd64.deb
    $(which sudo) rm -f ./google-chrome-stable_current_amd64.deb
}

function install_chrome_remote_desktop {
    banner "Install google chrome remote desktop"
    retry $(which sudo) apt-get install xvfb
    retry $(which sudo) apt-get install xbase-clients
    retry $(which sudo) apt-get install python-psutil
    retry $(which sudo) wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
    retry $(which sudo) dpkg -i chrome-remote-desktop_current_amd64.deb
    $(which sudo) rm -f ./chrome-remote-desktop_current_amd64.deb
    replace_or_add_lines_containing_string_in_file "/etc/environment" "CHROME_REMOTE_DESKTOP_DEFAULT_DESKTOP_SIZES" "CHROME_REMOTE_DESKTOP_DEFAULT_DESKTOP_SIZES=\"5120x1600\""
}

update_myself ${0} ${@}  # pass own script name and parameters
include_dependencies
wait_for_enter "Notwendige und nützliche Tools werden installiert"
install_essentials
linux_update
install_software
install_chrome
install_chrome_remote_desktop
install_and_update_language_packs
banner "Notwendige und nützliche Tools sind installiert"
