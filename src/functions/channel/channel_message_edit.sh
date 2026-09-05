function channel_message_edit {
local channel_id=${1}
local json=${2}
local message_id=${3}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/messages/${message_id}" -H "Authorization: Bot ${token}" --data "$json" -H "Content-Type: application/json" -X PATCH --silent) 
if $f; then
echo $output 
fi
}