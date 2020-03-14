local QUI = LibStub("AceAddon-3.0"):GetAddon("QUI")

local function cofunc()
	local running = coroutine.running()
	local function event_resume(...)
		QUI.resume(running,...)
	end
	local eventer = {}
	QUI.RegisterEvent(eventer,"NAME_PLATE_UNIT_REMOVED",event_resume,0)
	QUI.RegisterEvent(eventer,"NAME_PLATE_UNIT_ADDED",event_resume,1)
	local statusbar_pool = CreateFramePool("StatusBar")
	local units = {}
	local function unit_event_resume(tag,event,unit)
		local ue = units[unit]
		if ue then
			QUI.resume(running,tag,event,unit,ue)
		end
	end
	QUI.RegisterEvent(eventer,"UNIT_HEALTH_FREQUENT",unit_event_resume,2)
--	C_NamePlate.SetNamePlateFriendlySize(80,5)
--	C_NamePlate.SetNamePlateEnemySize(80,5)
	local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit
	local coyield = coroutine.yield
	local UnitHealthMax = UnitHealthMax
	local UnitHealth = UnitHealth
	local UnitGetTotalAbsorbs = UnitGetTotalAbsorbs
	local UnitReaction = UnitReaction
--	local UnitGetTotalHealAbsorbs = UnitGetTotalHealAbsorbs
	while true do	--performance critical must save memory usage + be cache friendly as much as possible
		local tag,event,arg1,arg2,arg3,arg4 = coyield()
		if tag == 0 then
			local bar = units[arg1]
			statusbar_pool:Release(bar)
			units[arg1] = nil
		else
			local bar
			if tag == 1 then
				bar = statusbar_pool:Acquire()
				units[arg1] = bar
				bar:SetStatusBarColor(0,0,0)
				local nameplate = GetNamePlateForUnit(arg1,true)
				bar:ClearAllPoints()
				bar:SetParent(nameplate)
				bar:SetPoint("CENTER")
				bar:SetSize(80,5)
				bar:SetStatusBarTexture([[Interface\BUTTONS\WHITE8X8]])
				local uract = UnitReaction("player", arg1)
				if uract < 5 then
					if uract == 4 then
						bar:SetStatusBarColor(1,1,0,0.8)
					else
						bar:SetStatusBarColor(1,0,0,1-uract/4)
					end
				else
					bar:SetStatusBarColor(0,1,0,8)
				end
				bar:Show()
			else
				bar = arg2
			end
			bar:SetMinMaxValues(0,UnitHealthMax(arg1) + UnitGetTotalHealAbsorbs(arg1))
			bar:SetValue(UnitHealth(arg1))
		end
	end
end

coroutine.wrap(cofunc)()
