--- Wrapper for execute sql
-- @module bot.ext.sql
local uuid = require('uuid')

--- Example
--[=[
local rows = sql("SELECT * FROM SEQSCAN users WHERE name = ${name}", { name = 'Alex' })
if rows == nil then
  log.error('No rows')
end
--]=]

local function escape(value)
  return string.format("'%s'", value:gsub("'", "''"))
end

local function cast(value, field_type)
  if field_type == 'uuid' then
    return string.format("CAST('%s' AS UUID)", value)

  elseif field_type == 'string' then
    return string.format("CAST(%s AS STRING)", escape(value))
  end

  return value
end

local sql
--- Execute sql query
-- @param sql_query (string) SQL string
-- @param values (table) Table of values
function sql(sql_query, values)
  local query
  if values then
    local castValues = {}
    for key, value in pairs(values) do
      local _type = type(value)
      if _type == 'cdata' then
        if uuid.is_uuid(value) then
          castValues[key] = cast(tostring(value), 'uuid')
        end
      else
        castValues[key] = cast(value, _type)
      end
    end

    query = string.gsub(sql_query, "%${([%w_]+)}", castValues)
  end

  local result = box.execute(query or sql_query)
  if result == nil then
    return nil
  elseif result.rows and next(result.rows) == nil then
    return nil
  end

  -- Mapping result
  local metadata = result.metadata
  local rows = {}
  if result.rows then
    for _, row in ipairs(result.rows) do
      local mapped_row = {}
      for i, value in ipairs(row) do
        local field_name = metadata[i].name
        mapped_row[field_name] = value
      end

      table.insert(rows, mapped_row)
    end
  end

  return rows
end

return sql
