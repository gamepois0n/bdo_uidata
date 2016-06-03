local UI_TM			= CppEnums.TextMode
local VCK			= CppEnums.VirtualKeyCode
local UI_color 		= Defines.Color
local UI_classType	= CppEnums.ClassType
local IM			= CppEnums.EProcessorInputMode
-- 퀘스트 번호 정리
	-- 1 : 이동 튜토리얼
	-- 2 : 전투 튜토리얼


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local ui = 
{
		_obsidian 				= UI.getChildControl ( Panel_Tutorial, "Static_Obsidian" ),
		_obsidian_B 			= UI.getChildControl ( Panel_Tutorial, "Static_Obsidian_B" ),
		_obsidian_B_Left 		= UI.getChildControl ( Panel_Tutorial, "Static_Obsidian_B_Left" ),
		_obsidian_Text 			= UI.getChildControl ( Panel_Tutorial, "StaticText_Obsidian_B" ),
		_obsidian_Text_2		= UI.getChildControl ( Panel_Tutorial, "StaticText_Obsidian_B_2" ),

		_purposeText 			= UI.getChildControl ( Panel_Tutorial, "StaticText_Purpose" ),
		_nextStep_1 			= UI.getChildControl ( Panel_Tutorial, "StaticText_Step_1" ),
		_nextStep_2 			= UI.getChildControl ( Panel_Tutorial, "StaticText_Step_2" ),
		_nextStep_3 			= UI.getChildControl ( Panel_Tutorial, "StaticText_Step_3" ),
		_nextStep_4 			= UI.getChildControl ( Panel_Tutorial, "StaticText_Step_4" ),
		_nextArrow_0 			= UI.getChildControl ( Panel_Tutorial, "Static_NextArrow_0" ),
		_nextArrow_1 			= UI.getChildControl ( Panel_Tutorial, "Static_NextArrow_1" ),
		_nextArrow_2 			= UI.getChildControl ( Panel_Tutorial, "Static_NextArrow_2" ),

		_button_Q 				= UI.getChildControl ( Panel_Tutorial, "StaticText_Btn_Q" ),
		_button_W 				= UI.getChildControl ( Panel_Tutorial, "StaticText_Btn_W" ),
		_button_A 				= UI.getChildControl ( Panel_Tutorial, "StaticText_Btn_A" ),
		_button_S				= UI.getChildControl ( Panel_Tutorial, "StaticText_Btn_S" ),
		_button_D 				= UI.getChildControl ( Panel_Tutorial, "StaticText_Btn_D" ),

		_button_E 				= UI.getChildControl ( Panel_Tutorial, "StaticText_Btn_E" ),
		_button_F 				= UI.getChildControl ( Panel_Tutorial, "StaticText_Btn_F" ),
		_button_T 				= UI.getChildControl ( Panel_Tutorial, "StaticText_Btn_T" ),

		_button_Tab 			= UI.getChildControl ( Panel_Tutorial, "StaticText_Btn_Tab" ),
		_button_Shift 			= UI.getChildControl ( Panel_Tutorial, "StaticText_Btn_Shift" ),
		_button_Space 			= UI.getChildControl ( Panel_Tutorial, "StaticText_Btn_Space" ),
		
		_button_Ctrl 			= UI.getChildControl ( Panel_Tutorial, "StaticText_Btn_Ctrl" ),

		_m0 					= UI.getChildControl ( Panel_Tutorial, "StaticText_M0" ),
		_m1 					= UI.getChildControl ( Panel_Tutorial, "StaticText_M1" ),
		_mBody 					= UI.getChildControl ( Panel_Tutorial, "StaticText_Mouse_Body" ),

		_buttonLock 			= UI.getChildControl ( Panel_Tutorial, "StaticText_Button_Lock" ),
		_m0_Lock 				= UI.getChildControl ( Panel_Tutorial, "StaticText_M0_Lock" ),
		_m1_Lock 				= UI.getChildControl ( Panel_Tutorial, "StaticText_M1_Lock" ),

		_clearStep_1 			= UI.getChildControl ( Panel_Tutorial, "Static_Clear_Step1" ),
		_clearStep_2 			= UI.getChildControl ( Panel_Tutorial, "Static_Clear_Step2" ),
		_clearStep_3 			= UI.getChildControl ( Panel_Tutorial, "Static_Clear_Step3" ),
		_clearStep_4 			= UI.getChildControl ( Panel_Tutorial, "Static_Clear_Step4" ),
		
		_bubbleKey_W			= UI.getChildControl ( Panel_Tutorial, "Static_BubbleKey_W" ),
		_bubbleKey_A			= UI.getChildControl ( Panel_Tutorial, "Static_BubbleKey_A" ),
		_bubbleKey_S			= UI.getChildControl ( Panel_Tutorial, "Static_BubbleKey_S" ),
		_bubbleKey_D			= UI.getChildControl ( Panel_Tutorial, "Static_BubbleKey_D" ),
		_bubbleKey_I			= UI.getChildControl ( Panel_Tutorial, "Static_BubbleKey_I" ),
		_bubbleKey_R			= UI.getChildControl ( Panel_Tutorial, "Static_BubbleKey_R" ),
		_bubbleKey_T			= UI.getChildControl ( Panel_Tutorial, "Static_BubbleKey_T" ),
		_bubbleKey_Shift		= UI.getChildControl ( Panel_Tutorial, "Static_BubbleKey_Shift" ),
		_bubbleKey_Ctrl			= UI.getChildControl ( Panel_Tutorial, "Static_BubbleKey_Ctrl" ),
}

-- if isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_NA ) then
	ui._bubbleKey_W				= UI.getChildControl( Panel_Tutorial, "StaticText_BubbleKey_W" )
	ui._bubbleKey_A				= UI.getChildControl( Panel_Tutorial, "StaticText_BubbleKey_A" )
	ui._bubbleKey_S				= UI.getChildControl( Panel_Tutorial, "StaticText_BubbleKey_S" )
	ui._bubbleKey_D				= UI.getChildControl( Panel_Tutorial, "StaticText_BubbleKey_D" )
	ui._bubbleKey_I				= UI.getChildControl( Panel_Tutorial, "StaticText_BubbleKey_I" )
	ui._bubbleKey_R				= UI.getChildControl( Panel_Tutorial, "StaticText_BubbleKey_R" )
	ui._bubbleKey_T				= UI.getChildControl( Panel_Tutorial, "StaticText_BubbleKey_T" )
	ui._bubbleKey_Shift			= UI.getChildControl( Panel_Tutorial, "StaticText_BubbleKey_Shift" )
	ui._bubbleKey_Ctrl			= UI.getChildControl( Panel_Tutorial, "StaticText_BubbleKey_Ctrl" )
-- end

local uvSet = 
{
		_button_Q 				= { on = { 1, 1, 63, 65 } , 	click = { 63, 0, 126, 65 }, 	off = { 127, 1, 189, 65 }},
		_button_W 				= { on = { 1, 1, 63, 65 } , 	click = { 63, 0, 126, 65 }, 	off = { 127, 1, 189, 65 }},
		_button_A 				= { on = { 1, 1, 63, 65 } , 	click = { 63, 0, 126, 65 }, 	off = { 127, 1, 189, 65 }},
		_button_S				= { on = { 1, 1, 63, 65 } , 	click = { 63, 0, 126, 65 }, 	off = { 127, 1, 189, 65 }},
		_button_D 				= { on = { 1, 1, 63, 65 } , 	click = { 63, 0, 126, 65 }, 	off = { 127, 1, 189, 65 }},
		_button_E 				= { on = { 1, 1, 63, 65 } , 	click = { 63, 0, 126, 65 }, 	off = { 127, 1, 189, 65 }},
		_button_F 				= { on = { 1, 1, 63, 65 } , 	click = { 63, 0, 126, 65 }, 	off = { 127, 1, 189, 65 }},
		_button_T				= { on = { 1, 1, 63, 65 } , 	click = { 63, 0, 126, 65 }, 	off = { 127, 1, 189, 65 }},
		_button_Tab 			= { on = { 1, 1, 63, 65 } , 	click = { 63, 0, 126, 65 }, 	off = { 127, 1, 189, 65 }},
		_button_Shift 			= { on = { 1, 1, 63, 65 } , 	click = { 63, 0, 126, 65 }, 	off = { 127, 1, 189, 65 }},
		_button_Space 			= { on = { 1, 1, 63, 65 } , 	click = { 63, 0, 126, 65 }, 	off = { 127, 1, 189, 65 }},
		_button_Ctrl 			= { on = { 1, 1, 63, 65 } , 	click = { 63, 0, 126, 65 }, 	off = { 127, 1, 189, 65 }},
		_m0 					= { on = { 1, 66, 74, 143 } , 	click = { 75, 65, 148, 143 }, 	off = { 149, 66, 222, 143 }},
		_m1 					= { on = { 1, 144, 74, 221 } , 	click = { 75, 143, 148, 221 }, 	off = { 149, 144, 222, 221 }},
}

local keyIndexSet = 
{
		_m0 					= ( 4 )		,
		_m1 					= ( 5 )		,
		_button_Q 				= ( 12 )	,
		_button_W 				= ( 0 )		,
		_button_A 				= ( 2 )		,
		_button_S				= ( 1 )		,
		_button_D 				= ( 3 )		,
		_button_E 				= ( 13 )	,
		_button_F 				= ( 14 )	,
		_button_T 				= ( 9 )		,
		_button_Tab 			= ( 10 )	,
		_button_Shift 			= ( 6 )		,
		_button_Space 			= ( 7 )		,
		_button_Ctrl 			= ( 99 )	,

		-- _m0 					= 0,
		-- _m1 					= 1,
		-- _button_Q 			= 6,
		-- _button_W 			= 2,
		-- _button_A 			= 3,
		-- _button_S			= 4,
		-- _button_D 			= 5,
		-- _button_E 			= 7,
		-- _button_F 			= 9,
		-- _button_T 			= 17,
		-- _button_Tab 			= 16,
		-- _button_Shift 		= 14,
		-- _button_Space 		= 15,
		-- _button_Ctrl 		= 0,
		
		-- 0 : M0
		-- 1 : M1
		-- 2 : W
		-- 3 : A
		-- 4 : S
		-- 5 : D
		-- 6 : Q
		-- 7 : E
		-- 8 : R
		-- 9 : F
		-- 10 : Z
		-- 11 : X
		-- 12 : C
		-- 13 : V
		-- 14 : Shift
		-- 15 : Space
		-- 16 : Tab
		-- 17 : T
}

local keyToVirtualKey = 
{
		_m0 					= ( 4 )		,
		_m1 					= ( 5 )		,
		_button_Q 				= ( 12 )	,
		_button_W 				= ( 0 )		,
		_button_A 				= ( 2 )		,
		_button_S				= ( 1 )		,
		_button_D 				= ( 3 )		,
		_button_E 				= ( 13 )	,
		_button_F 				= ( 14 )	,
		_button_T 				= ( 9 )		,
		_button_Tab 			= ( 10 )	,
		_button_Shift 			= ( 6 )		,
		_button_Space 			= ( 7 )		,
		_button_Ctrl 			= ( 99 )	,
		_button_R				= ( 8 )
}

-- 튜토리얼 시 사용할 마스킹 패널 로드
local _maskBg_Quest				= UI.getChildControl( Panel_Masking_Tutorial, "Static_MaskBg_Quest" )
local _maskBg_SelfExpGuage		= UI.getChildControl( Panel_Masking_Tutorial, "Static_MaskBg_SelfExpGauge" )
local _maskBg_Spirit			= UI.getChildControl( Panel_Masking_Tutorial, "Static_MaskBg_Spirit" )
_maskBg_Quest			:SetShow( false )
_maskBg_SelfExpGuage	:SetShow( false )
_maskBg_Spirit			:SetShow( false )

local prevUsingKey = {}

local _updateTime = 0
local _pushed_time = 0
local _stepNo = 0
local isBattleTutorialComplete = false
Panel_Tutorial_NaviCtrl_IsNaviDone = true

local isFirstPotion = false					-- 포션 튜토리얼 이펙트 체크용

-- 0 : nil
-- 1 : 기본 이동 스텝 1
-- 2 : 기본 이동 스텝 2
-- 3 : 기본 이동 스텝 3
-- 4 : 기본 이동 스텝 종료 딜레이
-- 5 : 전투 스텝 1 ( TAB키 )
-- 6 : 전투 스텝 2 ( 좌클릭, 우클릭 )
-- 7 : 전투 스텝 3 ( E 를 이용해서 보조 공격 )
-- 8 : 전투 스텝 3 ( E 를 이용해서 보조 공격 )
-- 9 : 전투 스텝 3 ( E 를 이용해서 보조 공격 )
-- 10 : 전투 스텝 4 ( F 를 이용해서 보조 공격 )
-- 11 : 전투 스텝 종료 딜레이
-- 96 : 인벤토리를 열어라
-- 97 : 물약을 먹어라
-- 98 : 인벤토리 튜토리얼 종료 딜레이
-- 99 : 완전 처음 시작해라!

local bubbleKey_Hide = function()
	ui._bubbleKey_W		:SetShow( false )
	ui._bubbleKey_A		:SetShow( false )
	ui._bubbleKey_S		:SetShow( false )
	ui._bubbleKey_D		:SetShow( false )
	ui._bubbleKey_I		:SetShow( false )
	ui._bubbleKey_R		:SetShow( false )
	ui._bubbleKey_T		:SetShow( false )
	ui._bubbleKey_Shift	:SetShow( false )
	ui._bubbleKey_Ctrl	:SetShow( false )
end

local actionKey_Change = function()
	ui._button_W 		:SetText( keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_MoveFront ) )
	ui._button_A		:SetText( keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_MoveLeft ) )
	ui._button_S		:SetText( keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_MoveBack ) )
	ui._button_D		:SetText( keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_MoveRight ) )
	
	ui._button_Q 		:SetText( keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_CrouchOrSkill ) )
	ui._button_E 		:SetText( keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_GrabOrGuard ) )
	ui._button_F 		:SetText( keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_Kick ) )
	ui._button_T 		:SetText( keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_AutoRun ) )
	
	ui._button_Tab 		:SetText( keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_WeaponInOut ) )
	ui._button_Shift	:SetText( keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_Dash ) )
	ui._button_Space	:SetText( keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_Jump ) )
	ui._button_Ctrl 	:SetText( keyCustom_GetString_UiKey( CppEnums.UiInputType.UiInputType_CursorOnOff ) )
end

local bubbleKey_Change = function()
	-- if not isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_NA ) then
		-- return
	-- end
	
	ui._bubbleKey_W		:SetText( keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_MoveFront ) )
	ui._bubbleKey_A		:SetText( keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_MoveLeft ) )
	ui._bubbleKey_S		:SetText( keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_MoveBack ) )
	ui._bubbleKey_D		:SetText( keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_MoveRight ) )
	
	ui._bubbleKey_I		:SetText( keyCustom_GetString_UiKey( CppEnums.UiInputType.UiInputType_Inventory ) )
	ui._bubbleKey_R		:SetText( keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_Interaction ) )
	ui._bubbleKey_T 	:SetText( keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_AutoRun ) )
	
	ui._bubbleKey_Shift	:SetText( keyCustom_GetString_ActionKey( CppEnums.ActionInputType.ActionInputType_Dash ) )
	ui._bubbleKey_Ctrl 	:SetText( keyCustom_GetString_UiKey( CppEnums.UiInputType.UiInputType_CursorOnOff ) )
end


local classType = nil
local get_ClsaaType = function()
	local selfPlayer = getSelfPlayer()
	if nil ~= selfPlayer then
		classType = selfPlayer:getClassType()
	end
end
get_ClsaaType()

local welcomeToTheWorld = false
local isFirstTime_CtrlNavi = false	-- 길찾기 이펙트를 한 번 만 뿌리기 위해
local _isTutorialEnd = true
local isInteractionForTutorial = false

function FGlobal_GetFirstTutorialState()
	if true == welcomeToTheWorld then
		return true
	end
	
	return false
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 화면 리사이즈
function Tutorial_ScreenRePosition()
	local scrX = getScreenSizeX()
	local scrY = getScreenSizeY()

	Panel_Tutorial:SetSize ( scrX, scrY )
	Panel_Tutorial:SetPosX(0)
	Panel_Tutorial:SetPosY(0)

	-- ui 안에 놈들 알아서 정렬
	for key, value in pairs(ui) do
		value:ComputePos()
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 공용 : 버튼 눌렀을 때 색 바꿔주기!!
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local index = 0
local ButtonToggle = function( key, isOn )
	local aUI = ui[key]
	local keyName = "on"
	
	if ( false == isOn ) then
		keyName = "off"
	else
		if ( true == prevUsingKey[key] ) then
			aUI:SetFontColor ( UI_color.C_FFC4BEBE )
		else
			aUI:SetFontColor ( UI_color.C_FF00C0D7 )
		end
	end
	
	if ( key == "_button_Ctrl" ) then
		if ( true == isOn ) and ( keyCustom_IsPressed_Ui ( 0 ) ) then
			keyName = "click"
			aUI:SetFontColor ( UI_color.C_FFFFCE22 )
		end
	else
		if ( true == isOn ) and ( keyCustom_IsPressed_Action ( keyToVirtualKey[key] ) ) then
			keyName = "click"
			aUI:SetFontColor ( UI_color.C_FFFFCE22 )
		end
	end

	local textureUV = uvSet[key][keyName]
	aUI:ChangeTextureInfoName( "new_ui_common_forlua/widget/tutorial/tutorial_00.dds" )
	local x1, y1, x2, y2 = setTextureUV_Func( aUI, textureUV[1], textureUV[2], textureUV[3], textureUV[4] )
	aUI:getBaseTexture():setUV(  x1, y1, x2, y2  )
	aUI:setRenderTexture(aUI:getBaseTexture())
	if ( isOn ) then
		if ( "_m0" == key ) then
			aUI:SetText("L")
		elseif ( "_m1" == key ) then
			aUI:SetText("R")
		elseif ( "_button_Ctrl" == key ) then
			local actionString = "";
			if getGamePadEnable() then
				actionString = keyCustom_GetString_UiPad( 0 );
			else
				actionString = keyCustom_GetString_UiKey( 0 );
			end
			aUI:SetText( actionString )
		else
			local actionString = "";
			if getGamePadEnable() then
				actionString = keyCustom_GetString_ActionPad( keyIndexSet[key] );
			else
				actionString = keyCustom_GetString_ActionKey( keyIndexSet[key] );
			end
			aUI:SetText( actionString )
		end
	else
		aUI:SetText(" ")
	end
end

local ButtonToggleAll = function(isOn)
	for key, value in pairs(uvSet) do
		ButtonToggle(key, isOn)
	end
end

local ChattingPanel_Hide = function()
	local chattingPanelCount = ToClient_getChattingPanelCount()
	for panelIndex = 0, chattingPanelCount - 1, 1 do
		local chatPanel		= ToClient_getChattingPanel( panelIndex )
		if ( chatPanel:isOpen() ) then
			local chatPanelUI	= FGlobal_getChattingPanel( panelIndex )
			chatPanelUI:SetShow(false)
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 기본 이동 튜토리얼
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Panel_WelcomeToTheWorld_Start()
	Panel_ChallengeReward_Alert	:SetShow( false )
	Panel_SpecialReward_Alert	:SetShow( false )
	Panel_Adrenallin:SetShow( false )
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
	
	ui._nextStep_4:SetShow(false)
	ui._nextArrow_2:SetShow(false)
	ui._clearStep_4:SetShow(false)

	-- Panel_Win_Npc_Quest_List:SetShow( false )
	Panel_MainStatus_User_Bar:SetShow( false )
	Panel_SelfPlayerExpGage:SetShow( false )
	
	Panel_QuickSlot:SetShow( false )
	Panel_UIMain:SetShow( false )
	
	--Panel_Radar:SetShow( false )
	--Panel_RadarRealLine.panel:SetShow( false )
	FGlobal_Panel_Radar_Show( false )
	FGlobal_Panel_RadarRealLine_Show( false )
	
	Panel_SkillCommand:SetShow( false )
	Panel_TimeBar:SetShow( false )
	Panel_ClassResource:SetShow(false)
	Panel_MyHouseNavi:SetShow( false )
	Panel_GameTips:SetShow( false )
	Panel_GameTipMask:SetShow( false )
	knowledgeList[0]._panel:SetShow( false )
	knowledgeList[1]._panel:SetShow( false )
	-- Panel_NewKnowledge:SetShow( false )
	Panel_NewEquip:SetShow( false )
	Panel_MovieGuideButton:SetShow( false )
	Panel_HuntingAlertButton:SetShow( false )
	Panel_AutoTraining:SetShow( false )
	Panel_Widget_TownNpcNavi:SetShow( false )
	Panel_Window_PetControl:SetShow( false )
	Panel_RecentMemory:SetShow( false )
	Panel_Window_PetIcon:SetShow( false )
	
	-- 채팅창
	ChattingPanel_Hide()

	-- 새 흑정령 퀘스트 알림 끄기
	Panel_CheckedQuest:SetShow( false )
	Panel_NewEventProduct_Alarm:SetShow( false )

	-- 생산 레벨 위젯 끄기
	CraftLevInfo_Hide()
	PotenGradeInfo_Hide()
	
	if check_ShowWindow() then		-- 켜져있는 창이 있으면!
		close_WindowPanelList()
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
	end	
	
	_isTutorialEnd = false

	-- ui._m0:ResetVertexAni()
	-- ui._m1:ResetVertexAni()
	-- ui._button_W:ResetVertexAni()
	-- ui._button_A:ResetVertexAni()
	-- ui._button_S:ResetVertexAni()
	-- ui._button_D:ResetVertexAni()
	-- ui._button_E:ResetVertexAni()
	-- ui._button_F:ResetVertexAni()
	-- ui._button_Tab:ResetVertexAni()
	-- ui._button_Shift:ResetVertexAni()
	-- ui._button_Space:ResetVertexAni()
	-- ui._mBody:ResetVertexAni()

	Panel_Tutorial_BtnHide()

	ui._obsidian:EraseAllEffect()
	ui._obsidian:AddEffect ( "fUI_DarkSpirit_Tutorial", true, 0, 0 )
	ui._obsidian_B:SetShow ( false )
	ui._obsidian_B_Left:SetShow ( false )
	ui._obsidian_Text:SetShow ( false )

	Panel_Tutorial:SetShow( true, false )
	_stepNo = 99
	welcomeToTheWorld = true
	
	bubbleKey_Hide()
	
	local selfPlayer = getSelfPlayer()
	if nil ~= selfPlayer then		
		getSelfPlayer():setActionChart("TUTORIAL_WAIT_STEP1")
	end
end

function Panel_WelcomeToTheWorld_End()
	isTutorialStart = false
	bubbleKey_Hide()
	
	Panel_Tutorial:SetShow( false, false )
	Panel_SelfPlayerExpGage:SetShow( true )
	Panel_UIMain:SetShow( true )
	
	--[[Panel_CheckedQuest:SetShow( true )
	Panel_MainStatus_User_Bar:SetShow( true )
	Panel_SelfPlayerExpGage:SetShow( true )
	Panel_QuickSlot:SetShow( true )
	Panel_Radar:SetShow( true )
	Panel_RadarRealLine.panel:SetShow( true )
	Panel_MovieGuideButton:SetShow( true )
	Panel_Widget_TownNpcNavi:SetShow( true, true )
	FGlobal_PetControl_CheckUnSealPet()
	
	if isPvpEnable() then	-- PVP버튼 활성 조건을 만족해야 켠다.
		Panel_PvpMode:SetShow( true )
	else
		Panel_PvpMode:SetShow( false )
	end

	if CppEnums.ClassType.ClassType_Sorcerer== classType then -- 소서러만 어둠의 조각 카운트 UI를 켜줌
		Panel_ClassResource:SetShow( true  )
	else
		Panel_ClassResource:SetShow( false )
	end

	-- 채팅창
	local chattingPanelCount = ToClient_getChattingPanelCount()
	for panelIndex = 0, chattingPanelCount - 1, 1 do
		local chatPanel		= ToClient_getChattingPanel( panelIndex )
		if ( chatPanel:isOpen() ) then
			local chatPanelUI	= FGlobal_getChattingPanel( panelIndex )
			chatPanelUI:SetShow(true)
		end
	end
	
	-- Panel_NewQuest:SetShow( true )
	Panel_SkillCommand:SetShow( true )
	Panel_TimeBar:SetShow( true )
	Panel_MyHouseNavi:SetShow( true )
	-- Panel_NewKnowledge:SetShow( true )
	Panel_GameTips:SetShow( true )
	Panel_GameTipMask:SetShow( true )

	-- 생산 정보 위젝 켜기
	CraftLevInfo_Show()
	PotenGradeInfo_Show()
	--]]

	welcomeToTheWorld = false
	UpdateLuaEvent(1)			-- 흑정령을 강제로 띄우는 것
	request_clearMiniGame(1)	-- 미니게임 클리어 체크
	getSelfPlayer():setActionChart("TUTORIAL_END")
	
	local chattingPanelCount = ToClient_getChattingPanelCount()
	for panelIndex = 0, chattingPanelCount - 1, 1 do
		local chatPanel		= ToClient_getChattingPanel( panelIndex )
		if ( chatPanel:isOpen() ) then
			local chatPanelUI	= FGlobal_getChattingPanel( panelIndex )
			chatPanelUI:SetShow(false)
		end
	end
	
	isInteractionForTutorial = true
	
	--[[FromClient_CompleteBenefitReward()			-- 특별 선물 알림 체크
	FromClient_CompleteChallengeReward()		-- 도전과제 보상 알림을 체크한다.
	check_CashShop_PossibleBuyEventItem()		-- 새 신상이 있으면 켠다.
	--]]
end

function Panel_Tutorial_BtnShow()
	-- ui._purposeText:SetShow(true)
	-- ui._nextStep_1:SetShow(true)
	-- ui._nextStep_2:SetShow(true)
	-- ui._nextStep_3:SetShow(true)
	-- ui._nextArrow_0:SetShow(true)
	-- ui._nextArrow_1:SetShow(true)
	ui._button_Q:SetShow(true)
	ui._button_W:SetShow(true)
	ui._button_A:SetShow(true)
	ui._button_S:SetShow(true)
	ui._button_D:SetShow(true)
	ui._button_E:SetShow(true)
	ui._button_F:SetShow(true)
	ui._button_T:SetShow(false)
	ui._button_Tab:SetShow(true)
	ui._button_Shift:SetShow(true)
	ui._button_Space:SetShow(true)
	ui._button_Ctrl:SetShow(false)
	ui._m0:SetShow(true)
	ui._m1:SetShow(true)
	ui._mBody:SetShow(true)
	
	ui._purposeText:SetAlpha(1)
	ui._nextStep_1:SetAlpha(1)
	ui._nextStep_2:SetAlpha(1)
	ui._nextStep_3:SetAlpha(1)
	ui._nextArrow_0:SetAlpha(1)
	ui._nextArrow_1:SetAlpha(1)
	ui._button_Q:SetAlpha(1)
	ui._button_W:SetAlpha(1)
	ui._button_A:SetAlpha(1)
	ui._button_S:SetAlpha(1)
	ui._button_D:SetAlpha(1)
	ui._button_E:SetAlpha(1)
	ui._button_F:SetAlpha(1)
	ui._button_T:SetAlpha(0)
	ui._button_Tab:SetAlpha(1)
	ui._button_Shift:SetAlpha(1)
	ui._button_Space:SetAlpha(1)
	ui._button_Ctrl:SetAlpha(0)
	ui._m0:SetAlpha(1)
	ui._m1:SetAlpha(1)
	ui._mBody:SetAlpha(1)
