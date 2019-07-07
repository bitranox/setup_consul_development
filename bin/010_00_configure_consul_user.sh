#!/bin/bash

function include_dependencies {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    sudo chmod -R +x "${my_dir}"/*.sh
    sudo chmod -R +x "${my_dir}"/lib_install/*.sh
    source "${my_dir}/000_update_myself.sh"
    source /usr/lib/lib_bash/lib_color.sh
    source /usr/lib/lib_bash/lib_retry.sh
    source /usr/lib/lib_bash/lib_helpers.sh
    source "${my_dir}/lib_install/install_essentials.sh"
}

include_dependencies  # we need to do that via a function to have local scope of my_dir


function install_ruby {
    banner "Install Ruby"
    sudo apt-get install zlib1g
    sudo apt-get install zlib1g-dev
    sudo apt-get install ruby-full
    # https://stackoverflow.com/questions/2119064/sudo-gem-install-or-gem-install-and-gem-locations
    # use RVM !!!
    gem install bundler             # not Install gems as root !!!
    sudo apt-get install nodejs
    sudo apt-get install npm
}


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
