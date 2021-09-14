-- See LICENSE for terms

-- fired when settings are changed/init
local function ModOptions()
	if CurrentModOptions:GetProperty("PinAllRockets") and UICity then
		MapForEach(true, "RocketBase", function(o)
			if o.command ~= "OnEarth" then
				o:SetPinned(true)
			end
		end)
	end
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

function RocketBase.CanBeUnpinned()
	return true
end

RocketBase.show_pin_toggle = true

local function StartupCode()
	MapForEach(true, "RocketBase", function(o)
		o.show_pin_toggle = true
	end)
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
