-- Simple bot
-- Commands:
-- /start
-- /inline
--

-- Init bot core
local conf = require 'libs.lua-ini.ini'.loadParse("parameters.ini")
local bot = require 'core.bot'
:setOptions({
    token = os.getenv('BOT_TOKEN');
    debug = true;
})

-- Load all libs/extensions
local log = require 'log'
local dec = require 'extensions.html-decoration'

-- Command /start Example
bot.cmd["/start"] = function(message)
    -- Get command arguments
    local args = message:getArguments({count = 3})

    -- Get bot information
    local data = bot:call('getMe')

    if not data.ok then
        log.error(data)
        return
    end

    -- Creating textual information about the bot
    --
    local infoText = dec.bold('Bot Info:\n')

    for paramName, value in pairs(data.result) do
        paramName = dec.bold(paramName)
        value = dec.mono(value)

        infoText = infoText .. paramName .. ': ' .. value .. '\n'
    end

    -- Send text message
    bot:call('sendMessage', {
        text = infoText;
        chat_id = message:getChatId();
        parse_mode = 'HTML';
    })
end

-- Command /inline Example
bot.cmd["/inline"] = function(callback)
    local keyboard = bot:inlineKeyboardInit()
    bot:inlineCallbackButton(keyboard, {text = 'Button 1', callback = '/cb_button_1', row = 1})
    bot:inlineCallbackButton(keyboard, {text = 'Button 2', callback = '/cb_button_2', row = 2})
    bot:inlineCallbackButton(keyboard, {text = 'Button 2', callback = '/cb_button_2', row = 3})

    -- Send callback buttons
    bot:call('sendMessage', {
        text = 'Buttons!';
        parse_mode = 'HTML';
        chat_id = callback:getChatId();
        reply_markup = keyboard:toJson();
    })
end

-- Command /send_photo Example
-- bot.cmd["/send_photo"] = function(message)
--     bot:call('sendPhoto', {
--         photo = bot.Photo('image.png');
--         caption = 'Omg! It\'s photo';
--         chat_id = message:getChatId();
--     })
-- end

bot.cmd["/cb_button_1"] = function(callback)
    bot:call('sendMessage', {
        parse_mode = 'HTML';
        text = 'You press button 1';
        chat_id = callback:getChatId();
    })
end

bot.cmd["/cb_button_2"] = function(callback)
    bot:call('sendMessage', {
        parse_mode = 'HTML';
        text = 'You press button 2';
        chat_id = callback:getChatId();
    })
end

bot.cmd["/cb_button_3"] = function(callback)
    bot:call('sendMessage', {
        parse_mode = 'HTML';
        text = 'You press button 3';
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
bot:startLongPolling()

-- bot:startWebHook({
--     host = os.getenv('BOT_HOST');
--     port = os.getenv('BOT_PORT');
--     url = os.getenv('BOT_URL');
--     certificate = os.getenv('BOT_CERTIFICATE');
--     drop_pending_updates = true;
--     allowed_updates = '["message", "my_chat_member", "callback_query"]'
-- })
