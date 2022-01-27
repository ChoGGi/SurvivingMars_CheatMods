-- See LICENSE for terms

local IsValidThread = IsValidThread

local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

function OnMsg.LoadGame()
	if not mod_EnableMod then
		return
	end

	local objs = MapGet("map", "BaseMeteor")
	for i = #objs, 1, -1 do
		local obj = objs[i]

		-- same pt as the dest means stuck on ground
		if obj:GetPos() == obj.dest then
			obj:delete()
		-- stuck on roof of dome
		elseif not IsValidThread(obj.fall_thread) then
			obj:delete()
		end
	end

end
