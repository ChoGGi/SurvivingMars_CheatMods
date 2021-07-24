-- See LICENSE for terms

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	-- I'm sure it wouldn't be that hard to only call this msg for the mod being applied, but...
	if id == CurrentModId then
		ModOptions()
	end
end

function OnMsg.GatherUIBuildingPrerequisites(template)
	if not mod_EnableMod then
		return
	end

	local class = g_Classes[template.template_class]
	if not class then
		print("Borked Mod Building Template:", ValueToLuaCode(template))

		CreateMessageBox(
			"Borked Mod Building Template:",
			"See log for more info:" .. template.id,
			nil,
			nil,
			nil,
			ChoGGi.library_path .. "UI/message_picture_01.png"
		)
	end

end
