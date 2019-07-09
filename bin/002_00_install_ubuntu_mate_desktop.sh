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
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    source /usr/lib/lib_bash/lib_color.sh
    source /usr/lib/lib_bash/lib_retry.sh
    source /usr/lib/lib_bash/lib_helpers.sh
    source "${my_dir}/lib_install.sh"
}

function install_swapfile {
    banner "Install 8GB Swapfile"
    local sudo_command=$(get_sudo_command)
    ${sudo_command} swapoff -a
    ${sudo_command} rm /swapfile
    ${sudo_command} mkdir -p /var/cache/swap
    ${sudo_command} fallocate -l 8G /var/cache/swap/swap0
    ${sudo_command} chmod 0600 /var/cache/swap/swap0
    ${sudo_command} mkswap /var/cache/swap/swap0
    ${sudo_command} swapon /var/cache/swap/swap0
}

function disable_hibernate {
    local sudo_command=$(get_sudo_command)
    ${sudo_command} systemctl mask sleep.target
    ${sudo_command} systemctl mask suspend.target
    ${sudo_command} systemctl mask hibernate.target
    ${sudo_command} systemctl mask hybrid-sleep.target
}

function install_ubuntu_mate_desktop {
    banner "Install ubuntu-mate-desktop"
    local sudo_command=$(get_sudo_command)
    retry ${sudo_command} apt-get install ubuntu-mate-desktop -y
    retry ${sudo_command} apt-get install grub2-themes-ubuntu-mate install -y
    retry ${sudo_command} apt-get install ubuntu-mate-core install -y
    retry ${sudo_command} apt-get install ubuntu-mate-artwork install -y
    retry ${sudo_command} apt-get install ubuntu-mate-default-settings install -y
    retry ${sudo_command} apt-get install ubuntu-mate-icon-themes install -y
    retry ${sudo_command} apt-get install ubuntu-mate-wallpapers-complete install -y
    retry ${sudo_command} apt-get install human-theme install -y
    retry ${sudo_command} apt-get install mate-applet-brisk-menu -y
    retry ${sudo_command} apt-get install mate-system-monitor -y
    retry ${sudo_command} apt-get install language-pack-gnome-de -y
    retry ${sudo_command} apt-get install geany -y
    retry ${sudo_command} apt-get install mc -y
    retry ${sudo_command} apt-get install meld -y
    retry ${sudo_command} apt-get purge byobu -y
    retry ${sudo_command} apt-get purge vim -y
    backup_file /etc/netplan/50-cloud-init.yaml  # @lib_bash/lib_helpers
    remove_file /etc/netplan/50-cloud-init.yaml  # @lib_bash/lib_helpers
    ${sudo_command} cp -f ./shared/config/etc/netplan/01-network-manager-all.yaml /etc/netplan/01-network-manager-all.yaml
}

function install_x2go_server {
    banner "Install x2go Server"
    local sudo_command=$(get_sudo_command)
    retry ${sudo_command} add-apt-repository ppa:x2go/stable -y
    retry ${sudo_command} apt-get update
    retry ${sudo_command} install x2goserver -y
    retry ${sudo_command} install x2goserver-xsession -y
    retry ${sudo_command} install x2goclient -y
}


include_dependencies
update_myself ${0} ${@}  # pass own script name and parameters
wait_for_enter "Installiere Ubuntu Mate Desktop - bitte Lightdm als Default Displaymanager auswählen"
install_essentials
linux_update
install_swapfile
disable_hibernate
install_ubuntu_mate_desktop
install_x2go_server
linux_update
wait_for_enter_warning "Ubuntu Mate Desktop installiert"
reboot
