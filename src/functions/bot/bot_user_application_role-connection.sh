function bot_user_application_role-connection {
local application_id=${1}
output=$(curl "https://discord.com/api/v10/users/@me/applications/${application_id}/role-connection" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi

}