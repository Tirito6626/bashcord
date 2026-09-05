function bot_guilds {
output=$(curl "https://discord.com/api/v10/users/@me/guilds" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi

}