--[[
    ####--------------------------------####
    #--# Author:   by uriid1            #--#
    #--# License:  GNU GPLv3            #--#
    #--# Telegram: @main_moderator      #--#
    #--# E-mail:   appdurov@gmail.com   #--#
    ####--------------------------------####
--]]

local log = require 'log'
local c = require 'core.util.term_color'

-- Debug Pretty Print
local function init(bot)
    return function(...)
        if not bot.debug then
            return
        end

        local n = select('#', ...)
        for i = 1, n do
            local v = select(i, ...)
            local arg_type = type(v)

            if arg_type == 'table' then
                log.info(v)
                goto continue
            else
                if type(v) == 'string' then
                    local result, info = v:match("^%[(.+)%](.+)")
                    if result and info then
                        if result == 'true' then
                            log.info('[%s] %s', c.try(result), info)
                        else
                            log.info('[%s] %s', c.err(result), info)
                        end
                    end
                elseif type(v) == 'number' then
                    log.info(c.val(v))
                else
                    log.info(v)
                end
            end

            if i < n then
                log.info('\t')
            end
        end

        ::continue::
    end
end

return init
