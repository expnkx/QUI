local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local AceLocale = LibStub("AceLocale-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local ControlPanel = AceAddon:GetAddon("ControlPanel")
local ControlPanel_Options = AceAddon:GetAddon("ControlPanel_Options")
local L = AceLocale:GetLocale("ControlPanel_Options")
local get_cvar_bool = ControlPanel_Options.get_cvar_bool
local string_format = string.format

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

local Network

function ControlPanel_Options:CreateNetwork(o)
	if Network == nil then
		Network =
		{
			name = NETWORK_LABEL,
			type = "group",
			order = o,
			args =
			{
				disableServerNagle = 
				{
					order = get_order(),
					name = OPTIMIZE_NETWORK_SPEED,
					desc = OPTION_TOOLTIP_OPTIMIZE_NETWORK_SPEED,
					type = "toggle",
					set = function(info,val)
						ControlPanel:SetCVarInstance(info[1],"disableServerNagle",val)
					end,
					get = function(info)
						return ControlPanel:GetCVarBoolInstance(info[1],"disableServerNagle")
					end,
					width = "full",
				},
				useIPv6 =
				{
					order = get_order(),
					name = USEIPV6,
					desc = OPTION_TOOLTIP_USEIPV6,
					type = "toggle",
					set = function(info,val)
						ControlPanel:SetCVarInstance(info[1],"useIPv6",val)
					end,
					get = function(info)
						return ControlPanel:GetCVarBoolInstance(info[1],"useIPv6")
					end,
					width = "full",
				},
				advancedCombatLogging =
				{
					order = get_order(),
					name = ADVANCED_COMBAT_LOGGING,
					desc = OPTION_TOOLTIP_ADVANCED_COMBAT_LOGGING,
					type = "toggle",
					set = function(info,val)
						ControlPanel:SetCVarInstance(info[1],"advancedCombatLogging",val)
					end,
					get = function(info)
						return ControlPanel:GetCVarBoolInstance(info[1],"advancedCombatLogging")
					end,
					width = "full",
				},
			}
		}
	end
	return Network
end
