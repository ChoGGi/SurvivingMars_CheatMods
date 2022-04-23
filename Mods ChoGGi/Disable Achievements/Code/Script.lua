-- See LICENSE for terms

-- If I don't have this here (or something else), then I got this error from "packed" mods
-- Script.lua:1: syntax error near '<\218>'
local packed_is_bugged = true

-- replace the func that unlocks them with nadda
AchievementUnlock = empty_func
