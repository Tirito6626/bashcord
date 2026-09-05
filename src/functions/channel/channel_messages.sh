function channel_messages {
local channel_id=${1}
local json=${2}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/messages" -H "Authorization: Bot ${token}" --data $json -H "Content-Type: application/json" -X GET --silent) 
if $f; then
echo $output 
fi
}