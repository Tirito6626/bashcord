function channel_thread_member_remove {
local channel_id=${1}
local user_id=${2}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/thread-members/${user_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X DELETE --silent) 
if $f; then
echo $output 
fi
}