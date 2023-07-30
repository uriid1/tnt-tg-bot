---
-- Module for init all modules.
-- @module init

local extension_string = require 'string'
local extension_table = require 'table'
local extension_math = require 'math'
local extension_date = require 'date'

return {
  string = extension_string;
  table = extension_table;
  date = extension_math;
  math = extension_date;
}
