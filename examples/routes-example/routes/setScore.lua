---
--
local json = require('json')

local error_403 = function()
  return {
    status = 403,
    headers = {
      ['content-type'] = 'application/json'
    },

    body = json.encode({
      status = 403,
      reason = 'Forbidden'
    })
  }
end

-- luacheck: ignore req
-- luacheck: ignore res
local setScore = function(req, res)
  local data = req:json()
  local score = data.score

  print('Received score: '..score)

  return error_403()
end

return setScore
