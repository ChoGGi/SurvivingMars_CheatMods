local table = table

function OnMsg.ClassesBuilt()

  local orig_ConstructionSite_Complete = ConstructionSite.Complete
  function ConstructionSite:Complete(...)
    --grab priority before site is removed
    local priority = self.priority
    --the func returns the building, so no need to bother with OnMsg.ConstructionComplete
    local ret = {orig_ConstructionSite_Complete(self,...)}
    --and apply it to the new bld
    ret[1]:SetPriority(priority)
    --i wrapped it in a table, just incase devs add something
    return table.unpack(ret)
  end

  --domes...
  local orig_ConstructionSiteWithHeightSurfaces_Complete = ConstructionSiteWithHeightSurfaces.Complete
  function ConstructionSiteWithHeightSurfaces:Complete(...)
    --grab priority before site is removed
    local priority = self.priority
    --the func returns the building, so no need to bother with OnMsg.ConstructionComplete
    local ret = {orig_ConstructionSiteWithHeightSurfaces_Complete(self,...)}
    --and apply it to the new bld
    ret[1]:SetPriority(priority)
    --i wrapped it in a table, just incase devs add something
    return table.unpack(ret)
  end

end
