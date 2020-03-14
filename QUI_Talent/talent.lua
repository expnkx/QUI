PlayerTalentFrame.NineSlice:Hide()
PlayerTalentFrame.Bg:SetTexture(131071)
PlayerTalentFrame.TitleBg:SetTexture(131071)
PlayerTalentFrame.TopTileStreaks:SetAlpha(0)
PlayerTalentFrameInset:Hide()

local _G = _G
for i=1,3 do
	_G["PlayerTalentFrameTab"..i.."Left"]:SetAlpha(0)
	_G["PlayerTalentFrameTab"..i.."Middle"]:SetAlpha(0)
	_G["PlayerTalentFrameTab"..i.."Right"]:SetAlpha(0)
	_G["PlayerTalentFrameTab"..i.."LeftDisabled"]:SetAlpha(0)
	_G["PlayerTalentFrameTab"..i.."MiddleDisabled"]:SetAlpha(0)
	_G["PlayerTalentFrameTab"..i.."RightDisabled"]:SetAlpha(0)
end

PlayerTalentFrameSpecialization.bg:SetAlpha(0)

local regions = {PlayerTalentFrameSpecialization:GetRegions()}
local type = type
for i=1,#regions do
	local region = regions[i]
	if region:IsObjectType("Texture") then
		region:SetAlpha(0)
	end
end

local regions = {PlayerTalentFrameSpecialization:GetChildren()}
for i=1,#regions do
	local region = regions[i]
	if region:IsObjectType("Frame") and not region:GetName()  then
		region:SetAlpha(0)
	end
end


PlayerTalentFrameSpecializationTLCorner:SetAlpha(0)
PlayerTalentFrameSpecializationTRCorner:SetAlpha(0)
PlayerTalentFrameSpecializationBLCorner:SetAlpha(0)
PlayerTalentFrameSpecializationBRCorner:SetAlpha(0)

for i=1,MAX_TALENT_TIERS do
	_G["PlayerTalentFrameTalentsTalentRow"..i.."Bg"]:SetAlpha(0)
	_G["PlayerTalentFrameTalentsTalentRow"..i.."LeftCap"]:SetAlpha(0)
	_G["PlayerTalentFrameTalentsTalentRow"..i.."RightCap"]:SetAlpha(0)
	local talentframe = PlayerTalentFrameTalents["tier"..i]
	for j=1,NUM_TALENT_COLUMNS do
		_G["PlayerTalentFrameTalentsTalentRow"..i.."Separator"..j]:SetAlpha(0)
		talentframe["talent"..j].icon:SetTexCoord(0.1,0.9,0.1,0.9)
		talentframe["talent"..j].Slot:SetAlpha(0)
	end
end

local regions = {PlayerTalentFrameTalents:GetRegions()}
for i=1,#regions do
	local region = regions[i]
	if region:IsObjectType("Texture") then
		region:SetAlpha(0)
	end
end

local regions = {PlayerTalentFrameTalentsPvpTalentFrame:GetRegions()}
for i=1,#regions do
	local region = regions[i]
	if region:IsObjectType("Texture") and region:GetTexture()=="Interface\\Common\\bluemenu-vert" then
		region:SetAlpha(0)
	end
end
PlayerTalentFrameTalentsPvpTalentFrameTLCorner:SetAlpha(0)
PlayerTalentFrameTalentsPvpTalentFrameTRCorner:SetAlpha(0)
PlayerTalentFrameTalentsPvpTalentFrameBLCorner:SetAlpha(0)
PlayerTalentFrameTalentsPvpTalentFrameBRCorner:SetAlpha(0)
