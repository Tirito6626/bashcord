function channel_threads_archived_private_joined {
local channel_id=${1}
local before=${2}
local limit=${3}
local json='{"before":"'"$before"'","limit":'"$limit"'}'
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/users/@me/threads/archived/private" -data -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent) 
if $f; then
echo $output 
fi
}