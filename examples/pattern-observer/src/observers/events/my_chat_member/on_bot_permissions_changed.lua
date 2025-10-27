local log = require('bot.libs.logger')

local function on_bot_permissions_changed(ctx)
  log.info('[event] %s', 'on_bot_permissions_changed')
end

return on_bot_permissions_changed
