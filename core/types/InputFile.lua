--[[
    ####--------------------------------####
    #--# Author:   by uriid1            #--#
    #--# License:  GNU GPLv3            #--#
    #--# Telegram: @main_moderator      #--#
    #--# E-mail:   appdurov@gmail.com   #--#
    ####--------------------------------####
--]]

local fio = require 'fio'

local function inputFile(filename)
    if type(filename) ~= 'string' then
        return nil
    end

    local fd = fio.open(filename, "O_RDONLY")
    
    if fd == nil then
        return nil
    end

    local data = fd:read(); fd:close()

    return {
        data = data;
        filename = filename;
    }
end

return inputFile