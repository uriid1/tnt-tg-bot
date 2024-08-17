--- Process incoming data and create corresponding objects
--
local Message = require('core.classes.message')
local Callback = require('core.classes.callback')
local ChatMember = require('core.classes.chatMember')
local MyChatMember = require('core.classes.myChatMember')

local processMessage

---
-- @function processMessage
-- @param data (table) Response from the Telegram Bot API
function processMessage(data)
  if data.message then
    return Message(data)
  elseif data.callback_query then
    return Callback(data)
  elseif data.chat_member then
    return ChatMember(data)
  elseif data.my_chat_member then
    return MyChatMember(data)
  end

  return data
end

return processMessage
