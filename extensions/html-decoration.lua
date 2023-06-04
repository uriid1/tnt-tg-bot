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

local html_escape_map = {
  ["<"] = "&lt;",
  [">"] = "&gt;",
  ["&"] = "&amp;",
  ['"'] = "&quot;",
  ["'"] = "&#039;",
}

-- Format
function format(text)
    text = tostring(text)
    return string.gsub(text, "[<>&\"']", html_escape_map)
end

-- Bold
function bold(text)
    return "<b>"..format(text).."</b>"
end

-- Italic
function italic(text)
    return "<i>"..format(text).."</i>"
end

-- Monospace
function monospaced(text)
    return "<code>"..format(text).."</code>"
end

-- M.mono = M.monospaced

-- Strike
function strike(text)
    return "<strike>"..format(text).."</strike>"
end

-- Underline
function underline(text)
    return "<u>"..format(text).."</u>"
end

-- Code
function code(lang, code)
    return ('<pre language="%s">%s</pre>'):format(lang, code)
end

-- URL
function url(url, link_name)
    return ('<a href="%s">%s</a>'):format(url, format(link_name))
end

-- User URL
function user_url(id, link_name)
    return ('<a href="tg://user?id=%s">%s</a>'):format(id, format(link_name))
end

-- Comvert object User to link
function user(User)
    if not User then
        return 'Nil'
    end

    if not User.id or not User.first_name then
        return 'Nil'
    end

    return ('<a href="tg://user?id=%s">%s</a>'):format(User.id, format(User.first_name))
end

-- Comvert object Chat to link
function chat(Chat)
    if not Chat then
        return 'Nil'
    end

    if not Chat.id or not Chat.title then
        return 'Nil'
    end

    if Chat.invite_link then
        return ('<a href="%s">%s</a>'):format(Chat.invite_link, format(Chat.title))
    end

    return ('<a href="https://t.me/%s">%s</a>'):format(Chat.username, format(Chat.title))
end

-- Message URL
function message_url(username, id, link_name)
    return ('<a href="https://t.me/%s/%s">%s</a>'):format(username, id, format(link_name))
end

-- Spoiler
function spoiler(text)
    return ("<tg-spoiler>%s</tg-spoiler>"):format(format(text))
end

return {
    format = format;
    bold = bold;
    italic = italic;
    monospaced = monospaced;
    mono = monospaced;
    strike = strike;
    underline = underline;
    code = code;
    url = url;
    user_url = user_url;
    user = user;
    chat = chat;
    message_url = message_url;
    spoiler = spoiler;
}
