--- Message module for handling message data
-- @module classes.message
local message = {}
message.__index = message

--- Creates a new message object
-- @param data (table) Message data
-- @return (message) Message object
function message:new(data)
  local obj = {}
  obj.update_id = data.update_id
  obj.message = data.message or data.result

  return setmetatable(obj, self)
end

--- Gets the update ID
-- @return (number) Update ID
function message:getUpdateId()
  if self.update_id then
    return self.update_id
  end
end

--- Gets the message data
-- @return (table) Message object
function message:getMessage()
  return self.message
end

--- Gets the arguments from the callback query data
-- @param opts (table) Options table
  -- @param[opt] opts.separator Separator to split the data (default is ' ')
  -- @param[opt] opts.count Maximum number of arguments to retrieve (default is 10)
--
-- @return (table) Arguments as a table
function message:getArguments(opts)
  if self.message and self.message.text then
    local separator = opts.separator or ' '
    local count = opts.count or 10
    return self.message.text:split(separator, count)
  end
end

--- Get the chat information from the message object
-- @return (table) Chat object
function message:getChat()
  if self.message and self.message.chat then
    return self.message.chat
  end
end

--- Gets the chat ID from the message data
-- @return (number) Chat ID
function message:getChatId()
  if self.message and self.message.chat then
    return self.message.chat.id
  end
end

--- Gets the chat type from the message data
-- @return (string) Chat type
function message:getChatType()
  if self.message and self.message.chat then
    return self.message.chat.type
  end
end

--- Gets the message ID from the message data
-- @return (number) Message ID
function message:getMessageId()
  if self.message and self.message.message_id then
    return self.message.message_id
  end
end

--- Gets the text from the message data
-- @return (string) Message text
function message:getText()
  if self.message and self.message.text then
    return self.message.text
  end
end

--- Gets the user data from the message data
-- @return (table) User object
function message:getUserFrom()
  if self.message and self.message.from then
    return self.message.from
  end
end

--- Gets the user ID from the message data
-- @return (number) User ID
function message:getUserFromId()
  if self.message and self.message.from then
    return self.message.from.id
  end
end

--- Gets the user who replied to the message
-- @return (table) User object
function message:getUserReply()
  if self.message and self.message.reply_to_message and self.message.reply_to_message.from then
    return self.message.reply_to_message.from
  end
end

--- Gets the user ID reply to the message
-- @return (number) User ID
function message:getUserReplyId()
  if self.message and self.message.reply_to_message and self.message.reply_to_message.from then
    return self.message.reply_to_message.from.id
  end
end

--- Gets the reply to message data
-- @return (table) Reply to message object
function message:getReplyToMessage()
  if self.message and self.message.reply_to_message then
    return self.message.reply_to_message
  end
end

--- Gets the reply to message id
-- @return (number) Reply to message id
function message:getReplyToMessageId()
  if self.message and self.message.reply_to_message then
    return self.message.reply_to_message.message_id
  end
end

--- Gets the entities from the message data
-- @return (table) Message entities
function message:getEntities()
  if self.message and self.message.entities then
    return self.message.entities
  end
end

--- Gets the dice
-- @return (table) Dice object
function message:getDice()
  if self.message and self.message.dice then
    return self.message.dice
  end
end

--- Gets the date
-- @return (number) Date
function message:getDate()
  if self.message and self.message.date then
    return self.message.date
  end
end

--- Gets the left chat member data from the message data
-- @return (table) Left chat member object
function message:getLeftChatMember()
  if self.message and self.message.left_chat_member then
    return self.message.left_chat_member
  end
end

--- Gets the new chat member data from the message data
-- @return (table) New chat member object
function message:getNewChatMember()
  if self.message and self.message.new_chat_member then
    return self.message.new_chat_member
  end
end

--- Gets the new chat members data from the message data
-- @return (table) New chat members object
function message:getNewChatMembers()
  if self.message and self.message.new_chat_members then
    return self.message.new_chat_members
  end
end

--- Checks if the message sender is a new chat member
-- True if the sender is a new chat member, false otherwise
-- @return (boolean) true or false
function message:isNewChatMember()
  if self.message and self.message.new_chat_members then
    return self.message.new_chat_members[1].id == self.message.from.id
  end
end

--- Checks if the message sender added a new chat member
-- True if the sender added a new chat member, false otherwise
-- @return (boolean) true or false
function message:isAddNewChatMember()
  if self.message and self.message.new_chat_members then
    return self.message.new_chat_members[1].id ~= self.message.from.id
  end
end

--- Checks if the message sender is a left chat member
-- True if the sender is a left chat member, false otherwise
-- @return (boolean) true or false
function message:isLeftMember()
  if self.message and self.message.left_chat_member then
    return self.message.left_chat_member.id == self.message.from.id
  end
end

--- Checks if the message sender removed a chat member
-- True if the sender removed a chat member, false otherwise
-- @return (boolean) true or false
function message:isRemoveMember()
  if self.message and self.message.left_chat_member then
    return self.message.left_chat_member.id ~= self.message.from.id
  end
end

--- Gets the sender chat
-- @return (table) Sender chat object
function message:getSenderChat()
  if self.message and self.message.sender_chat then
    return self.message.sender_chat
  end
end

--- Gets the sender chat id
-- @return (number) Sender chat id
function message:getSenderChatId()
  if self.message and self.message.sender_chat then
    return self.message.sender_chat.id
  end
end

--- Trim the command
-- @return (text)
function message:trimCommand()
  if self.message and self.message.text and self.__command then
    local res = self.message.text:gsub(self.__command..' ', '', 1)
    return res
  end
end

setmetatable(message, {
  __call = message.new
})

return message
