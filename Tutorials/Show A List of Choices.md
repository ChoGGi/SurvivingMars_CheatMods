### Shows a list of choices then does something based on the selected item

```lua
CreateRealTimeThread(function()

	local choice = WaitListChoice(
		{
			{text = "Choice 1"},
			{text = "Choice 2"},
			{
				text = "Choice 3",
				func = function(value)
					print(value)
				end,
			},
		},
		"Title of dialog"
	)

	if choice == 1 then
		print(choice.text)
	elseif choice == 2 then
		print(choice.text)
	elseif choice == 3 then
		choice.func("function choice")
	end

end)
```

##### See [ListChoiceCustom](https://github.com/ChoGGi/SurvivingMars_CheatMods/blob/master/ChoGGi's%20Library/Code/ListChoice.lua) for how to implement a custom list dialog
