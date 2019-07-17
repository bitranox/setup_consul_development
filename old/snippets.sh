#!/bin/bash

function include_dependencies {
    # shellcheck disable=SC2164
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts


}

# works for sourced scripts also
function include_dependencies {
    local my_dir
    # shellcheck disable=SC2164
    my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    source "${my_dir}/lib_color.sh"
}

include_dependencies


## run install or update on top of the file
[[ -d "${BASH_SOURCE%/*" ]] && "${BASH_SOURCE%/*}"./install_or_update.sh || "${PWD}"./install_or_update.sh
