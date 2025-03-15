-- See LICENSE for terms

-- non visible id for your nation (best to use something unique)
local nation_id = "Example_Nation"
-- Name that'll be visible to players (0000 is a placeholder for assigning a unique number, you don't need to though)
local nation_name = T(0000, "Example Nation")

-- Add new nation (I don't think we need to check for it, but it doesn't hurt)
if not table.find(Nations, "value", nation_id) then
	Nations[#Nations+1] = {
		value = nation_id,
		-- The game code uses .tga for dds files, so I just make every path .tga even if it isn't
		flag = CurrentModPath .. "UI/flag.tga",
		text = nation_name
	}
end

-- Family and Unique don't seem to be needed
HumanNames[nation_id] = {
	Male = {
		-- These are existing names from English, you can change the number to 0000 and use whatever
		T(0000, "Bob"),
		T(0000, "Doug"),
		T(0000, "Ricky"),
		T(0000, "Julian"),
		T(0000, "Bubbles"),
		T(0000, "J-Roc"),
		T(0000, "Ray"),
		T(0000, "Cory"),
		T(0000, "Trevor"),
		T(0000, "Cyrus"),
	},
	Female = {
		T(0000, "Sarah"),
		T(0000, "Lucy"),
		T(0000, "Desiree"),
	},
	Family = {
		T(0000, "McKenzie"),
		T(0000, "LaFleur"),
		T(0000, "Lahey"),
		T(0000, "Collins"),
	},
	-- Only used once a playthrough
	Unique = {
		T(0000, "Jim Lahey") ,
		T(0000, "Michael Jackson"),
		T(0000, [[Philadelphia "Phil" Collins ]]),
	},

}
-- See more name examples here:
-- https://github.com/surviving-mars/SurvivingMars/blob/master/Lua/Names.lua#L1097
