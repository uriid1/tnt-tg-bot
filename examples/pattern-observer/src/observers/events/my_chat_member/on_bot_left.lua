local log = require('bot.libs.logger')

local function on_bot_left(ctx)
  log.info('[event] %s', 'on_bot_left')
end

return on_bot_left
