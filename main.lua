--
-- Examples of how some methods and commands work
--

-- Init bot core
local bot = require 'core.bot'
:setOptions({
    token = os.getenv('BOT_TOKEN'); -- Your bot Token
    debug = true;                   -- This option enables debugging
    parse_mode = 'HTML';            -- Mode for parsing entities
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

local chat_member_status = require 'core.enums.chat_member_status'

-- Command /start
-- Method getMe
bot.cmd["/start"] = function(message)
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

-- Command /args_test
-- Paring argumnts
bot.cmd['/args_test'] = function(message)
    local args = message:getArguments({count=3})

    local arg1 = args[1]
    local arg2 = args[2] or 'nil'
    local arg3 = args[3] or 'nil'

    local text = 'arg1: ' .. arg1 .. '\n'
    .. 'arg2: ' .. arg2 .. '\n'
    .. 'arg3: ' .. arg3

    bot:call("sendMessage", {
        text = text;
        chat_id = message:getChatId() 
    })
end

-- Command /send_photo
-- Method sendPhoto
bot.cmd["/send_photo"] = function(message)
    bot:call('sendPhoto', {
        photo = InputFile('/path/to/image.png');
        caption = 'Omg! It\'s photo from disk!';
        chat_id = message:getChatId();
    })
end

-- Command /send_reply_buttons_1
-- Method sendMessage with reply_markup
bot.cmd["/send_reply_buttons_1"] = function(message)
    bot:call('sendMessage', {
        text = 'Reply keyboard buttons test 1';
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

-- Command /send_reply_buttons_2
-- Method sendMessage with reply_markup and keyboard buttons
bot.cmd["/send_reply_buttons_2"] = function(message)
    -- Another option for building buttons
    local keyboard = ReplyKeyboardMarkup({ one_time_keyboard = true })
    KeyboardButton(keyboard, { text = 'Button 1' })
    KeyboardButton(keyboard, { text = 'Button 2'; row = 2 })
    KeyboardButton(keyboard, { text = 'Button 3'; row = 2 })

    bot:call('sendMessage', {
        text = 'Reply keyboard buttons test 2';
        chat_id = message:getChatId();
        reply_markup = keyboard:toJson()
    })
end

-- Command send_inline_buttons_1
-- Method sendMessage with reply_markup
bot.cmd["/send_inline_buttons_1"] = function(message)
    bot:call('sendMessage', {
        text = 'Inline keyboard buttons test 1';
        chat_id = message:getChatId();
        reply_markup = InlineKeyboardMarkup({
            inline_keyboard = {
                { InlineKeyboardButton(nil, { text = 'Button 1',  callback_data = '/cb_close'; }) };
                { InlineKeyboardButton(nil, { text = 'Button 2',  callback_data = '/cb_close'; }) }
            }
        })
    })
end

-- Command send_inline_buttons_1
-- Method sendMessage with reply_markup and inline buttons
bot.cmd["/send_inline_buttons_2"] = function(message)
    -- Another option for building buttons
    local keyboard = InlineKeyboardMarkup()
    InlineKeyboardButton(keyboard, { text = 'Button 1',  callback_data = '/cb_close'; });
    InlineKeyboardButton(keyboard, { text = 'Button 2',  callback_data = '/cb_close'; row = 1 })

    bot:call('sendMessage', {
        text = 'Inline keyboard buttons test 2';
        chat_id = message:getChatId();
        reply_markup = keyboard:toJson()
    })
end

-- Command /send_media_group
-- Method sendMediaGroup
bot.cmd["/send_media_group"] = function(message)
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

-- Event of getting entities
bot.event.onGetEntities = function(message)
    local entities = message:getEntities()

    -- Call bot command
    if entities[1] and entities[1].type == 'bot_command' then
        bot.Command(message)
    end
end

-- Event of getting callbacks
bot.event.onCallbackQuery = function(callbackQuery)
    -- Callback processing
    bot.CallbackCommand(callbackQuery)
end

-- Event of getting any message
bot.event.onGetMessageText = function(message)
    -- Send message
    bot:call('sendMessage', {
        parse_mode = 'HTML';
        text = dec.bold(message:getText());
        chat_id = message:getChatId();
    })
end

-- Event of my chat member
bot.event.onMyChatMember = function(myChatMember)
    local status = myChatMember:getNewChatMemberStatus()
   
    if status == chat_member_status.MEMBER then
        local ufrom = myChatMember:getUserFrom()

        bot:call('sendMessage', {
            text = dec.user(ufrom) .. ' - Added me to this chat';
            chat_id = myChatMember:getChatId();
        })
    end
end

-- Run bot
-- Use long polling to develop
-- and webhook for release
--
-- Enable long polling
bot:startLongPolling()

-- Setup Web Hook
-- bot:startWebHook({
--     host = os.getenv('BOT_HOST');
--     port = os.getenv('BOT_PORT');
--     url = os.getenv('BOT_URL');
--     certificate = os.getenv('BOT_CERTIFICATE');
--     drop_pending_updates = true;
--     allowed_updates = '["message", "my_chat_member", "callback_query"]'
-- })
