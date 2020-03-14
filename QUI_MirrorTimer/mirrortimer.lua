local _G = _G
for i=1,MIRRORTIMER_NUMTIMERS do
	_G["MirrorTimer"..i.."Border"]:SetAlpha(0)
	local statusbar = _G["MirrorTimer"..i.."StatusBar"]
	statusbar:SetStatusBarTexture("interface/buttons/white8x8")
	local text = _G["MirrorTimer"..i.."Text"]
	text:ClearAllPoints()
	text:SetPoint("TOP",statusbar,"TOP",0,0)
end
