-- See LICENSE for terms

-- local any funcs used below (more than once)
local tonumber, tostring, pcall = tonumber, tostring, pcall
local AsyncRand, _InternalTranslate, T = AsyncRand, _InternalTranslate, T

do -- translate
	local locale_path = CurrentModPath .. "Locales/"
	if not LoadTranslationTableFile(locale_path .. GetLanguage() .. ".csv") then
		LoadTranslationTableFile(locale_path .. "English.csv")
	end
	Msg("TranslationChanged")
end

-- locale id to string
local function t(str)
	return _InternalTranslate(T(str))
end

local str = {
	not_implemented = t(302535920010000, "math.%s not implemented yet."),
	error = t(302535920010001, "bad argument #%s to 'math.%s' (%s)"),
	zero = t(302535920010002, "zero"),
	less_than_or_equals_zero = t(302535920010003, "less than or equals zero"),
	less_than_zero = t(302535920010004, "less than zero"),
	arg2_arg1_less_than_zero = t(302535920010005, "arg#2 - arg#1 == less than zero"),
	test_start = t(302535920010006, "Testing math: Start"),
	test_end = t(302535920010007, "Testing math: End"),
	test_error = t(302535920010008, "Testing math: Error file: (%s) line number: (%s) val1: (%s) val2: (%s) func: (math.%s)"),
	nan = t(302535920010009, "nan"),
	fmod = t(302535920010010, "fmod"),
	log = t(302535920010011, "log"),
	oneortwo = t(302535920010012, "1 or #2"),
	random = t(302535920010013, "random"),
	sqrt = t(302535920010014, "sqrt"),
	sin = t(302535920010015, "sin"),
	tan = t(302535920010016, "tan"),
	acos = t(302535920010017, "acos"),
	asin = t(302535920010018, "asin"),
	atan = t(302535920010019, "atan"),
	abs = t(302535920010020, "abs"),
	ceil = t(302535920010021, "ceil"),
	deg = t(302535920010022, "deg"),
	exp = t(302535920010023, "exp"),
	floor = t(302535920010024, "floor"),
	modf = t(302535920010025, "modf"),
	rad = t(302535920010026, "rad"),
	tointeger = t(302535920010027, "tointeger"),
	type = t(302535920010028, "type"),
	cos = t(302535920010029, "cos"),
	RoundDown = t(302535920010030, "RoundDown"),
	pow = t(302535920010031, "pow"),
	log10 = t(302535920010032, "log10"),
	ldexp = t(302535920010033, "ldexp"),
	frexp = t(302535920010034, "frexp"),
}

local function CheckNum(x, name, arg)
	x = tonumber(x)
	if x then
		return x
	else
		print(str.error:format(arg or 1, name, str.nan))
		return 0/0
	end
end

-- don't overwrite math. table if it exists (maybe someone else added it)
if type(math) ~= "table" then
	-- global table holding all the functions
	math = {}
end

-- Returns the absolute value of x. (integer/float)
math.sm_abs = abs
function math.abs(x)
	x = CheckNum(x, str.abs)

	if x < 0 then
		x = 0 - x
	end
	return x
end

-- Returns the smallest integral value larger than or equal to x.
function math.ceil(x)
	x = CheckNum(x, str.ceil)

	-- needed for neg numbers
	if x < 0 then
		x = x + 1 - (x % 1)
		return math.floor(x)
	end
	-- works fine on pos numbers
	return math.floor(x + 0.9)

end

-- Converts the angle x from radians to degrees.
function math.deg(x)
	x = CheckNum(x, str.deg)

	return x * 180.0 / math.pi
end

-- Napier's constant/Euler's number (to 104 digits)
math.e = 2.71828182845904523536028747135266249775724709369995957496696762772407663035354759457138217852516642742746

-- Returns the value e^x (where e is the base of natural logarithms).
function math.exp(x)
	x = CheckNum(x, str.exp)

	return math.e^x
end

-- Returns the largest integral value smaller than or equal to x.
math.floor = rawget(_G, "floatfloor") or function(x)
	x = CheckNum(x, str.floor)

	return x - (x % 1)
end

