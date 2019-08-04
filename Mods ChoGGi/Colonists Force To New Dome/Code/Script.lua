-- See LICENSE for terms

local PopupToggle = ChoGGi.ComFuncs.PopupToggle
local RetName = ChoGGi.ComFuncs.RetName

local XTemplates = XTemplates
local IsValid = IsValid

local function ClickObj(old, new, button)
	--skip selected dome
	if not old or not IsValid(new) then
		return
	end
	if button == "R" then
		ViewObjectMars(new)
	else
		local c = old.labels.Colonist
		for i = #c, 1, -1 do
			c[i]:SetDome(new)
		end
	end
end

local function ListBuildings(parent, dome)
	local domes = UICity.labels.Dome or ""

	local item_list = {}
	local c = 0

	-- make it pretty
	for i = 1, #domes do
		local dome = domes[i]
		-- skip ruined domes, and self
		if dome.air and dome.handle ~= dome.handle then
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
					ClickObj(dome, dome, button)
				end,
			}
		end
	end

	if #item_list == 0 then
		return
	end

	-- add controller for ease of movement
	item_list[#item_list+1] = {
		name = T(302535920011060, [[Current Dome]]),
		pos = dome:GetVisualPos(),
		hint = T(302535920011061, [[Currently selected dome]]),
		mouseup = function(_, _, _, button)
			ClickObj(false, dome, button)
		end,
	}

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
		Title = T(302535920011062, [[Force New Dome]]),
		RolloverText = T(302535920011063, [[Use this to force colonists to migrate.]]),
		func = function(self, context)
			ListBuildings(self, context)
		end,
	})

end --OnMsg
