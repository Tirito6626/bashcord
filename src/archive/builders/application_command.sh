#!/bin/bash

function applicationCommandBuilder {
 slash_json="{}"
}
function addCommandID {
  slash_json=$(echo "$slash_json" | ${jq_binary} '. += { "id": "'"${1}"'" }')
}
function addCommandType {
    local type=$(
    [ ! -z "${1}" ] && { 
     [ ! -z "${application_types[${1}]}" ] && echo ${application_types[${1}]} || { [[ "${1}" =~ ^[0-9] ]] && echo "${1}" || warn "$FUNCNAME: Invalid command type provided, using default (string)" && echo 3; }; 
    } || warn "$FUNCNAME: No command type provided, using default (chat_input)"
    )
  slash_json=$(echo "$slash_json" | ${jq_binary} '. += { "type": '"${type:=1}"' }')
}

function addCommandApplicationID {
  local arg=$([ ! -z "${1}" ] && echo "${1}" || error "$FUNCNAME: Value expected")
  slash_json=$(echo "$slash_json" | ${jq_binary} '. += { "application_id": "'"${arg}"'" }')
}

function addCommandGuildID {
  local arg=$([ ! -z "${1}" ] && echo "${1}" || error "$FUNCNAME: Value expected")
  slash_json=$(echo "$slash_json" | ${jq_binary} '. += { "guild_id": "'"${arg}"'" }')
}
function addCommandName {
  local arg=$([ ! -z "${1}" ] && echo "${1}" || error "$FUNCNAME: Value expected")
  local localization="${2}"
  slash_json=$(echo "$slash_json" | ${jq_binary} '. += { "name": "'"${arg}"'" }')
  [ ! -z "${localization}" ] && slash_json=$(echo "$slash_json" | ${jq_binary} '. += { "name_localizations": ["'"${localization// /\",\"}"'"] }')
}

function addCommandDescription {
  local arg=$([ ! -z "${1}" ] && echo "${1}" || error "$FUNCNAME: Value expected")
  local localization="${2}"
  slash_json=$(echo "$slash_json" | ${jq_binary} '. += { "description": "'"${arg}"'" }')
  [ ! -z "${localization}" ] && slash_json=$(echo "$slash_json" | ${jq_binary} '. += { "description_localizations": ["'"${localization// /\",\"}"'"] }')
}

function addCommandIntegrationType { 
  local arg=$([ ! -z "${1}" ] && {
   IFS=','; 
   for i in "${1}"; do 
   contexts+="${application_install_types[${i}]},"; 
   done; 
   echo "$(echo -n ${contexts} | jq -cR 'split(" ")')"; 
   } || error "$FUNCNAME: At least 1 value expected")
  slash_json=$(echo "$slash_json" | ${jq_binary} '. += { "integration_types": '"${arg}"' }')  
}

function addCommandDefaultMemberPermissions {
  local arg=$([ ! -z "${1}" ] && echo "${1}" || error "$FUNCNAME: Value expected")
  slash_json=$(echo "$slash_json" | ${jq_binary} '. += { "default_member_permissions": "'"${arg}"'" }')
}

function addCommandContexts {
  local arg=$([ ! -z "${1}" ] && {
   IFS=','; 
   for i in "${1}"; do 
   contexts+="${application_install_types[${i}]},"; 
   done; 
   echo "$(echo -n ${contexts} | jq -cR 'split(" ")')"; 
   } || error "$FUNCNAME: At least 1 value expected")
  slash_json=$(echo "$slash_json" | ${jq_binary} '. += { "contexts": '"${arg}"' }')
}

function addCommandNSFW {
   local arg=$([ ! -z "${1}" ] && echo "${1}" || error "$FUNCNAME: Value expected")
  slash_json=$(echo "$slash_json" | ${jq_binary} '. += { "nsfw": '"${arg}"' }')
}

function addCommandVersion {
   local arg=$([ ! -z "${1}" ] && echo "${1}" || error "$FUNCNAME: Value expected")
  slash_json=$(echo "$slash_json" | ${jq_binary} '. += { "version": '"${arg}"' }')
}

function commandOptionsBuilder {
  slash_json=$(echo "$slash_json" | ${jq_binary} '. += { "options": [] }')
}

