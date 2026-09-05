#!/bin/bash
function actionRowBuilder {
  message_json=$( echo -e $message_json | ${jq_binary} '. += { "components": [{ "type": 1, "components": [] }] }')
}

function addButton { 
  local style=$(
    [ ! -z "${1}" ] && { 
    [ ! -z "${button_styles[${1}]}" ] && echo ${button_styles[${1}]} || echo ${1}; 
    } || warn "$FUNCNAME: No button style supplied, using default (primary)"
    )
  local label=$(
    [ ! -z "${2}" ] && echo "${2}" || \
    error "$FUNCNAME: No button label provided\n
    > ${cyan}$FUNCNAME${nc} \"${1}\" ${red}\"${2}\"${nc} \"${3}\" \"${4}\" \"${5}\" \"${6}\""
    ) 
  local custom_id=$(
  [ ! -z "${3}" ] && { 
    [[ "$style" != 5 ]] && echo "${3}"; 
    } || { 
    [[ "$style" != 5 ]] && \
    error "$FUNCNAME: No custom ID provided\n
    > ${cyan}$FUNCNAME${nc} \"${1}\" \"${2}\" ${red}\"${3}\"${nc} \"${4}\" \"${5}\" \"${6}\""; 
    })
  local url=$(
  [ -z "${4}" ] && { 
    [[ "$style" == 5 ]] && error "$FUNCNAME: No URL provided while using style '$1'\n> ${cyan}$FUNCNAME${nc} \"${1}\" \"${2}\" \"${3}\" ${red}\"${4}\"${nc} \"${5}\" \"${6}\""; 
    } || echo "${5}"
    )
  local emoji=${5}
  local disabled=${6}
  message_json=$(echo "$message_json" | ${jq_binary} -r '.components[].components |= . + 
  [
    { 
      "type": 2, 
      "style": '"${style:=1}"',
      "label": "'"${label}"'", 
      "custom_id": "'"${custom_id}"'", 
      "url": "'"${url}"'", 
      "disabled": '"${disabled:=false}"' 
    }
  ]'
  )
}

function addSelectMenu {
  local type=$(
    [ ! -z "${1}" ] && { 
     [ ! -z "${select_menu_types[${1}]}" ] && echo ${select_menu_types[${1}]} || echo "${1}"; 
    } || warn "$FUNCNAME: No select menu type provided, using default (string)"
    )
  local custom_id=$(
  [ ! -z "${2}" ] && \
  echo "${2}" || \
  error "$FUNCNAME: No custom ID provided
  > ${cyan}$FUNCNAME${nc} \"${1}\" ${red}\"${2}\"${nc} \"${3}\" \"${4}\" \"${5}\" \"${6}\""; 
    )
  local placeholder=${3}
  local min_values=${4}
  local max_values=${5}
  local disabled=${6}
  echo $type
  case $type in 
  3)
  message_json=$(echo "$message_json" | ${jq_binary} -r '.components[].components |= . + 
  [
    { 
      "type": '"${type:=3}"', 
      "custom_id": "'"${custom_id}"'", 
      "placeholder": "'"${placeholder}"'", 
      "min_values": '"${min_values:=1}"', 
      "max_values": '"${max_values:=1}"', 
      "options": [], 
      "disabled": '"${disabled:=false}"' 
    }
  ]'
  )  ;;
  5|6|7)
  local default_values=$([ ! -z "${8}" ] && [[ ! "${8}"  =~ '[' ]] && echo -n "${8}" | ${jq_binary} -scR 'split(",") | map(split(":")) | map([{ id: (.[0]), type: .[1] }]) | add')
  message_json=$(echo "$message_json" | ${jq_binary} -r '.components[].components |= . + 
  [
    { 
      "type": '"${type:=3}"', 
      "custom_id": "'"${custom_id}"'", 
      "placeholder": "'"${placeholder}"'", 
      "min_values": '"${min_values:=1}"', 
      "max_values": '"${max_values:=1}"', 
      "default_values": '"${default_values:=[]}"', 
      "disabled": '"${disabled:=false}"' 
    }
  ]'
  )  ;;
  8) 

  [ ! -z "${7}" ] && { 
    for i in ${7//,/ }; do types+="${channel_types[$i]} "; done
    channeltypes=$(echo $types | ${jq_binary} -cR 'split(" ")'); 
  }
  local default_values=$([ ! -z "${8}" ] && [[ ! "${8}"  =~ '[' ]] && echo -n "${8}" | ${jq_binary} -scR 'split(",") | map(split(":")) | map([{ id: (.[0]), type: .[1] }]) | add')
  message_json=$(echo "$message_json" | ${jq_binary} -cr '.components[].components |= . + 
  [
    { 
      "type": '"${type:=3}"', 
      "custom_id": "'"${custom_id}"'", 
      "placeholder": "'"${placeholder}"'", 
      "min_values": '"${min_values:=1}"', 
      "max_values": '"${max_values:=1}"', 
      "default_values": '"${default_values:=[]}"', 
      "channel_types": '"${channeltypes:=[]}"',
      "disabled": '"${disabled:=false}"' 
    }
  ]'
  )  ;;
  esac
}

