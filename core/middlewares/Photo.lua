--[[
    ####--------------------------------####
    #--# Author:   by uriid1            #--#
    #--# License:  GNU GPLv3            #--#
    #--# Telegram: @main_moderator      #--#
    #--# E-mail:   appdurov@gmail.com   #--#
    ####--------------------------------####
--]]

local function Photo(filename)
    if type(filename) ~= 'string' then
        return nil
    end

    local fd = io.open(filename, 'rb')
    
    if fd == nil then
        return nil
    end

    local data = fd:read('*all'); fd:close()

    return {
        data = data;
        filename = filename;
    }
end

return Photo