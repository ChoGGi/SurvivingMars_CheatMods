--[[
Any code that isn't mine is under the respective copyright of that author.

All of my code is licensed under the MIT License as follows:

MIT License

Copyright (c) [2018] [ChoGGi]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

-- local any funcs used below
local tonumber,tostring = tonumber,tostring
local AsyncRand = AsyncRand
local TableConcat = oldTableConcat or table.concat

math = {
--~   returns -nan(ind) (I figure that's close enough)
  nan = 10e500 - 10e400,

--~   Returns the absolute value of x. (integer/float)
  sm_abs = abs,
  abs = function(x)
    x = tonumber(x)
    if not x then
      return math.nan
    end

    if x < 0 then
      x = 0 - x
    end
    return x
  end,
--~   Returns the smallest integral value larger than or equal to x.
  ceil = function(x)
    x = tonumber(x)

    if not x then
      return math.nan
    end

    return math.floor(x+.5)
    -- returns 0.0 instead of 0
--~     return x + 1 - (x%1)
  end,
--~   Converts the angle x from radians to degrees.
  deg = function(x)
    if not tonumber(x) then
      return math.nan
    end
    return x * 180.0 / math.pi
  end,
--~   Returns the value e^x (where e is the base of natural logarithms).
  exp = function(x)
    x = tonumber(x)
    if not x then
      return math.nan
    end

    return math.e^x
  end,
--~   Returns the largest integral value smaller than or equal to x.
  floor = floatfloor or function(x)
    return x - (x%1)
  end,
--~   Returns the remainder of the division of x by y that rounds the quotient towards zero. (integer/float)
  fmod = function(x, y)
    if math.type(x) == "integer" and math.type(y) == "integer" then
      local d = math.tointeger(y)
      if d + 1 <= 1 then
        if d ~= 0 then
          return 0
        end
      end
      if x > 0 then
        return math.tointeger(x) % d
      end
      -- return negative?
      return math.tointeger(x) % d * -1
    end
    return math.nan
  end,
--~   The float value HUGE_VAL, a value larger than any other numeric value.
  huge = 10e500 + 10e400,
--~   Returns the logarithm of x in the given base. The default for base is e (so that the function returns the natural logarithm of x).
  log = function(x,base)
    x = tonumber(x)
    if not x or x < 0 or tostring(x) == "0" then
      return math.nan
    end
    if tostring(x) == "1" then
      return 0.0
    end

    base = tonumber(base)
    if base then
      return math.log(x) / math.log(base)
    end
    base = math.e

--~     http://foldit.wikia.com/wiki/Lua_Script_Library#math.log_.28Taylor_Series_Approximation_.29
    local result = 0
    local residue = x / base
    while residue > 1 do
      residue = residue / base
      result = result + 1
    end
    local y = residue - 1
    -- just enough to get the same result as math.log()
    -- Taylor series
    residue = 1+y-y ^2/2+y ^3/3-y ^4/4+y ^5/5-y ^6/6+y ^7/7-y ^8/8+y
      ^9/9-y ^10/10+y ^11/11-y ^12/12+y ^13/13-y ^14/14+y ^15/15-y ^16/16+y
      ^17/17-y ^18/18+y ^19/19-y ^20/20+y ^21/21-y ^22/22+y ^23/23-y ^24/24+y
      ^25/25-y ^26/26+y ^27/27-y ^28/28+y ^29/29-y ^30/30+y ^31/31-y ^32/32+y
      ^33/33-y ^34/34+y ^35/35-y ^36/36+y ^37/37-y ^38/38+y ^39/39-y ^40/40+y
      ^41/41-y ^42/42+y ^43/43-y ^44/44+y ^45/45-y ^46/46+y ^47/47-y ^48/48+y
      ^49/49-y ^50/50+y ^51/51-y ^52/52+y ^53/53-y ^54/54+y ^55/55-y ^56/56
    result = result + residue
    return result
  end,
--~   Returns the argument with the maximum value, according to the Lua operator <. (integer/float)
  max = Max, -- (i, ...)
--~   An integer with the maximum value for an integer.
  maxinteger = 9223372036854775807,
--~   Returns the argument with the minimum value, according to the Lua operator <. (integer/float)
  min = Min, -- (i, ...)
--~   An integer with the minimum value for an integer.
  mininteger = -9223372036854775808,
--~   Returns the integral part of x and the fractional part of x. Its second result is always a float.
  modf = function(x)
    local num = tonumber(x)
    if not num then
      return math.nan
    end

    if math.type(x) == "integer" then
      return num,0.0
    else
      local int

      if num < 0 then
        int = math.ceil(num)
      else
        int = math.floor(num)
      end

      if num == int then
        num = num % 1
      else
        num = num - int
      end

      return int,num
    end
  end,
--~   pi is pi is pi
  pi = 3.1415926535898, -- that 8 should probably be a 7, but I suppose luac likes to round up?
--~   Converts the angle x from degrees to radians.
  rad = function(x)
    if not tonumber(x) then
      return math.nan
    end
    return x * math.pi / 180.0
  end,
--~   When called without arguments, returns a pseudo-random float with uniform distribution in the range [0,1).
--~   When called with two integers m and n, math.random returns a pseudo-random integer with uniform distribution in the range [m, n].
--~   (The value n-m cannot be negative and must fit in a Lua integer.) The call math.random(n) is equivalent to math.random(1,n).
  random = function(max,min)
    if max and min then
      return AsyncRand(max - min + 1) + min
    elseif max then
      return AsyncRand(max - 1 + 1) + 1
    else
      return tonumber(TableConcat{"0.",AsyncRand()})
    end
  end,
--~   Sets x as the "seed" for the pseudo-random generator: equal seeds produce equal sequences of numbers.
--~   The math.randomseed() function sets a seed for the pseudo-random generator: Equal seeds produce equal sequences of numbers.
  randomseed = AsyncSetSeed,
--~   Returns the square root of x.
  sqrt = function(x)
    x = tonumber(x)
    if not x or x < 0 then
      return math.nan
    end

    return x^0.5
  end,
--~   If the value x is convertible to an integer, returns that integer. Otherwise, returns nil.
  tointeger = function(x)
    if not tonumber(x) then
      return
    end
    return math.floor(x)
  end,
--~   Returns "integer" if x is an integer, "float" if it is a float, or nil if x is not a number.
  type = function(x)
    if not tonumber(x) then
      return
    end

    -- SM thinks 5.5 == 5...
    if tostring(math.floor(x)) == tostring(x) then
      return "integer"
    end
    return "float"
  end,
--~   Returns a boolean, true if and only if integer m is below integer n when they are compared as unsigned integers.
  ult = function(m, n)
    m = math.tointeger(m)
    n = math.tointeger(n)

    if m and n and m < n then
      return true
    end
    return false
  end,



--~   Returns the cosine of x (assumed to be in radians).
  sm_cos = cos,
  cos = function(x)
    print("math.cos not implemented yet.")
  end,
--~   Returns the sine of x (assumed to be in radians).
  sm_sin = sin,
  sin = function(x)
    print("math.sin not implemented yet.")
  end,
--~   Returns the tangent of x (assumed to be in radians).
  tan = function(x)
    print("math.tan not implemented yet.")
  end,
--~   Returns the arc cosine of x (in radians).
  sm_acos = acos,
  acos = function(x)
    print("math.acos not implemented yet.")
  end,
--~   Returns the arc sine of x (in radians).
  sm_asin = asin,
  asin = function(x)
    print("math.asin not implemented yet.")
  end,
--~   Returns the arc tangent of y/x (in radians), but uses the signs of both arguments to find the quadrant of the result. (It also handles correctly the case of x being zero.)
--~   The default value for x is 1, so that the call math.atan(y) returns the arc tangent of y.
  sm_atan = atan,
  atan = function(x)
    print("math.atan not implemented yet.")
  end,
}

do --~ https://rosettacode.org/wiki/Calculating_the_value_of_e#Lua
  local EPSILON = 1.0e-15
  local e = 2.0
  local fact = 1
  local e0 = 0.0
  local n = 2

  repeat
    e0 = e
    fact = fact * n
    n = n + 1
    e = e + 1.0 / fact
  until (math.abs(e - e0) < EPSILON)

  math.e = e
end



--~ other functions



-- round down to nearest (default 1000)
function math.RoundDown(x, g)
  g = g or 1000
  return (x - x % g) / g * g
end
-- integer round up to nearest
math.sm_RoundUp = round -- (number, granularity)

math.sm_AngleNormalize = AngleNormalize -- (angle)
math.sm_band = band -- (n1, n2)
math.sm_bnot = bnot -- (n)
math.sm_bor = bor -- (n1, n2)
math.sm_bxor = bxor -- (n1, n2)
math.sm_CatmullRomSpline = CatmullRomSpline -- (p1, p2, p3, p4, t, scale)
math.sm_compare = compare -- (n1, n2)
math.sm_DivCeil = DivCeil -- (v, d)
math.sm_DivRound = DivRound -- (m, d)
math.sm_FastSin = FastSin -- (a)
math.sm_GetClock = GetClock
math.sm_GetPreciseTicks = GetPreciseTicks
math.sm_HermiteSpline = HermiteSpline -- (p1, m1, p2, m2, t, scale)
math.sm_IsPowerOf2 = IsPowerOf2 -- (v)
math.sm_maskset = maskset -- (flags, mask, value)
math.sm_MulDivRound = MulDivRound -- (v, m, d)
math.sm_MulDivTrunc = MulDivTrunc -- (v, m, d)
math.sm_shift = shift -- (value, shift)
math.sm_xxhash = xxhash -- (arg1, arg2, arg3)

-- not really mathy
math.sm_cs = cs
math.sm_perlin = perlin
math.sm_Encode16 = Encode16
math.sm_Decode16 = Decode16
math.sm_Encode64 = Encode64
math.sm_Decode64 = Decode64
math.sm_EaseCoeff = EaseCoeff
