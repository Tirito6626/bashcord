function clientBuilder {
client_json='{}'
client_json=$(echo "$client_json" | ${jq_binary} '. += { "properties": { "os": "linux", "browser": "bashcord", "device": "bashcord" }  }')
}
function addReactOnBots {
[ ! -z "${1}" ] && respondOnBots=${1} || warn "$FUNCNAME: No value provided, using default (false)"
}
function addToken {
token=${1}
client_json=$(echo "$client_json" | ${jq_binary} '. += { "token": "'"$token"'" }')
}
function addIntents {
local clientintents=0
for intent in ${@}; do 
case $intent in 
[0-9]*)
clientintents=$intent
;;
*)
[ -z "${intents[$intent]}" ] && error "$FUNCNAME: Invalid intent: $intent"
clientintents=$((${clientintents}+${intents[$intent]}))
;;
esac 
done 
client_json=$(echo "$client_json" | ${jq_binary} '. += { "intents": '"$clientintents"' }')
}
function addShards {
local shard_id=${1}
local shard_count=${2}
client_json=$(echo "$client_json" | ${jq_binary} '. += { "shard": ['"$shard_id"','"$shard_count"'] }')
}

function presenceBuilder {
client_json=$(echo "$client_json" | ${jq_binary} '. += { "presence": {} }')
}
function addStatus {
local arg=$([ ! -z "${1}" ] && echo "${1}" || error "$FUNCNAME: Value expected")
client_json=$(echo "$client_json" | ${jq_binary} '.presence += { "status": "'"$arg"'" }')
} 
function addSince {
local arg=$([ ! -z "${1}" ] && echo "${1}" || error "$FUNCNAME: Value expected")
client_json=$(echo "$client_json" | ${jq_binary} '.presence += { "since": '"$arg"' }')
}
function addAFK {
local arg=$([ ! -z "${1}" ] && echo "${1}" || error "$FUNCNAME: Value expected")
client_json=$(echo "$client_json" | ${jq_binary} '.presence += { "afk": '"$arg"' }')
}