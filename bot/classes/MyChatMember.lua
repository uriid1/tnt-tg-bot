--- Module myChatMember
-- @module bot.classes.myChatMember

local myChatMember = {}
myChatMember.__index = myChatMember

--- Creates a new myChatMember object
-- @param ctx The data for initializing the object
-- @return The created myChatMember object
function myChatMember:new(ctx)
  local obj = {}
  obj.update_id = ctx.update_id
  obj.my_chat_member = ctx.my_chat_member

  return setmetatable(obj, self)
end

--- Get the update ID from the myChatMember object
-- @return The update ID
function myChatMember:getUpdateId()
  if self.update_id then
    return self.update_id
  end
end

--- Get the chat information from the myChatMember object
-- @return The chat information
function myChatMember:getChat()
  if self.my_chat_member and self.my_chat_member.chat then
    return self.my_chat_member.chat
  end
end

--- Get the chat ID from the myChatMember object
-- @return The chat ID
function myChatMember:getChatId()
  if self.my_chat_member and self.my_chat_member.chat then
    return self.my_chat_member.chat.id
  end
end

--- Get the chat type from the myChatMember object
-- @return The chat type
function myChatMember:getChatType()
  if self.my_chat_member and self.my_chat_member.chat then
    return self.my_chat_member.chat.type
  end
end

--- Get the user information from the myChatMember object
-- @return The user information
function myChatMember:getUserFrom()
  if self.my_chat_member and self.my_chat_member.from then
    return self.my_chat_member.from
  end
end

--- Get the user ID from the myChatMember object
-- @return The user ID
function myChatMember:getUserFromId()
  if self.my_chat_member and self.my_chat_member.from then
    return self.my_chat_member.from.id
  end
end

--- Get the date from the myChatMember object
-- @return The date
function myChatMember:getDate()
  if self.my_chat_member and self.my_chat_member.date then
    return self.my_chat_member.date
  end
end

--- Get the old chat member information from the myChatMember object
-- @return The old chat member information
function myChatMember:getOldChatMember()
  if self.my_chat_member and self.my_chat_member.old_chat_member then
    return self.my_chat_member.old_chat_member
  end
end

--- Get the new chat member information from the myChatMember object
-- @return The new chat member information
function myChatMember:getNewChatMember()
  if self.my_chat_member and self.my_chat_member.new_chat_member then
    return self.my_chat_member.new_chat_member
  end
end

--- Get the status of the new chat member from the myChatMember object
-- @return The status of the new chat member
function myChatMember:getNewChatMemberStatus()
  if self.my_chat_member and self.my_chat_member.new_chat_member then
    return self.my_chat_member.new_chat_member.status
  end
end

--- Get the status of the old chat member from the myChatMember object
-- @return The status of the old chat member
function myChatMember:getOldChatMemberStatus()
  if self.my_chat_member and self.my_chat_member.old_chat_member then
    return self.my_chat_member.old_chat_member.status
  end
end

setmetatable(myChatMember, {
  __call = myChatMember.new
})

return myChatMember
