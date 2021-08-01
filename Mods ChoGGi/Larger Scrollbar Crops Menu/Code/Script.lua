-- See LICENSE for terms

local orig_ItemMenuBase_InitButtonsUI = ItemMenuBase.InitButtonsUI
function ItemMenuBase:InitButtonsUI(...)
	local ret = orig_ItemMenuBase_InitButtonsUI(self, ...)
	local contain = self.idContainer
	if contain.parent and contain.parent.class == "InfopanelItems" then
		for i = 1, #contain do
			local el = contain[i]
			if el.Id == "idButtonsListScroll" then
				el:SetMinHeight(el.MinHeight * 2)
				el:SetMaxHeight(el.MaxHeight * 2)
				break
			end
		end
	end
	return ret
end

-- add a bunch of crops for testing
--~ function OnMsg.ClassesPostprocess()
--~ 	for i = 1, 100 do
--~ 		PlaceObj('CropPreset', {
--~ 			CropEntity = "CropWheat",
--~ 			Desc = T(7001, --[[CropPreset Wheat Desc]] "Low yield but grows fast and requires less Water"),
--~ 			DisplayName = T(0000, --[[CropPreset Wheat DisplayName]] "WheatXXXX"),
--~ 			FarmClass = "FarmConventional",
--~ 			group = "Farm",
--~ 			icon = "UI/Icons/Buildings/crops_wheat.tga",
--~ 			id = "Wheat" .. i,
--~ 		})
--~ 	end
--~ end
