--- Обработчик команд
--
local bot = require('bot')
local log = require('bot.libs.logger')
local command_type = require('src.enums.command_type')
local chat_type = require('bot.enums.chat_type')
local userService = require('src.services.users')

-- TODO: Обработчик таймаута нажатий на callback
-- TODO: Антифлуддер

local function processCommand(ctx, opts)
  local commandName
  local command

  if opts and opts.is_text_command then
    command = opts.command

    goto text_command
  end

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

  command = bot.commands[commandName]
  if command == nil then
    return
  end

  ::text_command::

  -- Определение типа команд
  if command.type == command_type.PRIVATE then
    if ctx:getChatType() ~= chat_type.PRIVATE then
      return
    end
  end

  -- Регистрация пользователя
  --
  local ufrom = ctx:getUserFrom()
  -- Пропуска ботов
  if ufrom.is_bot then
    return
  end

  local _, err = userService.upsert(ufrom)
  if err then
    log.error(err)
  end
  --

  -- Выполнение команды
  command.call(ctx)
end

return processCommand
