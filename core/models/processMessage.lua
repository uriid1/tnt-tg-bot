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

local function processMessage(data)
    if data.message then
        data = message:new(data)
    elseif data.callback_query then
        data = callback:new(data)
    else
        data = data
    end

    return data
end

return processMessage
