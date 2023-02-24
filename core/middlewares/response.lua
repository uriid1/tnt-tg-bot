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
    local dprint = require('core.util.debug_print')(bot)
    local f = function() end

    return function(result, cb)
        cb = cb or f

        -- Parse
        if result.ok then
            return cb(result)
        end

        -- Debug
        dprint({error = result})

        -- Handling by err code
        --
        -- Bad Request
        if result.error_code == error_enum.BAD_REQUEST then
            -- Group chat was migrated to a supergroup chat
            if result.parameters then
                if result.parameters.migrate_to_chat_id then
                    return bot.event.onRequestErrMigrateToChat(result)
                end
            end

            return cb(result)

        -- Unauthorized (Bot token is incorrect)
        elseif result.error_code == error_enum.UNAUTHORIZED then
            return bot.event.onRequestErrUnauthorized(result)

        -- Forbidden
        elseif result.error_code == error_enum.FORBIDDEN then
            return cb(result)

        -- Too Many Requests
        elseif result.error_code == error_enum.TOO_MANY_REQUESTS then
            return bot.event.onRequestErrTooManyRequests(result)
        end
    end
end

return init
