--- Module for making HTTP requests to the Telegram Bot API.
-- @module bot.middlewares.request
local config = require('bot.config')
local request = {}

local json = require('bot.libs.json')
local mpEncode = require('bot.libs.multipart-post')

---
--- Выполнение POST запроса
---
local ltn12 = require('ltn12')
local https = require('ssl.https')

local function POST(url, headers, body)
  local response = {}

  local success, code, headers, status = https.request {
    url = url,
    method = 'POST',
    headers = headers,
    source = ltn12.source.string(body),
    sink = ltn12.sink.table(response)
  }

  return  {
    success = success,
    code = code,
    status = status,
    headers = table.concat(headers  or {"no headers"});
    body = table.concat(response or {"no response"});
  }
end

--- Send an HTTP request to the Telegram Bot API.
-- @param params The request parameters.
-- @return The response from the API, or nil if there was an error.
function request.send(params)
  local headers
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

      headers = {
        ['Content-Type'] = 'multipart/form-data; boundary=' .. boundary,
        ['Content-Length'] = #body
      }
    else
      body = json.encode(params.fields)

      headers = {
        ['Content-Type'] = 'application/json',
        ['Content-Length'] = #body
      }
    end
  end

  -- Request
  local urlFmt = config.api_url..'%s/%s'

  -- Options
  local response = POST(urlFmt:format(config.token, params.method), headers, body)

  -- Handle error
  if response.body == nil then
    local err = {}
    err.__method = params.method

    if response and response.success == 1 then
      err.status = response.status
    else
      err.status = 'Empty data received'
    end

    return nil, err
  end

  -- Decode JSON response
  -- luacheck: ignore data
  local data = json.decode(response.body)

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
