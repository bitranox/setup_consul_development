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
}

include_dependencies  # we need to do that via a function to have local scope of my_dir

function install_swapfile {
    banner "Install 8GB Swapfile"
    sudo swapoff -a
    sudo rm /swapfile
    sudo mkdir -p /var/cache/swap
    sudo fallocate -l 8G /var/cache/swap/swap0
    sudo chmod 0600 /var/cache/swap/swap0
    sudo mkswap /var/cache/swap/swap0
    sudo swapon /var/cache/swap/swap0
}

function disable_hibernate {
    sudo systemctl mask sleep.target
    sudo systemctl mask suspend.target
    sudo systemctl mask hibernate.target
    sudo systemctl mask hybrid-sleep.target
}

function install_ubuntu_mate_desktop {
    banner "Install ubuntu-mate-desktop"
    retry sudo apt-get install ubuntu-mate-desktop -y
    backup_file /etc/netplan/50-cloud-init.yaml
    remove_file /etc/netplan/50-cloud-init.yaml
    sudo cp -f ./shared/config/etc/netplan/01-network-manager-all.yaml /etc/netplan/01-network-manager-all.yaml
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

