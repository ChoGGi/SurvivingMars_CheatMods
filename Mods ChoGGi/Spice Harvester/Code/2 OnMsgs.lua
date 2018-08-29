local SaveOrigFunc = SpiceHarvester.ComFuncs.SaveOrigFunc

function OnMsg.ClassesGenerate()
  -- if it idles it'll go home, so we return my command till we remove thread
  SaveOrigFunc("CargoShuttle","Idle")
  function CargoShuttle:Idle()
    if self.SpiceHarvester_FollowHarvesterShuttle then
      self:SetCommand("SpiceHarvester_FollowHarvester")
      Sleep(500)
    else
      return SpiceHarvester.OrigFuncs.CargoShuttle_Idle(self)
    end
  end
end

function OnMsg.ClassesBuilt()
  -- gives an error when we spawn shuttle since i'm using a fake task, so we just return true instead
  SaveOrigFunc("CargoShuttle","OnTaskAssigned")
  function CargoShuttle:OnTaskAssigned()
    if self.SpiceHarvester_FollowHarvesterShuttle then
      return true
    else
      return SpiceHarvester.OrigFuncs.CargoShuttle_OnTaskAssigned(self)
    end
  end
end

do -- DoShit
	local function DoShit()
		local UICity = UICity

		-- for new games
		if not UICity then
			return
		end

		-- place to store per-game values
		if not UICity.SpiceHarvester then
			UICity.SpiceHarvester = {}
		end

		-- controllable shuttle handles launched
		if not UICity.SpiceHarvester.CargoShuttleThreads then
			UICity.SpiceHarvester.CargoShuttleThreads = {}
		end
	end

	function OnMsg.LoadGame()
		DoShit()
	end
	function OnMsg.CityStart()
		DoShit()
	end
end -- do

function OnMsg.NewDay() --newsol
  local UICity = UICity

  -- clean up old handles
	local IsValid = IsValid
	local HandleToObject = HandleToObject
  if next(UICity.SpiceHarvester.CargoShuttleThreads) then
    for h,_ in pairs(UICity.SpiceHarvester.CargoShuttleThreads) do
      if not IsValid(HandleToObject[h]) then
        UICity.SpiceHarvester.CargoShuttleThreads[h] = nil
      end
    end
  end

end
