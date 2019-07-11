#!/bin/bash

function update_myself {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    "${my_dir}/000_000_update_myself.sh" "${@}" || exit 0              # exit old instance after updates
}

function include_dependencies {
    source /usr/local/lib_bash/lib_color.sh
    source /usr/local/lib_bash/lib_retry.sh
    source /usr/local/lib_bash/lib_helpers.sh
    source /usr/local/lib_bash_install/900_000_lib_install_basics.sh
}

function install_swapfile {
    banner "Install 8GB Swapfile"
    $(which sudo) swapoff -a
    $(which sudo) rm /swapfile
    $(which sudo) mkdir -p /var/cache/swap
    $(which sudo) fallocate -l 8G /var/cache/swap/swap0
    $(which sudo) chmod 0600 /var/cache/swap/swap0
    $(which sudo) mkswap /var/cache/swap/swap0
    $(which sudo) swapon /var/cache/swap/swap0
}

function disable_hibernate {
    $(which sudo) systemctl mask sleep.target
    $(which sudo) systemctl mask suspend.target
    $(which sudo) systemctl mask hibernate.target
    $(which sudo) systemctl mask hybrid-sleep.target
}

function install_ubuntu_mate_desktop {
    banner "Install ubuntu-mate-desktop"

    retry $(which sudo) apt-get install lightdm -y
    retry $(which sudo) apt-get install slick-greeter -y
    retry $(which sudo) dpkg-reconfigure lightdm

    retry $(which sudo) apt-get install grub2-themes-ubuntu-mate -y
    retry $(which sudo) apt-get install ubuntu-mate-core -y
    retry $(which sudo) apt-get install ubuntu-mate-artwork -y
    retry $(which sudo) apt-get install ubuntu-mate-default-settings -y
    retry $(which sudo) apt-get install ubuntu-mate-icon-themes -y
    retry $(which sudo) apt-get install ubuntu-mate-wallpapers-complete -y
    retry $(which sudo) apt-get install human-theme -y
    retry $(which sudo) apt-get install mate-applet-brisk-menu -y
    retry $(which sudo) apt-get install mate-system-monitor -y
    retry $(which sudo) apt-get install language-pack-gnome-de -y
    retry $(which sudo) apt-get install geany -y
    retry $(which sudo) apt-get install mc -y
    retry $(which sudo) apt-get install meld -y
    retry $(which sudo) apt-get purge byobu -y
    retry $(which sudo) apt-get purge vim -y
    backup_file /etc/netplan/50-cloud-init.yaml  # @lib_bash/lib_helpers
    remove_file /etc/netplan/50-cloud-init.yaml  # @lib_bash/lib_helpers
    $(which sudo) cp -f ./shared/config/etc/netplan/01-network-manager-all.yaml /etc/netplan/01-network-manager-all.yaml
    retry $(which sudo) dpkg-reconfigure lightdm
}

function install_x2go_server {
    banner "Install x2go Server"
    retry $(which sudo) add-apt-repository ppa:x2go/stable -y
    retry $(which sudo) apt-get update
    retry $(which sudo) apt-get install x2goserver -y
    retry $(which sudo) apt-get install x2goserver-xsession -y
    retry $(which sudo) apt-get install x2goclient -y
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
