local log = require('bot.libs.logger')

local function on_admin_promoted(ctx)
  log.info('[event] %s', 'on_admin_promoted')
end

return on_admin_promoted
