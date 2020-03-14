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
local sound_channels = {[24]=string_format(SOUND_CHANNELS_LOW,24),
					[48]=string_format(SOUND_CHANNELS_MEDIUM,48),
					[64]=string_format(SOUND_CHANNELS_HIGH,64),
					[128]=string_format(SOUND_CHANNELS_HIGH,128)}
local Sound_GameSystem_GetNumOutputDrivers = Sound_GameSystem_GetNumOutputDrivers
local pow = math.pow
local log = math.log

local function get_output_drivers_table()
	local t = Sound_GameSystem_GetNumOutputDrivers()
	local r = {}
	local i
	for i=1,t do
		local s = Sound_GameSystem_GetOutputDriverNameByIndex(i-1)
		r[s] = s
	end
	return r
end

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

local Sound

function ControlPanel_Options:CreateSound(o)
	if Sound == nil then
		Sound =
		{
			order = get_order(),
			name = SOUND_LABEL,
			desc = SOUND_SUBTEXT,
			order = o,
			type = "group",
			args =
			{
				Sound_EnableAllSound =
				{
					order = get_order(),
					name = ENABLE_SOUND,
					desc = OPTION_TOOLTIP_ENABLE_SOUND,
					type = "toggle",
					set = function(info,val)
						ControlPanel:SetCVarInstance(info[1],"Sound_EnableAllSound",val)
					end,
					get = function(info)
						return ControlPanel:GetCVarBoolInstance(info[1],"Sound_EnableAllSound")
					end,
					width = "full",
				},
				Sound_MasterVolume =
				{
					order = get_order(),
					name = MASTER_VOLUME,
					desc = OPTION_TOOLTIP_MASTER_VOLUME,
					type = "range",
					min = 0,
					max = 1,
					isPercent = true,
					set = function(info,val)
						ControlPanel:SetCVarInstance(info[1],"Sound_MasterVolume",val)
					end,
					get = function(info)
						return ControlPanel:GetCVarNumberInstance(info[1],"Sound_MasterVolume")
					end,
					width = "full",
				},
				SoundEffects =
				{
					order = get_order(),
					name = ENABLE_SOUNDFX,
					type = "group",
					args = 
					{
						Sound_EnableSFX = 
						{
							order = get_order(),
							name = ENABLE_SOUNDFX,
							desc = OPTION_TOOLTIP_ENABLE_SOUNDFX,
							type = "toggle",
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"Sound_EnableSFX",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarBoolInstance(info[1],"Sound_EnableSFX")
							end,
							width = "full",
						},
						Sound_SFXVolume =
						{
							order = get_order(),
							name = SOUND_VOLUME,
							desc = OPTION_TOOLTIP_SOUND_VOLUME,
							type = "range",
							min = 0,
							max = 1,
							isPercent = true,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"Sound_SFXVolume",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"Sound_SFXVolume")
							end,
							width = "full",
						},
						Sound_EnablePetSounds =
						{
							order = get_order(),
							name = ENABLE_PET_SOUNDS,
							desc = OPTION_TOOLTIP_ENABLE_PET_SOUNDS,
							type = "toggle",
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"Sound_EnablePetSounds",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarBoolInstance(info[1],"Sound_EnablePetSounds")
							end,
						},
						Sound_EnableEmoteSounds =
						{
							order = get_order(),
							name = ENABLE_EMOTE_SOUNDS,
							desc = OPTION_TOOLTIP_ENABLE_EMOTE_SOUNDS,
							type = "toggle",
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"Sound_EnableEmoteSounds",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarBoolInstance(info[1],"Sound_EnableEmoteSounds")
							end,
						},
					}
				},
				Music =
				{
					order = get_order(),
					name = MUSIC_VOLUME,
					type = "group",
					args = 
					{
						Sound_EnableMusic =
						{
							order = get_order(),
							name = ENABLE_MUSIC,
							desc = OPTION_TOOLTIP_ENABLE_MUSIC,
							type = "toggle",
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"Sound_EnableMusic",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarBoolInstance(info[1],"Sound_EnableMusic")
							end,
							width = "full",
						},
						Sound_MusicVolume =
						{
							order = get_order(),
							name = MUSIC_VOLUME,
							desc = OPTION_TOOLTIP_MUSIC_VOLUME,
							type = "range",
							min = 0,
							max = 1,
							isPercent = true,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"Sound_MusicVolume",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"Sound_MusicVolume")
							end,
							width = "full",
						},
						Sound_ZoneMusicNoDelay = 
						{
							order = get_order(),
							name = ENABLE_MUSIC_LOOPING,
							desc = OPTION_TOOLTIP_ENABLE_MUSIC_LOOPING,
							type = "toggle",
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"Sound_ZoneMusicNoDelay",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarBoolInstance(info[1],"Sound_ZoneMusicNoDelay")
							end,
						},
						Sound_EnablePetBattleMusic = 
						{
							order = get_order(),
							name = ENABLE_PET_BATTLE_MUSIC,
							desc = OPTION_TOOLTIP_ENABLE_PET_BATTLE_MUSIC,
							type = "toggle",
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"Sound_EnablePetBattleMusic",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarBoolInstance(info[1],"Sound_EnablePetBattleMusic")
							end,
						},
					}
				},
				Ambience = 
				{
					order = get_order(),
					name = AMBIENCE_VOLUME,
					type = "group",
					args = 
					{
						Sound_EnableAmbience =
						{
							order = get_order(),
							name = ENABLE_AMBIENCE ,
							desc = OPTION_TOOLTIP_ENABLE_AMBIENCE,
							type = "toggle",
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"Sound_EnableAmbience",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarBoolInstance(info[1],"Sound_EnableAmbience")
							end,
							width = "full",
						},
						Sound_AmbienceVolume =
						{
							order = get_order(),
							name = AMBIENCE_VOLUME,
							desc = OPTION_TOOLTIP_AMBIENCE_VOLUME,
							type = "range",
							min = 0,
							max = 1,
							isPercent = true,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"Sound_AmbienceVolume",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"Sound_AmbienceVolume")
							end,
							width = "full",
						},
					}
				},
				Dialog =
				{
					order = get_order(),
					name = ENABLE_DIALOG,
					type = "group",
					args = 
					{
						Sound_EnableDialog =
						{
							order = get_order(),
							name = ENABLE_DIALOG,
							desc = OPTION_TOOLTIP_ENABLE_DIALOG,
							type = "toggle",
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"Sound_EnableDialog",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarBoolInstance(info[1],"Sound_EnableDialog")
							end,
							width = "full",
						},
						Sound_DialogVolume =
						{
							order = get_order(),
							name = DIALOG_VOLUME,
							desc = OPTION_TOOLTIP_DIALOG_VOLUME,
							type = "range",
							min = 0,
							max = 1,
							isPercent = true,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"Sound_DialogVolume",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"Sound_DialogVolume")
							end,
							width = "full",
						},
						Sound_EnableErrorSpeech = 
						{
							order = get_order(),
							name = ENABLE_ERROR_SPEECH,
							desc = OPTION_TOOLTIP_ENABLE_ERROR_SPEECH,
							type = "toggle",
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"Sound_EnableErrorSpeech",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarBoolInstance(info[1],"Sound_EnableErrorSpeech")
							end,
						},
					}
				},
				Playback =
				{
					order = get_order(),
					name = PLAYBACK,
					type = "group",
					args = 
					{
						Sound_EnableSoundWhenGameIsInBG = 
						{
							order = get_order(),
							name = ENABLE_BGSOUND,
							desc = OPTION_TOOLTIP_ENABLE_BGSOUND,
							type = "toggle",
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"Sound_EnableSoundWhenGameIsInBG",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarBoolInstance(info[1],"Sound_EnableSoundWhenGameIsInBG")
							end,
							width = "full",
						},
						Sound_EnableReverb = 
						{
							order = get_order(),
							name = ENABLE_REVERB,
							desc = OPTION_TOOLTIP_ENABLE_REVERB,
							type = "toggle",
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"Sound_EnableReverb",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarBoolInstance(info[1],"Sound_EnableReverb")
							end,
							width = "full",
						},
						Sound_EnablePositionalLowPassFilter = 
						{
							order = get_order(),
							name = ENABLE_SOFTWARE_HRTF,
							desc = OPTION_TOOLTIP_ENABLE_SOFTWARE_HRTF,
							type = "toggle",
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"Sound_EnablePositionalLowPassFilter",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarBoolInstance(info[1],"Sound_EnablePositionalLowPassFilter")
							end,
							width = "full",
						},
					}
				},
				ClassVoices = 
				{
					order = get_order(),
					name = L["Class Voices"],
					desc = L["Special voice modulation effects for some classes. Disable to improve performance."],
					type = "group",
					args =
					{
						Sound_EnableDSPEffects = 
						{
							order = get_order(),
							name = GetClassInfo(6),
							type = "toggle",
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"Sound_EnableDSPEffects",val)
							end,	
							get = function(info)
								return ControlPanel:GetCVarBoolInstance(info[1],"Sound_EnableDSPEffects")
							end,
						}
					}
				},
				Hardware =
				{
					order = get_order(),
					name = HARDWARE,
					desc = L["Requires a restart of the game's sound systems"] ,
					type = "group",
					args =
					{
						Sound_OutputDriverName =
						{
							order = get_order(),
							name = GAME_SOUND_OUTPUT,
							type = "select",
							values = get_output_drivers_table,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"Sound_OutputDriverName",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarInstance(info[1],"Sound_OutputDriverName")
							end,
							width = "full",
						},
						Sound_NumChannels = 
						{
							order = get_order(),
							name = SOUND_CHANNELS,
							type = "select",
							values = sound_channels,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"Sound_NumChannels",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"Sound_NumChannels")
							end,
							width = "full",
						},
						Sound_MaxCacheSizeInBytes = 
						{
							order = get_order(),
							name = SOUND_CACHESIZE,
							desc = "pow(2,value) bytes",
							type = "range",
							min = 0,
							max = 31,
							step = 1,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"Sound_MaxCacheSizeInBytes",pow(2,val))
							end,
							get = function(info)
								return log(ControlPanel:GetCVarNumberInstance(info[1],"Sound_MaxCacheSizeInBytes"))/log(2)
							end,
							width = "full",
						},
						restart_sound_systems =
						{
							order = get_order(),
							name = L["Restart sound systems"],
							type = "execute",
							func = Sound_GameSystem_RestartSoundSystem,
							width = "full"
						}
					}
				}
			}
		}
	end
	return Sound
end
