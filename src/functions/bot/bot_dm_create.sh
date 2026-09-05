function bot_dm_create {
  local user_id=${2}
  local json='"{"recipient_id":"'"$user_id"'"}'
output=$(curl "https://discord.com/api/v10/users/@me/channels" -H "Authorization: Bot ${token}" --data "$json" -H "Content-Type: application/json" -X POST --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi

}