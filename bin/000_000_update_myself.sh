#!/bin/bash

function install_or_update_lib_bash {
    if [[ -d "/usr/local/lib_bash" ]]; then
        $(which sudo) /usr/local/lib_bash/install_or_update_lib_bash.sh
    else
        $(which sudo) git clone https://github.com/bitranox/lib_bash.git /usr/local/lib_bash > /dev/null 2>&1
        $(which sudo) chmod -R 0755 /usr/local/lib_bash
        $(which sudo) chmod -R +x /usr/local/lib_bash/*.sh
        $(which sudo) chown -R root /usr/local/lib_bash || $(which sudo) chown -R ${USER} /usr/local/lib_bash  || echo "giving up set owner" # there is no user root on travis
        $(which sudo) chgrp -R root /usr/local/lib_bash || $(which sudo) chgrp -R ${USER} /usr/local/lib_bash  || echo "giving up set group" # there is no user root on travis
    fi
}

function include_dependencies {
    source /usr/local/lib_bash/lib_color.sh
    source /usr/local/lib_bash/lib_retry.sh
    source /usr/local/lib_bash/lib_helpers.sh
    source /usr/local/lib_bash/lib_install.sh
}

include_dependencies

function set_consul_dev_env_public_permissions {
    $(which sudo) chmod -R 0755 ~/consul-dev-env-public
    $(which sudo) chmod -R +x ~/consul-dev-env-public/bin/*.sh
    $(which sudo) chown -R "${USER}" ~/consul-dev-env-public/
    $(which sudo) chgrp -R "${USER}" ~/consul-dev-env-public/
}


function is_consul_dev_env_public_installed {
        if [[ -d "~/consul-dev-env-public" ]]; then
            echo "True"
        else
            echo "False"
        fi
}


function is_consul_dev_env_public_to_update {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    local git_remote_hash=$(git --no-pager ls-remote --quiet https://github.com/bitranox/consul-dev-env-public.git | grep HEAD | awk '{print $1;}' )
    local git_local_hash=$( $(which sudo) cat ~/consul-dev-env-public/.git/refs/heads/master)
    if [[ "${git_remote_hash}" == "${git_local_hash}" ]]; then
        echo "False"
    else
        echo "True"
    fi
}


function install_consul_dev_env_public {
    clr_green "installing consul_dev_env_public"
    (
        # create a subshell to preserve current directory
        cd ~
        $(which sudo) git clone https://github.com/bitranox/consul-dev-env-public.git > /dev/null 2>&1
        set_consul_dev_env_public_permissions
    )
}


function update_consul_dev_env_public {
    if [[ $(is_consul_dev_env_public_to_update) == "True" ]]; then
        clr_green "consul-dev-env-public needs to update"
        (
            # create a subshell to preserve current directory
            cd ~/consul-dev-env-public
            $(which sudo) git fetch --all  > /dev/null 2>&1
            $(which sudo) git reset --hard origin/master  > /dev/null 2>&1
            set_consul_dev_env_public_permissions
        )
        clr_green "consul-dev-env-public update complete"
    else
        clr_green "consul-dev-env-public is up to date"
        exit 0
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


install_or_update_lib_bash

if [[ $(is_consul_dev_env_public_installed) == "True" ]]; then
    update_consul_dev_env_public
    restart_calling_script  "${@}"  # needs caller name and parameters
else
    install_consul_dev_env_public
fi
