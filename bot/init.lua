-----------------------------------
--- Tarantool Telegram Bot API
--- By uriid1
--- Licence MIT
-----------------------------------
--- @module bot
local bot = { _version = '1.0.0' }

local log = require('log')
local fio = require('fio')
local json = require('json')
local fiber = require('fiber')
local switch = require('bot.middlewares.switch')
local request = require('bot.middlewares.request')
local parse_mode = require('bot.enums.parse_mode')
local InputFile = require('bot.types.InputFile')
local methods = require('bot.enums.methods')

--- Initializes the bot with options
--
-- @param options (table) Options
  -- @param[opt] options.token (string) Bot token
  -- @param[opt] options.parse_mode (string) Parse mode. HTML by default
  -- @param[opt] options.api_url (string)
-- @usage
-- bot:cfg {
--  token = '1234567:AABBccDDFF',
--  parse_mode = 'HTML'
-- }
--
-- @return bot object
function bot:cfg(options)
  self.token = options.token
  self.commands = {}
  self.events = {}
  self.api_url = options.api_url or 'https://api.telegram.org/bot'
  self.parse_mode = options.parse_mode or parse_mode.HTML
  self.username = options.username

  _G.bot = bot

  return self
end

--- Executes a Telegram Bot API method.
--
-- @param method (string) TG API method to execute
-- @param options (table) Method options
-- @param[optchain] request_param (table) { multipart_post = true }
--
-- @usage
-- bot.call("sendMessage", {
--  text = 'Hello!',
--  chat_id = 123456789,
-- })
--
-- @return (table) Response from the Telegram Bot API
-- @return (table) Error object
function bot.call(method, options, opts)
  if method == nil then
    error('bot.call method is nil.')
  end

  local params = {
    method = method,
    options = options,
  }

  if opts and opts.multipart_post then
    params.is_multipart = true
  end

  return request.send(params)
end

--- A simplified version of the sendPhoto method
--
-- @param data (table) Method options
-- @param data.filepath Path to image
-- @param data.url URL to image
function bot.sendImage(data)
  if data.filepath then
    data.photo = InputFile(data.filepath)
    data.filepath = nil
  elseif data.url then
    data.photo = data.url
    data.url = nil
  end

  bot.call(methods.sendPhoto, data, { multipart_post = true })
end

--- Handles a command via text (ctx.message.text)
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
  if type(options) ~= 'table' or
    type(options.bot_url) ~= 'string'
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
  return bot.call('setWebhook', {
    url = options.bot_url,
    certificate = data,
    drop_pending_updates = options.drop_pending_updates or false,
    allowed_updates = options.allowed_updates
  }, { multipart_post = true })
end

--- Start the webhook
--
-- @param options (table) Options table
  -- @param options.host (string) Host to bind to (default is '0.0.0.0')
  -- @param options.port (number) Port to listen on (default is 9091)
  -- @param options.path (string) Route path ('/' string by default)
  -- @param options.routes (table) Routes table
  -- @param options.maintenance_mode (string) Maintenance mode eq 'maint'
  -- @param options.allowed_updates (array)
function bot:startWebHook(options)
  local http_server = require('http.server')
  local host = options.host or '0.0.0.0'
  local port = options.port or 9091
  local httpd = http_server.new(host, port)

  local route = {
    path = options.path or '/',
    method = 'POST',
  }

  -- Bot route setup
  --
  local function default_callback(req)
    fiber.create(function ()
      local data = req:json()

      switch.call(data)
    end)

    return {
      status = 200,
      headers = {
        ['content-type'] = 'text/plain'
      },
      body = [[OK]]
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

  self.maintenance = options.maintenance_mode == 'maint'
end

local getUpdates
getUpdates = function(opts)
  local first_start = opts.first_start
  local offset = opts.offset
  local timeout = opts.timeout
  local token = opts.token
  local client = opts.client
  local allowed_updates = opts.allowed_updates
  local api_url = bot.api_url

  local url
  if allowed_updates then
      url = string.format(api_url..'%s/getUpdates?offset=%d&timeout=%d&allowed_updates=%s',
      token,
      offset,
      timeout,
      json.encode(allowed_updates)
    )
  else
    url = string.format(api_url..'%s/getUpdates?offset=%d&timeout=%d',
      token,
      offset,
      timeout
    )
  end

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
        switch.call(data)
      end)

      offset = data.update_id + 1
    end
  else
    -- Debug
    log.error('Long polling error')
  end

  -- Get new updates
  return getUpdates({
    fisrt_start = true,
    offset = offset,
    timeout = timeout,
    token = token,
    client = client,
    allowed_updates = allowed_updates
  })
end

--- Start long polling
--
-- @param[opt] options (table) Options table
  -- @param[opt] options.offset (number) Update offset (default is -1)
  -- @param[opt] options.timeout (number) Polling timeout in seconds (default is 60)
  -- @param[opt] options.max_connections (number) (default is 1)
  -- @param[opt] options.allowed_updates (array)
  -- @param[opt] options.api_url (string)
function bot:startLongPolling(options)
  options = options or {}

  local http = require('http.client')
  local client = http.new({
    max_connections = options and options.max_connections or 1
  })

  -- Set options
  local offset = -1
  local polling_timeout = 60

  if options then
    offset = options.offset or -1
    polling_timeout = options.timeout or 60
  end

  log.info('[Success] Getting Updates')

  getUpdates({
    fisrt_start = false,
    offset = offset,
    timeout = polling_timeout,
    token = self.token,
    client = client,
    allowed_updates = options.allowed_updates,
    api_url = self.api_url
  })
end

return bot
