function channel_reaction_add {
local channel_id=${1}
local message_id=${2}
local emoji=${3}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/messages/${message_id}/reactions/${emoji}/@me" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X PUT --silent) 
if $f; then
echo $output 
fi
}