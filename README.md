Russian | [English](README_EN.md)</br>

[![luacheck](https://github.com/uriid1/tnt-tg-bot/actions/workflows/luacheck.yml/badge.svg?branch=master)](https://github.com/uriid1/tnt-tg-bot/actions/workflows/luacheck.yml)
[![License](https://img.shields.io/badge/License-MIT-brightgreen.svg)](LICENSE)

## Описание
tnt-tg-bot - это библиотека, написанная на Lua для платформы Tarantool, которая предоставляет интерфейсы для работы с Telegram Bot API.

## Особенности
  + Простата и ясность интерфейсов
  + Асинхронная обработка запросов
  + Встроенная поддержка работы с платежами в Telegram Stars
  + Встроенные методы для обработки команд, в том числе callback
  + Вы сами даёте названия событиям, из коробки у вас только - `bot.events.onGetUpdate(ctx)`
  + Простая работа с WebApp
  + Поддержка LDoc
  + Большое колличество примеров

## Showcase
  - [Niko Bot](https://t.me/Niko_rp_bot) - Бот с мини играми, множеством команд, питомцами и модерацией групп
  - [Talking Hooligan](https://t.me/talking_piska_bot) - Популярный бот для чатов, присылает смешные и глупые сообщения

## Установка

### Автоматическая
1. Установите `git`, `curl`, `lua 5.1` и `luarocks`.
2. (опционально) если нужна работа с WebApp: </br>
    Потребуется установить rock пакет `luaossl`, для него в вашем дистрибутиве - </br>
    установите заголовочные файлы для `lua 5.1` и `openssl`.
2. Установите [tarantool](https://www.tarantool.io/ru/download/os-installation)
3. Выполните скрипт автоматической установки необходимых пакетов
```bash
bash tnt-tg-bot.pre-build.sh
```
5. В случае проблем, перейти к ручной установки.

> [!NOTE]
> Для успешной сборки `luaossl` - биндинга к OpenSSL, потребуются заголовочные файлы OpenSSL и Lua 5.1.
> В Ubuntu можно установить, выполнив `sudo apt install libssl-dev liblua5.1-0-dev`.
> `luaossl` нужен для работы модуля `bot/libs/parseInitData.lua`, модуль нужен для обработки данных веб Mini App.
> https://core.telegram.org/bots/webapps#validating-data-received-via-the-mini-app

### Ручная
1. Установите `git`, `curl`, `lua 5.1` и `luarocks`.
2. Установите [tarantool](https://www.tarantool.io/ru/download/os-installation)
3. (опционально) если нужна работа с WebApp: </br>
    Потребуется установить rock пакет `luaossl`, для него в вашем дистрибутиве - </br>
    установите заголовочные файлы для `lua 5.1` и `openssl`.
4. Установка необходимых пакетов с помощью `luarocks`
  + **HTTP клиент/сервер (обязательно)**
    ```bash
    luarocks install --local --tree=$PWD/.rocks --server=https://rocks.tarantool.org/ http
    ```
  + **Multipart Post обработчик (обязательно)**
    ```bash
    luarocks install --local --tree=$PWD/.rocks --lua-version 5.1 lua-multipart-post 1.0-0
    ```
  + **Биндинг к openssl (опционально)**
    ```bash
    luarocks install --local --tree=$PWD/.rocks --lua-version 5.1 luaossl
    ```
## Примеры
  + [Observer pattern](examples/pattern-observer) - Пример показывает реализацию паттерна наблюдателя, по факту - диспетчеризация событий. Так же пример хорошо структурирован, подходит что бы взять за основу
  + [Mini Shop](examples/mini-shop) - Пример минимального "магазина", показано как можно структурировать проект
  + [Star payments](examples/stars-payment) - Пример обработки платежей в звездах (покупка, возврат)
  + `examples/echo-bot-webhook.lua` - Эхо-бот через WebHook
  + `examples/echo-bot.lua` - Эхо-бот (старый API)
  + `examples/echo-bot-2.lua` - Эхо-бот (новый API) 
  + `examples/ping-pong.lua` - Реакция на команду /ping
  + `examples/send-animation.lua` - Отправка gif по команде /get_animation
  + `examples/send-document.lua` - Отправка документа по команде /get_document
  + `examples/send-image.lua` - Отправка изображения по команде /get_image
  + `examples/send-image-2.lua` - Упрощенный пример отправки изображения через `bot.sendImage`
  + `examples/send-media-group.lua` - Отправка группы медиа-файлов
  + `examples/simple-callback.lua` - Пример обработки callback - /send_callback (старый API)
  + `examples/simple-callback-2.lua` - Упрощенный пример обработки callback команд (новый API)
  + `examples/simple-process-commands.lua` - Пример простого процессинга команд
  + `examples/routes-example/init.lua` - Пример работы ручек в боте

> [!NOTE]
> Рекомендуется использовать только новый API

### Запуск примера
`BOT_TOKEN` - токен вашего бота
```bash
BOT_TOKEN="1348551682:AAFK3iZwBqEHwSrPKyi-hKyAtRgUwXrTiWW" tarantool examples/echo-bot.lua
```

## Структура проекта
  + `bot/init.lua` - Точка входа
  + `bot/libs` - Вспомогательные библиотеки
  + `bot/enums` - Инамы
  + `bot/classes` - Классы для объектов телеграмма
  + `bot/middlewares` - Посредники
  + `bot/processes` - Процессы. Пример processCommand - процессинг команд
  + `bot/types` - Модели/валидаторы для типов телеграмма
  + `bot/ext` - Встроенные экстеншины

## Интерфейс библиотеки
| Метод | Описание | Пример использования |
|---------------|---------|---------------------|
| bot:cfg | Инициализация настроек | `bot:cfg { token = "123468:foobarBAZ" }` |
| bot.call | Выполнение запроса к Telegram API | `bot.call('sendMessage', {chat_id = 123, text = 'Привет!'})` |
| bot.events | Таблица с пользовательскими событиями | `function bot.events.onPoll(ctx) ... end` |
| bot.events.onGetUpdate | Событие обработки обновлений от Telegram | `function bot.events.onGetUpdate(ctx) ... end` |
| bot.sendImage | Упрощенная отправка картинки | `examples/send-image-2.lua`  |
| bot.Command | Минимальный обработчик команд | `bot.Command(ctx)` |
| bot.CallbackCommand | Минимальный обработчик callback команд | `bot.CallbackCommand(ctx)`
| bot:startWebHook | Запуск бота на удаленном сервере | Пример `examples/echo-bot-webhook.lua` |
| bot:startLongPolling | Запуск бота в режиме long polling | Любой пример из `examples/*` |
| bot:debugRoutes | Отладка ручек в режиме longPolling |  |

По наличию аргументов см. ldoc - `doc/index.html`

## Вклад в проект
Через форк репозитория и открытия Pull Request
