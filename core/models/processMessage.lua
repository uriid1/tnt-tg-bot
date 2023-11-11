---
-- Process incoming data and create corresponding objects.
-- @module processMessage

local message = require 'core.classes.message'
local callback = require 'core.classes.callback'
local chatMember = require 'core.classes.chatMember'
local myChatMember = require 'core.classes.myChatMember'

local function processMessage(data)
  if data.message then
    return message(data)
  elseif data.callback_query then
    return callback(data)
  elseif data.chat_member then
    return chatMember(data)
  elseif data.my_chat_member then
    return myChatMember(data)
  end

  return data
end

return processMessage
