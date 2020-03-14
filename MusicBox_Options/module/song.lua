local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local AceLocale = LibStub("AceLocale-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local MusicBox = AceAddon:GetAddon("MusicBox")
local MusicBox_Options = AceAddon:GetAddon("MusicBox_Options")
local L = AceLocale:GetLocale("MusicBox_Options")
local tsort = table.sort
local wipe = wipe
local pairs = pairs

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

local select_playlist,select_roplaylist,select_add_from_playlist
local function generate_song_select_values()
	return MusicBox_Options.GeneratePlayListSongsValues(select_playlist)
end
local function generate_song_select_add_from_values()
	return MusicBox_Options.GeneratePlayListSongsValues(select_add_from_playlist)
end
local song_path

local remove_tb = {}
local song_tb = {}

local plst = 
{
	order = get_order(),
	name = L["Playlist"],
	type = "select",
	values = MusicBox_Options.GenerateRWPlayListValues_AddNull,
	set = function(info,val)
		if val == "" then
			song_path = nil
			select_playlist = nil
		else
			select_playlist = val
		end
		wipe(remove_tb)
	end,
	get = function(info) return select_playlist end,
	width = "full",
}

local temp = {}

local song =
{
	name = L["Song"],
	type = "group",
	args =
	{
		Playlist = 
		{
			order = get_order(),
			name = L["Playlist"],
			type = "select",
			values = MusicBox_Options.GenerateROPlayListValues,
			set = function(info,val)
				select_roplaylist = val
				wipe(song_tb)
			end,
			get = function(info) return select_roplaylist end,
			width = "full",
		},

		SelectAll =
		{
			order = get_order(),
			name = L["Select All"],
			type = "execute",
			func = function()
				local ft = MusicBox:GetPlaylist(select_roplaylist)
				if ft then
					for i = 1,#ft do
						song_tb[i] = true
					end
				end
			end,
		},
		Songlist =
		{
			order = get_order(),
			name = L["Song"],
			type = "multiselect",
			values = function() return MusicBox_Options.GeneratePlayListSongsValues(select_roplaylist) end,
			set = function(info,key,val)
				if select_roplaylist then
					song_tb[key] = val
					if val then
						MusicBox:PlayMusic(MusicBox:GetPlaylist(select_roplaylist)[key])
					end
				end
			end,
			get = function(info,key) return song_tb[key] end,
			width = "full",
		},
		Cancel =
		{
			order = get_order(),
			name = CANCEL,
			type = "execute",
			func = function()
				wipe(song_tb)
			end
		},
		DBPlaylist = 
		{
			order = get_order(),
			name = L["Playlist"],
			type = "select",
			values = MusicBox_Options.GenerateRWPlayListValues_AddNull,
			set = function(info,val)
				if val == "" then
					song_path = nil
					select_playlist = nil
				else
					select_playlist = val
				end
				wipe(remove_tb)
			end,
			get = function(info) return select_playlist end,
			width = "full",
		},
		Add =
		{
			order = get_order(),
			name = ADD,
			type = "execute",
			func = function()
				if select_roplaylist~=nil and select_playlist ~=nil then
					wipe(temp)
					local k,v
					for k,v in pairs(song_tb) do
						if v then
							temp[#temp+1] = k
						end
					end
					wipe(song_tb)
					tsort(temp)
					local f = MusicBox:GetPlaylist(select_roplaylist)
					local t = MusicBox:GetPlaylist(select_playlist)
					local i
					for i = 1,#temp do
						t[#t+1] = f[temp[i]]
					end
				end
			end
		},
	}
}

MusicBox_Options:push("song",song)

MusicBox_Options:push("database",
{
	name = L["Database"],
	type = "group",
	args =
	{
		Playlist = plst,
		SelectAll =
		{
			order = get_order(),
			name = L["Select All"],
			type = "execute",
			func = function()
				local ft = MusicBox:GetPlaylist(select_playlist)
				if ft then
					for i = 1,#ft do
						remove_tb[i] = true
					end
				end
			end,
		},
		Song =
		{
			order = get_order(),
			name = L["Song"],
			type = "multiselect",
			values = generate_song_select_values,
			set = function(info,key,val,...)
				if select_playlist == nil then
					song_path = nil
					return
				end
				remove_tb[key] = val
				if val then
					MusicBox:PlayMusic(MusicBox:GetPlaylist(select_playlist)[key])
				end
			end,
			get = function(info,key) return remove_tb[key] end,
			width = "full",
		},
		Cancel =
		{
			order = get_order(),
			name = CANCEL,
			type = "execute",
			func = function()
				wipe(remove_tb)
			end
		},
		Remove =
		{
			order = get_order(),
			name = REMOVE,
			type = "execute",
			func = function()
				if select_playlist == nil then
					return
				end
				local tb = {}
				local playlist = MusicBox:GetPlaylist(select_playlist)
				local i
				for i=1,#playlist do
					if remove_tb[i] ~= true then
						tb[#tb+1] = playlist[i]
					end
				end
				MusicBox:AddPlaylist(select_playlist,tb)
				wipe(remove_tb)
			end
		},
		Path =
		{
			order = get_order(),
			name = L["Path"],
			type = "input",
			multiline = true,
			width = "full",
			set = function(info,val)
				if select_playlist == nil or val == "" then
					return
				end
				song_path = val
			end,
			get = function(info) return song_path end,
		},
		Length =
		{
			order = get_order(),
			name = L["Length(sec)"],
			type = "input",
			width = "full",
			set = function(info,val)
				if select_playlist == nil or song_path == nil or val == "" then
					return
				end
				local song_length = tonumber(val)
				if song_length == nil then
					return
				end
				local pl = MusicBox:GetPlaylist(select_playlist)
				pl[#pl+1] = {song_path,song_length}
				song_path = nil
			end,
			get = function(info) end,
		},
	}
})
