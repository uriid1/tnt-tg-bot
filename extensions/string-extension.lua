--[[
    ####--------------------------------####
    #--# Author:   by uriid1            #--#
    #--# License:  GNU GPLv3            #--#
    #--# Telegram: @main_moderator      #--#
    #--# E-mail:   appdurov@gmail.com   #--#
    ####--------------------------------####
--]]

--- ("Hello")[1] -> H
debug.getmetatable("").__index = function(self, n)
    if type(n) == "number" then
        return self:sub(n, n)
    end

    return string[n]
end

-- AAABBBCCC -> ABC
string.delrep = function(text, optional)
    local sub    = optional and optional.sub    or string.sub
    local gmatch = optional and optional.gmatch or string.gmatch

    local cs = sub(text, 1, 1)
    local r = cs

    for s in gmatch(text, ".") do
        if cs ~= s then
            cs = s
            r = r .. cs
        end
    end

    return r
end

-- ("Hello World!"):slpit(' ') -> { [1] = 'Hello'; [2] = 'World!' }
string.split = function(text, sep, max)
    local result = {}
    local i = 1

    for s in text:gmatch("[^"..sep.."]+") do
        result[i] = s

        if i == max then
            break
        end

        i = i + 1
    end

    return result
end

-- ("    Hello  "):trim() -> Hello
string.trim = function(text)
    return text:match("^%s*(.-)%s*$")
end

-- Sub s
assert(("Hello")[1] == "H", "ERROR SUB first symbol not 'H'")
-- Delete rep
assert(("AABBBCCCCD"):delrep() == "ABCD", "ERROR DELREP result not 'ABCD'")
-- Split
assert(("Hello World"):split(" ")[1] == "Hello", "ERROR SPLIT result not 'Hello'")
-- Trim
assert(("    Hello  World!   "):trim() == "Hello  World!", "ERROR TRIM result not 'Hello  World!'")
