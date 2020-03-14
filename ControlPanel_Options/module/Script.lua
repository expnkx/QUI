local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local AceLocale = LibStub("AceLocale-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local ControlPanel = AceAddon:GetAddon("ControlPanel")
local ControlPanel_Options = AceAddon:GetAddon("ControlPanel_Options")
local L = AceLocale:GetLocale("ControlPanel_Options")
local string_format = string.format

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

local Script

function ControlPanel_Options:CreateScript(o)
	if Script == nil then
		Script =
		{
			name = L["Script"],
			type = "group",
			order = o,
			args =
			{
				scriptErrors =
				{
					order = get_order(),
					name = SHOW_LUA_ERRORS,
					type = "toggle",
					set = function(info,val)
						ControlPanel:SetCVarInstance(info[1],"scriptErrors",val)
					end,
					get = function(info)
						return ControlPanel:GetCVarBoolInstance(info[1],"scriptErrors")
					end,
					width = "full",
				},
				scriptWarnings =
				{
					order = get_order(),
					name = L["Display Lua Warnings"],
					type = "toggle",
					set = function(info,val)
						ControlPanel:SetCVarInstance(info[1],"scriptWarnings",val)
					end,
					get = function(info)
						return ControlPanel:GetCVarBoolInstance(info[1],"scriptWarnings")
					end,
					width = "full",
				},
				scriptProfile =
				{
					order = get_order(),
					name = L["Script Profile"],
					desc = L["CPU profiling is disabled by default since it has some overhead. CPU profiling is controlled by this option."],
					type = "toggle",
					set = function(info,val)
						ControlPanel:SetCVarInstance(info[1],"scriptProfile",val)
					end,
					get = function(info)
						return ControlPanel:GetCVarBoolInstance(info[1],"scriptProfile")
					end,
					width = "full",
				},
				worldPreloadNonCritical =
				{
					order = get_order(),
					name = L["World Preload Non Critical"],
					desc = L["Disable it to solve very long loading screens"],
					type = "toggle",
					set = function(info,val)
						ControlPanel:SetCVarInstance(info[1],"worldPreloadNonCritical",val)
					end,
					get = function(info)
						return ControlPanel:GetCVarBoolInstance(info[1],"worldPreloadNonCritical")
					end,
					width = "full",
				},
				casttimingenhancements =
				{
					order = get_order(),
					name = L["Cast Timing Enhancements"],
					type = "toggle",
					width = "full",
					set = function(info,val)
						ControlPanel:SetCVarInstance(info[1],"casttimingenhancements",val)
					end,
					get = function(info)
						return ControlPanel:GetCVarBoolInstance(info[1],"casttimingenhancements")
					end
				},
				spellqueuewindow=
				{
					order = get_order(),
					name = function(info) return string_format(REDUCED_LAG_TOLERANCE,ControlPanel:GetCVarNumberInstance(info[1],"spellqueuewindow")) end,
					desc = OPTION_TOOLTIP_REDUCED_LAG_TOLERANCE,
					min = 0,
					max = 400,
					type = "range",
					width = "full",
					set = function(info,val)
						ControlPanel:SetCVarInstance(info[1],"spellqueuewindow",val)
					end,
					get = function(info)
						return ControlPanel:GetCVarNumberInstance(info[1],"spellqueuewindow")
					end,
				},
				taintLog =
				{
					order = get_order(),
					name = "taintLog",
					type = "range",
					min = 0,
					max = 2,
					step = 1,
					set = function(info,val)
						ControlPanel:SetCVarInstance(info[1],"taintLog",val)
					end,
					get = function(info)
						return ControlPanel:GetCVarNumberInstance(info[1],"taintLog")
					end,
					width = "full",
				},
			}
		}
	end
	return Script
end
