CharacterFrame.NineSlice:Hide()
CharacterFrameInset:Hide()
CharacterFrame.Bg:SetTexture(131071)
CharacterFrame.TitleBg:SetTexture(131071)
CharacterFrame.TopTileStreaks:Hide()

local slots = {PaperDollItemsFrame:GetChildren()}
local _G = _G
for i=1,#slots do
	local slot=slots[i]
	if slot:IsObjectType("Button") or slot:IsObjectType("ItemButton") then
		_G[slot:GetName().."Frame"]:Hide()
		slot:SetNormalTexture("")
		slot:GetHighlightTexture():SetTexCoord(0.1,0.9,0.1,0.9)
		slot:GetPushedTexture():SetTexCoord(0.1,0.9,0.1,0.9)
		slot.IconBorder:SetAlpha(0)
		slot.icon:SetTexCoord(0.1,0.9,0.1,0.9)
	end
end

local function hide_left_right(slot)
	local regions = {slot:GetRegions()}
	for i=1,#regions do
		local region = regions[i]
		if region:IsObjectType("Texture") and region:GetTexture()=="Interface\\CharacterFrame\\Char-Paperdoll-Parts" then
			region:Hide()
		end
	end
end

hide_left_right(CharacterMainHandSlot)
hide_left_right(CharacterSecondaryHandSlot)

CharacterFrame.InsetRight.NineSlice:Hide()
CharacterFrame.InsetRight.Bg:Hide()
CharacterStatsPane.ClassBackground:SetAlpha(0)
CharacterModelFrame.BackgroundOverlay:Hide()
PaperDollInnerBorderTopLeft:Hide()
PaperDollInnerBorderTopRight:Hide()
PaperDollInnerBorderBottomLeft:Hide()
PaperDollInnerBorderBottomRight:Hide()
PaperDollInnerBorderLeft:Hide()
PaperDollInnerBorderRight:Hide()
PaperDollInnerBorderTop:Hide()
PaperDollInnerBorderBottom:Hide()
PaperDollInnerBorderBottom2:Hide()

local function hide_character_frame_tab(str)
	local _G = _G
	_G[str.."Left"]:SetAlpha(0)
	_G[str.."LeftDisabled"]:SetAlpha(0)
	_G[str.."Middle"]:SetAlpha(0)
	_G[str.."MiddleDisabled"]:SetAlpha(0)
	_G[str.."Right"]:SetAlpha(0)
	_G[str.."RightDisabled"]:SetAlpha(0)
end
hide_character_frame_tab("CharacterFrameTab1")
hide_character_frame_tab("CharacterFrameTab2")
hide_character_frame_tab("CharacterFrameTab3")
ReputationListScrollFrame:SetAlpha(0)
TokenFrameContainerScrollBar:SetAlpha(0)
PaperDollTitlesPaneScrollBar:SetAlpha(0)
PaperDollEquipmentManagerPaneScrollBar:SetAlpha(0)

local function skinbutton(v)
	v.Left:SetAlpha(0)
	v.Middle:SetAlpha(0)
	v.Right:SetAlpha(0)
end

skinbutton(PaperDollEquipmentManagerPaneSaveSet)
skinbutton(PaperDollEquipmentManagerPaneEquipSet)

for i=1,3 do
	_G["PaperDollSidebarTab"..i].TabBg:Hide()
end

ReputationDetailCorner:Hide()
ReputationDetailDivider:Hide()
local regions = {ReputationDetailFrame.Border:GetRegions()}

for i=1,#regions do
   local region = regions[i]
   if region:IsObjectType("Texture") then
      region:Hide()
   end
end
ReputationDetailFrame.Border.Bg:Show()
TokenFramePopupCorner:Hide()

for k,v in pairs(TokenFramePopup.Border) do
	if type(k) == "string" and (k:find("Edge") or k:find("Corner")) and type(v) == "table" then
		v:Hide()
	end
end

local function skin_checkbox(box)
	box:GetNormalTexture():SetTexCoord(0.3, 0.7, 0.3, 0.7)
	box:GetPushedTexture():SetTexCoord(0.3, 0.7, 0.3, 0.7)
	box:GetHighlightTexture():SetTexCoord(0.3, 0.7, 0.3, 0.7)
	box:GetCheckedTexture():SetTexCoord(0.2, 0.9, 0.1 ,0.9)
end

skin_checkbox(ReputationDetailAtWarCheckBox)
skin_checkbox(ReputationDetailInactiveCheckBox)
skin_checkbox(ReputationDetailMainScreenCheckBox)
--skin_checkbox(ReputationDetailLFGBonusReputationCheckBox)
skin_checkbox(TokenFramePopupInactiveCheckBox)
skin_checkbox(TokenFramePopupBackpackCheckBox)


local type = type
for k,v in pairs(CharacterModelFrame) do
	if type(k)=="string" and k:find("PaperDollInnerBorder") and type(v)=="table" then
		v:Hide()
	end
end

local QUI = LibStub("AceAddon-3.0"):GetAddon("QUI")

function QUI:PaperDollBgDesaturate()
	CharacterModelFrameBackgroundTopLeft:SetDesaturated(false)
	CharacterModelFrameBackgroundTopRight:SetDesaturated(false)
	CharacterModelFrameBackgroundBotLeft:SetDesaturated(false)
	CharacterModelFrameBackgroundBotRight:SetDesaturated(false)
end

QUI:SecureHook("PaperDollBgDesaturate")
