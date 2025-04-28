Russian | [English](README_EN.md)</br>

[![luacheck](https://github.com/uriid1/tnt-tg-bot/actions/workflows/luacheck.yml/badge.svg?branch=master)](https://github.com/uriid1/tnt-tg-bot/actions/workflows/luacheck.yml)
[![License](https://img.shields.io/badge/License-MIT-brightgreen.svg)](LICENSE)

## Описание
tnt-tg-bot - это библиотека, написанная на Lua для платформы Tarantool, которая предоставляет минималистичный интерфейс для работы с Telegram Bot API.

## Особенности
  + Практически полная поддержка Telegram Bot API
  + Простой интерфейс
  + Асинхронная обработка запросов
  + Встроенная поддержка работы с платежами в Telegram Stars
  + Встроенные методы для простой обработки команд, в том числе callback
  + Вы сами даёте названия событиям, из коробки у вас только - `bot.events.onGetUpdate(ctx)`
  + Простая работа с Web App (не сделан пример)
  + Поддержка LDoc (не полная)
  + Больше 10-ти примеров и они будут пополняться
  + Легкая интеграция с Tarantool

Из-за простой и понятной архитектуры, отсутствующий функционал добавлять несложно.

## Установка

### Предварительная сборка
```bash
bash tnt-tg-bot.pre-build.sh
```

## Примеры
  + `examples/echo-bot.lua` - Простой эхо-бот
  + `examples/ping-pong.lua` - Реакция на команду /ping
  + `examples/send-animation.lua` - Отправка gif по команде /get_animation
  + `examples/send-document.lua` - Отправка документа по команде /get_document
  + `examples/send-image.lua` - Отправка изображения по команде /get_image
  + `examples/send-image-2.lua` - Упрощенный пример отправки изображения через `bot.sendImage`
  + `examples/send-media-group.lua` - Отправка группы медиа-файлов
  + `examples/simple-callback.lua` - Пример обработки callback - /send_callback
  + `examples/simple-callback-2.lua` - Упрощенный пример обработки callback команд
  + `examples/simple-process-commands.lua` - Пример простого процессинга команд
  + `examples/routes-example/init.lua` - Пример работы ручек в боте
  + `examples/stars-payment/init.lua` - Пример обработки платежей в звездах

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

| Метод/Свойство | Описание | Пример использования |
|---------------|---------|---------------------|
| bot:cfg | Инициализация настроек | `bot:cfg { token = "123468:foobarBAZ" }` |
| bot.call | Выполнение запроса к Telegram API | `bot.call('sendMessage', {chat_id = 123, text = 'Привет!'})` |
| bot.events | Таблица с пользовательскими событиями | `function bot.events.onPoll(ctx) ... end` |
| bot.events.onGetUpdate | Событие обработки обновлений от Telegram | `function bot.events.onGetUpdate(ctx) ... end` |
| bot.sendImage | Упрощенная отправка картинки | `examples/send-image-2.lua`  |
| bot.Command | Минимальный обработчик команд | `bot.Command(ctx)` |
| bot.CallbackCommand | Минимальный обработчик callback команд | `bot.CallbackCommand(ctx)`
| bot:startWebHook | Запуск бота на удаленном сервере | (позже будет пример) |
| bot:startLongPolling | Запуск бота в режиме long polling | Любой пример из `examples/*` |

По наличию аргументов см. ldoc - `doc/index.html`

## Вклад в проект
Через форк репозитория и открытия Pull Request
