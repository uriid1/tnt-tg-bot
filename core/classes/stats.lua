--[[
    ####--------------------------------####
    #--# Author:   by uriid1            #--#
    #--# License:  GNU GPLv3            #--#
    #--# Telegram: @main_moderator      #--#
    #--# E-mail:   appdurov@gmail.com   #--#
    ####--------------------------------####
--]]

-- Class definition
local stats = {}

stats.__index = stats
function stats:new()
    return setmetatable({}, self)
end

function stats:append(name, max_count)
    self[name] = {
        count = max_count or 10;
        parts = {};
    }
end

function stats:set(name, val)
    if not self[name] then
        return
    end

    if #self[name] == self.count then
        table.remove(self[name].parts, self.count)
    end

    table.insert(self[name].parts, val)
end

function stats:get(name)
    if not self[name] then
        return
    end

    local sum = 0
    for i = 1, #self[name].parts do
        sum = sum + self[name].parts[i]
    end

    return sum/#self[name].parts
end

return stats
