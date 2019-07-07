#!/bin/bash

function get_sudo_exists {
    # we need this for travis - there is no sudo command !
    if [[ -f /usr/bin/sudo ]]; then
        echo "True"
    else
        echo "False"
    fi
}

function get_sudo_command_prefix {
    # we need this for travis - there is no sudo command !
    if [[ $(get_sudo_exists) == "True" ]]; then
        local sudo_cmd_prefix="sudo"
        echo ${sudo_cmd_prefix}
    else
        local sudo_cmd_prefix=""
        echo ${sudo_cmd_prefix}
    fi
}


function include_dependencies {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    local sudo_command_prefix=$(get_sudo_command_prefix)
    ${sudo_command_prefix} chmod -R +x "${my_dir}"/*.sh
    ${sudo_command_prefix} chmod -R +x "${my_dir}"/lib_install/*.sh
    source "${my_dir}/000_update_myself.sh"
    source /usr/lib/lib_bash/lib_color.sh
    source /usr/lib/lib_bash/lib_retry.sh
    source /usr/lib/lib_bash/lib_helpers.sh
    source "${my_dir}/lib_install/install_essentials.sh"
}

include_dependencies  # we need to do that via a function to have local scope of my_dir

function install_postgresql_repository {
    local sudo_command_prefix=$(get_sudo_command_prefix)
    ${sudo_command_prefix} apt-get install wget ca-certificates
    wget -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    ${sudo_command_prefix} sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    ${sudo_command_prefix} apt-get update
}


function install_postgresql {
    local sudo_command_prefix=$(get_sudo_command_prefix)
    ${sudo_command_prefix} apt-get install postgresql postgresql-contrib -y
    ${sudo_command_prefix} apt-get install postgresql-server-dev-all -y
}

function install_postgresql_pgadmin4 {
    local sudo_command_prefix=$(get_sudo_command_prefix)
    ${sudo_command_prefix} apt-get install pgadmin4 -y
}
