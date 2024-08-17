--- ChatMember module for handling chat member data
-- @module classes.chatMember
local chatMember = {}
chatMember.__index = chatMember

--- Creates a new chatMember object
-- @param data (table) Chat member data
-- @return chatMember object
function chatMember:new(data)
  local obj = {}
  obj.update_id = data.update_id
  obj.chat_member = data.chat_member or data.result

  return setmetatable(obj, self)
end

--- Gets the update ID
-- @return (number) The update ID
function chatMember:getUpdateId()
  if self.update_id then
    return self.update_id
  end
end

--- Gets the associated chat
-- @return (table) chat object
function chatMember:getChat()
  if self.chat_member and self.chat_member.chat then
    return self.chat_member.chat
  end
end

--- Gets the chat ID from the associated chat data
-- @return (number) Chat ID
function chatMember:getChatId()
  if self.chat_member and self.chat_member.chat then
    return self.chat_member.chat.id
  end
end

--- Gets the chat type from the associated chat data
-- @return (string) Chat type
function chatMember:getChatType()
  if self.chat_member and self.chat_member.chat then
    return self.chat_member.chat.type
  end
end

--- Gets the user data from the chat member data
-- @return (table) User from object
function chatMember:getUserFrom()
  if self.chat_member and self.chat_member.from then
    return self.chat_member.from
  end
end

--- Gets the user ID from the chat member data
-- @return (number) User ID
function chatMember:getUserFromId()
  if self.chat_member and self.chat_member.from then
    return self.chat_member.from.id
  end
end

--- Gets the date from the chat member data
-- @return (number) The date
function chatMember:getDate()
  if self.chat_member and self.chat_member.date then
    return self.chat_member.date
  end
end

--- Gets the old chat member data
-- @return (table) Old chat member object
function chatMember:getOldChatMember()
  if self.chat_member and self.chat_member.old_chat_member then
    return self.chat_member.old_chat_member.user
  end
end

--- Gets the status of the old chat member
-- @return (string) Status of the old chat member
function chatMember:getOldChatMemberStatus()
  if self.chat_member and self.chat_member.old_chat_member then
    return self.chat_member.old_chat_member.status
  end
end

--- Gets the new chat member data
-- @return (table) New chat member object
function chatMember:getNewChatMember()
  if self.chat_member and self.chat_member.new_chat_member then
    return self.chat_member.new_chat_member.user
  end
end

--- Gets the status of the new chat member
-- @return (string) Status of the new chat member
function chatMember:getNewChatMemberStatus()
  if self.chat_member and self.chat_member.new_chat_member then
    return self.chat_member.new_chat_member.status
  end
end

setmetatable(chatMember, { __call = chatMember.new })

return chatMember
