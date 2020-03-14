local _G = _G
for i=2,4 do
	_G["WowLuaFrameBG"..i]:SetAlpha(0)
end


WowLuaFrameTopLeft:SetAlpha(0)
WowLuaFrameTopRight:SetAlpha(0)
WowLuaFrameBotLeft:SetAlpha(0)
WowLuaFrameBotRight:SetAlpha(0)
WowLuaFrameBotMiddle:SetAlpha(0)
WowLuaFrameMidLeft:SetAlpha(0)
WowLuaFrameMidRight:SetAlpha(0)

local regions = {WowLuaFrame:GetRegions()}
for i=1,#regions do
	local region = regions[i]
	if region:IsObjectType("Texture") and (region:GetTexture()=="Interface\\WorldStateFrame\\WorldStateFinalScoreFrame-Top" or region:GetTexture()=="Interface\\WorldStateFrame\\WorldStateFinalScoreFrame-TopLeft") then
		region:SetAlpha(0)
	end
end

WowLuaFrameResizeBar:SetAlpha(0)
WowLuaFrameResizeCorner:SetAlpha(0)

WowLuaFrameBG1:ClearAllPoints()
WowLuaFrameBG1:SetAllPoints()
WowLuaFrameBG1:SetTexture(131071)
WowLuaButton_Close:ClearAllPoints()
WowLuaButton_Close:SetPoint("TOPRIGHT")
WowLuaFrameTitle:ClearAllPoints()
WowLuaFrameTitle:SetPoint("TOP",0,-5)
WowLuaFrameDragHeader:ClearAllPoints()
WowLuaFrameDragHeader:SetPoint("TOPLEFT")
WowLuaFrameDragHeader:SetPoint("TOPRIGHT")
WowLuaFrameToolbar:ClearAllPoints()
WowLuaFrameToolbar:SetPoint("TOPLEFT",80,-30)
WowLuaFrameToolbar:SetPoint("TOPRIGHT",-5,-30)

local regions = {WowLuaFrameCommand:GetRegions()}
for i=1,#regions do
   local region = regions[i]
   if region:IsObjectType("Texture") then
      region:SetAlpha(0)
   end
end

local regions = {WowLuaFrameLineNumScrollFrame:GetRegions()}
for i=1,#regions do
   local region = regions[i]
   if region:IsObjectType("Texture") then
      region:SetAlpha(0)
   end
end

local buttons = {WowLuaButton_New,WowLuaButton_Open,WowLuaButton_Save,WowLuaButton_Undo,WowLuaButton_Redo,WowLuaButton_Delete,WowLuaButton_Lock,WowLuaButton_Unlock,WowLuaButton_Config,WowLuaButton_Previous,WowLuaButton_Next,WowLuaButton_Run}

for i=1,#buttons do
	local bi = buttons[i]
	bi:GetNormalTexture():SetTexCoord(0.1,0.9,0.15,0.9)
	bi:GetHighlightTexture():SetTexCoord(0.1,0.9,0.15,0.9)
	local disabled = bi:GetDisabledTexture()
	if disabled then
		disabled:SetTexCoord(0.1,0.9,0.15,0.9)
	end
end
