-- See LICENSE for terms

local mod_EnableMod
local SetMouse

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	SetMouse(mod_EnableMod)
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
local function EnableMouse()
	SetMouse(false)
end
OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
OnMsg.SystemActivate = StartupCode
OnMsg.MouseInside = StartupCode
-- always enable so when going back in the mouse won't be visible
OnMsg.SystemMinimize = EnableMouse
OnMsg.SystemInactivate = EnableMouse
OnMsg.MouseOutside = EnableMouse

local orig_XDesktop_OnShortcut = XDesktop.OnShortcut
function XDesktop:OnShortcut(shortcut, source, ...)
  if source == "mouse" and mod_EnableMod then
		return
	end
	return orig_XDesktop_OnShortcut(self, shortcut, source, ...)
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
