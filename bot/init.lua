-- ----------------------------- --
-- Tarantool Telegram Bot API    --
-- By uriid1                     --
-- Licence MIT                   --
-- ----------------------------- --
--- @module bot
local bot = { _version = '1.1.3' }

package.path = package.path .. ';.rocks/share/lua/5.1/?.lua'
package.cpath = package.cpath .. ';.rocks/lib/lua/5.1/?.so'

string.split = require('bot.libs.split')

local json = require('bot.libs.json')
local config = require('bot.config')
local request = require('bot.middlewares.request')
local processMessage = require('bot.middlewares.processMessage')
local log = require('bot.libs.logger')
local inputFile = require('bot.libs.inputFile')
local methods = require('bot.enums.methods')

local switch = function (ctx)
  if bot.events.onGetUpdate then
    bot.events.onGetUpdate(processMessage(ctx))
  end
end

--- Initializes the bot with opts
--
-- @param opts (table) opts
  -- @param[opt] opts.token (string) Bot token
  -- @param[opt] opts.parse_mode (string) Parse mode. HTML by default
  -- @param[opt] opts.api_url (string)
-- @usage
-- bot:cfg {
--  token = '1234567:AABBccDDFF...',
--  parse_mode = 'HTML' -- Default: 'HTML'
-- }
--
-- @return bot object
function bot:cfg(opts)
  self.token = opts.token
  self.api_url = opts.api_url or config.api_url
  self.parse_mode = opts.parse_mode or config.parse_mode
  self.username = opts.username
  self.methods = methods
  self.logger = opts.logger or log
  self.commands = {}

  config.token = opts.token
  config.api_url = opts.api_url or config.api_url
  config.parse_mode = opts.parse_mode or config.parse_mode
  config.username = opts.username

  -- Log calls to undefined events
  self.events = setmetatable({}, {
    __index = function(_, key)
      return function ()
        log.warn(string.format('[Event] "%s" is not defined', key))
      end
    end
  })

  return self
end

--- Executes a Telegram Bot API method.
--
-- @param method (string) TG API method to execute
-- @param fields (table) Method fields
-- @param opts (table) Options
-- @param[optchain] opts.request_param (table) { multipart_post = true }
--
-- @usage
-- bot.call("sendMessage", {
--  text = 'Hello!',
--  chat_id = 123456789,
-- })
--
-- @return (table) Response from the Telegram Bot API
-- @return (table) Error object
function bot.call(method, fields, opts)
  if method == nil then
    error('bot.call method is nil')
  end

  local params = {
    method = method,
    fields = fields,
  }

  if opts and opts.multipart_post then
    params.is_multipart = true
  end

  return request.send(params)
end

--- Wrap mehods
--
for method,_ in pairs(methods) do
  bot[method] = function (_, fields, opts)
    return bot.call(method, fields, opts)
  end
end

--- A simplified version of the sendPhoto method
--
-- @param data (table) Method fields
-- @param data.filepath Path to image
-- @param data.url URL to image
function bot.sendImage(data)
  if data.filepath then
    data.photo = inputFile(data.filepath)
    data.filepath = nil
  elseif data.url then
    data.photo = data.url
    data.url = nil
  end

  bot.call(methods.sendPhoto, data, { multipart_post = true })
end

--- Handles a command via text (ctx.message.text)
--
-- @param ctx (table) Message object
--
-- @return Command func
-- @return Bot username
function bot.Command(ctx)
  local command = ctx:getArguments({ count = 1 })[1]

  local username
  if command:find('@') then
    command, username = command:match("(/.+)@(.+)")
  end

  if not bot.commands[command] then
    return nil, nil
  end

  ctx.__command = command

  log.verbose('[Command] %s', command)

  return bot.commands[command], username
end

--- Handles a callback query
--
-- @param ctx (table) Callback query object
--
-- @return Command func
function bot.CallbackCommand(ctx)
  local command = ctx:getArguments({ count = 1 })[1]
  if not bot.commands[command] then
    return
  end

  ctx.__command = command

  log.info('[Callback] %s', command)

  return bot.commands[command]
end


---
--- Выполнение GET запроса
---
local ltn12 = require('ltn12')
local https = require('ssl.https')
local request = https.request

local function GET(url)
  local response = {}

  local success, code, headers, status = request {
    url = url,
    method = 'GET',
    sink = ltn12.sink.table(response),
  }

  return {
    success = success or false;
    code    = code    or 0;
    status  = status  or 0;
    headers = table.concat(headers  or { 'no headers' });
    body    = table.concat(response or { 'no response' });
  }
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
      url = string.format(
        api_url..'%s/getUpdates?offset=%d&timeout=%d&allowed_updates=%s',
        token,
        offset,
        timeout,
        json.encode(allowed_updates))
  else
    url = string.format(
      api_url..'%s/getUpdates?offset=%d&timeout=%d',
      token,
      offset,
      timeout)
  end

  local res = GET(url)
  local body = json.decode(res.body)

  -- First start
  if not first_start then
    if not body.ok then
      log.error('[Long Polling] %s | %s',
        'Code: ' .. body.error_code,
        'Description: ' .. body.description)

      return
    end

    log.verbose('[Long Polling] %s', 'Received updates')
  end

  if body.ok and body.result then
    for i = 1, #body.result do
      local data = body.result[i]
      switch(data)

      offset = data.update_id + 1
    end
  else
    -- Debug
    log.error(json.encode{ err = body.error })
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

local DEFAULT_ALLOWED_UPDATES = {
  'message',
  'chat_member',
  'my_chat_member',
  'callback_query',
  'pre_checkout_query'
}

--- Start long polling
--
-- @param[opt] opts (table) opts table
  -- @param[opt] opts.offset (number) Update offset (default is -1)
  -- @param[opt] opts.timeout (number) Polling timeout in seconds (default is 60)
  -- @param[opt] opts.max_connections (number) (default is 1)
  -- @param[opt] opts.allowed_updates (array)
  -- @param[opt] opts.api_url (string)
function bot:startLongPolling(opts)
  opts = opts or {}

  -- Set opts
  local offset = -1
  local polling_timeout = 60

  if opts then
    offset = opts.offset or -1
    polling_timeout = opts.timeout or 60
  end

  local allowed_updates = opts.allowed_updates or DEFAULT_ALLOWED_UPDATES

  log.info('[Long Polling] %s', 'Running | Updates: '..table.concat(allowed_updates, ', '))

  getUpdates({
    fisrt_start = false,
    offset = offset,
    timeout = polling_timeout,
    token = self.token,
    allowed_updates = opts.allowed_updates or DEFAULT_ALLOWED_UPDATES,
    api_url = self.api_url
  })
end

return bot
