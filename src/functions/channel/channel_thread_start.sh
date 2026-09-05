function channel_thread_start {
local channel_id=${1}
local name=${2}
local auto_archive_duration=${3}
local type=${4}
local invitable=${5}
local rate_limit_per_user=${6}
local json='{ "name": "'"$name"'", "auto_archive_duration": "'"$auto_archive_duration"'", "type": '"${type}"', "invitable": '"${invitable}"', "rate_limit_per_user": "'"$rate_limit_per_user"'" }'
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/threads" -H "Authorization: Bot ${token}" --data "$json" -H "Content-Type: application/json" -X POST --silent) 
if $f; then
echo $output 
fi
}