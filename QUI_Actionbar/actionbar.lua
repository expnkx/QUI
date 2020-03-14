local QUI = LibStub("AceAddon-3.0"):GetAddon("QUI")
local ActionBar = QUI:NewModule("ActionBar","AceEvent-3.0")

do
	local UIHider = QUI.UIHider
	-- Hide MultiBar Buttons, but keep the bars alive
	MultiBarBottomLeft:SetParent(UIHider)
	MultiBarBottomRight:SetParent(UIHider)
	MultiBarLeft:SetParent(UIHider)
	MultiBarRight:SetParent(UIHider)

	-- Hide MultiBar Buttons, but keep the bars alive
	for i=1,12 do
		_G["ActionButton" .. i]:Hide()
		_G["ActionButton" .. i]:UnregisterAllEvents()
		_G["ActionButton" .. i]:SetAttribute("statehidden", true)

		_G["MultiBarBottomLeftButton" .. i]:Hide()
		_G["MultiBarBottomLeftButton" .. i]:UnregisterAllEvents()
		_G["MultiBarBottomLeftButton" .. i]:SetAttribute("statehidden", true)

		_G["MultiBarBottomRightButton" .. i]:Hide()
		_G["MultiBarBottomRightButton" .. i]:UnregisterAllEvents()
		_G["MultiBarBottomRightButton" .. i]:SetAttribute("statehidden", true)

		_G["MultiBarRightButton" .. i]:Hide()
		_G["MultiBarRightButton" .. i]:UnregisterAllEvents()
		_G["MultiBarRightButton" .. i]:SetAttribute("statehidden", true)

		_G["MultiBarLeftButton" .. i]:Hide()
		_G["MultiBarLeftButton" .. i]:UnregisterAllEvents()
		_G["MultiBarLeftButton" .. i]:SetAttribute("statehidden", true)

		if _G["VehicleMenuBarActionButton" .. i] then
			_G["VehicleMenuBarActionButton" .. i]:Hide()
			_G["VehicleMenuBarActionButton" .. i]:UnregisterAllEvents()
			_G["VehicleMenuBarActionButton" .. i]:SetAttribute("statehidden", true)
		end

		if _G['OverrideActionBarButton'..i] then
			_G['OverrideActionBarButton'..i]:Hide()
			_G['OverrideActionBarButton'..i]:UnregisterAllEvents()
			_G['OverrideActionBarButton'..i]:SetAttribute("statehidden", true)
		end

		_G['MultiCastActionButton'..i]:Hide()
		_G['MultiCastActionButton'..i]:UnregisterAllEvents()
		_G['MultiCastActionButton'..i]:SetAttribute("statehidden", true)
	end
	MicroButtonAndBagsBar:Show()
	ActionBarController:UnregisterAllEvents()
--	ActionBarController:RegisterEvent('PLAYER_ENTERING_WORLD')

	MainMenuBar:EnableMouse(false)
	MainMenuBar:SetAlpha(0)
	MainMenuBar:SetScale(0.00001)
	MainMenuBar:SetParent(UIHider)
--	MicroButtonAndBagsBar:SetScale(0.00001)
	MicroButtonAndBagsBar:EnableMouse(false)
	MicroButtonAndBagsBar:SetParent(UIHider)
	MicroButtonAndBagsBar:Hide()
	
	MainMenuBarArtFrame:UnregisterAllEvents()
	MainMenuBarArtFrame:Hide()
	MainMenuBarArtFrame:SetParent(UIHider)

	StatusTrackingBarManager:EnableMouse(false)
	StatusTrackingBarManager:UnregisterAllEvents()
	StatusTrackingBarManager:Hide()

	StanceBarFrame:UnregisterAllEvents()
	StanceBarFrame:Hide()
	StanceBarFrame:SetParent(UIHider)

	OverrideActionBar:UnregisterAllEvents()
	OverrideActionBar:Hide()
	OverrideActionBar:SetParent(UIHider)

	PossessBarFrame:UnregisterAllEvents()
	PossessBarFrame:Hide()
	PossessBarFrame:SetParent(UIHider)

	PetActionBarFrame:UnregisterAllEvents()
	PetActionBarFrame:Hide()
	PetActionBarFrame:SetParent(UIHider)

	MultiCastActionBarFrame:UnregisterAllEvents()
	MultiCastActionBarFrame:Hide()
	MultiCastActionBarFrame:SetParent(UIHider)

