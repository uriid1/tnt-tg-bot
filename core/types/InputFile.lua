--- Input file
local fio = require('fio')

local inputFile
--- Function inputFile
-- @function inputFile
-- @param filename (string)
-- @return (table)
function inputFile(filename)
  if type(filename) ~= 'string' then
    return nil
  end

  local fd = fio.open(filename, 'O_RDONLY')

  if fd == nil then
    return nil
  end

  local data = fd:read()
  fd:close()

  return {
    data = data;
    filename = filename;
  }
end

return inputFile