end
function Panel_Tutorial_BtnHide()
	ui._purposeText:SetShow(false)
	ui._nextStep_1:SetShow(false)
	ui._nextStep_2:SetShow(false)
	ui._nextStep_3:SetShow(false)
	ui._nextArrow_0:SetShow(false)
	ui._nextArrow_1:SetShow(false)
	ui._button_Q:SetShow(false)
	ui._button_W:SetShow(false)
	ui._button_A:SetShow(false)
	ui._button_S:SetShow(false)
	ui._button_D:SetShow(false)
	ui._button_E:SetShow(false)
	ui._button_F:SetShow(false)
	ui._button_T:SetShow(false)
	ui._button_Tab:SetShow(false)
	ui._button_Shift:SetShow(false)
	ui._button_Space:SetShow(false)
	ui._button_Ctrl:SetShow(false)
	ui._m0:SetShow(false)
	ui._m1:SetShow(false)
	ui._mBody:SetShow(false)
	ui._bubbleKey_W:SetShow(false)
	ui._bubbleKey_A:SetShow(false)
	ui._bubbleKey_S:SetShow(false)
	ui._bubbleKey_D:SetShow(false)
	ui._bubbleKey_I:SetShow(false)
	ui._bubbleKey_R:SetShow(false)
	ui._bubbleKey_Shift:SetShow(false)
	
	ui._purposeText:SetAlpha(0)
	ui._nextStep_1:SetAlpha(0)
	ui._nextStep_2:SetAlpha(0)
	ui._nextStep_3:SetAlpha(0)
	ui._nextArrow_0:SetAlpha(0)
	ui._nextArrow_1:SetAlpha(0)
	ui._button_Q:SetAlpha(0)
	ui._button_W:SetAlpha(0)
	ui._button_A:SetAlpha(0)
	ui._button_S:SetAlpha(0)
	ui._button_D:SetAlpha(0)
	ui._button_E:SetAlpha(0)
	ui._button_F:SetAlpha(0)
	ui._button_T:SetAlpha(0)
	ui._button_Tab:SetAlpha(0)
	ui._button_Shift:SetAlpha(0)
	ui._button_Space:SetAlpha(0)
	ui._button_Ctrl:SetAlpha(0)
	ui._m0:SetAlpha(0)
	ui._m1:SetAlpha(0)
	ui._mBody:SetAlpha(0)
end


function FirstTime_Tutorial()
	local scrX = getScreenSizeX()
	local scrY = getScreenSizeY()
	
	ui._obsidian:SetPosX( scrX * 0.5 - 20 )
	ui._obsidian:SetPosY( scrY * 0.5 - 300 )
	ui._obsidian_B:SetPosX( scrX * 0.5 + 50 )
	ui._obsidian_B:SetPosY( scrY * 0.5 - 250 )
	ui._obsidian_Text:SetPosX( scrX * 0.5 + 53 )
	ui._obsidian_Text:SetPosY( scrY * 0.5 - 225 )
	ui._obsidian_Text_2:SetPosX( scrX * 0.5 + 53 )
		
	ui._obsidian:SetShow(true)
	ui._obsidian_B:SetShow(true)
	ui._obsidian_B_Left:SetShow(false)
	ui._obsidian_Text:SetShow(true)
	ui._obsidian_Text_2:SetShow(false)
end

local startTutorial_comment1 = false
local startTutorial_comment2 = false
local startTutorial_comment3 = false
function updateDeltaTime_StartTutorial( deltaTime )
	knowledgeList[0]._panel:SetShow( false )
	knowledgeList[1]._panel:SetShow( false )
	
	_updateTime = _updateTime + deltaTime
	ui._obsidian_B:SetShow ( true )
	ui._obsidian_Text:SetShow ( true )

	FirstTime_Tutorial()

	----------
	-- 강제로 흐느적 상태 만들기
	-- if ( 0 < _updateTime ) and ( 0.5 > _updateTime ) then
		-- getSelfPlayer():setActionChart("TUTORIAL_WAIT_STEP1")	
	-- end
	
	----------------------------------------------------------------------
	-- 워리어
	if ( 0 < _updateTime ) and ( UI_classType.ClassType_Warrior == classType ) then
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "TUTORIAL_MOVE_WARRIOR_TALK1" ))		--이제 조금 정신이 들어?
		
		if false == startTutorial_comment1 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment1 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 4 < _updateTime ) and ( UI_classType.ClassType_Warrior == classType )  then
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "TUTORIAL_MOVE_WARRIOR_TALK2" ))		--드디어 해방이야.\n네가 깨어나길 한참을 기다렸어.
		
		if false == startTutorial_comment2 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment2 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 8 < _updateTime ) and ( UI_classType.ClassType_Warrior == classType )  then
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "TUTORIAL_MOVE_WARRIOR_TALK3" ))		--도와줄 테니 움직여 보는 게 어때? \n설마 계약을 잊은 건 아니겠지?
		
		if false == startTutorial_comment3 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment3 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 13 < _updateTime ) and ( UI_classType.ClassType_Warrior == classType )  then
		Panel_Tutorial_BtnShow()
		_updateTime = 0
		_stepNo = 1
	end

	----------------------------------------------------------------------
	-- 레인저
	if ( 0 < _updateTime ) and ( UI_classType.ClassType_Ranger == classType ) then
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "TUTORIAL_MOVE_RANGER_TALK1" ))		--이제야 정신이 들었네.\n네가 자는 동안 여길 몇 번이나 맴돌았어.

		if false == startTutorial_comment1 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment1 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()		
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )	
	end
	if ( 4 < _updateTime ) and ( UI_classType.ClassType_Ranger == classType )  then
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "TUTORIAL_MOVE_RANGER_TALK2" ))		--한참.. 한참을 말이야.\n깨어나서 다행이야.

		if false == startTutorial_comment2 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment2 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()		
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 8 < _updateTime ) and ( UI_classType.ClassType_Ranger == classType )  then
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "TUTORIAL_MOVE_RANGER_TALK3" ))		--몸을 움직이면 괜찮아질 거야.\n설마 우리의 계약을 잊은 건 아니겠지?
	
		if false == startTutorial_comment3 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment3 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 13 < _updateTime ) and ( UI_classType.ClassType_Ranger == classType )  then
		Panel_Tutorial_BtnShow()
		_updateTime = 0
		_stepNo = 1
	end

	----------------------------------------------------------------------
	-- 소서러
	if ( 0 < _updateTime ) and ( UI_classType.ClassType_Sorcerer == classType ) then
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "TUTORIAL_MOVE_SORCERER_TALK1" ))		--여긴 어디야.\n하마터면 무너질 뻔했어.

		if false == startTutorial_comment1 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment1 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()	
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 5 < _updateTime ) and ( UI_classType.ClassType_Sorcerer == classType )  then
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "TUTORIAL_MOVE_SORCERER_TALK2" ))		--인간의 생존력은 대단해.\n하지만 아직 정신은 돌아오진 않는 모양이네.

		if false == startTutorial_comment2 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment2 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 9 < _updateTime ) and ( UI_classType.ClassType_Sorcerer == classType )  then
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "TUTORIAL_MOVE_SORCERER_TALK3" ))		--도와줄 테니 몸을 움직여봐.\n벌써 계약을 잊은 건 아니지?
		
		if false == startTutorial_comment3 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment3 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()		
		
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 13 < _updateTime ) and ( UI_classType.ClassType_Sorcerer == classType )  then
		Panel_Tutorial_BtnShow()
		_updateTime = 0
		_stepNo = 1
	end

	----------------------------------------------------------------------
	-- 자이언트
	if ( 0 < _updateTime ) and ( UI_classType.ClassType_Giant == classType ) then
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "TUTORIAL_MOVE_GIANT_TALK1" ))		--그래. 이제 깰 때가 됐지.\n여기가 어딘지 궁금해?
		
		if false == startTutorial_comment1 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment1 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()		
		
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 4 < _updateTime ) and ( UI_classType.ClassType_Giant == classType )  then
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "TUTORIAL_MOVE_GIANT_TALK2" ))		--나도 잘 모르겠어...\n일단 정신부터 차리는 게 어때?
		
		if false == startTutorial_comment2 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment2 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()
		
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 9 < _updateTime ) and ( UI_classType.ClassType_Giant == classType )  then
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "TUTORIAL_MOVE_GIANT_TALK3" ))		--도와줄 테니 움직여 봐. \n우리의 계약을 잊은 건 아니겠지?
		
		if false == startTutorial_comment3 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment3 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()
		
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 12 < _updateTime ) and ( UI_classType.ClassType_Giant == classType )  then
		Panel_Tutorial_BtnShow()
		_updateTime = 0
		ButtonToggleAll(false)
		ButtonToggle("_button_W", true)
		_stepNo = 1
	end

	----------------------------------------------------------------------
	-- 테이머
	if ( 0 < _updateTime ) and ( UI_classType.ClassType_Tamer == classType ) then
		ui._obsidian_Text:SetText (PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_MOVE_TAMER_TALK1"))
		
		if false == startTutorial_comment1 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment1 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()		
		
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 4 < _updateTime ) and ( UI_classType.ClassType_Tamer == classType )  then
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "LUA_TUTORIAL_MOVE_TAMER_TALK2" ))
		
		if false == startTutorial_comment2 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment2 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()
		
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 9 < _updateTime ) and ( UI_classType.ClassType_Tamer == classType )  then
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "LUA_TUTORIAL_MOVE_TAMER_TALK2" ))
		
		if false == startTutorial_comment3 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment3 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()
		
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 12 < _updateTime ) and ( UI_classType.ClassType_Tamer == classType )  then
		Panel_Tutorial_BtnShow()
		_updateTime = 0
		ButtonToggleAll(false)
		ButtonToggle("_button_W", true)
		_stepNo = 1
	end

	----------------------------------------------------------------------
	-- 무사
	if ( 0 < _updateTime ) and ( UI_classType.ClassType_BladeMaster == classType ) then
		ui._obsidian_Text:SetText (PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_MOVE_BLADEMASTER_TALK1"))
		
		if false == startTutorial_comment1 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment1 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()		
		
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 4 < _updateTime ) and ( UI_classType.ClassType_BladeMaster == classType )  then
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "LUA_TUTORIAL_MOVE_BLADEMASTER_TALK2" ))
		
		if false == startTutorial_comment2 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment2 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()
		
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 9 < _updateTime ) and ( UI_classType.ClassType_BladeMaster == classType )  then
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "LUA_TUTORIAL_MOVE_BLADEMASTER_TALK3" ))
		
		if false == startTutorial_comment3 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment3 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()
		
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 13 < _updateTime ) and ( UI_classType.ClassType_BladeMaster == classType )  then
		Panel_Tutorial_BtnShow()
		_updateTime = 0
		ButtonToggleAll(false)
		ButtonToggle("_button_W", true)
		_stepNo = 1
	end

	----------------------------------------------------------------------
	-- 여자 무사
	if ( 0 < _updateTime ) and ( UI_classType.ClassType_BladeMasterWomen == classType ) then
		ui._obsidian_Text:SetText (PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_MOVE_BLADEMASTER_TALK1"))
		
		if false == startTutorial_comment1 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment1 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()		
		
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 4 < _updateTime ) and ( UI_classType.ClassType_BladeMasterWomen == classType )  then
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "LUA_TUTORIAL_MOVE_BLADEMASTER_TALK2" ))
		
		if false == startTutorial_comment2 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment2 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()
		
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 9 < _updateTime ) and ( UI_classType.ClassType_BladeMasterWomen == classType )  then
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "LUA_TUTORIAL_MOVE_BLADEMASTER_TALK3" ))
		
		if false == startTutorial_comment3 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment3 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()
		
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 13 < _updateTime ) and ( UI_classType.ClassType_BladeMasterWomen == classType )  then
		Panel_Tutorial_BtnShow()
		_updateTime = 0
		ButtonToggleAll(false)
		ButtonToggle("_button_W", true)
		_stepNo = 1
	end

	----------------------------------------------------------------------
	-- 발키리
	if ( 0 < _updateTime ) and ( UI_classType.ClassType_Valkyrie == classType ) then
		ui._obsidian_Text:SetText (PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_MOVE_VALKYRIE_TALK1"))
		
		if false == startTutorial_comment1 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment1 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()		
		
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 4 < _updateTime ) and ( UI_classType.ClassType_Valkyrie == classType )  then
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "LUA_TUTORIAL_MOVE_VALKYRIE_TALK2" ))
		
		if false == startTutorial_comment2 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment2 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()
		
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 9 < _updateTime ) and ( UI_classType.ClassType_Valkyrie == classType )  then
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "LUA_TUTORIAL_MOVE_VALKYRIE_TALK3" ))
		
		if false == startTutorial_comment3 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment3 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()
		
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 13 < _updateTime ) and ( UI_classType.ClassType_Valkyrie == classType )  then
		Panel_Tutorial_BtnShow()
		_updateTime = 0
		ButtonToggleAll(false)
		ButtonToggle("_button_W", true)
		_stepNo = 1
	end

	----------------------------------------------------------------------
	-- 위자드 & 여자 위자드
	if ( 0 < _updateTime ) and ( UI_classType.ClassType_Wizard == classType or UI_classType.ClassType_WizardWomen == classType ) then
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "TUTORIAL_MOVE_WIZRAD_TALK1" ))		--여긴 어디야.\n하마터면 무너질 뻔했어.

		if false == startTutorial_comment1 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment1 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()	
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 5 < _updateTime ) and ( UI_classType.ClassType_Wizard == classType or UI_classType.ClassType_WizardWomen == classType )  then
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "TUTORIAL_MOVE_WIZRAD_TALK2" ))		--인간의 생존력은 대단해.\n하지만 아직 정신은 돌아오진 않는 모양이네.

		if false == startTutorial_comment2 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment2 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 9 < _updateTime ) and ( UI_classType.ClassType_Wizard == classType or UI_classType.ClassType_WizardWomen == classType )  then
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "TUTORIAL_MOVE_WIZRAD_TALK3" ))		--도와줄 테니 몸을 움직여봐.\n벌써 계약을 잊은 건 아니지?
		
		if false == startTutorial_comment3 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment3 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()		
		
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 13 < _updateTime ) and ( UI_classType.ClassType_Wizard == classType or UI_classType.ClassType_WizardWomen == classType )  then
		Panel_Tutorial_BtnShow()
		_updateTime = 0
		_stepNo = 1
	end
	
	-- 닌자 우먼 / 닌자
	if ( 0 < _updateTime ) and ( UI_classType.ClassType_NinjaWomen == classType or UI_classType.ClassType_NinjaMan == classType ) then
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "TUTORIAL_MOVE_NINJA_TALK1" ))		--여긴 어디야.\n하마터면 무너질 뻔했어.

		if false == startTutorial_comment1 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment1 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()	
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 5 < _updateTime ) and ( UI_classType.ClassType_NinjaWomen == classType or UI_classType.ClassType_NinjaMan == classType ) then
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "TUTORIAL_MOVE_NINJA_TALK2" ))		--인간의 생존력은 대단해.\n하지만 아직 정신은 돌아오진 않는 모양이네.

		if false == startTutorial_comment2 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment2 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 9 < _updateTime ) and ( UI_classType.ClassType_NinjaWomen == classType or UI_classType.ClassType_NinjaMan == classType ) then
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "TUTORIAL_MOVE_NINJA_TALK3" ))		--도와줄 테니 몸을 움직여봐.\n벌써 계약을 잊은 건 아니지?
		
		if false == startTutorial_comment3 then
			chatting_sendMessage( "", ui._obsidian_Text:GetText() , CppEnums.ChatType.System )
			startTutorial_comment3 = true
		end

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()		
		
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
	if ( 13 < _updateTime ) and ( UI_classType.ClassType_NinjaWomen == classType or UI_classType.ClassType_NinjaMan == classType ) then
		Panel_Tutorial_BtnShow()
		_updateTime = 0
		_stepNo = 1
	end
	
	
	
	
end

local sendChat_tutorial_Step1 = false
local updateDeltaTime_Step1 = function( deltaTime )
	Tutorial_ScreenRePosition()
	
	local srtingValue = PAGetString(Defines.StringSheet_GAME, "TUTORIAL_PURPOSE_STEP1")
	-- ui._purposeText:SetText( srtingValue )
	if false == sendChat_tutorial_Step1 then
		chatting_sendMessage( "", srtingValue , CppEnums.ChatType.System )
		sendChat_tutorial_Step1 = true
	end

	local scrX = getScreenSizeX()
	local scrY = getScreenSizeY()
	
	ui._obsidian:SetPosX( scrX * 0.5 - 20 )
	ui._obsidian:SetPosY( scrY * 0.5 - 300 )

	ui._obsidian_Text:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT") ) -- "도와줄 테니 움직여 보는 게 어때? \n설마 계약을 잊은 건 아니겠지?")
	ui._obsidian_Text_2:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_2") ) -- "<W>키를 눌러 앞으로 이동해봐~" )

	ui._bubbleKey_W:SetShow( true )

	local obsidianX = ui._obsidian:GetPosX()
	local obsidianY = ui._obsidian:GetPosY()
	
	ui._obsidian_B:SetPosX( getScreenSizeX()/2 + 50 )
	ui._obsidian_B:SetPosY( getScreenSizeY()/2 - 250 )
	
	local obsidianB_X = ui._obsidian_B:GetPosX()
	local obsidianB_Y = ui._obsidian_B:GetPosY()
	
	ui._obsidian_Text:SetPosX( obsidianB_X + 3 )
	ui._obsidian_Text:SetPosY( obsidianB_Y + 25 )

	local textSizeX = ui._obsidian_Text:GetTextSizeX()
	local textSizeY = ui._obsidian_Text:GetTextSizeY()
	-- ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
	
	ui._obsidian_Text_2:SetPosX( obsidianB_X + 3 )
	ui._obsidian_Text_2:SetPosY( ui._obsidian_Text:GetPosY() + textSizeY + 5 )
	ui._obsidian_Text_2:SetShow( true )

	ui._bubbleKey_W:SetPosX( ui._obsidian_Text_2:GetPosX() + ui._obsidian_Text_2:GetTextSizeX() + 20 )
	ui._bubbleKey_W:SetPosY( ui._obsidian_Text:GetPosY() + textSizeY + 5 )

	local widthSize = 20
	if isGameTypeKorea() then
		widthSize = 20
	else
		widthSize = 70
	end

	ui._obsidian_B:SetSize( ui._bubbleKey_W:GetPosX() - ui._obsidian_Text_2:GetPosX() + ui._bubbleKey_W:GetSizeX() + widthSize, textSizeY + ui._obsidian_Text_2:GetTextSizeY() + 45 )
	ui._obsidian_Text:SetSize( textSizeX, textSizeY )

	-- ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "TUTORIAL_PURPOSE_STEP1") )
	local isPress = keyCustom_IsPressed_Action( 0 )
	if ( isPress ) then
		_updateTime = _updateTime + deltaTime
	end

	ButtonToggleAll(false)
	ButtonToggle("_button_W", true)

	if ( 1.5 < _updateTime ) then
		-- ♬ 체크가 되고, 키가 열릴 때 사운드 추가
		ui._obsidian_Text_2:SetShow( false )
	
		-- ui._purposeText:AddEffect( "fUI_Gauge_BigWhite", false, 0.0, 0.0 )
		-- ui._clearStep_1:SetShow(true)
		-- ui._clearStep_1:AddEffect( "fUI_Light", false, 0.0, 0.0 )
		-- ui._clearStep_1:AddEffect( "UI_Check01", false, -2.0, 0.0 )
		-- ui._clearStep_1:AddEffect( "fL_CheckSpark01", false, -2.0, 0.0 )
		ui._nextStep_1:SetFontColor( UI_color.C_FFF26A6A )
		audioPostEvent_SystemUi(04,12)

		-- ui._obsidian_Text:SetText ( PAGetString(Defines.StringSheet_GAME, "TUTORIAL_MOVE_STEP1_DARKSPIRIT" ) )	-- 내 기운이 느껴져?
		ui._obsidian_Text:SetText ( PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_3") ) -- "내 기운이 느껴져?\n비틀거리지 말고 중심을 잡아봐." )
		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()

		ui._obsidian_Text_2:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_4") ) -- "<W>, <A>, <S>, <D>로 이동할 수 있어~." )
		ui._obsidian_Text_2:SetPosX( obsidianB_X + 3 )
		ui._obsidian_Text_2:SetPosY( ui._obsidian_Text:GetPosY() + textSizeY + 5 )
		ui._obsidian_Text_2:SetShow( true )
		
		bubbleKey_Hide()
		ui._bubbleKey_W:SetShow( true )
		ui._bubbleKey_A:SetShow( true )
		ui._bubbleKey_S:SetShow( true )
		ui._bubbleKey_D:SetShow( true )
		
		ui._bubbleKey_A:SetPosX( ui._obsidian_Text_2:GetPosX() + ui._obsidian_Text_2:GetTextSizeX() + 20 )
		ui._bubbleKey_A:SetPosY( ui._obsidian_Text_2:GetPosY() )
		ui._bubbleKey_S:SetPosX( ui._bubbleKey_A:GetPosX() + ui._bubbleKey_A:GetSizeX() + 5 )
		ui._bubbleKey_S:SetPosY( ui._obsidian_Text_2:GetPosY() )
		ui._bubbleKey_D:SetPosX( ui._bubbleKey_S:GetPosX() + ui._bubbleKey_S:GetSizeX() + 5 )
		ui._bubbleKey_D:SetPosY( ui._obsidian_Text_2:GetPosY() )
		ui._bubbleKey_W:SetPosX( ui._bubbleKey_A:GetPosX() + ui._bubbleKey_A:GetSizeX() + 5 )
		ui._bubbleKey_W:SetPosY( ui._bubbleKey_S:GetPosY() - ui._bubbleKey_S:GetSizeY() - 5 )
		
		ui._obsidian_B:SetSize( ui._bubbleKey_D:GetPosX() - ui._obsidian_Text_2:GetPosX() + ui._bubbleKey_D:GetSizeX() + 20, textSizeY + ui._obsidian_Text_2:GetTextSizeY() + 45 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )


		-- ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		-- ui._obsidian_Text:SetSize( textSizeX, textSizeY )
		
		-- ui._button_A:AddEffect("UI_ItemInstall", false, 0.0, 0.0 )
		-- ui._button_S:AddEffect("UI_ItemInstall", false, 0.0, 0.0 )
		-- ui._button_D:AddEffect("UI_ItemInstall", false, 0.0, 0.0 )
		local selfPlayer = getSelfPlayer()
		if nil ~= selfPlayer then		
			getSelfPlayer():setActionChart("TUTORIAL_WAIT_STEP2")
		end
		_updateTime = 0
		_stepNo = 2
		-- prevUsingKey._button_W = true
	end
end

local sendChat_tutorial_Step2 = false
local updateDeltaTime_Step2 = function( deltaTime )
	-- ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "TUTORIAL_PURPOSE_STEP2") )
	local srtingValue = PAGetString(Defines.StringSheet_GAME, "TUTORIAL_PURPOSE_STEP2")
	-- ui._purposeText:SetText( srtingValue )
	if false == sendChat_tutorial_Step2 then
		chatting_sendMessage( "", srtingValue , CppEnums.ChatType.System )
		sendChat_tutorial_Step2 = true
	end

	local isPress = keyCustom_IsPressed_Action( 0 ) or keyCustom_IsPressed_Action( 1 ) or keyCustom_IsPressed_Action( 2 ) or keyCustom_IsPressed_Action( 3 )
	if ( isPress ) then
		_updateTime = _updateTime + deltaTime
	end

	local obsidianB_X = ui._obsidian_B:GetPosX()
	local obsidianB_Y = ui._obsidian_B:GetPosY()

	ButtonToggleAll(false)
	ButtonToggle("_button_W", true)
	ButtonToggle("_button_A", true)
	ButtonToggle("_button_S", true)
	ButtonToggle("_button_D", true)

	if ( 2.0 < _updateTime ) then
		-- ♬ 체크가 되고, 키가 열릴 때 사운드 추가
		
		
		-- ui._purposeText:AddEffect( "fUI_Gauge_BigWhite", false, 0.0, 0.0 )
		-- ui._clearStep_2:SetShow(true)
		-- ui._clearStep_2:AddEffect( "fUI_Light", false, 0.0, 0.0 )
		-- ui._clearStep_2:AddEffect( "UI_Check01", false, -2.0, 0.0 )
		-- ui._clearStep_2:AddEffect( "fL_CheckSpark01", false, -2.0, 0.0 )
		-- ui._nextStep_2:SetFontColor( UI_color.C_FFF26A6A )
		audioPostEvent_SystemUi(04,12)

		ui._obsidian_Text:SetText ( PAGetString(Defines.StringSheet_GAME, "TUTORIAL_MOVE_STEP2_DARKSPIRIT" ) )		-- 점점 회복되고 있는 것 같아.\n역시 생각보다 빨라.
		-- local textSizeX = ui._obsidian_Text:GetTextSizeX()
		-- local textSizeY = ui._obsidian_Text:GetTextSizeY()
		-- ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		-- ui._obsidian_Text:SetSize( textSizeX, textSizeY )

		ui._obsidian_Text_2:SetShow( true )

		bubbleKey_Hide()
		ui._bubbleKey_W:SetShow( true )
		ui._bubbleKey_Shift:SetShow( true )

		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()
		-- ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )

		ui._obsidian_Text_2:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_5") ) -- "<SHIFT>와 <W>키를 누르면 달릴 수 있어." )
		ui._obsidian_Text_2:SetPosX( obsidianB_X + 3 )
		ui._obsidian_Text_2:SetPosY( ui._obsidian_Text:GetPosY() + textSizeY + 5 )

		ui._bubbleKey_Shift:SetPosX( ui._obsidian_Text_2:GetPosX() + ui._obsidian_Text_2:GetTextSizeX() + 20 )
		ui._bubbleKey_Shift:SetPosY( ui._obsidian_Text:GetPosY() + textSizeY + 5 )
		ui._bubbleKey_W:SetPosX( ui._bubbleKey_Shift:GetPosX() + ui._bubbleKey_Shift:GetSizeX() + 5 )
		ui._bubbleKey_W:SetPosY( ui._obsidian_Text:GetPosY() + textSizeY + 5 )

		ui._obsidian_B:SetSize( ui._bubbleKey_W:GetPosX() - ui._obsidian_Text_2:GetPosX() + ui._bubbleKey_W:GetSizeX() + 20, textSizeY + ui._obsidian_Text_2:GetTextSizeY() + 45 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )

		-- ui._button_Shift:AddEffect("UI_ItemInstall", false, 0.0, 0.0 )
		local selfPlayer = getSelfPlayer()
		if nil ~= selfPlayer then		
			getSelfPlayer():setActionChart("TUTORIAL_WAIT_STEP3")
		end
		_updateTime = 0
		_stepNo = 3
		-- prevUsingKey._button_W = true
		prevUsingKey._button_A = true
		prevUsingKey._button_S = true
		prevUsingKey._button_D = true
	end
