---
--
local log = require('bot.libs.logger')
local Permissions = require('src.models.Permissions')
local chatUsersService = require('src.services.chat_users')

local function on_bot_blocked(ctx)
  local newChatMember = ctx:getNewChatMember()

  local _, err = chatUsersService.upsert({
    user_id = newChatMember.user.id,
    chat_id = ctx:getChatId(),
    status = newChatMember.status,
    permissions = Permissions({}),
  })

  if err then
    log.error(err)
    return
  end

  log.verbose('[event] %s', 'on_bot_blocked')
end

return on_bot_blocked
