function bot_user {
output=$(curl "https://discord.com/api/v10/users/@me" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}