end

local sendChat_tutorial_Step3 = false
local updateDeltaTime_Step3 = function( deltaTime )
	local stringValue = PAGetString(Defines.StringSheet_GAME, "TUTORIAL_PURPOSE_STEP3")
	-- ui._purposeText:SetText( stringValue )
	if false == sendChat_tutorial_Step3 then
		chatting_sendMessage( "", stringValue , CppEnums.ChatType.System )
		sendChat_tutorial_Step3 = true
	end
	
	local isPress = keyCustom_IsPressed_Action( 0 ) and keyCustom_IsPressed_Action( 6 )
	if ( isPress ) then
		_updateTime = _updateTime + deltaTime
	end

	ButtonToggleAll(false)
	ButtonToggle("_button_W", true)
	ButtonToggle("_button_A", true)
	ButtonToggle("_button_S", true)
	ButtonToggle("_button_D", true)
	ButtonToggle("_button_Shift", true)

	if ( 2 < _updateTime ) then
		-- ♬ 체크가 되고, 키가 열릴 때 사운드 추가
		
		
		ui._purposeText:AddEffect( "fUI_Gauge_BigWhite", false, 0.0, 0.0 )
		-- UI.debugMessage("MOVE ENDEND")
		-- getSelfPlayer():setActionChart("WAIT")
		-- ui._clearStep_3:SetShow(true)
		ui._clearStep_3:AddEffect( "fUI_Light", false, 0.0, 0.0 )
		ui._clearStep_3:AddEffect( "UI_Check01", false, -2.0, 0.0 )
		ui._clearStep_3:AddEffect( "fL_CheckSpark01", false, -2.0, 0.0 )
		ui._nextStep_3:SetFontColor( UI_color.C_FFF26A6A )
		Panel_Tutorial_BtnsDisappear()
		audioPostEvent_SystemUi(04,12)

		ui._obsidian_Text:SetText ( PAGetString(Defines.StringSheet_GAME, "TUTORIAL_MOVE_STEP3_DARKSPIRIT" ) )			-- 이제 너와 난 하나라는 걸 잊지마.
		ui._obsidian_Text_2:SetShow(false)
		ui._bubbleKey_W:SetShow( false )
		ui._bubbleKey_Shift:SetShow( false )
		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )

		_updateTime = 0
		_stepNo = 4
	end
end

local sendChat_tutorial_Step4 = false
function updateDeltaTime_Step4( deltaTime )
	local srtingValue = PAGetString(Defines.StringSheet_GAME, "TUTORIAL_PURPOSE_STEP4")
	ui._purposeText:SetText( srtingValue )
	if false == sendChat_tutorial_Step4 then
		chatting_sendMessage( "", srtingValue , CppEnums.ChatType.System )
		sendChat_tutorial_Step4 = true
	end

	_updateTime = _updateTime + deltaTime
	
	if ( 0.5 >= _updateTime ) then
		local selfPlayer = getSelfPlayer()
		if nil ~= selfPlayer then		
			getSelfPlayer():setActionChart("TUTORIAL_END")
		end
	end
	
	if ( 2.0 < _updateTime ) then
		_updateTime = 0
		_stepNo = 0
		Panel_WelcomeToTheWorld_End( deltaTime )
	end
end



-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CTRL, NPC찾기 튜토리얼
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local isNaviTutorial = false
local naviTutorialCount = 0
-- local naviCountCheck = false
function Panel_Tutorial_NaviCtrl_Start()
	Panel_Tutorial:SetShow( true, false )
	ui._purposeText:ComputePos()
	
	-- 기본적으로 애들을 꺼준다
	for _, v in pairs ( ui ) do
		v:SetShow( false )
	end
	Panel_Chat0:SetShow( false )	
	
	ButtonToggleAll(false)
	Panel_Tutorial_BtnHide()
	bubbleKey_Hide()
	FGlobal_Panel_LowLevelGuide_MovePlay_FindWay()
	
	-- naviCountCheck = false
	
	if 0 == naviTutorialCount then
		if( check_ShowWindow() ) then
			close_WindowPanelList()
		end
		if IM.eProcessorInputMode_GameMode ~= UI.Get_ProcessorInputMode() then
			UI.Set_ProcessorInputMode( IM.eProcessorInputMode_GameMode)
		end
	end
	
	ui._obsidian:SetShow(true)
	ui._obsidian:EraseAllEffect()
	ui._obsidian:AddEffect ( "fUI_DarkSpirit_Tutorial", true, 0, 0 )

	if 0 == naviTutorialCount then
		_stepNo = 21
	elseif 1 == naviTutorialCount or 2 == naviTutorialCount then
		_stepNo = 25
	elseif 3 <= naviTutorialCount then
		_stepNo = 26
	else
		_stepNo = 0
	end
	naviTutorialCount = naviTutorialCount + 1
end

function Panel_Tutorial_NaviCtrl_End()
	_stepNo = 0
	isNaviTutorial = false
	Panel_Tutorial:SetShow( false, false )
	Panel_Chat0:SetShow( false )
	isFirstPotion = false
end

local sendChat_NaviTutorial_Step1 = false
local updateDeltaTime_NaviCtrl_Step1 = function( deltaTime )
	if isFlushedUI() then
		ui._obsidian:SetShow(false)
		return
	end
	-- if 2 < naviTutorialCount then
		-- bubbleKey_Hide()
		-- ui._obsidian:SetShow(false)
		-- ui._obsidian_B_Left:SetShow(false)
		-- ui._obsidian_Text:SetShow(false)
		-- ui._obsidian_Text_2:SetShow( false )
		-- _stepNo = 0
		-- return
	-- end

	Panel_CheckedQuest:SetShow( true )
	Panel_Tutorial_NaviCtrl_IsNaviDone = true
	-- ui._purposeText:SetShow( true )
	-- ui._purposeText:SetAlpha( 1 )
	-- ui._purposeText:SetPosY( 100 )
	-- ui._purposeText:SetText( PAGetString ( Defines.StringSheet_GAME, "TUTORIAL_FINDWAY_STEP1" )	)	-- <PAColor0xFFFFD649>'CTRL'<PAOldColor> 키를 눌러 마우스 포인트를 활성화하세요
	
	local srtingValue = PAGetString(Defines.StringSheet_GAME, "TUTORIAL_FINDWAY_STEP1")-- <PAColor0xFFFFD649>'CTRL'<PAOldColor> 키를 눌러 마우스 포인트를 활성화하세요
	ui._purposeText:SetText( srtingValue )
	if false == sendChat_NaviTutorial_Step1 then
		chatting_sendMessage( "", srtingValue , CppEnums.ChatType.System )
		sendChat_NaviTutorial_Step1 = true
	end

	ButtonToggleAll(false)
	-- ButtonToggle("_button_Ctrl", true)

	-- ui._button_Ctrl:SetShow( true )
	-- ui._button_Ctrl:SetAlpha( 1 )

	
	-- 흑정령 안내 부분 : <Ctrl> 키를 눌러봐~
	
	-- if 0 == naviTutorialCount and ( false == naviCountCheck ) then
	
		ui._obsidian_B_Left:SetShow(true)
		ui._obsidian_Text:SetShow(true)
		ui._obsidian_Text_2:SetShow( true )

		bubbleKey_Hide()
		ui._bubbleKey_T:SetShow( true )
		
		ui._obsidian:SetPosX( getScreenSizeX()/2 - 150 )
		ui._obsidian:SetPosY( getScreenSizeY()/2 )
		
		local obsidianX = ui._obsidian:GetPosX()
		local obsidianY = ui._obsidian:GetPosY()
		
		ui._obsidian_Text:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_6") ) -- "안내선을 따라가면 목적지로 갈 수 있어.\n자동 달리기를 이용하면 편하게 갈 수 있어.")
		ui._obsidian_Text_2:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_7") ) -- "<T>키를 눌러 이동해봐~" )
		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()

		ui._obsidian_B_Left:SetSize( textSizeX + 20, textSizeY + ui._obsidian_Text_2:GetTextSizeY() + 45 )
		ui._obsidian_B_Left:SetPosX( obsidianX - ui._obsidian_B_Left:GetSizeX() + 30)
		ui._obsidian_B_Left:SetPosY( obsidianY - 150 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )

		local obsidianB_X = ui._obsidian_B_Left:GetPosX()
		local obsidianB_Y = ui._obsidian_B_Left:GetPosY()
		
		ui._obsidian_Text:SetPosX( obsidianB_X + 3 )
		ui._obsidian_Text:SetPosY( obsidianB_Y + 5 )

		ui._obsidian_Text_2:SetPosX( obsidianB_X + 3 )
		ui._obsidian_Text_2:SetPosY( ui._obsidian_Text:GetPosY() + textSizeY + 5 )
		
		ui._bubbleKey_T:SetPosX( ui._obsidian_Text_2:GetPosX() + ui._obsidian_Text_2:GetTextSizeX() + 10 )
		ui._bubbleKey_T:SetPosY( ui._obsidian_Text_2:GetPosY() )
		
		-- if false == naviCountCheck then
			-- naviCountCheck = true
			-- isInteractionForTutorial = true
			-- naviTutorialCount = naviTutorialCount + 1
		-- end
		
		-- _updateTime = _updateTime + deltaTime
		-- if ( 8.0 < _updateTime ) then
			-- _updateTime = 0
			-- bubbleKey_Hide()
			-- ui._obsidian:SetShow(false)
			-- ui._obsidian_B_Left:SetShow(false)
			-- ui._obsidian_Text:SetShow(false)
			-- ui._obsidian_Text_2:SetShow( false )
			-- Panel_Tutorial_NaviCtrl_End()
		-- end
end

local updateDeltaTime_NaviCtrl_Step1_1 = function( deltaTime )
	if isFlushedUI() then
		ui._obsidian:SetShow(false)
		return
	end

	local isPress = keyCustom_IsDownOnce_Ui( 0 )

	ui._obsidian_B_Left:SetShow(true)
	ui._obsidian_Text:SetShow(true)
	ui._obsidian_Text_2:SetShow( true )

	bubbleKey_Hide()
	ui._bubbleKey_Ctrl:SetShow( true )
	
	ui._obsidian:SetPosX( getScreenSizeX()/2 - 150 )
	ui._obsidian:SetPosY( getScreenSizeY()/2 )
	
	local obsidianX = ui._obsidian:GetPosX()
	local obsidianY = ui._obsidian:GetPosY()
	
	ui._obsidian_Text:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_8") ) -- "안내선이 나왔을 때 <T>키 말고도\n마우스를 이용해 이동할 수 있어.")
	ui._obsidian_Text_2:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_9") ) -- "<CTRL>키를 눌러봐~" )
	local textSizeX = ui._obsidian_Text:GetTextSizeX()
	local textSizeY = ui._obsidian_Text:GetTextSizeY()

	ui._obsidian_B_Left:SetSize( textSizeX + 20, textSizeY + ui._obsidian_Text_2:GetTextSizeY() + 45 )
	ui._obsidian_B_Left:SetPosX( obsidianX - ui._obsidian_B_Left:GetSizeX() + 30)
	ui._obsidian_B_Left:SetPosY( obsidianY - 150 )
	ui._obsidian_Text:SetSize( textSizeX, textSizeY )

	local obsidianB_X = ui._obsidian_B_Left:GetPosX()
	local obsidianB_Y = ui._obsidian_B_Left:GetPosY()
	
	ui._obsidian_Text:SetPosX( obsidianB_X + 3 )
	ui._obsidian_Text:SetPosY( obsidianB_Y + 5 )

	ui._obsidian_Text_2:SetPosX( obsidianB_X + 3 )
	ui._obsidian_Text_2:SetPosY( ui._obsidian_Text:GetPosY() + textSizeY + 5 )
	
	ui._bubbleKey_Ctrl:SetPosX( ui._obsidian_Text_2:GetPosX() + ui._obsidian_Text_2:GetTextSizeX() + 10 )
	ui._bubbleKey_Ctrl:SetPosY( ui._obsidian_Text_2:GetPosY() )
	
	-- if false == naviCountCheck then
		-- naviCountCheck = true
		-- naviTutorialCount = naviTutorialCount + 1
	-- end

	_updateTime = _updateTime + deltaTime
	if ( 8.0 < _updateTime ) then
		_updateTime = 0
		bubbleKey_Hide()
		ui._obsidian:SetShow(false)
		ui._obsidian_B_Left:SetShow(false)
		ui._obsidian_Text:SetShow(false)
		ui._obsidian_Text_2:SetShow( false )
		Panel_Tutorial_NaviCtrl_End()
	end

	if ( isPress ) then
		-- ui._purposeText:AddEffect( "fUI_Gauge_BigWhite", false, 0.0, 0.0 )
		audioPostEvent_SystemUi(04,12)
		
		-- bubbleKey_Hide()

		-- ui._obsidian:SetShow(true)
		-- ui._obsidian_B_Left:SetShow(true)
		-- ui._obsidian_Text:SetShow(true)
		-- ui._obsidian_Text_2:SetShow( true )

		ui._button_Ctrl:SetShow( false )
		ui._button_Ctrl:SetAlpha( 0 )

		isNaviTutorial = true
		-- FromClient_QuestWidget_Update()
		
		ui._obsidian_Text:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_12") ) -- "아래의 반짝이는 노란색 버튼을 누르면\n<T>키를 누른 것처럼 자동 이동을 시작해.")
		ui._obsidian_Text_2:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_13") ) -- "노란색 버튼을 마우스로 클릭해봐~" )
		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()
		local textSizeX2 = ui._obsidian_Text_2:GetTextSizeX()
		local textSizeY2 = ui._obsidian_Text_2:GetTextSizeY()

		ui._obsidian:SetPosX( Panel_CheckedQuest:GetPosX() + Panel_CheckedQuest:GetSizeX() - 100 )
		ui._obsidian:SetPosY( Panel_CheckedQuest:GetPosY() - 100 )
		
		local obsidianX = ui._obsidian:GetPosX()
		local obsidianY = ui._obsidian:GetPosY()
		
		ui._obsidian_B_Left:SetSize( textSizeX2 + 20, textSizeY + textSizeY2 + 45 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )

		ui._obsidian_B_Left:SetPosX( obsidianX - ui._obsidian_B_Left:GetSizeX() + 30)
		ui._obsidian_B_Left:SetPosY( obsidianY - 150 )

		local obsidianB_X = ui._obsidian_B_Left:GetPosX()
		local obsidianB_Y = ui._obsidian_B_Left:GetPosY()
		
		ui._obsidian_Text:SetPosX( obsidianB_X + 3 )
		ui._obsidian_Text:SetPosY( obsidianB_Y + 5 )

		ui._obsidian_Text_2:SetPosX( obsidianB_X + 3 )
		ui._obsidian_Text_2:SetPosY( ui._obsidian_Text:GetPosY() + textSizeY + 5 )
		
		ButtonToggleAll(false)
		Panel_CheckedQuest:AddEffect("UI_Tutorial_MouseMove", false, 140, -115 )
		
		-- if ( Panel_Tutorial_NaviCtrl_IsNaviDone == false ) then
			-- naviCountCheck = false
			_stepNo = 22
		-- end
	end
end

local updateDeltaTime_NaviCtrl_Step1_2 = function( deltaTime )
	if isFlushedUI() then
		ui._obsidian:SetShow(false)
		return
	end

	bubbleKey_Hide()

	ui._obsidian:SetShow(true)
	ui._obsidian_B_Left:SetShow(true)
	ui._obsidian_Text:SetShow(true)
	ui._obsidian_Text_2:SetShow( true )

	-- ui._bubbleKey_Ctrl:SetShow( true )
	
	ui._obsidian:SetPosX( getScreenSizeX()/2 - 150 )
	ui._obsidian:SetPosY( getScreenSizeY()/2 )
	
	local obsidianX = ui._obsidian:GetPosX()
	local obsidianY = ui._obsidian:GetPosY()
	
	ui._obsidian_Text:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_10") ) -- "이제 목적지까지 가는 법은 익숙해졌어?")
	ui._obsidian_Text_2:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_11") ) -- "<CTRL>키보단 <T>키가 편하긴 하지?" )

	local textSizeX = ui._obsidian_Text:GetTextSizeX()
	local textSizeY = ui._obsidian_Text:GetTextSizeY()

	ui._obsidian_B_Left:SetSize( ui._obsidian_Text_2:GetTextSizeX() + 20, textSizeY + ui._obsidian_Text_2:GetTextSizeY() + 45 )
	ui._obsidian_B_Left:SetPosX( obsidianX - ui._obsidian_B_Left:GetSizeX() + 30)
	ui._obsidian_B_Left:SetPosY( obsidianY - 150 )
	ui._obsidian_Text:SetSize( textSizeX, textSizeY )

	local obsidianB_X = ui._obsidian_B_Left:GetPosX()
	local obsidianB_Y = ui._obsidian_B_Left:GetPosY()
	
	ui._obsidian_Text:SetPosX( obsidianB_X + 3 )
	ui._obsidian_Text:SetPosY( obsidianB_Y + 5 )

	ui._obsidian_Text_2:SetPosX( obsidianB_X + 3 )
	ui._obsidian_Text_2:SetPosY( ui._obsidian_Text:GetPosY() + textSizeY + 5 )
	
	-- ui._bubbleKey_Ctrl:SetPosX( ui._obsidian_Text_2:GetPosX() + ui._obsidian_Text_2:GetTextSizeX() + 10 )
	-- ui._bubbleKey_Ctrl:SetPosY( ui._obsidian_Text_2:GetPosY() )
	_updateTime = _updateTime + deltaTime
	
	-- if false == naviCountCheck then
		-- naviCountCheck = true
		-- naviTutorialCount = naviTutorialCount + 1
	-- end

	if ( 8.0 < _updateTime ) then
		_updateTime = 0
		bubbleKey_Hide()
		ui._obsidian:SetShow(false)
		ui._obsidian_B_Left:SetShow(false)
		ui._obsidian_Text:SetShow(false)
		ui._obsidian_Text_2:SetShow( false )
		Panel_Tutorial_NaviCtrl_End()
	end
end


local sendChat_NaviTutorial_Step2 = false
local updateDeltaTime_NaviCtrl_Step2 = function( deltaTime )
	local srtingValue = PAGetString(Defines.StringSheet_GAME, "TUTORIAL_FINDWAY_STEP2")
		-- 마우스로 <PAColor0xFFFFD649>'빨간색'<PAOldColor> 또는 <PAColor0xFFFFD649>'노란색'<PAOldColor> 길 찾기 버튼을 누르세요
	ui._purposeText:SetText( srtingValue )
	if false == sendChat_NaviTutorial_Step2 then
		chatting_sendMessage( "", srtingValue , CppEnums.ChatType.System )
		sendChat_NaviTutorial_Step2 = true
	end
	
	bubbleKey_Hide()

	if ( Panel_Tutorial_NaviCtrl_IsNaviDone == false ) then
		-- ui._purposeText:AddEffect( "fUI_Gauge_BigWhite", false, 0.0, 0.0 )
		audioPostEvent_SystemUi(04,12)
		
		_stepNo = 23

		isNaviTutorial = false
		FromClient_QuestWidget_Update()
	end
end

local sendChat_NaviTutorial_Step3 = false
local updateDeltaTime_NaviCtrl_Step3 = function( deltaTime )
	FGlobal_Tutorial_QuestMasking_Hide()
	_updateTime = _updateTime + deltaTime

	local srtingValue = PAGetString(Defines.StringSheet_GAME, "TUTORIAL_FINDWAY_STEP3")	-- <PAColor0xFFFFD649>'빛 기둥'<PAOldColor> 을 찾아 해당 위치로 이동하세요
	ui._purposeText:SetText( srtingValue )
	if false == sendChat_NaviTutorial_Step3 then
		chatting_sendMessage( "", srtingValue , CppEnums.ChatType.System )
		sendChat_NaviTutorial_Step3 = true
	end
	
	if ( _updateTime >= 6 ) then
		ui._purposeText:AddEffect( "fUI_Gauge_BigWhite", false, 0.0, 0.0 )
		_updateTime = 0
		_stepNo = 24
	end

	isNaviTutorial = false
end

local sendChat_NaviTutorial_Step4 = false
local updateDeltaTime_NaviCtrl_Step4 = function( deltaTime )
	_updateTime = _updateTime + deltaTime
	local srtingValue = PAGetString(Defines.StringSheet_GAME, "TUTORIAL_FINDWAY_STEP4")	-- 마우스 커서 활성화 및 길 찾기 튜토리얼을 마칩니다
	ui._purposeText:SetText( srtingValue )
	if false == sendChat_NaviTutorial_Step4 then
		chatting_sendMessage( "", srtingValue , CppEnums.ChatType.System )
		sendChat_NaviTutorial_Step4 = true
	end
	
	if ( _updateTime >= 4 ) then
		Panel_Tutorial_NaviCtrl_End()
		_updateTime = 0
		isNaviTutorial = false
		FromClient_QuestWidget_Update()
		_stepNo = 0
	end
end

function IsNaviTutorial()
	return 	isNaviTutorial
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 기본 공격 튜토리얼
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Panel_Tutorial_Battle_Start()
	Panel_Adrenallin:SetShow( false )
	ui._purposeText:ComputePos()
	
	ui._nextStep_1:SetShow(true)
	ui._nextStep_2:SetShow(true)
	ui._nextStep_3:SetShow(true)
	ui._nextStep_4:SetShow(true)
	
	ui._nextArrow_0:SetShow(true)
	ui._nextArrow_1:SetShow(true)
	ui._nextArrow_2:SetShow(true)

	ui._clearStep_1:SetShow(false)
	ui._clearStep_2:SetShow(false)
	ui._clearStep_3:SetShow(false)
	ui._nextStep_1:SetFontColor( UI_color.C_FFFFFFFF )
	ui._nextStep_2:SetFontColor( UI_color.C_FFFFFFFF )
	ui._nextStep_3:SetFontColor( UI_color.C_FFFFFFFF )
	
	-- Panel_Win_Npc_Quest_List:SetShow( false )
	Panel_MainStatus_User_Bar:SetShow( false )
	Panel_SelfPlayerExpGage:SetShow( false )
	Panel_Chat0:SetShow( false )
	Panel_QuickSlot:SetShow( false )
	
	--Panel_Radar:SetShow( false )
	--Panel_RadarRealLine.panel:SetShow( false )
	FGlobal_Panel_RadarRealLine_Show( false )
	FGlobal_Panel_Radar_Show( false )
	
	-- Panel_NewQuest:SetShow( false )
	Panel_SkillCommand:SetShow( false )
	Panel_TimeBar:SetShow( false )

	-- ui._m0:ResetVertexAni()
	-- ui._m1:ResetVertexAni()
	-- ui._button_W:ResetVertexAni()
	-- ui._button_A:ResetVertexAni()
	-- ui._button_S:ResetVertexAni()
	-- ui._button_D:ResetVertexAni()
	-- ui._button_E:ResetVertexAni()
	-- ui._button_F:ResetVertexAni()
	-- ui._button_Tab:ResetVertexAni()
	-- ui._button_Shift:ResetVertexAni()
	-- ui._button_Space:ResetVertexAni()
	-- ui._mBody:ResetVertexAni()
	
	-- ui._m0:SetAlpha(1)
	-- ui._m1:SetAlpha(1)
	-- ui._button_W:SetAlpha(1)
	-- ui._button_A:SetAlpha(1)
	-- ui._button_S:SetAlpha(1)
	-- ui._button_D:SetAlpha(1)
	-- ui._button_E:SetAlpha(1)
	-- ui._button_F:SetAlpha(1)
	-- ui._button_Tab:SetAlpha(1)
	-- ui._button_Shift:SetAlpha(1)
	-- ui._button_Space:SetAlpha(1)
	-- ui._mBody:SetAlpha(1)

	Panel_Tutorial_BtnHide()
	bubbleKey_Hide()
	
	ui._obsidian:SetShow ( false )
	ui._obsidian_B:SetShow ( false )
	ui._obsidian_Text:SetShow ( false )
	-- ui._obsidian:SetShow(false)
	ui._obsidian_B_Left:SetShow(false)
	-- ui._obsidian_Text:SetShow(false)
	ui._obsidian_Text_2:SetShow( false )
	ui._bubbleKey_Ctrl:SetShow( false )
	ui._bubbleKey_T:SetShow( false )
	
	Panel_Tutorial:SetShow( true, false )
	
	Panel_Tutorial_BtnShow()
	ui._purposeText:SetShow(true)
	ui._nextStep_1:SetShow(true)
	ui._nextStep_2:SetShow(true)
	ui._nextStep_3:SetShow(true)
	ui._nextArrow_0:SetShow(true)
	ui._nextArrow_1:SetShow(true)
	
	_stepNo = 5
	ButtonToggleAll(false)
	ButtonToggle("_button_Q", true)
	ButtonToggle("_button_W", true)
	ButtonToggle("_button_A", true)
	ButtonToggle("_button_S", true)
	ButtonToggle("_button_D", true)
	ButtonToggle("_button_Shift", true)
	
	prevUsingKey._button_Q = true
	prevUsingKey._button_W = true
	prevUsingKey._button_A = true
	prevUsingKey._button_S = true
	prevUsingKey._button_D = true
	prevUsingKey._button_Shift = true
	
	isNaviTutorial = false
	isFirstPotion = false
end

function Panel_Tutorial_Battle_End()
	Panel_Adrenallin:SetShow( true )
	-- Panel_Win_Npc_Quest_List:SetShow( false )
	-- Panel_MainStatus_User_Bar:SetShow( true )
	FGlobal_Panel_MainStatus_User_Bar_Show()
	Panel_SelfPlayerExpGage:SetShow( true )
	-- Panel_Chat0:SetShow( true )
	-- Panel_QuickSlot:SetShow( true )
	-- Panel_UIMain:SetShow( false )
	-- Panel_Radar:SetShow( true )
	-- Panel_RadarRealLine.panel:SetShow( true )
	-- Panel_NewQuest:SetShow( true )
	Panel_SkillCommand:SetShow( false )
	-- GameOption_ShowSkillCmd()
	-- Panel_TimeBar:SetShow( true )
	
	FGlobal_MiniGame_Tutorial()
	-- getSelfPlayer():setActionChart("BT_WAIT")
	_stepNo = 0
	Panel_Tutorial:SetShow( false, false )

	_isTutorialEnd = true
	-- FGlobal_FirstLogin_Open()
	isBattleTutorialComplete = true
end
function FGlobal_BattleTutorial_CompleteCheck()
	return isBattleTutorialComplete
end

-- 키 입력을 체크하기 위한 변수
local isPressedTab = false
local isPressedMouse = false
local PressCount = -1
local isPressCountFirst = true

