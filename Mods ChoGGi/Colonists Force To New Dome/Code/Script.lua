-- See LICENSE for terms

local PopupToggle = ChoGGi.ComFuncs.PopupToggle
local RetName = ChoGGi.ComFuncs.RetName
local IsValid = IsValid
local WorldToHex = WorldToHex
local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate

local function SortName(a, b)
	return CmpLower(_InternalTranslate(a.name), _InternalTranslate(b.name))
end

local function SetNewDome(old, new, button, obj_type)
	-- skip selected dome
	if not old or not IsValid(new) then
		return
	end

	if button == "R" then
		ViewObjectMars(new)
	else
		if obj_type == "dome" then
			local objs = old.labels.Colonist or ""
			for i = #objs, 1, -1 do
				local obj = objs[i]
				obj.dome = false -- force the setter
				obj:SetDome(new)
			end
--~ 		elseif obj_type == "unit" then
		else
			old.dome = false -- force the setter
			old:SetDome(new)
		end
	end
end

local function ListBuildings(parent, input_obj, obj_type)
	local domes = UICity.labels.Dome or ""

	local item_list = {}
	local c = 0

	-- make it pretty
	for i = 1, #domes do
		local obj = domes[i]
		-- skip non-working domes, and current dome
		if obj.working and obj.handle ~= input_obj.handle then
			local pos = obj:GetPos()
			local h1, h2 = WorldToHex(pos)
			c = c + 1
			item_list[c] = {
				pos = pos,
				name = RetName(obj),
				 -- provide a slight reference
				hint = T{302535920011059, [[Position: <position>
Colonists: <colonist>
Living Spaces: <spaces>]],
					position = h1 .. ", " .. h2,
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
		local h1, h2 = WorldToHex(pos)
		-- add controller for ease of movement
		c = c + 1
		item_list[c] = {
			name = T{302535920011060, "<name> (Current)",
				name = input_obj:GetDisplayName(),
			},
			pos = pos,
			hint = T{302535920011059, [[Position: <position>
Colonists: <colonist>
Living Spaces: <spaces>]],
				position = h1 .. ", " .. h2,
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
		RolloverText = T(302535920011063, "Force colonists to migrate to new dome."),
		func = function(self, context)
			ListBuildings(self, context, "dome")
		end,
	})

	ChoGGi.ComFuncs.AddXTemplate("ManualColonistRelocation", "ipColonist", {
		Icon = "UI/Icons/bmc_domes_shine.tga",
		Title = T(302535920011062, "Force New Dome"),
		RolloverText = T(302535920011061, "Force colonist to migrate to new dome."),
		func = function(self, context)
			ListBuildings(self, context, "unit")
		end,
	})

end -- OnMsg
