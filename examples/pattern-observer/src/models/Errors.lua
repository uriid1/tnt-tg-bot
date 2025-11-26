---
--
local errors = {
  REQUIRED_FIELD_MISSING = 'required_field_missing'
}
errors.__index = errors

-- TODO: Можно добавить ссылку на space, чтобы потом по формату
-- передавать только имя поля, и модуль мог сам определить код и тип ошибки.
-- Например: WRONG_TYPE когда передан неправильный тип поля к ожидаемому в формате спейса.
function errors:new()
  local obj = {
    errors = {},
    count = 0
  }
  setmetatable(obj, self)
  return obj
end

function errors:add(data)
  self.count = self.count + 1

  table.insert(self.errors, {
    field = data.field,
    type = data.type,
    details = data.details,
    -- TODO: Вынести коды ошибок в инам
    code = data.code or 'VALIDATION_ERROR',
  })
end

function errors:has_errors()
  return self.count > 0
end

function errors:get_errors()
  return self.errors
end

function errors:to_string()
  local result = {}
  for _, err in ipairs(self.errors) do
    table.insert(result, string.format(
      "[%s] %s: %s",
      err.code,
      err.field,
      err.details or 'Validation failed'
    ))
  end
  return table.concat(result, '\n')
end

return errors
