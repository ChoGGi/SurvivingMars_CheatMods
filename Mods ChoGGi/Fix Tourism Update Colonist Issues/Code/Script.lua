-- See LICENSE for terms

if LuaRevision > 1001514 then
	return
end

-- figure I just use the code from the hotfix
function SavegameFixups.AddSatisfactionStat()
  MapForEach(true, "Colonist", function(col)
    col.stat_satisfaction = 0
    col.log_satisfaction = {}
  end)
end
function SavegameFixups.AddSatisfactionStat2()
  MapForEach(true, "Colonist", function(col)
    if not col.stat_satisfaction then
      col.stat_satisfaction = 0
    end
    if not col.log_satisfaction then
      col.log_satisfaction = {}
    end
  end)
end
