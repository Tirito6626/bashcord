function channel_message_bulk-delete {
local channel_id=${1}
local messages_array=${2}
local json='{"messages": '"$messages_array"' }'
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/messages/bulk-delete" -H "Authorization: Bot ${token}" --data "$json" -H "Content-Type: application/json" -X POST --silent) 
if $f; then
echo $output 
fi
}