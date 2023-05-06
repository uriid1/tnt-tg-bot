--[[
    ####--------------------------------####
    #--# Author:   by uriid1            #--#
    #--# License:  GNU GPLv3            #--#
    #--# Telegram: @main_moderator      #--#
    #--# E-mail:   appdurov@gmail.com   #--#
    ####--------------------------------####
--]]

-- Init
local bot = {
    -- Consts
    token = "";
    admin_id = 0;
    parse_mode = "HTML";

    -- Parama
    debug = false;

    -- Stats of RPS
    max_rps = 0;
    avg_rps = 0;

    -- Enents
    event = require 'core.models.events';

    -- Middlewares
    Photo = require 'core.middlewares.Photo';

    -- Commands table
    cmd = {};
}

-- Set the bot token
function bot:setOptions(options)
    for k,v in pairs(options) do
        self[k] = v
    end
    return self
end

-------------------------
-- Power Functions
-------------------------
-- Debug print
local dprint = require 'core.util.debug_print' (bot)
local request = require 'core.helpers.request' (bot)

-- Anonymous function
local f = function() end

-------------------------
-- Libs
-------------------------
require "extensions.string-extension"
require "extensions.table-extension"

local fiber = require 'fiber'
local json = require 'json'
local fio = require 'fio'
local log = require 'log'

local processMessage = require 'core.models.processMessage' 

local http = require 'http.client'
local client = http.new({max_connections = 100})

local stats = require('core.classes.stats'):new():append('rps')

-- Webhook
-- https://core.telegram.org/bots/api#getwebhookinfo
-- https://core.telegram.org/bots/api#setwebhook
-- https://core.telegram.org/bots/api#deletewebhook


-- Available methods
--
-- This function allows you to execute any method
function bot:call(method, options)
    return request {
        method = method;
        options = options;
    }
end

-- https://core.telegram.org/bots/api#getme
-- https://core.telegram.org/bots/api#close
-- https://core.telegram.org/bots/api#sendmessage
-- https://core.telegram.org/bots/api#forwardmessage
-- https://core.telegram.org/bots/api#copyMessage
-- https://core.telegram.org/bots/api#sendphoto
-- https://core.telegram.org/bots/api#sendaudio
-- https://core.telegram.org/bots/api#senddocument
-- https://core.telegram.org/bots/api#sendvideo
-- https://core.telegram.org/bots/api#sendanimation
-- https://core.telegram.org/bots/api#sendvoice
-- https://core.telegram.org/bots/api#sendvideoNote
-- https://core.telegram.org/bots/api#sendmediagroup
-- https://core.telegram.org/bots/api#sendlocation
-- https://core.telegram.org/bots/api#editmessageliveLocation
-- https://core.telegram.org/bots/api#stopmessageliveLocation
-- https://core.telegram.org/bots/api#sendvenue
-- https://core.telegram.org/bots/api#sendcontact
-- https://core.telegram.org/bots/api#sendpoll
-- https://core.telegram.org/bots/api#senddice
-- https://core.telegram.org/bots/api#sendChataction
-- https://core.telegram.org/bots/api#getuserprofilephotos
-- https://core.telegram.org/bots/api#getfile
-- https://core.telegram.org/bots/api#banchatmember
-- https://core.telegram.org/bots/api#unbanchatmember
-- https://core.telegram.org/bots/api#restrictchatmember
-- https://core.telegram.org/bots/api#promotechatmember
-- https://core.telegram.org/bots/api#setchatadministratorcustomtitle
-- https://core.telegram.org/bots/api#banchatsenderchat
-- https://core.telegram.org/bots/api#unbanchatsenderchat
-- https://core.telegram.org/bots/api#setchatpermissions
-- https://core.telegram.org/bots/api#exportchatinvitelink
-- https://core.telegram.org/bots/api#createchatinvitelink
-- https://core.telegram.org/bots/api#editchatinvitelink
-- https://core.telegram.org/bots/api#revokechatinvitelink
-- https://core.telegram.org/bots/api#approvechatjoinrequest
-- https://core.telegram.org/bots/api#declinechatjoinrequest
-- https://core.telegram.org/bots/api#setchatphoto
-- https://core.telegram.org/bots/api#deletechatphoto
-- https://core.telegram.org/bots/api#setchattitle
-- https://core.telegram.org/bots/api#setchatdescription
-- https://core.telegram.org/bots/api#pinchatmessage
-- https://core.telegram.org/bots/api#unpinchatmessage
-- https://core.telegram.org/bots/api#unpinallchatmessages
-- https://core.telegram.org/bots/api#leavechat
-- https://core.telegram.org/bots/api#getchat
-- https://core.telegram.org/bots/api#getchatadministrators
-- https://core.telegram.org/bots/api#getchatmembercount
-- https://core.telegram.org/bots/api#getchatmember
-- https://core.telegram.org/bots/api#setchatstickerSet
-- https://core.telegram.org/bots/api#deletechatstickerSet
-- https://core.telegram.org/bots/api#answercallbackquery
-- https://core.telegram.org/bots/api#setmycommands
-- https://core.telegram.org/bots/api#deletemycommands
-- https://core.telegram.org/bots/api#getmycommands
-- https://core.telegram.org/bots/api#getchatmenuButton
-- https://core.telegram.org/bots/api#setmydefaultadministratorrights
-- https://core.telegram.org/bots/api#getmydefaultadministratorrights

