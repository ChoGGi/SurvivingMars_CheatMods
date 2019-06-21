-- See LICENSE for terms

local function DeleteAnom(self)
	local function CallBackFunc(answer)
		if answer then
			local marker = self.dialog[self.snapped_id]
			if marker then
				-- cleanup
				marker:delete()
				self.selected_spot:delete()
				-- watch out for fors
				self.marker_id_to_spot_id[self.snapped_id] = nil
				for id, marker_id in pairs(self.spot_id_to_marker_id) do
					if marker_id == self.snapped_id then
						if type(marker_id) == "number" then
							table.remove(self.spot_id_to_marker_id, marker_id)
						else
							self.spot_id_to_marker_id[marker_id] = nil
						end
						break
					end
				end
				-- fake it till you make it
				self.dialog[self.snapped_id] = {SetVisible = empty_func}
			end
		end
	end

	ChoGGi.ComFuncs.QuestionBox(
		T{0, "Are you sure you want to delete <name>?", name = self.selected_spot.display_name},
		CallBackFunc,
		T(5451, "DELETE") .. "!!!!"
	)
end

local function AddButton(self)
	local toolbar = self.dialog.idToolBar
	if not toolbar then
		return
	end

	CreateRealTimeThread(function()
		ChoGGi.ComFuncs.RetToolbarButton{
			parent = toolbar,
			id = "idChoGGi_DeleteAnomaly",
			text = T(5451, "DELETE"),

			roll_title = T(0, "Delete Anomaly"),
			roll_text = T(0, "Deletes Anomaly!!!"),
			onpress = function()
				DeleteAnom(self)
			end,
		}
	end)

end

local orig_SetUIAnomalyParams = LandingSiteObject.SetUIAnomalyParams
function LandingSiteObject:SetUIAnomalyParams(...)
	orig_SetUIAnomalyParams(self, ...)
	AddButton(self)
end

local orig_SetUIProjectParams = LandingSiteObject.SetUIProjectParams
function LandingSiteObject:SetUIProjectParams(...)
	orig_SetUIProjectParams(self, ...)
	AddButton(self)
end
