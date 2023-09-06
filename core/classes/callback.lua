---
-- Callback class for handling callback queries.
-- @module callback
local callback = {}
callback.__index = callback

---
-- Creates a new callback object.
-- @param data (table) The callback query data.
--   - update_id (number): The update ID.
--   - callback_query (table): The callback query data.
-- @return (callback) The callback object.
function callback:new(data)
  local obj = {
    update_id = data.update_id,
    message = data.callback_query.message,
    callback_query = data.callback_query
  }

  setmetatable(obj, self)
  return obj
end

---
-- Gets the update ID.
-- @return (number) The update ID.
function callback:getUpdateId()
    if self.update_id then
        return self.update_id
    end
end

---
-- Gets the callback query ID.
-- @return (string) The callback query ID.
function callback:getQueryId()
  if self.callback_query then
    return self.callback_query.id
  end
end

---
-- Gets the associated message.
-- @return (table) The associated message.
function callback:getMessage()
  return self.message
end

---
-- Gets the arguments from the callback query data.
-- @param opts (table) Options table.
--   - separator (string, optional): The separator to split the data (default is ' ').
--   - count (number, optional): The maximum number of arguments to retrieve (default is 10).
-- @return (table) The arguments as a table.
function callback:getArguments(opts)
  if self.callback_query then
    local separator = opts.separator or ' '
    local count = opts.count or 10
    return self.callback_query.data:split(separator, count)
  end
end

---
-- Gets the chat ID from the associated message.
-- @return (number) The chat ID.
function callback:getChatId()
  if self.message and self.message.chat then
    return self.message.chat.id
  end
end

---
-- Gets the chat type from the associated message.
-- @return (string) The chat type.
function callback:getChatType()
  if self.message and self.message.chat then
    return self.message.chat.type
  end
end

---
-- Gets the message ID from the associated message.
-- @return (number) The message ID.
function callback:getMessageId()
  if self.message and self.message.message_id then
    return self.message.message_id
  end
end

---
-- Gets the text from the associated message.
-- @return (string) The message text.
function callback:getText()
  if self.message and self.message.text then
    return self.message.text
  end
end

---
-- Gets the user data from the callback query.
-- @return (table) The user data.
function callback:getUserFrom()
  if self.callback_query and self.callback_query.from then
    return self.callback_query.from
  end
end

---
-- Gets the user ID from the callback query.
-- @return (number) The user ID.
function callback:getUserFromId()
  if self.callback_query and self.callback_query.from then
    return self.callback_query.from.id
  end
end

---
-- Gets the user data from the associated message.
-- @return (table) The user data.
function callback:getUserMessageFrom()
  if self.message and self.message.from then
    return self.message.from
  end
end

---
-- Gets the user who replied to the associated message.
-- @return (table) The user data of the reply.
function callback:getUserReply()
  if self.message and self.message.reply_to_message then
    return self.message.reply_to_message.from
  end
end

---
-- Checks if the user who sent the callback query is the same as the one who replied to the associated message.
-- @return (boolean) True if it's the same user, false otherwise.
function callback:isSameUser()
  if self.callback_query and self.callback_query.from and
    self.message and self.message.reply_to_message
  then
    return self.callback_query.from.id == self.message.reply_to_message.from.id
  end
end

return callback
