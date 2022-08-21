### Adding new traits:

```lua
function OnMsg.ClassesPostprocess()
	if TraitPresets.UniqueName_Fitter then
		return
	end

	PlaceObj("TraitPreset", {
		id = "UniqueName_Fitter",

		display_name = "Fitter", -- probably should use T{} and translate it

		description = T{6639, --[[TraitPreset Composed description]] "All Sanity losses are halved."},
		infopanel_effect_text = T{6694, --[[TraitPreset Empath infopanel_effect_text]] "Inspired by an Empath +<amount>"},

		group = "Positive",

		-- is it going in the rare mods table?
		rare = false,
		-- weighted selection of rare mods?
		weight = 5,
		-- something like Biorobot?
		hidden_on_start = false,
		-- only happens in domes?
		dome_filter_only = false,

		modify_amount = 5,
		modify_percent = 0,
		modify_property = "DailyHealthRecover", -- default = ""
		modify_target = "self", -- default = "" (Empath has this set to "dome colonists")
		modify_trait = "" -- Target only Colonists with trait (Saint has this set to "Religious")

		-- if this was the dreamer trait then you'd get +15 performance
		param = 15,

		-- does this trait add an interest
		add_interest = "interestExercise",

		-- just added for an example
		incompatible = {
			-- Composed = true,
		},

		-- what happens when a colonist receives the trait, this is for the "Senior" trait
		apply_func = function (colonist, trait, init)
			colonist:ChooseEntity()
			if not g_SeniorsCanWork then
				colonist:SetWorkplace(false)
			end
		end,
		-- after a trait is removed
		unapply_func = function (colonist, trait)
			colonist:SetModifier("performance", "trait effect(Dreamer)", 0, 0)
		end,

	})
end
-- in-game traits https://github.com/HaemimontGames/SurvivingMars/blob/master/Data/TraitPreset.lua
-- trait definition https://github.com/HaemimontGames/SurvivingMars/blob/master/Lua/Traits.lua
```

Access trait with:
```lua
local Fitter = TraitPresets.UniqueName_Fitter
print(Fitter.display_name)
```