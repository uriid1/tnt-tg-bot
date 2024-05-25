-- Input media
--
local json = require('json')
local InputFile = require('core.types.InputFile')

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

  jsonData.media = json.encode(jsonData.media)

  return jsonData
end

return InputMedia
