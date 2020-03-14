MerchantFrame.NineSlice:Hide()
MerchantFrame.Bg:SetTexture(131071)
MerchantFrame.TitleBg:SetTexture(131071)
MerchantFrame.TopTileStreaks:Hide()
MerchantFrameInset:Hide()

MerchantFrameTab1Left:SetAlpha(0)
MerchantFrameTab1Middle:SetAlpha(0)
MerchantFrameTab1Right:SetAlpha(0)
MerchantFrameTab1LeftDisabled:SetAlpha(0)
MerchantFrameTab1MiddleDisabled:SetAlpha(0)
MerchantFrameTab1RightDisabled:SetAlpha(0)

MerchantFrameTab2Left:SetAlpha(0)
MerchantFrameTab2Middle:SetAlpha(0)
MerchantFrameTab2Right:SetAlpha(0)
MerchantFrameTab2LeftDisabled:SetAlpha(0)
MerchantFrameTab2MiddleDisabled:SetAlpha(0)
MerchantFrameTab2RightDisabled:SetAlpha(0)

MerchantMoneyBg:SetAlpha(0)
MerchantExtraCurrencyBg:SetAlpha(0)
MerchantExtraCurrencyInset:SetAlpha(0)
MerchantMoneyInset:SetAlpha(0)

BuybackBG:SetAlpha(0)
MerchantFrameBottomLeftBorder:SetAlpha(0)
MerchantFrameBottomRightBorder:SetAlpha(0)



for i=1,BUYBACK_ITEMS_PER_PAGE do
	local button = _G["MerchantItem"..i.."ItemButton"]
	button.IconBorder:SetAlpha(0)
	button.icon:SetTexCoord(0.1,0.9,0.1,0.9)
	button:GetNormalTexture():SetAlpha(0)
	_G["MerchantItem"..i.."SlotTexture"]:SetAlpha(0)
	_G["MerchantItem"..i.."NameFrame"]:SetAlpha(0)
end

local button = MerchantBuyBackItemItemButton
button.IconBorder:SetAlpha(0)
button.icon:SetTexCoord(0.1,0.9,0.1,0.9)
button:GetNormalTexture():SetAlpha(0)
MerchantBuyBackItemSlotTexture:SetAlpha(0)
MerchantBuyBackItemNameFrame:SetAlpha(0)


MerchantFrameLootFilterLeft:SetAlpha(0)
MerchantFrameLootFilterMiddle:SetTexture("Interface\\Common\\Common-Input-Border")
MerchantFrameLootFilterMiddle:SetHeight(20)
MerchantFrameLootFilterMiddle:SetTexCoord(0.0625,0.9375,0.1,0.525)
MerchantFrameLootFilterRight:SetAlpha(0)
local button = MerchantFrameLootFilter.Button
button:GetNormalTexture():SetTexCoord(0.25,0.75,0.28,0.75)
button:GetDisabledTexture():SetTexCoord(0.25,0.75,0.28,0.75)
button:GetPushedTexture():SetTexCoord(0.25,0.75,0.28,0.75)
button:GetHighlightTexture():SetTexCoord(0.25,0.75,0.28,0.75)
