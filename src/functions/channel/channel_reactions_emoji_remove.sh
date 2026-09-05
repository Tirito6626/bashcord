function channel_reactions_emoji_remove {
local channel_id=${1}
local message_id=${2}
local emoji=${3}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/messages/${message_id}/reactions/${emoji}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent) 
if $f; then
echo $output 
fi
}