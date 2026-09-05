function channel_message_reaction_remove {
local channel_id=${1}
local message_id=${2}
local emoji=${3}
local user_id=${4}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/messages/${message_id}/reactions/${emoji}/${user_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X DELETE --silent) 
if $f; then
echo $output 
fi
}