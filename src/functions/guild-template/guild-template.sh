function guild-template {
template_code=${1}
output=$(curl "https://discord.com/api/v10/guilds/templates/${template_code}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}