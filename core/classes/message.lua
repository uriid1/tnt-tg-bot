--[[
    ####--------------------------------####
    #--# Author:   by uriid1            #--#
    #--# License:  GNU GPLv3            #--#
    #--# Telegram: @main_moderator      #--#
    #--# E-mail:   appdurov@gmail.com   #--#
    ####--------------------------------####
--]]

-- Class definition
--
local message = {}

function message:new(data)
    local obj = {
        update_id = data.update_id;
        message = data.message;
    }

    setmetatable(obj, self)
    self.__index = self
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

return message
