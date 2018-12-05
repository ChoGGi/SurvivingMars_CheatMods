-- See LICENSE for terms

local MulDivRound = MulDivRound
local IsValid = IsValid
local Sleep = Sleep

local orig_OverviewModeDialog_ScaleSmallObjects = OverviewModeDialog.ScaleSmallObjects

function OverviewModeDialog:ScaleSmallObjects(time, direction, ...)
	orig_OverviewModeDialog_ScaleSmallObjects(self, time, direction, ...)

	local SignsOverviewCameraScaleUp = const.SignsOverviewCameraScaleUp
	local SignsOverviewCameraScaleDown = const.SignsOverviewCameraScaleDown
	local g_SignsVisible = g_SignsVisible
	local g_ResourceIconsVisible = g_ResourceIconsVisible

	local signs = MapGet(true, "BaseRover")
	CreateRealTimeThread(function()
		g_CurrentDepositScale = direction == "up" and SignsOverviewCameraScaleUp or SignsOverviewCameraScaleDown

		local i = 0
		local step = 33
		repeat
			Sleep(step)
			local sings_scale
			if time == 0 then
				sings_scale = direction == "up" and SignsOverviewCameraScaleUp or SignsOverviewCameraScaleDown
			else
				sings_scale = SignsOverviewCameraScaleDown + MulDivRound(direction == "up" and i or time-i, SignsOverviewCameraScaleUp - SignsOverviewCameraScaleDown, time)
			end

			for i = 1, #signs do
				local sign = signs[i]
				if IsValid(sign) then
					sign:SetVisible(direction == "up" and g_SignsVisible or g_SignsVisible and g_ResourceIconsVisible)
					sign:SetScale(sings_scale)
				end
			end
			i = i + step
		until i > time or not CameraTransitionThread

		local disableZ = direction == "up"
		for i = 1, #signs do
			local obj = signs[i]
			if IsValid(obj) then
				obj:SetNoDepthTest(disableZ)
			end
		end
	end)
end

