#!/bin/bash

function include_dependencies {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    sudo chmod -R +x "${my_dir}"/*.sh
    sudo chmod -R +x "${my_dir}"/lib_bash/*.sh
    sudo chmod -R +x "${my_dir}"/lib_install/*.sh
    source "${my_dir}/lib_bash/lib_color.sh"
    source "${my_dir}/lib_bash/lib_retry.sh"
    source "${my_dir}/lib_bash/lib_helpers.sh"
    source "${my_dir}/lib_install/install_essentials.sh"
}

include_dependencies  # we need to do that via a function to have local scope of my_dir

function install_languagepack {
    retry sudo apt-get install language-pack-de -y
    retry sudo apt-get install language-pack-de-base -y
}

wait_for_enter "Installiere deutsche Sprachpakete"
install_essentials
linux_update
install_languagepack
wait_for_enter_warning "deutsche Sprachpakete installiert - ein Neustart ist erforderlich, Enter rebootet die Maschine - offene Dokumente vorher sichern !"
reboot


