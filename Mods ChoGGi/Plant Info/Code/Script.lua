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

local AddParentToClass = rawget(_G, "ChoGGi") and ChoGGi.ComFuncs.AddParentToClass
	or function(class_obj, parent_name)
		local p = class_obj.__parents
		if not table.find(p, parent_name) then
			p[#p+1] = parent_name
		end
	end
AddParentToClass(VegetationObject, "VegetationSelectionObject")

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

	local objs = UICity.labels[label] or empty_table
	if #objs > 0 then
		local pt = self:GetPos()
		table.sort(objs, function(a, b)
			return a:GetDist2D(pt) < b:GetDist2D(pt)
		end)

		return objs[1]:GetDisplayName()
	else
		return T(588, "Empty")
	end
end

local orig_text
local my_text = T(302535920011719, [[Soil quality is <yellow><ChoGGi_SoilQuality></yellow>.
The nearest seeder is <yellow><ChoGGi_NearestSeeder></yellow>.
<SeedStatusStr>]])
function VegetationSelectionObject:GetChoGGi_ReplaceText()
	if entity_lookup[self.entity] then
		return my_text
	else
		return orig_text
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
	orig_text = xtemplate[idx][1].Text

	xtemplate[idx][1].Text = T("<ChoGGi_ReplaceText>")

end
