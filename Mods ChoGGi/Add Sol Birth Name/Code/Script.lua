-- See LICENSE for terms

-- Workaround for: [mod] Error loading PackedMods/*/Code/Script.lua: PackedMods/*/Code/Script.lua:1: syntax error near '<\218>'
do
	function OnMsg.ColonistBorn(colonist)
		colonist.name = colonist:GetDisplayName() .. " " .. UIColony.day
	end
end
