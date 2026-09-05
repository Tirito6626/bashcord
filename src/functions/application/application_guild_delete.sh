function application_guild_delete {
local application_id=${1}
local guild_id=${2}
local command_id=${3}
output=$(curl "https://discord.com/api/v10/applications/${application_id}/guilds/${guild_id}/commands/${command_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X DELETE --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}