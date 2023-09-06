---
-- Module for making HTTP requests to the Telegram Bot API.
-- @module request
local json = require('json')
local http = require('http.client')
local mp_encode = require('multipart-post')
local Error = require('core.middlewares.Error')

local request = {}

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
  local boundary
  local bot = self.bot
  local client = self.client

  if params.options then
    -- Set parse mode
    if params.options.text or params.options.caption then
      params.options.parse_mode = params.options.parse_mode or bot.parse_mode
    end

    -- Make multipart-data
    body, boundary = mp_encode(params.options)

    -- Make headers
    opts = {
      headers = {
        ['Content-Type'] = "multipart/form-data; boundary="..boundary;
      }
    }
  end

  -- Request
  local url_fmt = 'https://api.telegram.org/bot%s/%s'
  local url = url_fmt:format(bot.token, params.method)
  local data = client:request('POST', url, body, opts)

  if not data.body then
    Error:handle(data)
    return
  end

  -- Decode JSON response
  local response_body = json.decode(data.body)

  -- Handle error
  if not response_body.ok then
    Error:handle(response_body)
    return
  end

  return response_body
end

return request
