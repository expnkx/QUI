MYSLOT_ReportFrame:SetBackdropBorderColor(0,0,0,0)
MYSLOT_ReportFrameHeaderTexture:SetAlpha(0)
MYSLOT_ReportFrameHeaderTexture:ClearAllPoints()
MYSLOT_ReportFrameHeaderTexture:SetPoint("TOP")
MYSLOT_ScrollFrameScrollBar:SetAlpha(0)

local buttons = {MYSLOT_ReportFrameCloseButton,MYSLOT_ReportFrameImportButton,MYSLOT_ReportFrameExportButton}
for i=1,#buttons do
	local v = buttons[i]
	v.Left:SetAlpha(0)
	v.Middle:SetAlpha(0)
	v.Right:SetAlpha(0)
	v:SetNormalTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]])
	v:SetHighlightTexture([[Interface\DialogFrame\UI-DialogBox-Gold-Background]])
end
