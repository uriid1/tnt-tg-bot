--- Callback class for handling callback queries
-- @module classes.callback
local callback = {}
callback.__index = callback

--- Creates a new callback object
-- @param data (table) Callback query data
-- @return (table) Callback object
function callback:new(data)
  local obj = {}
  obj.update_id = data.update_id
  obj.message = data.callback_query.message or (data.result and data.result.message)
  obj.callback_query = data.callback_query or data.result
  obj.is_callback_query = true

  return setmetatable(obj, self)
end

--- Gets the update ID
-- @return (number) Update ID
function callback:getUpdateId()
  if self.update_id then
    return self.update_id
  end
end

--- Gets the callback query ID
-- @return (string) Callback query ID
function callback:getQueryId()
  if self.callback_query then
    return self.callback_query.id
  end
end

--- Gets the associated message
-- @return (table) Message object
function callback:getMessage()
  return self.message
end

--- Gets the arguments from the callback query data
-- @param opts (table) Options table
  -- @param[opt] opts.separator Separator to split the data (default is ' ')
  -- @param[opt] opts.count Maximum number of arguments to retrieve (default is 10)
--
-- @return (table) Arguments as a table.
function callback:getArguments(opts)
  if self.callback_query then
    local separator = opts.separator or ' '
    local count = opts.count or 10
    return self.callback_query.data:split(separator, count)
  end
end

--- Gets the chat  from the associated message
-- @return (number) Chat object
function callback:getChat()
  if self.message and self.message.chat then
    return self.message.chat
  end
end

--- Gets the chat ID from the associated message
-- @return (number) Chat ID
function callback:getChatId()
  if self.message and self.message.chat then
    return self.message.chat.id
  end
end

--- Gets the chat type from the associated message
-- @return (string) Chat type
function callback:getChatType()
  if self.message and self.message.chat then
    return self.message.chat.type
  end
end

--- Gets the message ID from the associated message
-- @return (number) Message ID
function callback:getMessageId()
  if self.message and self.message.message_id then
    return self.message.message_id
  end
end

--- Gets the text from the associated message
-- @return (string) Message text
function callback:getText()
  if self.message and self.message.text then
    return self.message.text
  end
end

--- Gets the user data from the callback query
-- @return (table) User object
function callback:getUserFrom()
  if self.callback_query and self.callback_query.from then
    return self.callback_query.from
  end
end

--- Gets the user ID from the callback query
-- @return (number) User ID
function callback:getUserFromId()
  if self.callback_query and self.callback_query.from then
    return self.callback_query.from.id
  end
end

--- Gets the user data from the associated message
-- @return (table) User object
function callback:getUserMessageFrom()
  if self.message and self.message.from then
    return self.message.from
  end
end

--- Gets the user who replied to the associated message
-- @return (table) User object
function callback:getUserReply()
  if self.message and self.message.reply_to_message then
    return self.message.reply_to_message.from
  end
end

--- Gets the reply to message
-- @return (table) Message object
function callback:getReplyToMessage()
  if self.message and self.message.reply_to_message then
    return self.message.reply_to_message
  end
end

--- Checks if the user who sent the callback query
-- is the same as the one who replied to the associated message
-- @return (boolean) true or false
function callback:isSameUser()
  if self.callback_query and self.callback_query.from and
    self.message and self.message.reply_to_message
  then
    return self.callback_query.from.id == self.message.reply_to_message.from.id
  end
end

--- Gets the inline keyboard
-- @return (table) inline keyboard object
function callback:getInlineKeyboard()
  if self.message
    and self.message.reply_markup
    and self.message.reply_markup.inline_keyboard
  then
    return self.message.reply_markup.inline_keyboard
  end
end

--- Gets the sender chat
-- @return (table) Sender chat object
function callback:getSenderChat()
  if self.message
    and self.message.reply_to_message
    and self.message.reply_to_message.sender_chat
  then
    return self.message.reply_to_message.sender_chat
  end
end

--- Gets the callback query data
-- @return (table) Callback query data
function callback:getQueryData()
  if self.callback_query
    and self.callback_query.data
  then
    return self.callback_query.data
  end
end

--- Trim the command
-- @return (text)
function callback:trimCommand()
  if self.callback_query and self.callback_query.data and self.__command then
    local res = self.callback_query.data:gsub(self.__command..' ', '', 1)
    return res
  end
end

setmetatable(callback, {
  __call = callback.new
})

return callback
