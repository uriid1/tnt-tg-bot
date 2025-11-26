---
--
local log = require('bot.libs.logger')
local Permissions = require('src.models.Permissions')
local chatUsersService = require('src.services.chat_users')
local chatsService = require('src.services.chats')

local function on_bot_admin_promoted(ctx)
  local newChatMember = ctx:getNewChatMember()

  local _, err = chatUsersService.upsert({
    user_id = newChatMember.user.id,
    chat_id = ctx:getChatId(),
    status = newChatMember.status,
    permissions = Permissions(newChatMember),
  })

  if err then
    log.error(err)
    return
  end

  local chat = ctx:getChat()

  local _, err = chatsService.upsert(chat)
  if err then
    log.error(err)
    return
  end

  log.verbose('[event] %s', 'on_bot_admin_promoted')
end

return on_bot_admin_promoted
