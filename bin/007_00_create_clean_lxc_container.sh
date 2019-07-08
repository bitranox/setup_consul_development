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
    source /usr/lib/lib_bash/lib_lxc_helpers.sh
    source "${my_dir}/lib_install/install_essentials.sh"
}

function create_container_disco {
    # parameter: $1 = container_name
    local container_name=$1
    banner "Erzeuge Container ${container_name}"
    lxc stop "${container_name}"  > /dev/null 2>&1
    lxc delete "${container_name}"  > /dev/null 2>&1
    lxc launch ubuntu:disco "${container_name}"
}

function create_lxc_user {
    # parameter: $1 = container_name, $2=user_name
    local container_name=$1
    local user_name=$2
    banner "Container ${container_name}: lege LXC User ${user_name} an - bitte geben Sie das Passwort (Vorschlag) \"consul\" ein"
    lxc_exec "${container_name}" "adduser ${user_name}"
    clr_green "adding user ${user_name} to sudoer group"
    # seltsamerweise funktioniert dies nicht mit lxc_exec !
    lxc exec "${container_name}" -- sh -c "usermod -aG sudo ${user_name}"
}


function install_scripts_on_lxc_container {
    # parameter: $1 = container_name
    local container_name=$1
    banner "Container ${container_name}: lege Install Scripte an"
    retry lxc_exec "${container_name}" "sudo rm -Rf ./consul-dev-env-public"
    retry lxc_exec "${container_name}" "sudo apt-get install git -y"
    retry lxc_exec "${container_name}" "git clone https://github.com/bitranox/consul-dev-env-public.git"
    retry lxc_exec "${container_name}" "sudo chmod -R +x ./consul-dev-env-public/bin/*.sh"
}

function lxc_install_language_pack {
    # install language pack and install language files for applications
    # parameter: $1 = container_name
    local container_name=$1
    banner "Container ${container_name}: Install Language Pack"
    lxc_update ${container_name}
    retry lxc_exec "${container_name}" "sudo apt-get install language-pack-de -y"
    retry lxc_exec "${container_name}" "sudo apt-get install language-pack-de-base -y"
    retry lxc_exec "${container_name}" "sudo apt-get install language-pack-gnome-de -y"
    retry lxc exec "${container_name}" -- sh -c "sudo apt-get install $(check-language-support -l de)"
    lxc_exec "${container_name}" "update-locale LANG=\"de_AT.UTF-8\" LANGUAGE=\"de_AT:de\""
    lxc_update ${container_name}
    lxc_reboot ${container_name}
    lxc_wait_until_internet_connected ${container_name}
    lxc_update ${container_name}
}

function lxc_install_ubuntu_mate_desktop {
    # parameter: $1 = container_name
    local container_name=$1
    wait_for_enter "Container ${container_name}: Installiere Ubuntu Mate Desktop - bitte Lightdm als Default Displaymanager auswählen"
    lxc_update ${container_name}
    retry lxc_exec "${container_name}" "sudo apt-get install ubuntu-mate-desktop -y"
    lxc_install_language_pack ${container_name}
    lxc_reboot ${container_name}
    lxc_wait_until_internet_connected ${container_name}
}

function lxc_install_tools {
    # parameter: $1 = container_name
    local container_name=$1
    banner "Container ${container_name}: Install Tools"
    ### remove Canonical Reporting
    retry lxc_exec "${container_name}" "sudo apt-get purge whoopsie -y"
    retry lxc_exec "${container_name}" "sudo apt-get purge libwhoopsie0 -y"
    retry lxc_exec "${container_name}" "sudo apt-get purge libwhoopsie-preferences0 -y"
    retry lxc_exec "${container_name}" "sudo apt-get purge apport -y"

    retry lxc_exec "${container_name}" "sudo apt-get install git -y"
    retry lxc_exec "${container_name}" "sudo apt-get install net-tools -y"
    retry lxc_exec "${container_name}" "sudo apt-get install build-essential -y"
    retry lxc_exec "${container_name}" "sudo apt-get install mc -y"
    retry lxc_exec "${container_name}" "sudo apt-get purge enchant -y"
    retry lxc_exec "${container_name}" "sudo apt-get purge gedit -y"
    retry lxc_exec "${container_name}" "sudo apt-get purge gedit-common -y"
    retry lxc_exec "${container_name}" "sudo apt-get purge pluma-common -y"
    retry lxc_exec "${container_name}" "sudo apt-get purge tilda -y"
    retry lxc_exec "${container_name}" "sudo apt-get purge vim -y"
    retry lxc_exec "${container_name}" "sudo apt-get install geany -y"
    retry lxc_exec "${container_name}" "sudo apt-get install meld -y"
    retry lxc_exec "${container_name}" "sudo apt-get install synaptic -y"
}

