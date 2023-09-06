--- HTML formatting functions.
-- @module html_formatter
local M = {}

local html_escape_map = {
  ["<"] = "&lt;",
  [">"] = "&gt;",
  ["&"] = "&amp;",
  ['"'] = "&quot;",
  ["'"] = "&#039;",
}

---
-- Format HTML-unsafe characters as HTML entities.
-- @param text The input text.
-- @return The formatted text.
function M.format(text)
  text = tostring(text)
  return string.gsub(text, "[<>&\"']", html_escape_map)
end

---
-- Wrap the input text in <b> tags for bold formatting.</b>
-- @param text The input text.
-- @return The formatted text.
function M.bold(text)
  return "<b>"..M.format(text).."</b>"
end

---
-- Wrap the input text in <i> tags for italic formatting.</i>
-- @param text The input text.
-- @return The formatted text.
function M.italic(text)
  return "<i>"..M.format(text).."</i>"
end

---
-- Wrap the input text in "code" tags for monospaced formatting.
-- @param text The input text.
-- @return The formatted text.
function M.monospaced(text)
  return "<code>"..M.format(text).."</code>"
end

---
-- Wrap the input text in <strike> tags for strike-through formatting.</strike>
-- @param text The input text.
-- @return The formatted text.
function M.strike(text)
  return "<strike>"..M.format(text).."</strike>"
end

---
-- Wrap the input text in <u> tags for underline formatting.</u>
-- @param text The input text.
-- @return The formatted text.
function M.underline(text)
  return "<u>"..M.format(text).."</u>"
end

---
-- Generate a "pre" code block with a specified language for code formatting.
-- @param lang The programming language for syntax highlighting.
-- @param text The code text.
-- @return The formatted code block.
function M.code(lang, text)
  return ('<pre language="%s">%s</pre>'):format(lang, text)
end

---
-- Generate an HTML hyperlink.
-- @param source The URL.
-- @param name The link text.
-- @return The formatted hyperlink.
function M.url(source, name)
  return ('<a href="%s">%s</a>'):format(source, M.format(name))
end

---
-- Generate a Telegram user mention link.
-- @param id The user ID.
-- @param link_name The link text.
-- @return The formatted user mention link.
function M.user_url(id, link_name)
  return ('<a href="tg://user?id=%s">%s</a>'):format(id, M.format(link_name))
end

---
-- Convert a Telegram User object to a mention link.
-- @param User The User object.
-- @return The formatted user mention link.
function M.user(User)
  if not User or not User.id or not User.first_name then
    return 'Nil'
  end
  return ('<a href="tg://user?id=%s">%s</a>'):format(User.id, M.format(User.first_name))
end

---
-- Convert a Telegram Chat object to a mention link.
-- @param Chat The Chat object.
-- @return The formatted chat mention link.
function M.chat(Chat)
  if not Chat or not Chat.id or not Chat.title then
    return 'Nil'
  end
  if Chat.invite_link then
    return ('<a href="%s">%s</a>'):format(Chat.invite_link, M.format(Chat.title))
  end
  return ('<a href="https://t.me/%s">%s</a>'):format(Chat.username, M.format(Chat.title))
end

---
-- Generate a Telegram message URL.
-- @param username The username of the user or chat.
-- @param id The message ID.
-- @param link_name The link text.
-- @return The formatted message URL.
function M.message_url(username, id, link_name)
  return ('<a href="https://t.me/%s/%s">%s</a>'):format(username, id, M.format(link_name))
end

---
-- Wrap the input text in "tg-spoiler" tags for spoiler formatting.
-- @param text The input text.
-- @return The formatted text.
function M.spoiler(text)
  return ("<tg-spoiler>%s</tg-spoiler>"):format(M.format(text))
end

return M
