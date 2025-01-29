--- Enum entity_type
--

-- https://core.telegram.org/api/errors
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

--- errors
-- @table export
return errors
