#!/bin/bash

function update_myself {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    "${my_dir}/000_000_update_myself.sh" "${@}" || exit 0              # exit old instance after updates
}

function include_dependencies {
    source /usr/local/lib_bash/lib_color.sh
    source /usr/local/lib_bash/lib_retry.sh
    source /usr/local/lib_bash/lib_helpers.sh
    source /usr/local/lib_bash/lib_lxc_helpers.sh
    source /usr/local/lib_bash_install/900_000_lib_install_basics.sh
}

function create_new_container {
    # parameter: $1 = container_name
    # parameter: $2 = Ubuntu Release "bionic", "disco"
    local container_name=$1
    local ubuntu_release=$2
    banner "Erzeuge Container ${container_name}"
    lxc stop "${container_name}"  > /dev/null 2>&1
    lxc delete "${container_name}"  > /dev/null 2>&1
    lxc launch ubuntu:${ubuntu_release} "${container_name}"
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
    retry lxc_exec "${container_name}" "git clone https://github.com/bitranox/setup_consul_development.git"
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
    lxc_exec "${container_name}" "update-locale LANG=\"de_AT.UTF-8\" LANGUAGE=\"de_AT:de\""
    retry lxc exec "${container_name}" -- sh -c "sudo apt-get install $(check-language-support -l de) -y"
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
    retry lxc_exec "${container_name}" "apt-get install lightdm -y"
    retry lxc_exec "${container_name}" "apt-get install slick-greeter -y"
    retry lxc_exec "${container_name}" "dpkg-reconfigure lightdm"
    retry lxc_exec "${container_name}" "apt-get install grub2-themes-ubuntu-mate -y"
    retry lxc_exec "${container_name}" "apt-get install ubuntu-mate-core -y"
    retry lxc_exec "${container_name}" "apt-get install ubuntu-mate-artwork -y"
    retry lxc_exec "${container_name}" "apt-get install ubuntu-mate-default-settings -y"
    retry lxc_exec "${container_name}" "apt-get install ubuntu-mate-icon-themes -y"
    retry lxc_exec "${container_name}" "apt-get install ubuntu-mate-wallpapers-complete -y"
    retry lxc_exec "${container_name}" "apt-get install human-theme -y"
    retry lxc_exec "${container_name}" "apt-get install mate-applet-brisk-menu -y"
    retry lxc_exec "${container_name}" "apt-get install mate-system-monitor -y"
    retry lxc_exec "${container_name}" "apt-get install language-pack-gnome-de -y"
    retry lxc_exec "${container_name}" "apt-get install geany -y"
    retry lxc_exec "${container_name}" "apt-get install mc -y"
    retry lxc_exec "${container_name}" "apt-get install meld -y"
    retry lxc_exec "${container_name}" "apt-get purge byobu -y"
    retry lxc_exec "${container_name}" "apt-get purge vim -y"
    retry lxc_exec "${container_name}" "dpkg-reconfigure lightdm"

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

function lxc_configure_sshd {
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
    retry lxc_exec "${container_name}" "sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
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
    retry lxc_exec "${container_name}" "sudo wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb"
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
ubuntu_release="disco"
lxc_user_name="consul"
lxc_install_desktop="True"
lxc_create_image="True"
wait_for_enter "Erzeuge einen sauberen LXC-Container ${container_name}, user=${lxc_user_name}, pwd=consul, DNS Name = ${container_name}.lxd"
install_essentials
linux_update
create_new_container "${container_name}" "${ubuntu_release}"
create_lxc_user "${container_name}" "${lxc_user_name}"
install_scripts_on_lxc_container "${container_name}"
lxc_install_language_pack "${container_name}"
lxc_configure_sshd "${container_name}" "${lxc_user_name}"
lxc_disable_hibernate "${container_name}"

if [[ "${lxc_install_desktop}" == "True" ]]; then
    lxc_install_ubuntu_mate_desktop "${container_name}"
    lxc_install_tools "${container_name}"
    lxc_install_x2goserver "${container_name}"
    lxc_install_chrome "${container_name}"
    lxc_install_chrome_remote_desktop "${container_name}"
    lxc_install_language_pack ${container_name}
    lxc_disable_hibernate "${container_name}"
fi

if [[ "${lxc_create_image}" == "True" ]]; then
    lxc_create_image "${container_name}"
fi

lxc_reboot "${container_name}"
banner "LXC-Container fertig - erreichbar mit ssh, x2goclient (wenn Sie Desktop installiert haben), Adresse ${container_name}.lxd"
