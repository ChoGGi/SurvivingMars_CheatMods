### Adding new traits:

```
function OnMsg.ClassesPostprocess()
  PlaceObj("TraitPreset", {
    add_interest = "interestExercise",
    description ="copy n paste of Fit with display name/id changed",
    display_name = "Fitter",
    id = "Fitter",
    group = "Positive",
    incompatible = {},
    modify_amount = 5,
    modify_property = "DailyHealthRecover",
    modify_target = "self",
    param = 10,
  })
end
```