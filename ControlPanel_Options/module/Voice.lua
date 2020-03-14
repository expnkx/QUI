local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local AceLocale = LibStub("AceLocale-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local ControlPanel = AceAddon:GetAddon("ControlPanel")
local ControlPanel_Options = AceAddon:GetAddon("ControlPanel_Options")
local L = AceLocale:GetLocale("ControlPanel_Options")
local SetCVar = SetCVar
local GetCVar = GetCVar
local Sound_GameSystem_RestartSoundSystem = Sound_GameSystem_RestartSoundSystem

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

local Sound_ChatSystem_GetNumInputDrivers = Sound_ChatSystem_GetNumInputDrivers
local Sound_ChatSystem_GetInputDriverNameByIndex = Sound_ChatSystem_GetInputDriverNameByIndex
local function get_voice_chat_input_drivers_table()
	local n = Sound_ChatSystem_GetNumInputDrivers()
	local i
	local tb = {}
	for i=0,n-1 do
		local v = Sound_ChatSystem_GetInputDriverNameByIndex(i)
		tb[v]=v
	end
	return tb
end

local voice_chat_mode_table = {PUSH_TO_TALK,VOICE_ACTIVATED}

local Sound_ChatSystem_GetNumOutputDrivers = Sound_ChatSystem_GetNumOutputDrivers
local Sound_ChatSystem_GetOutputDriverNameByIndex = Sound_ChatSystem_GetOutputDriverNameByIndex

local function get_voice_chat_output_drivers_table()
	local n = Sound_ChatSystem_GetNumOutputDrivers()
	local i
	local tb = {}
	for i=0,n-1 do
		local v = Sound_ChatSystem_GetOutputDriverNameByIndex(i)
		tb[v]=v
	end
	return tb
end

local Voice

function ControlPanel_Options:CreateVoice(o)
	if Voice == nil then
		Voice =
		{
			name = VOICE_LABEL,
			desc = VOICE_SUBTEXT,
			order = o,
			type = "group",
			args =
			{
				EnableVoiceChat = 
				{
					order = get_order(),
					name = ENABLE_VOICECHAT,
					desc = OPTION_TOOLTIP_ENABLE_VOICECHAT,
					type = "toggle",
					set = function(info,val)
						ControlPanel:SetCVarInstance(info[1],"EnableVoiceChat",val)
					end,
					get = function(info)
						return ControlPanel:GetCVarBoolInstance(info[1],"EnableVoiceChat")
					end,
				},
				Talking =
				{
					order = get_order(),
					name = VOICE_TALKING,
					type = "group",
					args =
					{
						EnableMicrophone = 
						{
							order = get_order(),
							name = ENABLE_MICROPHONE,
							desc = OPTION_TOOLTIP_ENABLE_MICROPHONE,
							type = "toggle",
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"EnableMicrophone",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarBoolInstance(info[1],"EnableMicrophone")
							end,
							width = "full"
						},
						OutboundChatVolume = 
						{
							order = get_order(),
							name = VOICE_INPUT_VOLUME,
							desc = OPTION_TOOLTIP_VOICE_INPUT_VOLUME,
							type = "range",
							min = 0,
							max = 2,
							isPercent = true,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"OutboundChatVolume",val*2.5)
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"OutboundChatVolume")/2.5
							end,
							width = "full"
						}
					}
				},
				VoiceChatMode =
				{
					order = get_order(),
					name = VOICE_CHAT_MODE,
					desc = OPTION_TOOLTIP_VOICE_TYPE2,
					type = "group",
					childGroups = "tab",
					args = 
					{
						VoiceChatMode =
						{
							order = get_order(),
							name = VOICE_CHAT_MODE,
							type = "select",
							values = voice_chat_mode_table,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"VoiceChatMode",val-1)
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"VoiceChatMode")+1
							end,
							width = "full",
						},
						Push_to_Talk =
						{
							order = get_order(),
							name = PUSH_TO_TALK,
							type = "group",
							args =
							{
								PushToTalkSound =
								{
									order = get_order(),
									name = PUSHTOTALK_SOUND_TEXT,
									desc = OPTION_TOOLTIP_PUSHTOTALK_SOUND,
									type = "toggle",
									set = function(info,val)
										ControlPanel:SetCVarInstance(info[1],"PushToTalkSound",val)
									end,
									get = function(info)
										return ControlPanel:GetCVarBoolInstance(info[1],"PushToTalkSound")
									end,
									width = "full"
								}
							}
						},
						VoiceActivated =
						{
							order = get_order(),
							name = VOICE_ACTIVATED,
							type = "group",
							args =
							{
								VoiceActivationSensitivity =
								{
									order = get_order(),
									name = VOICE_ACTIVATION_SENSITIVITY,
									desc = OPTION_TOOLTIP_VOICE_ACTIVATION_SENSITIVITY,
									type = "range",
									min = 0,
									max = 1,
									isPercent = true,
									set = function(info,val)
										ControlPanel:SetCVarInstance(info[1],"VoiceActivationSensitivity",val)
									end,
									get = function(info)
										return ControlPanel:GetCVarNumberInstance(info[1],"VoiceActivationSensitivity")
									end,
									width = "full"
								}
							}
						}
					}
				},
				Listening =
				{
					order = get_order(),
					name = VOICE_LISTENING,
					type = "group",
					args =
					{
						InboundChatVolume = 
						{
							order = get_order(),
							name = VOICE_OUTPUT_VOLUME,
							desc = OPTION_TOOLTIP_VOICE_OUTPUT_VOLUME,
							type = "range",
							min = 0,
							max = 1,
							isPercent = true,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"InboundChatVolume",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"InboundChatVolume")
							end,
							width = "full",
						},
						GameAudioFade=
						{
							order = get_order(),
							name = VOICE_GAME_DUCKING,
							desc = VOICE_CHAT_AUDIO_DUCKING,
							type = "group",
							args =
							{
								ChatSoundVolume =
								{
									order = get_order(),
									name = SOUND_LABEL,
									type = "range",
									min = 0,
									max = 1,
									isPercent = true,
									set = function(info,val)
										ControlPanel:SetCVarInstance(info[1],"ChatSoundVolume",val)
									end,
									get = function(info)
										return ControlPanel:GetCVarNumberInstance(info[1],"ChatSoundVolume")
									end,
								},
								ChatMusicVolume =
								{
									order = get_order(),
									name = MUSIC_VOLUME,
									desc = OPTION_TOOLTIP_MUSIC_VOLUME,
									type = "range",
									min = 0,
									max = 1,
									isPercent = true,
									set = function(info,val)
										ControlPanel:SetCVarInstance(info[1],"ChatMusicVolume",val)
									end,
									get = function(info)
										return ControlPanel:GetCVarNumberInstance(info[1],"ChatMusicVolume")
									end,
								},
								ChatAmbienceVolume =
								{
									order = get_order(),
									name = AMBIENCE_VOLUME,
									desc = OPTION_TOOLTIP_AMBIENCE_VOLUME,
									type = "range",
									min = 0,
									max = 1,
									isPercent = true,
									set = function(info,val)
										ControlPanel:SetCVarInstance(info[1],"ChatAmbienceVolume",val)
									end,
									get = function(info)
										return ControlPanel:GetCVarNumberInstance(info[1],"ChatAmbienceVolume")
									end,
								},
							}
						},
					}
				},

				Hardware =
				{
					order = get_order(),
					name = HARDWARE,
					desc = L["Requires a restart of the game's sound systems"].."\n\n"..L["ControlPanel won't manage these options."],
					type = "group",
					args =
					{
						Sound_VoiceChatInputDriverName =
						{
							order = get_order(),
							name = VOICE_TALKING,
							desc = OPTION_TOOLTIP_VOICE_INPUT,
							type = "select",
							values = get_voice_chat_input_drivers_table,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"Sound_VoiceChatInputDriverName",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarInstance(info[1],"Sound_VoiceChatInputDriverName")
							end,
							width = "full",
						},
						Sound_VoiceChatOutputDriverName =
						{
							order = get_order(),
							name = VOICE_CHAT_OUTPUT_DEVICE,
							desc = OPTION_TOOLTIP_VOICE_OUTPUT,
							type = "select",
							values = get_voice_chat_output_drivers_table,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"Sound_VoiceChatOutputDriverName",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarInstance(info[1],"Sound_VoiceChatOutputDriverName")
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
	return Voice
end