-- Updating messages
-- https://core.telegram.org/bots/api#editmessagetext
-- https://core.telegram.org/bots/api#editmessagecaption
-- https://core.telegram.org/bots/api#editmessagemedia
-- https://core.telegram.org/bots/api#editmessagereplymarkup
-- https://core.telegram.org/bots/api#stoppoll
-- https://core.telegram.org/bots/api#deletemessage

-- Stickers
-- https://core.telegram.org/bots/api#sendsticker
-- https://core.telegram.org/bots/api#getstickerSet
-- https://core.telegram.org/bots/api#uploadstickerfile
-- https://core.telegram.org/bots/api#createnewstickerset
-- https://core.telegram.org/bots/api#addstickertoSet
-- https://core.telegram.org/bots/api#setstickerpositioninset
-- https://core.telegram.org/bots/api#deletestickerfromSet
-- https://core.telegram.org/bots/api#setstickersetthumb

-- Inline mode
-- https://core.telegram.org/bots/api#answerinlinequery
-- https://core.telegram.org/bots/api#answerwebappquery


-- Inline Keyboard
--
-- Inline init
function bot:inlineKeyboardInit()
    local keyboard = {}
    keyboard.__index = keyboard

    local obj = {
        inline_keyboard = {}
    }

    setmetatable(obj, keyboard)

    function keyboard:toJson()
        return json.encode(self)
    end

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
        url  = url;
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

    setmetatable(obj, keyboard)

    function keyboard:toJson()
        if opts then
            for k,v in pairs(opts) do
                self[k] = v
            end
        end

        return json.encode(self)
    end

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

-- Payments
-- https://core.telegram.org/bots/api#sendinvoice
-- https://core.telegram.org/bots/api#answershippingquery
-- https://core.telegram.org/bots/api#answerprecheckoutquery

-- Games
-- https://core.telegram.org/bots/api#sendgame
-- https://core.telegram.org/bots/api#setGameScore
-- https://core.telegram.org/bots/api#getGameHighScores


-- Command handler
function bot.Command(message)
    local command = message:getArguments({count=1})[1]
    if not bot["cmd"][command] then
        return
    end

    bot["cmd"][command](message)
end

-- Callback handler
function bot.CallbackCommand(callbackQuery)
    local command = callbackQuery:getArguments({count=1})[1]
    if not bot["cmd"][command] then
        return
    end

    bot["cmd"][command](callbackQuery)
end

-- Event handler
local call_event = function(event, data)
    local data = processMessage(data)
    return event(data)
end


-- Entity parse
--
local entity_parse = {}

entity_parse["bot_command"] = function(message)
    call_event(bot.event.onGetEntityBotCommand, message)
    return true
end

entity_parse["mention"] = function(message)
    call_event(bot.event.onGetEntityMention, message)
    return false
end

entity_parse["hashtag"] = function(message)
    call_event(bot.event.onGetEntityHashtag, message)
    return false
end

entity_parse["cashtag"] = function(message)
    call_event(bot.event.onGetEntityCashtag, message)
    return false
end

entity_parse["url"] = function(message)
    call_event(bot.event.onGetEntityUrl, message)
    return false
end

entity_parse["email"] = function(message)
    call_event(bot.event.onGetEntityEmail, message)
    return false
end

entity_parse["phone_number"] = function(message)
    call_event(bot.event.onGetEntityPhone, message)
    return false
end

entity_parse["code"] = function(message)
    call_event(bot.event.onGetEntityFormattedText, message)
    return false
end

