#!/bin/bash

function update_myself {
    /usr/local/setup_consul_development/install_or_update.sh "${@}" || exit 0              # exit old instance after updates
}


update_myself ${0}

function include_dependencies {
    source /usr/local/lib_bash/lib_color.sh
    source /usr/local/lib_bash/lib_retry.sh
    source /usr/local/lib_bash/lib_helpers.sh
    source /usr/local/lib_bash_install/900_000_lib_install_basics.sh
}


include_dependencies


function install_ruby {
    banner "Install Ruby"
    $(get_sudo) apt-get install zlib1g -y
    $(get_sudo) apt-get install zlib1g-dev -y
    $(get_sudo) apt-get install ruby-full -y
    $(get_sudo) apt-get install nodejs -y
    $(get_sudo) apt-get install npm -y
}


function tests {
	clr_green "no tests in ${0}"
}


wait_for_enter "Install Ruby, nodejs, npm"
install_ruby
banner "Install Ruby, nodejs, npm fertig"

