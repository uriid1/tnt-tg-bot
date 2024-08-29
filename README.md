[Russian](README_RU.md) | English</br>

# Description
This small library helps to implement the basic logic for your bot.</br>
The library's logic is designed in such a way that any missing components can be easily implemented.</br>
In [main.lua](https://github.com/uriid1/tnt-tg-bot/blob/main/main.lua), you can explore some of the library's features.</br>
I hope you find it easy to understand ᓚ₍ ^. .^₎.

# Installation
### Clone this repository and navigate into it
```sh
git clone https://github.com/uriid1/tnt-tg-bot && cd tnt-tg-bot
```

#### Install the required dependencies
> [!NOTE]
> The `--optional` flag installs the module for pretty printing tables.</br>
> The `--http-patch` flag applies a patch to the HTTP module, which replaces the 500 error code with a 200 code.</br>
> This is useful for always responding to Telegram with a code indicating that your request was processed, even if it was processed incorrectly.
```sh
chmod +x install-dependencies.sh && sh install-dependencies.sh --optional
```

### Finally, you can start your bot
```sh
BOT_TOKEN=123456:AAAAABBBBCCCCDDDeeeFFFF tarantool main.lua
```

# Minimal Example
```lua
-- init.lua
local bot = require('core.bot')
bot:cfg {
  token = os.getenv('BOT_TOKEN'), -- Your bot token from @botfather
  parse_mode = 'HTML',            -- Text formatting mode
}

-- Event for receiving entities
bot.event.onGetEntities = function(message)
  local entities = message:getEntities()

  -- Trigger command if the entity is a bot command
  if entities[1] and entities[1].type == 'bot_command' then
    local command = bot.Command(message)
    if command then
      command(message)
    end
  end
end

-- /start command
bot.commands["/start"] = function(message)
  -- Send a text message
  bot:call('sendMessage', {
    text = 'Hello!',
    chat_id = message:getChatId(),
  })
end

bot:startLongPolling()
```

# Using WebHooks
### Example with a self-signed certificate
```lua
bot:startWebHook({
  -- Local server parameters
  port = 8081,
  host = '0.0.0.0',
  -- URL where Telegram will send messages to your server
  bot_url = 'https://123.123.123.124/my_bot_location',
  -- Путь до сертификата
  certificate = '/etc/path/to/ssl/public.pem',

  -- Optional parameters
  -- https://core.telegram.org/bots/api#setwebhook
  drop_pending_updates = true,
  allowed_updates = { "message", "my_chat_member", "callback_query" }
})
```

### If you have your own domain name
> !NOTE If your certificate is from a provider like Let's Encrypt, you don't need to specify the path to it.</br>
> Telegram will automatically handle retrieving the public certificate.
```lua
bot:startWebHook({
  port = 8081,
  host = '0.0.0.0',
  bot_url = 'https://mysite.ru/my_bot_location',
  drop_pending_updates = true,
  allowed_updates = { "message", "my_chat_member", "callback_query" }
})
```

# Configuration for nginx
Add a location block in the server section to allow nginx to proxy requests from Telegram to your bot.
```nginx
location /my_bot_location {
  proxy_set_header Host $http_host;
  proxy_redirect   off;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Scheme $scheme;
  proxy_pass       http://0.0.0.0:8081/;
}
```

# Preface
You may notice that some classes are independent of each other.</br>
For example, the core/classes/callback.lua class contains a message object and implements methods similar to those in core/classes/message.lua.</br>
The reason callback.lua doesn't create a message object from the message.lua class is for optimization.</br>
However, in the future, it may be necessary to implement dependencies between classes.</br>
From an architectural perspective, this would be the correct approach.
