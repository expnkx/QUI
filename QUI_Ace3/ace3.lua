local AceGUI = LibStub("AceGUI-3.0",true)
local QUI = LibStub("AceAddon-3.0"):GetAddon("QUI")
local Ace3 = QUI:NewModule("Ace3","AceEvent-3.0")

function Ace3:OnEnable()
	self:RegisterEvent("ADDON_LOADED")
	self:ADDON_LOADED()
	self.OnEnable = nil
end

function Ace3.CheckBox_SetType(self, type)
	local checkbg = self.checkbg
	local check = self.check
	local highlight = self.highlight

	local size
	if type == "radio" then
		size = 16
		checkbg:SetTexture(130843) -- Interface\\Buttons\\UI-RadioButton
		checkbg:SetTexCoord(0, 0.25, 0, 1)
		check:SetTexture(130843) -- Interface\\Buttons\\UI-RadioButton
		check:SetTexCoord(0.25, 0.5, 0, 1)
		check:SetBlendMode("ADD")
		highlight:SetTexture(130843) -- Interface\\Buttons\\UI-RadioButton
		highlight:SetTexCoord(0.5, 0.75, 0, 1)
	else
		size = 18
		checkbg:SetTexture(130755) -- Interface\\Buttons\\UI-CheckBox-Up
		checkbg:SetTexCoord(0.3, 0.7, 0.3, 0.7)
		check:SetTexture(130751) -- Interface\\Buttons\\UI-CheckBox-Check
		check:SetTexCoord(0.2, 0.9, 0.1 ,0.9)
		check:SetBlendMode("BLEND")
		highlight:SetTexture(130753) -- Interface\\Buttons\\UI-CheckBox-Highlight
		highlight:SetTexCoord(0.2, 0.7, 0.3,0.7)
	end
	checkbg:SetHeight(size)
	checkbg:SetWidth(size)
end

function Ace3.RegisterAsWidget(acegui,widget)
	local wdg = Ace3.original_register_as_widget(acegui,widget)
	local tpe = wdg.type
	if wdg.frame.SetBackdropBorderColor then
		local backdrop = wdg.frame:GetBackdrop()
		if backdrop then
			backdrop.bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]]
			wdg.frame:SetBackdrop(backdrop)
		end
		wdg.frame:SetBackdropBorderColor(0,0,0,1)
	end
	if tpe == "Button" then
		local button = wdg.frame
		button.Left:Hide()
		button.Middle:SetVertexColor(0,0,0,0.8)
		button.Right:Hide()
		button:SetHighlightTexture("")
		button:SetPushedTexture("")
		button:SetDisabledTexture("")
	elseif tpe == "Dropdown" then
		local dropdown = wdg.dropdown
		local dropname = dropdown:GetName()
		local _G = _G
		_G[dropname .. "Left"]:SetAlpha(0)
		local middle = _G[dropname .. "Middle"]
		middle:SetTexture("Interface\\Common\\Common-Input-Border")
		middle:SetHeight(20)
		middle:SetTexCoord(0.0625,0.9375,0.1,0.525)
		_G[dropname .. "Right"]:SetAlpha(0)
		local button = dropdown.Button
		button:GetNormalTexture():SetTexCoord(0.25,0.75,0.28,0.75)
		button:GetDisabledTexture():SetTexCoord(0.25,0.75,0.28,0.75)
		button:GetPushedTexture():SetTexCoord(0.25,0.75,0.28,0.75)
		button:GetHighlightTexture():SetTexCoord(0.25,0.75,0.28,0.75)
	elseif tpe == "CheckBox" then
		wdg.SetType = Ace3.CheckBox_SetType
	elseif tpe == "EditBox" then
		wdg.editbox.Left:Hide()
		wdg.editbox.Right:Hide()
		wdg.editbox.Middle:SetTexCoord(0.0625,0.9375,0.1,0.525)
	elseif tpe  == "MultiLineEditBox" then
		wdg.scrollBG:SetBackdropBorderColor(0,0,0,0)
		local button = wdg.button
		button.Left:SetVertexColor(0,0,0,0.8)
		button.Middle:SetVertexColor(0,0,0,0.8)
		button.Right:SetVertexColor(0,0,0,0.8)
	end
	return wdg
end

function Ace3.RegisterAsContainer(acegui,container)
	local ctn = Ace3.original_register_as_container(acegui,container)
	local tpe = ctn.type
	local border = ctn.border
	if border then
		border:SetBackdropBorderColor(0, 0, 0, 0)
	end
	if tpe == "TreeGroup" then
		ctn.treeframe:SetBackdropBorderColor(0, 0, 0, 0)
		local CreateButton = ctn.CreateButton
		ctn.CreateButton = function(self)
			local bt = CreateButton(self)
			local toggle = _G[bt:GetName() .. "Toggle"]
			toggle:GetNormalTexture():SetTexCoord(0.25,0.7,0.4,0.7)
			toggle:GetPushedTexture():SetTexCoord(0.25,0.7,0.4,0.7)
			toggle:GetHighlightTexture():SetTexCoord(0.25,0.7,0.4,0.7)
			return bt
		end
	elseif tpe == "TabGroup" then
		local CreateTab = ctn.CreateTab
		ctn.CreateTab = function(self, id)
			local tab = CreateTab(self, id)
			local name = tab:GetName()
			local _G = _G
			_G[name .. "Left"]:SetAlpha(0)
			_G[name .. "Middle"]:SetAlpha(0)
			_G[name .. "Right"]:SetAlpha(0)
			_G[name .. "LeftDisabled"]:SetAlpha(0)
			_G[name .. "MiddleDisabled"]:SetAlpha(0)
			_G[name .. "RightDisabled"]:SetAlpha(0)
			return tab
		end
	end
	return ctn
end

function Ace3:ADDON_LOADED()
	AceGUI = LibStub('AceGUI-3.0', true)
	if not AceGUI then return end
	if AceGUI.RegisterAsWidget ~= self.RegisterAsWidget then
		self.original_register_as_widget =  AceGUI.RegisterAsWidget
		AceGUI.RegisterAsWidget = self.RegisterAsWidget
	end
	if AceGUI.RegisterAsContainer ~= self.RegisterAsContainer then
		self.original_register_as_container =  AceGUI.RegisterAsContainer
		AceGUI.RegisterAsContainer = self.RegisterAsContainer
	end
	local AceConfigDialog = LibStub("AceConfigDialog-3.0",true)
	if not AceConfigDialog then return end
	local popup = AceConfigDialog.popup
	if popup and not popup.qui_skinned then
		if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
			popup:SetBackdropBorderColor(0,0,0,0)
		else
			popup:GetChildren():Hide()
			popup:SetBackdrop({bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]]})
		end
		popup:SetBackdropColor(0,0,0,0.6)
		popup:ClearAllPoints()
		popup:SetPoint("TOP", UIParent, "TOP", 0, -120)
		popup.accept:SetNormalTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]])
		popup.accept:SetPushedTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]])
		popup.accept:SetHighlightTexture("")
		popup.cancel:SetNormalTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]])
		popup.cancel:SetPushedTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]])
		popup.cancel:SetHighlightTexture("")
		popup.qui_skinned = true
	end
end
