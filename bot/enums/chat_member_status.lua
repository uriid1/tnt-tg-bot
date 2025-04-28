--- Enum Chat Member Status

---
-- @table bot.enums.chat_member_status
-- @field CREATOR
-- @field ADMINISTRATOR
-- @field MEMBER
-- @field RESTRICTED
-- @field LEFT
-- @field KICKED
-- @field UNKNOWN
local chat_member_status = {
  CREATOR = 'creator',
  ADMINISTRATOR = 'administrator',
  MEMBER = 'member',
  RESTRICTED = 'restricted',
  LEFT = 'left',
  KICKED = 'kicked',
  UNKNOWN = 'unknown',
}

return chat_member_status
