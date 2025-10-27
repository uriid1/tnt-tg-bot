local log = require('bot.libs.logger')

local function on_bot_added_as_member(ctx)
  log.info('[event] %s', 'on_bot_added_as_member')
end

return on_bot_added_as_member
