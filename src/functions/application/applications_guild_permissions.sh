function applications_guild_permissions {
local application_id=${1}
local guild_id=${2}
output=$(curl "https://discord.com/api/v10/applications/${application_id}}/guilds/${guild_id}/commands/permissions" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}