local sendChat_BattleTutorial_Step1 = false
local updateDeltaTime_Battle_Step1 = function( deltaTime )
	ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "TUTORIAL_PURPOSE_BATTLE_STEP1") )		-- [STEP 1] Tab 키 또는 좌클릭 하여 전투 자세와 비전투 자세로 변환해보세요
	local srtingValue = PAGetString(Defines.StringSheet_GAME, "TUTORIAL_PURPOSE_BATTLE_STEP1")	-- [STEP 1] Tab 키 또는 좌클릭 하여 전투 자세와 비전투 자세로 변환해보세요
	ui._purposeText:SetText( srtingValue )
	if false == sendChat_BattleTutorial_Step1 then
		chatting_sendMessage( "", srtingValue , CppEnums.ChatType.System )
		sendChat_BattleTutorial_Step1 = true
	end

	local isPressTab = keyCustom_IsDownOnce_Action( 10 )
	local isPressMouse = keyCustom_IsDownOnce_Action( 4 )
	
	if ( isPressTab ) then
		isPressedTab = true
	end
	
	if ( isPressMouse ) then
		isPressedMouse = true
	end
	
	ButtonToggleAll(false)
	-- ButtonToggle("_button_Q", true)
	ButtonToggle("_button_W", true)
	ButtonToggle("_button_A", true)
	ButtonToggle("_button_S", true)
	ButtonToggle("_button_D", true)
	ButtonToggle("_button_Shift", true)
	ButtonToggle("_m0", true)
	ButtonToggle("_button_Tab", true)

	if ( isPressedTab == true ) and ( isPressedMouse == true ) then
		-- ♬ 체크가 되고, 키가 열릴 때 사운드 추가
		
		
		ui._purposeText:AddEffect( "fUI_Gauge_BigWhite", false, 0.0, 0.0 )
		ui._clearStep_1:SetShow(true)
		ui._clearStep_1:AddEffect( "fUI_Light", false, 0.0, 0.0 )
		ui._clearStep_1:AddEffect( "UI_Check01", false, -2.0, 0.0 )
		ui._clearStep_1:AddEffect( "fL_CheckSpark01", false, -2.0, 0.0 )
		ui._nextStep_1:SetFontColor( UI_color.C_FFF26A6A )
		audioPostEvent_SystemUi(04,12)

		ui._m0:AddEffect("UI_ItemInstall", false, 0.0, 0.0 )
		ui._m1:AddEffect("UI_ItemInstall", false, 0.0, 0.0 )

		_updateTime = 0
		_stepNo = 6
		prevUsingKey._button_Q = true
		prevUsingKey._button_W = true
		prevUsingKey._button_A = true
		prevUsingKey._button_S = true
		prevUsingKey._button_D = true
		prevUsingKey._button_Shift = true
		prevUsingKey._button_Tab = true
	end
end

----------------------------------------------------------------------------
--				마우스를 마구 눌렀을 때 흑정령이 욕하는 곳
local updateDeltaTime_Battle_ForKeyPressed = function ( deltaTime )
	local isUp = keyCustom_IsUp_Action( 4 ) or keyCustom_IsUp_Action ( 5 )
	----------------------------------
	--		카운트를 누적시킨다..
	if ( isUp ) then
		PressCount = PressCount + 1
	end
	
	if ( PressCount == 3 ) and ( isPressCountFirst == true ) then
		isPressCountFirst = false
		local obsidianX = ui._obsidian:GetPosX()
		local obsidianY = ui._obsidian:GetPosY()
		
		ui._obsidian:SetShow( true )
		ui._obsidian_Text:SetShow( true )
		ui._obsidian_B:SetShow( true )
		ui._obsidian:EraseAllEffect()
		ui._obsidian:AddEffect ( "fUI_DarkSpirit_Tutorial", false, 0, 0 )
		
		ui._obsidian_B:SetPosX( obsidianX + 50 )
		ui._obsidian_B:SetPosY( obsidianY + 100 )
		
		local obsidianB_X = ui._obsidian_B:GetPosX()
		local obsidianB_Y = ui._obsidian_B:GetPosY()
		
		ui._obsidian_Text:SetText ( PAGetString( Defines.StringSheet_GAME, "TUTORIAL_PRESSEDKEY_DARKSPIRIT" ) )		-- 멍청아! 버튼을 계속 누르고 있는게\n더 효율적이라는 걸 왜 몰라!
		ui._obsidian_Text:SetPosX( obsidianB_X + 3 )
		ui._obsidian_Text:SetPosY( obsidianB_Y + 25 )
		
		local textSizeX = ui._obsidian_Text:GetTextSizeX()
		local textSizeY = ui._obsidian_Text:GetTextSizeY()
		ui._obsidian_B:SetSize( textSizeX + 15 ,textSizeY + 32 )
		ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	end
end

local sendChat_BattleTutorial_Step2 = false
local updateDeltaTime_Battle_Step2 = function( deltaTime )
	local srtingValue = PAGetString(Defines.StringSheet_GAME, "TUTORIAL_PURPOSE_BATTLE_STEP2")	-- [STEP 1] Tab 키 또는 좌클릭 하여 전투 자세와 비전투 자세로 변환해보세요
	ui._purposeText:SetText( srtingValue )
	if false == sendChat_BattleTutorial_Step2 then
		chatting_sendMessage( "", srtingValue , CppEnums.ChatType.System )
		sendChat_BattleTutorial_Step2 = true
	end

	local isPress = keyCustom_IsPressed_Action( 4 ) or keyCustom_IsPressed_Action( 5 )
	
	if ( isPress ) then
		_updateTime = _updateTime + deltaTime
	end

	ButtonToggleAll(false)
	ButtonToggle("_button_W", true)
	ButtonToggle("_button_A", true)
	ButtonToggle("_button_S", true)
	ButtonToggle("_button_D", true)
	ButtonToggle("_button_Shift", true)
	ButtonToggle("_button_Tab", true)
	ButtonToggle("_m0", true)
	ButtonToggle("_m1", true)

	if ( 3 < _updateTime ) then
		-- ♬ 체크가 되고, 키가 열릴 때 사운드 추가
		
		
		ui._purposeText:AddEffect( "fUI_Gauge_BigWhite", false, 0.0, 0.0 )
		ui._clearStep_2:SetShow(true)
		ui._clearStep_2:AddEffect( "fUI_Light", false, 0.0, 0.0 )
		ui._clearStep_2:AddEffect( "UI_Check01", false, -2.0, 0.0 )
		ui._clearStep_2:AddEffect( "fL_CheckSpark01", false, -2.0, 0.0 )
		ui._nextStep_2:SetFontColor( UI_color.C_FFF26A6A )
		audioPostEvent_SystemUi(04,12)

		_updateTime = 0
		PressCount = -1
		

		-- prevUsingKey._button_Q = true
		prevUsingKey._button_F = true
		prevUsingKey._button_W = true
		prevUsingKey._button_A = true
		prevUsingKey._button_S = true
		prevUsingKey._button_D = true
		prevUsingKey._button_Shift = true
		prevUsingKey._button_Tab = true
		prevUsingKey._m0 = true
		prevUsingKey._m1 = true
		
		-- 클래스 체크해서 PURPOSE 메시지 따로 출력해준다!
		if UI_classType.ClassType_Ranger == classType then
			prevUsingKey._button_Q = true
			prevUsingKey._button_S = false
			prevUsingKey._m0 = false
			_stepNo = 7
		elseif UI_classType.ClassType_Sorcerer == classType then
			prevUsingKey._button_Q = true
			prevUsingKey._button_S = false
			prevUsingKey._button_F = false
			_stepNo = 8
		elseif UI_classType.ClassType_Warrior == classType then -- or UI_classType.ClassType_BladeMaster == classType then
			ui._button_Q:AddEffect("UI_ItemInstall", false, 0.0, 0.0 )
			prevUsingKey._button_Q = false
			_stepNo = 9
		elseif UI_classType.ClassType_Giant == classType then
			ui._button_E:AddEffect("UI_ItemInstall", false, 0.0, 0.0 )
			prevUsingKey._button_Q = true
			_stepNo = 10
		elseif UI_classType.ClassType_Tamer == classType then
			-- ui._button_E:AddEffect("UI_ItemInstall", false, 0.0, 0.0 )
			prevUsingKey._m1 = false
			prevUsingKey._button_S = false
			prevUsingKey._button_Q = true
			ui._button_S:AddEffect("UI_ItemInstall", false, 0.0, 0.0 )
			ui._m1:AddEffect("UI_ItemInstall", false, 0.0, 0.0 )
			_stepNo = 13
		elseif UI_classType.ClassType_BladeMaster == classType or UI_classType.ClassType_BladeMasterWomen == classType then
			prevUsingKey._button_Q = true
			_stepNo = 14
		elseif UI_classType.ClassType_Valkyrie == classType then
			ui._button_Q:AddEffect("UI_ItemInstall", false, 0.0, 0.0 )
			prevUsingKey._button_Q = false
			_stepNo = 15
		elseif UI_classType.ClassType_Wizard == classType or UI_classType.ClassType_WizardWomen == classType then
			ui._button_S:AddEffect("UI_ItemInstall", false, 0.0, 0.0 )
			ui._m0:AddEffect("UI_ItemInstall", false, 0.0, 0.0 )
			prevUsingKey._button_S = false
			prevUsingKey._m0 = false
			prevUsingKey._button_F = true
			_stepNo = 16
		elseif UI_classType.ClassType_NinjaWomen == classType or UI_classType.ClassType_NinjaMan == classType then
			ui._m0:AddEffect("UI_ItemInstall", false, 0.0, 0.0 )
			ui._m1:AddEffect("UI_ItemInstall", false, 0.0, 0.0 )
			prevUsingKey._m0 = false
			prevUsingKey._m1 = false
			
			_stepNo = 17
		end

		ui._obsidian:SetShow( false )
		ui._obsidian_Text:SetShow( false )
		ui._obsidian_B:SetShow( false )
		
		ui._obsidian:EraseAllEffect()
	end
end

local sendChat_BattleTutorial_Step3_Ranger = false
local updateDeltaTime_Battle_Step3_Ranger = function( deltaTime )									-- 레인저
	local srtingValue = PAGetString(Defines.StringSheet_GAME, "TUTORIAL_PURPOSE_BATTLE_STEP3_Ranger")
	ui._purposeText:SetText( srtingValue )
	if false == sendChat_BattleTutorial_Step3_Ranger then
		chatting_sendMessage( "", srtingValue , CppEnums.ChatType.System )
		sendChat_BattleTutorial_Step3_Ranger = true
	end

	local isPress = keyCustom_IsPressed_Action( 1 ) and keyCustom_IsPressed_Action( 4 )

	ButtonToggleAll(false)
	-- ButtonToggle("_button_Q", true)
	ButtonToggle("_button_W", true)
	ButtonToggle("_button_A", true)
	ButtonToggle("_button_S", true)
	ButtonToggle("_button_D", true)
	ButtonToggle("_button_Shift", true)
	ButtonToggle("_button_Tab", true)
	-- ButtonToggle("_button_E", true)
	ButtonToggle("_m0", true)
	ButtonToggle("_m1", true)
	
	if ( isPress ) then
		_updateTime = _updateTime + deltaTime
	end

	if ( 1.0 < _updateTime ) then
		-- ♬ 체크가 되고, 키가 열릴 때 사운드 추가
		
		
		ui._purposeText:AddEffect( "fUI_Gauge_BigWhite", false, 0.0, 0.0 )
		ui._clearStep_3:SetShow(true)
		ui._clearStep_3:AddEffect( "fUI_Light", false, 0.0, 0.0 )
		ui._clearStep_3:AddEffect( "UI_Check01", false, -2.0, 0.0 )
		ui._clearStep_3:AddEffect( "fL_CheckSpark01", false, -2.0, 0.0 )
		ui._nextStep_3:SetFontColor( UI_color.C_FFF26A6A )
		audioPostEvent_SystemUi(04,12)

		ui._button_F:AddEffect("UI_ItemInstall", false, 0.0, 0.0 )

		_updateTime = 0
		_stepNo = 11
		-- prevUsingKey._button_Q = true
		prevUsingKey._button_W = true
		prevUsingKey._button_A = true
		prevUsingKey._button_S = true
		prevUsingKey._button_D = true
		prevUsingKey._button_Shift = true
		prevUsingKey._button_Tab = true
		prevUsingKey._button_E = true
		prevUsingKey._m0 = true
		prevUsingKey._m1 = true
	end
end

local sendChat_BattleTutorial_Step3_Sorcerer = false
local updateDeltaTime_Battle_Step3_Sorcerer = function( deltaTime )									-- 소서러
	local srtingValue = PAGetString(Defines.StringSheet_GAME, "TUTORIAL_PURPOSE_BATTLE_STEP3_Sorcerer")
	ui._purposeText:SetText( srtingValue )
	if false == sendChat_BattleTutorial_Step3_Sorcerer then
		chatting_sendMessage( "", srtingValue , CppEnums.ChatType.System )
		sendChat_BattleTutorial_Step3_Sorcerer = true
	end

	local isPress = keyCustom_IsPressed_Action( 1 ) and keyCustom_IsPressed_Action( 14 )

	ButtonToggleAll(false)
	-- ButtonToggle("_button_Q", true)
	ButtonToggle("_button_W", true)
	ButtonToggle("_button_A", true)
	ButtonToggle("_button_S", true)
	ButtonToggle("_button_D", true)
	ButtonToggle("_button_Shift", true)
	ButtonToggle("_button_Tab", true)
	ButtonToggle("_button_F", true)
	ButtonToggle("_m0", true)
	ButtonToggle("_m1", true)

	if ( isPress ) then
		_updateTime = _updateTime + deltaTime
	end

	if ( 1.0 < _updateTime ) then
		-- ♬ 체크가 되고, 키가 열릴 때 사운드 추가
		
		
		ui._purposeText:AddEffect( "fUI_Gauge_BigWhite", false, 0.0, 0.0 )
		ui._clearStep_3:SetShow(true)
		ui._clearStep_3:AddEffect( "fUI_Light", false, 0.0, 0.0 )
		ui._clearStep_3:AddEffect( "UI_Check01", false, -2.0, 0.0 )
		ui._clearStep_3:AddEffect( "fL_CheckSpark01", false, -2.0, 0.0 )
		ui._nextStep_3:SetFontColor( UI_color.C_FFF26A6A )
		audioPostEvent_SystemUi(04,12)

		ui._button_F:AddEffect("UI_ItemInstall", false, 0.0, 0.0 )

		_updateTime = 0
		_stepNo = 11
		-- prevUsingKey._button_Q = true
		prevUsingKey._button_W = true
		prevUsingKey._button_A = true
		prevUsingKey._button_S = true
		prevUsingKey._button_D = true
		prevUsingKey._button_Shift = true
		prevUsingKey._button_Tab = true
		-- prevUsingKey._button_F = true
		prevUsingKey._m0 = true
		prevUsingKey._m1 = true
	end
end

local sendChat_BattleTutorial_Step3_Warrior = false
local updateDeltaTime_Battle_Step3_Warrior = function( deltaTime ) 									-- 워리어
	local srtingValue = PAGetString(Defines.StringSheet_GAME, "TUTORIAL_PURPOSE_BATTLE_STEP3_War")
	ui._purposeText:SetText( srtingValue )
	if false == sendChat_BattleTutorial_Step3_Warrior then
		chatting_sendMessage( "", srtingValue , CppEnums.ChatType.System )
		sendChat_BattleTutorial_Step3_Warrior = true
	end

	local isPress = keyCustom_IsPressed_Action( 12 )

	ButtonToggleAll(false)
	ButtonToggle("_button_Q", true)
	ButtonToggle("_button_W", true)
	ButtonToggle("_button_A", true)
	ButtonToggle("_button_S", true)
	ButtonToggle("_button_D", true)
	ButtonToggle("_button_Shift", true)
	ButtonToggle("_button_Tab", true)
	-- ButtonToggle("_button_E", true)
	ButtonToggle("_m0", true)
	ButtonToggle("_m1", true)

	if ( isPress ) then
		_updateTime = _updateTime + deltaTime
	end

	if ( 1.0 < _updateTime ) then
		-- ♬ 체크가 되고, 키가 열릴 때 사운드 추가
		
		
		ui._purposeText:AddEffect( "fUI_Gauge_BigWhite", false, 0.0, 0.0 )
		ui._clearStep_3:SetShow(true)
		ui._clearStep_3:AddEffect( "fUI_Light", false, 0.0, 0.0 )
		ui._clearStep_3:AddEffect( "UI_Check01", false, -2.0, 0.0 )
		ui._clearStep_3:AddEffect( "fL_CheckSpark01", false, -2.0, 0.0 )
		ui._nextStep_3:SetFontColor( UI_color.C_FFF26A6A )
		audioPostEvent_SystemUi(04,12)

		ui._button_F:AddEffect("UI_ItemInstall", false, 0.0, 0.0 )

		_updateTime = 0
		_stepNo = 11
		prevUsingKey._button_Q = true
		prevUsingKey._button_W = true
		prevUsingKey._button_A = true
		prevUsingKey._button_S = true
		prevUsingKey._button_D = true
		prevUsingKey._button_Shift = true
		prevUsingKey._button_Tab = true
		-- prevUsingKey._button_E = true
		prevUsingKey._m0 = true
		prevUsingKey._m1 = true
	end
end

local sendChat_BattleTutorial_Step3_Giant = false
local updateDeltaTime_Battle_Step3_Giant = function( deltaTime )									-- 자이언트
	local srtingValue = PAGetString(Defines.StringSheet_GAME, "TUTORIAL_PURPOSE_BATTLE_STEP3_Giant")
	ui._purposeText:SetText( srtingValue )
	if false == sendChat_BattleTutorial_Step3_Giant then
		chatting_sendMessage( "", srtingValue , CppEnums.ChatType.System )
		sendChat_BattleTutorial_Step3_Giant = true
	end

	local isPress = keyCustom_IsPressed_Action( 13 )

	ButtonToggleAll(false)
	-- ButtonToggle("_button_Q", true)
	ButtonToggle("_button_W", true)
	ButtonToggle("_button_A", true)
	ButtonToggle("_button_S", true)
	ButtonToggle("_button_D", true)
	ButtonToggle("_button_Shift", true)
	ButtonToggle("_button_Tab", true)
	ButtonToggle("_button_E", true)
	ButtonToggle("_m0", true)
	ButtonToggle("_m1", true)

	if ( isPress ) then
		_updateTime = _updateTime + deltaTime
	end

	if ( 1.0 < _updateTime ) then
		-- ♬ 체크가 되고, 키가 열릴 때 사운드 추가
		ui._purposeText:AddEffect( "fUI_Gauge_BigWhite", false, 0.0, 0.0 )
		ui._clearStep_3:SetShow(true)
		ui._clearStep_3:AddEffect( "fUI_Light", false, 0.0, 0.0 )
		ui._clearStep_3:AddEffect( "UI_Check01", false, -2.0, 0.0 )
		ui._clearStep_3:AddEffect( "fL_CheckSpark01", false, -2.0, 0.0 )
		ui._nextStep_3:SetFontColor( UI_color.C_FFF26A6A )
		audioPostEvent_SystemUi(04,12)

		ui._button_F:AddEffect("UI_ItemInstall", false, 0.0, 0.0 )

		_updateTime = 0
		_stepNo = 11
		-- prevUsingKey._button_Q = true
		prevUsingKey._button_W = true
		prevUsingKey._button_A = true
		prevUsingKey._button_S = true
		prevUsingKey._button_D = true
		prevUsingKey._button_Shift = true
		prevUsingKey._button_Tab = true
		prevUsingKey._button_E = true
		prevUsingKey._m0 = true
		prevUsingKey._m1 = true
	end
end

local sendChat_BattleTutorial_Step3_Tamer = false
local updateDeltaTime_Battle_Step3_Tamer = function( deltaTime )									-- 금수랑
	local srtingValue = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_TAMER_BATTLE_STEP3") -- "[STEP 3] <PAColor0xFFFFD649>S + 우클릭<PAOldColor> 하여 공격해보세요"
	ui._purposeText:SetText( srtingValue )
	if false == sendChat_BattleTutorial_Step3_Tamer then
		chatting_sendMessage( "", srtingValue , CppEnums.ChatType.System )
		sendChat_BattleTutorial_Step3_Tamer = true
	end

	local isPress = keyCustom_IsPressed_Action( 1 ) and keyCustom_IsPressed_Action( 5 )

	ButtonToggleAll(false)
	-- ButtonToggle("_button_Q", true)
	ButtonToggle("_button_W", true)
	ButtonToggle("_button_A", true)
	ButtonToggle("_button_S", true)
	ButtonToggle("_button_D", true)
	ButtonToggle("_button_Shift", true)
	ButtonToggle("_button_Tab", true)
	-- ButtonToggle("_button_E", true)
	ButtonToggle("_m0", true)
	ButtonToggle("_m1", true)

	if ( isPress ) then
		_updateTime = _updateTime + deltaTime
	end

	if ( 0.5 < _updateTime ) then
		-- ♬ 체크가 되고, 키가 열릴 때 사운드 추가
		ui._purposeText:AddEffect( "fUI_Gauge_BigWhite", false, 0.0, 0.0 )
		ui._clearStep_3:SetShow(true)
		ui._clearStep_3:AddEffect( "fUI_Light", false, 0.0, 0.0 )
		ui._clearStep_3:AddEffect( "UI_Check01", false, -2.0, 0.0 )
		ui._clearStep_3:AddEffect( "fL_CheckSpark01", false, -2.0, 0.0 )
		ui._nextStep_3:SetFontColor( UI_color.C_FFF26A6A )
		audioPostEvent_SystemUi(04,12)

		ui._button_F:AddEffect("UI_ItemInstall", false, 0.0, 0.0 )

		_updateTime = 0
		_stepNo = 11
		-- prevUsingKey._button_Q = true
		prevUsingKey._button_W = true
		prevUsingKey._button_A = true
		prevUsingKey._button_S = true
		prevUsingKey._button_D = true
		prevUsingKey._button_Shift = true
		prevUsingKey._button_Tab = true
		prevUsingKey._button_E = true
		prevUsingKey._m0 = true
		prevUsingKey._m1 = true
	end
end

local sendChat_BattleTutorial_Step3_BladeMaster = false
local updateDeltaTime_Battle_Step3_BladeMaster = function( deltaTime ) 									-- 무사
	local srtingValue = PAGetString(Defines.StringSheet_GAME, "TUTORIAL_PURPOSE_BATTLE_STEP3_Blader")
	ui._purposeText:SetText( srtingValue )
	if false == sendChat_BattleTutorial_Step3_BladeMaster then
		chatting_sendMessage( "", srtingValue , CppEnums.ChatType.System )
		sendChat_BattleTutorial_Step3_BladeMaster = true
	end

	local isPress = keyCustom_IsPressed_Action( 13 )

	ButtonToggleAll(false)
	ButtonToggle("_button_Q", true)
	ButtonToggle("_button_W", true)
	ButtonToggle("_button_A", true)
	ButtonToggle("_button_S", true)
	ButtonToggle("_button_D", true)
	ButtonToggle("_button_Shift", true)
	ButtonToggle("_button_Tab", true)
	ButtonToggle("_button_E", true)
	ButtonToggle("_m0", true)
	ButtonToggle("_m1", true)

	if ( isPress ) then
		_updateTime = _updateTime + deltaTime
	end

	if ( 1.0 < _updateTime ) then
		-- ♬ 체크가 되고, 키가 열릴 때 사운드 추가
		
		
		ui._purposeText:AddEffect( "fUI_Gauge_BigWhite", false, 0.0, 0.0 )
		ui._clearStep_3:SetShow(true)
		ui._clearStep_3:AddEffect( "fUI_Light", false, 0.0, 0.0 )
		ui._clearStep_3:AddEffect( "UI_Check01", false, -2.0, 0.0 )
		ui._clearStep_3:AddEffect( "fL_CheckSpark01", false, -2.0, 0.0 )
		ui._nextStep_3:SetFontColor( UI_color.C_FFF26A6A )
		audioPostEvent_SystemUi(04,12)

		ui._button_F:AddEffect("UI_ItemInstall", false, 0.0, 0.0 )

		_updateTime = 0
		_stepNo = 11
		prevUsingKey._button_Q = true
		prevUsingKey._button_W = true
		prevUsingKey._button_A = true
		prevUsingKey._button_S = true
		prevUsingKey._button_D = true
		prevUsingKey._button_Shift = true
		prevUsingKey._button_Tab = true
		prevUsingKey._button_E = true
		prevUsingKey._m0 = true
		prevUsingKey._m1 = true
	end
end

local updateDeltaTime_Battle_Step3_Valkyrie = false
local updateDeltaTime_Battle_Step3_Valkyrie = function( deltaTime )									-- 발키리
	local srtingValue = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_VALKYRIE_BATTLE_STEP3") -- "[STEP 3] <PAColor0xFFFFD649>S + 우클릭<PAOldColor> 하여 공격해보세요"
	ui._purposeText:SetText( srtingValue )
	if false == updateDeltaTime_Battle_Step3_Valkyrie then
		chatting_sendMessage( "", srtingValue , CppEnums.ChatType.System )
		updateDeltaTime_Battle_Step3_Valkyrie = true
	end

	local isPress = keyCustom_IsPressed_Action( 12 )

	ButtonToggleAll(false)
	ButtonToggle("_button_Q", true)
	ButtonToggle("_button_W", true)
	ButtonToggle("_button_A", true)
	ButtonToggle("_button_S", true)
	ButtonToggle("_button_D", true)
	ButtonToggle("_button_Shift", true)
	ButtonToggle("_button_Tab", true)
	-- ButtonToggle("_button_E", true)
	ButtonToggle("_m0", true)
	ButtonToggle("_m1", true)

	if ( isPress ) then
		_updateTime = _updateTime + deltaTime
	end

	if ( 1.0 < _updateTime ) then
		-- ♬ 체크가 되고, 키가 열릴 때 사운드 추가
		
		
		ui._purposeText:AddEffect( "fUI_Gauge_BigWhite", false, 0.0, 0.0 )
		ui._clearStep_3:SetShow(true)
		ui._clearStep_3:AddEffect( "fUI_Light", false, 0.0, 0.0 )
		ui._clearStep_3:AddEffect( "UI_Check01", false, -2.0, 0.0 )
		ui._clearStep_3:AddEffect( "fL_CheckSpark01", false, -2.0, 0.0 )
		ui._nextStep_3:SetFontColor( UI_color.C_FFF26A6A )
		audioPostEvent_SystemUi(04,12)

		ui._button_F:AddEffect("UI_ItemInstall", false, 0.0, 0.0 )

		_updateTime = 0
		_stepNo = 11
		prevUsingKey._button_Q = true
		prevUsingKey._button_W = true
		prevUsingKey._button_A = true
		prevUsingKey._button_S = true
		prevUsingKey._button_D = true
		prevUsingKey._button_Shift = true
		prevUsingKey._button_Tab = true
		-- prevUsingKey._button_E = true
		prevUsingKey._m0 = true
		prevUsingKey._m1 = true
	end
end

