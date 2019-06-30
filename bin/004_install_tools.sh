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

function install_software {
    banner "install needed tools : build-essential, mc, geany, meld, synaptic, x2goclient"
    retry sudo apt-get install net-tools -y
    retry sudo apt-get install git -y
    # build-essential
    retry sudo apt-get install build-essential -y
    # midnight commander
    retry sudo apt-get install mc -y
    # geany Editor
    retry sudo apt-get purge emacsen-common -y
    retry sudo apt-get purge enchant -y
    retry sudo apt-get purge gedit -y
    retry sudo apt-get purge gedit-common -y
    retry sudo apt-get purge pluma-common -y
    retry sudo apt-get purge tilda -y
    retry sudo apt-get purge vim -y
    retry sudo apt-get install geany -y
    # Meld Vergleichstool
    retry sudo apt-get install meld -y
    # Paketverwaltung
    retry sudo apt-get install synaptic -y
    # x2go client
    retry sudo apt-get install x2goclient -y
}


function install_chrome {
    banner "Install google chrome"
    retry wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    retry sudo dpkg -i google-chrome-stable_current_amd64.deb
    sudo rm -f ./google-chrome-stable_current_amd64.deb
}

function install_chrome_remote_desktop {
    banner "Install google chrome remote desktop"
    retry sudo apt-get install xvfb
    retry sudo apt-get install xbase-clients
    retry sudo apt-get install python-psutil
    retry wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
    retry sudo dpkg -i chrome-remote-desktop_current_amd64.deb
    sudo rm -f ./chrome-remote-desktop_current_amd64.deb
}



wait_for_enter "Notwendige und nützliche Tools werden installiert"
install_essentials
linux_update
install_software
install_chrome
install_chrome_remote_desktop
banner "Notwendige und nützliche Tools sind installiert"

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

