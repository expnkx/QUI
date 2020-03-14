CollectionsJournal.NineSlice:Hide()
CollectionsJournal.Bg:SetTexture(131071)
CollectionsJournal.TitleBg:SetTexture(131071)
CollectionsJournal.TopTileStreaks:Hide()

for i=1, 5 do
	local str = 'CollectionsJournalTab'..i
	_G[str.."Left"]:SetAlpha(0)
	_G[str.."LeftDisabled"]:SetAlpha(0)
	_G[str.."Middle"]:SetAlpha(0)
	_G[str.."MiddleDisabled"]:SetAlpha(0)
	_G[str.."Right"]:SetAlpha(0)
	_G[str.."RightDisabled"]:SetAlpha(0)
end
