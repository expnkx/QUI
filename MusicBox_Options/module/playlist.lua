local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local AceLocale = LibStub("AceLocale-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local MusicBox = AceAddon:GetAddon("MusicBox")
local MusicBox_Options = AceAddon:GetAddon("MusicBox_Options")
local L = AceLocale:GetLocale("MusicBox_Options")
local wipe = wipe
local pairs = pairs
local MusicBox_RemovePlaylist = MusicBox.RemovePlaylist

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

local remove_tb = {}

local playlist =
{
	name = L["Playlist"],
	type = "group",
	args =
	{
		game =
		{
			order = get_order(),
			name = GAME,
			type = "toggle",
			set = function(info,val)
				MusicBox.db.profile.game_music = val
				if val then
					MusicBox:OnEnable()
				end
			end,
			get = function(info)
				return MusicBox.db.profile.game_music
			end
		},
		temp =
		{
			order = get_order(),
			name = ENABLE,
			type = "execute",
			func = function()
				LoadAddOn("MusicBox_GameMusic")
			end
		},
		Add =
		{
			order = get_order(),
			name = ADD,
			type = "input",
			set = function(info,val)
				if val == "" then
					return
				end
				MusicBox:AddPlaylist(val,{})
			end,
			get = function(info) end,
			width = "full",
		},
		Remove =
		{
			order = get_order(),
			name = REMOVE,
			type = "execute",
			func = function()
				local k,v
				for k,v in pairs(remove_tb) do
					if v then
						MusicBox_RemovePlaylist(MusicBox,k)
					end
				end
			end
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
		Playlist =
		{
			order = get_order(),
			name = L["Playlist"],
			type = "multiselect",
			values = MusicBox_Options.GenerateRWPlayListValues,
			set = function(info,key,val)
				remove_tb[key] = val
			end,
			get = function(info,key) return remove_tb[key] end,
			width = "full",
		},
	}
}

MusicBox_Options:push("playlist",playlist)
