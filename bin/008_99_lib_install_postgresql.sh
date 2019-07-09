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
    source /usr/lib/lib_bash/lib_color.sh
    source /usr/lib/lib_bash/lib_retry.sh
    source /usr/lib/lib_bash/lib_helpers.sh
    source /usr/lib/lib_bash/lib_install.sh
}

function install_postgresql_repository {
    local sudo_command=$(get_sudo_command)
    ${sudo_command} apt-get install wget ca-certificates
    ${sudo_command} wget -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    ${sudo_command} sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    ${sudo_command} apt-get update
}

function install_postgresql {
    local sudo_command=$(get_sudo_command)
    ${sudo_command} apt-get install postgresql postgresql-contrib -y
    ${sudo_command} apt-get install postgresql-server-dev-all -y
}

function install_postgresql_pgadmin4 {
    local sudo_command=$(get_sudo_command)
    ${sudo_command} apt-get install pgadmin4 -y
}

include_dependencies