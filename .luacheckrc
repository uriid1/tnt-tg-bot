std = 'min'
max_line_length = 130

globals = {
  -- Module bot
  'bot',
  '_TARANTOOL',
}

read_globals = {
  -- Module box
  'box',

  -- Module string
  'string.ljust',
  'string.rjust',
  'string.hex',
  'string.fromhex',
  'string.startswith',
  'string.endswith',
  'string.lstrip',
  'string.rstrip',
  'string.split',
  'string.strip',

  -- Module table
  'table.clear',
  'table.copy',
  'table.deepcopy',
  'table.foreach',
  'table.foreachi',
  'table.maxn',
  'table.move',
  'table.new',

  -- Module os
  'os.environ',
  'os.setenv',

  -- Math
  'math.pow'
}

ignore = {
  '411', -- Redefining a local variable.
  '412', -- Redefining an argument.
  '413', -- Redefining a loop variable.
  '421', -- Shadowing a local variable.
  '422', -- Shadowing an argument.
  '423', -- Shadowing a loop variable.
  '431', -- Shadowing an upvalue.
  '432', -- Shadowing an upvalue argument.
  '433', -- Shadowing an upvalue loop variable.
  '581' -- 'not (x == y)'
}
