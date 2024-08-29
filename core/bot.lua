---
--- Tarantool Telegram Bot API
--- By uriid1
--- Licence GPL V2
---
-- @module bot
local bot = { _version = '0.8.3' }

local log = require('log')
local fio = require('fio')
local json = require('json')
local fiber = require('fiber')
local events = require('core.middlewares.events')
local switch = require('core.modules.switch'):init(bot)
local request = require('core.modules.request'):init(bot)
local parse_mode = require('core.enums.parse_mode')

--- Initializes the bot with options
--
-- @param options (table) Options
  -- @param[opt] options.token (string) Bot token
  -- @param[opt] options.parse_mode (string) Parse mode. HTML by default
-- @usage
-- bot:cfg {
--  token = '1234567:AABBccDDFF',
--  parse_mode = 'HTML'
-- }
--
-- @return bot object
function bot:cfg(options)
  self.commands = {}
  self.token = options.token
  self.events = events
  self.parse_mode = options.parse_mode or parse_mode.HTML

  return self
end

--- Executes a Telegram Bot API method.
--
-- @param method (string) TG API method to execute
-- @param options (table) Method options
-- @param[optchain] request_param (table) { multipart_post = true }
--
-- @usage
-- bot:call("sendMessage", {
--  text = 'Hello!',
--  chat_id = 123456789,
-- })
--
-- @return (table) Response from the Telegram Bot API
-- @return (table) Error object
function bot:call(method, options, request_param)
  local params = {
    method = method,
    options = options,
  }

  if request_param and request_param.multipart_post then
    params.is_multipart = true
  end

  return request:send(params)
end

--- Handles a command message
--
-- @param data (table) Message object
--
-- @return Command func
-- @return Bot username
function bot.Command(data)
  local command = data:getArguments({ count = 1 })[1]

  local username
  if command:find('@') then
    command, username = command:match("(/.+)@(.+)")
  end

  if not bot.commands[command] then
    return nil, nil
  end

  data.__command = command

  log.info('[command] '..command)
  return bot.commands[command], username
end

--- Handles a callback query
--
-- @param data (table) Callback query object
--
-- @return Command func
function bot.CallbackCommand(data)
  local command = data:getArguments({ count = 1 })[1]
  if not bot.commands[command] then
    return
  end

  data.__command = command

  log.info('[callback] '..command)
  return bot.commands[command]
end

--- Sends a certificate for webhook setup
--
-- @param options (table) Options table
  -- @param options.url (string) URL for the webhook
  -- @param options.certificate (string) Path to the certificate file
  -- @param options.drop_pending_updates (boolean) Whether to drop pending updates (false by default)
  -- @param options.allowed_updates (table) List of allowed updates (nil by default)
--
-- @return (table) Response data
function bot.send_certificate(options)
  if type(options) ~= 'table'
    or type(options.bot_url) ~= 'string'
  then
    log.error('Invalid options to start a webhook')
    return
  end

  -- Read certificate
  local data
  if options.certificate then
    if not fio.path.exists(options.certificate) then
      log.error('Certificate not found: '..options.certificate)
      return
    end

    local cert = fio.open(options.certificate, 'O_RDONLY')
    data = {
      filename = options.certificate:match('[^/]*.$'),
      data = cert:read()
    }
    cert:close()
  end

  if type(options.allowed_updates) == 'table' then
    options.allowed_updates = json.encode(options.allowed_updates)
  end

  -- Set webhook
  return bot:call('setWebhook', {
    url = options.url,
    certificate = data,
    drop_pending_updates = options.drop_pending_updates or false,
    allowed_updates = options.allowed_updates
  }, { multipart_post = true })
end

--- Start the webhook
--
-- @param options (table) Options table
  -- @param options.host (string) Host to bind to (default is '0.0.0.0')
  -- @param options.port (number) Port to listen on (default is 5077)
  -- @param options.path (string) Route path ('/' string by default)
function bot:startWebHook(options)
  local http_server = require('http.server')
  local host = options.host or '0.0.0.0'
  local port = options.port or 5077
  local httpd = http_server.new(host, port)

  local route = {
    path = options.path or '/',
    method = 'POST',
  }

  -- Bot route setup
  --
  local function default_callback(req)
    local data = req:json()

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

  httpd:route(route, default_callback)
  --

  -- Declaration custom routes
  if options.routes then
    for i = 1, #options.routes do
      local route = options.routes[i]
      httpd:route({ path = route.path, method = route.method }, route.callback)
    end
  end

  httpd:start()
  log.info('[Success] HTTP Server listening at %s:%d', host, port)

  if options.maintenance_mode ~= 'maint' then
    local res = bot.send_certificate(options)
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

  -- First start
  if not first_start then
    if not body.ok then
      log.error('Error code: %s | Description: %s', body.error_code, body.description)
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

--- Start long polling
--
-- @param[opt] options (table) Options table
  -- @param[opt] options.offset (number) Update offset (default is -1)
  -- @param[opt] options.timeout (number) Polling timeout in seconds (default is 60)
  -- @param[opt] options.max_connections (number) (default is 1)
function bot:startLongPolling(options)
  if options and type(options) ~= 'table' then
    log.error('Invalid options to start long polling')
    return
  end

  local http = require('http.client')
  local client = http.new({ max_connections = options and options.max_connections or 1 })

  -- Set options
  local offset = -1
  local polling_timeout = 60

  if options then
    offset = options.offset or -1
    polling_timeout = options.timeout or 60
  end

  log.info('[Success] Getting Updates')

  getUpdates(false, offset, polling_timeout, self.token, client)
end

return bot
