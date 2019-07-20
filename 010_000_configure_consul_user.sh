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
    "$(cmd "sudo")" apt-get install zlib1g
    "$(cmd "sudo")" apt-get install zlib1g-dev
    "$(cmd "sudo")" apt-get install ruby-full
    # https://stackoverflow.com/questions/2119064/sudo-gem-install-or-gem-install-and-gem-locations
    # use RVM !!!
    gem install bundler             # do not Install gems as root !!!
    "$(cmd "sudo")" apt-get install nodejs
    "$(cmd "sudo")" apt-get install npm
}

wait_for_enter "Install Ruby, nodejs, npm"
install_ruby
banner "Install Ruby, nodejs, npm fertig"
