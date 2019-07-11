#!/bin/bash

function install_or_update_lib_bash {
    if [[ -f "/usr/local/lib_bash/install_or_update.sh" ]]; then
        $(which sudo) /usr/local/lib_bash/install_or_update.sh
    else
        $(which sudo) rm -fR /usr/local/lib_bash
        $(which sudo) git clone https://github.com/bitranox/lib_bash.git /usr/local/lib_bash > /dev/null 2>&1
        $(which sudo) chmod -R 0755 /usr/local/lib_bash
        $(which sudo) chmod -R +x /usr/local/lib_bash/*.sh
        $(which sudo) chown -R root /usr/local/lib_bash || $(which sudo) chown -R ${USER} /usr/local/lib_bash  || echo "giving up set owner" # there is no user root on travis
        $(which sudo) chgrp -R root /usr/local/lib_bash || $(which sudo) chgrp -R ${USER} /usr/local/lib_bash  || echo "giving up set group" # there is no user root on travis
    fi
}

install_or_update_lib_bash

function install_or_update_lib_bash_install {
    if [[ -f "/usr/local/lib_bash_install/install_or_update.sh" ]]; then
        $(which sudo) /usr/local/lib_bash_install/install_or_update.sh
    else
        $(which sudo) rm -fR /usr/local/lib_bash_install
        $(which sudo) git clone https://github.com/bitranox/lib_bash_install.git /usr/local/lib_bash_install > /dev/null 2>&1
        $(which sudo) chmod -R 0755 /usr/local/lib_bash_install
        $(which sudo) chmod -R +x /usr/local/lib_bash_install/*.sh
        $(which sudo) chown -R root /usr/local/lib_bash_install || $(which sudo) chown -R ${USER} /usr/local/lib_bash_install  || echo "giving up set owner" # there is no user root on travis
        $(which sudo) chgrp -R root /usr/local/lib_bash_install || $(which sudo) chgrp -R ${USER} /usr/local/lib_bash_install  || echo "giving up set group" # there is no user root on travis
    fi
}

install_or_update_lib_bash_install


function include_dependencies {
    source /usr/local/lib_bash/lib_color.sh
    source /usr/local/lib_bash/lib_retry.sh
    source /usr/local/lib_bash/lib_helpers.sh
    source /usr/local/lib_bash_install/900_000_lib_install_basics.sh
}

include_dependencies

function set_setup_consul_development_permissions {
    $(which sudo) chmod -R 0755 /usr/local/setup_consul_development
    $(which sudo) chmod -R +x /usr/local/setup_consul_development/*.sh
    $(which sudo) chown -R "${USER}" /usr/local/setup_consul_development
    $(which sudo) chgrp -R "${USER}" /usr/local/setup_consul_development
}


function is_setup_consul_development_installed {
        if [[ -f "/usr/local/setup_consul_development/install_or_update.sh" ]]; then
            echo "True"
        else
            echo "False"
        fi
}


function is_setup_consul_development_to_update {
    local git_remote_hash=$(git --no-pager ls-remote --quiet https://github.com/bitranox/setup_consul_development.git | grep HEAD | awk '{print $1;}' )
    local git_local_hash=$( $(which sudo) cat /usr/local/setup_consul_development/.git/refs/heads/master)
    if [[ "${git_remote_hash}" == "${git_local_hash}" ]]; then
        echo "False"
    else
        echo "True"
    fi
}


function install_setup_consul_development {
    clr_green "installing setup_consul_development"
    $(which sudo) git clone https://github.com/bitranox/setup_consul_development.git /usr/local/setup_consul_development > /dev/null 2>&1
    set_setup_consul_development_permissions
}


function update_setup_consul_development {
    if [[ $(is_setup_consul_development_to_update) == "True" ]]; then
        clr_green "setup_consul_development needs to update"
        (
            # create a subshell to preserve current directory
            cd /usr/local/setup_consul_development
            $(which sudo) git fetch --all  > /dev/null 2>&1
            $(which sudo) git reset --hard origin/master  > /dev/null 2>&1
            set_setup_consul_development_permissions
        )
        clr_green "setup_consul_development update complete"
    else
        clr_green "setup_consul_development is up to date"
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


if [[ $(is_setup_consul_development_installed) == "True" ]]; then
    update_setup_consul_development
    restart_calling_script  "${@}"  # needs caller name and parameters
else
    install_setup_consul_development
fi
