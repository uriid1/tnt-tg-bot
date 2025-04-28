--- Input file
-- @module bot.types.inputFile
local fio = require('fio')
local log = require('log')

local function inputFile(filename)
  if type(filename) ~= 'string' then
    return nil
  end

  local fd = fio.open(filename, 'O_RDONLY')

  if fd == nil then
    log.error('Error opening file: '..filename)

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
