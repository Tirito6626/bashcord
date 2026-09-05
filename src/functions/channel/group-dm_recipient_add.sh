function group-dm_recipient_add {
local channel_id=${1}
local user_id=${2}
local access_token=${3}
local nick=${4}
local json='{ "access_token": "'"$access_token"'", "nick": "'"$nick"'" }'
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/recipients/${user_id}" -H "Authorization: Bot ${token}" --data "$json" -H "Content-Type: application/json" -X PUT --silent) 
if $f; then
echo $output 
fi
}