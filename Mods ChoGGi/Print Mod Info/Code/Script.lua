-- See LICENSE for terms

--~ local mod_EnableMod
local _InternalTranslate = _InternalTranslate
local tostring = tostring

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	if not CurrentModOptions:GetProperty("EnableMod") then
		return
	end

	-- Build a table and sort by title afterwards
	local mods_list = {}
	local c = 0

	local ModsLoaded = ModsLoaded
	for i = 1, #ModsLoaded do
		local mod = ModsLoaded[i]
		c = c + 1
		-- Loaded mod with no mod options (log aleady shows them, but for this list
		mods_list[c] = {
			title = mod.title,
			id = mod.id,
			options = mod.has_options,
		}
		--
		if mod.has_options then
			-- Build list of options then stick into .options
			local options = {}

			local props = mod.options:GetProperties()
			for j = 1, #props do
				local prop = props[j]

--~ 				options[j] = _InternalTranslate(prop.name)
--~ 					.. ", Type: " .. prop.editor
--~ 					.. ", Current: " .. tostring(mod.options:GetProperty(prop.id))
--~ 					.. ", Default: " .. tostring(prop.default)

				options[j] = "Current: " .. tostring(mod.options:GetProperty(prop.id))
					.. ", id: " .. prop.id
			end

			mods_list[c].options = options
		end
	end


	-- Sort by title and print
	local CmpLower = CmpLower
	table.sort(mods_list, function(a, b)
		return CmpLower(a.title, b.title)
	end)

	print(" --- Print Mod Info Start ---\n\n")
	for i = 1, c do
		local mod = mods_list[i]
		if mod.options then
			print("Mod Info:", mod.title, "mod_id:", mod.id, "Options:\n", table.concat(mod.options, "\n"))
		else
			print("Mod Info:", mod.title, "mod_id:", mod.id)
		end
		print("-----\n\n")
	end
	print("\n\n --- Print Mod Info End ---\n\n")

end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
--~ -- Fired when Mod Options>Apply button is clicked
--~ OnMsg.ApplyModOptions = ModOptions
