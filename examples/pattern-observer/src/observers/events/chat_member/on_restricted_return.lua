local log = require('bot.libs.logger')

local function on_restricted_return(ctx)
  log.verbose('[event] %s', 'on_restricted_return')
end

return on_restricted_return
