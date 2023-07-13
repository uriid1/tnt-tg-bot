--[[
    ####--------------------------------####
    #--# Author:   by uriid1            #--#
    #--# License:  GNU GPLv3            #--#
    #--# Telegram: @main_moderator      #--#
    #--# E-mail:   appdurov@gmail.com   #--#
    ####--------------------------------####
--]]

local chat_member_status = require 'core.enums.chat_member_status'

-- Class definition
--
local chatMember = {}

function chatMember:new(data)
    local obj = {
        update_id = data.update_id;
        chat_member = data.chat_member
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
    if self.chat_member and self.chat_member.chat then
        return self.chat_member.chat
    end
end

function chatMember:getChatId()
    if self.chat_member and self.chat_member.chat then
        return self.chat_member.chat.id
    end
end

function chatMember:getChatType()
    if self.chat_member and self.chat_member.chat then
        return self.chat_member.chat.type
    end
end

function chatMember:getUserFrom()
    if self.chat_member and self.chat_member.from then
        return self.chat_member.from
    end
end

function chatMember:getUserFromId()
    if self.chat_member and self.chat_member.from then
        return self.chat_member.from.id
    end
end

function chatMember:getDate()
    if self.chat_member and self.chat_member.date then
        return self.chat_member.date
    end
end

function chatMember:getOldChatMember()
    if self.chat_member and self.chat_member.old_chat_member then
        return self.chat_member.old_chat_member.user
    end
end

function chatMember:getOldChatMemberStatus()
    if self.chat_member and self.chat_member.old_chat_member then
        return self.chat_member.old_chat_member.status
    end
end

function chatMember:getNewChatMember()
    if self.chat_member and self.chat_member.new_chat_member then
        return self.chat_member.new_chat_member.user
    end
end

function chatMember:getNewChatMemberStatus()
    if self.chat_member and self.chat_member.new_chat_member then
        return self.chat_member.new_chat_member.status
    end
end

return chatMember
