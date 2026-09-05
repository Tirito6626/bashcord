function application_global {
local application_id=${1}
local command_id=${2}
output=$(curl "https://discord.com/api/v10/applications/${application_id}/commands/${command_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}