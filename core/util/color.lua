--[[
    ####--------------------------------####
    #--# Author:   by uriid1            #--#
    #--# License:  GNU GPLv3            #--#
    #--# Telegram: @main_moderator      #--#
    #--# E-mail:   appdurov@gmail.com   #--#
    ####--------------------------------####
--]]

local function decorator(color) 
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
