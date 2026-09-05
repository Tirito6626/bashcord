#!/bin/bash
_green=$'\e[38;5;2m'
_red=$'\e[38;5;1m'
_yellow=$'\e[38;5;3m'
_blue=$'\e[38;5;4m'
_white=$'\e[38;5;255m'
_bold=$'\e[1m'
_gray=$'\e[38;5;240m'
_nc=$'\e[0m'

__bc_tag_rest=$'\e[48;5;4m'" REST ${_nc}"
function to_hex {
    result=""
    hex="$1"
    for ((i=0; i<${#hex}; i+=2)); do
        result="${result}\\x${hex:i:2}"
    done
}


function _savePubKey {
    [ -z "$1" ] && return
    read uuid < /proc/sys/kernel/random/uuid
    mkdir -p "$tmp_path"

    #pub_key_base64=$(printf '%b' "$(sed 's/../\\x&/g' <<< "$1")" | base64 -w0)
    to_hex "$1"
    printf -v result '%b' "$result"
    pub_key_base64=$(base64 -w0 <<< "$result")
    cat > "${tmp_path}/key_${uuid}" << EOF
-----BEGIN PUBLIC KEY-----
MCowBQYDK2VwAyEA${pub_key_base64}
-----END PUBLIC KEY-----
EOF
    readonly __key="${tmp_path}/key_${uuid}"
}

function arg_parser {
	local arg=''
	key="" 
	value=""
	argkey="";
	for arg in "$@"; do
		if [[ "$argkey" ]]; then
			printf -v "${argkey}" "%s" "$arg"
			argkey=""
		fi

		case "$arg" in
			--*=*)
				IFS='=' read key value <<< "$arg"
				printf -v "${key##--}" "%s" "$value"
				;;
			--*)
				argkey="${arg##--}"
			;;
		esac
	done
	[[ "$required_args" ]] && \
		for arg in "${required_args[@]}"; do
			[[ -z "${!arg}" ]] && __error="'--${arg}' option missing" && return 1
		done
	return 0
}

# rest functions
function time_ms {
	ms="${EPOCHREALTIME//./}"
	ms="${ms::-3}"
}

function parse_sec {
	T="$1"
	local D=$((T/60/60/24))
	local H=$((T/60/60%24))
	local M=$((T/60%60))
	local S=$((T%60))
	local out=""
	(( D > 0 )) && { (( D > 1 )) && out+="$D days " || out+="$D day "; }
	(( H > 0 )) && { (( H > 1 )) && out+="$H hours " || out+="$H hour "; }
	(( M > 0 )) && { (( M > 1 )) && out+="$M minutes " || out+="$M minute "; }
	(( D > 0 || H > 0 || M > 0 && S > 0 )) && out+='and '
	(( S > 0 )) && { (( S > 1 )) && out+="$S seconds " || out+="$S second "; }
	[[ -z "$out" ]] && human_readable_time="${T:-0}s" || human_readable_time="${out::-1}"
}

function latency_api {
	echo "$request_time"
}

function process_uptime {
	local T=$(($(date +%s)-$(stat -c %Y /proc/$pid)))
	parse_sec "$T"
	echo "${human_readable_time}"
}


function error_trace {
	[[ "$__TAG" ]] && printf "%s " "$__TAG"
	[[ "$__error" ]] || { __error="$1"; shift; }
    echo $'\e[48;5;1m'"${_bold} ERROR ${_nc} ${_red}${__error}${_nc}" 
    pos="$1"
    shift
    local args=("${@@Q}");
    [ "$pos" -eq "$pos" ] 2>/dev/null && args[$pos]="${_red}${args[$pos]:-''}${_nc}"
    echo "${_gray}> ${FUNCNAME[1]}${_nc} ${args[@]}"
    printf "\n"
	if [[ "$SHOW_FULL_TRACE" != 1 ]]; then 
		echo "${_gray}function trace: (last 5)${_nc}"
		func_len="6"
	else
		echo "function trace:"
		func_len="${#FUNCNAME[@]}"
	fi
	local indent=''
    for ((i=1; func_len-i != 0; i++)); do
		idx=$((func_len-i))
		if [[ "${BASH_LINENO[idx+1]}" ]]; then 
			(( i != 1 )) && printf "%s↳ "  "${indent}" >&2
			echo "${_gray}${FUNCNAME[idx]}() at ${BASH_SOURCE[idx+1]}:${BASH_LINENO[idx+1]}${_nc}" >&2
			indent+='  '
		fi

	done
	event has error && case "$__TAG" in 
	"$__bc_tag_rest") 
		event emit error "$__error" "REST"
		;;
	*)
		event emit error "$__error"
	esac 
	unset __error 
    #echo "triggered by '${_nc}${FUNCNAME[1]}'"
	#return 1
}

