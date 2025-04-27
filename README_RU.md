Russian | [English](README.md)</br>

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

## Вклад в проект
Через форк репозитория и открытия Pull Request
