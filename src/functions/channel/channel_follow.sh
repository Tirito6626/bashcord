function channel_follow {
local channel_id=${1}
local webhook_channel_id=${2}
local json='{"webhook_channel_id": '"$webhook_channel_id"' }'
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/followers" -H "Authorization: Bot ${token}" --data "$json" -H "Content-Type: application/json" -X POST --silent) 
if $f; then
echo $output 
fi
}