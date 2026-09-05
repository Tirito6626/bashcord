function channel_threads_archived {
local type=${1}
local channel_id=${2}
local before=${3}
local limit=${4}
local json='{"before":"'"$before"'","limit":'"$limit"'}'
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/threads/archived/${type:=public}" -data -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent) 
if $f; then
echo $output 
fi
}