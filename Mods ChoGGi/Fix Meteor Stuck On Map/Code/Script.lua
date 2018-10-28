
function OnMsg.LoadGame()

	local m = MapGet("map","BaseMeteor")
	for i = #m, 1, -1 do
		-- same pt as the dest means stuck on ground
		if m[i]:GetPos() == m[i].dest then
			-- save pt then remove
			local pt = m[i].dest
			m[i]:delete()
			-- check for and delete a parsystem at the same pt
			local par = MapGet(pt,1,"ParSystem")
			if par[1] then
				par[1]:delete()
			end
		end
	end

end
