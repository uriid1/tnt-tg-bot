---
--
local chat_member_status = require('bot.enums.chat_member_status')
local Errors = require('src.models.Errors')

local function Chat(data, opts)
  local init = opts and opts.init

  local model = {}
  local errors = Errors:new()

  if tonumber(data.id) then
    model.id = tonumber(data.id)
  else
    errors:add {
      field = 'id',
      type = 'number',
      code = errors.REQUIRED_FIELD_MISSING
    }
  end

  if data.username then
    model.username = data.username
  else
    model.username = box.NULL
  end

  if data.type then
    model.type = tostring(data.type)
  else
    errors:add {
      field = 'type',
      type = 'number',
      code = errors.REQUIRED_FIELD_MISSING
    }
  end

  if data.title then
    model.title = data.title
  else
    errors:add {
      field = 'title',
      type = 'string',
      code = errors.REQUIRED_FIELD_MISSING
    }
  end

  if data.is_forum ~= nil then
    model.is_forum = data.is_forum and true or false
  elseif init then
    model.is_forum = false
  end

  if data.member_count then
    model.member_count = data.member_count
  elseif init then
    model.member_count = 0
  end

  if data.bot_status then
    model.bot_status = data.bot_status
  elseif init then
    model.bot_status = chat_member_status.MEMBER
  end

  if data.joined_at then
    model.joined_at = data.joined_at
  elseif init then
    model.joined_at = os.time()
  end

  if data.options then
    model.options = setmetatable(data.options, { __serialize = 'map' })
  elseif init then
    model.options = setmetatable({}, { __serialize = 'map' })
  end

  if errors:has_errors() then
    return nil, errors
  end

  return model, nil
end

-- local model, errs = Chat({
--   id = uuid()
-- }, { init = true })

-- require('pimp')(model)
-- if errs then
--   require('pimp')(errs)
--   require('pimp')(errs:to_string())
-- end

return Chat
