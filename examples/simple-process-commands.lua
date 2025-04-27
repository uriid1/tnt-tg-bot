-- Example simple process command
--
local bot = require('bot')
local parse_mode = require('bot.enums.parse_mode')
local entity_type = require('bot.enums.entity_type')
local methods = require('bot.enums.methods')

local InlineKeyboardMarkup = require('bot.types.InlineKeyboardMarkup')
local InlineKeyboardButton = require('bot.types.InlineKeyboardButton')

bot:cfg({
  token = os.getenv('BOT_TOKEN'),
  parse_mode = parse_mode.HTML
})

local function makeKeyboard()
  local keyboard = InlineKeyboardMarkup()

  InlineKeyboardButton(keyboard, {
    text = 'Click Me!',
    callback_data = 'cb_button_press' -- bot callback command
  })

  InlineKeyboardButton(keyboard, {
    text = 'Send apple',
    callback_data = 'cb_send_apple' -- bot callback command
  })

  return keyboard
end

-- Bot command /send_callback
bot.commands['/send_callback'] = function(ctx)
  bot.call(methods.sendMessage, {
    text = 'Test Callback Button',
    chat_id = ctx:getChatId(),
    reply_markup = makeKeyboard()
  })
end

-- Callback cb_button_press
bot.commands['cb_button_press'] = function(ctx)
  local callbackId = ctx:getQueryId()

  bot.call(methods.answerCallbackQuery, {
    text = 'Hello!',
    callback_query_id = callbackId
  })
end

-- Callback cb_send_apple
bot.commands['cb_send_apple'] = function(ctx)
  local message = ctx:getMessage()
  local chatId = message:getChatId()

  bot.call(methods.sendMessage, {
    text = '🍎',
    chat_id = chatId,
  })
end

-- Text commad - hello
bot.commands['hello'] = function(ctx)
  bot.call(methods.sendMessage, {
    text = 'Hi!',
    chat_id = ctx:getChatId()
  })
end

local function processCommand(ctx)
  if ctx.is_callback_query then
    local command = bot.CallbackCommand(ctx)

    if command then
      command(ctx)
    end

    return
  end

  local command, botUserName = bot.Command(ctx)

  if botUserName ~= '@myUserNameBot' then
    -- return
  end

  if command then
    command(ctx)
  end
end

function bot.events.onGetUpdate(ctx)
  if ctx.is_callback_query then
    return processCommand(ctx)
  end

  if ctx.message then
    if ctx.message.entities then
      local entityType = ctx.message.entities[1].type

      if entityType == entity_type.BOT_COMMAND then
        return processCommand(ctx)
      end
    elseif ctx.message.text then
      return processCommand(ctx)
    end
  end
end

bot:startLongPolling()
