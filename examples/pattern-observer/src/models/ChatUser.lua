---
--
local chat_member_status = require('bot.enums.chat_member_status')
local Errors = require('src.models.Errors')

local function ChatUser(data, opts)
  local init = opts and opts.init

  local model = {}
  local errors = Errors:new()

  if tonumber(data.user_id) then
    model.user_id = tonumber(data.user_id)
  else
    errors:add {
      field = 'user_id',
      type = 'number',
      code = errors.REQUIRED_FIELD_MISSING
    }
  end

  if tonumber(data.chat_id) then
    model.chat_id = tonumber(data.chat_id)
  else
    errors:add {
      field = 'chat_id',
      type = 'number',
      code = errors.REQUIRED_FIELD_MISSING
    }
  end

  if data.joined_at then
    model.joined_at = data.joined_at
  elseif init then
    model.joined_at = os.time()
  end

  if data.permissions then
    model.permissions = setmetatable(data.permissions, { __serialize = 'map' })
  elseif init then
    model.permissions = setmetatable({}, { __serialize = 'map' })
  end

  if data.status then
    model.status = data.status
  elseif init then
    model.status = chat_member_status.MEMBER
  end

  if data.count_messages then
    model.count_messages = data.count_messages
  elseif init then
    model.count_messages = 0
  end

  if data.count_commands then
    model.count_commands = data.count_commands
  elseif init then
    model.count_commands = 0
  end

  if errors:has_errors() then
    return nil, errors
  end

  return model, nil
end

return ChatUser
