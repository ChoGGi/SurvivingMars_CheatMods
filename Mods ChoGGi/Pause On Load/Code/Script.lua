-- See LICENSE for terms

local mod_NewPause
local mod_LoadPause

-- fired when settings are changed/init
local function ModOptions()
	mod_NewPause = CurrentModOptions:GetProperty("NewPause")
	mod_LoadPause = CurrentModOptions:GetProperty("LoadPause")
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