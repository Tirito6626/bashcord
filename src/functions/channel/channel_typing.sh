function channel_typing {
local channel_id=${1}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/typing" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X POST --silent) 
if $f; then
echo $output 
fi
}