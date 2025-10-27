--- Subject
--
local Subject = {}
Subject.__index = Subject

function Subject:new()
  local obj = {}
  obj.observers = {}

  setmetatable(obj, self)
  return obj
end

function Subject:subscribe(observer)
  table.insert(self.observers, observer)
end

function Subject:unsubscribe(observer)
  for i = #self.observers, 1, -1 do
    local o = self.observers[i]

    if o == observer then
      table.remove(self.observers, i)
      return true
    end
  end
  return false
end

function Subject:notify(event, ctx)
  for i = #self.observers, 1, -1 do
    local observer = self.observers[i]
    if observer.update then
      observer:update(event, ctx)
    end
  end
end

return Subject
