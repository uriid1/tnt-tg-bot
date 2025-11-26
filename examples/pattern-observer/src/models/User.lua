---
--
local Errors = require('src.models.Errors')

local function User(data, opts)
  local init = opts and opts.init

  local model = {}
  local errors = Errors:new()

  if tonumber(data.id) then
    model.id = tonumber(data.id)
  else
    errors:add {
      field = 'id',
      type = 'number',
      code = errors.REQUIRED_FIELD_MISSING
    }
  end

  if data.first_name then
    model.first_name = tostring(data.first_name)
  elseif init then
    model.first_name = ''
  end

  if data.last_name then
    model.last_name = tostring(data.last_name)
  elseif init then
    model.last_name = ''
  end

  if data.username then
    model.username = data.username
  else
    model.username = box.NULL
  end

  if data.language_code then
    model.language_code = tostring(data.language_code)
  elseif init then
    model.language_code = 'ru'
  end

  -- Игровая схема
  --
  if data.status then
    model.status = tostring(data.status)
  elseif init then
    -- TODO: Статус определяется по текстам с привязкой к языку
    model.status = 'Малой'
  end

  if data.energy then
    model.energy = tonumber(data.energy)
  elseif init then
    model.energy = 10
  end

  if data.eat then
    model.eat = tonumber(data.eat)
  elseif init then
    model.eat = 0
  end

  if data.balance then
    model.balance = tonumber(data.balance)
  elseif init then
    model.balance = 0
  end

  if data.reserved_balance then
    model.reserved_balance = tonumber(data.reserved_balance)
  elseif init then
    model.reserved_balance = 0
  end

  if data.likes then
    model.likes = tonumber(data.likes)
  elseif init then
    model.likes = 0
  end

  if data.health then
    model.health = tonumber(data.health)
  elseif init then
    model.health = 100
  end

  if data.hooliganism then
    model.hooliganism = tonumber(data.hooliganism)
  elseif init then
    model.hooliganism = 100
  end

  if data.stats then
    model.stats = setmetatable(data.stats, { __serialize = 'map' })
  elseif init then
    model.stats = setmetatable({}, { __serialize = 'map' })
  end
  --

  if data.started_bot ~= nil then
    model.started_bot = data.started_bot and true or false
  elseif init then
    model.started_bot = false
  end

  if errors:has_errors() then
    return nil, errors
  end

  return model, nil
end

-- local model, errs = User({
--   id = uuid()
-- }, { init = true })

-- require('pimp')(model)
-- if errs then
--   require('pimp')(errs)
--   require('pimp')(errs:to_string())
-- end

return User
