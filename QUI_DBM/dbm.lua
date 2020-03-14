DBM_GUI_OptionsFrame:SetBackdropBorderColor(0,0,0,0)
DBM_GUI_OptionsFrameHeader:SetAlpha(0)
DBM_GUI_OptionsFrameHeader:ClearAllPoints()
DBM_GUI_OptionsFrameHeader:SetPoint("TOP")

local function skinbutton(button)
	button.Left:SetAlpha(0)
	button.Middle:SetVertexColor(0,0,0,1)
	button.Right:SetAlpha(0)
	button:SetHighlightTexture("")
end

skinbutton(DBM_GUI_OptionsFrameOkay)
skinbutton(DBM_GUI_OptionsFrameWebsiteButton)
