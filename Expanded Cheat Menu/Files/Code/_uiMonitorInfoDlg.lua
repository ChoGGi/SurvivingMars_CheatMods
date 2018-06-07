--See LICENSE for terms

local oldTableConcat = oldTableConcat

-- 1 above console log, 1000 above examine
local zorder = 2001001

DefineClass.ChoGGi_MonitorInfoDlg_Defaults = {
  __parents = {"FrameWindow"}
}

function ChoGGi_MonitorInfoDlg_Defaults:Init()
  local ChoGGi = ChoGGi

  self:SetPos(point(100, 100))
  self:SetSize(point(400, 600))
  self:SetMinSize(point(50, 50))
  self:SetTranslate(false)
  self:SetMovable(true)
  self:SetZOrder(zorder)

  local Sleep = Sleep
  local CreateRealTimeThread = CreateRealTimeThread
  local terminal = terminal
  local const = const
  local OpenExamine = OpenExamine

  self.refreshing = false
  --defaults
  self.object = false
  self.values = false
  self.tables = false
  self.delay = 1000


  ChoGGi.ComFuncs.DialogAddCaption(self,{pos = point(50, 101),size = point(390, 22)})
  ChoGGi.ComFuncs.DialogAddCloseX(self)

  self.idAutoRefresh = CheckButton:new(self)
  self.idAutoRefresh:SetPos(point(115, 128))
  self.idAutoRefresh:SetSize(point(100, 17))
  self.idAutoRefresh:SetImage("CommonAssets/UI/Controls/Button/CheckButton.tga")
  self.idAutoRefresh:SetText(ChoGGi.ComFuncs.Trans(302535920000084,"Auto-Refresh"))
  self.idAutoRefresh:SetHint(ChoGGi.ComFuncs.Trans(302535920000085,"Auto-refresh list every \"Amount\"."))
  self.idAutoRefresh:SetButtonSize(point(16, 16))
  --add check for auto-refresh
  local children = self.idAutoRefresh.children
  for i = 1, #children do
    if children[i].class == "Button" then
      local but = children[i]
      function but.OnButtonPressed()
        self.refreshing = self.idAutoRefresh:GetState()
        CreateRealTimeThread(function()
          while self.refreshing do
            self:UpdateText()
            Sleep(self.delay)
            --check for missing table objects
            if self.object.title:find("Grids") then
              self.tables = ChoGGi.ComFuncs.RemoveMissingTableObjects(self.tables,"elements")
              --break if there's none left
              if #self.tables == 0 then
                --fire once more to show the nothing here text
                self:UpdateText()
                break
              end
            end
          end
        end)
      end
    end
  end

  self.idRefresh = Button:new(self)
  self.idRefresh:SetPos(point(225, 128))
  self.idRefresh:SetSize(point(55, 17))
  self.idRefresh:SetText(ChoGGi.ComFuncs.Trans(1000220,"Refresh"))
  self.idRefresh:SetHint(ChoGGi.ComFuncs.Trans(302535920000086,"Manually refresh the list."))
  function self.idRefresh.OnButtonPressed()
    if ChoGGi.Temp.Testing then
      OpenExamine(self.object)
    end
    self:UpdateText()
  end

  self.idTimerAmount = SingleLineEdit:new(self)
  self.idTimerAmount:SetPos(point(290, 126))
  self.idTimerAmount:SetSize(point(200, 24))
  self.idTimerAmount:SetHSizing("Resize")
  self.idTimerAmount:SetVSizing("AnchorToTop")
  self.idTimerAmount:SetFontStyle("Editor14Bold")
  self.idTimerAmount:SetText("1000")
  self.idTimerAmount:SetHint(ChoGGi.ComFuncs.Trans(302535920000087,"Refresh delay in ms"))
  self.idTimerAmount:SetTextVAlign("center")
  self.idTimerAmount:SetMaxLen(-1)
  function self.idTimerAmount.OnValueChanged()
    local delay = ChoGGi.ComFuncs.RetProperType(self.idTimerAmount:GetText())
    if type(delay) == "number" and delay > 0 then
      self.delay = delay
    end
  end

  self.idText = StaticText:new(self)
  self.idText:SetPos(point(110, 152))
  self.idText:SetSize(point(385, 537))
  self.idText:SetHSizing("Resize")
  self.idText:SetVSizing("Resize")
  self.idText:SetFontStyle("Editor12Bold")
  self.idText:SetHint(ChoGGi.ComFuncs.Trans(302535920000088,"Double right-click to open list of objects."))
  self.idText:SetBackgroundColor(RGBA(0, 0, 0, 16))
  self.idText:SetScrollBar(true)
  self.idText:SetScrollAutohide(true)
  function self.idText.OnRButtonDoubleClick()
    ChoGGi.ComFuncs.OpenExamineAtExPosOrMouse(self.tables)
  end

  --so elements move when dialog re-sizes
  self:InitChildrenSizing()

  self:SetPos(point(100, 100))
  self:SetSize(point(400, 600))
