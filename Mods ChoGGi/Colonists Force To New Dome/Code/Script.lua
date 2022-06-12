-- See LICENSE for terms

local mod_CleanupColonists

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_CleanupColonists = CurrentModOptions:GetProperty("CleanupColonists")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local PopupToggle = ChoGGi.ComFuncs.PopupToggle
local IsValid = IsValid
local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate

local function SortName(a, b)
	return CmpLower(_InternalTranslate(a.name), _InternalTranslate(b.name))
end

local function SetNewDome(old, new_dome, button, obj_type)
	if not IsValid(old) or not IsValid(new_dome) then
		return
	end

	if button == "R" then
		ViewObjectMars(new_dome)
	else
		if obj_type == "dome" then
			local objs = old.labels.Colonist or ""
			for i = #objs, 1, -1 do
				local obj = objs[i]
				if mod_CleanupColonists and not IsValid(obj) then
					-- probably not needed
					old:RemoveFromLabel("Colonist", obj)
					-- needed
					table.remove(objs, i)
				else
					obj.current_dome = false
					obj:SetOutside(true)
					obj:SetWorkplace(false)
					obj:SetResidence(false)
					obj:SetDome(false)
					obj.dome = false -- force the setter
					obj:SetDome(new_dome)
				end
			end
--~ 		elseif obj_type == "unit" then
		else
			old.current_dome = false
			old:SetOutside(true)
			old:SetWorkplace(false)
			old:SetResidence(false)
			old:SetDome(false)
			old.dome = false -- force the setter
			old:SetDome(new_dome)
		end
	end
end

local function ListBuildings(sidepanel, input_obj, obj_type)
	local domes = UIColony:GetCityLabels("Dome")

	local item_list = {}
	local c = 0

	-- make it pretty
	for i = 1, #domes do
		local obj = domes[i]
		-- skip non-working domes, and current dome
		if obj.working and obj ~= input_obj then
			local pos = obj:GetPos()
			c = c + 1
			item_list[c] = {
				pos = pos,
				name = obj:GetDisplayName(),
				 -- provide a slight reference
				hint = T{302535920011059, [[Colonists: <yellow><colonist></yellow>
Living Spaces: <yellow><spaces></yellow>]],
					colonist = #(obj.labels.Colonist or ""),
					spaces = obj:GetLivingSpace() or 0,
				},
				mouseup = function(_, _, _, button)
					SetNewDome(input_obj, obj, button, obj_type)
				end,
			}
		end
	end

	if #item_list == 0 then
		return
	end

	if obj_type == "dome" then
		local pos = input_obj:GetPos()
		-- add controller for ease of movement
		c = c + 1
		item_list[c] = {
			name = T{302535920011060, "<name> (Current)",
				name = input_obj:GetDisplayName(),
			},
			pos = pos,
			hint = T{302535920011059, [[Colonists: <yellow><colonist></yellow>
Living Spaces: <yellow><spaces></yellow>]],
				colonist = #(input_obj.labels.Colonist or ""),
				spaces = input_obj:GetLivingSpace() or 0,
			},
			mouseup = function(_, _, _, button)
				SetNewDome(false, input_obj, button, "dome")
			end,
		}
	end

	table.sort(item_list, SortName)

	local popup = terminal.desktop.idForceNewDomeMenu
	if popup then
		popup:Close()
	else
		PopupToggle(sidepanel, "idForceNewDomeMenu", item_list)
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
		Icon = "UI/Icons/bmc_domes_shine.tga",
		Title = T(302535920011062, "Force New Dome"),
		RolloverText = T(302535920011063, "Force colonists to migrate to new dome."),
		RolloverHint = T(302535920011766, "<left_click> View Dome List"),
		func = function(self, context)
			ListBuildings(self, context, "dome")
		end,
	})

	ChoGGi.ComFuncs.AddXTemplate("ManualColonistRelocation", "ipColonist", {
		Icon = "UI/Icons/bmc_domes_shine.tga",
		Title = T(302535920011062, "Force New Dome"),
		RolloverText = T(302535920011061, "Force colonist to migrate to new dome."),
		RolloverHint = T(302535920011766, "<left_click> View Dome List"),
		func = function(self, context)
			ListBuildings(self, context, "unit")
		end,
	})

end -- OnMsg
