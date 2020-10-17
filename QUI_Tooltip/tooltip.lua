local QUI = LibStub("AceAddon-3.0"):GetAddon("QUI")

function QUI:SharedTooltip_SetBackdropStyle(obj,...)
	if not obj:IsForbidden() then
		obj:SetBackdropColor(0,0,0,1)
		obj:SetBackdropBorderColor(0,0,0,0)
	end
end

local type = type
for k,v in pairs(QueueStatusFrame) do
	if type(k)=="string" and k:find("Border") and type(v)=="table" then
		v:Hide()
	end
end

for k,v in pairs(QuestScrollFrame) do
	if type(k) == "string" and k:find("Tooltip") and type(v)=="table" then
		QUI:SharedTooltip_SetBackdropStyle(v)
	end
end

function QUI:SetUnitAura(obj, ...)
	if obj:IsForbidden() then return end
	local name, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID = UnitAura(...)
	local caster_name
	if caster then
		caster_name = UnitName(caster)
	end
	if caster_name then
		local localized_class,class = UnitClass(caster)
		if class then
			local classcolor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
			obj:AddDoubleLine(spellID,caster_name,0.5, 0.5, 0.8,classcolor.r,classcolor.g,classcolor.b)
		else
			obj:AddDoubleLine(spellID,caster_name,0.5, 0.5, 0.8)
		end
	else
		obj:AddLine(spellID,0.5, 0.5, 0.8)
	end
	obj:Show()
end

QUI:SecureHook(GameTooltip,"SetUnitAura")

function QUI:OnTooltipSetSpell(obj)
	if obj:IsForbidden() then return end
	local spellName,spellID = obj:GetSpell()
	if not spellID then return end
	spellID = tostring(spellID)
	local _G = _G
	for i=GameTooltip:NumLines(),1,-1 do
		if _G["GameTooltipTextLeft"..i]:GetText() == spellID then return end
	end
	obj:AddLine(spellID,0.5, 0.5, 0.8)
end

QUI:SecureHookScript(GameTooltip, "OnTooltipSetSpell")

local tooltips_frames = 
{
ItemRefTooltip,
ItemRefShoppingTooltip1,
ItemRefShoppingTooltip2,
AutoCompleteBox,
FriendsTooltip,
ShoppingTooltip1,
ShoppingTooltip2,
EmbeddedItemTooltip
}

for i=1,#tooltips_frames do
	QUI:SharedTooltip_SetBackdropStyle(tooltips_frames[i])
end


QUI:SecureHook("UIDropDownMenu_CreateFrames",function(level, index)
	QUI:SharedTooltip_SetBackdropStyle(_G["DropDownList"..level.."MenuBackdrop"])
end)

local ChatMenus =
{
ChatMenu,
EmoteMenu,
LanguageMenu,
VoiceMacroMenu
}

for i = 1, #ChatMenus do
	QUI:SecureHookScript(ChatMenus[i],"OnShow", "SharedTooltip_SetBackdropStyle")
end
QUI:SecureHook("SharedTooltip_SetBackdropStyle")
