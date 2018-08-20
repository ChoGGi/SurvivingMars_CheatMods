### Adding new traits:

```
function OnMsg.ClassesPostprocess()
  PlaceObj("TraitPreset", {
    id = "Fitter",
    display_name = "Fitter",
    description ="copy n paste of Fit with display name/id changed",
    group = "Positive",

    modify_amount = 5,
    modify_property = "DailyHealthRecover",
    modify_target = "self",
    param = 10,
    add_interest = "interestExercise",
    incompatible = {},
  })
end
-- in-game traits https://github.com/HaemimontGames/SurvivingMars/blob/master/Data/TraitPreset.lua
```

Access traits with:
```
local Fitter = TraitPresets.Fitter
print(Fitter.display_name)
```