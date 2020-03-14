local BorderFrame = WorldMapFrame.BorderFrame
WorldMapFrame.BorderFrame.TitleBg:Hide()

WorldMapFrame.BorderFrame.NineSlice:Hide()
for k,v in pairs(WorldMapFrame.NavBar) do
   if type(k)=="string" and k:find("InsetBorder") then
      v:Hide()
   end
end
WorldMapFrame.BorderFrame:SetFrameStrata(WorldMapFrame:GetFrameStrata())
local texture = BorderFrame:CreateTexture(nil,"BACKGROUND")
texture:SetTexture(131071)
texture:SetAllPoints(BorderFrame)
WorldMapFrame.NavBar.overlay:Hide()
QuestMapFrame.QuestsFrame.DetailFrame:SetAlpha(0)
local regions = {WorldMapFrame.NavBar:GetRegions()}

for i=1,#regions do
	local region = regions[i]
	if region:IsObjectType("Texture") then
		region:Hide()
	end
end

QuestMapFrame.VerticalSeparator:Hide()

QuestScrollFrame.Background:SetAlpha(0)

QuestScrollFrame.Contents.Separator:Hide()

local regions = {WorldMapFrame:GetRegions()}

for i=1,#regions do
	local region = regions[i]
	if region:IsObjectType("Texture") then
		region:SetVertexColor(0,0,0,0)
	end
end

QuestScrollFrameScrollBar:SetAlpha(0)
QuestScrollFrame.Contents.Separator:SetAlpha(0)
QuestScrollFrame.Contents.WarCampaignHeader.Background:SetAlpha(0)
QuestScrollFrame.Contents.StoryHeader.Background:SetAlpha(0)

local function skinbutton(button)
	if button.Left then
	button.Left:SetAlpha(0)
	button.Middle:SetAlpha(0)
	button.Right:SetAlpha(0)
	button:SetNormalTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]])
	button:SetHighlightTexture([[Interface\DialogFrame\UI-DialogBox-Gold-Background]])
	end

end

local type = type

skinbutton(QuestMapFrame.DetailsFrame.BackButton)
for k,v in pairs(QuestMapFrame.DetailsFrame) do
	if type(k)=="string" and k:find("Button") and type(v)=="table" then
		skinbutton(v)
	end
end

local QUI = LibStub("AceAddon-3.0"):GetAddon("QUI")

WorldMapFrame.ScrollContainer:HookScript("OnEnter", function(...)
	QUI:SendMessage("QUI_WorldMapFrame_ScrollContainer_OnEnter",...)
end)

WorldMapFrame.ScrollContainer:HookScript("OnLeave", function(...)
	QUI:SendMessage("QUI_WorldMapFrame_ScrollContainer_OnLeave",...)
end)

local scrolltext = WorldMapFrame:CreateFontString(nil,nil,"GameFontNormalSmall")
scrolltext:SetPoint("TOP",WorldMapFrame,"BOTTOM")


local function cofunc(...)
	local running = coroutine.running()
	local function resume(...)
		QUI.resume(running,...)
	end
	QUI:RegisterMessage("QUI_WorldMapFrame_ScrollContainer_OnEnter",resume,1)
	QUI:RegisterMessage("QUI_WorldMapFrame_ScrollContainer_OnLeave",resume,0)
	local ticker = C_Timer.NewTicker(0.1,function()
		QUI.resume(running,1)
	end)
	local tag,event,arg1,arg2,arg3 = 1
	while true do
		if tag ~= 1 then
			break
		end
		local mapid = WorldMapFrame.mapID
		local position = mapid and C_Map.GetPlayerMapPosition(mapid, "player")
		local x,y = WorldMapFrame.ScrollContainer:GetNormalizedCursorPosition()
		if position then
			scrolltext:SetFormattedText("%.2f,%.2f %s:%.2f,%.2f",x*100,y*100,PLAYER,position.x*100,position.y*100)
		else
			scrolltext:SetFormattedText("%.2f,%.2f",x*100,y*100)
		end
		scrolltext:Show()
		tag,event,arg1,arg2,arg3 = coroutine.yield()
	end
	ticker:Cancel()
	QUI:UnregisterMessage("QUI_WorldMapFrame_ScrollContainer_OnLeave")
	QUI:RegisterMessage("QUI_WorldMapFrame_ScrollContainer_OnEnter")
	scrolltext:Hide()
end

function QUI:QUI_WorldMapFrame_ScrollContainer_OnEnter(...)
	coroutine.wrap(cofunc)(...)
end


QUI:RegisterMessage("QUI_WorldMapFrame_ScrollContainer_OnEnter")
