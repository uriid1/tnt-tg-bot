---
-- Message module for handling message data.
-- @module message
local message = {}
message.__index = message

---
-- Creates a new message object.
-- @param data (table) The message data.
--   - update_id (number): The update ID.
--   - message (table): The message data.
--
-- @return (message) The message object.
function message:new(data)
  local obj = {}
  obj.update_id = data.update_id
  obj.message = data.message or data.result

  return setmetatable(obj, self)
end

---
-- Gets the update ID.
-- @return (number) The update ID.
function message:getUpdateId()
  if self.update_id then
    return self.update_id
  end
end

---
-- Gets the message data.
-- @return (table) The message data.
function message:getMessage()
  return self.message
end

---
-- Gets the arguments from the message text.
-- @param opts (table) Options table.
--   - separator (string, optional): The separator to split the text (default is ' ').
--   - count (number, optional): The maximum number of arguments to retrieve (default is 10).
--
-- @return (table) The arguments as a table.
function message:getArguments(opts)
  if self.message and self.message.text then
    local separator = opts.separator or ' '
    local count = opts.count or 10
    return self.message.text:split(separator, count)
  end
end

---
-- Get the chat information from the message object.
-- @return The chat information.
function message:getChat()
  if self.message and self.message.chat then
    return self.message.chat
  end
end

---
-- Gets the chat ID from the message data.
-- @return (number) The chat ID.
function message:getChatId()
  if self.message and self.message.chat then
    return self.message.chat.id
  end
end

---
-- Gets the chat type from the message data.
-- @return (string) The chat type.
function message:getChatType()
  if self.message and self.message.chat then
    return self.message.chat.type
  end
end

---
-- Gets the message ID from the message data.
-- @return (number) The message ID.
function message:getMessageId()
  if self.message and self.message.message_id then
    return self.message.message_id
  end
end

---
-- Gets the text from the message data.
-- @return (string) The message text.
function message:getText()
  if self.message and self.message.text then
    return self.message.text
  end
end

---
-- Gets the user data from the message data.
-- @return (table) The user data.
function message:getUserFrom()
  if self.message and self.message.from then
    return self.message.from
  end
end

---
-- Gets the user ID from the message data.
-- @return (number) The user ID.
function message:getUserFromId()
  if self.message and self.message.from then
    return self.message.from.id
  end
end

---
-- Gets the user who replied to the message.
-- @return (table) The user data of the reply.
function message:getUserReply()
  if self.message and self.message.reply_to_message and self.message.reply_to_message.from then
    return self.message.reply_to_message.from
  end
end

---
-- message.reply_to_message
-- @return (number)
function message:getUserReplyId()
  if self.message and self.message.reply_to_message and self.message.reply_to_message.from then
    return self.message.reply_to_message.from.id
  end
end

---
-- message.reply_to_message
-- @return (table)
function message:getReplyToMessage()
  if self.message and self.message.reply_to_message then
    return self.message.reply_to_message
  end
end

---
-- Gets the entities from the message data.
-- @return (table) The message entities.
function message:getEntities()
  if self.message and self.message.entities then
    return self.message.entities
  end
end

---
-- Gets the left chat member data from the message data.
-- @return (table) The left chat member data.
function message:getLeftChatMember()
  if self.message and self.message.left_chat_member then
    return self.message.left_chat_member
  end
end

---
-- Gets the new chat member data from the message data.
-- @return (table) The new chat member data.
function message:getNewChatMember()
  if self.message and self.message.new_chat_member then
    return self.message.new_chat_member
  end
end

---
-- Gets the new chat members data from the message data.
-- @return (table) The new chat members data.
function message:getNewChatMembers()
  if self.message and self.message.new_chat_members then
    return self.message.new_chat_members
  end
end

---
-- Checks if the message sender is a new chat member.
-- @return (boolean) True if the sender is a new chat member, false otherwise.
function message:isNewChatMember()
  if self.message and self.message.new_chat_members then
    return self.message.new_chat_members[1].id == self.message.from.id
  end
end

---
-- Checks if the message sender added a new chat member.
-- @return (boolean) True if the sender added a new chat member, false otherwise.
function message:isAddNewChatMember()
  if self.message and self.message.new_chat_members then
    return self.message.new_chat_members[1].id ~= self.message.from.id
  end
end

---
-- Checks if the message sender is a left chat member.
-- @return (boolean) True if the sender is a left chat member, false otherwise.
function message:isLeftMember()
  if self.message and self.message.left_chat_member then
    return self.message.left_chat_member.id == self.message.from.id
  end
end

---
-- Checks if the message sender removed a chat member.
-- @return (boolean) True if the sender removed a chat member, false otherwise.
function message:isRemoveMember()
  if self.message and self.message.left_chat_member then
    return self.message.left_chat_member.id ~= self.message.from.id
  end
end

---
-- @return (test)
function message:trimCommand()
  if self.message and self.message.text and self.message.__command then
    return self.message.text:gsub(self.message.__command..' ', '', 1)
  end
end

setmetatable(message, { __call = message.new })

return message
