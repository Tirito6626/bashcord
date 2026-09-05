function channel_modify {
local channel_id=${1}
local json=${2}
local output=$(curl "https://discord.com/api/v10/channels/${channel_id}" -H "Authorization: Bot ${token}" --data $json -H "Content-Type: application/json" -X PATCH --silent) 
if $f; then
echo $output 
fi
}