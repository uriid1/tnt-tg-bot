--
-- Examples of how some methods and commands work
--
local fiber = require('fiber')
local log = require('log')
local bot = require('core.bot')
local parse_mode = require('core.enums.parse_mode')

-- Optional pretty-print
--
_G.p = require('pimp')
p:matchPath('tnt%-tg%-bot/(.+)')
  :disableTableAddr()
  :enableVisibility()
  :enableFullCallStack()
  :enableCallStackLadder()
--

-- Setup
bot:cfg {
  token = os.getenv('BOT_TOKEN'), -- Your bot Token
  parse_mode = parse_mode.HTML,   -- Mode for parsing entities
}

-- Commands:
-- /start
-- /set_commands
-- /timer
-- /args_test arg1 arg2
-- /send_photo
-- /send_reply_buttons_1
-- /send_reply_buttons_2
-- /remove_reply_keyboard
-- /send_inline_buttons_1
-- /send_inline_buttons_2
-- /send_media_group

-- Load all libs/extensions
local dec = require('core.extensions.html_formatter')
local chat_member_status = require('core.enums.chat_member_status')
local bot_command_scope = require('core.enums.bot_command_scope')
-- Inputs
local InputFile = require('core.types.InputFile')
local InputMedia = require('core.types.InputMedia')
local InputMediaPhoto = require('core.types.InputMediaPhoto')
-- Inline buttons
local InlineKeyboardMarkup = require('core.types.InlineKeyboardMarkup')
local InlineKeyboardButton = require('core.types.InlineKeyboardButton')
-- Reply buttons
local ReplyKeyboardMarkup = require('core.types.ReplyKeyboardMarkup')
local KeyboardButton = require('core.types.KeyboardButton')
local ReplyKeyboardRemove = require('core.types.ReplyKeyboardRemove')
-- Bot commands
local BotCommand = require('core.types.BotCommand')
local BotCommandScope = require('core.types.BotCommandScope')

-- Command handler
local function processCommand(data, opts)
  -- Callback commanmd
  if opts and opts.is_callback then
    local command = bot.CallbackCommand(data)
    if command then
      command(data)

      -- Answer callback
      bot:call('answerCallbackQuery', {
        callback_query_id = data:getQueryId()
      })
    end

    return
  end

  -- Bot command or other
  local command = bot.Command(data)
  if command then
    command(data)
  end
end

-- Command /start
bot.commands['/start'] = function(data)
  -- Get bot information
  local dataGetMe, err = bot:call('getMe')

  if err then
    log.error(err)

    return
  end

  -- Creating textual information about the bot
  --
  local infoText = dec.bold('Bot Info:\n')

  for paramName, value in pairs(dataGetMe.result) do
    paramName = dec.bold(paramName)
    value = dec.monospaced(value)

    infoText = infoText .. paramName .. ': ' .. value .. '\n'
  end

  -- Send text message
  bot:call('sendMessage', {
    text = infoText,
    chat_id = data:getChatId(),
  })
end

-- Set bot commands
bot.commands['/set_commands'] = function(data)
  local _, err = bot:call('setMyCommands', {
    commands = {
      BotCommand({ '/start', 'Start the bot' }),
      BotCommand({ '/timer', 'Timer test' }),
      BotCommand({ '/test' })
    },
    scope = BotCommandScope(bot_command_scope.DEFAULT)
  })

  if err then
    log.error(err)

    return
  end

  bot:call('sendMessage', {
    text = 'Commands installed',
    chat_id = data:getChatId(),
  })
end

-- Delete bot commands
bot.commands['/delete_commands'] = function(data)
  local _, err = bot:call('deleteMyCommands', {
    scope = BotCommandScope(bot_command_scope.DEFAULT)
  })

  if err then
    log.error(err)

    return
  end

  bot:call('sendMessage', {
    text = 'Commands removed',
    chat_id = data:getChatId(),
  })
end

-- Test timer
bot.commands['/timer'] = function(data)
  for i = 1, 3 do
    bot:call('sendMessage', {
      text = 'timeout: ' .. i,
      chat_id = data:getChatId(),
    })

    fiber.sleep(1)
  end
end

-- Command /args_test
-- Paring argumnts
bot.commands['/args_test'] = function(data)
  -- arguments[1] -- Command name
  -- arguments[2] -- Argument 1
  -- arguments[3] -- Argument 2
  local arguments = data:getArguments({ count = 3 })
  local arg1 = arguments[1] or 'nil'
  local arg2 = arguments[2] or 'nil'
  local arg3 = arguments[3] or 'nil'

  local text_fmt = 'Command: %s\n arg2: %s\n arg3: %s\n'
  local text = text_fmt:format(arg1, arg2, arg3)

  bot:call('sendMessage', {
    text = text,
    chat_id = data:getChatId(),
  })
end

-- Close all callback command
bot.commands['cb_close'] = function(callback)
  -- Delete message
  bot:call('deleteMessage', {
    chat_id = callback:getChatId(),
    message_id = callback:getMessageId(),
  })
end

bot.commands['cb_button'] = function(callback)
  -- arguments[1] - Command name
  -- arguments[2] - Button ID
  local arguments = callback:getArguments({ count = 2 })
  local buttonId = tonumber(arguments[2])

  bot:call('sendMessage', {
    text = 'Press Button: '..buttonId,
    chat_id = callback:getChatId(),
  })
end