-- Returns the remainder of the division of x by y that rounds the quotient towards zero. (integer/float)
function math.fmod(x, y)
	x = CheckNum(x, str.fmod)
	y = CheckNum(y, str.fmod, 2)

	if y == 0 then
		print(str.error:format(2, str.fmod, str.zero))
		return 0/0
	end

	if y < 0 then
		y = y * -1
	end

	local neg
	if x < 0 then
		neg = true
		x = x * -1
	end

	x = x % y
		if neg then
			return -x
		end
	return x

end

-- The float value HUGE_VAL, a value larger than any other numeric value.
math.huge = 10e500 + 10e500

-- Returns the logarithm of x in the given base. The default for base is e (so that the function returns the natural logarithm of x).
function math.log(x, base)
	x = CheckNum(x, str.log)
	if x < 0 or tostring(x) == "0" then
		print(str.error:format(1, str.log, str.less_than_or_equals_zero))
		return 0/0
	end

	if base then
		base = tonumber(base)
		if base then
			if base < 0 then
				print(str.error:format(2, str.log, str.less_than_zero))
				return 0/0
			elseif base == 0 then
				return -0.0
			end
			if tostring(x) == "1" then
				return 0.0
			end

			return math.log(x) / math.log(base)
		else
			-- user put something for base that isn't a number
			print(str.error:format(2, str.log, str.nan))
			return 0/0
		end
	end

	-- no base means use
	base = math.e

-- http://foldit.wikia.com/wiki/Lua_Script_Library#math.log_.28Taylor_Series_Approximation_.29
	local result = 0
	local residue = x / base
	while residue > 1 do
		residue = residue / base
		result = result + 1
	end
	local y = residue - 1
	-- Taylor series, just enough to get the same result as math.log()
	residue = 1+y-y ^2/2+y ^3/3-y ^4/4+y ^5/5-y ^6/6+y ^7/7-y ^8/8+y
		^9/9-y ^10/10+y ^11/11-y ^12/12+y ^13/13-y ^14/14+y ^15/15-y ^16/16+y
		^17/17-y ^18/18+y ^19/19-y ^20/20+y ^21/21-y ^22/22+y ^23/23-y ^24/24+y
		^25/25-y ^26/26+y ^27/27-y ^28/28+y ^29/29-y ^30/30+y ^31/31-y ^32/32+y
		^33/33-y ^34/34+y ^35/35-y ^36/36+y ^37/37-y ^38/38+y ^39/39-y ^40/40+y
		^41/41-y ^42/42+y ^43/43-y ^44/44+y ^45/45-y ^46/46+y ^47/47-y ^48/48+y
		^49/49-y ^50/50+y ^51/51-y ^52/52+y ^53/53-y ^54/54+y ^55/55-y ^56/56+y
		^57/57-y ^58/58+y ^59/59-y ^60/60+y ^61/61-y ^62/62+y ^63/63-y ^64/64
	result = result + residue
	return result
end

-- Returns the argument with the maximum value, according to the Lua operator <. (integer/float)
math.max = Max

-- An integer with the maximum value for an integer.
math.maxinteger = max_int

-- Returns the argument with the minimum value, according to the Lua operator <. (integer/float)
math.min = Min

-- An integer with the minimum value for an integer.
math.mininteger = min_int

-- Returns the integral part of x and the fractional part of x. Its second result is always a float.
function math.modf(x)
	x = CheckNum(x, str.modf)

	if math.type(x) == "integer" then
		return x, 0.0
	end

	local neg
	if x < 0 then
		neg = true
		x = x * -1
	end

	local int = math.floor(x)

	if tostring(x) == tostring(int) then
		x = x % 1
	else
		x = x - int
	end

	if neg then
		return -int, -x
	end
	return int, x

end

-- pi is pi is pi (to 104 digits)
math.pi = 3.14159265358979323846264338327950288419716939937510582097494459230781640628620899862803482534211706798214

-- Converts the angle x from degrees to radians.
function math.rad(x)
	x = CheckNum(x, str.rad)

	return x * math.pi / 180.0
end

