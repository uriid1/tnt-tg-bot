---
--
local json = require('json')

-- luacheck: ignore req
-- luacheck: ignore res
local getPayments = function(req, res)
  return {
    status = 404,
    headers = {
      ['content-type'] = 'application/json'
    },
    body = json.encode({
      payments = {
        [1] = {
          date = os.time(),
          sum = 1000
        }
      }
    })
  }
end

return getPayments
