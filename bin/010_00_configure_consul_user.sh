#!/bin/bash

function get_sudo_exists {
    # we need this for travis - there is no sudo command !
    if [[ -f /usr/bin/sudo ]]; then
        echo "True"
    else
        echo "False"
    fi
}

function get_sudo_command {
    # we need this for travis - there is no sudo command !
    if [[ $(get_sudo_exists) == "True" ]]; then
        local sudo_command="sudo"
        echo ${sudo_command}
    else
        local sudo_command=""
        echo ${sudo_command}
    fi
}


function include_dependencies {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    local sudo_command=$(get_sudo_command)
    ${sudo_command} chmod -R +x "${my_dir}"/*.sh
    ${sudo_command} chmod -R +x "${my_dir}"/lib_install/*.sh
    "${my_dir}/000_00_update_myself.sh" "${@}" || exit 0              # exit old instance after update
    source /usr/lib/lib_bash/lib_color.sh
    source /usr/lib/lib_bash/lib_retry.sh
    source /usr/lib/lib_bash/lib_helpers.sh
    source "${my_dir}/lib_install/install_essentials.sh"
}

include_dependencies "${0}" "${@}" # pass own script name and parameters


function install_ruby {
    banner "Install Ruby"
    local sudo_command=$(get_sudo_command)
    ${sudo_command} apt-get install zlib1g
    ${sudo_command} apt-get install zlib1g-dev
    ${sudo_command} apt-get install ruby-full
    # https://stackoverflow.com/questions/2119064/sudo-gem-install-or-gem-install-and-gem-locations
    # use RVM !!!
    gem install bundler             # not Install gems as root !!!
    ${sudo_command} apt-get install nodejs
    ${sudo_command} apt-get install npm
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
