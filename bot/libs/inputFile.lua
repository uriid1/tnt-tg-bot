--- Input file
-- @module bot.libs.inputFile
local log = require('bot.libs.logger')

local function inputFile(filename)
  if type(filename) ~= 'string' then
    return nil
  end

  local fd = io.open(filename, 'r')

  if fd == nil then
    log.error('Cannot open file: ' .. filename)

    return nil
  end

  local data = fd:read()
  fd:close()

  return {
    data = data,
    filename = filename
  }
end

return inputFile
