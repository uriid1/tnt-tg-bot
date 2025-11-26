--- Обработчик команд
--
local bot = require('bot')

local function processCommand(ctx)
  -- Нажали на callback кнопку
  if ctx.is_callback_query then
    local commandName = ctx:getArguments({ count = 1 })[1]
    if bot.commands[commandName] then
      bot.commands[commandName].call(ctx)
    end

    return
  end

  -- Выполняем комнда бота
  local entities = ctx:getEntities()
  if entities then
    local commandName = ctx.message.text:split(' ', 1)[1]
    if bot.commands[commandName] then
      bot.commands[commandName].call(ctx)
    end
  end
end

return processCommand
