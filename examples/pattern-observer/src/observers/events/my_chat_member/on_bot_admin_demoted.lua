local log = require('bot.libs.logger')

local function on_bot_admin_demoted(ctx)
  log.info('[event] %s', 'on_bot_admin_demoted')
end

return on_bot_admin_demoted
