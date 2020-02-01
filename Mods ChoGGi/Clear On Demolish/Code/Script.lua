-- See LICENSE for terms

function OnMsg.Demolished(obj)
	-- only demo on user stuff, not storybits
	if not obj.bulldozed then
		return
	end

	-- no demo if no tech for it
	if not IsTechResearched("DecommissionProtocol") then
		return
	end

	obj:DestroyedClear()
end
