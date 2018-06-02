function OnMsg.ClassesBuilt()

  local orig_ConstructionSite_Complete = ConstructionSite.Complete
  function ConstructionSite:Complete(...)
    --grab priority before site is removed
    local priority = self.priority
    --the func returns the building, so no need to bother with OnMsg.ConstructionComplete
    local bld = {orig_ConstructionSite_Complete(self,...)}
    --and apply it to the new bld
    bld[1]:SetPriority(priority)
    --i wrapped it in a table, just incase devs add something
    return table.unpack(bld)
  end

end