local sendChat_BattleTutorial_Step3_Wizard = false
local updateDeltaTime_Battle_Step3_Wizard = function( deltaTime )									-- 위저드
	local srtingValue = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_WIZARD_BATTLE_STEP3")
	ui._purposeText:SetText( srtingValue )
	if false == sendChat_BattleTutorial_Step3_Wizard then
		chatting_sendMessage( "", srtingValue , CppEnums.ChatType.System )
		sendChat_BattleTutorial_Step3_Wizard = true
	end

	local isPress = keyCustom_IsPressed_Action( 1 ) and keyCustom_IsPressed_Action( 4 )

	ButtonToggleAll(false)
	-- ButtonToggle("_button_Q", true)
	ButtonToggle("_button_W", true)
	ButtonToggle("_button_A", true)
	ButtonToggle("_button_S", true)
	ButtonToggle("_button_D", true)
	ButtonToggle("_button_Shift", true)
	ButtonToggle("_button_Tab", true)
	ButtonToggle("_button_F", true)
	ButtonToggle("_m0", true)
	ButtonToggle("_m1", true)

	if ( isPress ) then
		_updateTime = _updateTime + deltaTime
	end

	if ( 1.0 < _updateTime ) then
		-- ♬ 체크가 되고, 키가 열릴 때 사운드 추가
		
		
		ui._purposeText:AddEffect( "fUI_Gauge_BigWhite", false, 0.0, 0.0 )
		ui._clearStep_3:SetShow(true)
		ui._clearStep_3:AddEffect( "fUI_Light", false, 0.0, 0.0 )
		ui._clearStep_3:AddEffect( "UI_Check01", false, -2.0, 0.0 )
		ui._clearStep_3:AddEffect( "fL_CheckSpark01", false, -2.0, 0.0 )
		ui._nextStep_3:SetFontColor( UI_color.C_FFF26A6A )
		audioPostEvent_SystemUi(04,12)

		ui._button_F:AddEffect("UI_ItemInstall", false, 0.0, 0.0 )

		_updateTime = 0
		_stepNo = 11
		-- prevUsingKey._button_Q = true
		prevUsingKey._button_W = true
		prevUsingKey._button_A = true
		prevUsingKey._button_S = true
		prevUsingKey._button_D = true
		prevUsingKey._button_Shift = true
		prevUsingKey._button_Tab = true
		prevUsingKey._button_F = true
		prevUsingKey._m0 = true
		prevUsingKey._m1 = true
	end
end

local sendChat_BattleTutorial_Step3_Ninja = false
local updateDeltaTime_Battle_Step3_Ninja = function( deltaTime )									-- 닌자
	local srtingValue = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_NINJA_BATTLE_STEP3")
	ui._purposeText:SetText( srtingValue )
	if false == sendChat_BattleTutorial_Step3_Ninja then
		chatting_sendMessage( "", srtingValue , CppEnums.ChatType.System )
		sendChat_BattleTutorial_Step3_Ninja = true
	end

	local isPress = keyCustom_IsPressed_Action( 4 ) and keyCustom_IsPressed_Action( 5 )

	ButtonToggleAll(false)
	-- ButtonToggle("_button_Q", true)
	ButtonToggle("_button_W", true)
	ButtonToggle("_button_A", true)
	ButtonToggle("_button_S", true)
	ButtonToggle("_button_D", true)
	ButtonToggle("_button_Shift", true)
	ButtonToggle("_button_Tab", true)
	ButtonToggle("_button_F", true)
	ButtonToggle("_m0", true)
	ButtonToggle("_m1", true)

	if ( isPress ) then
		_updateTime = _updateTime + deltaTime
	end

	if ( 1.0 < _updateTime ) then
		-- ♬ 체크가 되고, 키가 열릴 때 사운드 추가
		
		
		ui._purposeText:AddEffect( "fUI_Gauge_BigWhite", false, 0.0, 0.0 )
		ui._clearStep_3:SetShow(true)
		ui._clearStep_3:AddEffect( "fUI_Light", false, 0.0, 0.0 )
		ui._clearStep_3:AddEffect( "UI_Check01", false, -2.0, 0.0 )
		ui._clearStep_3:AddEffect( "fL_CheckSpark01", false, -2.0, 0.0 )
		ui._nextStep_3:SetFontColor( UI_color.C_FFF26A6A )
		audioPostEvent_SystemUi(04,12)

		ui._button_F:AddEffect("UI_ItemInstall", false, 0.0, 0.0 )

		_updateTime = 0
		_stepNo = 11
		-- prevUsingKey._button_Q = true
		prevUsingKey._button_W = true
		prevUsingKey._button_A = true
		prevUsingKey._button_S = true
		prevUsingKey._button_D = true
		prevUsingKey._button_Shift = true
		prevUsingKey._button_Tab = true
		prevUsingKey._button_F = true
		prevUsingKey._m0 = true
		prevUsingKey._m1 = true
	end
end

local sendChat_BattleTutorial_Step4 = false
local updateDeltaTime_Battle_Step4 = function( deltaTime )
	local srtingValue = PAGetString(Defines.StringSheet_GAME, "TUTORIAL_PURPOSE_BATTLE_STEP4")
	ui._purposeText:SetText( srtingValue )
	if false == sendChat_BattleTutorial_Step4 then
		chatting_sendMessage( "", srtingValue , CppEnums.ChatType.System )
		sendChat_BattleTutorial_Step4 = true
	end

	local isPress = keyCustom_IsPressed_Action( 14 )
	if ( isPress ) then
		_updateTime = _updateTime + deltaTime
	end

	ButtonToggleAll(false)
	ButtonToggle("_button_W", true)
	ButtonToggle("_button_A", true)
	ButtonToggle("_button_S", true)
	ButtonToggle("_button_D", true)
	ButtonToggle("_button_Shift", true)
	ButtonToggle("_button_Tab", true)
	ButtonToggle("_button_F", true)
	
	if UI_classType.ClassType_Ranger == classType then
		ButtonToggle("_button_E", false)
		ButtonToggle("_button_Q", false)
	elseif UI_classType.ClassType_Sorcerer== classType then
		ButtonToggle("_button_E", false)
		ButtonToggle("_button_Q", false)
	elseif UI_classType.ClassType_Warrior == classType then
		ButtonToggle("_button_E", false)
		ButtonToggle("_button_Q", true)
	elseif UI_classType.ClassType_Giant == classType then
		ButtonToggle("_button_E", true)
		ButtonToggle("_button_Q", false)
	else
		ButtonToggle("_button_E", false)
		ButtonToggle("_button_Q", false)
	end
	
	
	ButtonToggle("_m0", true)
	ButtonToggle("_m1", true)
	
	prevUsingKey._button_F = false

	if ( 1.0 < _updateTime ) then
		-- ♬ 체크가 되고, 키가 열릴 때 사운드 추가
		
		
		ui._purposeText:AddEffect( "fUI_Gauge_BigWhite", false, 0.0, 0.0 )
		ui._clearStep_4:SetShow(true)
		ui._clearStep_4:AddEffect( "fUI_Light", false, 0.0, 0.0 )
		ui._clearStep_4:AddEffect( "UI_Check01", false, -2.0, 0.0 )
		ui._clearStep_4:AddEffect( "fL_CheckSpark01", false, -2.0, 0.0 )
		ui._nextStep_4:SetFontColor( UI_color.C_FFF26A6A )
		audioPostEvent_SystemUi(04,12)

		Panel_Tutorial_BtnsDisappear()

		_updateTime = 0
		_stepNo = 12
		prevUsingKey._button_Q = true
		prevUsingKey._button_W = true
		prevUsingKey._button_A = true
		prevUsingKey._button_S = true
		prevUsingKey._button_D = true
		prevUsingKey._button_Shift = true
		prevUsingKey._button_Tab = true
		prevUsingKey._button_F = true
		
		if UI_classType.ClassType_Ranger == classType then
		elseif UI_classType.ClassType_Sorcerer== classType then
		elseif UI_classType.ClassType_Warrior == classType then
		elseif UI_classType.ClassType_Giant == classType then
		end
	
		prevUsingKey._button_E = true
		prevUsingKey._m0 = true
		prevUsingKey._m1 = true
	end
end

local sendChat_BattleTutorial_Step5 = false
function updateDeltaTime_Battle_Step5( deltaTime )
	local srtingValue = PAGetString(Defines.StringSheet_GAME, "TUTORIAL_PURPOSE_BATTLE_STEP5")
	ui._purposeText:SetText( srtingValue )
	if false == sendChat_BattleTutorial_Step5 then
		chatting_sendMessage( "", srtingValue , CppEnums.ChatType.System )
		sendChat_BattleTutorial_Step5 = true
	end

	_updateTime = _updateTime + deltaTime

	if ( 1 < _updateTime ) then
		_updateTime = 0
		_stepNo = 0
		Panel_Tutorial_Battle_End()
	end
end



-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 인벤토리 열기 튜토리얼
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Panel_Tutorial_OpenInventory_Start()
	-- Panel_MainStatus_User_Bar:SetShow( true )
	-- Panel_QuickSlot:SetShow( true )

	Panel_Tutorial:SetShow( true, false )
	
	-- 기본적으로 애들을 꺼준다
	for _, v in pairs ( ui ) do
		v:SetShow( false )
	end
	
	ui._obsidian:SetShow(true)
	ui._obsidian:EraseAllEffect()
	ui._obsidian:AddEffect ( "fUI_DarkSpirit_Tutorial", true, 0, 0 )
	ui._obsidian_B:SetShow(false)
	ui._obsidian_B_Left:SetShow(true)
	ui._obsidian_Text:SetShow(true)
	ui._obsidian_Text_2:SetShow( true )
	
	_stepNo = 96
	isFirstPotion = true
	
end

function Panel_Tutorial_OpenInventory_End()
	_stepNo = 0
	Panel_Tutorial:SetShow( false, false )
	isFirstPotion = false
end

function isFirstPotionTutorial()
	return isFirstPotion
end

--------------------------------------------------------------------
--				물약 먹기 튜토리얼용 변수 모음
local openInven_isPressed_I = false			-- i키를 눌렀는지 변수 체크
local openInven_isPressed_M1 = false		-- 마우스 우클릭을 눌렀는지 변수 체크

local sendChat_OpenInventory_Step1 = false
local updateDeltaTime_OpenInventory_Step1 = function( deltaTime )
	-- ui._purposeText:SetShow( true )
	-- ui._purposeText:SetPosY( 100 )
	-- ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "TUTORIAL_OPENINVENTORY_STEP1") )		-- 'i' 키를 눌러 가방을 열어 물약을 먹으세요
	local srtingValue = PAGetString(Defines.StringSheet_GAME, "TUTORIAL_OPENINVENTORY_STEP1")-- 'i' 키를 눌러 가방을 열어 물약을 먹으세요
	-- ui._purposeText:SetText( srtingValue )
	if false == sendChat_OpenInventory_Step1 then
		chatting_sendMessage( "", srtingValue , CppEnums.ChatType.System )
		sendChat_OpenInventory_Step1 = true
	end	
	
	bubbleKey_Hide()
	ui._bubbleKey_I:SetShow( true )

	ui._obsidian:SetPosX( getScreenSizeX()/2 - 150 )
	ui._obsidian:SetPosY( getScreenSizeY()/2 )
	
	local obsidianX = ui._obsidian:GetPosX()
	local obsidianY = ui._obsidian:GetPosY()
	
	ui._obsidian_Text:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_14") ) --  "가방을 열면 생명력 회복제가 있을 거야.")
	ui._obsidian_Text_2:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_15") ) --  "<i>키를 눌러 가방을 열어봐~" )
	
	local textSizeX		= ui._obsidian_Text:GetTextSizeX()
	local text2SizeX	= ui._obsidian_Text_2:GetTextSizeX() + ui._bubbleKey_I:GetSizeX() + 20
	local moreLongSizeX = ui._obsidian_Text:GetTextSizeX()
	if text2SizeX < textSizeX then
		moreLongSizeX = ui._obsidian_Text:GetTextSizeX() + 20
	else
		moreLongSizeX = ui._obsidian_Text_2:GetTextSizeX() + ui._bubbleKey_I:GetSizeX() + 20
	end
	local textSizeY		= ui._obsidian_Text:GetTextSizeY()

	-- ui._obsidian_B_Left:SetSize( ui._obsidian_Text:GetTextSizeX() + 20, textSizeY + ui._obsidian_Text_2:GetTextSizeY() + 45 )
	-- ui._obsidian_Text:SetSize( textSizeX, textSizeY )

	-- ui._obsidian_B_Left:SetPosX( obsidianX - ui._obsidian_B_Left:GetSizeX() - 50)
	-- ui._obsidian_B_Left:SetPosY( obsidianY - 100 )
	
	local obsidianB_X = ui._obsidian_B_Left:GetPosX()
	local obsidianB_Y = ui._obsidian_B_Left:GetPosY()
	
	ui._obsidian_Text:SetPosX( obsidianB_X + 3 )
	ui._obsidian_Text:SetPosY( obsidianB_Y + 5 )

	ui._obsidian_Text_2:SetPosX( obsidianB_X + 3 )
	ui._obsidian_Text_2:SetPosY( ui._obsidian_Text:GetPosY() + textSizeY + 5 )
	
	ui._bubbleKey_I:SetPosX( ui._obsidian_Text_2:GetPosX() + ui._obsidian_Text_2:GetTextSizeX() + 10 )
	ui._bubbleKey_I:SetPosY( ui._obsidian_Text_2:GetPosY() )
	
	ui._obsidian_B_Left:SetSize( moreLongSizeX, textSizeY + ui._obsidian_Text_2:GetTextSizeY() + 45 )
	ui._obsidian_B_Left:SetPosX( obsidianX - ui._obsidian_B_Left:GetSizeX() + 30)
	ui._obsidian_B_Left:SetPosY( obsidianY - 150 )
	ui._obsidian_Text:SetSize( textSizeX, textSizeY )

	local isPress_I = keyCustom_IsDownOnce_Ui( 3 ) 
	
	if ( isPress_I ) then
		openInven_isPressed_I = true
	end

	if ( openInven_isPressed_I == true ) then
		-- ♬ 클리어 사운드 추가
		audioPostEvent_SystemUi(04,12)
		-- ui._purposeText:AddEffect( "fUI_Gauge_BigWhite", false, 0.0, 0.0 )
		
		_updateTime = 0
		_stepNo = 97
	end
end

local sendChat_OpenInventory_Step2 = false
local updateDeltaTime_OpenInventory_Step2 = function( deltaTime )
	local srtingValue = PAGetString(Defines.StringSheet_GAME, "TUTORIAL_OPENINVENTORY_STEP2")-- 가방 안에 있는 물약을 '마우스 우클릭'을 이용해 먹어보세요
	ui._purposeText:SetText( srtingValue )
	if false == sendChat_OpenInventory_Step2 then
		chatting_sendMessage( "", srtingValue , CppEnums.ChatType.System )
		sendChat_OpenInventory_Step2 = true
	end

	local isPress_MouseRUp = keyCustom_IsDownOnce_Action( 5 ) 
	-- ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "TUTORIAL_OPENINVENTORY_STEP2") )		-- 가방 안에 있는 물약을 '마우스 우클릭'을 이용해 먹어보세요
	
	bubbleKey_Hide()
	ui._obsidian_B:SetShow(true)
	ui._obsidian_B_Left:SetShow(false)
	ui._obsidian_Text:SetShow( true )
	ui._obsidian_Text_2:SetShow( true )

	ui._obsidian_Text:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_16") ) -- "가방 안에서 빛나고 있는 생명력 회복제가 보여?")
	ui._obsidian_Text_2:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_17") ) -- "마우스 우클릭을 이용해 사용해봐." )
	
	-- local scrX = getScreenSizeX()
	-- local scrY = getScreenSizeY()
	
	-- ui._obsidian:SetPosX( Panel_Window_Inventory:GetPosX() - 20 )
	-- ui._obsidian:SetPosY( Panel_Window_Inventory:GetPosY() - 100 )

	-- local obsidianX = ui._obsidian:GetPosX()
	-- local obsidianY = ui._obsidian:GetPosY()
	
	-- ui._obsidian_B:SetPosX( obsidianX + 80 )
	-- ui._obsidian_B:SetPosY( obsidianY + 30 )
	
	-- local obsidianB_X = ui._obsidian_B:GetPosX()
	-- local obsidianB_Y = ui._obsidian_B:GetPosY()
	
	-- ui._obsidian_Text:SetPosX( obsidianB_X + 3 )
	-- ui._obsidian_Text:SetPosY( obsidianB_Y + 25 )

	-- local textSizeX = ui._obsidian_Text:GetTextSizeX()
	-- local textSizeY = ui._obsidian_Text:GetTextSizeY()

	-- ui._obsidian_Text_2:SetPosX( obsidianB_X + 3 )
	-- ui._obsidian_Text_2:SetPosY( ui._obsidian_Text:GetPosY() + textSizeY + 5 )
	
	-- ui._obsidian_B:SetSize( ui._obsidian_Text:GetTextSizeX() + 20, ui._obsidian_Text_2:GetTextSizeY() + textSizeY + 40 )
	-- ui._obsidian_Text:SetSize( textSizeX, textSizeY )
	
	local textSizeX = ui._obsidian_Text:GetTextSizeX()
	local textSizeY = ui._obsidian_Text:GetTextSizeY()

	local scrX = getScreenSizeX()
	local scrY = getScreenSizeY()
	
	ui._obsidian_B:SetSize( ui._obsidian_Text:GetTextSizeX() + 20, ui._obsidian_Text_2:GetTextSizeY() + textSizeY + 40 )
	ui._obsidian_Text:SetSize( textSizeX, textSizeY )

	ui._obsidian:SetPosX( scrX - ui._obsidian_B:GetSizeX() - ui._obsidian:GetSizeX() - 40 )
	ui._obsidian:SetPosY( Panel_Window_Inventory:GetPosY() - 100 )

	local obsidianX = ui._obsidian:GetPosX()
	local obsidianY = ui._obsidian:GetPosY()
	
	ui._obsidian_B:SetPosX( obsidianX + 80 )
	ui._obsidian_B:SetPosY( obsidianY + 30 )
	
	local obsidianB_X = ui._obsidian_B:GetPosX()
	local obsidianB_Y = ui._obsidian_B:GetPosY()
	
	ui._obsidian_Text:SetPosX( obsidianB_X + 3 )
	ui._obsidian_Text:SetPosY( obsidianB_Y + 25 )

	ui._obsidian_Text_2:SetPosX( obsidianB_X + 3 )
	ui._obsidian_Text_2:SetPosY( ui._obsidian_Text:GetPosY() + textSizeY + 5 )



	if ( isPress_MouseRUp ) then
		openInven_isPressed_M1 = true
	end
	
	if ( openInven_isPressed_M1 == true ) or not isFirstPotion then
		-- ♬ 클리어 사운드 추가
		audioPostEvent_SystemUi(04,12)
		ui._purposeText:AddEffect( "fUI_Gauge_BigWhite", false, 0.0, 0.0 )

		_updateTime = 0
		_stepNo = 98
		isFirstPotion = false
		FGlobal_Tutorial_QuestMasking_Hide()
	end
	
end

local sendChat_OpenInventory_Step3 = false
function updateDeltaTime_OpenInventory_Step3( deltaTime )
	local srtingValue = PAGetString(Defines.StringSheet_GAME, "TUTORIAL_OPENINVENTORY_STEP3")-- 물약을 건네준 NPC와 대화하여 퀘스트를 완료하세요
	ui._purposeText:SetText( srtingValue )
	if false == sendChat_OpenInventory_Step3 then
		chatting_sendMessage( "", srtingValue , CppEnums.ChatType.System )
		sendChat_OpenInventory_Step3 = true
	end
	-- ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "TUTORIAL_OPENINVENTORY_STEP3") )		-- 물약을 건네준 NPC와 대화하여 퀘스트를 완료하세요

	bubbleKey_Hide()
	ui._obsidian_Text_2:SetShow( false )
	
	ui._obsidian_Text:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_18") ) -- "잘 했어~. 이제 회복제를 준 녀석에게 <R>키로\n말을 걸면 의뢰가 완료될 거야. 어서 가봐~")
	
	local obsidianX = ui._obsidian:GetPosX()
	local obsidianY = ui._obsidian:GetPosY()
	
	ui._obsidian_B:SetPosX( obsidianX + 80 )
	ui._obsidian_B:SetPosY( obsidianY + 30 )
	
	local obsidianB_X = ui._obsidian_B:GetPosX()
	local obsidianB_Y = ui._obsidian_B:GetPosY()
	
	ui._obsidian_Text:SetPosX( obsidianB_X + 3 )
	ui._obsidian_Text:SetPosY( obsidianB_Y + 25 )

	_updateTime = _updateTime + deltaTime

	if isFirstPotion then
		isFirstPotion = false
	end
	if ( 5 < _updateTime ) then
		_updateTime = 0
		_stepNo = 0
		Panel_Tutorial_OpenInventory_End()
	end
end

function FGlobal_FirstPotionUse()		-- 단축키로 포션을 먹었을 때!
	isFirstPotion = false
end

--Panel_Tutorial_OpenInventory_Start()
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------
--				흑정령 소환 튜토리얼
--------------------------------------------------------------------
local updateDeltaTime_CallSpirit_Step1 = function( deltaTime )

	FGlobal_Tutorial_SpiritMasking_Show()
	
	-- local isPress = GlobalKeyBinder_CheckCustomKeyPressed( CppEnums.UiInputType.UiInputType_BlackSpirit )
	-- ui._purposeText:SetText( PAGetString(Defines.StringSheet_GAME, "TUTORIAL_OPENINVENTORY_STEP2") )		-- 가방 안에 있는 물약을 '마우스 우클릭'을 이용해 먹어보세요
	
	ui._obsidian:SetShow(true)
	ui._obsidian_B:SetShow(true)
	ui._obsidian_B_Left:SetShow(false)
	ui._obsidian_Text:SetShow( true )
	ui._obsidian_Text_2:SetShow( true )
	
	ui._obsidian_Text:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_19") ) -- "잘 했어. 역시 내 파트너야~. 이제 너에게 줄 것이 있어.")
	local blackSpiritKeyString = keyCustom_GetString_UiKey( CppEnums.UiInputType.UiInputType_BlackSpirit )
	ui._obsidian_Text_2:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_20", "keyString", blackSpiritKeyString ) ) -- "/키를 눌러 나를 소환해봐." )
	
	local textSizeX = ui._obsidian_Text:GetTextSizeX()
	local textSizeY = ui._obsidian_Text:GetTextSizeY()

	local scrX = getScreenSizeX()
	local scrY = getScreenSizeY()
	
	ui._obsidian_B:SetSize( ui._obsidian_Text:GetTextSizeX() + 20, ui._obsidian_Text_2:GetTextSizeY() + textSizeY + 40 )
	ui._obsidian_Text:SetSize( textSizeX, textSizeY )

	ui._obsidian:SetPosX( scrX - ui._obsidian_B:GetSizeX() - ui._obsidian:GetSizeX() - 40 )
	ui._obsidian:SetPosY( Panel_NewQuest_Alarm:GetPosY() - 180 )

	local obsidianX = ui._obsidian:GetPosX()
	local obsidianY = ui._obsidian:GetPosY()
	
	ui._obsidian_B:SetPosX( obsidianX + 80 )
	ui._obsidian_B:SetPosY( obsidianY + 30 )
	
	local obsidianB_X = ui._obsidian_B:GetPosX()
	local obsidianB_Y = ui._obsidian_B:GetPosY()
	
	ui._obsidian_Text:SetPosX( obsidianB_X + 3 )
	ui._obsidian_Text:SetPosY( obsidianB_Y + 25 )

	ui._obsidian_Text_2:SetPosX( obsidianB_X + 3 )
	ui._obsidian_Text_2:SetPosY( ui._obsidian_Text:GetPosY() + textSizeY + 5 )
	
end

--------------------------------------------------------------------
--				보스 소환 튜토리얼
--------------------------------------------------------------------
local summonText = {}
local updateDeltaTime_SummonBoss_Step1 = function( deltaTime )

	ui._obsidian:SetShow(true)
	ui._obsidian_B:SetShow(true)
	ui._obsidian_B_Left:SetShow(false)
	ui._obsidian_Text:SetShow( true )
	ui._obsidian_Text_2:SetShow( true )
	ui._bubbleKey_I:SetShow( true )	
	
	ui._obsidian_Text:SetText( summonText[0] ) -- "바로 여기야! 이곳에서 임프 대장을 소환할 수 있어." )
	ui._obsidian_Text_2:SetText( summonText[1] ) -- "가방을 열어 임프 대장 소환서를 우클릭해봐." )
	
	local textSizeX = ui._obsidian_Text:GetTextSizeX()
	local textSizeY = ui._obsidian_Text:GetTextSizeY()

	local scrX = getScreenSizeX()
	local scrY = getScreenSizeY()

	ui._obsidian_B:SetSize( ui._obsidian_Text_2:GetTextSizeX() + ui._bubbleKey_I:GetSizeX() + 30, ui._obsidian_Text_2:GetTextSizeY() + textSizeY + 40 )
	ui._obsidian_Text:SetSize( textSizeX, textSizeY )

	ui._obsidian:SetPosX( scrX/2 - ui._obsidian_B:GetSizeX()/2 - ui._obsidian:GetSizeX()/2 )
	ui._obsidian:SetPosY( 100 )

	local obsidianX = ui._obsidian:GetPosX()
	local obsidianY = ui._obsidian:GetPosY()
	
	ui._obsidian_B:SetPosX( obsidianX + 80 )
	ui._obsidian_B:SetPosY( obsidianY + 30 )
	
	local obsidianB_X = ui._obsidian_B:GetPosX()
	local obsidianB_Y = ui._obsidian_B:GetPosY()
	
	ui._obsidian_Text:SetPosX( obsidianB_X + 3 )
	ui._obsidian_Text:SetPosY( obsidianB_Y + 25 )

	ui._bubbleKey_I:SetPosX( ui._obsidian_Text_2:GetPosX() + ui._obsidian_Text_2:GetTextSizeX() + 10 )
	ui._bubbleKey_I:SetPosY( ui._obsidian_Text_2:GetPosY() )

	ui._obsidian_Text_2:SetPosX( obsidianB_X + 3 )
	ui._obsidian_Text_2:SetPosY( ui._obsidian_Text:GetPosY() + textSizeY + 5 )
	
	local invenOpenCheck = Panel_Window_Inventory:GetShow()
	_updateTime = _updateTime + deltaTime
	
	-- 가방이 열려 있는지 체크. 열려 있지 않다면 20초 후에 강제적으로 연다!
	if ( invenOpenCheck ) or ( 20.0 < _updateTime ) then
		-- ♬ 클리어 사운드 추가
		if not Panel_Window_Inventory:GetShow() then
			InventoryWindow_Show()
		end
		audioPostEvent_SystemUi(04,12)

		_updateTime = 0
		_stepNo = 52
		ui._bubbleKey_I:SetShow( false )	
	end
end

