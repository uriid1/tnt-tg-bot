--[[
    ####--------------------------------####
    #--# Author:   by uriid1            #--#
    #--# License:  GNU GPLv3            #--#
    #--# Telegram: @main_moderator      #--#
    #--# E-mail:   appdurov@gmail.com   #--#
    ####--------------------------------####
--]]

--[[ HTML
    <b>bold</b>
    <strong>bold</strong>
    <i>italic</i>
    <em>italic</em>
    <u>underline</u>
    <ins>underline</ins>
    <s>strikethrough</s>
    <strike>strikethrough</strike>
    <del>strikethrough</del>
    <span class="tg-spoiler">spoiler</span>
    <tg-spoiler>spoiler</tg-spoiler>
    <b>bold <i>italic bold <s>italic bold strikethrough <span class="tg-spoiler">italic bold strikethrough spoiler</span></s> <u>underline italic bold</u></i> bold</b>
    <a href="http://www.example.com/">inline URL</a>
    <a href="tg://user?id=123456789">inline mention of a user</a>
    <code>inline fixed-width code</code>
    <pre>pre-formatted fixed-width code block</pre>
    <pre><code class="language-python">pre-formatted fixed-width code block written in the Python programming language</code></pre>
]]

-- Main
local M = {}

local html_escape_map = {
  ["<"] = "&lt;",
  [">"] = "&gt;",
  ["&"] = "&amp;",
  ['"'] = "&quot;",
  ["'"] = "&#039;",
}

-- Format
function M.format(text)
    -- Debug
    if not text then
        return ""
    end

    return string.gsub(text, "[<>&\"']", html_escape_map)
end

-- Bold
function M.bold(text)
    return "<b>"..text.."</b>"
end

-- Italic
function M.italic(text)
    return "<i>"..text.."</i>"
end

-- Monospace
function M.monospaced(text)
    return "<code>"..text.."</code>"
end

M.mono = M.monospaced

-- Strike
function M.strike(text)
    return "<strike>"..text.."</strike>"
end

-- Underline
function M.underline(text)
    return "<u>"..text.."</u>"
end

-- Code
function M.code(lang, code)
    return ('<pre language="%s">%s</pre>'):format(lang, code)
end

-- URL
function M.url(url, link_name)
    return ('<a href="%s">%s</a>'):format(url, M.format(link_name))
end

-- User URL
function M.user_url(id, link_name)
    return ('<a href="tg://user?id=%s">%s</a>'):format(id, M.format(link_name))
end

-- Message URL
function M.message_url(username, id, link_name)
    return ('<a href="https://t.me/%s/%s">%s</a>'):format(username, id, M.format(link_name))
end

-- Spoiler
function M.spoiler(text)
    return M.format(("<tg-spoiler>%s</tg-spoiler>"):format(text))
end

return M
