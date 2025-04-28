--- Enum Bot Command Scope

---
-- See: <a href="https://core.telegram.org/bots/api#botcommandscope">Bot Command Scope</a>
-- @table bot.enums.bot_command_scope
-- @field DEFAULT
-- @field ALL_PRIVATE_CHATS
-- @field ALL_GROUP_CHATS
-- @field ALL_CHAT_ADMINISTRATORS
-- @field CHAT
-- @field CHAT_ADMINISTRATORS
-- @field CHAT_MEMBER
local bot_command_scope = {
  DEFAULT = 'default',
  ALL_PRIVATE_CHATS = 'all_private_chats',
  ALL_GROUP_CHATS = 'all_group_chats',
  ALL_CHAT_ADMINISTRATORS = 'all_chat_administrators',
  CHAT = 'chat',
  CHAT_ADMINISTRATORS = 'chat_administrators',
  CHAT_MEMBER = 'chat_member',
}

return bot_command_scope
