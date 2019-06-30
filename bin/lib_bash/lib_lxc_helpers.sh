#!/bin/bash

function include_dependencies {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    source "${my_dir}/lib_color.sh"
    source "${my_dir}/lib_helpers.sh"

}

include_dependencies  # we need to do that via a function to have local scope of my_dir


function lxc_exec {
    # parameter: $1 = container_name
    # parameter: $2 = shell_command
    local container_name=$1
    local shell_command=$2
    lxc exec "${container_name}" -- sh -c "${shell_command}"
}




function lxc_update {
    # parameter: $1 = container_name
    local container_name=$1
    retry lxc_exec "${container_name}" "sudo apt-get update"
    retry lxc_exec "${container_name}" "sudo apt-get upgrade -y"
    retry lxc_exec "${container_name}" "sudo apt-get dist-upgrade -y"
    retry lxc_exec "${container_name}" "sudo apt-get autoclean -y"
    retry lxc_exec "${container_name}" "sudo apt-get autoremove -y"
}


function lxc_wait_until_machine_stopped {
    # parameter: $1 = container_name
    local container_name=$1
    clr_green "Container ${container_name}: stopping"
    while true; do
        if [[ $(lxc list -cns | grep "${container_name}" | grep -c STOPPED) == "1" ]]; then
            break
        else
            sleep 1
            clr_green "Container ${container_name}: stopping"
        fi
    done
}

function lxc_wait_until_machine_running {
    # parameter: $1 = container_name
    local container_name=$1
    clr_green "Container ${container_name}: starting"
    while true; do
        if [[ $(lxc list -cns | grep "${container_name}" | grep -c RUNNING) == "1" ]]; then
            break
        else
            sleep 1
            clr_green "Container ${container_name}: starting"
        fi
    done
}

function lxc_wait_until_internet_connected {
    # parameter: $1 = container_name
    local container_name=$1
    clr_green "Container ${container_name}: wait for internet connection"
    while true; do
        lxc_exec "${container_name}" "wget -q --spider http://google.com"
        if [[ $? -eq 0 ]]; then
            break
        else
            sleep 1
            clr_green "Container ${container_name}: wait for internet connection"
        fi
    done
}


function lxc_startup {
    # parameter: $1 = container_name
    local container_name=$1
    banner "Container ${container_name}: Startup"
    lxc start "${container_name}"
    lxc_wait_until_machine_running "${container_name}"
}

function lxc_shutdown {
    # parameter: $1 = container_name
    local container_name=$1
    banner "Container ${container_name}: Shutdown"
    lxc_exec "${container_name}" "sudo shutdown now"
    lxc_wait_until_machine_stopped "${container_name}"
}


function lxc_reboot {
    # parameter: $1 = container_name
    local container_name=$1
    banner "Container ${container_name}: Rebooting"
    lxc_shutdown "${container_name}"
    lxc_startup "${container_name}"
}




## make it possible to call functions without source include
# Check if the function exists (bash specific)
if [[ ! -z "$1" ]]
    then
        if declare -f "${1}" > /dev/null
        then
          # call arguments verbatim
          "$@"
        else
          # Show a helpful error
          function_name="${1}"
          library_name="${0}"
          fail "\"${function_name}\" is not a known function name of \"${library_name}\""
        fi
	fi
