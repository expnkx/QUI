local QUI = LibStub("AceAddon-3.0"):GetAddon("QUI")
local UnitFrame = QUI:NewModule("UnitFrame","AceEvent-3.0")

do
	local UIHider = QUI.UIHider
	PlayerFrame:SetParent(UIHider)
	PlayerFrame:Hide()
	PlayerFrame:UnregisterAllEvents()
	TargetFrame:SetParent(UIHider)
	TargetFrame:Hide()
	TargetFrame:UnregisterAllEvents()
	HidePartyFrame()
end

local function cofunc(unit,left,...)
	local realframe = CreateFrame("Frame",nil,UIParent)
	local frame = CreateFrame("Frame",nil,realframe)
	frame:Hide()
	local secureunitbutton = CreateFrame("Button", nil, realframe, "SecureUnitButtonTemplate")
	secureunitbutton:SetAttribute("unit", unit)
	secureunitbutton:SetAttribute("type1","target")
	secureunitbutton:SetAttribute("type2","togglemenu")
	secureunitbutton:RegisterForClicks("AnyDown")
	secureunitbutton.unit = unit
	frame:SetAllPoints(realframe)
	secureunitbutton:SetAllPoints(realframe)
	local current = coroutine.running()
	local function resume(tag,event,u,...)
		if UnitIsUnit(u,unit) then
			coroutine.resume(current,tag,event,u,...)
		end
	end
	realframe:SetSize(90,200)
	if left then
		realframe:SetPoint("BOTTOMLEFT",UIParent,"BOTTOM",-420,140)
	else
		realframe:SetPoint("BOTTOMLEFT",UIParent,"BOTTOM",420,140)
	end
--	frame:SetPoint(400,400)
	local statusbar = CreateFrame("StatusBar",nil,frame)
	statusbar:SetFrameStrata("BACKGROUND")
	statusbar:SetWidth(80)
	statusbar:SetPoint("BOTTOMLEFT",frame,"BOTTOMLEFT",0,0)
	statusbar:SetPoint("TOPLEFT",frame,"TOPLEFT",0,0)
	statusbar:SetOrientation("VERTICAL")
	statusbar:SetStatusBarTexture([[Interface\BUTTONS\WHITE8X8]])
	statusbar:SetStatusBarColor(0,1,0)
	local playermodel = CreateFrame("PlayerModel",nil,statusbar)
	playermodel:SetAllPoints(statusbar)
	playermodel:SetFacing(0.5)
	playermodel:SetCamDistanceScale(0.6)
	playermodel:SetPosition(0,0,-.19)
	playermodel:SetFrameStrata("LOW")
	local resourcebar = CreateFrame("StatusBar",nil,frame)
	resourcebar:SetFrameLevel(frame:GetFrameLevel())
	resourcebar:SetPoint("BOTTOMRIGHT",frame,"BOTTOMRIGHT",0,0)
	resourcebar:SetPoint("TOPRIGHT",frame,"TOPRIGHT",0,0)
	resourcebar:SetPoint("BOTTOMLEFT",statusbar,"BOTTOMRIGHT",0,0)
	resourcebar:SetPoint("TOPLEFT",statusbar,"TOPRIGHT",0,0)
	resourcebar:SetOrientation("VERTICAL")
	resourcebar:SetStatusBarTexture([[Interface\BUTTONS\WHITE8X8]])
	local castbar = CreateFrame("StatusBar",nil,frame)
	castbar:SetFrameLevel(frame:GetFrameLevel())
	castbar:SetPoint("TOPLEFT",frame,"BOTTOMLEFT",0,0)
	castbar:SetPoint("TOPRIGHT",frame,"BOTTOMRIGHT",0,0)
	castbar:SetHeight(15)
	castbar:SetStatusBarTexture([[Interface\BUTTONS\WHITE8X8]])
	castbar:SetStatusBarColor(0,1,1,1)