declare -A status_code=(
	[101]="101 Switching Protocols"
	[200]="200 OK"
	[204]="204 No Content"
	[201]="201 Created"
	[301]="301 Moved Permanently"
	[302]="302 Found"
	[400]="400 Bad Request"
	[401]="401 Unauthorized"
	[403]="403 Forbidden"
	[404]="404 Not Found"
	[405]="405 Method Not Allowed"
	[418]="I'm a teapot"
	[429]="Too many requests"
	[500]="500 Internal Server Error"
	[503]="Bad gateway"
)

declare -gA Response
function api_request {
	local argscount=0 argtype=0
	local path="$1"
	#local method="$2"
	local outkeys=''
	local args=("$@")
	shift
	for arg in "$@"; do
		case "$arg" in
			-q|--query) argtype=0 ;;
			-d|--data) argtype=1 ;;
			-H|--header) argtype=2 ;;
            -A|--arr) argtype=3 ;;
			POST|PATCH|PUT|DELETE) method="$arg" ;;
		esac
		((++argscount))
		case "$argtype" in 
			0)
				IFS=':' read key value <<< "$arg"
				[[ "$argcount" > 1 ]] && outkeys+="&${key}=${value}" || outkeys+="?${key}=${value}"
				;;
			1)
				local body="$arg"
				;;
            3)
                local arr_name="$arg"
                ;;
		esac
	done
	#echo "[bashcord/http] $method $route" >&2
    time_ms
    _ms1="$ms"
    echo > "$CAPTURE_OUT_PATH"
	#set -x
	if [[ "${body::1}" ]]; then
		request_output="$(curl "https://discord.com/api/v${API_VERSION:-=10}${path}${outkeys}" \
			-H "Authorization: Bot ${__token}" \
			-H "Content-Type: application/json" \
			${method:+ -X "$method"} \
			-d "$body" \
            -w "%{stderr}%{response_code} %header{X-RateLimit-Limit} %header{X-RateLimit-Remaining}" \
			--silent \
			--show-error 2>"$CAPTURE_OUT_PATH"
            )"
	else
		request_output="$(curl "https://discord.com/api/v${API_VERSION:-=10}${path}${outkeys}" \
			-H "Authorization: Bot ${__token}" \
			-H "Content-Type: application/json" \
			${method:+ -X "$method"} \
            -w "%{stderr}%{response_code} %header{Retry-After} %header{X-RateLimit-Limit} %header{X-RateLimit-Remaining} " \
			--silent \
			--show-error 2>"$CAPTURE_OUT_PATH"
		)"
	fi
	read response_code ratelimit_reset_after ratelimit_total ratelimit_remaining < "$CAPTURE_OUT_PATH"
    #cat "$CAPTURE_OUT_PATH"
	if [[ "$response_code" == "curl:" ]]; then
		read error <"$CAPTURE_OUT_PATH"
		error_trace "$error" "" "" "${args[@]}" >&2
        return 1
	fi
    #echo "$response_code $ratelimit_total $ratelimit_remaining"
    time_ms
    request_time=$((ms - _ms1))
    echo "$request_time" > "$LOCATION/.latency"
    if (( ${response_code:=0} >= 400 )); then
        case "${response_code}" in
			429) 
				parse_sec "${ratelimit_reset_after}"
				__TAG="${__bc_tag_rest}" error_trace "Ratelimited. Try again in ${human_readable_time} ${_nc}" "" "" "${args[@]}" >&2 ;;
			*) 
				json_pretty "$request_output"
				__TAG="${__bc_tag_rest}" error_trace "HTTP ${status_code[$response_code]:-$response_code}${_nc} $json_pretty_output" "" "" "${args[@]}" >&2
        esac
        return 1
    else
		set +x
		json_to_arr "$request_output" "${arr_name:-Response}" "" false true true
        return 0
    fi
}
function is_empty {
	for arg in "$@"; do
		[[ -z "${!arg}" ]] && __error="'--${arg}' option missing" && return 0
	done
	return 1
}