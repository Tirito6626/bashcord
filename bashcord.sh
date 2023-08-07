#!/bin/bash
REQUIRED_PKG="jq"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG| grep "ok" | awk '{print $2}')
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "$REQUIRED_PKG is missing. Setting up $REQUIRED_PKG."
  apt-get --yes install $REQUIRED_PKG
fi
REQUIRED_PKG2="curl"
PKG_OK2=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG2 |grep "ok" | awk '{print $2}')
echo Checking for $REQUIRED_PKG2: $PKG_OK2
if [ "" = "$PKG_OK2" ]; then
  echo "$REQUIRED_PKG2 is missing. Setting up $REQUIRED_PKG2."
  apt-get --yes install $REQUIRED_PKG2
fi
function messageBuilder {
message_json="{}"
}
##############################################################
function addContent {
local content=${1}
message_json=$( echo $message_json | jq --arg content "$content" '. += { "content": "\($content)" }')
}
##############################################################
function addTTS {
local tts=${1}
message_json=$( echo $message_json | jq '. += { "tts":'"$tts"' }')
}
##############################################################
function embedBuilder {
message_json=$( echo $message_json | jq '. += { "embeds": [{}] }')
}
##############################################################
function addTitle {
local title=${1}
message_json=$( echo $message_json | jq --arg title "$title" '.embeds[] += { "title": "\($title)" }')
}
##############################################################
function addDescription {
local description=${1}
message_json=$( echo $message_json | jq --arg description "$description" '.embeds[] += { "description": "\($description)" }' )
}
##############################################################
function addColor {
local color=${1}
message_json=$( echo $message_json | jq '.embeds[] += { "color":"'"$color"'" }')
}
##############################################################
function addURL {
local url=${1}
message_json=$( echo $message_json | jq '.embeds[] += { "url":"'"$url"'" }')
}
##############################################################
function addTimestamp {
local timestamp=${1}
message_json=$( echo $message_json | jq '.embeds[] += { "timestamp":"'"$timestamp"'" }')
}
##############################################################
function addColor {
local color=${1}
message_json=$( echo $message_json | jq '.embeds[] += { "color":"'"$color"'" }')
}
##############################################################
function addFooter {
local text=${1}
message_json=$( echo $message_json | jq '.embeds[] += { "footer": {"text":"'"$text"'" } }')
}
##############################################################
function addImage {
local url=${1}
message_json=$( echo $message_json | jq '.embeds[] += { "image":{ "url":"'"$url"'" } }')
}
##############################################################
function addVideo {
local url=${1}
message_json=$( echo $message_json | jq '.embeds[] += { "video":{ "url":"'"$url"'" } }')
}
##############################################################
function addThumbnail {
local url=${1}
local proxy_url=${2}
local height=${3}
local width=${4}
message_json=$( echo $message_json | jq '.embeds[] += { "thumbnail":{ "url":"'"$url"'" } }')
}
##############################################################
function addProvider {
local name=${1}
local url=${2}
message_json=$( echo $message_json | jq '.embeds[] += { "provider":{ "name":"'"$name"'","url":"'"$url"'" } }')
}
##############################################################
function addAuthor {
local name=${1}
local url=${2}
message_json=$( echo $message_json | jq '.embeds[] += { "author":{ "name":"'"$name"'","url":"'"$url"'" } }')
}
##############################################################
function addField {
local name=${1}
local value=${2}
local inline=${3}
message_json=$( echo $message_json | jq '.embeds[] += { "fields": [{}] }')
message_json=$( echo $message_json | jq '.embeds[].fields[] |= { "name":"'"$name"'","value":"'"$value"'" } ')
}


