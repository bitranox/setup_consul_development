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