end

DefineClass.ChoGGi_MonitorInfoDlg = {
  __parents = {
    "ChoGGi_MonitorInfoDlg_Defaults",
  },
  ZOrder = zorder
}

local texttable
local text
local monitort
local name
local kind
function ChoGGi_MonitorInfoDlg:UpdateText()
  --check for scroll pos
  local scrollpos = self.idText.scroll:GetPosition()
  --create prop list for list
  texttable = {[1]=""}
  if #self.tables > 0 then
    for i = 1, #self.tables do
      monitort = self.tables[i]
      texttable[#texttable+1] = "----- "
      texttable[#texttable+1] = i
      texttable[#texttable+1] = ". "
      texttable[#texttable+1] = monitort.class
      texttable[#texttable+1] = ":\n"
      if self.object.listtype == "all" then
        print("all")
        ex(self.tables[i])
        ex(self.values)
        for SecName,SecValue in pairs(self.tables[i]) do
        --goes through all tables

          --goes through each table
          texttable[#texttable+1] = SecName
          texttable[#texttable+1] = "\n"
          for Key,Value in pairs(SecValue) do

            if self.values[Key] then
              for j = 1, #self.values do
                local v = self.values[i]
                --name = monitort[SecName.name]
                texttable[#texttable+1] = "\t"
                texttable[#texttable+1] = v.name
                self:BuildValue(Value,0)
              end
            elseif Key == "field" then
              texttable[#texttable+1] = "\t"
              texttable[#texttable+1] = Value
              texttable[#texttable+1] = ": "
            end

          end

        end
      else
        for Key,Value in pairs(self.values) do
          name = monitort[Value.name]
          if name or type(name) == "boolean" then
            texttable[#texttable+1] = Value.name
            self:BuildValue(name,Value.kind)
          end
        end
      end --for
    end --if
  else
    texttable[#texttable+1] = ChoGGi.ComFuncs.Trans(302535920000089,"Nothing left")
  end --if #self.tables > 0

  texttable[#texttable+1] = "\n"
  --less .. is better
  text = oldTableConcat(texttable)

  if text == "" then
    self.idText:SetText(oldTableConcat({ChoGGi.ComFuncs.Trans(302535920000090,"Error opening"),tostring(self.object)}))
    return
  end
  --populate it
  self.idText:SetText(text)
  --and scroll to saved pos
  self.idText.scroll:SetPosition(scrollpos)
end

function ChoGGi_MonitorInfoDlg:BuildValue(name,kind)
  --0 = value
  if kind == 0 then
    texttable[#texttable+1] = ": "
    texttable[#texttable+1] = tostring(name)
    texttable[#texttable+1] = "\n"
  --1=table
  elseif kind == 1 then
    texttable[#texttable+1] = ": "
    texttable[#texttable+1] = #name
    texttable[#texttable+1] = "\n"
  --2=list table values
  elseif kind == 2 then
    texttable[#texttable+1] = ":\n"
    for t_name,t_value in pairs(name) do
      texttable[#texttable+1] = "\t"
      texttable[#texttable+1] = t_name
      texttable[#texttable+1] = ": "
      texttable[#texttable+1] = tostring(t_value)
      texttable[#texttable+1] = "\n"
    end
    texttable[#texttable+1] = "\n"
  end
  --just the three for now
end


--esc removes focus,shift+esc closes, enter executes code
function ChoGGi_MonitorInfoDlg:OnKbdKeyDown(_, virtual_key)
  if virtual_key == const.vkEsc then
    self.idCloseX:Press()
    return "break"
  end
  return "continue"
end