-- Command /send_photo
-- Method sendPhoto
bot.commands['/send_photo'] = function(data)
  local data, err = bot:call('sendPhoto', {
    photo = InputFile('image.jpg'),
    caption = 'Omg! It\'s photo from disk!',
    chat_id = data:getChatId(),
  }, { multipart_post = true })

  if err then
    log.error(err)

    return
  end

  local fileIdArr = data.result.photo
  local file_id = fileIdArr[#fileIdArr].file_id
  local width = fileIdArr[#fileIdArr].width
  local height = fileIdArr[#fileIdArr].height
  log.info('File ID: %s Width: %d Height: %d', file_id, width, height)
end

-- Command /send_reply_buttons_1
-- Method sendMessage with reply_markup
bot.commands['/send_reply_buttons_1'] = function(data)
  bot:call('sendMessage', {
    text = 'Reply keyboard buttons test 1',
    chat_id = data:getChatId(),
    reply_markup = ReplyKeyboardMarkup({
      keyboard = {
        { KeyboardButton(nil, { text = 'Apple' }), KeyboardButton(nil, { text = 'Banana' }) },
        { KeyboardButton(nil, { text = 'Orange' }) },
      },

      one_time_keyboard = true,
    })
  })
end

-- Command /send_reply_buttons_2
-- Method sendMessage with reply_markup and keyboard buttons
bot.commands['/send_reply_buttons_2'] = function(data)
  -- Another option for building buttons
  local keyboard = ReplyKeyboardMarkup({ one_time_keyboard = false })
  KeyboardButton(keyboard, { text = 'Apple' })
  KeyboardButton(keyboard, { text = 'Banana' })
  KeyboardButton(keyboard, { text = 'Orange', row = 2 })

  bot:call('sendMessage', {
    text = 'Reply keyboard buttons test 2',
    chat_id = data:getChatId(),
    reply_markup = keyboard,
  })
end

-- Command remove_reply_keyboard
-- Work only in private chat type
-- see https://core.telegram.org/bots/api#replykeyboardremove
bot.commands['/remove_reply_keyboard'] = function(data)
  bot:call('sendMessage', {
    text = 'Removed reply keyboard',
    chat_id = data:getChatId(),
    reply_markup = ReplyKeyboardRemove({ selective = true }),
  })
end

-- Command send_inline_buttons_1
-- Method sendMessage with reply_markup
bot.commands['/send_inline_buttons_1'] = function(data)
  bot:call('sendMessage', {
    text = 'Inline keyboard buttons test 1',
    chat_id = data:getChatId(),
    reply_markup = InlineKeyboardMarkup({
      inline_keyboard = {
        {
          InlineKeyboardButton(nil, { text = 'Button 1', callback_data = 'cb_button 1' }),
          InlineKeyboardButton(nil, { text = 'Button 2', callback_data = 'cb_button 2' })
        },
        { InlineKeyboardButton(nil, { text = 'Close', callback_data = 'cb_close' }) }
      }
    })
  })
end

-- Command send_inline_buttons_2
-- Method sendMessage with reply_markup and inline buttons
bot.commands['/send_inline_buttons_2'] = function(data)
  -- Another option for building buttons
  local keyboard = InlineKeyboardMarkup()
  InlineKeyboardButton(keyboard, { text = 'Button 1', callback_data = 'cb_button 1' })
  InlineKeyboardButton(keyboard, { text = 'Button 2', callback_data = 'cb_button 2', row = 1 })
  InlineKeyboardButton(keyboard, { text = 'Close', callback_data = 'cb_close' })

  bot:call('sendMessage', {
    text = 'Inline keyboard buttons test 2',
    chat_id = data:getChatId(),
    reply_markup = keyboard,
  })
end

-- Command /send_media_group
-- Method sendMediaGroup
bot.commands['/send_media_group'] = function(data)
  local mediaData = InputMedia({
    -- For file id
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

  mediaData.chat_id = data:getChatId()

  bot:call('sendMediaGroup', mediaData, {
    multipart_post = true
  })
end

-- Event of getting entities
-- https://core.telegram.org/bots/api#messageentity
bot.events.onGetEntities = function(data)
  local entities = data:getEntities()

  if entities[1] and entities[1].type == 'bot_command' then
    -- Call bot command
    processCommand(data)
  end
end

-- Event of getting callbacks
bot.events.onCallbackQuery = function(callback)
  -- Call bot callback
  processCommand(callback, { is_callback = true })
end

bot.events.onGetMessage = function(data)
  if not data.message then
    return
  end

  if data.message.entities then
    return bot.events.onGetEntities(data)

  elseif data.message.text then
    return bot.events.onGetMessageText(data)

  end
end

-- Event of getting any message
bot.events.onGetMessageText = function(data)
  local text = data.message.text

  local result
  if text == 'Apple' then
    result = 'You got +1 apple!'
  elseif text == 'Banana' then
    result = 'You got +1 banana!'
  elseif text == 'Orange' then
    result = 'You got +1 orange!'
  end

  if result then
    bot:call('sendMessage', {
      text = result,
      chat_id = data.message.chat.id,
    })
    return
  end

  -- Send message
  bot:call('sendMessage', {
    text = dec.bold(data.message.text),
    chat_id = data.message.chat.id,
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
bot.events.onRequestErr = function(err, _, _)
  log.error(err)
end

-- Run bot
-- Use long polling to develop
-- and webhook for release
--
-- Enable long polling
bot:startLongPolling()

--[[ Setup Web Hook
bot:startWebHook({
  -- Server setup
  host = '0.0.0.0',
  port = 5505,
  -- Bot setup
  url = 'https://mysite.ru/myBotUrl',
  certificate = '/etc/cert/myBotName/public.pem',
  drop_pending_updates = true,
  allowed_updates = {
    "message",
    "my_chat_member",
    "callback_query"
  },

  -- Custom routes (array of routes)
  routes = {
    -- Example
    {
      path = '/bot/v1/payments',
      method = 'GET',
      callback = function(req)
        return {
          status = 200,
          headers = { ['content-type'] = 'text/plain' },
          body = "Payments: no data"
        }
      end
    }
  },
})
]]
