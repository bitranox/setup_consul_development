#!/bin/bash

my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts

sudo rm -rf ${my_dir}/lib_bash
git clone https://github.com/bitranox/lib_bash.git ${my_dir}/lib_bash_new
