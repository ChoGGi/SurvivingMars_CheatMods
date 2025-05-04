-- See LICENSE for terms

local mod_EnableMod
local mod_ChangeSkin

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_ChangeSkin = CurrentModOptions:GetProperty("ChangeSkin")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions


local ObjectColourRandom = ChoGGi_Funcs.Common.ObjectColourRandom

local function ChangeColour(self)
	-- we need to wait a sec before we can edit attaches
	WaitMsg("OnRender")
	ObjectColourRandom(self)
end

local ChoOrig_BaseBuilding_GameInit = BaseBuilding.GameInit
function BaseBuilding:GameInit(...)
	if not mod_EnableMod then
		return ChoOrig_BaseBuilding_GameInit(self, ...)
	end

	ChoOrig_BaseBuilding_GameInit(self, ...)
	CreateRealTimeThread(ChangeColour, self)
end

local ChoOrig_Building_ChangeSkin = Building.ChangeSkin
function Building:ChangeSkin(...)
	if not mod_EnableMod or not mod_ChangeSkin then
		return ChoOrig_Building_ChangeSkin(self, ...)
	end

	ChoOrig_Building_ChangeSkin(self, ...)
	ObjectColourRandom(self)
end

local ChoOrig_SkinChangeable_CycleSkin = SkinChangeable.CycleSkin
function SkinChangeable:CycleSkin(...)
	if not mod_EnableMod or not mod_ChangeSkin then
		return ChoOrig_SkinChangeable_CycleSkin(self, ...)
	end

	ChoOrig_SkinChangeable_CycleSkin(self, ...)
	ObjectColourRandom(self)
end

-- Always show paintbrush
function OnMsg.ClassesPostprocess()

	-- I wish there was a better way of accessing dialogs...
	local template = XTemplates.Infopanel[1][1][3][1][2]
	template.__condition = function(_, context)
--~ 		return not IsKindOf(context, "ConstructionSite") and #(context:GetSkins() or "") > 1

		if IsKindOf(context, "ConstructionSite") then
			return false
		end

		if mod_ChangeSkin or #(context:GetSkins() or "") > 1 then
			return true
		end
	end

end

