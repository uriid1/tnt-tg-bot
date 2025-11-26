-- Сервис CRUD к пользователям в чате
--
local sql = require('bot.ext.sql')
local ChatUser = require('src.models.ChatUser')
local merge = require('src.utils.merge')

local SPACE = 'chat_users'

local service = {}

--- Создание записи
-- @param data (table) record(s)
-- @return[1] model chat_user
-- @return[2] err
function service.create(data)
  local chat_user, errs = ChatUser(data, { init = true })
  if errs then
    return nil, errs
  end

  local _, err = sql.create(SPACE, chat_user)
  if err then
    return nil, err
  end

  return chat_user, nil
end

--- Чтение записи
-- @param user_id (number) user id
-- @param chat_id (number) chat id
-- @return[1] model chat
-- @return[2] err
function service.read(user_id, chat_id)
  local item, err = sql([[
    SELECT * FROM ]]..SPACE..[[ WHERE chat_id = ${chat_id} AND user_id = ${user_id}
  ]], {
    chat_id = chat_id,
    user_id = user_id
  })
  if err then
    return nil, err
  end

  if item == nil then
    return nil, nil
  end

  local chat, errs = ChatUser(item[1])
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
-- @param chat_id (number) chat id
-- @return[1] res
-- @return[2] err
function service.delete(user_id, chat_id)
  local res, err = sql([[
    DELETE FROM ]]..SPACE..[[ WHERE user_id = ${user_id} AND chat_id = ${chat_id}
  ]], {
    user_id = user_id,
    chat_id = chat_id
  })

  return res, err
end

--- Гарантированное создание записи (если записи не существует)
-- @param data (table) chat object
-- @return[1] chat_user model
-- @return[2] err
function service.ensure(data)
  local chat_id = data.chat_id
  local user_id = data.user_id

  if chat_id == nil then
    error('Field chat_id is empty', 1)
  elseif user_id == nil then
    error('Field user_id is empty', 1)
  end

  local chatUser, err = service.read(user_id, chat_id)
  if err or chatUser then
    return chatUser, err
  end

  return service.create(data)
end

--- Добавление или обновление записи
-- @param data (table) fields
-- @return[1] model user_chat
-- @return[2] err
function service.upsert(data)
  local chat_id = data.chat_id
  local user_id = data.user_id

  -- Read record
  local chat_user, err = service.read(user_id, chat_id)
  if err then
    return nil, err
  end

  -- Create record
  if chat_user == nil then
    return service.create(data)
  end

  -- Update record
  local model, errs = ChatUser(merge(chat_user, data), { init = true })
  if errs then
    return nil, errs
  end

  local _, err = service.update(model, {
    user_id = user_id,
    chat_id = chat_id
  })

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
