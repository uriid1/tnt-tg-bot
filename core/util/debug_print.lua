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
                            io.stdout:write('['..c.try(result)..']', info)
                        else
                            io.stdout:write('['..c.err(result)..']', info)
                        end
                    end
                elseif type(v) == 'number' then
                    io.stdout:write(c.val(v))
                else
                    io.stdout:write(v)
                end
            end

            if i < n then
                io.stdout:write('\t')
            end
        end

        io.stdout:write('\n')
        io.stdout:flush()
        ::continue::
    end
end

return init
