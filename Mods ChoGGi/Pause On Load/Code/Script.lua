-- See LICENSE for terms

local mod_NewPause
local mod_LoadPause

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_NewPause = CurrentModOptions:GetProperty("NewPause")
	mod_LoadPause = CurrentModOptions:GetProperty("LoadPause")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

function OnMsg.CityStart()
	if mod_NewPause then
		CreateRealTimeThread(function()
			WaitMsg("MessageBoxClosed")
			Sleep(100)
			UIColony:SetGameSpeed(0)
			UISpeedState = "pause"
		end)
	end
end

function OnMsg.LoadGame()
	if mod_LoadPause then
		CreateRealTimeThread(function()
			Sleep(100)
			UIColony:SetGameSpeed(0)
			UISpeedState = "pause"
		end)
	end
end
