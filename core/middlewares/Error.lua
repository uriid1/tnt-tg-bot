--[[
    ####--------------------------------####
    #--# Author:   by uriid1            #--#
    #--# License:  GNU GPLv3            #--#
    #--# Telegram: @main_moderator      #--#
    #--# E-mail:   appdurov@gmail.com   #--#
    ####--------------------------------####
--]]

local function init(bot)
    local error_enum = require 'core.enums.errors'
    local dprint = require 'core.modules.debug_print' (bot)

    return function(data)
        -- Debug
        if data.body then
            dprint('[Error] error_code: %d | description: %s', data.error_code, data.description)
        elseif data.status then
            dprint('[Error] status: %d | reason: %s', data.status, data.reason)
        else
            dprint(data)
        end

        -- Handling error code
        for err_name, error_code in pairs(error_enum) do
            if data.error_code == error_code then
                return bot.event.onRequestErr(data, err_name, error_code)
            end
        end
        
        return bot.event.onRequestErr(data, nil, data.error_code)
    end
end

return init
