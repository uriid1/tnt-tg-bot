---
--
local chat_member_status = require('bot.enums.chat_member_status')
local chat_type = require('bot.enums.chat_type')
local subject = require('src.subjects.my_chat_member')
local event_my_chat_member = require('src.enums.events.event_my_chat_member')

local function onMyChatMember(ctx)
  local chatType = ctx:getChatType()

  -- Событие для каналов
  if chat_type.CHANNEL == chatType then
    return subject:notify(event_my_chat_member.CHANNEL, ctx)
  end

  local chat = ctx:getChat()
  local newStatus = ctx:getNewChatMemberStatus()
  local oldStatus = ctx:getOldChatMemberStatus()

  -- require('pimp')(newStatus)
  -- require('pimp')(oldStatus)

  -- События в ЛС пользователя и бота
  --
  if chat.type == chat_type.PRIVATE then
    if newStatus == chat_member_status.KICKED then
      -- Пользователь заблокировал у себя бота
      return subject:notify(event_my_chat_member.BOT_BLOCKED, ctx)
    end
  end

  -- Изменили права или повысили до администратора
  --
  if newStatus == chat_member_status.ADMINISTRATOR then
    if oldStatus == chat_member_status.ADMINISTRATOR then
      -- Изменили права
      return subject:notify(event_my_chat_member.BOT_PERMISSIONS_CHANGED, ctx)
    else
      -- Повысили до администратора
      return subject:notify(event_my_chat_member.BOT_ADMIN_PROMOTED, ctx)
    end
  end

  -- Добавили бота в чат
  --
  if newStatus == chat_member_status.MEMBER then
    -- Добавили в качестве участника
    return subject:notify(event_my_chat_member.BOT_ADDED_AS_MEMBER, ctx)

  elseif newStatus == chat_member_status.KICKED then
    -- Бота кикнули из чата
    return subject:notify(event_my_chat_member.BOT_KICKED, ctx)

  elseif newStatus == chat_member_status.RESTRICTED then
    -- Понизили с админа до member
    if oldStatus == chat_member_status.ADMINISTRATOR then
      return subject:notify(event_my_chat_member.BOT_ADMIN_DEMOTED, ctx)
    end

    -- Изменили права
    return subject:notify(event_my_chat_member.BOT_PERMISSIONS_CHANGED, ctx)

  elseif newStatus == chat_member_status.LEFT then
    -- Скорее всего чат удалили или бот сам вышел
    return subject:notify(event_my_chat_member.BOT_LEFT, ctx)
  end
end

return onMyChatMember
