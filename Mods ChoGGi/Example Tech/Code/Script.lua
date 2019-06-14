
-- add a new tech
function OnMsg.ClassesPostprocess()
	if TechDef.ChoGGi_ExampleTech then
		return
	end

	PlaceObj("TechPreset", {
		-- where in the list to add it (for new games)
		SortKey = 1,
		description = "stuff happens",
		display_name = "Example tech",
		group = "Engineering",
		icon = "UI/Icons/Research/construction_nanites.tga",
		id = "ChoGGi_ExampleTech",
	})

end

-- insert into existing saves
function OnMsg.LoadGame()
	local UICity = UICity

	-- already added
	if UICity.tech_status.ChoGGi_ExampleTech then
		return
	end

	UICity.tech_status.ChoGGi_ExampleTech = {
		field = "Engineering",
		-- any points researched yet?
		points = 0,
		-- how many to complete (defaults to 3000?)
		cost = 1000,
	}
	-- where in the list to add it (for existing games)
	table.insert(UICity.tech_field.Engineering, 3, "ChoGGi_ExampleTech")
end