-- When called without arguments, returns a pseudo-random float with uniform distribution in the range [0, 1).
-- When called with two integers m and n, math.random returns a pseudo-random integer with uniform distribution in the range [m, n].
-- (The value n-m cannot be negative and must fit in a Lua integer.) The call math.random(n) is equivalent to math.random(1, n).
function math.random(m, n)

	if m and n then
		m = CheckNum(m, str.random)
		n = CheckNum(n, str.random)
		if n-m < 0 then
			print(str.error:format(str.oneortwo, str.random, str.arg2_arg1_less_than_zero))
			return 0/0
		end

		return AsyncRand(n - m + 1) + m
	elseif m then
		m = CheckNum(m, str.random)
		if m <= 0 then
			print(str.error:format(1, str.random, str.less_than_or_equals_zero))
			return 0/0
		end

		return AsyncRand(m)
	else
		-- so it'll never return 1, close enough
		return tonumber("0." .. AsyncRand())
	end

end

-- Sets x as the "seed" for the pseudo-random generator: equal seeds produce equal sequences of numbers.
-- The math.randomseed() function sets a seed for the pseudo-random generator: Equal seeds produce equal sequences of numbers.
math.randomseed = AsyncSetSeed

-- Returns the square root of x.
function math.sqrt(x)
	x = CheckNum(x, str.sqrt)
	if x < 0 then
		print(str.error:format(1, str.sqrt, str.less_than_zero))
		return 0/0
	end

	return x^0.5
end

-- If the value x is convertible to an integer, returns that integer. Otherwise, returns nil.
function math.tointeger(x)
	x = CheckNum(x, str.tointeger)

	return math.floor(x)
end

-- Returns "integer" if x is an integer, "float" if it is a float, or nil if x is not a number.
function math.type(x)
	-- nil
	if not tonumber(x) then
		return
	end

	x = CheckNum(x, str.type)
	-- SM thinks 5.5 == 5...
	if tostring(math.floor(x)) == tostring(x) then
		return "integer"
	end
	return "float"
end

-- Returns a boolean, true if and only if integer m is below integer n when they are compared as unsigned integers.
function math.ult(m, n)
	m = math.tointeger(m)
	n = math.tointeger(n)

--~ 	if m and n and m < n then
--~ 		return true
--~ 	end
--~ 	return false
	if m and n then
		if m < n then
			return true
		else
			return false
		end
	end
end



-- Returns the cosine of x (assumed to be in radians).
math.sm_cos = cos
function math.cos(x)
	x = CheckNum(x, str.cos)

	return math.sin(x + math.pi/2)
end

-- Returns the sine of x (assumed to be in radians).
math.sm_sin = sin
function math.sin(x)
	x = CheckNum(x, str.sin)

	print(str.not_implemented:format(str.sin))
end

-- Returns the tangent of x (assumed to be in radians).
function math.tan(x)
	x = CheckNum(x, str.tan)

	print(str.not_implemented:format(str.tan))
end

-- Returns the arc cosine of x (in radians).
math.sm_acos = acos
function math.acos(x)
	x = CheckNum(x, str.acos)

	print(str.not_implemented:format(str.acos))
end

-- Returns the arc sine of x (in radians).
math.sm_asin = asin
function math.asin(x)
	x = CheckNum(x, str.asin)

	print(str.not_implemented:format(str.asin))
end

-- Returns the arc tangent of y/x (in radians), but uses the signs of both arguments to find the quadrant of the result. (It also handles correctly the case of x being zero.)
-- The default value for x is 1, so that the call math.atan(y) returns the arc tangent of y.
math.sm_atan = atan
function math.atan(x)
	x = CheckNum(x, str.atan)

	print(str.not_implemented:format(str.atan))
end



--~ other functions



-- round down to nearest (default 1000)
function math.RoundDown(x, g)
	x = CheckNum(x, str.RoundDown)
	g = CheckNum(g, str.RoundDown, 2)
	g = g or 1000
	return (x - x % g) / g * g
end

pcall(function()
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
--~	 math.sm_cs = cs
	math.sm_perlin = perlin
	math.sm_Encode16 = Encode16
	math.sm_Decode16 = Decode16
	math.sm_Encode64 = Encode64
	math.sm_Decode64 = Decode64
	math.sm_EaseCoeff = EaseCoeff
end)

-- deprecated

function math.pow(x, y)
	x = CheckNum(x, str.pow)
	y = CheckNum(y, str.pow, 2)

	return x^y
end

function math.log10(x)
	x = CheckNum(x, str.log10)

	return math.log(x, 10)
end

function math.ldexp(x, exp)
	x = CheckNum(x, str.ldexp)
	exp = CheckNum(exp, str.ldexp, 2)

	return x * 2.0^exp
