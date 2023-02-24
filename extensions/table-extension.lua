--[[
    ####--------------------------------####
    #--# Author:   by uriid1            #--#
    #--# License:  GNU GPLv3            #--#
    #--# Telegram: @main_moderator      #--#
    #--# E-mail:   appdurov@gmail.com   #--#
    ####--------------------------------####
--]]

local type = type
local next = next 
local insert = table.insert
local remove = table.remove
local concat = table.concat
local random = math.random

-- table.isEmpty({}) -> true
function table.isEmpty(t)
    return not next(t)
end

-- table.isTable({}) -> true
function table.isTable(t)
    return type(t) == 'table'
end

-- table.isArray({'foo', 'bar'}) -> true
function table.isArray(t)
    if type(t) ~= 'table' then
        return false
    end

    local i = 1
    for _ in next, t do
        if t[i] == nil then
            return false
        end

        i = i + 1
    end

    return true
end

-- table.push({}, 'foo') -> {[1] = 'foo'}
function table.push(t, item)
    insert(t, #t+1, item)
end

-- Returns the first element of the table
-- then deletes it by making an offset
-- table.shift({ [1] = 'foo'; [2] = 'bar' }) -> foo
-- { [1]='bar' }
function table.shift(t)
    local tmp = {}
    insert(tmp, t[1])
    remove(t, 1)
    return tmp[1] or {}
end

-- Merging table t2 into t1
-- Is not deep copy
function table.merge(t1, t2)
    for k, v in next, t2 do
        t1[k] = v
    end
end

-- Reverse the table
function table.reverse(t)
    local tbl = {}
    for i = #t, 1, -1 do
        insert(tbl, #tbl+1, t[i])
    end
    return tbl
end

-- fills all elements of the array from the start to the
-- end(done) indexes with a single value
function table.fill(t, value, start, done)
    for i = start, done do
        t[i] = value
    end
end

-- returns a string representation of array elements
function table.toString(t, sep, start, done)
    return concat(t, sep or ',', start or 1, done or #t)
end

-- Shuffles the table
function table.shake(t)
    for i = #t, 1, -1 do
        local rnd_index = random(i)
        t[rnd_index], t[i] = t[i], t[rnd_index]
    end
end
