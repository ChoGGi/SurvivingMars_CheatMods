-- See LICENSE for terms

local ChoOrig_PinsDlg_GetPinConditionImage = PinsDlg.GetPinConditionImage
function PinsDlg:GetPinConditionImage(obj, ...)
	local img = ChoOrig_PinsDlg_GetPinConditionImage(self, obj, ...)

	if not img and obj:IsKindOf("BaseRover") then
		if obj.command == "TransferResources" and obj.fx == "Unload" then
			img = "UI/Icons/pin_unload.tga"
		elseif obj.command == "TransferResources" and obj.fx == "Load" then
			img = "UI/Icons/pin_load.tga"
		end
	end

	return img
end
