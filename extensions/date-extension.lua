--[[
   ####--------------------------------####
   #--# Author:   by uriid1            #--#
   #--# License:  GNU GPLv3            #--#
   #--# Telegram: @main_moderator      #--#
   #--# E-mail:   appdurov@gmail.com   #--#
   ####--------------------------------####
--]]

local function set_hours(date, h, m, s)
   date.hour = h
   date.min = m
   date.sec = s
   return os.time(date)
end

local function get_timezone()
   local now = os.time()
   return os.difftime(now, os.time(os.date("!*t", now)))
end

local function to_iso8601(unixtime)
   unixtime = unixtime or os.time()
   return os.date('!%Y-%m-%dT%TZ', unixtime)
end

local function to_unix(date)
   if type(date) ~= 'string' then
      return os.time()
   end

   local yy, mm, dd, hh, min, sec = date:match('^(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)Z$')
   if not yy or
      not mm or
      not dd or
      not hh or
      not min or
      not sec
   then
      return nil
   end

   return os.time({year=yy, month=mm, day=dd, hour=hh, min=min, sec=sec})
end

return {
   get_timezone = get_timezone;
   set_hours = set_hours;
   to_iso8601 = to_iso8601;
   to_unix = to_unix;
}
