-- See LICENSE for terms

local mod_EnableMod
local mod_LessDust

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_LessDust = CurrentModOptions:GetProperty("LessDust")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

local IsValid = IsValid

local orig_PlayFX = PlayFX
function PlayFX(actionFXClass, actionFXMoment, actor, ...)

	if not mod_EnableMod or not IsValid(actor) or not actor:IsKindOf("RocketBase")
		or actionFXClass ~= "RocketLand"
		or (actionFXMoment ~= "pre-hit-ground2" and actionFXMoment ~= "pre-hit-ground")
	then
		return orig_PlayFX(actionFXClass, actionFXMoment, actor, ...)
	end

	if IsValid(actor.landing_site and actor.landing_site.landing_pad) then
		if mod_LessDust and actionFXMoment == "pre-hit-ground" then
			return orig_PlayFX(actionFXClass, actionFXMoment, actor, ...)
		end
		return
	end

	return orig_PlayFX(actionFXClass, actionFXMoment, actor, ...)
end
