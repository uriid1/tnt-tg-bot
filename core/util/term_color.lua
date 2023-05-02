--[[
    ####--------------------------------####
    #--# Author:   by uriid1            #--#
    #--# License:  GNU GPLv3            #--#
    #--# Telegram: @main_moderator      #--#
    #--# E-mail:   appdurov@gmail.com   #--#
    ####--------------------------------####
--]]

-- auto-detect when 16 color mode should be used
local getenv = require('os').getenv
local term = getenv("TERM")
local color256 = term and (term == 'xterm' or term:find'-256color$')

local function decorator(color) 
    if not color256 then
        return function(str)
            return str
        end
    end

    return function(str)
        return ('\27[%sm%s\27[0m'):format(color, str)
    end
end

return {
    val  = decorator("38;5;221");
    warn = decorator("0;91");
    try  = decorator("0;94");
    err  = decorator("1;91");
}
