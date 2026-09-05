function guild-template_guild_create {
template_code=${1}
name=${2}
icon=${3}
output=$(curl "https://discord.com/api/v10/guilds/templates/${template_code}" -H "Authorization: Bot ${token}" --data '{"name":'"$name"',"icon":'"$icon"'}' -H "Content-Type: application/json" -X POST --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}