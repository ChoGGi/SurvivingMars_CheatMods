-- See LICENSE for terms

if not g_AvailableDlc.contentpack1 then
	print("Build Philosopher Stones needs Mysteries DLC installed.")
	return
end

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- make sure we're in-game
	if not UICity then
		return
	end
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

local function SetTemplate(id)
	local bt = BuildingTemplates[id]
	bt.Group = "ChoGGi"
	bt.build_category = "ChoGGi"
	bt.display_icon = "UI/Icons/Buildings/placeholder.tga"
end

local function StartupCode()
	if not mod_EnableMod then
		return
	end

	SetTemplate("CrystalsBig")
	SetTemplate("CrystalsSmall")
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
