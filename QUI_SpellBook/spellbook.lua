SpellBookFrame.NineSlice:Hide()
SpellBookFrameInset:Hide()
SpellBookFrame.Bg:SetTexture(131071)
SpellBookFrame.TitleBg:SetTexture(131071)
SpellBookFrame.TopTileStreaks:Hide()
SpellBookPage1:Hide()
SpellBookPage2:Hide()

local _G = _G
for i=1,SPELLS_PER_PAGE do
	local button=_G["SpellButton"..i]
	button.IconTextureBg:SetTexCoord(0.1,0.9,0.1,0.9)
	_G["SpellButton"..i.."IconTexture"]:SetTexCoord(0.1,0.9,0.1,0.9)
	button.TextBackground:Hide()
	button.TextBackground2:Hide()
end


SpellBookFrameTabButton1Left:SetAlpha(0)
SpellBookFrameTabButton1Middle:SetAlpha(0)
SpellBookFrameTabButton1Right:SetAlpha(0)
SpellBookFrameTabButton1LeftDisabled:SetAlpha(0)
SpellBookFrameTabButton1MiddleDisabled:SetAlpha(0)
SpellBookFrameTabButton1RightDisabled:SetAlpha(0)

SpellBookFrameTabButton2Left:SetAlpha(0)
SpellBookFrameTabButton2Middle:SetAlpha(0)
SpellBookFrameTabButton2Right:SetAlpha(0)
SpellBookFrameTabButton2LeftDisabled:SetAlpha(0)
SpellBookFrameTabButton2MiddleDisabled:SetAlpha(0)
SpellBookFrameTabButton2RightDisabled:SetAlpha(0)

for i=1,8 do
	local tab = _G["SpellBookSkillLineTab"..i]
	local regions = {tab:GetRegions()}
	for j=1,#regions do
		local region = regions[j]
		if region:IsObjectType("Texture") and region:GetTexture()=="Interface\\SpellBook\\SpellBook-SkillLineTab" then
			region:SetAlpha(0)
		end
	end
	tab:GetNormalTexture():SetTexCoord(0.1,0.9,0.1,0.9)
	tab:GetHighlightTexture():SetTexCoord(0.1,0.9,0.1,0.9)
	_G["SpellBookSkillLineTab"..i.."TabardEmblem"]:SetAlpha(0)
end

local function skin_button(box)
	box:GetNormalTexture():SetTexCoord(0.22, 0.7, 0.28, 0.7)
	box:GetPushedTexture():SetTexCoord(0.22, 0.7, 0.28, 0.7)
	box:GetHighlightTexture():SetTexCoord(0.22, 0.7, 0.28, 0.7)
	box:GetDisabledTexture():SetTexCoord(0.22, 0.7, 0.28 ,0.7)
end

skin_button(SpellBookPrevPageButton)
skin_button(SpellBookNextPageButton)
