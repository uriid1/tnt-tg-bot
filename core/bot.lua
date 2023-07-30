--[[
  [------------------------------------]
  [   Author:   uriid1                 ]
  [   License:  GNU GPLv3              ]
  [   Telegram: @main_moderator        ]
  [   E-mail:   appdurov@gmail.com     ]
  [------------------------------------]
--]]

-- Init
local bot = { _version = '0.3.2' }

-- Load all libs
local json = require('json')
local fio = require('fio')
local dprint = require('core.modules.debug_print')(bot)
local request = require('core.modules.request')(bot)
local event_switch = require('core.modules.event_switch')(bot)
local stats = require('core.classes.stats'):new('RPS')
local parse_mode = require('core.enums.parse_mode')

-- Set bot options
function bot:setOptions(options)
  for key, value in pairs(options) do
    self[key] = value
  end

  -- Set default options
  self.creator_id = 0
  self.parse_mode = parse_mode.HTML

  -- Stats of RPS
  self.max_rps = 0
  self.avg_rps = 0

  -- Enents
  self.event = require 'core.models.events'

  -- Table of commands
  self.cmd = {}

  return self
end

-- This function allows you to execute any method
function bot:call(method, options, ...)
  if ... then
    for i = 1, select('#', ...) do
      local data = select(i, ...)
      if type(data) == 'table' then
        for key, val in pairs(data) do
          options[key] = val
        end
      end
    end
  end

  return request {
    method = method;
    options = options;
  }
end

-- Command handler
function bot.Command(message)
  local command = message:getArguments({count=1})[1]
  if not bot['cmd'][command] then
    return
  end

  dprint('[command] %s', command)

  bot['cmd'][command](message)
end

-- Callback handler
function bot.CallbackCommand(callbackQuery)
  local command = callbackQuery:getArguments({count=1})[1]
  if not bot['cmd'][command] then
    return
  end

  dprint('[callback] %s', command)

  bot['cmd'][command](callbackQuery)
end

-- Send cert
--
local send_certificate = function(options)
  if type(options) ~= 'table' or
    type(options.url) ~= 'string'
  then
    dprint('[Error] Invalid options to start a webhook')
    return
  end

  -- Read certificate
  local data
  if options.certificate then
    local cert = fio.open(options.certificate, 'O_RDONLY')
    data = {
      filename = options.certificate:match('[^/]*.$');
      data = cert:read();
    }
    cert:close()
  end

  -- Set webhook
  return bot:call('setWebhook', {
    url = options.url;
    certificate = data;
    drop_pending_updates = options.drop_pending_updates or false;
    allowed_updates = options.allowed_updates or nil
  })
end

-- Start webhook
function bot:startWebHook(options)
  -- RPS
  local rps_in_sec = 0
  local time = os.time()
  
  -- Server setup
  local http_server = require 'http.server'
  local host = options.host or '0.0.0.0'
  local port = options.port or 8081
  local httpd = http_server.new(host, port)

  local route = {
    path = options.path or '';
    method = 'POST';
    template = '200';
  }

  local function callback(req)
    -- Manage RPS
    --
    rps_in_sec = rps_in_sec + 1

    if os.time() - time > 1 then
      time = os.time()

      if bot.max_rps < rps_in_sec then
        bot.max_rps = rps_in_sec
      end

      stats:put('RPS', rps_in_sec)

      rps_in_sec = 0
    end

    local data = req:json()
    if bot.response_handler then
      bot.response_handler(event_switch, data)
    else
      event_switch(data)
    end

    -- Current average RPS
    bot.avg_rps = stats:getAverage('RPS')
  end

  httpd:route(route, callback):start()

  dprint('[Success] HTTP Server listening at 0.0.0.0:' .. options.port)

  local res = send_certificate(options)
  if res and not res.ok then
    dprint('[%s] description: %s', res.ok, res.description)
    os.exit()
  end
end

-- Start long polling
--
local getUpdates
getUpdates = function(first_start, offset, timeout, token, client)
  local res = client:request('GET', 'https://api.telegram.org'..string.format('/bot%s/getUpdates?offset=%d&timeout=%d', token, offset, timeout))
  local body = json.decode(res.body)

  -- First start
  if not first_start then
    if type(body) == 'table' then
      if not body.ok then
        dprint('[Error] error_code: %s | description: %s', body.error_code, body.description)
        return
      end

      dprint('[Success] Long polling work')
    end
  end

  if type(body) == 'table' then
    if body.ok then
      for i = 1, #body.result do
        local data = body.result[i]
        if bot.response_handler then
          bot.response_handler(event_switch, data)
        else
          event_switch(data)
        end

        offset = data.update_id + 1
      end
    end
  else
    -- Debug
    dprint('[Error] Long polling.')
  end

  -- Get new updates
  return getUpdates(true, offset, timeout, token, client)
end

function bot:startLongPolling(options)
  if options and type(options) ~= 'table' then
    dprint('[Error] Invalid options to start a long polling')
    return
  end

  local http = require 'http.client'
  local client = http.new({max_connections = 100})

  -- Set options
  local offset = -1
  local polling_timeout = 60

  if options then
    offset = options.offset or -1
    polling_timeout = options.timeout or 60
  end

  dprint('[Success] Gettin Updates')

  -- Start long polling
  getUpdates(false, offset, polling_timeout, self.token, client)
end

return bot
