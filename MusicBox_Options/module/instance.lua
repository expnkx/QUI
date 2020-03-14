local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local AceLocale = LibStub("AceLocale-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local MusicBox = AceAddon:GetAddon("MusicBox")
local MusicBox_Options = AceAddon:GetAddon("MusicBox_Options")
local L = AceLocale:GetLocale("MusicBox_Options")

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

local Playlist =
{
	order = get_order(),
	name = L["Playlist"],
	type = "select",
	values = MusicBox_Options.GenerateROPlayListValues_AddNull,
	set = function(info,val)
		if val == "" then
			MusicBox:SetPlaylistNameInstance(info[1],nil)
		else
			MusicBox:SetPlaylistNameInstance(info[1],val)
		end
	end,
	get = function(info)
		local pn = MusicBox:GetPlaylistNameInstance(info[1])
		if pn == nil then
			return ""
		else
			return pn
		end
	end,
	width = "full",
}

local none = 
{
	name = WORLD,
	type = "group",
	args = 
	{
		playlist = Playlist
	}
}

local instance_playlist =
{
	playlist = Playlist,
	enable = 
	{
		name = ENABLE,
		type = "toggle",
		set = function(info,val)
			MusicBox.db.profile["enable_"..info[1]] = val
			MusicBox:PLAYER_UPDATE_RESTING()
		end,
		get = function(info)
			return MusicBox.db.profile["enable_"..info[1]]
		end,
	}
}

local arena = 
{
	name = ARENA,
	type = "group",
	args = instance_playlist,
}

local party = 
{
	name = DUNGEONS,
	type = "group",
	args = instance_playlist
}

local pvp = 
{
	name = BATTLEGROUND,
	type = "group",
	args = instance_playlist
}

local raid = 
{
	name = RAID,
	type = "group",
	args = instance_playlist
}

local rest = 
{
	name = XP,
	desc = L["Inns and major cities"],
	type = "group",
	args = instance_playlist
}

local scenario =
{
	name = SCENARIOS,
	type = "group",
	args = instance_playlist,
}

MusicBox_Options:push("none",none)
MusicBox_Options:push("arena",arena)
MusicBox_Options:push("party",party)
MusicBox_Options:push("pvp",pvp)
MusicBox_Options:push("raid",raid)
MusicBox_Options:push("rest",rest)
MusicBox_Options:push("scenario",scenario)
