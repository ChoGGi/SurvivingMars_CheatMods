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

-- just in case they remove oldTableConcat
local TableConcat
pcall(function()
  TableConcat = oldTableConcat
end)
TableConcat = TableConcat or table.concat
-- just in case they remove floatfloor
local float_func
pcall(function()
  float_func = floatfloor
end)

-- needed for tmp file when doing unit tests
local mod_path = Mods.ChoGGi_AddMathFunctions.path
local tmpfile = TableConcat{mod_path,"UnitTest.txt"}

math = {
--~   Returns the absolute value of x. (integer/float)
  sm_abs = abs,
  abs = function(x)
    x = tonumber(x)
    if not x then
      return 0/0
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
      return 0/0
    end

    return math.floor(x+.5)
    -- returns 0.0 instead of 0
--~     return x + 1 - (x%1)
  end,
--~   Converts the angle x from radians to degrees.
  deg = function(x)
    x = tonumber(x)
    if not x then
      return 0/0
    end

    return x * 180.0 / math.pi
  end,
--~   Returns the value e^x (where e is the base of natural logarithms).
  exp = function(x)
    x = tonumber(x)
    if not x then
      return 0/0
    end

    return math.e^x
  end,
--~   Returns the largest integral value smaller than or equal to x.
  floor = float_func or function(x)
    x = tonumber(x)
    if not x then
      return 0/0
    end

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
    return 0/0
  end,
--~   The float value HUGE_VAL, a value larger than any other numeric value.
  huge = 10e500 + 10e400,
--~   Returns the logarithm of x in the given base. The default for base is e (so that the function returns the natural logarithm of x).
  log = function(x,base)
    x = tonumber(x)
    if not x or x < 0 or tostring(x) == "0" then
      return 0/0
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
    x = tonumber(x)
    if not x then
      return 0/0
    end

    if math.type(x) == "integer" then
      return x,0.0
    end

    local int

    if x < 0 then
      int = math.ceil(x)
    else
      int = math.floor(x)
    end

    if x == int then
      x = x % 1
    else
      x = x - int
    end

    return int,x

  end,
--~   pi is pi is pi
  pi = 3.1415926535898, -- that 8 should probably be a 7, but I suppose luac likes to round up?
--~   Converts the angle x from degrees to radians.
  rad = function(x)
    x = tonumber(x)
    if not x then
      return 0/0
    end

    return x * math.pi / 180.0
  end,
--~   When called without arguments, returns a pseudo-random float with uniform distribution in the range [0,1).
--~   When called with two integers m and n, math.random returns a pseudo-random integer with uniform distribution in the range [m, n].
--~   (The value n-m cannot be negative and must fit in a Lua integer.) The call math.random(n) is equivalent to math.random(1,n).
  random = function(m,n)

    if m and n then
      m = tonumber(m)
      n = tonumber(n)
      if not m or not n or n-m < 0 then
        return 0/0
      end

      return AsyncRand(n - m + 1) + m
    elseif m then
      m = tonumber(m)
      if not m or m <= 0 then
        return 0/0
      end

      return AsyncRand(1 - m + 1) + m
    else
      -- okay so it'll never return 1, close enough
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
      return 0/0
    end

    return x^0.5
  end,
--~   If the value x is convertible to an integer, returns that integer. Otherwise, returns nil.
  tointeger = function(x)
    x = tonumber(x)
    if not x then
      return 0/0
    end

    return math.floor(x)
  end,
--~   Returns "integer" if x is an integer, "float" if it is a float, or nil if x is not a number.
  type = function(x)
    x = tonumber(x)
    if not x then
      return 0/0
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

--~     if m and n and m < n then
--~       return true
--~     end
--~     return false
    if m and n then
      if m < n then
        return true
      else
        return false
      end
    end
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

-- deprecated

function math.pow(x,y)
  x = tonumber(x)
  y = tonumber(y)
  if not x or not y then
    return 0/0
  end

  return x^y
end

function math.log10(x)
  x = tonumber(x)
  if not x then
    return 0/0
  end

  return math.log(x,10)
end

function math.ldexp(x,exp)
  x = tonumber(x)
  exp = tonumber(exp)
  if not x or not exp then
    return 0/0
  end

  return x * 2.0^exp
end

--~ https://github.com/excessive/cpml/blob/master/modules/utils.lua
function math.frexp(x)
  x = tonumber(x)
  if not x then
    return 0/0
  end

  if x == 0 then
    return 0,0
  end
  local e = math.floor(math.log(math.abs(x)) / math.log(2) + 1)
  return x / 2 ^ e, e
end

math.atan2 = math.atan
math.mod = math.fmod

--~ https://github.com/NLua/LuaTests/blob/master/suite/math.lua
function math.test()
  print("testing numbers and math lib")

  local orig_assert = assert
  local function assert(line,value)
    if not orig_assert(value) then
      print("error, line number: ",line)
    end
  end
  local getinfo = debug.getinfo


  do
    local a,b,c = "2", " 3e0 ", " 10  "
    assert(getinfo(1).currentline,a+b == 5 and -b == -3 and b+"2" == 5 and "10"-c == 0)
    assert(getinfo(1).currentline,type(a) == 'string' and type(b) == 'string' and type(c) == 'string')
    assert(getinfo(1).currentline,a == "2" and b == " 3e0 " and c == " 10  " and -c == -"  10 ")
    assert(getinfo(1).currentline,c%a == 0 and a^b == 8)
  end


  do
    local a,b = math.modf(3.5)
    assert(getinfo(1).currentline,a == 3 and b == 0.5)
    assert(getinfo(1).currentline,math.huge > 10e30)
    assert(getinfo(1).currentline,-math.huge < -10e30)
  end

  local function f(...)
    if select('#', ...) == 1 then
      return (...)
    else
      return "***"
    end
  end

  assert(getinfo(1).currentline,tonumber{} == nil)
  assert(getinfo(1).currentline,tonumber'+0.01' == 1/100 and tonumber'+.01' == 0.01 and
         tonumber'.01' == 0.01    and tonumber'-1.' == -1 and
         tonumber'+1.' == 1)
  assert(getinfo(1).currentline,tonumber'+ 0.01' == nil and tonumber'+.e1' == nil and
         tonumber'1e' == nil     and tonumber'1.0e+' == nil and
         tonumber'.' == nil)
  assert(getinfo(1).currentline,tonumber('-12') == -10-2)
  assert(getinfo(1).currentline,tonumber('-1.2e2') == - - -120)
  assert(getinfo(1).currentline,f(tonumber('1  a')) == nil)
  assert(getinfo(1).currentline,f(tonumber('e1')) == nil)
  assert(getinfo(1).currentline,f(tonumber('e  1')) == nil)
  assert(getinfo(1).currentline,f(tonumber(' 3.4.5 ')) == nil)
  assert(getinfo(1).currentline,f(tonumber('')) == nil)
  assert(getinfo(1).currentline,f(tonumber('', 8)) == nil)
  assert(getinfo(1).currentline,f(tonumber('  ')) == nil)
  assert(getinfo(1).currentline,f(tonumber('  ', 9)) == nil)
  assert(getinfo(1).currentline,f(tonumber('99', 8)) == nil)
  assert(getinfo(1).currentline,tonumber('  1010  ', 2) == 10)
  assert(getinfo(1).currentline,tonumber('10', 36) == 36)
  --assert(getinfo(1).currentline,tonumber('\n  -10  \n', 36) == -36)
  --assert(getinfo(1).currentline,tonumber('-fFfa', 16) == -(10+(16*(15+(16*(15+(16*15)))))))
  assert(getinfo(1).currentline,tonumber('fFfa', 15) == nil)
  --assert(getinfo(1).currentline,tonumber(string.rep('1', 42), 2) + 1 == 2^42)
  assert(getinfo(1).currentline,tonumber(string.rep('1', 32), 2) + 1 == 2^32)
  --assert(getinfo(1).currentline,tonumber('-fffffFFFFF', 16)-1 == -2^40)
  assert(getinfo(1).currentline,tonumber('ffffFFFF', 16)+1 == 2^32)

  assert(getinfo(1).currentline,1.1 == 1.+.1)
  assert(getinfo(1).currentline,100.0 == 1E2 and .01 == 1e-2)
  assert(getinfo(1).currentline,1111111111111111-1111111111111110== 1000.00e-03)
  --     1234567890123456
  assert(getinfo(1).currentline,1.1 == '1.'+'.1')
  assert(getinfo(1).currentline,'1111111111111111'-'1111111111111110' == tonumber"  +0.001e+3 \n\t")

  local function eq (a,b,limit)
    if not limit then limit = 10E-10 end
    return math.abs(a-b) <= limit
  end

  assert(getinfo(1).currentline,0.1e-30 > 0.9E-31 and 0.9E30 < 0.1e31)

  assert(getinfo(1).currentline,0.123456 > 0.123455)

  -- doesn't work in SM ("1.23*10^30" returns "6.2446414524755e+18" instead of "1.23e+030")
--~   assert(getinfo(1).currentline,tonumber('+1.23E30') == 1.23*10^30)

  -- testing order operators
  assert(getinfo(1).currentline,not(1<1) and (1<2) and not(2<1))
  assert(getinfo(1).currentline,not('a'<'a') and ('a'<'b') and not('b'<'a'))
  assert(getinfo(1).currentline,(1<=1) and (1<=2) and not(2<=1))
  assert(getinfo(1).currentline,('a'<='a') and ('a'<='b') and not('b'<='a'))
  assert(getinfo(1).currentline,not(1>1) and not(1>2) and (2>1))
  assert(getinfo(1).currentline,not('a'>'a') and not('a'>'b') and ('b'>'a'))
  assert(getinfo(1).currentline,(1>=1) and not(1>=2) and (2>=1))
  assert(getinfo(1).currentline,('a'>='a') and not('a'>='b') and ('b'>='a'))

  -- testing mod operator
  assert(getinfo(1).currentline,-4%3 == 2)
  assert(getinfo(1).currentline,4%-3 == -2)
  assert(getinfo(1).currentline,math.pi - math.pi % 1 == 3)
  assert(getinfo(1).currentline,math.pi - math.pi % 0.001 == 3.141)

  local function testbit(a, n)
    return a/2^n % 2 >= 1
  end

--~   assert(getinfo(1).currentline,eq(math.sin(-9.8)^2 + math.cos(-9.8)^2, 1))
--~   assert(getinfo(1).currentline,eq(math.tan(math.pi/4), 1))
--~   assert(getinfo(1).currentline,eq(math.sin(math.pi/2), 1) and eq(math.cos(math.pi/2), 0))
--~   assert(getinfo(1).currentline,eq(math.atan(1), math.pi/4) and eq(math.acos(0), math.pi/2) and
--~          eq(math.asin(1), math.pi/2))
  assert(getinfo(1).currentline,eq(math.deg(math.pi/2), 90) and eq(math.rad(90), math.pi/2))
  assert(getinfo(1).currentline,math.abs(-10) == 10)
--~   assert(getinfo(1).currentline,eq(math.atan2(1,0), math.pi/2))
  assert(getinfo(1).currentline,math.ceil(4.5) == 5.0)
  assert(getinfo(1).currentline,math.floor(4.5) == 4.0)
  assert(getinfo(1).currentline,math.mod(10,3) == 1)
  assert(getinfo(1).currentline,eq(math.sqrt(10)^2, 10))
  assert(getinfo(1).currentline,eq(math.log10(2), math.log(2)/math.log(10)))
  assert(getinfo(1).currentline,eq(math.exp(0), 1))
--~   assert(getinfo(1).currentline,eq(math.sin(10), math.sin(10%(2*math.pi))))
  local v,e = math.frexp(math.pi)
  assert(getinfo(1).currentline,eq(math.ldexp(v,e), math.pi))

--~   assert(getinfo(1).currentline,eq(math.tanh(3.5), math.sinh(3.5)/math.cosh(3.5)))

  assert(getinfo(1).currentline,tonumber(' 1.3e-2 ') == 1.3e-2)
  assert(getinfo(1).currentline,tonumber(' -1.00000000000001 ') == -1.00000000000001)

  -- testing constant limits
  -- 2^23 = 8388608
  assert(getinfo(1).currentline,8388609 + -8388609 == 0)
  assert(getinfo(1).currentline,8388608 + -8388608 == 0)
  assert(getinfo(1).currentline,8388607 + -8388607 == 0)

--~   if rawget(_G, "_soft") then return end

--~   local AsyncStringToFile = AsyncStringToFile
--~   ThreadLockKey(tmpfile)
--~   AsyncStringToFile(tmpfile,"a = {","-1")
--~   i = 1
--~   repeat
--~     AsyncStringToFile(tmpfile,TableConcat{"{", math.sin(i), ", ", math.cos(i), ", ", i/3, "},\n"},"-1")
--~     i=i+1
--~   until i > 1000
--~   AsyncStringToFile(tmpfile,"}","-1")
--~   f:seek("set", 0)
--~   assert(getinfo(1).currentline,loadstring(select(2,AsyncFileToString(tmpfile))))()
--~   ThreadUnlockKey(tmpfile)

--~   assert(getinfo(1).currentline,eq(a[300][1], math.sin(300)))
--~   assert(getinfo(1).currentline,eq(a[600][1], math.sin(600)))
--~   assert(getinfo(1).currentline,eq(a[500][2], math.cos(500)))
--~   assert(getinfo(1).currentline,eq(a[800][2], math.cos(800)))
--~   assert(getinfo(1).currentline,eq(a[200][3], 200/3))
--~   assert(getinfo(1).currentline,eq(a[1000][3], 1000/3, 0.001))

  -- doesn't work in SM ("10e500 - 10e400" returns "-nan(ind)" instead of "nan")
--~   do   -- testing NaN
--~     local NaN = 10e500 - 10e400
--~     assert(getinfo(1).currentline,NaN ~= NaN)
--~     assert(getinfo(1).currentline,not (NaN < NaN))
--~     assert(getinfo(1).currentline,not (NaN <= NaN))
--~     assert(getinfo(1).currentline,not (NaN > NaN))
--~     assert(getinfo(1).currentline,not (NaN >= NaN))
--~     assert(getinfo(1).currentline,not (0 < NaN))
--~     assert(getinfo(1).currentline,not (NaN < 0))
--~     local a = {}
--~     assert(getinfo(1).currentline,not pcall(function () a[NaN] = 1 end))
--~     assert(getinfo(1).currentline,a[NaN] == nil)
--~     a[1] = 1
--~     assert(getinfo(1).currentline,not pcall(function () a[NaN] = 1 end))
--~     assert(getinfo(1).currentline,a[NaN] == nil)
--~   end

--~   require "checktable"
--~   stat(a)

--~   a = nil

  -- testing implicit convertions

  local a,b = '10', '20'
  assert(getinfo(1).currentline,a*b == 200 and a+b == 30 and a-b == -10 and a/b == 0.5 and -b == -20)
  assert(getinfo(1).currentline,a == '10' and b == '20')


  math.randomseed(0)
  local flag
  local i
  local Max
  local Min

  -- this will always fail as my math.random will never return 1 :)
--~   i = 0
--~   Max = 0
--~   Min = 2
--~   repeat
--~     local t = math.random()
--~     Max = math.max(Max, t)
--~     Min = math.min(Min, t)
--~     i=i+1
--~     flag = eq(Max, 1, 0.001) and eq(Min, 0, 0.001)
--~   until flag or i>10000
--~   assert(getinfo(1).currentline,0 <= Min and Max<1)
--~   assert(getinfo(1).currentline,flag);

  for i=1,10 do
    local t = math.random(5)
    assert(getinfo(1).currentline,1 <= t and t <= 5)
  end

  i = 0
  Max = -200
  Min = 200
  repeat
    local t = math.random(-10,0)
    Max = math.max(Max, t)
    Min = math.min(Min, t)
    i=i+1
    flag = (Max == 0 and Min == -10)
  until flag or i>10000
  assert(getinfo(1).currentline,-10 <= Min and Max<=0)
  assert(getinfo(1).currentline,flag);


  print('OK')
end