local updateDeltaTime_SummonBoss_Step2 = function( deltaTime )

	ui._obsidian:SetShow(true)
	ui._obsidian_B:SetShow(true)
	ui._obsidian_B_Left:SetShow(false)
	ui._obsidian_Text:SetShow( true )
	ui._obsidian_Text_2:SetShow( true )
	
	ui._obsidian_Text:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_25") ) -- "가방 안에 반짝이는 아이템이 보여?" )
	ui._obsidian_Text_2:SetText( summonText[2] ) -- "아이템을 우클릭하면 보스 소환이 시작돼." )
	
	local textSizeX = ui._obsidian_Text:GetTextSizeX()
	local textSizeY = ui._obsidian_Text:GetTextSizeY()

	local scrX = getScreenSizeX()
	local scrY = getScreenSizeY()
	
	ui._obsidian_B:SetSize( ui._obsidian_Text_2:GetTextSizeX() + 20, ui._obsidian_Text_2:GetTextSizeY() + textSizeY + 40 )
	ui._obsidian_Text:SetSize( textSizeX, textSizeY )

	ui._obsidian:SetPosX( scrX/2 - ui._obsidian_B:GetSizeX()/2 - ui._obsidian:GetSizeX()/2 )
	ui._obsidian:SetPosY( 100 )

	local obsidianX = ui._obsidian:GetPosX()
	local obsidianY = ui._obsidian:GetPosY()
	
	ui._obsidian_B:SetPosX( obsidianX + 80 )
	ui._obsidian_B:SetPosY( obsidianY + 30 )
	
	local obsidianB_X = ui._obsidian_B:GetPosX()
	local obsidianB_Y = ui._obsidian_B:GetPosY()
	
	ui._obsidian_Text:SetPosX( obsidianB_X + 3 )
	ui._obsidian_Text:SetPosY( obsidianB_Y + 25 )

	ui._obsidian_Text_2:SetPosX( obsidianB_X + 3 )
	ui._obsidian_Text_2:SetPosY( ui._obsidian_Text:GetPosY() + textSizeY + 5 )
	
	if FGlobal_FirstSummonItemUse() then
		-- ♬ 클리어 사운드 추가

		_updateTime = 0
		_stepNo = 53
	end
	
	-- 아이템 사용 전 인벤을 닫아버리면 튜토리얼도 종료한다.
	if not Panel_Window_Inventory:GetShow() then
		_updateTime = 0
		_stepNo = 0
		FGlobal_Tutorial_Close()
	end
end

local updateDeltaTime_SummonBoss_Step3 = function( deltaTime )

	_updateTime = _updateTime + deltaTime
	ui._obsidian:SetShow(true)
	ui._obsidian_B:SetShow(true)
	ui._obsidian_B_Left:SetShow(false)
	ui._obsidian_Text:SetShow( true )
	ui._obsidian_Text_2:SetShow( true )
	
	ui._obsidian_Text:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_27") ) -- "잘 했어, 파트너!" )
	ui._obsidian_Text_2:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_28") ) -- "배운 기술만 잘 활용하면 어렵지 않을거야." )
	
	local textSizeX = ui._obsidian_Text:GetTextSizeX()
	local textSizeY = ui._obsidian_Text:GetTextSizeY()

	local scrX = getScreenSizeX()
	local scrY = getScreenSizeY()
	
	ui._obsidian_B:SetSize( ui._obsidian_Text_2:GetTextSizeX() + 20, ui._obsidian_Text_2:GetTextSizeY() + textSizeY + 40 )
	ui._obsidian_Text:SetSize( textSizeX, textSizeY )

	ui._obsidian:SetPosX( scrX/2 - ui._obsidian_B:GetSizeX()/2 - ui._obsidian:GetSizeX()/2 )
	ui._obsidian:SetPosY( 100 )

	local obsidianX = ui._obsidian:GetPosX()
	local obsidianY = ui._obsidian:GetPosY()
	
	ui._obsidian_B:SetPosX( obsidianX + 80 )
	ui._obsidian_B:SetPosY( obsidianY + 30 )
	
	local obsidianB_X = ui._obsidian_B:GetPosX()
	local obsidianB_Y = ui._obsidian_B:GetPosY()
	
	ui._obsidian_Text:SetPosX( obsidianB_X + 3 )
	ui._obsidian_Text:SetPosY( obsidianB_Y + 25 )

	ui._obsidian_Text_2:SetPosX( obsidianB_X + 3 )
	ui._obsidian_Text_2:SetPosY( ui._obsidian_Text:GetPosY() + textSizeY + 5 )
	
	if 8.0 < _updateTime then
		_updateTime = 0
		_stepNo = 0
		FGlobal_Tutorial_Close()
	end
end

function FGlobal_Tutorial_Close()
	if (_stepNo < 21 or 27 < _stepNo) and ( 41 ~= _stepNo ) and ( 0 ~= _stepNo ) then
		return
	end
	bubbleKey_Hide()
	for _, v in pairs ( ui ) do
		v:SetShow( false )
	end

	Panel_Tutorial:SetShow( false, false )
	FGlobal_Tutorial_QuestMasking_Hide()
	_stepNo = 0
end

local updateDeltaTime_CallSpirit_Step2 = function( deltaTime )
	_stepNo = 0
	bubbleKey_Hide()
	for _, v in pairs ( ui ) do
		v:SetShow( false )
	end
	Panel_Tutorial:SetShow( false, false )
	
end

function FGlobal_InteractionTutorialShow()
	Panel_Tutorial_NaviCtrl_End()
	Panel_Tutorial:SetShow( true, false )
	
	-- 기본적으로 애들을 꺼준다
	for _, v in pairs ( ui ) do
		v:SetShow( false )
	end
	
	ui._obsidian:SetShow(true)
	ui._obsidian_B:SetShow(false)
	ui._obsidian_B_Left:SetShow(true)
	ui._obsidian_Text:SetShow(true)
	ui._obsidian_Text_2:SetShow(true)
	ui._obsidian:EraseAllEffect()
	ui._obsidian:AddEffect ( "fUI_DarkSpirit_Tutorial", true, 0, 0 )

	_stepNo = 31
end


local updateDeltaTime_Interaction_Step1 = function(deltaTime)
	if Panel_Masking_Tutorial:GetShow() then
		FGlobal_Tutorial_QuestMasking_Hide()
	end
	isInteractionForTutorial = false

	bubbleKey_Hide()

	ui._obsidian_Text:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_21") ) -- "상호작용 창이 떴을 때 R키를 누르면\n사람들과 대화할 수 있어.")
	ui._obsidian_Text_2:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_22") ) -- "<R>키로 말을 걸어봐. 도와줄지도 모르잖아?")

	local scrX = getScreenSizeX()
	local scrY = getScreenSizeY()
	
	ui._obsidian:SetPosX( scrX * 0.5 - 150 )
	ui._obsidian:SetPosY( scrY * 0.5 )
	
	local obsidianX = ui._obsidian:GetPosX()
	local obsidianY = ui._obsidian:GetPosY()
		
	local textSizeX = ui._obsidian_Text:GetTextSizeX()
	local textSizeY = ui._obsidian_Text:GetTextSizeY()

	ui._obsidian_Text:SetSize( textSizeX, textSizeY )

	ui._obsidian_B_Left:SetPosX( obsidianX - ui._obsidian_B_Left:GetSizeX() + 70)
	ui._obsidian_B_Left:SetPosY( obsidianY - 150 )
	
	local obsidianB_X = ui._obsidian_B_Left:GetPosX()
	local obsidianB_Y = ui._obsidian_B_Left:GetPosY()
	
	ui._obsidian_Text:SetPosX( obsidianB_X + 3 )
	ui._obsidian_Text:SetPosY( obsidianB_Y + 5 )

	ui._obsidian_Text_2:SetPosX( obsidianB_X + 3 )
	ui._obsidian_Text_2:SetPosY( ui._obsidian_Text:GetPosY() + textSizeY + 5 )
	
	ui._bubbleKey_R:SetPosX( ui._obsidian_Text_2:GetPosX() + ui._obsidian_Text_2:GetTextSizeX() + 20 )
	ui._bubbleKey_R:SetPosY( ui._obsidian_Text:GetPosY() + textSizeY + 5 )
	
	ui._obsidian_B_Left:SetSize( ui._bubbleKey_R:GetPosX() - ui._obsidian_Text_2:GetPosX() + ui._bubbleKey_R:GetSizeX() + 20, textSizeY + ui._obsidian_Text_2:GetTextSizeY() + 45 )
	
	isPress = keyCustom_IsPressed_Action( 8 )
	if (isPress) then
		_stepNo = 32
	end
end

local updateDeltaTime_Interaction_Step2 = function(deltaTime)
	Panel_Tutorial:SetShow( false, false )
	ui._obsidian:SetShow(false)
	ui._obsidian_B:SetShow(false)
	ui._obsidian_B_Left:SetShow(false)
	ui._obsidian_Text:SetShow(false)
	ui._obsidian_Text_2:SetShow(false)
	ui._bubbleKey_R:SetShow(false)
	
	-- naviCountCheck = false
	_stepNo = 0
end

---------------------------------------------------------------------------------------------------
-- 스킬 콤보 튜토리얼
---------------------------------------------------------------------------------------------------

-- 사용한 스킬키를 담아둘 배열.. 일단 4개까지만 만들어둠! 체크할 개수가 늘어나면 얘기바람!! - 이문종
local baseComboCount = 4
local usedSkillKey = {}
local usedSkillMatch = {}
for index = 0, baseComboCount - 1 do
	usedSkillKey[index] = nil
	usedSkillMatch[index] = false
end

-- 스킬키는 하위 또는 상위 스킬도 모두 포함되게 배열로 구성(전질검술 체크하려면 모든 전절검술을 넣자)
local SkillComboCheck =
{
	-- 워리어
	[UI_classType.ClassType_Warrior] =
	{
		[0] = {
			[0] = { 349, 350, 351, 705 },	-- 전진검술I, II, III, IV
			{ 349, 350, 351, 705 },			-- 전진검술I, II, III, IV
			{ 1712 },						-- 각성 : 고옌의 대검
			},
		
		[1] = {
			[0] = { 385 },					-- 황혼의 상처
			{ 1712 },						-- 각성 : 고옌의 대검
			{ 1765, 1766, 1767, 1768 },		-- 무자비I, 무자비II, 무자비III, 무자비IV
			},
	},
	
	-- [UI_classType.ClassType_Ranger] = {},
	[UI_classType.ClassType_Sorcerer] =
	{
		[0] = {
			[0] = { 1056, 1202, 1203, 583 },	-- 어둠의 연격I, II, III, IV
			{ 1769 },							-- 카르티안의 사신낫
			},
		
		[1] = {
			[0] = { 1056, 1202, 1203, 583 },	-- 어둠의 연격I, II, III, IV
			{ 1769 },							-- 카르티안의 사신낫
			{ 1785, 1786, 1787, 1788 },			-- 망자사냥I, II, III, IV
			},
	},
	[UI_classType.ClassType_Giant] =
	{
		[0] = {
			[0] = { 1041, 1163, 1164, 1165, 1166, 296 },	-- 맹렬한 공격I, II, III, IV, V, 극 맹렬한 공격
			{ 1812 },										-- 탄투의 철장갑포
			},
		
		[1] = {
			[0] = { 1042, 1167, 1168, 1169, 1170, 1171 },	-- 광분의 파괴자I, II, III, IV, V, VI
			{ 1812 },										-- 탄투의 철장갑포
			{ 1830, 1831, 1832, 1833 },						-- 뿌리박기I, II, III, IV
			},
	},
	-- [UI_classType.ClassType_Tamer] = {},
	-- [UI_classType.ClassType_BladeMaster] = {},
	-- [UI_classType.ClassType_BladeMasterWomen] = {},
	-- [UI_classType.ClassType_Valkyrie] = {},
	-- [UI_classType.ClassType_Wizard] = {},
	-- [UI_classType.ClassType_WizardWomen] = {},
	-- [UI_classType.ClassType_NinjaMan] = {},
	-- [UI_classType.ClassType_NinjaWomen] = {},
}

-- 스킬콤보와 퀘스트를 매칭 시켜야 한다!
local questCheck =
{
	-- 워리어
	[UI_classType.ClassType_Warrior] =
	{
		[0] = {
			questGroup = 285,
			questId = 6,
			clearMinigameIndex = 100,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Warrior_0_PurposeText"), -- "각성 무기 - 워리어 : 연계 기술 활용I",
			combo = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Warrior_0_Combo_1"), -- "전진 검술",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Warrior_0_Combo_1"), -- "전진 검술",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Warrior_0_Combo_2"), -- "각성 : 고옌의 대검"
			},
			comboKey = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Warrior_0_ComboKey_1"), -- "( ↑ + 좌클릭 )",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Warrior_0_ComboKey_1"), -- "( ↑ + 좌클릭 )",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Warrior_0_ComboKey_2"), -- "( C )"
			},
			
		},
		[1] = {
			questGroup = 285,
			questId = 7,
			clearMinigameIndex = 101,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Warrior_1_PurposeText"), -- "각성 무기 - 워리어 : 연계 기술 활용II",
			combo = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Warrior_1_Combo_1"), -- "황혼의 상처",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Warrior_0_Combo_2"), -- "각성 : 고옌의 대검",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Warrior_1_Combo_2"), -- "무자비"
			},
			comboKey = { 
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Warrior_1_ComboKey_1"), -- "( 기술슬롯에 등록해 사용 )",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Warrior_0_ComboKey_2"), -- "( C )",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Warrior_1_ComboKey_2"), -- "( ↓ + 우클릭 )"
			},
		},
	},
	
	-- [UI_classType.ClassType_Ranger] = {},
	[UI_classType.ClassType_Sorcerer] =
	{
		[0] = {
			questGroup = 287,
			questId = 6,
			clearMinigameIndex = 100,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Socceror_0_PurposeText"), -- "각성 무기 - 소서러 : 연계 기술 활용I",
			combo = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Socceror_0_Combo_1"), -- "어둠의 연격",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Socceror_0_Combo_2"), -- "각성 : 카르티안의 사신낫",
			},
			comboKey = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Socceror_0_ComboKey_1"), -- "( ↓ + 좌클릭 )",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Socceror_0_ComboKey_2"), -- "( C )",
			},
			
		},
		[1] = {
			questGroup = 287,
			questId = 7,
			clearMinigameIndex = 101,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Socceror_1_PurposeText"), -- "각성 무기 - 소서러 : 연계 기술 활용II",
			combo = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Socceror_0_Combo_1"), -- "어둠의 연격",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Socceror_0_Combo_2"), -- "각성 : 카르티안의 사신낫",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Socceror_0_Combo_3"), -- "망자 사냥",
			},
			comboKey = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Socceror_0_ComboKey_1"), -- "( ↓ + 좌클릭 )",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Socceror_0_ComboKey_2"), -- "( C )",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Socceror_0_ComboKey_1"), -- "( ↓ + 좌클릭 )",
			},
		},
	},
	[UI_classType.ClassType_Giant] =
	{
		[0] = {
			questGroup = 290,
			questId = 6,
			clearMinigameIndex = 100,
			purposeText = "각성 무기 - 자이언트 : 연계 기술 활용I",		-- PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Socceror_0_PurposeText"), -- "각성 무기 - 소서러 : 연계 기술 활용I",
			combo = {
				"맹렬한 공격",		-- PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Socceror_0_Combo_1"), -- "어둠의 연격",
				"탄투의 철장갑포",	-- PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Socceror_0_Combo_2"), -- "각성 : 카르티안의 사신낫",
			},
			comboKey = {
				"( 우클릭 )",	-- PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Socceror_0_ComboKey_1"), -- "( ↓ + 좌클릭 )",
				"( C )",		-- PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Socceror_0_ComboKey_2"), -- "( C )",
			},
			
		},
		[1] = {
			questGroup = 290,
			questId = 7,
			clearMinigameIndex = 101,
			purposeText = "각성 무기 - 자이언트 : 연계 기술 활용II",		-- PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Socceror_1_PurposeText"), -- "각성 무기 - 소서러 : 연계 기술 활용II",
			combo = {
				"광분의 파괴자",		-- PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Socceror_0_Combo_1"), -- "어둠의 연격",
				"탄투의 철장갑포",		-- PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Socceror_0_Combo_2"), -- "각성 : 카르티안의 사신낫",
				"황폐화",			-- PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Socceror_0_Combo_3"), -- "망자 사냥",
			},
			comboKey = {
				"( ↓ + 좌클릭 )",		-- PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Socceror_0_ComboKey_1"), -- "( ↓ + 좌클릭 )",
				"( C )",				-- PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Socceror_0_ComboKey_2"), -- "( C )",
				"( ↓ + 우클릭 )",		-- PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_COMBO_Socceror_0_ComboKey_1"), -- "( ↓ + 좌클릭 )",
			},
		},
	},
	-- [UI_classType.ClassType_Tamer] = {},
	-- [UI_classType.ClassType_BladeMaster] = {},
	-- [UI_classType.ClassType_BladeMasterWomen] = {},
	-- [UI_classType.ClassType_Valkyrie] = {},
	-- [UI_classType.ClassType_Wizard] = {},
	-- [UI_classType.ClassType_WizardWomen] = {},
	-- [UI_classType.ClassType_NinjaMan] = {},
	-- [UI_classType.ClassType_NinjaWomen] = {},
}


function pushSkillKey( startIndex, endIndex )
	if startIndex == endIndex then
		return
	end
	if nil ~= usedSkillKey[startIndex] then
		pushSkillKey( startIndex+1, endIndex )
	else
		return
	end
	usedSkillKey[startIndex+1] = usedSkillKey[startIndex]
end

