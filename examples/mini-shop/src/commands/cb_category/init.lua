--- Команда покупки по заданным категориям
--
local log = require('log')
local Command = require('src.classes.Command')
local command_type = require('src.enums.command_type')
local inlineKeyboard = require('bot.middlewares.inlineKeyboard')
local f = require('bot.ext.fstring')

local command = Command:new {
  commands = { 'cb_category' },
  type = command_type.CALLBACK
}

local TEMPLATE = [[
Ваша категория: ${category}
]]

function command.call(ctx)
  -- arguments[1] cb_category
  -- arguments[2] category
  local arguments = ctx:getArguments { count = 2 }
  local category = arguments[2]

  -- Получаем счписок доступных товаров
  local keyboard = {}

  -- TODO: пагинация
  local res, err = box.execute(
    f([[
      SELECT
        id AS id,
        name AS name,
        url AS url
      FROM SEQSCAN keys
      WHERE category = '${category}'
      LIMIT 10
      OFFSET ${offset}
    ]], {
      category = category,
      offset = 0
    })
  )

  if err then
    log.error(err)
    return
  end

  -- Лучшей практикой будет переводить tuple в таблицу -
  -- по формату спейса
  local rows = res.rows

  for i = 1, #rows do
    local row  = rows[i]
    local id   = tostring(row[1])
    local name = tostring(row[2])
    -- local url = row[3]

    table.insert(keyboard, {
      text = name,
      callback = 'cb_buy '..id
    })
  end

  table.insert(keyboard, {
    text = '⬅️ Назад',
    callback = '/categories reopen'
  })

  bot:editMessageText {
    text = f(TEMPLATE, {
      category = category
    }),
    message_id = ctx:getMessageId(),
    chat_id = ctx:getChatId(),
    reply_markup = inlineKeyboard(keyboard)
  }
end

return command
