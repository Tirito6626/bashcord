
function sticker {
    arg_parser "$@"
	local route='' data="/stickers/${id}" required_args=('id') method='GET'
	is_empty "${required_args[@]}" || { error_trace "$@"; return 1; }
	api_request "$route" "$method"
	return $?
}

function sticker-packs {
    arg_parser "$@"
	local route='' data="/sticker-packs" required_args=() method='GET'
	#is_empty "${required_args[@]}" || { error_trace "$@"; return 1; }
	api_request "$route" "$method"
	return $?
}
