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

local filter
local math_floor = math.floor
local table_concat = table.concat

local string_find = string.find
local string_lower = string.lower
local results_tb = {}
local function search(tb)
	if filter then
		for k,v in pairs(tb) do
			for i=1,#v do
				local temp = v[i]
				if temp[3] then
					local tmp1 = string_lower(tostring(temp[3]))
					if string_find(tmp1,filter) then
						results_tb[#results_tb+1] = temp
					end
				end
				local tmp1 = string_lower(tostring(temp[1]))
				if string_find(tmp1,filter) then
					results_tb[#results_tb+1] = temp
				end
			end			
		end
	end
end

local select_tb = {}
local select_playlist
local generated

MusicBox_Options:push("search",
{
	name = SEARCH,
	type = "group",
	args =
	{
		filter =
		{
			order = get_order(),
			name = FILTER,
			type = "input",
			width = "full",
			set = function(_,val)
				filter = string.lower(val)
			end,
			get = function()
				return filter
			end
		},
		search =
		{
			order = get_order(),
			name = SEARCH,
			type = "execute",
			func = function()
				wipe(results_tb)
				wipe(select_tb)
				search(MusicBox.db.profile.playlists)
				search(MusicBox.temp_playlist)
				generated = MusicBox_Options.generate_playlist(results_tb)
			end,
		},
		add2 =
		{
			order = get_order(),
			name = ADD,
			type = "execute",
			func = function()
				if filter and select_playlist then
					wipe(results_tb)
					wipe(select_tb)
					generated = nil
					search(MusicBox.db.profile.playlists)
					search(MusicBox.temp_playlist)
					local t = MusicBox:GetPlaylist(select_playlist)
					for i = 1,#results_tb do
						t[#t+1] = results_tb[i]
					end
					wipe(results_tb)
				end
			end
		},
		music =
		{
			order = get_order(),
			name = L.Song,
			type = "multiselect",
			values = function()
				return generated
			end,
			width = "full",
			set = function(info,key,val)
				if filter then
					if val then
						select_tb[key] = val
						MusicBox:PlayMusic(results_tb[key])
					else
						select_tb[key] = nil
					end
				end
			end,
			get = function(info,key)
				return select_tb[key]
			end,
		},
		all =
		{
			order = get_order(),
			name = ALL,
			type = "execute",
			func = function()
				for i=1,#results_tb do
					select_tb[i] = true
				end
			end,
		},
		reset =
		{
			order = get_order(),
			name = RESET,
			type = "execute",
			func = function()
				filter = nil
				wipe(results_tb)
				wipe(select_tb)
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
					select_playlist = nil
				else
					select_playlist = val
				end
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
				if next(select_tb) and select_playlist then
					local temp = {}
					local k,v
					for k,v in pairs(select_tb) do
						if v then
							temp[#temp+1] = k
						end
					end
					wipe(select_tb)
					table.sort(temp)
					local t = MusicBox:GetPlaylist(select_playlist)
					local i
					for i = 1,#temp do
						t[#t+1] = results_tb[temp[i]]
					end
				end
			end
		},
	}
})
