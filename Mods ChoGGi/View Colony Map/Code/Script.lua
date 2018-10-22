-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
local fire_once
function OnMsg.ModsReloaded()
	if fire_once then
		return
	end
	fire_once = true
	local min_version = 26

	local ModsLoaded = ModsLoaded
	-- we need a version check to remind Nexus/GoG users
	local not_found_or_wrong_version
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	if idx then
		-- steam updates automatically
		if not Platform.steam and min_version > ModsLoaded[idx].version then
			not_found_or_wrong_version = true
		end
	else
		not_found_or_wrong_version = true
	end

	if not_found_or_wrong_version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[View Colony Map requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
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
			-- just to make it obvious to me for later SM updates (this only fires once so it shouldn't spam the log...)
			if not ChoGGi_ShowImageDlg then
				print("ChoGGi_ShowImageDlg is borked")
			end
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

	-- position dialog just off to the side of the colony site text on the right (or 25,25 if we can't)
	local x,y = 25,25
	local dlg
	-- parent being XDesktop
	local idx = table.find(self.parent,"XTemplate","PGMainMenu")
	if idx then
		-- wrapped in a pcall, so if we fail then it doesn't matter (other than an error in the log)
		pcall(function()
			dlg = self.parent[idx].idContent[1][2][1].idContent.box
			x = dlg:minx() - dlg:sizex() - 100
		end)
	end
	-- and do the same for y, using the diff chal text at the top
	idx = table.find(self.parent,"XTemplate","TitleLayer")
	if idx then
		pcall(function()
			dlg = self.parent[idx][1].box
			y = dlg:miny() + dlg:sizey() + 25
		end)
	end

	self:SetInitPos(nil,point(x,y))
end
