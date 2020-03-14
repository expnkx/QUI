local alpha = 0.6
AuctionFrameTopLeft:SetVertexColor(0,0,0,alpha)
AuctionFrameTop:SetVertexColor(0,0,0,alpha)
AuctionFrameTopRight:SetVertexColor(0,0,0,alpha)
AuctionFrameBotLeft:SetVertexColor(0,0,0,alpha)
AuctionFrameBot:SetVertexColor(0,0,0,alpha)
AuctionFrameBotRight:SetVertexColor(0,0,0,alpha)

for i=1, 3 do
	local str = 'AuctionFrameTab'..i
	_G[str.."Left"]:SetAlpha(0)
	_G[str.."LeftDisabled"]:SetAlpha(0)
	_G[str.."Middle"]:SetAlpha(0)
	_G[str.."MiddleDisabled"]:SetAlpha(0)
	_G[str.."Right"]:SetAlpha(0)
	_G[str.."RightDisabled"]:SetAlpha(0)
end
