-- See LICENSE for terms

-- for those of you interested in adding new banners (you'll also have to do something with SponsorBannerBase:GetEntity()/:GetSkins())

-- not much point without it
if not g_AvailableDlc.gagarin then
	print(CurrentModDef.title, ": Space Race DLC not installed!")
	return
end

local entity = "Hex1_Placeholder"

-- GetEntity seems to be called a little too early (for my setup only probably)
local lookup_table = {
	Flag_01_ = {entity},
	Flag_02_ = {entity},
	Flag_03_ = {entity},
}

-- If any mods add flags
function OnMsg.ModsReloaded()
	-- build lists of flag entities (nation names)
	local flag_c = 0
	local flag_spons_1 = lookup_table.Flag_01_
	local EntityData = EntityData
	for key in pairs(EntityData) do
		if key:find("Flag_01_") then
			flag_c = flag_c + 1
			flag_spons_1[flag_c] = key:sub(9)
		end
	end
	-- make changeskin button consistent
	table.sort(flag_spons_1)

	for i = 1, flag_c do
		local flag = flag_spons_1[i]
		lookup_table.Flag_02_[i] = "Flag_02_" .. flag
		lookup_table.Flag_03_[i] = "Flag_03_" .. flag
		flag_spons_1[i] = "Flag_01_" .. flag
	end
end

-- Load a random flag when banner is placed
function SponsorBannerBase:GetEntity()
	if self.entity == entity then
		-- default entity = return a random flag
		return table.rand(lookup_table[self.banner])
	else
		return self.entity
	end
end

-- make the change skin button work properly
function SponsorBannerBase:GetSkins()
	return lookup_table[self.banner]
end
