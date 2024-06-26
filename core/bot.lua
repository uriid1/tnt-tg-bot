---
-- Tarantool telegram bot API.
-- @module bot

local bot = { _version = '0.7.5' }

local fiber = require('fiber')
local json = require('json')
local fio = require('fio')
local log = require('log')
local events = require('core.middlewares.events')
local request = require('core.modules.request'):init(bot)
local switch = require('core.modules.switch'):init(bot)
local parse_mode = require('core.enums.parse_mode')

---
-- Initializes the bot with options.
-- @param options (table) Options table.
--   - parse_mode (string, optional): The default parse mode (HTML by default).
-- @return (table) The bot object.
function bot:cfg(options)
  -- Set default options
  self.commands = {}
  self.rate = options.rate
  self.token = options.token
  self.events = events
  self.parse_mode = options.parse_mode or parse_mode.HTML

  return self
end

---
-- Executes a Telegram Bot API method.
-- @param method (string) The method to execute.
-- @param options (table) Method options.
-- @return[1] (table) The response from the Telegram Bot API.
-- @return[2] Error
function bot:call(method, options, request_param)
  local params = {
    method = method,
    options = options,
  }

  if request_param and request_param.multipart_post then
    params.is_multipart = true
  end

  if self.rate and self.rate.limit then
    return self.rate.limit(request, params)
  end

  return request:send(params)
end

---
-- Handles a command message.
-- @param data (table) The command message.
-- @return command, username
function bot.Command(data)
  local command = data:getArguments({ count = 1 })[1]

  local username
  if command:find('@') then
    command, username = command:match("(/.+)@(.+)")
  end

  if not bot.commands[command] then
    return nil, nil
  end

  data.message.__command = command

  log.info('[command] '..command)
  return bot.commands[command], username
end

---
-- Handles a callback query.
-- @param data (table) The callback query.
-- @return (function) The callback handler function.
function bot.CallbackCommand(data)
  local command = data:getArguments({ count = 1 })[1]
  if not bot.commands[command] then
    return
  end

  data.message.__command = command

  log.info('[callback] '..command)
  return bot.commands[command]
end

---
-- Sends a certificate for webhook setup.
-- @param options (table) Options table.
--   - url (string): The URL for the webhook.
--   - certificate (string, optional): The path to the certificate file.
--   - drop_pending_updates (boolean, optional): Whether to drop pending updates (false by default).
--   - allowed_updates (table, optional): List of allowed updates (nil by default).
-- @return (table) The response from the Telegram Bot API.
local function send_certificate(options)
  if type(options) ~= 'table' or type(options.url) ~= 'string' then
    log.error('Invalid options to start a webhook')
    return
  end

  -- Read certificate
  local data
  if options.certificate then
    local cert = fio.open(options.certificate, 'O_RDONLY')
    data = {
      filename = options.certificate:match('[^/]*.$'),
      data = cert:read()
    }
    cert:close()
  end

  -- Set webhook
  return bot:call('setWebhook', {
    url = options.url,
    certificate = data,
    drop_pending_updates = options.drop_pending_updates or false,
    allowed_updates = options.allowed_updates or nil
  }, { multipart_post = true })
end

---
-- Starts the webhook.
-- @param options (table) Options table.
--   - host (string, optional): The host to bind to (default is '0.0.0.0').
--   - port (number, optional): The port to listen on (default is 8081).
--   - path (string, optional): The route path ('/' string by default).
function bot:startWebHook(options)
  -- Server setup
  local http_server = require('http.server')
  local host = options.host or '0.0.0.0'
  local port = options.port or 8081
  local httpd = http_server.new(host, port)

  local route = {
    path = options.path or '/',
    method = 'POST',
  }

  local function callback(req)
    local data = req:json()

    -- Debug
    -- p(body)

    if self.response_handler then
      self.response_handler(switch.call_event, data)
    else
      switch:call_event(data)
    end

    return {
      status = 200,
      headers = { ['content-type'] = 'text/plain' },
      body = [[Ok]]
    }
  end

  httpd:route(route, callback):start()

  log.info('[Success] HTTP Server listening at 0.0.0.0:' .. options.port)

  if options.maintenance_mode ~= 'maint' then
    local res = send_certificate(options)
    if res and not res.ok then
      log.error('[%s] description: %s', res.ok, res.description)
      os.exit(1)
    end
  end
end

local getUpdates
getUpdates = function(first_start, offset, timeout, token, client)
  local url = string.format('https://api.telegram.org/bot%s/getUpdates?offset=%d&timeout=%d', token, offset, timeout)
  local res = client:request('GET', url)
  local body = json.decode(res.body)

  -- Debug
  -- p(body)

  -- First start
  if not first_start then
    if not body.ok then
      log.error('error_code: %s | description: %s', body.error_code, body.description)
      return
    end

    log.info('Long polling work')
  end

  if body.ok and body.result then
    for i = 1, #body.result do
      local data = body.result[i]

      fiber.create(function ()
        if bot.response_handler then
          bot.response_handler(switch.call_event, data)
        else
          switch:call_event(data)
        end
      end)

      offset = data.update_id + 1
    end
  else
    -- Debug
    log.error('Long polling error')
  end

  -- Get new updates
  return getUpdates(true, offset, timeout, token, client)
end

---
-- Starts long polling.
-- @param options (table, optional) Options table.
--   - offset (number, optional): The update offset (default is -1).
--   - timeout (number, optional): The polling timeout in seconds (default is 60).
function bot:startLongPolling(options)
  if options and type(options) ~= 'table' then
    log.error('Invalid options to start long polling')
    return
  end

  local http = require('http.client')
  local client = http.new({ max_connections = 1 })

  -- Set options
  local offset = -1
  local polling_timeout = 60

  if options then
    offset = options.offset or -1
    polling_timeout = options.timeout or 60
  end

  log.info('[Success] Getting Updates')

  -- Start long polling
  getUpdates(false, offset, polling_timeout, self.token, client)
end

return bot
