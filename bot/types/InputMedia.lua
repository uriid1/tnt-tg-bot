--- Input media
--
local InputFile = require('bot.types.InputFile')

local function InputMedia(data)
  if not data then
    return nil
  end

  local jsonData = {
    media = {}
  }

  for i = 1, #data do
    local media = data[i].media

    local filename = media:match('^attach://(.+)')
    if filename then
      jsonData[filename] = InputFile(filename)
    end

    table.insert(jsonData.media, data[i])
  end

  jsonData.media = jsonData.media

  return jsonData
end

return InputMedia
