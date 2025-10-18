box.cfg {
  checkpoint_interval = 7200,
  checkpoint_count = 2,
  memtx_memory = 512 * 1024 * 1024,
  memtx_max_tuple_size = 524288,
  memtx_dir = 'storage/snap',
  wal_dir = 'storage/xlog',
}

local uuid = require('uuid')

for i = 1, 10 do
  box.space.keys:insert {
    uuid(),         -- id
    'key-' .. i,    -- key
    'racing',       -- category
    'foo bar '..i,  -- name
    'https://niko-bot.ru', -- url
  }
end

for i = 1, 10 do
  box.space.keys:insert {
    uuid(),         -- id
    'key-' .. i,    -- key
    'shooters',     -- category
    'foo bar '..i,  -- name
    'https://niko-bot.ru', -- url
  }
end

for i = 1, 10 do
  box.space.keys:insert {
    uuid(),         -- id
    'key-' .. i,    -- key
    'strategy',     -- category
    'foo bar '..i,  -- name
    'https://niko-bot.ru', -- url
  }
end
