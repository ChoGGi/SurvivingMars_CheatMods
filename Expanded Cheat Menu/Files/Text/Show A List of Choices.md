### Shows a list of choices then does something based on the selected item

```
CreateRealTimeThread(function()
  local choice = WaitListChoice({
    {text="Choice 1"},
    {text="Choice 2"},
    {text="Choice 3"},
  }, "Title of dialog")
  if choice == 1 then
    print("choice " .. choice)
  elseif choice == 2 then
    print("choice " .. choice)
  elseif choice == 3 then
    print("choice " .. choice)
  end
end)
```

##### See [ListChoiceCustom](https://github.com/ChoGGi/SurvivingMars_CheatMods/blob/master/Expanded%20Cheat%20Menu/Files/Code/ListChoiceCustom.lua) for how to implement a custom dialog
