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
    backup_file /etc/netplan/50-cloud-init.yaml
    remove_file /etc/netplan/50-cloud-init.yaml
    ${sudo_command} cp -f ./shared/config/etc/netplan/01-network-manager-all.yaml /etc/netplan/01-network-manager-all.yaml
}


wait_for_enter "Installiere Ubuntu Mate Desktop - bitte Lightdm als Default Displaymanager auswählen"
install_essentials
linux_update
install_swapfile
disable_hibernate
install_ubuntu_mate_desktop
install_and_update_language_packs
wait_for_enter_warning "Ubuntu Mate Desktop installiert - ein Neustart ist erforderlich, Enter rebootet die Maschine - offene Dokumente vorher sichern !"
reboot

