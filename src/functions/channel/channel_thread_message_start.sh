function channel_thread_message_start {
local channel_id=${1}
local message_id=${2}
local name=${3}
local auto_archive_duration=${4}
local rate_limit_per_user=${5}
local json='{ "name": "'"$name"'", "auto_archive_duration": "'"$auto_archive_duration"'", "rate_limit_per_user": "'"$rate_limit_per_user"'" }'
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/messages/${message_id}/threads" -H "Authorization: Bot ${token}" --data "$json" -H "Content-Type: application/json" -X POST --silent) 
if $f; then
echo $output 
fi
}