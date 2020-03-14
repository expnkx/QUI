ScriptErrorsFrameTopLeft:SetAlpha(0)
ScriptErrorsFrameTopRight:SetAlpha(0)
ScriptErrorsFrameTop:SetAlpha(0)
ScriptErrorsFrameBottomLeft:SetAlpha(0)
ScriptErrorsFrameBottomRight:SetAlpha(0)
ScriptErrorsFrameBottom:SetAlpha(0)
ScriptErrorsFrameLeft:SetAlpha(0)
ScriptErrorsFrameRight:SetAlpha(0)
ScriptErrorsFrameTitleBG:SetTexture(131071)
ScriptErrorsFrameDialogBG:SetTexture(131071)


local function skinbutton(button)
	button.Left:SetAlpha(0)
	button.Middle:SetVertexColor(0,0,0,1)
	button.Right:SetAlpha(0)
	button:SetHighlightTexture("")
end

ScriptErrorsFrameScrollBar:SetAlpha(0)

skinbutton(ScriptErrorsFrame.Reload)
skinbutton(ScriptErrorsFrame.Close)
