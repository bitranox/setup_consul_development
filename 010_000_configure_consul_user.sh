#!/bin/bash

function update_myself {
    /usr/local/setup_consul_development/install_or_update.sh "${@}" || exit 0              # exit old instance after updates
}


function include_dependencies {
    source /usr/local/lib_bash/lib_color.sh
    source /usr/local/lib_bash/lib_retry.sh
    source /usr/local/lib_bash/lib_helpers.sh
    source /usr/local/lib_bash_install/900_000_lib_install_basics.sh
}

function install_ruby {
    banner "Install Ruby"
    $(which sudo) apt-get install zlib1g
    $(which sudo) apt-get install zlib1g-dev
    $(which sudo) apt-get install ruby-full
    # https://stackoverflow.com/questions/2119064/sudo-gem-install-or-gem-install-and-gem-locations
    # use RVM !!!
    gem install bundler             # do not Install gems as root !!!
    $(which sudo) apt-get install nodejs
    $(which sudo) apt-get install npm
}


update_myself ${0} ${@}  # pass own script name and parameters
include_dependencies
wait_for_enter "Install Ruby, nodejs, npm"
install_ruby
banner "Install Ruby, nodejs, npm fertig"

################################################################################################
# function get_input_with_default_value
################################################################################################

#
# name="Ricardo"
# read -e -i "$name" -p "Please enter your name: " input
# name="${input:-$name}"
#
