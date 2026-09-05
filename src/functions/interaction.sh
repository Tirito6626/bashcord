function interaction {
    arg_parser "$@"
	local route='' required_args=() method='GET'
    local token="${token:-${Interaction[token]}}" use_response=0
	case "$1" in
		reply)
            (( callback )) || use_response=1
		    route="/interactions/${Interaction[id]}/$token/callback" method=POST
		    required_args=("data")
		    [[ "$data" ]] && data="{ \"type\": 4, \"data\": $data }" ;;
        defer)
            (( callback )) || use_response=1
			route="/interactions/${Interaction[id]}/$token/callback" method=POST data='{ "type": 5 }' ;;
		edit)
			required_args=("data")
			route="/webhooks/${Application[id]}/$token/messages/@original" method=POST ;;
		delete) 
			route="/webhooks/${Application[id]}/$token/messages/@original" method=DELETE ;;
		followup)
			route="/webhooks/${Application[id]}/$token"
            [[ "$2" ]] && required_args+=("id") route+="/messages/${id}"
			case "$2" in
				get) route+="/messages/${id}" ;;
				edit) method=PATCH required_args+=("data") ;;
				delete) method=DELETE ;;
			esac
			;;
		*)
		error_trace "Invalid action: $1" "$@"

	esac
	is_empty "${required_args[@]}" && error_trace "$@" && return 1

	if (( use_response )); then
        fiction.respond 200 "$data"
    else 
        api_request "$route" "$method" ${data:+--data "$data"} -A InteractionCallback
    fi
	return $?
}