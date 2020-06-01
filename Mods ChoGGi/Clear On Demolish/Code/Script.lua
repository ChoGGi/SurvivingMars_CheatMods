-- See LICENSE for terms

function OnMsg.Demolished(obj)
	-- no demo if no tech for it
	if not IsTechResearched("DecommissionProtocol") then
		return
	end

	obj:DestroyedClear()
end
