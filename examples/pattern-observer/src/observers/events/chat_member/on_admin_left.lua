local log = require('bot.libs.logger')

local function on_admin_left(ctx)
  log.verbose('[event] %s', 'on_admin_left')
end

return on_admin_left