--	castbar:SetMinMaxValues(0,100)
--	castbar:SetValue(100)	
	secureunitbutton:SetScript("OnEnter",UnitFrame_OnEnter)
	secureunitbutton:SetScript("OnLeave",UnitFrame_OnLeave)
	
	local healthtext = statusbar:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
	healthtext:SetPoint("BOTTOM",statusbar,"TOP",0,0)
	healthtext:SetFont([[FONTS\FRIZQT__.ttf]],12)
	
	local resourcetext = resourcebar:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
	resourcetext:SetPoint("CENTER",resourcebar,"CENTER",0,0)
	resourcetext:SetFont([[FONTS\FRIZQT__.ttf]],12)

	local font = frame:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
	font:SetPoint("BOTTOM",statusbar,"BOTTOM",0,-27)
	font:SetFont([[FONTS\FRIZQT__.ttf]],12)
	local castbar_text = castbar:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
	castbar_text:SetPoint("CENTER",castbar,"CENTER",0,0)
	castbar_text:SetFont([[FONTS\FRIZQT__.ttf]],12)
	do
		local tbls = {{"UNIT_HEALTH_FREQUENT","UNIT_HEALTH","UNIT_MAXHEALTH","UNIT_HEAL_PREDICTION","UNIT_COMBAT"},
		{"UNIT_POWER_UPDATE","UNIT_MAXPOWER","UNIT_POWER_FREQUENT"},
		{"UNIT_MODEL_CHANGED"},
		{"UNIT_SPELLCAST_INTERRUPTED","UNIT_SPELLCAST_DELAYED","UNIT_SPELLCAST_CHANNEL_START","UNIT_SPELLCAST_CHANNEL_UPDATE",
		"UNIT_SPELLCAST_CHANNEL_STOP","UNIT_SPELLCAST_INTERRUPTIBLE","UNIT_SPELLCAST_NOT_INTERRUPTIBLE","UNIT_SPELLCAST_START","UNIT_SPELLCAST_STOP","UNIT_SPELLCAST_FAILED"}}
		for j = 1, #tbls do
			local tbl = tbls[j]
			for i = 1, #tbl do
				UnitFrame.RegisterEvent(frame,tbl[i],resume,j)
			end
		end
		local function nounit(...)
			coroutine.resume(current,...)
		end
		if left then
			UnitFrame.RegisterEvent(frame,"PLAYER_REGEN_DISABLED",nounit,1)
			UnitFrame.RegisterEvent(frame,"PLAYER_REGEN_ENABLED",nounit,1)
		else
			UnitFrame.RegisterEvent(frame,"PLAYER_TARGET_CHANGED",nounit,3)
		end
		UnitFrame.RegisterEvent(frame,"LOADING_SCREEN_DISABLED",nounit,3)
	end
	local function resume4()
		coroutine.resume(current,4)
	end
	local ticker
	local class_colors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
	local tag,event,arg1,arg2,arg3,arg4,arg5 = 0,nil,unit
	local lastguid
	local resource_pool = CreateFramePool("StatusBar",frame)
	local UnitPowerMax = UnitPowerMax
	local UnitPower = UnitPower
	while true do
		repeat
		local guid = UnitGUID(unit)
		if guid then
			frame:Show()
		else
			frame:Hide()
			lastguid = nil
			break
		end
		if tag == 3 or guid~=lastguid then
			playermodel:SetUnit(unit)
			playermodel:SetAnimation(0)
		end
		lastguid = guid
		if tag < 2 or tag == 3 then
			local name,server = UnitName(unit)
			if server then
				font:SetText(name.."-"..server)
			else
				font:SetText(name)
			end
			if UnitAffectingCombat(unit) then
				font:SetTextColor(1,0,0,1)
			else
				font:SetTextColor(1,1,1,1)
			end
			local healthmax = UnitHealthMax(unit)
			local health = UnitHealth(unit)
			if healthmax==health then
				playermodel:Show()
				statusbar:SetStatusBarColor(0,0,0,0)
				healthtext:SetText(healthmax)
			else
				playermodel:Hide()
				healthtext:SetFormattedText("%d\n%d\n|cff8080cc%.0f|r",health,healthmax,100*health/healthmax)
				local _,class = UnitClass(unit)
				if class then
					local color = class_colors[class]
					statusbar:SetStatusBarColor(color.r,color.g,color.b,1)
				else
					statusbar:SetStatusBarColor(0,0,0,1)
				end
			end
			statusbar:SetMinMaxValues(0,healthmax)
			statusbar:SetValue(health)
		end
		if tag ~= 1 and tag ~= 4 then
			local powerType = UnitPowerType(unit)
			local powercolor = PowerBarColor[powerType]
			resourcebar:SetStatusBarColor(powercolor.r,powercolor.g,powercolor.b,powercolor.a)
			local pmx = UnitPowerMax(unit)
			local pw = UnitPower(unit)
			resourcebar:SetMinMaxValues(0,pmx)
			resourcebar:SetValue(pw)
			if pmx == pw then
				resourcetext:Hide()
			else
				resourcetext:SetFormattedText("%.1f",100*pw/pmx)
				resourcetext:Show()
			end
			resource_pool:ReleaseAll()
			local last = resourcebar
			for i=max(powerType+1,4),18 do
				local resource_max = UnitPowerMax(unit,i)
				if resource_max~=0 then
					local newsb = resource_pool:Acquire()
					newsb:SetPoint("TOPLEFT",last,"TOPRIGHT",0,0)
					newsb:SetPoint("BOTTOMLEFT",last,"BOTTOMRIGHT",0,0)
					newsb:SetStatusBarTexture([[Interface\BUTTONS\WHITE8X8]])
					local powercolor = PowerBarColor[i]
					if powercolor then
						newsb:SetStatusBarColor(powercolor.r,powercolor.g,powercolor.b,powercolor.a)
					else
						newsb:SetStatusBarColor(1,0,1,1)
					end
					newsb:SetFrameLevel(frame:GetFrameLevel())
					newsb:SetOrientation("VERTICAL")
					newsb:SetMinMaxValues(0,resource_max)
					newsb:SetValue(UnitPower(unit,i))
					newsb:SetWidth(10)
					newsb:Show()
					last = newsb
				end
			end
		end
		if tag ~= 1 and tag ~= 2 then
			local spell, displayName, icon, startTime, endTime, isTradeSkill, castID, interrupt = UnitCastingInfo(unit)
			if spell == nil then
				spell, displayName, icon, startTime, endTime, isTradeSkill, castID, interrupt = UnitChannelInfo(unit)
			end
			if startTime then
				castbar:SetMinMaxValues(startTime,endTime)
				local gtime = GetTime()*1000
				castbar:SetValue(gtime)
				castbar_text:SetFormattedText("|c0000ff00%s|r %.1f",spell,(endTime-gtime)/1000)
				castbar:Show()
				if ticker == nil then
					ticker = C_Timer.NewTicker(0.01,resume4)
				end
			else
				castbar:Hide()
				if ticker then
					ticker:Cancel()
					ticker=nil
				end
			end
		end
		until true
		tag,event,arg1,arg2,arg3,arg4,arg5 = coroutine.yield()
	end
end

function UnitFrame:OnInitialize()
	coroutine.wrap(cofunc)("player",true)
	coroutine.wrap(cofunc)("target",false)
end
