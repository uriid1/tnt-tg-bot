--- Message module for handling message data
-- @module bot.classes.message

local SuccessfulPayment = require('bot.classes.SuccessfulPayment')

local message = {}
message.__index = message

--- Creates a new message object
-- @param ctx (table) The message data
--   - update_id (number): The update ID.
--   - message (table): The message data
-- @param opts (table)
--
-- @return (message) The message object
function message:new(ctx, opts)
  local obj = {}

  local update_id
  local refMessage

  if opts and opts.direct then
    refMessage = ctx
  else
    update_id = ctx.update_id
    refMessage = ctx.message
  end

  obj.update_id = update_id
  obj.message = refMessage

  if ctx.message then
    if ctx.message.successful_payment then
      obj.message.successful_payment = SuccessfulPayment(ctx.message.successful_payment)
    end
  end

  return setmetatable(obj, self)
end

--- Gets the update ID
-- @return (number) The update ID
function message:getUpdateId()
  if self.update_id then
    return self.update_id
  end
end

--- Gets the self data
-- @return (table) The self data
function message:getMessage()
  return self
end

--- Gets the arguments from the message text.
-- @param opts (table) Options table.
--   - separator (string, optional): The separator to split the text (default is ' ').
--   - count (number, optional): The maximum number of arguments to retrieve (default is 10).
--
-- @return (table) The arguments as a table
function message:getArguments(opts)
  if self.message and self.message.text then
    local separator = opts.separator or ' '
    local count = opts.count or 10
    return self.message.text:split(separator, count)
  end
end

--- Get the chat information from the message object
-- @return The chat information
function message:getChat()
  if self.message and self.message.chat then
    return self.message.chat
  end
end

--- Gets the chat ID from the message data
-- @return (number) The chat ID
function message:getChatId()
  if self.message and self.message.chat then
    return self.message.chat.id
  end
end

--- Gets the chat type from the message data
-- @return (string) The chat type
function message:getChatType()
  if self.message and self.message.chat then
    return self.message.chat.type
  end
end

--- Gets the message ID from the message data
-- @return (number) The message ID
function message:getMessageId()
  if self.message and self.message.message_id then
    return self.message.message_id
  end
end

--- Gets the text from the message data
-- @return (string) The message text
function message:getText()
  if self.message and self.message.text then
    return self.message.text
  end
end

--- Gets the user data from the message data
-- @return (table) The user data
function message:getUserFrom()
  if self.message and self.message.from then
    return self.message.from
  end
end

--- Gets the user ID from the message data
-- @return (number) The user ID
function message:getUserFromId()
  if self.message and self.message.from then
    return self.message.from.id
  end
end

--- Gets the user who replied to the message
-- @return (table) The user data of the reply
function message:getUserReply()
  if self.message and self.message.reply_to_message and self.message.reply_to_message.from then
    return self.message.reply_to_message.from
  end
end

--- message.external_reply.origin
-- @return message.external_reply.origin
function message:getExternalReply()
  if self.message and self.message.external_reply and self.message.external_reply.origin then
    return self.message.external_reply.origin
  end
end

--- message.reply_to_message
-- @return (number)
function message:getUserReplyId()
  if self.message and self.message.reply_to_message and self.message.reply_to_message.from then
    return self.message.reply_to_message.from.id
  end
end

--- message.reply_to_message
-- @return (table)
function message:getReplyToMessage()
  if self.message and self.message.reply_to_message then
    return self.message.reply_to_message
  end
end

--- reply_to_message.message_id
-- @return (number)
function message:getReplyToMessageId()
  if self.message and self.message.reply_to_message then
    return self.message.reply_to_message.message_id
  end
end

--- Gets the entities from the message data
-- @return (table) The message entities
function message:getEntities()
  if self.message and self.message.entities then
    return self.message.entities
  end
end

--- message.dice
-- @return (string)
function message:getDice()
  if self.message and self.message.dice then
    return self.message.dice
  end
end

--- message.date
-- @return (table)
function message:getDate()
  if self.message and self.message.date then
    return self.message.date
  end
end

-- START DEPRECATED BLOCK
--
-- Этот блок, стоило бы не делать, так как -
-- left_chat_member и new_chat_member должны быть отдельными классами.
-- Но оставим ради поддержки старой версии библиотеки.
--

--- Gets the left chat member data from the message data
-- @return (table) The left chat member data
function message:getLeftChatMember()
  if self.message and self.message.left_chat_member then
    return self.message.left_chat_member
  end
end

--- Gets the new chat member data from the message data
-- @return (table) The new chat member data
function message:getNewChatMember()
  if self.message and self.message.new_chat_member then
    return self.message.new_chat_member
  end
end

--- Gets the new chat members data from the message data
-- @return (table) The new chat members data
function message:getNewChatMembers()
  if self.message and self.message.new_chat_members then
    return self.message.new_chat_members
  end
end

--- Checks if the message sender is a new chat member
-- @return (boolean) True if the sender is a new chat member, false otherwise
function message:isNewChatMember()
  if self.message and self.message.new_chat_members then
    return self.message.new_chat_members[1].id == self.message.from.id
  end
end

--- Checks if the message sender added a new chat member
-- @return (boolean) True if the sender added a new chat member, false otherwise
function message:isAddNewChatMember()
  if self.message and self.message.new_chat_members then
    return self.message.new_chat_members[1].id ~= self.message.from.id
  end
end

--- Checks if the message sender is a left chat member
-- @return (boolean) True if the sender is a left chat member, false otherwise
function message:isLeftMember()
  if self.message and self.message.left_chat_member then
    return self.message.left_chat_member.id == self.message.from.id
  end
end

--- Checks if the message sender removed a chat member
-- @return (boolean) True if the sender removed a chat member, false otherwise
function message:isRemoveMember()
  if self.message and self.message.left_chat_member then
    return self.message.left_chat_member.id ~= self.message.from.id
  end
end
--
-- END DEPRECATED BLOCK

--- message.sender_chat
-- @return message.sender_chat
function message:getSenderChat()
  if self.message and self.message.sender_chat then
    return self.message.sender_chat
  end
end

--- message.sender_chat.id
-- @return message.sender_chat.id
function message:getSenderChatId()
  if self.message and self.message.sender_chat then
    return self.message.sender_chat.id
  end
end

function message:getSuccessfulPayment()
  return self.message.successful_payment
end

--- Trim Command
-- @return trimCommand
function message:trimCommand()
  if self.message and self.message.text and self.__command then
    local res, count = self.message.text:gsub(self.__command..' ', '', 1)
    return res, count
  end
end

setmetatable(message, {
  __call = message.new
})

return message
