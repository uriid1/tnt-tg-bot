--- Пользователи
--

local formatSpace = {
  -- https://core.telegram.org/bots/api#user
  {
    name = 'id',
    type = 'number'
  },
  {
    name = 'first_name',
    type ='string',
  },
  {
    name = 'last_name',
    type ='string',
  },
  {
    name = 'username',
    type ='string',
    is_nullable = true
  },
  {
    name = 'language_code',
    type ='string',
  },

  -- Игровая схема
  {
    name = 'status',
    type = 'string'
  },
  {
    name = 'energy',
    type = 'number'
  },
  {
    name = 'eat',
    type = 'number'
  },
  {
    name = 'balance',
    type = 'number'
  },
  {
    name = 'reserved_balance',
    type = 'number'
  },
  {
    name = 'likes',
    type = 'number'
  },
  {
    name = 'health',
    type = 'number'
  },
  {
    name = 'hooliganism',
    type = 'number'
  },

  {
    name = 'stats',
    type ='map',
  },

  {
    name = 'started_bot',
    type = 'boolean',
    is_nullable = true,
  }
}

--- Индексы спейса
local index = {
  {
    name = 'id',
    options = {
      parts = { 'id' },
      unique = true,
      if_not_exists = true
    }
  },
}

return {
  format_space = formatSpace,
  index = index
}
