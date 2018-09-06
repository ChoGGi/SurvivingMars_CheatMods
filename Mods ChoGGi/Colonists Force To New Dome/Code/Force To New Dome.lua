-- See LICENSE for terms

function OnMsg.ModsLoaded()
	if not table.find(ModsLoaded,"id","ChoGGi_Library") then
		print([[Error: This mod requires ChoGGi's Library:
https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374
Check Mod Manager to make sure it's enabled.]])
	end
end

-- nope not hacky at all
local is_loaded
function OnMsg.ClassesGenerate()
	Msg("ChoGGi_Library_Loaded","ChoGGi_ColonistsForceToNewDome")
end
function OnMsg.ChoGGi_Library_Loaded(mod_id)
	if is_loaded or mod_id and mod_id ~= "ChoGGi_ColonistsForceToNewDome" then
		return
	end
	is_loaded = true
	-- nope nope nope

	local S = ChoGGi.Strings
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

		local ItemList = {}
		local c = 0

		--make it pretty
		for i = 1, #domes do
			--skip ruined domes, and self
			if domes[i].air and domes[i].handle ~= dome.handle then
				local pos = domes[i]:GetVisualPos()
				c = c + 1
				ItemList[c] = {
					pos = pos,
					name = RetName(domes[i]),
					hint = string.format([[Position: %s

Colonists: %s

Living Spaces: %s]],
						pos,
						#(domes[i].labels.Colonist or ""),
						domes[i]:GetLivingSpace() or 0
					), -- provide a slight reference
					clicked = function(_,_,button)
						ClickObj(dome,domes[i],button)
					end,
				}
			end
		end

		if #ItemList == 0 then
			return
		end

		-- add controller for ease of movement
		ItemList[#ItemList+1] = {
			name = [[ Current Dome]],
			pos = dome:GetVisualPos(),
			hint = [[Currently selected dome]],
			clicked = function(_,_,button)
				ClickObj(false,dome,button)
			end,
		}

		local popup = rawget(terminal.desktop, "idForceNewDomeMenu")
		if popup then
			popup:Close()
		else
			PopupToggle(parent,"idForceNewDomeMenu",ItemList)
		end

	end

	function OnMsg.ClassesBuilt()

		if XTemplates.sectionDome.ChoGGi_ForceNewDome then
			table.remove(XTemplates.sectionDome[1],#XTemplates.sectionDome[1])
			XTemplates.sectionDome.ChoGGi_ForceNewDome = nil
		end

		ChoGGi.CodeFuncs.RemoveXTemplateSections(XTemplates.sectionDome[1],"ChoGGi_ForceNewDome")
		XTemplates.sectionDome[1][#XTemplates.sectionDome[1]+1] = PlaceObj("XTemplateTemplate", {
			"ChoGGi_ForceNewDome", true,
			"__template", "InfopanelSection",
			-- skip any ruined domes
			"__condition", function (parent, context) return context.air end,
			"RolloverTitle", " ",
			"RolloverHint",  "",
			"Title",  [[Force New Dome]],
			"RolloverText",  [[Use this to force colonists to migrate.]],
			"Icon",  "UI/Icons/bmc_domes_shine.tga",
		}, {
			PlaceObj("XTemplateFunc", {
				"name", "OnActivate(self, context)",
				"parent", function(parent, context)
					return parent.parent
				end,
				"func", function(self, context)
					---
					ListBuildings(self, context)
					---
				end
			})
		})

	end --OnMsg

end
