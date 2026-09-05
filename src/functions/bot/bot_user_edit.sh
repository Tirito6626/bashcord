function bot_user_edit {
local username=${1}
local avatar=${2}
local json='{ "username": "'"$username"'", "avatar":"'"$avatar"'"}'
output=$(curl "https://discord.com/api/v10/users/@me" -H "Authorization: Bot ${token}" --data "$json" -H "Content-Type: application/json" -X PATCH --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}