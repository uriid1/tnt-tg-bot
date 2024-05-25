---
-- Module for making HTTP requests to the Telegram Bot API.
-- @module request
local request = {}

local json = require('json')
local http = require('http.client')
local mpEncode = require('multipart-post')
local Error = require('core.middlewares.Error')

---
-- Initialize the request module with a bot instance and maximum connections.
-- @param bot The bot instance.
-- @param max_connections The maximum number of connections (optional, default is 40).
-- @return The initialized request module.
function request:init(bot, max_connections)
  self.bot = bot
  self.client = http.new { max_connections = max_connections or 40 }

  Error = Error:init(bot)

  return self
end

---
-- Send an HTTP request to the Telegram Bot API.
-- @param params The request parameters.
-- @return The response from the API, or nil if there was an error.
function request:send(params)
  local opts
  local body
  local bot = self.bot
  local client = self.client

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
  local urlFmt = 'https://api.telegram.org/bot%s/%s'
  local data = client:request('POST', urlFmt:format(bot.token, params.method), body, opts)

  -- Handle error
  if data.body == nil then
    local err
    if data then
      err = data
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
    else
      err = 'Empty data received'
    end

    return nil, err
  end

  return data, nil
end

return request