local progressQuestIndex = 0
local _ramainTime = 0
function compareSkillCombo(classType)
	progressQuestIndex = -1
	for index = 0, #questCheck[classType] do
		if questList_hasProgressQuest(questCheck[classType][index].questGroup, questCheck[classType][index].questId) then
			progressQuestIndex = index
			if not Panel_Tutorial:GetShow() then
				FGlobal_CharacterSkill_Tutorial()
			end
		end
	end
	
	if -1 == progressQuestIndex then
		return
	end
	
	local comboSkillKey = SkillComboCheck[classType][progressQuestIndex]
	local matchCount = 0
	for index = #comboSkillKey, 0, -1 do
		for key, value in pairs (comboSkillKey[index]) do
			if value == usedSkillKey[matchCount] then
				matchCount = matchCount + 1
				_ramainTime = 0
			end
		end
	end
	
	if (#comboSkillKey + 1) == matchCount then
		return true
	end
	return false
end

local comboQuestClear = false
function Tutorial_CheckUsedSkill( skillWrapper )
	-- if not Panel_Tutorial:GetShow() then
		-- return
	-- end
	if getSelfPlayer():get():getLevel() < 56 then
		return
	end
	
	if nil == SkillComboCheck[classType] then
		return
	end
	
	-- 퀘스트가 진행중이라면, 첫 번째 조건이 완료됐는지 체크! 완료 조건이 여러 개일 경우, 콤보 부분은 퀘스트 첫 번째 조건으로 세팅해야 함!
	for index = 0, #questCheck[classType] do
		if questList_hasProgressQuest(questCheck[classType][index].questGroup, questCheck[classType][index].questId) then
			local uiQuestInfo = ToClient_GetQuestInfo( questCheck[classType][index].questGroup, questCheck[classType][index].questId )
			local questCondition = uiQuestInfo:getDemandAt( 0 )
			if (questCondition._destCount <= questCondition._currentCount) then
				return
			else
				-- ui가 리로드 되는 상황일 때, 퀘스트가 진행중인 상태라면 튜토리얼을 다시 켜준다.
				if not Panel_Tutorial:GetShow() then
					FGlobal_CharacterSkill_Tutorial()
				end
			end
		end
	end
	
	if comboQuestClear then
		return
	end
	
	pushSkillKey( 0, baseComboCount )
	local skillWrapper = selfPlayerUsedSkillFront()
	if nil ~= skillWrapper then
		local skillNo = skillWrapper:getSkillNo()
		local skillName = skillWrapper:getName()
		usedSkillKey[0] = skillNo
		selfPlayerUsedSkillPopFront()
	end
	
	comboQuestClear = false
	if compareSkillCombo(classType) then
		request_clearMiniGame( questCheck[classType][progressQuestIndex].clearMinigameIndex )
		ui._purposeText:AddEffect( "fUI_Gauge_BigWhite", false, 0.0, 0.0 )
		comboQuestClear = true
	end
end

function ComboTutorial_NextStep_FontColorChange( index1, index2, index3, index4 )
	if index1 then
		ui._nextStep_1:SetFontColor( UI_color.C_FFB5FF6D )
		-- ui._nextStep_1:AddEffect( "fUI_Light", false, 0.0, 0.0 )
		ui._clearStep_1:SetShow( true )
		ui._clearStep_1:AddEffect( "UI_Check01", false, -2.0, 0.0 )
		ui._clearStep_1:AddEffect( "fL_CheckSpark01", false, -2.0, 0.0 )
	else
		ui._nextStep_1:SetFontColor( UI_color.C_FFC4BEBE )
		ui._clearStep_1:EraseAllEffect()
		ui._clearStep_1:SetShow( false )
	end
	if index2 then
		ui._nextStep_2:SetFontColor( UI_color.C_FFB5FF6D )
		-- ui._nextStep_2:AddEffect( "fUI_Light", false, 0.0, 0.0 )
		ui._clearStep_2:SetShow( true )
		ui._clearStep_2:AddEffect( "UI_Check01", false, -2.0, 0.0 )
		ui._clearStep_2:AddEffect( "fL_CheckSpark01", false, -2.0, 0.0 )
	else
		ui._nextStep_2:SetFontColor( UI_color.C_FFC4BEBE )
		ui._clearStep_2:EraseAllEffect()
		ui._clearStep_2:SetShow( false )
	end
	if index3 then
		ui._nextStep_3:SetFontColor( UI_color.C_FFB5FF6D )
		-- ui._nextStep_3:AddEffect( "fUI_Light", false, 0.0, 0.0 )
		ui._clearStep_3:SetShow( true )
		ui._clearStep_3:AddEffect( "UI_Check01", false, -2.0, 0.0 )
		ui._clearStep_3:AddEffect( "fL_CheckSpark01", false, -2.0, 0.0 )
	else
		ui._nextStep_3:SetFontColor( UI_color.C_FFC4BEBE )
		ui._clearStep_3:EraseAllEffect()
		ui._clearStep_3:SetShow( false )
	end
	if index4 then
		ui._nextStep_4:SetFontColor( UI_color.C_FFB5FF6D )
		-- ui._nextStep_4:AddEffect( "fUI_Light", false, 0.0, 0.0 )
		ui._clearStep_4:SetShow( true )
		ui._clearStep_4:AddEffect( "UI_Check01", false, -2.0, 0.0 )
		ui._clearStep_4:AddEffect( "fL_CheckSpark01", false, -2.0, 0.0 )
	else
		ui._nextStep_4:SetFontColor( UI_color.C_FFC4BEBE )
		ui._clearStep_4:EraseAllEffect()
		ui._clearStep_4:SetShow( false )
	end
end

local comboSuccess = function( comboSkillIndex, usedSkillIndex )
	local comboSkillKey = SkillComboCheck[classType][progressQuestIndex]
	if nil == comboSkillKey[comboSkillIndex] then
		return
	end
	for  key, value in pairs (comboSkillKey[comboSkillIndex]) do
		if value == usedSkillKey[usedSkillIndex] then
			return true
		end
	end
	return false
end

-- compareSkillCombo(classType) 과는 검증 과정이 다르므로 현재 사용한 스킬로 체크!
local comboCheck = function()
	if progressQuestIndex < 0 then
		return
	end
	
	if usedSkillMatch[3] then
		ComboTutorial_NextStep_FontColorChange( true, true, true, true )
	elseif usedSkillMatch[2] then
		ComboTutorial_NextStep_FontColorChange( true, true, true, false )
		if comboSuccess(3, 0) then
			if comboSuccess(2, 1) then
				usedSkillMatch[3] = true
			end
		end
	elseif usedSkillMatch[1] then
		ComboTutorial_NextStep_FontColorChange( true, true, false, false )
		if comboSuccess(2, 0) then
			if comboSuccess(1, 1) then
				usedSkillMatch[2] = true
			end
		end
	elseif usedSkillMatch[0] then
		ComboTutorial_NextStep_FontColorChange( true, false, false, false )
		if comboSuccess(1, 0) then
			if comboSuccess(0, 1) then
				usedSkillMatch[1] = true
			end
		end
	else
		ComboTutorial_NextStep_FontColorChange( false, false, false, false )
	end
	
	if comboSuccess(0, 0) then
		usedSkillMatch[0] = true
	end
end

local updateDeltaTime_ComboTutorial = function( deltaTime )
	_ramainTime = _ramainTime + deltaTime
	
	-- 콤보 체크
	comboCheck()
	
	-- 콤보 성공 후 5초 후 튜토리얼 패널을 꺼준다.
	if comboQuestClear and 5 < _ramainTime then
		_stepNo = 0
		FGlobal_Tutorial_Close()
	end
	
	-- 3초 이내에 다음 스킬이 들어오지 않으면 초기화! 시전시간이 긴 스킬 때문에 더 이상 줄이면 안됨!
	if not comboQuestClear and 3 < _ramainTime then
		_ramainTime = 0
		for index = 0, baseComboCount - 1 do
			usedSkillKey[index] = nil
			usedSkillMatch[index] = false
		end		
	end
end


---------------------------------------------------------------------------------------------------
-- 기본 스킬 콤보 튜토리얼
---------------------------------------------------------------------------------------------------
local ActIT = CppEnums.ActionInputType
local baseSkillComboCount = 4				-- 최대 콤보 개수
local repeatCount = 3						-- 콤보 반복 횟수
local clearCount = 0
local baseSkillMatch = {}
local baseSkillProgressIndex = -1
local baseSkillMatch_Init = function()
	for index = 0, baseSkillComboCount - 1 do
		baseSkillMatch[index] = false
	end
	_ramainTime = 0
end

local baseSkillQuestCheck =
{
	-- 워리어
	[UI_classType.ClassType_Warrior] =
	{
		[0] = {
			questGroup = 401,
			questId = 1,
			clearMinigameIndex = 110,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_PURPOSE_0"), -- "[수련] 기본 기술 연계 I",
			combo = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WARRIOR_COMBO_0_1"), -- "강타",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WARRIOR_COMBO_0_2"), -- "전진 검술"
			},
			comboKey = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WARRIOR_COMMAND_0_1"), -- "<좌클릭> + <우클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WARRIOR_COMMAND_0_2"), -- "<KeyBind:MoveFront> + <좌클릭>"
			},
			actionKey = {
				[0] = { ActIT.ActionInputType_Attack1, ActIT.ActionInputType_Attack2 },
				{ ActIT.ActionInputType_MoveFront, ActIT.ActionInputType_Attack1 },
			}
		},
		[1] = {
			questGroup = 401,
			questId = 2,
			clearMinigameIndex = 111,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_PURPOSE_1"), -- "[수련] 기본 기술 연계 II",
			combo = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WARRIOR_COMBO_0_2"), -- "전진 검술",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WARRIOR_COMBO_0_1"), -- "강타"
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WARRIOR_COMBO_1_1"), -- "깊게 찌르기",
			},
			comboKey = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WARRIOR_COMMAND_0_2"), -- "<KeyBind:MoveFront> + <좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WARRIOR_COMMAND_0_1"), -- "<좌클릭> + <우클릭>"
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_SORCERER_COMMAND_1_1"), -- "<KeyBind:Dash> + <좌클릭>",
			},
			actionKey = {
				[0] = { ActIT.ActionInputType_MoveFront, ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_Attack1, ActIT.ActionInputType_Attack2 },
				{ ActIT.ActionInputType_Dash, ActIT.ActionInputType_Attack1 },
			}
		},
	},
	
	[UI_classType.ClassType_Ranger] =
	{
		[0] = {
			questGroup = 404,
			questId = 1,
			clearMinigameIndex = 110,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_PURPOSE_0"), -- "[수련] 기본 기술 연계 I",
			combo = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMBO_0_1"), -- "활 숙련도",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMBO_0_2"), -- "회피 사격",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMBO_0_3"), -- "약점 노리기",
			},
			-- 순서에 주의!!!!! or 스킬일 경우, 공유 키는 [1]에 세팅!! <S> + <F> or <W> + <F>(소서 해방된 어둠) 는 [2] = <F>, [1] = <S>, [3] = <W> 로 
			comboKey = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMMAND_0_1"), -- "<좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMMAND_0_2"), -- "<KeyBind:MoveLeft> + <좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMMAND_0_3"), -- "<KeyBind:MoveBack> + <좌클릭>"
			},
			actionKey = {
				[0] = { ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_MoveLeft, ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_MoveBack, ActIT.ActionInputType_Attack1 },
			},
		},
		
		[1] = {
			questGroup = 404,
			questId = 2,
			clearMinigameIndex = 111,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_PURPOSE_1"), -- "[수련] 기본 기술 연계 II",
			combo = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMBO_0_1"), -- "활 숙련도",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMBO_0_3"), -- "약점 노리기",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMBO_1_3"), -- "바람 모아 쏘기",
			},
			comboKey = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMMAND_0_1"), -- "<좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMMAND_0_3"), -- "<KeyBind:MoveBack> + <좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMMAND_1_3"), -- "<KeyBind:Dash> + <우클릭>",
			},
			actionKey = {
				[0] = { ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_MoveBack, ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_Dash, ActIT.ActionInputType_Attack2 },
			},
		},
	},
	
	[UI_classType.ClassType_Sorcerer] =
	{
		[0] = {
			questGroup = 402,
			questId = 1,
			clearMinigameIndex = 110,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_PURPOSE_0"), -- "[수련] 기본 기술 연계 I",
			combo = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_SORCERER_COMBO_0_1"), -- "해방된 어둠",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_SORCERER_COMBO_0_2"), -- "어둠의 연격",
			},
			-- 순서에 주의!!!!! or 스킬일 경우, 공유 키는 [1]에 세팅!! <S> + <F> or <W> + <F>(소서 해방된 어둠) 는 [2] = <F>, [1] = <S>, [3] = <W> 로 
			comboKey = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_SORCERER_COMMAND_0_1"), -- "<KeyBind:MoveBack> + <KeyBind:Kick>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WIZARD_COMMAND_1_3"), -- "<KeyBind:MoveBack> + <좌클릭>",
			},
			actionKey = {
				[0] = { ActIT.ActionInputType_Kick, ActIT.ActionInputType_MoveBack },
				{ ActIT.ActionInputType_MoveBack, ActIT.ActionInputType_Attack1 },
			},
			
		},
		[1] = {
			questGroup = 402,
			questId = 2,
			clearMinigameIndex = 111,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_PURPOSE_1"), -- "[수련] 기본 기술 연계 II",
			combo = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_SORCERER_COMBO_1_1"), -- "긴밤 지르기",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_SORCERER_COMBO_1_2"), -- "어둠 가르기",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_SORCERER_COMBO_1_3"), -- "하단 차기",
			},
			comboKey = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_SORCERER_COMMAND_1_1"), -- "<KeyBind:Dash> + <좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMMAND_0_1"), -- "<좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_SORCERER_COMMAND_1_3"), -- "<KeyBind:Kick>",
			},
			actionKey = {
				[0] = { ActIT.ActionInputType_Dash, ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_Kick },
			},
		},
	},
	[UI_classType.ClassType_Giant] =
	{
		[0] = {
			questGroup = 403,
			questId = 1,
			clearMinigameIndex = 110,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_PURPOSE_0"), -- "[수련] 기본 기술 연계 I",
			combo = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_GIANT_COMBO_0_1"), -- "힘의 탄력",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_GIANT_COMBO_0_2"), -- "박치기",
			},
			comboKey = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WARRIOR_COMMAND_0_2"), -- "<KeyBind:MoveFront> + <좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_GIANT_COMMAND_0_2"), -- "<KeyBind:MoveFront> + <우클릭>",
			},
			actionKey = {
				[0] = { ActIT.ActionInputType_MoveFront, ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_MoveFront, ActIT.ActionInputType_Attack2 },
			},
			
		},
		[1] = {
			questGroup = 403,
			questId = 2,
			clearMinigameIndex = 111,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_PURPOSE_1"), -- "[수련] 기본 기술 연계 II",
			combo = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_GIANT_COMBO_0_1"), -- "힘의 탄력",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_GIANT_COMBO_0_2"), -- "박치기",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_GIANT_COMBO_1_3"), -- "맹수의 습격",
			},
			comboKey = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WARRIOR_COMMAND_0_2"), -- "<KeyBind:MoveFront> + <좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_GIANT_COMMAND_0_2"), -- "<KeyBind:MoveFront> + <우클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_SORCERER_COMMAND_1_3"), -- "<KeyBind:Kick>",
			},
			actionKey = {
				[0] = { ActIT.ActionInputType_MoveFront, ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_MoveFront, ActIT.ActionInputType_Attack2 },
				{ ActIT.ActionInputType_Kick },
			},
		},
	},
	[UI_classType.ClassType_Tamer] =
	{
		[0] = {
			questGroup = 405,
			questId = 1,
			clearMinigameIndex = 110,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_PURPOSE_0"), -- "[수련] 기본 기술 연계 I",
			combo = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_TAMER_COMBO_0_1"), -- "낙엽 베기",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_TAMER_COMBO_0_2"), -- "채찍 휘두르기",
			},
			-- 순서에 주의!!!!! or 스킬일 경우, 공유 키는 [1]에 세팅!! <S> + <F> or <W> + <F>(소서 해방된 어둠) 는 [2] = <F>, [1] = <S>, [3] = <W> 로 
			comboKey = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WARRIOR_COMMAND_0_2"), -- "<KeyBind:MoveFront> + <좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_TAMER_COMMAND_1_3"), -- "<우클릭>",
			},
			actionKey = {
				[0] = { ActIT.ActionInputType_MoveFront, ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_Attack2 }
			},
			
		},
		[1] = {
			questGroup = 405,
			questId = 2,
			clearMinigameIndex = 111,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_PURPOSE_1"), -- "[수련] 기본 기술 연계 II",
			combo = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_TAMER_COMBO_0_1"), -- "낙엽 베기",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_TAMER_COMBO_0_2"), -- "채찍 휘두르기",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_TAMER_COMBO_1_3"), -- "벽력장",
			},
			-- 순서에 주의!!!!! or 스킬일 경우, 공유 키는 [1]에 세팅!! <S> + <F> or <W> + <F>(소서 해방된 어둠) 는 [2] = <F>, [1] = <S>, [3] = <W> 로 
			comboKey = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WARRIOR_COMMAND_0_2"), -- "<KeyBind:MoveFront> + <좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_TAMER_COMMAND_1_3"), -- "<우클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_SORCERER_COMMAND_1_1"), -- "<KeyBind:Dash> + <좌클릭>",
			},
			actionKey = {
				[0] = { ActIT.ActionInputType_MoveFront, ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_Attack2 },
				{ ActIT.ActionInputType_Dash, ActIT.ActionInputType_Attack1 },
			},
		},
	},
	[UI_classType.ClassType_BladeMaster] = {
		[0] = {
			questGroup = 406,
			questId = 1,
			clearMinigameIndex = 110,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_PURPOSE_0"), -- "[수련] 기본 기술 연계 I",
			combo = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_BLADEMASTER_COMBO_0_1"), -- "본검",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_BLADEMASTER_COMBO_0_2"), -- "돌개 베기",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_BLADEMASTER_COMBO_0_3"), -- "장님 찌르기"
			},
			-- 순서에 주의!!!!! or 스킬일 경우, 공유 키는 [1]에 세팅!! <S> + <F> or <W> + <F>(소서 해방된 어둠) 는 [2] = <F>, [1] = <S>, [3] = <W> 로 
			comboKey = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMMAND_0_1"), -- "<좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMMAND_0_2"), -- "<KeyBind:MoveLeft> + <좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_BLADEMASTER_COMMAND_0_3"), -- "<KeyBind:Jump>"
			},
			actionKey = {
				[0] = { ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_MoveLeft, ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_Jump }
			},
			
		},
		[1] = {
			questGroup = 406,
			questId = 2,
			clearMinigameIndex = 111,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_PURPOSE_1"), -- "[수련] 기본 기술 연계 II",
			combo = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_BLADEMASTER_COMBO_0_1"), -- "본검",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_BLADEMASTER_COMBO_0_3"), -- "장님 찌르기",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_BLADEMASTER_COMBO_1_3"), -- "가름",
			},
			comboKey = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMMAND_0_1"), -- "<좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_BLADEMASTER_COMMAND_0_3"), -- "<KeyBind:Jump>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WARRIOR_COMMAND_1_1"), -- "<KeyBind:GrabOrGuard>",
			},
			actionKey = {
				[0] = { ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_Jump },
				{ ActIT.ActionInputType_GrabOrGuard }
			},
		},
	},
	[UI_classType.ClassType_BladeMasterWomen] = {
		[0] = {
			questGroup = 408,
			questId = 1,
			clearMinigameIndex = 110,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_PURPOSE_0"), -- "[수련] 기본 기술 연계 I",
			combo = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_BLADEMASTER_COMBO_0_1"), -- "본검",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_BLADEMASTER_COMBO_0_2"), -- "돌개 베기",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_BLADEMASTER_COMBO_0_3"), -- "장님 찌르기"
			},
			-- 순서에 주의!!!!! or 스킬일 경우, 공유 키는 [1]에 세팅!! <S> + <F> or <W> + <F>(소서 해방된 어둠) 는 [2] = <F>, [1] = <S>, [3] = <W> 로 
			comboKey = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMMAND_0_1"), -- "<좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMMAND_0_2"), -- "<KeyBind:MoveLeft> + <좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_BLADEMASTER_COMMAND_0_3"), -- "<KeyBind:Jump>"
			},
			actionKey = {
				[0] = { ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_MoveLeft, ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_Jump }
			},
			
		},
		[1] = {
			questGroup = 408,
			questId = 2,
			clearMinigameIndex = 111,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_PURPOSE_1"), -- "[수련] 기본 기술 연계 II",
			combo = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_BLADEMASTER_COMBO_0_1"), -- "본검",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_BLADEMASTER_COMBO_0_3"), -- "장님 찌르기",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_BLADEMASTER_COMBO_1_3"), -- "가름",
			},
			comboKey = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMMAND_0_1"), -- "<좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_BLADEMASTER_COMMAND_0_3"), -- "<KeyBind:Jump>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WARRIOR_COMMAND_1_1"), -- "<KeyBind:GrabOrGuard>",
			},
			actionKey = {
				[0] = { ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_Jump },
				{ ActIT.ActionInputType_GrabOrGuard }
			},
		},
	},
	[UI_classType.ClassType_Valkyrie] = {
		[0] = {
			questGroup = 407,
			questId = 1,
			clearMinigameIndex = 110,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_PURPOSE_0"), -- "[수련] 기본 기술 연계 I",
			combo = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_VALKYRIE_COMBO_0_1"), -- "빛 가르기",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_VALKYRIE_COMBO_0_2"), -- "전진 검술",
			},
			comboKey = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WARRIOR_COMMAND_0_1"), -- "<좌클릭> + <우클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WARRIOR_COMMAND_0_2"), -- "<KeyBind:MoveFront> + <좌클릭>",
			},
			actionKey = {
				[0] = { ActIT.ActionInputType_Attack1, ActIT.ActionInputType_Attack2 },
				{ ActIT.ActionInputType_MoveFront, ActIT.ActionInputType_Attack1 },
			},
			
		},
		[1] = {
			questGroup = 407,
			questId = 2,
			clearMinigameIndex = 111,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_PURPOSE_1"), -- "[수련] 기본 기술 연계 II",
			combo = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_VALKYRIE_COMBO_1_1"), -- "좌우 베기",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_VALKYRIE_COMBO_1_2"), -- "반격 태세",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_VALKYRIE_COMBO_1_3"), -- "단죄의 검",
			},
			comboKey = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMMAND_0_2"), -- "<KeyBind:MoveLeft> + <좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_VALKYRIE_COMMAND_1_2"), -- "<KeyBind:CrouchOrSkill>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_VALKYRIE_COMMAND_1_3"), -- "<KeyBind:MoveBack> + <우클릭>",
			},
			actionKey = {
				[0] = { ActIT.ActionInputType_MoveLeft, ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_CrouchOrSkill },
				{ ActIT.ActionInputType_MoveBack, ActIT.ActionInputType_Attack2 }
			},
		},
	},
	[UI_classType.ClassType_Wizard] = {
		[0] = {
			questGroup = 409,
			questId = 1,
			clearMinigameIndex = 110,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_PURPOSE_0"), -- "[수련] 기본 기술 연계 I",
			combo = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WIZARD_COMBO_0_1"), -- "지팡이 공격",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WIZARD_COMBO_0_2"), -- "단검 찌르기",
			},
			comboKey = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMMAND_0_1"), -- "<좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_SORCERER_COMMAND_1_3"), -- "<KeyBind:Kick>",
			},
			actionKey = {
				[0] = { ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_Kick },
			},
			
		},
		[1] = {
			questGroup = 409,
			questId = 2,
			clearMinigameIndex = 111,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_PURPOSE_1"), -- "[수련] 기본 기술 연계 II",
			combo = {
				-- PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WIZARD_COMBO_1_1"), -- "단검 찌르기",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WIZARD_COMBO_1_2"), -- "마력 흡수",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WIZARD_COMBO_1_3"), -- "화염구",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WIZARD_COMBO_1_4"), -- "화염구 발사",
			},
			-- 순서에 주의!!!!! or 스킬일 경우, 공유 키는 [1]에 세팅!! <S> + <F> or <W> + <F>(소서 해방된 어둠) 는 [2] = <F>, [1] = <S>, [3] = <W> 로 
			comboKey = {
				-- PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_SORCERER_COMMAND_1_3"), -- "<KeyBind:Kick>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WIZARD_COMMAND_1_2"), -- "<KeyBind:Dash> + <좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WIZARD_COMMAND_1_3"), -- "<KeyBind:MoveBack> + <좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMMAND_0_1"), -- "<좌클릭>"
			},
			actionKey = {
				-- [0] = { ActIT.ActionInputType_Kick },
				[0] = { ActIT.ActionInputType_Dash, ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_MoveBack, ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_Attack1 },
			},
		},
	},
	[UI_classType.ClassType_WizardWomen] = {
		[0] = {
			questGroup = 410,
			questId = 1,
			clearMinigameIndex = 110,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_PURPOSE_0"), -- "[수련] 기본 기술 연계 I",
			combo = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WIZARD_COMBO_0_1"), -- "지팡이 공격",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WIZARD_COMBO_0_2"), -- "단검 찌르기",
			},
			comboKey = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMMAND_0_1"), -- "<좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_SORCERER_COMMAND_1_3"), -- "<KeyBind:Kick>",
			},
			actionKey = {
				[0] = { ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_Kick },
			},
			
		},
		[1] = {
			questGroup = 410,
			questId = 2,
			clearMinigameIndex = 111,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_PURPOSE_1"), -- "[수련] 기본 기술 연계 II",
			combo = {
				-- PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WIZARD_COMBO_1_1"), -- "단검 찌르기",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WIZARD_COMBO_1_2"), -- "마력 흡수",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WIZARD_COMBO_1_3"), -- "화염구",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WIZARD_COMBO_1_4"), -- "화염구 발사",
			},
			-- 순서에 주의!!!!! or 스킬일 경우, 공유 키는 [1]에 세팅!! <S> + <F> or <W> + <F>(소서 해방된 어둠) 는 [2] = <F>, [1] = <S>, [3] = <W> 로 
			comboKey = {
				-- PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_SORCERER_COMMAND_1_3"), -- "<KeyBind:Kick>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WIZARD_COMMAND_1_2"), -- "<KeyBind:Dash> + <좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_WIZARD_COMMAND_1_3"), -- "<KeyBind:MoveBack> + <좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMMAND_0_1"), -- "<좌클릭>"
			},
			actionKey = {
				-- [0] = { ActIT.ActionInputType_Kick },
				[0] = { ActIT.ActionInputType_Dash, ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_MoveBack, ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_Attack1 },
			},
		},
	},
	[UI_classType.ClassType_NinjaMan] = {
		[0] = {
			questGroup = 412,
			questId = 1,
			clearMinigameIndex = 110,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_PURPOSE_0"), -- "[수련] 기본 기술 연계 I",
			combo = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_NINJAMAN_COMBO_0_1"), -- "바람 베기",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_NINJAMAN_COMBO_0_2"), -- "후려 차기",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_NINJAMAN_COMBO_0_3"), -- "하단 베기"
			},
			comboKey = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMMAND_0_1"), -- "<좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_SORCERER_COMMAND_1_3"), -- "<KeyBind:Kick>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_SORCERER_COMMAND_1_1"), -- "<KeyBind:Dash> + <좌클릭>"
			},
			actionKey = {
				[0] = { ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_Kick },
				{ ActIT.ActionInputType_Dash, ActIT.ActionInputType_Attack1 }
			},
			
		},
		[1] = {
			questGroup = 412,
			questId = 2,
			clearMinigameIndex = 111,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_PURPOSE_1"), -- "[수련] 기본 기술 연계 II",
			combo = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_NINJAMAN_COMBO_0_1"), -- "바람 베기",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_NINJAMAN_COMBO_1_2"), -- "그림자 베기",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_NINJAMAN_COMBO_1_3"), -- "발목 차기",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_NINJAMAN_COMBO_0_3"), -- "하단 베기"
			},
			-- 순서에 주의!!!!! or 스킬일 경우, 공유 키는 [1]에 세팅!! <S> + <F> or <W> + <F>(소서 해방된 어둠) 는 [2] = <F>, [1] = <S>, [3] = <W> 로 
			comboKey = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMMAND_0_1"), -- "<좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMMAND_0_2"), -- "<KeyBind:MoveLeft> + <좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_NINJAMAN_COMMAND_1_3"), -- "<KeyBind:MoveBack> + <KeyBind:Kick>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_SORCERER_COMMAND_1_1"), -- "<KeyBind:Dash> + <좌클릭>"
			},
			actionKey = {
				[0] = { ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_MoveLeft, ActIT.ActionInputType_Attack1, ActIT.ActionInputType_MoveRight },
				{ ActIT.ActionInputType_MoveBack, ActIT.ActionInputType_Kick },
				{ ActIT.ActionInputType_Dash, ActIT.ActionInputType_Attack1 }
			},
		},
	},
	[UI_classType.ClassType_NinjaWomen] = {
		[0] = {
			questGroup = 411,
			questId = 1,
			clearMinigameIndex = 110,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_PURPOSE_0"), -- "[수련] 기본 기술 연계 I",
			combo = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_NINJAMAN_COMBO_0_1"), -- "바람 베기",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_NINJAMAN_COMBO_0_2"), -- "후려 차기",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_NINJAMAN_COMBO_0_3"), -- "하단 베기"
			},
			comboKey = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMMAND_0_1"), -- "<좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_SORCERER_COMMAND_1_3"), -- "<KeyBind:Kick>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_SORCERER_COMMAND_1_1"), -- "<KeyBind:Dash> + <좌클릭>"
			},
			actionKey = {
				[0] = { ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_Kick },
				{ ActIT.ActionInputType_Dash, ActIT.ActionInputType_Attack1 }
			},
			
		},
		[1] = {
			questGroup = 411,
			questId = 2,
			clearMinigameIndex = 111,
			purposeText = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_PURPOSE_1"), -- "[수련] 기본 기술 연계 II",
			combo = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_NINJAMAN_COMBO_0_1"), -- "바람 베기",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_NINJAMAN_COMBO_1_2"), -- "그림자 베기",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_NINJAMAN_COMBO_1_3"), -- "발목 차기",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_NINJAMAN_COMBO_0_3"), -- "하단 베기"
			},
			-- 순서에 주의!!!!! or 스킬일 경우, 공유 키는 [1]에 세팅!! <S> + <F> or <W> + <F>(소서 해방된 어둠) 는 [2] = <F>, [1] = <S>, [3] = <W> 로 
			comboKey = {
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMMAND_0_1"), -- "<좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_RANGER_COMMAND_0_2"), -- "<KeyBind:MoveLeft> + <좌클릭>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_NINJAMAN_COMMAND_1_3"), -- "<KeyBind:MoveBack> + <KeyBind:Kick>",
				PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_BASECOMBO_SORCERER_COMMAND_1_1"), -- "<KeyBind:Dash> + <좌클릭>"
			},
			actionKey = {
				[0] = { ActIT.ActionInputType_Attack1 },
				{ ActIT.ActionInputType_MoveLeft, ActIT.ActionInputType_Attack1, ActIT.ActionInputType_MoveRight },
				{ ActIT.ActionInputType_MoveBack, ActIT.ActionInputType_Kick },
				{ ActIT.ActionInputType_Dash, ActIT.ActionInputType_Attack1 }
			},
		},
	},
	[22]={}, -- 임시 매화
}

local questClearCheck = function()
	baseSkillProgressIndex = -1
	for index = 0, #baseSkillQuestCheck[classType] do
		if questList_hasProgressQuest(baseSkillQuestCheck[classType][index].questGroup, baseSkillQuestCheck[classType][index].questId) then
			baseSkillProgressIndex = index
			if not Panel_Tutorial:GetShow() then
				FGlobal_CharacterSkill_Tutorial()
			end
		end
	end
	
	if -1 == baseSkillProgressIndex then
		return
	end
	
	local matchCount = #baseSkillQuestCheck[classType][baseSkillProgressIndex].combo - 1
	if baseSkillMatch[matchCount] then
		return true
	else
		return false
	end
end

local baseComboQuestClear = false
local baseComboVar = false
function Tutorial_CheckBaseCombo()
	-- 퀘스트가 진행중이라면, 첫 번째 조건이 완료됐는지 체크! 완료 조건이 여러 개일 경우, 콤보 부분은 퀘스트 첫 번째 조건으로 세팅해야 함!
	for index = 0, #baseSkillQuestCheck[classType] do
		if questList_hasProgressQuest(baseSkillQuestCheck[classType][index].questGroup, baseSkillQuestCheck[classType][index].questId) then
			baseSkillProgressIndex = index
			local uiQuestInfo = ToClient_GetQuestInfo( baseSkillQuestCheck[classType][index].questGroup, baseSkillQuestCheck[classType][index].questId )
			local questCondition = uiQuestInfo:getDemandAt( 0 )
			if (questCondition._destCount <= questCondition._currentCount) then
				return
			else
				-- ui가 리로드 되는 상황일 때, 퀘스트가 진행중인 상태라면 튜토리얼을 다시 켜준다.
				if not Panel_Tutorial:GetShow() then
					FGlobal_BaseSkill_Tutorial()
				end
			end
		end
	end
	
	if baseComboQuestClear then
		return
	end
	
	baseComboQuestClear = false
	if questClearCheck() then
		clearCount = clearCount + 1
		_ramainTime = 0
		baseComboVar = true
		ui._purposeText:SetText( baseSkillQuestCheck[classType][baseSkillProgressIndex].purposeText .. " ( " .. clearCount .. " / " .. repeatCount .. " )")
		if repeatCount <= clearCount then
			request_clearMiniGame( baseSkillQuestCheck[classType][baseSkillProgressIndex].clearMinigameIndex )
			ui._purposeText:AddEffect( "fUI_Gauge_BigWhite", false, 0.0, 0.0 )
			baseComboQuestClear = true
		end
	end
end

local baseComboSuccess = function( comboSkillIndex )
	-- local isPress = IsSelfPlayerBattleMode()		-- 주무기가 꺼내져 있는지 체크!!1 아직 바인드 안됨!! 16.02.24 이문종
	local isPress = true
	if nil == baseSkillQuestCheck[classType][baseSkillProgressIndex].actionKey[comboSkillIndex] then
		return false
	end
	
	-- 순서에 주의!!!!! or 스킬일 경우, 공유 키는 [2]에 세팅!! <S> + <F> or <W> + <F>(소서 해방된 어둠) 는 [2] = <F>, [1] = <S>, [3] = <W> 로 
	-- if 3 == #baseSkillQuestCheck[classType][baseSkillProgressIndex].actionKey[comboSkillIndex] then
		-- isPress = isPress and keyCustom_IsPressed_Action( baseSkillQuestCheck[classType][baseSkillProgressIndex].actionKey[comboSkillIndex][2] )
		-- isPress = isPress and ( keyCustom_IsPressed_Action( baseSkillQuestCheck[classType][baseSkillProgressIndex].actionKey[comboSkillIndex][1] )
							 -- or keyCustom_IsPressed_Action( baseSkillQuestCheck[classType][baseSkillProgressIndex].actionKey[comboSkillIndex][3] ))
		-- return isPress
	-- elseif ( UI_classType.ClassType_Wizard == classType or UI_classType.ClassType_WizardWomen == classType ) and ( 1 == baseSkillProgressIndex ) and ( 2 == comboSkillIndex ) then
		-- isPress = isPress and ( keyCustom_IsPressed_Action( baseSkillQuestCheck[classType][baseSkillProgressIndex].actionKey[comboSkillIndex][1] )
							 -- or keyCustom_IsPressed_Action( baseSkillQuestCheck[classType][baseSkillProgressIndex].actionKey[comboSkillIndex][2] ))
		-- return isPress
	-- else
		for v, key in pairs ( baseSkillQuestCheck[classType][baseSkillProgressIndex].actionKey[comboSkillIndex] ) do
			isPress = isPress and keyCustom_IsPressed_Action( key )
		end
		return isPress
	-- end
end

local baseCombo_PressCheck = function()
	if baseSkillProgressIndex < 0 then
		return
	end
	
	if _ramainTime < 0.7 then
		return
	end
	
	if baseSkillMatch[3] then
		ComboTutorial_NextStep_FontColorChange( true, true, true, true )
		_ramainTime = 0
		baseSkillMatch_Init()
		Tutorial_CheckBaseCombo()
	elseif baseSkillMatch[2] then
		ComboTutorial_NextStep_FontColorChange( true, true, true, false )
		if baseComboSuccess(3) then
			baseSkillMatch[3] = true
			_ramainTime = 0
			Tutorial_CheckBaseCombo()
		end
	elseif baseSkillMatch[1] then
		ComboTutorial_NextStep_FontColorChange( true, true, false, false )
		if baseComboSuccess(2) then
			baseSkillMatch[2] = true
			_ramainTime = 0
			Tutorial_CheckBaseCombo()
		end
	elseif baseSkillMatch[0] then
		ComboTutorial_NextStep_FontColorChange( true, false, false, false )
		if baseComboSuccess(1) then
			baseSkillMatch[1] = true
			_ramainTime = 0
			Tutorial_CheckBaseCombo()
		end
	else
		ComboTutorial_NextStep_FontColorChange( false, false, false, false )
	end
	
	if not baseSkillMatch[0] then
		if baseComboSuccess(0) then
			baseSkillMatch[0] = true
			_ramainTime = 0
		end
	end
