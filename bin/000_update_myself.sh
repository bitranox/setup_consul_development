#!/bin/bash
./install_lib_bash.sh

function include_dependencies {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    sudo chmod -R +x "${my_dir}"/*.sh
    sudo chmod -R +x "${my_dir}"/lib_install/*.sh
    source "${my_dir}/lib_bash/lib_color.sh"
    source "${my_dir}/lib_bash/lib_retry.sh"
    source "${my_dir}/lib_bash/lib_helpers.sh"
    source "${my_dir}/lib_install/install_essentials.sh"
}

include_dependencies  # we need to do that via a function to have local scope of my_dir

function update_myself {
    retry sudo git fetch --all > /dev/null 2>&1
    sudo git reset --hard origin/master > /dev/null 2>&1
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    sudo chmod -R +x "${my_dir}"/*.sh
    sudo chmod -R +x "${my_dir}"/lib_install/*.sh
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
