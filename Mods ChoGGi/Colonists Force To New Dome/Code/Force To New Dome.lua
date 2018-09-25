-- See LICENSE for terms

-- tell people know how to get the library
function OnMsg.ModsLoaded()
	local library_version = 13

	local ModsLoaded = ModsLoaded
	local not_found_or_wrong_version
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	if idx then
		if library_version < ModsLoaded[idx].version then
			not_found_or_wrong_version = true
		end
	else
		not_found_or_wrong_version = true
	end

	if not_found_or_wrong_version then
		CreateRealTimeThread(function()
			local Sleep = Sleep
			while not UICity do
				Sleep(1000)
			end
			if WaitMarsQuestion(nil,nil,string.format([[Error: This mod requires ChoGGi's Library v%s.
Press Ok to download it or check Mod Manager to make sure it's enabled.]],library_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

-- generate is late enough that my library is loaded, but early enough to replace anything i need to
function OnMsg.ClassesGenerate()

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
		local XTemplates = XTemplates

		if XTemplates.sectionDome.ChoGGi_ForceNewDome then
			table.remove(XTemplates.sectionDome[1],#XTemplates.sectionDome[1])
			XTemplates.sectionDome.ChoGGi_ForceNewDome = nil
		end
		ChoGGi.CodeFuncs.RemoveXTemplateSections(XTemplates.sectionDome[1],"ChoGGi_ForceNewDome")

		ChoGGi.CodeFuncs.AddXTemplate("ForceNewDome","sectionDome",{
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
