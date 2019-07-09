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
    source /usr/lib/lib_bash/lib_color.sh
    source /usr/lib/lib_bash/lib_retry.sh
    source /usr/lib/lib_bash/lib_helpers.sh
    source /usr/lib/lib_bash/lib_install.sh
}

function lxd_init {
    # lxd initialisieren
    lxd init --auto --storage-backend dir
}

function set_uids {
    # subuid, subgid setzen
    local sudo_command=$(get_sudo_command)
    ${sudo_command} sh -c "echo \"${USER}:100000:65536\nroot:$(id -u):1\n\" > /etc/subuid"
    ${sudo_command} sh -c "echo \"${USER}:100000:65536\nroot:$(id -g):1\n\" > /etc/subgid"
}

function create_shared_directory {
    # shared Verzeichnis anlegen
    local sudo_command=$(get_sudo_command)
    ${sudo_command} mkdir -p /media/lxc-shared
    ${sudo_command} chmod -R 0777 /media/lxc-shared

}

function configure_dns {
    # LXC Network dns einschalten
    local sudo_command=$(get_sudo_command)
    echo -e "auth-zone=lxd\ndns-loop-detect" | lxc network set lxdbr0 raw.dnsmasq -
    # systemd-resolved für domain .lxd von Bridge IP abfragen - DNSMASQ darf NICHT installiert sein !
    local bridge_ip=$(ifconfig lxdbr0 | grep 'inet' | head -n 1 | tail -n 1 | awk '{print $2}')
    ${sudo_command} mkdir -p /etc/systemd/resolved.conf.d
    ${sudo_command} sh -c "echo \"[Resolve]\nDNS=$bridge_ip\nDomains=lxd\n\" > /etc/systemd/resolved.conf.d/lxdbr0.conf"
    ${sudo_command} service systemd-resolved restart
    ${sudo_command} service network-manager restart
    ${sudo_command} snap restart lxd
}

function create_lxc_profile {
    # parameter: $1:profile_name
    ## deprecated --> extend_default_profile
    local profile_name=$1
    lxc profile delete "${profile_name}"
    lxc profile create "${profile_name}"
    # Device zu Profile hinzufügen
    lxc profile device add "${profile_name}" root disk path=/ pool=default
    lxc profile device add "${profile_name}" lxc-shared disk source=/media/lxc-shared path=/media/lxc-shared

    # raw idmap im profile setzen
    lxc profile set "${profile_name}" raw.idmap "both $(id -u) $(id -g)"
}


function extend_default_profile {
    # Device zu Profile hinzufügen
    lxc profile device add default lxc-shared disk source=/media/lxc-shared path=/media/lxc-shared
    lxc profile set default raw.idmap "both $(id -u) $(id -g)"
}

function add_current_user_to_lxd_group {
    banner "LXD - add current user to lxd group"
    local sudo_command=$(get_sudo_command)
    # add current user to lxd group
    ${sudo_command} usermod --append --groups lxd "${USER}"
    # join the group for this session - not as root !
    # init LXD - not as root !
}


update_myself ${0} ${@}  # pass own script name and parameters
include_dependencies
profile_name="map-lxc-shared"
wait_for_enter "Konfiguriere LXD Container System"
install_essentials
linux_update
add_current_user_to_lxd_group
lxd_init
set_uids
create_shared_directory
configure_dns
# create_lxc_profile "${profile_name}"
extend_default_profile
banner "LXD fertig konfiguriert"

