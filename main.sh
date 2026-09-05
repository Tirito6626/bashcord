__core="${1:-http}"
case "$core" in
	"http") : ;;
	"__hotreload") return ;;
esac
#LOCATION="${BASH_SOURCE##/main\.sh}"
[[ ! -v LOCATION ]] && LOCATION=$(realpath "${BASH_SOURCE[0]}")
LOCATION="${LOCATION/\/main\.sh}"
API_VERSION="10"
jq_binary="${LOCATION}/../deps/jq"
#websocat_binary="${LOCATION}/../deps/websocat"
#events_path="${LOCATION}/../modules/bashup.events"

for file in "$LOCATION"/src/functions/*.sh "$LOCATION"/src/builders/*.sh; do
	source "$file"
done

for file in "$LOCATION"/modules/*; do
	source "$file"
	echo "loaded $file"
done

source "$LOCATION/src/types.sh"
[[ $? > 0 ]] && echo "failed to load types file ($LOCATION/src/types.sh). cannot proceed"
source "$LOCATION/src/utils.sh"
[[ $? > 0 ]] && echo "failed to load utils file ($LOCATION/src/utils.sh). cannot proceed"
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM # make sure all child processes are killed on exit

tmp_path="/tmp/bashcord"
CAPTURE_OUT_PATH="$tmp_path/.out"

function capture_out() {
	local var="$1"
	#printf -v "$var" "$(${@:2})"
#  return
	${@:2} >"$CAPTURE_OUT_PATH"
	read -r -d $'\0' $var <"$CAPTURE_OUT_PATH"
}


function initialize {
case "$__core" in
	"http")
		source "${LOCATION}/fiction/fiction.so.sh" dev
		source "$LOCATION/src/core/http.sh"
		fiction.serve "/api/interactions" "handleEvent"
		fiction.server
esac
}