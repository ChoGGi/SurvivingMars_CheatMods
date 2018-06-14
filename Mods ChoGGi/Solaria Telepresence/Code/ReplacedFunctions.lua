local rawget,setmetatable,type = rawget,setmetatable,type

function OnMsg.ClassesBuilt()

  --so we can build without NoNearbyWorkers limit
  SolariaTelepresence.ComFuncs.SaveOrigFunc("ConstructionController","UpdateConstructionStatuses")
  function ConstructionController:UpdateConstructionStatuses(dont_finalize)
    local SolariaTelepresence = SolariaTelepresence
    --send "dont_finalize" so it comes back here without doing FinalizeStatusGathering
    SolariaTelepresence.OrigFuncs.ConstructionController_UpdateConstructionStatuses(self,"dont_finalize")

    local status = self.construction_statuses

    if self.is_template then
      local cobj = rawget(self.cursor_obj, true)
      local tobj = setmetatable({
        [true] = cobj,
        ["city"] = UICity
      }, {
        __index = self.template_obj
      })
      tobj:GatherConstructionStatuses(self.construction_statuses)
    end

    --remove errors we want to remove
    local statusNew = {}
    local ConstructionStatus = ConstructionStatus
    if type(status) == "table" and #status > 0 then
      for i = 1, #status do

        if status[i] ~= ConstructionStatus.NoNearbyWorkers then
          statusNew[#statusNew+1] = status[i]
        end

      end
    end
    --make sure we don't get errors down the line
    if type(statusNew) == "boolean" then
      statusNew = {}
    end

    self.construction_statuses = statusNew
    status = self.construction_statuses

    if not dont_finalize then
      self:FinalizeStatusGathering(status)
    else
      return status
    end
  end

end
