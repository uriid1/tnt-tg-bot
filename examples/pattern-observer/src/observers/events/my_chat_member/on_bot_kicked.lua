local log = require('bot.libs.logger')

local function on_bot_kicked(ctx)
  log.info('[event] %s', 'on_bot_kicked')
end

return on_bot_kicked
