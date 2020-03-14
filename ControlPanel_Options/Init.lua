local ControlPanel_Options = LibStub("AceAddon-3.0"):NewAddon("ControlPanel_Options")

ControlPanel_Options.option_table =
{
	type = "group",
	name = "ControlPanel",
	args = {}
}

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

function ControlPanel_Options : push(key,val)
	val.order = get_order()
	self.option_table.args[key] = val
end

function ControlPanel_Options : get_table()
	return self.option_table
end

local GetCVarBool = GetCVarBool
local tonumber = tonumber
local GetCVar = GetCVar

function ControlPanel_Options.get_cvar_bool(c)
	if GetCVarBool(c) then
		return true
	else
		return false
	end
end

function ControlPanel_Options.get_cvar_number(c)
	return tonumber(GetCVar(c))
end
