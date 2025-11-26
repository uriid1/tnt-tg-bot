--- Рекурсивное объединение двух таблиц
--
-- @module merge
local merge

--- Функция объединения
--
-- @param t1 (table) Первая таблица
-- @param t2 (table) Вторая таблица
-- @return Мутированная первая таблица из t1 + t2 полей
-- @usage
  -- local tbl = merge({ type = 'bot' }, { id = 100 })
  -- print(tbl.type) -- 'bot'
  -- print(tbl.id) -- 100
function merge(t1, t2)
  for k, v in pairs(t2) do
    if (type(v) == 'table') and (type(t1[k] or false) == 'table') then
      merge(t1[k], t2[k])
    else
      t1[k] = v
    end
  end

  return t1
end

return merge
