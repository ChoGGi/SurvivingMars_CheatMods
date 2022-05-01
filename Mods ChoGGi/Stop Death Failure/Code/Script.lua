-- See LICENSE for terms

-- Workaround for: [mod] Error loading PackedMods/*/Code/Script.lua: PackedMods/*/Code/Script.lua:1: syntax error near '<\218>'
do
	-- replace the func that gameovers with nadda (it's supposed to return false, but nil is good enough)
	IsGameOver = empty_func
end
