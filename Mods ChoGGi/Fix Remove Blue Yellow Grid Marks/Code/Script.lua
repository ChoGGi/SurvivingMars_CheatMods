
function OnMsg.LoadGame()
	-- suspending speeds up deleting
	SuspendPassEdits("RemoveBlueYellowGridMarks")

	-- blue/yellow markers
	MapDelete(true, "GridTile","RangeHexRadius",function(o)
		-- SkiRich's Toggle Hub Zone
		if not o.ToggleWorkZone then
			return true
		end
	end)

	-- remove the rover outlines added from https://forum.paradoxplaza.com/forum/index.php?threads/surviving-mars-persistent-transport-route-blueprint-on-map.1121333/
	MapDelete(true, "WireFramedPrettification",function(o)
		if o.entity == "RoverTransport" then
			return true
		end
	end)

	ResumePassEdits("RemoveBlueYellowGridMarks")
end
