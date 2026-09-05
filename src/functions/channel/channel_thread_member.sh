function channel_thread_member {
local channel_id=${1}
local user_id=${2}
local with_member=${3}
local json='{"with_member":'"$with_member"'}'
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/thread-members/${user_id}" -data -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent) 
if $f; then
echo $output 
fi
}