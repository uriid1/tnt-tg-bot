--
local function set_hours(tbl_date, h, m, s)
   tbl_date.hour = h
   tbl_date.min  = m
   tbl_date.sec  = s
   return os.time(tbl_date)
end

local function get_timezone()
   local now = os.time()
   return os.difftime(now, os.time(os.date("!*t", now)))
end

return {
   get_timezone = get_timezone;
   set_hours = set_hours;
}
