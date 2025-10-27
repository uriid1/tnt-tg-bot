local log = require('bot.libs.logger')

local function on_bot_blocked(ctx)
  log.info('[event] %s', 'on_bot_blocked')
end

return on_bot_blocked