entity_parse["bold"] = entity_parse["code"]
entity_parse["italic"] = entity_parse["code"]
entity_parse["underline"] = entity_parse["code"]
entity_parse["strikethrough"] = entity_parse["code"]
entity_parse["strikethrough"] = entity_parse["code"]
entity_parse["spoiler"] = entity_parse["code"]
entity_parse["pre"] = entity_parse["code"]
entity_parse["text_link"] = entity_parse["url"]
entity_parse["text_mention"] = entity_parse["url"]

--
local parse_query = function(result)
    -- Empty result
    if not result then
        dprint("[Error] Empty result")
        return
    end

    -- Not table
    if not table.isTable(result) then
        dprint("[Error] Result is not a table", result)
        return
    end

    -------------------
    -- Update Call Event
    -------------------
    -- https://core.telegram.org/bots/api#message
    if result.edited_message then
        return call_event(bot.event.onEditedMessage, result)

    -- https://core.telegram.org/bots/api#message
    elseif result.channel_post then
        return call_event(bot.event.onChannelPost, result)

    -- https://core.telegram.org/bots/api#message
    elseif result.edited_channel_post then
        return call_event(bot.event.onEditedChannelPost, result)

    -- https://core.telegram.org/bots/api#inlinequery
    elseif result.inline_query then
        return call_event(bot.event.onInlineQuery, result)

    -- https://core.telegram.org/bots/api#choseninlineresult
    elseif result.chosen_inline_result then
        return call_event(bot.event.onChosenInlineResult, result)

    -- https://core.telegram.org/bots/api#callbackquery
    elseif result.callback_query then
        return call_event(bot.event.onCallbackQuery, result)

    -- https://core.telegram.org/bots/api#shippingquery
    elseif result.shipping_query then
        return call_event(bot.event.ShippingQuery, result)

    -- https://core.telegram.org/bots/api#precheckoutquery
    elseif result.pre_checkout_query then
        return call_event(bot.event.PreCheckoutQuery, result)

    -- https://core.telegram.org/bots/api#poll
    elseif result.poll then
        return call_event(bot.event.onPoll, result)

    -- https://core.telegram.org/bots/api#pollanswer
    elseif result.poll_answer then
        return call_event(bot.event.onPollAnswer, result)

    -- https://core.telegram.org/bots/api#chatmemberupdated
    elseif result.my_chat_member then
        return call_event(bot.event.onMyChatMember, result)

    -- https://core.telegram.org/bots/api#chatmemberupdated
    elseif result.chat_member then
        return call_event(bot.event.onChatMember, result)

    -- https://core.telegram.org/bots/api#chatjoinrequest
    elseif result.chat_join_request then
        return call_event(bot.event.onChatJoinRequest, result)
    end

    -- Message Call Event
    -- https://core.telegram.org/bots/api#message
    --
    -- Get msg (useful when debugging)
    call_event(bot.event.onGetMessage, result)

    -- Sender Chat
    -- https://core.telegram.org/bots/api#chat
    if result.message.sender_chat then
        return call_event(bot.event.onSenderChat, result)
    end

    -- Forward
    -- https://core.telegram.org/bots/api#user
    if result.message.forward_from then
        return call_event(bot.event.onForwardFrom, result)

    -- https://core.telegram.org/bots/api#chat
    elseif result.message.forward_from_chat then
        return call_event(bot.event.onForwardFromChat, result)
    end

    -- Via bot
    -- https://core.telegram.org/bots/api#user
    if result.message.via_bot then
        return call_event(bot.event.onViaBot, result)
    end

    -- Chat
    -- https://core.telegram.org/bots/api#message
    if result.message.left_chat_member then
        return call_event(bot.event.onLeftChatMember, result)

    elseif result.message.new_chat_member then
        return call_event(bot.event.onNewChatMember, result)

    elseif result.message.new_chat_title then
        return call_event(bot.event.onNewChatTitle, result)

    elseif result.message.new_chat_photo then
        return call_event(bot.event.onNewChatPhoto, result)

    elseif result.message.delete_chat_photo then
        return call_event(bot.event.onDeleteChatPhoto, result)

    elseif result.message.group_chat_created then
        return call_event(bot.event.onGroupChatCreated, result)

    elseif result.message.supergroup_chat_created then
        return call_event(bot.event.onSupergroupChatCreated, result)

    elseif result.message.channel_chat_created then
        return call_event(bot.event.onChannelChatCreated, result)

    elseif result.message.migrate_to_chat_id then
        return call_event(bot.event.onMigrateToChatId, result)

    elseif result.message.migrate_from_chat_id then
        return call_event(bot.event.onMigrateFromChatId, result)

    end

    -- Payment
    -- https://core.telegram.org/bots/api#invoice
    if result.message.invoice then
        return call_event(bot.event.onInvoice, result)

    -- https://core.telegram.org/bots/api#successfulpayment
    elseif result.message.successful_payment then
        return call_event(bot.event.onSuccessfulPayment, result)
    end

    -- Passport
    -- https://core.telegram.org/bots/api#passportdata
    if result.message.passport_data then
        return call_event(bot.event.onPassportData, result)
    end

    -- Video Chat
    -- https://core.telegram.org/bots/api#videochatscheduled
    if result.message.video_chat_scheduled then
        return call_event(bot.event.onVideoChatScheduled, result)

    -- https://core.telegram.org/bots/api#videochatstarted
    elseif result.message.video_chat_started then
       return call_event(bot.event.onVideoChatStarted, result)

    -- https://core.telegram.org/bots/api#videochatended
    elseif result.message.video_chat_ended then
        return call_event(bot.event.onVideoChatEnded, result)

    -- https://core.telegram.org/bots/api#videochatparticipantsinvited
    elseif result.message.video_chat_participants_invited then
        return call_event(bot.event.onVideoChatParticipantsInvited, result)
    end

    -- Media
    -- https://core.telegram.org/bots/api#photosize
    if result.message.photo then
        return call_event(bot.event.onGetPhoto, result)

    -- https://core.telegram.org/bots/api#video
    elseif result.message.video then
        return call_event(bot.event.onGetVideo, result)

    -- https://core.telegram.org/bots/api#animation
    elseif result.message.animation then
        return call_event(bot.event.onGetAnimation, result)

    -- https://core.telegram.org/bots/api#document
    elseif result.message.document then
        return call_event(bot.event.onGetDocument, result)

    -- https://core.telegram.org/bots/api#location
    elseif result.message.location then
        return call_event(bot.event.onGetLocation, result)

    -- https://core.telegram.org/bots/api#poll
    elseif result.message.poll then
        return call_event(bot.event.onGetPoll, result)

    -- https://core.telegram.org/bots/api#audio
    elseif result.message.audio then
        return call_event(bot.event.onGetAudio, result)

    -- https://core.telegram.org/bots/api#contact
    elseif result.message.contact then
        return call_event(bot.event.onGetContact, result)

    -- https://core.telegram.org/bots/api#dice
    elseif result.message.dice then
        return call_event(bot.event.onGetDice, result)

    -- https://core.telegram.org/bots/api#game
    elseif result.message.game then
        return call_event(bot.event.onGetGame, result)

    -- https://core.telegram.org/bots/api#videonote
    elseif result.message.video_note then
        return call_event(bot.event.onGetVideoNote, result)

    -- https://core.telegram.org/bots/api#voice
    elseif result.message.voice then
        return call_event(bot.event.onGetVoice, result)

    -- https://core.telegram.org/bots/api#sticker
    elseif result.message.sticker then
        return call_event(bot.event.onGetSticker, result)
    end

    -- Entities
    -- https://core.telegram.org/bots/api#messageentity
    if result.message.entities then
        -- Empty entities
        if not result.message.entities[1] then
            return
        end

        -- For entities
        for i = 1, #result.message.entities do
            dprint(("[%s] %s"):format(result.message.entities[i].type, result.message.text))
            
            -- Check entity exists
            if entity_parse[result.message.entities[i].type] then
                if entity_parse[result.message.entities[i].type](result) then
                    return
                end
            end
        end

    end -- message.entities

    -- Text
    if result.message.text then
        return call_event(bot.event.onGetMessageText, result)
    end

    return call_event(bot.event.onUnknownUpdate, result)
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

            parse_query(result)

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
getUpdates = function(first_start, offset, timeout, token)
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
                parse_query(body.result[i])
                offset = body.result[i].update_id + 1
            end
        end
    else
        -- Debug
        dprint("[false] Long polling.")
    end

    -- Get new updates
    return getUpdates(true, offset, timeout, token)
end

function bot:startLongPolling(options)
    if options and type(options) ~= 'table' then
        dprint("[Error] Invalid options to start a long polling")
        return
    end

    -- Set options
    local offset = -1
    local polling_timeout = 60

    if options then
        offset = options.offset or -1
        polling_timeout = options.timeout or 60
    end

    dprint("[true] Gettin Updates")

    -- Start long polling
    getUpdates(false, offset, polling_timeout, self.token)
end

return bot
