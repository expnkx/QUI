for i=1,STATICPOPUP_NUMDIALOGS do
	for k,v in pairs(_G["StaticPopup"..i].Border) do
		if type(k)=="string" and (k:find("Corner") or k:find("Edge")) and type(v)=="table" then
			v:SetAlpha(0)
		end
	end
	for j=1,4 do
		local button = _G["StaticPopup"..i.."Button"..j]
		button:SetNormalTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]])
		button:SetHighlightTexture([[Interface\DialogFrame\UI-DialogBox-Gold-Background]])
		button:SetDisabledTexture("")
		button:SetPushedTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]])
	end
end
