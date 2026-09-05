function applications_guild {
local application_id=${1}
local guild_id=${2}
local with_localizations=${3} || with_localizations=false
local json='{ "with_localizations": '"$with_locatlizations"' }'
output=$(curl "https://discord.com/api/v10/applications/${application_id}/guilds/${guild_id}/commands" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent -d "$json" | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}