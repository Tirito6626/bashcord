function channel_crossport-message_send {
local channel_id=${1}
local message_id=${2}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/messages/${message_id}/crosspost" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X POST --silent) 
if $f; then
echo $output 
fi
}