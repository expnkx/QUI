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
local SetCVar = SetCVar

local get_cvar_number = ControlPanel_Options.get_cvar_number
local get_cvar_bool = ControlPanel_Options.get_cvar_bool

local GetCVarBool = GetCVarBool

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

local Interface =
{
	name = UIOPTIONS_MENU,
	desc = L["ControlPanel won't manage these options."],
	type = "group",
	args =
	{

		movieSubtitle = 
		{
			order = get_order(),
			name = CINEMATIC_SUBTITLES,
			desc = OPTION_TOOLTIP_CINEMATIC_SUBTITLES,
			type = "toggle",
			set = function(info,val)
				SetCVar("movieSubtitle",val)
			end,
			get = function(info)
				return get_cvar_bool("movieSubtitle")
			end,
		},
		enableMovePad =
		{
			order = get_order(),
			name = MOVE_PAD,
			desc = OPTION_TOOLTIP_MOVE_PAD,
			type = "toggle",
			set = function(info,val)
				SetCVar("enableMovePad",val)
			end,
			get = function(info)
				return get_cvar_bool("enableMovePad")
			end,		
		},
		showTutorials =
		{
			order = get_order(),
			name = SHOW_TUTORIALS,
			desc = OPTION_TOOLTIP_SHOW_TUTORIALS,
			type = "toggle",
			set = function(info,val)
				SetCVar("showTutorials",val)
			end,
			get = function(info)
				return get_cvar_bool("showTutorials")
			end
		},
		Controls = 
		{
			name = CONTROLS_LABEL,
			desc = CONTROLS_SUBTEXT,
			type = "group",
			args =
			{
				deselectOnClick =
				{
					name = GAMEFIELD_DESELECT_TEXT,
					desc = OPTION_TOOLTIP_GAMEFIELD_DESELECT,
					type = "toggle",
					set = function(info,val)
						SetCVar("deselectOnClick",not val)
					end,
					get = function(info)
						return not GetCVarBool("deselectOnClick")
					end,
					width = "full",
				},
				autoDismountFlying =
				{
					name = AUTO_DISMOUNT_FLYING_TEXT,
					desc = OPTION_TOOLTIP_AUTO_DISMOUNT_FLYING,
					type = "toggle",
					set = function(info,val)
						SetCVar("autoDismountFlying",val)
					end,
					get = function(info)
						return GetCVarBool("autoDismountFlying")
					end,
					width = "full",
				},
				autoClearAFK =
				{
					name = CLEAR_AFK,
					desc = OPTION_TOOLTIP_CLEAR_AFK,
					type = "toggle",
					set = function(info,val)
						SetCVar("autoClearAFK",val)
					end,
					get = function(info)
						return GetCVarBool("autoClearAFK")
					end,
					width = "full",
				},
				autoLootDefault =
				{
					name = AUTO_LOOT_DEFAULT_TEXT,
					desc = OPTION_TOOLTIP_AUTO_LOOT_DEFAULT,
					type = "toggle",
					set = function(info,val)
						SetCVar("autoLootDefault",val)
					end,
					get = function(info)
						return GetCVarBool("autoLootDefault")
					end,
					width = "full",
				},
				interactOnLeftClick =
				{
					name = INTERACT_ON_LEFT_CLICK_TEXT,
					desc = OPTION_TOOLTIP_INTERACT_ON_LEFT_CLICK,
					type = "toggle",
					set = function(info,val)
						SetCVar("interactOnLeftClick",val)
					end,
					get = function(info)
						return GetCVarBool("interactOnLeftClick")
					end,
					width = "full",
				},
				lootUnderMouse =
				{
					name = LOOT_UNDER_MOUSE_TEXT,
					desc = OPTION_TOOLTIP_LOOT_UNDER_MOUSE,
					type = "toggle",
					set = function(info,val)
						SetCVar("lootUnderMouse",val)
					end,
					get = function(info)
						return GetCVarBool("lootUnderMouse")
					end,
					width = "full",
				},
			}
		},
		Combat =
		{
			name = COMBAT_LABEL,
			desc = COMBAT_SUBTEXT,
			type = "group",
			args =
			{
				autoSelfCast =
				{
					name = AUTO_SELF_CAST_TEXT,
					desc = OPTION_TOOLTIP_AUTO_SELF_CAST,
					type = "toggle",
					set = function(info,val)
						SetCVar("autoSelfCast",val)
					end,
					get = function(info)
						return GetCVarBool("autoSelfCast")
					end,
					width = "full",
				},
				showTargetOfTarget =
				{
					name = SHOW_TARGET_OF_TARGET_TEXT,
					desc = OPTION_TOOLTIP_SHOW_TARGET_OF_TARGET,
					type = "toggle",
					set = function(info,val)
						SetCVar("showTargetOfTarget",val)
					end,
					get = function(info)
						return GetCVarBool("showTargetOfTarget")
					end,
					width = "full",
				},
				spellActivationOverlayOpacity =
				{
					order = -1,
					name = SPELL_ALERT_OPACITY,
					desc = OPTION_TOOLTIP_SPELL_ALERT_OPACITY,
					type = "range",
					min = 0,
					max = 1,
					set = function(info,val)
						SetCVar("SPELL_ALERT_OPACITY",val)
					end,
					get = function(info)
						return GetCVarBool("SPELL_ALERT_OPACITY")
					end,
				},
				doNotFlashLowHealthWarning =
				{
					name = FLASH_LOW_HEALTH_WARNING,
					desc = OPTION_TOOLTIP_FLASH_LOW_HEALTH_WARNING,
					type = "toggle",
					set = function(info,val)
						SetCVar("doNotFlashLowHealthWarning",val)
					end,
					get = function(info)
						return GetCVarBool("doNotFlashLowHealthWarning")
					end,
					width = "full",
				},
				lossOfControl =
				{
					name = LOSS_OF_CONTROL,
					desc = OPTION_TOOLTIP_LOSS_OF_CONTROL,
					type = "toggle",
					set = function(info,val)
						SetCVar("lossOfControl",val)
					end,
					get = function(info)
						return GetCVarBool("lossOfControl")
					end,
					width = "full",
				},
				enableFloatingCombatText =
				{
					name = SHOW_COMBAT_TEXT_TEXT,
					desc = OPTION_TOOLTIP_SHOW_COMBAT,
					type = "toggle",
					set = function(info,val)
						SetCVar("enableFloatingCombatText",val)
					end,
					get = function(info)
						return GetCVarBool("enableFloatingCombatText")
					end,
					width = "full",
				},
			}
		},
		Camera =
		{
			name = CAMERA_LABEL,
			desc = CAMERA_SUBTEXT,
			type = "group",
			args =
			{
				cameraWaterCollision =
				{
					name = WATER_COLLISION,
					desc = OPTION_TOOLTIP_WATER_COLLISION,
					type = "toggle",
					set = function(info,val)
						SetCVar("cameraWaterCollision",val)
					end,
					get = function(info)
						return GetCVarBool("cameraWaterCollision")
					end,
				},
				cameraYawSmoothSpeed =
				{
					name = AUTO_FOLLOW_SPEED,
					desc = OPTION_TOOLTIP_AUTO_FOLLOW_SPEED,
					type = "range",
					min = 0,
					max = 300,
					set = function(info,val)
						SetCVar("cameraYawSmoothSpeed",val)
					end,
					get = function(info)
						return get_cvar_number("cameraYawSmoothSpeed")
					end,
				},
				cameraDistanceMaxZoomFactor =
				{
					name = L["Distance Max Zoom Factor"],
					type = "range",
					min = 1,
					max = 2.6,
					set = function(info,val)
						SetCVar("cameraDistanceMaxZoomFactor",val)
					end,
					get = function(info)
						return get_cvar_number("cameraDistanceMaxZoomFactor")
					end,
				},
			}
		},


		SocialPanelOptions =
		{
			name = SOCIAL_LABEL,
			desc = SOCIAL_SUBTEXT,
			type = "group",
			args =
			{
				profanityFilter =
				{
					name = PROFANITY_FILTER,
					desc = OPTION_TOOLTIP_PROFANITY_FILTER,
					type = "toggle",
					set = function(info,val)
						SetCVar("profanityFilter",val)
					end,
					get = function(info)
						return GetCVarBool("profanityFilter")
					end,
				},
				spamFilter =
				{
					name = SPAM_FILTER,
					desc = OPTION_TOOLTIP_SPAM_FILTER,
					type = "toggle",
					set = function(info,val)
						SetCVar("spamFilter",val)
					end,
					get = function(info)
						return GetCVarBool("spamFilter")
					end,
				},
				guildMemberNotify =
				{
					name = GUILDMEMBER_ALERT,
					desc = OPTION_TOOLTIP_GUILDMEMBER_ALERT,
					type = "toggle",
					set = function(info,val)
						SetCVar("guildMemberNotify",val)
					end,
					get = function(info)
						return GetCVarBool("guildMemberNotify")
					end,
				},
				blockTrades =
				{
					name = BLOCK_TRADES,
					desc = OPTION_TOOLTIP_BLOCK_TRADES,
					type = "toggle",
					set = function(info,val)
						SetCVar("blockTrades",val)
					end,
					get = function(info)
						return GetCVarBool("blockTrades")
					end,
				},
				blockChannelInvites =
				{
					name = BLOCK_CHAT_CHANNEL_INVITE,
					desc = OPTION_TOOLTIP_BLOCK_CHAT_CHANNEL_INVITE,
					type = "toggle",
					set = function(info,val)
						SetCVar("blockChannelInvites",val)
					end,
					get = function(info)
						return GetCVarBool("blockChannelInvites")
					end,
				},
				showToastOnline =
				{
					name = SHOW_TOAST_ONLINE_TEXT,
					desc = OPTION_TOOLTIP_SHOW_TOAST_ONLINE,
					type = "toggle",
					set = function(info,val)
						SetCVar("showToastOnline",val)
					end,
					get = function(info)
						return GetCVarBool("showToastOnline")
					end,
				},
				showToastOffline =
				{
					name = SHOW_TOAST_OFFLINE_TEXT,
					desc = OPTION_TOOLTIP_SHOW_TOAST_OFFLINE,
					type = "toggle",
					set = function(info,val)
						SetCVar("showToastOffline",val)
					end,
					get = function(info)
						return GetCVarBool("showToastOffline")
					end,
				},
				showToastBroadcast =
				{
					name = SHOW_TOAST_BROADCAST_TEXT,
					desc = OPTION_TOOLTIP_SHOW_TOAST_BROADCAST,
					type = "toggle",
					set = function(info,val)
						SetCVar("showToastBroadcast",val)
					end,
					get = function(info)
						return GetCVarBool("showToastBroadcast")
					end,
				},
				showToastFriendRequest =
				{
					name = SHOW_TOAST_FRIEND_REQUEST_TEXT,
					desc = OPTION_TOOLTIP_SHOW_TOAST_FRIEND_REQUEST,
					type = "toggle",
					set = function(info,val)
						SetCVar("showToastFriendRequest",val)
					end,
					get = function(info)
						return GetCVarBool("showToastFriendRequest")
					end,
				},
				showToastWindow =
				{
					name = SHOW_TOAST_WINDOW_TEXT,
					desc = OPTION_TOOLTIP_SHOW_TOAST_WINDOW,
					type = "toggle",
					set = function(info,val)
						SetCVar("showToastWindow",val)
					end,
					get = function(info)
						return GetCVarBool("showToastWindow")
					end,
				},
				enableTwitter =
				{
					name = SOCIAL_ENABLE_TWITTER_FUNCTIONALITY,
					desc = OPTION_TOOLTIP_SOCIAL_ENABLE_TWITTER_FUNCTIONALITY,
					type = "toggle",
					set = function(info,val)
						SetCVar("enableTwitter",val)
					end,
					get = function(info)
						return GetCVarBool("enableTwitter")
					end,
				},
			}
		},
		Display =
		{
			name = DISPLAY_LABEL,
			desc = DISPLAY_SUBTEXT,
			type = "group",
			args =
			{
				rotateMinimap =
				{
					name = ROTATE_MINIMAP,
					desc = OPTION_TOOLTIP_ROTATE_MINIMAP,
					type = "toggle",
					set = function(info,val)
						SetCVar("rotateMinimap",val)
					end,
					get = function(info)
						return GetCVarBool("rotateMinimap")
					end,
					width = "full",
				},
				hideAdventureJournalAlerts =
				{
					name = HIDE_ADVENTURE_JOURNAL_ALERTS,
					desc = OPTION_TOOLTIP_HIDE_ADVENTURE_JOURNAL_ALERTS,
					type = "toggle",
					set = function(info,val)
						SetCVar("hideAdventureJournalAlerts",val)
					end,
					get = function(info)
						return GetCVarBool("hideAdventureJournalAlerts")
					end,
					width = "full",
				},
				showTutorials =
				{
					name = SHOW_TUTORIALS,
					desc = OPTION_TOOLTIP_SHOW_TUTORIALS,
					type = "toggle",
					set = function(info,val)
						SetCVar("showTutorials",val)
					end,
					get = function(info)
						return GetCVarBool("showTutorials")
					end,
					width = "full",
				},
			}
		},
		Mouse =
		{
			name = MOUSE_LABEL,
			desc = MOUSE_SUBTEXT,
			type = "group",
			args =
			{
				enableMouseSpeed =
				{
					name = ENABLE_MOUSE_SPEED,
					desc = OPTION_TOOLTIP_MOUSE_SPEED,
					type = "toggle",
					set = function(info,val)
						SetCVar("enableMouseSpeed",val)
					end,
					get = function(info)
						return GetCVarBool("enableMouseSpeed")
					end,
					width = "full",
				},
				mouseInvertPitch =
				{
					name = INVERT_MOUSE,
					desc = OPTION_TOOLTIP_INVERT_MOUSE,
					type = "toggle",
					set = function(info,val)
						SetCVar("mouseInvertPitch",val)
					end,
					get = function(info)
						return GetCVarBool("mouseInvertPitch")
					end,
					width = "full",
				},
				autointeract =
				{
					name = CLICK_TO_MOVE,
					desc = OPTION_TOOLTIP_CLICK_TO_MOVE,
					type = "toggle",
					set = function(info,val)
						SetCVar("autointeract",val)
					end,
					get = function(info)
						return GetCVarBool("autointeract")
					end,
					width = "full",
				},
				mouseSpeed =
				{
					name = MOUSE_SENSITIVITY,
					desc = OPTION_TOOLTIP_MOUSE_SENSITIVITY,
					type = "range",
					min = 0,
					max = 1.5,
					set = function(info,val)
						SetCVar("mouseSpeed",val)
					end,
					get = function(info)
						return get_cvar_number("mouseSpeed")
					end,
					width = "full",
				},
				cameraYawMoveSpeed =
				{
					name = MOUSE_LOOK_SPEED,
					desc = OPTION_TOOLTIP_MOUSE_LOOK_SPEED,
					type = "range",
					min = 0,
					max = 270,
					set = function(info,val)
						SetCVar("cameraYawMoveSpeed",val)
					end,
					get = function(info)
						return get_cvar_number("cameraYawMoveSpeed")
					end,
					width = "full",
				},
			}
		},
		Names =
		{
			name = NAMES_LABEL,
			desc = NAMES_SUBTEXT,
			type = "group",
			args =
			{
				UnitNameOwn =
				{
					name = UNIT_NAME_OWN,
					desc = OPTION_TOOLTIP_UNIT_NAME_OWN,
					type = "toggle",
					set = function(info,val)
						SetCVar(info[3],val)
					end,
					get = function(info)
						return GetCVarBool(info[3])
					end,
				},
				UnitNameNPC =
				{
					name = UNIT_NAME_NPC,
					desc = OPTION_TOOLTIP_UNIT_NAME_NPC,
					type = "toggle",
					set = function(info,val)
						SetCVar(info[3],val)
					end,
					get = function(info)
						return GetCVarBool(info[3])
					end,
				},
				UnitNameNonCombatCreatureName =
				{
					name = UNIT_NAME_NONCOMBAT_CREATURE,
					desc = OPTION_TOOLTIP_UNIT_NAME_NONCOMBAT_CREATURE,
					type = "toggle",
					set = function(info,val)
						SetCVar(info[3],val)
					end,
					get = function(info)
						return GetCVarBool(info[3])
					end,
				},
				UnitNameFriendlyPlayerName =
				{
					name = UNIT_NAME_FRIENDLY,
					desc = OPTION_TOOLTIP_UNIT_NAME_FRIENDLY,
					type = "toggle",
					set = function(info,val)
						SetCVar(info[3],val)
					end,
					get = function(info)
						return GetCVarBool(info[3])
					end,
				},
				UnitNameFriendlyMinionName =
				{
					name = UNIT_NAME_FRIENDLY_MINIONS,
					desc = OPTION_TOOLTIP_UNIT_NAME_FRIENDLY_MINIONS,
					type = "toggle",
					set = function(info,val)
						SetCVar(info[3],val)
					end,
					get = function(info)
						return GetCVarBool(info[3])
					end,
				},
				UnitNameEnemyPlayerName =
				{
					name = UNIT_NAME_ENEMY,
					desc = OPTION_TOOLTIP_UNIT_NAME_ENEMY,
					type = "toggle",
					set = function(info,val)
						SetCVar(info[3],val)
					end,
					get = function(info)
						return GetCVarBool(info[3])
					end,
				},
				UnitNameEnemyMinionName =
				{
					name = UNIT_NAME_ENEMY_MINIONS,
					desc = OPTION_TOOLTIP_UNIT_NAME_ENEMY_MINIONS,
					type = "toggle",
					set = function(info,val)
						SetCVar(info[3],val)
					end,
					get = function(info)
						return GetCVarBool(info[3])
					end,
				},
				nameplateShowFriends =
				{
					name = UNIT_NAMEPLATES_SHOW_FRIENDS,
					desc = OPTION_TOOLTIP_UNIT_NAMEPLATES_SHOW_FRIENDS,
					type = "toggle",
					set = function(info,val)
						SetCVar(info[3],val)
					end,
					get = function(info)
						return GetCVarBool(info[3])
					end,
				},
				nameplateShowDebuffsOnFriendly =
				{
					type = "toggle",
					name = "nameplateShowDebuffsOnFriendly",
					desc = "Solving Nameplate Tainting issue After 7.3",
					set = function(info,val)
						SetCVar(info[3],val)
					end,
					get = function(info)
						return GetCVarBool(info[3])
					end,
				},
				nameplateShowFriendlyMinions =
				{
					name = UNIT_NAMEPLATES_SHOW_FRIENDLY_MINIONS,
					desc = OPTION_TOOLTIP_UNIT_NAMEPLATES_SHOW_FRIENDLY_MINIONS,
					type = "toggle",
					set = function(info,val)
						SetCVar(info[3],val)
					end,
					get = function(info)
						return GetCVarBool(info[3])
					end,
				},
				nameplateShowEnemies =
				{
					name = UNIT_NAMEPLATES_SHOW_ENEMIES,
					desc = OPTION_TOOLTIP_UNIT_UNIT_NAMEPLATES_SHOW_ENEMIES,
					type = "toggle",
					set = function(info,val)
						SetCVar(info[3],val)
					end,
					get = function(info)
						return GetCVarBool(info[3])
					end,
				},
				nameplateShowEnemyMinions =
				{
					name = UNIT_NAMEPLATES_SHOW_ENEMY_MINIONS,
					desc = OPTION_TOOLTIP_UNIT_NAMEPLATES_SHOW_ENEMY_MINIONS,
					type = "toggle",
					set = function(info,val)
						SetCVar(info[3],val)
					end,
					get = function(info)
						return GetCVarBool(info[3])
					end,
				},
				nameplateShowEnemyMinus =
				{
					name = UNIT_NAMEPLATES_SHOW_ENEMY_MINUS,
					desc = OPTION_TOOLTIP_UNIT_NAMEPLATES_SHOW_ENEMY_MINUS,
					type = "toggle",
					set = function(info,val)
						SetCVar(info[3],val)
					end,
					get = function(info)
						return GetCVarBool(info[3])
					end,
				},
				ShowNamePlateLoseAggroFlash =
				{
					name = SHOW_NAMEPLATE_LOSE_AGGRO_FLASH,
					desc = OPTION_TOOLTIP_SHOW_NAMEPLATE_LOSE_AGGRO_FLASH,
					type = "toggle",
					set = function(info,val)
						SetCVar(info[3],val)
					end,
					get = function(info)
						return GetCVarBool(info[3])
					end,
				},
				nameplateShowAll =
				{
					name = UNIT_NAMEPLATES_AUTOMODE,
					desc = OPTION_TOOLTIP_UNIT_NAMEPLATES_AUTOMODE,
					type = "toggle",
					set = function(info,val)
						SetCVar(info[3],val)
					end,
					get = function(info)
						return GetCVarBool(info[3])
					end,
				},
				nameplateShowSelf =
				{
					name = DISPLAY_PERSONAL_RESOURCE,
					desc = OPTION_TOOLTIP_DISPLAY_PERSONAL_RESOURCE,
					type = "toggle",
					set = function(info,val)
						SetCVar(info[3],val)
					end,
					get = function(info)
						return GetCVarBool(info[3])
					end,
				},
				nameplateResourceOnTarget =
				{
					name = DISPLAY_PERSONAL_RESOURCE_ON_ENEMY,
					desc = OPTION_TOOLTIP_DISPLAY_PERSONAL_RESOURCE_ON_ENEMY,
					type = "toggle",
					set = function(info,val)
						SetCVar(info[3],val)
					end,
					get = function(info)
						return GetCVarBool(info[3])
					end,
				},
				nameplateMaxDistance =
				{
					name = "nameplateMaxDistance",
					type = "range",
					min = 0,
					max = 100,
					set = function(info,val)
						SetCVar("nameplateMaxDistance",val)
					end,
					get = function(info)
						return GetCVar("nameplateMaxDistance")
					end,
				},
--[[				MakeLarger =
				{
					name = UNIT_NAMEPLATES_MAKE_LARGER,
					desc = OPTION_TOOLTIP_UNIT_NAMEPLATES_MAKE_LARGER,
					type = "toggle",
					set = function(info,val)
						SetCVar(info[3],val)
					end,
					get = function(info)
						return GetCVarBool(info[3])
					end,
				},]]
				ShowClassColorInNameplate =
				{
					name = "Show Class Color In Namplate",
					type = "toggle",
					set = function(info,val)
						SetCVar(info[3],val)
						ReloadUI()
					end,
					get = function(info)
						return GetCVarBool(info[3])
					end,
					confirm = true
				},
				ShowClassColorInFriendlyNameplate =
				{
					name = "Show Class Color In Friendly Namplate",
					type = "toggle",
					set = function(info,val)
						SetCVar(info[3],val)
						ReloadUI()
					end,
					get = function(info)
						return GetCVarBool(info[3])
					end,
					confirm = true
				}
			}
		},
		Privacy =
		{
			name = L["Privacy"],
			desc = L["Warning : Turning these options off will lose your privacy. This addon will lock these options to protect your privacy once you turn it on."],
			type = "group",
			args =
			{
				accountAchievements = 
				{
					name = SHOW_ACCOUNT_ACHIEVEMENTS,
					desc = OPTION_TOOLTIP_SHOW_ACCOUNT_ACHIEVEMENTS,
					type = "toggle",
					set = function(info,val)
						if val == true then
							ShowAccountAchievements(true)
						end
					end,
					get = function(info)
						return AreAccountAchievementsHidden()
					end
				}
			}
		},
		Synchronize =
		{
			name = L["Synchronize"],
			desc = L["Whether client settings should be stored on the server"],
			type = "group",
			args =
			{
				synchronizeSettings = 
				{
					name = SETTINGS,
					type = "toggle",
					set = function(info,val)
						SetCVar("synchronizeSettings",val)
					end,
					get = function(info)
						return GetCVarBool("synchronizeSettings")
					end,
				},
				synchronizeConfig = 
				{
					name = L["Config"],
					type = "toggle",
					set = function(info,val)
						SetCVar("synchronizeConfig",val)
					end,
					get = function(info)
						return GetCVarBool("synchronizeConfig")
					end,
				},
				synchronizeBindings = 
				{
					name = KEY_BINDINGS_MAC,
					type = "toggle",
					set = function(info,val)
						SetCVar("synchronizeBindings",val)
					end,
					get = function(info)
						return GetCVarBool("synchronizeBindings")
					end,
				},
				synchronizeMacros = 
				{
					name = MACROS,
					type = "toggle",
					set = function(info,val)
						SetCVar("synchronizeMacros",val)
					end,
					get = function(info)
						return GetCVarBool("synchronizeMacros")
					end,
				},
				synchronizeChatFrames = 
				{
					name = L["Chat Frames"],
					type = "toggle",
					set = function(info,val)
						SetCVar("synchronizeChatFrames",val)
					end,
					get = function(info)
						return GetCVarBool("synchronizeChatFrames")
					end,
				},
				forceEnglishNames = 
				{
					order = -1,
					name = L["Force English Names"],
					type = "toggle",
					set = function(info,val)
						SetCVar("forceEnglishNames",val)
					end,
					get = function(info)
						return GetCVarBool("forceEnglishNames")
					end,
				},
			}
		}
	}
}

ControlPanel_Options:push("Interface",Interface)
