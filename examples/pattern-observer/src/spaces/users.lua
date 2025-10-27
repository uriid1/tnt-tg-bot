--- Пользователи
--

--- Схема спейса
local formatSpace = {
  {
    name = 'id',
    type = 'uuid'
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
  },
  {
    name = 'language_code',
    type ='string',
  },

  -- Игровая схема
  {
    name = 'status',
    tpye = 'string'
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
    name = 'money',
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
    tpye = 'number'
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
  index = index,
}
