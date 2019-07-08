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
    local sudo_command=$(get_sudo_command)
    ${sudo_command} chmod -R +x "${my_dir}"/*.sh
    ${sudo_command} chmod -R +x "${my_dir}"/lib_install/*.sh
    "${my_dir}/000_00_update_myself.sh" "${@}" || exit 0              # exit old instance after updates
}


function include_dependencies {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    local sudo_command=$(get_sudo_command)
    ${sudo_command} chmod -R +x "${my_dir}"/*.sh
    ${sudo_command} chmod -R +x "${my_dir}"/lib_install/*.sh
    source /usr/lib/lib_bash/lib_color.sh
    source /usr/lib/lib_bash/lib_retry.sh
    source /usr/lib/lib_bash/lib_helpers.sh
    source "${my_dir}/lib_install/install_essentials.sh"
}

function install_software {
    banner "install needed tools : build-essential, mc, geany, meld, synaptic, x2goclient"
    local sudo_command=$(get_sudo_command)
    ### remove Canonical Reporting
    ${sudo_command} apt-get purge whoopsie -y
    ${sudo_command} apt-get purge libwhoopsie0 -y
    ${sudo_command} apt-get purge libwhoopsie-preferences0 -y
    ${sudo_command} apt-get purge apport -y
    # essential
    retry ${sudo_command} apt-get install net-tools -y
    retry ${sudo_command} apt-get install git -y
    # build-essential
    retry ${sudo_command} apt-get install build-essential -y
    # midnight commander
    retry ${sudo_command} apt-get install mc -y
    # geany Editor
    retry ${sudo_command} apt-get purge enchant -y
    retry ${sudo_command} apt-get purge gedit -y
    retry ${sudo_command} apt-get purge gedit-common -y
    retry ${sudo_command} apt-get purge pluma-common -y
    retry ${sudo_command} apt-get purge tilda -y
    retry ${sudo_command} apt-get purge vim -y
    retry ${sudo_command} apt-get install geany -y
    # Meld Vergleichstool
    retry ${sudo_command} apt-get install meld -y
    # Paketverwaltung
    retry ${sudo_command} apt-get install synaptic -y
    # x2go client
    retry ${sudo_command} apt-get install x2goclient -y
}



function install_chrome {
    banner "Install google chrome"
    local sudo_command=$(get_sudo_command)
    retry ${sudo_command} wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    retry ${sudo_command} dpkg -i google-chrome-stable_current_amd64.deb
    ${sudo_command} rm -f ./google-chrome-stable_current_amd64.deb
}

function install_chrome_remote_desktop {
    banner "Install google chrome remote desktop"
    local sudo_command=$(get_sudo_command)
    retry ${sudo_command} apt-get install xvfb
    retry ${sudo_command} apt-get install xbase-clients
    retry ${sudo_command} apt-get install python-psutil
    retry ${sudo_command} wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
    retry ${sudo_command} dpkg -i chrome-remote-desktop_current_amd64.deb
    ${sudo_command} rm -f ./chrome-remote-desktop_current_amd64.deb
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
