-- See LICENSE for terms

local fuel_needed = 10 * ChoGGi.Consts.ResearchPointsScale

local function CanPositionRocket(obj)
	return (obj.command == "WaitLaunchOrder" or obj.command == "Refuel")
		and (obj.launch_fuel - obj.refuel_request:GetActualAmount()) >= fuel_needed
end

-- we need to get the fuel amount from here (after the drones have been kicked out)
local orig_SupplyRocket_Takeoff = SupplyRocket.Takeoff
function SupplyRocket:Takeoff(...)
	-- save fuel amount -10
	self.ChoGGi_RepositionRocket = (self.launch_fuel - self.refuel_request:GetActualAmount()) - fuel_needed
	return orig_SupplyRocket_Takeoff(self,...)
end

local Sleep = Sleep
local function RepositionRocket(obj)
	local igi = GetInGameInterface()
	igi:SetMode("construction", {
		template = obj.landing_site_class, --"RocketLandingSite",
		instant_build = true,
		params = {
			amount = 0,
			stockpiles_obstruct = true,
			override_palette = obj.rocket_palette,
			rocket = obj,
			ui_callback = function(site)
				CreateGameTimeThread(function()
					obj:SetCommand("Countdown")
					-- once the takeoff anim is done we can land it
					while obj.command ~= "Takeoff" do
						Sleep(1000)
					end
--~ 					print(obj.ChoGGi_RepositionRocket/1000)
					while obj.command == "Takeoff" do
						Sleep(2500)
					end
					-- and land it
					obj:SetCommand("LandOnMars", site, "from ui")
					obj:UpdateStatus("landing")
				end)
			end,
		}
	})
end

-- set fuel to whatever was stored (if it's one of ours)
function OnMsg.RocketLanded(obj)
	if obj.ChoGGi_RepositionRocket then
		local target = obj.ChoGGi_RepositionRocket
		obj.ChoGGi_RepositionRocket = nil

		obj.accumulated_fuel = target
		obj.refuel_request:SetAmount(target)
		-- make sure it always shows the correct amount
		obj.refuel_request:SetAmount(0)
		-- update selection panel
		local sel = SelectedObj
		if sel and sel.handle == obj.handle then
			RebuildInfopanel(obj)
		end
	end
end

function OnMsg.ClassesBuilt()
	-- add button to colonists
	ChoGGi.ComFuncs.AddXTemplate(XTemplates.customSupplyRocket[1],"ChangeRocketPosition",nil,{
		RolloverText = T(0,[[<left_click> Land this rocket somewhere else.]]),
		Title = [[Reposition Rocket]],
		Icon = "UI/Icons/IPButtons/automated_mode.tga",

		OnContextUpdate = function(self, context)
			-- hide button if not enough fuel
			if CanPositionRocket(context) then
				self:SetVisible(true)
				self:SetMaxHeight()
			else
				self:SetMaxHeight(0)
				self:SetVisible()
			end
		end,
		func = function(self, context)
			RepositionRocket(context)
			ObjModified(context)
		end,
	})
end