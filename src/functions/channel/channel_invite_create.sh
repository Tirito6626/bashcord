function channel_invite_create {
local channel_id=${1}
local max_age=${2}
local max_uses=${3}
local temporary=${4}
local unique=${5}
local target_type=${6}
local target_user_id=${7}
local target_application_id=${8}
local json='{"max_age": '"$max_age"', "max_uses"; '"$max_uses"', "temporary": '"$temporary"', "unique": '"$unique"', "target_type": '"$target_type"', "target_user_id": '"$target_user_id"', "target_application_id":'"$target_application_id"' }'
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/invites" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent) 
if $f; then
echo $output 
fi
}