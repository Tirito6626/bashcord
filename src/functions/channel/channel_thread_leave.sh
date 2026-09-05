function channel_thread_leave {
local channel_id=${1}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/thread-members/@me" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X DELETE --silent) 
if $f; then
echo $output 
fi
}