payload="$1"
#set -x  
LOCATION=$(echo $0 | sed 's|modules/websocket\.sh$||g')
websocat_binary="${LOCATION}deps/websocat"
jq_binary="${LOCATION}deps/jq"
fd="./bashcord/src/fd"
#rm -f pablo pablo2 && mkfifo pablo && mkfifo pablo2
#exec 3<>$fd
start=true
heartbeat() {
 # export func_pid=$$; 
 sleep 3
 while true; do 
 echo '{ "op": 1, "d": null }' >&"${WEBSOCKET[1]}"
 # >$fd
 sleep 42
 done 
}
IFS=$'\n'
function start {
heartbeat_pid=""
while true; do
start=true
coproc WEBSOCKET { ${websocat_binary} --no-close "wss://gateway.discord.gg/?v=10&encoding=json"; }
echo "$payload" >&"${WEBSOCKET[1]}"
    if [ -z "$heartbeat_pid" ]; then
     coproc heartbeat { heartbeat; } 
     heartbeat_pid=$heartbeat_PID
     fi
websocket_pid=${WEBSOCKET_PID}
 #cat $fd - | ${websocat_binary} --no-close "wss://gateway.discord.gg/?v=10&encoding=json" | while read -r line; do
 while read line <&"${WEBSOCKET[0]}"; do
    opcode=$(echo "$line" | ${jq_binary} -r '.op')
    event=$(echo "$line" | ${jq_binary} -r '.t')
    echo "$line"
    
    if [[ "$opcode" -eq 7 ]]; then
      kill $heartbeat_pid $websocket_pid 
      break
    fi
  #  if "$start"; then
    #  func_pid=$!
   #   echo "$payload" >&"${WEBSOCKET[1]}"
      #>> $fd
    #  start=false
  #  fi
  done
 heartbeat_pid=""
 websocket_pid=""
  echo "$(date) Restarting the loop..."
done

}
start
function kill_coproc {  
  kill $func_pid $websocket_pid
}
trap kill_coproc EXIT