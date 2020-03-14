local QUI = LibStub("AceAddon-3.0"):GetAddon("QUI")
local last_buff,last_debuff = 0,0

QUI:RegisterEvent("UNIT_AURA",function(event,unit)
	if unit == PlayerFrame.unit then
		local _G = _G
		for i = last_buff+1, BUFF_ACTUAL_DISPLAY do
			_G["BuffButton"..i.."Icon"]:SetTexCoord(0.1,0.9,0.1,0.9)
		end
		last_buff=BUFF_ACTUAL_DISPLAY
		for i = last_debuff+1, DEBUFF_ACTUAL_DISPLAY do
			_G["DebuffButton"..i.."Icon"]:SetTexCoord(0.1,0.9,0.1,0.9)
		end
		last_debuff=DEBUFF_ACTUAL_DISPLAY
	end
end)
