--- Событие получение сущностей
--
local bot = require('bot')
local config = require('conf.config')
local processCommand = require('src.processes.processCommand')

local function onGetEntities(ctx)
  local entities = ctx:getEntities()

  -- Прерываем обработку сущностей
  -- если сущность не команда
  local entity = entities[1]
  if entity.type ~= 'bot_command' then
    return
  end

  if ctx.message.text:find('@') then
    local commandName, username = ctx.message.text:match('(/.+)@(.+)')

    if username ~= config.bot.username then
      return
    end

    return processCommand(ctx, {
      is_text_command = true,
      command = bot.commands[commandName]
    })
  end

  processCommand(ctx)
end

return onGetEntities
