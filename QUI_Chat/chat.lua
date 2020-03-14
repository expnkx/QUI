local function skinbutton(button)
	button:SetSize(22,22)
	local normaltexture = button:GetNormalTexture()
	normaltexture:SetTexCoord(0.22,0.75,0.25,0.75)
	local highlighttexture = button:GetHighlightTexture()
	highlighttexture:SetTexCoord(0.22,0.75,0.25,0.75)
	local pushedtexture = button:GetPushedTexture()
	pushedtexture:SetTexCoord(0.22,0.75,0.25,0.75)
end

local _G = _G

for i=1,10 do
	local t =_G["ChatFrame"..i.."Tab"]
	t.leftTexture:SetAlpha(0)
	t.middleTexture:SetAlpha(0)
	t.rightTexture:SetAlpha(0)
	t.leftSelectedTexture:SetAlpha(0)
	t.middleSelectedTexture:SetAlpha(0)
	t.rightSelectedTexture:SetAlpha(0)
	_G["ChatFrame"..i.."EditBoxLeft"]:SetAlpha(0)
	_G["ChatFrame"..i.."EditBoxRight"]:SetAlpha(0)
	_G["ChatFrame"..i.."EditBoxMid"]:SetAlpha(0)
	_G["ChatFrame"..i.."EditBoxFocusLeft"]:SetAlpha(0)
	_G["ChatFrame"..i.."EditBoxFocusRight"]:SetAlpha(0)
	_G["ChatFrame"..i.."EditBoxFocusMid"]:SetAlpha(0)
	_G["ChatFrame"..i.."EditBox"]:SetAltArrowKeyMode(false)
end
skinbutton(ChatFrameMenuButton)
skinbutton(ChatFrameChannelButton)
skinbutton(ChatFrameToggleVoiceDeafenButton)
skinbutton(ChatFrameToggleVoiceMuteButton)
QuickJoinToastButton:Hide()
QuickJoinToastButton:UnregisterAllEvents()