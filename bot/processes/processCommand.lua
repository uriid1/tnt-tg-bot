--- Process for handling commands and callbacks
-- @module processCommand
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
  end

  local entities = ctx:getEntities()

  if entities[1].type == entity_type.BOT_COMMAND then
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

return processCommand
