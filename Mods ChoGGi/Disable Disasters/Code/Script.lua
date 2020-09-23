-- See LICENSE for terms

local options
local disasters = {
	"ColdWave",
	"DustDevils",
	"DustStorm",
	"Meteor",
--~ 	"Marsquake",
--~ 	"RainsDisaster",
}
local c = #disasters

local kill_current = {
	ColdWave = function()
		if g_ColdWave then
			StopColdWave()
			g_ColdWave = false
		end
	end,
	DustDevils = function()
		local objs = g_DustDevils or ""
		for i = #objs, 1, -1 do
			objs[i]:delete()
		end
	end,
	DustStorm = function()
		if g_DustStorm then
			StopDustStorm()
			g_DustStormType = false
		end
	end,
	Meteor = function()
		local objs = g_MeteorsPredicted or ""
		for i = #objs, 1, -1 do
			local o = objs[i]
			Msg("MeteorIntercepted", o)
			o:ExplodeInAir()
		end
	end,
--~ 	Marsquake = function()
--~ 		-- don't trigger quakes if setting is enabled
--~ 		SaveOrigFunc("TriggerMarsquake")
--~ 		function TriggerMarsquake(...)
--~ 			if not UserSettings.DisasterQuakeDisable then
--~ 				return ChoGGi_OrigFuncs.TriggerMarsquake(...)
--~ 			end
--~ 		end
--~ 	end,
--~ 	RainsDisaster = function()
--~ 		-- don't trigger toxic rains if setting is enabled
--~ 		SaveOrigFunc("RainProcedure")
--~ 		function RainProcedure(settings, ...)
--~ 			if settings.type == "normal" or not UserSettings.DisasterRainsDisable then
--~ 				return ChoGGi_OrigFuncs.RainProcedure(settings, ...)
--~ 			end
--~ 		end
--~ 	end,
}

-- fired when settings are changed/init
local function ModOptions(skip_disabled)
	-- make sure we're ingame
	if not UICity then
		return
	end

	for i = 1, c do
		local id = disasters[i]
		-- stop disaster threads
		if options:GetProperty(id) then
			if id == "Meteor" then
				DeleteThread(_G.Meteors)
				DeleteThread(_G.MeteorStorm)
			else
				DeleteThread(_G[id])
			end
			-- stop current disaster (if happening)
			kill_current[id]()
		-- skip_disabled is only for when loading saves, so we don't restart existing countdowns.
		elseif not skip_disabled then
			if id == "Meteor" then
				RestartGlobalGameTimeThread("Meteors")
				RestartGlobalGameTimeThread("MeteorStorm")
			else
				RestartGlobalGameTimeThread(id)
			end
		end
	end

end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

OnMsg.CityStart = ModOptions
-- we don't want to reset current disasters if option is disabled
function OnMsg.LoadGame()
	ModOptions(true)
end
