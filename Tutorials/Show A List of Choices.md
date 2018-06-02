### Shows a list of choices then does something based on the selected item

```
CreateRealTimeThread(function()
  local choice = WaitListChoice({
    {text="Tons of countries Asia"},
    {text="Tons of countries Africa"},
    {text="Tons of countries Europe"},
    {text="Tons of countries North America"},
    {text="Tons of countries South America"},
    {text="Tons of countries Oceania"},
  }, "I have abandoned this mod")
  if choice == 1 then
    OpenUrl("http://steamcommunity.com", true)
  elseif choice == 2 then
    OpenUrl("http://steamcommunity.com", true)
  elseif choice == 3 then
    OpenUrl("http://steamcommunity.com", true)
  elseif choice == 4 then
    OpenUrl("http://steamcommunity.com", true)
  elseif choice == 5 then
    OpenUrl("http://steamcommunity.com", true)
  elseif choice == 6 then
    OpenUrl("http://steamcommunity.com", true)
  end
end)
```