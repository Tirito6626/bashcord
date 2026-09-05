function channel_delete {
local channel_id=${1}
local output=$(curl "https://discord.com/api/v10/channels/${channel_id}" -H "Authorization: Bot ${token}" --data $json -H "Content-Type: application/json" -X DELETE --silent) 
if $f; then
echo $output 
fi
}