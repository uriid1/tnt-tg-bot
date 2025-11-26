--- Модель прав пользователя
--
local chat_member_status = require('bot.enums.chat_member_status')

-- @see https://core.telegram.org/bots/api#chatmemberadministrator
local administrator_perms = {
  'can_be_edited',
  'is_anonymous',
  'can_manage_chat',
  'can_delete_messages',
  'can_manage_video_chats',
  'can_restrict_members',
  'can_promote_members',
  'can_change_info',
  'can_invite_users',
  'can_post_stories',
  'can_edit_stories',
  'can_delete_stories',
  'can_post_messages',
  'can_edit_messages',
  'can_pin_messages',
  'can_manage_topics',
  'can_manage_direct_messages',
  'custom_title',
}

-- @see https://core.telegram.org/bots/api#chatmemberrestricted
local restricted_perms = {
  'is_member',
  'can_send_messages',
  'can_send_audios',
  'can_send_documents',
  'can_send_photos',
  'can_send_videos',
  'can_send_video_notes',
  'can_send_voice_notes',
  'can_send_polls',
  'can_send_other_messages',
  'can_add_web_page_previews',
  'can_change_info',
  'can_invite_users',
  'can_pin_messages',
  'can_manage_topics',
  'until_date'
}

-- Паминг прав
local function mapping(member, perms)
  local result = {}
  for _, field in ipairs(perms) do
    if member[field] ~= nil then
      result[field] = member[field]
    end
  end
  return result
end

--- Конструктор модели
--
-- @param data Исходные данные
-- @return[1] Сериализуемая модель
-- @return[2] Коллекция ошибок
local function Permissions(data)
  local status = data.status

  local perms = {}
  if status == chat_member_status.ADMINISTRATOR then
    perms = mapping(data, administrator_perms)
  elseif status == chat_member_status.RESTRICTED then
    perms = mapping(data, restricted_perms)
  end

  setmetatable(perms, { __serialize = 'map' })

  return perms
end

return Permissions
