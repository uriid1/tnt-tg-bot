--[[
  ####--------------------------------####
  #--# Author:   by uriid1            #--#
  #--# license:  GNU GPL              #--#
  ####--------------------------------####
--]]

local string = string
local table = table
local pairs = pairs
local tostring = tostring

local function format(resTable, formatString, value)
  if value == nil then
    table.insert(resTable, formatString)
    return
  end

  -- formatString exists
  table.insert(resTable, string.format(formatString, value))
end

local function append_data(resTable, name, data, extra)
  format(resTable, "content-disposition: form-data; name=\"%s\"", name)

  if extra then
    if extra.filename then
      format(resTable, "; filename=\"%s\"", extra.filename)
    end

    if extra.content_type then
      format(resTable, "\r\ncontent-type: %s", extra.content_type)
    end

    if extra.content_transfer_encoding then
      format(resTable, "\r\ncontent-transfer-encoding: %s", extra.content_transfer_encoding)
    end
  end

  format(resTable, "\r\n\r\n")
  format(resTable, data)
  format(resTable, "\r\n")
end

local function switch_type(resTable, key, val, errs)
  local type = type(val)

  if type == 'string' then
    append_data(resTable, key, val)
  elseif type == 'number' then
    append_data(resTable, key, val)
  elseif type == 'boolean' then
    append_data(resTable, key, tostring(val))
  elseif type == 'table' then
    if not val.data then
      table.insert(errs, {
        type = 'Error';
        info = '\'data\' not provided';
      })
      return
    end

    append_data(resTable, key, val.data, {
      filename = val.filename or val.name;
      content_type = val.content_type or val.mimetype or "application/octet-stream";
      content_transfer_encoding = val.content_transfer_encoding or "binary";
    })
  end
end

-- Generate boundary
local gen_boundary = function()
  local res = { "BOUNDARY-" }

  for i = 2, 17 do
    res[i] = string.char(math.random(65, 90))
  end
  table.insert(res, "-BOUNDARY")

  return table.concat(res)
end

-- Encode
local function encode(body)
  if type(body) ~= 'table' then
    return nil, nil, nil
  end

  -- Gen
  local boundary = gen_boundary()
  local errs = {}
  local resTable = {}

  for key, val in pairs(body) do
    format(resTable, "--%s\r\n", boundary)
    switch_type(resTable, key, val, errs)
  end
  format(resTable, "--%s--\r\n", boundary)

  return table.concat(resTable), boundary, errs
end

return encode
