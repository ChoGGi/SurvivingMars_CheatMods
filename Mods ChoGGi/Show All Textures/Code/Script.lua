-- See LICENSE for terms

local mod_EnableMod

local function StartupCode()
	if not mod_EnableMod then
		return
	end

	SuspendPassEdits("ChoGGi.ShowAllTextures.DeleteObjects")
	MapDelete(true, {"VegetationBillboardObject", "StoneSmall", "Deposition", "WasteRockObstructorSmall", "WasteRockObstructor"})
	ResumePassEdits("ChoGGi.ShowAllTextures.DeleteObjects")

	CreateRealTimeThread(function()
		-- Wait for igi so we can add text boxes
		WaitMsg("InGameInterfaceCreated")

		local table = table
		local XText = XText
		local igi = Dialogs.InGameInterface

		-- Add ifs for diff combinations of dlc someday...
		local start_pos = point(478000, 490000, 10000)

		local offset_x = 0
		local offset_y = 0
		local row = 0

		local terrain = ActiveGameMap.terrain
		local const = const

		-- Large circle
		terrain:SetHeightCircle(
			point(447000, 467000), 100000, 150000, 5000, const.hsDefault
		)

		local TerrainTextures = TerrainTextures
		local objs = table.icopy(TerrainTextures)

		local CmpLower = CmpLower
		table.sort(objs, function(a, b)
			return CmpLower(a.name, b.name)
		end)

		for i = 1, #objs do
			local obj = objs[i]

			row = row + 1
			offset_x = offset_x + -5000
			local pos = start_pos:AddX(offset_x):AddY(offset_y)

			-- Make a raised area
			terrain:SetHeightCircle(pos, 2500, 1000, 10000, const.hsDefault)

			-- Since we sorted for humans, we need to map name to texture in TerrainTextures
			local idx = table.find(TerrainTextures, "name", obj.name)
			terrain:SetTypeCircle(pos, 2600, idx)

			-- Floating text for texture name
			local text_dlg = XText:new({
				TextStyle = "EncyclopediaArticleTitle",
				Background = black,
				Dock = "box",
				HAlign = "left",
				VAlign = "top",
				Clip = false,
				HandleMouse = false,
			}, igi)
			text_dlg:AddDynamicPosModifier{
				id = "obj_info",
				target = pos,
			}
			text_dlg:SetText(obj.name)

			--
			if row > 10 then
				offset_x = 0
				offset_y = offset_y + -5000
				row = 0
			end
		end
	--
	end)

end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

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
