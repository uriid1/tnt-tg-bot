--[[
    ####--------------------------------####
    #--# Author:   by uriid1            #--#
    #--# License:  GNU GPLv3            #--#
    #--# Telegram: @main_moderator      #--#
    #--# E-mail:   appdurov@gmail.com   #--#
    ####--------------------------------####
--]]

local function init(bot)
    local error_enum = require 'core.models.error_enum'
    local dprint = require 'core.util.debug_print' (bot)

    return function(result)
        -- Debug
        dprint({error = result})

        -- Handling error code
        for err_name, error_code in pairs(error_enum) do
            if result.error_code == error_code then
                return bot.event.onRequestErr(result, err_name, error_code)
            end
        end
        
        return bot.event.onRequestErr(result, nil, result.error_code)
    end
end

return init
