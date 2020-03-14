GossipFrame.NineSlice:Hide()
GossipFrameInset:Hide()
GossipFrame.Bg:SetTexture(131071)
GossipFrame.TitleBg:SetTexture(131071)
GossipFrame.TopTileStreaks:Hide()
GossipGreetingScrollFrameTop:SetAlpha(0)
GossipGreetingScrollFrameMiddle:SetAlpha(0)
GossipGreetingScrollFrameBottom:SetAlpha(0)
GossipGreetingScrollFrameScrollBar:SetAlpha(0)


local function skinbutton(button)
	button.Left:SetAlpha(0)
	button.Middle:SetAlpha(0)
	button.Right:SetAlpha(0)
	button:SetNormalTexture([[Interface\DialogFrame\UI-DialogBox-Background-Dark]])
	button:SetHighlightTexture("")
end

skinbutton(GossipFrameGreetingGoodbyeButton)

QuestFrame.NineSlice:Hide()
QuestFrameInset:Hide()
QuestFrame.Bg:SetTexture(131071)
QuestFrame.TitleBg:SetTexture(131071)
QuestFrame.TopTileStreaks:Hide()


skinbutton(QuestFrameCompleteQuestButton)
skinbutton(QuestFrameGoodbyeButton)
skinbutton(QuestFrameCompleteButton)
skinbutton(QuestFrameDeclineButton)
skinbutton(QuestFrameAcceptButton)
skinbutton(QuestFrameGreetingGoodbyeButton)

local function skinscrollframe(frame)
	local name = frame:GetName()
	_G[name.."Top"]:SetAlpha(0)
	_G[name.."Middle"]:SetAlpha(0)
	_G[name.."Bottom"]:SetAlpha(0)
	_G[name.."ScrollBar"]:SetAlpha(0)
end

skinscrollframe(QuestRewardScrollFrame)
skinscrollframe(QuestDetailScrollFrame)
skinscrollframe(QuestGreetingScrollFrame)
--skinscrollframe(QuestNPCModelTextScrollFrame)
