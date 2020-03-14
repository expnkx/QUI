local QUI = LibStub("AceAddon-3.0"):GetAddon("QUI")
local minimap = QUI:NewModule("Minimap","AceEvent-3.0")
Minimap:SetMaskTexture('Interface\\ChatFrame\\ChatFrameBackground')
MinimapBorder:Hide()
MinimapBorderTop:Hide()
MiniMapWorldMapButton:Hide()
MinimapNorthTag:SetParent(QUI.UIHider)
GameTimeFrame:SetParent(QUI.UIHider)

MinimapZoomIn:SetAlpha(0)
MinimapZoomIn:SetScale(0.0001)
MinimapZoomIn:SetParent(QUI.UIHider)
MinimapZoomOut:SetAlpha(0)
MinimapZoomOut:SetScale(0.0001)
MinimapZoomOut:SetParent(QUI.UIHider)

Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel",function(self,val,...)
	local zoom = Minimap:GetZoom() + val
	if zoom + val < 0 or Minimap:GetZoomLevels() < zoom then
		return
	end
	Minimap:SetZoom(zoom)
end)

GarrisonLandingPageMinimapButton:ClearAllPoints()
GarrisonLandingPageMinimapButton:SetPoint("BOTTOMLEFT",Minimap,"BOTTOMLEFT",-20,-46)
GarrisonLandingPageMinimapButton:SetScale(0.7)

function GetMinimapShape() return 'SQUARE' end

function minimap:OnEnable()
	TimeManagerClockButton:SetParent(QUI.UIHider)
	self.OnEnable = nil
end

local coordinates = Minimap:CreateFontString(nil,nil,"GameFontNormalSmall")
minimap.coordinates = coordinates
coordinates:SetPoint("TOP",Minimap,"BOTTOM")

local SetFormattedText = coordinates.SetFormattedText
local SetText = coordinates.SetText

C_Timer.NewTicker(1,function()
	local x,y=UnitPosition("player")
	if x and y then
		SetFormattedText(coordinates,"%.1f,%.1f",x,y)
	else
		SetText(coordinates,"")
	end
end)
