-- See LICENSE for terms

function OnMsg.Demolished(obj)
	-- no demo if no tech for it
	if not IsTechResearched("DecommissionProtocol") then
		return
	end

	if not obj then
		return
	end

	-- only clear stuff user has demo'd personally
	if not obj.ChoGGi_ManualDemo then
		return
	end
	obj.ChoGGi_ManualDemo = nil

	obj:DestroyedClear()
end

local IsValidThread = IsValidThread

local orig_ToggleDemolish = Demolishable.ToggleDemolish
function Demolishable:ToggleDemolish(...)
	-- add a slight delay to make it more reliable?
	CreateGameTimeThread(function()
		Sleep(1000)
		self.ChoGGi_ManualDemo = IsValidThread(self.demolishing_thread) and true or nil
	end)

	-- there's no return, but if a modder adds one
	return orig_ToggleDemolish(self, ...)
end
