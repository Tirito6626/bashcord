#!/bin/bash
function messageBuilder {
message_json="{}"
}
function addContent {
local content=$([ ! -z "${1}" ] && echo "${1}" || error "$FUNCNAME: Value expected")
message_json=$( echo "$message_json" | ${jq_binary} --arg content "$content" '. += { "content": "\($content)" }')
}
function addTTS {
local tts=$([ ! -z "${1}" ] && echo "${1}" || error "$FUNCNAME: Value expected")
message_json=$( echo "$message_json" | ${jq_binary} '. += { "tts":'"$tts"' }')
}
function addAllowedMentions {
local parse="${1}"
local users="${2}"
local roles="${3}"
local replied_user="${4}"
message_json=$( echo "$message_json" | ${jq_binary} '. += { "allowed_mentions": {} }')
[ ! -z "$parse" ] && message_json=$( echo "$message_json" | ${jq_binary} '.allowed_mentions += { "parse": ["'"${parse// /\",\"}"'"] }')
[ ! -z "$users" ] && message_json=$( echo "$message_json" | ${jq_binary} '.allowed_mentions += { "users": ["'"${users// /\",\"}"'"] }')
[ ! -z "$roles" ] && message_json=$( echo "$message_json" | ${jq_binary} '.allowed_mentions += { "roles": ["'"${roles// /\",\"}"'"] }')
[ ! -z "$replied_user" ] && message_json=$( echo "$message_json" | ${jq_binary} '.allowed_mentions += { "parse": '"$replied_user"' }')
}
function addPoll {
local question="${1}"
local answers="${2}"
local expiry="${3}"
local multiselect="${4}"
[ ! -z "$answers" ] && [[ "${answers:0:1}" != '[' ]] && answers=$(echo -n "$answers" | ${jq_binary} -scR 'split(",") | map(split(":")) | map([{ id: (.[0]), type: .[1] }]) | add')
}