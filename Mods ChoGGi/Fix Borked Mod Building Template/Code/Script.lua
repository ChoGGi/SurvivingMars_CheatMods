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
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

function OnMsg.GatherUIBuildingPrerequisites(template)
	if not mod_EnableMod then
		return
	end

	-- they added a bunch of stuff in picard that uses "false"...
	if template.template_class and template.template_class ~= "false" then
		local class = g_Classes[template.template_class]
		if not class then
			print("Borked Mod Building Template:", ValueToLuaCode(template))

			local title = template.mod and template.mod.title or ""
			CreateMessageBox(
				"Borked Mod Building Template:",
				"See log for more info:" .. template.id .. "\n" .. title)
		end
	end

end
