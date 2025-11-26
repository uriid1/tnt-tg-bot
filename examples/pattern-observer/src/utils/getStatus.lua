---
--
local ENUM_STATUS = {
  'На пути к семкам',
  'Может позволить тапки',
  'Покупает шаверму',
  'Любитель семок',
  'Король магнитол',
  'Главный на районе',
  'Боятся даже кавказцы',
  'Яростный тип';
  'Весь город в его подчинении',
  'Легенда'
}

local function getStatus(money)
  if money < 1000 then
    return ENUM_STATUS[1]
  elseif money < 5000 then
    return ENUM_STATUS[2]
  elseif money < 10000 then
    return ENUM_STATUS[3]
  elseif money < 15000 then
    return ENUM_STATUS[4]
  elseif money < 20000 then
    return ENUM_STATUS[5]
  elseif money < 30000 then
    return ENUM_STATUS[6]
  elseif money < 50000 then
    return ENUM_STATUS[7]
  elseif money < 80000 then
    return ENUM_STATUS[8]
  elseif money < 100000 then
    return ENUM_STATUS[9]
  elseif money < 1000000 then
    return ENUM_STATUS[9]
  end
end

return getStatus
