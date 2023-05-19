--[[
    ####--------------------------------####
    #--# Author:   by uriid1            #--#
    #--# License:  GNU GPLv3            #--#
    #--# Telegram: @main_moderator      #--#
    #--# E-mail:   appdurov@gmail.com   #--#
    ####--------------------------------####
--]]

-- Class definition
--
local stats = {}

function stats:new(name, max_count)
    self[name] = {
        count = max_count or 10;
        parts = {};
    }

    self.__index = self
    return setmetatable({}, self)
end

function stats:put(name, val)
    if not self[name] then
        return nil
    end

    if #self[name] == self.count then
        table.remove(self[name].parts, self.count)
    end

    table.insert(self[name].parts, val)
end

function stats:getAverage(name)
    if not self[name] then
        return nil
    end

    local sum = 0
    for i = 1, #self[name].parts do
        sum = sum + self[name].parts[i]
    end

    return sum/#self[name].parts
end

return stats
