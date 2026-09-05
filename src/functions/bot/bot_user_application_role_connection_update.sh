function bot_user_application_role_connection_update {
local application_id=${1}
local platform_name=${2}
local platform_username=${3}
local metadata=${4}
local json='{ "platform_name": "'"$platform_name"'", "platform_username":"'"$platform_username"'", "metadata": ['"$metadata"']}'
output=$(curl "https://discord.com/api/v10/users/@me/applications/${application_id}/role-connection" -H "Authorization: Bot ${token}" --data "$json" -H "Content-Type: application/json" -X PUT --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi

}