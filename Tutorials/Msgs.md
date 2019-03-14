### Msgs

Each OnMsg you declare is added to a list, and fired in that order when the Msg happens.

##### Do something when a Msg() is fired
```lua
local function somefunc()
	print("game is loaded")
end

-- you can either do it this way
function OnMsg.LoadGame()
	somefunc()
end
-- or this
OnMsg.LoadGame = somefunc

-- they'll both work the same, but the second one only has to do one function call instead of two.
```

##### Fire your own custom Msg
```lua
Msg("CustomMsgBlahBlah")
```

##### Waiting for a msg
```lua
CreateRealTimeThread(function() -- or GameTime
	while true do
		WaitMsg("OnRender")
		print("scene render update")
	end
end)
```

##### A realtime loop that pauses.
```lua
local is_paused = false
function OnMsg.MarsPause()
	is_paused = true
end

CreateRealTimeThread(function()
	while true do
		if is_paused then
			WaitMsg("MarsResume")
			is_paused = false
		end
		print("not paused")
	end
end)
```

##### Show a list of OnMsgs/WaitMsgs that are waiting for Msgs.
###### You need ECM for OpenExamine.
```lua
OpenExamine(GetHandledMsg(true))
```

##### Show a list of functions in the order they will be called when an OnMsg is fired.
###### ECM needs the HelperMod installed to do this.
```lua
local _,v = debug.getupvalue(getmetatable(OnMsg).__newindex,1)
OpenExamine(v)
```
