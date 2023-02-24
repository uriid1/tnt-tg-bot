--[[
    ####--------------------------------####
    #--# Author:   by uriid1            #--#
    #--# License:  GNU GPLv3            #--#
    #--# Telegram: @main_moderator      #--#
    #--# E-mail:   appdurov@gmail.com   #--#
    ####--------------------------------####
--]]

local pairs         = pairs
local tostring      = tostring
local os_time       = os.time
local string_format = string.format
local table_concat  = table.concat

---------------------------------------
------------- Formating  --------------
---------------------------------------
local function table_print_format(t_gen, p, s)
  if s == nil then
    t_gen[#t_gen + 1] = p
    return
  end

  -- If 's' is exists
  t_gen[#t_gen + 1] = string_format(p, s)
end

---------------------------------------
------------ Append Data  -------------
---------------------------------------
local function append_data(t_gen, key, data, extra)
  table_print_format(t_gen, "content-disposition: form-data; name=\"%s\"", key)
  if extra.filename then
    table_print_format(t_gen, "; filename=\"%s\"", extra.filename)
  end

  if extra.content_type then
    table_print_format(t_gen, "\r\ncontent-type: %s", extra.content_type)
  end

  if extra.content_transfer_encoding then
    table_print_format(t_gen, "\r\ncontent-transfer-encoding: %s", extra.content_transfer_encoding)
  end

  table_print_format(t_gen, "\r\n\r\n")
  table_print_format(t_gen, data)
  table_print_format(t_gen, "\r\n")
end

--------------------------------------
------------ Switch type -------------
--------------------------------------
local t_switch_type = {
  ["string"] = function(val, key, t_gen)
      append_data(t_gen, key, val, {})
  end;

  ["table"] = function(val, key, t_gen)
      append_data(t_gen, key, val.data, {
        filename                  = val.filename or val.name;
        content_type              = val.content_type or val.mimetype or "application/octet-stream";
        content_transfer_encoding = val.content_transfer_encoding or "binary";
      })
  end;

  ["number"] = function(val, key, t_gen)
      append_data(t_gen, key, val, {})
  end;

  ["boolean"] = function(val, key, t_gen)
      append_data(t_gen, key, tostring(val), {})
  end
}

--
local function switch_type(type, val, key, t_gen)
  if t_switch_type[type] == nil then
    error(string_format("unexpected type %s", type))
  end

  t_switch_type[type](val, key, t_gen)
end

---------------------------------
------------ Encode -------------
---------------------------------
local function encode(request_body)
  if not request_body then
    return
  end

  -- Gen
  local boundary = "TG" .. os_time() .. "tg"
  local t_gen = {}

  for key, val in pairs(request_body) do
    table_print_format(t_gen, "--%s\r\n", boundary)
    switch_type(type(val), val, key, t_gen)
  end
  table_print_format(t_gen, "--%s--\r\n", boundary)

  return table_concat(t_gen), boundary
end

return encode
