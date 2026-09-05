function application_guild_bulk-overwrite {
local application_id=${1}
local guild_id=${2}
local json=${3}
output=$(curl "https://discord.com/api/v10/applications/${application_id}}/guilds/${guild_id}/commands" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X PUT -d "$json" --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}