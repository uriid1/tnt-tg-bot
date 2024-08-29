--
-- Патч подмены 500 ошибки, на 200
-- Это решает проблему, когда бот падает из-за какой-либо ошибки -
-- а телеграм, получив 500 ошибку продолжает слать сообщения на сервер
-- из-за чего бот перестает быть доступен и приходится его перезапускать
--
local escape = require('escape')

local filePath = '.rocks/share/tarantool/http/server.lua'
local fd = io.open(filePath, 'rw+')
local data = fd:read('*a')

local funcFind = escape [[
        if not res then
            status = 500
            hdrs = {}
            local trace = debug.traceback()
            local logerror = get_error_logger(self.options, route)
            logerror('unhandled error: %s\n%s\nrequest:\n%s',
                     tostring(reason), trace, tostring(p))
            if self.options.display_errors then
            body =
                  "Unhandled error: " .. tostring(reason) .. "\n"
                .. trace .. "\n\n"
                .. "\n\nRequest:\n"
                .. tostring(p)
            else
                body = "Internal Error"
            end
]]

local funcReplace = escape [[
        if not res then
            status = 200
            hdrs = {}
            local trace = debug.traceback()
            local logerror = get_error_logger(self.options, route)
            logerror('unhandled error: %s\n%s\nrequest:\n%s',
                     tostring(reason), trace, tostring(p))
            if self.options.display_errors then
            body =
                  "Unhandled error: " .. tostring(reason) .. "\n"
                .. trace .. "\n\n"
                .. "\n\nRequest:\n"
                .. tostring(p)
            else
                body = "Internal Error"
            end
]]

local result, count = data:gsub(funcFind, funcReplace)
if count == 0 then
  print("Failed to apply http patch")
  os.exit(0)
else
  print("Patch http successfully applied")
end

fd:seek('set')
fd:write(result)
fd:close()
