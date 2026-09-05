function guild {
    arg_parser "$@"
    local route='' route="/guilds/${id}" required_args=('id') method='GET' query_args=()
    case "$1" in
        preview) route+='/preview' ;;
        ban)
            required_args+=('user');
            route+="/bans/${user}" 
            case "$2" in
                get) : ;;
                remove|delete) method='DELETE' ;;
                bulk)
                    method='POST'
                    route="/guilds/${id}/bulk-ban" 
                    if [[ -z "$data" ]]; then 
                        required_args+=('users')
                        data="{ \"user_ids\": ${users}${delete_message_seconds:+, \"delete_message_seconds\": $delete_message_seconds} }"
                    fi
                    ;;
                *)   method='PUT' ;;
            esac
            ;;
        bans)
            route+="/bans/" 
            [[ "$limit" ]] && query_args+=("-Q limit:$limit")
            [[ "$before" ]] && query_args+=("-Q before:$before")
            [[ "$after" ]] && query_args+=("-Q limit:$after")
        ;;
        channels) route+='/channels' ;;
        channel)  ;;
        members) route+='/members' ;;
        member|user)
            required_args+=('user')
            route+="/members/${id}"
            case "$2" in
                ban) route="/guilds/${id}/bans/${user}" method='PUT' ;;
                unban) route="/guilds/${id}/bans/${user}" method='DELETE' ;; 
                kick|remove|delete) method='DELETE' ;;
                role)
                    required_args+=('role')
                    route+="/roles/${role}"
                    case "$3" in
                        add)  method='PUT' ;;
                        delete|remove) method='DELETE' ;;
                        *) error_trace "Invalid action: $2" "$@" ;;
                    esac
                ;;
        roles) route+='/roles' ;;
        role)
            route+='/roles'
            case "$2" in 
                create) method=POST required_args+=("data") ;;
                modify) method=PATCH required_args+=("data" "role") ;;
                delete|remove) method=DELETE required_args+=("role") ;;
                *) method=GET required_args+=("role") ;;
            esac
            ;;
        emojis) route+='/emojis' ;;
        emoji)
            required_args+=("emoji")
            case "$2" in
                create)
                    route+='/emojis'
                    method='POST'
                    required_args+=('name' 'image')
                    data="{\"name\": \"$name\", \"image\": \"$image\", \"roles\": $roles }"
                    ;;
                modify) 
                    required_args+=('roles')
                    data="{\"name\": \"$name\"${roles:+, \"roles\": $roles} }"
                    method='PATCH'
                    ;;
                delete|remove) method='DELETE' ;;
                *) error_trace "Invalid action: $2" "$@" ;;
            esac
        ;;
        integration) 
            required_args+=('integration')
            route+="/integrations/$integration"
            case "$2" in 
                delete) method='DELETE' ;;
                *)  error_trace "Invalid action: $2" "$@" ;;
            esac
            ;;
        integrations) route+="/integrations/" ;;
        invites) route+='/invites' ;;
        onboarding)
            route+="/onboarding"
            case "$2" in
                modify) method='PUT' required_args+=('data') ;;
            esac
            ;;
        sticker) : ;;
        stickers) : ;;
        templates) : ;;
        template) : ;;
        vanity-url) : ;;
    esac
    is_empty "${required_args[@]}" || { error_trace "$@"; return 1; }

    api_request "$route" -X "$method" "${query_args[@]}" ${data:+--data "$data"}
}

