--- Process for handling commands and callbacks
-- @module bot.processes.processCommand
local bot = require('bot')
local entity_type = require('bot.enums.entity_type')

-- luacheck: ignore bot
local function processCommand(ctx)
  if ctx.is_callback_query then
    local command = bot.CallbackCommand(ctx)

    if not command then
      return false
    end

    command(ctx)

    return true
  elseif ctx.getEntities then
    local entities = ctx:getEntities()

    if entities and entities[1].type == entity_type.BOT_COMMAND then
      local command, botUserName = bot.Command(ctx)

      if botUserName ~= bot.username then
        return false
      end

      if not command then
        return false
      end

      command(ctx)

      return true
    end
  end
end

return processCommand
