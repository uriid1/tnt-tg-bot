local log = require('log')

-- luacheck: ignore loadstring

--- Lua format string
-- @param text text
-- @param args table
-- @param opts options
local function fstring(text, args, opts)
  local eval = opts and opts.eval or false

  local res, _ = string.gsub(text, '%${([%w_]+)}', args)

  if eval then
    res, _ = res:gsub('([\n]-){{%s*(.-)%s*}}?([\n]-)', function (nl1, temp, nl2)
      ---@diagnostic disable-next-line: deprecated
      local func, err = (load or loadstring)(temp)
      local res
      if not err then
        ---@diagnostic disable-next-line: need-check-nil
        res = func()

        if res == nil then
          return ''
        end

        return nl1 .. res .. nl2
      else
        log.error(err)
      end

      return ''
    end)
  end

  return res
end

return fstring
