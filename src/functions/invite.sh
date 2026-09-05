function invite {
    arg_parser "$@"
	local route='' data="/invites/${code}" required_args='code' method='GET'
	case "$1" in
		delete) method=DELETE ;;
	esac
	is_empty "${required_args[@]}" || { error_trace "$@"; return 1; }
	api_request "$route" "$method"
	return $?
}