function interaction {
    arg_parser "$@"
	local route='' data='' required_args=() method='GET'
    local token="${token:-${Interaction[token]}}"
	case "$1" in
		reply) 
		    route="/interactions/${Interaction[id]}/$token/callback" method=POST
		    required_args=("data")
		    data="${data:+\{ \"type\": 4, \"data\": \"$data\" \}}" ;;
        defer)
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
	is_empty "${required_args[@]}" && { error_trace "$@"; return 1; }

	api_request "$route" "$method" ${data:+--data "$data"} -A InteractionCallback
	return $?
}