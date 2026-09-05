#!/bin/bash
function embedBuilder {
message_json=$(echo "$message_json" | ${jq_binary} '. += { "embeds": [{}] }')
}

function addTitle {
[ ! -z "${1}" ] && title="${1}" || error "$FUNCNAME: Value expected"
message_json=$(echo "$message_json" | ${jq_binary} --arg title "$title" '.embeds[] += { "title": "\($title)" }')
}

function addDescription {
local description=${1}
message_json=$(echo "$message_json" | ${jq_binary} --arg description "$description" '.embeds[] += { "description": "\($description)" }' )
}

function addColor {
[ ! -z "${1}" ] || error "$FUNCNAME: Value expected"
message_json=$(echo "$message_json" | ${jq_binary} '.embeds[] += { "color":"'"$1"'" }')
}

function addURL {
[ ! -z "${1}" ] || error "$FUNCNAME: Value expected"
message_json=$(echo "$message_json" | ${jq_binary} '.embeds[] += { "url":"'"$1"'" }')
}

function addTimestamp {
[ ! -z "${1}" ] || error "$FUNCNAME: Value expected"
message_json=$(echo "$message_json" | ${jq_binary} '.embeds[] += { "timestamp":"'"$1"'" }')
}

function addFooter {
[ ! -z "${1}" ] || error "$FUNCNAME: Value expected"
message_json=$(echo "$message_json" | ${jq_binary} '.embeds[] += { "footer": {"text":"'"$1"'" } }')
}

function addImage {
[ ! -z "${1}" ] || error "$FUNCNAME: Value expected"
message_json=$(echo "$message_json" | ${jq_binary} '.embeds[] += { "image":{ "url":"'"$1"'" } }')
}

function addVideo {
[ ! -z "${1}" ] || error "$FUNCNAME: Value expected"
message_json=$(echo "$message_json" | ${jq_binary} '.embeds[] += { "video":{ "url":"'"$1"'" } }')
}

function addThumbnail {
[ ! -z "${1}" ] || error "$FUNCNAME: At least 1 value expected"
local json='{"url":"'"$1"'"}'
[ ! -z ${2} ] && json="$(json_append '{}' "proxy_url" "$2")"
[ ! -z ${3} ] && json="$(json_append '{}' "height" "$3")"
[ ! -z ${4} ] && json="$(json_append '{}' "width" "$4")"
message_json=$(json_append "$message_json" '.embeds[]' '{ "thumbnail":'"$json"' }')
}

function addProvider {
[ ! -z "${1}" ] && local name="${1}" || error "$FUNCNAME: Name expected"
[ ! -z "${2}" ] && local url="${1}" || error "$FUNCNAME: URL expected"
message_json=$(echo "$message_json" | ${jq_binary} '.embeds[] += { "provider":{ "name":"'"$name"'","url":"'"$url"'" } }')
}
function addAuthor {
[ ! -z "${1}" ] || error "$FUNCNAME: Name expected"
[ ! -z "${2}" ] || error "$FUNCNAME: URL expected"
message_json=$(echo "$message_json" | ${jq_binary} '.embeds[] += { "author":{ "name":"'"$1"'","url":"'"$2"'" } }')
}
function addField {
  [ ! -z "${1}" ] || error "$FUNCNAME: Name expected"
  [ ! -z "${2}" ] || error "$FUNCNAME: URL expected"
  local inline=${3}
  message_json=$(echo "$message_json" | ${jq_binary} '.embeds[].fields |= . + [{ "name": "'"$1"'", "value":"'"$2"'", "inline": "'"${inline:=false}"'" }]')
}
