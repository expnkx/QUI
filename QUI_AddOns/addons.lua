AddonList.NineSlice:Hide()
AddonList.Bg:SetTexture(131071)
AddonList.TitleBg:SetTexture(131071)
AddonList.TopTileStreaks:Hide()
AddonListScrollFrame:SetAlpha(0)
AddonListInset:Hide()

local type = type
for k,v in pairs(AddonList) do
	if type(k) == "string" and k~="CloseButton" and k:find("Button") and type(v) == "table" then
		local regions = {v:GetRegions()}
		for i=1,#regions do
			local region = regions[i]
			if region:IsObjectType("Texture") then
				region:SetAlpha(0)
			end
		end
		v:SetNormalTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]])
		v:SetHighlightTexture([[Interface\DialogFrame\UI-DialogBox-Gold-Background]])
	end
end

local function skin_checkbox(box)
	box:GetNormalTexture():SetTexCoord(0.3, 0.7, 0.3, 0.7)
	box:GetPushedTexture():SetTexCoord(0.3, 0.7, 0.3, 0.7)
	box:GetHighlightTexture():SetTexCoord(0.3, 0.7, 0.3, 0.7)
	box:GetCheckedTexture():SetTexCoord(0.2, 0.9, 0.1 ,0.9)
end
skin_checkbox(AddonListForceLoad)

for i=1,MAX_ADDONS_DISPLAYED do
	skin_checkbox(_G["AddonListEntry"..i.."Enabled"])
end

AddonCharacterDropDownLeft:SetAlpha(0)
AddonCharacterDropDownMiddle:SetTexture("Interface\\Common\\Common-Input-Border")
AddonCharacterDropDownMiddle:SetHeight(20)
AddonCharacterDropDownMiddle:SetTexCoord(0.0625,0.9375,0.1,0.525)
AddonCharacterDropDownRight:SetAlpha(0)
local button = AddonCharacterDropDown.Button
button:GetNormalTexture():SetTexCoord(0.25,0.75,0.28,0.75)
button:GetDisabledTexture():SetTexCoord(0.25,0.75,0.28,0.75)
button:GetPushedTexture():SetTexCoord(0.25,0.75,0.28,0.75)
button:GetHighlightTexture():SetTexCoord(0.25,0.75,0.28,0.75)
