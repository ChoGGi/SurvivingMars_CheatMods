-- See LICENSE for terms

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end


local function CheckMorph()
	if not mod_EnableMod then
		return
	end

	local IsValid = IsValid
	local WaitMsg = WaitMsg
	local CreateGameTimeThread = CreateGameTimeThread

	local morphs = UICity.labels.ProjectMorpheus or ""
	for i = 1, #morphs do
		local obj = morphs[i]
		-- If it's turned off then pretty sure it won't fall off
		if obj.ui_working and IsValid(obj) then
			obj:ForEachAttach("ParSystem", function(a)
				-- If there's not spot name then it's fallen down
				if a:GetParticlesName() == "ProjectMorpheus_Projector" and a:GetAttachSpotName() == "" then
					CreateGameTimeThread(function()
						local working = obj.ui_working
						obj:SetUIWorking(not working)
						-- wait for it...
						while obj:GetStateText() ~= "end" do
							WaitMsg("OnRender")
						end
						obj:SetUIWorking(working)
					end)
				end
			end)
		end
	end
end

OnMsg.NewDay = CheckMorph
OnMsg.LoadGame = CheckMorph
