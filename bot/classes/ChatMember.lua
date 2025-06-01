--- ChatMember module for handling chat member data
-- @module bot.classes.chatMember
local chatMember = {}
chatMember.__index = chatMember

--- Creates a new chatMember object
-- @param ctx (table) The chat member data
--   - update_id (number): The update ID.
--   - chat_member (table): The chat member data
-- @return (chatMember) The chatMember object
function chatMember:new(ctx)
  local obj = {}
  obj.update_id = ctx.update_id
  obj.chat_member = ctx.chat_member

  return setmetatable(obj, self)
end

--- Gets the update ID
-- @return (number) The update ID
function chatMember:getUpdateId()
  if self.update_id then
    return self.update_id
  end
end

--- Gets the associated chat.
-- @return (table) The associated chat data
function chatMember:getChat()
  if self.chat_member and self.chat_member.chat then
    return self.chat_member.chat
  end
end

--- Gets the chat ID from the associated chat data
-- @return (number) The chat ID
function chatMember:getChatId()
  if self.chat_member and self.chat_member.chat then
    return self.chat_member.chat.id
  end
end

--- Gets the chat type from the associated chat data
-- @return (string) The chat type
function chatMember:getChatType()
  if self.chat_member and self.chat_member.chat then
    return self.chat_member.chat.type
  end
end

--- Gets the user data from the chat member data
-- @return (table) The user data
function chatMember:getUserFrom()
  if self.chat_member and self.chat_member.from then
    return self.chat_member.from
  end
end

--- Gets the user ID from the chat member data
-- @return (number) The user ID
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

--- Gets the new chat member data
-- @return (table) The new chat member data
function chatMember:getNewChatMember()
  if self.chat_member and self.chat_member.new_chat_member then
    return self.chat_member.new_chat_member
  end
end

--- Gets the old chat member data
-- @return (table) The old chat member data
function chatMember:getOldChatMember()
  if self.chat_member and self.chat_member.old_chat_member then
    return self.chat_member.old_chat_member
  end
end

--- Gets the status of the old chat member
-- @return (string) The status of the old chat member
function chatMember:getOldChatMemberStatus()
  if self.chat_member and self.chat_member.old_chat_member then
    return self.chat_member.old_chat_member.status
  end
end

---Gets the status of the new chat member
-- @return (string) The status of the new chat member
function chatMember:getNewChatMemberStatus()
  if self.chat_member and self.chat_member.new_chat_member then
    return self.chat_member.new_chat_member.status
  end
end

setmetatable(chatMember, {
  __call = chatMember.new
})

return chatMember
