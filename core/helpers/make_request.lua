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
local mp_encode = require 'libs.multipart-post'

local function init(bot, max_connections)
	local client = http.new { max_connections = max_connections or 100 }
	local response = require('core.middlewares.response')(bot)
	
	return function(params)
	    local opts
	    local body, boundary
	    if params.options then
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
		local data = client:request('POST', 'https://api.telegram.org'..string.format("/bot%s/%s", bot.token, params.method), body, opts)

	    local res_body = json.decode(data.body)

	    response(res_body, params.callback)

	    return res_body
	end
end

return init
