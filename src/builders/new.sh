#source /root/bashcord2/bashcord/bashcord/modules/shelljq

function new {
    local -a __trash=()
    case "${1,,}" in
        'instance')
            if [[ -z "$2" ]]; then 
                error_trace "Bot token required" 1 "$@"
                return 1
            fi
            declare -rg  __token="$2"
            declare -gA Application=()
            #set -x
            if ! api_request "/applications/@me" -A Application 2>/dev/null; then
                case "$response_code" in
                    429)
					    parse_sec "$ratelimit_reset_after"
					    error_trace "This IP is ratelimited (https://docs.discord.com/developers/topics/rate-limits). Any API requests will fail for $human_readable_time"$'\n' 1 "$@"
                        ;;
                    401)
                        error_trace "Failed to verify token" 1 "$@"
                	    return 1
                        ;;
                    *)
					    error_trace "Failed to verify token due to unknown error: ${error}" 1 "$@"
                	    return 1
                esac
            fi
            #set +x
            #echo "$request_output"
            #declare -p Application
            declare -gA Bot=()
            key_to_arr "bot" Bot true Application
            if [[ -z "$3" ]]; then 
                error_trace "Public key required" 2 "$@"
                return 1
            fi
            _savePubKey "$3"
            ;;
        'option')
            arg_parser "$@"
            case 1 in
            #    "$sub_command") type=1; trash+=("sub_command") ;;
            #    "$sub_command_group") type=2 ;;
                "$string") type=3;  __trash+=("string") ;;
                "$integer"|"$int") type=4; __trash+=("integer" "int") ;;
                "$boolean"|"$bool") type=5; __trash+=("boolean" "bool") ;;
                "$user") type=6; __trash+=("user") ;;
                "$channel") type=7; __trash+=("channel") ;;
                "$role") type=8; __trash+=("role") ;;
                "$mentionable") type=9; __trash+=("mentionable") ;;
                "$number") type=10; __trash+=("number") ;;
                "$attachment") type=11; __trash+=("attachment") ;;
                *) type="${application_option_types[$type]:-3}"
            esac
            required_args=("type" "name" "description")
            __trash+=("required" "autocomplete")

            local -A option_payload=(
                ["type"]="$type"
                ["name"]="$name"
                ["description"]="$description"
            )
            
                ! is_empty "${required_args[@]}" && \
                add_arr_if_exists option_payload string channel_type file_type && \
                add_if_exists option_payload bool autocomplete required && \
                add_if_exists option_payload int min_value max_value min_length max_length || { 
                error_trace "option" "$@"
                return 1
            }

            if [[ "$choice" ]]; then
                local __=''
                for key in "${choice[@]}"; do 
                    IFS=':' read key value <<< "$key"
                    __+="{\"name\":\"$key\",\"value\":\"$value\"},"
                done
                option_payload[choices]="[${__::-1}]"
            fi
            arr_to_json option_payload true
            json_trim "$arr_to_json_output" true true || \
            __TAG="$__bc_tag_json" error_trace "$__shjq_error"$'\n'"${_gray}while parsing${_nc} $arr_to_json_output" "$@"
            if is_true "$return"; then
                echo "$json_trim_output"
            else
                [[ "$option" ]] && option+=("$json_trim_output") || option=("$json_trim_output")
            fi
            ;;
        'command')
            if [[ -z "${Application[id]}" ]]; then
                error_trace "Couldn't access the application ID. Are you sure 'Application' array is available?" "command" "$@"
                return 1
            fi
            local route="/applications/${Application[id]}/commands" type='' json=''
            required_args=("type" "name" "description")
            arg_parser "$@"
            [[ "$guild" ]] && route+="/guilds/$guild"
            if [[ -z "$data" ]]; then
                case 1 in
                    "$chat_input"|"$slash") type=1; __trash+=("chat_input" "slash") ;;
                    "$user") type=2; __trash+=("user") ;;
                    "$message") type=3; __trash+=("message") ;;
                    *) 
                        if [[ -z "$type" ]]; then
                            error_trace "Invalid command type provided: '$type'"$'\n\n'"supported types: ${!application_types[*]}" '' "$@"
                            return 1
                        fi
                        type="${application_types[$type]}"
                esac
                [[ "$integration_type" ]] && for i in "${!integration_type[@]}"; do
                    integration_type[i]="${integration_types[${integration_type[$i]}]}"
                done
                #set -x

                local -A command_payload=(
                    ["type"]="$type"
                    ["name"]="$name"
                    ["description"]="$description"
                )

                {
                    ! is_empty "${required_args[@]}"
                    add_if_exists command_payload bool nsfw
                    add_arr_if_exists command_payload object option 
                    add_arr_if_exists command_payload int context integration_type
                } || { 
                    error_trace "$@"
                    return 1
                }
                arr_to_json command_payload true
                json_trim "$arr_to_json_output" true true || \
                __TAG="$__bc_tag_json" error_trace "$__shjq_error"$'\n'"${_gray}while parsing${_nc} $arr_to_json_output" "$@"
                #echo "$return"
                #return
                #echo "$route"
                __trash+=("command_payload" "arr_to_json_output")
                if is_true "$return"; then
                    echo "$json_trim_output"
                else
                    api_request "$route" POST -d "$json_trim_output"
                fi
            fi
    esac
    unset "${__trash[@]}" "${required_args[@]}"
    return 0
}
