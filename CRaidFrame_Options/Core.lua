local AceAddon = LibStub("AceAddon-3.0")

local CRaidFrame = AceAddon:GetAddon("CRaidFrame")
local CRaidFrame_Options = AceAddon:NewAddon("CRaidFrame_Options")
local L = LibStub("AceLocale-3.0"):GetLocale("CRaidFrame")

local rswidth,rsheight = GetCVar("gxFullscreenResolution"):match("(%d+)x(%d+)")
rswidth = tonumber(rswidth)
rsheight = tonumber(rsheight)

local order = 0

local function get_order()
	local temp = order
	order = order + 1
	return temp
end


local temp_tb = {}
local temp1_tb = {}
local concat_tb = {}
local filters = {}
local filters_select_sup = {}
local mouse_keybuttons = {[0]=SPELL_TARGET_TYPE1_DESC}

for i=1,31 do
	local kbn = _G["KEY_BUTTON"..i]
	if kbn then
		mouse_keybuttons[i] = kbn
	else
		break
	end
end

local function concat(str)
	if str then
		wipe(concat_tb)
		if temp_tb.any then
			concat_tb[#concat_tb+1] = "*"
		else
			if temp_tb.alt then
				concat_tb[#concat_tb+1] = "alt-"
			end
			if temp_tb.ctrl then
				concat_tb[#concat_tb+1] = "ctrl-"
			end
			if temp_tb.shift then
				concat_tb[#concat_tb+1] = "shift-"
			end
		end
		if temp_tb.mouse then
			concat_tb[#concat_tb+1] = str		
			if temp_tb.mouse == 0 then
				concat_tb[#concat_tb+1] = "*"
			else
				concat_tb[#concat_tb+1] = temp_tb.mouse
			end
		else
			return
		end
		return table.concat(concat_tb)
	end
end

local function update_crf()
	if not InCombatLockdown() and CRaidFrame.Update then
		CRaidFrame.Update()
	end
end

function CRaidFrame_Options:OnInitialize()
	local profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(CRaidFrame.db)
	LibStub('LibDualSpec-1.0'):EnhanceOptions(profile, CRaidFrame.db)
	profile.order = -1
	if CRaidFrame.Update then
		CRaidFrame.db.RegisterCallback(CRaidFrame, "OnProfileChanged", "Update")
		CRaidFrame.db.RegisterCallback(CRaidFrame, "OnProfileCopied", "Update")
		CRaidFrame.db.RegisterCallback(CRaidFrame, "OnProfileReset", "Update")
	end
	local aid,ap
	local cct = {}
	local generate = {}
	local reloadui =
	{
		name = RELOADUI,
		type = "execute",
		confirm = true,
		func = ReloadUI
	}
	local idf= 
	{
		name = function()
			if aid then
				return ID.."("..GetSpellInfo(aid)..")"
			else
				return ID
			end
		end,
		type = "input",
		order = get_order(),
		set = function(_,val)
			if val:len() == 0 then
				aid = nil
			else
				local a = tonumber(val)
				if GetSpellInfo(a) then
					aid = a
				end
			end
		end,
		get = function()
			if aid then
				return tostring(aid)
			end
		end,
		pattern = "^[0-9]*$"
	}
	local pdf =
	{
		name = "Priority",
		type = "input",
		pattern = "^[0-9]*$",
		order = get_order(),
		set = function(_,val)
			if val:len() == 0 then
				ap = nil
			else
				local v = tonumber(val)
				if v < 62 then
					ap = v
				else
					ap = 63
				end
			end
		end,
		get = function()
			if ap then
				return tostring(ap)
			end
		end,
	}
	local function factory(ss,tt)
		local select_tb = {}
		return
		{
			id = idf,
			priority = pdf,
			add =
			{
				name = ADD,
				type = "execute",
				order = get_order(),
				func = function()
					if aid then
						CRaidFrame.db.profile[ss][aid] = ap
						update_crf()
					end
				end
			},
			reset =
			{
				name = RESET,
				type = "execute",
				order = get_order(),
				func = function() wipe(select_tb) end
			},
			rmv =
			{
				name = REMOVE,
				type = "execute",
				order = get_order(),
				func = function()
					local s = CRaidFrame.db.profile[ss]
					for k,v in pairs(select_tb) do
						s[k] = nil
					end
					wipe(select_tb)
					update_crf()
				end
			},
			reset = reset_idf,
			enable =
			{
				name = ENABLE,
				type = "toggle",
				order = get_order(),
				get = function()
					return CRaidFrame.db.profile[tt]
				end,
				set = function(info,val)
					if val then
						CRaidFrame.db.profile[tt] = true
					else
						CRaidFrame.db.profile[tt] = nil
					end
					update_crf()
				end
			},
			filters_s =
			{
				name = FILTERS,
				type = "multiselect",
				order = get_order(),
				values = function()
					local s = CRaidFrame.db.profile[ss]
					wipe(generate)
					for k,v in pairs(CRaidFrame.db.profile[ss]) do
						wipe(cct)
						cct[#cct+1] = k
						cct[#cct+1] = " ("
						cct[#cct+1] = GetSpellInfo(k)
						cct[#cct+1] = ") "
						cct[#cct+1] = v
						generate[k] = table.concat(cct)
					end
					return generate
				end,
				set = function(_,key,val)
					if val then
						select_tb[key] = true
					else
						select_tb[key] = nil
					end
				end,
				get = function(_,key)
					return select_tb[key]
				end,
				width = "full",
			},
		}
	end
	
	LibStub("AceConfig-3.0"):RegisterOptionsTable("CRaidFrame", 
	{
		type = "group",
		name = "CRaidFrame",
		args =
		{
			options =
			{
				type = "group",
				name = OPTIONS,
				args =
				{
					lock =
					{
						name = LOCK,
						type = "toggle",
						get = function()
							return not CRaidFrame.db.profile.lock
						end,
						set = function(_,val)
							if InCombatLockdown() then
								return
							end
							if val then
								CRaidFrame.db.profile.lock = nil
							else
								CRaidFrame.db.profile.lock = true
							end
							update_crf()
						end
					},
					release =
					{
						name = "Release",
						type = "toggle",
						get = function()
							return CRaidFrame.db.profile.release
						end,
						set = function(_,val)
							if InCombatLockdown() then
								return
							end
							if val then
								CRaidFrame.db.profile.release = true
							else
								CRaidFrame.db.profile.release = nil
							end
							CRaidFrame.Update = nil
							update_crf=nop
							collectgarbage("collect")
						end
					},
					left =
					{
						name = L.Left,
						type = "range",
						min = 0,
						max = rswidth,
						order = 3,
						step = 0.01,
						get = function()
							return CRaidFrame.db.profile.left
						end,
						set = function(info,val)
							CRaidFrame.db.profile.left = val
							update_crf()
						end,
					},
					bottom =
					{
						name = L.Bottom,
						type = "range",
						min = 0,
						max = rsheight,
						order = 3,
						step = 0.01,
						get = function(info)
							return CRaidFrame.db.profile.bottom
						end,
						set = function(info,val)
							CRaidFrame.db.profile.bottom = val
							update_crf()
						end,
					},
					width =
					{
						name = COMPACT_UNIT_FRAME_PROFILE_FRAMEWIDTH,
						type = "range",
						min = 0,
						max = rswidth,
						step = 0.01,
						order = 2,
						get = function()
							return CRaidFrame.db.profile.width
						end,
						set = function(info,val)
							CRaidFrame.db.profile.width = val
							update_crf()
						end,
					},
					height =
					{
						name = COMPACT_UNIT_FRAME_PROFILE_FRAMEHEIGHT,
						type = "range",
						order = 2,
						min = 0,
						max = rsheight,
						step = 0.01,
						get = function(info)
							return CRaidFrame.db.profile.height
						end,
						set = function(info,val)
							CRaidFrame.db.profile.height = val
							update_crf()
						end,
					},
					font =
					{
						type = 'select',
						dialogControl = 'LSM30_Font',
						name = L.Font,
						values = AceGUIWidgetLSMlists.font,
						get = function()
							return CRaidFrame.db.profile.font
						end,
						set = function(self,key)
							CRaidFrame.db.profile.font = key
							update_crf()
						end,
					},
					font_size =
					{
						name = FONT_SIZE,
						type = "range",
						min = 0,
						max = rswidth,
						step = 0.01,
						set = function(_,val)
							CRaidFrame.db.profile.font_size = val
							update_crf()
						end,
						get = function()
							return CRaidFrame.db.profile.font_size
						end
					},
					border_size =
					{
						name = L["Border Size"],
						type = "range",
						min = 0,
						max = rswidth,
						step = 0.01,
						set = function(_,val)
							CRaidFrame.db.profile.border_size = val
							update_crf()
						end,
						get = function()
							return CRaidFrame.db.profile.border_size
						end
					},
					statusbar=
					{
						name = TEXTURES_SUBHEADER,
						type = 'select',
						dialogControl = 'LSM30_Statusbar',
						values = AceGUIWidgetLSMlists.statusbar,
						get = function()
							return CRaidFrame.db.profile.statusbar
						end,
						set = function(self,key)
							CRaidFrame.db.profile.statusbar = key
							update_crf()
						end,
						width = "full",
					},
					background =
					{
						name = BACKGROUND,
						type = 'select',
						dialogControl = 'LSM30_Background',
						values = AceGUIWidgetLSMlists.background,
						get = function()
							return CRaidFrame.db.profile.background
						end,
						set = function(self,key)
							CRaidFrame.db.profile.background = key
							update_crf()
						end,
						width = "full",
					},
					border =
					{
						name = L.Border,
						type = 'select',
						dialogControl = 'LSM30_Border',
						values = AceGUIWidgetLSMlists.border,
						get = function()
							return CRaidFrame.db.profile.border
						end,
						set = function(self,key)
							CRaidFrame.db.profile.border = key
							update_crf()
						end,
						width = "full",
					},
					solo =
					{
						name = SOLO,
						get = function()
							return not CRaidFrame.db.profile.show_solo
						end,
						set = function(self,key)
							if key then
								CRaidFrame.db.profile.show_solo = nil
							else
								CRaidFrame.db.profile.show_solo = true
							end
							update_crf()
						end,
						type = "toggle",
						width = "full",
					},
					anchor = 
					{
						name = L.Anchor,
						type = "select",
						values = {"TOPLEFT","TOPRIGHT","BOTTOMLEFT","BOTTOMRIGHT"},
						get = function()
							return CRaidFrame.db.profile.anchor or 3
						end,
						set = function(self,key)
							if key == 3 then
								CRaidFrame.db.profile.anchor = nil
							else
								CRaidFrame.db.profile.anchor = key
							end
							update_crf()
						end,
						order = 5,
					},
					horizontal =
					{
						name = COMPACT_UNIT_FRAME_PROFILE_HORIZONTALGROUPS,
						type = 'toggle',
						get = function()
							return not CRaidFrame.db.profile.vertical
						end,
						set = function(_,key)
							if key then
								CRaidFrame.db.profile.vertical = nil
							else
								CRaidFrame.db.profile.vertical = true
							end
							update_crf()						
						end
					},
					resourcebar =
					{
						name = L["Resource Bar"],
						type = "toggle",
						get = function()
							return CRaidFrame.db.profile.resourcebar
						end,
						set = function(_,v)
							CRaidFrame.db.profile.resourcebar=v
							update_crf()
						end,
						tristate = true
					},
					resourcebar_length =
					{
						name = L["Resource Bar Length"],
						type = 'range',
						min = 0,
						max = rsheight,
						get = function()
							return CRaidFrame.db.profile.resourcebar_length
						end,
						set = function(_,v)
							local profile = CRaidFrame.db.profile
							if v == 0 then
								profile.resourcebar = true
								profile.resourcebar_length = 0
							else
								local mx_length
								if profile.vertical then
									mx_length = math.abs(profile.width)
								else
									mx_length = math.abs(profile.height)
								end
								if v <= mx_length then
									profile.resourcebar_length = v
								end
							end
							update_crf()						
						end
					},
					enable_blizzard =
					{
						name = "Blizzard Compact Raid Frames",
						type = "toggle",
						get = function()
							return IsAddOnLoaded("Blizzard_CompactRaidFrames")
						end,
						confirm = true,
						set = function(_,v)
							local loaded = IsAddOnLoaded("Blizzard_CompactRaidFrames")
							local func
							if loaded then
								func = DisableAddOn
							else
								func = EnableAddOn
							end
							func("Blizzard_CompactRaidFrames")
							func("Blizzard_CUFProfiles")
							ReloadUI()
						end						
					},
				}
			},
			bindings =
			{
				type = "group",
				name = KEY_BINDINGS_MAC,
				childGroups = "select",
				args =
				{
					mouse =
					{
						name = MOUSE_LABEL,
						type = "select",
						order = get_order(),
						values = mouse_keybuttons,
						get = function(_,key)
							return temp_tb.mouse
						end,
						set = function(_,key)
							temp_tb.mouse = key
						end
					},
					value =
					{
						name = STATUS_TEXT_VALUE,
						set = function(_,val)
							if val~="" then
								temp_tb.mouse = tonumber(val)
							end
						end,
						get = function()
							if temp_tb.mouse then
								if temp_tb.mouse == 0 then
									return "*"
								else
									return tostring(temp_tb.mouse)
								end
							end
						end,
						order = get_order(),
						type = "input",
						pattern = "^[0-9]*$",
					},
					kb =
					{
						name = "ALT/CTRL/SHIFT+",
						type = "description",
						order = get_order()
					},
					any =
					{
						name = SPELL_TARGET_TYPE1_DESC,
						type = 'toggle',
						order = get_order(),
						set = function(_,val)
							temp_tb.any = val
						end,
						get = function(_,key)
							return temp_tb.any
						end
					},
					alt =
					{
						name = "ALT",
						type = 'toggle',
						order = get_order(),
						set = function(_,val)
							temp_tb.alt = val
						end,
						get = function(_,key)
							return temp_tb.alt
						end
					},
					ctrl =
					{
						name = "CTRL",
						type = 'toggle',
						order = get_order(),
						set = function(_,val)
							temp_tb.ctrl = val
						end,
						get = function(_,key)
							return temp_tb.ctrl
						end
					},
					shift =
					{
						name = "SHIFT",
						type = 'toggle',
						order = get_order(),
						set = function(_,val)
							temp_tb.shift = val
						end,
						get = function(_,key)
							return temp_tb.shift
						end
					},
					cpl =
					{
						name = function()
							temp1_tb.keybd = concat("type")
							return temp1_tb.keybd
						end,
						order = get_order(),
						type = "description",
					},
					cpl1 =
					{
						name = function()
							return temp1_tb[1]
						end,
						order = get_order(),
						type = "description",
					},
					cpl2 =
					{
						name = function()
							if temp1_tb[2] then
								if temp1_tb[3] then
									temp1_tb.subbd = concat(temp1_tb[3])
									temp1_tb.disablebd = concat(temp1_tb[1])
								else
									temp1_tb.subbd = concat(temp1_tb[1])
								end
								return temp1_tb.subbd
							end
						end,
						order = get_order(),
						type = "description",
					},
					cpl3 =
					{
						name = function()
							return temp1_tb[2]
						end,
						order = get_order(),
						type = "description",
					},
					add =
					{
						name = ADD,
						type = "execute",
						order = get_order(),
						func = function()
							if InCombatLockdown() then
								return
							end
							local bindings = CRaidFrame.db.profile.bindings
							local kbd = temp1_tb.keybd
							if kbd and temp1_tb[1] then
								for i=1,#bindings do
									if bindings[i][1] == kbd then
										return
									end
								end
								if temp1_tb[2] then
									bindings[#bindings+1] = {kbd,temp1_tb[1],temp1_tb.subbd,temp1_tb[2],temp1_tb.disablebd}
								else
									bindings[#bindings+1] = {kbd,temp1_tb[1]}									
								end
								update_crf()
							end
						end
					},
					reset =
					{
						name = RESET,
						type = "execute",
						order = get_order(),
						func = function()
							wipe(temp_tb)
							wipe(temp1_tb)
							wipe(filters_select_sup)
						end
					},
					filters_s =
					{
						name = FILTERS,
						type = "multiselect",
						order = get_order(),
						values = function()
							wipe(filters)
							local bindings = CRaidFrame.db.profile.bindings
							for i=1,#bindings do
								filters[#filters+1] = table.concat(bindings[i],"   ")
							end
							return filters
						end,
						set = function(_,key,val)
							if val then
								filters_select_sup[key] = true
							else
								filters_select_sup[key] = nil
							end
						end,
						get = function(_,key)
							return filters_select_sup[key]
						end,
						width = "full",
					},
					rmv = 
					{
						name = REMOVE,
						type = "execute",
						order = get_order(),
						func = function()
							if InCombatLockdown() then
								return
							end
							local bds = CRaidFrame.db.profile.bindings
							if bds then
								local tb = {}
								local i
								for i = 1,#bds do
									local ele = bds[i]
									if not filters_select_sup[i] then
										tb[#tb+1] = ele
									else
										ele[2] = nil
										ele[3] = nil	
									end
								end
								update_crf()
								CRaidFrame.db.profile.bindings = tb
								wipe(filters_select_sup)
							end
						end
					},
					spell = 
					{
						type = "group",
						name = BOOKTYPE_SPELL,
						args =
						{
							id =
							{
								name = ID,
								order = get_order(),
								type = "input",
								set = function(_,val)
									wipe(temp1_tb)
									if val ~= "" then
										val = tonumber(val)
										local name = GetSpellInfo(val)
										if name then
											temp1_tb.spellid = val
											temp1_tb.spellname = name
											temp1_tb[1] = "spell"											
											temp1_tb[2] = name
										end
									end
								end,
								get = function()
									if temp1_tb.spellid then
										return tostring(temp1_tb.spellid)
									end
								end,
								pattern = "^[0-9]*$",
							},
							name =
							{
								name = NAME,
								order = get_order(),
								type = "input",
								set = function(_,val)
									wipe(temp1_tb)								
									if val == "" then
										temp1_tb.spellname = nil
										return
									end
									temp1_tb.spellname = val
									temp1_tb[1] = "spell"									
									temp1_tb[2] = val
								end,
								get = function()
									return temp1_tb.spellname
								end,
							},
						}
					},
					target =
					{
						type = "group",
						name = TARGET,
						args =
						{
							target =
							{
								name = TARGET,
								type = "toggle",
								set = function(_,val)
									wipe(temp1_tb)
									if val then
										temp1_tb[1] = "target"
										temp1_tb.target = val
									end
								end,
								get = function(_,key)
									return temp1_tb.target
								end
							},
							focus =
							{
								name = FOCUS,
								type = "toggle",
								set = function(_,val)
									wipe(temp1_tb)
									if val then
										temp1_tb[1] = "focus"
										temp1_tb.focus = val
									end
								end,
								get = function(_,key)
									return temp1_tb.focus
								end
							},
							assist =
							{
								name = PET_MODE_ASSIST,
								type = "toggle",
								set = function(_,val)
									wipe(temp1_tb)
									if val then
										temp1_tb[1] = "assist"
										temp1_tb.assist = val
									end
								end,
								get = function(_,key)
									return temp1_tb.assist
								end
							},
						},
					},
					macro =
					{
						type = "group",
						name = MACRO,
						args =
						{
							name =
							{
								name = NAME,
								type = "input",
								set = function(_,val)
									wipe(temp1_tb)								
									if val == "" then
										temp1_tb.macro = nil
										return
									end
									temp1_tb.macro = val
									temp1_tb[1] = "macro"								
									temp1_tb[2] = val
								end,
								get = function()
									return temp1_tb.macro
								end,
								width = "full"
							},
							text =
							{
								name = LOCALE_TEXT_LABEL,
								type = "input",
								set = function(_,val)
									wipe(temp1_tb)								
									if val == "" then
										temp1_tb.macro_text = nil
										return
									end
									temp1_tb.macro_text = val
									temp1_tb[1] = "macro"								
									temp1_tb[2] = val
									temp1_tb[3] = "macrotext"
								end,
								get = function()
									return temp1_tb.macro_text
								end,
								multiline = true,
								width = "full"
							},
						}
					},
					togglemenu =
					{
						type = "group",
						name = MAINMENU_BUTTON,
						args =
						{
							togglemenu =
							{
								name = MAINMENU_BUTTON,
								order = get_order(),
								type = "toggle",
								order = get_order(),
								set = function(_,val)
									wipe(temp1_tb)
									if val then
										temp1_tb[1] = "togglemenu"
										temp1_tb.togglemenu = val
									end
								end,
								get = function(_,key)
									return temp1_tb.togglemenu
								end
							}
						}
					},
					cancelaura =
					{
						type = "group",
						name = "cancelaura",
						args =
						{
							index =
							{
								name = "index",
								order = get_order(),
								type = "input",
								set = function(_,val)
									wipe(temp1_tb)
									if val ~= "" then
										val = tonumber(val)
										temp1_tb.cancelaura_index = val
										temp1_tb[1] = "cancelaura"									
										temp1_tb[2] = val
									end
								end,
								get = function()
									if temp1_tb.cancelaura_index then
										return tostring(temp1_tb.cancelaura_index)
									end
								end,
								pattern = "^[0-9]*$",
								width = "full",
							},
							id =
							{
								name = ID,
								order = get_order(),
								type = "input",
								set = function(_,val)
									wipe(temp1_tb)
									if val ~= "" then
										val = tonumber(val)
										local name = GetSpellInfo(val)
										if name then
											temp1_tb.cancel_aura_spellid = val
											temp1_tb.cancel_aura_spellname = name
											temp1_tb[1] = "cancelaura"											
											temp1_tb[2] = name
											temp1_tb[3] = "index"											
										end
									end
								end,
								get = function()
									if temp1_tb.cancel_aura_spellid then
										return tostring(temp1_tb.cancel_aura_spellid)
									end
								end,
								pattern = "^[0-9]*$",
							},
							name =
							{
								name = NAME,
								order = get_order(),
								type = "input",
								set = function(_,val)
									wipe(temp1_tb)								
									if val == "" then
										temp1_tb.cancel_aura_spellname = nil
										return
									end
									temp1_tb[1] = "cancelaura"									
									temp1_tb.cancel_aura_spellname = val
									temp1_tb[2] = val
									temp1_tb[3] = "index"									
								end,
								get = function()
									return temp1_tb.cancel_aura_spellname
								end,
							},
						}
					}
				}
			},
			buff_options =
			{
				name = BUFFOPTIONS_LABEL,
				type = "group",
				args =
				{
					reset =
					{
						name = RESET,
						type = "execute",
						confirm = true,
						func = function()
							local profile = CRaidFrame.db.profile
							wipe(profile.self_buff)
							profile.buffs = nil
							profile.debuffs = nil
							ReloadUI()
						end
					},
					buffs = 
					{
						name = SHOW_BUFFS,
						type = "range",
						min = 3,
						max = 10,
						step = 1,
						set = function(_,val)
							CRaidFrame.db.profile.buffs = val
						end,
						get = function()
							return CRaidFrame.db.profile.buffs
						end
					},
					debuffs = 
					{
						name = SHOW_DEBUFFS,
						type = "range",
						min = 3,
						max = 10,
						step = 1,
						set = function(_,val)
							CRaidFrame.db.profile.debuffs = val
						end,
						get = function()
							return CRaidFrame.db.profile.debuffs
						end
					},
					reloadui = reloadui
				}
			},
			tooltip =
			{
				name = "Tooltip",
				type = "group",
				args =
				{
					player_tooltip =
					{
						name = PLAYER,
						type = "toggle",
						set = function(_,val)
							if val then
								CRaidFrame.db.profile.player_tooltip = nil
							else
								CRaidFrame.db.profile.player_tooltip = true
							end
						end,
						get = function()
							return not CRaidFrame.db.profile.player_tooltip
						end
					},
					tooltip =
					{
						name = BUFFOPTIONS_LABEL,
						type = "toggle",
						set = function(_,val)
							if val then
								CRaidFrame.db.profile.tooltip = nil
							else
								CRaidFrame.db.profile.tooltip = true
							end
						end,
						get = function()
							return not CRaidFrame.db.profile.tooltip
						end
					},
					reloadui = reloadui
				}
			},
			filters =
			{
				name = FILTERS,
				type = "group",
				childGroups = "tab",
				args =
				{
					buffs =
					{
						name = "Buffs",
						type = "group",
						args = factory(1,"b")
					},
					debuffs =
					{
						name = "Debuffs",
						type = "group",
						args = factory(2,"d")
					}
				}

			},
			refresh =
			{
				name = REFRESH,
				type = "group",
				args =
				{
					timer =
					{
						name = L.Timer,
						type = "toggle",
						set = function(_,val)
							if val then
								CRaidFrame.db.profile.timer = true
							else
								CRaidFrame.db.profile.timer = nil
							end
							update_crf()
						end,
						get = function()
							return CRaidFrame.db.profile.timer
						end
					},
					refresh_rate =
					{
						name = REFRESH_RATE,
						type = "range",
						min = 0,
						max = 10,
						step = 0.01,
						set = function(_,val)
							local profile = CRaidFrame.db.profile
							profile.refresh_rate = val
							if val == 0 then
								profile.timer = nil
							end
							update_crf()
						end,
						get = function()
							return CRaidFrame.db.profile.refresh_rate
						end
					},
					event =
					{
						name = EVENTS_LABEL,
						type = "toggle",
						set = function(_,val)
							if val then
								CRaidFrame.db.profile.event = nil
							else
								CRaidFrame.db.profile.event = true
							end
							update_crf()
						end,
						get = function()
							return not CRaidFrame.db.profile.event
						end
					},
					unit_health_frequent =
					{
						name = "UNIT_HEALTH_FREQUENT",
						type = "toggle",
						set = function(t,val)
							if val then
								CRaidFrame.db.profile.disable_unit_health_frequent = nil
							else
								CRaidFrame.db.profile.disable_unit_health_frequent = true
							end
							update_crf()
						end,
						get = function(t)
							return not CRaidFrame.db.profile.disable_unit_health_frequent
						end,
						width = "full"
					},
					unit_aura =
					{
						name = "UNIT_AURA",
						type = "toggle",
						set = function(t,val)
							if val then
								CRaidFrame.db.profile.disable_unit_aura = nil
							else
								CRaidFrame.db.profile.disable_unit_aura = true
							end
							update_crf()
						end,
						get = function(t)
							return not CRaidFrame.db.profile.disable_unit_aura
						end,
						width = "full"
					},
				}
			},
			profile = profile
		}
	})
	CRaidFrame.RegisterMessage(CRaidFrame_Options,"CRF_ChatCommand")
end

function CRaidFrame_Options:OnEnable()
end

function CRaidFrame_Options:CRF_ChatCommand(message,input)
	if not input or input:trim() == "" then
		LibStub("AceConfigDialog-3.0"):Open("CRaidFrame")
	else
		LibStub("AceConfigCmd-3.0"):HandleCommand("CRaidFrame", "CRaidFrame",input)
	end
end
