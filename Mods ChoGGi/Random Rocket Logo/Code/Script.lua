-- See LICENSE for terms

local mod_SkipDefault

-- fired when settings are changed/init
local function ModOptions()
	mod_SkipDefault = CurrentModOptions:GetProperty("SkipDefault")
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

local default_logos = {
	Android = true,
	BlueSun = true,
	Brazil = true,
	BrusselsSprout = true,
	China = true,
	Curiosity = true,
	DontPanic = true,
	Europe = true,
	FinalCountdown = true,
	IMM = true,
	India = true,
	Japan = true,
	MarsExpress = true,
	MarsU = true,
	MrHandy = true,
	NewArk = true,
	OneSmallStep = true,
	Paradox = true,
	Russia = true,
	Serenity = true,
	SpaceCommunism = true,
	SpaceY = true,
	SurvivingMars = true,
	TerraInitiative = true,
	USA = true,
	Voyager = true,
}

local logos
local c
local function BuildLogos()
	logos = {}
	c = 0
	local list = Presets.MissionLogoPreset.Default
	for i = 1, #list do
		local logo = list[i]
		if not mod_SkipDefault or mod_SkipDefault and not default_logos[logo.id] then
			c = c + 1
			logos[c] = logo.entity_name
		end
	end
end

local skip_rockets = {
	ForeignTradeRocket = true,
	RefugeeRocket = true,
--~ 	TradeRocket = true,
}

function OnMsg.RocketLandAttempt(rocket)
	if skip_rockets[rocket.class] then
		return
	end

	-- some rockets might not have a logo?
	local logo = rocket:GetAttaches("Logo")
	logo = logo and logo[1]
	if not logo then
		return
	end

	if not logos then
		BuildLogos()
	end
	-- no logos in list to pick so abort
	if c < 1 then
		return
	end

	-- table.rand outputs the count as well which messes up ChangeEntity
	local new_logo = table.rand(logos)
	logo:ChangeEntity(new_logo)
end

--~ ~MissionLogoPresetMap
