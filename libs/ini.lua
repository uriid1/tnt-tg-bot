-- ####--------------------------------####
-- #--# Author:   by uriid1            #--#
-- #--# License:  GNU GPLv3            #--#
-- #--# Telegram: @main_moderator      #--#
-- #--# E-mail:   appdurov@gmail.com   #--#
-- ####--------------------------------####

local fio = require 'fio'

local M = {
    _version = 1.0;
}

-- Type definition
local type_def = function(s)
    -- nil
    if s == nil then
        return nil
    end

    -- number
    local num = tonumber(s)
    if num then
        return num
    end

    -- boolean
    if s == "true" then
        return true
    elseif s == "false" then
        return false
    end

    -- string
    return s
end

-- Load text file
function file_read(path)
    local file = fio.open(path, "O_RDONLY")
    local rfile = file:read()
    file:close()
    return rfile
end

-- Parse ini text
local function parse(str)

    local result   = {}
    local section  = nil

    for line in string.gmatch(str, "[^\n]+") do
        -- Find and add section
        local find_section = line:match("^%[(%S+)%]$")
        if find_section then
            if not result[line] then
                section = find_section
                result[section] = {}
            end
        end

        -- Add key = val
        local key, val = line:match("^(%w+)%s+=%s+(.+)$")
        if key then
            if section then
                result[section][key] = type_def(val)
            else
                result[key] = type_def(val)
            end
        end
    end

    return result
end

-- Load and parse 
function M.parse(path)
    return parse(file_read(path))
end

-- For compatibility with older versions
M.loadParse = M.parse

-- Save ini
-- M.save(table_to_ini, path_to_save)
function M.save(t, path)
    local global = "; Global var\n"
    local default = ""

    -- Parse
    for k, v in pairs(t) do
        if type(t[k]) == "table" then
            default = default .. ("\n[%s]"):format(k)
            for k1, v1 in pairs(t[k]) do
                default = default .. ("\n%s = %s"):format(k1, v1)
            end

            default = default .. "\n"
        else
            global = global .. ("%s = %s\n"):format(k, v)
        end
    end

    -- Save
    local file = fio.open(path, "O_RDONLY")
    file:write(global .. default)
    file:close()
    
    return true
end

return M