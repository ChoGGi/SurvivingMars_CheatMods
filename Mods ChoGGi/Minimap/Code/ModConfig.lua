function OnMsg.ModConfigReady()
	local ModConfig = ModConfig
	local ChoGGi_Minimap = ChoGGi_Minimap

	-- setup menu options
	ModConfig:RegisterMod("ChoGGi_Minimap", "Minimap")

	ModConfig:RegisterOption("ChoGGi_Minimap", "UseScreenshots", {
		name = "Screenshots or topography images (needs topo mod)",
		type = "boolean",
		default = ChoGGi_Minimap.UseScreenshots,
	})

	-- get saved options
	ChoGGi_Minimap.UseScreenshots = ModConfig:Get("ChoGGi_Minimap", "UseScreenshots")
end

function OnMsg.ModConfigChanged(mod_id, option_id, value)
	if mod_id == "ChoGGi_Minimap" and option_id == "UseScreenshots" then
		ChoGGi_Minimap.UseScreenshots = value

		-- find our map dlg
		local map_dlg
		local dlgs = g_ChoGGiDlgs
		for dlg in pairs(dlgs) do
			if dlg:IsKindOf("ChoGGi_MinimapDlg") then
				map_dlg = dlg
				break
			end
		end

		if not map_dlg then
			return
		end

		-- update minimap with image or topo image
		if value then
			map_dlg:UpdateMapImage(map_dlg.map_file)
		else

			local str = ChoGGi_Minimap.image_str
			if not str then
				local image_mod = Mods.ChoGGi_MapImagesPack
				ChoGGi_Minimap.image_str = image_mod and string.format("%sMaps/%s.png",image_mod.env.CurrentModPath,"%s")
				str = ChoGGi_Minimap.image_str
			end
			if str then
				map_dlg:UpdateMapImage(str:format(map_dlg.map_name))
			else
				print([[ChoGGi Minimap needs: https://steamcommunity.com/sharedfiles/filedetails/?id=1571465108]])
			end

		end

	end
end
