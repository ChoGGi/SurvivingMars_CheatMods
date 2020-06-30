-- See LICENSE for terms

function OnMsg.Demolished(obj)
	-- no demo if no tech for it
	if not IsTechResearched("DecommissionProtocol") then
		return
	end

	-- only clear stuff user has demo'd personally
	if not self.ChoGGi_ManualDemo then
		return
	end
	self.ChoGGi_ManualDemo = nil

	obj:DestroyedClear()
end

local IsValidThread = IsValidThread

local orig_ToggleDemolish = Demolishable.ToggleDemolish
function Demolishable:ToggleDemolish(...)
	local ret = orig_ToggleDemolish(self, ...)

	self.ChoGGi_ManualDemo = IsValidThread(self.demolishing_thread) and true or nil

	-- there's no return, but if a modder adds one
	return ret
end
