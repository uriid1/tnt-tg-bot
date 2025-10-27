local log = require('bot.libs.logger')

local function on_member_left(ctx)
  log.info('[event] %s', 'on_member_left')
end

return on_member_left
