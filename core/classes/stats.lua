-- Class definition
--
local stats = {}
stats.__index = stats

function stats:new(name, max_count)
  self[name] = {
    count = max_count or 10;
    parts = {};
  }

  return setmetatable({}, self)
end

function stats:put(name, val)
  if not self[name] then
    return nil
  end

  if #self[name] == self.count then
    table.remove(self[name].parts, self.count)
  end

  table.insert(self[name].parts, val)
end

function stats:getAverage(name)
  if not self[name] then
    return nil
  end

  local sum = 0
  for i = 1, #self[name].parts do
    sum = sum + self[name].parts[i]
  end

  return sum/#self[name].parts
end

return stats
