-- Simple bot
-- Commands:
-- /start
-- /inline
--

-- Init bot core
local bot = require 'core.bot'
:setOptions({
    token = os.getenv('BOT_TOKEN');
    debug = true;
    parse_mode = 'HTML';
})

-- Load all libs/extensions
local log = require 'log'
local dec = require 'extensions.html-decoration'

local InputFile = require 'core.types.InputFile'
local InputMedia = require 'core.types.InputMedia'
local InputMediaPhoto = require 'core.types.InputMediaPhoto'

local InlineKeyboardMarkup = require 'core.types.InlineKeyboardMarkup'
local InlineKeyboardButton = require 'core.types.InlineKeyboardButton'

local ReplyKeyboardMarkup = require 'core.types.ReplyKeyboardMarkup'
local KeyboardButton = require 'core.types.KeyboardButton'

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
    })
end

-- Command /send_photo Example
-- bot.cmd["/send_photo"] = function(message)
--     bot:call('sendPhoto', {
--         photo = bot.inputFile('image.png');
--         caption = 'Omg! It\'s photo';
--         chat_id = message:getChatId();
--     })
-- end


bot.cmd["/send_reply_buttons_1"] = function(message)
    bot:call('sendMessage', {
        text = 'Тест кнопок';
        chat_id = message:getChatId();
        reply_markup = ReplyKeyboardMarkup({
            keyboard = {
                { KeyboardButton(nil, { text = 'Button 1' }), KeyboardButton(nil, { text = 'Button 2' }) };
                { KeyboardButton(nil, { text = 'Button 3' }) };
            };

            one_time_keyboard = true
        });
    })
end

bot.cmd["/send_reply_buttons_2"] = function(message)
    local keyboard = ReplyKeyboardMarkup({ one_time_keyboard = true })
    KeyboardButton(keyboard, { text = 'Button 1' })
    KeyboardButton(keyboard, { text = 'Button 2'; row = 2 })
    KeyboardButton(keyboard, { text = 'Button 3'; row = 2 })

    bot:call('sendMessage', {
        text = 'Тест кнопок';
        chat_id = message:getChatId();
        reply_markup = keyboard:toJson()
    })
end


-- Тест отправки inline кнопок
bot.cmd["/send_inline_buttons_1"] = function(message)
    bot:call('sendMessage', {
        text = 'Тест кнопок';
        chat_id = message:getChatId();
        reply_markup = InlineKeyboardMarkup({
            inline_keyboard = {
                { InlineKeyboardButton(nil, { text = 'Button 1',  callback_data = '/cb_close'; }) };
                { InlineKeyboardButton(nil, { text = 'Button 2',  callback_data = '/cb_close'; }) }
            }
        })
    })
end

bot.cmd["/send_inline_buttons_2"] = function(message)
    local keyboard = InlineKeyboardMarkup()
    InlineKeyboardButton(keyboard, { text = 'Button 1',  callback_data = '/cb_close'; });
    InlineKeyboardButton(keyboard, { text = 'Button 2',  callback_data = '/cb_close'; row = 1 })

    bot:call('sendMessage', {
        text = 'Тест кнопок';
        chat_id = message:getChatId();
        reply_markup = keyboard:toJson()
    })
end

bot.cmd["/send_media"] = function(message)
    local data = InputMedia({
        InputMediaPhoto({
            media = 'AgACAgIAAxkDAAIJ52RX2qzt6oCMY5P9Ge9uVuZgTDH_AAL-yTEb9gABuEp-yXhmUY3rfAEAAwIAA3MAAy8E';
            caption = 'Photo with file_id'
        });
        InputMediaPhoto({
            media = 'attach://'..'image.png';
            caption = 'Photo with disk'
        });
        InputMediaPhoto({
            media = 'https://raw.githubusercontent.com/uriid1/scrfmp/main/AppleWar/lvl5.png';
            caption = 'Photo with url'
        });
    });

    bot:call('sendMediaGroup', data, {
        chat_id = message:getChatId()
    })
end

-- Get Entities
bot.event.onGetEntities = function(message)
    local entities = message:getEntities()

    -- Call command
    if entities[1] and entities[1].type == 'bot_command' then
        bot.Command(message)
    end
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
