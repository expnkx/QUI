local function skinframe(str)
	local frame = _G[str]
	local header = _G[str.."Header"]
	header:SetAlpha(0)
	local header_text = _G[str.."HeaderText"]
	header_text:ClearAllPoints()
	_G[str.."HeaderText"]:SetPoint("TOP",frame,"TOP",0,-15)
	for k,v in pairs(frame.Border) do
		if type(k)=="string" and type(v)=="table" and (k:find("Edge") or k:find("Corner")) then
			v:SetAlpha(0)
		end
	end
end

skinframe("VideoOptionsFrame")
skinframe("InterfaceOptionsFrame")
