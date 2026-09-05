function user {
	#local type="${interaction_types[${1}]:-$1}"
	arg_parser "$@"
	local route="/users/${id}" required_args='id' method='GET'
	is_empty "${required_args[@]}" || { error_trace "$@"; return 1; }
	api_request "$route" "$method" -A User
	return $?
}