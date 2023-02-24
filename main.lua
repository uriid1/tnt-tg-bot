-- Simple bot
--

-- Init bot core
local conf = require 'libs.ini'.loadParse("parameters.ini")
local bot = require 'core.bot'
            :setToken(conf.token)
bot.debug = false

-- Load all libs/extensions
local log = require 'log'
local dec = require 'extensions.html-decoration'

-- Command Example
bot.cmd["/start"] = function(user_id, arguments, message)
    local infoText = dec.bold('Bot Info:\n')

    local data = bot:call('getMe')
    if not data.ok then
        log.error(data)
        return
    end

    for k,v in pairs(data.result) do
        infoText = infoText .. ("%s: %s\n"):format(dec.mono(k), dec.bold(tostring(v)))
    end

    bot:call('sendMessage', {
        parse_mode = 'HTML';
        text = infoText;
        chat_id = message.chat.id;
    })
end


-- Event Example
bot.event.onGetMessageText = function(message)
    -- Send message
    bot:call('sendMessage', {
        parse_mode = 'HTML';
        text = dec.bold(message.text);
        chat_id = message.chat.id;
    })
end


-- Run bot
-- Enable long polling
bot:startLongPolling {
    token = bot.token
}

-- bot:startWebHook({
--     token = conf.token;
--     host = conf.host;
--     port = conf.port;
--     url = conf.url;
--     certificate = conf.certificate;
--     drop_pending_updates = true;
--     allowed_updates = '["message", "my_chat_member", "callback_query"]'
-- })
