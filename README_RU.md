Russian | [English](README.md)</br>

# Описание
Эта небольшая библиотека, котрая поможет реализовать основною «базовую» логику вашего бота.</br>
Логика библиотеки написана так, чтобы все отсутствующие можно было легко реализовать.</br>
В [main.lua](https://github.com/uriid1/tnt-tg-bot/blob/main/main.lua), можно просмотреть некоторые возможности библиотеки.</br>
Надеюсь, разобраться в этом не составит большого труда ᓚ₍ ^. .^₎.</br>

Бот который написан с использованием этой библиотеки: https://t.me/niko_rp_bot


# Установка
### Загрузите этот репозиторий и перейдите в него
```sh
git clone https://github.com/uriid1/tnt-tg-bot && cd tnt-tg-bot
```

#### Установите необходимые зависимости
> [!NOTE]  
> Флаг `--optional` устанавливает модуль для pretty print-а таблиц</br>
> Флаг `--http-patch` применяет патч к модулю http, который подменит 500 код ошибки на 200</br>
> это полезно, чтобы отвечать телеграму всегда кодом, соответствующим тому</br>
> что ваш запрос был обработан, хоть и некорректно.
```sh
chmod +x install-dependencies.sh && sh install-dependencies.sh --optional
```

### Наконец, вы можете запустить вашего бота
```sh
BOT_TOKEN=123456:AAAAABBBBCCCCDDDeeeFFFF tarantool main.lua
```

# Минимальный пример
```lua
-- init.lua
local bot = require('core.bot')
bot:cfg {
  token = os.getenv('BOT_TOKEN'), -- Ваш токен, полученный от @botfather
  parse_mode = 'HTML',            -- Тип форматирования текста
}

-- Событие получения сущностей
bot.event.onGetEntities = function(message)
  local entities = message:getEntities()

  -- Вызов команды, если сущность является командой
  if entities[1] and entities[1].type == 'bot_command' then
    local command = bot.Command(message)
    if command then
      command(message)
    end
  end
end

-- Команда /start
bot.commands["/start"] = function(message)
  -- Отправка текстового сообщения
  bot:call('sendMessage', {
    text = 'Hello!',
    chat_id = message:getChatId(),
  })
end

bot:startLongPolling()
```

# Использование WebHooks
### Пример с self-signed (самоподписным) сертификатом
```lua
bot:startWebHook({
  -- Параметры локального сервера
  port = 8081,
  host = '0.0.0.0',
  -- Ссылка по которой телеграм, будет отправлять -
  -- на ваш сервер сообщения
  bot_url = 'https://123.123.123.124/my_bot_location',
  -- Путь до сертификата
  certificate = '/etc/path/to/ssl/public.pem',

  -- Опциональные параметры
  -- https://core.telegram.org/bots/api#setwebhook
  drop_pending_updates = true,
  allowed_updates = { "message", "my_chat_member", "callback_query" }
})
```

### Если у вас есть своё доменное имя
> !NOTE Если ваш сертификат, например от letsencrypt, то указывать до него путь не нужно</br>
> так так телеграм сам обработает получение публичного сертификата
```lua
bot:startWebHook({
  port = 8081,
  host = '0.0.0.0',
  bot_url = 'https://mysite.ru/my_bot_location',
  drop_pending_updates = true,
  allowed_updates = { "message", "my_chat_member", "callback_query" }
})
```

# Настройка под nginx
Добавьте location в блок server, это позволит nginx проксировать запросы от от телеграма к боту.
```nginx
location /my_bot_location {
  proxy_set_header Host $http_host;
  proxy_redirect   off;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Scheme $scheme;
  proxy_pass       http://0.0.0.0:8081/;
}
```

# Предисловие
Можно заметить, что некоторые классы не зависят друг от друга.
Например, класс [core/classes/callback.lua](https://github.com/uriid1/tnt-tg-bot/blob/main/core/classes/callback.lua) содержит в себе объект сообщения и реализует методы, аналогичные - [core/classes/message.lua](https://github.com/uriid1/tnt-tg-bot/blob/main/core/classes/message.lua)<br>
Причина, по которой в `callback.lua` не создаётся объект сообщения из класса `message.lua` заключается в оптимизации.<br>
Но в будущем, вероятно всё же придется реализовать зависимости у классов.<br>
С архитектурной стороны, так куда правильнее.