end

--~ https://github.com/excessive/cpml/blob/master/modules/utils.lua
function math.frexp(x)
	x = CheckNum(x, str.frexp)

	if x == 0 then
		return 0, 0
	end
	local e = math.floor(math.log(math.abs(x)) / math.log(2) + 1)
	return x / 2 ^ e, e
end

math.atan2 = math.atan
math.mod = math.fmod

--~ https://github.com/NLua/LuaTests/blob/master/suite/math.lua (mostly)
function math.test()
	print(str.test_start)

	local getinfo = format_value
--~ 	local	= debug.getinfo
	local script_name = CurrentModPath .. "Script.lua"

	local function Test(line, func, n1, n2)
		if n1 == false then
			print(str.test_error:format(script_name, line, n1, n2, func))
		elseif n1 and n2 and n1 ~= n2 then
			print(str.test_error:format(script_name, line, n1, n2, func))
		end
	end

	local function eq(a, b, limit)
		return math.abs(a-b) <= (limit or 10E-10)
	end

	Test(getinfo(function()end), "huge", math.huge > 10e30)
	Test(getinfo(function()end), "huge", -math.huge < -10e30)

	-- testing mod operator
	Test(getinfo(function()end), "pi", tostring(math.pi - math.pi % 1), "3.0")
	Test(getinfo(function()end), "pi", tostring(math.pi - math.pi % 0.001), "3.141")

--~ 	local function testbit(a, n)
--~ 		return a/2^n % 2 >= 1
--~ 	end

--~ 	Test(getinfo(function()end), "sin", eq(math.sin(-9.8)^2 + math.cos(-9.8)^2, 1))
--~ 	Test(getinfo(function()end), "tan", eq(math.tan(math.pi/4), 1))
--~ 	Test(getinfo(function()end), "sin", eq(math.sin(math.pi/2), 1) and eq(math.cos(math.pi/2), 0))
--~ 	Test(getinfo(function()end), "atan", eq(math.atan(1), math.pi/4) and eq(math.acos(0), math.pi/2) and
--~ 					eq(math.asin(1), math.pi/2))
	Test(getinfo(function()end), "deg", eq(math.deg(math.pi/2), 90) and eq(math.rad(90), math.pi/2))
	Test(getinfo(function()end), "abs", math.abs(-10), 10)
--~ 	Test(getinfo(function()end), "atan2", eq(math.atan2(1, 0), math.pi/2))
	Test(getinfo(function()end), "ceil", math.ceil(4.5), 5)
	Test(getinfo(function()end), "floor", math.floor(4.5), 4)
	Test(getinfo(function()end), "mod", math.mod(10, 3), 1)
	Test(getinfo(function()end), "sqrt", eq(math.sqrt(10)^2, 10))
	Test(getinfo(function()end), "log10", eq(math.log10(2), math.log(2)/math.log(10)))
	Test(getinfo(function()end), "exp", eq(math.exp(0), 1))

--~ 	Test(getinfo(function()end), "sin", eq(math.sin(10), math.sin(10%(2*math.pi))))
	local v, e = math.frexp(math.pi)
	Test(getinfo(function()end), "ldexp", eq(math.ldexp(v, e), math.pi))

--~ 	Test(getinfo(function()end), "tanh", eq(math.tanh(3.5), math.sinh(3.5)/math.cosh(3.5)))

--~ 	if rawget(_G, "_soft") then return end

--~ 	local AsyncStringToFile = AsyncStringToFile
--~ 	ThreadLockKey(tmpfile)
--~ 	AsyncStringToFile(tmpfile, "a = {", "-1")
--~ 	for i = 1, 1000 do
--~ 		AsyncStringToFile(tmpfile,
--~ 		"{" .. math.sin(i) .. ", " .. math.cos(i) .. ", " .. i/3 .. "}, \n",
--~ 		"-1")
--~ 	end
--~ 	AsyncStringToFile(tmpfile, "}", "-1")
--~ 	f:seek("set", 0)
--~ 	Test(getinfo(function()end), "sin", loadstring(select(2, AsyncFileToString(tmpfile))))()
--~ 	ThreadUnlockKey(tmpfile)

