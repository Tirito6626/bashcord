const WebSocket = require('ws');
const client = process.argv[2];
const json = JSON.parse(client);
function Connect() {
	const ws = new WebSocket('wss://gateway.discord.gg/?v=10&encoding=json');
	let heartbeatInterval;
	let delay;
	let lastSeq;
    let seq;
	ws.on('open', () => {
		const payload = { op: 2, d: json };
		ws.send(JSON.stringify(payload));
		console.log(JSON.stringify(payload));
	});
	ws.on('pong', () => {
		lastSeq = seq;
		let endTime = new Date().getTime();
		delay = endTime - startTime;
	});
	ws.on('message', (message) => {
		startTime = new Date().getTime();
		const { d: data, t: event, op, s: seq } = JSON.parse(message);
		if (op !== 11) {
			ws.ping('ping');
		}
		console.log(
			JSON.stringify({ d: data, t: event, op: op, s: seq, p: delay })
		);
		switch (op) {
			case 10:
				heartbeatInterval = setInterval(() => {
					ws.send(
						JSON.stringify({
							op: 1,
							d: lastSeq || null,
						})
					);
				}, data.heartbeat_interval);
				break;
		}
	});

	ws.on('close', (code) => {
		clearInterval(heartbeatInterval);
		console.log(code);
		Connect();
	});
}
Connect();
