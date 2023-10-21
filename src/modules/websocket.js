const WebSocket = require("ws");
const client = require("/etc/bashcord/config.json")
const ws = new WebSocket('wss://gateway.discord.gg/?v=10&encoding=json');
let heartbeatInterval;

let lastSeq;
function Connect() {
ws.on('open', () => {
    const payload = { op: 2, d: client }
    ws.send(JSON.stringify(payload));
    console.log(JSON.stringify(payload));
});

ws.on('message', message => {

    const { d: data, t: event, op, s: seq } = JSON.parse(message);
    
    lastSeq = seq;
console.log(JSON.stringify({ d: data, t: event, op: op, s: seq}))
    switch (op) {

        case 10:

            heartbeatInterval = setInterval(() => {

                ws.send(JSON.stringify({

                    op: 1,

                    d: lastSeq || null

                }));

            }, data.heartbeat_interval);

            break;

    }
});

ws.on('close', code => {

    clearInterval(heartbeatInterval);

    console.log(code);
    Connect();

});
}
Connect();
