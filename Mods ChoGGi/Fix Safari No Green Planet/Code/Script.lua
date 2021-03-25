-- See LICENSE for terms

if LuaRevision > 1001551 then
	return
end

if not g_AvailableDlc.armstrong then
	function CanSeeForest()
		-- it'll always be false since there's no trees
		return false
	end
end
