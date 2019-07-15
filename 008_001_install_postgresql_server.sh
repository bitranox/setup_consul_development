#!/bin/bash

function update_myself {
    /usr/local/setup_consul_development/install_or_update.sh "${@}" || exit 0              # exit old instance after updates
}


update_myself ${0}

function include_dependencies {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    source "${my_dir}/008_990_lib_install_postgresql.sh"
    source /usr/local/lib_bash/lib_color.sh
    source /usr/local/lib_bash/lib_retry.sh
    source /usr/local/lib_bash/lib_helpers.sh
    source /usr/local/lib_bash_install/900_000_lib_install_basics.sh
}


include_dependencies

function tests {
	clr_green "no tests in ${0}"
}


wait_for_enter "Installiere Datenbankserver postgresql"
install_essentials
install_postgresql_repository
install_postgresql
banner "Installation Datenbankserver postgresql fertig"
