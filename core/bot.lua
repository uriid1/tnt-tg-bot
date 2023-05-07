--[[
    ####--------------------------------####
    #--# Author:   by uriid1            #--#
    #--# License:  GNU GPLv3            #--#
    #--# Telegram: @main_moderator      #--#
    #--# E-mail:   appdurov@gmail.com   #--#
    ####--------------------------------####
--]]

-- Init
local bot = {}

-- Load all libs
require "extensions.string-extension"
require "extensions.table-extension"
local fiber = require 'fiber'
local json = require 'json'
local fio = require 'fio'
local log = require 'log'
local dprint = require 'core.modules.debug_print' (bot)
local request = require 'core.modules.make_request' (bot)
local event_switch = require 'core.modules.event_switch' (bot)
local stats = require 'core.classes.stats' :new() :append('rps')

-- Set bot options
function bot:setOptions(options)
    for key, value in pairs(options) do
        self[key] = value
    end

    -- Set default options
    self.creator_id = 0
    self.parse_mode = "HTML"

    -- Stats of RPS
    self.max_rps = 0
    self.avg_rps = 0

    -- Enents
    self.event = require 'core.models.events'
    -- Middlewares
    self.inputFile = require 'core.middlewares.inputFile'

    self.cmd = {}

    return self
end

-- Anonymous function
local f = function() end

-- This function allows you to execute any method
function bot:call(method, options)
    return request {
        method = method;
        options = options;
    }
end

-- Inline Keyboard
--
-- Inline init
function bot:inlineKeyboardInit()
    local keyboard = {}
    keyboard.__index = keyboard

    local obj = {
        inline_keyboard = {}
    }

    function keyboard:toJson()
        return json.encode(self)
    end

    setmetatable(obj, keyboard)

    return obj
end

bot.inlineKeyboardMarkup = bot.inlineKeyboardInit

-- InlineKeyboardButton
function bot:inlineKeyboardButton(keyboard, opts)
    -- Add to line
    if not keyboard["inline_keyboard"][opts.row] then
        table.insert(keyboard["inline_keyboard"], { opts })
        return
    end

    -- Add to row
    table.insert(keyboard["inline_keyboard"][opts.row or 1], opts)
end

-- Add inline URL button
function bot:inlineUrlButton(keyboard, opts)
    local text = opts.text
    local url = opts.url
    local row = opts.row

    local button = {
        url = url;
        text = text;
    }

    -- Add to line
    if not keyboard["inline_keyboard"][row] then
        table.insert(keyboard["inline_keyboard"], {button})
        return
    end

    -- Add to row
    table.insert(keyboard["inline_keyboard"][row or 1], button)
end

-- Add inline callback button
function bot:inlineCallbackButton(keyboard, opts)
    local text = opts.text
    local callback = opts.callback
    local row = opts.row

    local button = {
        callback_data = callback;
        text = text;
    }

    -- Add to line
    if not keyboard["inline_keyboard"][row] then
        table.insert(keyboard["inline_keyboard"], {button})
        return
    end

    -- Add to row
    table.insert(keyboard["inline_keyboard"][row or 1], button)
end


-- Reply Reyboard
--
-- https://core.telegram.org/bots/api#replykeyboardmarkup
function bot:replyKeyboardInit(opts)
    local keyboard = {}
    keyboard.__index = keyboard

    local obj = {
        keyboard = {}
    }

    function keyboard:toJson()
        if opts then
            for k,v in pairs(opts) do
                self[k] = v
            end
        end

        return json.encode(self)
    end

    setmetatable(obj, keyboard)

    return obj
end

bot.replyKeyboardMarkup = bot.replyKeyboardInit

-- https://core.telegram.org/bots/api#keyboardbutton
function bot:keyboardButton(keyboard, opts)
    local row = opts.row

    -- Add to line
    if not keyboard["keyboard"][row] then
        table.insert(keyboard["keyboard"], { opts })
        return
    end

    -- Add to row
    table.insert(keyboard["keyboard"][row or 1], opts)
