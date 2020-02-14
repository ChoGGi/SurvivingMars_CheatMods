-- See LICENSE for terms

function OnMsg.Demolished(obj)
	-- only demo on user stuff, not storybits
	if not obj.bulldozed
		-- no demo if no tech for it
		or not IsTechResearched("DecommissionProtocol")
	then
		return
	end

	obj:DestroyedClear()
end
