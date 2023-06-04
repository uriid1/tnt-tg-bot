--[[
    ####--------------------------------####
    #--# Author:   by uriid1            #--#
    #--# License:  GNU GPLv3            #--#
    #--# Telegram: @main_moderator      #--#
    #--# E-mail:   appdurov@gmail.com   #--#
    ####--------------------------------####
--]]

local message = require 'core.classes.message'
local callback = require 'core.classes.callback'
local chatMember = require 'core.classes.chatMember'
local myChatMember = require 'core.classes.myChatMember'

local function processMessage(data)
    if data.message then
        return message:new(data)
    elseif data.callback_query then
        return callback:new(data)
    elseif data.chat_member then
        return chatMember:new(data)
    elseif data.my_chat_member then
        return myChatMember:new(data)
    end

    return data
end

return processMessage
