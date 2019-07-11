#!/bin/bash

function update_myself {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    "${my_dir}/000_000_update_myself.sh" "${@}" || exit 0              # exit old instance after updates
}

function include_dependencies {
    source /usr/local/lib_bash/lib_color.sh
    source /usr/local/lib_bash/lib_retry.sh
    source /usr/local/lib_bash/lib_helpers.sh
    source /usr/local/lib_bash/lib_install.sh
}

function install_ruby {
    banner "Install Ruby"
    $(which sudo) apt-get install zlib1g -y
    $(which sudo) apt-get install zlib1g-dev -y
    $(which sudo) apt-get install ruby-full -y
    $(which sudo) apt-get install nodejs -y
    $(which sudo) apt-get install npm -y
}

update_myself ${0} ${@}  # pass own script name and parameters
include_dependencies
wait_for_enter "Install Ruby, nodejs, npm"
install_ruby
banner "Install Ruby, nodejs, npm fertig"

