--- Force Reply
  --
  -- see https://core.telegram.org/bots/api#forcereply
-- @module bot.types.ForceReply
local function ForceReply(data)
  if not data then
    return {
      force_reply = true
    }
  end

  local obj = {
    force_reply = true,
    input_field_placeholder = data.input_field_placeholder,
    selective = data.selective
  }

  return obj
end

return ForceReply
