-- Class definition
--
local message = {}
message.__index = message

function message:new(data)
  local obj = {
    update_id = data.update_id;
    message = data.message;
  }

  setmetatable(obj, self)
  return obj
end

function message:getUpdateId()
  if self.update_id then
    return self.update_id
  end
end

function message:getMessage()
  return self.message
end

function message:getArguments(opts)
  if self.message and self.message.text then
    local separator = opts.separator or ' '
    local count = opts.count or 10
    return self.message.text:split(separator, count)
  end
end

function message:getChatId()
  if self.message and self.message.chat then
    return self.message.chat.id
  end
end

function message:getChatType()
  if self.message and self.message.chat then
    return self.message.chat.type
  end
end

function message:getMessageId()
  if self.message and self.message.message_id then
    return self.message.message_id
  end
end

function message:getText()
  if self.message and self.message.text then
    return self.message.text
  end
end

function message:getUserFrom()
  if self.message and self.message.from then
    return self.message.from
  end
end

function message:getUserFromId()
  if self.message and self.message.from then
    return self.message.from.id
  end
end

function message:getUserReply()
  if self.message and self.message.reply_to_message then
    return self.message.reply_to_message
  end
end

function message:getEntities()
  if self.message and self.message.entities then
    return self.message.entities
  end
end

function message:getLeftChatMember()
  if self.message and self.message.left_chat_member then
    return self.message.left_chat_member
  end
end

function message:getNewChatMember()
  if self.message and self.message.new_chat_member then
    return self.message.new_chat_member
  end
end

function message:getNewChatMembers()
  if self.message and self.message.new_chat_members then
    return self.message.new_chat_members
  end
end

function message:isNewChatMember()
  if self.message and self.message.new_chat_members then
    return self.message.new_chat_members[1].id == self.message.from.id
  end
end

function message:isAddNewChatMember()
  if self.message and self.message.new_chat_members then
    return self.message.new_chat_members[1].id ~= self.message.from.id
  end
end

function message:isLeftMember()
  if self.message and self.message.left_chat_member then
    return self.message.left_chat_member.id == self.message.from.id
  end
end

function message:isRemoveMember()
  if self.message and self.message.left_chat_member then
    return self.message.left_chat_member.id ~= self.message.from.id
  end
end

return message