end

-- https://core.telegram.org/bots/api#replykeyboardremove
function bot:ReplyKeyboardRemove()
    return json.encode {
        remove_keyboard = true
    }
end

-- Command handler
function bot.Command(message)
    local command = message:getArguments({count=1})[1]
    if not bot["cmd"][command] then
        return
    end

    dprint("[command] %s", command)

    bot["cmd"][command](message)
end

-- Callback handler
function bot.CallbackCommand(callbackQuery)
    local command = callbackQuery:getArguments({count=1})[1]
    if not bot["cmd"][command] then
        return
    end

    dprint("[callback] %s", command)

    bot["cmd"][command](callbackQuery)
end

-- Send cert
--
local send_certificate = function(options)
    if type(options) ~= 'table' or
        type(options.url) ~= "string" or
        type(options.certificate) ~= "string"
    then
        dprint("[Error] Invalid options to start a webhook")
        return
    end

    -- Certificate
    local cert_data
    if options.certificate ~= "non-self-signed" or options.certificate ~= false then
        local cert = fio.open(options.certificate, "O_RDONLY")
        cert_data = {
            filename = options.certificate:match("[^/]*.$");
            data = cert:read();
        }
        cert:close()
    end

    -- Set webhook
    return bot:call('setWebhook', {
        url = options.url;
        certificate = cert_data;
        drop_pending_updates = options.drop_pending_updates or false;
        allowed_updates = options.allowed_updates or nil
    })
end

-- Start webhook 
function bot:startWebHook(options)
    -- For calc RPS
    local rps_in_sec = 0
    local time = os.time()
    
    local http_server = require 'http.server'
    local httpd = http_server.new(options.host, options.port)
    httpd:route({
        path = options.path or '';
        method = 'POST';
        template = '200';
    }, function(req)
        -- Manage RPS
        --
        rps_in_sec = rps_in_sec + 1

        if os.time() - time > 1 then
            time = os.time()

            if bot.max_rps < rps_in_sec then
                bot.max_rps = rps_in_sec
            end

            -- In metrics
            stats:set('rps', rps_in_sec)

            rps_in_sec = 0
        end

        --
        fiber.create(function()
            local result = req:json()

            event_switch(result)

            bot.avg_rps = stats:get('rps')
        end)
    end)

    -- 
    httpd:start()
    dprint("[true] HTTP Server listening at 0.0.0.0:" .. options.port)

    --
    local res = send_certificate(options)
    if not res.ok then
        dprint(("[%s] description: %s"):format(res.ok, res.description))

        -- Exit
        if not res.ok then
            os.exit()
        end
    end
end

-- Start long polling
--
local getUpdates
getUpdates = function(first_start, offset, timeout, token, client)
    local res = client:request('GET', 'https://api.telegram.org'..string.format("/bot%s/getUpdates?offset=%d&timeout=%d", token, offset, timeout))
    local body = json.decode(res.body)

    -- First start
    if not first_start then
        if type(body) == 'table' then
            if not body.ok then
                dprint(("[Error] error_code: %s | description: %s")
                :format(body.error_code, body.description))
                return
            end

            dprint("[true] Long polling work")
        end
    end

    if type(body) == 'table' then
        if body.ok then
            for i = 1, #body.result do
                event_switch(body.result[i])
                offset = body.result[i].update_id + 1
            end
        end
    else
        -- Debug
        dprint("[false] Long polling.")
    end

    -- Get new updates
    return getUpdates(true, offset, timeout, token, client)
end

function bot:startLongPolling(options)
    if options and type(options) ~= 'table' then
        dprint("[Error] Invalid options to start a long polling")
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

    dprint("[true] Gettin Updates")

    -- Start long polling
    getUpdates(false, offset, polling_timeout, self.token, client)
end

return bot