end

local function action_button_onenter(actionbutton)
	GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
	local action = actionbutton:GetAttribute("action")
	if action < 13 then
		action = ((MainMenuBarArtFrame:GetAttribute("actionpage") or GetActionBarPage())-1)*12+action
	end
	GameTooltip:SetAction(action)
end

local function action_button_onleave()
	GameTooltip:Hide()
end

local function create(frame,ipstart,location,width,macro)
	local actionbutton = CreateFrame("Button",nil,frame,"SecureActionButtonTemplate")
	location = location * width
	actionbutton:SetPoint("TOPLEFT",frame,"TOPLEFT",location,0)
	actionbutton:SetPoint("BOTTOMLEFT",frame,"BOTTOMLEFT",location,0)
	actionbutton:SetWidth(width)
	local texture = actionbutton:CreateTexture(nil,"OVERLAY")
	texture:SetTexCoord(0.1,0.9,0.1,0.9)
	texture:SetTexture(GetActionTexture(ipstart))
	texture:SetAllPoints(actionbutton)
	actionbutton:SetAttribute("type", "action")
	actionbutton:SetAttribute("action", ipstart)
	actionbutton[2] = texture
	local cd = CreateFrame("Cooldown", nil, actionbutton, "CooldownFrameTemplate")
	cd:SetHideCountdownNumbers(true)
	actionbutton[3] = cd
	local charges = actionbutton:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	charges:SetPoint("BOTTOMRIGHT", actionbutton, "BOTTOMRIGHT",0, 0)
	charges:SetFont([[FONTS\FRIZQT__.ttf]],12)
	actionbutton[4] = charges
	local keybind = actionbutton:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	keybind:SetPoint("TOPRIGHT", actionbutton, "TOPRIGHT",0, 0)
	keybind:SetFont([[FONTS\FRIZQT__.ttf]],12)
	actionbutton[5] = keybind
	local cd_text = actionbutton:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	cd_text:SetPoint("CENTER", actionbutton, "CENTER",0, 0)
	cd_text:SetFont([[FONTS\FRIZQT__.ttf]],12)
	actionbutton[6] = cd_text
	actionbutton:SetScript("OnEnter",action_button_onenter)
	actionbutton:SetScript("OnLeave",action_button_onleave)
	return actionbutton
end

