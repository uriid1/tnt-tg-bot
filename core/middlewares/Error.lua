---
-- Error handling module.
-- @module Error
local error_enum = require('core.enums.errors')

local Error = {}

---
-- Handle errors based on error codes.
-- @param data The error data.
-- @return The result of handling the error.
function Error:handle(data)
  local bot = self.bot

  for err_name, error_code in pairs(error_enum) do
    if data.error_code == error_code then
      return bot.event.onRequestErr(data, err_name, error_code)
    end
  end

  return bot.event.onRequestErr(data, nil, data.error_code)
end

---
-- Initialize the Error module with a bot instance.
-- @param bot The bot instance.
-- @return The initialized Error module.
function Error:init(bot)
  self.bot = bot
  return self
end

return Error
