#!/bin/bash

function include_dependencies {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    chmod +x "${my_dir}"/../lib_bash/*.sh
    source "${my_dir}/../lib_bash/lib_color.sh"
    source "${my_dir}/../lib_bash/lib_retry.sh"
    source "${my_dir}/../lib_bash/lib_helpers.sh"
}

include_dependencies  # we need to do that via a function to have local scope of my_dir

function linux_update {
    # update / upgrade linux and clean / autoremove
    clr_bold clr_green ""
    clr_bold clr_green "Linux Update"
    retry sudo apt-get update
    retry sudo apt-get upgrade -y
    retry sudo apt-get autoclean -y
    retry sudo apt-get autoremove -y
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
