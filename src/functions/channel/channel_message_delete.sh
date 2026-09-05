function channel_message_delete {
local channel_id=${1}
local message_id=${2}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/messages/${message_id}" -H "Authorization: Bot ${token}"  -H "Content-Type: application/json" -X DELETE --silent) 
if $f; then
echo $output 
fi
}