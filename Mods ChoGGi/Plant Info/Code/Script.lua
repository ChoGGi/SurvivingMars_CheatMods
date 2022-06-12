-- See LICENSE for terms

local entity_lookup = {
	GrassArm_01 = "Grass",
	GrassArm_02 = "Grass",
	BushArm_01 = "Bush",
	BushArm_02 = "Bush",
	BushArm_03 = "Bush",
	TreeArm_01 = "Tree",
	TreeArm_02 = "Tree",
	TreeArm_03 = "Tree",
	TreeArm_04 = "Tree",

	CropHerbsArm = "Herbs",
	CropPotatoesArm = "Potato",
	CropRapeSeedsArm = "Rapeseed",
	CropWheatArm = "Wheat",
	CropSpinachArm = "Spinach",
}

ChoGGi.ComFuncs.AddParentToClass(VegetationObject, "VegetationSelectionObject")

function VegetationSelectionObject:GetDisplayName()
	return veg_preset_lookup[entity_lookup[self.entity]].display_name or T(588, "Empty")
end

function VegetationSelectionObject:Getdescription()
	return veg_preset_lookup[entity_lookup[self.entity]].description or T(588, "Empty")
end
VegetationSelectionObject.GetIPDescription = VegetationSelectionObject.GetDescription

function VegetationSelectionObject:GetChoGGi_SoilQuality()
  return GetSoilQuality(WorldToHex(self:GetPos()))
end

function VegetationSelectionObject:GetChoGGi_NearestSeeder()
	local label = "ForestationPlant"
	if self.entity:sub(1,4) == "Crop" then
		label = "OpenFarm"
	end

	local objs = UIColony.city_labels.labels[label] or ""
	if #objs > 0 then
		local obj_pos = self:GetPos()

		-- get nearest
		local length = max_int
		local nearest = objs[1]
		local new_length, spot
		for i = 1, #objs do
			spot = objs[i]
			new_length = spot:GetPos():Dist2D(obj_pos)
			if new_length < length then
				length = new_length
				nearest = spot
			end
		end
		return nearest:GetDisplayName()
	else
		return T(588, "Empty")
	end
end

local ChoOrig_text
local my_text = T(302535920011719, [[Soil quality is <yellow><ChoGGi_SoilQuality></yellow>.
The nearest seeder is <yellow><ChoGGi_NearestSeeder></yellow>.
<SeedStatusStr>]])
function VegetationSelectionObject:GetChoGGi_ReplaceText()
	if entity_lookup[self.entity] then
		return my_text
	else
		return ChoOrig_text
	end
end

function OnMsg.ClassesPostprocess()
	local xtemplate = XTemplates.ipVegetation[1]

	-- make sure we only add it once
	if xtemplate.ChoGGi_Template_AddVegetationInfo then
		return
	end
	xtemplate.ChoGGi_Template_AddVegetationInfo = true

	local idx = table.find(xtemplate, "__template", "InfopanelSection")
	if not idx then
		return
	end

	xtemplate[idx].Icon = "UI/Icons/Sections/terraforming.tga"

--~ 	ex(xtemplate[idx][1].Text)
	ChoOrig_text = xtemplate[idx][1].Text

	xtemplate[idx][1].Text = T("<ChoGGi_ReplaceText>")

end
