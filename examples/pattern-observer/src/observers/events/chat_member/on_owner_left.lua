local log = require('bot.libs.logger')

local function on_owner_left(ctx)
  log.verbose('[event] %s', 'on_owner_left')
end

return on_owner_left
