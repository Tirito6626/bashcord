function applications_global {
  local application_id=${1}
  local with_localizations=${2} || with_localizations=false
  local json='{ "with_localizations": '"$with_locatlizations"' }'
output=$(curl "https://discord.com/api/v10/applications/${application_id}/commands" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent -d "$json" | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}