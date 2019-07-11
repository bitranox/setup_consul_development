#!/bin/bash

function update_myself {
    /usr/local/setup_consul_development/install_or_update.sh "${@}" || exit 0              # exit old instance after updates
}

update_myself ${0} ${@}  # pass own script name and parameters

function include_dependencies {
    source /usr/local/lib_bash/lib_color.sh
    source /usr/local/lib_bash/lib_retry.sh
    source /usr/local/lib_bash/lib_helpers.sh
    source /usr/local/lib_bash_install/900_000_lib_install_basics.sh
}

include_dependencies


DIALOG_CANCEL=1
DIALOG_ESC=255
MENUE_HEIGHT=0
MENUE_WIDTH=0
MENUE_ITEMS_HEIGHT=10

INPUTBOX_HEIGHT=0
INPUTBOX_WIDTH=0


function display_result {
  # --no-collapse: do not convert tabs to spaces and reduces multiple spaces to a single space
  dialog --title "$1" \
    --no-collapse \
    --msgbox "$result" 0 0
}


function dialog_inputbox {
    # $1: title
    # $2: backtitle
    # $3: text
    # $4: <optional> height
    # $5: <optional> width
    # returns : result
    # exitcode: status
    local title=$1
    local backtitle=$2
    local text=$3
    local height=$4
    local width=$5

    local result=$(dialog --title "${title}" \
        --backtitle "${backtitle}" \
        --inputbox "${text}" "${height}" "${width}" \
         2>&1 1>/dev/tty);
    echo "${result}"
    return $?
}

function dialog_return_on_exit_status_esc_or_cancel {
    # $1: $? the exit code
    # Usage : $(dialog_return_on_exit_status_esc_or_cancel $?)
    local exit_status=$1
    case ${exit_status} in
        ${DIALOG_ESC})
            echo "clear && return"
            ;;
        ${DIALOG_CANCEL})
            echo "clear && return"
            ;;
        *)
            echo ""
            ;;
    esac
}


function add_user {
    username=$(dialog_inputbox "Benutzer anlegen" "Benutzer anlegen" "Benutzername: " 0 0)
    $(dialog_return_on_exit_status_esc_or_cancel $?)
    if [[ "${username}" == "" ]]; then
        result="no User!!!"
        display_result "no User"
    fi
}


while true; do
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
    2>&1 1>/dev/tty);
  exit_status=$?

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
        add_user

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

