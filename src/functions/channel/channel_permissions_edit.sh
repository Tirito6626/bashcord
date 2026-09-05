function channel_permissions_edit {
local channel_id=${1}
local overwrite_id=${2}
local allow=${3}
local deny=${4}
local type=${5}
local json='{"allow": "'"$allow"'", "deny"; "'"$deny"'", "type": '"$type"' }'
output=$(curl "https://discord.com/api/v10/channels/${channel_id}/permissions/${overwrite_id}" -H "Authorization: Bot ${token}" --data "$json" -H "Content-Type: application/json" -X PUT --silent) 
if $f; then
echo $output 
fi
}