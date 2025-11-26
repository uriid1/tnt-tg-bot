--- Команда /help
--
local bot = require('bot')
local Command = require('src.classes.Command')
local command_type = require('src.enums.command_type')

local command = Command:new {
  commands = { '/help' },
  type = command_type.PRIVATE
}

local TEMPLATE = [[
Помощь по командам
]]

function command.call(ctx)
  bot:sendMessage {
    text = TEMPLATE,
    chat_id = ctx:getChatId()
  }
end

return command
