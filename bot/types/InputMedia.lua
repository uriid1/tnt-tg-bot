--- Input media
-- @module bot.types.InputMedia
local json = require('bot.libs.json')

local function InputMedia(data)
  if not data then
    return nil
  end

  return json.encode(data)
end

return InputMedia