local function maincofunc()
--	RegisterStateDriver(OverrideActionBar, "visibility", "[overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")
	local GetActionTexture = GetActionTexture
	local GetActionCharges = GetActionCharges
	local GetActionCooldown = GetActionCooldown
	local GetSpellCooldown = GetSpellCooldown
	local FlyoutHasSpell = FlyoutHasSpell
	local GetMacroSpell = GetMacroSpell
	local GetActionInfo = GetActionInfo
	local gcd = 1.5
	local function update(index,button,gtime,current_page)
		if index < 13 then
			index = (current_page-1)*12+index
		end
		local texture = button[2]
		texture:SetTexture(GetActionTexture(index))
		local usable,oom = IsUsableAction(index)
		local alpha = usable and 1 or 0.3
		if oom then
			texture:SetVertexColor(0.1,0.1,1,alpha)
		else
			texture:SetVertexColor(1,1,1,alpha)
		end
		local currentCharges, maxCharges, cooldownStart, cooldownDuration, chargeModRate = GetActionCharges(index)
		local gg
		if currentCharges == maxCharges then
			cooldownStart,cooldownDuration,chargeModRate = GetActionCooldown(index)
			if maxCharges == 0 then
				local counts = GetActionCount(index)
				if counts~=0 then
					button[4]:SetText(counts)
				else
					button[4]:SetText(nil)
				end
			else
				button[4]:SetText(currentCharges)
			end
			if cooldownDuration <= gcd then
				if cooldownDuration == 0.001 then
					button[3]:SetCooldown(gtime,2147483647)
				else
					button[3]:SetCooldown(cooldownStart,cooldownDuration,chargeModRate)					
				end
				button[6]:SetText(nil)
				return
			end
		else
			button[4]:SetText(currentCharges)
		end
		if chargeModRate  == 0.001 then
			button[3]:SetCooldown(gtime,2147483647)
		else
			button[3]:SetCooldown(cooldownStart,cooldownDuration,chargeModRate)
		end
		gg = cooldownStart+cooldownDuration-gtime
		local cd = button[6]
		if gg < 0 then
			cd:SetText(nil)
			return
		elseif 30 < gg then
			cd:SetFormattedText("%.0f",gg)
			cd:SetTextColor(0,0,1,1)
		else
			cd:SetFormattedText("%.1f",gg)
			if 3 < gg then
				cd:SetTextColor(1,1,1,1)
			else
				cd:SetTextColor(1,0,0,1)
			end
		end
		return true
	end
	local buttons={}
	local function actionbar(start,...)
		local frame = CreateFrame("Frame",nil, UIParent,"SecureHandlerStateTemplate")
		frame:SetPoint(...)
		frame:SetSize(360,30)
		RegisterStateDriver(frame, "visibility", "[petbattle] hide; show")
		frame:SetAttribute("_onstate-visibility",[[
			if self:IsShown() then
				self:Hide()
			else
				self:Show()
			end
		]])
		start = start * 12
		local macro = start == 0
		for i = 1,12 do
			buttons[#buttons+1] = create(frame,i+start,i-1,30,macro)
		end
		if macro then
			RegisterStateDriver(frame, "page", "[possessbar] 12; [overridebar] 14; [shapeshift] 13; [form,noform] 0; [bar:1] 1; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6")
			frame:SetFrameRef("MainMenuBarArtFrame", MainMenuBarArtFrame)
			frame:SetAttribute("_onstate-page", [[self:GetFrameRef("MainMenuBarArtFrame"):SetAttribute("actionpage", newstate)]])
		end
		return frame
	end
	local frame0 = actionbar(0,"BOTTOM",UIParent,"BOTTOM",0,0)
	actionbar(1,"BOTTOM",UIParent,"BOTTOM",-370,30)
	actionbar(2,"BOTTOM",UIParent,"BOTTOM",-370,0)
	actionbar(3,"BOTTOM",UIParent,"BOTTOM",370,30)
	actionbar(4,"BOTTOM",UIParent,"BOTTOM",0,30)
	actionbar(5,"BOTTOM",UIParent,"BOTTOM",370,0)
	local extrabuttonframe = CreateFrame("Frame",nil, UIParent)
	extrabuttonframe:SetPoint("BOTTOM",UIParent,"BOTTOM",630,0)
	extrabuttonframe:SetSize(30,30)
	local extrabutton = create(extrabuttonframe,169,0,30)
	buttons[169] = extrabutton
	local current = coroutine.running()
	local function resume(...)
		QUI.resume(current,...)
	end
	do
		local tbls = {{"ACTIONBAR_UPDATE_STATE","PLAYER_TALENT_UPDATE","ACTIONBAR_UPDATE_USABLE","SPELL_UPDATE_CHARGES","PLAYER_REGEN_ENABLED","PLAYER_REGEN_DISABLED","PLAYER_ENTER_COMBAT","PLAYER_LEAVE_COMBAT"},{"UPDATE_BINDINGS","UPDATE_BONUS_ACTIONBAR","UPDATE_VEHICLE_ACTIONBAR","UPDATE_OVERRIDE_ACTIONBAR","UPDATE_SHAPESHIFT_FORM","UPDATE_SHAPESHIFT_FORMS","UPDATE_SHAPESHIFT_USABLE"},
		{"SPELL_ACTIVATION_OVERLAY_GLOW_SHOW","SPELL_ACTIVATION_OVERLAY_GLOW_HIDE"},{"LOADING_SCREEN_DISABLED","UPDATE_MOUSEOVER_UNIT"},{"PLAYER_TARGET_CHANGED","PLAYER_FOCUS_CHANGED"}}
		for j = 1, #tbls do
			local tbl = tbls[j]
			for i = 1, #tbl do
				ActionBar:RegisterEvent(tbl[i],resume,j)
			end
		end
	end
	
	local function resume4()
		coroutine.resume(current,4)
	end
	local NewTicker = C_Timer.NewTicker
	local ticker
	local IsActionInRange = IsActionInRange
	local UnitExists = UnitExists
	local function updaterange(i,button,current_page)
		if i < 13 then
			i = (current_page-1)*12+i
		end
		local inrange = IsActionInRange(i)
		local r,g,b,a
		if inrange then
			r,g,b,a = 0,1,0,1
		elseif inrange == false then
			r,g,b,a = 1,0,0,1
		else
			r,g,b,a = 1,1,1,1
		end
		button[4]:SetTextColor(r,g,b,a)
		button[5]:SetTextColor(r,g,b,a)
	end

	local cds = {}
	local tag,arg1,arg2,arg3,arg4 = 2
	local spell_activation_pool = CreateFramePool("Frame",frame,"ActionBarButtonSpellActivationAlert")
	while true do
		repeat
		local gtime = GetTime()
		local gcds,gcdt = GetSpellCooldown(61304)
		if 0~= gcdt then
			gcd = gcdt + 0.01
		end
		if 3 < tag then
			local current_page = MainMenuBarArtFrame:GetAttribute("actionpage") or GetActionBarPage()
			for i=1,#cds do
				local e = cds[i]
				update(e,buttons[e],gtime,current_page)
			end
			for i=1,#buttons do
				updaterange(i,buttons[i],current_page)
			end
			updaterange(169,extrabutton,current_page)
			break
		elseif tag == 3 then
			local current_page = MainMenuBarArtFrame:GetAttribute("actionpage") or GetActionBarPage()
			for i=1,#buttons do
				local j = i
				if i < 13 then
					j = (current_page-1)*12+j
				end
				local actionType, id, subType = GetActionInfo(j);
				local isthisspell = false
				if actionType == "spell" and id == arg2 then
					isthisspell = true
				elseif actionType == "macro" then
					local spellId = GetMacroSpell(id)
					if spellId and spellId == arg2 then
						isthisspell = true
					end
				elseif actionType == "flyout" and FlyoutHasSpell(id, arg2) then
					isthisspell = true
				end
				if isthisspell then
					local button = buttons[j]
					local overlay = button.overlay
					if arg1 == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW" then
						if overlay == nil then
							overlay = spell_activation_pool:Acquire()
							button.cooldown = button[3]
							button.overlay = overlay
							overlay:SetParent(button);
							overlay:ClearAllPoints();
							local frameWidth, frameHeight = button:GetSize();
							overlay:SetSize(frameWidth * 1.4, frameHeight * 1.4);
							overlay:SetPoint("TOPLEFT", button, "TOPLEFT", -frameWidth * 0.2, frameHeight * 0.2);
							overlay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", frameWidth * 0.2, -frameHeight * 0.2);
						end
						if overlay.animOut:IsPlaying() then
							overlay.animOut:Stop();
						end
						overlay.animIn:Play();
					elseif overlay then
						spell_activation_pool:Release(overlay)
						button.cooldown = nil
						button.overlay = nil
					end
				end
			end
			break
		elseif tag == 2 then
			local GetBindingKey = GetBindingKey
			for i=1,12 do
				buttons[i][5]:SetText(GetBindingKey("ACTIONBUTTON"..i))
				buttons[i+24][5]:SetText(GetBindingKey("MULTIACTIONBAR3BUTTON"..i))
				buttons[i+36][5]:SetText(GetBindingKey("MULTIACTIONBAR4BUTTON"..i))
				buttons[i+48][5]:SetText(GetBindingKey("MULTIACTIONBAR2BUTTON"..i))
				buttons[i+60][5]:SetText(GetBindingKey("MULTIACTIONBAR1BUTTON"..i))
			end
			tag = 1
		end
		if tag == 1 then
			wipe(cds)
			local current_page = MainMenuBarArtFrame:GetAttribute("actionpage") or GetActionBarPage()
			for i=1,#buttons do
				if update(i,buttons[i],gtime,current_page) then
					cds[#cds+1] = i
				end
			end
			if update(169,extrabutton,gtime,current_page) then
				cds[#cds+1] = 169
			end
		end
		until true
		if tag == 1 or tag == 5 then
			if #cds~= 0 or UnitExists("target") or UnitExists("focus") then
				if ticker == nil then
					ticker = NewTicker(0.1,resume4)
				end
			else
				if ticker then
					ticker:Cancel()
					ticker=nil
				end
			end
		end
		tag,arg1,arg2,arg3,arg4 = coroutine.yield()
	end
--[[	actionbar(6,"BOTTOM",UIParent,"BOTTOM",-740,0)
	actionbar(7,"BOTTOM",UIParent,"BOTTOM",-740,30)
	actionbar(8,"BOTTOM",UIParent,"BOTTOM",740,0)
	actionbar(9,"BOTTOM",UIParent,"BOTTOM",740,30)]]
end

coroutine.wrap(maincofunc)()
