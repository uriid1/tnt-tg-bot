--- Команда покупки по заданным категориям
--
local bot = require('bot')
local Command = require('src.classes.Command')
local command_type = require('src.enums.command_type')
local inlineKeyboard = require('bot.middlewares.inlineKeyboard')
local sql = require('bot.ext.sql')
local f = require('bot.ext.fstring')

local command = Command:new {
  commands = { 'cb_category' },
  type = command_type.CALLBACK
}

local TEMPLATE = [[
Ваша категория: ${category}
]]

local LIMIT = 10

function command.call(ctx)
  -- arguments[1] cb_category
  -- arguments[2] category
  -- arguments[3] page
  local arguments = ctx:getArguments { count = 3 }
  local category = arguments[2]
  local page = arguments[3] and tonumber(arguments[3]) or 1

  if page < 0 then page = 1 end

  -- Получение списка ключей к продаже
  local rows = sql([[
    SELECT *
    FROM SEQSCAN keys
    WHERE category = ${category}
    ORDER BY created DESC
    LIMIT ${limit}
    OFFSET ${offset}
  ]], {
    category = category,
    limit = LIMIT,
    offset = (page - 1) * LIMIT
  })

  -- Объект кнопок
  local keyboard = {}

  for i = 1, #rows do
    local row  = rows[i]
    local id   = tostring(row.id)
    local name = row.name

    table.insert(keyboard, {
      text = name,
      callback = 'cb_buy '..id
    })
  end

  -- Инициализация ряда для нижних кнопок
  table.insert(keyboard, {})
  -- Индекс ряда
  local rowKeysIndex = #keyboard

  if page > 1 then
    table.insert(keyboard[rowKeysIndex], {
      text = '⬅️ Назад',
      callback = f('cb_category ${category} ${page}', {
        category = category,
        page = page - 1
      })
    })
  end

  -- Колличество товаров нужной категории
  local countRow = sql([[
    SELECT COUNT(*) AS count
    FROM SEQSCAN keys
    WHERE category = ${category}
  ]], {
    category = category,
  })

  local count = countRow[1] and tonumber(countRow[1].count) or 0
  if count > (page * LIMIT) then
    table.insert(keyboard[rowKeysIndex], {
      text = '➡️ Далее',
      callback = f('cb_category ${category} ${page}', {
        category = category,
        page = page + 1
      })
    })
  end

  table.insert(keyboard, {
    text = '⬆️ Вернуть в категории',
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
