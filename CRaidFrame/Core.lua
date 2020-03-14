local CRaidFrame = LibStub("AceAddon-3.0"):GetAddon("CRaidFrame")

local function aura_onenter(self)
	if self[2] then
		GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
		GameTooltip:SetUnitAura(self[2],self[3],self[4])
	end
end

local function aura_onleave(self)
	GameTooltip:Hide()
end

local function create_cooldown(frame)
	local cd = CreateFrame("Cooldown",nil,frame,"CooldownFrameTemplate")
	cd:SetHideCountdownNumbers(true)
	local texture = frame:CreateTexture(nil,"OVERLAY")
	texture:SetTexCoord(0.1,0.9,0.1,0.9)
	cd[1] = texture
	return cd
end

local function create_multiple_cooldown(frame,buffs,tooltip)
	local tb = {}
	for i = 1,buffs do
		local ele = create_cooldown(frame)
		if tooltip then
			ele:SetScript("OnEnter",aura_onenter)
			ele:SetScript("OnLeave",aura_onleave)
		end
		tb[i] = ele
	end
	return tb
end

local function set_point_multiple_cooldown(tb,frame,b,e,size)
	tb[1]:ClearAllPoints()
	tb[1]:SetPoint(b,frame,b)
	size = size / #tb
	tb[1]:SetSize(size,size)
	tb[1][1]:SetAllPoints(tb[1])
	for i = 2, #tb-1 do
		tb[i]:ClearAllPoints()
		tb[i]:SetPoint(b,tb[i-1],e)
		tb[i]:SetSize(size,size)
		tb[i][1]:SetAllPoints(tb[i])
	end
	tb[#tb]:ClearAllPoints()
	tb[#tb]:SetPoint(e,frame,e)
	tb[#tb]:SetSize(size,size)
	tb[#tb][1]:SetAllPoints(tb[#tb])
end

local backdrop

local function config_unitbutton(frame,secure)
	local profile = CRaidFrame.db.profile
	local LSM = LibStub("LibSharedMedia-3.0")	
	local font = LSM:HashTable("font")[profile.font]
	local vertical = profile.vertical
	local sttx = LSM:HashTable("statusbar")[profile.statusbar]
	local ftsz = profile.font_size
	local virtualframe,statusbar,resourcebar,absorb_bar,border_frame = frame[1],frame[2],frame[3],frame[4],frame[9]
	local rb = profile.resourcebar~=false
	local rsbsz = profile.resourcebar_length
	local width,height = profile.width,profile.height
	border_frame:SetBackdrop(backdrop)
	if not secure and frame:CanChangeAttribute() then
		local bindings = profile.bindings
		for i=1,#bindings do
			local ele = bindings[i]
			local ele1,ele2,ele3,ele4,ele5 = ele[1],ele[2],ele[3],ele[4],ele[5]
			frame:SetAttribute(ele1,ele2)
			if ele3 and ele4 then
				frame:SetAttribute(ele3,ele4)
			end
			if ele5 then
				frame:SetAttribute(ele5,nil)
			end
		end
		frame:SetSize(width,height)
	end
	local frame_width,frame_height = frame:GetSize()
	local border_size = backdrop.edgeSize
	virtualframe:SetSize(frame_width-border_size,frame_height-border_size)
	statusbar:ClearAllPoints()
	statusbar:SetStatusBarTexture(sttx)
	resourcebar:ClearAllPoints()
	resourcebar:SetStatusBarTexture(sttx)
	absorb_bar:SetStatusBarTexture(sttx)
	absorb_bar:SetAllPoints(statusbar)
--	frame[3]:SetTexture(bgtx)
	frame[5]:SetFont(font,ftsz)
	local dispel = frame[8]
	dispel:ClearAllPoints()
	if vertical then
		statusbar:SetOrientation("VERTICAL")
		statusbar:SetRotatesTexture(true)
		absorb_bar:SetOrientation("VERTICAL")
		absorb_bar:SetRotatesTexture(true)
		statusbar:SetPoint("TOPLEFT")
		statusbar:SetPoint("BOTTOMLEFT")
		if rb then
			resourcebar:SetOrientation("VERTICAL")
			resourcebar:SetRotatesTexture(true)
			resourcebar:SetPoint("BOTTOMRIGHT")
			resourcebar:SetPoint("TOPRIGHT")
			statusbar:SetPoint("TOPRIGHT",resourcebar,"TOPLEFT")
			statusbar:SetPoint("BOTTOMRIGHT",resourcebar,"BOTTOMLEFT")
			resourcebar:SetWidth(rsbsz)
			resourcebar:Show()
		else
			resourcebar:Hide()
			statusbar:SetPoint("BOTTOMLEFT")
			statusbar:SetPoint("BOTTOMRIGHT")
		end
		set_point_multiple_cooldown(frame[6],statusbar,"TOPLEFT","BOTTOMLEFT",height)
		set_point_multiple_cooldown(frame[7],statusbar,"TOPRIGHT","BOTTOMRIGHT",height)
		dispel:SetPoint("BOTTOM",statusbar,"BOTTOM")
	else
		statusbar:SetOrientation("HORIZONTAL")
		statusbar:SetRotatesTexture(false)
		absorb_bar:SetOrientation("HORIZONTAL")
		absorb_bar:SetRotatesTexture(false)
		statusbar:SetPoint("TOPLEFT")
		statusbar:SetPoint("TOPRIGHT")
		if rb then
			statusbar:SetPoint("BOTTOMLEFT",resourcebar,"TOPLEFT")
			statusbar:SetPoint("BOTTOMRIGHT",resourcebar,"TOPRIGHT")
			resourcebar:SetOrientation("HORIZONTAL")
			resourcebar:SetRotatesTexture(false)
			resourcebar:SetPoint("BOTTOMLEFT")
			resourcebar:SetPoint("BOTTOMRIGHT")
			resourcebar:SetHeight(rsbsz)
			resourcebar:Show()
		else
			resourcebar:Hide()
			statusbar:SetPoint("BOTTOMLEFT")
			statusbar:SetPoint("BOTTOMRIGHT")
		end
		set_point_multiple_cooldown(frame[6],statusbar,"TOPLEFT","TOPRIGHT",width)
		set_point_multiple_cooldown(frame[7],statusbar,"BOTTOMLEFT","BOTTOMRIGHT",width)
		dispel:SetPoint("RIGHT",statusbar,"RIGHT")
	end

	local mn = min(height,width) / 4
	dispel:SetSize(mn,mn)
	dispel[1]:SetAllPoints(dispel)
	CRaidFrame:SendMessage("CRFCfg",frame,profile)
end

local UnitExists = UnitExists
local UnitClass = UnitClass
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
local table_concat = table.concat
local wipe = wipe
local UnitIsUnit = UnitIsUnit
local UnitInPhase = UnitInPhase
local UnitIsWarModePhased = UnitIsWarModePhased
local math_floor = math.floor
local text_ctb = {}
local self_buff
local GHOST = GetSpellInfo(8326)
local aura_filters = {}
local resource_bar_healer_only
local UnitIsFriend = UnitIsFriend

local buffs,bf
local debuffs,df
local simple

local function update(self,tag)
	local unit = self:GetAttribute("unit")
	self.unit = unit
	local virtualframe = self[1]
	if not UnitExists(unit) then
		virtualframe:Hide()
		return
	end
	local statusbar = self[2]
	local resourcebar = self[3]
	local absorb_bar = self[4]
	if tag < 1 then
		local _,class = UnitClass(unit)
		if class then
			local color = CLASS_COLORS[class]
			local r,g,b = color.r,color.g,color.b
			statusbar:SetStatusBarColor(r,g,b)
			absorb_bar:SetStatusBarColor(r,g,b)
		else
			virtualframe:Hide()
			return
		end
		if resource_bar_healer_only~=nil then
			local role = UnitGroupRolesAssigned(unit)
			if role == "HEALER" then
				if resource_bar_healer_only then
					statusbar:SetPoint("TOPRIGHT",resourcebar,"TOPLEFT")
					statusbar:SetPoint("BOTTOMRIGHT",resourcebar,"BOTTOMLEFT")
				else
					statusbar:SetPoint("BOTTOMLEFT",resourcebar,"TOPLEFT")
					statusbar:SetPoint("BOTTOMRIGHT",resourcebar,"TOPRIGHT")
				end
				resourcebar:Show()
			else
				resourcebar:Hide()
				if resource_bar_healer_only then
					statusbar:SetPoint("TOPRIGHT")
					statusbar:SetPoint("BOTTOMRIGHT")
				else
					statusbar:SetPoint("BOTTOMLEFT",virtualframe,"BOTTOMLEFT")
					statusbar:SetPoint("BOTTOMRIGHT",virtualframe,"BOTTOMRIGHT")
				end
			end
		end
	end
	if tag == 4 or tag < 2 then
		local isInSamePhase = UnitInPhase(unit) and not UnitIsWarModePhased(unit)
		local alpha
		if not isInSamePhase or not UnitIsFriend("player",unit) then
			alpha = 0.1
		-- y = -0.015x + 1.05
		elseif CheckInteractDistance(unit,3) then --10 yards -- most ranged aoe healing spells
			alpha = 0.9
		elseif CheckInteractDistance(unit,1) then -- 30 yards -- for spells like Essence Font
			alpha = 0.78
		elseif UnitInRange(unit) then -- 43 yards not strict any more
			alpha = 0.65
		elseif IsItemInRange(35278, uId) then -- 80 yards
			alpha = 0.25
		else -- too far away
			alpha = 0.2
		end
		if self:IsMouseOver() then
			alpha = alpha + 0.1
		end
		statusbar:SetAlpha(alpha)
		resourcebar:SetAlpha(alpha)
		absorb_bar:SetAlpha(alpha)
		if tag < 2 then
			local name = UnitName(unit)
			wipe(text_ctb)
			local ghost = UnitIsGhost(unit)
			local dead = ghost or UnitIsDead(unit)
			if name then
				if dead then
					text_ctb[#text_ctb+1] = "|cffff0000"
					text_ctb[#text_ctb+1] = name
					text_ctb[#text_ctb+1] = "|r"
				else
					text_ctb[#text_ctb+1] = name
				end
			end
			local role
			if not simple then
				role = UnitGroupRolesAssigned(unit)
				if role then
					if role == "TANK" then
						if resource_bar_healer_only == nil then
							text_ctb[#text_ctb+1] = "\n|T337497:16:16:0:0:64:64:0:19:22:41|t"
						else
							text_ctb[#text_ctb+1] = "\n|T337497:16:16:0:0:64:64:0:19:22:41|t"
						end
					elseif role == "HEALER" and resource_bar_healer_only == nil then
						text_ctb[#text_ctb+1] = "\n|T337497:16:16:0:0:64:64:20:39:1:20|t"
					else
						role = nil
					end
				end
				if UnitIsGroupLeader(unit) then
					if role then
						text_ctb[#text_ctb+1] = ' '
					else
						text_ctb[#text_ctb+1] = '\n'
						role = true
					end
					text_ctb[#text_ctb+1] = "|T337497:16:16:0:0:64:64:0:19:1:20|t"
				end
				local raid_target_index = GetRaidTargetIndex(unit)
				if raid_target_index then
					if role then
						text_ctb[#text_ctb+1] = ' '
					else
						text_ctb[#text_ctb+1] = '\n'
					end
					text_ctb[#text_ctb+1]="|T"
					text_ctb[#text_ctb+1]=137000+raid_target_index
					text_ctb[#text_ctb+1]=":0|t"
				end
			end
			if not isInSamePhase then
				if role then
					text_ctb[#text_ctb+1] = ' '
					role = true
				else
					text_ctb[#text_ctb+1] = '\n'
				end
				text_ctb[#text_ctb+1] = "|T446212:0:0:0:0:32:32:5:27:5:27|t"
			end
			if not UnitIsConnected(unit) then
				text_ctb[#text_ctb+1] = '\n'
				text_ctb[#text_ctb+1] = PLAYER_OFFLINE
			end
			local healthmax = UnitHealthMax(unit) + UnitGetTotalHealAbsorbs(unit)
			local health = UnitHealth(unit)
			local absorbs = UnitGetTotalAbsorbs(unit)
			if not simple then
				if dead then
					if UnitHasIncomingResurrection(unit) then
						text_ctb[#text_ctb+1] = '\nRESCUE'
					elseif ghost then
						text_ctb[#text_ctb+1] = '\n'
						text_ctb[#text_ctb+1] = GHOST
					end
				else
					local incoming = UnitGetIncomingHeals(unit) or 0
					if health < healthmax or 0 < incoming then
						text_ctb[#text_ctb+1] = '\n'
						text_ctb[#text_ctb+1] = math_floor(((incoming+health-healthmax)/(healthmax+absorbs))*100 + 0.5)
					end
				end
			end
			local status = GetReadyCheckStatus(unit)
			if status then
				if status == "notready" then
					text_ctb[#text_ctb+1] = "\n|T136813:14|t"
				elseif status == "ready" then
					text_ctb[#text_ctb+1] = "\n|T136814:14|t"
				elseif status == "waiting" then
					text_ctb[#text_ctb+1] = "\n|T136815:14|t"
				end
			end
			self[5]:SetText(table_concat(text_ctb))
			statusbar:SetMinMaxValues(0,healthmax)
			statusbar:SetValue(health)
			if absorbs == 0 then
				absorb_bar:Hide()
			else
				absorb_bar:SetValue(health+absorbs)
				absorb_bar:SetMinMaxValues(0,healthmax)
				local r,g,b = statusbar:GetStatusBarColor()
				absorb_bar:SetStatusBarColor(1-r,1-g,1-b)
				absorb_bar:Show()
			end
		end
	end

	if (tag < 1 or tag == 2) and resourcebar:IsShown() then
		local powerType = UnitPowerType(unit)
		local powercolor = PowerBarColor[powerType]
		resourcebar:SetStatusBarColor(powercolor.r,powercolor.g,powercolor.b,powercolor.a)
		resourcebar:SetMinMaxValues(0,UnitPowerMax(unit))
		resourcebar:SetValue(UnitPower(unit))
	end
	if tag == -1 or tag == 3 then
		local band = bit.band
		local i = 1
		wipe(aura_filters)
		local lshift = bit.lshift
		local isplayer = UnitIsUnit(unit,"player")
		local require_sort = false
		local UnitBuff,UnitDebuff = UnitBuff,UnitDebuff
		while true do
			local name, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID,canApplyAura, isBossDebuff =UnitBuff(unit,i,"PLAYER")
			if name then
				if duration and expires and 0 <= duration then
					local v = buffs[spellID]
					if bf then
						if v then
							if v == 0 then
								aura_filters[#aura_filters+1] = 2113929216 + i
							else
								aura_filters[#aura_filters+1] = lshift(63-v,25) + i
								require_sort = true
							end
						end
					else
						if v ~= 0 and (isBossDebuff or (caster == "player" and (not isplayer or self_buff[spellID]))) then
							if v then
								aura_filters[#aura_filters+1] = lshift(63-v,25) + i
								require_sort = true
							else
								aura_filters[#aura_filters+1] = 2113929216 + i
							end
							self_buff[spellID] = true
						end
					end
				end
			else
				break
			end
			i = i + 1
		end
		if require_sort then
			table.sort(aura_filters)
		end
		local tb = self[6]
		local n = min(#tb,#aura_filters)
		for i=1,n do
			local ai = band(aura_filters[i],33554431)
			local name, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID,canApplyAura, isBossDebuff =UnitBuff(unit,ai,"PLAYER")
			local t = tb[i]
			t:SetCooldown(expires-duration,duration)
			t[1]:SetTexture(icon)
			t[2] = unit
			t[3] = ai
			t[4] = "PLAYER"
			t[1]:Show()
			t:Show()
		end
		for i=n+1,#tb do
			local tbi = tb[i]
			tbi:Hide()
			tbi[1]:Hide()
		end
		wipe(aura_filters)
		i = 1
		require_sort = false
		while true do
			local name, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID,canApplyAura, isBossDebuff =UnitDebuff(unit,i)
			if name then
				if duration and expires and 0 <= duration then
					local v = debuffs[spellID]
					if df then
						if v then
							aura_filters[#aura_filters+1] = lshift(v,25) + i
							require_sort = require_sort or v~=0
						end
					else
						if v ~= 0 then
							if v then
								aura_filters[#aura_filters+1] = lshift(v,25) + i
								require_sort = true
							else
								aura_filters[#aura_filters+1] = i
							end
						end
					end
				end
			else
				break
			end
			i = i + 1
		end
		if require_sort then
			table.sort(aura_filters)
		end
		tb = self[7]
		local dispeldebuff = self[8]
		local sdbf
		n = min(#tb,#aura_filters)
		local j = 1
		for i=1,n do
			local ai = band(aura_filters[i],33554431)
			local name, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID,canApplyAura, isBossDebuff =UnitDebuff(unit,ai)
			local t
			if dispelType and (not sdbf) then
				t = dispeldebuff
				sdbf = spellID
			else
				t = tb[j]
				j = j + 1
			end
			t:SetCooldown(expires-duration,duration)
			t[1]:SetTexture(icon)
			t[2] = unit
			t[3] = ai
			t[4] = "HARMFUL"
			t[1]:Show()
			t:Show()
		end
		for i=j,#tb do
			local tbi = tb[i]
			tbi:Hide()
			tbi[1]:Hide()
		end
		if not sdbf then
			dispeldebuff:Hide()
			dispeldebuff[1]:Hide()
		end
	end
	local crfunit = CRaidFrame.crfunit
	if crfunit then
		for i=1,#crfunit do
			crfunit(self,unit,tag)
		end
	end
	virtualframe:Show()
end

local function on_enter(self)
	update(self,0)
	UnitFrame_OnEnter(self)
end

local function on_leave(self)
	update(self,0)
	UnitFrame_OnLeave(self)
end

local buttons = {}

local function feedback(tag,event,...)
	for i=1,#buttons do
		local bi = buttons[i]
		for j=1,#bi do
			update(bi[j],tag)
		end
	end
	local feedbacks=CRaidFrame.feedbacks
	if feedbacks then
		for i=1,#feedbacks do
			feedbacks[i](buttons,tag)
		end
	end
end

local function time_feedback()
	feedback(4)
end

local function configure(tb,h)
	local frame = _G[h]
	local k1,v1 = h:match("CRaidFrame([0-9]+)UnitButton([0-9]+)")
	k1=tonumber(k1)
	v1=tonumber(v1)
	local bk1 = buttons[k1]
	if bk1 == nil then
		bk1 = {}
		buttons[k1] = bk1
	end
	bk1[v1] = frame
	frame:RegisterForClicks("AnyDown")
	local virtualframe = CreateFrame("Frame",nil,frame)
	virtualframe:SetFrameLevel(frame:GetFrameLevel())
	virtualframe:SetPoint("CENTER")
	local statusbar = CreateFrame("StatusBar",nil,virtualframe)
	statusbar:SetFrameLevel(virtualframe:GetFrameLevel())
	local absorb_bar = CreateFrame("StatusBar",nil,virtualframe)
	absorb_bar:SetFrameLevel(virtualframe:GetFrameLevel()-1)
	local resourcebar = CreateFrame("StatusBar",nil,virtualframe)
	resourcebar:SetFrameLevel(virtualframe:GetFrameLevel())

	local font = virtualframe:CreateFontString(nil,nil,"GameFontNormalSmall")
	font:SetPoint("CENTER",statusbar,"CENTER",0,0)

	local profile = CRaidFrame.db.profile
	if not profile.player_tooltip then
		frame:SetScript("OnEnter",on_enter)
		frame:SetScript("OnLeave",on_leave)
	end
	frame[1]=virtualframe
	frame[2]=statusbar
	frame[3]=resourcebar
	frame[4]=absorb_bar
	frame[5]=font
	frame[6]=create_multiple_cooldown(statusbar,profile.buffs,not profile.tooltip)
	frame[7]=create_multiple_cooldown(statusbar,profile.debuffs,not profile.tooltip)
	frame[8]=create_cooldown(statusbar)
	local border_frame = CreateFrame("Frame",nil,virtualframe)
	border_frame:SetAllPoints(frame)
	border_frame:SetFrameLevel(frame:GetFrameLevel())
	frame[9]=border_frame
	CRaidFrame.SendMessage(CRaidFrame,"CRFNew",frame,profile,create_cooldown)
	config_unitbutton(frame,true)
end

local function unit_event(tag,event,unit)
	local ui = unit:match("raid([0-9]+)")
	local bi
	if ui then
		ui = tonumber(ui)
		local name, rank, subgroup = GetRaidRosterInfo(ui)
		bi = buttons[subgroup]
	elseif unit=="player" or unit:find("party([0-9]+)") then
		bi = buttons[1]
	else
		return
	end
	for i=1,#bi do
		local ele = bi[i]
		if ele:GetAttribute("unit") == unit then
			update(ele,tag)
			return
		end
	end
end

local crf_frame

function CRaidFrame.Update()
	local profile = CRaidFrame.db.profile
	if profile.release then
		CRaidFrame.Update = nil
	end
	local width,height = profile.width,profile.height
	simple = height <= 55
	local tb = {[[
	RegisterUnitWatch(self)
	local w,h=]],width,",",height,[[	
	self:SetWidth(w)
	self:SetHeight(h)
	self:SetAttribute("initial-width",w)
	self:SetAttribute("initial-height",h)
	self:GetParent():CallMethod("initialConfigFunction", self:GetName(),self)
	]]}
	local bindings = profile.bindings
	for i=1,#bindings do
		local ele = bindings[i]
		local ele1,ele2,ele3,ele4,ele5 = ele[1],ele[2],ele[3],ele[4],ele[5]
		tb[#tb+1]=[[self:SetAttribute("]]
		tb[#tb+1]=ele1
		tb[#tb+1]=[[","]]
		tb[#tb+1]=ele2
		tb[#tb+1]=[[")
		]]
		if ele3 and ele4 then
			tb[#tb+1]=[[self:SetAttribute("]]
			tb[#tb+1]=ele3
			tb[#tb+1]=[[","]]
			tb[#tb+1]=ele4
			tb[#tb+1]=
			[[")
			]]
		end
		if ele5 then
			tb[#tb+1]="self:SetAttribute(\""
			tb[#tb+1]=ele5
			tb[#tb+1]=
			[[",nil)
			]]
		end
	end
	local str = table_concat(tb)
	local anchor = profile.anchor
	local anchor_point = profile.width
	local left,bottom = profile.left,profile.bottom
	crf_frame:ClearAllPoints()
	local anchor_string = "BOTTOMLEFT"
	if anchor == 1 then
		anchor_string="TOPLEFT"
		crf_frame:SetPoint(anchor_string,left,-bottom)
	elseif anchor == 2 then
		anchor_string="TOPRIGHT"
		crf_frame:SetPoint(anchor_string,-left,-bottom)
		anchor_point = -anchor_point
	elseif anchor == 4 then
		anchor_string="BOTTOMRIGHT"
		crf_frame:SetPoint(anchor_string,-left,bottom)
		anchor_point = -anchor_point
	else
		crf_frame:SetPoint(anchor_string,left,bottom)
	end
	crf_frame:SetSize(width*8,height*5)
	local show_solo = not profile.show_solo
	for i=1,#crf_frame do
		local ele = crf_frame[i]
		ele:ClearAllPoints()
		ele:SetPoint(anchor_string,(i-1)*anchor_point,0)
		ele:SetAttribute("initialConfigFunction",str)
		ele:SetAttribute("showSolo",show_solo)
	end
	local LSM = LibStub("LibSharedMedia-3.0")	
	backdrop ={bgFile = LSM:HashTable("background")[profile.background],
	edgeFile = LSM:HashTable("border")[profile.border],
	edgeSize = profile.border_size}
	for i=1,#buttons do
		local bi=buttons[i]
		for j=1,#bi do
			config_unitbutton(bi[j])
		end
	end
	if CRaidFrame.timer then
		CRaidFrame.timer:Cancel()
	end
	CRaidFrame:UnregisterAllEvents()
	if not profile.event then
		CRaidFrame:RegisterEvent("UNIT_PHASE",unit_event,0)
		CRaidFrame:RegisterEvent("UNIT_CONNECTION",unit_event,0)
		CRaidFrame:RegisterEvent("UNIT_FLAGS",unit_event,0)
		if not profile.disable_unit_health_frequent then
			CRaidFrame:RegisterEvent("UNIT_HEALTH_FREQUENT", unit_event,1)
		else
			CRaidFrame:RegisterEvent("UNIT_HEALTH", unit_event,1)
		end
		CRaidFrame:RegisterEvent("UNIT_MAXHEALTH", unit_event,1)
		CRaidFrame:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED",unit_event,1)
		CRaidFrame:RegisterEvent("UNIT_HEAL_ABSORB_AMOUNT_CHANGED",unit_event,1)
		if profile.resourcebar~=false then
			CRaidFrame:RegisterEvent("UNIT_POWER_UPDATE",unit_event,2)
			CRaidFrame:RegisterEvent("UNIT_MAXPOWER",unit_event,2)
			CRaidFrame:RegisterEvent("UNIT_POWER_FREQUENT",unit_event,2)
		end
		CRaidFrame:RegisterEvent("UNIT_HEAL_PREDICTION",unit_event,1)
		local v = 0
		if not profile.disable_unit_aura then
			CRaidFrame:RegisterEvent("UNIT_AURA",unit_event,3)
			v = -1
		end
		CRaidFrame:RegisterEvent("PLAYER_REGEN_DISABLED",feedback,v)
		CRaidFrame:RegisterEvent("PLAYER_REGEN_ENABLED",feedback,v)
		CRaidFrame:RegisterEvent("RAID_TARGET_UPDATE",feedback,v)
		CRaidFrame:RegisterEvent("GROUP_ROSTER_UPDATE",feedback,v)
		CRaidFrame:RegisterEvent("RAID_ROSTER_UPDATE",feedback,v)
		CRaidFrame:RegisterEvent("READY_CHECK",feedback,v)
		CRaidFrame:RegisterEvent("READY_CHECK_CONFIRM",feedback,v)
		CRaidFrame:RegisterEvent("READY_CHECK_FINISHED",feedback,v)
		CRaidFrame:RegisterEvent("PLAYER_ROLES_ASSIGNED",feedback,v)
		CRaidFrame:RegisterEvent("INCOMING_RESURRECT_CHANGED",feedback,v)
		CRaidFrame:RegisterEvent("UNIT_NAME_UPDATE",feedback,v)
	end
	if profile.timer then
		CRaidFrame.timer = C_Timer.NewTicker(profile.refresh_rate,time_feedback)
	end
	crf_frame:SetMovable(profile.lock)
	crf_frame:EnableMouse(profile.lock)
	self_buff = profile.self_buff
	if profile.resourcebar == nil then
		resource_bar_healer_only = profile.vertical or false
	else
		resource_bar_healer_only = nil
	end
	buffs = profile[1]
	debuffs = profile[2]
	bf = profile.b
	df = profile.d
	crf_frame:Show()
	feedback(0)
end

function CRaidFrame:OnEnable()
	crf_frame = CreateFrame("Frame",nil,UIParent)
	crf_frame:Hide()
	crf_frame:SetScript("OnMouseDown",function(self) 
		if not InCombatLockdown() then
			self:StartMoving()
		end
	end)
	crf_frame:SetScript("OnMouseUp", function(self)
		self:StopMovingOrSizing()
		local left,bottom=self:GetLeft(),self:GetBottom()
		local profile = CRaidFrame.db.profile
		local rswidth,rsheight = GetCVar("gxFullscreenResolution"):match("(%d+)x(%d+)")
		rswidth = tonumber(rswidth)
		rsheight = tonumber(rsheight)
		local anchor = profile.anchor
		if anchor == 1 then
			bottom = rsheight - bottom
			bottom = bottom - 5*profile.height
		elseif anchor == 2 then
			bottom = rsheight - bottom
			bottom = bottom + 5*profile.height
			left = rswidth - left
			left = left - 8*profile.width
		elseif anchor == 4 then
			left = rswidth - left
			left = left - 8*profile.width
		end
		profile.left,profile.bottom = left,bottom
	end)
	crf_frame:SetScript("OnDragStop", crf_frame.StopMoving)
	for i=1,8 do
		local ele = CreateFrame("Frame", "CRaidFrame"..i, crf_frame, "SecureGroupHeaderTemplate")
		ele:SetAttribute("template", "SecureUnitButtonTemplate")
		ele:SetAttribute("templateType", "Button")
		ele:SetAttribute("showParty", true)
		ele:SetAttribute("showRaid", 	true)
		ele:SetAttribute("showPlayer", true)
		ele:SetAttribute("showSolo",show_solo)
		ele:SetAttribute("groupFilter",i)
		ele.initialConfigFunction = configure
		ele:Show()
		crf_frame[i] = ele
	end
	CRaidFrame.Update()
	self.OnInitialize = nil
	self.OnEnable = nil
end
