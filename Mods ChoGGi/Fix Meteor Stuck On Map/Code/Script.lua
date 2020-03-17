-- See LICENSE for terms

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

function OnMsg.LoadGame()
	if not mod_EnableMod then
		return
	end

	local MapGet = MapGet
	local objs = MapGet("map", "BaseMeteor")
	for i = #objs, 1, -1 do
		local obj = objs[i]
		-- same pt as the dest means stuck on ground
		if obj:GetPos() == obj.dest then
			-- save pt then remove
			local pt = obj.dest
			obj:delete()
			-- check for and delete a parsystem at the same pt
			local par = MapGet(pt, 1, "ParSystem")
			if par[1] then
				par[1]:delete()
			end
		end
	end

end