--~ 	Test(getinfo(function()end), "sin", eq(a[300][1], math.sin(300)))
--~ 	Test(getinfo(function()end), "sin", eq(a[600][1], math.sin(600)))
--~ 	Test(getinfo(function()end), "cos", eq(a[500][2], math.cos(500)))
--~ 	Test(getinfo(function()end), "cos", eq(a[800][2], math.cos(800)))
--~ 	Test(getinfo(function()end), "sin", eq(a[200][3], 200/3))
--~ 	Test(getinfo(function()end), "sin", eq(a[1000][3], 1000/3, 0.001))

--~ 	-- doesn't work in SM ("10e500 - 10e400" returns "-nan(ind)" instead of "nan")
--~ 	do	 -- testing NaN
--~ 		local NaN = 10e500 - 10e400
--~ 		Test(getinfo(function()end), "nan", NaN ~= NaN)
--~ 		Test(getinfo(function()end), "nan", not (NaN < NaN))
--~ 		Test(getinfo(function()end), "nan", not (NaN <= NaN))
--~ 		Test(getinfo(function()end), "nan", not (NaN > NaN))
--~ 		Test(getinfo(function()end), "nan", not (NaN >= NaN))
--~ 		Test(getinfo(function()end), "nan", not (0 < NaN))
--~ 		Test(getinfo(function()end), "nan", not (NaN < 0))
--~ 		local a = {}
--~ 		Test(getinfo(function()end), "nan", not pcall(function () a[NaN] = 1 end))
--~ 		Test(getinfo(function()end), "nan", a[NaN], nil)
--~ 		a[1] = 1
--~ 		Test(getinfo(function()end), "nan", not pcall(function () a[NaN] = 1 end))
--~ 		Test(getinfo(function()end), "nan", a[NaN], nil)
--~ 	end

--~ 	require "checktable"
--~ 	stat(a)

--~ 	a = nil

	math.randomseed(0)

	for _ = 1, 10 do
		local t = math.random(5)
		Test(getinfo(function()end), "random", 1 <= t and t <= 5)
	end

	local flag
	local Max = -200
	local Min = 200

	for _ = 1, 10000 do
		local t = math.random(-10, 0)
		Max = math.max(Max, t)
		Min = math.min(Min, t)
		flag = (Max == 0 and Min == -10)
		if flag then
			break
		end
	end

	Test(getinfo(function()end), "random", -10 <= Min and Max<=0)
	Test(getinfo(function()end), "random", flag);

	-- tests I added

	Test(getinfo(function()end), "huge", math.huge + math.huge, math.huge)
	Test(getinfo(function()end), "log", tostring(math.log(1.1)), "0.095310179804325")
	Test(getinfo(function()end), "log", tostring(math.log(6.4643, 25)), "0.57979705728765")
	Test(getinfo(function()end), "exp", tostring(math.exp(5.453454)), "233.56350262858")
	Test(getinfo(function()end), "exp", tostring(math.exp(-5.453454)), "0.0042814908525766")
	Test(getinfo(function()end), "fmod", tostring(math.fmod(56546.45645, 1)), "0.45644999999786")
	Test(getinfo(function()end), "fmod", tostring(math.fmod(-56546.45645, 1.5)), "-0.95644999999786")
	Test(getinfo(function()end), "fmod", tostring(math.fmod(-876.0007665, -1)), "-0.00076650000005429")
	Test(getinfo(function()end), "fmod", tostring(math.fmod(876.0007665, -1.6)), "0.80076650000001")
	Test(getinfo(function()end), "ceil", math.ceil(123.334546452), 124)
	Test(getinfo(function()end), "ceil", math.ceil(-123.334546452), -123)
	Test(getinfo(function()end), "floor", math.floor(-123.525645644), -124)
	Test(getinfo(function()end), "floor", math.floor(123.525645644), 123)

	local int, flt = math.modf(3453444.54354645)
	Test(getinfo(function()end), "modf", int, 3453444)
	Test(getinfo(function()end), "modf", tostring(flt), "0.5435464498587")
	int, flt = math.modf(-3453444.54354645)
	Test(getinfo(function()end), "modf", int, -3453444)
	Test(getinfo(function()end), "modf", tostring(flt), "-0.5435464498587")

	-- check error msg
--~ 	Test(getinfo(function()end), "test", 1, 0)

	print(str.test_end)
end
