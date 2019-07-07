#!/bin/bash

function get_sudo_exists {
    # we need this for travis - there is no sudo command !
    if [[ -f /usr/bin/sudo ]]; then
        echo "True"
    else
        echo "False"
    fi
}

function get_sudo_command_prefix {
    if [[ $(get_sudo_exists) == "True" ]]; then
        local sudo_cmd_prefix="sudo"
        echo ${sudo_cmd_prefix}
    else
        local sudo_cmd_prefix=""
        echo ${sudo_cmd_prefix}
    fi
}

function include_dependencies {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    local sudo_command_prefix=$(get_sudo_command_prefix)
    {sudo_command_prefix} chmod -R +x "${my_dir}"/*.sh
    {sudo_command_prefix} chmod -R +x "${my_dir}"/lib_install/*.sh
    source "${my_dir}/install_lib_bash.sh"
    source /usr/lib/lib_bash/lib_color.sh
    source /usr/lib/lib_bash/lib_retry.sh
    source /usr/lib/lib_bash/lib_helpers.sh
    source "${my_dir}/lib_install/install_essentials.sh"
}

include_dependencies  # we need to do that via a function to have local scope of my_dir

function update_myself {
    local sudo_command_prefix=$(get_sudo_command_prefix)
    retry ${sudo_command_prefix} git fetch --all > /dev/null 2>&1
    ${sudo_command_prefix} git reset --hard origin/master > /dev/null 2>&1
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    ${sudo_command_prefix} chmod -R 0755 "${my_dir}"
    ${sudo_command_prefix} chmod -R +x "${my_dir}"/*.sh
    ${sudo_command_prefix} chmod -R +x "${my_dir}"/lib_install/*.sh
    ${sudo_command_prefix} chown -R ${USER} "${my_dir}"
    ${sudo_command_prefix} chgrp -R ${USER} "${my_dir}"
}


function check_upgrade {
    # parameter: $1 script_name
    # parameter: $2 script_args
    local script_name=$1
    local script_args=$2

    local git_remote_hash=$(git --no-pager ls-remote --quiet | grep HEAD | awk '{print $1;}')
    local git_local_hash=$(git --no-pager log --decorate=short --pretty=oneline -n1 | grep HEAD | awk '{print $1;}')

    if [[ ${git_remote_hash} == ${git_local_hash} ]]; then
        clr_green "Version up to date"
    else
        banner "new Version, updating skripts..."
        update_myself

        # running the new Version
        $script_name $script_args

        # exit this old instance
        exit 0
    fi
}

check_upgrade "$0" "$@"
