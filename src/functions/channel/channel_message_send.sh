function channel_message_send {
local channel_id=${1}
local json=${2}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/messages" -H "Authorization: Bot ${token}" --data "$2" -H "Content-Type: application/json" -X POST --silent) 
if $f; then
echo $output 
fi
}