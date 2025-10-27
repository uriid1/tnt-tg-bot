--- Точка входа в проект
--
local bot = require('bot')
local config = require('conf.config')

bot:cfg {
  token = os.getenv('BOT_TOKEN'),
  username = config.bot.username
}

-- Загрузка событий
--
bot.events.onGetUpdate = require('src.events.onGetUpdate')
bot.events.onChatMember = require('src.events.onChatMember')
bot.events.onMyChatMember = require('src.events.onMyChatMember')
bot.events.onGetEntities = require('src.events.onGetEntities')
bot.events.onCallbackQuery = require('src.events.onCallbackQuery')

-- Подпись наблюдателей на события onChatMember
--
local subject_chat_member = require('src.subjects.chat_member')
local observer_chat_member = require('src.observers.events.chat_member')

subject_chat_member:subscribe(observer_chat_member.restricted_return)
subject_chat_member:subscribe(observer_chat_member.member_left)
subject_chat_member:subscribe(observer_chat_member.new_member)
subject_chat_member:subscribe(observer_chat_member.admin_demoted)
subject_chat_member:subscribe(observer_chat_member.admin_promoted)
subject_chat_member:subscribe(observer_chat_member.member_kicked)
subject_chat_member:subscribe(observer_chat_member.member_unbanned)
subject_chat_member:subscribe(observer_chat_member.admin_left)
subject_chat_member:subscribe(observer_chat_member.owner_left)

-- Подпись наблюдателей на события onMyChatMember
--
local subject_my_chat_member = require('src.subjects.my_chat_member')
local observer_my_chat_member = require('src.observers.events.my_chat_member')

subject_my_chat_member:subscribe(observer_my_chat_member.bot_blocked)
subject_my_chat_member:subscribe(observer_my_chat_member.bot_kicked)
subject_my_chat_member:subscribe(observer_my_chat_member.bot_left)
subject_my_chat_member:subscribe(observer_my_chat_member.bot_added_as_member)
subject_my_chat_member:subscribe(observer_my_chat_member.bot_permissions_changed)
subject_my_chat_member:subscribe(observer_my_chat_member.bot_admin_demoted)
subject_my_chat_member:subscribe(observer_my_chat_member.bot_admin_promoted)

-- Загрузка комманд
--
local commandLoader = require('src.commands.commandLoader')
commandLoader {
  'src.commands.start',
  'src.commands.help'
}

bot:startLongPolling {
  allowed_updates = {
    'message',
    'chat_member',
    'my_chat_member',
    'callback_query',
    'pre_checkout_query'
  }
}
