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
local myChatMember = {}

function myChatMember:new(data)
    local obj = {
        update_id = data.update_id;
        my_chat_member = data.my_chat_member
    }

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function myChatMember:getUpdateId()
    if self.update_id then
        return self.update_id
    end
end

function myChatMember:getChat()
    if self.my_chat_member and self.my_chat_member.chat then
        return self.my_chat_member.chat
    end
end

function myChatMember:getChatId()
    if self.my_chat_member and self.my_chat_member.chat then
        return self.my_chat_member.chat.id
    end
end

function myChatMember:getChatType()
    if self.my_chat_member and self.my_chat_member.chat then
        return self.my_chat_member.chat.type
    end
end

function myChatMember:getUserFrom()
    if self.my_chat_member and self.my_chat_member.from then
        return self.my_chat_member.from
    end
end

function myChatMember:getUserFromId()
    if self.my_chat_member and self.my_chat_member.from then
        return self.my_chat_member.from.id
    end
end

function myChatMember:getDate()
    if self.my_chat_member and self.my_chat_member.date then
        return self.my_chat_member.date
    end
end

function myChatMember:getOldChatMember()
    if self.my_chat_member and self.my_chat_member.old_chat_member then
        return self.my_chat_member.old_chat_member.user
    end
end

function myChatMember:getNewChatMember()
    if self.my_chat_member and self.my_chat_member.new_chat_member then
        return self.my_chat_member.new_chat_member.user
    end
end

function myChatMember:getNewChatMemberStatus()
    if self.my_chat_member and self.my_chat_member.new_chat_member then
        return self.my_chat_member.new_chat_member.status
    end
end

function myChatMember:getOldChatMemberStatus()
    if self.my_chat_member and self.my_chat_member.old_chat_member then
        return self.my_chat_member.old_chat_member.status
    end
end

return myChatMember
