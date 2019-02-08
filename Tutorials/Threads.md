### All? the tables with threads in them
```lua
ThreadsRegister
ThreadsMessageToThreads
ThreadsThreadToMessage
```

##### Returns a list of OnMsgs that are waiting for Msgs.
```lua
GetHandledMsg(true)
```
##### If you use ECM with the HelperMod then you can examine OnMsg, and follow the metatable to get the list of each func waiting on that OnMsg.

##### For a round about way to get some info about a thread (with blacklist intact)
```lua
GedInspectedObjects[object] = {}
GedInspectorFormatObject(object)
```

### If you know the file a thread is started from, but don't know which thread (or it's local):
You need the blacklist disabled to be able to use debug.*
This probably only works for Create*TimeThread threads.
```lua
local lua_filename = "Example_file.lua"
local threads = {}
local level = 1 --[[could try 2 or more, but 1 is usually fine and dandy.--]]
local ThreadsRegister = ThreadsRegister
for key in pairs(ThreadsRegister) do
	local info = debug.getinfo(key, level)
	if info and info.source:find(lua_filename,1,true) then
		threads[#threads+1] = info
	end
end
OpenExamine(threads)
```