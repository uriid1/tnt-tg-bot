--- Event switching module
-- @module bot.middlewares.switch
local processMessage = require('bot.middlewares.processMessage')

local switch = {}

-- Call events
-- luacheck: ignore bot
function switch.call(ctx)
  if bot.events.onGetUpdate then
    bot.events.onGetUpdate(processMessage(ctx))
  end
end

return switch
