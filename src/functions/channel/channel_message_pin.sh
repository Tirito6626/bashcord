function channel_message_pin {
local channel_id=${1}
local message_id=${2}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/pins/${message_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X PUT --silent) 
if $f; then
echo $output 
fi
}