-- See LICENSE for terms

do -- Map Images Pack (it doesn't need to be loaded just installed)
	local min_version = 1
	local mod = Mods.ChoGGi_MapImagesPack
	local p = Platform

	if not mod or mod and not (p.steam or p.pops) and min_version > mod.version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error","View Colony Map requires Map Images Pack (at least v" .. min_version .. [[).
Press OK to download it or check the Mod Manager to make sure it's enabled.]]) == "ok" then
				if p.steam then
					OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1571465108")
				elseif p.pops then
					OpenUrl("https://mods.paradoxplaza.com/mods/507/Any")
				else
					OpenUrl("https://www.nexusmods.com/survivingmars/mods/77?tab=files")
				end
			end
		end)
	end
end -- do

--~ local image_str = Mods.ChoGGi_MapImagesPack.env.CurrentModPath .. "Maps/%s.png"
local image_str = Mods.ChoGGi_MapImagesPack.env.CurrentModPath .. "Maps/"

-- tell people how to get my library mod (if needs be)
function OnMsg.ModsReloaded()
	-- version to version check with
	local min_version = 63
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")
	local p = Platform

	-- if we can't find mod or mod is less then min_version (we skip steam/pops since it updates automatically)
	if not idx or idx and not (p.steam or p.pops) and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error","View Colony Map requires ChoGGi's Library (at least v" .. min_version .. [[).
Press OK to download it or check the Mod Manager to make sure it's enabled.]]) == "ok" then
				if p.steam then
					OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
				elseif p.pops then
					OpenUrl("https://mods.paradoxplaza.com/mods/505/Any")
				else
					OpenUrl("https://www.nexusmods.com/survivingmars/mods/89?tab=files")
				end
			end
		end)
	end
end

local showimage
local skip_showing_image

-- override this func to create/update image when site changes
local orig_FillRandomMapProps = FillRandomMapProps
function FillRandomMapProps(gen, params, ...)
	local map = orig_FillRandomMapProps(gen, params, ...)

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
--~ 		showimage.idImage:SetImage(image_str:format(map))
		showimage.idImage:SetImage(image_str .. map .. ".png")
		showimage.idCaption:SetText(map)
	end

	return map
end

-- kill off image dialogs
function OnMsg.ChangeMapDone()
	local term = terminal.desktop
	for i = #term, 1, -1 do
		if term[i]:IsKindOf("ChoGGi_ShowImageDlg") then
			term[i]:Close()
		end
	end
end

local function ResetFunc()
	-- reset func once we know it's a new game (someone reported image showing up after landing)
	if orig_FillRandomMapProps then
		FillRandomMapProps = orig_FillRandomMapProps
		orig_FillRandomMapProps = nil
	end
	-- alright bugger...
	skip_showing_image = true
end

OnMsg.CityStart = ResetFunc
OnMsg.LoadGame = ResetFunc

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

	-- default dialog position if we can't find the ui stuff (new version or whatnot)
	local x = 150
	local PGMainMenu = Dialogs.PGMainMenu

	if PGMainMenu then
		-- wrapped in a pcall, so if we fail then it'll just use my default
		pcall(function()
			local dlg = PGMainMenu.idContent.PGMission[1][1].idContent.box
			x = dlg:sizex()
		end)
	end

	self:PostInit(nil,point(x,75))
end
