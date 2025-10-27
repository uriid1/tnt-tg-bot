--- Обработчик команд
--
local bot = require('bot')
local command_type = require('src.enums.command_type')
local chat_type = require('bot.enums.chat_type')

local function processCommand(ctx)
  local commandName

  -- Нажали на callback кнопку
  if ctx.is_callback_query then
    commandName = ctx:getArguments({ count = 1 })[1]
  else
    -- Выполняем команды бота
    local entities = ctx:getEntities()
    if entities then
      commandName = ctx.message.text:split(' ', 1)[1]
    end
  end

  local command = bot.commands[commandName]

  if command == nil then
    return
  end

  -- Определение типа команд
  if command.type == command_type.PRIVATE then
    if ctx:getChatType() ~= chat_type.PRIVATE then
      return
    end
  end

  bot.commands[commandName].call(ctx)
end

return processCommand
