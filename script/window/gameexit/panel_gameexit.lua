local UI_PSFT 			= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV 		= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 			= Defines.Color
local UI_TM 			= CppEnums.TextMode
local UCT 				= CppEnums.PA_UI_CONTROL_TYPE
local UI_Class			= CppEnums.ClassType
local PP 				= CppEnums.PAUIMB_PRIORITY
local ePcWorkingType 	= CppEnums.PcWorkType
local const_64			= Defines.s64_const

Panel_GameExit:setMaskingChild(true)
Panel_GameExit:ActiveMouseEventEffect(true)
Panel_GameExit:setGlassBackground(true)

Panel_ExitConfirm:setMaskingChild(true)
Panel_ExitConfirm:ActiveMouseEventEffect(true)
Panel_ExitConfirm:setGlassBackground(true)

Panel_ExitConfirm:SetShow( false )
Panel_GameExit:SetShow( false )

------------------------------------------
--		애니메이션 처리 함수
------------------------------------------
Panel_GameExit:RegisterShowEventFunc( true, 'Panel_GameExit_ShowAni()' )
Panel_GameExit:RegisterShowEventFunc( false, 'Panel_GameExit_HideAni()' )

function Panel_GameExit_ShowAni()
	UIAni.fadeInSCR_Down( Panel_GameExit )
	audioPostEvent_SystemUi(01,00)
end

