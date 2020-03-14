local AceAddon = LibStub("AceAddon-3.0")
local MusicBox_Options = AceAddon:NewAddon("MusicBox_Options")
local table_concat = table.concat
local string_format = string.format
local math_floor = math.floor

MusicBox_Options.option_table =
{
	type = "group",
	name = "MusicBox",
	args = {}
}

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

function MusicBox_Options : push(key,val)
	val.order = get_order()
	self.option_table.args[key] = val
end

function MusicBox_Options : get_table()
	return self.option_table
end
local MusicBox = AceAddon:GetAddon("MusicBox")
function MusicBox_Options.GenerateRWPlayListValues()
	local tb = {}
	for k,v in pairs(MusicBox.db.profile.playlists) do
		tb[k] = k
	end
	return tb
end
function MusicBox_Options.GenerateROPlayListValues()
	local tb = MusicBox_Options.GenerateRWPlayListValues()
	for k,v in pairs(MusicBox.temp_playlist) do
		tb[k] = k
	end
	return tb
end

local mscinfcc = {0,"    |c0000ff00",0,"|r"}

local function convert_sec_to_xx_xx_xx(value)
	local hour = value / 3600
	local min_sec = value % 3600
	local minute = min_sec / 60
	local sec = min_sec % 60
	return string_format("%02d:%02d:%02d",hour,minute,sec)
end

function MusicBox_Options.generate_playlist(tb)
	local t = {}
	local i
	for i=1,#tb do
		local temp = tb[i]
		mscinfcc[1] = temp[3] or temp[1]
		mscinfcc[3] = convert_sec_to_xx_xx_xx(math_floor(temp[2]))
		t[i] = table_concat(mscinfcc)
	end
	return t
end

function MusicBox_Options.GeneratePlayListSongsValues(pl)
	local tb = MusicBox:GetPlaylist(pl)
	if tb then
		return MusicBox_Options.generate_playlist(tb)
	end
end

function MusicBox_Options.AddNull(tb)
	tb[""] = ""
	return tb
end
function MusicBox_Options.GenerateRWPlayListValues_AddNull()
	return MusicBox_Options.AddNull(MusicBox_Options.GenerateRWPlayListValues())
end
function MusicBox_Options.GenerateROPlayListValues_AddNull()
	return MusicBox_Options.AddNull(MusicBox_Options.GenerateROPlayListValues())
end
