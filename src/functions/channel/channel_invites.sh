function channel_invites {
local channel_id=${1}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/invites" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent) 
if $f; then
echo $output 
fi
}