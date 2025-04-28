--- Enum errors

---
-- See: <a href="https://core.telegram.org/api/errors">Errors</a>
-- @table bot.enums.errors
-- @field SEE_OTHER
-- @field BAD_REQUEST
-- @field UNAUTHORIZED
-- @field FORBIDDEN
-- @field NOT_FOUND
-- @field NOT_ACCEPTABLE
-- @field FLOOD
-- @field TOO_MANY_REQUESTS
-- @field INTERNAL
local errors = {
  SEE_OTHER = 303,
  BAD_REQUEST = 400,
  UNAUTHORIZED = 401,
  FORBIDDEN = 403,
  NOT_FOUND = 404,
  NOT_ACCEPTABLE = 406,
  FLOOD = 420,
  TOO_MANY_REQUESTS = 429,
  INTERNAL = 500,
}

return errors
