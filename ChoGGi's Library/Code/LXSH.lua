-- http://github.com/xolox/lua-lxsh
-- This software is licensed under the [MIT license] https://en.wikipedia.org/wiki/MIT_License.
-- © 2011 Peter Odding <peter@peterodding.com>.

-- https://gist.github.com/starwing/1572004

--~ local aaaa  = "aaaaa"
--~ if true then
--~ end
--~ -- fdsafdsf
--~ print(aaaa)

--~ local bbbbb  = 12345
--~ if true then
--~ end
--~ --[[ fdsafdsf
--~ fdsafdsf
--~ --]]
--~ print(bbbbb)

local TableConcat = ChoGGi.ComFuncs.TableConcat
local StringFormat = string.format

local lpeg = lpeg
local P, R, S, C, Cc, Ct, match = lpeg.P, lpeg.R, lpeg.S, lpeg.C, lpeg.Cc, lpeg.Ct, lpeg.match
-- digits
local D = R("09")
-- range of valid characters after first character of identifier
local I = R("AZ", "az", "\127\255") + "_"
-- word boundary
local B = -(I + D)

-- create a pattern which captures the lua value [id] and the input matching
-- [patt] in a table
local function token(id, patt)
	return Ct(Cc(id) * C(patt))
end

-- Pattern definitions start here.
local constant = token("constant", (P"true" + "false" + "nil") * B)
local whitespace = token("whitespace", S"\r\n\f\t\v "^1)

-- Pattern for long strings and long comments.
local longstring = #(P"[" + (P"[" * P"="^0 * "[")) * P(function(input, index)
	local level = input:match("^%[(=*)%[", index)
	if level then
--~ 		local _, last = input:find(']' .. level .. ']', index, true)
		local _, last = input:find(StringFormat("]%s]",level), index, true)
		if last then
			return last + 1
		end
	end
end)

-- String literals.
local singlequoted = P("'") * ((1 - S("'\r\n\f\\")) + (P("\\") * 1))^0 * "'"
local doublequoted = P('"') * ((1 - S('"\r\n\f\\')) + (P("\\") * 1))^0 * '"'
local strings = token("string", singlequoted + doublequoted + longstring)

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

-- Numbers.
local sign = S'+-'^-1
local decimal = D^1
local hexadecimal = P'0' * S'xX' * R('09', 'AF', 'af') ^ 1
local float = D^1 * P'.' * D^0 + P'.' * D^1
local maybeexp = (float + decimal) * (S'eE' * sign * D^1)^-1
local number = token('number', hexadecimal + maybeexp)

-- Operators (matched after comments because of conflict with minus).
local operator = token("operator", P'not' + '...' + 'and' + '..' + '~=' + '==' + '>=' + '<='
																					+ 'or' + S']{=>^[<;)*(%}+-:,/.#')

-- Keywords.
--~ local keyword = token('keyword', (P 'break' + P 'do' + P 'else' +
--~ 	 P 'elseif' + P 'end' + P 'for' + P 'function' + P 'if' +
--~ 	 P 'in' + P 'local' + P 'repeat' + P 'return' +
--~ 	 P 'then' + P 'until' + P 'while') * -(I + D))
local keyword = token("keyword",[[
  break do else elseif end for function if in local repeat return then until while
]])

-- Identifiers.
local identifier = token("identifier", I * (I + D + P '.') ^ 0)
--~ -- Identifiers - Sometimes it's very convenient to match for example "io.write"
--~ -- as one token instead of three, however this is not really a lexer's job. As
--~ -- a compromise we'll let the caller choose by passing a table of options with
--~ -- the key "join_identifiers" and the value "true":
--~ local identt = I * (I + D)^0
--~ local expr = ('.' * identt)^0
--~ local identifier = token('identifier', lpeg.Cmt(identt * lpeg.Carg(1),
--~   function(input, index, options)
--~     if options and options.join_identifiers then
--~       return expr:match(input, index)
--~     else
--~       return index
--~     end
--~   end))

local err = token("error", 1)

-- ordered choice of all tokens and last-resort error which consumes one character
local any_token = whitespace + number + keyword + constant + identifier +
									strings + comment + operator + err

-- private interface
local table_of_tokens = Ct(any_token ^ 0)

-- increment [line] by the number of line-ends in [text]
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

local multiline_tokens = { comment = true, strings = true, whitespace = true }

-- public interface
local function lexer(input)
	local line = 1
	local tokens = match(table_of_tokens, input)
	for i = 1, #tokens do
		local token = tokens[i]
		token[3] = line
		if multiline_tokens[token[1]] then
			line = sync(line, token[2])
		end
	end
	return tokens
end
ChoGGi.ComFuncs.LXSH_lexer = lexer

-- strip interface
function ChoGGi.ComFuncs.StripComments(s)
	local tokens = lexer(s)
	local line_head = true
	local prev_space = false
	local line = {}
	for i = 1, #tokens do
		local v = tokens[i]
		if v[1] == "comment" or v[1] == "whitespace" then
			if v[2]:match("\n") then
				line[#line+1] = v[2]:gsub(".-\n[^\n]*", "\n")
				line_head = true
			end
			prev_space = true
		else
			if prev_space and not line_head then
				line[#line+1] = " "
			end
			line[#line+1] = v[2]
			prev_space = false
			line_head = false
		end
	end
	return TableConcat(line)
end
