-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 59
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error","Force To New Dome requires ChoGGi's Library (at least v" .. min_version .. [[).
Press OK to download it or check the Mod Manager to make sure it's enabled.]]) == "ok" then
				if p.steam then
					OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
				elseif p.pops then
					OpenUrl("https://mods.paradoxplaza.com/mods/505/Any")
				else
					OpenUrl("https://www.nexusmods.com/survivingmars/mods/89?tab=files")
				end
			end
		end)
	end
end

-- generate is late enough that my library is loaded, but early enough to replace anything i need to
function OnMsg.ClassesGenerate()

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

		--make it pretty
		for i = 1, #domes do
			--skip ruined domes, and self
			if domes[i].air and domes[i].handle ~= dome.handle then
				local pos = domes[i]:GetVisualPos()
				c = c + 1
				item_list[c] = {
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

		if #item_list == 0 then
			return
		end

		-- add controller for ease of movement
		item_list[#item_list+1] = {
			name = [[ Current Dome]],
			pos = dome:GetVisualPos(),
			hint = [[Currently selected dome]],
			clicked = function(_,_,button)
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

end
