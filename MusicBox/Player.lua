local MusicBox = LibStub("AceAddon-3.0"):GetAddon("MusicBox")
local PlayMusic = PlayMusic
local StopMusic = StopMusic

function MusicBox:PlayMusic(music)
	if self.db.profile.playing == true and music then
		if self.timer then
			self:CancelTimer(self.timer)
			self.timer = nil
		end
		local length = music[2]
		if 2 < length then
			self.now_playing = music
			PlayMusic(music[1])
			self.timer = self:ScheduleTimer("TimerFeedBack",length-2)
		else
			self.timer = self:ScheduleTimer("TimerFeedBack",0)
		end
	end
end

function MusicBox:StopMusic()
	if self.timer then
		self:CancelTimer(self.timer)
		self.timer = nil
		self.now_playing = nil
		StopMusic()
	end
end


local shuffle_order = {}
local order_pos = 0
local random = random
local wipe = wipe
local function shuffle_order_playlist(pl)
	wipe(shuffle_order)
	order_pos = 0
	local i
	for i = 1,#pl do
		shuffle_order[i] = i;
	end
	for i = #shuffle_order,2,-1 do
		local r = random(1,i)
		local t = shuffle_order[r]
		shuffle_order[r] = shuffle_order[i]
		shuffle_order[i] = t
	end
end

local current_playlist

function MusicBox:NextMusic()
	if self.db.profile.playing and current_playlist then
		if self.timer then
			self:CancelTimer(self.timer)
			self.timer = nil
			self.now_playing = nil
		end
		self:TimerFeedBack()
	end
end
function MusicBox:TimerFeedBack()
	if current_playlist == nil or #current_playlist == 0 then
		self:StopMusic()
		return
	end
	if #current_playlist ~= #shuffle_order or order_pos==#shuffle_order  then
		shuffle_order_playlist(current_playlist)
	end
	order_pos = order_pos + 1
	self:PlayMusic(current_playlist[shuffle_order[order_pos]])
end

function MusicBox:Stop()
	self:StopMusic()
	current_playlist = nil
end

local cvar_sound_enablemusic

local function feedback()
	if cvar_sound_enablemusic ~= nil then
		SetCVar("Sound_EnableMusic",cvar_sound_enablemusic)
		cvar_sound_enablemusic = nil
	end
end

function MusicBox:PlayPlaylist(pl)
	if current_playlist ~= pl then
		current_playlist = pl
		if self.timer then
			self:CancelTimer(self.timer)
			self.timer = nil
			self.now_playing = nil
			self:TimerFeedBack()
		else
			if cvar_sound_enablemusic == nil then
				cvar_sound_enablemusic = GetCVar("Sound_EnableMusic")
				SetCVar("Sound_EnableMusic",false)
				C_Timer.After(1,feedback)
			end
		end
	end
end
function MusicBox:Start()
	local music_enable = GetCVar("Sound_EnableMusic")
	if (music_enable==true or music_enable==1 or music_enable == "1") and self.db.profile.playing == true and current_playlist then
		shuffle_order_playlist(current_playlist)
		self:TimerFeedBack()
	else
		self:StopMusic()
	end
end

function MusicBox:HookPlayMusic(music)
	self:StopMusic()
	PlayMusic(music)
end

function MusicBox:HookStopMusic()
	self:Start()
end

function MusicBox:HookPlayMusic(music)
	if self.timer then
		self:CancelTimer(self.timer)
		self.timer = nil
		self.now_playing = nil
	end
end

function MusicBox:HookStopMusic()
	self:Start()
end

function MusicBox:SetCVar(name,value,...)
	if name == "Sound_EnableMusic" then
		self:Start()
	end
end
