-- See LICENSE for terms

local mod_EnableMod

local ChoOrig_Open
local function new_Open(...)
	ChoOrig_Open(...)

	if not mod_EnableMod then
		return
	end

	-- default 96
	hr.EnablePostProcScreenBlur = 1
end

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

-- backup orig func for easy swapping and replace with new func
function OnMsg.ClassesPostprocess()

	local xtemplate = XTemplates.ScreenBlur[1]
	local idx = table.find(xtemplate, "name", "Open")
	if idx then
		xtemplate = xtemplate[idx]

		-- don't want to save my new func as orig
		if type(ChoOrig_Open) ~= "function" then
			ChoOrig_Open = xtemplate.func
		end

		xtemplate.func = new_Open
	end
end
