-- https://github.com/uriid1/uriid1-lua-extensions/blob/dd8bd47f67169504a3ffd8229d003cf0aceba8cb/src/extensions/ustring.lua#L79C1-L95C4
local function split(text, sep, max)
  sep = sep or ' '

  local result = {}
  local i = 1
  for part in text:gmatch("[^"..sep.."]+") do
    result[i] = part

    if i == max then
      break
    end

    i = i + 1
  end

  return result
end

return split
