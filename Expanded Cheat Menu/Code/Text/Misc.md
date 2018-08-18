### Random info about random stuff.

```
Surviving Mars comes with LuaFileSystem 1.2 (which is weird as lfs 1.6.3 is the one with lua 5.3 support).
though SM has a bunch of AsyncFile* functions that should probably be used instead.
lfs._VERSION

lpeg v0.10 : lpeg.version()
require("leg.grammar") --LPeg grammar manipulation
require("leg.parser") --LPeg Lua parser

socket = require("socket")
print(socket._VERSION)

To get your mod path (if user renames your mod folder):
Mods["MOD_ID"].path

List all objects (zoom close into the ground for 200-400 ticks faster, realm means all objects (default ignores items not on the maps)):
OpenExamine(GetObjects{area = "realm"})
Just domes:
OpenExamine(GetObjects{class = "Dome"})

Add cargo to the initial rocket:
https://steamcommunity.com/workshop/discussions/18446744073709551615/1694923613869322889/?appid=464920

Hash a value:
Encode16(SHA256(value))

Access varargs (...):
Use select(index,...) index being the argument you want to select, or run it through a for loop with
for i = 1, select("#",...) do
  local arg = select(i,...)
end

Countdown timer (use CreateGameTimeThread to have it pause when the game pauses):
local countdown = CreateRealTimeThread(function()
  Sleep(10000)
  --do something after
end)
if you_want_stop_it_from_outside then
  DeleteThread(countdown)
end

Loop backwards through a table (good for deleting as you go):
for i = #some_table, 1, -1 do
  print(some_table[i])
  table.remove(some_table,i)
end

Info from other people:

  Crysm: 7200 units per revolution. So units = (degrees * 20)
```
