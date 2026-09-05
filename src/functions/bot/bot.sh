function bot { 
output=$(curl "https://discord.com/api/v10/applications/@me" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent) 
if $f; then
echo $output 
fi
}