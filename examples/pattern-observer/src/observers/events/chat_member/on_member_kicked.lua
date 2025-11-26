local log = require('bot.libs.logger')

local function on_member_kicked(ctx)
  log.verbose('[event] %s', 'on_member_kicked')
end

return on_member_kicked
