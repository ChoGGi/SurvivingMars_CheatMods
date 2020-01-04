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
	if not mod_NewPause then
		return
	end
	CreateRealTimeThread(function()
		WaitMsg("MessageBoxClosed")
		Sleep(100)
		if UISpeedState ~= "pause" then
			SetGameSpeedState("pause")
		end
	end)
end

function OnMsg.LoadGame()
	if not mod_LoadPause then
		return
	end
	CreateRealTimeThread(function()
		Sleep(100)
		if UISpeedState ~= "pause" then
			SetGameSpeedState("pause")
		end
	end)
end