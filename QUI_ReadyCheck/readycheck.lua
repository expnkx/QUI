local regions = {ReadyCheckListenerFrame:GetRegions()}
for i=1,#regions do
	local region = regions[i]
	if region:IsObjectType("Texture") and region:GetTexture()=="Interface\\RaidFrame\\UI-ReadyCheckFrame" then
		region:SetTexture(131071)
	end
end

local function skinbutton(button)
	button.Left:SetAlpha(0)
	button.Middle:SetVertexColor(0,0,0,1)
	button.Right:SetAlpha(0)
	button:SetHighlightTexture("")
end

skinbutton(ReadyCheckFrameYesButton)
skinbutton(ReadyCheckFrameNoButton)
