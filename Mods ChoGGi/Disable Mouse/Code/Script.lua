-- See LICENSE for terms

local mod_EnableMod
local mod_DisableHUD
local SetMouse

local ChoOrig_pin_margins

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_DisableHUD = CurrentModOptions:GetProperty("DisableHUD")

	SetMouse(mod_EnableMod)

	local d = Dialogs
	if not ChoOrig_pin_margins then
		ChoOrig_pin_margins = d.PinsDlg:GetMargins()
	end

	if mod_DisableHUD then
		d.HUD.idMiddle:SetVisible(false)
		d.HUD.idRight:SetVisible(false)
--~ 		d.PinsDlg:SetMargins(box(100, 0, 100, 20))
		local a, b = ChoOrig_pin_margins:minxyz()
		local x = ChoOrig_pin_margins:maxxyz()
		d.PinsDlg:SetMargins(box(a, b, x, 20))
	else
		d.HUD.idMiddle:SetVisible(true)
		d.HUD.idRight:SetVisible(true)
		d.PinsDlg:SetMargins(ChoOrig_pin_margins)
	end
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

SetMouse = function(toggle)
	if toggle then
		g_MouseConnected = false
		hr.EnablePreciseSelection = 0
		engineHideMouseCursor()
		terminal.desktop:ResetMousePosTarget()
	else
    g_MouseConnected = true
    hr.EnablePreciseSelection = 1
    if next(ForceHideMouseReasons) == nil and next(ShowMouseReasons) then
      engineShowMouseCursor()
    end
	end
end

local function StartupCode()
	SetMouse(mod_EnableMod)
end
local function StartupCodeHUD()
	local d = Dialogs
	if not ChoOrig_pin_margins then
		ChoOrig_pin_margins = d.PinsDlg:GetMargins()
	end

	if mod_DisableHUD then
		d.HUD.idMiddle:SetVisible(false)
		d.HUD.idRight:SetVisible(false)
		local a, b = ChoOrig_pin_margins:minxyz()
		local x = ChoOrig_pin_margins:maxxyz()
		d.PinsDlg:SetMargins(box(a, b, x, 20))
--~ 		d.PinsDlg:SetMargins(box(100, 0, 100, 20))
	end
end
function OnMsg.CityStart()
	StartupCode()
	StartupCodeHUD()
end
function OnMsg.LoadGame()
	StartupCode()
	StartupCodeHUD()
end
--~ OnMsg.CityStart = StartupCode
--~ OnMsg.LoadGame = StartupCode
OnMsg.SystemActivate = StartupCode
OnMsg.MouseInside = StartupCode

-- always enable so when going back in the mouse won't be visible
local function EnableMouse()
	SetMouse(false)
end
OnMsg.SystemMinimize = EnableMouse
OnMsg.SystemInactivate = EnableMouse
OnMsg.MouseOutside = EnableMouse

-- workaround for https://forum.paradoxplaza.com/forum/threads/disable-mouse.1461783
local function ToggleMouse()
	SetMouse(mod_EnableMod)
end
OnMsg.NewHour = ToggleMouse

local ChoOrig_XDesktop_OnShortcut = XDesktop.OnShortcut
function XDesktop:OnShortcut(shortcut, source, ...)
  if source == "mouse" and mod_EnableMod then
		return
	end
	return ChoOrig_XDesktop_OnShortcut(self, shortcut, source, ...)
end

local functions = {
	"UpdateCursor",
	"UpdateMouseTarget",
	"MouseEvent",
	"SetMouseCapture",
}
for i = 1, #functions do
	local func_name = functions[i]
	local func_orig = XDesktop[func_name]

	XDesktop[func_name] = function(...)
		if mod_EnableMod then
			return
		end
		return func_orig(...)
	end

end
