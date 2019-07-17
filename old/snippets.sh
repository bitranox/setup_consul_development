#!/bin/bash

function include_dependencies {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts


}

# works for sourced scripts also
function get_my_dir {
    local mydir=""
    mydir="${BASH_SOURCE%/*}"
    if [[ ! -d "$mydir" ]]; then mydir="$PWD"; fi
    echo "$mydir"
}

