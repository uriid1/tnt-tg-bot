-- Сервис CRUD к пользователям
--
local sql = require('bot.ext.sql')
local User = require('src.models.User')
local merge = require('src.utils.merge')

local SPACE = 'users'

local service = {}

--- Создание записи
-- @param data (table) record(s)
-- @return[1] model user
-- @return[2] err
function service.create(data)
  local user, errs = User(data, { init = true })
  if errs then
    return nil, errs
  end

  local _, err = sql.create(SPACE, user)
  if err then
    return nil, err
  end

  return user, nil
end

--- Чтение записи
-- @param user_id (number) user id
-- @return[1] model user
-- @return[2] err
function service.read(user_id)
  local item, err = sql([[SELECT * FROM ]]..SPACE..[[ WHERE id = ${id}]], { id = user_id })
  if err then
    return nil, err
  end

  if item == nil then
    return nil, nil
  end

  local user, errs = User(item[1])
  if errs then
    return nil, errs
  end

  return user, nil
end

--- Обновление записи
-- @param fields (table) fields
-- @param where (table) where condition
-- @return[1] res
-- @return[2] err
function service.update(fields, where)
  local res, err = sql.update(SPACE, fields, where)
  return res, err
end

--- Удаление записи
-- @param user_id (number) user id
-- @return[1] res
-- @return[2] err
function service.delete(user_id)
  local res, err = sql([[DELETE FROM ]]..SPACE..[[ WHERE id = ${id}]], { id = user_id })
  return res, err
end

--- Гарантированное создание записи (если записи не существует)
-- @param data (table) user object
-- @return[1] user model
-- @return[2] err
function service.ensure(data)
  local user_id = data.id

  if user_id == nil then
    error('Field id is empty', 1)
  end

  local user, err = service.read(user_id)
  if err or user then
    return user, err
  end

  return service.create(data)
end

--- Добавление или обновление записи (целиком)
-- @param data (table) fields
-- @return[1] model user
-- @return[2] err
function service.upsert(data)
  local user_id = data.id

  -- Read record
  local user, err = service.read(user_id)
  if err then
    return nil, err
  end

  -- Create record
  if user == nil then
    return service.create(data)
  end

  -- Update record
  local model, errs = User(merge(user, data), { init = true })
  if errs then
    return nil, errs
  end

  local _, err = service.update(model, { id = user_id })
  if err then
    return nil, err
  end

  return model, err
end

--- Операция, обновляющая только одно поле
-- function service.patch(user_id, field)
  -- ...
-- end

return service
