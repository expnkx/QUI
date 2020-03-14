TradeSkillFrame.NineSlice:Hide()
TradeSkillFrame.Bg:SetTexture(131071)
TradeSkillFrame.TitleBg:SetTexture(131071)
TradeSkillFrame.TopTileStreaks:Hide()
TradeSkillFrame.RecipeInset:Hide()

local function skin_tab(tab)
	tab.Left:SetAlpha(0)
	tab.Middle:SetAlpha(0)
	tab.Right:SetAlpha(0)
	tab.LeftDisabled:SetAlpha(0)
	tab.MiddleDisabled:SetAlpha(0)
	tab.RightDisabled:SetAlpha(0)
end

skin_tab(TradeSkillFrame.RecipeList.LearnedTab)
skin_tab(TradeSkillFrame.RecipeList.UnlearnedTab)
