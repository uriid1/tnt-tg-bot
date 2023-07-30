---
-- Module for working with table.
-- @module table

local M = {}

local type = type
local next = next 
local table_insert = table.insert
local table_remove = table.remove
local table_concat = table.concat
local table_random = math.random

---
-- Checking if a table is empty
-- @param t Table
-- @return boolean 
M.isEmpty = function(t)
  return not next(t)
end

---
-- Checking if it is a table
-- @param t Table
-- @return boolean
M.isTable = function(t)
  return type(t) == 'table'
end

---
-- Checking if a table is an array
-- @param t Table
-- @return boolean
M.isArray = function(t)
  if type(t) ~= 'table' then
  return false
  end

  local i = 1
  for _ in next, t do
  if t[i] == nil then
    return false
  end

  i = i + 1
  end

  return true
end

---
-- Inserting an item at the end of an array
-- @param t Table
-- @param item? Item 
M.push = function(t, item)
  table_insert(t, #t+1, item)
end

---
-- Returns the first element of the table, then deletes it by making an offset
-- @param t Table
-- @return first element or empty table
M.shift = function(t)
  local tmp = {}
  table_insert(tmp, t[1])
  table_remove(t, 1)
  return tmp[1] or {}
end

---
-- Merging table t2 into t1 (is not deep copy)
-- @param t1 Table
-- @param t2 Table
function M.merge(t1, t2)
  for key, value in pairs(t2) do
  if type(value) == 'table' then
    if type(t1[key]) == 'table' then
    M.merge(t1[key], t2[key])
    end
  else
    t1[key] = value
  end
  end

  return t1
end

---
-- Compare t1 and t2
-- @param t1 Table
-- @param t2 Table
function M.compare(t1, t2)
  -- Check element count
  local count1 = 0
  for _ in pairs(t1) do
  count1 = count1 + 1
  end

  local count2 = 0
  for _ in pairs(t2) do
  count2 = count2 + 1
  end

  if count1 ~= count2 then
  return false
  end

  -- Check key value
  for key, value in pairs(t1) do
  if type(value) == 'table' then
    if type(t2[key]) ~= 'table' or not M.compare(value, t2[key]) then
    return false
    end
  else
    if value ~= t2[key] then
    return false
    end
  end
  end

  return true
end

---
-- Reverse the table
-- @param t Table
-- @return table
M.reverse = function(t)
  local tbl = {}
  for i = #t, 1, -1 do
  table_insert(tbl, #tbl+1, t[i])
  end

  return tbl
end

---
-- Fills all elements of the array from the start to the end(done) indexes with a single value
-- @param t Table
-- @param value Value
-- @param start Start of fill
-- @param done End of fill
M.fill = function(t, value, start, done)
  for i = start, done do
  t[i] = value
  end
end

---
-- Returns a string representation of array elements
-- @param t Table
-- @param sep Separator
-- @param start Start
-- @param done End
-- @return table
M.toString = function(t, sep, start, done)
  return table_concat(t, sep or ',', start or 1, done or #t)
end

---
-- Shuffles the table
-- @param t Table
M.shake = function(t)
  for i = #t, 1, -1 do
  local rnd_index = table_random(i)
  t[rnd_index], t[i] = t[i], t[rnd_index]
  end
end

return M
