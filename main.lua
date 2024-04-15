--
-- Examples of how some methods and commands work
--
local log = require('log')
local bot = require('core.bot')
local parse_mode = require('core.enums.parse_mode')

-- Setup
bot:cfg {
  token = os.getenv('BOT_TOKEN'), -- Your bot Token
  parse_mode = parse_mode.HTML,   -- Mode for parsing entities
}

-- Load all libs/extensions
local dec = require('core.extensions.html_formatter')

local InputFile = require('core.types.InputFile')
local InputMedia = require('core.types.InputMedia')
local InputMediaPhoto = require('core.types.InputMediaPhoto')

local InlineKeyboardMarkup = require('core.types.InlineKeyboardMarkup')
local InlineKeyboardButton = require('core.types.InlineKeyboardButton')

local ReplyKeyboardMarkup = require('core.types.ReplyKeyboardMarkup')
local KeyboardButton = require('core.types.KeyboardButton')

local chat_member_status = require('core.enums.chat_member_status')

-- Command /start
-- Method getMe
bot.commands["/start"] = function(message)
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
    value = dec.monospaced(value)

    infoText = infoText .. paramName .. ': ' .. value .. '\n'
  end

  -- Send text message
  bot:call('sendMessage', {
    text = infoText,
    chat_id = message:getChatId(),
  })
end

-- Command /args_test
-- Paring argumnts
bot.commands['/args_test'] = function(message)
  local args = message:getArguments({count=3})

  local command_name = args[1]
  local arg2 = args[2] or 'nil'
  local arg3 = args[3] or 'nil'

  local text_fmt = "Command: %s\n arg2: %s\n arg3: %s\n"
  local text = text_fmt:format(command_name, arg2, arg3)

  bot:call("sendMessage", {
    text = text,
    chat_id = message:getChatId(),
  })
end

-- Close all callback command
bot.commands['/cb_close'] = function(callback)
  -- Delete message
  bot:call('deleteMessage', {
    chat_id = callback:getChatId(),
    message_id = callback:getMessageId(),
  })
end

-- Command /send_photo
-- Method sendPhoto
bot.commands["/send_photo"] = function(message)
  local result = bot:call('sendPhoto', {
    photo = InputFile('image.jpg'),
    caption = 'Omg! It\'s photo from disk!',
    chat_id = message:getChatId(),
  })

  log.info(result)
end

-- Command /send_reply_buttons_1
-- Method sendMessage with reply_markup
bot.commands["/send_reply_buttons_1"] = function(message)
  bot:call('sendMessage', {
    text = 'Reply keyboard buttons test 1',
    chat_id = message:getChatId(),
    reply_markup = ReplyKeyboardMarkup({
      keyboard = {
        { KeyboardButton(nil, { text = 'Button 1' }), KeyboardButton(nil, { text = 'Button 2' }) },
        { KeyboardButton(nil, { text = 'Button 3' }) },
      },

      one_time_keyboard = true,
    })
  })
end

-- Command /send_reply_buttons_2
-- Method sendMessage with reply_markup and keyboard buttons
bot.commands["/send_reply_buttons_2"] = function(message)
  -- Another option for building buttons
  local keyboard = ReplyKeyboardMarkup({ one_time_keyboard = true })
  KeyboardButton(keyboard, { text = 'Button 1' })
  KeyboardButton(keyboard, { text = 'Button 2', row = 2 })
  KeyboardButton(keyboard, { text = 'Button 3', row = 2 })

  bot:call('sendMessage', {
    text = 'Reply keyboard buttons test 2',
    chat_id = message:getChatId(),
    reply_markup = keyboard:toJson(),
  })
end

-- Command send_inline_buttons_1
-- Method sendMessage with reply_markup
bot.commands["/send_inline_buttons_1"] = function(message)
  bot:call('sendMessage', {
    text = 'Inline keyboard buttons test 1',
    chat_id = message:getChatId(),
    reply_markup = InlineKeyboardMarkup({
      inline_keyboard = {
        { InlineKeyboardButton(nil, { text = 'Button 1',  callback_data = '/cb_close' }) },
        { InlineKeyboardButton(nil, { text = 'Button 2',  callback_data = '/cb_close' }) }
      }
    })
  })
end

-- Command send_inline_buttons_1
-- Method sendMessage with reply_markup and inline buttons
bot.commands["/send_inline_buttons_2"] = function(message)
  -- Another option for building buttons
  local keyboard = InlineKeyboardMarkup()
  InlineKeyboardButton(keyboard, { text = 'Button 1',  callback_data = '/cb_close' })
  InlineKeyboardButton(keyboard, { text = 'Button 2',  callback_data = '/cb_close', row = 1 })

  bot:call('sendMessage', {
    text = 'Inline keyboard buttons test 2',
    chat_id = message:getChatId(),
    reply_markup = keyboard:toJson(),
  })
end

-- Command /send_media_group
-- Method sendMediaGroup
bot.commands["/send_media_group"] = function(message)
  local data = InputMedia({
    -- InputMediaPhoto({
    --   media = 'AgACAgIAAxkDAAIJ52RX2qzt6oCMY5P9Ge9uVuZgTDH_AAL-yTEb9gABuEp-yXhmUY3rfAEAAwIAA3MAAy8E',
    --   caption = 'Photo with file_id',
    -- }),
    InputMediaPhoto({
      media = 'attach://'..'image.jpg',
      caption = 'Photo with disk',
    }),
    InputMediaPhoto({
      media = 'https://raw.githubusercontent.com/uriid1/scrfmp/main/perfect-arkanoid/arkanoid.png',
      caption = 'Photo with url',
    }),
  })

  bot:call('sendMediaGroup', data, {
    chat_id = message:getChatId()
  })
end

-- Event of getting entities
bot.events.onGetEntities = function(message)
  local entities = message:getEntities()

  -- Call bot command
  if entities[1] and entities[1].type == 'bot_command' then
    local command = bot.Command(message)
    if command then
      command(message)
    end
  end
end

-- Event of getting callbacks
bot.events.onCallbackQuery = function(callbackQuery)
  -- Callback processing
  local command = bot.CallbackCommand(callbackQuery)
  if command then
    command(callbackQuery)
  end
end

-- Event of getting any message
bot.events.onGetMessageText = function(message)
  -- Send message
  bot:call('sendMessage', {
    text = dec.bold(message:getText()),
    chat_id = message:getChatId(),
  })
end

-- Event of my chat member
bot.events.onMyChatMember = function(myChatMember)
  local status = myChatMember:getNewChatMemberStatus()

  if status == chat_member_status.MEMBER then
    local ufrom = myChatMember:getUserFrom()

    bot:call('sendMessage', {
      text = dec.user(ufrom) .. ' - Added me to this chat',
      chat_id = myChatMember:getChatId(),
    })
  end
end

-- Handle errors
bot.events.onRequestErr = function(data, err_name, error_code)
  log.error(data)
end

-- Run bot
-- Use long polling to develop
-- and webhook for release
--
-- Enable long polling
bot:startLongPolling()

-- Setup Web Hook
-- bot:startWebHook({
--   host = '0.0.0.0',
--   port = 5505,
--   url = 'https://mysite.ru/myBotUrl',
--   certificate = '/etc/cert/myBotName/public.pem',
--   drop_pending_updates = true,
--   allowed_updates = '["message", "my_chat_member", "callback_query"]'
-- })
