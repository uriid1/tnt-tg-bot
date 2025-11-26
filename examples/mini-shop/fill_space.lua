---
--- Заполнение БД пустышками
---
local log = require('bot.libs.logger')
local uuid = require('uuid')

box.cfg {
  checkpoint_interval = 7200,
  checkpoint_count = 2,
  memtx_memory = 512 * 1024 * 1024,
  memtx_max_tuple_size = 524288,
  memtx_dir = 'storage/snap',
  wal_dir = 'storage/xlog',
}

for i = 1, 100 do
  box.space.keys:insert {
    uuid(),         -- id
    'key-' .. i,    -- key
    'racing',       -- category
    'Super Cool Racing N-'..i,  -- name
    'https://niko-bot.ru', -- url
    os.time() + i,        -- created
  }
end

for i = 1, 100 do
  box.space.keys:insert {
    uuid(),         -- id
    'key-' .. i,    -- key
    'shooters',     -- category
    'Shooter N-'..i,  -- name
    'https://niko-bot.ru', -- url
    os.time() + i,        -- created
  }
end

for i = 1, 100 do
  box.space.keys:insert {
    uuid(),         -- id
    'key-' .. i,    -- key
    'strategy',     -- category
    'Strategy N-'..i,  -- name
    'https://niko-bot.ru', -- url
    os.time() + i,        -- created
  }
end

log.info('Successfully filled')
