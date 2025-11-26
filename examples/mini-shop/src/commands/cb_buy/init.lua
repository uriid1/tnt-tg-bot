--- Команда покупки ключа
--
local bot = require('bot')
local Command = require('src.classes.Command')
local command_type = require('src.enums.command_type')

local command = Command:new {
  commands = { 'cb_buy' },
  type = command_type.CALLBACK
}

function command.call(ctx)
  bot:answerCallbackQuery {
    text = '🙃 Команда не реализована',
    show_alert = true,
    callback_query_id = ctx:getQueryId()
  }
end

return command
