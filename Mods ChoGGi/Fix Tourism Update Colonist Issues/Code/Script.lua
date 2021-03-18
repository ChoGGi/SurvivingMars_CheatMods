-- See LICENSE for terms

if LuaRevision > 1001514 then
	return
end

local Colonist = Colonist
local funcs = {
	"LogStatClear",
	"AddToLog",
}

for i = 1, #funcs do
	local func = Colonist[funcs[i]]
	Colonist[funcs[i]] = function(self, log, ...)
		if log then
			return func(self, log, ...)
		end
	end
end
