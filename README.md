# tarantool-telegram-bot
Telegram Bot API for tarantool <br>
Beta version 0.1.0

# Usage example
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

*See main.lua for more examples 
