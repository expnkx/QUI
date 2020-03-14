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
local ipairs = ipairs

local RestartGx = RestartGx

local post_process_anti_aliasings = {VIDEO_OPTIONS_NONE,ANTIALIASING_FXAA_LOW,ANTIALIASING_FXAA_HIGH,ANTIALIASING_CMAA}
local resample_qualities = {RESAMPLE_QUALITY_BILINEAR,RESAMPLE_QUALITY_BICUBIC}
local screenshot_formats = { jpg = "jpg", jpeg = "jpeg", tga = "tga"}
local MSAA_qualities = { ["0"] = VIDEO_OPTIONS_NONE, 
				["1,0"]=string_format(ADVANCED_ANTIALIASING_MSAA_FORMAT,2,2),
				["2,0"]=string_format(ADVANCED_ANTIALIASING_MSAA_FORMAT,4,4),
				["2,1"]=string_format(ADVANCED_ANTIALIASING_MSAA_FORMAT,4,8),["2,2"]=string_format(ADVANCED_ANTIALIASING_MSAA_FORMAT,4,16),
				["3,0"]=string_format(ADVANCED_ANTIALIASING_MSAA_FORMAT,8,8)}
local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

local Graphics

function ControlPanel_Options:CreateGraphics(o)
	if Graphics == nil then
		Graphics =
		{
			name = GRAPHICS_LABEL,
			type = "group",
			order = o,
			args =
			{
				hdPlayerModels =
				{
					order = get_order(),
					name = SHOW_HD_MODELS_TEXT,
					desc = OPTION_TOOLTIP_SHOW_HD_MODELS,
					type = "toggle",
					set = function(info,val)
						ControlPanel:SetCVarInstance(info[1],"hdPlayerModels",val)
					end,
					get = function(info)
						return ControlPanel:GetCVarBoolInstance(info[1],"hdPlayerModels")
					end,
					width = "full",
				},
				useUiScale =
				{
					order = get_order(),
					name = USE_UISCALE,
					desc = OPTION_TOOLTIP_USE_UISCALE,
					type = "toggle",
					set = function(info,val)
						ControlPanel:SetCVarInstance(info[1],"useUiScale",val)
					end,
					get = function(info)
						return ControlPanel:GetCVarBoolInstance(info[1],"useUiScale")
					end,
				},
				uiScale =
				{
					order = get_order(),
					name = UI_SCALE,
					desc = OPTION_TOOLTIP_UI_SCALE,
					type = "range",
					min = 0,
					max = 10,
					set = function(info,val)
						ControlPanel:SetCVarInstance(info[1],"uiScale",val)
					end,
					get = function(info)
						return ControlPanel:GetCVarNumberInstance(info[1],"uiScale")
					end,
				},
				physicsLevel = 
				{
					order = get_order(),
					name = PHYSICS_INTERACTION,
					desc = OPTION_PHYSICS_OPTIONS,
					type = "range",
					min = 0,
					max = 2,
					step = 1,
					set = function(info,val)
						ControlPanel:SetCVarInstance(info[1],"physicsLevel",val)
					end,
					get = function(info)
						return ControlPanel:GetCVarNumberInstance(info[1],"physicsLevel")
					end,
				},
				Anti_Aliasing =
				{
					order = get_order(),
					name = ANTIALIASING,
					desc = OPTION_TOOLTIP_ANTIALIASING,
					type = "group",
					args =
					{
						ffxAntiAliasingMode =
						{
							order = get_order(),
							name = POSTPROCESS_ANTI_ALIASING,
							desc = OPTION_TOOLTIP_ADVANCED_PPAA,
							type = "select",
							values = post_process_anti_aliasings,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"ffxAntiAliasingMode",val-1)
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"ffxAntiAliasingMode")+1
							end,
							width = "full",
						},
						MSAA =
						{
							order = get_order(),
							name = "MSAA",
							desc = MULTISAMPLE_ANTIALIASING,
							type = "group",
							args =
							{
								MSAAQuality =
								{
									order = get_order(),
									name = MULTISAMPLE_ANTIALIASING,
									desc = OPTION_TOOLTIP_ADVANCED_MSAA,
									type = "select",
									values = MSAA_qualities,
									set = function(info,val)
										ControlPanel:SetCVarInstance(info[1],"MSAAQuality",val)
									end,
									get = function(info)
										return ControlPanel:GetCVarInstance(info[1],"MSAAQuality")
									end,
									width = "full",
								},
								MSAAAlphaTest =
								{
									order = get_order(),
									name = MULTISAMPLE_ALPHA_TEST,
									desc = OPTION_TOOLTIP_MULTISAMPLE_ALPHA_TEST,
									type = "toggle",
									set = function(info,val)
										ControlPanel:SetCVarInstance(info[1],"MSAAAlphaTest",val)
									end,
									get = function(info)
										return ControlPanel:GetCVarBoolInstance(info[1],"MSAAAlphaTest")
									end,
									width = "full",
								}
							}
						},
						SSAA =
						{
							order = get_order(),
							name = "SSAA",
							desc = "Supersampling Anti-aliasing",
							type = "group",
							args =
							{
								RenderScale =
								{
									order = get_order(),
									name = RENDER_SCALE,
									desc = OPTION_TOOLTIP_RENDER_SCALE,
									type = "range",
									min = 0,
									max = 2,
									set = function(info,val)
										ControlPanel:SetCVarInstance(info[1],"RenderScale",val)
									end,
									get = function(info)
										return ControlPanel:GetCVarNumberInstance(info[1],"RenderScale")
									end,
								},
								ResampleQuality =
								{
									order = get_order(),
									name = RESAMPLE_QUALITY,
									desc = OPTION_TOOLTIP_RESAMPLE_QUALITY,
									type = "select",
									values = resample_qualities,
									set = function(info,val)
										ControlPanel:SetCVarInstance(info[1],"ResampleQuality",val-1)
									end,
									get = function(info)
										return ControlPanel:GetCVarNumberInstance(info[1],"ResampleQuality")+1
									end,
								}
							}
						},
					}
				},

				Textures =
				{
					order = get_order(),
					name = TEXTURES_SUBHEADER,
					type = "group",
					args =
					{
						graphicsTextureResolution = 
						{
							order = get_order(),
							name = TEXTURE_DETAIL,
							desc = OPTION_TOOLTIP_TEXTURE_DETAIL,
							type = "range",
							min = 1,
							max = 3,
							step = 1,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"graphicsTextureResolution",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"graphicsTextureResolution")
							end,
						},
						graphicsTextureFiltering = 
						{
							order = get_order(),
							name = ANISOTROPIC,
							desc = OPTION_TOOLTIP_ANISOTROPIC,
							type = "range",
							min = 1,
							max = 6,
							step = 1,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"graphicsTextureFiltering",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"graphicsTextureFiltering")
							end,
						},
						graphicsProjectedTextures = 
						{
							order = get_order(),
							name = PROJECTED_TEXTURES,
							desc = OPTION_TOOLTIP_PROJECTED_TEXTURES,
							type = "toggle",
							set = function(info,val)
								if val == true then
									ControlPanel:SetCVarInstance(info[1],"graphicsProjectedTextures",2)
								else
									ControlPanel:SetCVarInstance(info[1],"graphicsProjectedTextures",1)
								end
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"graphicsProjectedTextures")==2
							end,
						}
					}
				},
				Environment =
				{
					order = get_order(),
					name = ENVIRONMENT_SUBHEADER,
					type = "group",
					args = 
					{
						graphicsViewDistance = 
						{
							order = get_order(),
							name = FARCLIP,
							desc = OPTION_TOOLTIP_FARCLIP,
							type = "range",
							min = 1,
							max = 10,
							step = 1,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"graphicsViewDistance",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"graphicsViewDistance")
							end,
						},
						graphicsEnvironmentDetail = 
						{
							order = get_order(),
							name = ENVIRONMENT_DETAIL,
							desc = OPTION_TOOLTIP_ENVIRONMENT_DETAIL,
							type = "range",
							min = 1,
							max = 10,
							step = 1,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"graphicsEnvironmentDetail",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"graphicsEnvironmentDetail")
							end,
						},
						graphicsGroundClutter = 
						{
							order = get_order(),
							name = GROUND_CLUTTER,
							desc = OPTION_TOOLTIP_GROUND_CLUTTER,
							type = "range",
							min = 1,
							max = 10,
							step = 1,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"graphicsGroundClutter",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"graphicsGroundClutter")
							end,
						},
					}
				},
				Effects =
				{
					order = get_order(),
					name = EFFECTS_SUBHEADER,
					type = "group",
					args = 
					{
						Gamma =
						{
							order = get_order(),
							name = GAMMA,
							desc = OPTION_TOOLTIP_GAMMA,
							type = "range",
							min = 0,
							max = 3,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"GAMMA",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"GAMMA")
							end,
						},
						graphicsShadowQuality = 
						{
							order = get_order(),
							name = SHADOW_QUALITY,
							desc = OPTION_TOOLTIP_SHADOW_QUALITY,
							type = "range",
							min = 1,
							max = 6,
							step = 1,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"graphicsShadowQuality",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"graphicsShadowQuality")
							end,
						},
						graphicsLiquidDetail = 
						{
							order = get_order(),
							name = LIQUID_DETAIL,
							desc = OPTION_TOOLTIP_LIQUID_DETAIL,
							type = "range",
							min = 1,
							max = 4,
							step = 1,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"graphicsLiquidDetail",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"graphicsLiquidDetail")
							end,
						},
						graphicsSunshafts = 
						{
							order = get_order(),
							name = SUNSHAFTS,
							desc = OPTION_TOOLTIP_SUNSHAFTS,
							type = "range",
							min = 1,
							max = 3,
							step = 1,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"graphicsSunshafts",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"graphicsSunshafts")
							end,
						},
						graphicsParticleDensity = 
						{
							order = get_order(),
							name = PARTICLE_DENSITY,
							desc = OPTION_TOOLTIP_PARTICLE_DENSITY,
							type = "range",
							min = 1,
							max = 5,
							step = 1,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"graphicsParticleDensity",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"graphicsParticleDensity")
							end,
						},
						graphicsSSAO = 
						{
							order = get_order(),
							name = SSAO_LABEL,
							desc = OPTION_TOOLTIP_SSAO,
							type = "range",
							min = 1,
							max = 4,
							step = 1,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"graphicsSSAO",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"graphicsSSAO")
							end,
						},
						graphicsDepthEffects = 
						{
							order = get_order(),
							name = DEPTH_EFFECTS,
							desc = OPTION_TOOLTIP_DEPTH_EFFECTS,
							type = "range",
							min = 1,
							max = 4,
							step = 1,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"graphicsDepthEffects",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"graphicsDepthEffects")
							end,
						},
						graphicsLightingQuality = 
						{
							order = get_order(),
							name = LIGHTING_QUALITY,
							desc = OPTION_TOOLTIP_LIGHTING_QUALITY,
							type = "range",
							min = 1,
							max = 3,
							step = 1,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"graphicsLightingQuality",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"graphicsLightingQuality")
							end,
						},
						graphicsOutlineMode = 
						{
							order = get_order(),
							name = OUTLINE_MODE,
							desc = OPTION_TOOLTIP_OUTLINE_MODE,
							type = "range",
							min = 1,
							max = 3,
							step = 1,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"graphicsOutlineMode",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarBoolInstance(info[1],"graphicsOutlineMode")
							end,
						},
						weatherDensity = 
						{
							order = get_order(),
							name = WEATHER_DETAIL,
							desc = OPTION_TOOLTIP_WEATHER_DETAIL,
							type = "range",
							min = 1,
							max = 3,
							step = 1,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"weatherDensity",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"weatherDensity")
							end,
						}
					}
				},
				FPS =
				{
					order = get_order(),
					name = "FPS",
					type = "group",
					args =
					{
						maxFPS = 
						{
							order = get_order(),
							name = MAXFPS,
							desc = OPTION_MAXFPS,
							type = "range",
							min = 0,
							max = 200,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"maxFPS",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"maxFPS")
							end,
						},
						maxFPSBk = 
						{
							order = get_order(),
							name = MAXFPSBK,
							desc = OPTION_MAXFPSBK,
							type = "range",
							min = 0,
							max = 200,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"maxFPSBk",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"maxFPSBk")
							end,
						},
					}
				},
				Screenshot =
				{
					order = get_order(),
					name = L["Screenshot"],
					type = "group",
					args = 
					{
						screenshotFormat =
						{
							order = get_order(),
							name = L["Format"],
							type = "select",
							values = screenshot_formats,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"screenshotFormat",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarInstance(info[1],"screenshotFormat")
							end
						},
						screenshotQuality =
						{
							order = get_order(),
							name = QUALITY,
							desc = L["Note this option only affects JPEG screenshots (TGA screenshots always use lossless quality)."],
							type = "range",
							min = 1,
							max =10,
							step = 1,
							set = function(info,val)
								ControlPanel:SetCVarInstance(info[1],"screenshotQuality",val)
							end,
							get = function(info)
								return ControlPanel:GetCVarNumberInstance(info[1],"screenshotQuality")
							end,
						},
					}
				}
			}
		}
	end
	return Graphics
end
