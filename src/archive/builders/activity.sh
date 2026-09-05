function activitiesBuilder {
client_json=$(echo "$client_json" | ${jq_binary} '.presence += { "activities": [{}] }')
}
function addActivityName {
[ ! -z "${1}" ] && arg="${1}" || error "$FUNCNAME: Value expected"
client_json=$(echo "$client_json" | ${jq_binary} '.presence.activities[] += { "name":"'"$arg"'" }')
}
function addActivityType {
[ ! -z "${1}" ] && arg="${activity_types[${1}]}" || error "$FUNCNAME: Value expected"
client_json=$(echo "$client_json" | ${jq_binary} '.presence.activities[] += { "type":'"${arg:=0}"' }')
}
function addActivityEmoji {
  emoji=${1}
   if [ "$(IFS=':'; read -ra output <<< "$emoji"; echo "${#output[@]}")" -lt 2 ]; then
  error "$FUNCNAME: Invalid emoji: expected at least name and ID"
  else
  emoji=$(echo -n $emoji | ${jq_binary} -R 'split(":") | { name: .[0], id: .[1]|tonumber, animated: .[2] } | if .animated == null then .animated=false else .animated=(.animated|test("true")) end' )
  fi
client_json=$( echo "$client_json" | ${jq_binary} '.presence.activities[] += { "emoji": '"$emoji"' }')
}
function addActivityStreamURL {
[ ! -z "${1}" ] && {
  if [[ "${1}" != "https://twitch.tv" && "${1}" != "https://youtube.com" ]] 
  then
  arg="${activity_types[${1}]}" 
  else 
  error "$FUNCNAME: Only https://twitch.tv/ and https://youtube.com/ are supported"
  fi;
  } || error "$FUNCNAME: Value expected"
client_json=$(echo "$client_json" | ${jq_binary} '.presence.activities[] += { "url":"'"$arg"'" }')
}
function addActivityCreatedAt {
local arg=$([ ! -z "${1}" ] && echo "${1}" || error "$FUNCNAME: Value expected")
client_json=$(echo "$client_json" | ${jq_binary} '.presence.activities[] += { "created_at":'"$arg"' }')
}
function addActivityTimestamps {
local arg=$([ ! -z "${1}" ] && echo "${1}" ||  [ ! -z "${2}" ] || error "$FUNCNAME: At least one value expected")
local arg2=${1}
if [ -z "$arg2" ]; then
client_json=$(echo "$client_json" | ${jq_binary} '.presence.activities[] += { "timestamps": { "start": '"$arg"' } }')
elif [ -z "$arg" ]; then
client_json=$(echo "$client_json" | ${jq_binary} '.presence.activities[] += { "timestamps": { "end": '"$arg2"'} }')
else
client_json=$(echo "$client_json" | ${jq_binary} '.presence.activities[] += { "timestamps": { "start": '"$arg"', "end": '"$arg2"'} }')
fi
}
function addActivityApplicationID {
local arg=$([ ! -z "${1}" ] && echo "${1}" || error "$FUNCNAME: Value expected")
client_json=$(echo "$client_json" | ${jq_binary} '.presence.activities[] += { "application_id":'"$arg"' }')
}
