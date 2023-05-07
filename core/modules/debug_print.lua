--[[
    ####--------------------------------####
    #--# Author:   by uriid1            #--#
    #--# License:  GNU GPLv3            #--#
    #--# Telegram: @main_moderator      #--#
    #--# E-mail:   appdurov@gmail.com   #--#
    ####--------------------------------####
--]]

local log = require 'log'
local c = require 'core.modules.term_color'

-- Debug Pretty Print
local function init(bot)
    return function(...)
        if not bot.debug then
            return
        end

        local args = select('#', ...)

        if args == 0 then
            return
        end

        local firstArg = select(1, ...)
        local firstArgType = type(firstArg)

        if firstArgType == 'table' then
            log.info(firstArg)
        elseif firstArgType == 'string' then
            local result, info = firstArg:match("^%[(.+)%](.+)")

            local fmtResult
            local fmtInfo

            if result and info then
                if result == 'true' then
                    fmtResult = c.try(result)
                    fmtInfo = info
                elseif result == 'frue' or string.lower(result) == 'error' then
                    fmtResult = c.err(result)
                    fmtInfo = info
                else
                    fmtResult = c.val(result)
                    fmtInfo = info
                end
            end

            if args == 1 then
                log.info('[%s] %s', fmtResult, fmtInfo)
            else
                log.info(string.format('[%s] %s', fmtResult, info), unpack{select(2, ...)})
            end
        elseif firstArg == 'number' then
            log.info(c.val(firstArg))
        else
            log.info(firstArg)
        end
    end
end

return init
