-- See LICENSE for terms

local StoryBits = StoryBits

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "FickleEconomics",
		"DisplayName", StoryBits.IncreaseResourceCost.Title,
		"Help", T{302535920012093, "Stop this storybit from happening:<newline><newline><storybit><newline><newline><image "
			.. StoryBits.IncreaseResourceCost.Image .. ">",
			storybit = StoryBits.IncreaseResourceCost.Text,
		},
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "RocketMalfunction",
		"DisplayName", StoryBits.BadRocketLanding.Title,
		"Help", T{302535920012093, "Stop this storybit from happening:<newline><newline><storybit><newline><newline><image "
			.. StoryBits.BadRocketLanding.Image .. ">",
			storybit = StoryBits.BadRocketLanding.Text,
		},
		"DefaultValue", false,
	}),
}
