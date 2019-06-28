#!/bin/bash

function include_dependencies {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    source "${my_dir}/lib_color.sh"
}

include_dependencies  # we need to do that via a function to have local scope of my_dir


function fail {
  clr_bold clr_red "${1}" >&2
  exit 1
}

function get_linux_codename {
    export linux_codename=`lsb_release --codename | cut -f2`
}

function banner {
    clr_bold clr_green ""
    clr_bold clr_green ""
    local sep="********************************************************************************"
    clr_bold clr_green ${sep}
    clr_bold clr_green "${1}"
    clr_bold clr_green ${sep}
}

function wait_for_enter {
    # wait for enter - first parameter will be showed in a banner if present
    if [[ ! -z "$1" ]] ;
        then
            banner "${1}"
        fi
    clr_bold clr_green ""
    clr_bold clr_green "Enter to continue, Cntrl-C to exit: " && read -p
}

function reboot {
    clr_bold clr_green ""
    clr_bold clr_green "Rebooting"
    sudo shutdown -r now
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
