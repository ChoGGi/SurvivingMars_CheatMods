-- See LICENSE for terms

-- tell people know how to get the library
function OnMsg.ModsReloaded()
	local library_version = 14

	local ModsLoaded = ModsLoaded
	local not_found_or_wrong_version
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	if idx then
		if library_version < ModsLoaded[idx].version then
			not_found_or_wrong_version = true
		end
	else
		not_found_or_wrong_version = true
	end

	if not_found_or_wrong_version then
		CreateRealTimeThread(function()
			local Sleep = Sleep
			while not UICity do
				Sleep(1000)
			end
			if WaitMarsQuestion(nil,nil,string.format([[Error: This mod requires ChoGGi's Library v%s.
Press Ok to download it or check Mod Manager to make sure it's enabled.]],library_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

local image_str = string.format("%sMaps/%s.png",CurrentModPath,"%s")
local showimage
local skip_showing_image

-- override this func to create/update image when site changes
local orig_FillRandomMapProps = FillRandomMapProps
function FillRandomMapProps(gen, params)
	local map = orig_FillRandomMapProps(gen, params)

	-- if this doesn't work...
	if not skip_showing_image then
		-- check if we already created image viewer, and make one if not
		if not showimage then
			showimage = ChoGGi_ShowImageDlg:new({}, terminal.desktop,{})
		end
		-- pretty little image
		showimage.idImage:SetImage(image_str:format(map))
		showimage.idCaption:SetText(map)
	end

	return map
end

-- kill off image dialogs
function OnMsg.ChangeMapDone()
	local term = terminal.desktop
	for i = #term, 1, -1 do
		if term[i]:IsKindOf("ChoGGi_ShowImageDlg") then
			term[i]:delete()
		end
	end
end

local function ResetFunc()
	-- reset func once we know it's a new game (someone reported image showing up after landing)
	if orig_FillRandomMapProps then
		FillRandomMapProps = orig_FillRandomMapProps
		orig_FillRandomMapProps = nil
	end
	-- alright fucker...
	skip_showing_image = true
end

function OnMsg.CityStart()
	ResetFunc()
end
function OnMsg.LoadGame()
	ResetFunc()
end


-- a dialog that shows an image

DefineClass.ChoGGi_ShowImageDlg = {
	__parents = {"ChoGGi_Window"},
	dialog_width = 500.0,
	dialog_height = 500.0,
}

function ChoGGi_ShowImageDlg:Init(parent, context)
	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	self.idImage = XFrame:new({
		Id = "idImage",
	}, self.idDialog)

	local x,y = 25,25
	-- see if we can get the right-side list and position based on that, otherwise 25
	local idx = table.find(self.parent,"XTemplate","PGMainMenu")
	local dlg
	pcall(function()
		dlg = self.parent[idx].idContent[1][2][1]
	end)
	if dlg then
		dlg = dlg.idContent.box
		x = dlg:minx() - dlg:sizex() - 100
	end
	-- and do the same for y, using the diff chal text at the top
	idx = table.find(self.parent,"XTemplate","DifficultyBonus")
	pcall(function()
		dlg = self.parent[idx][1]
	end)
	if dlg then
		dlg = dlg.box
		y = dlg:miny() + dlg:sizey() + 25
	end

	self:SetInitPos(nil,point(x,y))
end
