--- Событие получение сущностей
--
local processCommand = require('src.processes.processCommand')

local function onGetEntities(ctx)
  local entities = ctx:getEntities()

  -- Прерываем обработку сущностей
  -- если сущность не команда
  local entity = entities[1]
  if entity.type ~= 'bot_command' then
    return
  end

  processCommand(ctx)
end

return onGetEntities
