-- See LICENSE for terms

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- they don't have a template_class
local skips = {
	OutsideMonumentLarge = true,
	OutsideMonumentSmall = true,
	OutsideStatueLarge = true,
	OutsideStatueSmall = true,
	OutsideStatue = true,
	OutsideObelisk = true,
	OutsideObelisk = true,
	LightTripod = true,
}
function OnMsg.GatherUIBuildingPrerequisites(template)
	if not mod_EnableMod or skips[template.id] then
		return
	end

	local class = g_Classes[template.template_class]
	-- they added a bunch of stuff in picard that uses "false"...
	if not class and template.template_class ~= "false" then
		print("Borked Mod Building Template:", ValueToLuaCode(template))

		CreateMessageBox(
			"Borked Mod Building Template:",
			"See log for more info:" .. template.id)
	end

end
