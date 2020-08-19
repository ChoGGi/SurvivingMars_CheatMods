-- See LICENSE for terms

local PopupToggle = ChoGGi.ComFuncs.PopupToggle
local RetName = ChoGGi.ComFuncs.RetName
local IsValid = IsValid

local function SetNewDome_Dome(old, new, button)
	-- skip selected dome
	if not old or not IsValid(new) then
		return
	end

	if button == "R" then
		ViewObjectMars(new)
	else
		local c = old.labels.Colonist or ""
		for i = #c, 1, -1 do
			local obj = c[i]
			obj.dome = false -- force the setter
			obj:SetDome(new)
		end
	end
end

local function SetNewDome_Unit(unit, dome, button)
	-- skip selected dome
	if not unit or not IsValid(dome) then
		return
	end

	if button == "R" then
		ViewObjectMars(dome)
	else
		unit.dome = false -- force the setter
		unit:SetDome(dome)
	end
end

local function ListBuildings(parent, dome)
	local domes = UICity.labels.Dome or ""

	local item_list = {}
	local c = 0

	-- make it pretty
	for i = 1, #domes do
		local obj = domes[i]
		-- skip ruined domes, and self
		if obj.air and obj.handle ~= dome.handle then
			local pos = obj:GetPos()
			c = c + 1
			item_list[c] = {
				pos = pos,
				name = RetName(obj),
				 -- provide a slight reference
				hint = T{302535920011059, [[Position: <position>

Colonists: <colonist>

Living Spaces: <spaces>]],
					position = pos,
					colonist = #(obj.labels.Colonist or ""),
					spaces = obj:GetLivingSpace() or 0,
				},
				mouseup = function(_, _, _, button)
					SetNewDome_Dome(dome, obj, button)
				end,
			}
		end
	end

	if #item_list == 0 then
		return
	end

	-- add controller for ease of movement
	c = c + 1
	item_list[c] = {
		name = T(302535920011060, "Current Dome"),
		pos = dome:GetPos(),
		hint = T(302535920011061, "Currently selected dome"),
		mouseup = function(_, _, _, button)
			SetNewDome_Dome(false, dome, button)
		end,
	}

	local popup = terminal.desktop.idForceNewDomeMenu
	if popup then
		popup:Close()
	else
		PopupToggle(parent, "idForceNewDomeMenu", item_list)
	end

end

local function ListBuildingsUnit(parent, unit)
	local domes = UICity.labels.Dome or ""

	local item_list = {}
	local c = 0

	-- make it pretty
	for i = 1, #domes do
		local dome = domes[i]
		-- skip ruined domes
		if dome.air then
			local pos = dome:GetPos()
			c = c + 1
			item_list[c] = {
				pos = pos,
				name = RetName(dome),
				 -- provide a slight reference
				hint = T{302535920011059, [[Position: <position>

Colonists: <colonist>

Living Spaces: <spaces>]],
					position = pos,
					colonist = #(dome.labels.Colonist or ""),
					spaces = dome:GetLivingSpace() or 0,
				},
				mouseup = function(_, _, _, button)
					SetNewDome_Unit(unit, dome, button)
				end,
			}
		end
	end

	if #item_list == 0 then
		return
	end

	local popup = terminal.desktop.idForceNewDomeMenu
	if popup then
		popup:Close()
	else
		PopupToggle(parent, "idForceNewDomeMenu", item_list)
	end

end


function OnMsg.ClassesPostprocess()
	local XTemplates = XTemplates

	-- old version cleanup
	if XTemplates.sectionDome.ChoGGi_ForceNewDome then
		ChoGGi.ComFuncs.RemoveXTemplateSections(XTemplates.sectionDome[1], "ChoGGi_ForceNewDome")
		XTemplates.sectionDome.ChoGGi_ForceNewDome = nil
	end

	ChoGGi.ComFuncs.AddXTemplate("ForceNewDome", "sectionDome", {
		-- skip any ruined domes
		__condition = function(_, context)
			return context.working
		end,
		Icon = "UI/Icons/bmc_domes_shine.tga",
		Title = T(302535920011062, "Force New Dome"),
		RolloverText = T(302535920011063, "Use this to force colonists to migrate."),
		func = function(self, context)
			ListBuildings(self, context)
		end,
	})

	ChoGGi.ComFuncs.AddXTemplate("ManualColonistRelocation", "ipColonist", {
		Icon = "UI/Icons/bmc_domes_shine.tga",
		Title = T(302535920011062, "Force New Dome"),
		RolloverText = T(00000000000, "Force colonist to migrate to new dome."),
		func = function(self, context)
			ListBuildingsUnit(self, context)
		end,
	})

end -- OnMsg
