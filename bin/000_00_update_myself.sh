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

function update_myself {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    local sudo_command=$(get_sudo_command)
    ${sudo_command} chmod -R +x "${my_dir}"/*.sh
    ${sudo_command} chmod -R +x "${my_dir}"/lib_install/*.sh
    "${my_dir}/install_or_update_lib_bash" "${@}" || exit 0              # exit old instance after updates
}


function include_dependencies {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    local sudo_command=$(get_sudo_command)
    ${sudo_command} chmod -R +x "${my_dir}"/*.sh
    ${sudo_command} chmod -R +x "${my_dir}"/lib_install/*.sh
    source /usr/lib/lib_bash/lib_color.sh
    source /usr/lib/lib_bash/lib_retry.sh
    source /usr/lib/lib_bash/lib_helpers.sh
    source "${my_dir}/lib_install/install_essentials.sh"
}

include_dependencies  # we need to do that via a function to have local scope of my_dir

function set_consul_dev_env_public_permissions {
    local sudo_command=$(get_sudo_command)
    ${sudo_command} chmod -R 0755 ~/consul-dev-env-public
    ${sudo_command} chmod -R +x ~/consul-dev-env-public/bin/*.sh
    ${sudo_command} chmod -R +x ~/consul-dev-env-public/bin/lib_install/*.sh
    ${sudo_command} chown -R "${USER}" ~/consul-dev-env-public/
    ${sudo_command} chgrp -R "${USER}" ~/consul-dev-env-public/
}

function is_consul_dev_env_public_to_update {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    local git_remote_hash=$(git --no-pager ls-remote --quiet https://github.com/bitranox/consul-dev-env-public.git | grep HEAD | awk '{print $1;}' )
    local git_local_hash=$( $(get_sudo_command) cat "${my_dir}"/.git/refs/heads/master)
    if [[ "${git_remote_hash}" == "${git_local_hash}" ]]; then
        echo "False"
    else
        echo "True"
    fi
}


function update_consul_dev_env_public {
    if [[ $(is_consul_dev_env_public_to_update) == "True" ]]; then
        clr_green "consul-dev-env-public needs to update"
        (
            # create a subshell to preserve current directory
            cd ~/consul-dev-env-public
            local sudo_command=$(get_sudo_command)
            ${sudo_command} git fetch --all  > /dev/null 2>&1
            ${sudo_command} git reset --hard origin/master  > /dev/null 2>&1
            set_consul_dev_env_public_permissions
        )
        clr_green "consul-dev-env-public update complete"
    else
        clr_green "consul-dev-env-public is up to date"
    fi
}


function restart_calling_script {
    local caller_command=("$@")
    if [ ${#caller_command[@]} -eq 0 ]; then
        # no parameters passed
        exit 0
    else
        # parameters passed, running the new Version of the calling script
        "${caller_command[@]}"
        # exit this old instance with error code 100
        exit 100
    fi

}

update_consul_dev_env_public
restart_calling_script "${@}"  # needs caller name and parameters
