local KeyBindingFrame = KeyBindingFrame
for k,v in pairs(KeyBindingFrame.BG) do
	if type(k)=="string" and type(v)=="table" and (k:find("Edge") or k:find("Corner")) then
		v:SetAlpha(0)
	end
end

local header = KeyBindingFrame.header
header:SetAlpha(0)

local text = header.text
text:ClearAllPoints()
text:SetParent(KeyBindingFrame)
text:SetPoint("TOP",0,-15)
