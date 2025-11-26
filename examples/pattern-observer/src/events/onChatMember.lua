---
--
local log = require('bot.libs.logger')
local chat_member_status = require('bot.enums.chat_member_status')
local chat_type = require('bot.enums.chat_type')
local subject = require('src.subjects.chat_member')
local event_chat_member = require('src.enums.events.event_chat_member')

local function onChatMember(ctx)
  local chatType = ctx:getChatType()

  -- Событие для каналов
  if chat_type.CHANNEL == chatType then
    return subject:notify(event_chat_member.CHANNEL, ctx)
  end

  local chat = ctx:getChat()
  local oldChatM = ctx:getOldChatMember()
  local newChatM = ctx:getNewChatMember()
  local oldStatus = oldChatM.status
  local newStatus = newChatM.status
  local oldIsMember = oldChatM.is_member
  local newIsMember = newChatM.is_member

  --
  -- Диспетчеризация по типу события
  --
  --
  -- Пользователь возвращается в чат с ограниченным статусом
  --
  if oldIsMember == false and newIsMember == true then
    -- Вернулся а чат изменёнными правами
    return subject:notify(event_chat_member.RESTRICTED_RETURN, ctx)

  elseif oldIsMember == true and newIsMember == false then
    -- Покинул чат
    return subject:notify(event_chat_member.MEMBER_LEFT, ctx)
  end

  -- Обработка по новому статусу
  --
  if newStatus == chat_member_status.MEMBER then
    -- Новый участник чата
    return subject:notify(event_chat_member.NEW_MEMBER, ctx)

  elseif newStatus == chat_member_status.RESTRICTED then
    if oldStatus == chat_member_status.ADMINISTRATOR then
      -- У администратора убрали все права
      return subject:notify(event_chat_member.ADMIN_DEMOTED, ctx)
    end

  elseif newStatus == chat_member_status.ADMINISTRATOR then
    -- Назначили участника администратором
    return subject:notify(event_chat_member.ADMIN_PROMOTED, ctx)

  elseif newStatus == chat_member_status.KICKED then
    -- Участника кикнули
    return subject:notify(event_chat_member.MEMBER_KICKED, ctx)

  -- Обход различных сценариев выхода
  --
  elseif newStatus == chat_member_status.LEFT then
    if oldStatus == chat_member_status.MEMBER then
      return subject:notify(event_chat_member.MEMBER_LEFT, ctx)

    elseif oldStatus == chat_member_status.RESTRICTED then
      return subject:notify(event_chat_member.MEMBER_LEFT, ctx)

    elseif oldStatus == chat_member_status.KICKED then
      return subject:notify(event_chat_member.MEMBER_UNBANNED, ctx)

    elseif oldStatus == chat_member_status.ADMINISTRATOR then
      return subject:notify(event_chat_member.ADMIN_LEFT, ctx)

    elseif oldStatus == chat_member_status.CREATOR then
      return subject:notify(event_chat_member.OWNER_LEFT, ctx)

    else
      log.error({
        message = 'Unexpected transition status',
        old_status = tostring(oldStatus),
        new_status = tostring(newStatus),
        user_id = newChatM.user.id,
        chat_id = chat.id
      })
    end
  end
end

return onChatMember