function channel {
channel_id=${1}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent) 
echo -e $output  
}
##############################################################
function channel_modify {
channel_id=${1}
json=${2}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}" -H "Authorization: Bot ${token}" --data $json -H "Content-Type: application/json" -X PATCH --silent) 
echo -e $output  
}
##############################################################
function channel_delete {
channel_id=${1}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}" -H "Authorization: Bot ${token}" --data $json -H "Content-Type: application/json" -X DELETE --silent) 
echo -e $output  
}
##############################################################
function channel_messages {
channel_id=${1}
json=${2}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/messages" -H "Authorization: Bot ${token}" --data $json -H "Content-Type: application/json" -X GET --silent) 
echo -e $output  
}
##############################################################
function channel_message {
channel_id=${1}
message_id=${2}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/messages/${message_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent) 
echo -e $output  
}
##############################################################
function channel_message_send {
channel_id=${1}
local json=${2}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/messages" -H "Authorization: Bot ${token}" --data "$json" -H "Content-Type: application/json" -X POST --silent) 
echo -e $output  
}
##############################################################
function channel_crossport-message_send {
local channel_id=${1}
local message_id=${2}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/messages/${message_id}/crosspost" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X POST --silent) 
echo -e $output  
}
##############################################################
function channel_reaction_add {
local channel_id=${1}
local message_id=${2}
local emoji=${3}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/messages/${message_id}/reactions/${emoji}/@me" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X PUT --silent) 
echo -e $output  
}
##############################################################
function channel_reaction_remove {
local channel_id=${1}
local message_id=${2}
local emoji=${3}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/messages/${message_id}/reactions/${emoji}/@me" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X DELETE --silent) 
echo -e $output  
}
##############################################################
function channel_reaction_user_remove {
local channel_id=${1}
local message_id=${2}
local emoji=${3}
local user_id=${4}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/messages/${message_id}/reactions/${emoji}/${user_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X DELETE --silent) 
echo -e $output  
}
##############################################################
function channel_reactions {
local channel_id=${1}
local message_id=${2}
local emoji=${3}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/messages/${message_id}/reactions/${emoji}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent) 
echo -e $output  
}
##############################################################
function channel_reactions_remove {
local channel_id=${1}
local message_id=${2}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/messages/${message_id}/reactions" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X DELETE --silent) 
echo -e $output  
}
##############################################################
function channel_reactions_emoji_remove {
local channel_id=${1}
local message_id=${2}
local emoji=${3}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/messages/${message_id}/reactions/${emoji}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent) 
echo -e $output  
}
##############################################################
function channel_message_edit {
local channel_id=${1}
local json=${2}
local message_id=${3}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/messages/${message_id}" -H "Authorization: Bot ${token}" --data "$json" -H "Content-Type: application/json" -X PATCH --silent) 
echo -e $output  
}
##############################################################
function channel_message_delete {
local channel_id=${1}
local message_id=${2}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/messages/${message_id}" -H "Authorization: Bot ${token}"  -H "Content-Type: application/json" -X DELETE --silent) 
echo -e $output  
}
##############################################################
function channel_message_bulk-delete {
local channel_id=${1}
local messages_array=${2}
local json='{"messages": '"$messages_array"' }'
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/messages" -H "Authorization: Bot ${token}" --data "$json" -H "Content-Type: application/json" -X POST --silent) 
echo -e $output  
}
##############################################################
function channel_permissions_edit {
local channel_id=${1}
local overwrite_id=${2}
local allow=${3}
local deny=${4}
local type=${5}
local json='{"allow": "'"$allow"'", "deny"; "'"$deny"'", "type": '"$type"' }'
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/permissions/${overwrite_id}" -H "Authorization: Bot ${token}" --data "$json" -H "Content-Type: application/json" -X PUT --silent) 
echo -e $output  
}
##############################################################
function channel_permissions_delete {
local channel_id=${1}
local overwrite_id=${2}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/permissions/${overwrite_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X DELETE --silent) 
echo -e $output  
}
##############################################################
function channel_invites {
local channel_id=${1}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/invites" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent) 
echo -e $output  
}
##############################################################
function channel_invites_create {
local channel_id=${1}
local max_age=${2}
local max_uses=${3}
local temporary=${4}
local unique=${5}
local target_type=${6}
local target_user_id=${7}
local target_application_id=${7}
local json='{"max_age": '"$max_age"', "max_uses"; '"$max_uses"', "temporary": '"$temporary"', "unique": '"$unique"', "target_type": '"$target_type"', "target_user_id": '"$target_user_id"', "target_application_id":'"$target_application_id"' }'
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/invites" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent) 
echo -e $output  
}
##############################################################
function channel_follow {
local channel_id=${1}
local webhook_channel_id=${2}
local json='{"webhook_channel_id": '"$webhook_channel_id"' }'
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/followers" -H "Authorization: Bot ${token}" --data "$json" -H "Content-Type: application/json" -X POST --silent) 
echo -e $output  
}
##############################################################
function channel_typing {
local channel_id=${1}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/typing" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X POST --silent) 
echo -e $output  
}
##############################################################
function channel_pins {
local channel_id=${1}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/typing" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent) 
echo -e $output  
}
##############################################################
function channel_message_pin {
local channel_id=${1}
local message_id=${2}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/pins/${message_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X PUT --silent) 
echo -e $output  
}
##############################################################
function channel_message_unpin {
local channel_id=${1}
local message_id=${2}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/pins/${message_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X DELETE --silent) 
echo -e $output  
}
##############################################################
function group-dm_recipient_add {
local channel_id=${1}
local user_id=${2}
local access_token=${3}
local nick=${4}
local json='{ "access_token": "'"$access_token"'", "nick": "'"$nick"'" }'
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/recipients/${user_id}" -H "Authorization: Bot ${token}" --data "$json" -H "Content-Type: application/json" -X PUT --silent) 
echo -e $output  
}
##############################################################
function group-dm_recipient_remove {
local channel_id=${1}
local user_id=${2}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/recipients/${user_id}" -H "Authorization: Bot ${token}" --data "$json" -H "Content-Type: application/json" -X DELETE --silent) 
echo -e $output  
}
##############################################################
function channel_thread_message_start {
local channel_id=${1}
local message_id=${2}
local name=${3}
local auto_archive_duration=${4}
local rate_limit_per_user=${5}
local json='{ "name": "'"$name"'", "auto_archive_duration": "'"$auto_archive_duration"'", "rate_limit_per_user": "'"$rate_limit_per_user"'" }'
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/messages/${message_id}/threads" -H "Authorization: Bot ${token}" --data "$json" -H "Content-Type: application/json" -X POST --silent) 
echo -e $output  
}
##############################################################
function channel_thread_start {
local channel_id=${1}
local name=${2}
local auto_archive_duration=${3}
local rate_limit_per_user=${4}
local json='{ "name": "'"$name"'", "auto_archive_duration": "'"$auto_archive_duration"'", "rate_limit_per_user": "'"$rate_limit_per_user"'" }'
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/threads" -H "Authorization: Bot ${token}" --data "$json" -H "Content-Type: application/json" -X POST --silent) 
echo -e $output  
}
##############################################################
function channel_thread_join {
local channel_id=${1}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/thread-members/@me" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X PUT --silent) 
echo -e $output  
}
##############################################################
function channel_thread_leave {
local channel_id=${1}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/thread-members/@me" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X DELETE --silent) 
echo -e $output  
}
##############################################################
function channel_thread_member_add {
local channel_id=${1}
local user_id=${2}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/thread-members/${user_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X PUT --silent) 
echo -e $output  
}
##############################################################
function channel_thread_member_remove {
local channel_id=${1}
local user_id=${2}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/thread-members/${user_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X DELETE --silent) 
echo -e $output  
}
##############################################################
function channel_thread_member_get {
local channel_id=${1}
local user_id=${2}
local with_member=${3}
local json='{"with_member":'"$with_member"'}'
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/thread-members/${user_id}" -data -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent) 
echo -e $output  
}
##############################################################
function channel_thread_members_get {
local channel_id=${1}
local with_member=${2}
local after=${3}
local limit=${4}
local json='{"with_member":'"$with_member"',"after":'"$after"',"limit":'"$limit"'}'
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/thread-members" -data -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent) 
echo -e $output  
}
##############################################################
function channel_threads_archived_public {
local channel_id=${1}
local before=${2}
local limit=${3}
local json='{"before":"'"$before"'","limit":'"$limit"'}'
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/threads/archived/public" -data -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent) 
echo -e $output  
}
##############################################################
function channel_threads_archived_private {
local channel_id=${1}
local before=${2}
local limit=${3}
local json='{"before":"'"$before"'","limit":'"$limit"'}'
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/threads/archived/private" -data -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent) 
echo -e $output  
}
##############################################################
function channel_threads_archived_private_joined {
local channel_id=${1}
local before=${2}
local limit=${3}
local json='{"before":"'"$before"'","limit":'"$limit"'}'
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/users/@me/threads/archived/private" -data -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent) 
echo -e $output  
}