function addCommandOption {
  local type=$(
   if [ ! -z "${1}" ]; then
  [ ! -z "${application_option_types[${1}]}" ] && echo "${application_option_types[${1}]}" || echo 3;  
  else
  warn "$FUNCNAME: No command option type provided, using default (string)" && echo 3;
  fi
    )
  local name=$(
    [ ! -z "${2}" ] && echo "${2}" || error "$FUNCNAME: No option name provided 
    > ${cyan}$FUNCNAME${nc} \"${1}\" ${red}\"${2}\"${nc} \"${3}\" \"${4}\" \"${5}\" \"${6}\""; 
    )
#  local name_localizations=${3}
  local description=${3}
#  local description_localizations=${5}
  local required=${4}
  local choices=${5}
  if [ ! -z "$choices" ]; then 
    if [ "$(IFS=':|,'; read -ra output <<< "$choices"; echo "${#output[@]}")" -lt 2 ] && [[ "${choices:0:1}" != '[' ]]; then
      error "$FUNCNAME: Invalid option: expected at least name & value
      > ${cyan}$FUNCNAME${nc} \"${1}\" \"${2}\" \"${3}\" \"${4}\" ${red}\"${5}\"${nc} \"${6}\"";
    elif [[ "${choices:0:1}" != '[' ]]; then 
      choices=$(echo -n "$choices" | ${jq_binary} -scR 'split(",") | map(split(":")) | map({ name: .[0], value: .[1] })')
    fi
  fi
  case $type in 
  1|2) local options=${6} 
  slash_json=$(echo "$slash_json" | ${jq_binary} '.options |= . +  
  [{ 
     "type": '"${type}"', "name": "'"${name}"'", 
     "description": "'"${description}"'", 
     "required": '"${required:=false}"', "choices": '"${choices}"',
     "options": '"${options}"'
     }]') ;;
  3) 
  local min_length=${6}
  local max_length=$([ ! -z "${7}" ] && echo "$7" || warn "$FUNCNAME: No maximal length supplied, using default (255)" && echo 255) 
  local autocomplete=${8}
  slash_json=$(echo "$slash_json" | ${jq_binary} '.options |= . +  
  [{ 
     "type": '"${type}"', "name": "'"${name}"'", 
     "description": "'"${description}"'", 
     "required": '"${required:=false}"', "choices": '"${choices:=[]}"',
     "min_length": '"${min_length:=1}"', "max_length": '"${max_length}"',
     "autocomplete": '"${autocomplete:=false}"' 
     }]') ;;
  7)  
    [ ! -z "${6}" ] && { 
    for i in ${6//,/ }; do types+="${channel_types[$i]} "; done
    channeltypes=$(echo $types | ${jq_binary} -cR 'split(" ")'); 
  }
  slash_json=$(echo "$slash_json" | ${jq_binary} '.options |= . +  
  [{ 
     "type": '"${type}"', "name": "'"${name}"'", 
     "description": "'"${description}"'", 
     "required": '"${required:=false}"',
     "min_length": '"${min_length}"', "max_length": '"${max_length}"',
     "channel_types": '"${channeltypes}"' 
     }]') ;;
  4|10) 
  local min_values=${6}
  local max_values=$([ ! -z "${7}" ] && echo "$7" || warn "$FUNCNAME: No maximal value supplied, using default (255)" && echo 255) 
  local autocomplete=${8:=false}
  slash_json=$(echo "$slash_json" | ${jq_binary} '.options |= . +  
  [{ 
     "type": '"${type:=3}"', "name": "'"${name}"'", 
     "description": "'"${description}"'", 
     "required": '"${required:=false}"',
     "min_values": '"${min_values:=1}"', "max_length": '"${max_values:}"',
     "autocomplete": '"${autocomplete}"' 
     }]') ;;
    5|6|8|9|11) 
    slash_json=$(echo "$slash_json" | ${jq_binary} '.options |= . +  
  [{ 
     "type": '"${type:=3}"', "name": "'"${name}"'", 
     "description": "'"${description}"'", "required": '"${required:=false}"'
     }]') ;;
  esac
}
