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
	if id == CurrentModId then
		ModOptions()
	end
end

local MapGet = MapGet
local IsValidThread = IsValidThread

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
