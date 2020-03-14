FriendsFrame.NineSlice:Hide()
FriendsFrame.Bg:SetTexture(131071)
FriendsFrame.TitleBg:SetTexture(131071)
FriendsFrame.TopTileStreaks:SetAlpha(0)
FriendsFrameInset:SetAlpha(0)

for i=1,4 do
	_G["FriendsFrameTab"..i.."Left"]:SetAlpha(0)
	_G["FriendsFrameTab"..i.."Middle"]:SetAlpha(0)
	_G["FriendsFrameTab"..i.."Right"]:SetAlpha(0)
	_G["FriendsFrameTab"..i.."LeftDisabled"]:SetAlpha(0)
	_G["FriendsFrameTab"..i.."MiddleDisabled"]:SetAlpha(0)
	_G["FriendsFrameTab"..i.."RightDisabled"]:SetAlpha(0)
end

for i=1,3 do
	_G["FriendsTabHeaderTab"..i.."Left"]:SetAlpha(0)
	_G["FriendsTabHeaderTab"..i.."Middle"]:SetAlpha(0)
	_G["FriendsTabHeaderTab"..i.."Right"]:SetAlpha(0)
	_G["FriendsTabHeaderTab"..i.."LeftDisabled"]:SetAlpha(0)
	_G["FriendsTabHeaderTab"..i.."MiddleDisabled"]:SetAlpha(0)
	_G["FriendsTabHeaderTab"..i.."RightDisabled"]:SetAlpha(0)
end



local function skinbutton(button)
	button.Left:SetAlpha(0)
	button.Middle:SetVertexColor(0,0,0,1)
	button.Right:SetAlpha(0)
	button:SetHighlightTexture("")
end

skinbutton(FriendsFrameSendMessageButton)
skinbutton(FriendsFrameAddFriendButton)
skinbutton(WhoFrameWhoButton)
skinbutton(WhoFrameAddFriendButton)
skinbutton(WhoFrameGroupInviteButton)
skinbutton(RaidFrameConvertToRaidButton)
skinbutton(RaidFrameRaidInfoButton)
skinbutton(RaidFrameRaidInfoButton)
skinbutton(QuickJoinFrame.JoinQueueButton)
WhoFrameEditBoxInset:SetAlpha(0)

WhoFrameListInset:SetAlpha(0)
