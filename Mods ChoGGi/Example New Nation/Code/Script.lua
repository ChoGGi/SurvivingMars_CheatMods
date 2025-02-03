-- See LICENSE for terms

-- non visible id for your nation (best to use something unique)
local nation_id = "Example_Nation"
-- Name that'll be visible to players (0000 is a placeholder for assigning a unique number, you don't need to though)
local nation_name = T(0000, "Example Nation")

-- Add new nation (I don't think we need to check for it, but it doesn't hurt)
if not table.find(Nations, "value", nation_id) then
	Nations[#Nations+1] = {
		value = nation_id,
		-- The game code uses .tga for dds files, so I just make everything .tga even if it isn't
		flag = CurrentModPath .. "UI/flag.tga",
		text = nation_name
	}
end

-- Family and Unique don't seem to be needed
HumanNames[nation_id] = {
	Male = {
		-- These are existing names from English, you can change the number to 0000 and use whatever
		T(1724, "Albion"),
		T(1725, "Alun"),
		T(1726, "Arin"),
	},
	Female = {
		T(1773, "Alannah"),
		T(1774, "Aphra"),
		T(1775, "Ashlyn"),
	},
	Family = {
		T(1839, "Jones"),
		T(1840, "Williams"),
		T(1841, "Brown"),
	},
	-- Only used once a playthrough
	Unique ={
		T(2870, "Gabriel Dobrev") ,
		T(2871, "Ivan-Assen Ivanov"),
		T(2872, "Ivko Stanilov"),
	},

}
-- See more name examples here:
-- https://github.com/surviving-mars/SurvivingMars/blob/master/Lua/Names.lua#L1097
