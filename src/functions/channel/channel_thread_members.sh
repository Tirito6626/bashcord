function channel_thread_members {
local channel_id=${1}
local with_member=${2}
local after=${3}
local limit=${4}
local json='{"with_member":'"$with_member"',"after":'"$after"',"limit":'"$limit"'}'
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/thread-members" -data -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent) 
if $f; then
echo $output 
fi
}