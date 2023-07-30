---
-- Module for working with math.
-- @module math

local M = {}

---
-- Factorial / Permutation (1 * ... * n)
-- To calculate the number of permutation options, for example.
-- @param n Number
-- @return number 
M.factorial = function(n)
  local res = 1
  for i = 1, n do
  res = i * res
  end

  return res
end

---
-- Arrangement
-- Selection of k elements from n with regard to order
-- Or the formula for calculating the number of arrangements without repetitions
-- @param n Number
-- @param k Number
-- @return number 
M.placement = function(n, k)
  return M.factorial(n) / M.factorial(n - k)
end

---
-- Combination
-- Selection without regard to order
-- @param n Number
-- @param k Number
-- @return number 
M.combination = function(n, k)
  return M.factorial(n) / (M.factorial(n - k) * M.factorial(k))
end

---
-- sign
-- @param x int
-- @return integer
M.sign = function(x)
  return (x > 0) and 1 or (x == 0 and 0 or -1)
end

---
-- round
-- @param x int
-- @return integer
M.round = function(x)
  return (x >= 0) and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

---
-- clamp
-- @param val Source value
-- @param val_min Minimal value
-- @param val_max Maximal value
-- @return integer
M.clamp = function(val, val_min, val_max)
  return math.max(val_min, math.min(val_max, val))
end

---
-- lerp
-- @param v0 Source value
-- @param v1 To value
-- @param t Time
-- @return float
M.lerp = function(v0, v1, t)
  return v0 * (1.0 - t) + t * v1
end

---
-- lengthdirX
-- @param length Length
-- @param direction Direction
-- @return float
M.lengthdirX = function(length, direction)
  return length * math.cos(direction)
end

---
-- lengthdirY
-- @param length Length
-- @param direction Direction
-- @return float
M.lengthdirY = function(length, direction)
  return length * math.sin(direction)
end

---
-- distance2point
-- @param x1 x1
-- @param y1 y1
-- @param x2 x2
-- @param y2 y2
-- @return float
M.distance2point = function(x1, y1, x2, y2) 
  return math.sqrt((x1 - x2)^2 + (y1 - y2)^2)
end

return M
