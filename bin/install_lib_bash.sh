#!/bin/bash

include_dependencies  # we need to do that via a function to have local scope of my_dir

current_dir="`dirname \"$0\"`"
echo "current_dir: ${current_dir}"
my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
echo "my_dir: ${current_dir}"