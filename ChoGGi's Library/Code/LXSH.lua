-- http://github.com/xolox/lua-lxsh
-- This software is licensed under the [MIT license] https://en.wikipedia.org/wiki/MIT_License.
-- © 2011 Peter Odding <peter@peterodding.com>.

-- https://gist.github.com/starwing/1572004

--~ local aaaa = "TEST"
--~ if aaaa ~= "" then
--~ 	--
--~ 	print("aaaa") --COMMENT
--~ 	--
--~ 	--[[
--~ 	print("bbbbb")
--~ 	]]
--~ 	print("ccccc")
--~ else
--~ 	print("dddddd")
--~ end
--~ print("eeee")

local lpeg = lpeg
local P, S, C, Cc, Ct, match = lpeg.P, lpeg.S, lpeg.C, lpeg.Cc, lpeg.Ct, lpeg.match

-- create a pattern which captures the lua value [id] and the input matching
-- [patt] in a table
local function token(id, patt)
	return Ct(Cc(id) * C(patt))
end

-- Pattern for long strings and long comments.
--~ local input_find_str = "]%s]"
local longstring = #(P"[" + (P"[" * P"="^0 * "[")) * P(function(input, index)
	local level = input:match("^%[(=*)%[", index)
	if level then
		local _, last = input:find("]" .. level .. "]", index, true)
		if last then
			return last + 1
		end
	end
end)

-- Comments.
local eol = P"\r\n" + "\n"
local line = (1 - S("\r\n\f"))^0 * eol^-1
local soi = P(function(_, i)
	return i == 1 and i
end)
local shebang = soi * "#!" * line
local singleline_comment = P("--") * line
local multiline_comment = P("--") * longstring
local comment = token("comment", multiline_comment + singleline_comment + shebang)

-- private interface
local table_of_tokens = Ct((comment + token("error", 1)) ^ 0)

-- Increment [line] by the number of line-ends in [text]
local function sync(line, text)
	local index, limit = 1, #text
	while index <= limit do
		local start, stop = text:find("\r\n", index, true)
		if not start then
			start, stop = text:find("[\r\n\f]", index)
			if not start then
				break
			end
		end
		index = stop + 1
		line = line + 1
	end
	return line
end

-- public interface
local function lexer(input)
	local line = 1
	local tokens = match(table_of_tokens, input)
	for i = 1, #tokens do
		local token = tokens[i]
		token[3] = line
		if token[1] == "comment" then
			line = sync(line, token[2])
		end
	end
	return tokens
end

-- strip interface
local TableConcat = ChoGGi.ComFuncs.TableConcat
local line_c = objlist:new()
function ChoGGi.ComFuncs.StripComments(s)
	line_c:Destroy()
	local c = 0

	local tokens = lexer(s)
	local line_head = true
	local prev_space = false
	for i = 1, #tokens do
		local v = tokens[i]
		if v[1] == "comment" then
			if v[2]:match("\n") then
				c = c + 1
				line_c[c] = v[2]:gsub(".-\n[^\n]*", "\n")
				line_head = true
			end
			prev_space = true
		else
			if prev_space and not line_head then
				c = c + 1
				line_c[c] = " "
			end
			c = c + 1
			line_c[c] = v[2]
			prev_space = false
			line_head = false
		end
	end
	return TableConcat(line_c)
end
