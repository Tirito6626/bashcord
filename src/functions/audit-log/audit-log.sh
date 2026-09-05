function audit-log { 
local guild_id=${1}
local action_type=${2}
local before=${3}
local after=${4}
local limit=${5}
api_request "/guilds/${guild_id}/audit-logs" "GET" "action_type:$action_type" "before:$before" "after:$after" "limit:$limit"
}