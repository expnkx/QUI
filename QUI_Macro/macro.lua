MacroFrame.NineSlice:Hide()
MacroFrame.Bg:SetTexture(131071)
MacroFrame.TitleBg:SetTexture(131071)
MacroFrame.TopTileStreaks:SetAlpha(0)
MacroFrameInset:Hide()

MacroHorizontalBarLeft:SetAlpha(0)

local regions = {MacroFrame:GetRegions()}
for i=1,#regions do
	local region = regions[i]
	if region:IsObjectType("Texture") and region:GetTexture()=="Interface\\ClassTrainerFrame\\UI-ClassTrainer-HorizontalBar" then
		region:SetAlpha(0)
	end
end


local _G = _G
for i=1,2 do
	_G["MacroFrameTab"..i.."Left"]:SetAlpha(0)
	_G["MacroFrameTab"..i.."Middle"]:SetAlpha(0)
	_G["MacroFrameTab"..i.."Right"]:SetAlpha(0)
	_G["MacroFrameTab"..i.."LeftDisabled"]:SetAlpha(0)
	_G["MacroFrameTab"..i.."MiddleDisabled"]:SetAlpha(0)
	_G["MacroFrameTab"..i.."RightDisabled"]:SetAlpha(0)
end

local function skinmacrobutton(macroButtonName)
	local macroButton = _G[macroButtonName]
	local macroName = _G[macroButtonName.."Name"]
	_G[macroButtonName.."Icon"]:SetTexCoord(0.1,0.9,0.1,0.9)
	local regions = {macroButton:GetRegions()}
	for i=1,#regions do 
		local region = regions[i]
		if region:IsObjectType("Texture") and region:GetTexture()=="Interface\\Buttons\\UI-EmptySlot-Disabled" then
			region:SetAlpha(0)
		end
	end
end

for i=1, max(MAX_ACCOUNT_MACROS, MAX_CHARACTER_MACROS) do
	skinmacrobutton("MacroButton"..i)
end

skinmacrobutton("MacroFrameSelectedMacroButton")

MacroFrameSelectedMacroBackground:SetAlpha(0)

MacroButtonScrollFrameTop:SetAlpha(0)
MacroButtonScrollFrameMiddle:SetAlpha(0)
MacroButtonScrollFrameBottom:SetAlpha(0)
MacroButtonScrollFrameScrollBar:SetAlpha(0)

local function skinbutton(button)
	button.Left:SetAlpha(0)
	button.Middle:SetVertexColor(0,0,0,1)
	button.Right:SetAlpha(0)
	button:SetHighlightTexture("")
end

skinbutton(MacroEditButton)
skinbutton(MacroCancelButton)
skinbutton(MacroSaveButton)
skinbutton(MacroDeleteButton)
skinbutton(MacroNewButton)
skinbutton(MacroExitButton)

MacroFrameTextBackground:SetAlpha(0)
MacroPopupFrame.BorderBox:SetAlpha(0)
