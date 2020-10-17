local CRaidFrame = LibStub("AceAddon-3.0"):NewAddon("CRaidFrame","AceConsole-3.0","AceEvent-3.0")

function CRaidFrame:OnInitialize()
	local LSM = LibStub("LibSharedMedia-3.0")
	local nulltb = {}
	self.db = LibStub("AceDB-3.0"):New("CRaidFrameDB",
	{
		profile =
		{
			bottom = 370,
			left = 0,
			width = 90,
			height = 80,
			refresh_rate = 0.05,
			font_size = 12,
			resourcebar_length = 10,
			font = LSM:GetDefault("font"),
			statusbar = "Solid",
			background = LSM:GetDefault("background"),
			border = "None",
			border_size = 0,
			bindings = {{"type1","target"},{"type2","togglemenu"}},
			self_buff = nulltb,
			buffs = 5,
			debuffs = 5,
			[1] = nulltb,
			[2] = nulltb
		}
	})
	local LibDualSpec = LibStub('LibDualSpec-1.0',true)
	if LibDualSpec == nil then
		LoadAddOn('LibDualSpec-1.0')
		LibDualSpec = LibStub('LibDualSpec-1.0')
	end
	LibDualSpec:EnhanceDatabase(self.db, "CRaidFrame")
	self:RegisterChatCommand("CRaidFrame", "ChatCommand")
	self:RegisterChatCommand("CRF", "ChatCommand")
--	self:RegisterEvent("GROUP_ROSTER_UPDATE")
--	self:RegisterEvent("PLAYER_REGEN_ENABLED","GROUP_ROSTER_UPDATE")
	local LoadAddOn = LoadAddOn
	local class = select(2,UnitClass("player"))
	for i = 1, GetNumAddOns() do
		local metadata = GetAddOnMetadata(i, "X-CRF")
		if metadata and (metadata == "1" or metadata == class) then
			LoadAddOn(i)
		end
		local event = GetAddOnMetadata(i, "X-CRF-EVENT")
		if event then
			self:RegisterEvent(event,"loadevent",i)
		end
		local message = GetAddOnMetadata(i,"X-CRF-MESSAGE")
		if message then
			self:RegisterMessage(message,"loadevent",i)
		end
	end
end

function CRaidFrame:loadevent(p,event,...)
	self:UnregisterEvent(event)
	self:UnregisterMessage(event)
	LoadAddOn(p)
	if IsAddOnLoaded(p) then
		local addon = GetAddOnInfo(p)
		local a = LibStub("AceAddon-3.0"):GetAddon(addon)
		a[event](a,event,...)
		return true
	end
end

function CRaidFrame:ChatCommand(input)
	self:SendMessage("CRF_ChatCommand",input)
end