end

local updateDeltaTime_BaseSkillTutorial = function( deltaTime )
	_ramainTime = _ramainTime + deltaTime
	baseCombo_PressCheck()
	
	if baseComboVar and 2.5 < _ramainTime then
		if clearCount < repeatCount then
			baseSkillMatch_Init()
			ComboTutorial_NextStep_FontColorChange( false, false, false, false )
			baseComboVar = false
		elseif ( repeatCount <= clearCount ) and 5.0 < _ramainTime then
			FGlobal_BaseSkill_TutorialClose()
		end
	end
	
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Panel_Tutorial_doStep( deltaTime )
	if ( welcomeToTheWorld ) then
		-- if not isPvpEnable() then
			Panel_PvpMode:SetShow( false )
		-- else
			-- Panel_PvpMode:SetShow( true )
		-- end
	end
	
	-- if 10 <= getSelfPlayer():get():getLevel() then
		-- Panel_Tutorial:SetShow( false, false )
		-- return
	-- end
	actionKey_Change()
	bubbleKey_Change()
	
	if ( 1 == _stepNo ) then				-- 기본 이동 스텝1
		updateDeltaTime_Step1(deltaTime)
	elseif ( 2 == _stepNo ) then			-- 기본 이동 스텝2
		updateDeltaTime_Step2(deltaTime)
	elseif ( 3 == _stepNo ) then			-- 기본 이동 스텝3
		updateDeltaTime_Step3(deltaTime)
	elseif ( 4 == _stepNo ) then			-- 기본 이동 종료
		updateDeltaTime_Step4(deltaTime)
	--------------------------------------------------------------
	elseif ( 5 == _stepNo ) then			-- 기본 공격 스텝1
		updateDeltaTime_Battle_Step1(deltaTime)
	elseif ( 6 == _stepNo ) then			-- 기본 공격 스텝2
		updateDeltaTime_Battle_Step2(deltaTime)
		updateDeltaTime_Battle_ForKeyPressed(deltaTime)
	--------------------------------------------------------------
	elseif ( 7 == _stepNo ) then			-- 기본 공격 스텝3 - 레인저 (↓ + 좌클릭)
		updateDeltaTime_Battle_Step3_Ranger(deltaTime)
	elseif ( 8 == _stepNo ) then			-- 기본 공격 스텝3 - 소서러 (우클릭)
		updateDeltaTime_Battle_Step3_Sorcerer(deltaTime)
	elseif ( 9 == _stepNo ) then			-- 기본 공격 스텝3 - 워리어 (가드)
		updateDeltaTime_Battle_Step3_Warrior(deltaTime)
	elseif ( 10 == _stepNo ) then			-- 기본 공격 스텝3 - 자이언트 (잡기)
		updateDeltaTime_Battle_Step3_Giant(deltaTime)
	elseif ( 13 == _stepNo ) then			-- 기본 공격 스텝3 - 테이머 (띄우기)
		updateDeltaTime_Battle_Step3_Tamer(deltaTime)
	elseif ( 14 == _stepNo ) then			-- 기본 공격 스텝3 - 무사 (???)
		updateDeltaTime_Battle_Step3_BladeMaster(deltaTime)
	elseif ( 15 == _stepNo ) then			-- 기본 공격 스텝3 - 발키리
		updateDeltaTime_Battle_Step3_Valkyrie(deltaTime)
	elseif ( 16 == _stepNo ) then			-- 기본 공격 스텝3 - 위저드
		updateDeltaTime_Battle_Step3_Wizard(deltaTime)
	elseif ( 17 == _stepNo ) then			-- 기본 공격 스텝3 - 닌자
		updateDeltaTime_Battle_Step3_Ninja(deltaTime)
	--------------------------------------------------------------
	elseif ( 11 == _stepNo ) then			-- 기본 공격 스텝4
		updateDeltaTime_Battle_Step4(deltaTime)
	elseif ( 12 == _stepNo ) then			-- 기본 공격 종료
		updateDeltaTime_Battle_Step5(deltaTime)
	--------------------------------------------------------------
	elseif ( 21 == _stepNo ) then			-- T키를 눌러
		updateDeltaTime_NaviCtrl_Step1(deltaTime)
	elseif ( 22 == _stepNo ) then			-- 길찾기 버튼을 눌러라
		updateDeltaTime_NaviCtrl_Step2(deltaTime)
	elseif ( 23 == _stepNo ) then			-- T를 눌러 자동이동 해봐라
		updateDeltaTime_NaviCtrl_Step3(deltaTime)
	elseif ( 24 == _stepNo ) then			-- 종료 한다
		updateDeltaTime_NaviCtrl_Step4(deltaTime)
	elseif ( 25 == _stepNo ) then			-- Ctrl 눌러
		updateDeltaTime_NaviCtrl_Step1_1(deltaTime)
	elseif ( 26 == _stepNo ) then			-- T키가 편하지?
		updateDeltaTime_NaviCtrl_Step1_2(deltaTime)
	--------------------------------------------------------------	
	elseif ( 31 == _stepNo ) then			-- 첫 인터랙션 창 오픈
		updateDeltaTime_Interaction_Step1(deltaTime)
	elseif ( 32 == _stepNo ) then			-- 인터랙션 가이드 종료
		updateDeltaTime_Interaction_Step2(deltaTime)
	--------------------------------------------------------------	
	elseif ( 41 == _stepNo ) then			-- 흑정령 소환 튜토리얼
		updateDeltaTime_CallSpirit_Step1(deltaTime)
	elseif ( 42 == _stepNo ) then			-- 흑정령 소환 튜토리얼 종료
		updateDeltaTime_CallSpirit_Step2(deltaTime)
	--------------------------------------------------------------	
	elseif ( 51 == _stepNo ) then			-- 보스 소환 튜토리얼
		updateDeltaTime_SummonBoss_Step1(deltaTime)
	elseif ( 52 == _stepNo ) then			-- 보스 소환 튜토리얼2
		updateDeltaTime_SummonBoss_Step2(deltaTime)
	elseif ( 53 == _stepNo ) then			-- 보스 소환 튜토리얼3
		updateDeltaTime_SummonBoss_Step3(deltaTime)
	--------------------------------------------------------------	
	elseif ( 96 == _stepNo ) then			-- 인벤토리 열기 튜토리얼 시작!
		updateDeltaTime_OpenInventory_Step1(deltaTime)
	elseif ( 97 == _stepNo ) then			-- 물약을 먹어라
		updateDeltaTime_OpenInventory_Step2(deltaTime)
	elseif ( 98 == _stepNo ) then			-- 종료 한다
		updateDeltaTime_OpenInventory_Step3(deltaTime)
	--------------------------------------------------------------
	elseif ( 99 == _stepNo ) then			-- 최초 튜토리얼 시작!
		updateDeltaTime_StartTutorial(deltaTime)
	--------------------------------------------------------------
	elseif ( 101 == _stepNo ) then			-- 워리어 스킬
		updateDeltaTime_ComboTutorial(deltaTime)
	--------------------------------------------------------------
	elseif ( 111 == _stepNo ) then			-- 기본 스킬 튜토리얼
		updateDeltaTime_BaseSkillTutorial(deltaTime)
		
	end

end

function Panel_Tutorial_BtnsDisappear()
	ui._m0:ResetVertexAni()
	ui._m1:ResetVertexAni()
	ui._button_Q:ResetVertexAni()
	ui._button_W:ResetVertexAni()
	ui._button_A:ResetVertexAni()
	ui._button_S:ResetVertexAni()
	ui._button_D:ResetVertexAni()
	ui._button_E:ResetVertexAni()
	ui._button_F:ResetVertexAni()
	ui._button_Tab:ResetVertexAni()
	ui._button_Shift:ResetVertexAni()
	ui._button_Space:ResetVertexAni()
	ui._button_Ctrl:ResetVertexAni()
	ui._mBody:ResetVertexAni()

	ui._m0:SetVertexAniRun( "Ani_Color_Disappear", true )
	ui._m1:SetVertexAniRun( "Ani_Color_Disappear", true )
	ui._button_Q:SetVertexAniRun( "Ani_Color_Disappear", true )
	ui._button_W:SetVertexAniRun( "Ani_Color_Disappear", true )
	ui._button_A:SetVertexAniRun( "Ani_Color_Disappear", true )
	ui._button_S:SetVertexAniRun( "Ani_Color_Disappear", true )
	ui._button_D:SetVertexAniRun( "Ani_Color_Disappear", true )
	ui._button_E:SetVertexAniRun( "Ani_Color_Disappear", true )
	ui._button_F:SetVertexAniRun( "Ani_Color_Disappear", true )
	ui._button_Tab:SetVertexAniRun( "Ani_Color_Disappear", true )
	ui._button_Shift:SetVertexAniRun( "Ani_Color_Disappear", true )
	ui._button_Space:SetVertexAniRun( "Ani_Color_Disappear", true )
	ui._button_Ctrl:SetVertexAniRun( "Ani_Color_Disappear", true )
	ui._mBody:SetVertexAniRun( "Ani_Color_Disappear", true )
end

-- 길찾기 튜토리얼 마스크는 한 번만 안내되게 한다!
local naviTutorialMaskCheck = false
function FGlobal_Tutorial_QuestMasking_Show( posX, posY )
	if true == naviTutorialMaskCheck then
		return
	end
	naviTutorialMaskCheck = true
	Panel_Masking_Tutorial:SetShow( true )
	_maskBg_Quest			:SetShow( true )
	_maskBg_SelfExpGuage	:SetShow( false )
	_maskBg_Spirit			:SetShow( false )

	local _posX = Panel_CheckedQuest:GetPosX() + posX - 150
	local _posY = Panel_CheckedQuest:GetPosY() + posY - 120
	Panel_Masking_Tutorial:SetPosX( _posX )
	Panel_Masking_Tutorial:SetPosY( _posY )
end

local invenTutorialMaskCheck = false
function FGlobal_Tutorial_InventoryMasking_Show( posX, posY )
	if true == invenTutorialMaskCheck then
		return
	end
	invenTutorialMaskCheck = true
	Panel_Masking_Tutorial	:SetShow( true )
	_maskBg_Quest			:SetShow( true )
	_maskBg_SelfExpGuage	:SetShow( false )
	_maskBg_Spirit			:SetShow( false )

	local _posX = Panel_Window_Inventory:GetPosX() + posX - 130
	local _posY = Panel_Window_Inventory:GetPosY() + posY - 115
	Panel_Masking_Tutorial:SetPosX( _posX )
	Panel_Masking_Tutorial:SetPosY( _posY )
end

local spiritTutorialMaskCheck = false
function FGlobal_Tutorial_SpiritMasking_Show()
	if true == spiritTutorialMaskCheck then
		return
	end
	spiritTutorialMaskCheck = true
	Panel_Masking_Tutorial	:SetShow( true )
	_maskBg_Quest			:SetShow( false )
	_maskBg_SelfExpGuage	:SetShow( false )
	_maskBg_Spirit			:SetShow( true )

	local _posX = Panel_NewQuest_Alarm:GetPosX() - 100
	local _posY = Panel_NewQuest_Alarm:GetPosY() - 70
	Panel_Masking_Tutorial:SetPosX( _posX )
	Panel_Masking_Tutorial:SetPosY( _posY )
end

function FGlobal_Tutorial_QuestMasking_Hide()
	Panel_Masking_Tutorial	:SetShow( false )
	_maskBg_Quest			:SetShow( false )
	_maskBg_SelfExpGuage	:SetShow( false )
	_maskBg_Spirit			:SetShow( false )
end


local callSpiritTutorialCount = 0
function FGlobal_Tutorial_CallSpirit()
	if Panel_Npc_Dialog:GetShow() then
		return
	end
	
	if 2 < callSpiritTutorialCount then
		return
	end
	
	callSpiritTutorialCount = callSpiritTutorialCount + 1

	Panel_MovieTheater_LowLevel_WindowClose()
	Panel_Tutorial:SetShow( true, false )

	-- 기본적으로 애들을 꺼준다
	for _, v in pairs ( ui ) do
		v:SetShow( false )
	end
	
	ui._obsidian:SetShow(true)
	ui._obsidian_B:SetShow(false)
	ui._obsidian_B_Left:SetShow(true)
	ui._obsidian_Text:SetShow(true)
	ui._obsidian_Text_2:SetShow(true)
	ui._bubbleKey_R:SetShow(true)
	ui._obsidian:EraseAllEffect()
	ui._obsidian:AddEffect ( "fUI_DarkSpirit_Tutorial", true, 0, 0 )

	ButtonToggleAll(false)
	Panel_Tutorial_BtnHide()
	bubbleKey_Hide()
	-- FGlobal_Panel_LowLevelGuide_MovePlay_Battle:SetShow( false, false )
	_stepNo = 41
end

function isTutorialEnd()
	return _isTutorialEnd
end

function isInteractionTutorial()
	return isInteractionForTutorial
end

function FGlobal_BossSummon_Alert( index )
	if isFlushedUI() then
		return
	end
	
	Panel_Tutorial:SetShow( true, false )

	-- 기본적으로 애들을 꺼준다
	for _, v in pairs ( ui ) do
		v:SetShow( false )
	end
	
	ui._obsidian:SetShow(true)
	ui._obsidian_B:SetShow(false)
	ui._obsidian_B_Left:SetShow(true)
	ui._obsidian_Text:SetShow(true)
	ui._obsidian_Text_2:SetShow(true)
	ui._bubbleKey_R:SetShow(true)
	ui._obsidian:EraseAllEffect()
	ui._obsidian:AddEffect ( "fUI_DarkSpirit_Tutorial", true, 0, 0 )

	ButtonToggleAll(false)
	Panel_Tutorial_BtnHide()
	bubbleKey_Hide()
	-- FGlobal_Panel_LowLevelGuide_MovePlay_Battle:SetShow( false, false )
	
	if 0 == index then
		summonText[0] = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_23")
		summonText[1] = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_24")
		summonText[2] = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_26")
	elseif 1 == index then
		summonText[0] = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_29") -- "바로 여기야! 이곳에서 고블린 족장을 소환할 수 있어."
		summonText[1] = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_30") -- "가방을 열어 고블린 족장 소환서를 우클릭해봐."
		summonText[2] = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_31") -- "아이템을 우클릭하면 고블린 족장 기아스 소환이 시작돼."
	end
	
	
	
	_stepNo = 51
end

function FGlobal_CharacterSkill_Tutorial()
	if isFlushedUI() then
		return
	end
	
	-- if Panel_Tutorial:GetShow() then
		-- return
	-- end
	
	Panel_Tutorial:SetShow( true, false )

	-- 기본적으로 애들을 꺼준다
	ui._purposeText:ComputePos()
	
	ui._nextStep_1:SetShow(false)
	ui._nextStep_2:SetShow(false)
	ui._nextStep_3:SetShow(false)
	ui._nextStep_4:SetShow(false)
	ui._nextArrow_0:SetShow(false)
	ui._nextArrow_1:SetShow(false)
	ui._nextArrow_2:SetShow(false)

	ui._clearStep_1:SetShow(false)
	ui._clearStep_2:SetShow(false)
	ui._clearStep_3:SetShow(false)
	ui._clearStep_4:SetShow(false)
	ui._clearStep_1:EraseAllEffect()
	ui._clearStep_2:EraseAllEffect()
	ui._clearStep_3:EraseAllEffect()
	ui._clearStep_4:EraseAllEffect()
	
	Panel_Tutorial_BtnHide()
	bubbleKey_Hide()
	
	ui._obsidian:SetShow ( false )
	ui._obsidian_B:SetShow ( false )
	ui._obsidian_Text:SetShow ( false )
	ui._obsidian_B_Left:SetShow( false )
	ui._obsidian_Text_2:SetShow( false )
	ui._bubbleKey_Ctrl:SetShow( false )
	ui._bubbleKey_T:SetShow( false )
	
	ui._purposeText:SetText( "" )
	ui._purposeText:SetShow(true)
	-- ui._nextStep_1:SetShow(true)
	-- ui._nextStep_2:SetShow(true)
	-- ui._nextStep_3:SetShow(true)
	-- ui._nextArrow_0:SetShow(true)
	-- ui._nextArrow_1:SetShow(true)
	ui._purposeText:SetAlpha(1)
	ui._nextStep_1:SetAlpha(1)
	ui._nextStep_2:SetAlpha(1)
	ui._nextStep_3:SetAlpha(1)
	ui._nextArrow_0:SetAlpha(1)
	ui._nextArrow_1:SetAlpha(1)
	
	ButtonToggleAll(false)
	ButtonToggle("_button_Q", false)
	ButtonToggle("_button_W", false)
	ButtonToggle("_button_A", false)
	ButtonToggle("_button_S", false)
	ButtonToggle("_button_D", false)
	ButtonToggle("_button_Shift", false)
	
	prevUsingKey._button_Q = false
	prevUsingKey._button_W = false
	prevUsingKey._button_A = false
	prevUsingKey._button_S = false
	prevUsingKey._button_D = false
	prevUsingKey._button_F = false
	prevUsingKey._button_Shift = false
	prevUsingKey._m0 = false
	prevUsingKey._m1 = false	
	
	for index = 0, #questCheck[classType] do
		if questList_hasProgressQuest(questCheck[classType][index].questGroup, questCheck[classType][index].questId) then
			ui._purposeText:SetText( questCheck[classType][index].purposeText )
			progressQuestNo._group = questCheck[classType][index].questGroup
			progressQuestNo._id = questCheck[classType][index].questId
			comboQuestClear = false
			for ii = 1, #questCheck[classType][index].combo do
				if nil ~= questCheck[classType][index].combo[ii] then
					if 1 == ii then
						ui._nextStep_1:SetText( questCheck[classType][index].combo[ii] .. "\n" .. questCheck[classType][index].comboKey[ii] )
						ui._nextStep_1:SetFontColor( UI_color.C_FFC4BEBE )
						ui._nextStep_1:SetShow( true )
					elseif 2 == ii then
						ui._nextStep_2:SetText( questCheck[classType][index].combo[ii] .. "\n" .. questCheck[classType][index].comboKey[ii] )
						ui._nextStep_2:SetShow( true )
						ui._nextStep_2:SetFontColor( UI_color.C_FFC4BEBE )
						ui._nextArrow_0:SetShow( true )
					elseif 3 == ii then
						ui._nextStep_3:SetText( questCheck[classType][index].combo[ii] .. "\n" .. questCheck[classType][index].comboKey[ii] )
						ui._nextStep_3:SetShow( true )
						ui._nextStep_3:SetFontColor( UI_color.C_FFC4BEBE )
						ui._nextArrow_1:SetShow( true )
					elseif 4 == ii then
						ui._nextStep_4:SetText( questCheck[classType][index].combo[ii] .. "\n" .. questCheck[classType][index].comboKey[ii] )
						ui._nextStep_4:SetShow( true )
						ui._nextStep_4:SetFontColor( UI_color.C_FFC4BEBE )
						ui._nextArrow_2:SetShow( true )
					end
				end
			end
			
		end
	end
	
	for index = 0, baseComboCount - 1 do
		usedSkillKey[index] = nil
		usedSkillMatch[index] = false
	end
	_stepNo	= 101
end


function FGlobal_BaseSkill_Tutorial()
	if isFlushedUI() then
		return
	end
	
	FGlobal_Tutorial_Close()
	-- if Panel_Tutorial:GetShow() then
		-- return
	-- end
	
	Panel_Tutorial:SetShow( true, false )

	-- 기본적으로 애들을 꺼준다
	ui._purposeText:ComputePos()
	
	ui._nextStep_1:SetShow(false)
	ui._nextStep_2:SetShow(false)
	ui._nextStep_3:SetShow(false)
	ui._nextStep_4:SetShow(false)
	ui._nextArrow_0:SetShow(false)
	ui._nextArrow_1:SetShow(false)
	ui._nextArrow_2:SetShow(false)

	ui._clearStep_1:SetShow(false)
	ui._clearStep_2:SetShow(false)
	ui._clearStep_3:SetShow(false)
	ui._clearStep_4:SetShow(false)
	ui._clearStep_1:EraseAllEffect()
	ui._clearStep_2:EraseAllEffect()
	ui._clearStep_3:EraseAllEffect()
	ui._clearStep_4:EraseAllEffect()
	
	Panel_Tutorial_BtnHide()
	bubbleKey_Hide()
	
	ui._obsidian:SetShow ( false )
	ui._obsidian_B:SetShow ( false )
	ui._obsidian_Text:SetShow ( false )
	ui._obsidian_B_Left:SetShow( false )
	ui._obsidian_Text_2:SetShow( false )
	ui._bubbleKey_Ctrl:SetShow( false )
	ui._bubbleKey_T:SetShow( false )
	
	ui._purposeText:SetText( "" )
	ui._purposeText:SetShow(true)
	-- ui._nextStep_1:SetShow(true)
	-- ui._nextStep_2:SetShow(true)
	-- ui._nextStep_3:SetShow(true)
	-- ui._nextArrow_0:SetShow(true)
	-- ui._nextArrow_1:SetShow(true)
	ui._purposeText:SetAlpha(1)
	ui._nextStep_1:SetAlpha(1)
	ui._nextStep_2:SetAlpha(1)
	ui._nextStep_3:SetAlpha(1)
	ui._nextArrow_0:SetAlpha(1)
	ui._nextArrow_1:SetAlpha(1)
	
	ButtonToggleAll(false)
	ButtonToggle("_button_Q", false)
	ButtonToggle("_button_W", false)
	ButtonToggle("_button_A", false)
	ButtonToggle("_button_S", false)
	ButtonToggle("_button_D", false)
	ButtonToggle("_button_Shift", false)
	
	prevUsingKey._button_Q = false
	prevUsingKey._button_W = false
	prevUsingKey._button_A = false
	prevUsingKey._button_S = false
	prevUsingKey._button_D = false
	prevUsingKey._button_F = false
	prevUsingKey._button_Shift = false
	prevUsingKey._m0 = false
	prevUsingKey._m1 = false	
	
	for index = 0, #baseSkillQuestCheck[classType] do
		if questList_hasProgressQuest(baseSkillQuestCheck[classType][index].questGroup, baseSkillQuestCheck[classType][index].questId) then
			ui._purposeText:SetText( baseSkillQuestCheck[classType][index].purposeText .. " ( 0 / " .. repeatCount .. " )")
			progressQuestNo._group = baseSkillQuestCheck[classType][index].questGroup
			progressQuestNo._id = baseSkillQuestCheck[classType][index].questId
			baseSkillProgressIndex = index
			baseComboQuestClear = false
			local uiQuestInfo = ToClient_GetQuestInfo( baseSkillQuestCheck[classType][index].questGroup, baseSkillQuestCheck[classType][index].questId )
			local questCondition = uiQuestInfo:getDemandAt( 0 )
			if (questCondition._destCount <= questCondition._currentCount) then
				FGlobal_BaseSkill_TutorialClose( true )
				return
			end
			for ii = 1, #baseSkillQuestCheck[classType][index].combo do
				if nil ~= baseSkillQuestCheck[classType][index].combo[ii] then
					if 1 == ii then
						ui._nextStep_1:SetText( baseSkillQuestCheck[classType][index].combo[ii] .. "\n" .. baseSkillQuestCheck[classType][index].comboKey[ii] )
						ui._nextStep_1:SetFontColor( UI_color.C_FFC4BEBE )
						ui._nextStep_1:SetShow( true )
					elseif 2 == ii then
						ui._nextStep_2:SetText( baseSkillQuestCheck[classType][index].combo[ii] .. "\n" .. baseSkillQuestCheck[classType][index].comboKey[ii] )
						ui._nextStep_2:SetShow( true )
						ui._nextStep_2:SetFontColor( UI_color.C_FFC4BEBE )
						ui._nextArrow_0:SetShow( true )
					elseif 3 == ii then
						ui._nextStep_3:SetText( baseSkillQuestCheck[classType][index].combo[ii] .. "\n" .. baseSkillQuestCheck[classType][index].comboKey[ii] )
						ui._nextStep_3:SetShow( true )
						ui._nextStep_3:SetFontColor( UI_color.C_FFC4BEBE )
						ui._nextArrow_1:SetShow( true )
					elseif 4 == ii then
						ui._nextStep_4:SetText( baseSkillQuestCheck[classType][index].combo[ii] .. "\n" .. baseSkillQuestCheck[classType][index].comboKey[ii] )
						ui._nextStep_4:SetShow( true )
						ui._nextStep_4:SetFontColor( UI_color.C_FFC4BEBE )
						ui._nextArrow_2:SetShow( true )
					end
				end
			end
			
		end
	end
	
	baseSkillMatch_Init()
	baseComboVar = false
	clearCount = 0
	_stepNo	= 111
end

function FGlobal_BaseSkill_TutorialClose( isCloese )
	if 111 == _stepNo or isCloese then
		_stepNo = 0
		_ramainTime = 0
		clearCount = 0
		baseSkillMatch_Init()
		Panel_Tutorial:SetShow( false, false )
	end
end

-- 퀘스트가 진행중일 때, UI가 리로드 되는 상황 대비해 한 번 실행해준다
function FGlobal_BaseSkill_QuestCheck()
	for index = 0, #baseSkillQuestCheck[classType] do
		if questList_hasProgressQuest(baseSkillQuestCheck[classType][index].questGroup, baseSkillQuestCheck[classType][index].questId) then
			FGlobal_BaseSkill_Tutorial()
			return
		end
	end
end
FGlobal_BaseSkill_QuestCheck()

-- 보스 퀘스트가 클리어되면 튜토리얼을 꺼준다!!
local summonBossQuest =
{
	groupId = { 104, 105 },
	questId = { 2, 6 }
}
function FGlobal_Tutorial_BossSummon_Close()
	if not Panel_Tutorial:GetShow() then
		return
	end
	
	for index = 1, #summonBossQuest.groupId do
		local bossTutorialProgress = questList_hasProgressQuest( summonBossQuest.groupId[index], summonBossQuest.questId[index] )
		if bossTutorialProgress then
			local uiQuestInfo = ToClient_GetQuestInfo( summonBossQuest.groupId[index], summonBossQuest.questId[index] )
			local questCondition = uiQuestInfo:getDemandAt( 0 )
			if (questCondition._destCount <= questCondition._currentCount) then
				FGlobal_Tutorial_Close()
				return
			end
		end
	end
end

registerEvent("onScreenResize", "Tutorial_ScreenRePosition")
Panel_Tutorial:RegisterUpdateFunc("Panel_Tutorial_doStep")

-- Panel_WelcomeToTheWorld_Start()
-- Panel_Tutorial_Battle_Start()
-- Panel_Tutorial_NaviCtrl_Start()