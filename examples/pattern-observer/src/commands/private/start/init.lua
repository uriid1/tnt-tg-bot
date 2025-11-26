--- Команда /start
--
local bot = require('bot')
local Command = require('src.classes.Command')
local command_type = require('src.enums.command_type')
local inlineKeyboard = require('bot.middlewares.inlineKeyboard')
local f = require('bot.ext.fstring')

local command = Command:new {
  commands = { '/start' },
  type = command_type.PRIVATE
}

local TEMPLATE = [[
Привет!

* Тут какая-то информация *
]]

local keyboard = inlineKeyboard({
  -- Row 1
  {
    text = '👉 ДОБАВИТЬ В ГРУППУ 👈',
    url = f('https://t.me/${username}?startgroup=true', { username = bot.username })
  },
})

function command.call(ctx)
  bot:sendMessage {
    text = TEMPLATE,
    chat_id = ctx:getChatId(),
    reply_markup = keyboard
  }
end

return command
