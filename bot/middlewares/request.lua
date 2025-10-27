--- Module for making HTTP requests to the Telegram Bot API.
-- @module bot.middlewares.request
local config = require('bot.config')
local request = {}

local json = require('json')
local http = require('http.client')
local mpEncode = require('multipart-post')

--- Send an HTTP request to the Telegram Bot API.
-- @param params The request parameters.
-- @return The response from the API, or nil if there was an error.
function request.send(params)
  local opts = {}
  local body

  if params.fields then
    -- Set parse mode
    if params.fields.text or params.fields.caption then
      if not params.fields.parse_mode then
        params.fields.parse_mode = config.parse_mode
      end
    end

    -- Make multipart-data
    if params.is_multipart or params.multipart then
      local boundary
      body, boundary = mpEncode(params.fields)

      opts.headers = {
        ['Content-Type'] = 'multipart/form-data; boundary=' .. boundary,
      }
    else
      body = json.encode(params.fields)

      opts.headers = {
        ['Content-Type'] = 'application/json'
      }
    end
  end

  -- Request
  local urlFmt = config.api_url..'%s/%s'
  local data = http.post(urlFmt:format(config.token, params.method), body, opts)

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
  -- luacheck: ignore data
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