function bot { 
output=$(curl "https://discord.com/api/v10/applications/@me" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent) 
echo -e $output
}
##############################################################
function bot_user {
output=$(curl "https://discord.com/api/v10/users/@me" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | jq '.') 
echo $output
}
##############################################################
function bot_user_edit {
local username=${1}
local avatar=${2}
local json='{ "username": "'"$username"'", "avatar":"'"$avatar"'"}'
output=$(curl "https://discord.com/api/v10/users/@me" -H "Authorization: Bot ${token}" --data "$json" -H "Content-Type: application/json" -X PATCH --silent | jq '.') 
echo $output
}
##############################################################
function bot_guilds {
output=$(curl "https://discord.com/api/v10/users/@me/guilds" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | jq '.') 
echo $output
}
##############################################################
function bot_member {
  local guild_id=${2}
output=$(curl "https://discord.com/api/v10/users/@me/guilds/${guild_id}/member" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | jq '.') 
echo $output
}
##############################################################
function bot_dm_create {
  local user_id=${2}
  local json='"{"recipient_id":"'"$user_id"'"}'
output=$(curl "https://discord.com/api/v10/users/@me/channels" -H "Authorization: Bot ${token}" --data "$json" -H "Content-Type: application/json" -X POST --silent | jq '.') 
echo $output
}


