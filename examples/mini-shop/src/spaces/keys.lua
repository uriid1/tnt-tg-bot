--- Ключи
--

--- Схема спейса
local formatSpace = {
  {
    name = 'id',
    type = 'uuid'
  },
  {
    name = 'key',
    type ='string'
  },
  {
    name = 'category',
    type = 'string'
  },
  {
    name = 'name',
    type = 'string'
  },
  -- Ссылка на игру
  {
    name = 'url',
    type = 'string'
  },
  {
    name = 'created',
    type = 'number'
  },
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
