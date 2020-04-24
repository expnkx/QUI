HonorFrame.ConquestBar.Border:Hide()
HonorFrame.ConquestBar.Background:SetTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]])
ConquestFrame.ConquestBar.Border:Hide()
ConquestFrame.ConquestBar.Background:SetTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]])

HonorFrame.QueueButton.Left:SetAlpha(0)
HonorFrame.QueueButton.Middle:SetVertexColor(0,0,0,1)
HonorFrame.QueueButton.Right:SetAlpha(0)
HonorFrame.QueueButton:SetHighlightTexture("")
ConquestFrame.JoinButton.Left:SetAlpha(0)
ConquestFrame.JoinButton.Middle:SetVertexColor(0,0,0,1)
ConquestFrame.JoinButton.Right:SetAlpha(0)
ConquestFrame.JoinButton:SetHighlightTexture("")

HonorFrameTypeDropDownLeft:SetAlpha(0)
HonorFrameTypeDropDownMiddle:SetTexture("Interface\\Common\\Common-Input-Border")
HonorFrameTypeDropDownMiddle:SetHeight(20)
HonorFrameTypeDropDownMiddle:SetTexCoord(0.0625,0.9375,0.1,0.525)
HonorFrameTypeDropDownRight:SetAlpha(0)
local button = HonorFrameTypeDropDown.Button
button:GetNormalTexture():SetTexCoord(0.25,0.75,0.28,0.75)
button:GetDisabledTexture():SetTexCoord(0.25,0.75,0.28,0.75)
button:GetPushedTexture():SetTexCoord(0.25,0.75,0.28,0.75)
button:GetHighlightTexture():SetTexCoord(0.25,0.75,0.28,0.75)

local function skin_checkbox(box)
	box:GetNormalTexture():SetTexCoord(0.3, 0.7, 0.3, 0.7)
	box:GetPushedTexture():SetTexCoord(0.3, 0.7, 0.3, 0.7)
	box:GetHighlightTexture():SetTexCoord(0.3, 0.7, 0.3, 0.7)
	box:GetCheckedTexture():SetTexCoord(0.2, 0.9, 0.1 ,0.9)
	box:SetScale(0.7)
end

HonorFrame.TankIcon:SetPoint("BOTTOMLEFT",HonorFrame.Inset,"TOPLEFT",9,7)
skin_checkbox(HonorFrame.TankIcon.checkButton)
skin_checkbox(HonorFrame.HealerIcon.checkButton)
skin_checkbox(HonorFrame.DPSIcon.checkButton)

ConquestFrame.TankIcon:SetPoint("BOTTOMLEFT",ConquestFrame.Inset,"TOPLEFT",9,7)
skin_checkbox(ConquestFrame.TankIcon.checkButton)
skin_checkbox(ConquestFrame.HealerIcon.checkButton)
skin_checkbox(ConquestFrame.DPSIcon.checkButton)

local ConquestTooltip = ConquestTooltip

ConquestTooltip:SetBackdropColor(0,0,0,1)
ConquestTooltip:SetBackdropBorderColor(0,0,0,0)

local HonorInset = PVPQueueFrame.HonorInset

PVPQueueFrame.HonorInset.NineSlice:SetAlpha(0)

local regions = {HonorInset:GetRegions()}
regions[1]:SetTexture([[Interface\DialogFrame\UI-DialogBox-Background]])

regions[1]:Show()
regions[2]:SetAlpha(0)