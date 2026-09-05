function bot_member {
  local guild_id=${2}
output=$(curl "https://discord.com/api/v10/users/@me/guilds/${guild_id}/member" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | ${jq_binary} '.') 
if $f; then
echo "$output" 
fi

}