local json = require('json')
local http = require('http.client')
local mp_encode = require('multipart-post')
local Error = require('core.middlewares.Error')

local client
local bot

local request = {}

function request:init(_bot, max_connections)
  bot = _bot
  Error = Error:init(bot)
  client = http.new { max_connections = max_connections or 100 }

  return self
end

function request:send(params)
  local opts
  local body
  local boundary

  if params.options then
    -- Set parse mode
    if params.options.text or
      params.options.caption
    then
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

  -- Decode json
  local responceBody = json.decode(data.body)

  -- Handle error
  if not responceBody.ok then
    Error:handle(responceBody)
    return
  end

  return responceBody
end

return request
