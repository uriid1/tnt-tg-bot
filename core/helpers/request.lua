--[[
    ####--------------------------------####
    #--# Author:   by uriid1            #--#
    #--# License:  GNU GPLv3            #--#
    #--# Telegram: @main_moderator      #--#
    #--# E-mail:   appdurov@gmail.com   #--#
    ####--------------------------------####
--]]

local json = require 'json'
local http = require 'http.client'
local mp_encode = require 'libs.lua-multipart-post.multipart-post'

local function init(bot, max_connections)
    local Error = require 'core.middlewares.Error'(bot)
    local client = http.new { max_connections = max_connections or 100 }
    
    return function(params)
        local opts
        local body
        local boundary

        if params.options then
            -- Set parse mode
            if params.options.text or
                params.options.caption
            then
                params.options.parse_mode = bot.parse_mode
            end

            -- Make multipart-data
            body, boundary = mp_encode(params.options)

            -- Make headers
            opts = {
                headers = {
                    ['Content-Type'] = "multipart/form-data; boundary="..boundary;
                }
            }
        end

        -- Request
        local url = 'https://api.telegram.org'..string.format("/bot%s/%s", bot.token, params.method)
        local data = client:request('POST', url, body, opts)

        -- Decode json
        local responceBody = json.decode(data.body)

        -- Handle error
        if not responceBody.ok then
            Error(responceBody)
            return
        end

        return responceBody
    end
end

return init
