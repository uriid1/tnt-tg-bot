local log = require('bot.libs.logger')

local function on_bot_admin_promoted(ctx)
  log.info('[event] %s', 'on_bot_admin_promoted')
end

return on_bot_admin_promoted
