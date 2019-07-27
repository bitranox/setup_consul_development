#!/bin/bash

sudo_askpass="$(command -v ssh-askpass)"
export SUDO_ASKPASS="${sudo_askpass}"
export NO_AT_BRIDGE=1  # get rid of (ssh-askpass:25930): dbind-WARNING **: 18:46:12.019: Couldn't register with accessibility bus: Did not receive a reply.

# call the update script if not sourced
if [[ "${0}" == "${BASH_SOURCE[0]}" ]] && [[ -d "${BASH_SOURCE%/*}" ]]; then "${BASH_SOURCE%/*}"/install_or_update.sh else "${PWD}"/install_or_update.sh ; fi


function include_dependencies {
    source /usr/local/lib_bash/lib_color.sh
    source /usr/local/lib_bash/lib_retry.sh
    source /usr/local/lib_bash/lib_helpers.sh
    source /usr/local/lib_bash_install/900_000_lib_install_basics.sh
}

include_dependencies


function install_postgresql_repository {
    "$(cmd "sudo")" apt-get install wget ca-certificates
    "$(cmd "sudo")" wget -nv -c -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    "$(cmd "sudo")" sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    "$(cmd "sudo")" apt-get update
}

function install_postgresql {
    "$(cmd "sudo")" apt-get install postgresql postgresql-contrib -y
    "$(cmd "sudo")" apt-get install postgresql-server-dev-all -y
}

function install_postgresql_pgadmin4 {
    "$(cmd "sudo")" apt-get install pgadmin4 -y
}

## make it possible to call functions without source include
call_function_from_commandline "${0}" "${@}"
