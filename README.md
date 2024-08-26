# Description
This library is being developed with the needs of my Telegram bots in mind. Therefore, some parts of the "Telegram bot API types" are missing, but they can be easily implemented, as the main part of everything necessary is ready.
I wrote main.lua, which turned out to be quite mixed in terms of logic. Hopefully, it won't be too difficult to figure it out.

In my experience, this library is much simpler than similar ones written in Python, Node.js, Go.

# Usage example
```sh
$ git clone https://github.com/uriid1/tarantool-telegram-bot
$ chmod +x install-dependencies.sh
$ sh install-dependencies.sh -o
$ BOT_TOKEN=123456:AAAAABBBBCCCCDDDeeeFFFF tarantool main.lua
```
See main.lua for more examples

# Minimal Example
```lua
-- init.lua
local bot = require('core.bot')
bot:cfg {
  token = os.getenv('BOT_TOKEN'), -- Your bot Token
  parse_mode = 'HTML',            -- Mode for parsing entities
}

-- Event of getting entities
bot.event.onGetEntities = function(message)
  local entities = message:getEntities()

  -- Call bot command
  if entities[1] and entities[1].type == 'bot_command' then
    local command = bot.Command(message)
    if command then
      command(message)
    end
  end
end

-- Command /start Example
bot.commands["/start"] = function(message)
  -- Send text message
  bot:call('sendMessage', {
    text = 'Hello!',
    chat_id = message:getChatId(),
  })
end

bot:startLongPolling()
```

# Usage of Webhooks
*Using self-signed certificates
```lua
bot:startWebHook({
  -- Server opts
  port = 8081,
  host = '0.0.0.0',
  -- Bot opts
  bot_url = 'https://123.123.123.124/my_bot_location',
  certificate = '/etc/path/to/ssl/public.pem',

  -- Optional webhook params
  -- https://core.telegram.org/bots/api#setwebhook
  drop_pending_updates = true,
  allowed_updates = { "message", "my_chat_member", "callback_query" }
})
```

*Using NON self-signed certificates
```lua
bot:startWebHook({
  -- Server opts
  port = 8081,
  host = '0.0.0.0',
  -- Bot opts
  bot_url = 'https://123.123.123.124/my_bot_location',
  certificate = '/etc/path/to/ssl/public.pem',

  -- Optional webhook params
  -- https://core.telegram.org/bots/api#setwebhook
  drop_pending_updates = true,
  allowed_updates = { "message", "my_chat_member", "callback_query" }
})
```
