-- See LICENSE for terms

local Strings = ChoGGi.Strings
local PopupToggle = ChoGGi.ComFuncs.PopupToggle
local RetName = ChoGGi.ComFuncs.RetName

local rawget = rawget
local XTemplates = XTemplates
local PlaceObj = PlaceObj
local IsValid = IsValid
local ViewPos = ViewPos

local function ClickObj(old,new,button)
	--skip selected dome
	if not old or not IsValid(new) then
		return
	end
	if button == "L" then
		local c = old.labels.Colonist
		for i = #c, 1, -1 do
			c[i]:SetDome(new)
		end
	elseif button == "R" then
		ViewObjectMars(new)
	end
end

local function ListBuildings(parent,dome)
	local domes = UICity.labels.Dome or ""

	local item_list = {}
	local c = 0

	local hint_str = [[Position: %s

Colonists: %s

Living Spaces: %s]]

	-- make it pretty
	for i = 1, #domes do
		-- skip ruined domes, and self
		if domes[i].air and domes[i].handle ~= dome.handle then
			local pos = domes[i]:GetVisualPos()
			c = c + 1
			item_list[c] = {
				pos = pos,
				name = RetName(domes[i]),
				 -- provide a slight reference
				hint = hint_str:format(
					pos,
					#(domes[i].labels.Colonist or ""),
					domes[i]:GetLivingSpace() or 0
				),
				mouseup = function(_,_,_,button)
					ClickObj(dome,domes[i],button)
				end,
			}
		end
	end

	if #item_list == 0 then
		return
	end

	-- add controller for ease of movement
	item_list[#item_list+1] = {
		name = [[ Current Dome]],
		pos = dome:GetVisualPos(),
		hint = [[Currently selected dome]],
		mouseup = function(_,_,_,button)
			ClickObj(false,dome,button)
		end,
	}

	local popup = terminal.desktop.idForceNewDomeMenu
	if popup then
		popup:Close()
	else
		PopupToggle(parent,"idForceNewDomeMenu",item_list)
	end

end

function OnMsg.ClassesBuilt()
	local XTemplates = XTemplates

	-- old version cleanup
	if XTemplates.sectionDome.ChoGGi_ForceNewDome then
		ChoGGi.ComFuncs.RemoveXTemplateSections(XTemplates.sectionDome[1],"ChoGGi_ForceNewDome")
		XTemplates.sectionDome.ChoGGi_ForceNewDome = nil
	end

	ChoGGi.ComFuncs.AddXTemplate("ForceNewDome","sectionDome",{
		-- skip any ruined domes
		__condition = function(parent, context)
			return context.working
		end,
		Icon = "UI/Icons/bmc_domes_shine.tga",
		Title = [[Force New Dome]],
		RolloverText = [[Use this to force colonists to migrate.]],
		func = function(self, context)
			ListBuildings(self, context)
		end,
	})

end --OnMsg
