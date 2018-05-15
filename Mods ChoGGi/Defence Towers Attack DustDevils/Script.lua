--keep everything stored in
ChoGGiX = {
  --orig funcs that we replace
  OrigFuncs = {},
  --CommonFunctions.lua
  ComFuncs = {},
  --/Code/_Functions.lua
  CodeFuncs = {},
  --temporary settings that aren't saved to SettingsFile
  Temp = {RocketFiredDustDevil = {}},
}

--functions used
function ChoGGiX.ComFuncs.SaveOrigFunc(Name,Class)
  if Class then
    local newname = Class .. "_" .. Name
    if not ChoGGiX.OrigFuncs[newname] then
      ChoGGiX.OrigFuncs[newname] = _G[Class][Name]
    end
  else
    if not ChoGGiX.OrigFuncs[Name] then
      ChoGGiX.OrigFuncs[Name] = _G[Name]
    end
  end
end

local cCodeFuncs = ChoGGiX.CodeFuncs
local cComFuncs = ChoGGiX.ComFuncs
local cOrigFuncs = ChoGGiX.OrigFuncs


--replace orig func with mine
function OnMsg.ClassesBuilt()

  cComFuncs.SaveOrigFunc("DefenceTick","DefenceTower")
  function DefenceTower:DefenceTick()

    --place at end of function to have it protect dustdevils before meteors
    cOrigFuncs.DefenceTower_DefenceTick(self)

    --if ChoGGiX.UserSettings.DefenceTowersAttackDustDevils then
      --copied from orig func
      if IsValidThread(self.track_thread) then
        return
      end
      --list of devil handles we attacked
      local devils = ChoGGiX.Temp.RocketFiredDustDevil
      local hostile = g_DustDevils or empty_table
      for i = 1, #hostile do
        local obj = hostile[i]

        --get dist (added * 10 as it didn't see to target at the range of it's hex grid)
        if obj and self:GetVisualDist2D(obj) <= self.shoot_range * 10 then
          --should probably stop this from aiming at devils it can't shoot at, but it's cute so fuck it
          self:OrientPlatform(obj:GetVisualPos(), 7200)
          --check if tower is working
          if not IsValid(self) or not self.working or self.destroyed then
            return
          end

          --follow = skip small ones attached to majors
          if (not obj.follow and not devils[obj.handle]) then
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
