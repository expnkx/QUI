tinsert(UISpecialFrames, "CalendarFrame")

local function cogameinfo()
	local gameinfo = CreateFrame("Button",nil,UIParent)
	gameinfo:SetPoint("TOP",UIParent,"TOP")
	gameinfo:SetSize(100,12)
	gameinfo:RegisterForClicks("AnyUp")
	local font = gameinfo:CreateFontString(nil,nil,"GameFontNormalSmall")
	font:SetPoint("CENTER",gameinfo,"CENTER")
	font:SetFont([[FONTS\FRIZQT__.ttf]],12)
	local current = coroutine.running()
	local ticker = C_Timer.NewTicker(1,function(...)
		coroutine.resume(current,...)
	end)
	local obj,event,arg1,arg2,arg3,arg4 = ticker
	local function onenter(obj,...)
		coroutine.resume(current,obj,"OnEnter",...)
	end
	gameinfo:SetScript("OnEnter",onenter)
	local function onleave(obj,...)
		coroutine.resume(current,obj,"OnLeave",...)
	end
	local lastreset = GetTime()
	gameinfo:SetScript("OnClick",function(self,button)
		if button == "RightButton" then
			if IsShiftKeyDown() and TimeManagerFrame then
				if TimeManagerFrame:IsShown() then
					TimeManagerFrame:Hide()
				else
					TimeManagerFrame:Show()
				end
			else
				if CalendarFrame == nil then
					LoadAddOn("Blizzard_Calendar")
					if CalendarFrame == nil then
						return
					end
				end
				if CalendarFrame:IsShown() then
					CalendarFrame:Hide()
				else
					CalendarFrame:Show()
				end
			end
		elseif IsShiftKeyDown() and GetCVarBool("scriptProfile") then
			lastreset = GetTime()
			ResetCPUUsage()
		else
			collectgarbage("collect")
		end
	end)
	local max_lvl = GetMaxPlayerLevel()
	local function xpstr()
		local level = UnitLevel("player")
		if level==max_lvl then
			local azeriteitem = C_AzeriteItem.FindActiveAzeriteItem()
			if azeriteitem then
				local c,m = C_AzeriteItem.GetAzeriteItemXPInfo(azeriteitem)
				return ("%d/%d/%d(%.1f%%) "):format(C_AzeriteItem.GetPowerLevel(azeriteitem),c,m,100*c/m)
			else
				return ""
			end
		else
			local c,m =UnitXP("player"),UnitXPMax("player")
			return ("%d/%d/%d(%.1f%%) "):format(level,c,m,100*c/m)
		end
		return ""
	end
	while true do
		local netdown, netup, netlagHome, netlagWorld = GetNetStats()
		local fmt_str="%s|c0000ff00%s|r H:%d W:%d %g"
		if netlagHome>=300 or netlagWorld>=300 then
			fmt_str="%s|c0000ff00%s|r |c00ff0000H:%d W:%d|r %g"
		end
		font:SetFormattedText(fmt_str,xpstr(),date("%Y/%m/%d %H:%M:%S",time()),netlagHome,netlagWorld,GetFramerate())
		if event == "OnEnter" then
			GameTooltip:SetOwner(gameinfo)
			gameinfo:SetScript("OnEnter",nop)
			gameinfo:SetScript("OnLeave",onleave)
			while true do
				local netdown, netup, netlagHome, netlagWorld = GetNetStats()
				local fmt_str="%s|c0000ff00%s|r H:%d W:%d %g"
				if netlagHome>=300 or netlagWorld>=300 then
					fmt_str="%s|c0000ff00%s|r |c00ff0000H:%d W:%d|r %g"
				end
				font:SetFormattedText(fmt_str,xpstr(),date("%Y/%m/%d %H:%M:%S",time()),netlagHome,netlagWorld,GetFramerate())
				UpdateAddOnMemoryUsage()
				UpdateAddOnCPUUsage()
				GameTooltip:ClearLines()
				local netdown, netup, netlagHome, netlagWorld = GetNetStats()
				local string_format = string.format
				GameTooltip:AddLine(string_format("%g/%g/%g",GetAverageItemLevel()),0.5, 0.5, 0.8,true)
				GameTooltip:AddDoubleLine(string_format("%g↓",netdown),string_format("%g↑",netup),0.5,0.5,0.8,  0.5, 0.5, 0.8,true)
				local homeip,worldip = GetNetIpTypes()
				GameTooltip:AddDoubleLine(HOME..(homeip==1 and ":IPv4" or ":IPv6"),netlagHome,0.5,0.5,0.8,0.5,0.5,0.8,true)
				GameTooltip:AddDoubleLine(WORLD..(worldip==1 and ":IPv4" or ":IPv6"),netlagWorld,0.5,0.5,0.8, 0.5, 0.5, 0.8,true)	
				GameTooltip:AddDoubleLine(IsResting() and "zzzzzz" or " ",GetXPExhaustion(),0.5,0.5,0.8,0.5,0.5,0.8,true)
				local IsAddOnLoaded = IsAddOnLoaded
				local GetAddOnInfo = GetAddOnInfo
				local GetAddOnMemoryUsage  = GetAddOnMemoryUsage
				local GetAddOnDependencies = GetAddOnDependencies
				local sum = 0
				local inshift = IsShiftKeyDown()
				if GetCVarBool("scriptProfile") then
					local cpusum = 0
					local qui_cpu_usage = 0
					local qui_memory_usage = 0
					local period = (GetTime()-lastreset)
					for i = 1, GetNumAddOns() do
						if IsAddOnLoaded(i) then
							local info,title = GetAddOnInfo(i)
							local usage = GetAddOnMemoryUsage(i)
							local cpuusage = GetAddOnCPUUsage(i)
							if title == "QUI" or GetAddOnDependencies(i) == "QUI" then
								qui_memory_usage = qui_memory_usage + usage
								qui_cpu_usage = qui_cpu_usage + cpuusage
								if inshift then
									GameTooltip:AddDoubleLine(title,string_format("%.3f |c0000ff00%.3f %.3f|r",usage,cpuusage,cpuusage/period),nil,nil,nil,  0.5, 0.5, 0.8,true)
								end
							elseif not inshift then
								GameTooltip:AddDoubleLine(title,string_format("%.3f |c0000ff00%.3f %.3f|r",usage,cpuusage,cpuusage/period),nil,nil,nil,  0.5, 0.5, 0.8,true)
							end
							sum = sum + usage
							cpusum = cpusum + cpuusage
						end
					end
					if not inshift then
							GameTooltip:AddDoubleLine("QUI * |c0000ff00(Shift)|r",string_format("%.3f |c0000ff00%.3f %.3f|r",qui_memory_usage,qui_cpu_usage,qui_cpu_usage/period),nil,nil,nil,  0.5, 0.5, 0.8,true)
					end
					GameTooltip:AddDoubleLine(cpusum,string_format("%.3f",cpusum/(GetTime()-lastreset)),0,1,0,  0, 1, 0,true)
				else
					local qui_memory_usage = 0
					for i = 1, GetNumAddOns() do
						if IsAddOnLoaded(i) then
							local info,title = GetAddOnInfo(i)
							local usage = GetAddOnMemoryUsage(i)
							if title == "QUI" or GetAddOnDependencies(i) == "QUI" then
								qui_memory_usage = qui_memory_usage + usage
								if inshift then
									GameTooltip:AddDoubleLine(title,string_format("%.3f",usage),nil,nil,nil,  0.5, 0.5, 0.8,true)
								end
							elseif not inshift then
								GameTooltip:AddDoubleLine(title,string_format("%.3f",usage),nil,nil,nil,  0.5, 0.5, 0.8,true)
							end
							sum = sum + usage
						end
					end
					if not inshift then
						GameTooltip:AddDoubleLine("QUI * |c0000ff00(Shift)|r",string_format("%.3f",qui_memory_usage),nil,nil,nil,  0.5, 0.5, 0.8,true)
					end
				end
				local gccount = collectgarbage("count")
				GameTooltip:AddDoubleLine(string_format("%.3f",sum).."/"..string_format("%.3f",gccount-sum),string_format("%.3f",gccount),0.5,0.5,0.8,  0.5, 0.5, 0.8,true)
				GameTooltip:Show()
				obj,event,arg1,arg2,arg3,arg4 = coroutine.yield()
				if event == "OnLeave" then
					gameinfo:SetScript("OnLeave",nop)
					gameinfo:SetScript("OnEnter",onenter)
					GameTooltip:Hide()
					break
				end
			end
		end
		obj,event,arg1,arg2,arg3,arg4 = coroutine.yield()
	end
end

coroutine.wrap(cogameinfo)()
