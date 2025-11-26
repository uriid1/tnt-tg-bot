local log = require('bot.libs.logger')

local function on_admin_demoted(ctx)
  log.verbose('[event] %s', 'on_admin_demoted')
end

return on_admin_demoted
