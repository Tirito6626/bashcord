function channel_message_reactions {
local channel_id=${1}
local message_id=${2}
local emoji=${3}
local after=${4}
local limit=${5}
local json='{ "after": "'"$after"'", "limit": "'$limit'" }'
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/messages/${message_id}/reactions/${emoji}" -H "Authorization: Bot ${token}" -d "'$json'"-H "Content-Type: application/json" -X GET --silent) 
if $f; then
echo $output 
fi
}