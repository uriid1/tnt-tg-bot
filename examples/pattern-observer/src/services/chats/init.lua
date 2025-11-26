-- Сервис CRUD к чатам
--
local sql = require('bot.ext.sql')
local Chat = require('src.models.Chat')
local merge = require('src.utils.merge')

local SPACE = 'chats'

local service = {}

--- Создание записи
-- @param data (table) record(s)
-- @return[1] model chat
-- @return[2] err
function service.create(data)
  local chat, errs = Chat(data, { init = true })
  if errs then
    return nil, errs
  end

  local _, err = sql.create(SPACE, chat)
  if err then
    return nil, err
  end

  return chat, nil
end

--- Чтение записи
-- @param user_id (number) chat id
-- @return[1] model chat
-- @return[2] err
function service.read(chat_id)
  local item, err = sql([[SELECT * FROM ]]..SPACE..[[ WHERE id = ${id}]], {
    id = chat_id
  })
  if err then
    return nil, err
  end

  if item == nil then
    return nil, nil
  end

  local chat, errs = Chat(item[1])
  if errs then
    return nil, errs
  end

  return chat, nil
end

--- Обновление записи
-- @param data (table) fields
-- @param where (table) where condition
-- @return[1] res
-- @return[2] err
function service.update(data, where)
  local res, err = sql.update(SPACE, data, where)
  return res, err
end

--- Удаление записи
-- @param user_id (number) user id
-- @return[1] res
-- @return[2] err
function service.delete(user_id)
  local res, err = sql([[DELETE FROM ]].. SPACE..[[ WHERE id = ${id}]], {
    id = user_id
  })
  return res, err
end

--- Гарантированное создание записи (если записи не существует)
-- @param data (table) chat object
-- @return[1] user model
-- @return[2] err
function service.ensure(data)
  local chatId = data.id
  if chatId == nil then
    error('Field id is empty', 1)
  end

  local chat, err = service.read(chatId)
  if err or chat then
    return chat, err
  end

  return service.create(data)
end

--- Добавление или обновление записи
-- @param data (table) fields
-- @return[1] model chat
-- @return[2] err
function service.upsert(data)
  local chat_id = data.id

  -- Read record
  local chat, err = service.read(chat_id)
  if err then
    return nil, err
  end

  -- Create record
  if chat == nil then
    return service.create(data)
  end

  -- Update record
  local model, errs = Chat(merge(chat, data), { init = true })
  if errs then
    return nil, errs
  end

  local _, err = service.update(model, { id = chat_id })
  if err then
    return nil, err
  end

  return model, err
end

--- Операция, обновляющая только одно поле
-- function service.patch(id, field)
  -- ...
-- end

return service
