local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local AceLocale = LibStub("AceLocale-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local ControlPanel = AceAddon:GetAddon("ControlPanel")
local ControlPanel_Options = AceAddon:GetAddon("ControlPanel_Options")

local optionsFrames = {}

function ControlPanel_Options:OnInitialize()
	local options = ControlPanel_Options : get_table()

	options.args.profile = AceDBOptions:GetOptionsTable(ControlPanel.db)
	options.args.profile.order = -1
	AceConfig:RegisterOptionsTable("ControlPanel", options, nil)
	optionsFrames.general = AceConfigDialog:AddToBlizOptions("ControlPanel", "ControlPanel")
	ControlPanel.db.RegisterCallback(ControlPanel, "OnProfileChanged", "OnEnable")
	ControlPanel.db.RegisterCallback(ControlPanel, "OnProfileCopied", "OnEnable")
	ControlPanel.db.RegisterCallback(ControlPanel, "OnProfileReset", "OnEnable")
	ControlPanel.RegisterMessage(ControlPanel_Options,"CONTROL_PANEL_CHAT_COMMAND")
end

function ControlPanel_Options:CONTROL_PANEL_CHAT_COMMAND(message,input)
	if not input or input:trim() == "" then
		LibStub("AceConfigDialog-3.0"):Open("ControlPanel")
	else
		LibStub("AceConfigCmd-3.0"):HandleCommand("ControlPanel", "ControlPanel",input)
	end
end
