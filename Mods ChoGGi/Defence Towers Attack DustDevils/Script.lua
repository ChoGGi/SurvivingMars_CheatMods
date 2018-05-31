--I don't want to make it too different from ECM, so if I update it there I can pretty much just copy and paste

--keep everything stored in
DTADD = {
  --orig funcs that we replace
  OrigFuncs = {},
  --CommonFunctions.lua
  ComFuncs = {},
  --/Code/_Functions.lua
  CodeFuncs = {},
  --temporary settings that aren't saved to SettingsFile
  Temp = {RocketFiredDustDevil = {}},
}

--function(s) used
function DTADD.ComFuncs.SaveOrigFunc(ClassOrFunc,Func)
  if Func then
    local newname = ClassOrFunc .. "_" .. Func
    if not DTADD.OrigFuncs[newname] then
      DTADD.OrigFuncs[newname] = _G[ClassOrFunc][Func]
    end
  else
    if not DTADD.OrigFuncs[ClassOrFunc] then
      DTADD.OrigFuncs[ClassOrFunc] = _G[ClassOrFunc]
    end
  end
end

local cCodeFuncs = DTADD.CodeFuncs
local cComFuncs = DTADD.ComFuncs
local cOrigFuncs = DTADD.OrigFuncs


function OnMsg.ClassesBuilt()

  --save orig func
  cComFuncs.SaveOrigFunc("DefenceTower","DefenceTick")
  --replace orig func with mine
  function DefenceTower:DefenceTick()

    --place at end of function to have it protect dustdevils before meteors
    cOrigFuncs.DefenceTower_DefenceTick(self)

    --if DTADD.UserSettings.DefenceTowersAttackDustDevils then
      --copied from orig func
      if IsValidThread(self.track_thread) then
        return
      end
      --list of devil handles we attacked
      local devils = DTADD.Temp.RocketFiredDustDevil
      --list of dustdevils on map
      local hostile = g_DustDevils or empty_table
      for i = 1, #hostile do
        local obj = hostile[i]

        --get dist (added * 10 as it didn't see to target at the range of it's hex grid)
        --it could be from me increasing protection radius, or just how it targets meteors
        if IsValid(obj) and self:GetVisualDist2D(obj) <= self.shoot_range * 10 then
          --check if tower is working
          if not IsValid(self) or not self.working or self.destroyed then
            return
          end

          --follow = skip small ones attached to majors
          if (not obj.follow and not devils[obj.handle]) then
            --aim the tower at the dustdevil
            self:OrientPlatform(obj:GetVisualPos(), 7200)
            --fire in the hole
            local rocket = self:FireRocket(nil, obj)
            --store handle so we only launch one per devil
            devils[obj.handle] = obj.handle
            --seems like safe bets to set
            self.meteor = obj
            self.is_firing = true
            --sleep till rocket explodes
            CreateRealTimeThread(function()
              while rocket.move_thread do
                Sleep(500)
              end
              --make it pretty
              PlayFX("AirExplosion", "start", obj, obj:GetAttaches()[1], obj:GetPos())
              --kill the devil object
              obj:delete()
              self.meteor = false
              self.is_firing = false
            end)
            --back to the usual stuff
            Sleep(self.reload_time)
            return true
          end
        end
      end
      --remove only remove devil handles if they're actually gone
      if #devils > 0 then
        CreateRealTimeThread(function()
          for i = 1, #devils do
            if not IsValid(HandleToObject[devils[i]]) then
              devils[i] = nil
            end
          end
        end)
      end
    --end --if active

    --end of function
  end

end

--[[
--spawn a bunch of dustdevils to test
for _ = 1, 15 do
  local data = DataInstances.MapSettings_DustDevils
  local descr = data[mapdata.MapSettings_DustDevils] or data.DustDevils_VeryLow
  GenerateDustDevil(GetTerrainCursor(), descr, nil, "major"):Start()
end
for _ = 1, 15 do
  local data = DataInstances.MapSettings_DustDevils
  local descr = data[mapdata.MapSettings_DustDevils] or data.DustDevils_VeryLow
  GenerateDustDevil(GetTerrainCursor(), descr, nil):Start()
end
--]]