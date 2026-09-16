function interaction {
	local route='' required_args=() method='GET' data='' args=()
    arg_parser "$@"
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
		followup|follow_up)
			route="/webhooks/${Application[id]}/$token" method=POST
			case "$2" in
				get) required_args+=("id") route+="/messages/${id}" ;;
				edit) required_args+=("id") method=PATCH; required_args+=("data") ;;
				delete) required_args+=("id") method=DELETE ;;
			esac
			;;
		*)
		error_trace "Invalid action: $1" "$@"

	esac
	is_empty "${required_args[@]}" && error_trace "$@" && return 1
	[[ "$data" ]] && args+=(--data "$data")
	if (( use_response )); then
        FictionResponseHeaders[content-type]="application/json"
        fiction.respond 200 "$data"
    else
		declare -gA InteractionCallback
        api_request "$route" "$method" "${args[@]}" -A InteractionCallback
    fi
	return $?
}