function Panel_GameExit_HideAni()
	Panel_GameExit:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo1 = Panel_GameExit:addColorAnimation( 0.0, 0.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd( true )
	aniInfo1:SetDisableWhileAni( true )
	
	audioPostEvent_SystemUi(01,01)
end

-----------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------
local _btn_winClose 		= UI.getChildControl( Panel_GameExit,	"Button_Win_Close" )				-- x 버튼

local _btn_selectCharacter 	= UI.getChildControl( Panel_GameExit,	"Button_CharacterSelect" )		-- 선택창 가기 버튼
local _btn_gameExit 		= UI.getChildControl( Panel_GameExit,	"Button_GameExit" )				-- 게임 종료 버튼
local _btn_cancel 			= UI.getChildControl( Panel_GameExit,	"Button_Cancel" )					-- 취소 버튼
local _charSlotBG 			= UI.getChildControl( Panel_GameExit,	"Static_CharSlot_BG" )
local _btn_NoticeMsg		= UI.getChildControl( Panel_GameExit,	"Button_NoticeMsg" )
local _btn_PreCharPage		= UI.getChildControl( Panel_GameExit,	"Button_PrePage" )
local _btn_NextCharPage		= UI.getChildControl( Panel_GameExit,	"Button_NextPage" )
local _btn_ChangeChannel	= UI.getChildControl( Panel_GameExit,	"Button_ChangeChannel")
local _btn_CharTransport	= UI.getChildControl( Panel_GameExit,	"Button_Transport" )
local _block_BG				= UI.getChildControl( Panel_GameExit,	"Static_block_BG" )

local isTrayMode					= false
local _exitConfirm_TitleText		= UI.getChildControl( Panel_ExitConfirm,	"StaticText_Title" )
local _exitConfirm_Btn_Confirm		= UI.getChildControl( Panel_ExitConfirm,	"Button_Confirm" )
local _exitConfirm_Btn_Cancle		= UI.getChildControl( Panel_ExitConfirm,	"Button_Cancle" )
local _exitConfirm_Chk_Tray			= UI.getChildControl( Panel_ExitConfirm,	"CheckButton_Tray" )
local _exitConfirm_TrayString		= UI.getChildControl( Panel_ExitConfirm,	"StaticText_TrayHelp" )
local _exitConfirm_ContentsString	= UI.getChildControl( Panel_ExitConfirm,	"StaticText_GameExit" )
_exitConfirm_ContentsString	:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEEXIT_TRAY_ASK") )
_exitConfirm_TrayString	:SetTextMode( UI_TM.eTextMode_AutoWrap )
_exitConfirm_TrayString	:SetAutoResize( true )
_exitConfirm_TrayString	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXITTRAY_TRAYHELP") )
	-- "트레이창으로 보내기가 체크되면, 닫기 버튼을 누를 때 게임이 종료 되는 것이 아니라 우측 하단 트레이창으로 게임이 최소화 됩니다."
_exitConfirm_Chk_Tray	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXITTRAY_CHKTRAY") )
	-- "종료시 트레이창으로 보내기"
_exitConfirm_Chk_Tray	:SetEnableArea( 0, 0, _exitConfirm_Chk_Tray:GetSizeX() + _exitConfirm_Chk_Tray:GetTextSizeX(), _exitConfirm_Chk_Tray:GetSizeY() )

local _exitConfirm_Chk_Tray_2 = UI.createControl( UCT.PA_UI_CONTROL_CHECKBUTTON, Panel_ExitConfirm, 'CheckButton_Tray_2' )
CopyBaseProperty( _exitConfirm_Chk_Tray, _exitConfirm_Chk_Tray_2 )
_exitConfirm_Chk_Tray_2:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GAMEXITTRAYCHECKBUTTONTEXT") ) -- "트레이창으로 최소화하기" )

local _progressingQuest		= UI.getChildControl( Panel_GameExit,	"StaticText_ProgressingQuest_Value" )
local _completeQuest		= UI.getChildControl( Panel_GameExit,	"StaticText_LastCompleteQuest_Value" )
local _addMessage			= UI.getChildControl( Panel_GameExit,	"Edit_AddMessage" )
local journalFrame			= UI.getChildControl( Panel_GameExit,	"Frame_TodayMyChallenge" )
local journalFrameContents	= UI.getChildControl( journalFrame,		"Frame_1_Content" )
local journalFrameScroll	= UI.getChildControl( journalFrame,		"Frame_Scroll_TodayMyChallenge" )
local journalContents		= UI.getChildControl( Panel_GameExit,	"StaticText_TodayMyChallenge_Contents" )
journalFrameContents:AddChild( journalContents )
Panel_GameExit:RemoveControl( journalContents )
journalContents:SetAutoResize( true )
journalContents:SetTextMode( UI_TM.eTextMode_AutoWrap )
journalContents:SetPosX( 0 )
journalContents:SetPosY( 30 )
_addMessage:SetMaxInput( 24 )

local normalStack	= {}
local valksStack	= {}

_btn_PreCharPage:SetAutoDisableTime(0)
_btn_NextCharPage:SetAutoDisableTime(0)

local 	_buttonQuestion = UI.getChildControl( Panel_GameExit, "Button_Question" )			-- 물음표 버튼

local Copy_UI_CharChange = 
{
	_copy_CharSlot 					= UI.getChildControl( Panel_GameExit, "Static_CharSlot" ),
	_copy_CharLevel 				= UI.getChildControl( Panel_GameExit, "StaticText_Char_Level" ),
	_copy_CharName 					= UI.getChildControl( Panel_GameExit, "StaticText_Char_Name" ),
	_copy_NormalStack				= UI.getChildControl( Panel_GameExit, "StaticText_NormalStack"),
	-- _copy_AddStack					= UI.getChildControl( Panel_GameExit, "StaticText_AddStack"),
	_copy_CharGaugeBG 				= UI.getChildControl( Panel_GameExit, "Static_Char_GaugeBG" ),
	_copy_CharGauge 				= UI.getChildControl( Panel_GameExit, "Static_Char_Gauge" ),
	_copy_CharWorkTxt 				= UI.getChildControl( Panel_GameExit, "StaticText_Char_Work" ),
	_copy_CharPcDeliveryRemainTime	= UI.getChildControl( Panel_GameExit, "StaticText_PcDeliveryRemainTime" ),
	_copy_CharWhere 				= UI.getChildControl( Panel_GameExit, "StaticText_Char_Where" ),
	_copy_CharPosition 				= UI.getChildControl( Panel_GameExit, "StaticText_Char_Position" ),
	_copy_CharEnterWaiting			= UI.getChildControl( Panel_GameExit, "StaticText_EnterWaiting" ),
	_copy_CharChange 				= UI.getChildControl( Panel_GameExit, "Button_Change" ),
	_copy_CharSelect 				= UI.getChildControl( Panel_GameExit, "Static_CharSlot_Select" ),
	_copy_CharSlot_BG2 				= UI.getChildControl( Panel_GameExit, "Static_CharSlot_BG2" ),
}

-----------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------
--						변수 모음
local totalCharacterCount = 4
local startPosX = 4
local exitMode = -1	-- 0 : 게임 종료 1 : 캐릭터 선택창으로 가기 2 : 캐릭터 교체
local logoutDelayTime = getLogoutWaitingTime()
-- local gameExitClick = false -- false : 게임 종료창 종료 가능 / true : 게임 종료창 종료 불가능.

enum_ExitMode =
{
	eExitMode_GameExit 		= 0,
	eExitMode_BackCharacter = 1,
	eExitMode_SwapCharacter = 2,
}

local exit_Time = 0.0
local prevTime = 0
local selectCharacterIndex = -1
local back_CharacterSelectTime = 0.0
local selfCharacterIndex = -1

local isCharacterSlotBG = {}
local isCharacterSlot = {}
local CharacterChangeButton = {}
local isCharacterSelect = {}

-- 갱신될 정보들
local charWorking = {}
local charPcDeliveryRemainTime = {}
local charEnterWaiting = {}
local charLevelPool = {}
local charNamePool = {}
local charPositionPool = {}
local beginnerReward = {}
local normalStackPool = {}
-- local addStackPool = {}

-- 채널 이동 관련
local _selectChannel = -1;

------------------------------------------------------------
--						초기화 함수
------------------------------------------------------------
function Panel_GameExit_Initialize()
	--------------------------------------
	--		캐릭터 개수대로 복사하기
	local selfProxy = getSelfPlayer()
	local characterNo_64 = toInt64( 0, 0 )
	
	if nil ~= selfProxy then
		 characterNo_64 = selfProxy:getCharacterNo_64()
	end
	
	for idx = 0, totalCharacterCount - 1, 1 do
		-- 슬롯BG 복사
		local charSlotBG2	= UI.createControl( UCT.PA_UI_CONTROL_STATIC, _charSlotBG, 'Static_CharSlotBG2_' .. idx )
		CopyBaseProperty( Copy_UI_CharChange._copy_CharSlot_BG2, charSlotBG2 )
		charSlotBG2:SetShow( false )
		charSlotBG2:SetIgnore( true )
		charSlotBG2:SetPosX( startPosX + idx * 159 )
		charSlotBG2:SetPosY( 4 )
		isCharacterSlotBG[idx] = charSlotBG2

		-- 슬롯 복사
		local charSlot	= UI.createControl( UCT.PA_UI_CONTROL_STATIC, _charSlotBG, 'Static_CharSlot_' .. idx )
		CopyBaseProperty( Copy_UI_CharChange._copy_CharSlot, charSlot )
		charSlot:SetShow( false )
		charSlot:SetPosX( startPosX + idx * 159 )
		charSlot:SetPosY( 4 )
		isCharacterSlot[idx] = charSlot

		-- 캐릭터 레벨 복사
		local charLevel	= UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT, charSlot, 'StaticText_CharLevel_' .. idx )
		CopyBaseProperty( Copy_UI_CharChange._copy_CharLevel, charLevel )
		charLevel:SetShow( false )
		charLevelPool[idx] = charLevel

		-- 캐릭터 이름 복사
		local charName	= UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT, charSlot, 'StaticText_CharName_' .. idx )
		CopyBaseProperty( Copy_UI_CharChange._copy_CharName, charName )
		charName:SetShow( false )
		charNamePool[idx] = charName

		-- 작업중 텍스트 복사
		local charWorkTxt	= UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT, charSlot, 'StaticText_CharWorkText_' .. idx )
		CopyBaseProperty( Copy_UI_CharChange._copy_CharWorkTxt, charWorkTxt )
		charWorkTxt:SetShow( false )
		charWorkTxt:SetPosY( charWorkTxt:GetPosY() + 20 )
		charWorking[idx] = charWorkTxt

		-- 남은 시간 복사
		local charWorkRemainText = UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT, charSlot, 'StaticText_PcDeliveryRamainTimeText_' .. idx )
		CopyBaseProperty( Copy_UI_CharChange._copy_CharPcDeliveryRemainTime, charWorkRemainText )
		charWorkRemainText:SetShow( false )
		charPcDeliveryRemainTime[idx] = charWorkRemainText
		
		-- 실제 위치 복사
		local charPositionTxt	= UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT, charSlot, 'StaticText_CharPosition_' .. idx )
		CopyBaseProperty( Copy_UI_CharChange._copy_CharPosition, charPositionTxt )
		charPositionTxt:SetShow( false )
		charPositionPool[idx] = charPositionTxt

		-- 대기열 복사
		local charEnterWaitingTxt	= UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT, charSlot, 'StaticText_EnterWaiting_' .. idx )
		CopyBaseProperty( Copy_UI_CharChange._copy_CharEnterWaiting, charEnterWaitingTxt )
		charEnterWaitingTxt:SetShow( false )			
		charEnterWaiting[idx] = charEnterWaitingTxt

		-- 교체버튼 복사
		local charChange	= UI.createControl( UCT.PA_UI_CONTROL_BUTTON, charSlot, 'Button_CharChange_' .. idx )
		CopyBaseProperty( Copy_UI_CharChange._copy_CharChange, charChange )
		charChange:SetShow( false )
		CharacterChangeButton[idx] = charChange
		
		-- -- 운송버튼 복사
		-- local charTransport	= UI.createControl( UCT.PA_UI_CONTROL_BUTTON, charSlot, 'Button_CharTransport_' .. idx )
		-- CopyBaseProperty( Copy_UI_CharChange._copy_CharTransport, charTransport )
		-- charTransport:SetShow( false )
		-- CharacterTransport[idx] = charTransport
		
		-- 선택한 테두리 복사
		local charSelected	= UI.createControl( UCT.PA_UI_CONTROL_STATIC, _charSlotBG, 'Statc_CharSelected_' .. idx )
		CopyBaseProperty( Copy_UI_CharChange._copy_CharSelect, charSelected )
		charSelected:SetShow( false )
		charSelected:SetPosX( 2 + idx * 159 )
		charSelected:SetPosY( 2 )
		isCharacterSelect[idx] = charSelected

		--기본 스택 복사
		local normalStack = UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT, charSlot, 'StaticText_NormalStack_' .. idx )
		CopyBaseProperty( Copy_UI_CharChange._copy_NormalStack, normalStack )
		normalStack:SetShow( false )
		normalStack:SetPosX( 127 )
		normalStack:SetPosY( 170 )
		normalStackPool[idx] = normalStack

		-- -- 추가 스택 복사
		-- local addStack = UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT, charSlot, 'StaticText_AddStack_' .. idx )
		-- CopyBaseProperty( Copy_UI_CharChange._copy_AddStack, addStack )
		-- addStack:SetShow( false )
		-- addStack:SetPosX( 127 )
		-- addStack:SetPosY( 170 )
		-- addStackPool[idx] = addStack
		
	end

	--------------------------------------
	--		복사 후 기본 꺼주기
	for _, value in pairs ( Copy_UI_CharChange ) do
		value:SetShow(false)
	end

	-- 채널 변경 콤보 박스 맨 위로 올리기
	Panel_GameExit:SetChildIndex(_btn_ChangeChannel, 9999 )
	
	-- 다른 곳을 클릭하지 못하도록 막는다.
	_block_BG:SetSize( getScreenSizeX()+200, getScreenSizeY()+200 )
	_block_BG:SetHorizonCenter()
	_block_BG:SetVerticalMiddle()

	_btn_ChangeChannel:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_TITLE_MSG") )
end

