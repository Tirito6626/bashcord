function channel_permission_delete {
local channel_id=${1}
local overwrite_id=${2}
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/permissions/${overwrite_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X DELETE --silent) 
if $f; then
echo $output 
fi
}