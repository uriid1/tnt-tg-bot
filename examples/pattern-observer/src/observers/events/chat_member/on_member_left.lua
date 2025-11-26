local log = require('bot.libs.logger')

local function on_member_left(ctx)
  log.verbose('[event] %s', 'on_member_left')
end

return on_member_left
