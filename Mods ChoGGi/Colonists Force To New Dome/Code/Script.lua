-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
local fire_once
function OnMsg.ModsReloaded()
	if fire_once then
		return
	end
	fire_once = true
	local min_version = 28

	local ModsLoaded = ModsLoaded
	-- we need a version check to remind Nexus/GoG users
	local not_found_or_wrong_version
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	if idx then
		-- steam updates automatically
		if not Platform.steam and min_version > ModsLoaded[idx].version then
			not_found_or_wrong_version = true
		end
	else
		not_found_or_wrong_version = true
	end

	if not_found_or_wrong_version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[Force To New Dome requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
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
