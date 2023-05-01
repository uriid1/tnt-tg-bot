-- Simple bot
--

-- Init bot core
local conf = require 'libs.ini'.loadParse("parameters.ini")
local bot = require 'core.bot'
            :setToken(conf.token)
bot.debug = true

-- Load all libs/extensions
local json = require 'json'
local log = require 'log'
local dec = require 'extensions.html-decoration'

-- Command /start Example
bot.cmd["/start"] = function(message)
    -- Получение аргументов команды
    local args = message:getArguments({count = 3})

    -- Получение информации о боте
    --
    local data = bot:call('getMe')

    if not data.ok then
        log.error(data)
        return
    end

    -- Создание текстовой информации о боте
    --
    local infoText = dec.bold('Bot Info:\n')

    for paramName, value in pairs(data.result) do
        paramName = dec.bold(paramName)
        value = dec.mono(value)

        infoText = infoText .. paramName .. ': ' .. value .. '\n'
    end

    -- Отправка результата
    bot:call('sendMessage', {
        parse_mode = 'HTML';
        text = infoText;
        chat_id = message:getChatId();
    })
end

-- Command /inline Example
bot.cmd["/inline"] = function(callback)
    local keyboard = bot:inlineKeyboardInit()
    bot:inlineCallbackButton(keyboard, {text = 'Кнопка 1', callback = '/cb_button_1', row = 1})
    bot:inlineCallbackButton(keyboard, {text = 'Кнопка 2', callback = '/cb_button_2', row = 2})
    bot:inlineCallbackButton(keyboard, {text = 'Кнопка 2', callback = '/cb_button_2', row = 3})

    -- Отправка результата
    bot:call('sendMessage', {
        parse_mode = 'HTML';
        text = 'Кнопки!';
        chat_id = callback:getChatId();
        reply_markup = json.encode(keyboard);
    })
end

bot.cmd["/cb_button_1"] = function(callback)
    bot:call('sendMessage', {
        parse_mode = 'HTML';
        text = 'Вы нажали кнопку 1';
        chat_id = callback:getChatId();
    })
end

bot.cmd["/cb_button_2"] = function(callback)
    bot:call('sendMessage', {
        parse_mode = 'HTML';
        text = 'Вы нажали кнопку 2';
        chat_id = callback:getChatId();
    })
end

bot.cmd["/cb_button_3"] = function(callback)
    bot:call('sendMessage', {
        parse_mode = 'HTML';
        text = 'Вы нажали кнопку 3';
        chat_id = callback:getChatId();
    })
end

-- Get commands
bot.event.onGetEntityBotCommand = function(message)
    -- Call command
    bot.Command(message)
end

-- Get callback
bot.event.onCallbackQuery = function(callbackQuery)
    -- log.error(callbackQuery)
    -- Call callback
    bot.CallbackCommand(callbackQuery)
end


-- Event Example
bot.event.onGetMessageText = function(message)
    -- Send message
    bot:call('sendMessage', {
        parse_mode = 'HTML';
        text = dec.bold(message:getText());
        chat_id = message:getChatId();
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
