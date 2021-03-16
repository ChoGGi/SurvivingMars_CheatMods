-- See LICENSE for terms

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
