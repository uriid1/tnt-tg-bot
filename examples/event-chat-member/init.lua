--- Точка входа в проект
--
local bot = require('bot')

bot:cfg {
  token = os.getenv('BOT_TOKEN')
}

-- Добавление ссылки бота в глобальное окружение
-- (опционально) можно грузить везде где нужно require
_G.bot = bot

-- Загрузка событий
bot.events.onGetUpdate = require('src.events.onGetUpdate')
bot.events.onChatMember = require('src.events.onChatMember')

-- Загрузка обработчиков событий
local eventsSubject = require('src.events.subject')
local obsChatMember = require('src.observers.events.chat_member')

-- Подпись наблюдателей
eventsSubject:subscribe(obsChatMember.restricted_return)
eventsSubject:subscribe(obsChatMember.member_left)
eventsSubject:subscribe(obsChatMember.new_member)
eventsSubject:subscribe(obsChatMember.admin_demoted)
eventsSubject:subscribe(obsChatMember.admin_promoted)
eventsSubject:subscribe(obsChatMember.member_kicked)
eventsSubject:subscribe(obsChatMember.member_unbanned)
eventsSubject:subscribe(obsChatMember.admin_left)
eventsSubject:subscribe(obsChatMember.owner_left)

bot:startLongPolling()