function guild_prune_count {
local guild_id=${1}
days=${2}
include_roles=${3}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/prune" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" --data '{"days": '$days', "include_roles",'"$include_roles"'}' -X GET --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}function guild_role_create {
local guild_id=${1}
name=${2}
permissions=${3}
color=${4}
hoist=${5}
mentionable=${6}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/roles" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" --data '{ "name": "'"${name}"'", "permissions": "'"${permissions}"'", "color": '"${color}"', "hoist": '"${hoist}"', "icon": null, "unicode_emoji": null, "mentionable": '"${mentionable}"' }' -X POST --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}function guild_role_delete {
local guild_id=${1}
role_id=${2}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/roles/${role_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X DELETE --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}function guild_role_modify {
local guild_id=${1}
role_id=${2}
name=${3}
permissions=${4}
color=${5}
hoist=${6}
mentionable=${7}
json='{ "name":'"${name}"', "permissions":'"${permissions}"', "color":'"${color}"', "hoist":'"${hoist}"', "icon":null, "unicode_emoji":null,"mentionable":'"${mentionable}"'}'
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/roles/${role_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" --data $json -X PATCH --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}function guild_role_position_modify {
local guild_id=${1}
role_id=${2}
position=${3}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/roles" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" --data '{"id":'"$role_id"',"position":'"$position"'}' -X PATCH --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}function guild_roles {
local guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/roles" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}
function guild {
local guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}function guild_sticker_create {
local guild_id=${1}
name=${2}
description=${3}
tags=${4}
file=${5}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/stickers/${sticker_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X POST --silent | ${jq_binary} '.') 
if $f; then
echo $output 
 fi
 }function guild_sticker_delete {
local guild_id=${1}
sticker_id=${2}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/stickers/${sticker_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X DELETE --silent | ${jq_binary} '.') 
if $f; then
echo $output 
 fi
 }function guild_sticker_modify {
local guild_id=${1}
name=${2}
description=${3}
tags=${4}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/stickers/${sticker_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X PATCH --silent | ${jq_binary} '.') 
if $f; then
echo $output 
 fi
 }function guild_sticker {
local guild_id=${1}
sticker_id=${2}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/stickers/${sticker_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | ${jq_binary} '.') 
if $f; then
echo $output 
 fi
 }function guild_stickers {
local guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/stickers" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | ${jq_binary} '.') 
if $f; then
echo $output 
 fi
 }function guild_template_create {
local guild_id=${1}
name=${2}
description=${3}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/templates" -H "Authorization: Bot ${token}" --data '{"name":'"$name"',"description":'"$description"'}' -H "Content-Type: application/json" -X POST --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}function guild_template_delete {
local guild_id=${1}
local template_code=${2}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/templates" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X DELETE --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}function guild_template_modify {
local guild_id=${1}
local template_code=${2}
local name=${3}
local description=${4}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/templates" -H "Authorization: Bot ${token}" --data '{"name":'"$name"',"description":'"$description"'}' -H "Content-Type: application/json" -X PATCH --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}function guild_templates {
local guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/templates" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}function guild_templates_sync {
local guild_id=${1}
local template_code=${2}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/templates/${template_code}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X PUT --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}function guild_template_sync {
local guild_id=${1}
local template_code=${2}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/templates/${template_code}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X PUT --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}function guild_threads_active {
local guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/threads/active" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}function guild_vanity-url {
local guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/vanity-url" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}function guild_voice_regions {
local guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/regions" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}function guild_voice-state_client_modify {
local guild_id=${1}
local channel_id=${2}
local suppress=${3}
local request_to_speak_timestamp=${4}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/voice-states/@me" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" --data '{"channel_id":'"$channel_id"',"suppress":'"$suppress"',"request_to_speak_timestamp":'"$request_to_speak_timestamp"'}' -X PATCH --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}function guild_voice-state_modify {
local guild_id=${1}
local user_id=${2}
local channel_id=${3}
local suppress=${4}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/voice-states/${user_id}" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" --data '{"channel_id":'"$channel_id"',"suppress":'"$suppress"',"request_to_speak_timestamp":'"$request_to_speak_timestamp"'}' -X PATCH --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}function guild_welcome-screen_modify {
local guild_id=${1}
enabled=${2}
welcome_channels=${3}
description=${4}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/welcome-screen" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" --data '{"enabled":'"$enabled"',"welcome_channels":'"$welcome_channels"',"description":'"$description"'}' -X PATCH --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}function guild_welcome-screen {
local guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/welcome-screen" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}function guild_widget_image {
local guild_id=${1}
type=${2}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/widget.png" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" --data '{"type":'"$type"'}' -X GET --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}function guild_widget_settings_modify {
local guild_id=${1}
widget_json=${2}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/widget" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -H "Content-Type: application/json" --data "$widget_json" -X PATCH --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}function guild_widget_settings {
local guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/widget" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}function guild_widget {
local guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/widget.json" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}function guild_widgets_image {
local guild_id=${1}
type=${2}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/widget.png" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" --data '{"type":'"$type"'}' -X GET --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}function guild_widgets_settings_modify {
local guild_id=${1}
widget_json=${2}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/widget" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -H "Content-Type: application/json" --data "$widget_json" -X PATCH --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}function guild_widgets_settings {
local guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/widget" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}function guild_widgets {
local guild_id=${1}
output=$(curl "https://discord.com/api/v10/guilds/${guild_id}/widget.json" -H "Authorization: Bot ${token}" -H "Content-Type: application/json" -X GET --silent | ${jq_binary} '.') 
if $f; then
echo $output 
fi
}