local QUI = LibStub("AceAddon-3.0"):GetAddon("QUI")
local function on_enter()
	MainMenuBarBackpackButton.icon:SetAlpha(1)
	MainMenuBarBackpackButton.Count:SetAlpha(1)
	for i=0,3 do
		local slot = _G["CharacterBag"..i.."Slot"]
		slot.icon:SetAlpha(1)
		slot.IconBorder:SetAlpha(1)
	end
end

local function on_leave()
	MainMenuBarBackpackButton.icon:SetAlpha(0)
	MainMenuBarBackpackButton.Count:SetAlpha(0)
	for i=0,3 do
		local slot = _G["CharacterBag"..i.."Slot"]
		slot.icon:SetAlpha(0)
		slot.IconBorder:SetAlpha(0)
	end
end

local function set_bag_background(texture)
	texture:SetVertexColor(0,0,0,0.4)
end

local function skinbag(name)
	local bagframe = _G[name]
	set_bag_background(_G[name.."BackgroundTop"])
	set_bag_background(_G[name.."BackgroundMiddle1"])
	set_bag_background(_G[name.."BackgroundMiddle2"])
	set_bag_background(_G[name.."BackgroundBottom"])
end

local function skinbutton(button)
	button:SetNormalTexture("")
	button.icon:SetTexCoord(0.1,0.9,0.1,0.9)
	button:SetParent(UIParent)
	button:HookScript("OnEnter",on_enter)
	button:HookScript("OnLeave",on_leave)
end

MainMenuBarBackpackButton:ClearAllPoints()
MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMRIGHT",0,0)
skinbutton(MainMenuBarBackpackButton)

for i=0,3 do
	skinbutton(_G["CharacterBag"..i.."Slot"])
end

on_leave()

for i=1,13 do
	skinbag("ContainerFrame"..i)
	for j=1,100 do
		local button =  _G["ContainerFrame"..i.."Item"..j]
		if button == nil then
			break
		end
		button:SetNormalTexture("")
		button.icon:SetTexCoord(0.1,0.9,0.1,0.9)
		button.IconBorder:SetAlpha(0)
	end
end

local function skin_auto_sort_button(button)
	button:GetNormalTexture():SetTexCoord(0.2,0.8,0.2,0.8)
	button:GetHighlightTexture():SetTexCoord(0.2,0.8,0.2,0.8)
	button:GetPushedTexture():SetTexCoord(0.2,0.8,0.2,0.8)
end

skin_auto_sort_button(BagItemAutoSortButton)
skin_auto_sort_button(BankItemAutoSortButton)

local selljunkbutton=CreateFrame("BUTTON",nil,ContainerFrame1)
QUI.selljunkbutton = selljunkbutton
selljunkbutton:SetSize(25,25)
selljunkbutton:SetNormalAtlas("bags-junkcoin")
selljunkbutton:SetPoint("RIGHT",BagItemSearchBox,"LEFT",-4,-5)
selljunkbutton:SetScript("OnClick",function()
	if GetMerchantItemInfo(1) then
		local GetContainerItemInfo = GetContainerItemInfo
		local le_item_quality_poor = Enum.ItemQuality.Poor
		for i=0,NUM_BAG_SLOTS do
			for j=1,GetContainerNumSlots(i) do
				local texture, itemCount, locked, quality, readable, lootable, itemLink , isFiltered, noValue, itemID = GetContainerItemInfo(i,j)
				if quality == le_item_quality_poor and not noValue then
					UseContainerItem(i,j)
				end
			end
		end
	end
end)
selljunkbutton:SetScript("OnEnter",function(self)
	GameTooltip:SetOwner(self,"ANCHOR_TOPRIGHT")
	GameTooltip:AddLine(BAG_FILTER_JUNK)
	GameTooltip:Show()
end)
selljunkbutton:SetScript("OnLeave",function()
	GameTooltip:Hide()
end)

local function skin_item_search_box(box)
	box.Left:Hide()
	box.Middle:Hide()
	box.Right:Hide()
end

BankFrame.NineSlice:Hide()
BankFrame.Bg:SetTexture(131071)
BankFrame.TitleBg:SetTexture(131071)
BankFrame.TopTileStreaks:SetAlpha(0)

skin_item_search_box(BagItemSearchBox)
skin_item_search_box(BankItemSearchBox)

local function remove_shadow(frame)
	local regions = {frame:GetRegions()}
	for i=1,#regions do
		local region = regions[i]
		if region:IsObjectType("Texture") then
			region:SetAlpha(0)
		end
	end
end
remove_shadow(BankSlotsFrame)

local regions = {BankFrame:GetRegions()}
for i=1,#regions do
	local region = regions[i]
	if region:IsObjectType("Texture") and region:GetTexture()=="Interface\\BankFrame\\Bank-Background" then
		region:SetAlpha(0)
	end
end


BankFrameTab1Left:SetAlpha(0)
BankFrameTab1Middle:SetAlpha(0)
BankFrameTab1Right:SetAlpha(0)
BankFrameTab1LeftDisabled:SetAlpha(0)
BankFrameTab1MiddleDisabled:SetAlpha(0)
BankFrameTab1RightDisabled:SetAlpha(0)

BankFrameTab2Left:SetAlpha(0)
BankFrameTab2Middle:SetAlpha(0)
BankFrameTab2Right:SetAlpha(0)
BankFrameTab2LeftDisabled:SetAlpha(0)
BankFrameTab2MiddleDisabled:SetAlpha(0)
BankFrameTab2RightDisabled:SetAlpha(0)
BankFrameMoneyFrameBorder:SetAlpha(0)
BankFrameMoneyFrameInset:SetAlpha(0)


local BankSlotsFrame = BankSlotsFrame
for i=1,7 do
	local bank_slot = BankSlotsFrame["Bag"..i]
	bank_slot.icon:SetTexCoord(0.1,0.9,0.1,0.9)
	bank_slot.IconBorder:SetAlpha(0)
	bank_slot:SetNormalTexture("")
end

for i=1,NUM_BANKGENERIC_SLOTS do
	local item_slot = BankSlotsFrame["Item"..i]
	item_slot.icon:SetTexCoord(0.1,0.9,0.1,0.9)
	item_slot.IconBorder:SetAlpha(0)
	item_slot:SetNormalTexture("")
end

QUI:SecureHookScript(ReagentBankFrame,"OnShow",function()
	remove_shadow(ReagentBankFrame)
	for i=1,98 do
		local item_slot = ReagentBankFrame["Item"..i]
		item_slot.icon:SetTexCoord(0.1,0.9,0.1,0.9)
		item_slot.IconBorder:SetAlpha(0)
		item_slot:SetNormalTexture("")
	end
	QUI:Unhook(ReagentBankFrame,"OnShow")
end)

ReagentBankFrame.DespositButton.Left:SetAlpha(0)
ReagentBankFrame.DespositButton.Right:SetAlpha(0)
ReagentBankFrame.DespositButton.Middle:SetVertexColor(0,0,0,1)
ReagentBankFrame.DespositButton:SetHighlightTexture("")
