-- See LICENSE for terms

local TerrainTextures = TerrainTextures
local point = point

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

local function StartupCode()
	if not mod_EnableMod then
		return
	end

	CreateRealTimeThread(function()
		-- wait for igi so we can add text boxes
		WaitMsg("InGameInterfaceCreated")

		local XText = XText
		local igi = Dialogs.InGameInterface

		local start_pos = point(475000, 470000, 10000)
		local offset_x = 0
		local offset_y = 0
		local row = 0

		local terrain = ActiveGameMap.terrain

		terrain:SetHeightCircle(point(447000, 467000), 100000, 100000, 5000)

		for i = 1, #TerrainTextures do
			row = row + 1
			offset_x = offset_x + -5000
			local pos = start_pos:AddX(offset_x):AddY(offset_y)
			terrain:SetHeightCircle(pos, 2500, 1000, 10000)
			terrain:SetTypeCircle(pos, 2600, i)

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
			text_dlg:SetText(TerrainTextures[i].name)


			if row > 10 then
				offset_x = 0
				offset_y = offset_y + -5000
				row = 0
			end
		end
	end)

end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
