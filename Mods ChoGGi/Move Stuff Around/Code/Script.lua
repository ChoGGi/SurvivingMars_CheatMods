-- See LICENSE for terms

local mod_EnableMod

-- Update mod options
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

local function MoveStuff(context, pos)
	-- otherwise there's a selection area left (that I'm too lazy to move as well)
	SelectObj(false)
	local grid_obj
	if context:HasMember("RemoveFromGrids") then
		grid_obj = true
		-- remove it's current pos from the object grid
		context:RemoveFromGrids()
	end
	-- probably best to use hex centres
	context:SetPos(HexGetNearestCenter(pos))
	if grid_obj then
		-- update obj grid to new pos
		context:ApplyToGrids()
	end
	-- re-select it
	SelectObj(context)
end

local ChoOrig_SelectionModeDialog_OnMouseButtonDown = SelectionModeDialog.OnMouseButtonDown

local function AddButton(xtemplate, button_id)
	-- Check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, button_id, true)

	table.insert(xtemplate, 1, PlaceObj("XTemplateTemplate", {
		"Id" , button_id,
		-- No need to add this (I use it for my RemoveXTemplateSections func)
		button_id, true,
		-- The button only shows when the class object is selected
		"__context_of_kind", "CObject",
		-- Section button (see Source\Lua\XTemplates\Infopanel*.lua for more examples)
		"__template", "InfopanelActiveSection",
		-- Only show button when it meets the req
		"__condition", function(_, context)
			return mod_EnableMod and IsValid(context)
		end,
		--
		"Icon", "UI/Icons/Sections/BlackCube_4.tga",
		"Title", T(0000, "Move Around"),
		"RolloverTitle", T(0000, "Move Around"),
		"RolloverText", T(0000, "Click here then somewhere else to move this stuff."),
		}, {
			PlaceObj("XTemplateFunc", {
				"name", "OnActivate(self, context)",
				"parent", function(self)
					return self.parent
				end,
				"func", function(_, context)
					local dlg = Dialogs.SelectionModeDialog
					if not dlg then
						return
					end

					-- too lazy to do a pcall so
					if not dlg.OnMouseButtonDown then
						dlg.OnMouseButtonDown = ChoOrig_SelectionModeDialog_OnMouseButtonDown
					end

					-- change cursor
					dlg:SetMouseCursor("UI/Cursors/loading.tga")

					-- wait for mouseclick
					local ChoOrig_OnMouseButtonDown = dlg.OnMouseButtonDown or ChoOrig_SelectionModeDialog_OnMouseButtonDown
					dlg.OnMouseButtonDown = function(self, pt, button, ...)
						if button == "L" then
							Msg("ChoGGi_MoveStuffAround_MousePressed", GetTerrainCursor())
							-- don't want anything else happening
							return
						end

						return ChoOrig_OnMouseButtonDown(self, pt, button, ...)
					end

					CreateRealTimeThread(function()
						local _, pos = WaitMsg("ChoGGi_MoveStuffAround_MousePressed")
						-- reset func
						dlg.OnMouseButtonDown = ChoOrig_OnMouseButtonDown or ChoOrig_SelectionModeDialog_OnMouseButtonDown
						-- and cursor
						dlg:SetMouseCursor("UI/Cursors/cursor.tga")

						MoveStuff(context, pos)
					end)

				end,
			}),
		})
	)
end

function OnMsg.ClassesPostprocess()
	local templates = {
		"ipSinkhole", "ipMirrorSphereBuilding", "ipMirrorSphere", "ipFirefly", "ipAlienDigger", "ipAttackRover",
		"ipVegetation", "ipToxicPool",
		"ipGridConstruction", "ipPillaredPipe", "ipLeak", "ipSwitch", "ipPassage",
		"ipConstruction", "ipBuilding", "ipAnomaly",
		"ipEffectDeposit", "ipTerrainDeposit", "ipSurfaceDeposit", "ipSubsurfaceDeposit",
		"ipResourcePile",
		"ipColonist", "ipRover", "ipDrone", "ipRogue", "ipShuttle",
		"ipPet", "ipTrack", "ipTrain",
	}
	for i = 1, #templates do
		local template = XTemplates[templates[i]]
		if template then
			AddButton(template[1], "ChoGGi_Template_MoveStuffAround_AddButton" .. i)
		end
	end
end
