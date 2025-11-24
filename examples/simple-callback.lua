-- Example simple callback button 2
--
local bot = require('bot')
local parse_mode = require('bot.enums.parse_mode')
local processCommand = require('bot.processes.processCommand')
local inlineKeyboard = require('bot.middlewares.inlineKeyboard')

bot:cfg({
  token = os.getenv('BOT_TOKEN'),
  parse_mode = parse_mode.HTML
})

local function makeKeyboard()
  local keyboard = inlineKeyboard({
    -- Row
    { text = 'Get Apple', callback = 'cb_get_fruit apple' },
    { text = 'Get Banana', callback = 'cb_get_fruit banana' },
    -- Column
    {
      { text = 'Get Orange', callback = 'cb_get_fruit orange' },
      { text = 'Get lemon', callback = 'cb_get_fruit lemon' },
      { text = 'Get Melon', callback = 'cb_get_fruit melon' }
    }
  })

  return keyboard
end

bot.commands['cb_get_fruit'] = function(ctx)
  -- arguments[1] - Command cb_get_fruit
  -- arguments[2] - Fruit type
  local arguments = ctx:getArguments({ count = 2 })
  local fruit = arguments[2]

  local emoji = nil
  if fruit == 'apple' then
    emoji = '🍎'
  elseif fruit == 'banana' then
    emoji = '🍌'
  elseif fruit == 'orange' then
    emoji = '🍊'
  elseif fruit == 'lemon' then
    emoji = '🍋'
  elseif fruit == 'melon' then
    emoji = '🍉'
  end

  local callbackId = ctx:getQueryId()

  bot:answerCallbackQuery {
    text = emoji,
    callback_query_id = callbackId
  }
end

-- Command: send_callback
bot.commands['/send_callback'] = function(ctx)
  bot:sendMessage {
    text = 'Test Callback Button',
    chat_id = ctx:getChatId(),
    reply_markup = makeKeyboard()
  }
end

function bot.events.onGetUpdate(ctx)
  local isCallCommand = processCommand(ctx)
  if isCallCommand then
    return
  end

  -- Another events
  -- if ctx.edited_message then
  -- bot.events.onEditedMesasage(ctx)
end

bot:startLongPolling()
