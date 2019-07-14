#!/bin/bash


function update_myself {
    /usr/local/setup_consul_development/install_or_update.sh "${@}" || exit 0              # exit old instance after updates
}


if [[ ! -z "$1" ]] && declare -f "${1}" ; then
    update_myself ${0}
else
    update_myself ${0} ${@}  > /dev/null 2>&1  # suppress messages here, not to spoil up answers from functions  when called verbatim
fi



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

