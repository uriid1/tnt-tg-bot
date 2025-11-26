--- Чаты
--

local formatSpace = {
  -- https://core.telegram.org/bots/api#chat
  {
    name = 'id',
    type ='number',
  },
  {
    name = 'username',
    type ='string',
    is_nullable = true,
  },
  {
    name = 'type',
    type ='string',
  },
  {
    name = 'title',
    type ='string',
  },
  {
    name = 'is_forum',
    type ='boolean',
    is_nullable = true,
  },

  -- Колличество участников в чате
  {
    name = 'member_count',
    type = 'number',
  },

  -- Дата, когда бота добавили в чате
  {
    name = 'joined_at',
    type ='number',
  },

  -- Настройки чата
  {
    name = 'options',
    type = 'map',
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
  }
}

--- export
--
return {
  format_space = formatSpace,
  index = index
}
