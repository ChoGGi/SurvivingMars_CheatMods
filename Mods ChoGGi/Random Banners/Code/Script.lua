-- not much point without it
if not g_AvailableDlc.gagarin then
	return
end

local flag_spons = {}
local c = 0
local EntityData = EntityData
for key in pairs(EntityData) do
	if key:find("Flag_03_") then
		c = c + 1
		flag_spons[c] = key:sub(9)
	end
end

local IsValidEntity = IsValidEntity
local table_rand = table.rand

function SponsorBannerBase:GetEntity()
	local entity = self.banner .. table_rand(flag_spons)

	if not IsValidEntity(entity) then
		entity = self.banner .. "IMM"
	end
	return entity

end
