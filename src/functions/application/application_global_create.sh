function application_global_create {
local application_id=${1}
local json=${2}
output=$(curl "https://discord.com/api/v10/applications/${application_id}/commands" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X POST --silent -d "$json" | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}