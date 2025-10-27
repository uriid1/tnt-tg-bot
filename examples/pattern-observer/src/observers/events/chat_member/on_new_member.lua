local log = require('bot.libs.logger')

local function on_new_member(ctx)
  log.info('[event] %s', 'on_new_member')
end

return on_new_member
