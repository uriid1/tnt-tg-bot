local error_enum = require('core.enums.errors')

local Error = {}

-- Handling error
-- luacheck: ignore self
function Error:handle(data)
  local bot = self.bot

  for err_name, error_code in pairs(error_enum) do
    if data.error_code == error_code then
      return bot.event.onRequestErr(data, err_name, error_code)
    end
  end

  return bot.event.onRequestErr(data, nil, data.error_code)
end

-- luacheck: ignore _bot
function Error:init(bot)
  self.bot = bot
  return self
end

return Error
