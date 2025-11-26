# tnt-tg-bot

[Русский](README.md) | English

[![luacheck](https://github.com/uriid1/tnt-tg-bot/actions/workflows/luacheck.yml/badge.svg?branch=master)](https://github.com/uriid1/tnt-tg-bot/actions/workflows/luacheck.yml)
[![License](https://img.shields.io/badge/License-MIT-brightgreen.svg)](LICENSE)

## Description
`tnt-tg-bot` is a Lua library for the Tarantool platform providing an interface to the Telegram Bot API.

## Features
+ Simplicity and clarity of interfaces
+ Asynchronous request processing
+ Built-in support for Telegram Stars payments
+ Built-in methods for handling commands, including callbacks
+ Event naming is fully customizable — by default, only `bot.events.onGetUpdate(ctx)` is available
+ Straightforward integration with WebApp
+ LDoc support
+ Extensive collection of examples

## Installation

### Automatic
1. Install `git`, `curl`, `lua 5.1`, and `luarocks`.
2. (optional) For WebApp support:</br>
   Install the `luaossl` rock. To build it, your distribution must include development headers for `lua 5.1` and `openssl`.
3. Install [tarantool](https://www.tarantool.io/en/download/os-installation)
4. Run the automatic setup script:
```bash
bash tnt-tg-bot.pre-build.sh
```
5. If any issue occurs, switch to manual installation.

> [!NOTE]
> Successful `luaossl` build (OpenSSL binding) requires development headers for both OpenSSL and Lua 5.1.
> On Ubuntu, install them via:
> ```bash
> sudo apt install libssl-dev liblua5.1-0-dev
> ```
> `luaossl` is required for the `bot/libs/parseInitData.lua` module, used to handle data from Telegram Mini Apps.
> https://core.telegram.org/bots/webapps#validating-data-received-via-the-mini-app

### Manual
1. Install `git`, `curl`, `lua 5.1`, and `luarocks`.
2. Install [tarantool](https://www.tarantool.io/en/download/os-installation)
3. (optional) For WebApp support:</br>
   Install the `luaossl` rock. To build it, your distribution must include development headers for `lua 5.1` and `openssl`.
4. Install required packages using `luarocks`:
   + **HTTP client/server (required)**
     ```bash
     luarocks install --local --tree=$PWD/.rocks --server=https://rocks.tarantool.org/ http
     ```
   + **Multipart Post handler (required)**
     ```bash
     luarocks install --local --tree=$PWD/.rocks --lua-version 5.1 lua-multipart-post 1.0-0
     ```
   + **OpenSSL binding (optional)**
     ```bash
     luarocks install --local --tree=$PWD/.rocks --lua-version 5.1 luaossl
     ```

## Examples
+ [Mini Shop](examples/mini-shop) — minimal example showing recommended project structure  
+ [Star payments](examples/stars-payment) — example of handling Telegram Stars payments (purchase, refund)  
+ `examples/echo-bot-webhook.lua` — Echo bot using WebHook  
+ `examples/echo-bot.lua` — Echo bot (legacy API)  
+ `examples/echo-bot-2.lua` — Echo bot (new API)  
+ `examples/ping-pong.lua` — `/ping` command handler  
+ `examples/send-animation.lua` — Send GIF via `/get_animation` command  
+ `examples/send-document.lua` — Send document via `/get_document` command  
+ `examples/send-image.lua` — Send image via `/get_image` command  
+ `examples/send-image-2.lua` — Simplified image sending example using `bot.sendImage`  
+ `examples/send-media-group.lua` — Send media group  
+ `examples/simple-callback.lua` — Basic callback handling (legacy API)  
+ `examples/simple-callback-2.lua` — Simplified callback command handler (new API)  
+ `examples/simple-process-commands.lua` — Simple command processing example  
+ `examples/routes-example/init.lua` — Example of route handling in the bot

> [!NOTE]
> It is recommended to use only the new API.

### Running examples
`BOT_TOKEN` — your bot’s token:
```bash
BOT_TOKEN="1348551682:AAFK3iZwBqEHwSrPKyi-hKyAtRgUwXrTiWW" tarantool examples/echo-bot.lua
```

## Project structure
+ `bot/init.lua` — entry point  
+ `bot/libs` — helper libraries  
+ `bot/enums` — enums  
+ `bot/classes` — Telegram object classes  
+ `bot/middlewares` — middlewares  
+ `bot/processes` — process modules (e.g. `processCommand` — command processor)  
+ `bot/types` — type models/validators for Telegram objects  
+ `bot/ext` — built-in extensions  

## Library Interface

| Method | Description | Example |
|---------------|-------------|----------|
| bot:cfg | Configuration initialization | `bot:cfg { token = "123468:foobarBAZ" }` |
| bot.call | Perform request to Telegram API | `bot.call('sendMessage', {chat_id = 123, text = 'Hello!'})` |
| bot.events | Table of user-defined events | `function bot.events.onPoll(ctx) ... end` |
| bot.events.onGetUpdate | Update handling event | `function bot.events.onGetUpdate(ctx) ... end` |
| bot.sendImage | Simplified image sending | `examples/send-image-2.lua` |
| bot.Command | Minimal command handler | `bot.Command(ctx)` |
| bot.CallbackCommand | Minimal callback command handler | `bot.CallbackCommand(ctx)` |
| bot:startWebHook | Run bot in WebHook mode | See `examples/echo-bot-webhook.lua` |
| bot:startLongPolling | Run bot in long polling mode | Any example from `examples/*` |
| bot:debugRoutes | Debug route handlers in longPolling mode | |

For argument details, see LDoc — `doc/index.html`.

## Library documentation generate
```bash
bash scripts/ldoc
```

## Contributing
Contributions via repository fork and Pull Requests are welcome.
