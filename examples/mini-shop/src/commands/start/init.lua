--- Команда /start
--
local bot = require('bot')
local Command = require('src.classes.Command')
local command_type = require('src.enums.command_type')
local inlineKeyboard = require('bot.middlewares.inlineKeyboard')

local command = Command:new {
  commands = { '/start', '/categories' },
  type = command_type.CALLBACK
}

local TEMPLATE = [[
🛍 Магазин покупки игровых ключей!
> Выберите категорию
]]

local keyboard = inlineKeyboard({
  -- Row 1
  {
    text = '🔫 Шутеры',
    callback = 'cb_category shooters 1'
  },

  -- Row 2
  {
    text = '🏎 Гонки',
    callback = 'cb_category racing 1'
  },

  -- Row 3
  {
    text = '🫅🏻 Стратегии',
    callback = 'cb_category strategy 1'
  }
})

function command.call(ctx)
  -- arguments[1] cb_category
  -- arguments[2] state
  local arguments = ctx:getArguments { count = 2 }
  local state = arguments[2]

  if state == 'reopen' then
    bot:editMessageText {
      text = TEMPLATE,
      chat_id = ctx:getChatId(),
      message_id = ctx:getMessageId(),
      reply_markup = keyboard
    }

    return
  end

  bot:sendMessage {
    text = TEMPLATE,
    chat_id = ctx:getChatId(),
    reply_markup = keyboard
  }
end

return command
