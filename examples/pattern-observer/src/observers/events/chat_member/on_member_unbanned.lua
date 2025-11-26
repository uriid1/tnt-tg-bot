local log = require('bot.libs.logger')

local function on_member_unbanned(ctx)
  log.verbose('[event] %s', 'on_member_unbanned')
end

return on_member_unbanned
