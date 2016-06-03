Panel_Window_Option:setMaskingChild(true)
Panel_Window_Option:ActiveMouseEventEffect(true)
Panel_Window_Option:setGlassBackground(true)

-- Panel_Window_Option:SetShow(true)		--삭제해야함 테스트용

Panel_Window_Option:RegisterShowEventFunc( true, 'Option_ShowAni()' )
Panel_Window_Option:RegisterShowEventFunc( false, 'Option_HideAni()' )

local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color
local UI_TM 		= CppEnums.TextMode

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local gamePanel_Main = {
	_btn_Display 				= UI.getChildControl ( Panel_Window_Option, "RadioButton_Display" ),
	_btn_Sound 					= UI.getChildControl ( Panel_Window_Option, "RadioButton_Sound" ),
	_btn_Game 					= UI.getChildControl ( Panel_Window_Option, "RadioButton_Game" ),
	_btn_KeyConfig				= UI.getChildControl ( Panel_Window_Option, "RadioButton_Key" ),
	_btn_KeyConfig_UI			= UI.getChildControl ( Panel_Window_Option, "RadioButton_KeyUI" ),
	-- _btn_UIRePos				= UI.getChildControl ( Panel_Window_Option, "RadioButton_UIRePos" ),
	-- _btn_GameExit				= UI.getChildControl ( Panel_Window_Option, "RadioButton_Exit" ),
	_btn_Language				= UI.getChildControl ( Panel_Window_Option, "RadioButton_Language"),

	_txt_Comment 				= UI.getChildControl ( Panel_Window_Option, "StaticText_OptionComment" ),
	
	_btn_Reset					= UI.getChildControl ( Panel_Window_Option, "Button_Reset" ),
	_btn_Apply 					= UI.getChildControl ( Panel_Window_Option, "Button_Apply" ),
	_btn_Confirm 				= UI.getChildControl ( Panel_Window_Option, "Button_Confirm" ),
	_btn_Cancel 				= UI.getChildControl ( Panel_Window_Option, "Button_Cancel" ),

	_btn_Close 					= UI.getChildControl ( Panel_Window_Option, "Button_Win_Close" ),
	_buttonQuestion				= UI.getChildControl ( Panel_Window_Option, "Button_Question" ),		--물음표 버튼
}

local _frame_Display 				= UI.getChildControl ( Panel_GameOption_Display, "Frame_Display" )
local _frameContent_Display 		= UI.getChildControl ( _frame_Display, "Frame_1_Content" )

local _frame_Sound 					= UI.getChildControl ( Panel_GameOption_Sound, "Frame_Sound" )
local _frameContent_Sound 			= UI.getChildControl ( _frame_Sound, "Frame_1_Content" )

local _frame_Game 					= UI.getChildControl ( Panel_GameOption_Game, "Frame_Game" )
local _frameContent_Game 			= UI.getChildControl ( _frame_Game, "Frame_1_Content" )

local _frame_KeyConfig				= UI.getChildControl ( Panel_GameOption_Key, "Frame_KeyConfig" )
local _static_KeySetTitle			= UI.getChildControl ( Panel_GameOption_Key, "StaticText_ControlSetting" )
local _static_KeySetBG				= UI.getChildControl ( Panel_GameOption_Key, "StaticText_KeyboardSet" )
local _static_PadSetBG				= UI.getChildControl ( Panel_GameOption_Key, "StaticText_GamePadSet" )
local _static_ResetKeyConfig		= UI.getChildControl ( Panel_GameOption_Key, "Button_Reset_Key" )
local _frameContent_KeyConfig		= UI.getChildControl ( _frame_KeyConfig, "Frame_1_Content" )

local _frame_KeyConfig_UI			= UI.getChildControl ( Panel_GameOption_Key_UI, "Frame_KeyConfig_UI" )
local _static_KeySetTitle_UI		= UI.getChildControl ( Panel_GameOption_Key_UI, "StaticText_ControlSet_UI" )
local _static_KeySetBG_UI			= UI.getChildControl ( Panel_GameOption_Key_UI, "StaticText_KeyboardSet_UI" )
local _static_PadSetBG_UI			= UI.getChildControl ( Panel_GameOption_Key_UI, "StaticText_GamePadSet_UI" )
local _static_ResetKeyConfig_UI		= UI.getChildControl ( Panel_GameOption_Key_UI, "Button_ResetUI" )
local _static_ResetPositionConfig_UI	= UI.getChildControl ( Panel_GameOption_Key_UI, "Button_ResetUI_Position" )
local _frameContent_KeyConfig_UI	= UI.getChildControl ( _frame_KeyConfig_UI, "Frame_1_Content" )

local _frame_Language				= UI.getChildControl ( Panel_GameOption_Language, "Frame_Language" )
local _frameContent_Language		= UI.getChildControl ( _frame_Language, "Frame_1_Content" )

-- 슬라이드 show 용 로컬들
local _display_SizeY 				= _frameContent_Display:GetSizeY()
local _sound_SizeY 					= _frameContent_Sound:GetSizeY()
local _game_SizeY					= _frameContent_Game:GetSizeY()
local _keyConfig_SizeY 				= _frameContent_KeyConfig:GetSizeY()
local _keyConfig_UI_SizeY 			= _frameContent_KeyConfig_UI:GetSizeY()
local _Language_SizeY				= _frameContent_Language:GetSizeY()

local _display_sld 					= UI.getChildControl ( _frame_Display, "Frame_1_VerticalScroll" )
local _sound_sld 					= UI.getChildControl ( _frame_Sound, "Frame_1_VerticalScroll" )
local _game_sld 					= UI.getChildControl ( _frame_Game, "Frame_1_VerticalScroll" )
local _keyConfig_sld 				= UI.getChildControl ( _frame_KeyConfig, "Frame_1_VerticalScroll" )
local _keyConfigUI_sld 				= UI.getChildControl ( _frame_KeyConfig_UI, "Frame_1_VerticalScroll" )
local _Language_sld 				= UI.getChildControl ( _frame_Language, "Frame_1_VerticalScroll" )

local _display_sld_btn 				= UI.getChildControl ( _display_sld, "Frame_1_VerticalScroll_CtrlButton" )
local _sound_sld_btn 				= UI.getChildControl ( _sound_sld, "Frame_1_VerticalScroll_CtrlButton" )
local _game_sld_btn 				= UI.getChildControl ( _game_sld, "Frame_1_VerticalScroll_CtrlButton" )
local _keyConfig_sld_btn 			= UI.getChildControl ( _keyConfig_sld, "Frame_1_VerticalScroll_CtrlButton" )
local _keyConfigUI_sld_btn 			= UI.getChildControl ( _keyConfigUI_sld, "Frame_1_VerticalScroll_CtrlButton" )
local _Language_sld_btn 			= UI.getChildControl ( _Language_sld, "Frame_1_VerticalScroll_CtrlButton" )



-- 화면 설정 프레임
local frame_Display = {
	_btn_ScreenMode =
	{
		[0] = UI.getChildControl ( _frameContent_Display, "RadioButton_FullScreen"),
		[1] = UI.getChildControl ( _frameContent_Display, "RadioButton_FullWindow"),
		[2] = UI.getChildControl ( _frameContent_Display, "RadioButton_Window"),
	},

	_btn_ScrSize				= UI.getChildControl ( _frameContent_Display, "Button_ScreenSize"),
	_btn_ScrSize_L				= UI.getChildControl ( _frameContent_Display, "Button_ScrSize_L"),
	_btn_ScrSize_R				= UI.getChildControl ( _frameContent_Display, "Button_ScrSize_R"),

	_btn_Trxt					= UI.getChildControl ( _frameContent_Display, "Button_TexQuality"),
	_btn_Trxt_L					= UI.getChildControl ( _frameContent_Display, "Button_Txtr_L"),
	_btn_Trxt_R					= UI.getChildControl ( _frameContent_Display, "Button_Txtr_R"),

	_btn_Rndr					= UI.getChildControl ( _frameContent_Display, "Button_RenderQuality"),
	_btn_Rndr_L					= UI.getChildControl ( _frameContent_Display, "Button_Rndr_L"),
	_btn_Rndr_R					= UI.getChildControl ( _frameContent_Display, "Button_Rndr_R"),

	_btn_LUT					= UI.getChildControl ( _frameContent_Display, "Button_LUT"),
	_btn_LUT_L					= UI.getChildControl ( _frameContent_Display, "Button_LUT_L"),
	_btn_LUT_R					= UI.getChildControl ( _frameContent_Display, "Button_LUT_R"),
	_btn_LUT_Reset				= UI.getChildControl ( _frameContent_Display, "Button_LUT_Reset"),
	
	_btn_DOF					= UI.getChildControl ( _frameContent_Display, "CheckButton_DOF"),
	_btn_AntiAlli				= UI.getChildControl ( _frameContent_Display, "CheckButton_Anti"),
	_btn_Ultra					= UI.getChildControl ( _frameContent_Display, "CheckButton_Ultra"),
	_btn_LensBlood				= UI.getChildControl ( _frameContent_Display, "CheckButton_LensBlood"),
	_btn_BloodEffect			= UI.getChildControl ( _frameContent_Display, "CheckButton_BloodEffect"),
	
	_btn_SSAO					= UI.getChildControl ( _frameContent_Display, "CheckButton_SSAO"),
	_btn_Tessellation			= UI.getChildControl ( _frameContent_Display, "CheckButton_Tessellation"),
	_btn_PostFilter				= UI.getChildControl ( _frameContent_Display, "CheckButton_PostFilter"),
	_btn_CharacterEffect		= UI.getChildControl ( _frameContent_Display, "CheckButton_CharacterEffect"),
	
	_txt_FPS					= UI.getChildControl ( _frameContent_Display, "StaticText_FPS"),
	
	_txt_Gamma					= UI.getChildControl ( _frameContent_Display, "StaticText_GammaControl"),
	_slide_Gamma				= UI.getChildControl ( _frameContent_Display, "Slider_GammaControl"),
	
	_txt_Contrast				= UI.getChildControl ( _frameContent_Display, "StaticText_ContrastControl"),
	_slide_Contrast				= UI.getChildControl ( _frameContent_Display, "Slider_ContrastControl"),

	_txt_UIScale				= UI.getChildControl ( _frameContent_Display, "StaticText_UISize"),
	_txt_UIScaleLow 			= UI.getChildControl ( _frameContent_Display, "StaticText_UI_LOW"),
	_txt_UIScaleMidle 			= UI.getChildControl ( _frameContent_Display, "StaticText_UI_MID"),
	_txt_UIScaleHigh 			= UI.getChildControl ( _frameContent_Display, "StaticText_UI_HIGH"),
	_slide_UIScale				= UI.getChildControl ( _frameContent_Display, "Slider_UI_Scaling"),

	_txt_CameraMaster			= UI.getChildControl ( _frameContent_Display, "StaticText_CameraMaster"),
	_slide_CameraMaster			= UI.getChildControl ( _frameContent_Display, "Slider_CameraMasterControl"),
	
	_txt_CameraShake			= UI.getChildControl ( _frameContent_Display, "StaticText_CameraShake"),
	_slide_CameraShake			= UI.getChildControl ( _frameContent_Display, "Slider_CameraShakeControl"),

	_txt_MotionBlur				= UI.getChildControl ( _frameContent_Display, "StaticText_CameraBlur"),
	_slide_MotionBlur			= UI.getChildControl ( _frameContent_Display, "Slider_CameraBlurControl"),
	
	_txt_CameraPos				= UI.getChildControl ( _frameContent_Display, "StaticText_CameraPos"),
	_slide_CameraPos			= UI.getChildControl ( _frameContent_Display, "Slider_CameraPos"),
	
	_txt_CameraFov				= UI.getChildControl ( _frameContent_Display, "StaticText_CameraFov"),
	_slide_CameraFov			= UI.getChildControl ( _frameContent_Display, "Slider_CameraFov"),
	
	_tooltip					= UI.getChildControl ( _frameContent_Display, "StaticText_ControlTooltip"),

	
	_txt_Fov				= UI.getChildControl ( _frameContent_Display, "StaticText_FovControl"),
	_slide_Fov				= UI.getChildControl ( _frameContent_Display, "Slider_FovControl"),
	
	_btn_Reset				= UI.getChildControl ( _frameContent_Display, "Button_Reset" ),
	
	_btn_ScreenShotFormat =
	{
		[0] = UI.getChildControl ( _frameContent_Display, "RadioButton_ScreenshotFormat_BMP"),
		[1] = UI.getChildControl ( _frameContent_Display, "RadioButton_ScreenshotFormat_JPG"),
		[2] = UI.getChildControl ( _frameContent_Display, "RadioButton_ScreenshotFormat_PNG"),
	},

	_btn_ColorBlind = 
	{
		[0] = UI.getChildControl( _frameContent_Display, "Radiobutton_ColorBlindNone"),
		[1] = UI.getChildControl( _frameContent_Display, "Radiobutton_ColorBlind_Protanopia"),
		[2] = UI.getChildControl( _frameContent_Display, "Radiobutton_ColorBlind_Deuteranopia"),
	},

	_btn_NearestPlayerOnlyEffect= UI.getChildControl ( _frameContent_Display, "CheckButton_OtherUserEffect"),
	_btn_SelfPlayerOnlyEffect	= UI.getChildControl ( _frameContent_Display, "CheckButton_OtherUserEffectAll"),
	
	_btn_SelfPlayerOnlyLantern	= UI.getChildControl ( _frameContent_Display, "CheckButton_OtherUserLantern"),
	
	_btn_UpscaleEnable			= UI.getChildControl ( _frameContent_Display, "CheckButton_Upscale"),
	_btn_SleepModeEnable		= UI.getChildControl ( _frameContent_Display, "CheckButton_SleepMode"),
	_btn_CropModeEnable			= UI.getChildControl ( _frameContent_Display, "CheckButton_CropMode"),
	_slide_CropModeScaleX		= UI.getChildControl ( _frameContent_Display, "Slider_CropModeX"),
	_slide_CropModeScaleY		= UI.getChildControl ( _frameContent_Display, "Slider_CropModeY"),
	}
-- 슬라이드 버튼 모음
local _btn_Gamma					= UI.getChildControl ( frame_Display._slide_Gamma, "Slider_GammaControl_Button")
local _btn_Contrast					= UI.getChildControl ( frame_Display._slide_Contrast, "Slider_ContrastControl_Button")
local _btn_UIScale					= UI.getChildControl ( frame_Display._slide_UIScale, "Slider_UI_Scaling_Button")
local _btn_CameraMaster				= UI.getChildControl ( frame_Display._slide_CameraMaster, "Slider_CameraMaster_Button")
local _btn_CameraShake				= UI.getChildControl ( frame_Display._slide_CameraShake, "Slider_CameraShake_Button")
local _btn_MotionBlur				= UI.getChildControl ( frame_Display._slide_MotionBlur, "Slider_CameraBlur_Button")
local _btn_CameraPos				= UI.getChildControl ( frame_Display._slide_CameraPos, "Slider_CameraPos_Button")
local _btn_CameraFov				= UI.getChildControl ( frame_Display._slide_CameraFov, "Slider_CameraFov_Button")
local _btn_CropModeScaleX			= UI.getChildControl ( frame_Display._slide_CropModeScaleX, "Slider_CropModeX_Button")
local _btn_CropModeScaleY			= UI.getChildControl ( frame_Display._slide_CropModeScaleY, "Slider_CropModeY_Button")
local _btn_Fov 						= UI.getChildControl ( frame_Display._slide_Fov, "Slider_FovControl_Button")
	-- local getTxt_FullScr_X = frame_Display._btn_FullScr:GetTextSizeX()
	-- local getTxt_FullWin_X = frame_Display._btn_FullWin:GetTextSizeX()
	-- local getTxt_Win_X = frame_Display._btn_Win:GetTextSizeX()
	-- frame_Display._btn_FullScr:SetEnableArea ( 0, 0, getTxt_FullScr_X,  frame_Display._btn_FullScr:GetSizeY() )
	-- frame_Display._btn_FullWin:SetEnableArea ( 0, 0, getTxt_FullWin_X, frame_Display._btn_FullWin:GetSizeY() )
	-- frame_Display._btn_Win:SetEnableArea ( 0, 0, getTxt_Win_X, frame_Display._btn_Win:GetSizeY() )


-- 음향 설정 프레임
local frame_Sound = {
	_btn_MusicOnOff	 			= UI.getChildControl ( _frameContent_Sound, "Checkbox_MusicOnOff"),
	_btn_FXOnOff 				= UI.getChildControl ( _frameContent_Sound, "Checkbox_FXOnOff"),
	_btn_EnvFXOnOff 			= UI.getChildControl ( _frameContent_Sound, "Checkbox_EnvFXOnOff"),

	_btn_RiddingOnOff			= UI.getChildControl ( _frameContent_Sound, "Checkbox_RiddingOnOff"),
	_btn_WhisperOnOff			= UI.getChildControl ( _frameContent_Sound, "Checkbox_WhisperOnOff"),
	_btn_TraySoundOnOff			= UI.getChildControl ( _frameContent_Sound, "Checkbox_TraySoundOnOff"),

	_btn_CombatAllwaysOff		= UI.getChildControl ( _frameContent_Sound, "RadioButton_AllwaysCombatOff"),
	_btn_CombatAllwaysOn		= UI.getChildControl ( _frameContent_Sound, "RadioButton_AllwaysCombatOn"),
	_btn_CombatAllwaysLowOff	= UI.getChildControl ( _frameContent_Sound, "RadioButton_AllwaysCombatLowOff"),

	--_btn_HitFxTypeOnOff			= UI.getChildControl ( _frameContent_Sound, "Checkbox_AttackSmoth_OnOff"),

	_txt_TotalVol 				= UI.getChildControl ( _frameContent_Sound, "StaticText_TotalVolume"),
	_slide_TotalVol 			= UI.getChildControl ( _frameContent_Sound, "Slider_TotalVolumeControl"),

	_txt_MusicVol 				= UI.getChildControl ( _frameContent_Sound, "StaticText_MusicVolume"),
	_slide_MusicVol 			= UI.getChildControl ( _frameContent_Sound, "Slider_MusicVolumeControl"),

	_txt_FxVol 					= UI.getChildControl ( _frameContent_Sound, "StaticText_FXVolume"),
	_slide_FxVol 				= UI.getChildControl ( _frameContent_Sound, "Slider_FXVolumeControl"),

	_txt_EnvFxVol 				= UI.getChildControl ( _frameContent_Sound, "StaticText_EnvFXVolume"),
	_slide_EnvFxVol 			= UI.getChildControl ( _frameContent_Sound, "Slider_EnvFXVolumeControl"),

	_txt_VoiceVol 				= UI.getChildControl ( _frameContent_Sound, "StaticText_VoiceVolume"),
	_slide_VoiceVol 			= UI.getChildControl ( _frameContent_Sound, "Slider_VoiceVolumeControl"),

	_txt_hitFxVolume			= UI.getChildControl ( _frameContent_Sound, "StaticText_AttackVolume"),
	_slide_hitFxVolume			= UI.getChildControl ( _frameContent_Sound, "Slider_AttackVolumeControl"),

	_txt_hitFxWeightVolume		= UI.getChildControl ( _frameContent_Sound, "StaticText_AttackSmothVolume"),
	_slide_hitFxWeightVolume	= UI.getChildControl ( _frameContent_Sound, "Slider_AttackSmothVolumeControl"),

	_txt_otherPlayerVolume		= UI.getChildControl ( _frameContent_Sound, "StaticText_OtherUserVolume"),
	_slide_otherPlayerVolume	= UI.getChildControl ( _frameContent_Sound, "Slider_OtherUserVolumeControl"),
	_btn_Reset					= UI.getChildControl ( _frameContent_Sound, "Button_Reset" ),
}
-- 슬라이드 버튼 모음
local _btn_TotalVol 				= UI.getChildControl ( frame_Sound._slide_TotalVol, "Slider_TotalVolume_Button")
local _btn_MusicVol 				= UI.getChildControl ( frame_Sound._slide_MusicVol, "Slider_MusicVolume_Button")
local _btn_FxVol 					= UI.getChildControl ( frame_Sound._slide_FxVol, "Slider_FXVolume_Button")
local _btn_EnvFxVol 				= UI.getChildControl ( frame_Sound._slide_EnvFxVol, "Slider_EnvFXVolume_Button")
local _btn_VoiceVol 				= UI.getChildControl ( frame_Sound._slide_VoiceVol, "Slider_VoiceVolume_Button")
local _btn_hitFxVolume				= UI.getChildControl ( frame_Sound._slide_hitFxVolume, "Slider_VoiceVolume_Button")
local _btn_hitFxWeightVolume		= UI.getChildControl ( frame_Sound._slide_hitFxWeightVolume, "Slider_VoiceVolume_Button")
local _btn_otherPlayerVolume		= UI.getChildControl ( frame_Sound._slide_otherPlayerVolume, "Slider_VoiceVolume_Button")


-- 게임 설정 프레임
local frame_Game = {
	-- _btn_MouseShow 				= UI.getChildControl ( _frameContent_Game, "Checkbox_MouseInvisible"),
	_btn_ShowTag 				= UI.getChildControl ( _frameContent_Game, "Checkbox_ShowCharTag"),
	_btn_AutoAim 				= UI.getChildControl ( _frameContent_Game, "CheckButton_AutoAim"),
	--_btn_BottomMenu				= UI.getChildControl ( _frameContent_Game, "Checkbox_ShowBottomMenu"),
	_btn_RejectInvitation		= UI.getChildControl ( _frameContent_Game, "Checkbox_RejectInvitation"),		
	_btn_HideWindow				= UI.getChildControl ( _frameContent_Game, "CheckButton_HideUIWindow"),
	_btn_EnableSimpleUI			= UI.getChildControl ( _frameContent_Game, "Checkbox_SimpleUI"),	
	_btn_SpiritGuide			= UI.getChildControl ( _frameContent_Game, "Checkbox_SpiritGuide"),				-- 연계기 영상 가이드 보이기
	_btn_MouseMove				= UI.getChildControl ( _frameContent_Game, "CheckBox_MoveMouse"),
	_btn_MiniMapRotation		= UI.getChildControl ( _frameContent_Game, "CheckBox_Minimap"),
	_btn_ShowAttackEffect		= UI.getChildControl ( _frameContent_Game, "CheckBox_ShowAttackEffect"),
	_btn_Alert_BlackSpirit		= UI.getChildControl ( _frameContent_Game, "CheckButton_BlackSpirit_Alert" ),
	_btn_UseNewQuickSlot		= UI.getChildControl ( _frameContent_Game, "CheckButton_NewQuickSlot" ),
	_btn_UseChattingFilter	 	= UI.getChildControl ( _frameContent_Game, "CheckButton_UseChattingFilter" ),
	_btn_IsOnScreenSaver	 	= UI.getChildControl ( _frameContent_Game, "CheckButton_ScreenSaver" ),
	_btn_UIModeMouseLock		= UI.getChildControl ( _frameContent_Game, "CheckButton_UIModeMouseLock" ),
	_btn_PvpRefuse				= UI.getChildControl ( _frameContent_Game, "CheckButton_PvpRefuse" ),	
		
	_btn_EnableOVR				= UI.getChildControl ( _frameContent_Game, "Checkbox_SupportOculus"),	
	_btn_MouseX 				= UI.getChildControl ( _frameContent_Game, "Checkbox_MouseX"),
	_btn_MouseY 				= UI.getChildControl ( _frameContent_Game, "Checkbox_MouseY"),
	_btn_UsePad 				= UI.getChildControl ( _frameContent_Game, "Checkbox_UsePad"),
	_btn_UseVibe 				= UI.getChildControl ( _frameContent_Game, "Checkbox_UseVibe"),
	_btn_PadX 					= UI.getChildControl ( _frameContent_Game, "Checkbox_PadX"),
	_btn_PadY 					= UI.getChildControl ( _frameContent_Game, "Checkbox_PadY"),
	_btn_SelfNameShowAllways	= UI.getChildControl ( _frameContent_Game, "CheckButton_SelfPlayer"),
	_btn_SelfNameShowNoShow		= UI.getChildControl ( _frameContent_Game, "Checkbox_MyCharacterNickNameShow"),
	_btn_SelfNameShowImportant	= UI.getChildControl ( _frameContent_Game, "Checkbox_AttackNameShow"),

	_btn_PetAll					= UI.getChildControl ( _frameContent_Game, "RadioButton_PetVisualAll"),
	_btn_PetMine				= UI.getChildControl ( _frameContent_Game, "RadioButton_PetVisualMine"),
	_btn_PetHide				= UI.getChildControl ( _frameContent_Game, "RadioButton_PetVisualHide"),
	
	_btn_NavGuideNone			= UI.getChildControl ( _frameContent_Game, "RadioButton_NavGuideNone"),
	_btn_NavGuideArrow			= UI.getChildControl ( _frameContent_Game, "RadioButton_NavGuideArrow"),
	_btn_NavGuideEffect			= UI.getChildControl ( _frameContent_Game, "RadioButton_NavGuideEffect"),
	_btn_NavGuideFairy			= UI.getChildControl ( _frameContent_Game, "RadioButton_NavGuideFairy"),
	
	_btn_OtherNameShow			= UI.getChildControl ( _frameContent_Game, "Checkbox_AnotherCharacterNickNameShow"),
	_btn_PartyNameShow			= UI.getChildControl ( _frameContent_Game, "Checkbox_PartyNickName"),
	_btn_GuildNameShow			= UI.getChildControl ( _frameContent_Game, "Checkbox_GuildAndClanCharacterNickName"),

	-- { 가이드 라인 설정
		_btn_GuideLineHumanRelation	= UI.getChildControl ( _frameContent_Game, "Checkbox_CharacterOutline_HumanRelation"),
		_btn_GuideLineQuestObject	= UI.getChildControl ( _frameContent_Game, "Checkbox_CharacterOutline_QuestObjectLine"),
		_btn_GuideLineZoneChange	= UI.getChildControl ( _frameContent_Game, "Checkbox_CharacterOutline_ZoneChange"),
		_btn_GuideLineWarAlly		= UI.getChildControl ( _frameContent_Game, "Checkbox_CharacterOutline_WarAlly"),
		_btn_GuideLineGuild			= UI.getChildControl ( _frameContent_Game, "Checkbox_CharacterOutline_Guild"),
		_btn_GuideLineParty			= UI.getChildControl ( _frameContent_Game, "Checkbox_CharacterOutline_Party"),
		_btn_GuideLineEnemy			= UI.getChildControl ( _frameContent_Game, "Checkbox_CharacterOutline_Enemy"),
		_btn_GuideLineNonWarPlayer	= UI.getChildControl ( _frameContent_Game, "Checkbox_CharacterOutline_NonWarPlayer"),
	-- }

	--{ 시스템 알림 끄기 설정
		_btn_Alert_Region			= UI.getChildControl ( _frameContent_Game, "CheckButton_Alert_Region" ),
		_btn_Alert_TerritoryTrade	= UI.getChildControl ( _frameContent_Game, "CheckButton_Alert_TerritoryTrade" ),
		_btn_Alert_RoyalTrade		= UI.getChildControl ( _frameContent_Game, "CheckButton_Alert_RoyalTrade" ),
		_btn_Alert_Fitness			= UI.getChildControl ( _frameContent_Game, "CheckButton_Alert_FitnessLevelUp" ),
		_btn_Alert_TerritoryWar		= UI.getChildControl ( _frameContent_Game, "CheckButton_Alert_TerritoryWar" ),
		_btn_Alert_GuildWar			= UI.getChildControl ( _frameContent_Game, "CheckButton_Alert_GuildWarStart" ),
		_btn_Alert_PlayerGotItem	= UI.getChildControl ( _frameContent_Game, "CheckButton_Alert_AnotherPlayerGotItem" ),
		_btn_Alert_ItemMarket		= UI.getChildControl ( _frameContent_Game, "CheckButton_Alert_ItemMarket" ),
		_btn_Alert_LifeLevUp		= UI.getChildControl ( _frameContent_Game, "CheckButton_Alert_LifeLevUp" ),
		_btn_Alert_GuildQuest		= UI.getChildControl ( _frameContent_Game, "CheckButton_Alert_GuildQuest"),
		_btn_Alert_NearMonster 		= UI.getChildControl ( _frameContent_Game, "CheckButton_Alert_NearMonster"),
	--}

	_btn_GuildLogin				= UI.getChildControl ( _frameContent_Game, "CheckButton_GuildLogin"),

	_txt_MouXSen				= UI.getChildControl ( _frameContent_Game, "StaticText_MouseXSen"),
	_slide_MouXSen				= UI.getChildControl ( _frameContent_Game, "Slider_MouseXSenControl"),

	_txt_MouYSen 				= UI.getChildControl ( _frameContent_Game, "StaticText_MouseYSen"),
	_slide_MouYSen 				= UI.getChildControl ( _frameContent_Game, "Slider_MouseYSenControl"),

	_txt_PadXSen 				= UI.getChildControl ( _frameContent_Game, "StaticText_PadXSen"),
	_slide_PadXSen 				= UI.getChildControl ( _frameContent_Game, "Slider_PadXSenControl"),

	_txt_PadYSen 				= UI.getChildControl ( _frameContent_Game, "StaticText_PadYSen"),
	_slide_PadYSen 				= UI.getChildControl ( _frameContent_Game, "Slider_PadYSenControl"),
	_btn_Reset					= UI.getChildControl ( _frameContent_Game, "Button_Reset" )
}

-- { 캐릭터 가이드라인용 변수
	local randerPlayerColorStr = {
		zoneChange		= "ZoneChange",	 	-- 안전지역/위험지역 표시
		warAlly			= "WarAlly",	 	-- 전쟁(공성전, 국지전) 같은편
		guild			= "Guild",	 		-- 같은 길드
		party			= "Party",	 		-- 같은 파티
		enemy			= "Enemy",	 		-- 적
		nonWarPlayer	= "NonWarPlayer",	-- 전쟁지역의 비참여자
	}
-- }

-- 게임팁,길드원 접속정보 임시용

-- 연계 가이드 변수 선언!
value_GameOption_Check_ComboGuide = frame_Game._btn_SpiritGuide
value_GameOption_Check_ComboGuide:SetCheck( true )
_currentSpiritGuideCheck = true

-- 슬라이드 버튼 모음
local _btn_MouXSen					= UI.getChildControl ( frame_Game._slide_MouXSen, "Slider_MouseXSen_Button")
local _btn_MouYSen 					= UI.getChildControl ( frame_Game._slide_MouYSen, "Slider_MouseYSen_Button")
local _btn_PadXSen 					= UI.getChildControl ( frame_Game._slide_PadXSen, "Slider_PadXSen_Button")
local _btn_PadYSen 					= UI.getChildControl ( frame_Game._slide_PadYSen, "Slider_PadYSen_Button")


-- 입력버튼 설정 프레임
local frame_Key = {
	_staticInputTitle_Func1 	= UI.getChildControl ( _frameContent_KeyConfig, "StaticText_Key_0"),
	_staticInputTitle_Func2 	= UI.getChildControl ( _frameContent_KeyConfig, "StaticText_Key_1"),
	_button_key 				= UI.getChildControl ( _frameContent_KeyConfig, "RadioButton_Key_0"),

	_button_Pad_Func1 			= UI.getChildControl ( _frameContent_KeyConfig, "RadioButton_Pad_0"),
	_button_Pad_Func2 			= UI.getChildControl ( _frameContent_KeyConfig, "RadioButton_Pad_1"),

	_sample_keyButton 			= UI.getChildControl ( _frameContent_KeyConfig, "RadioButton_Key_0"),
}


-- UI 단축키 설정 프레임
local frame_Key_UI = {
	_staticInputTitle_Func1 	= UI.getChildControl ( _frameContent_KeyConfig_UI, "StaticText_Key_0"),
	_button_key 				= UI.getChildControl ( _frameContent_KeyConfig_UI, "RadioButton_Key_0"),

	_button_Pad_Func1 			= UI.getChildControl ( _frameContent_KeyConfig_UI, "RadioButton_Pad_0"),

	_sample_keyButton 			= UI.getChildControl ( _frameContent_KeyConfig_UI, "RadioButton_Key_0"),
}


isChecked_SkillCommand = true
-- isChecked_UIMain = true
local isChecked_KeyViewer = false

local isChecked_HideWindow = true
local isKeyConfig_Open = false
local isKeyConfig_UI_Open = false
local isAutoAim = true

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local chk_Option = {
	-- radioButton Index , 클라이언트와 값이 일치해야함.
	FULL_SCREEN_IDX = 0,
	FULL_SCREEN_WINDOWED_IDX =1,
	WINDOWED_IDX = 2,
	SCREEN_MODE_COUNT =3,

	screenResolutionList = {},
	SCREEN_RESOLUTION_COUNT, -- client로 부터 획득해야 함.

	-- 스크린샷 포맷
	SCREENSHOT_BMP = 0,
	SCREENSHOT_JPG = 1,
	SCREENSHOT_PNG = 2,

	COLORBLIND_NONE			= 0,
	COLORBLIND_PROTANOPIA	= 1,
	COLORBLIND_DEUTERANOP	= 2,

	-- 클라이언트와 값이 일치해야함.
	TEXTURE_QUALITY_HIGH  = 0,
	TEXTURE_QUALITY_NORMAL  = 1,
	TEXTURE_QUALITY_LOW  = 2,
	TEXTURE_QUALITY_COUNT = 3,

	GRAPHIC_OPTION_HIGH0 = 0,
	GRAPHIC_OPTION_HIGH1 = 1,
	GRAPHIC_OPTION_NORMAL0 = 2,
	GRAPHIC_OPTION_NORMAL1 = 3,
	GRAPHIC_OPTION_LOW0 = 4,
	GRAPHIC_OPTION_LOW1 = 5,
	GRAPHIC_OPTION_VERYLOW = 6,
	GRAPHIC_OPTION_COUNT = 7,
	
	RESOLUTION_WIDTH = 1280,
	RESOLUTION_HEIGHT = 720,
	----------------------------------------------------------------------------------------------------
	-- 현재 선택 버튼 인덱스
	currentScreenModeIdx = 0,
	currentScreenShotFormat = 0,
	currentColorBlind = 0,
	currentSelfPlayerOnlyEffect = false,
	currentSelfPlayerOnlyLantern = false,
	currentNearestPlayerOnlyEffect = false,
	currentUpscaleEnable = false,
	currentSleepModeEnable = false,
	currentCropModeEnable = false,
	currentCropModeScaleX = 0,
	currentCropModeScaleY = 0,
	currentLUT =0,
	currentScreenResolutionIdx =0,
	currentTextureQualityIdx =0,
	currentGraphicOptionIdx = 0,
	currentGammaValue = 0,
	currentContrastValue = 0,
	currentCheckDof = true,
	currentCheckAA = true,
	currentCheckUltra = false,
	currentCheckLensBlood = true,
	currentCheckBloodEffect = true,
	currentCheckSSAO = true,
	currentCheckTessellation = true,
	currentCheckPostFilter = true,
	currentCheckCharacterEffect = true,
	currentCheckUIScale				= 1.0,

	currentMaster = 0,
	currentMusic = 0,
	currentFxSound = 0,
	currentEnvSound = 0,
	currentDlgSound = 0,
	currentHitFxWeight = 0,
	currentPlayerVolume = 0,

	currentCheckMusic = true,
	currentCheckSound = true,
	currentCheckEnvSound = true,
	--currentHitFxType = true,

	currentCheckCombatMusic = CppEnums.BattleSoundType.Sound_Nomal,
	currentCheckRiddingMusic = true,
	currentCheckWhisperMusic = true,
	currentCheckTraySoundOnOff = true,
	currentCheckVoiceChatOnOff = false,

	-- 새로 생긴것
	currentCheckNameTag 			= false,
	currentCheckShowSkillCmd 		= true,
	currentCheckShowComboGuide		= true,
	currentCheckAutoAim		 		= true,
	currentCheckHideWindowByAttacked= true,
	currentCheckShowGuildLoginMessage= true,
	currentCheckEnableSimpleUI		= true,
	currentCheckRenderCharacterColor= true,
	currentCheckEnableOVR			= true,
	currentCheckMiniMapRotation		= false,
	currentCheckRejectInvitation	= false,

	currentCheckCameraMasterPower	= 1.0,
	currentCheckCameraShakePower	= 0.5,
	currentCheckMotionBlurPower		= 0.5,
	currentCheckCameraPosPower 		= 0.7,
	currentCheckCameraFovPower 		= 0.7,
	
	currentCheckMouseMove 			= false,
	currentCheckMouseInvertX		= false,
	currentCheckMouseInvertY		= false,
	currentCheckMouseSensitivityX	= 1.05,
	currentCheckMouseSensitivityY	= 1.05,
	currentCheckPadEnable			= false,
	currentCheckPadVibration		= false,
	currentCheckPadInvertX			= false,
	currentCheckPadInvertY			= false,
	currentCheckPadSensitivityX		= 1.05,
	currentCheckPadSensitivityY		= 1.05,

	currentSelfPlayerNameTagVisible	= CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow,
	currentOtherPlayerNameTagVisible= CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow,
	currentPartyPlayerNameTagVisible= CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow,
	currentGuildPlayerNameTagVisible= CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow,

	currentServiceResourceType		= CppEnums.ServiceResourceType.eServiceResourceType_KR,
	currentChatChannelType			= CppEnums.ServiceResourceType.eServiceResourceType_KR,

	currentFovValue = 50,
	----------------------------------------------------------------------------------------------------
	-- 적용 버튼 저장용 인덱스
	appliedScreenModeIdx = 0,
	appliedScreenShotFormat = 0,
	appliedColorBlind = 0,
	appliedSelfPlayerOnlyEffect = true,
	appliedSelfPlayerOnlyLantern = false,
	appliedUpscaleEnable = false,
	appliedSleepModeEnable = false,
	appliedCropModeEnable = false,
	appliedCropModeScaleX = 0,
	appliedCropModeScaleY = 0,
	appliedLUT =0,		-- 사용안함, 바로 적용됨
	appliedScreenResolutionIdx =0,
	appliedTextureQualityIdx =0,
	appliedGraphicOptionIdx = 0,
	appliedGammaValue = 0,
	appliedContrastValue = 0,
	appliedCheckDof = true,
	appliedCheckAA = true,
	appliedCheckUltra = false,
	appliedCheckLensBlood = true,
	appliedCheckBloodEffect = true,
	appliedCheckSSAO = true,
	appliedCheckTessellation = true,
	appliedCheckPostFilter = true,
	appliedCheckCharacterEffect = true,
	appliedCheckUIScale				= 1.0,

	
	appliedMaster = 0,
	appliedMusic = 0,
	appliedFxSound = 0,
	appliedEnvSound = 0,
	appliedDlgSound = 0,
	appliedHitFxWeight = 0,
	appliedPlayerVolume = 0,

	appliedCheckMusic = true,
	appliedCheckSound = true,
	appliedCheckEnvSound = true,

	appliedCheckCombatMusic = CppEnums.BattleSoundType.Sound_Nomal,
	appliedCheckRiddingMusic = true,
	appliedCheckWhisperMusic = true,
	appliedCheckTraySoundOnOff = true,
	appliedCheckVoiceChatOnOff = false,
	--appliedHitFxType = true,

	-- 새로 생긴것
	appliedCheckNameTag 				= false,
	appliedCheckShowSkillCmd 			= true,
	appliedCheckShowComboGuide			= true,
	appliedCheckAutoAim 				= true,
	appliedCheckHideWindowByAttacked	= true,
	appliedCheckShowGuildLoginMessage	= true,
	appliedCheckEnableSimpleUI			= true,
	appliedCheckRenderCharacterColor	= true,
	appliedCheckEnableOVR				= true,
	appliedCheckMiniMapRotation			= false,
	appliedCheckRejectInvitation		= false,

	
	appliedCheckCameraMasterPower		= 1.0,
	appliedCheckCameraShakePower		= 0.5,
	appliedCheckMotionBlurPower			= 0.5,
	appliedCheckCameraPosPower 			= 0.7,
	appliedCheckCameraFovPower 			= 0.7,
		
	appliedCheckMouseMove 				= false,
	appliedCheckMouseInvertX			= false,
	appliedCheckMouseInvertY			= false,
	appliedCheckMouseSensitivityX		= 1.05,
	appliedCheckMouseSensitivityY		= 1.05,
	appliedCheckPadEnable				= false,
	appliedCheckPadVibration			= false,
	appliedCheckPadInvertX				= false,
	appliedCheckPadInvertY				= false,
	appliedCheckPadSensitivityX			= 1.05,
	appliedCheckPadSensitivityY			= 1.05,
	
	appliedCheckSelfNameShow			= CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow,
	appliedOtherPlayerNameTagVisible	= CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow,
	appliedPartyPlayerNameTagVisible	= CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow,
	appliedGuildPlayerNameTagVisible	= CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow,
	appliedPetObjectShow				= CppEnums.PetVisibleType.ePetVisibleType_All,
	
	appliedNavPathEffectType			= CppEnums.NavPathEffectType.eNavPathEffectType_Arrow,

	appliedServiceResourceType			= CppEnums.ServiceResourceType.eServiceResourceType_KR,
	appliedChatChannelType				= CppEnums.ServiceResourceType.eServiceResourceType_KR,

	appliedFovValue = 50,
	
	----------------------------------------------------------------------------------------------------
	-- 초기 저장된 버튼 인덱스
	savedScreenModeIdx =0,
	savedScreenShotFormat =0,
	savedColorBlind = 0,
	savedSelfPlayerOnlyEffect =true,
	savedNearestPlayerOnlyEffect =true,
	savedSelfPlayerOnlyLantern =false,
	savedUpscaleEnable = false;
	savedSleepModeEnable = false;
	savedCropModeEnable = false;
	savedCropModeScaleX = 0,
	savedCropModeScaleY = 0,
	savedLUT =0,
	savedScreenResolutionIdx =0,
	savedTextureQualityIdx =0,
	savedGraphicOptionIdx = 0,
	savedGammaValue = 0,
	savedContrastValue = 0,
	savedCheckDof = true,
	savedCheckAA = true,
	savedCheckUltra = false,
	savedCheckLensBlood = true,
	savedCheckBloodEffect = true,
	savedCheckSSAO = true,
	savedCheckTessellation = true,
	savedCheckPostFilter = true,
	savedCheckCharacterEffect = true,
	savedCheckUIScale			= 1.0,

	savedMaster = 0,
	savedMusic = 0,
	savedFxSound = 0,
	savedEnvSound = 0,
	savedDlgSound = 0,
	savedHitFxWeight = 0,
	savedPlayerVolume = 0,

	savedCheckMusic = true,
	savedCheckSound = true,
	savedCheckEnvSound = true,
	--savedHitFxType = true,

	savedCheckCombatMusic = CppEnums.BattleSoundType.Sound_Nomal,
	savedCheckRiddingMusic = true,
	savedCheckWhisperMusic = true,
	savedCheckTraySoundOnOff = true,
	savedCheckVoiceChatOnOff = false,

	-- 새로 생긴것
	savedCheckNameTag 				= false,
	savedCheckShowSkillCmd 			= true,
	savedCheckShowComboGuide		= true,
	savedCheckAutoAim 				= true,
	savedCheckHideWindowByAttacked	= true,
	savedCheckShowGuildLoginMessage	= true,
	savedCheckEnableSimpleUI		= true,
	savedCheckRenderCharacterColor	= true,
	savedCheckEnableOVR				= true,
	savedCheckMiniMapRotation		= false,
	savedCheckRejectInvitation		= false,

	savedCheckCameraMasterPower	= 1.0,
	savedCheckCameraShakePower	= 0.5,
	savedCheckMotionBlurPower	= 0.5,
	savedCheckCameraPosPower 	= 0.7,
	savedCheckCameraFovPower 	= 0.7,

	savedCheckMouseMove 		= false,
	savedCheckMouseInvertX		= false,
	savedCheckMouseInvertY		= false,
	savedCheckMouseSensitivityX	= 1.05,
	savedCheckMouseSensitivityY	= 1.05,
	savedCheckPadEnable			= false,
	savedCheckPadVibration		= false,
	savedCheckPadInvertX		= false,
	savedCheckPadInvertY		= false,
	savedCheckPadSensitivityX	= 1.05,
	savedCheckPadSensitivityY	= 1.05,

	savedCheckSelfNameShow			= CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow,
	savedOtherPlayerNameTagVisible	= CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow,
	savedPartyPlayerNameTagVisible	= CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow,
	savedGuildPlayerNameTagVisible	= CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow,
	savedPetObjectShow				= CppEnums.PetVisibleType.ePetVisibleType_All,
	savedNavPathEffectType			= CppEnums.NavPathEffectType.eNavPathEffectType_Arrow,
	
	savedServiceResourceType		= CppEnums.ServiceResourceType.eServiceResourceType_KR,
	savedChatChannelType				= CppEnums.ServiceResourceType.eServiceResourceType_KR,

	savedFovValue = 50,
}

------------------------------------------------------ 키 커스텀 전용 데이터 ------------------------------------------------------
local INPUT_COUNT_START = 0
local INPUT_COUNT_END = 48

local STATIC_INPUT_TITLE = {}
local BUTTON_KEY = {}
local BUTTON_PAD = {}

local INPUT_TYPE

local keyConfigListShowCount = 51	-- 화면에 보여줄 키컨피그버튼 갯수 const value
local configDataIndex = 0			-- 키컨피그가 시작될 인덱스
local keyConfigData = {}
-- key : index ( -2 to 11 == keyConfigListShowCount ) -2 , -1은 Pad 전용 Func 데이터입니다.
-- value
-- {
-- 	titleText : 키컨피그 종류 text임 controls.title하고 매칭됨
-- 	buttonKeyText : 키컨피그 키보드 입력 text임 subtitle1과 매칭됨
-- 	padKeyText : 키컨피그 패드 입력 text임 subtitle2과 매칭됨
--	padOnly : 패드버튼만 보일거면 true, 아니면 false
-- }


-- keyConfig의 상대 인댁스 데이터를 가져옴
local getKeyConfigData = function( index )
	return keyConfigData[ configDataIndex + index -2 ]
end

local setKeyConfigDataTitle = function(index, title )
	keyConfigData[index] = { titleText = title, buttonKeyText = "", padKeyText = "", padOnly = false }
end

local setKeyConfigDataConfigButton = function(index, button )
	keyConfigData[index].buttonKeyText = button
end

local setKeyConfigDataConfigPad = function(index, pad )
	keyConfigData[index].padKeyText = pad
end

local setKeyConfigDataConfigOnlyPad = function(index, padOnly )
	keyConfigData[index].padOnly = padOnly
end

local updateKeyConfig = function()
	for index = 0, keyConfigListShowCount -1 do
		local keyConfigData = getKeyConfigData(index)
		if ( nil ~= keyConfigData ) then
			STATIC_INPUT_TITLE[index]:SetText( keyConfigData.titleText )
			if ( false == keyConfigData.padOnly ) then
				BUTTON_KEY[index]:SetText( keyConfigData.buttonKeyText )
				BUTTON_KEY[index]:SetShow(true)
			else
				BUTTON_KEY[index]:SetShow(false)
			end
			BUTTON_PAD[index]:SetText( keyConfigData.padKeyText )
		else
			-- STATIC_INPUT_TITLE[index]:SetText( " " )
			-- BUTTON_KEY[index]:SetText( " " )
			-- BUTTON_PAD[index]:SetText( " " )
		end
	end
end
--------------------------------------------------- UI 단축키 커스텀 전용 데이터 ---------------------------------------------------

local INPUT_COUNT_START_UI = 0
local INPUT_COUNT_END_UI = 20

local STATIC_INPUT_TITLE_UI = {}
local BUTTON_KEY_UI = {}
local BUTTON_PAD_UI = {}

local INPUT_TYPE_UI

local keyConfigListShowCount_UI = 21	-- 화면에 보여줄 키컨피그버튼 갯수 const value
local configDataIndex_UI = 0			-- 키컨피그가 시작될 인덱스

local keyConfigData_UI = {}
-- key : index ( 0 to 11 == keyConfigListShowCount_UI )
-- value
-- {
-- 	titleText : 키컨피그 종류 text임 controls.title하고 매칭됨
-- 	buttonKeyText : 키컨피그 키보드 입력 text임 subtitle1과 매칭됨
-- 	padKeyText : 키컨피그 패드 입력 text임 subtitle2과 매칭됨
-- }


-- keyConfig의 상대 인댁스 데이터를 가져옴
local getKeyConfigData_UI = function( index )
	return keyConfigData_UI[ configDataIndex_UI + index ]
end

local setKeyConfigData_UI = function( index, title, button, padKey )
	if ( title ~= nil ) then
		keyConfigData_UI[index] = { titleText = title, buttonKeyText = button, padKeyText = padKey }
	else
		if ( nil ~= button ) then
			keyConfigData_UI[index].buttonKeyText = button
		else
			keyConfigData_UI[index].padKeyText = padKey
		end
	end
end
local setKeyConfigData_UITitle = function(index, title )
	setKeyConfigData_UI(index, title, "", "")
end

local setKeyConfigData_UIConfigButton = function(index, button )
	setKeyConfigData_UI(index, nil, button, nil)
end

local setKeyConfigData_UIConfigPad = function(index, pad )
	setKeyConfigData_UI(index, nil, nil, pad)
end

local updateKeyConfig_UI = function()
	for index = 0, keyConfigListShowCount_UI -1 do
		local keyConfigData_UI = getKeyConfigData_UI(index)

		if ( nil ~= keyConfigData_UI and CppEnums.UiInputType.UiInputType_Cancel ~= index ) then
			STATIC_INPUT_TITLE_UI[index]:SetText( keyConfigData_UI.titleText )
			BUTTON_KEY_UI[index]:SetText( keyConfigData_UI.buttonKeyText )
			BUTTON_PAD_UI[index]:SetText( keyConfigData_UI.padKeyText )
		else
			-- STATIC_INPUT_TITLE_UI[index]:SetText( " " )
			-- BUTTON_KEY_UI[index]:SetText( " " )
			-- BUTTON_PAD_UI[index]:SetText( " " )
		end
	end
end



-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local GetStr_Option = {
	[0] 	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TXT_DISPLAY_HELP" ),		--[[- 게임의 화면과 효과등을 조정할 수 있습니다. 현재 플레이하는 PC의 사양에 맞춰 알맞게 조절할 수 있습니다.]]
	[1] 	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TXT_SOUND_HELP" ),			--[[- 게임에서 나오는 모든 소리를 켜고 끄거나, 음량을 자유롭게 조정할 수 있습니다.]]
	[2] 	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TXT_GAME_HELP" ),			--[[- 게임의 세부적인 기능을 켜고 끄거나, 보다 사용자의 편의에 맞춰 조정할 수 있습니다.]]
	[3] 	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TXT_KEY_HELP" ),			--[[- 게임에서 사용되는 조작 키를 키보드 또는 지원하는 게임 패드에 사용자가 직접 적용하여 사용할 수 있습니다.]]

	[4] 	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_GAMMA" ),				--[[감마 조절]]
	[5] 	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_INTERFACE" ),			--[[인터페이스 크기 조절]]

	[6] 	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_MASTERVOLUME" ),		--[[전체 음량 조절]]
	[7] 	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_BGMVOLUME" ),			--[[음악 음량 조절]]
	[8] 	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_FXVOLUME" ),			--[[효과음 음량 조절]]
	[9] 	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_ENVVOLUME" ),			--[[환경 효과음 음량 조절]]
	[10] 	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_DIALOGVOLUME" ),		--[[음성 음량 조절]]

	[11] 	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_CAMERASHAKE" ),		--[[카메라 진동 설정]]
	[12] 	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_MOUSESENSEX" ),		--[[마우스 수평 감도]]
	[13] 	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_MOUSESENSEY" ),		--[[마우스 수직 감도]]
	[14] 	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_PADSENSEX" ),			--[[게임패드 수평 감도]]
	[15] 	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_PADSENSEY" ),			--[[게임패드 수직 감도]]

	[16] 	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TXT_KEYUI_HELP" ),			--[[- 게임에서 사용되는 인터페이스용 키를 키보드 또는 지원하는 게임 패드에 사용자가 직접 적용하여 사용할 수 있습니다.]]
	[17] 	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_CAMERABLUR" ),		--[[카메라 잔상 설정]]
	[18]	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_HITFXVOLUME" ),		--[[타격 음량 조절]]
	[19]	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_HITFXWEIGHT" ),		--[[타격음 밝기 조절]]
	[20]	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_OTHERUSERVOLUME" ),	--[[다른 유저의 음량 조절]]
	
	[21] 	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_CONTRAST" ),			--[[대비 조절]]
	
	[22] 	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_CAMERAPOS" ),			--[[카메라 각도 효과 설정(액션에 한하여)]]
	[23] 	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_CAMERAFOV" ),			--[
	[24] 	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_FOV" ),
	[25] 	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_CAMERAMASTER" ),		--[[카메라 효과 전체 설정]]	
	[26] 	= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TXT_LANGUAGE_HELP" ),		--[[- 게임에서 사용되는 조작 키를 키보드 또는 지원하는 게임 패드에 사용자가 직접 적용하여 사용할 수 있습니다.]]
}

local  _volumeParam = SoundVolumeParam()
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 프레임 가져오기
Panel_Window_Option:AddChild ( _frame_Display )
Panel_GameOption_Display:RemoveControl( _frame_Display )

Panel_Window_Option:AddChild ( _frame_Sound )
Panel_GameOption_Sound:RemoveControl( _frame_Sound )

Panel_Window_Option:AddChild ( _frame_Game )
Panel_GameOption_Game:RemoveControl( _frame_Game )----------------------------------------------------------------------------------------------

Panel_Window_Option:AddChild ( _static_KeySetBG )
Panel_Window_Option:AddChild ( _static_PadSetBG )
Panel_Window_Option:AddChild ( _static_KeySetTitle )
Panel_Window_Option:AddChild ( _static_ResetKeyConfig )
Panel_Window_Option:AddChild ( _frame_KeyConfig )
Panel_GameOption_Key:RemoveControl( _static_KeySetBG )
Panel_GameOption_Key:RemoveControl( _static_PadSetBG )
Panel_GameOption_Key:RemoveControl( _static_KeySetTitle )
Panel_GameOption_Key:RemoveControl( _static_ResetKeyConfig )
Panel_GameOption_Key:RemoveControl( _frame_KeyConfig )

Panel_Window_Option:AddChild ( _static_KeySetBG_UI )
Panel_Window_Option:AddChild ( _static_PadSetBG_UI )
Panel_Window_Option:AddChild ( _static_KeySetTitle_UI )
Panel_Window_Option:AddChild ( _static_ResetKeyConfig_UI )
Panel_Window_Option:AddChild ( _static_ResetPositionConfig_UI )
Panel_Window_Option:AddChild ( _frame_KeyConfig_UI )
Panel_GameOption_Key_UI:RemoveControl( _static_KeySetBG_UI )
Panel_GameOption_Key_UI:RemoveControl( _static_PadSetBG_UI )
Panel_GameOption_Key_UI:RemoveControl( _static_KeySetTitle_UI )
Panel_GameOption_Key_UI:RemoveControl( _static_ResetKeyConfig_UI )
Panel_GameOption_Key_UI:RemoveControl( _static_ResetPositionConfig_UI )
Panel_GameOption_Key_UI:RemoveControl( _frame_KeyConfig_UI )

Panel_Window_Option:AddChild( _frame_Language )
Panel_GameOption_Language:RemoveControl( _frame_Language )

gamePanel_Main._btn_Display:		addInputEvent("Mouse_LUp",	"ShowFrame_Func()")
gamePanel_Main._btn_Display:		addInputEvent("Mouse_On",	"GameOption_SimpleToolTips( true, 1 )")
gamePanel_Main._btn_Display:		addInputEvent("Mouse_Out",	"GameOption_SimpleToolTips( false )")
gamePanel_Main._btn_Sound:			addInputEvent("Mouse_LUp",	"ShowFrame_Func()")
gamePanel_Main._btn_Sound:			addInputEvent("Mouse_On",	"GameOption_SimpleToolTips( true, 2 )")
gamePanel_Main._btn_Sound:			addInputEvent("Mouse_Out",	"GameOption_SimpleToolTips( false )")
gamePanel_Main._btn_Game:			addInputEvent("Mouse_LUp",	"ShowFrame_Func()")
gamePanel_Main._btn_Game:			addInputEvent("Mouse_On",	"GameOption_SimpleToolTips( true, 3 )")
gamePanel_Main._btn_Game:			addInputEvent("Mouse_Out",	"GameOption_SimpleToolTips( false )")
gamePanel_Main._btn_KeyConfig:		addInputEvent("Mouse_LUp",	"ShowFrame_Func()")
gamePanel_Main._btn_KeyConfig:		addInputEvent("Mouse_On",	"GameOption_SimpleToolTips( true, 4 )")
gamePanel_Main._btn_KeyConfig:		addInputEvent("Mouse_Out",	"GameOption_SimpleToolTips( false )")
gamePanel_Main._btn_KeyConfig_UI:	addInputEvent("Mouse_LUp",	"ShowFrame_Func()")
gamePanel_Main._btn_KeyConfig_UI:	addInputEvent("Mouse_On",	"GameOption_SimpleToolTips( true, 5 )")
gamePanel_Main._btn_KeyConfig_UI:	addInputEvent("Mouse_Out",	"GameOption_SimpleToolTips( false )")

gamePanel_Main._btn_Language:		addInputEvent("Mouse_LUp",	"ShowFrame_Func()")
gamePanel_Main._btn_Language:		addInputEvent("Mouse_On",	"GameOption_SimpleToolTips( true, 6 )")
gamePanel_Main._btn_Language:		addInputEvent("Mouse_Out",	"GameOption_SimpleToolTips( false )")

-- gamePanel_Main._btn_UIRePos:		addInputEvent("Mouse_LUp",	"GameUIRepos()")
-- gamePanel_Main._btn_GameExit:		addInputEvent("Mouse_LUp",	"GameExitOpen()")





-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 심플툴팁 선언부
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local simpleToolTipIdx =
{
	-- 화면

	_btn_ScreenMode0			= 0,
	_btn_ScreenMode1			= 1,
	_btn_ScreenMode2			= 2,
	_btn_ScrSize				= 3,
	_btn_Trxt					= 4,
	_btn_Rndr					= 5,
	_btn_AntiAlli				= 6,
	_btn_SSAO					= 7,
	_btn_PostFilter		    	= 8,
	_btn_DOF					= 9,
	_btn_Tessellation			= 10,	
	_btn_Ultra			    	= 11,
	_btn_BloodEffect			= 12,
	_btn_LensBlood		    	= 13,
	_btn_CharacterEffect		= 14,
	_btn_SelfPlayerOnlyEffect	= 15,
	_btn_SelfPlayerOnlyLantern  = 16,
	_btn_CropModeEnable		    = 17,
	_btn_CropModeScaleX			= 18,
	_btn_CropModeScaleY			= 19,
	_btn_UpscaleEnable	    	= 20,
	_btn_SleepModeEnable		= 21,
	_btn_UIScale				= 22,
	_btn_CameraMaster		    = 23,
	_btn_CameraShake		    = 24,
	_btn_MotionBlur				= 25,
	_btn_CameraPos				= 26,
	_btn_CameraFov				= 27,
	_btn_LUT					= 28,
	_btn_LUT_Reset			    = 29,
	_btn_Gamma					= 30,
	_btn_Contrast			    = 31,
	_btn_Fov				    = 32,
	-- 소리
	_btn_MusicOnOff	 			= 33,
	_btn_FXOnOff 			    = 34,
	_btn_EnvFXOnOff 		    = 35,
	_btn_TotalVol 		  		= 36,
	_btn_MusicVol				= 37,
	_btn_FxVol 					= 38,
	_btn_EnvFxVol 			    = 39,
	_btn_VoiceVol				= 40,
	_btn_hitFxVolume		    = 41,
	_btn_hitFxWeightVolume    	= 42,
	_btn_otherPlayerVolume		= 43,
	-- 게임
	_btn_AutoAim				= 44,
	_btn_HideWindow				= 45,
	_btn_GuildLogin				= 46,
	_btn_RejectInvitation		= 47,
	_btn_EnableSimpleUI			= 48,
	_btn_SpiritGuide			= 49,
	_btn_MouseMove              = 50,
	_btn_EnableOVR              = 51,
	_btn_SelfNameShowAllways    = 52,
	_btn_SelfNameShowImportant  = 53,
	_btn_SelfNameShowNoShow		= 54,
	_btn_OtherNameShow          = 55,
	_btn_PartyNameShow          = 56,
	_btn_GuildNameShow          = 57,
	_btn_Alert_Region           = 58,
	_btn_Alert_TerritoryTrade	= 59,
	_btn_Alert_RoyalTrade       = 60,
	_btn_Alert_Fitness          = 61,
	_btn_Alert_TerritoryWar     = 62,
	_btn_Alert_GuildWar         = 63,
	_btn_Alert_PlayerGotItem	= 64,
	_btn_Alert_ItemMarket       = 65,
	_btn_Alert_LifeLevUp        = 66,
	_btn_Alert_GuildQuest		= 67,
	_btn_MouseX                 = 68,
	_btn_MouseY                 = 69,
	_btn_MouXSen				= 70,
	_btn_MouYSen				= 71,
	_btn_UsePad                 = 72,
	_btn_UseVibe                = 73,
	_btn_PadX                   = 74,
	_btn_PadY					= 75,
	_btn_PadXSen				= 76,
	_btn_PadYSen				= 77,
	_btn_MiniMapRotation		= 78,
	_btn_NearestPlayerOnlyEffect = 79,
	_btn_PetAll					= 80,
	_btn_PetMine				= 81,
	_btn_PetHide				= 82,
	
	_btn_NavGuideNone			= 83,
	_btn_NavGuideArrow			= 84,
	_btn_NavGuideEffect			= 85,
	_btn_NavGuideFairy			= 86,
	
	_btn_ShowAttackEffect		= 87,
	_btn_Alert_BlackSpirit		= 88,
	_btn_RiddingOnOff			= 89,
	_btn_CombatAllwaysOn		= 90,
	_btn_CombatAllwaysOff		= 91,
	_btn_CombatAllwaysLowOff	= 92,
	_btn_UseNewQuickSlot		= 93,
	_btn_UseChattingFilter		= 94,
	-- { 캐릭터 가이드 라인
		_btn_GuideLineHumanRelation	= 95,
		_btn_GuideLineZoneChange	= 96,
		_btn_GuideLineWarAlly		= 97,
		_btn_GuideLineGuild			= 98,
		_btn_GuideLineParty			= 99,
		_btn_GuideLineEnemy			= 100,
		_btn_GuideLineNonWarPlayer	= 101,
		_btn_GuideLineQuestObject	= 102,
	-- }

	_btn_IsOnScreenSaver		= 103,
	_btn_WhisperOnOff			= 105,
	_btn_UIModeMouseLock		= 108,
	_btn_PvpRefuse				= 109,
	_btn_TraySoundOnOff			= 111,

	_btn_ColorBlind_None		= 112,
	_btn_ColorBlind_Red			= 113,
	_btn_ColorBlind_Green		= 114,
	_btn_Alert_NearMonster					= 115,
}

local toolTipIdxValue =
{
	-- 화면
	[simpleToolTipIdx._btn_ScreenMode0]				= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_SCREENMODE0"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_SCREENMODE0"), control = frame_Display._btn_ScreenMode[0] }, 
	[simpleToolTipIdx._btn_ScreenMode1]				= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_SCREENMODE1"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_SCREENMODE1"), control = frame_Display._btn_ScreenMode[1] }, 
	[simpleToolTipIdx._btn_ScreenMode2]				= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_SCREENMODE2"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_SCREENMODE2"), control = frame_Display._btn_ScreenMode[2] }, 
	[simpleToolTipIdx._btn_ScrSize]					= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_SCRSIZE"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_SCRSIZE"), control = frame_Display._btn_ScrSize },
	[simpleToolTipIdx._btn_Trxt]					= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_TRXT"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_TRXT"), control = frame_Display._btn_Trxt },
	[simpleToolTipIdx._btn_Rndr]					= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_RNDR"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_RNDR"), control = frame_Display._btn_Rndr },
	[simpleToolTipIdx._btn_AntiAlli]				= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_ANTIALLI"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_ANTIALLI"), control = frame_Display._btn_AntiAlli },
	[simpleToolTipIdx._btn_SSAO]					= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_SSAO"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_SSAO"), control = frame_Display._btn_SSAO },
	[simpleToolTipIdx._btn_PostFilter]				= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_FILTER"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_FILTER"), control = frame_Display._btn_PostFilter },
	[simpleToolTipIdx._btn_DOF]						= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_DOF"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_DOF"), control = frame_Display._btn_DOF },
	[simpleToolTipIdx._btn_Tessellation]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_TESSELLATION"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_TESSELLATION"), control = frame_Display._btn_Tessellation },
	[simpleToolTipIdx._btn_Ultra]					= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_ULTRA"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_ULTRA"), control = frame_Display._btn_Ultra },
	[simpleToolTipIdx._btn_BloodEffect]				= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_BLOODEFFECT"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_BLOODEFFECT"), control = frame_Display._btn_BloodEffect },
	[simpleToolTipIdx._btn_LensBlood]				= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_LENSBLOOD"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_LENSBLOOD"), control = frame_Display._btn_LensBlood },
	[simpleToolTipIdx._btn_CharacterEffect]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_CHARACTEREFFECT"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_CHARACTEREFFECT"), control = frame_Display._btn_CharacterEffect },
	[simpleToolTipIdx._btn_SelfPlayerOnlyEffect]	= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_SELFPLAYERONLYEFFECT"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_SELFPLAYERONLYEFFECT"), control = frame_Display._btn_SelfPlayerOnlyEffect },
	[simpleToolTipIdx._btn_NearestPlayerOnlyEffect]	= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_NEARESTPLAYERONLYEFFECT"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NEARESTPLAYERONLYEFFECT"), control = frame_Display._btn_NearestPlayerOnlyEffect },
	[simpleToolTipIdx._btn_SelfPlayerOnlyLantern]	= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_SELFPLAYERONLYLANTERN"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_SELFPLAYERONLYLANTERN"), control = frame_Display._btn_SelfPlayerOnlyLantern },
	[simpleToolTipIdx._btn_CropModeEnable]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_CROPMODEENABLE"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_CROPMODEENABLE"), control = frame_Display._btn_CropModeEnable },
	[simpleToolTipIdx._btn_CropModeScaleX]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_CROPMODESCALEX"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_CROPMODESCALEX"), control = _btn_CropModeScaleX },
	[simpleToolTipIdx._btn_CropModeScaleY]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_CROPMODESCALEY"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_CROPMODESCALEY"), control = _btn_CropModeScaleY },	
	[simpleToolTipIdx._btn_UpscaleEnable]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_UPSCALE"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_UPSCALE"), control = frame_Display._btn_UpscaleEnable },
	[simpleToolTipIdx._btn_SleepModeEnable]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_SLEEPMODE"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_SLEEPMODE"), control = frame_Display._btn_SleepModeEnable },
	[simpleToolTipIdx._btn_UIScale]					= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_UISCALE"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_UISCALE"), control = _btn_UIScale },
	[simpleToolTipIdx._btn_CameraMaster]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_CAMERAMASTER"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_CAMERAMASTER"), control = _btn_CameraMaster },
	[simpleToolTipIdx._btn_CameraShake]				= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_CAMERASHAKE"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_CAMERASHAKE"), control = _btn_CameraShake },
	[simpleToolTipIdx._btn_MotionBlur]				= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_MOTIONBLUR"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_MOTIONBLUR"), control = _btn_MotionBlur },
	[simpleToolTipIdx._btn_CameraPos]				= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_CAMERAPOS"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_CAMERAPOS"), control = _btn_CameraPos },
	[simpleToolTipIdx._btn_CameraFov]				= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_CAMERAFOV"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_CAMERAFOV"), control = _btn_CameraFov },
	[simpleToolTipIdx._btn_LUT]						= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_LUT"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_LUT"), control = frame_Display._btn_LUT },
	[simpleToolTipIdx._btn_LUT_Reset]				= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_LUT_RESET"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_LUT_RESET"), control = frame_Display._btn_LUT_Reset },
	[simpleToolTipIdx._btn_Gamma]					= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_GAMMA"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_GAMMA"), control = _btn_Gamma },
	[simpleToolTipIdx._btn_Contrast]				= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_CONTRAST"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_CONTRAST"), control = _btn_Contrast },
	[simpleToolTipIdx._btn_Fov]						= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_FOV"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_FOV"), control = _btn_Fov },
-- [simpleToolTipIdx._btn_ColorBlind_None]				= { name= "설정 안함", desc= " 모드를 설정하지 않습니다.", control = frame_Display._btn_ColorBlind[0] },
	[simpleToolTipIdx._btn_ColorBlind_Red]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_COLORBLIND_TOOLTIP_NAME_RED"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_COLORBLIND_TOOLTIP_DESC_RED"), control = frame_Display._btn_ColorBlind[1] },
	[simpleToolTipIdx._btn_ColorBlind_Green]		= { name= PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_COLORBLIND_TOOLTIP_NAME_GREEN"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_COLORBLIND_TOOLTIP_DESC_GREEN"), control = frame_Display._btn_ColorBlind[2] },
	-- 소리
	[simpleToolTipIdx._btn_MusicOnOff]				= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_MUSICONOFF"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_MUSICONOFF"), control = frame_Sound._btn_MusicOnOff },
	[simpleToolTipIdx._btn_FXOnOff]					= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_FXONOFF"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_FXONOFF"), control = frame_Sound._btn_FXOnOff },
	[simpleToolTipIdx._btn_EnvFXOnOff]				= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_ENVFXONOFF"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_ENVFXONOFF"), control = frame_Sound._btn_EnvFXOnOff },
	[simpleToolTipIdx._btn_TotalVol]				= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_TOTALVOL"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_TOTALVOL"), control = _btn_TotalVol },
	[simpleToolTipIdx._btn_MusicVol]				= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_MUSICVOL"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_MUSICVOL"), control = _btn_MusicVol },
	[simpleToolTipIdx._btn_FxVol]					= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_FXVOL"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_FXVOL"), control = _btn_FxVol },
	[simpleToolTipIdx._btn_EnvFxVol]				= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_ENVFXVOL"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_ENVFXVOL"), control = _btn_EnvFxVol },
	[simpleToolTipIdx._btn_VoiceVol]				= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_VOICEVOL"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_VOICEVOL"), control = _btn_VoiceVol },
	[simpleToolTipIdx._btn_hitFxVolume]				= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_HITFXVOLUME"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_HITFXVOLUME"), control = _btn_hitFxVolume },
	[simpleToolTipIdx._btn_hitFxWeightVolume]		= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_HITFXWEIGHTVOLUME"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_HITFXWEIGHTVOLUME"), control = _btn_hitFxWeightVolume },
	[simpleToolTipIdx._btn_otherPlayerVolume]		= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_OTHERPLAYERVOLUME"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_OTHERPLAYERVOLUME"), control = _btn_otherPlayerVolume },
	[simpleToolTipIdx._btn_WhisperOnOff]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_WHISPERONOFF"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_WHISPERONOFFDESC"), control = frame_Sound._btn_WhisperOnOff },
	[simpleToolTipIdx._btn_TraySoundOnOff]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_TRAYSOUNDONOFF"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_TRAYSOUNDONOFFDESC"), control = frame_Sound._btn_TraySoundOnOff },
	
	-- 게임
	[simpleToolTipIdx._btn_AutoAim]					= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_AUTOAIM"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_AUTOAIM"), control = frame_Game._btn_AutoAim },
	[simpleToolTipIdx._btn_HideWindow]				= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_HIDEWINDOW"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_HIDEWINDOW"), control = frame_Game._btn_HideWindow },
	[simpleToolTipIdx._btn_GuildLogin]				= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_GUILDLOGIN"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_GUILDLOGIN"), control = frame_Game._btn_GuildLogin },
	[simpleToolTipIdx._btn_RejectInvitation]		= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_REJECTINVITATION"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_REJECTINVITATION"), control = frame_Game._btn_RejectInvitation },
	[simpleToolTipIdx._btn_EnableSimpleUI]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_ENABLESIMPLEUI"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_ENABLESIMPLEUI"), control = frame_Game._btn_EnableSimpleUI },
	[simpleToolTipIdx._btn_SpiritGuide]				= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_SPIRITGUIDE"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_SPIRITGUIDE"), control = frame_Game._btn_SpiritGuide },
	[simpleToolTipIdx._btn_MouseMove]				= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_MOUSEMOVE"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_MOUSEMOVE"), control = frame_Game._btn_MouseMove },
	[simpleToolTipIdx._btn_MiniMapRotation]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_MINIMAPROTATION"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_MINIMAPROTATION"), control = frame_Game._btn_MiniMapRotation },
	[simpleToolTipIdx._btn_ShowAttackEffect]		= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_ATTACKEFFECT"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_DESC_ATTACKEFFECT"), control = frame_Game._btn_ShowAttackEffect },
	[simpleToolTipIdx._btn_Alert_BlackSpirit]		= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_BLACKSPIRITALERT"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_DESC_BLACKSPIRITALERT"), control = frame_Game._btn_Alert_BlackSpirit },
	[simpleToolTipIdx._btn_UseNewQuickSlot]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_NEWQUICKSLOT"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_DESC_NEWQUICKSLOT"), control = frame_Game._btn_UseNewQuickSlot },
	[simpleToolTipIdx._btn_UseChattingFilter]		= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_CHATTINGFILTER"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_DESC_CHATTINGFILTER"), control = frame_Game._btn_UseChattingFilter },
	[simpleToolTipIdx._btn_EnableOVR]				= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_ENABLEOVR"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_ENABLEOVR"), control = frame_Game._btn_EnableOVR },
	[simpleToolTipIdx._btn_SelfNameShowAllways]		= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_SELFNAMESHOWALLWAYS"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_SELFNAMESHOWALLWAYS"), control = frame_Game._btn_SelfNameShowAllways },
	[simpleToolTipIdx._btn_SelfNameShowImportant]	= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_SELFNAMESHOWIMPORTANT"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_SELFNAMESHOWIMPORTANT"), control = frame_Game._btn_SelfNameShowImportant },
	[simpleToolTipIdx._btn_SelfNameShowNoShow]		= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_SELFNAMESHOWNOSHOW"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_SELFNAMESHOWNOSHOW"), control = frame_Game._btn_SelfNameShowNoShow },
	[simpleToolTipIdx._btn_PetAll]					= { name= PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_PETALL_TOOLTIP_NAME"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_PETALL_TOOLTIP_DESC"), control = frame_Game._btn_PetAll },
	[simpleToolTipIdx._btn_PetMine]					= { name= PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_PETMINE_TOOLTIP_NAME"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_PETMINE_TOOLTIP_DESC"), control = frame_Game._btn_PetMine },
	[simpleToolTipIdx._btn_PetHide]					= { name= PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_PETHIDE_TOOLTIP_NAME"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_PETHIDE_TOOLTIP_DESC"), control = frame_Game._btn_PetHide },

	[simpleToolTipIdx._btn_NavGuideNone]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_NAV_NONE_TOOLTIP_NAME"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_NAV_NONE_TOOLTIP_DESC"), control = frame_Game._btn_NavGuideNone },
	[simpleToolTipIdx._btn_NavGuideArrow]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_NAV_ARROW_TOOLTIP_NAME"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_NAV_ARROW_TOOLTIP_DESC"), control = frame_Game._btn_NavGuideArrow },
	[simpleToolTipIdx._btn_NavGuideEffect]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_NAV_EFFECT_TOOLTIP_NAME"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_NAV_EFFECT_TOOLTIP_DESC"), control = frame_Game._btn_NavGuideEffect },
	[simpleToolTipIdx._btn_NavGuideFairy]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_NAV_FAIRY_TOOLTIP_NAME"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_NAV_FAIRY_TOOLTIP_DESC"), control = frame_Game._btn_NavGuideFairy },

	[simpleToolTipIdx._btn_OtherNameShow]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_OTHERNAMESHOW"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_OTHERNAMESHOW"), control = frame_Game._btn_OtherNameShow },
	[simpleToolTipIdx._btn_PartyNameShow]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_PARTYNAMESHOW"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_PARTYNAMESHOW"), control = frame_Game._btn_PartyNameShow },
	[simpleToolTipIdx._btn_GuildNameShow]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_GUILDNAMESHOW"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_GUILDNAMESHOW"), control = frame_Game._btn_GuildNameShow },
	[simpleToolTipIdx._btn_GuideLineHumanRelation]	= { name = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_GAME_GUIDELINE_HUMANRELATION_TITLE"),		desc = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_GAME_GUIDELINE_HUMANRELATION_DESC"), control = frame_Game._btn_GuideLineHumanRelation },
	[simpleToolTipIdx._btn_GuideLineQuestObject]	= { name = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_QUESTLINE_TOOLTIP_NAME"), 		desc = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_QUESTLINE_TOOLTIP_DESC"), control = frame_Game._btn_GuideLineQuestObject },
	[simpleToolTipIdx._btn_GuideLineZoneChange]		= { name = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_GAME_GUIDELINE_ZONECHANGE_TITLE"),			desc = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_GAME_GUIDELINE_ZONECHANGE_DESC"), control = frame_Game._btn_GuideLineZoneChange },
	[simpleToolTipIdx._btn_GuideLineWarAlly]		= { name = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_GAME_GUIDELINE_WARALLY_TITLE"),			desc = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_GAME_GUIDELINE_WARALLY_DESC"), control = frame_Game._btn_GuideLineWarAlly },
	[simpleToolTipIdx._btn_GuideLineGuild]			= { name = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_GAME_GUIDELINE_GUILD_TITLE"),				desc = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_GAME_GUIDELINE_GUILD_DESC"), control = frame_Game._btn_GuideLineGuild },
	[simpleToolTipIdx._btn_GuideLineParty]			= { name = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_GAME_GUIDELINE_PARTY_TITLE"),				desc = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_GAME_GUIDELINE_PARTY_DESC"), control = frame_Game._btn_GuideLineParty },
	[simpleToolTipIdx._btn_GuideLineEnemy]			= { name = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_GAME_GUIDELINE_ENEMY_TITLE"),				desc = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_GAME_GUIDELINE_ENEMY_DESC"), control = frame_Game._btn_GuideLineEnemy },
	[simpleToolTipIdx._btn_GuideLineNonWarPlayer]	= { name = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_GAME_GUIDELINE_NONWARPLAYER_TITLE"),		desc = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_GAME_GUIDELINE_NONWARPLAYER_DESC"), control = frame_Game._btn_GuideLineNonWarPlayer },
	[simpleToolTipIdx._btn_Alert_Region]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_ALERT_REGION"), 					desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_ALERT_REGION"), control = frame_Game._btn_Alert_Region },
	[simpleToolTipIdx._btn_Alert_TerritoryTrade]	= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_ALERT_TERRITORYTRADE"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_ALERT_TERRITORYTRADE"), control = frame_Game._btn_Alert_TerritoryTrade },
	[simpleToolTipIdx._btn_Alert_RoyalTrade]		= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_ALERT_ROYALTRADE"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_ALERT_ROYALTRADE"), control = frame_Game._btn_Alert_RoyalTrade },
	[simpleToolTipIdx._btn_Alert_Fitness]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_ALERT_FITNESS"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_ALERT_FITNESS"), control = frame_Game._btn_Alert_Fitness },
	[simpleToolTipIdx._btn_Alert_TerritoryWar]		= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_ALERT_TERRITORYWAR"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_ALERT_TERRITORYWAR"), control = frame_Game._btn_Alert_TerritoryWar },
	[simpleToolTipIdx._btn_Alert_GuildWar]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_ALERT_GUILDWAR"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_ALERT_GUILDWAR"), control = frame_Game._btn_Alert_GuildWar },
	[simpleToolTipIdx._btn_Alert_PlayerGotItem]		= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_ALERT_PLAYERGOTITEM"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_ALERT_PLAYERGOTITEM"), control = frame_Game._btn_Alert_PlayerGotItem },
	[simpleToolTipIdx._btn_Alert_ItemMarket]		= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_ALERT_ITEMMARKET"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_ALERT_ITEMMARKET"), control = frame_Game._btn_Alert_ItemMarket },
	[simpleToolTipIdx._btn_Alert_LifeLevUp]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_ALERT_LIFELEVUP"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_ALERT_LIFELEVUP"), control = frame_Game._btn_Alert_LifeLevUp },
	[simpleToolTipIdx._btn_Alert_GuildQuest]		= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_ALERT_GUILDQUEST"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_ALERT_GUILDQUEST"), control = frame_Game._btn_Alert_GuildQuest },
	[simpleToolTipIdx._btn_Alert_NearMonster]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_ALERT_NEARMONSTER"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_ALERT_NEARMONSTER"), control = frame_Game._btn_Alert_NearMonster },
	[simpleToolTipIdx._btn_MouseX]					= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_MOUSEX"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_MOUSEX"), control = frame_Game._btn_MouseX },
	[simpleToolTipIdx._btn_MouseY]					= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_MOUSEY"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_MOUSEY"), control = frame_Game._btn_MouseY },
	[simpleToolTipIdx._btn_MouXSen]					= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_MOUXSEN"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_MOUXSEN"), control = _btn_MouXSen },
	[simpleToolTipIdx._btn_MouYSen]					= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_MOUYSEN"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_MOUYSEN"), control = _btn_MouYSen },
	[simpleToolTipIdx._btn_UsePad]					= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_USEPAD"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_USEPAD"), control = frame_Game._btn_UsePad },
	[simpleToolTipIdx._btn_UseVibe]					= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_USEVIBE"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_USEVIBE"), control = frame_Game._btn_UseVibe },
	[simpleToolTipIdx._btn_PadX]					= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_PADX"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_PADX"), control = frame_Game._btn_PadX },
	[simpleToolTipIdx._btn_PadY]					= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_PADY"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_PADY"), control = frame_Game._btn_PadY },
	[simpleToolTipIdx._btn_PadXSen]					= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_PADXSEN"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_PADXSEN"), control = _btn_PadXSen },
	[simpleToolTipIdx._btn_PadYSen]					= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_PADYSEN"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_PADYSEN"), control = _btn_PadYSen },
	[simpleToolTipIdx._btn_RiddingOnOff]			= { name= PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_SOUND_BTN_SERVANT"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_TOOLTIP_SOUND_SERVANT"), control = frame_Sound._btn_RiddingOnOff },
	[simpleToolTipIdx._btn_CombatAllwaysOn]			= { name= PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_SOUND_BTN_COMBATALLWAYS"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_TOOLTIP_SOUND_COMBATALLWAYS"), control = frame_Sound._btn_CombatAllwaysOn },
	[simpleToolTipIdx._btn_CombatAllwaysOff]		= { name= PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_SOUND_BTN_COMBATTURNOFF"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_TOOLTIP_SOUND_COMBATTURNOFF"), control = frame_Sound._btn_CombatAllwaysOff },
	[simpleToolTipIdx._btn_CombatAllwaysLowOff]		= { name= PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_SOUND_BTN_COMBATNORMAL"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_TOOLTIP_SOUND_COMBATNORMAL"), control = frame_Sound._btn_CombatAllwaysLowOff },
	[simpleToolTipIdx._btn_IsOnScreenSaver]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_ISONSCREENSAVER"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_ISONSCREENSAVERDESC"), control = frame_Game._btn_IsOnScreenSaver },
	[simpleToolTipIdx._btn_UIModeMouseLock]			= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_UIMODEMOUSELOCK"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_UIMODEMOUSELOCKDESC"), control = frame_Game._btn_UIModeMouseLock },
	[simpleToolTipIdx._btn_PvpRefuse]				= { name= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_PVPREFUSE"), desc= PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_NAME_PVPREFUSEDESC"), 	  control = frame_Game._btn_PvpRefuse },
}
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------






------------------------------------------------------------------------------------------------
-- 지역 변수
------------------------------------------------------------------------------------------------

local minScaleValue = 50;
local maxScaleValue = 120;

local minScaleHeight = 720;
local midleScaleHeight = 900;
local HighScaleHeight = 1080;
local MaxScaleHeight = 1600;

local const_UiScaleValue =
{
	50,
	90,
	100,
	120,
	140,
	200,
}

if false == isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_KOR ) then
	const_LowMaxScaleValue	= 100
end


function Panel_GameOption_Initialize()
	-- isChecked_UIMain = true
	-- isChecked_KeyViewer = false
	HideAllFrame_Func()
	getFrameSize_SetSlideSize()
	GameOption_UIScale_Change()

	gamePanel_Main._txt_Comment:SetTextMode( UI_TM.eTextMode_AutoWrap )
	gamePanel_Main._txt_Comment:SetText( GetStr_Option[0] )
	gamePanel_Main._txt_Comment:SetSize( gamePanel_Main._txt_Comment:GetSizeX(), gamePanel_Main._txt_Comment:GetSizeY() )

	gamePanel_Main._btn_Display:SetCheck(true)
	gamePanel_Main._btn_Sound:SetCheck(false)
	gamePanel_Main._btn_Game:SetCheck(false)
	gamePanel_Main._btn_KeyConfig:SetCheck(false)
	gamePanel_Main._btn_KeyConfig_UI:SetCheck(false)
	gamePanel_Main._btn_Language:SetCheck(false)

	-- 체크 버튼 ENABLE AREA를 셋팅해준다!
	local fullMode_TextSize 		= frame_Display._btn_ScreenMode[0]:GetTextSizeX() + 5
	local windowFullMode_TextSize 	= frame_Display._btn_ScreenMode[1]:GetTextSizeX() + 5
	local windowMode_TextSize		= frame_Display._btn_ScreenMode[2]:GetTextSizeX() + 5

	local fullMode 					= frame_Display._btn_ScreenMode[0]
	local windowFullMode 			= frame_Display._btn_ScreenMode[1]
	local windowMode				= frame_Display._btn_ScreenMode[2]

	local dof_TextSize 				= frame_Display._btn_DOF:GetTextSizeX() + 5
	local antiAlli_TextSize			= frame_Display._btn_AntiAlli:GetTextSizeX() + 5
	local ultra_TextSize			= frame_Display._btn_Ultra:GetTextSizeX() + 5
	local lensBlood_TextSize		= frame_Display._btn_LensBlood:GetTextSizeX() + 5
	local bloodEffect_TextSize		= frame_Display._btn_BloodEffect:GetTextSizeX() + 5
	
	local SSAO_TextSize				= frame_Display._btn_SSAO:GetTextSizeX() + 5
	local Tessellation_TextSize		= frame_Display._btn_Tessellation:GetTextSizeX() + 5
	local PostFilter_TextSize		= frame_Display._btn_PostFilter:GetTextSizeX() + 5
	local characterEffect_TextSize	= frame_Display._btn_CharacterEffect:GetTextSizeX() + 5
	
	local SelfPlayerOnlyEffect_TextSize	= frame_Display._btn_SelfPlayerOnlyEffect:GetTextSizeX() + 5
	local NearestPlayerOnlyEffect_TextSize	= frame_Display._btn_NearestPlayerOnlyEffect:GetTextSizeX() + 5
	local SelfPlayerOnlyLantern_TextSize= frame_Display._btn_SelfPlayerOnlyLantern:GetTextSizeX() + 5
	local UpscaleEnable_TextSize	= frame_Display._btn_UpscaleEnable:GetTextSizeX() + 5
	local SleepModeEnable_TextSize	= frame_Display._btn_SleepModeEnable:GetTextSizeX() + 5
	local CropModeEnable_TextSize	= frame_Display._btn_CropModeEnable:GetTextSizeX() + 5
	local IsOnScreenSaver_TextSize	= frame_Game._btn_IsOnScreenSaver:GetTextSizeX() + 5

	local dof						= frame_Display._btn_DOF
	local antiAlli					= frame_Display._btn_AntiAlli
	local ultra						= frame_Display._btn_Ultra
	local lensBlood					= frame_Display._btn_LensBlood
	local bloodEffect				= frame_Display._btn_BloodEffect
	
	local SSAO						= frame_Display._btn_SSAO
	local Tessellation				= frame_Display._btn_Tessellation
	local PostFilter				= frame_Display._btn_PostFilter
	local characterEffect			= frame_Display._btn_CharacterEffect
	
	local SelfPlayerOnlyEffect		= frame_Display._btn_SelfPlayerOnlyEffect
	local NearestPlayerOnlyEffect	= frame_Display._btn_NearestPlayerOnlyEffect
	local SelfPlayerOnlyLantern		= frame_Display._btn_SelfPlayerOnlyLantern
	local UpscaleEnable				= frame_Display._btn_UpscaleEnable
	local SleepModeEnable			= frame_Display._btn_SleepModeEnable
	
	local CropModeEnable			= frame_Display._btn_CropModeEnable
	local IsOnscreenSaver			= frame_Game._btn_IsOnScreenSaver

	fullMode:SetEnableArea ( 0, 0, fullMode:GetSizeX() + fullMode_TextSize, fullMode:GetSizeY() )
	windowFullMode:SetEnableArea ( 0, 0, windowFullMode:GetSizeX() + windowFullMode_TextSize, windowFullMode:GetSizeY() )
	windowMode:SetEnableArea ( 0, 0, windowMode:GetSizeX() + windowMode_TextSize, windowMode:GetSizeY() )

	dof:SetEnableArea ( 0, 0, dof:GetSizeX() + dof_TextSize, dof:GetSizeY() )
	antiAlli:SetEnableArea ( 0, 0, antiAlli:GetSizeX() + antiAlli_TextSize, antiAlli:GetSizeY() )
	ultra:SetEnableArea ( 0, 0, ultra:GetSizeX() + ultra_TextSize, ultra:GetSizeY() )
	lensBlood:SetEnableArea ( 0, 0, lensBlood:GetSizeX() + lensBlood_TextSize, lensBlood:GetSizeY() )
	bloodEffect:SetEnableArea ( 0, 0, bloodEffect:GetSizeX() + bloodEffect_TextSize, bloodEffect:GetSizeY() )
	
	SSAO:SetEnableArea ( 0, 0, SSAO:GetSizeX() + SSAO_TextSize, SSAO:GetSizeY() )
	Tessellation:SetEnableArea ( 0, 0, Tessellation:GetSizeX() + Tessellation_TextSize, Tessellation:GetSizeY() )
	PostFilter:SetEnableArea ( 0, 0, PostFilter:GetSizeX() + PostFilter_TextSize, PostFilter:GetSizeY() )
	characterEffect:SetEnableArea ( 0, 0, characterEffect:GetSizeX() + characterEffect_TextSize, characterEffect:GetSizeY() )
	
	SelfPlayerOnlyEffect:SetEnableArea ( 0, 0, SelfPlayerOnlyEffect:GetSizeX() + SelfPlayerOnlyEffect_TextSize, SelfPlayerOnlyEffect:GetSizeY() )
	NearestPlayerOnlyEffect:SetEnableArea ( 0, 0, NearestPlayerOnlyEffect:GetSizeX() + NearestPlayerOnlyEffect_TextSize, NearestPlayerOnlyEffect:GetSizeY() )
	SelfPlayerOnlyLantern:SetEnableArea ( 0, 0, SelfPlayerOnlyLantern:GetSizeX() + SelfPlayerOnlyLantern_TextSize, SelfPlayerOnlyLantern:GetSizeY() )
	UpscaleEnable:SetEnableArea ( 0, 0, UpscaleEnable:GetSizeX() + UpscaleEnable_TextSize, UpscaleEnable:GetSizeY() )
	-- SleepModeEnable:SetEnableArea ( 0, 0, SleepModeEnable:GetSizeX() +SleepModeEnable_TextSize, SleepModeEnable:GetSizeY() )
	CropModeEnable:SetEnableArea ( 0, 0, CropModeEnable:GetSizeX() + CropModeEnable_TextSize, CropModeEnable:GetSizeY() )
	IsOnscreenSaver:SetEnableArea ( 0, 0, IsOnscreenSaver:GetSizeX() + IsOnScreenSaver_TextSize, IsOnscreenSaver:GetSizeY() )
	
	-- 스크린샷 포맷 ENABLE AREA 설정
	local ss_FormatBMP_TextSize 		= frame_Display._btn_ScreenShotFormat[0]:GetTextSizeX() + 5
	local ss_FormatJPG_TextSize	 	= frame_Display._btn_ScreenShotFormat[1]:GetTextSizeX() + 5
	local ss_FormatPNG_TextSize		= frame_Display._btn_ScreenShotFormat[2]:GetTextSizeX() + 5

	local ss_FormatBMP 			= frame_Display._btn_ScreenShotFormat[0]
	local ss_FormatJPG 			= frame_Display._btn_ScreenShotFormat[1]
	local ss_FormatPNG			= frame_Display._btn_ScreenShotFormat[2]

	-- 스크린샷 포맷 ENABLE AREA 설정
	ss_FormatBMP:SetEnableArea ( 0, 0, ss_FormatBMP:GetSizeX() + ss_FormatBMP_TextSize, ss_FormatBMP:GetSizeY() )
	ss_FormatJPG:SetEnableArea ( 0, 0, ss_FormatJPG:GetSizeX() + ss_FormatJPG_TextSize, ss_FormatJPG:GetSizeY() )
	ss_FormatPNG:SetEnableArea ( 0, 0, ss_FormatPNG:GetSizeX() + ss_FormatPNG_TextSize, ss_FormatPNG:GetSizeY() )
	
	-- 흑정령 가이드(임시용)
	if frame_Game._btn_SpiritGuide:IsCheck() ~= _currentSpiritGuideCheck then
		frame_Game._btn_SpiritGuide:SetCheck(_currentSpiritGuideCheck)
	end

	local screenSizeX = getScreenSizeX()
	local screenSizeY = getScreenSizeY()
	Panel_Window_Option:SetPosX( (screenSizeX - Panel_Window_Option:GetSizeX()) / 2 )
	Panel_Window_Option:SetPosY( (screenSizeY - Panel_Window_Option:GetSizeY()) / 2 )

	local btnDisplaySizeX				= gamePanel_Main._btn_Display:GetSizeX()+23
	local btnDisplayTextPosX			= (btnDisplaySizeX - (btnDisplaySizeX/2) - ( gamePanel_Main._btn_Display:GetTextSizeX() / 2 ))
	local btnSoundSizeX					= gamePanel_Main._btn_Sound:GetSizeX()+23
	local btnSoundTextPosX				= (btnSoundSizeX - (btnSoundSizeX/2) - ( gamePanel_Main._btn_Sound:GetTextSizeX() / 2 ))
	local btnGameSizeX					= gamePanel_Main._btn_Game:GetSizeX()+23
	local btnGameTextPosX				= (btnGameSizeX - (btnGameSizeX/2) - ( gamePanel_Main._btn_Game:GetTextSizeX() / 2 ))
	local btnKeySizeX					= gamePanel_Main._btn_KeyConfig:GetSizeX()+23
	local btnKeyTextPosX				= (btnKeySizeX - (btnKeySizeX/2) - ( gamePanel_Main._btn_KeyConfig:GetTextSizeX() / 2 ))
	local btnKeyUiSizeX					= gamePanel_Main._btn_KeyConfig_UI:GetSizeX()+23
	local btnKeyUiTextPosX				= (btnKeyUiSizeX - (btnKeyUiSizeX/2) - ( gamePanel_Main._btn_KeyConfig_UI:GetTextSizeX() / 2 ))
	local btnLanguageSizeX				= gamePanel_Main._btn_Language:GetSizeX()+23
	local btnLanguageTextPosX			= (btnLanguageSizeX - (btnLanguageSizeX/2) - ( gamePanel_Main._btn_Language:GetTextSizeX() / 2 ))

	gamePanel_Main._btn_Display					:SetTextSpan( btnDisplayTextPosX, 5 )
	gamePanel_Main._btn_Sound					:SetTextSpan( btnSoundTextPosX, 5 )
	gamePanel_Main._btn_Game					:SetTextSpan( btnGameTextPosX, 5 )
	gamePanel_Main._btn_KeyConfig				:SetTextSpan( btnKeyTextPosX, 5 )
	gamePanel_Main._btn_KeyConfig_UI			:SetTextSpan( btnKeyUiTextPosX, 5 )
	gamePanel_Main._btn_Language				:SetTextSpan( btnLanguageTextPosX, 5 )
	
--{ AutoWrap 셋팅
	frame_Game._btn_ShowTag						:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_ShowTag						:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_BTN_CHARACTERNAME") )
	frame_Game._btn_AutoAim						:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_AutoAim						:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_BTN_TARGETHELP") )
	frame_Game._btn_RejectInvitation			:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_RejectInvitation			:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_BTN_REJECT") )
	frame_Game._btn_HideWindow					:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_HideWindow					:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_TEXT_HIDE_HIT") )
	frame_Game._btn_EnableSimpleUI				:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_EnableSimpleUI				:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_BTN_SIMPLE_UI") )
	frame_Game._btn_SpiritGuide					:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_SpiritGuide					:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_GAME_SPRITGUIDE") )
	frame_Game._btn_MouseMove					:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_MouseMove					:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_BTN_MOUSEMOVE") )
	frame_Game._btn_MiniMapRotation				:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_MiniMapRotation				:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_MINIMAPROTATION") )
	frame_Game._btn_ShowAttackEffect			:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_ShowAttackEffect			:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_GAME_SHOWATTACKEFFECT") )
	frame_Game._btn_Alert_BlackSpirit			:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_Alert_BlackSpirit			:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_GAME_BLACKSPIRITALERT") )
	frame_Game._btn_UseNewQuickSlot				:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_UseNewQuickSlot				:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_QUICKSLOT") )
	frame_Game._btn_UseChattingFilter			:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_UseChattingFilter			:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_CHATFILTERING") )
	frame_Game._btn_IsOnScreenSaver				:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_IsOnScreenSaver				:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_GAME_SCREENSAVER") )
	frame_Game._btn_EnableOVR					:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_EnableOVR					:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_BTN_RENDER_OVR") )
	frame_Game._btn_MouseX						:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_MouseX						:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_BTN_MOUSEINVERTX") )
	frame_Game._btn_MouseY						:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_MouseY						:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_BTN_MOUSEINVERTY") )
	frame_Game._btn_SelfNameShowAllways			:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_SelfNameShowAllways			:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_GAME_SELFPLAYER") )
	frame_Game._btn_SelfNameShowNoShow			:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_SelfNameShowNoShow			:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_GAME_MYCHARACTERNICKNAME") )
	frame_Game._btn_SelfNameShowImportant		:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_SelfNameShowImportant		:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_GAME_ATTACKNAMESHOW") )
	frame_Game._btn_PetAll						:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_PetAll						:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_PETVISUAL_ALL") )
	frame_Game._btn_PetMine						:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_PetMine						:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_PETVISUAL_MINE") )
	frame_Game._btn_PetHide						:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_PetHide						:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_PETVISUAL_HIDE") )
	frame_Game._btn_NavGuideNone				:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_NavGuideNone				:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_NAVPATH_NONE") )
	frame_Game._btn_NavGuideArrow				:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_NavGuideArrow				:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_NAVPATH_ARROW") )
	frame_Game._btn_NavGuideEffect				:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_NavGuideEffect				:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_NAVPATH_EFFECT") )
	frame_Game._btn_NavGuideFairy				:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_NavGuideFairy				:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_NAVPATH_FAIRY") )
	frame_Game._btn_OtherNameShow				:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_OtherNameShow				:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_GAME_ANOTHERCHARACTERNICKNAME") )
	frame_Game._btn_PartyNameShow				:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_PartyNameShow				:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_GAME_PARTYNICKNAME") )
	frame_Game._btn_GuildNameShow				:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_GuildNameShow				:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_GAME_GUILDCHARNICKNAME") )
	frame_Game._btn_GuideLineHumanRelation		:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_GuideLineHumanRelation		:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_OPTION_CHARACTEROUTLINE_HUMANRELATION") )
	frame_Game._btn_GuideLineQuestObject		:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_GuideLineQuestObject		:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_GAME_QUEST") )
	frame_Game._btn_GuideLineZoneChange			:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_GuideLineZoneChange			:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_OPTION_CHARACTEROUTLINE_ZONECHANGE") )
	frame_Game._btn_GuideLineWarAlly			:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_GuideLineWarAlly			:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_OPTION_CHARACTEROUTLINE_WARALLY") )
	frame_Game._btn_GuideLineGuild				:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_GuideLineGuild				:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_OPTION_CHARACTEROUTLINE_GUILD") )
	frame_Game._btn_GuideLineParty				:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_GuideLineParty				:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_OPTION_CHARACTEROUTLINE_PARTY") )
	frame_Game._btn_GuideLineEnemy				:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_GuideLineEnemy				:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_OPTION_CHARACTEROUTLINE_ENEMY") )
	frame_Game._btn_GuideLineNonWarPlayer		:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_GuideLineNonWarPlayer		:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_OPTION_CHARACTEROUTLINE_NONWARPLAYER") )
	frame_Game._btn_Alert_Region				:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_Alert_Region				:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_CHK_REGION_INOUT") )
	frame_Game._btn_Alert_TerritoryTrade		:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_Alert_TerritoryTrade		:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_CHK_NORMALTRADE") )
	frame_Game._btn_Alert_RoyalTrade			:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_Alert_RoyalTrade			:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_CHK_GOLDENTRADE") )
	frame_Game._btn_Alert_Fitness				:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_Alert_Fitness				:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_CHK_FITNESS") )
	frame_Game._btn_Alert_TerritoryWar			:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_Alert_TerritoryWar			:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_CHK_SIEGE") )
	frame_Game._btn_Alert_GuildWar				:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_Alert_GuildWar				:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_CHK_GUILDWAR") )
	frame_Game._btn_Alert_PlayerGotItem			:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_Alert_PlayerGotItem			:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_CHK_ANOTHERGOTITEM") )
	frame_Game._btn_Alert_ItemMarket			:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_Alert_ItemMarket			:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_CHK_DEALMARKET") )
	frame_Game._btn_Alert_LifeLevUp				:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_Alert_LifeLevUp				:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_CHK_ANOTHERLIFELEVEL") )
	frame_Game._btn_Alert_GuildQuest			:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_Alert_GuildQuest			:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_CHK_ANOTHERGUILDQUEST") )
	frame_Game._btn_Alert_NearMonster			:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_Alert_NearMonster			:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_CHK_NEARMONSTER") )
	frame_Game._btn_GuildLogin					:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_GuildLogin					:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_GAME_GUILDLOGIN") )
	frame_Game._btn_UIModeMouseLock				:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_UIModeMouseLock				:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_GAME_UIMODEMOUSELOCK") )
	frame_Game._btn_PvpRefuse					:SetTextMode( UI_TM.eTextMode_LimitText)
	frame_Game._btn_PvpRefuse					:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_GAME_PVPREFUSE") )

	frame_Display._btn_DOF									:SetTextMode( UI_TM.eTextMode_LimitText )
	frame_Display._btn_DOF									:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_TXT_DOFTOGGLE") )
	frame_Display._btn_AntiAlli								:SetTextMode( UI_TM.eTextMode_LimitText )
	frame_Display._btn_AntiAlli								:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_TXT_ANTI") )
	frame_Display._btn_Ultra								:SetTextMode( UI_TM.eTextMode_LimitText )
	frame_Display._btn_Ultra								:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_TXT_ULTRA") )
	frame_Display._btn_LensBlood							:SetTextMode( UI_TM.eTextMode_LimitText )
	frame_Display._btn_LensBlood							:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_TXT_BLOODONSCREEN") )
	frame_Display._btn_BloodEffect							:SetTextMode( UI_TM.eTextMode_LimitText )
	frame_Display._btn_BloodEffect							:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_TXT_BLOOD") )
	frame_Display._btn_SSAO									:SetTextMode( UI_TM.eTextMode_LimitText )
	frame_Display._btn_SSAO									:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_TXT_SSAO") )
	frame_Display._btn_Tessellation							:SetTextMode( UI_TM.eTextMode_LimitText )
	frame_Display._btn_Tessellation							:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_TXT_TESSELLATION") )
	frame_Display._btn_PostFilter							:SetTextMode( UI_TM.eTextMode_LimitText )
	frame_Display._btn_PostFilter							:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_TXT_FILTER") )
	frame_Display._btn_CharacterEffect						:SetTextMode( UI_TM.eTextMode_LimitText )
	frame_Display._btn_CharacterEffect						:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_TEXT_CHARACTEREFFECT") )
	frame_Display._btn_NearestPlayerOnlyEffect				:SetTextMode( UI_TM.eTextMode_LimitText )
	frame_Display._btn_NearestPlayerOnlyEffect				:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_TEXT_SELFONLY_EFFECT") )
	frame_Display._btn_SelfPlayerOnlyEffect					:SetTextMode( UI_TM.eTextMode_LimitText )
	frame_Display._btn_SelfPlayerOnlyEffect					:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_TEXT_NEARESTPLAYERONLYEFFECT") )
	frame_Display._btn_SelfPlayerOnlyLantern				:SetTextMode( UI_TM.eTextMode_LimitText )
	frame_Display._btn_SelfPlayerOnlyLantern				:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_TEXT_SELFONLY_LANTERN") )
	frame_Display._btn_UpscaleEnable						:SetTextMode( UI_TM.eTextMode_LimitText )
	frame_Display._btn_UpscaleEnable						:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_TEXT_UPSCALE") )
	frame_Display._btn_SleepModeEnable						:SetTextMode( UI_TM.eTextMode_LimitText )
	frame_Display._btn_SleepModeEnable						:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_GAME_SLEEPMODE") )
	frame_Display._btn_CropModeEnable						:SetTextMode( UI_TM.eTextMode_LimitText )
	frame_Display._btn_CropModeEnable						:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_TEXT_CROPMODE") )

	frame_Sound._btn_MusicOnOff								:SetTextMode( UI_TM.eTextMode_LimitText )
	frame_Sound._btn_MusicOnOff								:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_TXT_BGMTOGGLE") )
	frame_Sound._btn_FXOnOff								:SetTextMode( UI_TM.eTextMode_LimitText )
	frame_Sound._btn_FXOnOff								:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_TXT_EFFECTSOUNDTOGGLE") )
	frame_Sound._btn_EnvFXOnOff								:SetTextMode( UI_TM.eTextMode_LimitText )
	frame_Sound._btn_EnvFXOnOff								:SetText( PAGetString(Defines.StringSheet_RESOURCE, "OPTION_TXT_ENVSOUNDTOGGLE") )
	frame_Sound._btn_RiddingOnOff							:SetTextMode( UI_TM.eTextMode_LimitText )
	frame_Sound._btn_RiddingOnOff							:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_SOUND_BTN_SERVANT") )
	frame_Sound._btn_WhisperOnOff							:SetTextMode( UI_TM.eTextMode_LimitText )
	frame_Sound._btn_WhisperOnOff							:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_SOUND_BTN_WHISPER") )
	frame_Sound._btn_CombatAllwaysOff						:SetTextMode( UI_TM.eTextMode_LimitText )
	frame_Sound._btn_CombatAllwaysOff						:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_SOUND_BTN_COMBATTURNOFF") )
	frame_Sound._btn_CombatAllwaysOn						:SetTextMode( UI_TM.eTextMode_LimitText )
	frame_Sound._btn_CombatAllwaysOn						:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_SOUND_BTN_COMBATALLWAYS") )
	frame_Sound._btn_CombatAllwaysLowOff					:SetTextMode( UI_TM.eTextMode_LimitText )
	frame_Sound._btn_CombatAllwaysLowOff					:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_SOUND_BTN_COMBATNORMAL") )
	frame_Sound._btn_TraySoundOnOff							:SetTextMode( UI_TM.eTextMode_LimitText )
	frame_Sound._btn_TraySoundOnOff							:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_SOUND_BTN_TRAYSOUND") )
--}
	
	-- 북미/ 유럽 국가에서만 채팅 필터링을 적용한다. 변경시 협의해야합니다.
	frame_Game._btn_UseChattingFilter:SetShow( isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_NA ) )
end

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-- 국가별 언어 옵션 -- 사용하려는 언어타입 별로 true/false
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
local isOnServiceResourceTypeList = {
	[CppEnums.ServiceResourceType.eServiceResourceType_Dev]		= false,
	[CppEnums.ServiceResourceType.eServiceResourceType_KR]		= false,
	[CppEnums.ServiceResourceType.eServiceResourceType_EN]		= true,
	[CppEnums.ServiceResourceType.eServiceResourceType_JP]		= false,
	[CppEnums.ServiceResourceType.eServiceResourceType_CN]		= false,
	[CppEnums.ServiceResourceType.eServiceResourceType_RU]		= false,
	[CppEnums.ServiceResourceType.eServiceResourceType_FR]		= true,
	[CppEnums.ServiceResourceType.eServiceResourceType_DE]		= true,
	[CppEnums.ServiceResourceType.eServiceResourceType_ES]		= false,
}

local isOnServiceResourceTypeTag = {
	[CppEnums.ServiceResourceType.eServiceResourceType_Dev]		= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_DEV" ),	-- "DEV",
	[CppEnums.ServiceResourceType.eServiceResourceType_KR]		= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_KR" ),	-- "한국",
	[CppEnums.ServiceResourceType.eServiceResourceType_EN]		= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_EN" ),	-- "미국",
	[CppEnums.ServiceResourceType.eServiceResourceType_JP]		= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_JP" ),	-- "일본",
	[CppEnums.ServiceResourceType.eServiceResourceType_CN]		= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_CN" ),	-- "中國",
	[CppEnums.ServiceResourceType.eServiceResourceType_RU]		= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_RU" ),	-- "러시아",
	[CppEnums.ServiceResourceType.eServiceResourceType_FR]		= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_FR" ),	-- "프랑스",
	[CppEnums.ServiceResourceType.eServiceResourceType_DE]		= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_DE" ),	-- "독일",
	[CppEnums.ServiceResourceType.eServiceResourceType_ES]		= PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_TEXT_ES" ),	-- "스페인",
}

local _btn_ServiceResourceType = {}
local serviceResEnumsNumber = {}

local serviceResCount = 0
local _txt_LanguageOption
local _txt_ChatChannelOption

local _ServiceResComputePosY = 0

local createServiceResOption = function( frame, frameContent )
	local serviceResourceTypeControl	= UI.getChildControl ( frameContent, "RadioButton_ServiceResourceType" )
	local _frameContent		 			= UI.getChildControl ( frame, "Frame_1_Content" )
	local _txt_LanguageDesc				= UI.getChildControl ( _frameContent, "Static_LanguageCommentBG")
	local _txt_ChattingLanguageDesc		= UI.getChildControl ( _frameContent, "Static_ChattingLanguageCommentBG")
	
	local posYCount = 0
	local btn_index = 0
	local Size = CppEnums.ServiceResourceType.eServiceResourceTypeCount
		
	for index = 0, Size do
		if ( isOnServiceResourceTypeList[index] ) then
			
			_btn_ServiceResourceType[btn_index] = UI.createAndCopyBasePropertyControl( _frameContent, "RadioButton_ServiceResourceType", 
																					_frameContent, "RadioButton_ServiceResourceType_" .. btn_index )
																																									
			_btn_ServiceResourceType[btn_index]:SetPosY( serviceResourceTypeControl:GetPosY() + posYCount * 25 )
			_btn_ServiceResourceType[btn_index]:SetText( tostring(isOnServiceResourceTypeTag[index]) )
			_btn_ServiceResourceType[btn_index]:addInputEvent( "Mouse_LUp", "GameOption_ServiceResourceTypeFunc()" )

			serviceResEnumsNumber[btn_index] = index
			
			posYCount = posYCount + 1
			btn_index = btn_index + 1

			serviceResCount = serviceResCount + 1
		end
	end

	_txt_LanguageDesc:SetTextMode( UI_TM.eTextMode_AutoWrap )
	-- _txt_LanguageDesc:SetPosY( _btn_ServiceResourceType[btn_index]:GetPosY() )
	_txt_LanguageDesc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GMAEOPTION_LANGUAGESETTING_DESC") )
	_txt_LanguageDesc:SetSize( 545, _txt_LanguageDesc:GetTextSizeY()+10 )
	_txt_LanguageDesc:SetPosY( (serviceResourceTypeControl:GetPosY() + posYCount * 25) )
	_ServiceResComputePosY = (posYCount * 25) + _txt_LanguageDesc:GetSizeY()
	
	_txt_LanguageOption			= UI.getChildControl ( _frameContent_Game, "StaticText_Language")
end

local _btn_ChatLanguageType = {}
local ChatChannelEnumsNumber = {}

local createChatChannelOption = function( frame, frameContent )
	local serviceResourceTypeControl	= UI.getChildControl ( frameContent, "RadioButton_ChannelChat_Language" )
	
	local _frameContent		 			= UI.getChildControl ( frame, "Frame_1_Content" )
	local _txt_LanguageDesc				= UI.getChildControl ( _frameContent, "Static_LanguageCommentBG")
	local _txt_ChattingLanguageDesc		= UI.getChildControl ( _frameContent, "Static_ChattingLanguageCommentBG")

	local posYCount = 0
	local btn_index = 0
	local Size = CppEnums.ServiceResourceType.eServiceResourceTypeCount
		
	_btn_ChatLanguageType[0] = UI.createAndCopyBasePropertyControl( _frameContent, "RadioButton_ChannelChat_Language", 
																			_frameContent, "RadioButton_ChannelChat_Language_" .. btn_index )
		
	_btn_ChatLanguageType[0]:SetPosY( serviceResourceTypeControl:GetPosY() + (_ServiceResComputePosY-25) + posYCount * 25 )
	_btn_ChatLanguageType[0]:SetText( tostring("International") )
	_btn_ChatLanguageType[0]:addInputEvent( "Mouse_LUp", "ChatChannelOption()" )
	
	ChatChannelEnumsNumber[btn_index] = 1
			
	posYCount = posYCount + 1
	btn_index = btn_index + 1
			
	for index = 1, Size do
		if ( isOnServiceResourceTypeList[index] ) then
			
			_btn_ChatLanguageType[btn_index] = UI.createAndCopyBasePropertyControl( _frameContent, "RadioButton_ChannelChat_Language", 
																					_frameContent, "RadioButton_ChannelChat_Language_" .. btn_index )
																					
			_btn_ChatLanguageType[btn_index]:SetPosY( serviceResourceTypeControl:GetPosY() + (_ServiceResComputePosY-25) + posYCount * 25 )
			_btn_ChatLanguageType[btn_index]:SetText( tostring(isOnServiceResourceTypeTag[index]) )
			_btn_ChatLanguageType[btn_index]:addInputEvent( "Mouse_LUp", "ChatChannelOption()" )
			
			ChatChannelEnumsNumber[btn_index] = index

			posYCount = posYCount + 1
			btn_index = btn_index + 1

			--serviceResCount = serviceResCount + 1
		end
	end

	_txt_ChattingLanguageDesc	:SetTextMode( UI_TM.eTextMode_AutoWrap )
	_txt_ChattingLanguageDesc	:SetPosY( serviceResourceTypeControl:GetPosY() + (_ServiceResComputePosY-25) + posYCount * 25 )
	_txt_ChattingLanguageDesc	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GMAEOPTION_CHATTINGSETTING_DESC") )
	_txt_ChattingLanguageDesc	:SetSize( 545, _txt_ChattingLanguageDesc:GetTextSizeY()+10 )

	_txt_ChatChannelOption			= UI.getChildControl ( _frameContent, "StaticText_ChannelChat_Language")
	_txt_ChatChannelOption:SetSpanSize( 0, _txt_LanguageDesc:GetPosY() + _txt_LanguageDesc:GetSizeY() + 10 )
end

local eraseChatChannelOption = function(frameContent)
	local textChannelChat				= UI.getChildControl( frameContent, "StaticText_ChannelChat_Language" )
	local radioChannelChat				= UI.getChildControl( frameContent, "RadioButton_ChannelChat_Language" )
	local _txt_LanguageDesc				= UI.getChildControl( frameContent, "Static_LanguageCommentBG")
	local _txt_ChattingLanguageDesc		= UI.getChildControl( frameContent, "Static_ChattingLanguageCommentBG")
	UI.deleteControl(textChannelChat)
	UI.deleteControl(radioChannelChat)
	UI.deleteControl(_txt_LanguageDesc)
	UI.deleteControl(_txt_ChattingLanguageDesc)
end


-- 언어타입 관련 최초 생성 함수.
local loadLanguageResType = function()

	local serviceType = getGameServiceType()
	
	local _cpy_frame = nil
	local _cpy_frameContent = nil
	
	if isNeedGameOptionFromServer() == false then
		_cpy_frame = _frame_Language
		_cpy_frameContent = _frameContent_Language
	else
		_cpy_frame = _frame_Game
		_cpy_frameContent = _frameContent_Game
	end
	
	 _txt_LanguageOption	= UI.getChildControl( _cpy_frameContent, "StaticText_Language")
	
	if ( serviceType == CppEnums.GameServiceType.eGameServiceType_NA_ALPHA or 
		 serviceType == CppEnums.GameServiceType.eGameServiceType_NA_REAL or
		 serviceType == CppEnums.GameServiceType.eGameServiceType_DEV ) then
		 
		createServiceResOption( _cpy_frame, _cpy_frameContent )
		createChatChannelOption( _cpy_frame, _cpy_frameContent )
	else
		local serviceResourceType			= UI.getChildControl( _cpy_frameContent, "RadioButton_ServiceResourceType" )
		local _txt_LanguageDesc				= UI.getChildControl( _cpy_frameContent, "Static_LanguageCommentBG")
		local _txt_ChattingLanguageDesc		= UI.getChildControl( _cpy_frameContent, "Static_ChattingLanguageCommentBG")

		if (nil ~= serviceResourceType) then
			serviceResourceType:SetShow(false)
			UI.deleteControl(serviceResourceType)
		end

		-- 언어설정 static text 삭제.
		if ( nil ~= _txt_LanguageOption ) then
			_txt_LanguageOption:SetShow(false)		
			UI.deleteControl(_txt_LanguageOption)
			_txt_LanguageOption = nil
		end
		if ( nil ~= _txt_LanguageDesc ) then
			_txt_LanguageDesc:SetShow(false)		
			UI.deleteControl(_txt_LanguageDesc)
			_txt_LanguageDesc = nil
		end
		if ( nil ~= _txt_ChattingLanguageDesc ) then
			_txt_ChattingLanguageDesc:SetShow(false)		
			UI.deleteControl(_txt_ChattingLanguageDesc)
			_txt_ChattingLanguageDesc = nil
		end
		
		eraseChatChannelOption(_cpy_frameContent)
		_frameContent_Game:SetSize(_frameContent_Game:GetSizeX(), 1)
	end
	
	_frame_Game:UpdateContentPos()
	_frame_Game:UpdateContentScroll()
end

loadLanguageResType()


---------------------------------------------------------------------- end 국가별 언어 옵션
-------------------------------------------------------------------------------------------



----------------------------------------------------------------------------------------------------------------
-- 											슬라이드 사이즈 조정용
----------------------------------------------------------------------------------------------------------------
function getFrameSize_SetSlideSize()
	-- 화면 설정 슬라이드
	if ( gamePanel_Main._btn_Display:IsCheck() ) then
		_display_sld:SetShow(false)
		if ( _display_SizeY >= 600 ) then
			_display_sld:SetShow(true)
			_display_sld_btn:SetShow(true)

			-- local _display_sld_btnSize = _frame_Display:GetSizeY() - ( _display_SizeY - _frame_Display:GetSizeY() )
			-- _display_sld_btn:SetSize ( _display_sld_btn:GetSizeX(), _display_sld_btnSize  )
		end

	elseif( gamePanel_Main._btn_Sound:IsCheck() )then
		_sound_sld:SetShow(false)
		if ( _sound_SizeY >= 600 ) then
			_sound_sld:SetShow(true)
			_sound_sld_btn:SetShow(true)

			local _sound_sld_btnSize = _frame_Sound:GetSizeY() - ( _sound_SizeY - _frame_Sound:GetSizeY() )
			-- _sound_sld_btn:SetSize ( _sound_sld_btn:GetSizeX(), _sound_sld_btnSize  )
		end
	elseif ( gamePanel_Main._btn_Game:IsCheck() ) then
		_game_sld:SetShow(false)
		if ( _game_SizeY >= 600 ) then
			_game_sld:SetShow(true)
			_game_sld_btn:SetShow(true)

			local _game_sld_btnSize = _frame_Game:GetSizeY() - ( _game_SizeY - _frame_Game:GetSizeY() )
			-- _game_sld_btn:SetSize ( _game_sld_btn:GetSizeX(), _game_sld_btnSize  )
		end
	elseif ( gamePanel_Main._btn_KeyConfig:IsCheck() ) then
		_keyConfig_sld:SetShow(false)
		if ( _keyConfig_SizeY >= 600 ) then
			_keyConfig_sld:SetShow(true)
			_keyConfig_sld_btn:SetShow(true)

			local _keyConfig_sld_btnSize = _frame_KeyConfig:GetSizeY() - ( _keyConfig_SizeY - _frame_KeyConfig:GetSizeY() )
			-- _keyConfig_sld_btn:SetSize ( _keyConfig_sld_btn:GetSizeX(), _keyConfig_sld_btnSize  )
		end
	elseif ( gamePanel_Main._btn_KeyConfig_UI:IsCheck() ) then
		_keyConfigUI_sld:SetShow(false)
		if ( _keyConfig_UI_SizeY >= 600 ) then
			_keyConfigUI_sld:SetShow(true)
			_keyConfigUI_sld_btn:SetShow(true)

			local _keyConfigUI_sld_btnSize = _frame_KeyConfig_UI:GetSizeY() - ( _keyConfig_UI_SizeY - _frame_KeyConfig_UI:GetSizeY() )
			-- _keyConfigUI_sld_btn:SetSize ( _keyConfigUI_sld_btn:GetSizeX(), _keyConfigUI_sld_btnSize  )
		end
	elseif ( gamePanel_Main._btn_Language:IsCheck() ) then
		_Language_sld:SetShow(false)
		if ( _Language_SizeY >= 600 ) then
			_Language_sld:SetShow(true)
			_Language_sld:SetShow(true)

			local _Language_sld_btnSize = _frame_Language:GetSizeY() - ( _Language_SizeY - _frame_Language:GetSizeY() )
			-- _keyConfigUI_sld_btn:SetSize ( _keyConfigUI_sld_btn:GetSizeX(), _keyConfigUI_sld_btnSize  )
		end
	end
end

function HideAllFrame_Func()
	_frame_Display:SetShow(false)
	_frame_Sound:SetShow(false)
	_frame_Game:SetShow(false)
	_frame_KeyConfig:SetShow(false)
	_frame_KeyConfig_UI:SetShow(false)
	_frame_Language:SetShow(false)

	_static_KeySetBG:SetShow(false)
	_static_PadSetBG:SetShow(false)
	_static_ResetKeyConfig:SetShow(false)
	_static_KeySetTitle:SetShow(false)
	_static_KeySetBG_UI:SetShow(false)
	_static_PadSetBG_UI:SetShow(false)
	_static_ResetKeyConfig_UI:SetShow(false)
	_static_ResetPositionConfig_UI:SetShow(false)
	_static_KeySetTitle_UI:SetShow(false)
end

function optionCommentary()
	if ( gamePanel_Main._btn_Display:IsCheck() ) then
		gamePanel_Main._txt_Comment:SetTextMode( UI_TM.eTextMode_AutoWrap )
		gamePanel_Main._txt_Comment:SetText(GetStr_Option[0])
		gamePanel_Main._txt_Comment:SetSize(gamePanel_Main._txt_Comment:GetSizeX(), gamePanel_Main._txt_Comment:GetSizeY() )

	elseif ( gamePanel_Main._btn_Sound:IsCheck() ) then
		gamePanel_Main._txt_Comment:SetTextMode( UI_TM.eTextMode_AutoWrap )
		gamePanel_Main._txt_Comment:SetText(GetStr_Option[1])
		gamePanel_Main._txt_Comment:SetSize(gamePanel_Main._txt_Comment:GetSizeX(), gamePanel_Main._txt_Comment:GetSizeY() )

	elseif ( gamePanel_Main._btn_Game:IsCheck() ) then
		gamePanel_Main._txt_Comment:SetTextMode( UI_TM.eTextMode_AutoWrap )
		gamePanel_Main._txt_Comment:SetText(GetStr_Option[2])
		gamePanel_Main._txt_Comment:SetSize(gamePanel_Main._txt_Comment:GetSizeX(), gamePanel_Main._txt_Comment:GetSizeY() )

	elseif ( gamePanel_Main._btn_KeyConfig:IsCheck() ) then
		_static_KeySetBG:SetShow(true)
		_static_PadSetBG:SetShow(true)
		_static_ResetKeyConfig:SetShow(true)
		_static_KeySetTitle:SetShow(true)
		gamePanel_Main._txt_Comment:SetTextMode( UI_TM.eTextMode_AutoWrap )
		gamePanel_Main._txt_Comment:SetText(GetStr_Option[3])
		gamePanel_Main._txt_Comment:SetSize(gamePanel_Main._txt_Comment:GetSizeX(), gamePanel_Main._txt_Comment:GetSizeY() )

	elseif ( gamePanel_Main._btn_KeyConfig_UI:IsCheck() ) then
		_static_KeySetBG_UI:SetShow(true)
		_static_PadSetBG_UI:SetShow(true)
		_static_ResetKeyConfig_UI:SetShow(true)
		_static_ResetPositionConfig_UI:SetShow(false)	-- 나중에 한다.

		_static_KeySetTitle_UI:SetShow(true)
		gamePanel_Main._txt_Comment:SetTextMode( UI_TM.eTextMode_AutoWrap )
		gamePanel_Main._txt_Comment:SetText(GetStr_Option[16])
		gamePanel_Main._txt_Comment:SetSize(gamePanel_Main._txt_Comment:GetSizeX(), gamePanel_Main._txt_Comment:GetSizeY() )

	elseif ( gamePanel_Main._btn_Language:IsCheck() ) then
		gamePanel_Main._txt_Comment:SetTextMode( UI_TM.eTextMode_AutoWrap )
		gamePanel_Main._txt_Comment:SetText(GetStr_Option[26])
		gamePanel_Main._txt_Comment:SetSize(gamePanel_Main._txt_Comment:GetSizeX(), gamePanel_Main._txt_Comment:GetSizeY() )		
	
	end
end

----------------------------------------------------------------------------------------------------------------
--								CHECKBOX 의 ENABLE AREA 사이즈 조절해주는 함수
----------------------------------------------------------------------------------------------------------------
function gameOption_SetEnableArea_Func()
	local updateList = {}
	if ( _frame_Display:GetShow() == true ) then
		updateList = {
			-- frame_Display._btn_ScreenMode[0]			,
			-- frame_Display._btn_ScreenMode[1]			,
			-- frame_Display._btn_ScreenMode[2]			,

			-- frame_Display._btn_DOF						,
			-- frame_Display._btn_AntiAlli					,
			-- frame_Display._btn_Ultra					,
			-- frame_Display._btn_LensBlood				,
			-- frame_Display._btn_BloodEffect				,

			-- frame_Display._btn_SSAO						,
			-- frame_Display._btn_Tessellation				,
			-- frame_Display._btn_PostFilter				,
			-- frame_Display._btn_CharacterEffect			,

			-- frame_Display._btn_SelfPlayerOnlyEffect		,
			-- frame_Display._btn_NearestPlayerOnlyEffect		,
			-- frame_Display._btn_SelfPlayerOnlyLantern	,
			-- frame_Display._btn_UpscaleEnable			,
			-- frame_Display._btn_SleepModeEnable			,
			-- frame_Display._btn_CropModeEnable			,
		}

	elseif ( _frame_Sound:GetShow() == true ) then
		updateList = {
			-- frame_Sound._btn_MusicOnOff,
			-- frame_Sound._btn_FXOnOff,
			-- frame_Sound._btn_EnvFXOnOff,
			-- frame_Sound._btn_HitFxTypeOnOff,
			-- frame_Sound._btn_RiddingOnOff,
			-- frame_Sound._btn_CombatAllwaysOn,
			-- frame_Sound._btn_CombatAllwaysOff,
			-- frame_Sound._btn_CombatAllwaysLowOff,
		}
	elseif ( _frame_Game:GetShow() == true ) then
		updateList = {
			-- frame_Game._btn_ShowTag					,
			-- frame_Game._btn_AutoAim					,
			-- frame_Game._btn_GuildLogin				,
			-- frame_Game._btn_RejectInvitation		,
			-- frame_Game._btn_HideWindow				,
			-- frame_Game._btn_EnableSimpleUI			,
			-- frame_Game._btn_SpiritGuide				,
			-- frame_Game._btn_EnableOVR				,
			-- frame_Game._btn_MouseX					,
			-- frame_Game._btn_MouseY					,
			-- frame_Game._btn_UsePad					,
			-- frame_Game._btn_SelfNameShow			,
			-- frame_Game._btn_SelfNameShowAllways		,
			-- frame_Game._btn_SelfNameShowImportant	,
			-- frame_Game._btn_SelfNameShowNoShow		,
			-- frame_Game._btn_OtherNameShow			,
			-- frame_Game._btn_PartyNameShow			,
			-- frame_Game._btn_GuildNameShow			,
			-- frame_Game._btn_GuideLineHumanRelation	,
			-- frame_Game._btn_GuideLineQuestObject	,
			-- frame_Game._btn_GuideLineZoneChange		,
			-- frame_Game._btn_GuideLineWarAlly		,
			-- frame_Game._btn_GuideLineGuild			,
			-- frame_Game._btn_GuideLineParty			,
			-- frame_Game._btn_GuideLineEnemy			,
			-- frame_Game._btn_GuideLineNonWarPlayer	,
			-- frame_Game._btn_UseVibe					,
			-- frame_Game._btn_PadX					,
			-- frame_Game._btn_PadY					,
			-- frame_Game._btn_Alert_Region			,
			-- frame_Game._btn_Alert_TerritoryTrade	,
			-- frame_Game._btn_Alert_RoyalTrade		,
			-- frame_Game._btn_Alert_Fitness			,
			-- frame_Game._btn_Alert_TerritoryWar		,
			-- frame_Game._btn_Alert_GuildWar			,
			-- frame_Game._btn_Alert_PlayerGotItem		,
			-- frame_Game._btn_Alert_ItemMarket		,
			-- frame_Game._btn_Alert_LifeLevUp			,
			-- frame_Game._btn_Alert_GuildQuest		,
			-- frame_Game._btn_MouseMove				,
			-- frame_Game._btn_MiniMapRotation			,
			-- frame_Game._btn_PetAll					,
			-- frame_Game._btn_PetMine					,
			-- frame_Game._btn_PetHide					,
			-- frame_Game._btn_NavGuideNone			,
			-- frame_Game._btn_NavGuideArrow			,
			-- frame_Game._btn_NavGuideEffect			,
			-- frame_Game._btn_NavGuideFairy			,
			-- frame_Game._btn_ShowAttackEffect		,
			-- frame_Game._btn_Alert_BlackSpirit		,
			-- frame_Game._btn_UseNewQuickSlot			,
			-- frame_Game._btn_UseChattingFilter		,	
			-- frame_Game._btn_IsOnScreenSaver			,	

}
	end

	for key, value in pairs(updateList) do
		value:SetEnableArea ( 0, 0, value:GetSizeX() + value:GetTextSizeX() + 5, value:GetSizeY() )
	end
end


function ShowFrame_Func()
	--♬ 라디오 버튼이 바뀔 때 마다 사운드 추가
	audioPostEvent_SystemUi(00,00)

	getFrameSize_SetSlideSize()
	if ( gamePanel_Main._btn_Display:IsCheck() ) then													-- 화면 설정
		HideAllFrame_Func()
		_frame_Display:SetShow(true)

		isKeyConfig_Open = false
		isKeyConfig_UI_Open = false

		gameOption_SetEnableArea_Func()
		optionCommentary()
		
	elseif ( gamePanel_Main._btn_Sound:IsCheck() ) then													-- 소리 설정
		HideAllFrame_Func()
		_frame_Sound:SetShow(true)

		isKeyConfig_Open = false
		isKeyConfig_UI_Open = false

		gameOption_SetEnableArea_Func()
		optionCommentary()

	elseif ( gamePanel_Main._btn_Game:IsCheck() ) then													-- 게임 설정
		HideAllFrame_Func()
		_frame_Game:SetShow(true)

		isKeyConfig_Open = false
		isKeyConfig_UI_Open = false

		gameOption_SetEnableArea_Func()
		optionCommentary()

	elseif ( gamePanel_Main._btn_KeyConfig:IsCheck() ) and ( isKeyConfig_Open == false ) then			-- 액션 키 커스텀
		HideAllFrame_Func()
		_frame_KeyConfig:SetShow(true)
		isKeyConfig_Open = true
		isKeyConfig_UI_Open = false

		Option_Init_KeyConfig()
		KeyCustom_Action_UpdateButtonText_Key()
		KeyCustom_Action_UpdateButtonText_Pad()
		configDataIndex = 0
		updateKeyConfig()

		gameOption_SetEnableArea_Func()
		optionCommentary()

	elseif ( gamePanel_Main._btn_KeyConfig_UI:IsCheck() ) and ( isKeyConfig_UI_Open == false ) then		-- UI 단축키 커스텀
		HideAllFrame_Func()
		_frame_KeyConfig_UI:SetShow(true)

		isKeyConfig_Open = false
		isKeyConfig_UI_Open = true

		Option_Init_KeyConfig_UI()
		KeyCustom_Ui_UpdateButtonText_Key()
		KeyCustom_Ui_UpdateButtonText_Pad()
		configDataIndex_UI = 0
		updateKeyConfig_UI()

		gameOption_SetEnableArea_Func()
		optionCommentary()
		
	elseif ( gamePanel_Main._btn_Language:IsCheck() ) and ( isKeyConfig_UI_Open == false ) then		-- UI 단축키 커스텀
		HideAllFrame_Func()
		_frame_Language:SetShow(true)

		isKeyConfig_Open = false
		isKeyConfig_UI_Open = true

		Option_Init_KeyConfig_UI()
		KeyCustom_Ui_UpdateButtonText_Key()
		KeyCustom_Ui_UpdateButtonText_Pad()
		configDataIndex_UI = 0
		updateKeyConfig_UI()

		gameOption_SetEnableArea_Func()
		optionCommentary()
	end
end

function FGlobal_GameOptionOpen()
	if not Panel_Window_Option:GetShow() then
		showGameOption()
	end

	gamePanel_Main._btn_Display:SetCheck( false )
	gamePanel_Main._btn_Sound:SetCheck( false )
	gamePanel_Main._btn_Game:SetCheck( true )
	gamePanel_Main._btn_KeyConfig:SetCheck( false )
	gamePanel_Main._btn_KeyConfig_UI:SetCheck( false )
	ShowFrame_Func()
	_game_sld:SetControlBottom()
	_frame_Game:UpdateContentScroll()
	_frame_Game:UpdateContentPos()
end

function Option_ShowAni()
	UIAni.fadeInSCR_Down( Panel_Window_Option )
	_frame_Display:SetShow(true)
	
	local aniInfo1 = Panel_Window_Option:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.15)
	aniInfo1.AxisX = Panel_Window_Option:GetSizeX() / 2
	aniInfo1.AxisY = Panel_Window_Option:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_Window_Option:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.15)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_Window_Option:GetSizeX() / 2
	aniInfo2.AxisY = Panel_Window_Option:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
	
	_display_sld:SetControlPos( 0 )
	_sound_sld:SetControlPos( 0 )
	_game_sld:SetControlPos( 0 )
	_keyConfig_sld:SetControlPos( 0 )
	_keyConfigUI_sld:SetControlPos( 0 )
	_frame_Display:UpdateContentPos()
	_frame_Display:UpdateContentScroll()
	_frame_Game:UpdateContentScroll()
	_frame_Game:UpdateContentPos()
end

function Option_HideAni()
	Panel_Window_Option:SetAlpha( 1 )
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_Window_Option, 0.0, 0.1 )
	aniInfo:SetHideAtEnd(true)
end

function Option_Hide()
	SetUIMode( Defines.UIMode.eUIMode_Default )
	UI.Set_ProcessorInputMode( CppEnums.EProcessorInputMode.eProcessorInputMode_UiMode )
	Panel_Window_Option:SetShow(false, true)
	TooltipSimple_Hide()
end

------------------------------------ Update ---------------------------------------------
function Option_Update()
	GameOption_RefreshFPSText()
end

------------------------------------ 이벤트 등록 ( Client -> Lua ) ---------------------------------------------
function Option_RegistMessageHandler()
	registerEvent("EventGameOptionToggle", 					"GameOption_TogglePanel")
	registerEvent("EventGameOptionInitGameOption", 			"GameOption_InitGameOption")
	registerEvent("EventGameOptionInitDisplayModeList", 	"GameOption_InitDisplayModeList")
	registerEvent("EventGameOptionDefault", 				"GameOption_DefaultOption")
end

-- 버튼 이벤트 등록
function Option_RegistEventHandler()
	--------------------------------------------------------------------------------------------------------------------------------------------------
	gamePanel_Main._btn_Close:addInputEvent( "Mouse_LUp", "Option_Hide()" )
	gamePanel_Main._buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"UIGameOption\" )" )		--물음표 좌클릭
	gamePanel_Main._buttonQuestion:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"UIGameOption\", \"true\")" )		--물음표 마우스오버
	gamePanel_Main._buttonQuestion:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"UIGameOption\", \"false\")" )		--물음표 마우스아웃
	gamePanel_Main._btn_Apply:addInputEvent( "Mouse_LUp", "GameOption_Apply()" )
	gamePanel_Main._btn_Confirm:addInputEvent( "Mouse_LUp", "GameOption_Confirm()" )
	gamePanel_Main._btn_Cancel:addInputEvent( "Mouse_LUp", "GameOption_Cancel()" )

	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- 화면 설정용 버튼 이벤트
	frame_Display._btn_ScreenMode[chk_Option.FULL_SCREEN_IDX]:addInputEvent( "Mouse_LUp", "GameOption_CheckFullScreen()" )
	frame_Display._btn_ScreenMode[chk_Option.FULL_SCREEN_WINDOWED_IDX]:addInputEvent( "Mouse_LUp", "GameOption_CheckFullScreenWindowed()" )
	frame_Display._btn_ScreenMode[chk_Option.WINDOWED_IDX]:addInputEvent( "Mouse_LUp", "GameOption_CheckWindowed()" )

	frame_Display._btn_ScreenShotFormat[chk_Option.SCREENSHOT_BMP]:addInputEvent( "Mouse_LUp", "GameOption_CheckScreenShotBMP()" )
	frame_Display._btn_ScreenShotFormat[chk_Option.SCREENSHOT_JPG]:addInputEvent( "Mouse_LUp", "GameOption_CheckScreenShotJPG()" )
	frame_Display._btn_ScreenShotFormat[chk_Option.SCREENSHOT_PNG]:addInputEvent( "Mouse_LUp", "GameOption_CheckScreenShotPNG()" )

	frame_Display._btn_ColorBlind[chk_Option.COLORBLIND_NONE]		:addInputEvent( "Mouse_LUp", "GameOption_CheckColorBlindNONE()" )
	frame_Display._btn_ColorBlind[chk_Option.COLORBLIND_PROTANOPIA]	:addInputEvent( "Mouse_LUp", "GameOption_CheckColorBlindPROTANOPIA()" )
	frame_Display._btn_ColorBlind[chk_Option.COLORBLIND_DEUTERANOP]	:addInputEvent( "Mouse_LUp", "GameOption_CheckColorBlindEDUTERANOP()" )

	frame_Display._btn_SelfPlayerOnlyEffect:addInputEvent( "Mouse_LUp", "GameOption_CheckSelfPlayerOnlyEffect()" )
	frame_Display._btn_NearestPlayerOnlyEffect:addInputEvent( "Mouse_LUp", "GameOption_CheckNearestPlayerOnlyEffect()" )
	frame_Display._btn_SelfPlayerOnlyLantern:addInputEvent( "Mouse_LUp", "GameOption_CheckSelfPlayerOnlyLantern()" )
	
	frame_Display._btn_UpscaleEnable:addInputEvent( "Mouse_LUp", "GameOption_CheckUpscale()" )
	frame_Display._btn_SleepModeEnable:addInputEvent( "Mouse_LUp", "GameOption_CheckSleepMode()" )
	frame_Display._btn_CropModeEnable:addInputEvent( "Mouse_LUp", "GameOption_CheckCropMode()" )
	frame_Display._slide_CropModeScaleX:addInputEvent( "Mouse_LUp", "GameOption_CropModeScaleX_slider()" )
	frame_Display._slide_CropModeScaleY:addInputEvent( "Mouse_LUp", "GameOption_CropModeScaleY_slider()" )
	_btn_CropModeScaleX:addInputEvent( "Mouse_LUp", "GameOption_CropModeScaleX_button()" )
	_btn_CropModeScaleY:addInputEvent( "Mouse_LUp", "GameOption_CropModeScaleY_button()" )
	
	frame_Display._btn_ScrSize:addInputEvent( "Mouse_LUp", "GameOption_ScreenResolutionIncrease()" )
	frame_Display._btn_ScrSize_L:addInputEvent( "Mouse_LUp", "GameOption_ScreenResolutionDecrease()" )
	frame_Display._btn_ScrSize_R:addInputEvent( "Mouse_LUp", "GameOption_ScreenResolutionIncrease()" )

	frame_Display._btn_LUT:addInputEvent( "Mouse_LUp", "GameOption_LUTIncrease()" )
	frame_Display._btn_LUT_L:addInputEvent( "Mouse_LUp", "GameOption_LUTDecrease()" )
	frame_Display._btn_LUT_R:addInputEvent( "Mouse_LUp", "GameOption_LUTIncrease()" )
	frame_Display._btn_LUT_Reset:addInputEvent( "Mouse_LUp", "GameOption_SetRecommandationLUT()" )
	
	frame_Display._slide_CameraMaster:addInputEvent( "Mouse_LPress",  "GameOption_CameraMasterPower_slider()" )
	frame_Display._slide_CameraShake:addInputEvent( "Mouse_LPress",  "GameOption_CameraShakePower_slider()" )
	frame_Display._slide_MotionBlur:addInputEvent( "Mouse_LPress",  "GameOption_MotionBlurPower_slider()" )
	frame_Display._slide_CameraPos:addInputEvent( "Mouse_LPress",  "GameOption_CameraPosPower_slider()" )
	frame_Display._slide_CameraFov:addInputEvent( "Mouse_LPress",  "GameOption_CameraFovPower_slider()" )

	frame_Display._btn_Trxt:addInputEvent( "Mouse_LUp", "GameOption_TextureQualityIncrease()" )
	frame_Display._btn_Trxt_L:addInputEvent( "Mouse_LUp", "GameOption_TextureQualityDecrease()" )
	frame_Display._btn_Trxt_R:addInputEvent( "Mouse_LUp", "GameOption_TextureQualityIncrease()" )

	frame_Display._btn_Rndr:addInputEvent( "Mouse_LUp", "GameOption_GraphicOptionIncrease()" )
	frame_Display._btn_Rndr_L:addInputEvent( "Mouse_LUp", "GameOption_GraphicOptionDecrease()" )
	frame_Display._btn_Rndr_R:addInputEvent( "Mouse_LUp", "GameOption_GraphicOptionIncrease()" )

	frame_Display._btn_DOF			:addInputEvent( "Mouse_LUp", "GameOption_CheckDof()" )
	frame_Display._btn_AntiAlli		:addInputEvent( "Mouse_LUp", "GameOption_CheckAA()" )
	frame_Display._btn_Ultra		:addInputEvent( "Mouse_LUp", "GameOption_CheckUltra()" )
	frame_Display._btn_LensBlood	:addInputEvent( "Mouse_LUp", "GameOption_CheckLensBlood()" )
	frame_Display._btn_BloodEffect	:addInputEvent( "Mouse_LUp", "GameOption_CheckBloodEffect()" )
	
	frame_Display._btn_SSAO				:addInputEvent( "Mouse_LUp", "GameOption_CheckSSAO()" )
	frame_Display._btn_Tessellation		:addInputEvent( "Mouse_LUp", "GameOption_CheckTessellation()" )
	frame_Display._btn_PostFilter		:addInputEvent( "Mouse_LUp", "GameOption_CheckPostFilter()" )
	frame_Display._btn_CharacterEffect	:addInputEvent( "Mouse_LUp", "GameOption_CheckCharacterEffect()" )
	
	-- frame_Display._btn_DOF				:addInputEvent( "Mouse_On", "GameOption_Display_Tooltip( true, \"DOF\")" )
	-- frame_Display._btn_LensBlood		:addInputEvent( "Mouse_On", "GameOption_Display_Tooltip( true, \"Lens\")" )
	-- frame_Display._btn_AntiAlli			:addInputEvent( "Mouse_On", "GameOption_Display_Tooltip( true, \"Anti\")" )
	-- frame_Display._btn_Ultra			:addInputEvent( "Mouse_On", "GameOption_Display_Tooltip( true, \"Ultra\")" )
	-- frame_Display._btn_BloodEffect		:addInputEvent( "Mouse_On", "GameOption_Display_Tooltip( true, \"Blood\")" )
	-- frame_Display._btn_SSAO				:addInputEvent( "Mouse_On", "GameOption_Display_Tooltip( true, \"SSAO\")" )
	-- frame_Display._btn_Tessellation		:addInputEvent( "Mouse_On", "GameOption_Display_Tooltip( true, \"Tessellation\")" )
	-- frame_Display._btn_PostFilter		:addInputEvent( "Mouse_On", "GameOption_Display_Tooltip( true, \"PostFilter\")" )
	-- frame_Display._btn_CharacterEffect	:addInputEvent( "Mouse_On", "GameOption_Display_Tooltip( true, \"CharacterEffect\")" )
	-- frame_Display._btn_UpscaleEnable	:addInputEvent( "Mouse_On", "GameOption_Display_Tooltip( true, \"Upscale\")" )
	-- frame_Display._btn_SleepModeEnable	:addInputEvent( "Mouse_On", "GameOption_Display_Tooltip( true, \"SleepMode\")" )
	
	-- frame_Display._btn_DOF				:addInputEvent( "Mouse_Out", "GameOption_Display_Tooltip()" )
	-- frame_Display._btn_AntiAlli			:addInputEvent( "Mouse_Out", "GameOption_Display_Tooltip()" )
	-- frame_Display._btn_Ultra			:addInputEvent( "Mouse_Out", "GameOption_Display_Tooltip()" )
	-- frame_Display._btn_LensBlood		:addInputEvent( "Mouse_Out", "GameOption_Display_Tooltip()" )
	-- frame_Display._btn_BloodEffect		:addInputEvent( "Mouse_Out", "GameOption_Display_Tooltip()" )
	-- frame_Display._btn_SSAO				:addInputEvent( "Mouse_Out", "GameOption_Display_Tooltip()" )
	-- frame_Display._btn_Tessellation		:addInputEvent( "Mouse_Out", "GameOption_Display_Tooltip()" )
	-- frame_Display._btn_PostFilter		:addInputEvent( "Mouse_Out", "GameOption_Display_Tooltip()" )
	-- frame_Display._btn_CharacterEffect	:addInputEvent( "Mouse_Out", "GameOption_Display_Tooltip()" )
	-- frame_Display._btn_UpscaleEnable	:addInputEvent( "Mouse_Out", "GameOption_Display_Tooltip()" )
	-- frame_Display._btn_SleepModeEnable	:addInputEvent( "Mouse_Out", "GameOption_Display_Tooltip()" )

	frame_Display._slide_Gamma:addInputEvent( "Mouse_LPress", "GameOption_ChangeGamma_slider()" )
	frame_Display._slide_Contrast:addInputEvent( "Mouse_LPress", "GameOption_ChangeContrast_slider()" )	
	frame_Display._slide_UIScale:addInputEvent( "Mouse_LPress",	 "GameOption_UIScale_Change()" )
	frame_Display._slide_Fov:addInputEvent( "Mouse_LPress", "GameOption_ChangeFov_slider()" )	
	
	_btn_Gamma:addInputEvent( "Mouse_LPress", "GameOption_ChangeGamma_button()" )
	_btn_Contrast:addInputEvent( "Mouse_LPress", "GameOption_ChangeContrast_button()" )
	_btn_UIScale:addInputEvent( "Mouse_LPress",  "GameOption_UIScale_Change()" )
	_btn_Fov:addInputEvent("Mouse_LPress", "GameOption_ChangeFov_button()")
	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- 소리 설정용 버튼 이벤트
	frame_Sound._btn_MusicOnOff				:addInputEvent( "Mouse_LUp",  "GameOption_CheckMusic()" )
	frame_Sound._btn_FXOnOff				:addInputEvent( "Mouse_LUp",  "GameOption_CheckSound()" )
	frame_Sound._btn_EnvFXOnOff				:addInputEvent( "Mouse_LUp",  "GameOption_CheckEnvSound()" )

	frame_Sound._btn_RiddingOnOff			:addInputEvent( "Mouse_LUp",  "GameOption_CheckRiddingMusic()" )
	frame_Sound._btn_WhisperOnOff			:addInputEvent( "Mouse_LUp",  "GameOption_CheckWhisperMusic()" )
	frame_Sound._btn_TraySoundOnOff			:addInputEvent( "Mouse_LUp",  "GameOption_CheckTraySound()" )

	frame_Sound._btn_CombatAllwaysOff		:addInputEvent( "Mouse_LUp",	"GameOption_CheckCombatSound()")
	frame_Sound._btn_CombatAllwaysOn		:addInputEvent( "Mouse_LUp",	"GameOption_CheckCombatSound()")
	frame_Sound._btn_CombatAllwaysLowOff	:addInputEvent( "Mouse_LUp",	"GameOption_CheckCombatSound()")

	--frame_Sound._btn_HitFxTypeOnOff:addInputEvent( "Mouse_LUp",  "GameOption_CheckHitFxType()" )
	
	frame_Sound._slide_TotalVol				:addInputEvent( "Mouse_LPress", "GameOption_Master_slider()" )
	frame_Sound._slide_MusicVol				:addInputEvent( "Mouse_LPress", "GameOption_Music_slider()" )
	frame_Sound._slide_FxVol				:addInputEvent( "Mouse_LPress", "GameOption_FxSound_slider()" )
	frame_Sound._slide_EnvFxVol				:addInputEvent( "Mouse_LPress", "GameOption_EnvSound_slider()" )
	frame_Sound._slide_VoiceVol				:addInputEvent( "Mouse_LPress", "GameOption_DlgSound_slider()" )
	frame_Sound._slide_hitFxWeightVolume	:addInputEvent( "Mouse_LPress", "GameOption_HitFxWeight_slider()" )
	frame_Sound._slide_otherPlayerVolume	:addInputEvent( "Mouse_LPress", "GameOption_OtherPlayer_slider()" )

	_btn_TotalVol							:addInputEvent( "Mouse_LPress", "GameOption_Master_button()" )
	_btn_MusicVol							:addInputEvent( "Mouse_LPress", "GameOption_Music_button()" )
	_btn_FxVol								:addInputEvent( "Mouse_LPress", "GameOption_FxSound_button()" )
	_btn_EnvFxVol							:addInputEvent( "Mouse_LPress", "GameOption_EnvSound_button()" )
	_btn_VoiceVol							:addInputEvent( "Mouse_LPress", "GameOption_DlgSound_button()" )
	_btn_hitFxWeightVolume					:addInputEvent( "Mouse_LPress", "GameOption_HitFxWeight_button()" )
	_btn_otherPlayerVolume					:addInputEvent( "Mouse_LPress", "GameOption_OtherPlayer_button()" )

	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- 게임 설정용 버튼 이벤트
	frame_Game._btn_ShowTag:addInputEvent( "Mouse_LUp",  "GameOption_CheckNameTag()" )
	
	frame_Game._btn_AutoAim:addInputEvent( "Mouse_LUp",  "GameOption_AutoAim()" )
	--frame_Game._btn_BottomMenu:addInputEvent( "Mouse_LUp",  "Panel_UIMain_MainFunc()" )
	frame_Game._btn_GuildLogin:addInputEvent( "Mouse_LUp",	"Panel_GuildLogin_MainFunc()")
	frame_Game._btn_RejectInvitation:addInputEvent( "Mouse_LUp",  "Panel_RejectInvitation_MainFunc()" )
	frame_Game._btn_HideWindow:addInputEvent( "Mouse_LUp",  "GameOption_CheckHideWindow()" )
	frame_Game._btn_EnableSimpleUI:addInputEvent( "Mouse_LUp",  "GameOption_CheckSimpleUI()" )
	frame_Game._btn_MouseMove:addInputEvent("Mouse_LUp", "GameOption_CheckMouseMove()")
	frame_Game._btn_MiniMapRotation:addInputEvent("Mouse_LUp", "GameOption_CheckMiniMapRotation()")
	frame_Game._btn_ShowAttackEffect:addInputEvent("Mouse_LUp", "GameOption_CheckShowAttackEffect()")
	frame_Game._btn_Alert_BlackSpirit:addInputEvent("Mouse_LUp", "GameOption_CheckBlackSpiritAlert()" )
	frame_Game._btn_UseNewQuickSlot:addInputEvent("Mouse_LUp", "GameOption_CheckUseNewQuickSlot()" )
	frame_Game._btn_UseChattingFilter:addInputEvent("Mouse_LUp", "GameOption_CheckUseChattingFilter()" )
	frame_Game._btn_IsOnScreenSaver:addInputEvent("Mouse_LUp", "GameOption_CheckIsOnScreenSaver()" )
	frame_Game._btn_EnableOVR:addInputEvent( "Mouse_LUp",  "GameOption_CheckEnableOVR()" )
	frame_Game._btn_UIModeMouseLock:addInputEvent("Mouse_LUp", "GameOption_CheckUIModeMouseLock()" )
	frame_Game._btn_PvpRefuse:addInputEvent("Mouse_LUp", "GameOption_CheckPvpRefuse()" )

	frame_Game._btn_MouseX:addInputEvent( "Mouse_LUp",  "GameOption_CheckMouseInvertX()" )
	frame_Game._btn_MouseY:addInputEvent( "Mouse_LUp",  "GameOption_CheckMouseInvertY()" )
	frame_Game._slide_MouXSen:addInputEvent( "Mouse_LPress",  "GameOption_MouseSensitivityX_slider()" )
	frame_Game._slide_MouYSen:addInputEvent( "Mouse_LPress",  "GameOption_MouseSensitivityY_slider()" )

	frame_Game._btn_UsePad:addInputEvent( "Mouse_LUp",  "GameOption_CheckPadEnable()" )
	frame_Game._btn_UseVibe:addInputEvent( "Mouse_LUp",  "GameOption_CheckPadVibration()" )
	frame_Game._btn_PadX:addInputEvent( "Mouse_LUp",  "GameOption_CheckPadInvertX()" )
	frame_Game._btn_PadY:addInputEvent( "Mouse_LUp",  "GameOption_CheckPadInvertY()" )

	frame_Game._btn_Alert_Region:addInputEvent( "Mouse_LUp", "GameOption_CheckAlertMSG(0)" )
	frame_Game._btn_Alert_TerritoryTrade:addInputEvent( "Mouse_LUp", "GameOption_CheckAlertMSG(1)" )
	frame_Game._btn_Alert_RoyalTrade:addInputEvent( "Mouse_LUp", "GameOption_CheckAlertMSG(2)" )
	frame_Game._btn_Alert_Fitness:addInputEvent( "Mouse_LUp", "GameOption_CheckAlertMSG(3)" )
	frame_Game._btn_Alert_TerritoryWar:addInputEvent( "Mouse_LUp", "GameOption_CheckAlertMSG(4)" )
	frame_Game._btn_Alert_GuildWar:addInputEvent( "Mouse_LUp", "GameOption_CheckAlertMSG(5)" )
	frame_Game._btn_Alert_PlayerGotItem:addInputEvent( "Mouse_LUp", "GameOption_CheckAlertMSG(6)" )
	frame_Game._btn_Alert_ItemMarket:addInputEvent( "Mouse_LUp", "GameOption_CheckAlertMSG(7)" )
	frame_Game._btn_Alert_LifeLevUp:addInputEvent( "Mouse_LUp", "GameOption_CheckAlertMSG(8)" )
	frame_Game._btn_Alert_GuildQuest:addInputEvent( "Mouse_LUp", "GameOption_CheckAlertMSG(9)" )
	frame_Game._btn_Alert_NearMonster:addInputEvent( "Mouse_LUp", "GameOption_CheckAlertMSG(10)" )

	frame_Game._slide_PadXSen:addInputEvent( "Mouse_LPress",  "GameOption_PadSensitivityX_slider()" )
	frame_Game._slide_PadYSen:addInputEvent( "Mouse_LPress",  "GameOption_PadSensitivityY_slider()" )
	frame_Sound._slide_hitFxVolume:addInputEvent( "Mouse_LPress",  "GameOption_hitFxVolume_slider()" )

	
	frame_Game._btn_SelfNameShowAllways		:addInputEvent( "Mouse_LUp", "GameOption_CheckSelfPlayerNameTagVisible()" )
	frame_Game._btn_SelfNameShowImportant	:addInputEvent( "Mouse_LUp", "GameOption_CheckSelfPlayerNameTagVisible()" )
	frame_Game._btn_SelfNameShowNoShow		:addInputEvent( "Mouse_LUp", "GameOption_CheckSelfPlayerNameTagVisible()" )
	frame_Game._btn_PetAll					:addInputEvent( "Mouse_LUp", "GameOption_CheckPetObjectShow()" )
	frame_Game._btn_PetMine					:addInputEvent( "Mouse_LUp", "GameOption_CheckPetObjectShow()" )
	frame_Game._btn_PetHide					:addInputEvent( "Mouse_LUp", "GameOption_CheckPetObjectShow()" )
	
	frame_Game._btn_NavGuideNone			:addInputEvent( "Mouse_LUp", "GameOption_CheckNavGuidType()" )
	frame_Game._btn_NavGuideArrow			:addInputEvent( "Mouse_LUp", "GameOption_CheckNavGuidType()" )
	frame_Game._btn_NavGuideEffect			:addInputEvent( "Mouse_LUp", "GameOption_CheckNavGuidType()" )
	frame_Game._btn_NavGuideFairy			:addInputEvent( "Mouse_LUp", "GameOption_CheckNavGuidType()" )
	
	
	frame_Game._btn_OtherNameShow			:addInputEvent( "Mouse_LUp", "GameOption_CheckOtherPlayerNameTagVisible()" )
	frame_Game._btn_PartyNameShow			:addInputEvent( "Mouse_LUp", "GameOption_CheckPartyPlayerNameTagVisible()" )
	frame_Game._btn_GuildNameShow			:addInputEvent( "Mouse_LUp", "GameOption_CheckGuildPlayerNameTagVisible()" )
	
	frame_Game._btn_GuideLineHumanRelation	:addInputEvent( "Mouse_LUp", "GameOption_CheckGuideLine_HumanRelation()" )
	frame_Game._btn_GuideLineQuestObject	:addInputEvent( "Mouse_LUp", "GameOption_CheckGuideLine_QuestLine()" )
	frame_Game._btn_GuideLineZoneChange		:addInputEvent( "Mouse_LUp", "GameOption_CheckGuideLine_RanderColor( \"" .. randerPlayerColorStr.zoneChange .. "\" )" )
	frame_Game._btn_GuideLineWarAlly		:addInputEvent( "Mouse_LUp", "GameOption_CheckGuideLine_RanderColor( \"" .. randerPlayerColorStr.warAlly .. "\" )" )
	frame_Game._btn_GuideLineGuild			:addInputEvent( "Mouse_LUp", "GameOption_CheckGuideLine_RanderColor( \"" .. randerPlayerColorStr.guild .. "\" )" )
	frame_Game._btn_GuideLineParty			:addInputEvent( "Mouse_LUp", "GameOption_CheckGuideLine_RanderColor( \"" .. randerPlayerColorStr.party .. "\" )" )
	frame_Game._btn_GuideLineEnemy			:addInputEvent( "Mouse_LUp", "GameOption_CheckGuideLine_RanderColor( \"" .. randerPlayerColorStr.enemy .. "\" )" )
	frame_Game._btn_GuideLineNonWarPlayer	:addInputEvent( "Mouse_LUp", "GameOption_CheckGuideLine_RanderColor( \"" .. randerPlayerColorStr.nonWarPlayer .. "\" )" )

	_btn_CameraMaster:addInputEvent( "Mouse_LPress",  "GameOption_CameraMasterPower_button()" )
	_btn_CameraShake:addInputEvent( "Mouse_LPress",  "GameOption_CameraShakePower_button()" )
	_btn_MotionBlur:addInputEvent( "Mouse_LPress",  "GameOption_MotionBlurPower_button()" )
	_btn_CameraPos:addInputEvent( "Mouse_LPress",  "GameOption_CameraPosPower_button()" )
	_btn_CameraFov:addInputEvent( "Mouse_LPress",  "GameOption_CameraFovPower_button()" )

	_btn_MouXSen:addInputEvent( "Mouse_LPress",  "GameOption_MouseSensitivityX_button()" )
	_btn_MouYSen:addInputEvent( "Mouse_LPress",  "GameOption_MouseSensitivityY_button()" )
	_btn_PadXSen:addInputEvent( "Mouse_LPress",  "GameOption_PadSensitivityX_button()" )
	_btn_PadYSen:addInputEvent( "Mouse_LPress",  "GameOption_PadSensitivityY_button()" )
	_btn_hitFxVolume:addInputEvent( "Mouse_LPress",  "GameOption_hitFxVolume_button()" )

	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- 단축키 리셋
	_static_ResetKeyConfig:addInputEvent( "Mouse_LUp",		"GameOption_ReSetKeyConfig(" .. 0 .. ") " )
	_static_ResetKeyConfig_UI:addInputEvent( "Mouse_LUp",	"GameOption_ReSetKeyConfig(".. 1 .. ")" )
	_static_ResetPositionConfig_UI:addInputEvent( "Mouse_LUp", "GameOption_UIPositon_Reset()" )
	
	-- reset Display/Sound/Game
	frame_Display._btn_Reset:addInputEvent( "Mouse_LUp", "GameOption_ResetDisplayOption()" )
	frame_Sound._btn_Reset:addInputEvent( "Mouse_LUp", "GameOption_ResetSoundOption()" )
	frame_Game._btn_Reset:addInputEvent( "Mouse_LUp", "GameOption_ResetGameOption()" )
	gamePanel_Main._btn_Reset:addInputEvent( "Mouse_LUp", "GameOption_ResetAllOption()" )
	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- 연계기 영상 가이드 보이기
	value_GameOption_Check_ComboGuide:addInputEvent( "Mouse_LUp", "GameOption_ShowComboGuide()" )
	
	
	--------------------------------------------------------------------------------------------------------------------------------------------------
	-- 심플 툴팁
	frame_Display._btn_DOF						:addInputEvent( "Mouse_On", "Button_Simpletooltips( true , " .. simpleToolTipIdx._btn_DOF .. ")" )
	frame_Display._btn_DOF						:setTooltipEventRegistFunc( "Button_Simpletooltips( true , " .. simpleToolTipIdx._btn_DOF .. ")" )
	frame_Display._btn_DOF						:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Display._btn_LensBlood				:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_LensBlood .. ")" )
	frame_Display._btn_LensBlood				:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_LensBlood .. ")" )
	frame_Display._btn_LensBlood				:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Display._btn_AntiAlli					:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_AntiAlli .. ")" )
	frame_Display._btn_AntiAlli					:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_AntiAlli .. ")" )
	frame_Display._btn_AntiAlli					:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Display._btn_Ultra					:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Ultra .. ")" )
	frame_Display._btn_Ultra					:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Ultra .. ")" )
	frame_Display._btn_Ultra					:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Display._btn_BloodEffect				:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_BloodEffect .. ")" )
	frame_Display._btn_BloodEffect				:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_BloodEffect .. ")" )
	frame_Display._btn_BloodEffect				:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Display._btn_SSAO						:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_SSAO .. ")" )
	frame_Display._btn_SSAO						:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_SSAO .. ")" )
	frame_Display._btn_SSAO						:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Display._btn_Tessellation				:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Tessellation .. ")" )
	frame_Display._btn_Tessellation				:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Tessellation .. ")" )
	frame_Display._btn_Tessellation				:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Display._btn_PostFilter				:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_PostFilter .. ")" )
	frame_Display._btn_PostFilter				:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_PostFilter .. ")" )
	frame_Display._btn_PostFilter				:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Display._btn_CharacterEffect			:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_CharacterEffect .. ")" )
	frame_Display._btn_CharacterEffect			:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_CharacterEffect .. ")" )
	frame_Display._btn_CharacterEffect			:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Display._btn_UpscaleEnable			:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_UpscaleEnable .. ")" )
	frame_Display._btn_UpscaleEnable			:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_UpscaleEnable .. ")" )
	frame_Display._btn_UpscaleEnable			:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Display._btn_SleepModeEnable			:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_SleepModeEnable .. ")" )
	frame_Display._btn_SleepModeEnable			:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_SleepModeEnable .. ")" )
	frame_Display._btn_SleepModeEnable			:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Display._btn_ScreenMode[0]			:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_ScreenMode0 .. ")" )
	frame_Display._btn_ScreenMode[0]			:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_ScreenMode0 .. ")" )
	frame_Display._btn_ScreenMode[0]			:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Display._btn_ScreenMode[1]			:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_ScreenMode1 .. ")" )
	frame_Display._btn_ScreenMode[1]			:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_ScreenMode1 .. ")" )
	frame_Display._btn_ScreenMode[1]			:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Display._btn_ScreenMode[2]			:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_ScreenMode2 .. ")" )
	frame_Display._btn_ScreenMode[2]			:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_ScreenMode2 .. ")" )
	frame_Display._btn_ScreenMode[2]			:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Display._btn_ScrSize					:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_ScrSize .. ")" )
	frame_Display._btn_ScrSize					:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_ScrSize .. ")" )
	frame_Display._btn_ScrSize					:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Display._btn_Trxt						:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Trxt .. ")" )
	frame_Display._btn_Trxt						:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Trxt .. ")" )
	frame_Display._btn_Trxt						:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Display._btn_Rndr						:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Rndr .. ")" )
	frame_Display._btn_Rndr						:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Rndr .. ")" )
	frame_Display._btn_Rndr						:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Display._btn_SelfPlayerOnlyEffect		:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_SelfPlayerOnlyEffect .. ")" )
	frame_Display._btn_SelfPlayerOnlyEffect		:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_SelfPlayerOnlyEffect .. ")" )
	frame_Display._btn_SelfPlayerOnlyEffect		:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Display._btn_NearestPlayerOnlyEffect	:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_NearestPlayerOnlyEffect .. ")" )
	frame_Display._btn_NearestPlayerOnlyEffect	:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_NearestPlayerOnlyEffect .. ")" )
	frame_Display._btn_NearestPlayerOnlyEffect	:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Display._btn_SelfPlayerOnlyLantern	:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_SelfPlayerOnlyLantern .. ")" )
	frame_Display._btn_SelfPlayerOnlyLantern	:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_SelfPlayerOnlyLantern .. ")" )
	frame_Display._btn_SelfPlayerOnlyLantern	:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Display._btn_CropModeEnable			:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_CropModeEnable .. ")" )
	frame_Display._btn_CropModeEnable			:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_CropModeEnable .. ")" )
	frame_Display._btn_CropModeEnable			:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	_btn_CropModeScaleX							:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_CropModeScaleX .. ")" )
	_btn_CropModeScaleX							:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_CropModeScaleX .. ")" )
	_btn_CropModeScaleX							:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	_btn_CropModeScaleY							:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_CropModeScaleY .. ")" )
	_btn_CropModeScaleY							:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_CropModeScaleY .. ")" )
	_btn_CropModeScaleY							:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	_btn_UIScale								:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_UIScale .. ")" )
	_btn_UIScale								:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_UIScale .. ")" )
	_btn_UIScale								:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	_btn_CameraMaster							:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_CameraMaster .. ")" )
	_btn_CameraMaster							:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_CameraMaster .. ")" )
	_btn_CameraMaster							:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	_btn_CameraShake							:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_CameraShake .. ")" )
	_btn_CameraShake							:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_CameraShake .. ")" )
	_btn_CameraShake							:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	_btn_MotionBlur								:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_MotionBlur .. ")" )
	_btn_MotionBlur								:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_MotionBlur .. ")" )
	_btn_MotionBlur								:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	_btn_CameraPos								:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_CameraPos .. ")" )
	_btn_CameraPos								:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_CameraPos .. ")" )
	_btn_CameraPos								:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	_btn_CameraFov								:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_CameraFov .. ")" )
	_btn_CameraFov								:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_CameraFov .. ")" )
	_btn_CameraFov								:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Display._btn_LUT						:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_LUT .. ")" )
	frame_Display._btn_LUT						:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_LUT .. ")" )
	frame_Display._btn_LUT						:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Display._btn_LUT_Reset				:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_LUT_Reset .. ")" )
	frame_Display._btn_LUT_Reset				:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_LUT_Reset .. ")" )
	frame_Display._btn_LUT_Reset				:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	_btn_Gamma									:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Gamma .. ")" )
	_btn_Gamma									:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Gamma .. ")" )
	_btn_Gamma									:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	_btn_Contrast								:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Contrast .. ")" )
	_btn_Contrast								:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Contrast .. ")" )
	_btn_Contrast								:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	_btn_Fov									:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Fov .. ")" )
	_btn_Fov									:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Fov .. ")" )
	_btn_Fov									:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	-- frame_Display._btn_ColorBlind[0]			:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_ColorBlind_None .. ")" )
	-- frame_Display._btn_ColorBlind[0]			:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_ColorBlind_None .. ")" )
	-- frame_Display._btn_ColorBlind[0]			:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Display._btn_ColorBlind[1]			:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_ColorBlind_Red .. ")" )
	frame_Display._btn_ColorBlind[1]			:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_ColorBlind_Red .. ")" )
	frame_Display._btn_ColorBlind[1]			:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Display._btn_ColorBlind[2]			:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_ColorBlind_Green .. ")" )
	frame_Display._btn_ColorBlind[2]			:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_ColorBlind_Green .. ")" )
	frame_Display._btn_ColorBlind[2]			:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	-- 소리
	frame_Sound._btn_MusicOnOff					:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_MusicOnOff .. ")" )
	frame_Sound._btn_MusicOnOff					:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_MusicOnOff .. ")" )
	frame_Sound._btn_MusicOnOff					:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Sound._btn_FXOnOff					:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_FXOnOff .. ")" )
	frame_Sound._btn_FXOnOff					:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_FXOnOff .. ")" )
	frame_Sound._btn_FXOnOff					:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Sound._btn_EnvFXOnOff					:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_EnvFXOnOff .. ")" )
	frame_Sound._btn_EnvFXOnOff					:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_EnvFXOnOff .. ")" )
	frame_Sound._btn_EnvFXOnOff					:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Sound._btn_RiddingOnOff				:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_RiddingOnOff .. ")" )
	frame_Sound._btn_RiddingOnOff				:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_RiddingOnOff .. ")" )
	frame_Sound._btn_RiddingOnOff				:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Sound._btn_CombatAllwaysOff			:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_CombatAllwaysOff .. ")" )
	frame_Sound._btn_CombatAllwaysOff			:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_CombatAllwaysOff .. ")" )
	frame_Sound._btn_CombatAllwaysOff			:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Sound._btn_CombatAllwaysOn			:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_CombatAllwaysOn .. ")" )
	frame_Sound._btn_CombatAllwaysOn			:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_CombatAllwaysOn .. ")" )
	frame_Sound._btn_CombatAllwaysOn			:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Sound._btn_CombatAllwaysLowOff		:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_CombatAllwaysLowOff .. ")" )
	frame_Sound._btn_CombatAllwaysLowOff		:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_CombatAllwaysLowOff .. ")" )
	frame_Sound._btn_CombatAllwaysLowOff		:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Sound._btn_WhisperOnOff				:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_WhisperOnOff .. ")" )
	frame_Sound._btn_WhisperOnOff				:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_WhisperOnOff .. ")" )
	frame_Sound._btn_WhisperOnOff				:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Sound._btn_TraySoundOnOff				:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_TraySoundOnOff .. ")" )
	frame_Sound._btn_TraySoundOnOff				:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_TraySoundOnOff .. ")" )
	frame_Sound._btn_TraySoundOnOff				:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	_btn_TotalVol								:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_TotalVol .. ")" )
	_btn_TotalVol								:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_TotalVol .. ")" )
	_btn_TotalVol								:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	_btn_MusicVol								:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_MusicVol .. ")" )
	_btn_MusicVol								:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_MusicVol .. ")" )
	_btn_MusicVol								:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	_btn_FxVol									:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_FxVol .. ")" )
	_btn_FxVol									:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_FxVol .. ")" )
	_btn_FxVol									:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	_btn_EnvFxVol								:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_EnvFxVol .. ")" )
	_btn_EnvFxVol								:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_EnvFxVol .. ")" )
	_btn_EnvFxVol								:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	_btn_VoiceVol								:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_VoiceVol .. ")" )
	_btn_VoiceVol								:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_VoiceVol .. ")" )
	_btn_VoiceVol								:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	_btn_hitFxVolume							:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_hitFxVolume .. ")" )
	_btn_hitFxVolume							:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_hitFxVolume .. ")" )
	_btn_hitFxVolume							:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	_btn_hitFxWeightVolume						:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_hitFxWeightVolume .. ")" )
	_btn_hitFxWeightVolume						:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_hitFxWeightVolume .. ")" )
	_btn_hitFxWeightVolume						:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	_btn_otherPlayerVolume						:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_otherPlayerVolume .. ")" )
	_btn_otherPlayerVolume						:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_otherPlayerVolume .. ")" )
	_btn_otherPlayerVolume						:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	-- 게임
	frame_Game._btn_AutoAim						:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_AutoAim .. ")" )
	frame_Game._btn_AutoAim						:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_AutoAim .. ")" )
	frame_Game._btn_AutoAim						:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_HideWindow					:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_HideWindow .. ")" )
	frame_Game._btn_HideWindow					:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_HideWindow .. ")" )
	frame_Game._btn_HideWindow					:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_GuildLogin					:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_GuildLogin .. ")" )
	frame_Game._btn_GuildLogin					:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_GuildLogin .. ")" )
	frame_Game._btn_GuildLogin					:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_RejectInvitation			:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_RejectInvitation .. ")" )
	frame_Game._btn_RejectInvitation			:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_RejectInvitation .. ")" )
	frame_Game._btn_RejectInvitation			:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_EnableSimpleUI				:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_EnableSimpleUI .. ")" )
	frame_Game._btn_EnableSimpleUI				:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_EnableSimpleUI .. ")" )
	frame_Game._btn_EnableSimpleUI				:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	
	frame_Game._btn_SpiritGuide					:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_SpiritGuide .. ")" )
	frame_Game._btn_SpiritGuide					:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_SpiritGuide .. ")" )
	frame_Game._btn_SpiritGuide					:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_MouseMove					:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_MouseMove .. ")" )
	frame_Game._btn_MouseMove					:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_MouseMove .. ")" )
	frame_Game._btn_MouseMove					:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_MiniMapRotation				:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_MiniMapRotation .. ")" )
	frame_Game._btn_MiniMapRotation				:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_MiniMapRotation .. ")" )
	frame_Game._btn_MiniMapRotation				:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_ShowAttackEffect			:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_ShowAttackEffect .. ")" )
	frame_Game._btn_ShowAttackEffect			:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_ShowAttackEffect .. ")" )
	frame_Game._btn_ShowAttackEffect			:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_Alert_BlackSpirit			:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Alert_BlackSpirit .. ")" )
	frame_Game._btn_Alert_BlackSpirit			:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Alert_BlackSpirit .. ")" )
	frame_Game._btn_Alert_BlackSpirit			:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )

	frame_Game._btn_UseNewQuickSlot				:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_UseNewQuickSlot .. ")" )
	frame_Game._btn_UseNewQuickSlot				:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_UseNewQuickSlot .. ")" )
	frame_Game._btn_UseNewQuickSlot				:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	
	frame_Game._btn_UseChattingFilter			:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_UseChattingFilter .. ")" )
	frame_Game._btn_UseChattingFilter			:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_UseChattingFilter .. ")" )
	frame_Game._btn_UseChattingFilter			:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )

	frame_Game._btn_IsOnScreenSaver				:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_IsOnScreenSaver .. ")" )
	frame_Game._btn_IsOnScreenSaver				:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_IsOnScreenSaver .. ")" )
	frame_Game._btn_IsOnScreenSaver				:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	
	frame_Game._btn_UIModeMouseLock				:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_UIModeMouseLock .. ")" )
	frame_Game._btn_UIModeMouseLock				:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_UIModeMouseLock .. ")" )
	frame_Game._btn_UIModeMouseLock				:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	
	frame_Game._btn_PvpRefuse					:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_PvpRefuse .. ")" )
	frame_Game._btn_PvpRefuse					:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_PvpRefuse .. ")" )
	frame_Game._btn_PvpRefuse					:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	
	frame_Game._btn_EnableOVR					:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_EnableOVR .. ")" )
	frame_Game._btn_EnableOVR					:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_EnableOVR .. ")" )
	frame_Game._btn_EnableOVR					:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_SelfNameShowAllways			:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_SelfNameShowAllways .. ")" )
	frame_Game._btn_SelfNameShowAllways			:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_SelfNameShowAllways .. ")" )
	frame_Game._btn_SelfNameShowAllways			:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_SelfNameShowImportant		:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_SelfNameShowImportant .. ")" )
	frame_Game._btn_SelfNameShowImportant		:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_SelfNameShowImportant .. ")" )
	frame_Game._btn_SelfNameShowImportant		:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_SelfNameShowNoShow			:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_SelfNameShowNoShow .. ")" )
	frame_Game._btn_SelfNameShowNoShow			:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_SelfNameShowNoShow .. ")" )
	frame_Game._btn_SelfNameShowNoShow			:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_OtherNameShow				:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_OtherNameShow .. ")" )
	frame_Game._btn_OtherNameShow				:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_OtherNameShow .. ")" )
	frame_Game._btn_OtherNameShow				:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_PartyNameShow				:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_PartyNameShow .. ")" )
	frame_Game._btn_PartyNameShow				:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_PartyNameShow .. ")" )
	frame_Game._btn_PartyNameShow				:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_GuildNameShow				:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_GuildNameShow .. ")" )
	frame_Game._btn_GuildNameShow				:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_GuildNameShow .. ")" )
	frame_Game._btn_GuildNameShow				:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )

	frame_Game._btn_GuideLineHumanRelation		:addInputEvent( "Mouse_On",		"Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_GuideLineHumanRelation .. ")" )
	frame_Game._btn_GuideLineHumanRelation		:addInputEvent( "Mouse_Out",	"Button_Simpletooltips( false )" )
	frame_Game._btn_GuideLineHumanRelation		:setTooltipEventRegistFunc( 	"Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_GuideLineHumanRelation .. ")" )
	frame_Game._btn_GuideLineQuestObject		:addInputEvent( "Mouse_On",		"Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_GuideLineQuestObject .. ")" )
	frame_Game._btn_GuideLineQuestObject		:addInputEvent( "Mouse_Out",	"Button_Simpletooltips( false )" )
	frame_Game._btn_GuideLineQuestObject		:setTooltipEventRegistFunc( 	"Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_GuideLineQuestObject .. ")" )
	frame_Game._btn_GuideLineZoneChange			:addInputEvent( "Mouse_On",		"Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_GuideLineZoneChange .. ")" )
	frame_Game._btn_GuideLineZoneChange			:addInputEvent( "Mouse_Out",	"Button_Simpletooltips( false )" )
	frame_Game._btn_GuideLineZoneChange			:setTooltipEventRegistFunc( 	"Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_GuideLineZoneChange .. ")" )
	frame_Game._btn_GuideLineWarAlly			:addInputEvent( "Mouse_On",		"Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_GuideLineWarAlly .. ")" )
	frame_Game._btn_GuideLineWarAlly			:addInputEvent( "Mouse_Out",	"Button_Simpletooltips( false )" )
	frame_Game._btn_GuideLineWarAlly			:setTooltipEventRegistFunc( 	"Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_GuideLineWarAlly .. ")" )
	frame_Game._btn_GuideLineGuild				:addInputEvent( "Mouse_On",		"Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_GuideLineGuild .. ")" )
	frame_Game._btn_GuideLineGuild				:addInputEvent( "Mouse_Out",	"Button_Simpletooltips( false )" )
	frame_Game._btn_GuideLineGuild				:setTooltipEventRegistFunc( 	"Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_GuideLineGuild .. ")" )
	frame_Game._btn_GuideLineParty				:addInputEvent( "Mouse_On",		"Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_GuideLineParty .. ")" )
	frame_Game._btn_GuideLineParty				:addInputEvent( "Mouse_Out",	"Button_Simpletooltips( false )" )
	frame_Game._btn_GuideLineParty				:setTooltipEventRegistFunc( 	"Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_GuideLineParty .. ")" )
	frame_Game._btn_GuideLineEnemy				:addInputEvent( "Mouse_On",		"Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_GuideLineEnemy .. ")" )
	frame_Game._btn_GuideLineEnemy				:addInputEvent( "Mouse_Out",	"Button_Simpletooltips( false )" )
	frame_Game._btn_GuideLineEnemy				:setTooltipEventRegistFunc( 	"Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_GuideLineEnemy .. ")" )
	frame_Game._btn_GuideLineNonWarPlayer		:addInputEvent( "Mouse_On",		"Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_GuideLineNonWarPlayer .. ")" )
	frame_Game._btn_GuideLineNonWarPlayer		:addInputEvent( "Mouse_Out",	"Button_Simpletooltips( false )" )
	frame_Game._btn_GuideLineNonWarPlayer		:setTooltipEventRegistFunc( 	"Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_GuideLineNonWarPlayer .. ")" )

	frame_Game._btn_PetAll						:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_PetAll .. ")" )
	frame_Game._btn_PetAll						:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_PetAll .. ")" )
	frame_Game._btn_PetAll						:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_PetMine						:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_PetMine .. ")" )
	frame_Game._btn_PetMine						:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_PetMine .. ")" )
	frame_Game._btn_PetMine						:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_PetHide						:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_PetHide .. ")" )
	frame_Game._btn_PetHide						:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_PetHide .. ")" )
	frame_Game._btn_PetHide						:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	
	frame_Game._btn_NavGuideNone				:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_NavGuideNone .. ")" )
	frame_Game._btn_NavGuideNone				:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_NavGuideNone .. ")" )
	frame_Game._btn_NavGuideNone				:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_NavGuideArrow				:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_NavGuideArrow .. ")" )
	frame_Game._btn_NavGuideArrow				:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_NavGuideArrow .. ")" )
	frame_Game._btn_NavGuideArrow				:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_NavGuideEffect				:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_NavGuideEffect .. ")" )
	frame_Game._btn_NavGuideEffect				:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_NavGuideEffect .. ")" )
	frame_Game._btn_NavGuideEffect				:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_NavGuideFairy				:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_NavGuideFairy .. ")" )
	frame_Game._btn_NavGuideFairy				:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_NavGuideFairy .. ")" )
	frame_Game._btn_NavGuideFairy				:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	
	
	frame_Game._btn_Alert_Region				:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Alert_Region .. ")" )
	frame_Game._btn_Alert_Region				:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Alert_Region .. ")" )
	frame_Game._btn_Alert_Region				:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_Alert_TerritoryTrade		:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Alert_TerritoryTrade .. ")" )
	frame_Game._btn_Alert_TerritoryTrade		:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Alert_TerritoryTrade .. ")" )
	frame_Game._btn_Alert_TerritoryTrade		:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_Alert_RoyalTrade			:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Alert_RoyalTrade .. ")" )
	frame_Game._btn_Alert_RoyalTrade			:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Alert_RoyalTrade .. ")" )
	frame_Game._btn_Alert_RoyalTrade			:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_Alert_Fitness				:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Alert_Fitness .. ")" )
	frame_Game._btn_Alert_Fitness				:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Alert_Fitness .. ")" )
	frame_Game._btn_Alert_Fitness				:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_Alert_TerritoryWar			:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Alert_TerritoryWar .. ")" )
	frame_Game._btn_Alert_TerritoryWar			:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Alert_TerritoryWar .. ")" )
	frame_Game._btn_Alert_TerritoryWar			:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_Alert_GuildWar				:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Alert_GuildWar .. ")" )
	frame_Game._btn_Alert_GuildWar				:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Alert_GuildWar .. ")" )
	frame_Game._btn_Alert_GuildWar				:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_Alert_PlayerGotItem			:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Alert_PlayerGotItem .. ")" )
	frame_Game._btn_Alert_PlayerGotItem			:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Alert_PlayerGotItem .. ")" )
	frame_Game._btn_Alert_PlayerGotItem			:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_Alert_ItemMarket			:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Alert_ItemMarket .. ")" )
	frame_Game._btn_Alert_ItemMarket			:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Alert_ItemMarket .. ")" )
	frame_Game._btn_Alert_ItemMarket			:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_Alert_LifeLevUp				:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Alert_LifeLevUp .. ")" )
	frame_Game._btn_Alert_LifeLevUp				:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Alert_LifeLevUp .. ")" )
	frame_Game._btn_Alert_LifeLevUp				:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_Alert_GuildQuest			:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Alert_GuildQuest .. ")" )
	frame_Game._btn_Alert_GuildQuest			:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Alert_GuildQuest .. ")" )
	frame_Game._btn_Alert_GuildQuest			:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )	
	frame_Game._btn_Alert_NearMonster		:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Alert_NearMonster .. ")" )
	frame_Game._btn_Alert_NearMonster		:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_Alert_NearMonster .. ")" )
	frame_Game._btn_Alert_NearMonster		:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )	
	frame_Game._btn_MouseX						:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_MouseX .. ")" )
	frame_Game._btn_MouseX						:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_MouseX .. ")" )
	frame_Game._btn_MouseX						:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_MouseY						:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_MouseY .. ")" )
	frame_Game._btn_MouseY						:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_MouseY .. ")" )
	frame_Game._btn_MouseY						:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	_btn_MouXSen								:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_MouXSen .. ")" )
	_btn_MouXSen								:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_MouXSen .. ")" )
	_btn_MouXSen								:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	_btn_MouYSen								:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_MouYSen .. ")" )
	_btn_MouYSen								:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_MouYSen .. ")" )	
	_btn_MouYSen								:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_UsePad						:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_UsePad .. ")" )
	frame_Game._btn_UsePad						:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_UsePad .. ")" )
	frame_Game._btn_UsePad						:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_UseVibe						:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_UseVibe .. ")" )
	frame_Game._btn_UseVibe						:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_UseVibe .. ")" )
	frame_Game._btn_UseVibe						:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_PadX						:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_PadX .. ")" )
	frame_Game._btn_PadX						:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_PadX .. ")" )
	frame_Game._btn_PadX						:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	frame_Game._btn_PadY						:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_PadY .. ")" )
	frame_Game._btn_PadY						:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_PadY .. ")" )
	frame_Game._btn_PadY						:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	_btn_PadXSen								:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_PadXSen .. ")" )
	_btn_PadXSen								:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_PadXSen .. ")" )
	_btn_PadXSen								:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
	_btn_PadYSen								:addInputEvent( "Mouse_On", "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_PadYSen .. ")" )
	_btn_PadYSen								:setTooltipEventRegistFunc( "Button_Simpletooltips( true, " .. simpleToolTipIdx._btn_PadYSen .. ")" )
	_btn_PadYSen								:addInputEvent( "Mouse_Out", "Button_Simpletooltips( false )" )
end



-- function GameOption_Display_Tooltip( show, target )
	-- local tooltip 		= frame_Display._tooltip
	-- local targetControl = nil
	
	-- tooltip:SetAutoResize()
	-- tooltip:SetTextMode(UI_TM.eTextMode_AutoWrap)
	
	-- if ( true == show ) then
		-- if "DOF" == target then
			-- tooltip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_DOF") ) -- "화면의 선명함을 설정합니다."
			-- targetControl = frame_Display._btn_DOF
		-- elseif "Anti" == target then
			-- tooltip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_ANTIALLI") ) -- "그래픽을 자연스럽게 표현합니다."
			-- targetControl = frame_Display._btn_AntiAlli
		-- elseif "Ultra" == target then
			-- tooltip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_ULTRA") ) -- "그래픽을 자연스럽게 표현합니다."
			-- targetControl = frame_Display._btn_Ultra
		-- elseif "Blood" == target then
			-- tooltip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_BLOODEFFECT") ) -- "몬스터의 피 튀기는 것을 설정합니다."
			-- targetControl = frame_Display._btn_BloodEffect
		-- elseif "Lens" == target then
			-- tooltip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_LENSBLOOD") ) -- "핏자국이 화면에 튀는 것을 설정합니다."
			-- targetControl = frame_Display._btn_LensBlood
		-- elseif "SSAO" == target then
			-- tooltip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_SSAO") )
			-- targetControl = frame_Display._btn_SSAO
		-- elseif "Tessellation" == target then
			-- tooltip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_TESSELLATION") )
			-- targetControl = frame_Display._btn_Tessellation
		-- elseif "PostFilter" == target then
			-- tooltip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_FILTER") )
			-- targetControl = frame_Display._btn_PostFilter
		-- elseif "CharacterEffect" == target then
			-- tooltip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_CHARACTEREFFECT") )
			-- targetControl = frame_Display._btn_CharacterEffect
		-- elseif "Upscale" == target then
			-- tooltip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_UPSCALE") )
			-- targetControl = frame_Display._btn_UpscaleEnable
		-- elseif "SleepMode" == target then
			-- tooltip:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_TOOLTIP_SLEEPMODE") ) -- "화면보호기능 작동 시 절전기능을 추가합니다."
			-- targetControl = frame_Display._btn_SleepModeEnable
		-- end
		
		-- local posX = targetControl:GetPosX() - (tooltip:GetSizeX() / 2 )
		-- local posY = targetControl:GetPosY() - tooltip:GetSizeY()
		
		-- if posX <= 10 then
			-- posX = 10
		-- end
		-- tooltip:SetSize( tooltip:GetTextSizeX() + 20, tooltip:GetTextSizeY() )
		-- tooltip:SetPosX( posX )
		-- tooltip:SetPosY( posY )
		
		-- tooltip:SetShow( true )
	-- else
		-- tooltip:SetShow( false )
	-- end

-- end


function InitGraphicOptionAll( gameOptionSetting, optionType )
	-- 스크린 모드 획득 & 설정
	local screenModeIdx = gameOptionSetting:getScreenMode()
	GameOption_InitScreenMode( screenModeIdx)
	GameOption_SetScreenModeButtons( chk_Option.currentScreenModeIdx )

	local screenWidth =  gameOptionSetting:getScreenResolutionWidth()
	local screenHeight = gameOptionSetting:getScreenResolutionHeight()
		
	local screenResolutionIdx = GameOption_FindScreenResolutionIdx( screenWidth, screenHeight )
	
	if screenResolutionIdx == 0 then
		GameOption_InitScreenResolution( 0 ) 	-- 리스트에 있는 해상도가 아닌 경우에는 현재 해상도 그대로 출력 하도록 수정.
		GameOption_SetScreenResolutionText_exception( screenWidth, screenHeight )
	else
		GameOption_InitScreenResolution( screenResolutionIdx )
		GameOption_SetScreenResolutionText( chk_Option.currentScreenResolutionIdx )
	end

	-- LUT
	local LUT = gameOptionSetting:getCameraLUTFilter()
	GameOption_InitLUT( LUT )
	
	-- 스크린샷 포맷 받아오기
	local ScreenShotFormat = gameOptionSetting:getScreenShotFormat()
	GameOption_InitScreenShotFormat( ScreenShotFormat )
	GameOption_CheckScreenShotFormat( ScreenShotFormat )

	-- 색약 모드
	local ColorBlindType = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(CppEnums.GlobalUIOptionType.ColorBlindMode)
	GameOption_InitColorBlindMode( ColorBlindType )
	GameOption_CheckColorBlind( ColorBlindType )

	-- 다른 유저 이팩트 출력 여부 받아오기
	local SelfPlayerOnlyEffect = gameOptionSetting:getSelfPlayerOnlyEffect()	
	GameOption_InitSelfPlayerOnlyEffect( SelfPlayerOnlyEffect )
	GameOption_CheckSelfPlayerOnlyEffect( )

	-- 멀리있는 유저 이팩트 출력 여부 받아오기
	local NearestPlayerOnlyEffect = gameOptionSetting:getNearestPlayerOnlyEffect()	
	GameOption_InitNearestPlayerOnlyEffect( NearestPlayerOnlyEffect )
	GameOption_CheckNearestPlayerOnlyEffect( )
	
	-- 다른 유저 랜턴 출력 여부 받아오기
	local SelfPlayerOnlyLantern = gameOptionSetting:getSelfPlayerOnlyLantern()	
	GameOption_InitSelfPlayerOnlyLantern( SelfPlayerOnlyLantern )
	GameOption_CheckSelfPlayerOnlyLantern( )

	-- upscale
	local UpscaleEnable = gameOptionSetting:getUpscaleEnable()
	GameOption_InitUpscale( UpscaleEnable )
	GameOption_CheckUpscale()
	
	-- SleepMode
	local SleepModeEnable = gameOptionSetting:getSleepModeEnable()
	GameOption_InitSleepMode( SleepModeEnable )
	GameOption_CheckSleepMode()
	
	-- CropMode 받아오기
	local CropModeEnable = gameOptionSetting:getCropModeEnable()
	local CropModeScaleX = gameOptionSetting:getCropModeScaleX()
	local CropModeScaleY = gameOptionSetting:getCropModeScaleY()
	GameOption_InitCropMode( CropModeEnable, CropModeScaleX, CropModeScaleY )

	-- 텍스쳐 품질 획득 & 설정
	local textureQualityIdx = gameOptionSetting:getTextureQuality()
	GameOption_InitTextureQuality( textureQualityIdx )
	GameOption_SetTextureQualityText( chk_Option.currentTextureQualityIdx )

	-- 그래픽 옵션 획득 & 설정
	local graphicOptionIdx = gameOptionSetting:getGraphicOption()
	GameOption_InitGraphicOption( graphicOptionIdx )
	GameOption_SetGraphicOptionText( graphicOptionIdx )

	GameOption_InitGraphicCustomOption( gameOptionSetting )
	GameOption_SetGraphicCustomOption()
	
	-- CAMERA POS 설정
	local posPowerValue = gameOptionSetting:getCameraTranslatePower()	-- 0~1 값으로 넘어옴
	GameOption_InitCameraPos( posPowerValue )
	GameOption_SetGammaValueText( posPowerValue )
	
	-- CAMERA FOV 설정
	local fovPowerValue = gameOptionSetting:getCameraFovPower()	-- 0~1 값으로 넘어옴
	GameOption_InitCameraFov( fovPowerValue )
	GameOption_SetGammaValueText( fovPowerValue )
	
	-- 감마 설정
	local gammaValue = gameOptionSetting:getGammaValue()	-- 0~1 값으로 넘어옴
	GameOption_InitGamma( gammaValue )
	GameOption_SetGammaValueText( gammaValue )
	
	-- 대비 설정
	local contrastValue = gameOptionSetting:getContrastValue()	-- 0~1 값으로 넘어옴
	GameOption_InitContrast( contrastValue )
	GameOption_SetContrastValueText( contrastValue )

	local fovValue = gameOptionSetting:getFov()	-- 40 - 60 값으로 넘어옴
	GameOption_InitFov( fovValue )
	GameOption_SetFovValueText( fovValue )
		
	--if(optionType == 1) then
		-- UI 크기 설정
		local uiScale			= gameOptionSetting:getUIScale()
		uiScale = ((uiScale + 0.005) * 100 ) / 100
		--  TODO : 수정할것
	
		uiScale = GameOption_InitScale( uiScale, screenHeight)
				
		GameOption_SetUIMode( uiScale )
		setUIScale( uiScale );
	--end
end


function InitSoundOptionAll( gameOptionSetting )
	local enableMusic		= gameOptionSetting:getEnableMusic()
	local enableSound		= gameOptionSetting:getEnableSound()
	local enableEnvSound	= gameOptionSetting:getEnableEnvSound()
	--local enableHitFxType = gameOptionSetting:getHitFxType()
	local masterVolume		= gameOptionSetting:getMasterVolume()
	local musicVolume		= gameOptionSetting:getMusicVolume()
	local fxVolume			= gameOptionSetting:getFxVolume()
	local envVolume			= gameOptionSetting:getEnvSoundVolume()
	local dlgVolume			= gameOptionSetting:getDialogueVolume()
	local hitFxVolume		= gameOptionSetting:getHitFxVolume()
	local hitFxWeight		= gameOptionSetting:getHitFxWeight()
	local otherplayerVolume = gameOptionSetting:getOtherPlayerVolume()
	local combatMusic		= gameOptionSetting:getEnableBattleSoundType()
	local riddingMusic		= gameOptionSetting:getEnableRidingSound()
	local whisperMusic		= gameOptionSetting:getEnableWhisperSound()
	local TraySound			 = gameOptionSetting:getEnableTraySound()

	GameOption_InitSound( enableMusic, enableSound, enableEnvSound, nil, masterVolume, fxVolume, dlgVolume, envVolume, musicVolume, hitFxWeight, otherplayerVolume, riddingMusic, combatMusic, isVoiceChatOnOff, whisperMusic, voiceMicVolume, voiceSpeakerVolume, voiceNoiseControl, TraySound )
	GameOption_SetVolumeText( masterVolume, fxVolume, dlgVolume, envVolume, musicVolume, hitFxVolume, hitFxWeight, otherplayerVolume, voiceMicVolume, voiceSpeakerVolume, voiceNoiseControl )
end


-------------------------------------------------------------------------------------------------------
--                   		     			 옵션 초기 설정
----------------------------------------------------------------------------------------------------------------
function GameOption_InitGameOption( gameOptionSetting, optionType )
-------------- 여기 수정하려면 대일한테 허락받도록 (기본적으로 체크되어있는 목록) --------------
-------------- 여기 수정하려면 대일한테 허락받도록 (기본적으로 체크되어있는 목록) --------------
-------------- 여기 수정하려면 대일한테 허락받도록 (기본적으로 체크되어있는 목록) --------------
						-- frame_Game._btn_SkillCmd:SetCheck( true )
						-- frame_Game._btn_ShowKeyGuide:SetShow( false )

						-- frame_Sound._btn_MusicOnOff:SetCheck( true )
						-- frame_Sound._btn_FXOnOff:SetCheck( true )
						-- frame_Sound._btn_EnvFXOnOff:SetCheck( true )
-------------- 여기 수정하려면 대일한테 허락받도록 (기본적으로 체크되어있는 목록) --------------
-------------- 여기 수정하려면 대일한테 허락받도록 (기본적으로 체크되어있는 목록) --------------
-------------- 여기 수정하려면 대일한테 허락받도록 (기본적으로 체크되어있는 목록) --------------

	frame_Game._btn_HideWindow:SetCheck(true)
	gamePanel_Main._btn_Apply:SetEnable( false )

	InitGraphicOptionAll( gameOptionSetting, optionType )
	InitSoundOptionAll( gameOptionSetting )
	GameOption_SetGameMode( gameOptionSetting )
	GameOption_InitSystemNotify()
	
	-- 결투 시스템이 아직 없어서 결투신청 거부 옵션을 임시로 hide 시킴. 2016-04-11
	frame_Game._btn_PvpRefuse:SetShow(false)
end

-- 키 커스텀용 초기화 함수
function Option_Init_KeyConfig()
	local adderPosY = 35

	local titleStaticPosY		= frame_Key._button_Pad_Func1:GetPosY()
	local keyButtonPosY			= frame_Key._button_Pad_Func1:GetPosY()
	local padButtonPosY			= frame_Key._button_Pad_Func1:GetPosY()

	for ii = 0, keyConfigListShowCount -1 do
		if ( nil == STATIC_INPUT_TITLE[ii] ) then
			STATIC_INPUT_TITLE[ii]	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, 	_frameContent_KeyConfig, "StaticText_InputTitle_" .. tostring(ii) )
			CopyBaseProperty( frame_Key._staticInputTitle_Func1, STATIC_INPUT_TITLE[ii] )
			STATIC_INPUT_TITLE[ii]:SetIgnore( true )
			STATIC_INPUT_TITLE[ii]:SetShow( true )
		end
		if ( nil == BUTTON_KEY[ii] ) then
			BUTTON_KEY[ii]			= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON,		_frameContent_KeyConfig, "Button_Key_" .. tostring(ii) )
			CopyBaseProperty( frame_Key._button_key, BUTTON_KEY[ii] )
			BUTTON_KEY[ii]:addInputEvent( "Mouse_LUp", "KeyCustom_Action_ButtonPushed_Key(" .. ii .. ")" )
			BUTTON_KEY[ii]:SetShow( true )
		end
		if ( nil == BUTTON_PAD[ii] ) then
			BUTTON_PAD[ii]			= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON,		_frameContent_KeyConfig, "Button_Pad_" .. tostring(ii) )
			CopyBaseProperty( frame_Key._button_Pad_Func2, BUTTON_PAD[ii] )
			BUTTON_PAD[ii]:addInputEvent( "Mouse_LUp", "KeyCustom_Action_ButtonPushed_Pad(" .. ii .. ")" )
			BUTTON_PAD[ii]:SetShow( true )
		end

		STATIC_INPUT_TITLE[ii]:SetPosY( titleStaticPosY  )
		BUTTON_KEY[ii]:SetPosY( keyButtonPosY )
		BUTTON_PAD[ii]:SetPosY( padButtonPosY )

		titleStaticPosY			= titleStaticPosY + adderPosY
		keyButtonPosY			= keyButtonPosY + adderPosY
		padButtonPosY			= padButtonPosY + adderPosY
	end

	for index = INPUT_COUNT_START, INPUT_COUNT_END do
		local titleString =  PAGetString( Defines.StringSheet_GAME, ("Lua_KeyCustom_Action_" .. index) )
		setKeyConfigDataTitle(index, titleString)
	end

	setKeyConfigDataTitle(-2, frame_Key._staticInputTitle_Func1:GetText() )
	setKeyConfigDataTitle(-1, frame_Key._staticInputTitle_Func2:GetText() )
	setKeyConfigDataConfigOnlyPad(-2, true)
	setKeyConfigDataConfigOnlyPad(-1, true)

	frame_Key._button_key:SetShow( false )
	frame_Key._button_Pad_Func2:SetShow( false )
	frame_Key._staticInputTitle_Func1:SetShow( false )
	frame_Key._staticInputTitle_Func2:SetShow( false )
	frame_Key._button_Pad_Func1:SetShow( false )
	frame_Key._button_Pad_Func2:SetShow( false )

	_frame_KeyConfig:UpdateContentScroll()
	_frame_KeyConfig:UpdateContentPos()
end

-- UI 단축키 커스텀용 초기화 함수
function Option_Init_KeyConfig_UI()
	local adderPosY = 35

	local titleStaticPosY			= frame_Key_UI._button_Pad_Func1:GetPosY()
	local keyButtonPosY				= frame_Key_UI._button_Pad_Func1:GetPosY()
	local padButtonPosY				= frame_Key_UI._button_Pad_Func1:GetPosY()

	for ii = 0, keyConfigListShowCount_UI -1 do
		if( CppEnums.UiInputType.UiInputType_Cancel ~= ii ) then
			if ( nil == STATIC_INPUT_TITLE_UI[ii] ) then
				STATIC_INPUT_TITLE_UI[ii]	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, 	_frameContent_KeyConfig_UI, "StaticText_InputTitle_" .. tostring(ii) )
				CopyBaseProperty( frame_Key_UI._staticInputTitle_Func1, STATIC_INPUT_TITLE_UI[ii] )
				STATIC_INPUT_TITLE_UI[ii]:SetIgnore( true )
				STATIC_INPUT_TITLE_UI[ii]:SetShow( true )
			end
			if ( nil == BUTTON_KEY_UI[ii] ) then
				BUTTON_KEY_UI[ii]			= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, 		_frameContent_KeyConfig_UI, "Button_Key_" .. tostring(ii) )
				CopyBaseProperty( frame_Key_UI._button_key, BUTTON_KEY_UI[ii] )
				BUTTON_KEY_UI[ii]:addInputEvent( "Mouse_LUp", "KeyCustom_UI_ButtonPushed_Key(" .. ii .. ")" )
				BUTTON_KEY_UI[ii]:SetShow( true )
			end
			if ( nil == BUTTON_PAD_UI[ii] ) then
				BUTTON_PAD_UI[ii]			= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, 		_frameContent_KeyConfig_UI, "Button_Pad_" .. tostring(ii) )
				CopyBaseProperty( frame_Key_UI._button_Pad_Func1, BUTTON_PAD_UI[ii] )
				BUTTON_PAD_UI[ii]:addInputEvent( "Mouse_LUp", "KeyCustom_UI_ButtonPushed_Pad(" .. ii .. ")" )
				BUTTON_PAD_UI[ii]:SetShow( true )
			end

			STATIC_INPUT_TITLE_UI[ii]:SetPosY( titleStaticPosY )
			BUTTON_KEY_UI[ii]:SetPosY( keyButtonPosY )
			BUTTON_PAD_UI[ii]:SetPosY( padButtonPosY )

			titleStaticPosY				= titleStaticPosY + adderPosY
			keyButtonPosY				= keyButtonPosY + adderPosY
			padButtonPosY				= padButtonPosY + adderPosY
		end
	end

	for index = INPUT_COUNT_START_UI , INPUT_COUNT_END_UI do
		local titleString =  PAGetString( Defines.StringSheet_GAME, ("Lua_KeyCustom_Ui_" .. index) )
		setKeyConfigData_UITitle(index, titleString)
	end

	frame_Key_UI._staticInputTitle_Func1:SetShow( false )
	frame_Key_UI._button_key:SetShow( false )
	frame_Key_UI._button_Pad_Func1:SetShow( false )

	_frame_KeyConfig_UI:UpdateContentScroll()
	_frame_KeyConfig_UI:UpdateContentPos()
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------  실행  함수 모음 ------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------
--				        	스크린 모드 설정 관련
------------------------------------------------------------
function GameOption_InitScreenMode( screenModeIdx)
	local self = chk_Option
	if  0 <= screenModeIdx   and screenModeIdx < self.SCREEN_MODE_COUNT then
		self.currentScreenModeIdx = screenModeIdx
		self.savedScreenModeIdx = screenModeIdx
		self.appliedScreenModeIdx = screenModeIdx
	end
end
function GameOption_SetCurrentScreenMode( screenModeIdx )
	local self = chk_Option
	if( self.currentScreenModeIdx ~= screenModeIdx ) then
		self.currentScreenModeIdx = screenModeIdx
		GameOption_SetScreenModeButtons( screenModeIdx )
	end

	GameOption_UpdateOptionChanged()
end
function GameOption_SetScreenModeButtons( screenModeIdx )
	if  screenModeIdx == chk_Option.FULL_SCREEN_IDX  then
		frame_Display._btn_ScreenMode[chk_Option.FULL_SCREEN_IDX]:SetCheck(true)
		frame_Display._btn_ScreenMode[chk_Option.FULL_SCREEN_WINDOWED_IDX]:SetCheck(false)
		frame_Display._btn_ScreenMode[chk_Option.WINDOWED_IDX]:SetCheck(false)
	elseif screenModeIdx  == chk_Option.FULL_SCREEN_WINDOWED_IDX then
		frame_Display._btn_ScreenMode[chk_Option.FULL_SCREEN_IDX]:SetCheck(false)
		frame_Display._btn_ScreenMode[chk_Option.FULL_SCREEN_WINDOWED_IDX]:SetCheck(true)
		frame_Display._btn_ScreenMode[chk_Option.WINDOWED_IDX]:SetCheck(false)
	elseif screenModeIdx  == chk_Option.WINDOWED_IDX then
		frame_Display._btn_ScreenMode[chk_Option.FULL_SCREEN_IDX]:SetCheck(false)
		frame_Display._btn_ScreenMode[chk_Option.FULL_SCREEN_WINDOWED_IDX]:SetCheck(false)
		frame_Display._btn_ScreenMode[chk_Option.WINDOWED_IDX]:SetCheck(true)
	end
end

--  스케일 초기화 함수
function GameOption_InitScale( uiScale, screenHeight )

	if( screenHeight <= minScaleHeight) then
		minScaleValue = const_UiScaleValue[1];
		maxScaleValue = const_UiScaleValue[2];
	elseif( minScaleHeight < screenHeight and screenHeight <= midleScaleHeight ) then
		minScaleValue = const_UiScaleValue[1];
		maxScaleValue = const_UiScaleValue[3];
	elseif( midleScaleHeight < screenHeight and screenHeight <= HighScaleHeight ) then
		minScaleValue = const_UiScaleValue[1];
		maxScaleValue = const_UiScaleValue[4];
	elseif( HighScaleHeight < screenHeight and screenHeight <= MaxScaleHeight ) then
		minScaleValue = const_UiScaleValue[1];
		maxScaleValue = const_UiScaleValue[5];
	else
		minScaleValue = const_UiScaleValue[5];
		maxScaleValue = const_UiScaleValue[6];
	end
	
	uiScale = math.floor( uiScale * 100 ) / 100
	if( uiScale * 100 > maxScaleValue ) then
		uiScale = 0.8
	end
	chk_Option.appliedCheckUIScale = uiScale; 
	chk_Option.savedCheckUIScale   = uiScale;
	chk_Option.currentCheckUIScale = uiScale;
	return uiScale;
end

-- 스크린샷 포맷 설정 함수

function GameOption_InitScreenShotFormat( Format )
	local self = chk_Option
	self.currentScreenShotFormat = Format
	self.savedScreenShotFormat = Format
	self.appliedScreenShotFormat = Format
	GameOption_UpdateOptionChanged()
end

function GameOption_InitColorBlindMode( Format )
	local self = chk_Option
	self.currentColorBlind = Format
	self.savedColorBlind = Format
	self.appliedColorBlind = Format
	GameOption_UpdateOptionChanged()
end

function GameOption_InitSelfPlayerOnlyEffect( isSelfPlayerOnlyEffect )
	local self = chk_Option
	local check = isSelfPlayerOnlyEffect
	frame_Display._btn_SelfPlayerOnlyEffect:SetCheck(check)
	self.currentSelfPlayerOnlyEffect = check
	self.savedSelfPlayerOnlyEffect = check
	self.appliedSelfPlayerOnlyEffect = check
	GameOption_UpdateOptionChanged()
end

function GameOption_InitNearestPlayerOnlyEffect( isNearestPlayerOnlyEffect )
	local self = chk_Option
	local check = isNearestPlayerOnlyEffect
	frame_Display._btn_NearestPlayerOnlyEffect:SetCheck(check)
	self.currentNearestPlayerOnlyEffect = check
	self.savedNearestPlayerOnlyEffect = check
	self.appliedNearestPlayerOnlyEffect = check
	GameOption_UpdateOptionChanged()
end

function GameOption_InitSelfPlayerOnlyLantern( isSelfPlayerOnlyLantern )
	local self = chk_Option
	local check = isSelfPlayerOnlyLantern
	frame_Display._btn_SelfPlayerOnlyLantern:SetCheck(check)
	self.currentSelfPlayerOnlyLantern = check
	self.savedSelfPlayerOnlyLantern = check
	self.appliedSelfPlayerOnlyLantern = check
	GameOption_UpdateOptionChanged()
end

function GameOption_CheckScreenShotBMP()
	local self = chk_Option
	GameOption_SetScreenShotFormat( self.SCREENSHOT_BMP )
end

function GameOption_CheckScreenShotJPG()
	local self = chk_Option
	GameOption_SetScreenShotFormat( self.SCREENSHOT_JPG )
end

function GameOption_CheckScreenShotPNG()
	local self = chk_Option
	GameOption_SetScreenShotFormat( self.SCREENSHOT_PNG )
end


function GameOption_SetScreenShotFormat( Format )
	local self = chk_Option
	if( self.currentScreenShotFormat ~= Format ) then
		self.currentScreenShotFormat = Format
		GameOption_CheckScreenShotFormat( Format )
	end

	GameOption_UpdateOptionChanged()
end

function GameOption_CheckColorBlindNONE()
	local self = chk_Option
	GameOption_SetColorBlindMode( self.COLORBLIND_NONE )
end

function GameOption_CheckColorBlindPROTANOPIA()
	local self = chk_Option
	GameOption_SetColorBlindMode( self.COLORBLIND_PROTANOPIA )
end

function GameOption_CheckColorBlindEDUTERANOP()
	local self = chk_Option
	GameOption_SetColorBlindMode( self.COLORBLIND_DEUTERANOP )
end

function GameOption_SetColorBlindMode( Format )
	local self = chk_Option
	if( self.currentColorBlind ~= Format ) then
		self.currentColorBlind = Format
		GameOption_CheckColorBlind( Format )
	end

	GameOption_UpdateOptionChanged()
end

function GameOption_CheckScreenShotFormat( Format )
	if  Format == 0 then
		frame_Display._btn_ScreenShotFormat[chk_Option.SCREENSHOT_BMP]:SetCheck(true)
		frame_Display._btn_ScreenShotFormat[chk_Option.SCREENSHOT_JPG]:SetCheck(false)
		frame_Display._btn_ScreenShotFormat[chk_Option.SCREENSHOT_PNG]:SetCheck(false)
	elseif Format == 1 then
		frame_Display._btn_ScreenShotFormat[chk_Option.SCREENSHOT_BMP]:SetCheck(false)
		frame_Display._btn_ScreenShotFormat[chk_Option.SCREENSHOT_JPG]:SetCheck(true)
		frame_Display._btn_ScreenShotFormat[chk_Option.SCREENSHOT_PNG]:SetCheck(false)	
	elseif Format == 2 then
		frame_Display._btn_ScreenShotFormat[chk_Option.SCREENSHOT_BMP]:SetCheck(false)
		frame_Display._btn_ScreenShotFormat[chk_Option.SCREENSHOT_JPG]:SetCheck(false)
		frame_Display._btn_ScreenShotFormat[chk_Option.SCREENSHOT_PNG]:SetCheck(true)
	end
end

function GameOption_CheckColorBlind( Format )
	if  Format == 0 then
		frame_Display._btn_ColorBlind[chk_Option.COLORBLIND_NONE]:SetCheck(true)
		frame_Display._btn_ColorBlind[chk_Option.COLORBLIND_PROTANOPIA]:SetCheck(false)
		frame_Display._btn_ColorBlind[chk_Option.COLORBLIND_DEUTERANOP]:SetCheck(false)
	elseif Format == 1 then
		frame_Display._btn_ColorBlind[chk_Option.COLORBLIND_NONE]:SetCheck(false)
		frame_Display._btn_ColorBlind[chk_Option.COLORBLIND_PROTANOPIA]:SetCheck(true)
		frame_Display._btn_ColorBlind[chk_Option.COLORBLIND_DEUTERANOP]:SetCheck(false)	
	elseif Format == 2 then
		frame_Display._btn_ColorBlind[chk_Option.COLORBLIND_NONE]:SetCheck(false)
		frame_Display._btn_ColorBlind[chk_Option.COLORBLIND_PROTANOPIA]:SetCheck(false)
		frame_Display._btn_ColorBlind[chk_Option.COLORBLIND_DEUTERANOP]:SetCheck(true)
	end
end

function GameOption_CheckFullScreen()
	local self = chk_Option
	GameOption_SetCurrentScreenMode( self.FULL_SCREEN_IDX)
end
function GameOption_CheckFullScreenWindowed()
	local self = chk_Option
	GameOption_SetCurrentScreenMode( self.FULL_SCREEN_WINDOWED_IDX)
end
function GameOption_CheckWindowed()
	local self = chk_Option
	GameOption_SetCurrentScreenMode( self.WINDOWED_IDX)
end


------------------------------------------------------------
--					화면 해상도 설정 관련
--			화면 해상도만 변경시 바로 적용되지 않는다.
------------------------------------------------------------

function GameOption_InitScreenResolution( screenResolutionIdx )
	local self = chk_Option
	if screenResolutionIdx >= 0 and screenResolutionIdx <= self.SCREEN_RESOLUTION_COUNT then
		self.currentScreenResolutionIdx = screenResolutionIdx
		self.savedScreenResolutionIdx = screenResolutionIdx
		self.appliedScreenResolutionIdx = screenResolutionIdx
	end
end
function GameOption_SetCurrentScreenResolution( screenResolutionIdx )
	-- 가능한 해상도 획득하여 List 구성 후 설정
	if screenResolutionIdx > 0 and screenResolutionIdx <= chk_Option.SCREEN_RESOLUTION_COUNT then
		chk_Option.currentScreenResolutionIdx = screenResolutionIdx
		GameOption_SetScreenResolutionText( screenResolutionIdx )
	end

	GameOption_UpdateOptionChanged()
end
function GameOption_SetScreenResolutionText ( screenResolutionIdx )
	local self = chk_Option
	if screenResolutionIdx > 0 and screenResolutionIdx <= self.SCREEN_RESOLUTION_COUNT then
		local screenResolution = self.screenResolutionList[ screenResolutionIdx ]
		frame_Display._btn_ScrSize:SetText( tostring ( screenResolution.width .." x " .. screenResolution.height ) )

		if( screenResolution.height <= minScaleHeight ) then
			minScaleValue = const_UiScaleValue[1];
			maxScaleValue = const_UiScaleValue[2];
		elseif( screenResolution.height <= midleScaleHeight ) then
			minScaleValue = const_UiScaleValue[1];
			maxScaleValue = const_UiScaleValue[3];
		elseif( screenResolution.height <= HighScaleHeight ) then
			minScaleValue = const_UiScaleValue[1];
			maxScaleValue = const_UiScaleValue[4];
		elseif( screenResolution.height <= MaxScaleHeight ) then
			minScaleValue = const_UiScaleValue[1];
			maxScaleValue = const_UiScaleValue[5];
		else
			minScaleValue = const_UiScaleValue[5];
			maxScaleValue = const_UiScaleValue[6];
		end
		
--[[		
		if (screenResolution.height < 768 ) then
			_btn_UIScale:SetPosX(70)
		elseif ( 1080 < screenResolution.width ) then
			_btn_UIScale:SetPosX( (frame_Display._slide_UIScale:GetSizeX() - _btn_UIScale:GetSizeX()) / 2 )
		else
			local posX = 100 - ((1920 - screenResolution.width) * (100 - 70) / (1920 - 1280))
			posX = (frame_Display._slide_UIScale:GetSizeX() - _btn_UIScale:GetSizeX()) / 100 * (posX - 50)
			_btn_UIScale:SetPosX( posX )
		end
]]--
		
		if isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_KOR ) then
			-- 한국만 스케일을 자동으로 바꾼다.
			GameOption_UIScale_Change()
		end

		if isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_JAP ) then
			-- 일본은 해상도를 넘겨도 스케일을 유지 시켜야 한다.
			GameOption_Fix_UiScale()
		end
	end
end

function GameOption_Fix_UiScale()
	GameOption_SetUIMode( chk_Option.currentCheckUIScale )
end

function GameOption_SetScreenResolutionText_exception ( screenWidth, screenHeight )
	frame_Display._btn_ScrSize:SetText( tostring ( screenWidth .." x " .. screenHeight ) )
end
function GameOption_FindScreenResolutionIdx ( screenWidth, screenHeight )
	local self = chk_Option
	local screenResolutionList = self.screenResolutionList
	for ii = 1, self.SCREEN_RESOLUTION_COUNT do
		if screenResolutionList[ ii ].width == screenWidth and screenResolutionList[ ii ].height == screenHeight then
			return ii
		end
	end
	return 0
end

function GameOption_ScreenResolutionIncrease()
	frame_Display._btn_ScrSize:EraseAllEffect()
	frame_Display._btn_ScrSize:AddEffect( "UI_ButtonLineRight_White", false, 0.0, 0.0 )
	frame_Display._btn_ScrSize:AddEffect( "UI_ButtonLineRight_Blue", false, 0.0, 0.0 )

	GameOption_SetCurrentScreenResolution( chk_Option.currentScreenResolutionIdx + 1 )
end
function GameOption_ScreenResolutionDecrease()
	frame_Display._btn_ScrSize:EraseAllEffect()
	frame_Display._btn_ScrSize:AddEffect( "UI_ButtonLineLeft_White", false, 0.0, 0.0 )
	frame_Display._btn_ScrSize:AddEffect( "UI_ButtonLineLeft_Blue", false, 0.0, 0.0 )

	GameOption_SetCurrentScreenResolution( chk_Option.currentScreenResolutionIdx - 1 )
end


------------------------------------------------------------
-- LUT 화면 필터
------------------------------------------------------------
local LUTRecommandation = -1
local LUTRecommandationName = "Vibrance"

function GameOption_InitLUT( LUT )
	chk_Option.currentLUT = LUT
	chk_Option.savedLUT = LUT
	chk_Option.appliedLUT = LUT
	GameOption_SetLUTText( LUT )
end
function GameOption_SetRecommandationLUT()
	-- 추천값
	if LUTRecommandation == -1 then
		for idx = 0, 30 do
			if getCameraLUTFilterName( idx ) == LUTRecommandationName then
				LUTRecommandation = idx
				break;
			end
		end
	end
	
	local _contrastValue = 0.5 + 0.2		-- +20%
	
	if LUTRecommandation ~= -1 then
		-- Vibrance 설정
		GameOption_SetCurrentLUT( LUTRecommandation )
		
		-- Contrast 설정
		GameOption_SetContrast( _contrastValue )
		frame_Display._slide_Contrast:SetControlPos( _contrastValue * 100 )
	end
end
function GameOption_SetCurrentLUT( LUT )
	chk_Option.currentLUT = LUT
	
	GameOption_SetLUTText( LUT )
	setCameraLUTFilter( LUT )
end
function GameOption_SetLUTText ( LUT )
	local filterName = getCameraLUTFilterName( LUT )
	if filterName == LUTRecommandationName then
		-- VIBRANCE 는 [추천] 멘트 추가
		frame_Display._btn_LUT:SetText( filterName.."  <PAColor0xffffce22>["..PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_RECOMMANDATION" ).."]<PAOldColor>" )
	else
		frame_Display._btn_LUT:SetText( filterName )
	end
end
function GameOption_LUTIncrease()
	frame_Display._btn_LUT:EraseAllEffect()
	frame_Display._btn_LUT:AddEffect( "UI_ButtonLineRight_White", false, 0.0, 0.0 )
	frame_Display._btn_LUT:AddEffect( "UI_ButtonLineRight_Blue", false, 0.0, 0.0 )

	GameOption_SetCurrentLUT( chk_Option.currentLUT + 1 )
end
function GameOption_LUTDecrease()
	frame_Display._btn_LUT:EraseAllEffect()
	frame_Display._btn_LUT:AddEffect( "UI_ButtonLineLeft_White", false, 0.0, 0.0 )
	frame_Display._btn_LUT:AddEffect( "UI_ButtonLineLeft_Blue", false, 0.0, 0.0 )

	GameOption_SetCurrentLUT( chk_Option.currentLUT - 1 )
end

------------------------------------------------------------
--              텍스쳐 품질 설정  관련
-- 적용 버튼과 무관하게 버튼 누를 때마다 변경, seletecTextureQualityIdx 사용 안 함.
------------------------------------------------------------

function GameOption_InitTextureQuality( textureQualityIdx)
	local self = chk_Option
	if textureQualityIdx >= 0 and textureQualityIdx < self.TEXTURE_QUALITY_COUNT then
		self.currentTextureQualityIdx = textureQualityIdx
		self.savedTextureQualityIdx = textureQualityIdx
		self.appliedTextureQualityIdx = textureQualityIdx
	end
end
function GameOption_SetCurrentTextureQuality( textureQualityIdx )
	local self = chk_Option
	if textureQualityIdx >= 0 and textureQualityIdx < self.TEXTURE_QUALITY_COUNT then
		self.currentTextureQualityIdx = textureQualityIdx
		GameOption_SetTextureQualityText(textureQualityIdx)
	end

	GameOption_UpdateOptionChanged()
end
function GameOption_SetTextureQualityText( textureQualityIdx )
	if textureQualityIdx == chk_Option.TEXTURE_QUALITY_HIGH then
		frame_Display._btn_Trxt:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WINDOW_OPTION_HIGH" ) )
	elseif textureQualityIdx == chk_Option.TEXTURE_QUALITY_NORMAL then
		frame_Display._btn_Trxt:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WINDOW_OPTION_MIDDLE" ) )
	elseif textureQualityIdx == chk_Option.TEXTURE_QUALITY_LOW then
		frame_Display._btn_Trxt:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WINDOW_OPTION_LOW" ) )
	end

end

function GameOption_TextureQualityIncrease()
	frame_Display._btn_Trxt:EraseAllEffect()
	frame_Display._btn_Trxt:AddEffect( "UI_ButtonLineRight_White", false, 0.0, 0.0 )
	frame_Display._btn_Trxt:AddEffect( "UI_ButtonLineRight_Blue", false, 0.0, 0.0 )

	local self = chk_Option
	
	local texQuality = self.currentTextureQualityIdx - 1
	if texQuality < 0 then
		texQuality = 0
	end
		
	local validTexQuality = getValidTextureQuality()
	
	if ( texQuality < validTexQuality  ) then
		MessageBox_TextureQualityAlert()
		return
	end
	GameOption_SetCurrentTextureQuality( texQuality )
end

function GameOption_TextureQualityDecrease()
	frame_Display._btn_Trxt:EraseAllEffect()
	frame_Display._btn_Trxt:AddEffect( "UI_ButtonLineLeft_White", false, 0.0, 0.0 )
	frame_Display._btn_Trxt:AddEffect( "UI_ButtonLineLeft_Blue", false, 0.0, 0.0 )

	local self = chk_Option
	GameOption_SetCurrentTextureQuality( self.currentTextureQualityIdx + 1 )
end

function GameOption_TextureQualityApply()
	local self = chk_Option
	
	local texQuality = self.currentTextureQualityIdx - 1
	GameOption_SetCurrentTextureQuality( texQuality )
end

function MessageBox_TextureQualityAlert()
	local	messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_TEXTUREQUALITYALERT_MEMO") -- "해당 옵션을 적용하기에는 그래픽카드 메모리가 부족합니다. 잦은 끊김 혹은 강제 종료 현상이 발생할 수도 있습니다. 그래도 계속하시겠습니까?"  
	local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"), content = messageBoxMemo, functionYes = GameOption_TextureQualityApply, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}	
	
	MessageBox.showMessageBox(messageBoxData)
end
------------------------------------------------------------
--				          그래픽 옵션 설정  관련
------------------------------------------------------------
function GameOption_InitGraphicOption( graphicOptionIdx)
	local self = chk_Option
	if graphicOptionIdx >= 0 and graphicOptionIdx < self.GRAPHIC_OPTION_COUNT then
		self.currentGraphicOptionIdx = graphicOptionIdx
		self.savedGraphicOptionIdx = graphicOptionIdx
		self.appliedGraphicOptionIdx = graphicOptionIdx
	end
end
function GameOption_SetCurrentGraphicOption( graphicOptionIdx )
	local self = chk_Option
	if graphicOptionIdx >= 0 and graphicOptionIdx < self.GRAPHIC_OPTION_COUNT then
		self.currentGraphicOptionIdx = graphicOptionIdx
		GameOption_SetGraphicOptionText( graphicOptionIdx )
	end
	GameOption_GraphicChanged()
	GameOption_UpdateOptionChanged()
end
function GameOption_SetGraphicOptionText( graphicOptionIdx )
	if graphicOptionIdx == chk_Option.GRAPHIC_OPTION_HIGH0 then
		frame_Display._btn_Rndr:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WINDOW_OPTION_VERYHIGH" ) )
	elseif graphicOptionIdx == chk_Option.GRAPHIC_OPTION_HIGH1 then
		frame_Display._btn_Rndr:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WINDOW_OPTION_HIGH" ) )
	elseif graphicOptionIdx == chk_Option.GRAPHIC_OPTION_NORMAL0 then
		frame_Display._btn_Rndr:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WINDOW_OPTION_MIDDLEHIGH" ) )
	elseif graphicOptionIdx == chk_Option.GRAPHIC_OPTION_NORMAL1 then
		frame_Display._btn_Rndr:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WINDOW_OPTION_MIDDLE" ) )
	elseif graphicOptionIdx == chk_Option.GRAPHIC_OPTION_LOW0 then
		frame_Display._btn_Rndr:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WINDOW_OPTION_LOW" ) )
	elseif graphicOptionIdx == chk_Option.GRAPHIC_OPTION_LOW1 then
		frame_Display._btn_Rndr:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WINDOW_OPTION_VERYLOW" ) )
	elseif graphicOptionIdx == chk_Option.GRAPHIC_OPTION_VERYLOW then
		frame_Display._btn_Rndr:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_WINDOW_OPTION_FASTMODE" ) )
	end
end
function GameOption_GraphicOptionIncrease()
	local self = chk_Option
	frame_Display._btn_Rndr:EraseAllEffect()
	frame_Display._btn_Rndr:AddEffect( "UI_ButtonLineRight_White", false, 0.0, 0.0 )
	frame_Display._btn_Rndr:AddEffect( "UI_ButtonLineRight_Blue", false, 0.0, 0.0 )
	
	local nextIndex = self.currentGraphicOptionIdx - 1
	
	-- 추천 세팅
	-- AA, SSAO
	if nextIndex ~= chk_Option.GRAPHIC_OPTION_VERYLOW then
		self.currentCheckAA = true
		frame_Display._btn_AntiAlli:SetCheck( self.currentCheckAA )
		self.currentCheckSSAO = true
		frame_Display._btn_SSAO:SetCheck( self.currentCheckSSAO )
	end
	
	-- DOF
	if nextIndex <= chk_Option.GRAPHIC_OPTION_NORMAL0 then
		self.currentCheckDof = true
		frame_Display._btn_DOF:SetCheck( self.currentCheckDof )
	end
	
	-- Upscale
--	if self.currentGraphicOptionIdx == chk_Option.GRAPHIC_OPTION_VERYLOW then
--		self.currentUpscaleEnable = true
--		frame_Display._btn_UpscaleEnable:SetCheck( self.currentUpscaleEnable )
--	elseif nextIndex < chk_Option.GRAPHIC_OPTION_NORMAL1 then
--		self.currentUpscaleEnable = false
--		frame_Display._btn_UpscaleEnable:SetCheck( self.currentUpscaleEnable )
--	end
	
	GameOption_SetCurrentGraphicOption( nextIndex )
end
function GameOption_GraphicOptionDecrease()
	local self = chk_Option
	frame_Display._btn_Rndr:EraseAllEffect()
	frame_Display._btn_Rndr:AddEffect( "UI_ButtonLineLeft_White", false, 0.0, 0.0 )
	frame_Display._btn_Rndr:AddEffect( "UI_ButtonLineLeft_Blue", false, 0.0, 0.0 )
	
	local nextIndex = self.currentGraphicOptionIdx + 1
	
	-- 추천 세팅
	-- AA, SSAO
	if nextIndex == chk_Option.GRAPHIC_OPTION_VERYLOW then
		self.currentCheckAA = false
		frame_Display._btn_AntiAlli:SetCheck( self.currentCheckAA )
		self.currentCheckSSAO = false
		frame_Display._btn_SSAO:SetCheck( self.currentCheckSSAO )
	end
	
	-- DOF
	if nextIndex > chk_Option.GRAPHIC_OPTION_NORMAL0 then
		self.currentCheckDof = false		
		frame_Display._btn_DOF:SetCheck( self.currentCheckDof )
	end
	
	-- Upscale
--	if nextIndex == chk_Option.GRAPHIC_OPTION_VERYLOW then
--		self.currentUpscaleEnable = false
--		frame_Display._btn_UpscaleEnable:SetCheck( self.currentUpscaleEnable )
--	elseif nextIndex >= chk_Option.GRAPHIC_OPTION_NORMAL1 then
--		self.currentUpscaleEnable = true
--		frame_Display._btn_UpscaleEnable:SetCheck( self.currentUpscaleEnable )
--	end
	
	GameOption_SetCurrentGraphicOption( nextIndex )
end
function GameOption_InitGraphicCustomOption( gameOptionSetting )
	local self = chk_Option

	local dof = gameOptionSetting:getDof()
	self.currentCheckDof = dof
	self.appliedCheckDof = dof
	self.savedCheckDof = dof

	local aa = gameOptionSetting:getAntiAliasing()
	self.currentCheckAA = aa
	self.appliedCheckAA = aa
	self.savedCheckAA = aa
	
	local ul = gameOptionSetting:getGraphicUltra()
	self.currentCheckUltra = ul
	self.appliedCheckUltra = ul
	self.savedCheckUltra = ul

	local lb = gameOptionSetting:getLensBlood()
	self.currentCheckLensBlood = lb
	self.appliedCheckLensBlood = lb
	self.savedCheckLensBlood = lb
	
	local be = gameOptionSetting:getBloodEffect() == 2	-- 0: Off, 1:Effect Only, 2: Full
	self.currentCheckBloodEffect = be
	self.appliedCheckBloodEffect = be
	self.savedCheckBloodEffect = be
	
	local ssao = gameOptionSetting:getSSAO()
	self.currentCheckSSAO = ssao
	self.appliedCheckSSAO = ssao
	self.savedCheckSSAO = ssao
	
	local tess = gameOptionSetting:getTessellation()
	self.currentCheckTessellation = tess
	self.appliedCheckTessellation = tess
	self.savedCheckTessellation = tess
	
	local fi = gameOptionSetting:getPostFilter() == 2	-- 0: Off, 1:Sharpen Only, 2: Sharpen + Blur
	self.currentCheckPostFilter = fi
	self.appliedCheckPostFilter = fi
	self.savedCheckPostFilter = fi
	
	local ce = gameOptionSetting:getCharacterEffect()
	self.currentCheckCharacterEffect = ce
	self.appliedCheckCharacterEffect = ce
	self.savedCheckCharacterEffect = ce
end
function GameOption_GraphicChanged()
	local self = chk_Option
	if self.currentCheckUltra then
		GameOption_SetGraphicOptionText( chk_Option.GRAPHIC_OPTION_HIGH0 )
		
		frame_Display._btn_Rndr:SetEnable( false )
		frame_Display._btn_Rndr_L:SetEnable( false )
		frame_Display._btn_Rndr_R:SetEnable( false )
		frame_Display._btn_Rndr:SetMonoTone( true )
		frame_Display._btn_Rndr_L:SetMonoTone( true )
		frame_Display._btn_Rndr_R:SetMonoTone( true )
	else
		GameOption_SetGraphicOptionText( self.currentGraphicOptionIdx )
		
		frame_Display._btn_Rndr:SetEnable( true )
		frame_Display._btn_Rndr_L:SetEnable( true )
		frame_Display._btn_Rndr_R:SetEnable( true )
		frame_Display._btn_Rndr:SetMonoTone( false )
		frame_Display._btn_Rndr_L:SetMonoTone( false )
		frame_Display._btn_Rndr_R:SetMonoTone( false )
	end
	
	-- SSAO 는 낮음에서 지원안함
	--if self.currentGraphicOptionIdx < chk_Option.GRAPHIC_OPTION_LOW0 or self.currentCheckUltra then
	if self.currentGraphicOptionIdx < chk_Option.GRAPHIC_OPTION_VERYLOW or self.currentCheckUltra then	
		frame_Display._btn_SSAO:SetEnable( true )
		frame_Display._btn_SSAO:SetMonoTone( false )
	else
		frame_Display._btn_SSAO:SetEnable( false )
		frame_Display._btn_SSAO:SetMonoTone( true )
	end
	
	-- Tessellation 은 높음 이상에서 지원
	if ( self.currentGraphicOptionIdx < chk_Option.GRAPHIC_OPTION_NORMAL0 or self.currentCheckUltra ) and getDX11Feature() then
		frame_Display._btn_Tessellation:SetEnable( true )
		frame_Display._btn_Tessellation:SetMonoTone( false )
	else
		frame_Display._btn_Tessellation:SetEnable( false )
		frame_Display._btn_Tessellation:SetMonoTone( true )
	end
		
end
function GameOption_SetGraphicCustomOption()
	local self = chk_Option
	frame_Display._btn_DOF:SetCheck( self.currentCheckDof )
	frame_Display._btn_AntiAlli:SetCheck( self.currentCheckAA )
	frame_Display._btn_Ultra:SetCheck( self.currentCheckUltra )
	frame_Display._btn_LensBlood:SetCheck( self.currentCheckLensBlood )
	frame_Display._btn_BloodEffect:SetCheck( self.currentCheckBloodEffect )
	
	frame_Display._btn_SSAO:SetCheck( self.currentCheckSSAO )
	frame_Display._btn_Tessellation:SetCheck( self.currentCheckTessellation )
	frame_Display._btn_PostFilter:SetCheck( self.currentCheckPostFilter )
	frame_Display._btn_CharacterEffect:SetCheck( self.currentCheckCharacterEffect )
	
	GameOption_GraphicChanged()
end
function GameOption_CheckDof()
	local self = chk_Option
	local check = frame_Display._btn_DOF:IsCheck()
	self.currentCheckDof = check
	GameOption_UpdateOptionChanged()
end
function GameOption_CheckSelfPlayerOnlyEffect( )
	local self = chk_Option
	local check = frame_Display._btn_SelfPlayerOnlyEffect:IsCheck()
	self.currentSelfPlayerOnlyEffect = check
	GameOption_UpdateOptionChanged()
end
function GameOption_CheckNearestPlayerOnlyEffect( )
	local self = chk_Option
	local check = frame_Display._btn_NearestPlayerOnlyEffect:IsCheck()
	self.currentNearestPlayerOnlyEffect = check
	GameOption_UpdateOptionChanged()
end
function GameOption_CheckSelfPlayerOnlyLantern( )
	local self = chk_Option
	local check = frame_Display._btn_SelfPlayerOnlyLantern:IsCheck()
	self.currentSelfPlayerOnlyLantern = check
	GameOption_UpdateOptionChanged()
end
function GameOption_CheckAA()
	local self = chk_Option
	local check = frame_Display._btn_AntiAlli:IsCheck()
	self.currentCheckAA = check
	GameOption_UpdateOptionChanged()
end
function GameOption_CheckSSAO()
	local self = chk_Option
	local check = frame_Display._btn_SSAO:IsCheck()
	self.currentCheckSSAO = check
	GameOption_UpdateOptionChanged()
end
function GameOption_CheckTessellation()
	local self = chk_Option
	local check = frame_Display._btn_Tessellation:IsCheck()
	self.currentCheckTessellation = check
	GameOption_UpdateOptionChanged()
end
function GameOption_CheckPostFilter()
	local self = chk_Option
	local check = frame_Display._btn_PostFilter:IsCheck()
	self.currentCheckPostFilter = check
	GameOption_UpdateOptionChanged()
end
function GameOption_CheckCharacterEffect()
	local self = chk_Option
	local check = frame_Display._btn_CharacterEffect:IsCheck()
	self.currentCheckCharacterEffect = check
	GameOption_UpdateOptionChanged()
end
function GameOption_CheckUltra()
	local self = chk_Option
	local check = frame_Display._btn_Ultra:IsCheck()
	self.currentCheckUltra = check
	GameOption_GraphicChanged()
	GameOption_UpdateOptionChanged()
end
function GameOption_CheckLensBlood()
	local self = chk_Option
	local check = frame_Display._btn_LensBlood:IsCheck()
	self.currentCheckLensBlood = check
	GameOption_UpdateOptionChanged()
end
function GameOption_CheckBloodEffect()
	local self = chk_Option
	local check = frame_Display._btn_BloodEffect:IsCheck()
	self.currentCheckBloodEffect = check
	GameOption_UpdateOptionChanged()
end

function GameOption_RefreshFPSText()
	local value = math.floor( getFPS() )
	if value < 20 then
		frame_Display._txt_FPS:SetText( "FPS: " .. "<PAColor0xfff25221>" .. tostring( value ) .. "<PAOldColor>" )
	else
		frame_Display._txt_FPS:SetText( "FPS: " .. "<PAColor0xff00f281>" .. tostring( value ) .. "<PAOldColor>" )
	end
end


function GameOption_InitSleepMode( isSleepModeEnable )
	local self = chk_Option
	local check = isSleepModeEnable
	frame_Display._btn_SleepModeEnable:SetCheck(check)
	self.currentSleepModeEnable = check
	self.savedSleepModeEnable = check
	self.appliedSleepModeEnable = check
	GameOption_UpdateOptionChanged()
end
function GameOption_CheckSleepMode( )
	local self = chk_Option
	local check = frame_Display._btn_SleepModeEnable:IsCheck()
	self.currentSleepModeEnable = check
	GameOption_UpdateOptionChanged()
end

------------------------------------------------------------
--					        CropMode 옵션 설정  관련
------------------------------------------------------------
function GameOption_InitUpscale( isUpscaleEnable )
	local self = chk_Option
	local check = isUpscaleEnable
	frame_Display._btn_UpscaleEnable:SetCheck(check)
	self.currentUpscaleEnable = check
	self.savedUpscaleEnable = check
	self.appliedUpscaleEnable = check
	GameOption_UpdateOptionChanged()
end
function GameOption_CheckUpscale( )
	local self = chk_Option
	local check = frame_Display._btn_UpscaleEnable:IsCheck()
	self.currentUpscaleEnable = check
	GameOption_UpdateOptionChanged()
end

function GameOption_InitCropMode( isEnable, scaleX, scaleY )
	local self = chk_Option	
	frame_Display._btn_CropModeEnable:SetCheck( isEnable )
	self.currentCropModeEnable = isEnable
	self.savedCropModeEnable = isEnable
	self.appliedCropModeEnable = isEnable
	
	self.currentCropModeScaleX = scaleX
	self.savedCropModeScaleX = scaleX
	self.appliedCropModeScaleX = scaleX
	
	self.currentCropModeScaleY = scaleY
	self.savedCropModeScaleY = scaleY
	self.appliedCropModeScaleY = scaleY
	
	frame_Display._slide_CropModeScaleX:SetControlPos( scaleX * 200 - 100 ) -- 50~100
	frame_Display._slide_CropModeScaleY:SetControlPos( scaleY * 200 - 100 )
	-- frame_Display._slide_CropModeScaleX:SetEnable( check )
	-- frame_Display._slide_CropModeScaleY:SetEnable( check )
	
	GameOption_UpdateOptionChanged()
end

function GameOption_CheckCropMode()
	local self = chk_Option
	local check = frame_Display._btn_CropModeEnable:IsCheck()
	self.currentCropModeEnable = check
	GameOption_UpdateOptionChanged()
	
	-- frame_Display._slide_CropModeScaleX:SetEnable( check )
	-- frame_Display._slide_CropModeScaleY:SetEnable( check )
end

-- slider X
function GameOption_SetCropModeScaleX( scale )
	local self = chk_Option
	local convertedScale = 0.5 + scale * 0.5
	self.currentCropModeScaleX = convertedScale
	self.appliedCropModeScaleX = self.currentCropModeScaleX
	setCropModeScaleX( convertedScale )	-- sendClient
end
function GameOption_CropModeScaleX_slider()
	local ratio = frame_Display._slide_CropModeScaleX:GetControlPos()	-- 0~1
	GameOption_SetCropModeScaleX( ratio )
end
function GameOption_CropModeScaleX_button()
	local ratio = _btn_CropModeScaleX:GetPosX() / ( frame_Display._slide_CropModeScaleX:GetSizeX() - _btn_CropModeScaleX:GetSizeX() ) -- 대략 0~1
	GameOption_SetCropModeScaleX( ratio )
end

-- slider Y
function GameOption_SetCropModeScaleY( scale )
	local self = chk_Option
	local convertedScale = 0.5 + scale * 0.5
	self.currentCropModeScaleY = convertedScale
	self.appliedCropModeScaleY = self.currentCropModeScaleY
	setCropModeScaleY( convertedScale )	-- sendClient
end
function GameOption_CropModeScaleY_slider()
	local ratio = frame_Display._slide_CropModeScaleY:GetControlPos()	-- 0~1
	GameOption_SetCropModeScaleY( ratio )
end
function GameOption_CropModeScaleY_button()
	local ratio = _btn_CropModeScaleY:GetPosX() / ( frame_Display._slide_CropModeScaleY:GetSizeX() - _btn_CropModeScaleY:GetSizeX() ) -- 대략 0~1
	GameOption_SetCropModeScaleY( ratio )
end

------------------------------------------------------------
--				 CAMERA POS 설정 관련
------------------------------------------------------------
function GameOption_InitCameraPos( posPowerValue ) -- 0~1
	local self = chk_Option
	self.currentCheckCameraPosPower = posPowerValue
	self.savedCheckCameraPosPower = posPowerValue
	self.appliedCheckCameraPosPower = posPowerValue

	frame_Display._slide_CameraPos:SetControlPos( posPowerValue * 100 ) -- 0~100
end

function GameOption_SetCameraPosValueText( posPowerValue )	-- 0~1
	local value = math.floor( posPowerValue * 100 + 0.5 - 50 )
	frame_Display._txt_CameraPos:SetText( GetStr_Option[22].." ( <PAColor0xffbcf281>" ..tostring ( value ).. "% <PAOldColor>) " )
end

------------------------------------------------------------
--				CAMERA FOV 설정 관련
------------------------------------------------------------
function GameOption_InitCameraFov( fovPowerValue ) -- 0~1
	local self = chk_Option
	self.currentCheckCameraFovPower = fovPowerValue
	self.savedCheckCameraFovPower = fovPowerValue
	self.appliedCheckCameraFovPower = fovPowerValue

	frame_Display._slide_CameraFov:SetControlPos( fovPowerValue * 100 ) -- 0~100
end

function GameOption_SetCameraFovValueText( fovPowerValue )	-- 0~1
	local value = math.floor( posPowerValue * 100 + 0.5 - 50 )
	frame_Display._txt_CameraFov:SetText( GetStr_Option[23].." ( <PAColor0xffbcf281>" ..tostring ( value ).. "% <PAOldColor>) " )
end

------------------------------------------------------------
--					        감마 옵션 설정  관련
------------------------------------------------------------
function GameOption_InitGamma( gammaValue ) -- 0~1
	local self = chk_Option
	self.currentGammaValue = gammaValue
	self.savedGammaValue = gammaValue
	self.appliedGammaValue = gammaValue

	frame_Display._slide_Gamma:SetControlPos( gammaValue * 100 ) -- 0~100
end

function GameOption_SetGammaValueText( gammaValue )	-- 0~1
	local value = math.floor( gammaValue * 100 + 0.5 - 50 )
	frame_Display._txt_Gamma:SetText( GetStr_Option[4].." ( <PAColor0xffbcf281>" ..tostring ( value ).. "% <PAOldColor>) " )
end

function GameOption_SetGamma( gammaValue )
	local self = chk_Option
	self.currentGammaValue = gammaValue
	GameOption_SetGammaValueText( gammaValue )
	setGammaValue( gammaValue )	-- sendClient

	GameOption_UpdateOptionChanged()
end

function GameOption_ChangeGamma_slider()
	local ratio = frame_Display._slide_Gamma:GetControlPos()	-- 0~1
	GameOption_SetGamma( ratio )
end

function GameOption_ChangeGamma_button()
	local ratio = _btn_Gamma:GetPosX() / ( frame_Display._slide_Gamma:GetSizeX() - _btn_Gamma:GetSizeX() ) -- 대략 0~1
	GameOption_SetGamma( ratio )
end

------------------------------------------------------------
--					        대비 옵션 설정  관련
------------------------------------------------------------
function GameOption_InitContrast( contrastValue ) -- 0~1
	local self = chk_Option
	self.currentContrastValue = contrastValue
	self.savedContrastValue = contrastValue
	self.appliedContrastValue = contrastValue

	frame_Display._slide_Contrast:SetControlPos( contrastValue * 100 ) -- 0~100
end

function GameOption_SetContrastValueText( contrastValue )	-- 0~1
	local value = math.floor( contrastValue * 100 + 0.5 - 50 )
	frame_Display._txt_Contrast:SetText( GetStr_Option[21].." ( <PAColor0xffbcf281>" ..tostring ( value ).. "% <PAOldColor>) " )
end

function GameOption_SetContrast( contrastValue )
	local self = chk_Option
	self.currentContrastValue = contrastValue
	GameOption_SetContrastValueText( contrastValue )
	setContrastValue( contrastValue )	-- sendClient

	GameOption_UpdateOptionChanged()
end

function GameOption_ChangeContrast_slider()
	local ratio = frame_Display._slide_Contrast:GetControlPos()	-- 0~1
	GameOption_SetContrast( ratio )
end

function GameOption_ChangeContrast_button()
	local ratio = _btn_Contrast:GetPosX() / ( frame_Display._slide_Contrast:GetSizeX() - _btn_Contrast:GetSizeX() ) -- 대략 0~1
	GameOption_SetContrast( ratio )
end


function GameOption_InitFov( fovValue ) -- 40~70
	local self = chk_Option
	self.currentFovValue = fovValue
	self.savedFovValue = fovValue
	self.appliedFovValue = fovValue


	if( fovValue < 40 ) then
		fovValue = 40
	elseif( fovValue > 70 ) then
		fovValue = 70
	end

	local sliderValue = ( fovValue - 40 ) / 30  * 100
	frame_Display._slide_Fov:SetControlPos( sliderValue ) -- 0~100
end

function GameOption_SetFovValueText( fovValue )	-- 40~60
	local value = math.floor( fovValue + 0.5 )
	frame_Display._txt_Fov:SetText( GetStr_Option[24].." ( <PAColor0xffbcf281>" ..tostring ( value ).. " <PAOldColor>) " )
end

function GameOption_SetFov( fovValue )
	local self = chk_Option
	self.currentFovValue = fovValue
	GameOption_SetFovValueText( fovValue )
	setFov( fovValue )	-- sendClient

	GameOption_UpdateOptionChanged()
end

function GameOption_ChangeFov_slider()
	local fov = 40  + 30 * frame_Display._slide_Fov:GetControlPos()
	GameOption_SetFov( fov )
end

function GameOption_ChangeFov_button()
	local ratio = _btn_Fov:GetPosX() / ( frame_Display._slide_Fov:GetSizeX() - _btn_Fov:GetSizeX() ) -- 대략 0~1
	local fov = 40  + 30 * ratio
	GameOption_SetFov( fov )
end
------------------------------------------------------------
--					          UI 옵션 설정 관련
------------------------------------------------------------
function GameOption_SetUIMode( uiScale )
	local uiScale_Slider	= uiScale
	local uiScale_Percent = (uiScale * 100)

--	frame_Display._slide_UIScale:SetControlPos((uiScale_Slider - 0.5) * 100 )
	local interval = maxScaleValue - minScaleValue;
	
	frame_Display._slide_UIScale:SetControlPos(	( uiScale_Percent - minScaleValue ) / interval * 100 );	
	frame_Display._txt_UIScale:SetText( GetStr_Option[5].." ( <PAColor0xffbcf281>" ..string.format("%.0f", uiScale_Percent) .."% <PAOldColor>)" )
end
--[[
function GameOption_UIScale_Change()
--	local btn_posX = (_btn_UIScale:GetPosX() / ( frame_Display._slide_UIScale:GetSizeX() - _btn_UIScale:GetSizeX() )) -- 대략 0~1
--	chk_Option.currentCheckUIScale = btn_posX + 0.5
	frame_Display._txt_UIScale:SetText( GetStr_Option[5].." ( <PAColor0xffbcf281>" ..string.format("%.0f", chk_Option.currentCheckUIScale * 100) .."% <PAOldColor>)" )
	
	local interval = maxScaleValue - minScaleValue;
	frame_Display._slide_UIScale:SetInterval( interval );
	frame_Display._slide_UIScale:SetControlPos(0);
	chk_Option.currentCheckUIScale = ( minScaleValue + ( interval * 0.5 ) ) * 0.01;
	frame_Display._txt_UIScale:SetText( GetStr_Option[5].." ( <PAColor0xffbcf281>" ..string.format("%.0f", chk_Option.currentCheckUIScale * 100) .."% <PAOldColor>)" )
	
	frame_Display._txt_UIScaleLow:SetText( tostring( minScaleValue ) )
	frame_Display._txt_UIScaleMidle:SetText( tostring( maxScaleValue * 0.5 ) )
	frame_Display._txt_UIScaleHigh:SetText( tostring( maxScaleValue ) )

	local slide_posX = frame_Display._slide_UIScale:GetControlPos()
	local interval = maxScaleValue - minScaleValue
	chk_Option.currentCheckUIScale = ( minScaleValue + ( interval * slide_posX ) ) * 0.01;
--	chk_Option.currentCheckUIScale = slide_posX + 0.5
	frame_Display._txt_UIScale:SetText( GetStr_Option[5].." ( <PAColor0xffbcf281>" ..string.format("%.0f", chk_Option.currentCheckUIScale * 100) .."% <PAOldColor>)" )
end
]]--
function GameOption_UIScale_Change()
	local slide_posX = frame_Display._slide_UIScale:GetControlPos()
	local interval = maxScaleValue - minScaleValue
	
	frame_Display._txt_UIScaleLow:SetText( tostring( minScaleValue ) )
	frame_Display._txt_UIScaleMidle:SetText( tostring( minScaleValue + ( interval * 0.5 ) ) )
	frame_Display._txt_UIScaleHigh:SetText( tostring( maxScaleValue ) )

	chk_Option.currentCheckUIScale = ( minScaleValue + ( interval * slide_posX ) ) * 0.01;
	-- 소수점의 오차범위 때문에, 3번째 자리에서 올림한다.
	chk_Option.currentCheckUIScale = math.floor( ( chk_Option.currentCheckUIScale + 0.005 ) * 100 ) / 100;
--	chk_Option.currentCheckUIScale = slide_posX + 0.5
	frame_Display._txt_UIScale:SetText( GetStr_Option[5].." ( <PAColor0xffbcf281>" ..string.format("%.0f", chk_Option.currentCheckUIScale * 100) .."% <PAOldColor>)" )
end
-- 메시지 뿌리는 
function GameOption_InitSystemNotify()
	frame_Game._btn_Alert_Region			:SetCheck(ToClient_GetMessageFilter(0))
	frame_Game._btn_Alert_TerritoryTrade	:SetCheck(ToClient_GetMessageFilter(1))
	frame_Game._btn_Alert_RoyalTrade		:SetCheck(ToClient_GetMessageFilter(2))
	frame_Game._btn_Alert_Fitness			:SetCheck(ToClient_GetMessageFilter(3))
	frame_Game._btn_Alert_TerritoryWar		:SetCheck(ToClient_GetMessageFilter(4))
	frame_Game._btn_Alert_GuildWar			:SetCheck(ToClient_GetMessageFilter(5))
	frame_Game._btn_Alert_PlayerGotItem		:SetCheck(ToClient_GetMessageFilter(6))
	frame_Game._btn_Alert_ItemMarket		:SetCheck(ToClient_GetMessageFilter(7))
	frame_Game._btn_Alert_LifeLevUp			:SetCheck(ToClient_GetMessageFilter(8))
	frame_Game._btn_Alert_GuildQuest		:SetCheck(ToClient_GetMessageFilter(9))
	frame_Game._btn_Alert_NearMonster		:SetCheck(ToClient_GetMessageFilter(10))

end

------------------------------------------------------------
--					        사운드 옵션 설정 관련
------------------------------------------------------------
function GameOption_InitSound( enableMusic, enableSound, enableEnvSound, hitFxType, masterVolume, fxVolume, dlgVolume, envVolume, musicVolume, hitFxWeight, otherPlayerVolume, riddingMusic, combatMusic, isVoiceChatOnOff, whisperMusic, voiceMicVolume, voiceSpeakerVolume, voiceNoiseControl, TraySound )
	local self = chk_Option
	--	save data
	self.currentMaster = masterVolume
	self.appliedMaster = masterVolume
	self.savedMaster = masterVolume

	self.currentMusic = musicVolume
	self.appliedMusic = musicVolume
	self.savedMusic = musicVolume

	self.currentFxSound = fxVolume
	self.appliedFxSound = fxVolume
	self.savedFxSound = fxVolume

	self.currentEnvSound = envVolume
	self.appliedEnvSound = envVolume
	self.savedEnvSound = envVolume

	self.currentDlgSound = dlgVolume
	self.appliedDlgSound = dlgVolume
	self.savedDlgSound = dlgVolume

	self.currentCheckMusic = enableMusic
	self.appliedCheckMusic = enableMusic
	self.savedCheckMusic = enableMusic

	self.currentCheckSound			= enableSound
	self.appliedCheckSound			= enableSound
	self.savedCheckSound			= enableSound

	self.currentCheckEnvSound		= enableEnvSound
	self.appliedCheckEnvSound		= enableEnvSound
	self.savedCheckEnvSound			= enableEnvSound

	self.currentCheckRiddingMusic	= riddingMusic
	self.appliedCheckRiddingMusic	= riddingMusic
	self.savedCheckRiddingMusic		= riddingMusic

	self.currentCheckWhisperMusic	= whisperMusic
	self.appliedCheckWhisperMusic	= whisperMusic
	self.savedCheckWhisperMusic		= whisperMusic

	self.currentCheckTraySoundOnOff	= TraySound
	self.appliedCheckTraySoundOnOff	= TraySound
	self.savedCheckTraySoundOnOff	= TraySound

	self.currentHitFxWeight			= hitFxWeight
	self.appliedHitFxWeight			= hitFxWeight
	self.savedHitFxWeight			= hitFxWeight

	self.currentPlayerVolume		= otherPlayerVolume
	self.appliedPlayerVolume		= otherPlayerVolume
	self.savedPlayerVolume			= otherPlayerVolume

	self.currentCheckCombatMusic	= combatMusic
	self.appliedCheckCombatMusic	= combatMusic
	self.savedCheckCombatMusic		= combatMusic

	frame_Sound._slide_TotalVol:SetControlPos(masterVolume)	-- 0~100
	frame_Sound._slide_MusicVol:SetControlPos(musicVolume)
	frame_Sound._slide_FxVol:SetControlPos(fxVolume)
	frame_Sound._slide_EnvFxVol:SetControlPos(envVolume)
	frame_Sound._slide_VoiceVol:SetControlPos(dlgVolume)
	frame_Sound._slide_hitFxWeightVolume:SetControlPos(hitFxWeight)
	frame_Sound._slide_otherPlayerVolume:SetControlPos(otherPlayerVolume)

	frame_Sound._btn_MusicOnOff:SetCheck(enableMusic)
	frame_Sound._btn_FXOnOff:SetCheck(enableSound)
	frame_Sound._btn_EnvFXOnOff:SetCheck(enableEnvSound)

	frame_Sound._btn_RiddingOnOff:SetCheck(riddingMusic)
	frame_Sound._btn_WhisperOnOff:SetCheck(whisperMusic)
	frame_Sound._btn_TraySoundOnOff:SetCheck(TraySound)

	frame_Sound._btn_CombatAllwaysOff			:SetCheck( CppEnums.BattleSoundType.Sound_NotUse	== combatMusic )
	frame_Sound._btn_CombatAllwaysOn			:SetCheck( CppEnums.BattleSoundType.Sound_Always	== combatMusic )
	frame_Sound._btn_CombatAllwaysLowOff		:SetCheck( CppEnums.BattleSoundType.Sound_Nomal		== combatMusic )
end

function GameOption_SetVolumeText( masterVolume, fxVolume, dlgVolume, envVolume, musicVolume, hitFxVolume, hitFxWeight, otherplayerVolume )
	local master = math.floor( masterVolume + 0.5 )
	local music = math.floor( musicVolume + 0.5 )
	local fx = math.floor( fxVolume + 0.5 )
	local env = math.floor( envVolume + 0.5 )
	local dlg = math.floor( dlgVolume + 0.5 )
	local hitFx = math.floor( hitFxVolume + 0.5 )
	local hitFxW = math.floor( hitFxWeight + 0.5 )
	local otherVolume = math.floor( otherplayerVolume + 0.5 )

	frame_Sound._txt_TotalVol:SetText( GetStr_Option[6].." ( <PAColor0xffbcf281>" .. master .. "% <PAOldColor>)" )
	frame_Sound._txt_MusicVol:SetText( GetStr_Option[7].." ( <PAColor0xffbcf281>" .. music .. "% <PAOldColor>)" )
	frame_Sound._txt_FxVol:SetText( GetStr_Option[8].." ( <PAColor0xffbcf281>" .. fx .. "% <PAOldColor>)" )
	frame_Sound._txt_EnvFxVol:SetText( GetStr_Option[9].." ( <PAColor0xffbcf281>" .. env .. "% <PAOldColor>)" )
	frame_Sound._txt_VoiceVol:SetText( GetStr_Option[10].." ( <PAColor0xffbcf281>" .. dlg .. "% <PAOldColor>)" )
	frame_Sound._txt_hitFxVolume:SetText( GetStr_Option[18].." ( <PAColor0xffbcf281>" .. hitFx .. "% <PAOldColor>)" )
	frame_Sound._txt_hitFxWeightVolume:SetText( GetStr_Option[19].." ( <PAColor0xffbcf281>" .. hitFxW .. "% <PAOldColor>)" )
	frame_Sound._txt_otherPlayerVolume:SetText( GetStr_Option[20].." ( <PAColor0xffbcf281>" .. otherVolume .. "% <PAOldColor>)" )
end

function GameOption_SetVolume( masterVolume, fxVolume, dlgVolume, envVolume, musicVolume, hitFxVolume, hitFxWeight, otherVolume )
	local self = chk_Option

	self.currentMaster = masterVolume
	self.currentMusic = musicVolume
	self.currentFxSound = fxVolume
	self.currentEnvSound = envVolume
	self.currentDlgSound = dlgVolume
	self.currentHitFxVolume = hitFxVolume
	self.currentHitFxWeight = hitFxWeight
	self.currentPlayerVolume = otherVolume


	GameOption_SetVolumeText( masterVolume, fxVolume, dlgVolume, envVolume, musicVolume, hitFxVolume, hitFxWeight, otherVolume )

	--setVolume( masterVolume, fxVolume, dlgVolume, envVolume, musicVolume, hitFxVolume )	--	sendClient 파라메터 순서 잘 봐야함
	_volumeParam.master = masterVolume
	_volumeParam.fx = fxVolume
	_volumeParam.dlg = dlgVolume
	_volumeParam.env = envVolume
	_volumeParam.music = musicVolume
	_volumeParam.hitFx = hitFxVolume
	_volumeParam.otherPlayerVolume = otherVolume
	_volumeParam.hitFxWeight = hitFxWeight
	setVolumeParam(_volumeParam)
	
	GameOption_UpdateOptionChanged()
end

function GameOption_SetEnableSound( enableMusic, enableSound, enableEnvSound, hitFxType )
	local self = chk_Option
	self.currentCheckMusic = enableMusic
	self.currentCheckSound = enableSound
	self.currentCheckEnvSound = enableEnvSound
	--self.currentHitFxType = hitFxType

	setEnableSound( enableSound, enableMusic, enableEnvSound, nil )				--	sendClient
	GameOption_UpdateOptionChanged()
end

function GameOption_Master_slider()	-- master input
	local self = chk_Option
	local volume = frame_Sound._slide_TotalVol:GetControlPos() * 100
	GameOption_SetVolume( volume, self.currentFxSound, self.currentDlgSound, self.currentEnvSound, self.currentMusic, self.currentHitFxVolume, self.currentHitFxWeight, self.currentPlayerVolume )
end
function GameOption_Master_button()
	local self = chk_Option
	local volume = (_btn_TotalVol:GetPosX() / ( frame_Sound._slide_TotalVol:GetSizeX() - _btn_TotalVol:GetSizeX() )) * 100 -- 대략 0~1
	GameOption_SetVolume( volume, self.currentFxSound, self.currentDlgSound, self.currentEnvSound, self.currentMusic, self.currentHitFxVolume, self.currentHitFxWeight, self.currentPlayerVolume )
end

function GameOption_Music_slider()	-- music input
	local self = chk_Option
	local volume = frame_Sound._slide_MusicVol:GetControlPos() * 100
	GameOption_SetVolume( self.currentMaster, self.currentFxSound, self.currentDlgSound, self.currentEnvSound, volume, self.currentHitFxVolume, self.currentHitFxWeight, self.currentPlayerVolume )
end
function GameOption_Music_button()
	local self = chk_Option
	local volume = (_btn_MusicVol:GetPosX() / ( frame_Sound._slide_MusicVol:GetSizeX() - _btn_MusicVol:GetSizeX() )) * 100 -- 대략 0~1
	GameOption_SetVolume( self.currentMaster, self.currentFxSound, self.currentDlgSound, self.currentEnvSound, volume, self.currentHitFxVolume, self.currentHitFxWeight, self.currentPlayerVolume )
end

function GameOption_FxSound_slider()	-- fx input
	local self = chk_Option
	local volume = frame_Sound._slide_FxVol:GetControlPos() * 100
	GameOption_SetVolume( self.currentMaster, volume, self.currentDlgSound, self.currentEnvSound, self.currentMusic, self.currentHitFxVolume, self.currentHitFxWeight, self.currentPlayerVolume )
end
function GameOption_FxSound_button()
	local self = chk_Option
	local volume = (_btn_FxVol:GetPosX() / ( frame_Sound._slide_FxVol:GetSizeX() - _btn_FxVol:GetSizeX() )) * 100 -- 대략 0~1
	GameOption_SetVolume( self.currentMaster, volume, self.currentDlgSound, self.currentEnvSound, self.currentMusic, self.currentHitFxVolume, self.currentHitFxWeight, self.currentPlayerVolume )
end

function GameOption_EnvSound_slider()	-- env input
	local self = chk_Option
	local volume = frame_Sound._slide_EnvFxVol:GetControlPos() * 100
	GameOption_SetVolume( self.currentMaster, self.currentFxSound, self.currentDlgSound, volume, self.currentMusic, self.currentHitFxVolume, self.currentHitFxWeight, self.currentPlayerVolume )
end
function GameOption_EnvSound_button()
	local self = chk_Option
	local volume = (_btn_EnvFxVol:GetPosX() / ( frame_Sound._slide_EnvFxVol:GetSizeX() - _btn_EnvFxVol:GetSizeX() )) * 100 -- 대략 0~1
	GameOption_SetVolume( self.currentMaster, self.currentFxSound, self.currentDlgSound, volume, self.currentMusic, self.currentHitFxVolume, self.currentHitFxWeight, self.currentPlayerVolume )
end

function GameOption_DlgSound_slider()	-- dlg input
	local self = chk_Option
	local volume = frame_Sound._slide_VoiceVol:GetControlPos() * 100
	GameOption_SetVolume( self.currentMaster, self.currentFxSound, volume, self.currentEnvSound,  self.currentMusic, self.currentHitFxVolume, self.currentHitFxWeight, self.currentPlayerVolume )
end
function GameOption_DlgSound_button()
	local self = chk_Option
	local volume = (_btn_VoiceVol:GetPosX() / ( frame_Sound._slide_VoiceVol:GetSizeX() - _btn_VoiceVol:GetSizeX() )) * 100 -- 대략 0~1
	GameOption_SetVolume( self.currentMaster, self.currentFxSound, volume, self.currentEnvSound,  self.currentMusic, self.currentHitFxVolume, self.currentHitFxWeight, self.currentPlayerVolume )
end

function GameOption_CheckMusic()
	local self = chk_Option
	local check = frame_Sound._btn_MusicOnOff:IsCheck()
	self.currentCheckMusic = check
	-- setEnableSound( self.currentCheckSound, check, self.currentCheckEnvSound, nil )
end
function GameOption_CheckSound()
	local self = chk_Option
	local check = frame_Sound._btn_FXOnOff:IsCheck()
	self.currentCheckSound = check
	-- setEnableSound( check, self.currentCheckMusic, self.currentCheckEnvSound, nil )
end
function GameOption_CheckEnvSound()
	local self = chk_Option
	local check = frame_Sound._btn_EnvFXOnOff:IsCheck()
	self.currentCheckEnvSound = check
	-- setEnableSound( self.currentCheckSound, self.currentCheckMusic, check, nil )
end

function GameOption_CheckRiddingMusic()
	local self = chk_Option
	local check = frame_Sound._btn_RiddingOnOff:IsCheck()
	self.currentCheckRiddingMusic = check
end

function GameOption_CheckWhisperMusic()
	local self = chk_Option
	local check = frame_Sound._btn_WhisperOnOff:IsCheck()
	self.currentCheckWhisperMusic = check
end

function GameOption_CheckTraySound()
	local self = chk_Option
	local check = frame_Sound._btn_TraySoundOnOff:IsCheck()
	self.currentCheckTraySoundOnOff = check
end

function GameOption_CheckCombatSound()
	local self = chk_Option
	local combatOffCheck	= frame_Sound._btn_CombatAllwaysOff:IsCheck()
	local combatOnCheck		= frame_Sound._btn_CombatAllwaysOn:IsCheck()
	local combatLowOffCheck	= frame_Sound._btn_CombatAllwaysLowOff:IsCheck()

	if ( combatOffCheck ) then
		self.currentCheckCombatMusic = CppEnums.BattleSoundType.Sound_NotUse
	elseif ( combatOnCheck ) then
		self.currentCheckCombatMusic = CppEnums.BattleSoundType.Sound_Always
	else
		self.currentCheckCombatMusic = CppEnums.BattleSoundType.Sound_Nomal
	end
	GameOption_UpdateOptionChanged()
end

function GameOption_CheckHitFxType()
	--local self = chk_Option
	--local check = frame_Sound._btn_HitFxTypeOnOff:IsCheck()
	--self.currentHitFxType = check
	--setEnableSound( self.currentCheckSound, self.currentCheckMusic, check, self.currentHitFxType )
end

function GameOption_HitFxWeight_slider()	-- music input
	local self = chk_Option
	local volume = frame_Sound._slide_hitFxWeightVolume:GetControlPos() * 100
	GameOption_SetVolume( self.currentMaster, self.currentFxSound, self.currentDlgSound, self.currentEnvSound, self.currentMusic, self.currentHitFxVolume, volume, self.currentPlayerVolume )
end
function GameOption_HitFxWeight_button()
	local self = chk_Option
	local volume = (_btn_hitFxWeightVolume:GetPosX() / ( frame_Sound._slide_hitFxWeightVolume:GetSizeX() - _btn_hitFxWeightVolume:GetSizeX() )) * 100 -- 대략 0~1
	GameOption_SetVolume( self.currentMaster, self.currentFxSound, self.currentDlgSound, self.currentEnvSound, self.currentMusic, self.currentHitFxVolume, volume, self.currentPlayerVolume )
end

function GameOption_OtherPlayer_slider()	-- music input
	local self = chk_Option
	local volume = frame_Sound._slide_otherPlayerVolume:GetControlPos() * 100
	GameOption_SetVolume( self.currentMaster, self.currentFxSound, self.currentDlgSound, self.currentEnvSound, self.currentMusic, self.currentHitFxVolume, self.currentHitFxWeight, volume )
end
function GameOption_OtherPlayer_button()
	local self = chk_Option
	local volume = (_btn_otherPlayerVolume:GetPosX() / ( frame_Sound._slide_otherPlayerVolume:GetSizeX() - _btn_otherPlayerVolume:GetSizeX() )) * 100 -- 대략 0~1
	GameOption_SetVolume( self.currentMaster, self.currentFxSound, self.currentDlgSound, self.currentEnvSound, self.currentMusic, self.currentHitFxVolume, self.currentHitFxWeight, volume )
end


------------------------------------------------------------------------
--                          게임 옵션 설정 관련
------------------------------------------------------------------------
function GameOption_SetGameMode( gameOptionSetting )
	local showSkillCmd				= gameOptionSetting:getShowSkillCmd()
	local showComboGuide			= gameOptionSetting:getShowComboGuide()
	local mouseMove					= gameOptionSetting:getGameMouseMode()
	local minimapRotation			= gameOptionSetting:getRadarRotateMode()
	local showAttackEffect			= gameOptionSetting:getRenderHitEffect()
	local blackSpiritAlert			= gameOptionSetting:getBlackSpiritNotice()
	local useNewQuickSlot			= ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(CppEnums.GlobalUIOptionType.NewQuickSlot)	-- 클라 저장 변수 사용.
	local useChattingFilter 		= gameOptionSetting:getUseChattingFilter()
	local isOnScreenSaver			= gameOptionSetting:getIsOnScreenSaver()
	local isUIModeMouseLock			= gameOptionSetting:getUIModeMouseLock()
	local isPvpRefuse				= gameOptionSetting:getPvpRefuse()
	local autoAim					= gameOptionSetting:getAimAssist()
	local hideWindowByAttacked		= gameOptionSetting:getHideWindowByAttacked()
	local showGuildLoginMessage		= gameOptionSetting:getShowGuildLoginMessage()
	local mouseInvertX				= gameOptionSetting:getMouseInvertX()
	local mouseInvertY				= gameOptionSetting:getMouseInvertY()
	local mouseSensitivityX			= gameOptionSetting:getMouseSensitivityX()
	local mouseSensitivityY			= gameOptionSetting:getMouseSensitivityY()
	local padEnable					= gameOptionSetting:getGamePadEnable()
	local padVibration				= gameOptionSetting:getGamePadVibration()
	local padInvertX				= gameOptionSetting:getGamePadInvertX()
	local padInvertY				= gameOptionSetting:getGamePadInvertY()
	local padSensitivityX			= gameOptionSetting:getGamePadSensitivityX()
	local padSensitivityY			= gameOptionSetting:getGamePadSensitivityY()
	local cameraMasterPower			= gameOptionSetting:getCameraMasterPower()
	local cameraShakePower			= gameOptionSetting:getCameraShakePower()
	local motionBlurPower			= gameOptionSetting:getMotionBlurPower()
	local CameraPosPower			= gameOptionSetting:getCameraTranslatePower()
	local CameraFovPower			= gameOptionSetting:getCameraFovPower()
	local selfNameShow				= gameOptionSetting:getSelfPlayerNameTagVisible()
	local hitFxVolume				= gameOptionSetting:getHitFxVolume()
	local RejectInvitation			= gameOptionSetting:getRefuseRequests()
	local enableSimpleUI			= gameOptionSetting:getEnableSimpleUI()
	local isRenderCharacterColor	= gameOptionSetting:getRenderCharacterColor()
	local enableOVR					= gameOptionSetting:getEnableOVR()
	local selfPlayerNameTagVisible	= gameOptionSetting:getSelfPlayerNameTagVisible()
	local otherPlayerNameTagVisible	= gameOptionSetting:getOtherPlayerNameTagVisible()
	local partyPlayerNameTagVisible	= gameOptionSetting:getPartyPlayerNameTagVisible()
	local guildPlayerNameTagVisible	= gameOptionSetting:getGuildPlayerNameTagVisible()
	local guideLineHumanRelation	= gameOptionSetting:getShowHumanRelation()
	local guideLineQuestLine		= gameOptionSetting:getShowQuestActorColor()
	local guideLineZoneChange		= gameOptionSetting:getRenderPlayerColor( randerPlayerColorStr.zoneChange )
	local guideLineWarAlly			= gameOptionSetting:getRenderPlayerColor( randerPlayerColorStr.warAlly )
	local guideLineGuild			= gameOptionSetting:getRenderPlayerColor( randerPlayerColorStr.guild )
	local guideLineParty			= gameOptionSetting:getRenderPlayerColor( randerPlayerColorStr.party )
	local guideLineEnemy			= gameOptionSetting:getRenderPlayerColor( randerPlayerColorStr.enemy )
	local guideLineNonWarPlayer		= gameOptionSetting:getRenderPlayerColor( randerPlayerColorStr.nonWarPlayer )
	local petObject					= gameOptionSetting:getPetRender()
	local navPathEffectType			= gameOptionSetting:getShowNavPathEffectType()

	--ReloadLanguageOption()
		
	local ServiceResType			= gameOptionSetting:getServiceResType()
	local ChatChannelType 			= gameOptionSetting:getChatLanguageType()
	
		
	for index = 0, serviceResCount -1 do
		if ( serviceResEnumsNumber[index] == ServiceResType ) then
			ServiceResType = serviceResEnumsNumber[index]
			break
		end
	end
	
	for index = 0, serviceResCount do
		if ( ChatChannelEnumsNumber[index] == ChatChannelType ) then
			ChatChannelType = ChatChannelEnumsNumber[index]
			break
		end
	end
		
	local self = chk_Option
	self.currentCheckShowSkillCmd 			= showSkillCmd
	self.appliedCheckShowSkillCmd 			= showSkillCmd
	self.savedCheckShowSkillCmd 			= showSkillCmd
	self.currentCheckAutoAim 				= autoAim
	self.appliedCheckAutoAim 				= autoAim
	self.savedCheckAutoAim 					= autoAim
	self.currentCheckHideWindowByAttacked 	= hideWindowByAttacked
	self.appliedCheckHideWindowByAttacked 	= hideWindowByAttacked
	self.savedCheckHideWindowByAttacked 	= hideWindowByAttacked
	self.currentCheckShowGuildLoginMessage 	= showGuildLoginMessage
	self.appliedCheckShowGuildLoginMessage 	= showGuildLoginMessage
	self.savedCheckShowGuildLoginMessage 	= showGuildLoginMessage
	
	
	self.currentCheckEnableSimpleUI 		= enableSimpleUI
	self.appliedCheckEnableSimpleUI 		= enableSimpleUI
	self.savedCheckEnableSimpleUI 			= enableSimpleUI
	self.currentCheckEnableOVR 				= enableOVR
	self.appliedCheckEnableOVR 				= enableOVR
	self.savedCheckEnableOVR		 		= enableOVR

	self.currentCheckRenderCharacterColor 	= isRenderCharacterColor
	self.appliedCheckRenderCharacterColor 	= isRenderCharacterColor
	self.savedCheckRenderCharacterColor		= isRenderCharacterColor
	
	
	self.currentCheckMouseMove				= mouseMove
	self.appliedCheckMouseMove				= mouseMove
	self.savedCheckMouseMove				= mouseMove

	self.currentCheckMiniMapRotation		= minimapRotation
	self.appliedCheckMiniMapRotation		= minimapRotation
	self.savedCheckMiniMapRotation			= minimapRotation

	self.currentCheckShowAttackEffect		= showAttackEffect
	self.appliedCheckShowAttackEffect		= showAttackEffect
	self.savedCheckShowAttackEffect			= showAttackEffect

	self.currentCheckBlackSpiritAlert		= blackSpiritAlert
	self.appliedCheckBlackSpiritAlert		= blackSpiritAlert
	self.savedCheckBlackSpiritAlert			= blackSpiritAlert

	self.currentCheckUseNewQuickSlot		= useNewQuickSlot
	self.appliedCheckUseNewQuickSlot		= useNewQuickSlot
	self.savedCheckUseNewQuickSlot			= useNewQuickSlot

	self.currentCheckUseChattingFilter 		= useChattingFilter
	self.appliedCheckUseChattingFilter 		= useChattingFilter
	self.savedCheckUseChattingFilter 		= useChattingFilter
	
	self.currentCheckIsOnScreenSaver 		= isOnScreenSaver
	self.appliedCheckIsOnScreenSaver 		= isOnScreenSaver
	self.savedCheckisOnScreenSaver	 		= isOnScreenSaver
	
	self.currentCheckIsUIModeMouseLock 		= isUIModeMouseLock
	self.appliedCheckIsUIModeMouseLock 		= isUIModeMouseLock
	self.savedCheckIsUIModeMouseLock	 	= isUIModeMouseLock
		
	self.currentCheckIsPvpRefuse 			= isPvpRefuse
	self.appliedCheckIsPvpRefuse	 		= isPvpRefuse
	self.savedCheckisPvpRefuse	 			= isPvpRefuse
	
	self.currentCheckRejectInvitation		= RejectInvitation
	self.appliedCheckRejectInvitation		= RejectInvitation
	self.savedCheckRejectInvitation			= RejectInvitation

	self.currentPetObjectShow				= petObject
	self.appliedPetObjectShow				= petObject
	self.savedPetObjectShow					= petObject
	
	self.currentNavPathEffectType			= navPathEffectType;
	self.appliedNavPathEffectType			= navPathEffectType;
	self.savedNavPathEffectType				= navPathEffectType;

	self.currentServiceResourceType			= ServiceResType
	self.appliedServiceResourceType			= ServiceResType
	self.savedServiceResourceType			= ServiceResType
	
	self.currentChatChannelType				= ChatChannelType
	self.appliedChatChannelType				= ChatChannelType
	self.savedChatChannelType				= ChatChannelType

	self.currentCheckMouseInvertX			= mouseInvertX
	self.currentCheckMouseInvertY			= mouseInvertY
	self.currentCheckMouseSensitivityX		= mouseSensitivityX
	self.currentCheckMouseSensitivityY		= mouseSensitivityY
	self.currentCheckPadEnable				= padEnable
	self.currentCheckPadVibration			= padVibration
	self.currentCheckPadInvertX				= padInvertX
	self.currentCheckPadInvertY				= padInvertY
	self.currentCheckPadSensitivityX		= padSensitivityX
	self.currentCheckPadSensitivityY		= padSensitivityY
	self.currentSelfPlayerNameTagVisible	= selfPlayerNameTagVisible
	self.currentOtherPlayerNameTagVisible	= otherPlayerNameTagVisible
	self.currentPartyPlayerNameTagVisible	= partyPlayerNameTagVisible
	self.currentGuildPlayerNameTagVisible	= guildPlayerNameTagVisible

	self.currentGuideLineHumanRelation		= guideLineHumanRelation
	self.currentGuideLineQuestLine			= guideLineQuestLine
	self.currentGuideLineZoneChange			= guideLineZoneChange
	self.currentGuideLineWarAlly			= guideLineWarAlly
	self.currentGuideLineGuild				= guideLineGuild
	self.currentGuideLineParty				= guideLineParty
	self.currentGuideLineEnemy				= guideLineEnemy
	self.currentGuideLineNonWarPlayer		= guideLineNonWarPlayer

	self.currentHitFxVolume					= hitFxVolume
	self.currentCheckShowComboGuide			= showComboGuide

	self.appliedCheckMouseInvertX			= mouseInvertX
	self.appliedCheckMouseInvertY			= mouseInvertY
	self.appliedCheckMouseSensitivityX		= mouseSensitivityX
	self.appliedCheckMouseSensitivityY		= mouseSensitivityY
	self.appliedCheckPadEnable				= padEnable
	self.appliedCheckPadVibration			= padVibration
	self.appliedCheckPadInvertX				= padInvertX
	self.appliedCheckPadInvertY				= padInvertY
	self.appliedCheckPadSensitivityX		= padSensitivityX
	self.appliedCheckPadSensitivityY		= padSensitivityY
	self.appliedSelfPlayerNameTagVisible	= selfPlayerNameTagVisible
	self.appliedOtherPlayerNameTagVisible	= otherPlayerNameTagVisible
	self.appliedPartyPlayerNameTagVisible	= partyPlayerNameTagVisible
	self.appliedGuildPlayerNameTagVisible	= guildPlayerNameTagVisible
	self.appliedGuideLineHumanRelation		= guideLineHumanRelation
	self.appliedGuideLineQuestLine			= guideLineQuestLine
	self.appliedGuideLineZoneChange			= guideLineZoneChange
	self.appliedGuideLineWarAlly			= guideLineWarAlly
	self.appliedGuideLineGuild				= guideLineGuild
	self.appliedGuideLineParty				= guideLineParty
	self.appliedGuideLineEnemy				= guideLineEnemy
	self.appliedGuideLineNonWarPlayer		= guideLineNonWarPlayer

	self.appliedHitFxVolume					= hitFxVolume
	self.appliedCheckShowComboGuide			= showComboGuide
	

	self.savedCheckMouseInvertX				= mouseInvertX
	self.savedCheckMouseInvertY				= mouseInvertY
	self.savedCheckMouseSensitivityX		= mouseSensitivityX
	self.savedCheckMouseSensitivityY		= mouseSensitivityY
	self.savedCheckPadEnable				= padEnable
	self.savedCheckPadVibration				= padVibration
	self.savedCheckPadInvertX				= padInvertX
	self.savedCheckPadInvertY				= padInvertY
	self.savedCheckPadSensitivityX			= padSensitivityX
	self.savedCheckPadSensitivityY			= padSensitivityY
	self.savedCheckSelfNameShow				= selfNameShow
	self.savedSelfPlayerNameTagVisible		= selfPlayerNameTagVisible
	self.savedOtherPlayerNameTagVisible		= otherPlayerNameTagVisible
	self.savedPartyPlayerNameTagVisible		= partyPlayerNameTagVisible
	self.savedGuildPlayerNameTagVisible		= guildPlayerNameTagVisible
	self.savedGuideLineHumanRelation		= guideLineHumanRelation
	self.savedGuideLineQuestLine			= guideLineQuestLine
	self.savedGuideLineZoneChange			= guideLineZoneChange
	self.savedGuideLineWarAlly				= guideLineWarAlly
	self.savedGuideLineGuild				= guideLineGuild
	self.savedGuideLineParty				= guideLineParty
	self.savedGuideLineEnemy				= guideLineEnemy
	self.savedGuideLineNonWarPlayer			= guideLineNonWarPlayer
	self.savedHitFxVolume					= hitFxVolume
	self.savedCheckShowComboGuide			= showComboGuide
	_currentSpiritGuideCheck				= showComboGuide

	frame_Game._btn_AutoAim					:SetCheck( autoAim )
	frame_Game._btn_HideWindow				:SetCheck( hideWindowByAttacked )
	frame_Game._btn_MouseMove				:SetCheck( mouseMove )
	frame_Game._btn_MiniMapRotation			:SetCheck( minimapRotation )
	frame_Game._btn_ShowAttackEffect		:SetCheck( showAttackEffect )
	frame_Game._btn_Alert_BlackSpirit		:SetCheck( blackSpiritAlert )
	frame_Game._btn_UseNewQuickSlot			:SetCheck( useNewQuickSlot )
	frame_Game._btn_UseChattingFilter		:SetCheck( useChattingFilter )
	frame_Game._btn_IsOnScreenSaver			:SetCheck( isOnScreenSaver )
	frame_Game._btn_UIModeMouseLock			:SetCheck( isUIModeMouseLock )
	frame_Game._btn_PvpRefuse				:SetCheck( isPvpRefuse )
	frame_Game._btn_GuildLogin				:SetCheck( showGuildLoginMessage )
	frame_Game._btn_MouseX					:SetCheck( mouseInvertX )
	frame_Game._btn_MouseY					:SetCheck( mouseInvertY )
	frame_Game._btn_UsePad					:SetCheck( padEnable )
	frame_Game._btn_UseVibe					:SetCheck( padVibration )
	frame_Game._btn_PadX					:SetCheck( padInvertX )
	frame_Game._btn_PadY					:SetCheck( padInvertY )
	frame_Game._btn_SelfNameShowAllways		:SetCheck(CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow	== selfPlayerNameTagVisible	)
	frame_Game._btn_SelfNameShowImportant	:SetCheck(CppEnums.VisibleNameTagType.eVisibleNameTagType_ImportantShow	== selfPlayerNameTagVisible	)
	frame_Game._btn_SelfNameShowNoShow		:SetCheck(CppEnums.VisibleNameTagType.eVisibleNameTagType_NoShow		== selfPlayerNameTagVisible		)
	frame_Game._btn_OtherNameShow			:SetCheck(CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow	== otherPlayerNameTagVisible	)
	frame_Game._btn_PartyNameShow			:SetCheck(CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow	== partyPlayerNameTagVisible	)
	frame_Game._btn_GuildNameShow			:SetCheck(CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow	== guildPlayerNameTagVisible	)

	frame_Game._btn_GuideLineHumanRelation	:SetCheck( guideLineHumanRelation )
	frame_Game._btn_GuideLineQuestObject	:SetCheck( guideLineQuestLine )
	frame_Game._btn_GuideLineZoneChange		:SetCheck( guideLineZoneChange )
	frame_Game._btn_GuideLineWarAlly		:SetCheck( guideLineWarAlly )
	frame_Game._btn_GuideLineGuild			:SetCheck( guideLineGuild )
	frame_Game._btn_GuideLineParty			:SetCheck( guideLineParty )
	frame_Game._btn_GuideLineEnemy			:SetCheck( guideLineEnemy )
	frame_Game._btn_GuideLineNonWarPlayer	:SetCheck( guideLineNonWarPlayer )

	frame_Game._btn_PetAll					:SetCheck( CppEnums.PetVisibleType.ePetVisibleType_All					== petObject )
	frame_Game._btn_PetMine					:SetCheck( CppEnums.PetVisibleType.ePetVisibleType_Mine					== petObject )
	frame_Game._btn_PetHide					:SetCheck( CppEnums.PetVisibleType.ePetVisibleType_Hide					== petObject )
	
	frame_Game._btn_NavGuideNone			:SetCheck( CppEnums.NavPathEffectType.eNavPathEffectType_None		== navPathEffectType )
	frame_Game._btn_NavGuideArrow			:SetCheck( CppEnums.NavPathEffectType.eNavPathEffectType_Arrow		== navPathEffectType )
	frame_Game._btn_NavGuideEffect			:SetCheck( CppEnums.NavPathEffectType.eNavPathEffectType_PathEffect	== navPathEffectType )
	frame_Game._btn_NavGuideFairy			:SetCheck( CppEnums.NavPathEffectType.eNavPathEffectType_Fairy		== navPathEffectType )
	
	
	frame_Game._btn_RejectInvitation		:SetCheck(RejectInvitation)

	if ( 0 < serviceResCount  ) then
		for index = 0, serviceResCount - 1 do
			_btn_ServiceResourceType[index]		:SetCheck( serviceResEnumsNumber[index] == ServiceResType )
		end
	end

	if ( 0 < serviceResCount  ) then
		for index = 0, serviceResCount do
			if ( nil ~= _btn_ChatLanguageType[index] ) then
				_btn_ChatLanguageType[index]		:SetCheck( ChatChannelEnumsNumber[index] == ChatChannelType )
			end
		end
	end
	
	frame_Game._btn_EnableSimpleUI			:SetCheck(enableSimpleUI)
	frame_Game._btn_EnableOVR				:SetCheck(enableOVR)	
	
	-- 연계기 영상 가이드 보이기
	value_GameOption_Check_ComboGuide:SetCheck( showComboGuide )
	

	local mouseSensitivityX_Percent = (mouseSensitivityX -0.1) / 1.9 * 100
	local mouseSensitivityY_Percent = (mouseSensitivityY -0.1) / 1.9 * 100
	local padSensitivityX_Percent	= (padSensitivityX	-0.1) / 1.9 * 100
	local padSensitivityY_Percent	= (padSensitivityY	-0.1) / 1.9 * 100
	local cameraMasterPower_Percent	= (cameraMasterPower) * 100
	local cameraShakePower_Percent	= (cameraShakePower) * 100
	local motionBlurPower_Percent	= (motionBlurPower) * 100
	local CameraPosPower_Percent	= (CameraPosPower) * 100
	local CameraFovPower_Percent	= (CameraFovPower) * 100

	frame_Display._slide_CameraMaster:SetControlPos(cameraMasterPower_Percent)
	frame_Display._slide_CameraShake:SetControlPos(cameraShakePower_Percent)
	frame_Display._slide_MotionBlur:SetControlPos(motionBlurPower_Percent)
	frame_Game._slide_MouXSen:SetControlPos(mouseSensitivityX_Percent)
	frame_Game._slide_MouYSen:SetControlPos(mouseSensitivityY_Percent)
	frame_Game._slide_PadXSen:SetControlPos(padSensitivityX_Percent)
	frame_Game._slide_PadYSen:SetControlPos(padSensitivityY_Percent)
	frame_Sound._slide_hitFxVolume:SetControlPos(hitFxVolume)

	frame_Display._txt_CameraMaster:SetText( GetStr_Option[25].. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(cameraMasterPower_Percent , 	100) ) .. "% <PAOldColor>) " )
	frame_Display._txt_CameraShake:SetText( GetStr_Option[11].. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(cameraShakePower_Percent , 	100) ) .. "% <PAOldColor>) " )
	frame_Display._txt_MotionBlur:SetText( GetStr_Option[17].. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(motionBlurPower_Percent, 		100) ) .. "% <PAOldColor>) " )
	frame_Display._txt_CameraPos:SetText( GetStr_Option[22].. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(CameraPosPower_Percent, 		100) ) .. "% <PAOldColor>) " )
	frame_Display._txt_CameraFov:SetText( GetStr_Option[23].. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(CameraFovPower_Percent, 		100) ) .. "% <PAOldColor>) " )
	frame_Game._txt_MouXSen:SetText( GetStr_Option[12].. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(mouseSensitivityX_Percent, 			100) ) .. "% <PAOldColor>) " )
	frame_Game._txt_MouYSen:SetText( GetStr_Option[13].. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(mouseSensitivityY_Percent, 			100) ) .. "% <PAOldColor>) " )
	frame_Game._txt_PadXSen:SetText( GetStr_Option[14].. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(padSensitivityX_Percent, 			100) ) .. "% <PAOldColor>) " )
	frame_Game._txt_PadYSen:SetText( GetStr_Option[15].. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(padSensitivityY_Percent, 			100) ) .. "% <PAOldColor>) " )
	frame_Sound._txt_hitFxVolume:SetText( GetStr_Option[18].. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(hitFxVolume, 					100) ) .. "% <PAOldColor>) " )
	
	-- 액션 연계 가이드 표시
	if( nil ~= Panel_SkillCommand ) then
		Panel_SkillCommand:SetShow (showSkillCmd, false)
		isChecked_SkillCommand = showSkillCmd
	end
	
	-- 미니맵 회전을 초기 셋팅 해줌.
	setRotateRadarMode( self.currentCheckMiniMapRotation )
end

function FGlobal_IsChecked_SkillCommand()
	return isChecked_SkillCommand
end

-- 50레벨 이상일 경우 액션 가이드를 일단 꺼준다. 추후 다시 켤 수 있음!
function FGlobal_SkillCommand_LevelCheck()
	if 50 <= getSelfPlayer():get():getLevel() then
		setShowSkillCmd( false )
		GameOption_UpdateOptionChanged()
	
		Panel_SkillCommand:SetShow (false, false)
		isChecked_SkillCommand = false
	end
end

-- 스킬 커맨드용 ON/OFF 함수
-- function GameOption_ShowSkillCmd()
-- 	local self = chk_Option
-- 	local check = frame_Game._btn_ShowSkillCmd:IsCheck()
-- 	self.currentCheckShowSkillCmd = check
-- 	setShowSkillCmd( self.currentCheckShowSkillCmd )
-- 	GameOption_UpdateOptionChanged()
	
-- 	Panel_SkillCommand:SetShow (check, false)
-- 	isChecked_SkillCommand = check
-- end

-- 연계기 영상 가이드 ON/OFF 함수
function GameOption_ShowComboGuide()
	local self = chk_Option
	local check = value_GameOption_Check_ComboGuide:IsCheck()
	self.currentCheckShowComboGuide = check
	-- setShowComboGuide( self.currentCheckShowComboGuide )
	GameOption_UpdateOptionChanged()
end

-- 자동 조준 ON/OFF 함수
function GameOption_AutoAim()
	local self = chk_Option
	local check = frame_Game._btn_AutoAim:IsCheck()
	self.currentCheckAutoAim = check
	-- setAimAssist( self.currentCheckAutoAim )
	GameOption_UpdateOptionChanged()
end

-- 피격 시 윈도우 ON/OFF 함수
function GameOption_CheckHideWindow()
	local self = chk_Option
	local check = frame_Game._btn_HideWindow:IsCheck()
	self.currentCheckHideWindowByAttacked = check
	-- setHideWindowByAttacked( self.currentCheckHideWindowByAttacked )
	GameOption_UpdateOptionChanged()
end

function GameOption_GetHideWindow()
	local self = chk_Option
	return self.appliedCheckHideWindowByAttacked
end

-- UI 간소화 ON/OFF 함수
function SimpleUI_EnableCheck( simpleUI_Check )
	local selfPlayer = getSelfPlayer()
	if nil ~= selfPlayer then
		if ( 6 == selfPlayer:get():getLevel() ) then							-- 5레벨에서 6레벨 될 때 딱 한 번만 실행
			frame_Game._btn_EnableSimpleUI:SetCheck( simpleUI_Check )				-- 원래 설정으로 되돌림
		end
	end
	GameOption_CheckSimpleUI()
end

function GameOption_CheckSimpleUI()
	local self = chk_Option
	local check = frame_Game._btn_EnableSimpleUI:IsCheck()
	self.currentCheckEnableSimpleUI = check

	GameOption_UpdateOptionChanged()
end

function GameOption_GetEnableSimpleUI()
	local self = chk_Option
	return self.appliedCheckEnableSimpleUI
end

-- OculusVR ON/OFF 함수
function GameOption_CheckEnableOVR()
	local self = chk_Option
	local check = frame_Game._btn_EnableOVR:IsCheck()
	self.currentCheckEnableOVR = check
	GameOption_UpdateOptionChanged()
end

function GameOption_GetEnableOVR()
	local self = chk_Option
	return self.appliedCheckEnableOVR
end
	
-- 하단 메뉴용 ON/OFF 함수
-- function Panel_UIMain_MainFunc()
	-- if ( isChecked_UIMain == false ) then
		-- Panel_UIMain:SetShow (true, false)
		-- isChecked_UIMain = true
		-- --frame_Game._btn_BottomMenu:SetCheck(true)
	-- elseif ( isChecked_UIMain == true ) then
		-- Panel_UIMain:SetShow (false, false)
		-- isChecked_UIMain = false
	-- end
-- end

-- 키 입력 표시용 ON/OFF 함수
function Panel_KeyViewer_MainFunc()
	if ( isChecked_KeyViewer == false ) then
		FGlobal_KeyViewer_Show()
		isChecked_KeyViewer = true
		-- frame_Game._btn_ShowKeyGuide:SetCheck(true)
	elseif ( isChecked_KeyViewer == true ) then
		FGlobal_KeyViewer_Hide()
		isChecked_KeyViewer = false
	end
end

--길드원 접속 정보 메시지 표시
function Panel_GuildLogin_MainFunc()
	local self = chk_Option
	local GuildLoginState = frame_Game._btn_GuildLogin:IsCheck()
	self.currentCheckShowGuildLoginMessage = GuildLoginState
	GameOption_UpdateOptionChanged()
end

function GameOption_ShowGuildLoginMessage()
	local self = chk_Option
	return self.appliedCheckShowGuildLoginMessage
end

-- 거래, 파티, 길드 거부
function Panel_RejectInvitation_MainFunc()
	local self = chk_Option
	local check = frame_Game._btn_RejectInvitation:IsCheck()	
	self.currentCheckRejectInvitation = check
	-- setRefuseRequests( self.currentCheckRejectInvitation )
	GameOption_UpdateOptionChanged()
end

-- 흑정령 가이드
function GameOption_SpiritGuide_ShowFunc()
	local tempCheck = frame_Game._btn_SpiritGuide:IsCheck()
	-- 설정 저장하는 바인딩
end

function GameOption_CameraMasterPower_slider()
	local self = chk_Option
	local volume = frame_Display._slide_CameraMaster:GetControlPos()
	self.currentCheckCameraMasterPower = volume
	setCameraMasterPower( self.currentCheckCameraMasterPower )
	frame_Display._txt_CameraMaster:SetText( GetStr_Option[25] .. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(volume * 100,100)	) .. "% <PAOldColor>)" )
end
function GameOption_CameraMasterPower_button()
	local self = chk_Option
	local volume = ( _btn_CameraMaster:GetPosX() / ( frame_Display._slide_CameraMaster:GetSizeX() - _btn_CameraMaster:GetSizeX() )) -- 대략 0~1
	self.currentCheckCameraMasterPower = volume
	setCameraMasterPower( self.currentCheckCameraMasterPower )
	frame_Display._txt_CameraMaster:SetText( GetStr_Option[25] .. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(volume * 100,100)	) .. "% <PAOldColor>)" )
end
function GameOption_SetCameraMasterPower()
	local cameraMasterPower_Percent	= (chk_Option.currentCheckCameraMasterPower) * 100
	frame_Display._slide_CameraMaster:SetControlPos(cameraMasterPower_Percent)
	setCameraMasterPower( chk_Option.currentCheckCameraMasterPower )
	frame_Display._txt_MotionBlur:SetText( GetStr_Option[25] .. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min( cameraMasterPower_Percent,100)	) .. "% <PAOldColor>)" )
end

function GameOption_CameraShakePower_slider()
	local self = chk_Option
	local volume = frame_Display._slide_CameraShake:GetControlPos()
	self.currentCheckCameraShakePower = volume
	setCameraShakePower( self.currentCheckCameraShakePower )
	frame_Display._txt_CameraShake:SetText( GetStr_Option[11] .. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(volume * 100,100)	) .. "% <PAOldColor>)" )
end
function GameOption_CameraShakePower_button()
	local self = chk_Option
	local volume = ( _btn_CameraShake:GetPosX() / ( frame_Display._slide_CameraShake:GetSizeX() - _btn_CameraShake:GetSizeX() )) -- 대략 0~1
	self.currentCheckCameraShakePower = volume
	setCameraShakePower( self.currentCheckCameraShakePower )
	frame_Display._txt_CameraShake:SetText( GetStr_Option[11] .. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(volume * 100,100)	) .. "% <PAOldColor>)" )
end
function GameOption_SetCameraShakePower()
	local cameraShakePower_Percent	= (chk_Option.currentCheckCameraShakePower) * 100
	frame_Display._slide_CameraShake:SetControlPos(cameraShakePower_Percent)
	setCameraShakePower( chk_Option.currentCheckCameraShakePower )
	frame_Display._txt_MotionBlur:SetText( GetStr_Option[11] .. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min( cameraShakePower_Percent,100)	) .. "% <PAOldColor>)" )
end

function GameOption_MotionBlurPower_slider()
	local self = chk_Option
	local volume = frame_Display._slide_MotionBlur:GetControlPos()
	self.currentCheckMotionBlurPower = volume
	setMotionBlurPower( self.currentCheckMotionBlurPower )
	frame_Display._txt_MotionBlur:SetText( GetStr_Option[17] .. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(volume * 100,100)	) .. "% <PAOldColor>)" )
end
function GameOption_MotionBlurPower_button()
	local self = chk_Option
	local volume = ( _btn_MotionBlur:GetPosX() / ( frame_Display._slide_MotionBlur:GetSizeX() - _btn_MotionBlur:GetSizeX() )) -- 대략 0~1
	self.currentCheckMotionBlurPower = volume
	setMotionBlurPower( self.currentCheckMotionBlurPower )
	frame_Display._txt_MotionBlur:SetText( GetStr_Option[17] .. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(volume * 100,100)	) .. "% <PAOldColor>)" )
end
function GameOption_SetMotionBlurPower()
	local motionBlurPower_Percent	= ( chk_Option.currentCheckMotionBlurPower ) * 100
	frame_Display._slide_MotionBlur:SetControlPos( motionBlurPower_Percent )
	setMotionBlurPower( chk_Option.currentCheckMotionBlurPower )
	frame_Display._txt_MotionBlur:SetText( GetStr_Option[17] .. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min( motionBlurPower_Percent ,100)	) .. "% <PAOldColor>)" )
end

function GameOption_CameraPosPower_slider()
	local self = chk_Option
	local volume = frame_Display._slide_CameraPos:GetControlPos()
	self.currentCheckCameraPosPower = volume
	setCameraTranslatePower( self.currentCheckCameraPosPower )
	frame_Display._txt_CameraPos:SetText( GetStr_Option[22] .. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(volume * 100,100)	) .. "% <PAOldColor>)" )
end
function GameOption_CameraPosPower_button()
	local self = chk_Option
	local volume = ( _btn_CameraPos:GetPosX() / ( frame_Display._slide_CameraPos:GetSizeX() - _btn_CameraPos:GetSizeX() )) -- 대략 0~1
	self.currentCheckCameraPosPower = volume
	setCameraTranslatePower( self.currentCheckCameraPosPower )
	frame_Display._txt_CameraPos:SetText( GetStr_Option[22] .. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(volume * 100,100)	) .. "% <PAOldColor>)" )
end
function GameOption_SetCameraPosPower()
	local CameraPosPower_Percent	= (chk_Option.currentCheckCameraPosPower) * 100
	frame_Display._slide_CameraPos:SetControlPos( CameraPosPower_Percent ) -- 0~100
	setCameraTranslatePower( chk_Option.currentCheckCameraPosPower )
	frame_Display._txt_CameraPos:SetText( GetStr_Option[22] .. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(CameraPosPower_Percent,100)	) .. "% <PAOldColor>)" )
end

function GameOption_CameraFovPower_slider()
	local self = chk_Option
	local volume = frame_Display._slide_CameraFov:GetControlPos()
	self.currentCheckCameraFovPower = volume
	setCameraFovPower( self.currentCheckCameraFovPower )
	frame_Display._txt_CameraFov:SetText( GetStr_Option[23] .. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(volume * 100,100)	) .. "% <PAOldColor>)" )
end
function GameOption_CameraFovPower_button()
	local self = chk_Option
	local volume = ( _btn_CameraFov:GetPosX() / ( frame_Display._slide_CameraFov:GetSizeX() - _btn_CameraFov:GetSizeX() )) -- 대략 0~1
	self.currentCheckCameraFovPower = volume
	setCameraFovPower( self.currentCheckCameraFovPower )
	frame_Display._txt_CameraFov:SetText( GetStr_Option[23] .. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(volume * 100,100)	) .. "% <PAOldColor>)" )
end
function GameOption_SetCameraFovPower()
	local CameraFovPower_Percent	= (chk_Option.currentCheckCameraFovPower) * 100
	frame_Display._slide_CameraFov:SetControlPos( CameraFovPower_Percent ) -- 0~100
	setCameraFovPower( chk_Option.currentCheckCameraFovPower )
	frame_Display._txt_CameraFov:SetText( GetStr_Option[23] .. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min( CameraFovPower_Percent,100)	) .. "% <PAOldColor>)" )
end
function GameOption_CheckMouseMove()
	local self = chk_Option
	local check = frame_Game._btn_MouseMove:IsCheck()
	self.currentCheckMouseMove = check
	-- setGameMouseMode( self.currentCheckMouseMove )
	GameOption_UpdateOptionChanged()
end

function GameOption_CheckMiniMapRotation()
	local self = chk_Option
	local check = frame_Game._btn_MiniMapRotation:IsCheck()
	self.currentCheckMiniMapRotation = check
	GameOption_UpdateOptionChanged()
end

function GameOption_CheckShowAttackEffect()
	local self = chk_Option
	local check = frame_Game._btn_ShowAttackEffect:IsCheck()
	self.currentCheckShowAttackEffect = check
	GameOption_UpdateOptionChanged()
end

function GameOption_CheckBlackSpiritAlert()
	local self = chk_Option
	local check = frame_Game._btn_Alert_BlackSpirit:IsCheck()
	self.currentCheckBlackSpiritAlert = check
	GameOption_UpdateOptionChanged()
end

function GameOption_CheckUseNewQuickSlot()
	local self = chk_Option
	local check = frame_Game._btn_UseNewQuickSlot:IsCheck()
	self.currentCheckUseNewQuickSlot = check
	GameOption_UpdateOptionChanged()
end

function GameOption_CheckUseChattingFilter()
	local self = chk_Option
	local check = frame_Game._btn_UseChattingFilter:IsCheck()
	self.currentCheckUseChattingFilter = check
	GameOption_UpdateOptionChanged()
end

function GameOption_CheckIsOnScreenSaver()
	local self = chk_Option
	local check = frame_Game._btn_IsOnScreenSaver:IsCheck()
	self.currentCheckIsOnScreenSaver = check
	GameOption_UpdateOptionChanged()
end

function GameOption_CheckUIModeMouseLock()
	local self = chk_Option
	local check = frame_Game._btn_UIModeMouseLock:IsCheck()
	self.currentCheckIsUIModeMouseLock = check
	GameOption_UpdateOptionChanged()
end

function GameOption_CheckPvpRefuse()
	local self = chk_Option
	local check = frame_Game._btn_PvpRefuse:IsCheck()
	self.currentCheckIsPvpRefuse = check
	GameOption_UpdateOptionChanged()
end

function GameOption_CheckMouseInvertX()
	local self = chk_Option
	local check = frame_Game._btn_MouseX:IsCheck()
	self.currentCheckMouseInvertX = check

	GameOption_UpdateOptionChanged()
end
function GameOption_CheckMouseInvertY()
	local self = chk_Option
	local check = frame_Game._btn_MouseY:IsCheck()
	self.currentCheckMouseInvertY = check

	GameOption_UpdateOptionChanged()
end

function GameOption_MouseSensitivityX_slider()
	local self = chk_Option
	local volume = frame_Game._slide_MouXSen:GetControlPos()
	self.currentCheckMouseSensitivityX = volume * 1.9 + 0.1
	-- setMouseSensitivityX( self.currentCheckMouseSensitivityX )
	frame_Game._txt_MouXSen	:SetText( GetStr_Option[12] .. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(volume * 100,100) ) .. "% <PAOldColor>)" )
end
function GameOption_MouseSensitivityX_button()
	local self = chk_Option
	local volume = ( _btn_MouXSen:GetPosX() / ( frame_Game._slide_MouXSen:GetSizeX() - _btn_MouXSen:GetSizeX() )) -- 대략 0~1
	self.currentCheckMouseSensitivityX = volume * 1.9 + 0.1
	-- setMouseSensitivityX( self.currentCheckMouseSensitivityX )
	frame_Game._txt_MouXSen	:SetText( GetStr_Option[12] .. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(volume * 100,100) ) .. "% <PAOldColor>)" )
end
function GameOption_MouseSensitivityY_slider()
	local self = chk_Option
	local volume = frame_Game._slide_MouYSen:GetControlPos()
	self.currentCheckMouseSensitivityY = volume * 1.9 + 0.1
	-- setMouseSensitivityY( self.currentCheckMouseSensitivityY )
	frame_Game._txt_MouYSen	:SetText( GetStr_Option[13] .. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(volume * 100,100) ) .. "% <PAOldColor>)" )
end
function GameOption_MouseSensitivityY_button()
	local self = chk_Option
	local volume = ( _btn_MouYSen:GetPosX() / ( frame_Game._slide_MouYSen:GetSizeX() - _btn_MouYSen:GetSizeX() )) -- 대략 0~1

	self.currentCheckMouseSensitivityY = volume * 1.9 + 0.1
	-- setMouseSensitivityY( self.currentCheckMouseSensitivityY )
	frame_Game._txt_MouYSen	:SetText( GetStr_Option[13] .. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(volume * 100,100) ) .. "% <PAOldColor>)" )
end

function GameOption_hitFxVolume_slider()
	local self = chk_Option
	local volume = ( _btn_hitFxVolume:GetPosX() / ( frame_Sound._slide_hitFxVolume:GetSizeX() - _btn_hitFxVolume:GetSizeX() )) -- 대략 0~1

	self.currentHitFxVolume = volume * 100
	
	_volumeParam.master = self.currentMaster
	_volumeParam.fx = self.currentFxSound
	_volumeParam.dlg = self.currentDlgSound
	_volumeParam.env = self.currentEnvSound
	_volumeParam.music = self.currentMusic
	_volumeParam.hitFx = self.currentHitFxVolume
	_volumeParam.otherPlayerVolume = self.currentPlayerVolume
	_volumeParam.hitFxWeight = self.currentHitFxWeight
	setVolumeParam(_volumeParam)
	
	--setVolume( self.appliedMaster, self.appliedFxSound, self.appliedDlgSound, self.appliedEnvSound, self.appliedMusic, self.currentHitFxVolume )
	frame_Sound._txt_hitFxVolume:SetText( GetStr_Option[18] .. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(volume * 100,100) ) .. "% <PAOldColor>)" )
end


function GameOption_CheckPadEnable()
	local self = chk_Option
	local check = frame_Game._btn_UsePad:IsCheck()
	self.currentCheckPadEnable = check

	GameOption_UpdateOptionChanged()
end

function GameOption_CheckSelfPlayerNameTagVisible()
	local self = chk_Option
	
	if ( frame_Game._btn_SelfNameShowAllways:IsCheck() ) then
		self.currentSelfPlayerNameTagVisible = CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow
	elseif ( frame_Game._btn_SelfNameShowImportant:IsCheck() ) then
		self.currentSelfPlayerNameTagVisible = CppEnums.VisibleNameTagType.eVisibleNameTagType_ImportantShow
	else
		self.currentSelfPlayerNameTagVisible = CppEnums.VisibleNameTagType.eVisibleNameTagType_NoShow
	end

	GameOption_UpdateOptionChanged()
end

function GameOption_CheckPetObjectShow()
	local self = chk_Option

	if ( frame_Game._btn_PetAll:IsCheck() ) then
		self.currentPetObjectShow = CppEnums.PetVisibleType.ePetVisibleType_All
	elseif ( frame_Game._btn_PetMine:IsCheck() ) then
		self.currentPetObjectShow = CppEnums.PetVisibleType.ePetVisibleType_Mine
	else
		self.currentPetObjectShow = CppEnums.PetVisibleType.ePetVisibleType_Hide
	end

	GameOption_UpdateOptionChanged()
end

function GameOption_CheckNavGuidType()
	local self = chk_Option

	if ( frame_Game._btn_NavGuideNone:IsCheck() ) then
		self.currentNavPathEffectType = CppEnums.NavPathEffectType.eNavPathEffectType_None
	elseif ( frame_Game._btn_NavGuideArrow:IsCheck() ) then
		self.currentNavPathEffectType = CppEnums.NavPathEffectType.eNavPathEffectType_Arrow
	elseif ( frame_Game._btn_NavGuideEffect:IsCheck() ) then
		self.currentNavPathEffectType = CppEnums.NavPathEffectType.eNavPathEffectType_PathEffect
	else
		self.currentNavPathEffectType = CppEnums.NavPathEffectType.eNavPathEffectType_Fairy
	end

	GameOption_UpdateOptionChanged()
end


function GameOption_ServiceResourceTypeFunc()
	local self = chk_Option

	for index = 0, serviceResCount - 1 do
		if( _btn_ServiceResourceType[index]:IsCheck() ) then
			self.currentServiceResourceType = serviceResEnumsNumber[index]
			self.currentChatChannelType = self.currentServiceResourceType

			for indexLang = 0, serviceResCount do
				_btn_ChatLanguageType[indexLang]:SetCheck( ChatChannelEnumsNumber[indexLang] == self.currentChatChannelType )
			end
			break
		end
	end

	local messageboxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"), content = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_LANGUAGESETTING"),  functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
	MessageBox.showMessageBox( messageboxData )

	GameOption_UpdateOptionChanged()
end

function ChatChannelOption()
	local self = chk_Option

	for index = 0, serviceResCount do
		if( _btn_ChatLanguageType[index]:IsCheck() ) then
			self.currentChatChannelType = ChatChannelEnumsNumber[index]
			break
		end
	end

	local messageboxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"), content = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_LANGUAGESETTING"),  functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
	MessageBox.showMessageBox( messageboxData )

	GameOption_UpdateOptionChanged()
end


function GameOption_CheckOtherPlayerNameTagVisible()
	local self = chk_Option
	if ( frame_Game._btn_OtherNameShow:IsCheck() ) then
		self.currentOtherPlayerNameTagVisible = CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow
	else
		self.currentOtherPlayerNameTagVisible = CppEnums.VisibleNameTagType.eVisibleNameTagType_ImportantShow
	end
	
	GameOption_UpdateOptionChanged()
end

function GameOption_CheckPartyPlayerNameTagVisible()
	local self = chk_Option
	if ( frame_Game._btn_PartyNameShow:IsCheck() ) then
		self.currentPartyPlayerNameTagVisible = CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow
	else
		self.currentPartyPlayerNameTagVisible = CppEnums.VisibleNameTagType.eVisibleNameTagType_ImportantShow
	end
	GameOption_UpdateOptionChanged()
end

function GameOption_CheckGuildPlayerNameTagVisible()
	local self = chk_Option
	if ( frame_Game._btn_GuildNameShow:IsCheck() ) then
		self.currentGuildPlayerNameTagVisible = CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow
	else
		self.currentGuildPlayerNameTagVisible = CppEnums.VisibleNameTagType.eVisibleNameTagType_ImportantShow
	end
	-- setGuildPlayerNameTagVisible( self.currentGuildPlayerNameTagVisible )
	GameOption_UpdateOptionChanged()
end

function GameOption_CheckGuildPlayerNameTagVisible()
	local self = chk_Option
	if ( frame_Game._btn_GuildNameShow:IsCheck() ) then
		self.currentGuildPlayerNameTagVisible = CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow
	else
		self.currentGuildPlayerNameTagVisible = CppEnums.VisibleNameTagType.eVisibleNameTagType_ImportantShow
	end
	GameOption_UpdateOptionChanged()
end


function GameOption_CheckGuideLine_HumanRelation()
	local self = chk_Option
	self.currentGuideLineHumanRelation = frame_Game._btn_GuideLineHumanRelation:IsCheck()
	GameOption_UpdateOptionChanged()
end

function GameOption_CheckGuideLine_QuestLine()
	local self = chk_Option
	self.currentGuideLineQuestLine = frame_Game._btn_GuideLineQuestObject:IsCheck()
	GameOption_UpdateOptionChanged()
end

function GameOption_CheckGuideLine_RanderColor( renderColorType )
	if randerPlayerColorStr.zoneChange == renderColorType then
		chk_Option.currentGuideLineZoneChange	= frame_Game._btn_GuideLineZoneChange:IsCheck()
	elseif randerPlayerColorStr.warAlly == renderColorType then
		chk_Option.currentGuideLineWarAlly		= frame_Game._btn_GuideLineWarAlly:IsCheck()
	elseif randerPlayerColorStr.guild == renderColorType then
		chk_Option.currentGuideLineGuild		= frame_Game._btn_GuideLineGuild:IsCheck()
	elseif randerPlayerColorStr.party == renderColorType then
		chk_Option.currentGuideLineParty		= frame_Game._btn_GuideLineParty:IsCheck()
	elseif randerPlayerColorStr.enemy == renderColorType then
		chk_Option.currentGuideLineEnemy		= frame_Game._btn_GuideLineEnemy:IsCheck()
	elseif randerPlayerColorStr.nonWarPlayer == renderColorType then
		chk_Option.currentGuideLineNonWarPlayer	= frame_Game._btn_GuideLineNonWarPlayer:IsCheck()
	end
	GameOption_UpdateOptionChanged()
end

function GameOption_CheckPadVibration()
	local self = chk_Option
	local check = frame_Game._btn_UseVibe:IsCheck()
	self.currentCheckPadVibration = check

	GameOption_UpdateOptionChanged()
end
function GameOption_CheckPadInvertX()
	local self = chk_Option
	local check = frame_Game._btn_PadX:IsCheck()
	self.currentCheckPadInvertX = check

	GameOption_UpdateOptionChanged()
end
function GameOption_CheckPadInvertY()
	local self = chk_Option
	local check = frame_Game._btn_PadY:IsCheck()
	self.currentCheckPadInvertY = check

	GameOption_UpdateOptionChanged()
end

function GameOption_CheckAlertMSG( alertType )
	if 0 == alertType then
		bCheck = frame_Game._btn_Alert_Region:IsCheck()
	elseif 1 == alertType then
		bCheck = frame_Game._btn_Alert_TerritoryTrade:IsCheck()
	elseif 2 == alertType then
		bCheck = frame_Game._btn_Alert_RoyalTrade:IsCheck()
	elseif 3 == alertType then
		bCheck = frame_Game._btn_Alert_Fitness:IsCheck()
	elseif 4 == alertType then
		bCheck = frame_Game._btn_Alert_TerritoryWar:IsCheck()
	elseif 5 == alertType then
		bCheck = frame_Game._btn_Alert_GuildWar:IsCheck()
	elseif 6 == alertType then
		bCheck = frame_Game._btn_Alert_PlayerGotItem:IsCheck()
	elseif 7 == alertType then
		bCheck = frame_Game._btn_Alert_ItemMarket:IsCheck()
	elseif 8 == alertType then
		bCheck = frame_Game._btn_Alert_LifeLevUp:IsCheck()
	elseif 9 == alertType then
		bCheck = frame_Game._btn_Alert_GuildQuest:IsCheck()
	elseif 10 == alertType then
		bCheck = frame_Game._btn_Alert_NearMonster:IsCheck()
	end


	ToClient_SetMessageFilter(alertType, bCheck)
end

function GameOption_PadSensitivityX_slider()
	local self = chk_Option
	local volume = frame_Game._slide_PadXSen:GetControlPos()
	self.currentCheckPadSensitivityX = volume * 1.9 + 0.1
	-- setGamePadSensitivityX( volume * 1.9 + 0.1 )
	frame_Game._txt_PadXSen:SetText( GetStr_Option[14] .. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(volume * 100,100)	) .. "% <PAOldColor>)" )
end
function GameOption_PadSensitivityX_button()
	local self = chk_Option
	local volume = (_btn_PadXSen:GetPosX() / ( frame_Game._slide_PadXSen:GetSizeX() - _btn_PadXSen:GetSizeX() )) -- 대략 0~1
	self.currentCheckPadSensitivityX = volume * 1.9 + 0.1
	-- setGamePadSensitivityX( self.currentCheckPadSensitivityX )
	frame_Game._txt_PadXSen:SetText( GetStr_Option[14] .. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(volume * 100,100)	) .. "% <PAOldColor>)" )
end
function GameOption_PadSensitivityY_slider()
	local self = chk_Option
	local volume = frame_Game._slide_PadYSen:GetControlPos()
	self.currentCheckPadSensitivityY = volume * 1.9 + 0.1
	-- setGamePadSensitivityY( self.currentCheckPadSensitivityY )
	frame_Game._txt_PadYSen:SetText( GetStr_Option[15] .. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(volume * 100,100)	) .. "% <PAOldColor>)" )
end
function GameOption_PadSensitivityY_button()
	local self = chk_Option
	local volume = (_btn_PadYSen:GetPosX() / ( frame_Game._slide_PadYSen:GetSizeX() - _btn_PadYSen:GetSizeX() )) -- 대략 0~1
	self.currentCheckPadSensitivityY = volume * 1.9 + 0.1
	-- setGamePadSensitivityY( self.currentCheckPadSensitivityY )
	frame_Game._txt_PadYSen:SetText( GetStr_Option[15] .. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(volume * 100,100)	) .. "% <PAOldColor>)" )
end

function GameOption_hitFxVolume_button()
	local self = chk_Option
	local volume = (_btn_hitFxVolume:GetPosX() / ( frame_Sound._slide_hitFxVolume:GetSizeX() - _btn_hitFxVolume:GetSizeX() )) -- 대략 0~1
	self.currentHitFxVolume = volume * 100
	
	_volumeParam.master = self.currentMaster
	_volumeParam.fx = self.currentFxSound
	_volumeParam.dlg = self.currentDlgSound
	_volumeParam.env = self.currentEnvSound
	_volumeParam.music = self.currentMusic
	_volumeParam.hitFx = self.currentHitFxVolume
	_volumeParam.otherPlayerVolume = self.currentPlayerVolume
	_volumeParam.hitFxWeight = self.currentHitFxWeight
	setVolumeParam(_volumeParam)
	
	--setVolume( self.appliedMaster, self.appliedFxSound, self.appliedDlgSound, self.appliedEnvSound, self.appliedMusic, self.currentHitFxVolume )
	frame_Sound._txt_hitFxVolume:SetText( GetStr_Option[18] .. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(volume * 100,100)	) .. "% <PAOldColor>)" )
end

------------------------------------------------------------------------
--            			키 커스터마이징 용
------------------------------------------------------------------------
function KeyCustom_Action_ButtonPushed_Key( inputTypeIndex )
	local inputType = configDataIndex + inputTypeIndex - 2
	if ( 0 <= inputType ) then
		INPUT_TYPE = inputType
		SetUIMode( Defines.UIMode.eUIMode_KeyCustom_ActionKey )
	else
		-- _PA_LOG("LUA", "ERROR")
	end
end

function KeyCustom_Action_ButtonPushed_Pad( inputTypeIndex )
	local inputType = configDataIndex + inputTypeIndex - 2
	if ( 0 <= inputType ) then
		INPUT_TYPE = inputType
		SetUIMode( Defines.UIMode.eUIMode_KeyCustom_ActionPad )
	elseif ( -1 == inputType ) then
		KeyCustom_Action_ButtonPushed_PadFunc2()
	else
		KeyCustom_Action_ButtonPushed_PadFunc1()
	end
end

function KeyCustom_Action_ButtonPushed_PadFunc1()
	SetUIMode( Defines.UIMode.eUIMode_KeyCustom_ActionPadFunc1 )
end

function KeyCustom_Action_ButtonPushed_PadFunc2()
	SetUIMode( Defines.UIMode.eUIMode_KeyCustom_ActionPadFunc2 )
end

function KeyCustom_Action_UpdateButtonText_Key()	-- 입력되어 있는 키 스트링을 출력
	for ii = INPUT_COUNT_START, INPUT_COUNT_END do
		setKeyConfigDataConfigButton(ii, keyCustom_GetString_ActionKey( ii ))
	end
	updateKeyConfig()
end

function KeyCustom_Action_UpdateButtonText_Pad()
	keyConfigData[-2].padKeyText = keyCustom_GetString_ActionPadFunc1()
	keyConfigData[-1].padKeyText = keyCustom_GetString_ActionPadFunc2()

	for ii = INPUT_COUNT_START, INPUT_COUNT_END do
		setKeyConfigDataConfigPad(ii, keyCustom_GetString_ActionPad( ii ))
	end
	updateKeyConfig()
end

function KeyCustom_Action_GetInputType()
	return INPUT_TYPE
end

function KeyCustom_Action_KeyButtonCheckReset( inputType )
	-- Func1과 Func2키는 사용하지 않기 때문에 index를 +2시켜서 사용한다.
	BUTTON_KEY[inputType+2]:SetCheck( false )
end

function KeyCustom_Action_PadButtonCheckReset( inputType )
	BUTTON_PAD[inputType+2]:SetCheck( false )
end

function KeyCustom_Action_FuncPadButtonCheckReset( inputType )
	BUTTON_PAD[inputType]:SetCheck( false )
end

------------------------------------------------------------------------
--            		UI 단축키 커스터마이징 용
------------------------------------------------------------------------
function KeyCustom_UI_ButtonPushed_Key( inputTypeIndex )
	local inputType = configDataIndex_UI + inputTypeIndex
	INPUT_TYPE_UI = inputType
	SetUIMode( Defines.UIMode.eUIMode_KeyCustom_UiKey )
end

function KeyCustom_UI_ButtonPushed_Pad( inputTypeIndex )
	local inputType = configDataIndex_UI + inputTypeIndex
	INPUT_TYPE_UI = inputType
	SetUIMode( Defines.UIMode.eUIMode_KeyCustom_UiPad )
end

function KeyCustom_Ui_UpdateButtonText_Key()
	for ii = INPUT_COUNT_START_UI, INPUT_COUNT_END_UI do
		setKeyConfigData_UIConfigButton(ii, keyCustom_GetString_UiKey( ii ))
	end
	updateKeyConfig_UI()
end

function KeyCustom_Ui_UpdateButtonText_Pad()
	for ii = INPUT_COUNT_START_UI, INPUT_COUNT_END_UI do
		setKeyConfigData_UIConfigPad(ii, keyCustom_GetString_UiPad( ii ))
	end
	updateKeyConfig_UI()
end

function KeyCustom_Ui_GetInputType()
	return INPUT_TYPE_UI
end

function KeyCustom_Ui_KeyButtonCheckReset( inputType )
	BUTTON_KEY_UI[inputType]:SetCheck( false )
end

function KeyCustom_Ui_PadButtonCheckReset( inputType )
	BUTTON_PAD_UI[inputType]:SetCheck( false )
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 취소, 적용 버튼 업데이트 함수
function GameOption_UpdateOptionChanged()
	local self = chk_Option
	-- 현재 선택한 옵션 내용이 적용된  내용과 다르면 Apply 버튼 활성화
	if self.currentScreenModeIdx					== self.appliedScreenModeIdx
	and self.currentScreenResolutionIdx				== self.appliedScreenModeIdx
	-- 스크린샷 포맷
	and self.currentScreenShotFormat				== self.appliedScreenShotFormat
	and self.currentColorBlind						== self.appliedColorBlind
	-- 다른 플레이어 이팩트
	and self.currentSelfPlayerOnlyEffect				== self.appliedSelfPlayerOnlyEffect
	and self.currentNearestPlayerOnlyEffect				== self.appliedNearestPlayerOnlyEffect
	and self.currentSelfPlayerOnlyLantern				== self.appliedSelfPlayerOnlyLantern
	and self.currentUpscaleEnable					== self.appliedUpscaleEnable
	and self.currentSleepModeEnable					== self.appliedSleepModeEnable
	and self.currentCropModeEnable					== self.appliedCropModeEnable
	and self.currentCropModeScaleX					== self.appliedCropModeScaleX
	and self.currentCropModeScaleY					== self.appliedCropModeScaleY
	and self.currentTextureQualityIdx				== self.appliedTextureQualityIdx
	and self.currentGraphicOptionIdx				== self.appliedGraphicOptionIdx
	and self.currentGammaValue						== self.appliedGammaValue
	and self.currentContrastValue					== self.appliedContrastValue
	and self.currentCheckDof						== self.appliedCheckDof
	and self.currentCheckAA							== self.appliedCheckAA
	and self.currentCheckUltra						== self.appliedCheckUltra
	and self.currentCheckLensBlood					== self.appliedCheckLensBlood
	and self.currentCheckBloodEffect				== self.appliedCheckBloodEffect
	
	and self.currentCheckSSAO						== self.appliedCheckSSAO
	and self.currentCheckTessellation				== self.appliedCheckTessellation
	and self.currentCheckPostFilter					== self.appliedCheckPostFilter
	and self.currentCheckCharacterEffect			== self.appliedCheckCharacterEffect
	
	and self.currentMaster							== self.appliedMaster
	and self.currentMusic							== self.appliedMusic
	and self.currentFxSound							== self.appliedFxSound
	and self.currentEnvSound						== self.appliedEnvSound
	and self.currentDlgSound						== self.appliedDlgSound
	and self.currentCheckMusic						== self.appliedCheckMusic
	and self.currentCheckSound						== self.appliedCheckSound
	and self.currentCheckEnvSound					== self.appliedCheckEnvSound
	--and self.currentHitFxType						== self.appliedHitFxType
	and self.currentCheckCombatMusic				== self.appliedCheckCombatMusic
	and self.currentCheckRiddingMusic				== self.appliedCheckRiddingMusic
	and self.currentCheckWhisperMusic				== self.appliedCheckWhisperMusic
	and self.currentCheckTraySoundOnOff				== self.appliedCheckTraySoundOnOff
	and self.currentCheckShowSkillCmd				== self.appliedCheckShowSkillCmd
	and self.currentCheckAutoAim					== self.appliedCheckAutoAim
	and self.currentCheckHideWindowByAttacked		== self.appliedCheckHideWindowByAttacked
	and self.currentCheckShowGuildLoginMessage		== self.appliedCheckShowGuildLoginMessage
	and self.currentCheckEnableSimpleUI				== self.appliedCheckEnableSimpleUI
	and self.currentCheckRenderCharacterColor		== self.appliedCheckRenderCharacterColor
	and self.currentCheckMouseMove					== self.appliedCheckMouseMove
	and self.currentCheckEnableOVR					== self.appliedCheckEnableOVR
	
	and self.currentCheckMouseInvertX				== self.appliedCheckMouseInvertX
	and self.currentCheckMouseInvertY				== self.appliedCheckMouseInvertY
	and self.currentCheckMouseSensitivityX			== self.appliedCheckMouseSensitivityX
	and self.currentCheckMouseSensitivityY			== self.appliedCheckMouseSensitivityY
	and self.currentCheckPadEnable					== self.appliedCheckPadEnable
	and self.currentCheckPadVibration				== self.appliedCheckPadVibration
	and self.currentCheckPadInvertX					== self.appliedCheckPadInvertX
	and self.currentCheckPadInvertY					== self.appliedCheckPadInvertY
	and self.currentCheckPadSensitivityX			== self.appliedCheckPadSensitivityX
	and self.currentCheckPadSensitivityY			== self.appliedCheckPadSensitivityY
	and self.currentCheckCameraMasterPower			== self.appliedCheckCameraMasterPower
	and self.currentCheckCameraShakePower			== self.appliedCheckCameraShakePower
	and self.currentCheckMotionBlurPower			== self.appliedCheckMotionBlurPower
	and self.currentCheckCameraPosPower				== self.appliedCheckCameraPosPower
	and self.currentCheckCameraFovPower				== self.appliedCheckCameraFovPower
	and self.currentCheckUIScale					== self.appliedCheckUIScale
	and self.currentSelfPlayerNameTagVisible		== self.appliedSelfPlayerNameTagVisible
	and self.currentOtherPlayerNameTagVisible		== self.appliedOtherPlayerNameTagVisible
	and self.currentPartyPlayerNameTagVisible		== self.appliedPartyPlayerNameTagVisible
	and self.currentGuildPlayerNameTagVisible		== self.appliedGuildPlayerNameTagVisible
	and self.currentPetObjectShow					== self.appliedPetObjectShow
	and self.currentNavPathEffectType				== self.appliedNavPathEffectType
	and self.currentHitFxWeight						== self.appliedHitFxWeight
	and self.currentPlayerVolume					== self.appliedPlayerVolume
	and self.currentFovValue						== self.appliedFovValue
	and self.currentServiceResourceType			== self.appliedServiceResourceType
	and self.currentChatChannelType				== self.appliedChatChannelType
	and self.currentCheckIsUIModeMouseLock			== self.appliedCheckIsUIModeMouseLock
	and self.currentCheckIsPvpRefuse			== self.appliedCheckIsPvpRefuse

	then
		gamePanel_Main._btn_Apply:SetEnable( false )
	else
		gamePanel_Main._btn_Apply:SetEnable( true )
	end
end

function GameOption_InitDisplayModeList( availableScreenResolution )
	local self = chk_Option
	local screenResolutionList = self.screenResolutionList
	self.SCREEN_RESOLUTION_COUNT = availableScreenResolution:getDisplayModeListSize()
	for ii = 1, self.SCREEN_RESOLUTION_COUNT do
		-- Refresh rate도 추가 가능할듯.
		local screenResolution= {height,width}
		screenResolution.height = availableScreenResolution:getDisplayModeHeight( ii -1 )
		screenResolution.width  = availableScreenResolution:getDisplayModeWidth( ii -1 )
		screenResolutionList[ ii ]  = screenResolution
	end
end

-- 옵션창 켜고 끄기!
function GameOption_TogglePanel()
	if ( CppEnums.EProcessorInputMode.eProcessorInputMode_ChattingInputMode == UI.Get_ProcessorInputMode() ) then 
		return
	end
	
	if GetUIMode() == Defines.UIMode.eUIMode_Gacha_Roulette then
		return
	end
	
	local screenX = getScreenSizeX()
	local screenY = getScreenSizeY()

	Panel_Window_Option:SetIgnore( false )
	local selfPlayer = getSelfPlayer()
	
	if isNeedGameOptionFromServer() == false then
		-- 메뉴가 보이되 선택 불가능한게 나을 듯???
		gamePanel_Main._btn_Game:SetShow(false)
		gamePanel_Main._btn_KeyConfig:SetShow(false)
		gamePanel_Main._btn_KeyConfig_UI:SetShow(false)
		
		local serviceType = getGameServiceType()
				
		if ( serviceType ~= CppEnums.GameServiceType.eGameServiceType_NA_ALPHA and 
			 serviceType ~= CppEnums.GameServiceType.eGameServiceType_NA_REAL and 
			 serviceType ~= CppEnums.GameServiceType.eGameServiceType_DEV ) then
			gamePanel_Main._btn_Language:SetShow(false)
		end
	else
		gamePanel_Main._btn_Language:SetShow(false)
		gamePanel_Main._buttonQuestion:SetShow(false)
	end
	
	
	if nil ~= selfPlayer then
		if ( 5 < selfPlayer:get():getLevel() ) then			-- 6레벨 이상만 간소화 체크할 수 있음
			frame_Game._btn_EnableSimpleUI:SetIgnore( false )		-- 6레벨부터 간소화 원래 설정으로 돌림
		else
			frame_Game._btn_EnableSimpleUI:SetIgnore( true )		-- 5레벨 이하일 경우 UI 간소화 체크 못함
		end
	else
		frame_Game._btn_EnableSimpleUI:SetIgnore( true )
	end
	
	local isShow = Panel_Window_Option:IsShow()
		
	if isShow == false then	
		-- 사운드 추가 필요
		Panel_GameOption_Initialize()	
		Panel_Window_Option:SetShow(true, true)
		--Panel_Window_Option:ComputePos()
		
		isKeyConfig_Open = false
		isKeyConfig_UI_Open = false
		audioPostEvent_SystemUi(01,00)
			
		if isNeedGameOptionFromServer() == true then
			keyCustom_StartEdit()
		end
	else		
		Panel_GameOption_Initialize()
		Panel_Window_Option:SetShow(false, true)
		audioPostEvent_SystemUi(01,00)

		if Panel_Tooltip_SimpleText:GetShow() then
			TooltipSimple_Hide()
		end
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
--                              확인, 취소, 적용 버튼 동작
--옵션 변경 조작 시 바로 클라이언트 함수 적용 여부에 따라(주로 Update함수에 있음)
--버튼 눌렀을 때  클라이언트 함수 호출 여부도 결정
--옵션 변경 조작 시 바로 변경했다고( 설정 클라이언트 함수 호출 ) 가정 함.
function GameOption_Cancel()
	local self = chk_Option
	if self.appliedScreenModeIdx ~= self.currentScreenModeIdx then
		setScreenMode ( self.appliedScreenModeIdx )
	end

	-- 스크린샷 포맷
	if self.appliedScreenShotFormat ~= self.currentScreenShotFormat then
		setScreenShotFormat ( self.appliedScreenShotFormat )
	end

	-- 색약 모드
	if self.appliedColorBlind ~= self.currentColorBlind then
		ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(CppEnums.GlobalUIOptionType.ColorBlindMode, self.appliedColorBlind)
		FGlobal_Rador_SetColorBlindMode()	-- 색약모드 레이더에서 직접 컨트롤되어야한다.
		FGlobal_ChangeEffectCheck()	-- 흑정령 새로운 퀘스트 조건 중 이펙트 한번만 뿌려주기 위한 조건 변경을 위해서 존재한다.
		ToClient_ChangeColorBlindMode( self.appliedColorBlind )
		FGlobal_Window_Servant_ColorBlindUpdate()
		UIMain_QuestUpdate()
	end

	-- 다른 플레이어 이팩트	
	if self.appliedSelfPlayerOnlyEffect ~= self.currentSelfPlayerOnlyEffect then
		setSelfPlayerOnlyEffect ( self.appliedSelfPlayerOnlyEffect )
	end

	-- 가까운 플레이어 이팩트	
	if self.appliedNearestPlayerOnlyEffect ~= self.currentNearestPlayerOnlyEffect then
		setNearestPlayerOnlyEffect ( self.appliedNearestPlayerOnlyEffect )
	end
	
	-- 다른 플레이어 랜턴
	if self.appliedSelfPlayerOnlyLantern ~= self.currentSelfPlayerOnlyLantern then
		setSelfPlayerOnlyLantern ( self.appliedSelfPlayerOnlyLantern )
	end
	
	-- Upscale
	if self.appliedUpscaleEnable ~= self.currentUpscaleEnable then
		setUpscaleEnable ( self.appliedUpscaleEnable )
	end
	
	-- SleepMode
	if self.appliedSleepModeEnable ~= self.currentSleepModeEnable then
		setSleepModeEnable ( self.appliedSleepModeEnable )
	end
	
	-- CropMode
	if self.appliedCropModeEnable ~= self.currentCropModeEnable then
		setCropModeEnable ( self.appliedCropModeEnable )
	end
	if self.appliedCropModeScaleX ~= self.currentCropModeScaleX then
		setCropModeScaleX ( self.appliedCropModeScaleX )
	end
	if self.appliedCropModeScaleY ~= self.currentCropModeScaleY then
		setCropModeScaleY ( self.appliedCropModeScaleY )
	end

	if self.appliedLUT ~= self.currentLUT then
		setCameraLUTFilter( self.appliedLUT )
	end
	
	if self.appliedScreenResolutionIdx ~= self.currentScreenResolutionIdx then
		local index = self.appliedScreenResolutionIdx
		setScreenResolution( self.screenResolutionList[ index ].width, self.screenResolutionList[ index ].height )
	end

	if self.appliedTextureQualityIdx ~= self.currentTextureQualityIdx then
		setTextureQuality( self.appliedTextureQualityIdx )
	end

	if self.appliedGraphicOptionIdx ~= self.currentGraphicOptionIdx then
		setGraphicOption( self.appliedGraphicOptionIdx )
	end

	if self.appliedCheckDof ~= self.currentCheckDof then
		setDof( self.appliedCheckDof )
	end

	if self.appliedCheckAA ~= self.currentCheckAA then
		setAntiAliasing( self.appliedCheckAA )
	end
	
	if self.appliedCheckUltra ~= self.currentCheckUltra then
		setGraphicUltra( self.appliedCheckUltra )
	end

	if self.appliedCheckLensBlood ~= self.currentCheckLensBlood then
		setLensBlood( self.appliedCheckLensBlood )
	end
	
	if self.appliedCheckBloodEffect ~= self.currentCheckBloodEffect then
		if true == self.appliedCheckBloodEffect then
			setBloodEffect( 2 )	-- 0: Off, 1:Effect Only, 2: Full
		else
			setBloodEffect( 0 )
		end
	end
	
	if self.appliedCheckSSAO ~= self.currentCheckSSAO then
		setSSAO( self.appliedCheckSSAO )
	end
	
	if self.appliedCheckTessellation ~= self.currentCheckTessellation then
		setTessellation( self.appliedCheckTessellation )
	end
	
	if self.appliedCheckPostFilter ~= self.currentCheckPostFilter then
		if true == self.appliedCheckPostFilter then
			setPostFilter( 2 )	-- 0: Off, 1:Sharpen Only, 2: Sharpen+Blur
		else
			setPostFilter( 1 )
		end
	end
	
	if self.appliedCheckCharacterEffect ~= self.currentCheckCharacterEffect then
		setCharacterEffect( self.appliedCheckCharacterEffect )
	end

	if self.appliedGammaValue ~= self.currentGammaValue then
		setGammaValue( self.appliedGammaValue )
	end
	
	if self.appliedContrastValue ~= self.currentContrastValue then
		setContrastValue( self.appliedContrastValue )
	end
	
	if self.appliedFovValue ~= self.currentFovValue then
		setFov( self.appliedFovValue )
	end
	
	if self.appliedMaster ~= self.currentMaster
	or self.appliedMusic ~= self.currentMusic
	or self.appliedFxSound ~= self.currentFxSound
	or self.appliedEnvSound ~= self.currentEnvSound
	or self.appliedDlgSound ~= self.currentDlgSound 
	or self.appliedHitFxVolume ~= self.currentHitFxVolume 
	or self.appliedHitFxWeight ~= self.currentHitFxWeight 
	or self.appliedPlayerVolume ~= self.currentPlayerVolume 
	then
		_volumeParam.master = self.appliedMaster
		_volumeParam.fx = self.appliedFxSound
		_volumeParam.dlg = self.appliedDlgSound
		_volumeParam.env = self.appliedEnvSound
		_volumeParam.music = self.appliedMusic
		_volumeParam.hitFx = self.appliedHitFxVolume
		_volumeParam.otherPlayerVolume = self.appliedPlayerVolume
		_volumeParam.hitFxWeight = self.appliedHitFxWeight
		setVolumeParam(_volumeParam)
		--setVolume( self.appliedMaster, self.appliedFxSound, self.appliedDlgSound, self.appliedEnvSound, self.appliedMusic, self.appliedHitFxVolume )	--	sendClient 파라메터 순서 잘 봐야함
	end

	if self.appliedCheckMusic ~= self.currentCheckMusic
	or self.appliedCheckSound ~= self.currentCheckSound
	or self.appliedCheckEnvSound ~= self.currentCheckEnvSound 
	--or self.currentHitFxType ~= self.savedHitFxType
	then
		--	sendClient
		setEnableSound( self.appliedCheckSound, self.appliedCheckMusic, self.appliedCheckEnvSound, self.appliedCheckWhisperMusic, self.appliedCheckTraySoundOnOff )			
	end

	if self.appliedCheckCombatMusic ~= self.currentCheckCombatMusic then
		setEnableBattleSoundType( self.appliedCheckCombatMusic )
	end

	if self.appliedCheckRiddingMusic ~= self.currentCheckRiddingMusic then
		setEnableRidingSound( self.appliedCheckRiddingMusic )
	end

	if self.appliedCheckWhisperMusic ~= self.currentCheckWhisperMusic then
		setEnableSound( self.appliedCheckSound, self.appliedCheckMusic, self.appliedCheckEnvSound, self.appliedCheckWhisperMusic, self.appliedCheckTraySoundOnOff )
	end
	
	if self.appliedCheckTraySoundOnOff ~= self.currentCheckTraySoundOnOff then
		setEnableSound( self.appliedCheckSound, self.appliedCheckMusic, self.appliedCheckEnvSound, self.appliedCheckWhisperMusic, self.appliedCheckTraySoundOnOff )
	end
	
	if self.appliedCheckVoiceChatOnOff ~= self.currentCheckVoiceChatOnOff then
		setEnableVoiceChatOnOff( self.appliedCheckVoiceChatOnOff )
	end

	---------------------------------------------------------------------------------------------
	----------- 게임 설정 -----------------------------------------------------------------------
	---------------------------------------------------------------------------------------------
	
	if self.appliedCheckShowSkillCmd			~= self.currentCheckShowSkillCmd			then
		setShowSkillCmd( self.appliedCheckShowSkillCmd )
	end
	if self.appliedCheckAutoAim					~= self.currentCheckAutoAim					then
		setAimAssist( self.appliedCheckAutoAim )
	end
	if self.appliedCheckHideWindowByAttacked	~= self.currentCheckHideWindowByAttacked 	then
		setHideWindowByAttacked( self.appliedCheckHideWindowByAttacked )
	end
	if self.appliedCheckShowGuildLoginMessage	~= self.currentCheckShowGuildLoginMessage 	then
		setShowGuildLoginMessage( self.appliedCheckShowGuildLoginMessage )
	end
	if self.appliedCheckEnableSimpleUI			~= self.currentCheckEnableSimpleUI 			then
		setEnableSimpleUI( self.appliedCheckEnableSimpleUI )
	end
	if self.appliedCheckRenderCharacterColor	~= self.currentCheckRenderCharacterColor 	then
		setRenderCharacterColor( self.appliedCheckRenderCharacterColor )
	end
	if self.appliedCheckMouseMove				~= self.currentCheckMouseMove				then
		setGameMouseMode( self.appliedCheckMouseMove )
	end
	if self.appliedCheckMouseInvertX			~= self.currentCheckMouseInvertX			then
		setMouseInvertX( self.appliedCheckMouseInvertX )
	end
	if self.appliedCheckMouseInvertY			~= self.currentCheckMouseInvertY			then
		setMouseInvertY(self.appliedCheckMouseInvertY		)
	end
	if self.appliedCheckMouseSensitivityX		~= self.currentCheckMouseSensitivityX		then
		setMouseSensitivityX(self.appliedCheckMouseSensitivityX	)
	end
	if self.appliedCheckMouseSensitivityY		~= self.currentCheckMouseSensitivityY		then
		setMouseSensitivityY(self.appliedCheckMouseSensitivityY	)
	end
	if self.appliedCheckPadEnable				~= self.currentCheckPadEnable				then
		setGamePadEnable(self.appliedCheckPadEnable		)
	end
	if self.appliedCheckPadVibration			~= self.currentCheckPadVibration			then
		setGamePadVibration(self.appliedCheckPadVibration		)
	end
	if self.appliedCheckPadInvertX				~= self.currentCheckPadInvertX				then
		setGamePadInvertX(self.appliedCheckPadInvertX		)
	end
	if self.appliedCheckPadInvertY				~= self.currentCheckPadInvertY				then
		setGamePadInvertY(self.appliedCheckPadInvertY		)
	end
	if self.appliedCheckPadSensitivityX			~= self.currentCheckPadSensitivityX			then
		setGamePadSensitivityX(self.appliedCheckPadSensitivityX	)
	end
	if self.appliedCheckPadSensitivityY			~= self.currentCheckPadSensitivityY			then
		setGamePadSensitivityY(self.appliedCheckPadSensitivityY	)
	end
	
	if self.appliedCheckCameraMasterPower		~= self.currentCheckCameraMasterPower		then
		setCameraMasterPower( self.appliedCheckCameraMasterPower )
	end
	if self.appliedCheckCameraShakePower		~= self.currentCheckCameraShakePower		then
		setCameraShakePower( self.appliedCheckCameraShakePower )
	end
	if self.appliedCheckMotionBlurPower			~= self.currentCheckMotionBlurPower			then
		setMotionBlurPower( self.appliedCheckMotionBlurPower )
	end
	if self.appliedCheckCameraPosPower			~= self.currentCheckCameraPosPower			then
		setCameraTranslatePower( self.appliedCheckCameraPosPower )
	end
	if self.appliedCheckCameraFovPower			~= self.currentCheckCameraFovPower			then
		setCameraFovPower( self.appliedCheckCameraFovPower )
	end
	if self.appliedCheckSelfNameShow			~= self.currentCheckSelfNameShow			then
		setUISelfPlayerNameTagAllwaysShow( self.appliedCheckSelfNameShow )
	end

	-- if self.appliedPetObjectShow				~= self.currentPetObjectShow				then
	-- 	setPetRender( self.appliedPetObjectShow )
	-- end

	if self.appliedServiceResourceType		~= self.currentServiceResourceType				then
		ToClient_saveServiceResourceType( self.appliedServiceResourceType )
	end
	
	-- AAA
	if self.appliedChatChannelType		~= self.currentChatChannelType					then
		ToClient_saveChatChannelType( self.appliedChatChannelType )
	end

	if self.appliedCheckUIScale					~= self.currentCheckUIScale					then
	    --self.savedCheckUIScale = math.min( math.max( minScaleValue * 0.01, self.savedCheckUIScale ), maxScaleValue * 0.01 )
	    --self.savedCheckUIScale = math.ceil( self.savedCheckUIScale * 100 ) / 100
		setUIScale( self.appliedCheckUIScale )
	end

	gamePanel_Main._btn_Apply:SetEnable( false )
	
	SetUIMode( Defines.UIMode.eUIMode_Default )
	UI.Set_ProcessorInputMode( CppEnums.EProcessorInputMode.eProcessorInputMode_UiMode )
	
	keyCustom_RollBack()
	
	Panel_Window_Option:SetShow(false, true)
	--Panel_Window_Option:ComputePos()
	-- ♬ 캔슬버튼 눌렀을 때 사운드 추가
	audioPostEvent_SystemUi(01,00)

	setAudioOptionByConfig()

	if Panel_Tooltip_SimpleText:GetShow() then
		TooltipSimple_Hide()
	end
end

function GameOption_Confirm()
	if isNeedGameOptionFromServer() == true then
		FGlobal_QuestWindowRateSetting()
		Panel_UIControl_SetShow(false)
	end

	GameOption_Apply()
	
	Panel_Window_Option:SetShow(false, true)
	--Panel_Window_Option:ComputePos()
	audioPostEvent_SystemUi(01,00)
end

function GameOption_Apply()
	local isChangedDisplay = false;
	local isResetUI	= false
	local self = chk_Option
	SetUIMode( Defines.UIMode.eUIMode_Default )
	UI.Set_ProcessorInputMode( CppEnums.EProcessorInputMode.eProcessorInputMode_UiMode )
	if self.currentScreenModeIdx ~= self.appliedScreenModeIdx then
		self.appliedScreenModeIdx = self.currentScreenModeIdx
		-- 클라이언트  스크린 모드 설정 함수
		setScreenMode( self.appliedScreenModeIdx )
		isChangedDisplay = true;
	end

	-- 스크린샷 포맷
	if self.currentScreenShotFormat ~= self.appliedScreenShotFormat then
		self.appliedScreenShotFormat = self.currentScreenShotFormat
		setScreenShotFormat( self.appliedScreenShotFormat )
	end

	-- 색약 모드
	if self.currentColorBlind ~= self.appliedColorBlind then
		self.appliedColorBlind = self.currentColorBlind
		ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(CppEnums.GlobalUIOptionType.ColorBlindMode, self.appliedColorBlind)
		FGlobal_Rador_SetColorBlindMode()	-- 색약모드 레이더에서 직접 컨트롤되어야한다.
		FGlobal_ChangeEffectCheck()	-- 흑정령 새로운 퀘스트 조건 중 이펙트 한번만 뿌려주기 위한 조건 변경을 위해서 존재한다.
		ToClient_ChangeColorBlindMode( self.appliedColorBlind )
		FGlobal_Window_Servant_ColorBlindUpdate()
		UIMain_QuestUpdate()
	end

	-- 다른 플레이어 이팩트
	if self.currentSelfPlayerOnlyEffect ~= self.appliedSelfPlayerOnlyEffect then
		self.appliedSelfPlayerOnlyEffect = self.currentSelfPlayerOnlyEffect
		setSelfPlayerOnlyEffect( self.appliedSelfPlayerOnlyEffect )
	end

	-- 가까운 플레이어 이팩트
	if self.currentNearestPlayerOnlyEffect ~= self.appliedNearestPlayerOnlyEffect then
		self.appliedNearestPlayerOnlyEffect = self.currentNearestPlayerOnlyEffect
		setNearestPlayerOnlyEffect( self.appliedNearestPlayerOnlyEffect )
	end
	
	-- 다른 플레이어 랜턴
	if self.currentSelfPlayerOnlyLantern ~= self.appliedSelfPlayerOnlyLantern then
		self.appliedSelfPlayerOnlyLantern = self.currentSelfPlayerOnlyLantern
		setSelfPlayerOnlyLantern( self.appliedSelfPlayerOnlyLantern )
	end
	
	-- Upscale
	if self.currentUpscaleEnable ~= self.appliedUpscaleEnable then
		self.appliedUpscaleEnable = self.currentUpscaleEnable
		setUpscaleEnable( self.appliedUpscaleEnable )
	end
	
	-- SleepMode
	if self.currentSleepModeEnable ~= self.appliedSleepModeEnable then
		self.appliedSleepModeEnable = self.currentSleepModeEnable
		setSleepModeEnable( self.appliedSleepModeEnable )
	end
	
	-- CropMode
	if self.currentCropModeScaleX > 0.95 and self.currentCropModeScaleY > 0.95 and self.currentCropModeEnable then
		-- 최소값이 안될때는 옵션을 자동으로 OFF
		frame_Display._btn_CropModeEnable:SetCheck( false )
		self.currentCropModeEnable = false
	end
	
	if self.currentCropModeEnable ~= self.appliedCropModeEnable then
		self.appliedCropModeEnable = self.currentCropModeEnable
		setCropModeEnable( self.appliedCropModeEnable )
	end
	if self.appliedCropModeEnable then
		GameOption_CropModeScaleX_slider()
		GameOption_CropModeScaleY_slider()
	end
	
	if self.currentCheckEnableOVR	~= self.appliedCheckEnableOVR 	then
		self.appliedCheckEnableOVR = self.currentCheckEnableOVR
		setRenderOVR( self.appliedCheckEnableOVR )
	end
	
	if self.currentScreenResolutionIdx ~= self.appliedScreenResolutionIdx then
		self.appliedScreenResolutionIdx = self.currentScreenResolutionIdx
		-- 클라이언트  스크린 해상도 설정 함수
		local index = self.appliedScreenResolutionIdx
		setScreenResolution( self.screenResolutionList[ index ].width, self.screenResolutionList[ index ].height )
		isChangedDisplay = true;
	end

	if self.currentTextureQualityIdx ~= self.appliedTextureQualityIdx then
		self.appliedTextureQualityIdx = self.currentTextureQualityIdx
		-- 클라이언트  텍스쳐 품질  설정 함수
		setTextureQuality( self.appliedTextureQualityIdx )
	end

	if self.currentGraphicOptionIdx ~= self.appliedGraphicOptionIdx then
		self.appliedGraphicOptionIdx = self.currentGraphicOptionIdx
		-- 클라이언트  그래픽 옵션  설정 함수
		setGraphicOption( self.appliedGraphicOptionIdx )
	end

	if self.currentCheckDof ~= self.appliedCheckDof then
		self.appliedCheckDof = self.currentCheckDof
		setDof( self.appliedCheckDof )
	end

	if self.currentCheckAA ~= self.appliedCheckAA then
		self.appliedCheckAA = self.currentCheckAA
		setAntiAliasing( self.appliedCheckAA )
	end
	
	if self.currentCheckUltra ~= self.appliedCheckUltra then
		self.appliedCheckUltra = self.currentCheckUltra
		setGraphicUltra( self.appliedCheckUltra )
	end

	if self.currentCheckLensBlood ~= self.appliedCheckLensBlood then
		self.appliedCheckLensBlood = self.currentCheckLensBlood
		setLensBlood( self.appliedCheckLensBlood )
	end
	
	if self.currentCheckBloodEffect ~= self.appliedCheckBloodEffect then
		self.appliedCheckBloodEffect = self.currentCheckBloodEffect
		if true == self.appliedCheckBloodEffect then
			setBloodEffect( 2 )	-- 0: Off, 1:Effect Only, 2: Full
		else
			setBloodEffect( 0 )
		end
	end
	
	if self.currentCheckSSAO ~= self.appliedCheckSSAO then
		self.appliedCheckSSAO = self.currentCheckSSAO;
		setSSAO( self.appliedCheckSSAO )
	end
	
	if self.currentCheckTessellation ~= self.appliedCheckTessellation then
		self.appliedCheckTessellation = self.currentCheckTessellation;
		setTessellation( self.appliedCheckTessellation )
	end
	
	if self.currentCheckPostFilter ~= self.appliedCheckPostFilter then
		self.appliedCheckPostFilter = self.currentCheckPostFilter
		if true == self.appliedCheckPostFilter then
			setPostFilter( 2 )	-- 0: Off, 1:Sharpen Only, 2: Sharpen+Blur
		else
			setPostFilter( 1 )
		end
	end
	
	if self.currentCheckCharacterEffect ~= self.appliedCheckCharacterEffect then
		self.appliedCheckCharacterEffect = self.currentCheckCharacterEffect
		setCharacterEffect( self.appliedCheckCharacterEffect )
	end

	if self.currentGammaValue ~= self.appliedGammaValue then
		self.appliedGammaValue = self.currentGammaValue
		--	클라이언트 감마 옵션 설정 함수
		setGammaValue( self.appliedGammaValue )
	end
	
	if self.currentContrastValue ~= self.appliedContrastValue then
		self.appliedContrastValue = self.currentContrastValue
		setContrastValue( self.appliedContrastValue )
	end

	if self.currentFovValue ~= self.appliedFovValue then
		self.appliedFovValue = self.currentFovValue
		setFov( self.appliedFovValue )
	end
	
	if self.currentMaster ~= self.appliedMaster
	or self.currentMusic ~= self.appliedMusic
	or self.currentEnvSound ~= self.appliedEnvSound
	or self.currentFxSound ~= self.appliedFxSound
	or self.currentDlgSound ~= self.appliedDlgSound 
	or self.currentHitFxVolume ~= self.appliedHitFxVolume 
	or self.currentHitFxWeight ~= self.appliedHitFxWeight 
	or self.currentPlayerVolume ~= self.appliedPlayerVolume 
	then

		self.appliedMaster = self.currentMaster
		self.appliedMusic = self.currentMusic
		self.appliedFxSound = self.currentFxSound
		self.appliedEnvSound = self.currentEnvSound
		self.appliedDlgSound = self.currentDlgSound
		self.appliedHitFxVolume = self.currentHitFxVolume
		self.appliedHitFxWeight = self.currentHitFxWeight
		self.appliedPlayerVolume = self.currentPlayerVolume
		
		_volumeParam.master = self.appliedMaster
		_volumeParam.fx = self.appliedFxSound
		_volumeParam.dlg = self.appliedDlgSound
		_volumeParam.env = self.appliedEnvSound
		_volumeParam.music = self.appliedMusic
		_volumeParam.hitFx = self.appliedHitFxVolume
		_volumeParam.otherPlayerVolume = self.appliedPlayerVolume
		_volumeParam.hitFxWeight = self.appliedHitFxWeight
		setVolumeParam(_volumeParam)

		--setVolume( self.appliedMaster, self.appliedFxSound, self.appliedDlgSound, self.appliedEnvSound, self.appliedMusic, self.appliedHitFxVolume )	--	sendClient 파라메터 순서 잘 봐야함
	end

	if self.currentCheckMusic ~= self.appliedCheckMusic
	or self.currentCheckSound ~= self.appliedCheckSound
	or self.currentCheckEnvSound ~= self.appliedCheckEnvSound 
	--or self.currentHitFxType ~= self.appliedHitFxType
	then

		self.appliedCheckMusic = self.currentCheckMusic
		self.appliedCheckSound = self.currentCheckSound
		self.appliedCheckEnvSound = self.currentCheckEnvSound
		--self.appliedHitFxType = self.currentHitFxType

		setEnableSound( self.appliedCheckSound, self.appliedCheckMusic, self.appliedCheckEnvSound, self.appliedCheckWhisperMusic, self.appliedCheckTraySoundOnOff )	--	sendClient
	end

	if self.currentCheckShowSkillCmd		~= self.appliedCheckShowSkillCmd 	then
		self.appliedCheckShowSkillCmd = self.currentCheckShowSkillCmd
		-- GameOption_ShowSkillCmd( self.appliedCheckShowSkillCmd )
	end

	if self.currentCheckAutoAim				~= self.appliedCheckAutoAim then
		self.appliedCheckAutoAim = self.currentCheckAutoAim
		setAimAssist( self.appliedCheckAutoAim )
	end

	if self.currentCheckHideWindowByAttacked	~= self.appliedCheckHideWindowByAttacked then
		self.appliedCheckHideWindowByAttacked = self.currentCheckHideWindowByAttacked
		setHideWindowByAttacked( self.appliedCheckHideWindowByAttacked )
	end
	
	if self.currentCheckShowGuildLoginMessage	~= self.appliedCheckShowGuildLoginMessage then
		self.appliedCheckShowGuildLoginMessage = self.currentCheckShowGuildLoginMessage
		setShowGuildLoginMessage( self.appliedCheckShowGuildLoginMessage )
	end
	
	if self.currentCheckEnableSimpleUI	~= self.appliedCheckEnableSimpleUI then
		self.appliedCheckEnableSimpleUI = self.currentCheckEnableSimpleUI

		local selfPlayer = getSelfPlayer()
		if nil ~= selfPlayer then
			if ( 5 < selfPlayer:get():getLevel() ) then			-- 6레벨 이상만 간소화 체크할 수 있음
				frame_Game._btn_EnableSimpleUI:SetCheck( self.appliedCheckEnableSimpleUI )
				setEnableSimpleUI( self.appliedCheckEnableSimpleUI )
			else
				frame_Game._btn_EnableSimpleUI:SetCheck( false )
				setEnableSimpleUI( false )
			end
		else
			frame_Game._btn_EnableSimpleUI:SetCheck( false )
			setEnableSimpleUI( false )
		end

		-- GameOption_CheckSimpleUI( self.appliedCheckEnableSimpleUI )
	end
	
	if self.currentCheckEnableOVR	~= self.appliedCheckEnableOVR then
		self.appliedCheckEnableOVR = self.currentCheckEnableOVR

		GameOption_CheckEnableOVR( self.appliedCheckEnableOVR )
	end

	if self.currentCheckMouseMove			~= self.appliedCheckMouseMove			then
		self.appliedCheckMouseMove			= self.currentCheckMouseMove
		setGameMouseMode( self.appliedCheckMouseMove )
	end

	if self.currentCheckMouseInvertX		~= self.appliedCheckMouseInvertX		then
		self.appliedCheckMouseInvertX		= self.currentCheckMouseInvertX
		setMouseInvertX( self.appliedCheckMouseInvertX )
	end
	if self.currentCheckMouseInvertY		~= self.appliedCheckMouseInvertY		then
		self.appliedCheckMouseInvertY		= self.currentCheckMouseInvertY
		setMouseInvertY( self.appliedCheckMouseInvertY )
	end
	if self.currentCheckMouseSensitivityX	~= self.appliedCheckMouseSensitivityX	then
		self.appliedCheckMouseSensitivityX		= self.currentCheckMouseSensitivityX
		setMouseSensitivityX( self.appliedCheckMouseSensitivityX )
	end
	if self.currentCheckMouseSensitivityY	~= self.appliedCheckMouseSensitivityY	then
		self.appliedCheckMouseSensitivityY	= self.currentCheckMouseSensitivityY
		setMouseSensitivityY( self.appliedCheckMouseSensitivityY )
	end
	if self.currentHitFxVolume				~= self.appliedHitFxVolume	then
		self.appliedHitFxVolume				= self.currentHitFxVolume
		GameOption_hitFxVolume_button()
	end
	if self.currentCheckPadEnable			~= self.appliedCheckPadEnable			then
		self.appliedCheckPadEnable			= self.currentCheckPadEnable
		setGamePadEnable( self.appliedCheckPadEnable )
	end
	if self.currentCheckPadVibration		~= self.appliedCheckPadVibration		then
		self.appliedCheckPadVibration		= self.currentCheckPadVibration
		setGamePadVibration( self.appliedCheckPadVibration )
	end
	if self.currentCheckPadInvertX			~= self.appliedCheckPadInvertX			then
		self.appliedCheckPadInvertX			= self.currentCheckPadInvertX
		setGamePadInvertX( self.appliedCheckPadInvertX )
	end
	if self.currentCheckPadInvertY			~= self.appliedCheckPadInvertY			then
		self.appliedCheckPadInvertY			= self.currentCheckPadInvertY
		setGamePadInvertY( self.appliedCheckPadInvertY )
	end
	if self.currentCheckPadSensitivityX		~= self.appliedCheckPadSensitivityX		then
		self.appliedCheckPadSensitivityX	= self.currentCheckPadSensitivityX
		setGamePadSensitivityX( self.appliedCheckPadSensitivityX )
	end
	if self.currentCheckPadSensitivityY		~= self.appliedCheckPadSensitivityY		then
		self.appliedCheckPadSensitivityY	= self.currentCheckPadSensitivityY
		setGamePadSensitivityY( self.appliedCheckPadSensitivityY )
	end
	
	if self.currentCheckCameraMasterPower	~= self.appliedCheckCameraMasterPower	then
		self.appliedCheckCameraMasterPower	= self.currentCheckCameraMasterPower
		GameOption_CameraMasterPower_button()
	end
	if self.currentCheckCameraShakePower	~= self.appliedCheckCameraShakePower	then
		self.appliedCheckCameraShakePower	= self.currentCheckCameraShakePower
		GameOption_CameraShakePower_button()
	end
	-- 나의 캐릭터 이름 표시
	if self.currentSelfPlayerNameTagVisible		~= self.appliedSelfPlayerNameTagVisible		then
		self.appliedSelfPlayerNameTagVisible		= self.currentSelfPlayerNameTagVisible
		setSelfPlayerNameTagVisible( self.appliedSelfPlayerNameTagVisible )
	end
	-- 다른 캐릭터 이름 보기
	if self.currentOtherPlayerNameTagVisible		~= self.appliedOtherPlayerNameTagVisible		then
		self.appliedOtherPlayerNameTagVisible		= self.currentOtherPlayerNameTagVisible
		setOtherPlayerNameTagVisible( self.appliedOtherPlayerNameTagVisible )
	end
	-- 파티원 이름 보기
	if self.currentPartyPlayerNameTagVisible		~= self.appliedPartyPlayerNameTagVisible		then
		self.appliedPartyPlayerNameTagVisible		= self.currentPartyPlayerNameTagVisible
		setPartyPlayerNameTagVisible( self.appliedPartyPlayerNameTagVisible )
	end
	if self.currentPetObjectShow				~= self.appliedPetObjectShow			then
		self.appliedPetObjectShow				= self.currentPetObjectShow
		setPetRender( self.appliedPetObjectShow )
	end
	if self.currentNavPathEffectType			~= self.appliedNavPathEffectType			then
		self.appliedNavPathEffectType				= self.currentNavPathEffectType
		setShowNavPathEffectType( self.appliedNavPathEffectType )
	end
	
	if self.currentServiceResourceType			~= self.appliedServiceResourceType		then
		self.appliedServiceResourceType = self.currentServiceResourceType
		ToClient_saveServiceResourceType( self.appliedServiceResourceType )
	end
	
	-- AAA
	if self.currentChatChannelType			~= self.appliedChatChannelType			then
		self.appliedChatChannelType = self.currentChatChannelType
		ToClient_saveChatChannelType( self.appliedChatChannelType )
	end

	-- 길드/클랜원 이름 보기
	if self.currentGuildPlayerNameTagVisible		~= self.appliedGuildPlayerNameTagVisible		then
		self.appliedGuildPlayerNameTagVisible		= self.currentGuildPlayerNameTagVisible
		if ( frame_Game._btn_GuildNameShow:IsCheck() ) then
			self.appliedGuildPlayerNameTagVisible = CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow
		else
			self.appliedGuildPlayerNameTagVisible = CppEnums.VisibleNameTagType.eVisibleNameTagType_ImportantShow
		end
		setGuildPlayerNameTagVisible( self.appliedGuildPlayerNameTagVisible )
	end

	-- 캐릭터 가이드 라인 : 친밀도 고리
	if self.currentGuideLineHumanRelation		~= self.appliedGuideLineHumanRelation		then
		self.appliedGuideLineHumanRelation		= self.currentGuideLineHumanRelation
		setShowHumanRelation( self.appliedGuideLineHumanRelation )
	end

	-- 캐릭터 가이드 라인 : 퀘스트 관련된 것(NPC, 목표물)
	if self.currentGuideLineQuestLine		~= self.appliedGuideLineQuestLine		then
		self.appliedGuideLineQuestLine		= self.currentGuideLineQuestLine
		setShowQuestActorColor( self.appliedGuideLineQuestLine )
	end

	-- 캐릭터 가이드 라인 : 전투/안전 지역 진입
	if self.currentGuideLineZoneChange		~= self.appliedGuideLineZoneChange		then
		self.appliedGuideLineZoneChange		= self.currentGuideLineZoneChange
		setRenderPlayerColor( randerPlayerColorStr.zoneChange, self.appliedGuideLineZoneChange )
	end

	-- 캐릭터 가이드 라인 : 점령전 피아 식별
	if self.currentGuideLineWarAlly		~= self.appliedGuideLineWarAlly		then
		self.appliedGuideLineWarAlly		= self.currentGuideLineWarAlly
		setRenderPlayerColor( randerPlayerColorStr.warAlly, self.appliedGuideLineWarAlly )
	end

	-- 캐릭터 가이드 라인 : 길드원
	if self.currentGuideLineGuild		~= self.appliedGuideLineGuild		then
		self.appliedGuideLineGuild		= self.currentGuideLineGuild
		setRenderPlayerColor( randerPlayerColorStr.guild, self.appliedGuideLineGuild )
	end

	-- 캐릭터 가이드 라인 : 파티원
	if self.currentGuideLineParty		~= self.appliedGuideLineParty		then
		self.appliedGuideLineParty		= self.currentGuideLineParty
		setRenderPlayerColor( randerPlayerColorStr.party, self.appliedGuideLineParty )
	end

	-- 캐릭터 가이드 라인 : 전쟁 적
	if self.currentGuideLineEnemy		~= self.appliedGuideLineEnemy		then
		self.appliedGuideLineEnemy		= self.currentGuideLineEnemy
		setRenderPlayerColor( randerPlayerColorStr.enemy, self.appliedGuideLineEnemy )
	end

	-- 캐릭터 가이드 라인 : 전쟁 비 참여자
	if self.currentGuideLineNonWarPlayer		~= self.appliedGuideLineNonWarPlayer		then
		self.appliedGuideLineNonWarPlayer		= self.currentGuideLineNonWarPlayer
		setRenderPlayerColor( randerPlayerColorStr.nonWarPlayer, self.appliedGuideLineNonWarPlayer )
	end

	-- 파티/길드 초대 차단 옵션
	if self.currentCheckRejectInvitation			~= self.appliedCheckRejectInvitation then
		self.appliedCheckRejectInvitation			= self.currentCheckRejectInvitation
		setRefuseRequests( self.appliedCheckRejectInvitation )
	end
	-- 미니맵 회전 옵션
	if self.currentCheckMiniMapRotation				~= self.appliedCheckMiniMapRotation then
		self.appliedCheckMiniMapRotation			= self.currentCheckMiniMapRotation
		setRotateRadarMode( self.appliedCheckMiniMapRotation )
	end

	-- 공격 판정 이팩트 보기
	if self.currentCheckShowAttackEffect				~= self.appliedCheckShowAttackEffect then
		self.appliedCheckShowAttackEffect			= self.currentCheckShowAttackEffect
		setRenderHitEffect( self.appliedCheckShowAttackEffect )
	end
	
	-- 흑정령 알림 보기
	if self.currentCheckBlackSpiritAlert				~= self.appliedCheckBlackSpiritAlert then
		self.appliedCheckBlackSpiritAlert			= self.currentCheckBlackSpiritAlert
		setBlackSpiritNotice( self.appliedCheckBlackSpiritAlert )
	end

	-- 분리형 퀵슬롯 사용
	if self.currentCheckUseNewQuickSlot				~= self.appliedCheckUseNewQuickSlot then
		self.appliedCheckUseNewQuickSlot			= self.currentCheckUseNewQuickSlot
		ToClient_getGameUIManagerWrapper():setLuaCacheDataListBool(CppEnums.GlobalUIOptionType.NewQuickSlot, self.appliedCheckUseNewQuickSlot)
	end
	
	-- 채팅 필터 사용
	if self.currentCheckUseChattingFilter			~= self.appliedCheckUseChattingFilter then
		self.appliedCheckUseChattingFilter			= self.currentCheckUseChattingFilter
		setUseChattingFilter( self.appliedCheckUseChattingFilter )
	end

	-- 채팅 필터 사용
	if self.currentCheckIsOnScreenSaver			~= self.appliedCheckIsOnScreenSaver then
		self.appliedCheckIsOnScreenSaver			= self.currentCheckIsOnScreenSaver
		setIsOnScreenSaver( self.appliedCheckIsOnScreenSaver )
	end
	
	-- UIMode 마우스 화면 잠금
	if self.currentCheckIsUIModeMouseLock		~= self.appliedCheckIsUIModeMouseLock then
		self.appliedCheckIsUIModeMouseLock			= self.currentCheckIsUIModeMouseLock
		setIsUIModeMouseLock( self.appliedCheckIsUIModeMouseLock )
	end
	
	-- 결투신청 거부
	if self.currentCheckIsPvpRefuse				~= self.appliedCheckIsPvpRefuse then
		self.appliedCheckIsPvpRefuse			= self.currentCheckIsPvpRefuse
		setIsPvpRefuse( self.appliedCheckIsPvpRefuse )
	end
	
	-- 콤보 연계가이드 옵션
	if self.currentCheckShowComboGuide				~= self.appliedCheckShowComboGuide then
		self.appliedCheckShowComboGuide				= self.currentCheckShowComboGuide
		setShowComboGuide( self.appliedCheckShowComboGuide )
		Panel_MovieTheater320_JustClose()
		_currentSpiritGuideCheck = check
	end

	-- 음악 옵션 
	if self.currentCheckMusic						~= self.appliedCheckMusic then
		self.appliedCheckMusic						= self.currentCheckMusic
		setEnableSound( self.currentCheckSound, self.appliedCheckMusic, self.currentCheckEnvSound, self.currentCheckWhisperMusic, self.currentCheckTraySoundOnOff  )
	end
	-- 효과음 옵션
	if self.currentCheckSound						~= self.appliedCheckSound then
		self.appliedCheckSound						= self.currentCheckSound
		setEnableSound( self.appliedCheckSound, self.currentCheckMusic, self.currentCheckEnvSound, self.currentCheckWhisperMusic, self.currentCheckTraySoundOnOff )
	end
	-- 환경 효과음 옵션
	if self.currentCheckEnvSound					~= self.appliedCheckEnvSound then
		self.appliedCheckEnvSound				 	= self.currentCheckEnvSound
		setEnableSound( self.currentCheckSound, self.currentCheckMusic, self.appliedCheckEnvSound, self.currentCheckWhisperMusic, self.currentCheckTraySoundOnOff )
	end
	if self.currentCheckRiddingMusic				~= self.appliedCheckRiddingMusic then
		self.appliedCheckRiddingMusic				= self.currentCheckRiddingMusic
		setEnableRidingSound( self.appliedCheckRiddingMusic )
	end
	
	-- 귓속말 음악
	if self.currentCheckWhisperMusic				~= self.appliedCheckWhisperMusic then
		self.appliedCheckWhisperMusic				= self.currentCheckWhisperMusic
		setEnableSound( self.currentCheckSound, self.currentCheckMusic, self.appliedCheckEnvSound, self.currentCheckWhisperMusic, self.currentCheckTraySoundOnOff )
	end
	
	if self.currentCheckTraySoundOnOff				~= self.appliedCheckTraySoundOnOff then
		self.appliedCheckTraySoundOnOff				= self.currentCheckTraySoundOnOff
		setEnableSound( self.currentCheckSound, self.currentCheckMusic, self.appliedCheckEnvSound, self.currentCheckWhisperMusic, self.currentCheckTraySoundOnOff )
	end
	
	-- 전투 음악 옵션
	if self.currentCheckCombatMusic					~= self.appliedCheckCombatMusic then
		self.appliedCheckCombatMusic				= self.currentCheckCombatMusic
		setEnableBattleSoundType( self.appliedCheckCombatMusic )
	end

	if self.currentCheckUIScale	~= self.appliedCheckUIScale	then
		self.appliedCheckUIScale	= self.currentCheckUIScale
		GameOption_UIScale_Change()
		--UIScale은 바로바뀌면 조종할수가 없어서 확인 ,적용 때 하는것으로 함.
		--self.currentCheckUIScale = math.min( math.max( minScaleValue * 0.01, self.currentCheckUIScale ), maxScaleValue * 0.01 )
		setUIScale( self.currentCheckUIScale )
		--isResetUI = true
		--isChangedDisplay = true
	end
	gamePanel_Main._btn_Apply:SetEnable( false )

	--	디스플레이 변경 여부 체크
	if true == isChangedDisplay then
		local messageboxData	= { 
			title = "changeDisplay", 
			content = PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_DISPLAYCOMMIT_COMMENT" ),
			functionApply = GameOption_ChangeDisplayApply, 
			functionCancel = GameOption_ChangeDisplayCancel, 
			priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW,
			isTimeCount = true,	-- messageBox Timer
			countTime = 10.0,
			timeString = PAGetString( Defines.StringSheet_GAME, "LUA_OPTION_DISPLAYCOMMIT_TIMELEFT" ),
			isStartTimer = true,
			afterFunction = GameOption_ChangeDisplayTimeOut,
		}
		allClearMessageData()
		MessageBox.showMessageBox( messageboxData )
	else
		saveGameOption(false)
	end

	keyCustom_applyChange()
	keyCustom_StartEdit()
		
	-- 흑정령 가이드(임시용)
	if frame_Game._btn_SpiritGuide:IsCheck() ~= _currentSpiritGuideCheck then
		_currentSpiritGuideCheck = frame_Game._btn_SpiritGuide:IsCheck()
	end
	if isLuaLoadingComplete then
		FGlobal_SetMamageShow()	-- 공격 판정 이팩트 표시 값 처리.
		FGlobal_NewMainQuest_Alarm_Check()

		QuickSlot_UpdateData()
		FGlobal_NewQuickSlot_Update()
	end
end

-- 흑정령 가이드(임시용)
function FGlobal_SpiritGuide_IsShow()
	return _currentSpiritGuideCheck
end

--	디스플레이 옵션 변경 허용
function GameOption_ChangeDisplayApply()
	if isNeedGameOptionFromServer() == true then
		FGlobal_QuestWindowRateSetting()
	end
	saveGameOption(true)

	local self = chk_Option

	self.savedScreenModeIdx 			= self.appliedScreenModeIdx

	-- 스크린샷 포맷
	self.savedScreenShotFormat 			= self.appliedScreenShotFormat

	-- 색약 모드
	self.savedColorBlind 				= self.appliedColorBlind

	-- 다른 플레이어 이팩트	
	self.savedSelfPlayerOnlyEffect 		= self.appliedSelfPlayerOnlyEffect
	
	-- 가까운 플레이어 이팩트	
	self.savedNearestPlayerOnlyEffect 	= self.appliedNearestPlayerOnlyEffect
	
	self.savedSelfPlayerOnlyLantern 	= self.appliedSelfPlayerOnlyLantern

	self.savedUpscaleEnable	 			= self.appliedUpscaleEnable
	self.savedSleepModeEnable	 			= self.appliedSleepModeEnable
	
	self.savedCropModeEnable	 		= self.appliedCropModeEnable
	self.savedCropModeScaleX	 		= self.appliedCropModeScaleX
	self.savedCropModeScaleY	 		= self.appliedCropModeScaleY
	
	self.savedLUT				 		= self.currentLUT
	
	self.savedScreenResolutionIdx 		= self.appliedScreenResolutionIdx

	self.savedTextureQualityIdx 		= self.appliedTextureQualityIdx

	self.savedGraphicOptionIdx 			= self.appliedGraphicOptionIdx

	self.savedCheckDof 					= self.appliedCheckDof

	self.savedCheckAA 					= self.appliedCheckAA
	
	self.savedCheckUltra				= self.appliedCheckUltra

	self.savedCheckLensBlood 			= self.appliedCheckLensBlood	

	self.savedCheckSSAO 				= self.appliedCheckSSAO
	self.savedCheckTessellation			= self.appliedCheckTessellation
	self.savedCheckPostFilter			= self.appliedCheckPostFilter
	self.savedCheckCharacterEffect		= self.appliedCheckCharacterEffect
	
	self.savedGammaValue 				= self.currentGammaValue
	self.savedContrastValue 			= self.currentContrastValue

	self.savedMaster 					= self.currentMaster
	self.savedMusic 					= self.currentMusic
	self.savedFxSound 					= self.currentFxSound
	self.savedEnvSound 					= self.currentEnvSound
	self.savedDlgSound 					= self.currentDlgSound
	self.savedHitFxVolume 				= self.currentHitFxVolume
	self.savedHitFxWeight 				= self.currentHitFxWeight
	self.savedPlayerVolume 				= self.currentPlayerVolume
	self.savedCheckCombatMusic			= self.currentCheckCombatMusic

	self.savedCheckMusic 				= self.appliedCheckMusic
	self.savedCheckSound 				= self.appliedCheckSound
	self.savedCheckEnvSound				= self.appliedCheckEnvSound

	self.savedCheckCombatMusic			= self.appliedCheckCombatMusic
	self.savedCheckRiddingMusic			= self.appliedCheckRiddingMusic
	self.savedCheckWhisperMusic			= self.appliedCheckWhisperMusic
	self.savedCheckTraySoundOnOff		= self.appliedCheckTraySoundOnOff

	self.savedCheckShowSkillCmd 		= self.appliedCheckShowSkillCmd

	self.savedCheckAutoAim				= self.appliedCheckAutoAim

	self.savedCheckHideWindowByAttacked = self.appliedCheckHideWindowByAttacked
	
	self.savedCheckShowGuildLoginMessage = self.appliedCheckShowGuildLoginMessage
	
	self.savedCheckEnableSimpleUI 		= self.appliedCheckEnableSimpleUI
	self.savedCheckRenderCharacterColor	= self.appliedCheckRenderCharacterColor

	self.savedCheckMouseMove			= self.appliedCheckMouseMove

	self.savedCheckMouseInvertX			= self.appliedCheckMouseInvertX
	
	self.savedCheckMouseInvertY			= self.appliedCheckMouseInvertY
	self.savedCheckMouseSensitivityX	= self.appliedCheckMouseSensitivityX
	self.savedCheckMouseSensitivityY 	= self.appliedCheckMouseSensitivityY
	self.savedCheckPadEnable 			= self.appliedCheckPadEnable
	self.savedCheckPadVibration 		= self.appliedCheckPadVibration
	self.savedCheckPadInvertX 			= self.appliedCheckPadInvertX
	self.savedCheckPadInvertY 			= self.appliedCheckPadInvertY
	self.savedCheckPadSensitivityX 		= self.appliedCheckPadSensitivityX
	self.savedCheckPadSensitivityY 		= self.appliedCheckPadSensitivityY
	
	self.savedCheckCameraMasterPower 	= self.appliedCheckCameraMasterPower
	self.savedCheckCameraShakePower 	= self.appliedCheckCameraShakePower
	self.savedCheckMotionBlurPower 		= self.appliedCheckMotionBlurPower
	self.savedCheckCameraPosPower 			= self.appliedCheckCameraPosPower
	self.savedCheckCameraFovPower 			= self.appliedCheckCameraFovPower
	
	self.savedCheckSelfNameShow 		= self.appliedCheckSelfNameShow

	self.savedCheckUIScale 				= self.appliedCheckUIScale

	self.savedPetObjectShow				= self.appliedPetObjectShow
	self.savedNavPathEffectType			= self.appliedNavPathEffectType

	self.savedServiceResourceType		= self.appliedServiceResourceType
	self.savedChatChannelType			= self.appliedChatChannelType

	self.savedFovValue = self.appliedFovValue 
	
	reloadGameUI()
end

--	디스플레이 옵션 이전으로 되돌림
function GameOption_ChangeDisplayCancel()
	local self = chk_Option
	if self.appliedScreenModeIdx ~= self.savedScreenModeIdx then
		self.appliedScreenModeIdx = self.savedScreenModeIdx
		GameOption_SetCurrentScreenMode( self.savedScreenModeIdx )
		setScreenMode ( self.savedScreenModeIdx )
	end

	if self.appliedScreenResolutionIdx ~= self.savedScreenResolutionIdx then
		local index = self.savedScreenResolutionIdx
		self.appliedScreenResolutionIdx = index
		GameOption_SetCurrentScreenResolution( index )
		setScreenResolution( self.screenResolutionList[ index ].width, self.screenResolutionList[ index ].height )
	end

	if self.appliedCheckUIScale ~= self.savedCheckUIScale then
	    self.savedCheckUIScale = math.min( math.max( minScaleValue * 0.01 , self.savedCheckUIScale ), maxScaleValue * 0.01 )
	    self.savedCheckUIScale = math.ceil( self.savedCheckUIScale * 100 ) / 100
		setUIScale( self.savedCheckUIScale );
		self.appliedCheckUIScale = self.savedCheckUIScale
		GameOption_SetUIMode( self.appliedCheckUIScale );
	end
end

function GameOption_ChangeDisplayTimeOut()
	if true == MessageBox.isPopUp() then
		messageBox_CancelButtonUp()
	end
end

function GameExitOpen()
	GameExitShowToggle()
	GameOption_Cancel()
end

function GameUIRepos()
	Panel_UIControl_SetShow( true )								-- 컨트롤 창 켜기
	GameOption_Cancel()
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

function GameOption_ReSetKeyConfig( target )
	if 0 == target then
		keyCustom_SetDefaultAction()
		KeyCustom_Action_UpdateButtonText_Key()
		KeyCustom_Action_UpdateButtonText_Pad()
		GameOption_Apply()
	elseif 1 == target then
		keyCustom_SetDefaultUI()
		KeyCustom_Ui_UpdateButtonText_Key()
		KeyCustom_Ui_UpdateButtonText_Pad()
		GameOption_Apply()
	else
		return
	end
end


function GameOption_ResetAllOption()

	GameOption_ResetDisplayOption()
	GameOption_ResetSoundOption()
	GameOption_ResetGameOption()
	
	keyCustom_SetDefaultAction()
	KeyCustom_Action_UpdateButtonText_Key()
	KeyCustom_Action_UpdateButtonText_Pad()
	keyCustom_SetDefaultUI()
	KeyCustom_Ui_UpdateButtonText_Key()
	KeyCustom_Ui_UpdateButtonText_Pad()
	
	GameOption_Apply()
end



function GameOption_DefaultOption( gameOptionSetting, optionType )
	-- Graphic Option
	if (optionType == 1) then
		chk_Option.RESOLUTION_WIDTH 			= gameOptionSetting:getScreenResolutionWidth()
		chk_Option.RESOLUTION_HEIGHT 			= gameOptionSetting:getScreenResolutionHeight()
		
		chk_Option.currentScreenModeIdx 		= gameOptionSetting:getScreenMode()
		chk_Option.currentScreenShotFormat 		= gameOptionSetting:getScreenShotFormat()
		chk_Option.currentColorBlind			= ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(CppEnums.GlobalUIOptionType.ColorBlindMode)
		chk_Option.currentSelfPlayerOnlyEffect 	= gameOptionSetting:getSelfPlayerOnlyEffect()
		chk_Option.currentNearestPlayerOnlyEffect = gameOptionSetting:getNearestPlayerOnlyEffect()
		chk_Option.currentSelfPlayerOnlyLantern	= gameOptionSetting:getSelfPlayerOnlyLantern()
		chk_Option.currentUpscaleEnable 		= gameOptionSetting:getUpscaleEnable()
		chk_Option.currentSleepModeEnable 		= gameOptionSetting:getSleepModeEnable()
		chk_Option.currentCropModeEnable 		= gameOptionSetting:getCropModeEnable()
		chk_Option.currentCropModeScaleX 		= gameOptionSetting:getCropModeScaleX()
		chk_Option.currentCropModeScaleY 		= gameOptionSetting:getCropModeScaleY()
		chk_Option.currentLUT			 		= gameOptionSetting:getCameraLUTFilter()
		chk_Option.currentScreenResolutionIdx 	= GameOption_FindScreenResolutionIdx( chk_Option.RESOLUTION_WIDTH, chk_Option.RESOLUTION_HEIGHT )
		chk_Option.currentTextureQualityIdx 	= gameOptionSetting:getTextureQuality()
		chk_Option.currentGraphicOptionIdx 		= gameOptionSetting:getGraphicOption()
		chk_Option.currentGammaValue 			= gameOptionSetting:getGammaValue()
		chk_Option.currentContrastValue 		= gameOptionSetting:getContrastValue()
		
		chk_Option.currentCheckDof 				= gameOptionSetting:getDof()
		chk_Option.currentCheckAA 				= gameOptionSetting:getAntiAliasing()
		chk_Option.currentCheckUltra 			= gameOptionSetting:getGraphicUltra()
		chk_Option.currentCheckLensBlood 		= gameOptionSetting:getLensBlood()
		chk_Option.currentCheckBloodEffect 		= (0 ~= gameOptionSetting:getBloodEffect())
		
		chk_Option.currentCheckSSAO				= gameOptionSetting:getSSAO()
		chk_Option.currentCheckTessellation		= gameOptionSetting:getTessellation()
		chk_Option.currentCheckPostFilter		= (0 ~= gameOptionSetting:getPostFilter())
		chk_Option.currentCheckCharacterEffect	= gameOptionSetting:getCharacterEffect()
		
		chk_Option.currentCheckUIScale			= 1.0-- 왜 글로벌 스케일을 가져오게 했지..gameOptionSetting:getUIScale()
		chk_Option.currentFovValue 				= gameOptionSetting:getFov()
		
		chk_Option.currentCheckCameraMasterPower= gameOptionSetting:getCameraMasterPower()
		chk_Option.currentCheckCameraShakePower	= gameOptionSetting:getCameraShakePower()
		chk_Option.currentCheckMotionBlurPower	= gameOptionSetting:getMotionBlurPower()
		chk_Option.currentCheckCameraPosPower 	= gameOptionSetting:getCameraTranslatePower()
		chk_Option.currentCheckCameraFovPower 	= gameOptionSetting:getCameraFovPower()
	end
	
	-- Sound Option
	if (optionType == 2) then
		chk_Option.currentMaster 				= gameOptionSetting:getMasterVolume()
		chk_Option.currentMusic 				= gameOptionSetting:getMusicVolume()
		chk_Option.currentFxSound 				= gameOptionSetting:getFxVolume()
		chk_Option.currentEnvSound 				= gameOptionSetting:getEnvSoundVolume()
		chk_Option.currentCheckCombatMusic		= gameOptionSetting:getEnableBattleSoundType()
		chk_Option.currentDlgSound 				= gameOptionSetting:getDialogueVolume()
		chk_Option.currentHitFxVolume 			= gameOptionSetting:getHitFxVolume()
		chk_Option.currentHitFxWeight 			= gameOptionSetting:getHitFxWeight()
		chk_Option.currentPlayerVolume 			= gameOptionSetting:getOtherPlayerVolume()

		chk_Option.currentCheckMusic 			= gameOptionSetting:getEnableMusic()
		chk_Option.currentCheckSound 			= gameOptionSetting:getEnableSound()
		chk_Option.currentCheckEnvSound 		= gameOptionSetting:getEnableEnvSound()
	end
	
	-- Game Option
	if (optionType == 3) then
		--chk_Option.currentCheckNameTag 				= gameOptionSetting:
		chk_Option.currentCheckShowSkillCmd 		= gameOptionSetting:getShowSkillCmd()
		chk_Option.currentCheckShowComboGuide		= gameOptionSetting:getShowComboGuide()
		chk_Option.currentCheckAutoAim		 		= gameOptionSetting:getAimAssist()
		chk_Option.currentCheckHideWindowByAttacked	= gameOptionSetting:getHideWindowByAttacked()
		chk_Option.currentCheckShowGuildLoginMessage= gameOptionSetting:getShowGuildLoginMessage()
		chk_Option.currentCheckEnableSimpleUI		= gameOptionSetting:getEnableSimpleUI()
		chk_Option.currentCheckMouseMove			= gameOptionSetting:getGameMouseMode()
		chk_Option.currentCheckEnableOVR			= gameOptionSetting:getEnableOVR()

		chk_Option.currentCheckMouseInvertX			= gameOptionSetting:getMouseInvertX()
		chk_Option.currentCheckMouseInvertY			= gameOptionSetting:getMouseInvertY()
		chk_Option.currentCheckMouseSensitivityX	= gameOptionSetting:getMouseSensitivityX()
		chk_Option.currentCheckMouseSensitivityY	= gameOptionSetting:getMouseSensitivityY()
		chk_Option.currentCheckPadEnable			= gameOptionSetting:getGamePadEnable()
		chk_Option.currentCheckPadVibration			= gameOptionSetting:getGamePadVibration()
		chk_Option.currentCheckPadInvertX			= gameOptionSetting:getGamePadInvertX()
		chk_Option.currentCheckPadInvertY			= gameOptionSetting:getGamePadInvertY()
		chk_Option.currentCheckPadSensitivityX		= gameOptionSetting:getGamePadSensitivityX()
		chk_Option.currentCheckPadSensitivityY		= gameOptionSetting:getGamePadSensitivityY()
		chk_Option.currentSelfPlayerNameTagVisible	= gameOptionSetting:getSelfPlayerNameTagVisible()
		chk_Option.currentOtherPlayerNameTagVisible	= gameOptionSetting:getOtherPlayerNameTagVisible()
		chk_Option.currentPartyPlayerNameTagVisible	= gameOptionSetting:getPartyPlayerNameTagVisible()
		chk_Option.currentGuildPlayerNameTagVisible	= gameOptionSetting:getGuildPlayerNameTagVisible()
		chk_Option.currentPetObjectShow				= gameOptionSetting:getPetRender()
		chk_Option.currentNavPathEffectType			= gameOptionSetting:getShowNavPathEffectType()
		chk_Option.currentServiceResourceType		= gameOptionSetting:getServiceResType()
		chk_Option.currentChatChannelType			= gameOptionSetting:getChatLanguageType()
	end
end


function GameOption_ResetDisplayOption()
	resetDisplayOption()
	--setDefaultDisplayOption()
	-- 게임 창 설정
	GameOption_SetScreenModeButtons( chk_Option.currentScreenModeIdx )
		
	-- 게임 해상도
	if chk_Option.currentScreenResolutionIdx == 0 then
		GameOption_SetScreenResolutionText_exception( chk_Option.RESOLUTION_WIDTH, chk_Option.RESOLUTION_HEIGHT )
	else
		GameOption_SetScreenResolutionText( chk_Option.currentScreenResolutionIdx )
	end
	
	GameOption_SetCurrentLUT( chk_Option.currentLUT )
	
	-- 인터페이스 크기 조절
	local uiScale_Percent = 100--(chk_Option.currentCheckUIScale * 100)
	local pos = (( uiScale_Percent - minScaleValue) / ( maxScaleValue - minScaleValue ))	* 100
	

	frame_Display._slide_UIScale:SetControlPos(	pos );		
	frame_Display._txt_UIScale:SetText( GetStr_Option[5].." ( <PAColor0xffbcf281>" ..string.format("%.0f", uiScale_Percent) .."% <PAOldColor>)" )
	--GameOption_SetUIMode( uiScale )
	--GameOption_UIScale_Change()
	
	-- 카메라 효과 전체 설정
	GameOption_SetCameraMasterPower()
	-- 카메라 진동 설정
	GameOption_SetCameraShakePower()
	-- 카메라 잔상 효과
	GameOption_SetMotionBlurPower()	
	-- 카메라 각도 효과 설정
	GameOption_SetCameraPosPower()
	-- 카메라 확대 축소 효과 설정	
	GameOption_SetCameraFovPower() 	
	
	-- 텍스쳐 품질
	GameOption_SetTextureQualityText( chk_Option.currentTextureQualityIdx )
	-- 그래픽 품질
	GameOption_SetGraphicOptionText( chk_Option.currentGraphicOptionIdx )
	GameOption_SetGraphicCustomOption()
	-- 감마 조절
	frame_Display._slide_Gamma:SetControlPos( chk_Option.currentGammaValue * 100 ) -- 0~100
	GameOption_SetGammaValueText( chk_Option.currentGammaValue )
	
	-- 대비 조절
	frame_Display._slide_Contrast:SetControlPos( chk_Option.currentContrastValue * 100 ) -- 0~100
	GameOption_SetContrastValueText( chk_Option.currentContrastValue )
	--GameOption_SetContrast( chk_Option.currentContrastValue )
	
	-- 스크린샷 포맷 설정
	GameOption_CheckScreenShotFormat( chk_Option.currentScreenShotFormat )

	-- 색약 모드
	GameOption_CheckColorBlind( chk_Option.currentColorBlind )

	-- 멀리있는 플레이어 이펙트 제거
	frame_Display._btn_SelfPlayerOnlyEffect:SetCheck( chk_Option.currentSelfPlayerOnlyEffect )
	GameOption_CheckSelfPlayerOnlyEffect()
	-- 다른 플레이어 이펙트 제거
	frame_Display._btn_NearestPlayerOnlyEffect:SetCheck( chk_Option.currentNearestPlayerOnlyEffect )
	GameOption_CheckNearestPlayerOnlyEffect()
	-- 멀리있는 플레이어 랜턴 제거
	frame_Display._btn_SelfPlayerOnlyLantern:SetCheck( chk_Option.currentSelfPlayerOnlyLantern )
	GameOption_CheckSelfPlayerOnlyLantern()
	
	-- 업스케일
	frame_Display._btn_UpscaleEnable:SetCheck( chk_Option.currentUpscaleEnable )
	GameOption_CheckUpscale()
	-- SleepMode
	frame_Display._btn_SleepModeEnable:SetCheck( chk_Option.currentSleepModeEnable )
	GameOption_CheckSleepMode()
	
	-- 크롭모드
	frame_Display._btn_CropModeEnable:SetCheck( chk_Option.currentCropModeEnable )
	frame_Display._slide_CropModeScaleX:SetControlPos( chk_Option.currentCropModeScaleX * 200 - 100 ) -- 50~100
	frame_Display._slide_CropModeScaleY:SetControlPos( chk_Option.currentCropModeScaleY * 200 - 100 )
	GameOption_CheckCropMode()
	-- 시야각조절
	local sliderValue = ( chk_Option.currentFovValue - 40 ) / 30  * 100
	frame_Display._slide_Fov:SetControlPos( sliderValue )
	GameOption_SetFov( chk_Option.currentFovValue )
	GameOption_SetFovValueText( chk_Option.currentFovValue )
	
	GameOption_UpdateOptionChanged()
end

function GameOption_ResetSoundOption()
	resetSoundOption()
	--setDefaultSoundOption()

	-- 음악 켜기/끄기
	frame_Sound._btn_MusicOnOff:SetCheck( chk_Option.currentCheckMusic )
	-- 효과음 켜기/끄기
	frame_Sound._btn_FXOnOff:SetCheck( chk_Option.currentCheckSound )
	-- 환경 효과음 켜기/끄기
	frame_Sound._btn_EnvFXOnOff:SetCheck( chk_Option.currentCheckEnvSound )
	
	frame_Sound._btn_RiddingOnOff:SetCheck( chk_Option.currentCheckRiddingMusic )

	frame_Sound._btn_WhisperOnOff:SetCheck( chk_Option.currentCheckWhisperMusic )

	frame_Sound._btn_TraySoundOnOff:SetCheck( chk_Option.currentCheckTraySoundOnOff )

	local updateCombatSoundTarget = {
		[CppEnums.BattleSoundType.Sound_NotUse]		= frame_Sound._btn_CombatAllwaysOff,
		[CppEnums.BattleSoundType.Sound_Always]		= frame_Sound._btn_CombatAllwaysOn,
		[CppEnums.BattleSoundType.Sound_Nomal]		= frame_Sound._btn_CombatAllwaysLowOff,
	}
	for key, value in pairs(updateCombatSoundTarget) do
		value:SetCheck( key == chk_Option.currentCheckCombatMusic )
	end

	self.currentMaster = 0
	self.currentMusic = 0
	self.currentFxSound = 0
	self.currentEnvSound = 0
	self.currentDlgSound = 0
	self.currentHitFxWeight = 0
	self.currentPlayerVolume = 0
	
	-- 전체 크기 조절
	frame_Sound._slide_TotalVol:SetControlPos( chk_Option.currentMaster )	-- 0~100
	-- 음악 크기 조절
	frame_Sound._slide_MusicVol:SetControlPos( chk_Option.currentMusic )
	-- 효과음 크기 조절
	frame_Sound._slide_FxVol:SetControlPos( chk_Option.currentFxSound )
	-- 환경 효과음 조절
	frame_Sound._slide_EnvFxVol:SetControlPos( chk_Option.currentEnvSound )
	-- 음성 효과음 조절
	frame_Sound._slide_VoiceVol:SetControlPos( chk_Option.currentDlgSound )
	-- 전투 효과음 조절
	frame_Sound._slide_hitFxVolume:SetControlPos( chk_Option.currentHitFxVolume )
	-- 타격음 크기 조절
	frame_Sound._slide_hitFxWeightVolume:SetControlPos( chk_Option.currentHitFxWeight )
	-- 다른 유저의 크기 조절
	frame_Sound._slide_otherPlayerVolume:SetControlPos( chk_Option.currentPlayerVolume )
	
	GameOption_SetVolumeText( chk_Option.currentMaster, chk_Option.currentFxSound, chk_Option.currentDlgSound, chk_Option.currentEnvSound, chk_Option.currentMusic, chk_Option.currentHitFxVolume, chk_Option.currentHitFxWeight, chk_Option.currentPlayerVolume )
end

function GameOption_ResetGameOption()
	resetGameOption()
	--setDefaultGameOption()
	
	local mouseSensitivityX_Percent = ( chk_Option.currentCheckMouseSensitivityX -0.1) / 1.9 * 100
	local mouseSensitivityY_Percent = ( chk_Option.currentCheckMouseSensitivityY -0.1) / 1.9 * 100
	local padSensitivityX_Percent	= ( chk_Option.currentCheckPadSensitivityX -0.1) / 1.9 * 100
	local padSensitivityY_Percent	= ( chk_Option.currentCheckPadSensitivityY -0.1) / 1.9 * 100
	
	_currentSpiritGuideCheck		= chk_Option.currentCheckShowComboGuide
	--chk_Option.currentCheckNameTag 				
				
	-- 액션 연계 가이드 표시
	Panel_SkillCommand:SetShow( chk_Option.currentCheckShowSkillCmd, false)
	isChecked_SkillCommand = chk_Option.currentCheckShowSkillCmd
	-- 캐릭터 정보 상시 표시
	local updateTarget = {
		[CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow]	= frame_Game._btn_SelfNameShowAllways,
		[CppEnums.VisibleNameTagType.eVisibleNameTagType_ImportantShow] = frame_Game._btn_SelfNameShowImportant,
		[CppEnums.VisibleNameTagType.eVisibleNameTagType_NoShow]		= frame_Game._btn_SelfNameShowNoShow,
	}

	local updatePetTarget = {
		[CppEnums.PetVisibleType.ePetVisibleType_All]	= frame_Game._btn_PetAll,
		[CppEnums.PetVisibleType.ePetVisibleType_Mine]	= frame_Game._btn_PetMine,
		[CppEnums.PetVisibleType.ePetVisibleType_Hide]	= frame_Game._btn_PetHide,
	}

	local updateNavPathEffect = {
		[CppEnums.NavPathEffectType.eNavPathEffectType_None]		= frame_Game._btn_NavGuideNone,
		[CppEnums.NavPathEffectType.eNavPathEffectType_Arrow]		= frame_Game._btn_NavGuideArrow,
		[CppEnums.NavPathEffectType.eNavPathEffectType_PathEffect]	= frame_Game._btn_NavGuideEffect,
		[CppEnums.NavPathEffectType.eNavPathEffectType_Fairy]		= frame_Game._btn_NavGuideFairy,
	}
	
	for key, value in pairs(updateTarget) do
		value:SetCheck( key == chk_Option.currentSelfPlayerNameTagVisible )
	end

	for key, value in pairs(updatePetTarget) do
		value:SetCheck( key == chk_Option.currentPetObjectShow )
	end

	for key, value in pairs(updateNavPathEffect) do
		value:SetCheck( key == chk_Option.currentNavPathEffectType )
	end


	-- 캐릭터 정보 상시 표시
	frame_Game._btn_OtherNameShow:SetCheck( CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow == chk_Option.currentOtherPlayerNameTagVisible )
	-- 캐릭터 정보 상시 표시
	frame_Game._btn_PartyNameShow:SetCheck( CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow == chk_Option.currentPartyPlayerNameTagVisible )
	-- 캐릭터 정보 상시 표시
	frame_Game._btn_GuildNameShow:SetCheck( CppEnums.VisibleNameTagType.eVisibleNameTagType_AllwaysShow == chk_Option.currentGuildPlayerNameTagVisible )

	-- 캐릭터 가이드 라인 : 친밀도 고리
	frame_Game._btn_GuideLineHumanRelation	:SetCheck( chk_Option.currentGuideLineHumanRelation )

	-- 캐릭터 가이드 라인 : 퀘스트 관련된 것(목표물, NPC)
	frame_Game._btn_GuideLineQuestObject	:SetCheck( chk_Option.currentGuideLineQuestLine )
	-- 캐릭터 가이드 라인 : 전투/안전 지역 진입
	frame_Game._btn_GuideLineZoneChange		:SetCheck( chk_Option.currentGuideLineZoneChange )
	-- 캐릭터 가이드 라인 : 점령전 피아 식별
	frame_Game._btn_GuideLineWarAlly		:SetCheck( chk_Option.currentGuideLineWarAlly )
	-- 캐릭터 가이드 라인 : 길드원
	frame_Game._btn_GuideLineGuild			:SetCheck( chk_Option.currentGuideLineGuild )
	-- 캐릭터 가이드 라인 : 파티원
	frame_Game._btn_GuideLineParty			:SetCheck( chk_Option.currentGuideLineParty )
	-- 캐릭터 가이드 라인 : 전쟁 적
	frame_Game._btn_GuideLineEnemy			:SetCheck( chk_Option.currentGuideLineEnemy )
	-- 캐릭터 가이드 라인 : 전쟁 비 참여자
	frame_Game._btn_GuideLineNonWarPlayer	:SetCheck( chk_Option.currentGuideLineNonWarPlayer )


	-- 조준 도우미 활성화
	frame_Game._btn_AutoAim:SetCheck( chk_Option.currentCheckAutoAim )
	-- 피격 시 유아이 창 숨기기
	frame_Game._btn_HideWindow:SetCheck( chk_Option.currentCheckHideWindowByAttacked )
	-- 피격 시 유아이 창 숨기기
	frame_Game._btn_GuildLogin:SetCheck( chk_Option.currentCheckShowGuildLoginMessage )
	-- 실시간 키 입력 표시
	-- frame_Game._btn_ShowKeyGuide:SetCheck( false )
	-- 파티 길드 초대 거부
	frame_Game._btn_RejectInvitation:SetCheck( chk_Option.currentCheckRejectInvitation )
	-- 유아이 간소화
	frame_Game._btn_EnableSimpleUI:SetCheck( chk_Option.currentCheckEnableSimpleUI )	

	-- 게임 팁 켜고/끄기
	-- frame_Game._btn_GameTip:SetCheck( true )

	-- 연계기 영상가이드 보이기
	value_GameOption_Check_ComboGuide:SetCheck( chk_Option.currentCheckShowComboGuide )
	-- 마우스 이동 끄기
	frame_Game._btn_MouseMove:SetCheck( chk_Option.currentCheckMouseMove )
	-- 미니맵 회전하기
	frame_Game._btn_MiniMapRotation:SetCheck( chk_Option.currentCheckMiniMapRotation)
	-- 공격 판정 이펙트 보기
	frame_Game._btn_ShowAttackEffect:SetCheck( chk_Option.currentCheckShowAttackEffect)
	-- 흑정령 알림 보기
	frame_Game._btn_Alert_BlackSpirit:SetCheck( chk_Option.currentCheckBlackSpiritAlert)
	-- 분리형 퀵슬롯 사용
	frame_Game._btn_UseNewQuickSlot:SetCheck( chk_Option.currentCheckUseNewQuickSlot)
	-- 채팅 필터 기능
	frame_Game._btn_UseChattingFilter:SetCheck( chk_Option.currentCheckUseChattingFilter )
	-- 스크린세이버 on/off기능
	frame_Game._btn_IsOnScreenSaver:SetCheck( chk_Option.currentCheckIsOnScreenSaver )
	-- UI모드 마우스 화면잠금 on/off
	frame_Game._btn_UIModeMouseLock:SetCheck( chk_Option.currentCheckIsUIModeMouseLock )
	-- 결투신청 거부 on/off기능
	frame_Game._btn_PvpRefuse:SetCheck( chk_Option.currentCheckIsPvpRefuse )
	-- 오큘러스
	frame_Game._btn_EnableOVR:SetCheck( chk_Option.currentCheckEnableOVR )	
	-- 마우스 수평반전
	frame_Game._btn_MouseX:SetCheck( chk_Option.currentCheckMouseInvertX )
	-- 마우스 수직반전
	frame_Game._btn_MouseY:SetCheck( chk_Option.currentCheckMouseInvertY )
	-- 마우스 수평감도
	frame_Game._slide_MouXSen:SetControlPos(mouseSensitivityX_Percent)
	frame_Game._txt_MouXSen:SetText( GetStr_Option[12].. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(mouseSensitivityX_Percent, 			100) ) .. "% <PAOldColor>) " )
	-- 마우스 수직감도
	frame_Game._slide_MouYSen:SetControlPos(mouseSensitivityY_Percent)
	frame_Game._txt_MouYSen:SetText( GetStr_Option[13].. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(mouseSensitivityY_Percent, 			100) ) .. "% <PAOldColor>) " )
	-- 게임 패드사용
	frame_Game._btn_UsePad:SetCheck( chk_Option.currentCheckPadEnable )
	-- 게임 패드 진동 활성화
	frame_Game._btn_UseVibe:SetCheck( chk_Option.currentCheckPadVibration )
	-- 게임패드 수평반전
	frame_Game._btn_PadX:SetCheck( chk_Option.currentCheckPadInvertX )
	-- 게임패드 수직반전
	frame_Game._btn_PadY:SetCheck( chk_Option.currentCheckPadInvertY )
	-- 게임패드 수평감도
	frame_Game._slide_PadXSen:SetControlPos(padSensitivityX_Percent)
	frame_Game._txt_PadXSen:SetText( GetStr_Option[14].. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(padSensitivityX_Percent, 			100) ) .. "% <PAOldColor>) " )
	-- 게임패드 수직감도
	frame_Game._slide_PadYSen:SetControlPos(padSensitivityY_Percent)
	frame_Game._txt_PadYSen:SetText( GetStr_Option[15].. " ( <PAColor0xffbcf281>" .. string.format("%.0f", math.min(padSensitivityY_Percent, 			100) ) .. "% <PAOldColor>) " )
end

-- UI 포지션 초기화
function GameOption_UIPositon_Reset()

end

function GameOption_SimpleToolTips( isShow, optionType )
	if optionType == 1 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_TOOLTIP_DISPLAY_NAME") -- "화면 설정"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_TOOLTIP_DISPLAY_DESC") -- "게임의 화면과 효과 등을 조정할 수 있습니다. 현재 플레이하는 PC의 사양에 맞춰 알맞게 조정할 수 있습니다."
		uiControl = gamePanel_Main._btn_Display
	elseif optionType == 2 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_TOOLTIP_SOUND_NAME") -- "소리 설정"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_TOOLTIP_SOUND_DESC") -- "게임에서 나오는 모든 소리를 켜고 끄거나, 크기를 자유롭게 조정할 수 있습니다."
		uiControl = gamePanel_Main._btn_Sound
	elseif optionType == 3 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_TOOLTIP_GMAE_NAME") -- "게임 설정"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_TOOLTIP_GMAE_DESC") -- "게임의 세부적인 기능을 켜고 끄거나, 보다 사용자의 편의에 맞춰 조정할 수 있습니다."
		uiControl = gamePanel_Main._btn_Game
	elseif optionType == 4 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_TOOLTIP_KEYCONFIG_NAME") -- "입력버튼 설정"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_TOOLTIP_KEYCONFIG_DESC") -- "게임에서 사용되는 조작 키를 키보드 또는 지원하는 게임 패드에 사용자가 직접 적용하여 사용할 수 있습니다."
		uiControl = gamePanel_Main._btn_KeyConfig
	elseif optionType == 5 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_TOOLTIP_KEYCONFIGUI_NAME") -- "UI 단축키 설정"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_TOOLTIP_KEYCONFIGUI_DESC") -- "게임에서 사용되는 인터페이스용 키를 키보드 또는 지원하는 게임 패드에 사용자가 직접 적용하여 사용할 수 있습니다."
		uiControl = gamePanel_Main._btn_KeyConfig_UI
	elseif optionType == 6 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_TOOLTIP_LANGUAGE_NAME") -- "UI 단축키 설정"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_TOOLTIP_LANGUAGE_DESC") -- "게임에서 사용되는 인터페이스용 키를 키보드 또는 지원하는 게임 패드에 사용자가 직접 적용하여 사용할 수 있습니다."
		uiControl = gamePanel_Main._btn_Language
	end

	if isShow == true then
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 심플툴팁 출력함수
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Button_Simpletooltips( isShow, targetNo )
	if true == isShow then
		registTooltipControl(toolTipIdxValue[targetNo].control, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( toolTipIdxValue[targetNo].control, toolTipIdxValue[targetNo].name, toolTipIdxValue[targetNo].desc )
	else
		TooltipSimple_Hide()
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------
-- 편집 모드용 리턴 함수
function FGlobal_getUIScale()
	local uiScale = {};
	uiScale.min = minScaleValue
	uiScale.max = maxScaleValue

	return uiScale
end

function FGlobal_returnUIScale()	-- 다른 곳에서 스케일을 써야 하는 경우를 위해.
	return chk_Option.currentCheckUIScale
end

function FGlobal_saveUIScale( scale )		-- 다른 곳에서 스케일을 저장해야 하는 경우를 위해.
	chk_Option.currentCheckUIScale = scale / 100
	chk_Option.appliedCheckUIScale = chk_Option.currentCheckUIScale
	chk_Option.savedCheckUIScale   = chk_Option.currentCheckUIScale
end

-- percent의 범위는 0.0 - 100.0
-- 3번째 자리는 올림
function FGlobal_ApplyUIScale( scalePercent )	
	local interval = maxScaleValue - minScaleValue
	local uiScale_Percent = scalePercent
	chk_Option.currentCheckUIScale = math.floor( (scalePercent / 100 ) * 100 ) / 100;

	frame_Display._txt_UIScale:SetText( GetStr_Option[5].." ( <PAColor0xffbcf281>" ..string.format("%.0f", chk_Option.currentCheckUIScale * 100) .."% <PAOldColor>)" )
	frame_Display._txt_UIScaleLow:SetText( tostring( minScaleValue ) )
	frame_Display._txt_UIScaleMidle:SetText( tostring( minScaleValue + ( interval * 0.5 ) ) )
	frame_Display._txt_UIScaleHigh:SetText( tostring( maxScaleValue ) )

	frame_Display._slide_UIScale:SetControlPos(	( ( uiScale_Percent - minScaleValue ) / interval )* 100 );	

	chk_Option.appliedCheckUIScale = chk_Option.currentCheckUIScale; 
	chk_Option.savedCheckUIScale   = chk_Option.currentCheckUIScale;
	setUIScale( chk_Option.savedCheckUIScale )
end
-- 편집 모드 끝
---------------------------------------------------------------

-- 실제 실행되는 코드
-- ui_Gameoption.lua를 실행시키면 호출하는 함수들
Panel_GameOption_Initialize()
Option_RegistEventHandler()
Option_RegistMessageHandler()
Panel_Window_Option:RegisterUpdateFunc("Option_Update")
ToClient_initGameOption()
	
gameOption_SetEnableArea_Func()

-- 간소화 모드 설정 되돌리기
local simpleUI_Check = frame_Game._btn_EnableSimpleUI:IsCheck()
function SimpleUI_Check()
	SimpleUI_EnableCheck(simpleUI_Check)
end
SimpleUI_EnableCheck( simpleUI_Check )

function FromClient_ChangeScreenMode()
	reloadGameUI()
	
	local	messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_CHANGESCREENMODE_FULL") -- "전체 화면으로 전환하시겠습니까?"  
	local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"), content = messageBoxMemo, functionYes = ToClient_ChangePreScreenMode, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}	
	
	MessageBox.showMessageBox(messageBoxData)
end

function GameOption_Repos()
	local screenSizeX = getScreenSizeX()
	local screenSizeY = getScreenSizeY()
	Panel_Window_Option:SetPosX( (screenSizeX - Panel_Window_Option:GetSizeX()) / 2 )
	Panel_Window_Option:SetPosY( (screenSizeY - Panel_Window_Option:GetSizeY()) / 2 )
end

function isNearMonsterAlert()
	return frame_Game._btn_Alert_NearMonster:IsCheck()
end

registerEvent( "FromClient_ChangeScreenMode",	"FromClient_ChangeScreenMode" )
registerEvent("onScreenResize", 				"GameOption_Repos" )