function lxc_install_x2goserver {
    # parameter: $1 = container_name
    local container_name=$1
    banner "Container ${container_name}: Install X2GO Server"
    retry lxc_exec "${container_name}" "sudo add-apt-repository ppa:x2go/stable -y"
    lxc_update ${container_name}
    retry lxc_exec "${container_name}" "sudo apt-get install x2goserver -y"
    retry lxc_exec "${container_name}" "sudo apt-get install x2goserver-xsession -y"
}

function lxc_configure_ssh {
    # parameter: $1 = container_name, $2=user_name
    local container_name=$1
    local user_name=$2
    banner "Container ${container_name}: Configure ssh"
    retry lxc_exec "${container_name}" "sudo apt-get install ssh -y"
    lxc_exec "${container_name}" "sudo cp -f ./consul-dev-env-public/bin/shared/config_lxc/etc/ssh/sshd_config /etc/ssh/sshd_config"
    lxc_exec "${container_name}" "sudo service sshd restart"
    lxc_exec "${container_name}" "sudo service x2goserver restart"
}

function lxc_disable_hibernate {
    # parameter: $1 = container_name
    local container_name=$1
    banner "Container ${container_name}: create backup image ${container_name}-fresh"
    lxc_exec "${container_name}" "sudo systemctl mask sleep.target"
    lxc_exec "${container_name}" "sudo systemctl mask suspend.target"
    lxc_exec "${container_name}" "sudo systemctl mask hibernate.target"
    lxc_exec "${container_name}" "sudo systemctl mask hybrid-sleep.target"
}

function lxc_assign_profile {
    # deprecated, we extended the default profile
    # parameter: $1 = container_name
    # parameter: $2 = profile_name
    local container_name=$1
    local profile_name=$2
    banner "Container ${container_name}: attach Profiles default,${profile_name}"
    lxc_shutdown "${container_name}"
    lxc profile assign "${container_name}" default,"${profile_name}"
    lxc_startup "${container_name}"
    lxc_wait_until_internet_connected ${container_name}

}

function lxc_install_chrome {
    # parameter: $1 = container_name
    local container_name=$1
    banner "Container ${container_name}: install google chrome"
    retry lxc_exec "${container_name}" "wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    retry lxc_exec "${container_name}" "sudo dpkg -i google-chrome-stable_current_amd64.deb"
    lxc_exec "${container_name}" "sudo rm -f ./google-chrome-stable_current_amd64.deb"

}

function lxc_install_chrome_remote_desktop {
    # parameter: $1 = container_name
    local container_name=$1
    banner "Container ${container_name}: install google chrome remote desktop"
    retry lxc_exec "${container_name}" "sudo apt-get install xvfb"
    retry lxc_exec "${container_name}" "sudo apt-get install xbase-clients"
    retry lxc_exec "${container_name}" "sudo apt-get install python-psutil"
    retry lxc_exec "${container_name}" "wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb"
    retry lxc_exec "${container_name}" "sudo dpkg -i chrome-remote-desktop_current_amd64.deb"
    lxc_exec "${container_name}" "sudo rm -f ./chrome-remote-desktop_current_amd64.deb"
    lxc_replace_or_add_lines_containing_string_in_file ${container_name} "/etc/environment" "CHROME_REMOTE_DESKTOP_DEFAULT_DESKTOP_SIZES" "CHROME_REMOTE_DESKTOP_DEFAULT_DESKTOP_SIZES=\"5120x1600\""
}


function lxc_create_image {
    # parameter: $1 = container_name
    local container_name=$1
    banner "Container ${container_name}: create backup image ${container_name}-fresh"
    lxc_shutdown "${container_name}"
    lxc publish ${container_name} --alias ${container_name}-fresh
    lxc_startup "${container_name}"
    lxc_wait_until_internet_connected ${container_name}
}


update_myself ${0} ${@}  # pass own script name and parameters
include_dependencies
container_name="lxc-clean"
profile_name="map-lxc-shared"
lxc_user_name="consul"
wait_for_enter "Erzeuge einen sauberen LXC-Container ${container_name}, user=${lxc_user_name}, pwd=consul, DNS Name = ${container_name}.lxd"
install_essentials
linux_update
create_container_disco "${container_name}"
create_lxc_user "${container_name}" "${lxc_user_name}"
install_scripts_on_lxc_container "${container_name}"
lxc_install_language_pack "${container_name}"
lxc_install_ubuntu_mate_desktop "${container_name}"
lxc_install_tools "${container_name}"
lxc_install_x2goserver "${container_name}"
lxc_configure_ssh "${container_name}" "${lxc_user_name}"
lxc_disable_hibernate "${container_name}"
# depricated, because we adopt the default profile - it is easier for the users to clone without
# assigning other profiles
# lxc_assign_profile "${container_name}" "${profile_name}"
lxc_install_chrome "${container_name}"
lxc_install_chrome_remote_desktop "${container_name}"
lxc_install_language_pack ${container_name}
lxc_create_image "${container_name}"
lxc_reboot "${container_name}"
banner "LXC-Container fertig - erreichbar mit x2goclient, Adresse ${container_name}.lxd, Desktop System \"MATE\""
