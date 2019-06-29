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

function lxd_init {
    # lxd initialisieren
    lxd init --auto --storage-backend dir
}

function set_uids {
    # subuid, subgid setzen
    sudo sh -c "echo \"${USER}:100000:65536\nroot:$(id -u):1\n\" > /etc/subuid"
    sudo sh -c "echo \"${USER}:100000:65536\nroot:$(id -g):1\n\" > /etc/subgid"
}

function create_shared_directory {
    # shared Verzeichnis anlegen
    sudo mkdir -p /media/lxc-shared
    sudo chmod -R 0777 /media/lxc-shared

}

function configure_dns {
    # LXC Network dns einschalten
    echo -e "auth-zone=lxd\ndns-loop-detect" | lxc network set lxdbr0 raw.dnsmasq -
    # systemd-resolved für domain .lxd von Bridge IP abfragen - DNSMASQ darf NICHT installiert sein !
    local bridge_ip=$(ifconfig lxdbr0 | grep 'inet' | head -n 1 | tail -n 1 | awk '{print $2}')
    sudo mkdir -p /etc/systemd/resolved.conf.d
    sudo sh -c "echo \"[Resolve]\nDNS=$bridge_ip\nDomains=lxd\n\" > /etc/systemd/resolved.conf.d/lxdbr0.conf"
    sudo service systemd-resolved restart
    sudo service network-manager restart
}

function create_lxc_profile {
    # parameter: $1:profile_name
    local profile_name=$1
    lxc profile delete "${profile_name}"
    lxc profile create "${profile_name}"
    # Device zu Profile hinzufügen
    lxc profile device add "${profile_name}" lxc-shared disk source=/media/lxc-shared path=/media/lxc-shared
    # raw idmap im profile setzen
    lxc profile set "${profile_name}" raw.idmap "both $(id -u) $(id -g)"
}


profile_name="consul"
wait_for_enter "Konfiguriere LXD Container System - DNSMASQ darf nicht installiert sein, DNS muss über systemd-resolved erfolgen !"
install_essentials
linux_update
lxd_init
set_uids
create_shared_directory
configure_dns
create_lxc_profile "${profile_name}"
wait_for_enter "LXD fertig konfiguriert"


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

