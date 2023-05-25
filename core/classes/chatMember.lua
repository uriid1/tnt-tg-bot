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
local chatMember = {}

function chatMember:new(data)
    local obj = {
        update_id = data.update_id;
        my_chat_member = data.my_chat_member
    }

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function chatMember:getUpdateId()
    if self.update_id then
        return self.update_id
    end
end

function chatMember:getChat()
    if self.my_chat_member and self.my_chat_member.chat then
        return self.my_chat_member.chat
    end
end

function chatMember:getChatId()
    if self.my_chat_member and self.my_chat_member.chat then
        return self.my_chat_member.chat.id
    end
end

function chatMember:getChatType()
    if self.my_chat_member and self.my_chat_member.chat then
        return self.my_chat_member.chat.type
    end
end

function chatMember:getUserFrom()
    if self.my_chat_member and self.my_chat_member.from then
        return self.my_chat_member.from
    end
end

function chatMember:getUserFromId()
    if self.my_chat_member and self.my_chat_member.from then
        return self.my_chat_member.from.id
    end
end

function chatMember:getDate()
    if self.my_chat_member and self.my_chat_member.date then
        return self.my_chat_member.date
    end
end

function chatMember:getOldChatMember()
    if self.my_chat_member and self.my_chat_member.old_chat_member then
        return self.my_chat_member.old_chat_member
    end
end

function chatMember:getNewChatMember()
    if self.my_chat_member and self.my_chat_member.new_chat_member then
        return self.my_chat_member.new_chat_member
    end
end

return chatMember
