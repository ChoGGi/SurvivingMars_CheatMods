-- See LICENSE for terms

-- the bugged save I got was on an empty map, so...
function OnMsg.CityStart()
	LandscapeLastMark = 0
end

function OnMsg.LoadGame()
	-- if there's placed landscapes grab the largest number
	local Landscapes = Landscapes
	if Landscapes and next(Landscapes) then
		local largest = 0
		for idx in pairs(Landscapes) do
			if idx > largest then
				largest = idx
			end
		end
		-- if over 3K then reset to 0
		if largest > 3000 then
			LandscapeLastMark = 0
		else
			LandscapeLastMark = largest + 1
		end
	else
		-- no landscapes so 0 it is
		LandscapeLastMark = 0
	end
end
