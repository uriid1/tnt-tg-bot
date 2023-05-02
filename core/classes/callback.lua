-- Class definition
--
local callback = {}

function callback:new(data)
    local obj = {
        update_id = data.update_id;
        message = data.callback_query.message;
        callback_query = data.callback_query;
    }

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function callback:getUpdateId()
    if self.update_id then
        return self.update_id
    end
end

function callback:getQueryId()
    if self.callback_query.id then
        return self.callback_query.id
    end
end

function callback:getMessage()
    return self.message
end

function callback:getArguments(opts)
    if self.callback_query then
        local separator = opts.separator or ' '
        local count = opts.count or 10
        return self.callback_query.data:split(separator, count)
    end
end

function callback:getChatId()
    if self.message and self.message.chat then
        return self.message.chat.id
    end
end

function callback:getMessageId()
    if self.message and self.message.message_id then
        return self.message.message_id
    end
end

function callback:getText()
    if self.message and self.message.text then
        return self.message.text
    end
end

function callback:getUserFrom()
    if self.message and self.message.from then
        return self.message.from
    end
end

function callback:getUserReply()
    if self.message and self.message.reply_to_message then
        return self.message.reply_to_message.from
    end
end

return callback
