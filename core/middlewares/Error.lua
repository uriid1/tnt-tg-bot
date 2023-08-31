local log = require('log')
local error_enum = require('core.enums.errors')

local Error = {}

local bot

-- luacheck: ignore _bot
function Error:init(_bot)
  bot = _bot
  return self
end

-- luacheck: ignore self
function Error:handle(data)
  if data.body then
    log.error('[Error] error_code: %d | description: %s', data.error_code, data.description)
  elseif data.status then
    log.error('[Error] status: %d | reason: %s', data.status, data.reason)
  else
    log.info(data)
  end

  -- Handling error code
  for err_name, error_code in pairs(error_enum) do
    if data.error_code == error_code then
      return bot.event.onRequestErr(data, err_name, error_code)
    end
  end

  return bot.event.onRequestErr(data, nil, data.error_code)
end

return Error