function guild {
guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_delete {
guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X DELETE --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_channels {
guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/channels" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_threads_active {
guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/threads/active" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_member {
guild_id=${1}
user_id=${2}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/members/${user_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | jq '.') 
echo -e $output 
}
function guild_members {
guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/members" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_member_role_add {
guild_id=${1}
user_id=${2}
role_id=${3}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/members/${user_id}/roles/${role_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X PUT --silent | jq '.') 
echo -e $output 
}
function guild_member_role_remove {
guild_id=${1}
user_id=${2}
role_id=${3}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/members/${user_id}/roles/${role_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X DELETE --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_member_kick {
guild_id=${1}
user_id=${2}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/members/${user_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X DELETE --silent | jq '.') 
echo -e $output 
}
function guild_member_ban {
guild_id=${1}
user_id=${2}
delete_message_days=${3}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/bans/${user_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json"  --data '{"delete_message_days":'"${delete_message_days}"'}' -X PUT --silent | jq '.') 
echo -e $output 
}
function guild_member_unban {
guild_id=${1}
user_id=${2}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/bans/${user_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X DELETE --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_bans_get {
guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/bans" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | jq '.') 
echo -e $output 
}
function guild_ban_get {
guild_id=${1}
user_id=${2}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/bans/${user_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_roles {
guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/roles" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | jq '.') 
echo -e $output 
}
function guild_roles_create {
guild_id=${1}
name=${2}
permissions=${3}
color=${4}
hoist=${5}
mentionable=${6}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/roles" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" --data '{ "name": "'"${name}"'", "permissions": "'"${permissions}"'", "color": '"${color}"', "hoist": '"${hoist}"', "icon": null, "unicode_emoji": null, "mentionable": '"${mentionable}"' }' -X POST --silent | jq '.') 
echo -e $output 
echo $json
}
##############################################################
function guild_roles_positions_modify {
guild_id=${1}
role_id=${2}
position=${3}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/roles" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" --data '{"id":'"$role_id"',"position":'"$position"'}' -X PATCH --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_roles_modify {
guild_id=${1}
role_id=${2}
name=${3}
permissions=${4}
color=${5}
hoist=${6}
mentionable=${7}
json='{ "name":'"${name}"', "permissions":'"${permissions}"', "color":'"${color}"', "hoist":'"${hoist}"', "icon":null, "unicode_emoji":null,"mentionable":'"${mentionable}"'}'
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/roles/${role_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" --data $json -X PATCH --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_roles_delete {
guild_id=${1}
role_id=${2}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/roles/${role_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X DELETE --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_mfa_modify {
guild_id=${1}
mfa_lvl=${2}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/mfa" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" --data '{"level": '$mfa_lvl'}' -X POST --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_prune_count {
guild_id=${1}
days=${2}
include_roles=${3}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/prune" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" --data '{"days": '$days', "include_roles",'"$include_roles"'}' -X GET --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_prune_count {
guild_id=${1}
days=${2}
compute_prune_count=${3}
include_roles=${4}
reason=${5}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/prune" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" --data '{"days": '$days',"compute_prune_count":'"$compute_prune_count"', "include_roles",'"$include_roles"',"reason":'"$reason"'}' -X POST --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_voice_regions {
guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/regions" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_invites {
guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/invites" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_integrations {
guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/integrations" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_integrations_delete {
guild_id=${1}
intergration_id=${2}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/integrations/${intergration_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X DELETE --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_widgets_settings {
guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/widget" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_widgets_settings_modify {
guild_id=${1}
widget_json=${2}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/widget" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -H "Content-Type: application/json" --data "$widget_json" -X PATCH --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_widgets {
guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/widget.json" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_widgets_image {
guild_id=${1}
type=${2}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/widget.png" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" --data '{"type":'"$type"'}' -X GET --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_vanity-url {
guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/vanity-url" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_welcome-screen {
guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/welcome-screen" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_welcome-screen_modify {
guild_id=${1}
enabled=${2}
welcome_channels=${3}
description=${4}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/welcome-screen" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" --data '{"enabled":'"$enabled"',"welcome_channels":'"$welcome_channels"',"description":'"$description"'}' -X PATCH --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_onboarding {
guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/onboarding" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_onboarding_modify {
guild_id=${1}
prompts=${2}
default_channel_ids=${3}
enabled=${4}
mode=${5}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/onboarding" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" --data '{"prompts":'"$prompts"',"default_channel_ids":'"$default_channel_ids"',"enabled":'"$enabled"',"mode":'"$mode"'}' -X PUT --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_voice-states_client_modify {
guild_id=${1}
channel_id=${2}
suppress=${3}
request_to_speak_timestamp=${4}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/voice-states/@me" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" --data '{"channel_id":'"$channel_id"',"suppress":'"$suppress"',"request_to_speak_timestamp":'"$request_to_speak_timestamp"'}' -X PATCH --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_voice-states_modify {
guild_id=${1}
user_id=${2}
channel_id=${3}
suppress=${4}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/voice-states/${user_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" --data '{"channel_id":'"$channel_id"',"suppress":'"$suppress"',"request_to_speak_timestamp":'"$request_to_speak_timestamp"'}' -X PATCH --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_templates {
guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/templates" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_templates_create {
guild_id=${1}
name=${2}
description=${3}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/templates" -H "Authorization: Bot ${token}" --data '{"name":'"$name"',"description":'"$description"'}' -H "Content-Type: application/json" -X POST --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_templates_sync {
guild_id=${1}
template_code=${2}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/templates/${template_code}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X PUT --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_templates_modify {
guild_id=${1}
template_code=${2}
name=${3}
description=${4}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/templates" -H "Authorization: Bot ${token}" --data '{"name":'"$name"',"description":'"$description"'}' -H "Content-Type: application/json" -X PATCH --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_templates_delete {
guild_id=${1}
template_code=${2}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/templates" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X DELETE --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_emojis {
guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/emojis" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_emoji {
guild_id=${1}
emoji_id=${2}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/emojis/${emoji_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_emoji_create {
guild_id=${1}
name=${3}
image=${4}
roles=${5}
local json='{"name":"'"$name"'", "image":"'"$image"'", "roles": '"$roles"'}'
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/emojis" -H "Authorization: Bot ${token}" --data "$json" -H "Content-Type: application/json" -X POST --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_emoji_modify {
guild_id=${1}
emoji_id=${2}
name=${3}
roles=${5}
local json='{"name":"'"$name"'", "roles": '"$roles"'}'
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/emojis" -H "Authorization: Bot ${token}" --data "$json" -H "Content-Type: application/json" -X PATCH --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild_emoji_delete {
guild_id=${1}
emoji_id=${2}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/emojis/${emoji_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X DELETE --silent | jq '.') 
echo -e $output 
}


function guild-template {
template_code=${1}
output=$(curl "https://discord.com/api/v10/guilds/templates/${template_code}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | jq '.') 
echo -e $output 
}
##############################################################
function guild-template_guild_create {
template_code=${1}
name=${2}
icon=${3}
output=$(curl "https://discord.com/api/v10/guilds/templates/${template_code}" -H "Authorization: Bot ${token}" --data '{"name":'"$name"',"icon":'"$icon"'}' -H "Content-Type: application/json" -X POST --silent | jq '.') 
echo -e $output 
}



function invite {
invite_code=${1}
output=$(curl "https://discord.com/api/v10/invites/${invite_code}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | jq '.') 
echo $output
}

function user {
user_id=${1}
output=$(curl "https://discord.com/api/v10/users/${user_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | jq '.') 
echo $output
}

bot=$(curl https://discord.com/api/v10/applications/@me -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent) 
apilatency=$(curl -o /dev/null -s -w ' API Latency: %{time_total}s\n'  https://discord.com/api/v10/applications/@me H "Authorization: Bot ${token}" -H "Content-Type: application/json")
botid=$(echo $bot | awk '{print $2}' | jq '.bot.id')
botname=$(echo $bot | jq '.bot.username')
botdiscriminator=$(echo $bot | jq '.bot.discriminator')
echo "========================================"
echo "Logged as ${botname}#${botdiscriminator}"
echo "Running bashcord v0.4.8"
echo "${apilatency}"
echo "========================================"
# read prompt args1 args2 args3 args4 args4 
# bash ${1}
