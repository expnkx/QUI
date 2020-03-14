local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local AceLocale = LibStub("AceLocale-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local ControlPanel = AceAddon:GetAddon("ControlPanel")
local ControlPanel_Options = AceAddon:GetAddon("ControlPanel_Options")
local L = AceLocale:GetLocale("ControlPanel_Options")
local pairs = pairs
local tostring = tostring
local wipe = wipe
local tb = {}

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

local function cvars_values(info)
	local tt = ControlPanel.db.profile[info[1]]
	if tt then
		wipe(tb)
		local k,v
		for k,v in pairs(ControlPanel.db.profile[info[1]]) do
			tb[k] = k.." : "..tostring(v)
		end
		return tb
	end
end

local Custom
local cvar_name


function ControlPanel_Options:CreateCustom(o)
	if Custom == nil then
		Custom =
		{
			name = CUSTOM,
			type = "group",
			order = o,
			args =
			{
				get_cvar =
				{
					name = "GetCVar",
					type = "input",
					order = get_order(),
					set = function(info,val)
						if val == "" then
							cvar_name = nil
						else
							cvar_name = val
						end
					end,
					get = function(info)
						if cvar_name ~= nil then
							return cvar_name
						end
					end
				},
				set_cvar =
				{
					name = "SetCVar",
					type = "input",
					order = get_order(),
					set = function(info,val)
						if cvar_name ~= nil then
							return ControlPanel:SetCVarInstance(info[1],cvar_name,val)
						end
					end,
					get = function(info)
						if cvar_name ~= nil then
							return ControlPanel:GetCVarInstance(info[1],cvar_name)
						end
					end
				},
				Remove =
				{
					name = REMOVE,
					type = "multiselect",
					order = get_order(),
					values = cvars_values,
					set = function(info,val)
						ControlPanel:FireCVarInstance(info[1],val)
					end,
					get = function(info)end,
					width = "full",
				}
			}
		}
	end
	return Custom
end
