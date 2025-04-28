--- Module for making HTTP requests to the Telegram Bot API.
-- @module bot.middlewares.request
local request = {}

local json = require('json')
local http = require('http.client')
local mpEncode = require('multipart-post')
local methods = require('bot.enums.methods')

-- luacheck: ignore bot
--- Send an HTTP request to the Telegram Bot API.
-- @param params The request parameters.
-- @return The response from the API, or nil if there was an error.
function request.send(params)
  local opts
  local body

  if not params.options then
    goto req_send
  end

  -- Set parse mode
  if params.options.text or params.options.caption then
    if not params.options.parse_mode then
      params.options.parse_mode = bot.parse_mode
    end
  end

  -- Make headers
  opts = {}

  if params.is_multipart then
    -- https://core.telegram.org/bots/api#sendmediagroup
    -- A JSON-serialized array describing messages to be sent, must include 2-10 items
    if params.method == methods.sendMediaGroup then
      local media = params.options.media

      if media then
        params.options.media = json.encode(media)
      end
    end

    -- Make multipart-data
    local boundary
    body, boundary = mpEncode(params.options)

    opts.headers = {
      ['Content-Type'] = 'multipart/form-data; boundary=' .. boundary,
    }
  else
    body = json.encode(params.options)

    opts.headers = {
      ['Content-Type'] = 'application/json'
    }
  end

  ::req_send::

  -- Request
  local urlFmt = bot.api_url..'%s/%s'
  local data = http.post(urlFmt:format(bot.token, params.method), body, opts)

  -- Handle error
  if data.body == nil then
    local err
    if data and data.ok == false then
      err = data
      err.__method = params.method
    else
      err = 'Empty data received'
    end

    return nil, err
  end

  -- Decode JSON response
  local data = json.decode(data.body)

  -- Handle error
  if data.ok == false then
    local err
    if data then
      err = data
      err.__method = params.method
    else
      err = 'Empty data received'
    end

    return nil, err
  end

  -- Proxy
  -- tg: data.result.object.key
  -- proxy: result.object.key
  --
  setmetatable(data, {
    __index = function(t, key)
      if key == nil then
        return rawget(t, 'result')
      end

      local _raw_t = rawget(t, 'result')
      if _raw_t and _raw_t[key] then
        return _raw_t[key]
      end
    end,

    __newindex = function(tbl, key, value)
      rawget(tbl, 'result')[key] = value
    end,
  })

  return data, nil
end

return request
