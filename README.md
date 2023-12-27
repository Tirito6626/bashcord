![logo](https://cdn.discordapp.com/attachments/1129769809039609962/1139251618072772678/Polish_20230810_193803119.jpg)
# bashcord
 Unofficial discord API wrapper written in Bash

## Features:
- Lightweight
- Easy to use
- Use with any linux package
- Easy to install
- 2500+ lines of bash, few lines of JS
# Requirements
- [jq](https://jqlang.github.io/jq/download/)
- [nodejs](https://github.com/nodesource/distributions) 
- [bash](https://www.gnu.org/software/bash/)
- [curl](https://curl.se/download.html)
# Installation
To install code, run this:

```php
git clone https://github.com/Tirito6626/bashcord.git
```

Now, lets create `main.sh` file:
```bash
#!/usr/bin/bash
source /path/to/bashcord/src/bashcord
token="YOUR TOKEN HERE"
clientBuilder;
 addToken $token # adding token  
 addIntents <intents, e.g. 33280> # adding required intents so our bot receives all important messages
  
presenceBuilder;
 addStatus <status, e.g. "online"> # let us know that bot is online

 #lets create startup command!
 function startup {
  messageBuilder; # creating message object
      embedBuilder; # adding embed array
        addDescription "Im alive!" # adding description to embed
channel_message_send <put your channel id here> "$message_json" # sending our message object which is saved in $message_json
 }
onReady startup # letting bashcord now which function what function should be executed on startup
startClient # start client 
```

Note: if you want to run bashcord on Pterodactyl or on any environment, that doesn't have required tools, you should change these lines in `/src/bashcord`
```bash
jq_binary="/path/to/jq"
nodejs_binary="/path/to/node"
npm_binary="/path/to/npm"
```
Also, if you want to disable autoupdate on startup, set this:
```bash
autoupdate=false
```
If you want to disable output from API calls, set this:
```bash
f=false
```

Also check [bashcord discord server](https://dsc.gg/bashcord) for future updates
