local Header = GameMenuFrame.Header
Header:SetPoint("TOP",0,-3)
Header.LeftBG:Hide()
Header.CenterBG:Hide()
Header.RightBG:Hide()
local type = type
GameMenuFrame.Border.Bg:SetVertexColor(0,0,0,0.4)
for k,v in pairs(GameMenuFrame.Border) do
	if type(k)=="string" and type(v)=="table" and (k:find("Edge") or k:find("Corner")) then
		v:Hide()
	end
end

local buttons = {GameMenuButtonHelp,GameMenuButtonStore,GameMenuButtonWhatsNew,GameMenuButtonOptions,GameMenuButtonUIOptions,GameMenuButtonKeybindings,
GameMenuButtonMacros,GameMenuButtonAddons,GameMenuButtonRatings,GameMenuButtonLogout,GameMenuButtonQuit,GameMenuButtonContinue}

for i=1,#buttons do
	local v = buttons[i]
	v.Left:SetAlpha(0)
	v.Middle:SetAlpha(0)
	v.Right:SetAlpha(0)
	v:SetNormalTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]])
	v:SetHighlightTexture([[Interface\DialogFrame\UI-DialogBox-Gold-Background]])
end
