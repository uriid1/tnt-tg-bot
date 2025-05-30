English | [Russian](README.md)

[![luacheck](https://github.com/uriid1/tnt-tg-bot/actions/workflows/luacheck.yml/badge.svg?branch=master)](https://github.com/uriid1/tnt-tg-bot/actions/workflows/luacheck.yml)
[![License](https://img.shields.io/badge/License-MIT-brightgreen.svg)](LICENSE)

## Description
tnt-tg-bot is a library written in Lua for the Tarantool platform that provides a minimalist interface for working with the Telegram Bot API.

## Features
  + Nearly complete support for Telegram Bot API
  + Simple interface
  + Asynchronous request processing
  + Built-in support for Telegram Stars payments
  + Built-in methods for easy command handling, including callbacks
  + You name your own events, with only `bot.events.onGetUpdate(ctx)` available out of the box
  + Easy Web App integration
  + LDoc support
  + More than 10 examples with more to come
  + Easy integration with Tarantool

Due to the simple and clear architecture, adding missing functionality is straightforward.

## Installation

### Automated Installation
1. Install `git`, `curl`, `lua 5.1` and `luarocks`.
2. (Optional) If Web App support is needed: </br>
    You’ll need the `luaossl` rock package. </br>
    To build it, install development headers for `lua 5.1` and `openssl` from your distribution.
2. Install [tarantool](https://www.tarantool.io/en/download/os-installation)
3. Run the automatic setup script
```bash
bash tnt-tg-bot.pre-build.sh
```
5. If issues occur, proceed with the manual installation.

> [!NOTE]
> To successfully build luaossl (OpenSSL bindings), development headers for `OpenSSL` and `Lua 5.1` are required. </br>
> On Ubuntu, install them with: `sudo apt install libssl-dev liblua5.1-0-dev` </br>
> luaossl is required by the module bot/libs/parseInitData.lua, which handles Telegram Mini App initialization data.
> https://core.telegram.org/bots/webapps#validating-data-received-via-the-mini-app

### Manual Installationc
1. Install `git`, `curl`, `lua 5.1` and `luarocks`.
2. Install [tarantool](https://www.tarantool.io/en/download/os-installation)
3. (Optional) If Web App support is needed: </br>
    You’ll need the `luaossl` rock package. </br>
    To build it, install development headers for `lua 5.1` and `openssl` from your distribution.
4. Install required packages via `luarocks`
  + **HTTP client/server (required)**
    ```bash
    luarocks install --local --tree=$PWD/.rocks --server=https://rocks.tarantool.org/ http
    ```
  + **Multipart Post обработчик (required)**
    ```bash
    luarocks install --local --tree=$PWD/.rocks --lua-version 5.1 lua-multipart-post 1.0-0
    ```
  + **OpenSSL bindings (optional)**
    ```bash
    luarocks install --local --tree=$PWD/.rocks --lua-version 5.1 luaossl
    ```

## Examples
  + `examples/echo-bot.lua` - Simple echo bot
  + `examples/ping-pong.lua` - Response to /ping command
  + `examples/send-animation.lua` - Sending a gif via /get_animation command
  + `examples/send-document.lua` - Sending a document via /get_document command
  + `examples/send-image.lua` - Sending an image via /get_image command
  + `examples/send-image-2.lua` - Simplified example of sending an image using `bot.sendImage`
  + `examples/send-media-group.lua` - Sending a media group
  + `examples/simple-callback.lua` - Example of callback handling - /send_callback
  + `examples/simple-callback-2.lua` - Simplified example of callback command handling
  + `examples/simple-process-commands.lua` - Example of simple command processing
  + `examples/routes-example/init.lua` - Example of bot handlers
  + `examples/stars-payment/init.lua` - Example of handling payments in stars

### Running an example
`BOT_TOKEN` - your bot token
```bash
BOT_TOKEN="1348551682:AAFK3iZwBqEHwSrPKyi-hKyAtRgUwXrTiWW" tarantool examples/echo-bot.lua
```

## Project Structure
  + `bot/init.lua` - Entry point
  + `bot/libs` - Helper libraries
  + `bot/enums` - Enums
  + `bot/classes` - Classes for Telegram objects
  + `bot/middlewares` - Middlewares
  + `bot/processes` - Processes. Example: processCommand - command processing
  + `bot/types` - Models/validators for Telegram types
  + `bot/ext` - Built-in extensions

## Library Interface

| Method/Property | Description | Usage Example |
|---------------|---------|---------------------|
| bot:cfg | Initialize settings | `bot:cfg { token = "123468:foobarBAZ" }` |
| bot.call | Execute request to Telegram API | `bot.call('sendMessage', {chat_id = 123, text = 'Hello!'})` |
| bot.events | Table with custom events | `function bot.events.onPoll(ctx) ... end` |
| bot.events.onGetUpdate | Event for processing updates from Telegram | `function bot.events.onGetUpdate(ctx) ... end` |
| bot.sendImage | Simplified image sending | `examples/send-image-2.lua`  |
| bot.Command | Minimal command handler | `bot.Command(ctx)` |
| bot.CallbackCommand | Minimal callback command handler | `bot.CallbackCommand(ctx)`
| bot:startWebHook | Start bot on remote server | Example `examples/echo-bot-webhook.lua` |
| bot:startLongPolling | Start bot in long polling mode | Any example from `examples/*` |

For argument details, see ldoc - `doc/index.html`

## Contributing
Through repository fork and Pull Request