function addSelectMenuOption {
  local custom_id=$(
  [ ! -z "${1}" ] && \
  echo "${1}" || \
  error "$FUNCNAME: No custom ID provided
  > ${cyan}$FUNCNAME${nc} ${red}\"${1}\"${nc} \"${2}\" \"${3}\" \"${4}\" \"${5}\" \"${6}\""; 
    )
  local label=$(
  [ ! -z "${2}" ] && \
  echo "${2}" || \
  error "$FUNCNAME: No label provided
  > ${cyan}$FUNCNAME${nc} \"${1}\" ${red}\"${2}\"${nc} \"${3}\" \"${4}\" \"${5}\" \"${6}\""; 
    )
  local value=$(
  [ ! -z "${3}" ] && \
  echo "${3}" || \
  error "$FUNCNAME: No value provided
  > ${cyan}$FUNCNAME${nc} \"${1}\" \"${2}\" ${red}\"${3}\"${nc} \"${4}\" \"${5}\" \"${6}\""; 
    )
  local description=${4}
  local emoji=${5}
  local default=${6}
  #local json=$(echo "$message_json" | ${jq_binary} -r '.components[].components[] | select(.custom_id == "'"${custom_id}"'")')
  if [ -z "$emoji" ]; then
  message_json=$(echo "$message_json" | ${jq_binary} -r '(.components[].components[] | select(.custom_id == "'"${custom_id}"'") | .options) |=
  [ 
    {
      "label": "'"${label}"'",
      "value": "'"${value}"'",
      "description": "'"${description}"'",
      "default": '"${default:=false}"'
    }
  ]
  ')
  else
  if [ "$(IFS=':'; read -ra output <<< "$emoji"; echo "${#output[@]}")" -lt 2 ]; then
  error "$FUNCNAME: Invalid emoji: expected at least name and ID
  > ${cyan}$FUNCNAME${nc} \"${1}\" \"${2}\" \"${3}\" \"${4}\" ${red}\"${5}\"${nc} \"${6}\""; 
  message_json=$(echo "$message_json" | ${jq_binary} -r '(.components[].components[] | select(.custom_id == "'"${custom_id}"'") | .options) |=
  [ 
    {
      "label": "'"${label}"'",
      "value": "'"${value}"'",
      "description": "'"${description}"'",
      "default": '"${default:=false}"'
    }
  ]
  ')
  else
  emoji=$([[ "${emoji:0:1}" != '[' ]] && echo -n $emoji | ${jq_binary} -R 'split(":") | { name: .[0], id: .[1]|tonumber, animated: .[2] } | if .animated == null then .animated=false else .animated=(.animated|test("true")) end' )
  message_json=$(echo "$message_json" | ${jq_binary} -r '(.components[].components[] | select(.custom_id == "'"${custom_id}"'") | .options) |=
  [ 
    {
      "label": "'"${label}"'",
      "value": "'"${value}"'",
      "description": "'"${description}"'",
      "emoji": '"${emoji}"',
      "default": '"${default:=false}"'
    }
  ]
  ')
  fi
  fi
}