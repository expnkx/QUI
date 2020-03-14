local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local AceLocale = LibStub("AceLocale-3.0")
local ControlPanel = AceAddon:GetAddon("ControlPanel")
local ControlPanel_Options = AceAddon:GetAddon("ControlPanel_Options")
local L = LibStub("AceLocale-3.0"):GetLocale("ControlPanel_Options")
local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

local temp_settings = {Graphics = ControlPanel_Options:CreateGraphics(get_order()),
				Network = ControlPanel_Options:CreateNetwork(get_order()),
				Sound = ControlPanel_Options:CreateSound(get_order()),
				Voice = ControlPanel_Options:CreateVoice(get_order()),
				Script =  ControlPanel_Options:CreateScript(get_order()),
				graphicsQuality = 
				{
					order = get_order(),
					name = OVERALL_QUALITY,
					type = "range",
					min = 1,
					max = 10,
					step = 1,
					get = function(info)
						return ControlPanel:GetCVarNumberInstance(info[1],"graphicsQuality")
					end,
					set = function(info,val)
						ControlPanel:SetCVarInstance(info[1],"graphicsQuality",val)
						ControlPanel_Options:set_graphics_quality(info[1],val)
					end,
					width = "full",
				}}
local pairs = pairs

local function deep_copy(t)
	local tb = {}
	local k,v
	for k,v in pairs(t) do
		tb[k] = v
	end
	return tb
end
				
local settings = deep_copy(temp_settings)

temp_settings.Custom =
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
					return SetCVar(cvar_name,val)
				end
			end,
			get = function(info)
				if cvar_name ~= nil then
					return GetCVar(cvar_name)
				end
			end
		}
	}
}
settings.Custom = ControlPanel_Options:CreateCustom(get_order())

local function generate_enable()
	local tb = deep_copy(settings)
	tb.enable = 
	{
		name = ENABLE,
		order = get_order(),
		type = "toggle",
		set = function(info,val)
			local f = info[1]
			ControlPanel.db.profile["enable_"..f] = val or nil
			if f == ControlPanel:GetInstanceType() then
				if val == true then
					ControlPanel:UpdateWorld(f)
				else
					ControlPanel:UpdateWorld("none")
				end
			end
		end,
		get = function(info)
			return ControlPanel.db.profile["enable_"..info[1]]
		end,
	}
	return tb
end

local instance_settings = generate_enable()

ControlPanel_Options:push("temp",
{
	name = NONE,
	type = "group",
	args = temp_settings,
})

ControlPanel_Options:push("none",
{
	name = WORLD,
	type = "group",
	args = settings
})

ControlPanel_Options:push("arena",
{
	name = ARENA,
	type = "group",
	args = instance_settings
})

ControlPanel_Options:push("party",
{
	name = DUNGEONS,
	type = "group",
	args = instance_settings
})

ControlPanel_Options:push("pvp",
{
	name = BATTLEGROUND,
	type = "group",
	args = instance_settings
})

ControlPanel_Options:push("raid",
{
	name = RAID,
	type = "group",
	args = instance_settings
})

ControlPanel_Options:push("rest",
{
	name = XP,
	desc = L["Inns and major cities"],
	type = "group",
	args = instance_settings
})

ControlPanel_Options:push("scenario",
{
	name = SCENARIOS,
	type = "group",
	args = instance_settings,
})
