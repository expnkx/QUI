hooksecurefunc("ChallengesFrame_Update", function(self)
	local icons = self.DungeonIcons
	for i=1,#icons do
		icons[i]:GetRegions():SetAlpha(0)
	end
end)