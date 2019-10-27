-- See LICENSE for terms

local AsyncRand = AsyncRand
local CreateRand = CreateRand

local orig_City_CreateMapRand = City.CreateMapRand
function City:CreateMapRand(which, ...)
	-- we don't want to mess with CreateResearchRand
	if which == "Exploration" then
		return CreateRand(true, AsyncRand(), ...)
	end
	return orig_City_CreateMapRand(self, which, ...)
end