-- 
function refreshCharacterInfoData( startIdx )
	local selfProxy			= getSelfPlayer()
	local characterNo_64	= toInt64( 0, 0 )

	if nil == startIdx or startIdx <= 0 then
		startIdx = 0
	end
	if nil ~= selfProxy then
		 characterNo_64 = selfProxy:getCharacterNo_64()
	end
	
	if false == Panel_GameExit:IsShow() then
		return 	-- 종료 창이 닫혀 있다면 갱신하지 않는다.
	end

	local currentTicketNo		= getCurrentTicketNo()
	local uiCount				= 0
	local characterTicketNo
	local firstTicketNo			= getFirstTicketNoByAll()
	local characterDatacount	= getCharacterDataCount()
	local nowPlayCharaterSlotNo	= nil
	local serverUtc64 = getServerUtc64()
	for idx = startIdx, characterDatacount - 1 do
		local characterData = getCharacterDataByIndex( idx )								-- 캐릭터 정보 데이터 바인드
		local char_Type 	= getCharacterClassType( characterData )						-- 클래스 타입
		local char_Level 	= string.format( "Lv. %d", characterData._level )				-- 캐릭터 레벨
		local char_Name 	= getCharacterName( characterData )								-- 캐릭터 이름
		local defaultCount			= characterData._enchantFailCount
		local valksCount			= characterData._valuePackCount
		local char_No_s64	= characterData._characterNo_s64
		local char_WorkTxt 	= ""
		local pcDeliveryRemainTimeText = ""
		local pcDeliveryRegionKey = characterData._arrivalRegionKey
		if 0 ~= pcDeliveryRegionKey:get() and serverUtc64 < characterData._arrivalTime then
			char_WorkTxt = PAGetString( Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_DELIVERY" )	-- 캐릭터 이동 중
			local remainTime = characterData._arrivalTime - serverUtc64
			pcDeliveryRemainTimeText = convertStringFromDatetime( remainTime )
		else
			char_WorkTxt = global_workTypeToStringSwap( characterData._pcWorkingType )	-- 작업중 텍스트
		end
		local regionInfo	= getRegionInfoByPosition( characterData._currentPosition )

		isCharacterSlot[uiCount]:SetShow( true )
		--	클래스에 따라 바꿔준다
		if ( char_Type == UI_Class.ClassType_Warrior ) then
			isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_00.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( isCharacterSlot[uiCount], 1, 1, 156, 201 )
			isCharacterSlot[uiCount]:getBaseTexture():setUV(  x1, y1, x2, y2  )
			isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
		elseif ( char_Type == UI_Class.ClassType_Ranger ) then
			isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_00.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( isCharacterSlot[uiCount], 157, 1, 312, 201 )
			isCharacterSlot[uiCount]:getBaseTexture():setUV(  x1, y1, x2, y2  )
			isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
		elseif ( char_Type == UI_Class.ClassType_Sorcerer ) then
			isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_00.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( isCharacterSlot[uiCount], 313, 1, 468, 201 )
			isCharacterSlot[uiCount]:getBaseTexture():setUV(  x1, y1, x2, y2  )
			isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
		elseif ( char_Type == UI_Class.ClassType_Giant ) then
			isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_00.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( isCharacterSlot[uiCount], 1, 202, 156, 402 )
			isCharacterSlot[uiCount]:getBaseTexture():setUV(  x1, y1, x2, y2  )
			isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
		elseif ( char_Type == UI_Class.ClassType_Tamer ) then
			isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_00.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( isCharacterSlot[uiCount], 157, 202, 312, 402 )
			isCharacterSlot[uiCount]:getBaseTexture():setUV(  x1, y1, x2, y2  )
			isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
		elseif ( char_Type == UI_Class.ClassType_BladeMaster ) then
			isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_00.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( isCharacterSlot[uiCount], 313, 202, 468, 402 )
			isCharacterSlot[uiCount]:getBaseTexture():setUV(  x1, y1, x2, y2  )
			isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
		elseif ( char_Type == UI_Class.ClassType_Valkyrie) then
			isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_01.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( isCharacterSlot[uiCount], 1, 1, 156, 201 )
			isCharacterSlot[uiCount]:getBaseTexture():setUV(  x1, y1, x2, y2  )
			isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
		elseif ( char_Type == UI_Class.ClassType_BladeMasterWomen) then
			isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_01.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( isCharacterSlot[uiCount], 157, 1, 312, 201 )
			isCharacterSlot[uiCount]:getBaseTexture():setUV(  x1, y1, x2, y2  )
			isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
		elseif ( char_Type == UI_Class.ClassType_Wizard) then
			isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_01.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( isCharacterSlot[uiCount], 313, 1, 468, 201 )
			isCharacterSlot[uiCount]:getBaseTexture():setUV(  x1, y1, x2, y2  )
			isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
		elseif ( char_Type == UI_Class.ClassType_WizardWomen) then
			isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_01.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( isCharacterSlot[uiCount], 1, 202, 156, 402 )
			isCharacterSlot[uiCount]:getBaseTexture():setUV(  x1, y1, x2, y2  )
			isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
		elseif ( char_Type == UI_Class.ClassType_NinjaWomen) then
			isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_01.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( isCharacterSlot[uiCount], 157, 202, 312, 402 )
			isCharacterSlot[uiCount]:getBaseTexture():setUV(  x1, y1, x2, y2  )
			isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
		elseif ( char_Type == UI_Class.ClassType_NinjaMan) then
			isCharacterSlot[uiCount]:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_01.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( isCharacterSlot[uiCount], 313, 202, 468, 402 )
			isCharacterSlot[uiCount]:getBaseTexture():setUV(  x1, y1, x2, y2  )
			isCharacterSlot[uiCount]:setRenderTexture(isCharacterSlot[uiCount]:getBaseTexture())
		end

		charLevelPool[uiCount]			:SetText( char_Level )
		charNamePool[uiCount]			:SetText( char_Name )
		if 0 == characterData._currentPosition.x and 0 == characterData._currentPosition.y and 0 == characterData._currentPosition.z then
			charPositionPool[uiCount]		:SetText( "" ) --"-"
		else
			if 0 ~= pcDeliveryRegionKey:get() and characterData._arrivalTime < serverUtc64 then
				local retionInfoArrival = getRegionInfoByRegionKey( pcDeliveryRegionKey )
				charPositionPool[uiCount]		:SetText( retionInfoArrival:getAreaName() )
			else
				charPositionPool[uiCount]		:SetText( regionInfo:getAreaName() )
			end
		end

		normalStackPool[uiCount]			:SetShow( true )
		-- addStackPool[uiCount]				:SetShow( true )
		if ToClient_IsReceivedEnchantFailCount() then
			normalStackPool[uiCount]			:SetText( defaultCount+valksCount )
		else
			normalStackPool[uiCount]			:SetText( "-" )
		end

		normalStackPool[uiCount]			:SetFontColor( UI_color.C_FFE7E7E7 )
		-- addStackPool[uiCount]				:SetText( valksCount )
		-- addStackPool[uiCount]				:SetFontColor( UI_color.C_FFE7E7E7 )

		normalStackPool[uiCount]			:addInputEvent( "Mouse_On", "GameExit_SimpleTooltips( true, " .. uiCount .. ", 0 )" )
		normalStackPool[uiCount]			:setTooltipEventRegistFunc( "GameExit_SimpleTooltips( true, " .. uiCount .. ", 0 )" )
		normalStackPool[uiCount]			:addInputEvent( "Mouse_Out", "GameExit_SimpleTooltips( false, " .. uiCount .. ", 0 )" )
		-- addStackPool[uiCount]				:addInputEvent( "Mouse_On", "GameExit_SimpleTooltips( true, " .. uiCount .. ", 1)" )
		-- addStackPool[uiCount]				:setTooltipEventRegistFunc( "GameExit_SimpleTooltips( true, " .. uiCount .. ", 1)" )
		-- addStackPool[uiCount]				:addInputEvent( "Mouse_Out", "GameExit_SimpleTooltips( false, " .. uiCount .. ", 1)" )

		charWorking[uiCount]				:SetShow( true )
		charPcDeliveryRemainTime[uiCount]	:SetShow( true )
		charLevelPool[uiCount]				:SetShow( true )
		charNamePool[uiCount]				:SetShow( true )
		charPositionPool[uiCount]			:SetShow( true )
		charEnterWaiting[uiCount]			:SetShow( true )
		
		isCharacterSlot[uiCount]			:addInputEvent( "Mouse_LUp", "Panel_GameExit_ClickCharSlot(" .. uiCount .. ")" )
		CharacterChangeButton[uiCount]		:addInputEvent( "Mouse_LUp", "Panel_GameExit_ChangeCharacter(".. idx ..")" )

		local selfProxy = getSelfPlayer()
		local characterNo_64 = toInt64( 0, 0 )
		if nil ~= selfProxy then
			 characterNo_64 = selfProxy:getCharacterNo_64()
		end

		CharacterChangeButton[uiCount]		:SetShow(false)
		if characterNo_64 == characterData._characterNo_s64 then
			isCharacterSlot[uiCount]			:SetMonoTone(false)
			isCharacterSlot[uiCount]			:SetIgnore(true)
			isCharacterSlotBG[uiCount]			:SetShow( true )
			if (startIdx + 4) <= (characterDatacount - 1) then
				_charSlotBG						:addInputEvent("Mouse_DownScroll", "refreshCharacterInfoData(" .. startIdx+1 .. ")")
			end
			_charSlotBG							:addInputEvent("Mouse_UpScroll", "refreshCharacterInfoData(" .. startIdx-1 .. ")")
			CharacterChangeButton[uiCount]		:SetShow(false)
			CharacterChangeButton[uiCount]		:SetIgnore(true)
			CharacterChangeButton[uiCount]		:SetEnable( false )
			normalStackPool[uiCount]			:SetFontColor( UI_color.C_FFE7E7E7 )
			-- addStackPool[uiCount]				:SetFontColor( UI_color.C_FFE7E7E7 )
			charWorking[uiCount]				:SetText( "" )			-- "접속중"
			charWorking[uiCount]				:SetFontColor(UI_color.C_FF6DC6FF)
			charPositionPool[uiCount]			:SetShow( false )
			-- local myRegionInfo	= getRegionInfoByPosition( selfProxy:get():getPosition() )
			-- charPositionPool[uiCount]			:SetText( myRegionInfo:getAreaName() )
			nowPlayCharaterSlotNo = uiCount
		else
			isCharacterSlot[uiCount]			:SetIgnore(false)
			isCharacterSlot[uiCount]			:SetMonoTone(true)
			if (startIdx + 4) <= (characterDatacount - 1) then
				isCharacterSlot[uiCount]			:addInputEvent("Mouse_DownScroll", "refreshCharacterInfoData(" .. startIdx+1 .. ")")
				_charSlotBG							:addInputEvent("Mouse_DownScroll", "refreshCharacterInfoData(" .. startIdx+1 .. ")")
			end
			isCharacterSlot[uiCount]			:addInputEvent("Mouse_UpScroll", "refreshCharacterInfoData(" .. startIdx-1 .. ")")
			_charSlotBG							:addInputEvent("Mouse_UpScroll", "refreshCharacterInfoData(" .. startIdx-1 .. ")")
			isCharacterSlotBG[uiCount]			:SetShow( false )
			normalStackPool[uiCount]			:SetFontColor( UI_color.C_FFC4BEBE )
			-- addStackPool[uiCount]				:SetFontColor( UI_color.C_FFC4BEBE )
			CharacterChangeButton[uiCount]		:SetIgnore(false)
			CharacterChangeButton[uiCount]		:SetEnable( true )
			charWorking[uiCount]				:SetText( char_WorkTxt )						-- 작업중 텍스트
			charWorking[uiCount]				:SetFontColor(UI_color.C_FFE7E7E7)
			charPcDeliveryRemainTime[uiCount]	:SetText( pcDeliveryRemainTimeText )
			
			local	removeTime	= getCharacterDataRemoveTime(idx)
			
			if nil ~= removeTime then
				charWorking[uiCount]			:SetText( PAGetString( Defines.StringSheet_GAME, "CHARACTER_DELETING" ) )			-- "삭제중"
				charEnterWaiting[uiCount]		:SetShow( false )	-- 삭제중인 캐릭터일 경우 바로 접속 가능 메시지 Off
				CharacterChangeButton[uiCount]	:SetEnable( false )	-- 교체 버튼 비활성
				charPositionPool[uiCount]		:SetShow( false )
			else
				charWorking[uiCount]			:SetText( char_WorkTxt )						-- 작업중 텍스트
			end
		end

		characterTicketNo = currentTicketNo - characterData._lastTicketNoByRegion
		if const_64.s64_m1 ~= firstTicketNo or (const_64.s64_m1 ~= characterData._lastTicketNoByRegion and const_64.s64_m1 < characterTicketNo) then		-- const_64.s64_m1
			charEnterWaiting[uiCount]:SetText(PAGetString( Defines.StringSheet_GAME, "LUA_GAMEEXIT_NOT_ENTER_TO_FIELD" ) )		-- 접속 대기 필요
		else
			if characterNo_64 == characterData._characterNo_s64 then
				charEnterWaiting[uiCount]:SetShow( false )
			-- else
			-- 	charEnterWaiting[uiCount]:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_GAMEEXIT_ENTER_TO_FIELD" ) )			-- 바로 접속 가능
			end
		end

		uiCount = uiCount + 1

		if 4 == uiCount then
			break
		end
	end

	if nil ~= nowPlayCharaterSlotNo then
		local basePosX = _charSlotBG:GetPosX()
		local basePosY = _charSlotBG:GetPosY()
		local posX = ( ( basePosX + isCharacterSlot[nowPlayCharaterSlotNo]:GetPosX()) + ( isCharacterSlot[nowPlayCharaterSlotNo]:GetSizeX()/2) ) - (_btn_ChangeChannel:GetSizeX()/2)
		local posY = ( basePosY + isCharacterSlot[nowPlayCharaterSlotNo]:GetPosY())+ isCharacterSlot[nowPlayCharaterSlotNo]:GetSizeY() - _btn_ChangeChannel:GetSizeY() - 10
		_btn_ChangeChannel:SetPosX( posX )
		_btn_ChangeChannel:SetPosY( posY )
		_btn_ChangeChannel:SetShow( true )
		_btn_ChangeChannel:addInputEvent("Mouse_LUp", "FGlobal_ChannelSelect_Show()")

		-- 보류 20150226
		local posX2 = ( ( basePosX + isCharacterSlot[nowPlayCharaterSlotNo]:GetPosX()) + ( isCharacterSlot[nowPlayCharaterSlotNo]:GetSizeX()/2) ) - (_btn_CharTransport:GetSizeX()/2)
		local posY2 = ( basePosY + isCharacterSlot[nowPlayCharaterSlotNo]:GetPosY())+ isCharacterSlot[nowPlayCharaterSlotNo]:GetSizeY() - _btn_CharTransport:GetSizeY() - 10		
		_btn_CharTransport:SetPosX( posX2 )
		_btn_CharTransport:SetPosY( posY2 + 37 )
		_btn_CharTransport:SetShow( true )
		_btn_CharTransport:addInputEvent("Mouse_LUp", "Panel_GameExit_Transport()")
		
	else
		_btn_ChangeChannel:SetShow( false )
		_btn_CharTransport:SetShow( false )
	end

	if (characterDatacount - 1) < (startIdx + 4) then
		_btn_NextCharPage:addInputEvent("Mouse_LUp", "")
		_btn_NextCharPage:SetShow(false)
	else
		-- _btn_NextCharPage:addInputEvent("Mouse_DownScroll", "refreshCharacterInfoData(" .. startIdx+1 .. ")")
		_btn_NextCharPage:addInputEvent("Mouse_LUp", "refreshCharacterInfoData(" .. startIdx+1 .. ")")
		_btn_NextCharPage:SetShow(true)
	end
	if 0 < startIdx then
		-- _btn_PreCharPage:addInputEvent("Mouse_UpScroll", "refreshCharacterInfoData(" .. startIdx-1 .. ")")
		_btn_PreCharPage:addInputEvent("Mouse_LUp", "refreshCharacterInfoData(" .. startIdx-1 .. ")")
		_btn_PreCharPage:SetShow(true)
	else
		_btn_PreCharPage:addInputEvent("Mouse_LUp", "")
		_btn_PreCharPage:SetShow(false)
	end
end


function confirm_MoveChannel_From_MessageBox()
	FGlobal_gameExit_saveCurrentData()
	gameExit_MoveChannel(_selectChannel);
	
	local	messageBoxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELWAIT_MSG") -- "채널 이동 대기중 입니다"
	local	messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_TITLE_MSG"), content = messageBoxMemo, functionYes = nil, functionClose = nil, exitButton = true, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData)
end

---------------------------------------------
--		교체 캐릭터의 상태 가져오기
function global_workTypeToStringSwap( workingType )
	local workingText

	if ePcWorkingType.ePcWorkType_Empty == workingType then
		workingText = ""		-- 대기 중
	elseif ePcWorkingType.ePcWorkType_Play == workingType then
		workingText = PAGetString( Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_PLAY" )		-- 플레이 중
	elseif ePcWorkingType.ePcWorkType_RepairItem == workingType then
		workingText = PAGetString( Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_REPAIRITEM" )	-- 수리 중
	elseif ePcWorkingType.ePcWorkType_Relax == workingType then
		workingText = PAGetString( Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_RELEX" )		-- 휴식 중
	elseif ePcWorkingType.ePcWorkType_ReadBook == workingType then
		workingText = PAGetString( Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_READBOOK" )	-- 책 읽는 중
	else
		_PA_ASSERT(false, "캐릭터 작업 타입이 추가 되었습니다. Lobby_New.lua 도 추가해 주어야 합니다.")
		workingText = "unKnown"
	end

	return workingText
end

------------------------------------------------------------
--			해당케릭터가 종료될때 메모및 현재 길찾기 정보를 기억해준다.
------------------------------------------------------------
function FGlobal_gameExit_saveCurrentData()
	getSelfPlayer():updateNavigationInformation(_addMessage:GetEditText())
	getSelfPlayer():saveCurrentDataForGameExit()
	ToClient_SaveUiInfo(true)
end

------------------------------------------------------------
--			버튼 눌렀을 때를 계속 감시한다
------------------------------------------------------------
function gameExit_UpdatePerFrame( deltaTime )
	if exit_Time > 0.0 then
		exit_Time = exit_Time - deltaTime

		local remainTime = math.floor( exit_Time )
		if prevTime ~= remainTime then
			if 0 > remainTime then
				remainTime = 0
			end

			prevTime = remainTime
			
			--------------------------------
			--		종료를 눌렀다
			if enum_ExitMode.eExitMode_GameExit == exitMode then
				_btn_NoticeMsg:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_EXIT", "remainTime", tostring(remainTime) ) )		-- {remainTime}초 뒤 게임 종료. <PAColor0xffff7383>클릭하면 취소됩니다.<PAOldColor>
				if prevTime <= 0 then
					exit_Time = -1
					_btn_NoticeMsg:SetText( PAGetString( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_PROGRESS" ) )				-- 잠시 후 종료 됩니다.
					doGameLogOut()
				end
				
			--------------------------------
			--		캐릭터 선택을 눌렀다
			elseif enum_ExitMode.eExitMode_BackCharacter == exitMode then
				_btn_NoticeMsg:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_CHARACTER_SELECT", "remainTime", tostring(remainTime) ) )	-- {remainTime}초 뒤 캐릭터 선택 화면으로 이동. <PAColor0xffff7383>클릭하면 취소됩니다.<PAOldColor>
				
				if prevTime <= 0 then
					exit_Time = -1

					_btn_NoticeMsg:SetText( PAGetString( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_GO_CHARACTERSELECT" ) )
				end
				
			--------------------------------
			--		교체를 눌렀다
			elseif enum_ExitMode.eExitMode_SwapCharacter == exitMode then
				_btn_NoticeMsg:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_CHARACTER_CHANGE", "remainTime", tostring(remainTime) ) )		-- {remainTime}초 뒤 캐릭터 교체. <PAColor0xffff7383>클릭하면 취소됩니다.<PAOldColor>
				--_btn_NoticeMsg:SetText( PAGetString( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_GO_SWAPCHARACTER" ) )
				if prevTime <= 0 then
					exit_Time = -1
					_btn_NoticeMsg:SetText( PAGetString( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_GO_SWAPCHARACTER" ) )
				end
			else
				_btn_NoticeMsg:SetShow( false )
			end
		end
	end
end

------------------------------------------------------------
--				선택 취소 보내기
------------------------------------------------------------
function Panel_GameExit_sendGameDelayExitCancel()
	if not _btn_NoticeMsg:GetShow() then
		return
	end

	--_PA_LOG( "asdf", " exit_Time : " .. tostring( exit_Time ) .. " exitMode : " .. tostring( exitMode ) .. " prevTime : " .. tostring ( prevTime ) )

	local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )			-- 안전지대에서는 딜레이가 없어진다.
	local cancelAble = true
	if ( ( exitMode == enum_ExitMode.eExitMode_BackCharacter) and true == regionInfo:get():isSafeZone() ) or prevTime < 2.0 then		-- 종료 취소는 2초 전까지는 안되게 하자. 종료중 피격시 연결해제 될 수 있다.(20150604:juicepia)
		cancelAble = false
	end
	
	if true == cancelAble then
		sendGameDelayExitCancel()
	end
	-- gameExitClick = false
	_btn_NoticeMsg:SetShow( false )
	_btn_selectCharacter:SetShow( true )
	_btn_gameExit:SetShow( true )
	_btn_cancel:SetShow( true )

	exit_Time = 0.0
	exitMode = -1
end

------------------------------------------------------------
--				캐릭터 슬롯을 클릭했다~!
------------------------------------------------------------
local prevClickIndex = 0
function Panel_GameExit_ClickCharSlot( idx )
	if prevClickIndex ~= idx then
		isCharacterSelect[prevClickIndex]:SetShow( false )
		CharacterChangeButton[prevClickIndex]:SetShow( false )
		isCharacterSlot[prevClickIndex]:ResetVertexAni()
		isCharacterSlot[prevClickIndex]:SetAlpha(1)
	end
	
	isCharacterSelect[idx]:SetShow( true )
	CharacterChangeButton[idx]:SetShow( true )
	isCharacterSlot[idx]:ResetVertexAni()
	isCharacterSlot[idx]:SetVertexAniRun( "Ani_Color_New", true )

	prevClickIndex = idx
end


------------------------------------------------------------
--				캐릭터 선택창을 눌렀다!
------------------------------------------------------------
function Panel_GameExit_ClickSelectCharacter()
	-- 러시아는 안전지대에서만 캐릭터 교체와, 캐릭터 선택창에 갈수 있어야합니다.
	if isGameTypeRussia() then
		local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
		if false == regionInfo:get():isSafeZone() then
			NotifyDisplay( PAGetString( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_DO_SAFEZONE" ) )
			return
		end
	end
	
	local contentStr = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_BACK_TO_CHARACTERSELECT_Q")	-- 캐릭터 선택 창으로 가시겠습니까?
	local messageboxData = { title = "", content = contentStr, functionYes = Panel_GameExit_CharSelect_Yes, functionCancel = MessageBox_Empty_function, priority = PP.PAUIMB_PRIORITY_LOW, exitButton = true }
	MessageBox.showMessageBox( messageboxData )
end

function Panel_GameExit_CharSelect_Yes()
	exitMode = enum_ExitMode.eExitMode_BackCharacter
	FGlobal_gameExit_saveCurrentData()
	sendCharacterSelect()
	
	-- gameExitClick = true

	_btn_selectCharacter:SetShow( false )
	_btn_gameExit:SetShow( false )
	_btn_cancel:SetShow( false )
	
	_btn_NoticeMsg:SetShow ( true )
	local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )			-- 안전지대에서는 딜레이가 없어진다.
	if true == regionInfo:get():isSafeZone() then
		_btn_NoticeMsg:SetIgnore( true )
		_btn_NoticeMsg:SetText( PAGetString( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_GO_CHARACTERSELECT" ) )
	else
		_btn_NoticeMsg:SetIgnore( false )
		_btn_NoticeMsg:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_CHARACTER_SELECT", "remainTime", logoutDelayTime ) )
	end
end

------------------------------------------------------------
--					캐릭터 교체를 눌렀다!!
------------------------------------------------------------
local changeIndex = 0
function Panel_GameExit_ChangeCharacter( index )
	changeIndex = index
	local characterData 			= getCharacterDataByIndex( index )
	if characterData._level < 5 then
		NotifyDisplay( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GAMEEXIT_DONT_CHAGECHARACTER", "iLevel", 4 ) )
		return
	end

	if isGameTypeRussia() then
		local selfProxy = getSelfPlayer()
		local regionInfo = getRegionInfoByPosition( selfProxy:get():getPosition() )
		if false == regionInfo:get():isSafeZone() then
			NotifyDisplay( PAGetString( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_DO_SAFEZONE" ) )
			return
		end
	end
	
	local	removeTime	= getCharacterDataRemoveTime(index)
	if nil ~= removeTime then
		NotifyDisplay( PAGetString( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_CHARACTER_DELETE" ) )
		return
	end
	
	local usabelSlotCount = getUsableCharacterSlotCount()
	--_PA_LOG("asdf", "usabelSlotCount : " .. tostring( usabelSlotCount ) .. " index : " .. tostring( index ) )
	if usabelSlotCount <= index then
		NotifyDisplay( PAGetString( Defines.StringSheet_GAME, "GAME_MESSAGE_CLOSE_CHARACTER_SLOT" ) )
		return
	end
	
	local contentString = ""
	if const_64.s64_m1 ~= characterData._lastTicketNoByRegion then
		contentString = PAGetString( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_WAIT" ) .. "\n"
	end

	if ePcWorkingType.ePcWorkType_Empty ~= characterData._pcWorkingType then
	
		if ePcWorkingType.ePcWorkType_ReadBook == characterData._pcWorkingType then
			contentString = contentString .. PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_WORKING_NOW_READ_BOOK")
		else
			contentString = contentString .. PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_WORKING_NOW_CHANGE_Q")
		end
		
	end
	
	local pcDeliveryRegionKey = characterData._arrivalRegionKey
	local serverUtc64 = getServerUtc64()

	if 0 ~= pcDeliveryRegionKey:get() and serverUtc64 < characterData._arrivalTime then
		contentString = PAGetString( Defines.StringSheet_GAME, "Lua_deliveryPerson_SelectPcDelivery" ) .. "\n"
	end
	
	if nil ~= contentString then
		contentString = contentString .. PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHARACTER_CHANGE_QUESTION")
		local messageboxData = { title = "", content = contentString, functionYes = Panel_GameExit_CharChange_Confirm, functionCancel = MessageBox_Empty_function, priority = PP.PAUIMB_PRIORITY_LOW } -- "작업중에 있습니다. 교체하겠습니까?"
		MessageBox.showMessageBox( messageboxData )
	else
		Panel_GameExit_CharChange_Confirm()
	end
end

function Panel_GameExit_Transport()
	FGlobal_DeliveryForGameExit_Show( true )
	-- Panel_GameExit:SetChildIndex(Panel_Window_DeliveryForGameExit:GetKey(), 9999 )
end

function Panel_GameExit_CharChange_Confirm()
	FGlobal_gameExit_saveCurrentData()
	local rv = swapCharacter_Select( changeIndex, true )

	if false == rv then
		--NotifyDisplay( PAGetString( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_NOT_SAFETYZONE" ) )
		return
	end
	
	-- gameExitClick = true

	exitMode = enum_ExitMode.eExitMode_SwapCharacter
	
	_btn_selectCharacter:SetShow( false )
	_btn_gameExit:SetShow( false )
	_btn_cancel:SetShow( false )
	
	_btn_NoticeMsg:SetShow ( true )
	_btn_NoticeMsg:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_CHARACTER_CHANGE", "remainTime", logoutDelayTime ) )
	--_btn_NoticeMsg:SetText( PAGetString( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_GO_SWAPCHARACTER" ) )
end

------------------------------------------------------------
--				게임 종료를 눌렀다!
------------------------------------------------------------
function Panel_GameExit_ClickGameOff()	-- 게임 종료 버튼을 눌렀다.
	_exitConfirm_TitleText		:SetText( PAGetString(Defines.StringSheet_GAME, "GAME_EXIT_MESSAGEBOX_TITLE") )
	_exitConfirm_ContentsString	:SetText( PAGetString(Defines.StringSheet_GAME, "PANEL_GAMEEXIT_TRAY_ASK") )

	if false == isFullscreenMode() then
		_exitConfirm_TrayString		:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXITTRAY_TRAYHELP") )	-- "트레이창으로 보내기가 체크되면, 닫기 버튼을 누를 때 게임이 종료 되는 것이 아니라 우측 하단 트레이창으로 게임이 최소화 됩니다."
		_exitConfirm_Chk_Tray		:SetCheck( false )
		_exitConfirm_Chk_Tray		:SetShow( true )
	else
		_exitConfirm_TrayString		:SetText( "" )	-- "트레이창으로 보내기가 체크되면, 닫기 버튼을 누를 때 게임이 종료 되는 것이 아니라 우측 하단 트레이창으로 게임이 최소화 됩니다."
		_exitConfirm_Chk_Tray		:SetCheck( false )
		_exitConfirm_Chk_Tray		:SetShow( false )
	end
	Panel_ExitConfirm:SetShow( true )
	_exitConfirm_Chk_Tray_2			:SetShow( false )
end

function FromClient_TrayIconMessageBox()	-- 최소화 버튼을 눌렀다.
	_exitConfirm_TitleText		:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXITCONFIRM_TITLE") )
	_exitConfirm_ContentsString	:SetText( PAGetString(Defines.StringSheet_GAME, "PANEL_GAMEEXIT_TRAY_ASK2") )
	_exitConfirm_TrayString		:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_TRAYLIMIT") ) -- "[트레이창으로 최소화하기]가 체크되어 있으면 게임이 트레이창으로 최소화됩니다. 최소화중에는 게임 접속이 유지되며 최소 리소스로 관리됩니다." ) -- 
	-- PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXITCONFIRM_DESC")
	-- PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXITTRAY_TRAYHELP2")
	-- "게임을 우측 하단 트레이창으로 최소화 합니다. 최소화 중에는 게임 접속이 유지 됩니다."

	_exitConfirm_Chk_Tray		:SetCheck( true )
	_exitConfirm_Chk_Tray		:SetShow( false )
	Panel_ExitConfirm			:SetShow( true )
	_exitConfirm_Chk_Tray_2		:SetShow( true )
end

function Panel_GameExit_Minimize()
	Panel_ExitConfirm:SetShow( false )

	-- if not Panel_GameExit:GetShow() then
		-- if _exitConfirm_Chk_Tray_2:IsCheck() then
			-- ToClient_UnCheckTrayIcon()
		-- else
			
		-- end
	-- end
end
function Panel_GameExit_MinimizeTray()
	if Panel_GameExit:GetShow() then
		if false == _exitConfirm_Chk_Tray:IsCheck() then
			Panel_GameExit_GameOff_Yes()
		else
			Panel_ExitConfirm:SetShow( false )
			GameExit_Close()
			ToClient_CheckTrayIcon()
		end
	else
		if _exitConfirm_Chk_Tray_2:IsCheck() then
			ToClient_CheckTrayIcon()
		else
			ToClient_UnCheckTrayIcon()
		end
		Panel_ExitConfirm:SetShow( false )
	end
end


-- function Panel_GameExit_ClickGameOff_Next()
-- 	if false == _exitConfirm_Chk_Tray:IsCheck() then
-- 		Panel_GameExit_GameOff_Yes()
-- 	else
-- 		ToClient_CheckTrayIcon()
-- 		Panel_ExitConfirm:SetShow( false )

-- 		if Panel_GameExit:GetShow() then
-- 			GameExit_Close()
-- 		end
-- 	end
-- end

function Panel_GameExit_GameOff_Yes()
	exitMode = enum_ExitMode.eExitMode_GameExit
	FGlobal_gameExit_saveCurrentData()
	
	local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )			-- 안전지대에서는 딜레이가 없어진다.
	if true == regionInfo:get():isSafeZone() then
		_btn_NoticeMsg:SetText( PAGetString( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_PROGRESS" ) )
		_btn_NoticeMsg:SetIgnore( true )
	else
		_btn_NoticeMsg:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_EXIT", "remainTime", logoutDelayTime ) )
		_btn_NoticeMsg:SetIgnore( false )
	end

	sendBeginGameDelayExit( enum_ExitMode.eExitMode_SwapCharacter == exitMode )

	_btn_selectCharacter:SetShow( false )
	_btn_gameExit:SetShow( false )
	_btn_cancel:SetShow( false )
	
	-- gameExitClick = true
	
	_btn_NoticeMsg:SetShow ( true )
end

-- 게임 종료
function doGameLogOut()
	--Panel_GameExit:SetShow( false )
	SetUIMode( Defines.UIMode.eUIMode_Default )
	sendGameLogOut()
end

-- 서버로 부터 지연 종료 처리 시간을 받음
function setGameExitDelayTime( delayTime )
	if false == Panel_GameExit:GetShow() then
		return
	end

	exit_Time = delayTime
	
	_btn_NoticeMsg:SetIgnore( false )

	if 0.0 == exit_Time then
		if enum_ExitMode.eExitMode_SwapCharacter == exitMode then
			_btn_NoticeMsg:SetText( PAGetString( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_GO_SWAPCHARACTER" ) )
		elseif enum_ExitMode.eExitMode_GameExit == exitMode then
			_btn_NoticeMsg:SetText( PAGetString( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_PROGRESS" ) )
		elseif enum_ExitMode.eExitMode_BackCharacter == exitMode then
			_btn_NoticeMsg:SetText( PAGetString( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_GO_CHARACTERSELECT" ) )
		end
	else
		if enum_ExitMode.eExitMode_SwapCharacter ~= exitMode then
			-- _textExitQuestionMsg:SetText( PAGetString( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_CANCEL" ) )
			_btn_NoticeMsg:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_CHARACTER_CHANGE", "remainTime", tostring(delayTime) ) )
		elseif enum_ExitMode.eExitMode_GameExit == exitMode then
			_btn_NoticeMsg:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_EXIT", "remainTime", tostring(delayTime) ) )
		elseif enum_ExitMode.eExitMode_BackCharacter == exitMode then
			_btn_NoticeMsg:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_CHARACTER_SELECT", "remainTime", tostring(delayTime) ) )
		end		
	end
end

------------------------------------------------------------
--				게임 종료창 SHOW TOGGLE
------------------------------------------------------------
function characterInfoRequest()
	--swapCharacter_sendLoginUserFieldServerReq()
end

local prevUIMode = 0
function GameExitShowToggle( isAttacked )
	if ( CppEnums.EProcessorInputMode.eProcessorInputMode_ChattingInputMode == UI.Get_ProcessorInputMode() ) then 
		return
	end
	
	local currentUIMode = GetUIMode()
	if currentUIMode == Defines.UIMode.eUIMode_Gacha_Roulette 
		or currentUIMode == Defines.UIMode.eUIMode_DeadMessage
	then
		return
	end

	if ( ToClient_cutsceneIsPlay() ) then
		return
	end
	
	if( isFlushedUI() ) then
		return
	end		

	if isAttacked then	-- gameExitClick and not isAttacked 
		return
	end
	
	if isGameTypeRussia() then
		if isAttacked then
			local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )			-- 안전지대에서는 공격받아도 취소가 되면 안된다.
			if regionInfo:get():isSafeZone() then
				return
			end
		end
	end

	local isShow = Panel_GameExit:IsShow()
	
	if (true == isShow) then
		if _btn_NoticeMsg:GetShow() then
			return
		end
		Panel_GameExit:SetShow( false, true )
		
		SetUIMode( prevUIMode )
		UI.Set_ProcessorInputMode(CppEnums.EProcessorInputMode.eProcessorInputMode_GameMode)
		
		if -1 ~= exitMode then
			Panel_GameExit_sendGameDelayExitCancel()
		end

		local focusEdit = GetFocusEdit()
		if ( nil ~= focusEdit ) and ( focusEdit:GetKey() == _addMessage:GetKey() ) then
			ClearFocusEdit()
		end

		if Panel_ExitConfirm:GetShow() then
			_exitConfirm_Chk_Tray:	SetCheck( false )
			Panel_ExitConfirm:		SetShow( false )
		end

	else
		prevUIMode = GetUIMode()
		SetUIMode( Defines.UIMode.eUIMode_GameExit )
		Panel_GameExit:SetShow( true, true )
		sendWaitingListOfMyCharacters()
		
		refreshCharacterInfoData( 0 )
		--swapCharacter_sendLoginUserFieldServerReq()
		
		ToClient_RequestRecentJournalByCount(5)		-- 최근 5개의 일지내역을 요청
		ToClient_RequestCharacterEnchantFailCount()	-- 스택 정보를 요청한다.

		-- { 기억 저장 }
			local questWrapper
			local questNo0 = getSelfPlayer():get():getLastCompleteQuest(0)
			questWrapper = ToClient_getQuestWrapper( questNo0 )
			if ( nil ~= questWrapper ) then
				_completeQuest		:SetText(questWrapper:getTitle())
			else
				_completeQuest		:SetText("-")
			end

			local questNo1 = getSelfPlayer():get():getLastCompleteQuest(1)
			questWrapper = ToClient_getQuestWrapper( questNo1 )
			if ( nil ~= questWrapper ) then
				_progressingQuest	:SetText(questWrapper:getTitle())
			else
				_progressingQuest	:SetText("-")
			end
			
			_addMessage				:SetEditText(getSelfPlayer():get():getUserMemo())
		-- }
	end
	
	local selfProxy = getSelfPlayer()
	local characterNo_64 = toInt64( 0, 0 )

	if nil ~= selfProxy then
		 characterNo_64 = selfProxy:getCharacterNo_64()
	end
	
	----------------------------------------
	--	선택했던 놈의 효과를 강제로 끈다!
	local uiCount = 0
	local characterDatacount = getCharacterDataCount()
	-- 현재 슬롯 넘버, 캐릭터 개수,
	for index = 0, 3, 1 do
		local characterData = getCharacterDataByIndex( index )								-- 캐릭터 정보 데이터 바인드
		if nil == characterData then
			return
		end

		if characterNo_64 ~= characterData._characterNo_s64 then
			isCharacterSlot[index]:ResetVertexAni()
			isCharacterSelect[index]:SetShow( false )
			CharacterChangeButton[index]:SetShow( false )
		end
		if 4 == uiCount then
			break
		end
		uiCount = uiCount + 1
	end
	local uiCount = 0
	local characterDatacount = getCharacterDataCount()
	for charIndex = 0, 3, 1  do
		local characterData	= getCharacterDataByIndex( charIndex )								-- 캐릭터 정보 데이터 바인드
		if nil == characterData then
			return
		end

		if nil ~= characterData and characterNo_64 ~= characterData._characterNo_s64 then
			charEnterWaiting[ uiCount ]:SetText( "" )		-- PAGetString( Defines.StringSheet_GAME, "LUA_GAMEEXIT_ENTER_TO_FIELD" )
			uiCount = uiCount + 1
		end
		if 4 == uiCount then
			break
		end
	end
end
----------------------------------
---- 캐릭터 별로 스택 정보를 받아온다.
----------------------------------
function FromClient_ResponseEnchantFailCountOfMyCharacters()
	local uiCount = 0
	local characterDatacount = getCharacterDataCount()
	normalStack	= {}
	valksStack	= {}
	for index = 0, characterDatacount-1, 1 do
		local characterData = getCharacterDataByIndex( index )								-- 캐릭터 정보 데이터 바인드
		if nil == characterData then
			return
		end

		local defaultCount			= characterData._enchantFailCount
		local valksCount			= characterData._valuePackCount
		local characterNo_64		= characterData._characterNo_s64
		normalStack[characterNo_64]	= defaultCount
		valksStack[characterNo_64]	= valksCount
	end
end

function GameExit_SimpleTooltips( isShow, index, tipType )
	local name, desc, control = nil, nil, nil
	if 0 == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_NORMALSTACK_TOOLTIP_NAME") --  "잠재력 돌파 확률 증가"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_NORMALSTACK_TOOLTIP_DESC") -- "해당 캐릭터의 잠재력 돌파 확률 증가 횟수입니다."
		control = normalStackPool[index]
	-- elseif 1 == tipType then
	-- 	name = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_ADDSTACK_TOOLTIP_NAME") -- "발크스의 외침 확률 증가"
	-- 	desc = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_ADDSTACK_TOOLTIP_DESC") -- "해당 캐릭터의 발크스의 외침 확률 증가 횟수입니다."
	-- 	control = addStackPool[index]
	end
	registTooltipControl(control, Panel_Tooltip_SimpleText)

	if isShow == true then
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end

end

function GameExit_Close()
	-- if gameExitClick then
	-- 	return
	-- end

	-- if not Panel_GameExit:GetShow() and Panel_ExitConfirm:GetShow() then
		-- Panel_ExitConfirm:SetShow( false )
		-- return
	-- end

	if _btn_NoticeMsg:GetShow() then
		return
	end

	Panel_GameExit:SetShow( false, true )
	
	SetUIMode( prevUIMode )
	UI.Set_ProcessorInputMode(CppEnums.EProcessorInputMode.eProcessorInputMode_GameMode)
	
	if -1 ~= exitMode then
		Panel_GameExit_sendGameDelayExitCancel()
	end

	local focusEdit = GetFocusEdit()
	if ( nil ~= focusEdit ) and ( focusEdit:GetKey() == _addMessage:GetKey() ) then
		ClearFocusEdit()
	end

	if Panel_ExitConfirm:GetShow() then
		_exitConfirm_Chk_Tray:	SetCheck( false )
		Panel_ExitConfirm:		SetShow( false )
	end

	local selfProxy = getSelfPlayer()
	local characterNo_64 = toInt64( 0, 0 )

	if nil ~= selfProxy then
		 characterNo_64 = selfProxy:getCharacterNo_64()
	end
	
	----------------------------------------
	--	선택했던 놈의 효과를 강제로 끈다!
	local uiCount = 0
	local characterDatacount = getCharacterDataCount()
	-- 현재 슬롯 넘버, 캐릭터 개수,
	for index = 0, 3, 1 do
		local characterData = getCharacterDataByIndex( index )								-- 캐릭터 정보 데이터 바인드
		if nil == characterData then
			return
		end
		if characterNo_64 ~= characterData._characterNo_s64 then
			isCharacterSlot[index]:ResetVertexAni()
			isCharacterSelect[index]:SetShow( false )
			CharacterChangeButton[index]:SetShow( false )
		end
		if 4 == uiCount then
			break
		end
		uiCount = uiCount + 1
	end
	local uiCount = 0
	local characterDatacount = getCharacterDataCount()
	for charIndex = 0, 3, 1  do
		local characterData	= getCharacterDataByIndex( charIndex )								-- 캐릭터 정보 데이터 바인드
		if nil == characterData then
			return
		end

		if nil ~= characterData and characterNo_64 ~= characterData._characterNo_s64 then
			charEnterWaiting[ uiCount ]:SetText( "-" )		-- PAGetString( Defines.StringSheet_GAME, "LUA_GAMEEXIT_ENTER_TO_FIELD" )
			uiCount = uiCount + 1
		end
		if 4 == uiCount then
			break
		end
	end

	if true == isTrayMode then
		ToClient_UnCheckTrayIcon()
		Panel_ExitConfirm:SetShow( false )
	end
end

function FromClient_RecentJournal_Update()
	journalContents:SetText("")
	
	-- 최근 5개의 일지를 가져온다.
	local journal_Count	= ToClient_GetRecentJournalCount()
	if 0 < journal_Count then
		for journal_Idx = 0, journal_Count - 1, 1 do
			local journalWrapper =	ToClient_GetRecentJournalByIndex( journal_Idx )
			local stringData = "[" .. string.format( "%.02d", journalWrapper:getJournalHour() ) .. ":" .. string.format( "%.02d", journalWrapper:getJournalMinute() ) .. "] " .. journalWrapper:getName()
			if (0 == journal_Idx) then
				journalContents:SetTextMode( UI_TM.eTextMode_LimitText )
				journalContents:SetText( stringData )
			else
				journalContents:SetTextMode( UI_TM.eTextMode_LimitText )
				journalContents:SetText( journalContents:GetText() .. "\n" .. stringData )
			end
			journalFrameContents:SetSize( journalFrameContents:GetSizeX(), journalContents:GetTextSizeY() )
		end
	else
		journalContents:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_JOURNALCONTENTS") ) -- "- 일지에 기록된 내용이 없습니다." )
	end
	
	if journalFrame:GetSizeY() < journalFrameContents:GetSizeY() then
		journalFrameScroll:SetShow( true )
	else
		journalFrameScroll:SetShow( false )
	end

	journalFrame:UpdateContentScroll()
	journalFrame:UpdateContentPos()
end

function GameExit_onScreenResize()
	Panel_GameExit:ComputePos()
	_block_BG:SetSize( getScreenSizeX()+50, getScreenSizeY()+50 )
	_block_BG:SetHorizonCenter()
	_block_BG:SetVerticalMiddle()
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------

Panel_GameExit_Initialize()

local registEventHandler = function()
	_btn_cancel:				addInputEvent( "Mouse_LUp", "GameExit_Close()" )								-- 취소 버튼
	_btn_winClose:				addInputEvent( "Mouse_LUp", "GameExit_Close()" )								-- x 버튼
	_btn_gameExit:				addInputEvent( "Mouse_LUp", "Panel_GameExit_ClickGameOff()" )		-- 클릭으로 호출
	_btn_selectCharacter:		addInputEvent( "Mouse_LUp", "Panel_GameExit_ClickSelectCharacter()" )
	_btn_NoticeMsg:				addInputEvent( "Mouse_LUp", "Panel_GameExit_sendGameDelayExitCancel()" )			-- 알림 메시지 x초 후 XXX 합니다. 취소하려면 클릭

	_buttonQuestion:			addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelGameExit\" )" )									-- 물음표 좌클릭
	_buttonQuestion:			addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"PanelGameExit\", \"true\")" )					-- 물음표 마우스오버
	_buttonQuestion:			addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"PanelGameExit\", \"false\")" )					-- 물음표 마우스아웃

	_exitConfirm_Btn_Confirm:	addInputEvent( "Mouse_LUp", "Panel_GameExit_MinimizeTray()" )	-- Panel_GameExit_ClickGameOff_Next
	_exitConfirm_Btn_Cancle:	addInputEvent( "Mouse_LUp", "Panel_GameExit_Minimize()" )
end

local registMessageHandler = function()
	Panel_GameExit:RegisterUpdateFunc("gameExit_UpdatePerFrame")
	registerEvent("EventGameExitDelayTime",								"setGameExitDelayTime")
	registerEvent("EventReceiveEnterWating",							"refreshCharacterInfoData")	--refreshCharacterInfoData	-- GameExitShowToggle
	registerEvent("EventGameWindowClose",								"GameExitShowToggle()")
	-- registerEvent("EventUpdateServerInformationForExit",				"EventUpdateServerInformation_Exit")
	registerEvent("FromClient_RecentJournal_Update",					"FromClient_RecentJournal_Update")
	registerEvent("FromClient_TrayIconMessageBox",						"FromClient_TrayIconMessageBox")
	registerEvent("FromClient_ResponseEnchantFailCountOfMyCharacters",	"refreshCharacterInfoData")
	registerEvent("onScreenResize",							"GameExit_onScreenResize")
end

registEventHandler()
registMessageHandler()

