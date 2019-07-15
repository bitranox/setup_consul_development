#!/bin/bash


function include_dependencies {
    source /usr/local/lib_bash/lib_color.sh
    source /usr/local/lib_bash/lib_retry.sh
    source /usr/local/lib_bash/lib_helpers.sh
    source /usr/local/lib_bash_install/900_000_lib_install_basics.sh
}

include_dependencies


function install_postgresql_repository {
    $(which sudo) apt-get install wget ca-certificates
    $(which sudo) wget -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    $(which sudo) sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    $(which sudo) apt-get update
}

function install_postgresql {
    $(which sudo) apt-get install postgresql postgresql-contrib -y
    $(which sudo) apt-get install postgresql-server-dev-all -y
}

function install_postgresql_pgadmin4 {
    $(which sudo) apt-get install pgadmin4 -y
}

function tests {
	clr_green "no tests in ${0}"
}


## make it possible to call functions without source include
call_function_from_commandline "${0}" "${@}"
