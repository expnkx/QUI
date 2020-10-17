local QUI = LibStub("AceAddon-3.0"):NewAddon("QUI","AceEvent-3.0","AceConsole-3.0","AceHook-3.0")

QUI.UIHider = CreateFrame("Frame")
QUI.UIHider:Hide()
QUI[1] = {}

function QUI:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("QUIDB",{profile = {}},true)
	local LibDualSpec = LibStub('LibDualSpec-1.0',true)
	if LibDualSpec == nil then
		LoadAddOn('LibDualSpec-1.0')
		LibDualSpec = LibStub('LibDualSpec-1.0')
	end
	LibDualSpec:EnhanceDatabase(self.db, "QUI")
	self:RegisterChatCommand("QUI", "ChatCommand")

	self:RegisterEvent("ADDON_LOADED")
	local lods = {}
	local GetAddOnMetadata = GetAddOnMetadata
	for i=1,GetNumAddOns() do
		local conflict = GetAddOnMetadata(i,"X-QUI-CONFLICT")
		if conflict and not IsAddOnLoaded(conflict) then
			LoadAddOn(i)
		end
		local meta = GetAddOnMetadata(i,"X-QUI-LOD")
		if meta then
			local addon, title, notes, enabled, loadable, reason, security = GetAddOnInfo(i)
			if loadable == "DEMAND_LOADED" then
				lods[meta] = i
			end
		end
	end
	if next(lods) then
		QUI.lods = lods
		QUI:RegisterEvent("ADDON_LOADED")
	else
		QUI.ADDON_LOADED = nil
	end
	QUI.OnInitialize = nil
end

function QUI:ChatCommand(input)
end

function QUI:ADDON_LOADED(event,addon,...)
	local lods = QUI.lods
	local index = QUI.lods[addon]
	if not index then return end
	LoadAddOn(index)
	lods[addon] = nil
	if next(lods) == nil then
		QUI:UnregisterEvent("ADDON_LOADED")
		QUI.ADDON_LOADED = nil
	end
end

function QUI.resume(current,...)
	local current_status = coroutine.status(current)
	if current_status =="suspended" then
		local status, msg = coroutine.resume(current,...)
		if not status then
			QUI:Print(msg)
		end
		return status,msg
	end
	return current_status
end
