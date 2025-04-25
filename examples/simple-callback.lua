-- Example simple callback button
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

  return keyboard
end

-- Command: send_callback
bot.commands['/send_callback'] = function(ctx)
  bot.call(methods.sendMessage, {
    text = 'Test Callback Button',
    chat_id = ctx:getChatId(),
    reply_markup = makeKeyboard()
  })
end

bot.commands['cb_button_press'] = function(ctx)
  local callbackId = ctx:getQueryId()

  bot.call(methods.answerCallbackQuery, {
    text = 'Hello!',
    callback_query_id = callbackId
  })
end

function bot.events.onGetUpdate(ctx)
  if ctx.is_callback_query then
    local command = bot.CallbackCommand(ctx)

    if command then
      command(ctx)
    end

    return
  end

  local entities = ctx:getEntities()

  if entities[1].type == entity_type.BOT_COMMAND then
    local command, botUserName = bot.Command(ctx)

    if botUserName ~= '@myUserNameBot' then
      -- return
    end

    if command then
      command(ctx)
    end
  end
end

bot:startLongPolling()
