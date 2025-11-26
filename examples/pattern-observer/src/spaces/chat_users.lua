--- Пользователи чата
--

--- Схема спейса
local formatSpace = {
  {
    name = 'user_id',
    type ='number',
  },
  {
    name = 'chat_id',
    type ='number',
  },
  {
    name = 'joined_at',
    type ='number',
  },
  {
    name = 'permissions',
    type = 'map'
  },

  -- Статус пользователя в чате
  {
    name = 'status',
    type ='string',
  },

  -- Параметры для статистики
  {
    name = 'count_messages',
    type ='number',
  },
  {
    name = 'count_commands',
    type ='number',
  }
}

--- Индексы спейса
local index = {
  {
    name = 'user_id_chat_id',
    options = {
      parts = { {'user_id'}, {'chat_id'} },
      unique = true,
      if_not_exists = true
    }
  },
  {
    name = 'user_id',
    options = {
      parts = { 'user_id' },
      unique = false,
      if_not_exists = true
    }
  },
  {
    name = 'chat_id',
    options = {
      parts = { 'chat_id' },
      unique = false,
      if_not_exists = true
    }
  }
}

return {
  format_space = formatSpace,
  index = index,
}
