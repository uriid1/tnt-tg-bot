--- Default bot logger
--
local defaultLogger = require('log')

local current = defaultLogger

local wrapper = {}

function wrapper.init(pkg)
  if pkg then
    current = pkg
  else
    current = defaultLogger
  end
  return wrapper
end

function wrapper.cfg(opts)
  if current.cfg then
    return current.cfg(opts)
  end
end

function wrapper.info(...)
  return current.info(...)
end

function wrapper.verbose(...)
  return current.verbose(...)
end

function wrapper.debug(...)
  return current.debug and current.debug(...) or current.verbose
end

function wrapper.warn(...)
  return current.warn(...)
end

function wrapper.error(...)
  return current.error(...)
end

-- Test
-- log.info("[info] %s | %s", 'GET', '200')
-- log.info({ message = 'Hello from logger' })
-- log.verbose("[verbose] %s | %s", 'command', '/start')
-- log.warn("[warn] %s | %s", 'event', 'user 1234 not found')
-- log.error("[error] %s | %s", 'fatal', 'function foo.bar, line 123')

return wrapper
