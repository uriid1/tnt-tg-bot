--- Enum Entity Type

---
-- See: <a href="https://core.telegram.org/bots/api#messageentity">Message Entity</a>
-- @table bot.enums.chat_permissions
-- @field MENTION
-- @field HASHTAG
-- @field CASHTAG
-- @field BOT_COMMAND
-- @field URL
-- @field EMAIL
-- @field PHONE_NUMBER
-- @field BOLD
-- @field ITALIC
-- @field UNDERLINE
-- @field STRIKETHROUGH
-- @field SPOILER
-- @field CODE
-- @field PRE
-- @field TEXT_LINK
-- @field TEXT_MENTION
-- @field CUSTOM_EMOJI
local entity_type = {
  MENTION = 'mention',
  HASHTAG = 'hashtag',
  CASHTAG = 'cashtag',
  BOT_COMMAND = 'bot_command',
  URL = 'url',
  EMAIL = 'email',
  PHONE_NUMBER = 'phone_number',
  BOLD = 'bold',
  ITALIC = 'italic',
  UNDERLINE = 'underline',
  STRIKETHROUGH = 'strikethrough',
  SPOILER = 'spoiler',
  CODE = 'code',
  PRE = 'pre',
  TEXT_LINK = 'text_link',
  TEXT_MENTION = 'text_mention',
  CUSTOM_EMOJI = 'custom_emoji',
}

return entity_type
