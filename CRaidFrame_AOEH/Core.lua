local CRaidFrame_AOEH = LibStub("AceAddon-3.0"):NewAddon("CRaidFrame_AOEH","AceEvent-3.0")
CRaidFrame_AOEH:RegisterMessage("CRFNew",function(_,frame,profile,create_cooldown)
	frame.aoeh = create_cooldown(frame[2])
end)
CRaidFrame_AOEH:RegisterMessage("CRFCfg",function(_,frame,profile)
	local aoeh = frame.aoeh
	local statusbar = frame[2]
	local mn = min(profile.height,profile.width) / 4
	aoeh:ClearAllPoints()
	if profile.vertical then
		aoeh:SetPoint("TOP",statusbar,"TOP")
	else
		aoeh:SetPoint("LEFT",statusbar,"LEFT")
	end
	aoeh:SetSize(mn,mn)
end)
