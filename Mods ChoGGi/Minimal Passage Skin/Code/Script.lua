-- See LICENSE for terms

local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits
local default_passage_palette = {"none", "none", "none", "none"}

-- add our "skin"
local orig_Passage_GetSkins = Passage.GetSkins
function Passage:GetSkins(...)
	local skins, palettes = orig_Passage_GetSkins(self,...)
	skins[#skins+1] = "ChoGGi_MinimalPassageSkin"
	palettes[#palettes+1] = default_passage_palette
	return skins, palettes
end

--	happens when our "skin" is choosen
local orig_Passage_ChangeSkin = Passage.ChangeSkin
function Passage:ChangeSkin(skin, ...)
	self.skin_id = skin
	if skin == "ChoGGi_MinimalPassageSkin" then
		SuspendPassEdits("ChoGGi.MinimalPassageSkin.ChangeSkin")
		for i = 1, #self.elements do
			local element = self.elements[i]
			if element ~= self.start_el and element ~= self.end_el then
				element:ChangeEntity("InvisibleObject")
			end
		end
		ResumePassEdits("ChoGGi.MinimalPassageSkin.ChangeSkin")
	else
		return orig_Passage_ChangeSkin(self, skin, ...)
	end
end
