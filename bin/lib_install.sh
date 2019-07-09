#!/bin/bash

function include_dependencies {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    source /usr/lib/lib_bash/lib_color.sh
    source /usr/lib/lib_bash/lib_retry.sh
    source /usr/lib/lib_bash/lib_helpers.sh
}

function install_essentials {
    # update / upgrade linux and clean / autoremove
    clr_bold clr_green " "
    clr_bold clr_green "Installiere Essentielles am Host, entferne Apport und Whoopsie"
    local sudo_command=$(get_sudo_command)
    retry ${sudo_command} apt-get install net-tools -y
    retry ${sudo_command} apt-get install git -y
    ${sudo_command} apt-get purge whoopsie -y
    ${sudo_command} apt-get purge libwhoopsie0 -y
    ${sudo_command} apt-get purge libwhoopsie-preferences0 -y
    ${sudo_command} apt-get purge apport -y
}

function install_and_update_language_packs {
    # install language pack and install language files for applications
    banner "Install and Update Language Packs"
    local sudo_command=$(get_sudo_command)
    retry ${sudo_command} apt-get install language-pack-de -y
    retry ${sudo_command} apt-get install language-pack-de-base -y
    retry ${sudo_command} apt-get install manpages-de -y
    retry ${sudo_command} apt-get install language-pack-gnome-de -y
    ${sudo_command} update-locale LANG=\"de_AT.UTF-8\" LANGUAGE=\"de_AT:de\"
    retry ${sudo_command} apt-get install $(check-language-support -l de)
}


include_dependencies  # we need to do that via a function to have local scope of my_dir

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
