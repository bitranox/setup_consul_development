#!/bin/bash

function update_myself {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    "${my_dir}/000_000_update_myself.sh" "${@}" || exit 0              # exit old instance after updates
}

function include_dependencies {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    source "${my_dir}/008_990_lib_install_postgresql.sh"
    source /usr/local/lib_bash/lib_color.sh
    source /usr/local/lib_bash/lib_retry.sh
    source /usr/local/lib_bash/lib_helpers.sh
    source /usr/local/lib_bash/lib_install.sh
}

update_myself ${0} ${@}  # pass own script name and parameters
include_dependencies
wait_for_enter "Installiere postgresql admin Interface für Desktop"
install_essentials
install_postgresql_repository
install_postgresql_pgadmin4
banner "Installation postgresql admin Interface fertig"
