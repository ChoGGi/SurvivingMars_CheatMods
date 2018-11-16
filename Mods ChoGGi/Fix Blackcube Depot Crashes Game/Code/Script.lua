local orig = Building.SetPalette
function Building:SetPalette(...)
--~ 	if self.class == "ConstructionSite" and self.building_class ~= "BlackCubeDump" then
	-- just in case it fucks up with other ones
	if self.class == "ConstructionSite" then
		orig(self,...)
	end
end
