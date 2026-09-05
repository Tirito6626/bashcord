function new {
    case "${1,,}" in
        'instance')
            if [[ -z "$2" ]]; then 
                error_trace "Bot token required" 1 "$@"
                return 1
            fi
            declare -rg  __token="$2"
            declare -gA Application=()
            if ! api_request "/applications/@me" -A Application 2>/dev/null; then
                if [[ "$response_code" == 429 ]]; then
					parse_sec "$ratelimit_reset_after"
					error_trace "This IP is ratelimited (https://docs.discord.com/developers/topics/rate-limits). Any API requests will fail for $human_readable_time"$'\n' 1 "$@"
				else 
					error_trace "Invalid token provided" 1 "$@"
                	return 1
                fi
            fi
            declare -gA Bot=()
            key_to_arr "bot" Bot true Application
            if [[ -z "$3" ]]; then 
                error_trace "Public key required" 2 "$@"
                return 1
            fi
            _savePubKey "$3"
            ;;
    esac
}