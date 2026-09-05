function application_guild_edit {
local application_id=${1}
local guild_id=${2}
local command_id=${3}
local json=${4}
output=$(curl "https://discord.com/api/v10/applications/${application_id}/guilds/${guild_id}/commands/${command_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X PATCH --silent -d $json | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}