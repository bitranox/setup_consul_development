#!/bin/bash

function get_sudo_exists {
    # we need this for travis - there is no sudo command !
    if [[ -f /usr/bin/sudo ]]; then
        echo "True"
    else
        echo "False"
    fi
}

function get_sudo_command {
    # we need this for travis - there is no sudo command !
    if [[ $(get_sudo_exists) == "True" ]]; then
        local sudo_command="sudo"
        echo ${sudo_command}
    else
        local sudo_command=""
        echo ${sudo_command}
    fi
}

function update_myself {
    local my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"  # this gives the full path, even for sourced scripts
    "${my_dir}/000_00_update_myself.sh" "${@}" || exit 0              # exit old instance after updates
}

function include_dependencies {
    source /usr/lib/lib_bash/lib_color.sh
    source /usr/lib/lib_bash/lib_retry.sh
    source /usr/lib/lib_bash/lib_helpers.sh
    source /usr/lib/lib_bash/lib_install.sh
}


update_myself ${0} ${@}  # pass own script name and parameters
include_dependencies


DIALOG_CANCEL=1
DIALOG_ESC=255
MENUE_HEIGHT=0
MENUE_WIDTH=0
MENUE_ITEMS_HEIGHT=10

INPUTBOX_HEIGHT=0
INPUTBOX_WIDTH=0



function display_result {
  dialog --title "$1" \
    --no-collapse \
    --msgbox "$result" 0 0
}

function get_username {
    # exec 3>&1
    local result=$(dialog --title "Inputbox - To take input from you" \
        --backtitle "Linux Shell Script Tutorial Example" \
        --inputbox "Enter your name " ${INPUTBOX_HEIGHT} ${INPUTBOX_WIDTH}
        )
    echo ${result}
}


while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "Host Installation" \
    --title "Host Installation - aktiver Benutzer ist ${USER}" \
    --clear \
    --cancel-label "Exit" \
    --menu "Bitte auswählen:" ${MENUE_HEIGHT} ${MENUE_WIDTH} ${MENUE_ITEMS_HEIGHT} \
    "1" "Benutzer anlegen" \
    "2" "Deutsches Sprachpaket Installieren" \
    "3" "Ubuntu Mate Desktop Installieren" \
    "4" "Unnötige Programme am Host entfernen" \
    "5" "Basisprogramme incl. Google Chrome installieren" \
    "6" "LXD Containersystem installieren" \
    "7" "LXD Containersystem konfigurieren" \
    "8" "Benutzer zur Gruppe LXD hinzufügen" \
    "9" "neuen LXC Container erstellen" \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      clear
      echo "Program terminated."
      exit
      ;;
    $DIALOG_ESC)
      clear
      echo "Program aborted." >&2
      exit 1
      ;;
  esac
  case $selection in
    0 )
      clear
      echo "Program terminated."
      ;;
    1 )
        result=$(get_username)
        display_result "Username"
        # result=$(echo "Hostname: $HOSTNAME"; uptime)
        # display_result "System Information"
      ;;
    2 )
      result=$(df -h)
      display_result "Disk Space"
      ;;
    3 )
      if [[ $(id -u) -eq 0 ]]; then
        result=$(du -sh /home/* 2> /dev/null)
        display_result "Home Space Utilization (All Users)"
      else
        result=$(du -sh $HOME 2> /dev/null)
        display_result "Home Space Utilization ($USER)"
      fi
      ;;
  esac
done