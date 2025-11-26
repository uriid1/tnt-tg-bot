--- Список подписчиков на событие onChatMember
--
local on_restricted_return = require('src.observers.events.chat_member.on_restricted_return')
local on_member_left = require('src.observers.events.chat_member.on_member_left')
local on_new_member = require('src.observers.events.chat_member.on_new_member')
local on_admin_demoted = require('src.observers.events.chat_member.on_admin_demoted')
local on_admin_promoted = require('src.observers.events.chat_member.on_admin_promoted')
local on_member_kicked = require('src.observers.events.chat_member.on_member_kicked')
local on_member_unbanned = require('src.observers.events.chat_member.on_member_unbanned')
local on_admin_left = require('src.observers.events.chat_member.on_admin_left')
local on_owner_left = require('src.observers.events.chat_member.on_owner_left')

local event_chat_member = require('src.enums.events.event_chat_member')
local observer = require('bot.interfaces.Observer')

local restricted_return = observer:new()
restricted_return:on(event_chat_member.RESTRICTED_RETURN, on_restricted_return)

local member_left = observer:new()
member_left:on(event_chat_member.MEMBER_LEFT, on_member_left)

local new_member = observer:new()
new_member:on(event_chat_member.NEW_MEMBER, on_new_member)

local admin_demoted = observer:new()
admin_demoted:on(event_chat_member.ADMIN_DEMOTED, on_admin_demoted)

local admin_promoted = observer:new()
admin_promoted:on(event_chat_member.ADMIN_PROMOTED, on_admin_promoted)

local member_kicked = observer:new()
member_kicked:on(event_chat_member.MEMBER_KICKED, on_member_kicked)

local member_unbanned = observer:new()
member_unbanned:on(event_chat_member.MEMBER_UNBANNED, on_member_unbanned)

local admin_left = observer:new()
admin_left:on(event_chat_member.ADMIN_LEFT, on_admin_left)

local owner_left = observer:new()
owner_left:on(event_chat_member.OWNER_LEFT, on_owner_left)

return {
  restricted_return = restricted_return,
  member_left = member_left,
  new_member = new_member,
  admin_demoted = admin_demoted,
  admin_promoted = admin_promoted,
  member_kicked = member_kicked,
  member_unbanned = member_unbanned,
  admin_left = admin_left,
  owner_left = owner_left
}
