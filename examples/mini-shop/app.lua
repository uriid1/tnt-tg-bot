--- Точка входа в проект
--
local log = require('log')
local bot = require('bot')

bot:cfg {
  token = os.getenv('BOT_TOKEN')
}

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
  memtx_dir = 'storage/snap',
  wal_dir = 'storage/xlog',
}

-- Загрузка событий
bot.events.onGetUpdate = require('src.events.onGetUpdate')
bot.events.onCallbackQuery = require('src.events.onCallbackQuery')
bot.events.onGetEntities = require('src.events.onGetEntities')

-- Загрузка команд
do
  local basePath = 'src.commands'
  local commands = {
    'start',
    'cb_category',
    'cb_buy'
  }

  for i = 1, #commands do
    local command = commands[i]
    local commandPath = basePath..'.'..command

    local objCommand = require(commandPath)
    for j = 1, #objCommand.commands do
      local commandName = objCommand.commands[j]

      -- Добавление ссылки объекта команды в список команд
      bot.commands[commandName] = objCommand

      log.info('Command [%s] loaded', commandName)
    end
  end
end

-- Инициализация хранилища
do
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

bot:startLongPolling()
