-- See LICENSE for terms

local WaitMsg = WaitMsg
local CreateRealTimeThread = CreateRealTimeThread

local function UpdateList(dlg)
	WaitMsg("OnRender")
	if not dlg.idPOIList then
		return
	end
	local const = const

--~ 	ex(buttons)

	local buttons = dlg.idPOIList or ""
	for i = 1, #buttons do
		local button = buttons[i]

		local context = button.context
		button.RolloverTemplate = "Rollover"
		button.RolloverTitle = context.display_name and T(context.display_name)
			or T(126095410863, "Info")
		local desc = context.description and T(context.description) .. "\n\n" or ""

		local str_resources = ""
		local str_time = ""
		local str_outcome = ""
		local str_rocket = ""

		local spot = context.spot_type
		-- show res needed
		if spot == "project" then
			local resources = context:GetRocketResources()
			if next(resources) then
				local inventory = {}
				local c = 0
				for j = 1, #resources do
					local text = resources[j]:GetText()
					if text ~= "" then
						c = c + 1
						inventory[c] = text
					end
				end
				if c > 0 then
					str_resources = T(387987656324, "Additional Inventory") .. "<right>"
						.. table.concat(inventory, " ")
				end
			end

		elseif spot == "anomaly" then
			local requirements = context.requirements
			if next(requirements) then
				local inventory = {}
				local c = 0

				if requirements.num_crew then
					local specialization = const.ColonistSpecialization[requirements.crew_specialization]
					local name = specialization and specialization.display_name or T(3609, "Any")

					c = c + 1
					inventory[c] = T{11539, "<colonist(colonists)>", colonists = requirements.num_crew}
						.. " " .. name
				end

				if requirements.num_drones or requirements.rover_type then
					if requirements.num_drones then
						c = c + 1
						inventory[c] = T{11180, "<drone(num)>", num = requirements.num_drones}
					end
					if requirements.rover_type then
						c = c + 1
						inventory[c] = g_Classes[requirements.rover_type].display_name
					end
				end

				if requirements.required_resources then
					local resources = requirements.required_resources or ""
					for j = 1, #resources do
						local text = resources[j]:GetText()
						if text ~= "" then
							c = c + 1
							inventory[c] = text
						end
					end
				end

				str_resources = T(387987656324, "Additional Inventory") .. "<right>"
					.. table.concat(inventory, " ")
			end

		end
		local newline = (str_resources == "" and "" or "\n")

		-- time it'll take
		if spot == "project" or spot == "anomaly" then

			-- change colour of stuff with a rocket "on the way"
			if IsValid(context.rocket) then
				button.idText:SetTextStyle("Action")
				str_rocket = newline .. "<left>" .. T(1685, "Rocket") .. "<right>"
					.. T{"<DisplayName>", context.rocket}
			end

			if not context.rocket and context.expedition_time then
				str_time = context.expedition_time
			elseif not context.rocket or not context.rocket.expedition_return_time then
				str_time = RocketExpedition.ExpeditionTime * 2
			end

			if str_time ~= "" then
				str_time = newline .. "<left>" .. T(874227567877, "Expedition time") .. "<right>"
					.. T{11604, "<time(time)>", time = str_time}
			end
		end

		-- what you get
		if context.ShowOutcomeText and context:ShowOutcomeText() then
			str_outcome = newline .. "<left>" .. T(130571839539, "Outcome") .. "<right>"
				.. context:GetOutcomeText()
		end

		button:SetRolloverText(desc .. str_resources .. str_time .. str_outcome .. str_rocket)
	end
end

local ChoOrig_GetSortedMarsPointsOfInterest = GetSortedMarsPointsOfInterest
function GetSortedMarsPointsOfInterest(...)
	if Dialogs.PlanetaryView then
		CreateRealTimeThread(UpdateList, Dialogs.PlanetaryView)
	end
	return ChoOrig_GetSortedMarsPointsOfInterest(...)
end
