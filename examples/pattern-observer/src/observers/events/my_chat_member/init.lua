--- Список подписчиков на событие onMyChatMember
--
local on_bot_blocked = require('src.observers.events.my_chat_member.on_bot_blocked')
local on_bot_kicked = require('src.observers.events.my_chat_member.on_bot_kicked')
local on_bot_left = require('src.observers.events.my_chat_member.on_bot_left')
local on_bot_added_as_member = require('src.observers.events.my_chat_member.on_bot_added_as_member')
local on_bot_permissions_changed = require('src.observers.events.my_chat_member.on_bot_permissions_changed')
local on_bot_admin_demoted = require('src.observers.events.my_chat_member.on_bot_admin_demoted')
local on_bot_admin_promoted = require('src.observers.events.my_chat_member.on_bot_admin_promoted')

local event = require('src.enums.events.event_my_chat_member')
local observer = require('bot.interfaces.Observer')

local bot_blocked = observer:new()
bot_blocked:on(event.BOT_BLOCKED, on_bot_blocked)

local bot_kicked = observer:new()
bot_kicked:on(event.BOT_KICKED, on_bot_kicked)

local bot_left = observer:new()
bot_left:on(event.BOT_LEFT, on_bot_left)

local bot_added_as_member = observer:new()
bot_added_as_member:on(event.BOT_ADDED_AS_MEMBER, on_bot_added_as_member)

local bot_permissions_changed = observer:new()
bot_permissions_changed:on(event.BOT_PERMISSIONS_CHANGED, on_bot_permissions_changed)

local bot_admin_demoted = observer:new()
bot_admin_demoted:on(event.BOT_ADMIN_DEMOTED, on_bot_admin_demoted)

local bot_admin_promoted = observer:new()
bot_admin_promoted:on(event.BOT_ADMIN_PROMOTED, on_bot_admin_promoted)

return {
  bot_blocked = bot_blocked,
  bot_kicked = bot_kicked,
  bot_left = bot_left,
  bot_added_as_member = bot_added_as_member,
  bot_permissions_changed = bot_permissions_changed,
  bot_admin_demoted = bot_admin_demoted,
  bot_admin_promoted = bot_admin_promoted,
}
