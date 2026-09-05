function channel_thread_join {
local channel_id=${1}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/thread-members/@me" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X PUT --silent) 
if $f; then
echo $output 
fi
}