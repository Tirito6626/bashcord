![logo](https://cdn.discordapp.com/attachments/1129769809039609962/1139251618072772678/Polish_20230810_193803119.jpg)
# bashcord
 Unofficial discord API wrapper written in Bash

## Features:
- Lightweight
- Easy to use
- Use with any linux package
- Easy to install
- 2000 lines of bash, few lines of JS
# Requirements
[jq](https://jqlang.github.io/jq/download/)
[nodejs](https://github.com/nodesource/distributions) 
bash
# Installation
To install code, run this:
```php
git clone https://raw.githubusercontent.com/Tirito6626/bashcord.git

```
To use it, add this to your code:
```bash
source /path/to/bashcord/src/bashcord
token="YOUR TOKEN HERE"
clientBuilder;
 addToken $token
 addIntents <intents, e.g. 33280>
 
presenceBuilder;
 addStatus <status, e.g. online>
```
And here you go! You can test it by typing `guild` in VScode and you should see something like this:

![image](https://github.com/Tirito6626/bashcord/assets/99983969/3a37ddae-7597-47ae-a2c9-3e94307ddb52)
Note: if you want to run bashcord on Pterodactyl, you should change these lines in `/src/bashcord`
```bash
jq_binary="/path/to/jq"
nodejs_binary="/path/to/node"
npm_binary="/path/to/npm"
```
Also, if you want to disable autoupdate on startup, change this:
```bash
autoupdate=false
```
Also check [bashcord discord server](https://dsc.gg/bashcord) for future updates
