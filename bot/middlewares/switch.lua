--- Event switching module
-- @module switch
local processMessage = require('bot.middlewares.processMessage')

local switch = {}

-- Call events
-- luacheck: ignore bot
function switch.call(ctx)
  local result = processMessage(ctx)

  if bot.events.onGetUpdate then
    bot.events.onGetUpdate(result)
  end
end

return switch
