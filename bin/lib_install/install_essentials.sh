#!/bin/bash

function include_dependencies {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    chmod +x "${my_dir}"/../lib_bash/*.sh
    source "${my_dir}/../lib_bash/lib_color.sh"
    source "${my_dir}/../lib_bash/lib_retry.sh"
    source "${my_dir}/../lib_bash/lib_helpers.sh"
}

include_dependencies  # we need to do that via a function to have local scope of my_dir

function install_essentials {
    # update / upgrade linux and clean / autoremove
    clr_bold clr_green ""
    clr_bold clr_green "Installiere Essentielles am Host, entferne Apport und Whoopsie"
    retry sudo apt-get install net-tools -y
    retry sudo apt-get install mc -y
    retry sudo apt-get install git -y
    retry sudo apt-get purge whoopsie -y
    retry sudo apt-get purge apport -y
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
