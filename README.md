# tarantool-telegram-bot
Telegram Bot API for tarantool <br>
Beta version 0.4.0

# Usage example
0. git clone https://github.com/uriid1/tarantool-telegram-bot
1. $ chmod +x installdep.sh <br>
2. $ ./installdep.sh <br>
3. Create <b>main.lua</b>:<br>

```lua
local bot = require 'core.bot'
:setOptions({
    token = os.getenv('BOT_TOKEN'); -- Your bot Token
    debug = true;                   -- This option enables debugging
    parse_mode = 'HTML';            -- Mode for parsing entities
})

-- Event of getting entities
bot.event.onGetEntities = function(message)
    local entities = message:getEntities()

    -- Call bot command
    if entities[1] and entities[1].type == 'bot_command' then
        bot.Command(message)
    end
end

-- Command /start Example
bot.cmd["/start"] = function(message)
    -- Send text message
    bot:call('sendMessage', {
        text = 'Hello!';
        chat_id = message:getChatId();
    })
end

bot:startLongPolling()
```
4. run tarantool main.lua<br>

*See main.lua for more examples

# WebHook
*Using self-signed certificates
```lua
bot:startWebHook({
    -- Server opts
    port = 8081;
    url = 'https://123.123.123.124/my_bot_location';
    certificate = '/etc/path/to/ssl/public.pem';
    -- path = '/path' -- Optional

    -- Optional webhook params
    -- https://core.telegram.org/bots/api#setwebhook
    drop_pending_updates = true;
    allowed_updates = '["message", "my_chat_member", "callback_query"]'
})
```

*Using NON self-signed certificates
```lua
bot:startWebHook({
    -- Server opts
    port = 8081;
    url = 'https://mycoolsite.com/my_bot_location';
    -- path = '/path' -- Optional

    -- Optional webhook params
    -- https://core.telegram.org/bots/api#setwebhook
    drop_pending_updates = true;
    allowed_updates = '["message", "my_chat_member", "callback_query"]'
})
```
