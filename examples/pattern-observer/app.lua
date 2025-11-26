-- ----------------------------
-- Точка входа
-- ----------------------------
package.cpath = package.cpath .. ";.rocks/lib/tarantool/?.so"
package.path = package.path .. ";.rocks/share/lua/5.1/?.lua"
package.path = package.path .. ";.rocks/share/lua/5.1/?/init.lua"

-- ----------------------------
-- Парсинг аргументов
-- ----------------------------
local argp = require('argp')

local parser = argp:new({
  name = 'Telegram bot',
  description = 'see github',
  version = '1.0'
})

parser:options({
  {
    short = 'h', long = 'help',
    description = 'Display this help and exit'
  },
  {
    short = 'v', long = 'verbose',
    description = 'Increase verbosity level'
  }
})

local args = parser:parse(arg)

-- ----------------------------
-- Настройка логгера
-- ----------------------------
local log = require('bot.libs.logger')

-- Verbose mode
if args.verbose then
  _G.p = require('pimp')

  log.init(require('minilog'))
  log.cfg {
    level = 'verbose',
  }
else
  log.init(require('log'))
  log.cfg {
    level = 'error',
    log = 'var/log/app.log'
  }
end

-- ----------------------------
-- Конфигурирование бота
-- ----------------------------
local config = require('conf.config')
local bot = require('bot')

bot:cfg {
  token = os.getenv('BOT_TOKEN'),
  username = config.bot.username
}

-- ----------------------------
-- События
-- ----------------------------
bot.events.onGetUpdate = require('src.events.onGetUpdate')
bot.events.onChatMember = require('src.events.onChatMember')
bot.events.onMyChatMember = require('src.events.onMyChatMember')
bot.events.onGetEntities = require('src.events.onGetEntities')
bot.events.onCallbackQuery = require('src.events.onCallbackQuery')
bot.events.onGetMessageText = require('src.events.onGetMessageText')

-- ----------------------------
-- Наблюдатели
-- ----------------------------

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

-- ----------------------------
-- Команды
-- ----------------------------
local commandLoader = require('src.commands.commandLoader')
commandLoader {
  -- Private
  'src.commands.private.start',
  'src.commands.private.help',
  -- Public
  'src.commands.public.dossier'
}

-- ----------------------------
-- Хранилище
-- ----------------------------
do
  box.cfg {
    -- Один час до очистки `мусора`
    checkpoint_interval = 7200,
    -- Количество snapshots
    checkpoint_count = 2,

    -- Кол-во памяти для кортежей
    memtx_memory = 512 * 1024 * 1024, -- байт
    -- Размер самого большого выделенного блока для хранилища memtx
    memtx_max_tuple_size = 524288, -- 512кб

    -- Директории хранений
    memtx_dir = 'var/storage/snap',
    wal_dir = 'var/storage/xlog',
  }

  local spaces = require('src.spaces')

  for spaceName, space in pairs(spaces) do
    local formatSpace = space.format_space

    -- Создание схемы
    local schema = box.schema.create_space(spaceName, {
      format = formatSpace,
      if_not_exists = true
    })

    -- Создание индексов
    for _, index in pairs(space.index) do
      schema:create_index(index.name, index.options)
    end

    log.info('Space [%s] inited', spaceName)
  end
end

-- ----------------------------
-- Запуск
-- ----------------------------
bot:startLongPolling {
  allowed_updates = {
    'message',
    'chat_member',
    'my_chat_member',
    'callback_query',
    'pre_checkout_query'
  }
}
