function group-dm_recipient_remove {
local channel_id=${1}
local user_id=${2}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/recipients/${user_id}" -H "Authorization: Bot ${token}" --data "$json" -H "Content-Type: application/json" -X DELETE --silent) 
if $f; then
echo $output 
fi
}