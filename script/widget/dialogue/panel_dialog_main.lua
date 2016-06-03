-------------------------- Panel 설정 -------------------------
Panel_Npc_Dialog:SetShow(false)
Panel_Npc_Dialog:setGlassBackground(true)
Panel_Npc_Dialog:setFlushAble(false)
Panel_Npc_Dialog:RegisterShowEventFunc( true,	'NpcDialogShowAni()' )
Panel_Npc_Dialog:RegisterShowEventFunc( false,	'NpcDialogHideAni()' )


---------------------------------------------------------------

-------------------------- Local 변수 설정 --------------------

local 	UCT 						= CppEnums.PA_UI_CONTROL_TYPE
local 	UI_ANI_ADV					= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local 	UI_DS			 			= CppEnums.DialogState
local 	UI_color					= Defines.Color
local 	UI_TM 						= CppEnums.TextMode
local	UI_BTN_TYPE					= CppEnums.DialogButtonType
local 	getScrX 					= getScreenSizeX()
local 	getScrY 					= getScreenSizeY()
		
local	_mainDialog					= {}
local	_currentLine				= 0
local	_maxLine					= 0
local 	_equipRewardCount 			= 0
local 	giftIcon 					= {}
local 	_ignoreShowDialog 			= false
local	_doConfirmIndex				= 0
local	_isQuestComplete			= false

-- 다이얼로그가 켜지고 처음 tooltip이 켜질때 true임.
local 	isFirstShowTooltip 			= true
isFirstTime_MeetDarkSpirit 	= 0
-- 0 : 처음 만났네
-- 1 : 이제 레벨 2가 되었어
-- 2 : 이제 그만해
local _math_AddVectorToVector = Util.Math.AddVectorToVector
local _math_MulNumberToVector = Util.Math.MulNumberToVector

local	isAuctionDialog				= false
local   isReContactDialog			= false
local	isDialogFunctionQuest		= false
local	_questDialogButtonIndex		= -1
local	isExchangeButtonIndex		= {}
local	isPromiseToken				= {}
local	_exchangalbeButtonIndex		= -1
local	_skillTutorial				= false
local	handleClickedQuestComplete	= false
local	nextQuestFunctionBtnClick	= {}

local 	uv = {
				[0] = 	{ _fileName = "New_UI_Common_forLua/Widget/HumanRelations/Compensation_00.dds", x1 = 1, 	y1 = 1,  	x2 = 61, 	y2 = 61 },
						{ _fileName = "New_UI_Common_forLua/Widget/HumanRelations/Compensation_00.dds", x1 = 62, 	y1 = 1,  	x2 = 122, 	y2 = 61 },
						{ _fileName = "New_UI_Common_forLua/Widget/HumanRelations/Compensation_00.dds", x1 = 62, 	y1 = 62, 	x2 = 122, 	y2 = 122 },
						{ _fileName = "New_UI_Common_forLua/Widget/HumanRelations/Compensation_00.dds", x1 = 1, 	y1 = 62,  	x2 = 61, 	y2 = 122 },
						{ _fileName = "New_UI_Common_forLua/Widget/HumanRelations/Compensation_00.dds", x1 = 62, 	y1 = 62,  	x2 = 122, 	y2 = 122 },
						{ _fileName = "New_UI_Common_forLua/Widget/HumanRelations/Compensation_02.dds", x1 = 1,		y1 = 1,		x2 = 61,	y2 = 61 },
}

local _shopType = {
					eShopType_None			= 0, 
					eShopType_Potion		= 1, 	-- 물약상인
					eShopType_Weapon		= 2,	-- 무기상인
					eShopType_Jewel			= 3,	-- 보석상인
					eShopType_Furniture 	= 4,	-- 가구상인
					eShopType_Collect 		= 5,	-- 재료상인
					eShopType_Fish 			= 6,	-- 물고기상인
					eShopType_Worker		= 7,	-- 작업감독관
					eShopType_Alchemy		= 8,	-- 연금술사
					eShopType_Cook			= 9,	-- 요리상인
					eShopType_PC			= 10,	-- pc방 상인
					eShopType_Grocery 		= 11,	-- 잡화상인
					eShopType_RandomShop	= 12, 	-- 랜덤상인
					eShopType_DayRandomShop	= 13, 	-- Day 랜덤상인
					eShopType_Count			= 14,
					}                     

-- 다이얼로그 위치값 저장을 위한 로컬 변수
local _dialogIndex = 0

---------------------------------------------------------------

-------------------------- Control 획득 -----------------------
local _uiNpcTitle					= UI.getChildControl( Panel_Npc_Dialog, "Static_NPC" )
local _uiNpcName					= UI.getChildControl( Panel_Npc_Dialog, "Static_NPC_Name" )
local _uiNpcDialog					= UI.getChildControl( Panel_Npc_Dialog, "Static_NPC_Content")
local _uiDialogButton				= {}
local _uiDialogIcon					= {}
local _uiFuncButton 				= {}
local _uiFuncBG 					= {}
local _uiNoticeNeedInfo				= {}
local _uiNeedWpAni					= {}
local _uiIntimacyIcon				= {}																		-- 친밀도 보상 아이콘 콘트롤 복사 예정
local _styleNormalTalkButton		= UI.getChildControl( Panel_Npc_Dialog, "style_Button_Original" )
local _styleExploreTalkButton		= UI.getChildControl( Panel_Npc_Dialog, "style_Button_Explore" )
local _styleDialogButtonIcon		= UI.getChildControl( Panel_Npc_Dialog, "Static_DialogButtonIcon" )
local _styleNoticeNeedInfo 			= UI.getChildControl( Panel_Npc_Dialog, "StaticText_Notice")
local _styleNeedWpAni 				= UI.getChildControl( Panel_Npc_Dialog, "Static_NeedWpAni")
local _SpacebarIcon					= UI.getChildControl( Panel_Npc_Dialog, "StaticText_Spacebar")
local _uiNextButton					= UI.getChildControl( Panel_Npc_Dialog, "Button_Next")
local _uiButtonExit 				= UI.getChildControl( Panel_Npc_Dialog, "Button_Exit")		-- 대화 종료 버튼
local _uiButtonBack 				= UI.getChildControl( Panel_Npc_Dialog, "Button_Back")		-- 대화 초기 화면 버튼

local _txt_intimacy					= UI.getChildControl( Panel_Npc_Dialog, "StaticText_Intimacy" )
local _intimacyFruitageValue		= UI.getChildControl( Panel_Npc_Dialog, "StaticText_Fruitage_Value" )
local _intimacyCircularProgress		= UI.getChildControl( Panel_Npc_Dialog, "CircularProgress_Current" )
local _intimacyProgressBG			= UI.getChildControl( Panel_Npc_Dialog, "Static_ProgressBG" )
local _intimacyGiftIcon				= UI.getChildControl( Panel_Npc_Dialog, "Static_GiftIcon" )
local _intimacyButtonIcon			= UI.getChildControl( Panel_Npc_Dialog, "Static_Intimacy" )		-- 친밀도 보상 아이콘 콘트롤

local intimacyNotice 				= UI.getChildControl ( Panel_Npc_Dialog, "Static_Notice")
local intimacyNoticeStyle 			= UI.getChildControl ( Panel_Npc_Dialog, "StaticText_IntimacyNotice")

local _txt_EnchantHelp 				= UI.getChildControl ( Panel_Npc_Dialog, "StaticText_EnchantMsg" )
local _txt_EnchantHelp_Desc 		= UI.getChildControl ( Panel_Npc_Dialog, "StaticText_EnchantMsg_Desc" )
local _txt_SocketHelp				= UI.getChildControl ( Panel_Npc_Dialog, "StaticText_SocketMsg" )
local _txt_SocketHelp_Desc			= UI.getChildControl ( Panel_Npc_Dialog, "StaticText_SocketMsg_Desc" )

local giftNotice 					= UI.getChildControl ( Panel_Npc_Dialog, "StaticText_GiftNotice")
local _wpHelp 						= UI.getChildControl( Panel_Npc_Dialog, "StaticText_BubbleBox" )
local _uiHalfLine					= UI.getChildControl( Panel_Npc_Dialog, "Static_HalfLine" )

local _prevPageButton				= UI.getChildControl( Panel_Npc_Dialog, "Button_PrevPage" )
local _nextPageButton				= UI.getChildControl( Panel_Npc_Dialog, "Button_NextPage" )
local _pageValue					= UI.getChildControl( Panel_Npc_Dialog, "StaticText_PageValue" )
local _scrollControl				= UI.getChildControl( Panel_Npc_Dialog, "Static_ContolForScroll" )


for index = 0, 3, 1 do
	_uiDialogButton[index] = UI.getChildControl( Panel_Npc_Dialog, "Button_Dialog_" .. tostring(index) )
	_uiDialogButton[index]:addInputEvent( "Mouse_LUp", "HandleClickedDialogButton("..index..")" )
	_uiDialogButton[index]:SetPosX ( getScrX / 2 - 175 )
	
	_uiDialogIcon[index] = UI.createControl( UCT.PA_UI_CONTROL_STATIC, _uiDialogButton[index], "StaticText_DialogIcon_"..tostring(index))
	CopyBaseProperty( _styleDialogButtonIcon, _uiDialogIcon[index] )
	_uiDialogIcon[index]:SetPosX( 5 )
	_uiDialogIcon[index]:SetPosY( 1 )
end

for index = 0, 5, 1 do
	_uiFuncButton[index] = UI.getChildControl( Panel_Npc_Dialog, "Button_Menu_" .. tostring(index) )
	_uiFuncButton[index]:addInputEvent( "Mouse_LUp", "HandleClickedFuncButton(".. index ..")")
	_uiFuncButton[index]:SetPosX( ( index * 180 ) + 200 )
	_uiFuncButton[index]:SetPosY( 38 )
	_uiFuncButton[index]:SetTextVerticalCenter()
	_uiFuncButton[index]:SetTextHorizonCenter()
	_uiFuncButton[index]:SetTextMode( UI_TM.eTextMode_LimitText )
end

for index = 0, 5, 1 do
	_uiFuncBG[index] = UI.getChildControl( Panel_Npc_Dialog, "Static_MenuAni_" .. tostring(index) )
end

for index = 0, 3, 1 do
	_uiNoticeNeedInfo[index] = UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT, Panel_Npc_Dialog, "StaticText_Notice_"..tostring(index))
	CopyBaseProperty( _styleNoticeNeedInfo, _uiNoticeNeedInfo[index] );
	_uiNoticeNeedInfo[index]:SetPosX ( getScrX / 2 + 175 )
	_uiNoticeNeedInfo[index]:SetPosY ( _uiDialogButton[index]:GetPosY() )
end

for index = 0, 3, 1 do
	_uiNeedWpAni[index] = UI.createControl( UCT.PA_UI_CONTROL_STATIC, Panel_Npc_Dialog, "Static_NeedWpAni_"..tostring(index))
	CopyBaseProperty( _styleNeedWpAni, _uiNeedWpAni[index] );
	_uiNeedWpAni[index]:SetPosX ( getScrX / 2 - 170 )
	_uiNeedWpAni[index]:SetPosY ( _uiDialogButton[index]:GetPosY() )
end

-- 친밀도 보상 콘트롤 생성
for index = 0, 3, 1 do
	_uiIntimacyIcon[index] = UI.createControl( UCT.PA_UI_CONTROL_STATIC, Panel_Npc_Dialog, "Static_Intimacy_Button_"..tostring(index))
	CopyBaseProperty( _intimacyButtonIcon, _uiIntimacyIcon[index] );
	--_uiIntimacyIcon[index]:SetPosX ( getScrX / 2 - 170 )
	--_uiIntimacyIcon[index]:SetPosY ( _uiDialogButton[index]:GetPosY() + 1 )
end

local intimacyNoticeText 			= UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT, intimacyNotice, "intimacyNoticeText")
CopyBaseProperty( intimacyNoticeStyle, intimacyNoticeText )
UI.deleteControl(intimacyNoticeStyle)
intimacyNoticeStyle = nil
intimacyNoticeText:SetSpanSize(10,0)

_wpHelp:SetFontAlpha(0)
_wpHelp:SetAlpha(0)
_styleNoticeNeedInfo:SetAlpha(0)
_styleNoticeNeedInfo:SetFontAlpha(0)

_styleNormalTalkButton:SetShow(false)
_styleExploreTalkButton:SetShow(false)

_uiNextButton:addInputEvent( "Mouse_LUp", "HandleClickedDialogNextButton()" )
_uiNextButton:SetPosX ( getScrX / 2 - 175 )
_SpacebarIcon:SetPosX ( _uiDialogButton[0]:GetPosX() + _uiDialogButton[0]:GetSizeX() + 10 )
local defaultDialogBtnSizeX = _uiDialogButton[0]:GetSizeX()

-- r 버튼 아이콘 포지션 저장
local _rBtnPosX = _uiDialogButton[0]:GetPosX() + _uiDialogButton[0]:GetSizeX() - _SpacebarIcon:GetSizeX() - 5
local _rBtnPosY = _uiDialogButton[0]:GetPosY()

_uiButtonExit:addInputEvent( "Mouse_On", "Dialog_EtcButtonToolTips( true," .. 0 .. ")" )
_uiButtonExit:addInputEvent( "Mouse_Out", "Dialog_EtcButtonToolTips( false," .. 0 .. ")" )
function Button_Exit()
	_uiButtonExit:addInputEvent( "Mouse_LUp", "FGlobal_HideDialog()" )
	--_uiButtonExit:SetHorizonRight()
	_uiButtonExit:SetVerticalBottom()
	_uiButtonExit:SetTextVerticalTop()
	_uiButtonExit:SetTextHorizonLeft()
	_uiButtonExit:SetSpanSize(10,192)
	local btnExitSizeX			= _uiButtonExit:GetSizeX()+23
	local btnExitTextPosX		= (btnExitSizeX - (btnExitSizeX/2) - ( _uiButtonExit:GetTextSizeX() / 2 ))
	_uiButtonExit:SetTextSpan( btnExitTextPosX, 7 )
end

_uiButtonBack:addInputEvent( "Mouse_On", "Dialog_EtcButtonToolTips( true," .. 1 .. ")" )
_uiButtonBack:addInputEvent( "Mouse_Out", "Dialog_EtcButtonToolTips( false," .. 1 .. ")" )
--추출 메뉴 호출로 임시 변경
function Button_Back()
	_uiButtonBack:addInputEvent( "Mouse_LUp", "HandleClickedBackButton()" )
	-- _uiButtonBack:SetHorizonLeft()
	_uiButtonBack:SetVerticalBottom()
	_uiButtonBack:SetTextVerticalTop()
	_uiButtonBack:SetTextHorizonLeft()
	_uiButtonBack:SetSpanSize(10,192)
	local btnBackSizeX			= _uiButtonBack:GetSizeX()+23
	local btnBackTextPosX		= (btnBackSizeX - (btnBackSizeX/2) - ( _uiButtonBack:GetTextSizeX() / 2 ))
	_uiButtonBack:SetTextSpan( btnBackTextPosX, 7 )	
end
---------------------------------------------------------------


-------------------------- 대화창 --------------------

function NpcDialogShowAni()
	-- ♬ 말을 걸었을 때 사운드 추가
	audioPostEvent_SystemUi(01,19)

	UIAni.fadeInSCR_Up(Panel_Npc_Dialog)
	Button_Exit()
	Button_Back()
	_uiNpcDialog:SetVerticalMiddle()
	Inventory_PosSaveMemory()	-- 대화창이 호출될 때 인벤 위치 저장
end

function NpcDialogHideAni()
	-- ♬  대화 종료했을 때 사운드 추가
	audioPostEvent_SystemUi(01,20)

	Panel_Npc_Dialog:ResetVertexAni()
	Panel_Npc_Dialog:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	local Ani1 = Panel_Npc_Dialog:addColorAnimation( 0.0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	Ani1:SetStartColor( UI_color.C_FFFFFFFF )
	Ani1:SetEndColor( UI_color.C_00FFFFFF )
	Ani1:SetStartIntensity( 3.0 )
	Ani1:SetEndIntensity( 1.0 )
	Ani1.IsChangeChild = true
	Ani1:SetHideAtEnd(true)
	Ani1:SetDisableWhileAni(true)
end

-- 대화 내용 Update
local Dialog_updateMainDialog = function()
	-- 퀘스트가 4개를 초과할 경우 다음페이지를 눌렀을때 
	-- (4 * 페이지번호)의 인덱스가 적용되므로 _dialogIndex 초기화를 해야 함(20141215:crazy4idea)
	_dialogIndex = 0	
	_uiNpcDialog:SetText(_mainDialog[_currentLine])
	if(_currentLine < _maxLine) then
		_uiNextButton:SetShow(true)
		_SpacebarIcon:SetShow(true)
		Dialog_updateButtons(false)
		_SpacebarIcon:SetPosX( _rBtnPosX + _SpacebarIcon:GetSizeX() + 10)
		_SpacebarIcon:SetPosY( _rBtnPosY )
	else
		_uiNextButton:SetShow(false)
		_SpacebarIcon:SetShow(false)
		Dialog_updateButtons(true)
		
		if ( isFirstTime_MeetDarkSpirit == 0 ) or ( isFirstTime_MeetDarkSpirit == 1 ) then
			firstTime_MeetDarkSpirit()
		end
	end
	_SpacebarIcon:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_INTERACTION_FUNCTIONKEY") )
end

-- 대화창 열기
function FromClient_ShowDialog(isFlushUI)

	-- 인터렉션 r키와 종료 버튼을 시간차로 누를경우 대화창과 동시에 종료 창이 뜨게 되어 움직이면서 종료가 될수도 있기에
	-- 어뷰징이 크므로 발생자체를 할 수 없도록 체크를 해서 막자 ㅜㅜ(20140403:juicepia)
	ToClient_SaveUiInfo( true )
	
	if Panel_QuestInfo:GetShow() then
		questInfo_TooltipShow( false )
	end
	
	if Panel_Dialog_Search:IsShow() then
		searchView_Close()
	end

	local isShow = Panel_GameExit:IsShow()
	if true == isShow then
		Panel_GameExit:SetShow( false )
	end
	_wpHelp:SetShow(false)
	intimacyNotice:SetShow( false )
	intimacyNoticeText:SetShow( false )
	if true == _ignoreShowDialog then
		return
	end
	if ( GetUIMode() ~= Defines.UIMode.eUIMode_Default ) and ( GetUIMode() ~= Defines.UIMode.eUIMode_NpcDialog ) and ( GetUIMode() ~= Defines.UIMode.eUIMode_NpcDialog_Dummy ) then
		ToClient_PopDialogueFlush();
		return
	end
	
	local dialogData = ToClient_GetCurrentDialogData()
	if (nil == dialogData) then
		ToClient_PopDialogueFlush();
		return
	end
	
	local mainDialog = dialogData:getMainDialog()
	if(mainDialog == '') then
		ToClient_PopDialogueFlush();
		return;
	end
	
	if ( not isFullSizeModeAble(FullSizeMode.fullSizeModeEnum.Dialog) ) then
		ToClient_PopDialogueFlush();
		return
	else
		setFullSizeMode( true, FullSizeMode.fullSizeModeEnum.Dialog )
	end

	-- Mode 설정
	SetUIMode( Defines.UIMode.eUIMode_NpcDialog )

	-- 툴팁이 떠 있게 되는 상황을 막는다.
	Panel_Tooltip_Item_hideTooltip()
	Panel_SkillTooltip_Hide()
	
	-- 인터랙션 닫아주기(다이얼로그 후 인터랙션 창 업데이트를 위해)
	Interaction_Close()
	
	-- 튜토리얼 마스킹 상태에서 튜토리얼을 따라가지 않고 다이얼로그를 연 경우, 그냥 닫아준다
	FGlobal_Tutorial_QuestMasking_Hide()
	
	-- Panel 숨기기
	if isFlushUI then
		UI.flushAndClearUI()
	end	
	-- Panel_TerritoryAuth_Message:SetShow(true)
	setShowLine(false)
	--Panel_QuestDirect:SetShow(true, false)
	PaGlobalAppliedBuffList:hide()
	
	-- 초기화
	for index = 0, 5, 1 do
		_uiFuncBG[index]:SetShow(false)
	end
	
	_equipRewardCount = 0
	_currentLine = 0
	
	-- 다른 PC와 교환시에 취소 메시지 전송 
	if Panel_Window_Exchange:GetShow() then
		ExchangePC_MessageBox_ResponseCancel()
	end
	
	setShowNpcDialog(true)
	
	-- NPC 정보
	local npcTitle = dialogData:getContactNpcTitle()
	local npcName = dialogData:getContactNpcName()
	_uiNpcTitle:SetText(npcTitle)
	_uiNpcName:SetText(npcName)
		
	if npcTitle == "" or npcTitle == nil then
		_uiNpcName:SetPosX( getScreenSizeX() / 2 - (_uiNpcName:GetTextSizeX() / 2) )
	else
		_uiNpcTitle:SetPosX((getScreenSizeX() / 2) - ((_uiNpcTitle:GetTextSizeX() + _uiNpcName:GetTextSizeX() + 16 ) / 2))
		_uiNpcName:SetPosX(_uiNpcTitle:GetPosX() + _uiNpcTitle:GetTextSizeX() + 16)
	end
	
	-- NPC 대화
	_mainDialog	 = {}
	local stringList = string.split(mainDialog, "\n")
	local i = 0;
	local strFirst, strSecond
	while true do
		strFirst = stringList[ i*2+1 ]
		strSecond = stringList[ i*2+2 ]

		if ( strFirst ~= nil ) and ( strSecond ~= nil) then
			_mainDialog[i] = strFirst .. "\n" .. strSecond
		elseif strFirst == nil then
			 break
		elseif strSecond == nil then
			_mainDialog[i] = strFirst
			break
		end
		i = i+1
	end
	_maxLine = #_mainDialog;
	-- 퀘스트 보상
	local questData		= questList_getQuestInfo( dialogData:getQuestRaw() )
	local baseCount 	= dialogData:getBaseRewardCount()
	local _baseReward = {}
	for idx=1, baseCount, 1 do
		local baseReward = dialogData:getBaseRewardAt(idx-1)
		_baseReward[idx] = {}
		_baseReward[idx]._type = baseReward._type
		if (CppEnums.RewardType.RewardType_Exp == baseReward._type) then
			_baseReward[idx]._exp = baseReward._experience
		elseif (CppEnums.RewardType.RewardType_SkillExp == baseReward._type) then
			_baseReward[idx]._exp = baseReward._skillExperience
		elseif (CppEnums.RewardType.RewardType_ProductExp == baseReward._type) then
			_baseReward[idx]._exp = baseReward._productExperience
		elseif (CppEnums.RewardType.RewardType_Item	 == baseReward._type) then
			_baseReward[idx]._item = baseReward:getItemEnchantKey()
			_baseReward[idx]._count = baseReward._itemCount
		elseif (CppEnums.RewardType.RewardType_Intimacy	 == baseReward._type) then
			_baseReward[idx]._character = baseReward:getIntimacyCharacter()
			_baseReward[idx]._value = baseReward._intimacyValue
		end
	end
	
	local selectCount 	= dialogData:getSelectRewardCount()
	local _selectReward = {}
	for idx=1, selectCount, 1 do
		local selectReward = dialogData:getSelectRewardAt(idx-1)
		_selectReward[idx] = {}
		_selectReward[idx]._type = selectReward._type
		if (CppEnums.RewardType.RewardType_Exp == selectReward._type) then
			_selectReward[idx]._exp = selectReward._experience
		elseif (CppEnums.RewardType.RewardType_SkillExp == selectReward._type) then
			_selectReward[idx]._exp = selectReward._skillExperience
		elseif (CppEnums.RewardType.RewardType_ProductExp == selectReward._type) then
			_selectReward[idx]._exp = selectReward._productExperience
		elseif (CppEnums.RewardType.RewardType_Item	 == selectReward._type) then
			_selectReward[idx]._item = selectReward:getItemEnchantKey()
			_selectReward[idx]._count = selectReward._itemCount
			local selfPlayer = getSelfPlayer()
			if nil ~= selfPlayer then
				local classType = selfPlayer:getClassType() 
				_selectReward[idx]._isEquipable = selectReward:isEquipable(classType)
			end
		elseif (CppEnums.RewardType.RewardType_Intimacy	 == selectReward._type) then
			_selectReward[idx]._character = selectReward:getIntimacyCharacter()
			_selectReward[idx]._value = selectReward._intimacyValue
		end
	end
	
	FGlobal_SetRewardList( _baseReward, _selectReward, questData )
	
	isFirstShowTooltip = true
	
	Dialog_updateMainDialog()
	-- 친밀도 Update
	Dialog_intimacyValueUpdate()

	Dialog_PageButton_Init()
	Panel_Npc_Dialog:SetShow(true, true)
	
	Panel_MovieTheater_LowLevel_WindowClose()
end

-- 다음 대화 넘기기
function HandleClickedDialogNextButton()
	_currentLine = _currentLine + 1;
	Dialog_updateMainDialog();
end

-- 친밀도 Update

local intimacyValueBuffer = {}
-- index
-- value : {}
	-- key : names
	-- value : string
	-- names : giftName, giftDesc, giftPercent [0,1]
function Dialog_intimacyValueUpdate()
	intimacyValueBuffer = {}
	local index = 0
	local talker = dialog_getTalker()
	if nil ~= talker then
		local characterKey = talker:getCharacterKey()
		local npcData = getNpcInfoByCharacterKeyRaw(characterKey, talker:get():getDialogIndex() )
		if nil ~= npcData then
			if ( true == npcData:hasSpawnType( CppEnums.SpawnType.eSpawnType_intimacy ) ) then
				local intimacy = getIntimacyByCharacterKey(characterKey)
				_txt_intimacy:SetShow(true)
				_intimacyFruitageValue:SetShow(true)
				_intimacyFruitageValue:SetText(tostring(intimacy))
				
				local valuePercent = intimacy / 1000 * 100
				if ( 100 < valuePercent ) then
					valuePercent = 100
				end
				_intimacyCircularProgress:SetShow(true)
				_intimacyCircularProgress:SetProgressRate(valuePercent)
				_intimacyCircularProgress:addInputEvent( "Mouse_On",	"FruitageValue_ShowTooltip(true)" )
				_intimacyCircularProgress:addInputEvent( "Mouse_Out",	"FruitageValue_ShowTooltip(false)" )

				_intimacyProgressBG:SetShow(true)
				local count = getIntimacyInformationCount( characterKey )
				local colorKey = float4(1,1,1,1)
				local startSize = 28
				local endSize = ( _intimacyProgressBG:GetSizeX() + _intimacyGiftIcon:GetSizeX() )/ 2
				local centerPosition = float3(_intimacyProgressBG:GetPosX() + _intimacyProgressBG:GetSizeX() / 2 , _intimacyProgressBG:GetPosY() + _intimacyProgressBG:GetSizeY() / 2,0)

				for index, value in pairs(giftIcon) do
					UI.deleteControl( value )
				end
				giftIcon = {}
				
				for index = 0, count -1 do
					local intimacyInformationData = getIntimacyInformation( characterKey, index )
					if( nil ~= intimacyInformationData ) then
						local percent = intimacyInformationData:getIntimacy() / 1000.0
						local imageType = intimacyInformationData:getTypeIndex()
						local giftName = intimacyInformationData:getTypeName()
						local giftDesc = intimacyInformationData:getTypeDescription()
						local giftOperator = intimacyInformationData:getOperatorType()
						local imageFileName = ""
						
						if ( 0 <= percent ) and ( percent <= 1 ) and ToClient_checkIntimacyInformationFixedState(intimacyInformationData) then
						local angle = math.pi * 2 * percent

						local lineStart = float3( math.sin(angle), -math.cos(angle),0 )
						local lineEnd = float3( math.sin(angle), -math.cos(angle),0 )

						lineStart = _math_AddVectorToVector( centerPosition ,_math_MulNumberToVector( lineStart, startSize ) )
						lineEnd = _math_AddVectorToVector( centerPosition ,_math_MulNumberToVector( lineEnd, endSize ) )

						local target = giftIcon[index]
						if ( nil == target ) then
							target = UI.createControl( UCT.PA_UI_CONTROL_STATIC, Panel_Npc_Dialog, 'GiftIcon_' .. tostring(index))
							giftIcon[index] = target
							CopyBaseProperty(_intimacyGiftIcon, target)
						end
						target:SetShow(true)

						target:ChangeTextureInfoName(uv[imageType]._fileName)

						local x1, y1, x2, y2 = setTextureUV_Func( target, uv[imageType].x1, uv[imageType].y1, uv[imageType].x2, uv[imageType].y2 )
						target:getBaseTexture():setUV(  x1, y1, x2, y2 )
						target:setRenderTexture(target:getBaseTexture())

						target:SetPosX( lineEnd.x - target:GetSizeX() / 2 )
						target:SetPosY( lineEnd.y - target:GetSizeY() / 2 )
						local targetPosX = target:GetPosX()
						local targetPosY = target:GetPosY()
						intimacyValueBuffer[index] = {giftName=giftName, giftDesc=giftDesc, giftPercent=percent, giftOperator=giftOperator}
						target:addInputEvent( "Mouse_On",	"FruitageItem_ShowTooltip("..percent..")" )
						target:addInputEvent( "Mouse_Out",	"FruitageItem_HideTooltip()" )

					end
					end					
				end
				return
			end
		end	
	end
	
	_txt_intimacy:SetShow(false)
	_intimacyFruitageValue:SetShow(false)
	_intimacyCircularProgress:SetShow(false)
	_intimacyProgressBG:SetShow(false)
	for index, value in pairs(giftIcon) do
		value:SetShow(false)
	end
end

function FromClient_VaryIntimacy_Dialog( actorKeyRaw, tendencyValue )
	-- NPC 대화모드일때 NPC친밀도 갱신 및 상점아이템 목록 갱신
	if ( (Defines.UIMode.eUIMode_NpcDialog == GetUIMode()) and (true == Panel_Window_NpcShop:GetShow()) ) then
		Dialog_intimacyValueUpdate()
		NpcShop_UpdateContent()
		Dialog_updateButtons(true)
	end
end

function Dialog_PageButton_Init()
	_prevPageButton:SetIgnore( true )
	_nextPageButton:SetIgnore( false )
	_dialogIndex = 0
	local dialogData = ToClient_GetCurrentDialogData()
	if nil == dialogData then	return	end
	local dialogButtonCount = dialogData:getDialogButtonCount()
	local pageCount = (dialogButtonCount-1) / 4 - ((dialogButtonCount-1) / 4) % 1
	_pageValue:SetText("1/" .. pageCount+1)
end
Dialog_PageButton_Init()

function HandleClicked_Next_Dialog( _startIndex )
	local dialogData = ToClient_GetCurrentDialogData()
	local dialogButtonCount = dialogData:getDialogButtonCount()
	local pageCount = (dialogButtonCount-1) / 4 - ((dialogButtonCount-1) / 4) % 1

	if (_startIndex < 0) or (dialogButtonCount <= _startIndex) then
		return
	end
	_dialogIndex = _startIndex

	if ( 0 == _startIndex ) then
		_prevPageButton:SetIgnore( true )
		_nextPageButton:SetIgnore( false )
		_pageValue:SetText(_startIndex/4 + 1 .. "/" .. pageCount+1)
	elseif ( _startIndex/4 == pageCount ) then
		_prevPageButton:SetIgnore( false )
		_nextPageButton:SetIgnore( true )
		_pageValue:SetText(_startIndex/4 + 1 .. "/" .. pageCount+1)
	else
		_prevPageButton:SetIgnore( false )
		_nextPageButton:SetIgnore( false )
		_pageValue:SetText(_startIndex/4 + 1 .. "/" .. pageCount+1)
	end
	Dialog_updateButtons( true )
end

-- 버튼 Update
local promiseTokenKey = 44192		-- 약속의 증표 아이템 키
function Dialog_updateButtons( isVisible )
	local sizeX = getScreenSizeX()
	local sizeY = getScreenSizeY()

	local pos = nil
	local displayData = nil
	local linkType = 0
	local Wp = 0
	local playerLevel = 0
	
	local selfPlayer = getSelfPlayer()
	if nil ~= selfPlayer then
		Wp 			= selfPlayer:getWp()
		playerLevel = selfPlayer:get():getLevel()
	end

	local isBlackStone_16001 = Panel_Inventory_isBlackStone_16001
	local isBlackStone_16002 = Panel_Inventory_isBlackStone_16002
	local value_IsSocket	 = Panel_Inventory_isSocketItem
	
	local dialogData = ToClient_GetCurrentDialogData()
	if (nil == dialogData) then
		return
	end
	
	local dialogButtonCount = dialogData:getDialogButtonCount()

	isReContactDialog = false
	isDialogFunctionQuest = false
	local isExchangalbeButtonCheck = false
	_questDialogButtonIndex = -1
	_exchangalbeButtonIndex = -1
	
	for i = 0, 3, 1 do
		_uiDialogButton[i]:SetShow(false)
		_uiNoticeNeedInfo[i]:SetShow(false)
		_uiNeedWpAni[i]:SetShow(false)
		_uiIntimacyIcon[i]:SetShow(false)
	end

	if ( 4 < dialogButtonCount ) then
		_prevPageButton:SetShow( true )
		_nextPageButton:SetShow( true )
		_scrollControl:SetShow( true )
		_scrollControl:SetIgnore( false )
		_pageValue:SetShow( true )
		
		_prevPageButton:SetAutoDisableTime(0.2)
		_nextPageButton:SetAutoDisableTime(0.2)

		_prevPageButton	:addInputEvent("Mouse_LUp",			"HandleClicked_Next_Dialog(" .. _dialogIndex - 4 .. ")")
		_nextPageButton	:addInputEvent("Mouse_LUp",			"HandleClicked_Next_Dialog(" .. _dialogIndex + 4 .. ")")
		
		------ 다이얼로그 버튼 및 페이지 변경 버튼 스크롤 -------
		for dialogBTScrollIndex = 0, 3, 1 do
			_uiDialogButton[dialogBTScrollIndex]:addInputEvent("Mouse_UpScroll",	"HandleClicked_Next_Dialog(" .. _dialogIndex - 4 .. ")")
			_uiDialogButton[dialogBTScrollIndex]:addInputEvent("Mouse_DownScroll",	"HandleClicked_Next_Dialog(" .. _dialogIndex + 4 .. ")")
		end
		_scrollControl	:addInputEvent("Mouse_UpScroll",	"HandleClicked_Next_Dialog(" .. _dialogIndex - 4 .. ")")
		_scrollControl	:addInputEvent("Mouse_DownScroll",	"HandleClicked_Next_Dialog(" .. _dialogIndex + 4 .. ")")
		_prevPageButton	:addInputEvent("Mouse_UpScroll",	"HandleClicked_Next_Dialog(" .. _dialogIndex - 4 .. ")")
		_prevPageButton	:addInputEvent("Mouse_DownScroll",	"HandleClicked_Next_Dialog(" .. _dialogIndex + 4 .. ")")
		_nextPageButton	:addInputEvent("Mouse_UpScroll",	"HandleClicked_Next_Dialog(" .. _dialogIndex - 4 .. ")")
		_nextPageButton	:addInputEvent("Mouse_DownScroll",	"HandleClicked_Next_Dialog(" .. _dialogIndex + 4 .. ")")
		----------------------------------------------------------
	else
		_prevPageButton:SetShow( false )
		_nextPageButton:SetShow( false )
		_scrollControl:SetShow( false )
		_scrollControl:SetIgnore( true )
		_pageValue:SetShow( false )
	end
	
	-- 대화 버튼
	local _dialogCount = 0
	local _firstDisplayQuest = false
	local _btnPositionType = 0
	local _questDialogButtonPosY = 0
	local _exchangalbeButtonPosY = 0
	local _rBtnPlusPosX	= 0
	local _dialogBtnSizeX = defaultDialogBtnSizeX
	
	for i = _dialogIndex, dialogButtonCount-1, 1 do
		local dialogButton = nil
		local needThings = ""
		local isNeedThings = false
		local itemStaticWrapper = nil
		isExchangeButtonIndex[i] = false
		isPromiseToken[i] = false
		
		if ((not isVisible) or (3 < _dialogCount)) then
			break
		end
		pos = _uiDialogButton[_dialogCount]:GetSpanSize();
		displayData = Dialog_getButtonDisplayData(i);
		
		if (false == displayData:empty()) then
			CopyBaseProperty( _styleExploreTalkButton, _uiDialogButton[_dialogCount] );
		else
			CopyBaseProperty( _styleNormalTalkButton, _uiDialogButton[_dialogCount] );
		end
		
		dialogButton = dialogData:getDialogButtonAt(i)
		-- if not isGameTypeKorea() then
			-- _uiDialogButton[_dialogCount]:SetTextMode( UI_TM.eTextMode_LimitText )	-- 프랑스어/독어 때문에 줄임 처리한다.
		-- end
		_uiDialogButton[_dialogCount]:SetText(dialogButton:getText())
		_uiDialogButton[_dialogCount]:SetSpanSize(pos.x, pos.y);
		if _dialogBtnSizeX < (_uiDialogButton[_dialogCount]:GetTextSizeX() + 80) then
			_dialogBtnSizeX = _uiDialogButton[_dialogCount]:GetTextSizeX() + 80
		end
		
		if (displayData:empty()) then
			_uiDialogButton[_dialogCount]:SetEnable( dialogButton._enable );
			if (dialogButton._enable) then
				if(false == dialogButton._invenPushable) then
					_uiDialogButton[_dialogCount]:SetEnable( dialogButton._invenPushable );
					_uiDialogButton[_dialogCount]:SetMonoTone(true)
					_uiDialogButton[_dialogCount]:SetFontColor(UI_color.C_FF515151)
					_uiNoticeNeedInfo[_dialogCount]:SetFontColor(UI_color.C_FFF26A6A)
				else
					_uiDialogButton[_dialogCount]:SetMonoTone(false)
					_uiDialogButton[_dialogCount]:SetFontColor(UI_color.C_FFDFDFDF)
					_uiNoticeNeedInfo[_dialogCount]:SetFontColor(UI_color.C_FFDFDFDF)
				end
			else
				_uiDialogButton[_dialogCount]:SetMonoTone(true)
				_uiDialogButton[_dialogCount]:SetFontColor(UI_color.C_FF515151)
				_uiNoticeNeedInfo[_dialogCount]:SetFontColor(UI_color.C_FFF26A6A)
			end
			
			linkType = dialogButton._linkType
			_uiNoticeNeedInfo[_dialogCount]:SetShow(false)
			_uiNeedWpAni[_dialogCount]:SetShow(false)
			
			-- 계속 버튼 나오면 R 키로 넘기기
			if ( UI_DS.eDialogState_ReContact == tostring(linkType) ) then
				isReContactDialog = true
				_btnPositionType = 2
			-- 퀘스트 수락, 완료 및 받을 수 있는 퀘스트가 있다면 첫 번째 것 R키로 수락
			elseif ( UI_DS.eDialogState_QuestComplete == tostring(linkType) ) or ( UI_DS.eDialogState_AcceptQuest == tostring(linkType) ) then
				isReContactDialog = true
				_btnPositionType = 2
			end
			
			-- 퀘스트 타입이 클리어라면
			if ( UI_DS.eDialogState_QuestComplete == tostring(linkType) ) then
				_isQuestComplete = true
			else
				_isQuestComplete = false
			end
			
			-- 받을 수 있는 퀘스트가 있다면 R 키로 첫 번째 것 받음
			if ( UI_DS.eDialogState_DisplayQuest == tostring( linkType ) and ( false == _firstDisplayQuest ) ) then
				_firstDisplayQuest = true
				_btnPositionType = 4
				_questDialogButtonIndex = _dialogCount
				_questDialogButtonPosY = _uiDialogButton[_questDialogButtonIndex]:GetPosY()
			end
			
			local needWp = dialogButton:getNeedWp()
			if ( UI_DS.eDialogState_Talk == tostring(linkType)) and ( 0 < needWp ) then
				needThings = needThings .. PAGetStringParam1(Defines.StringSheet_GAME, "DIALOG_NEED_WP", "wp", needWp ) .. " (" .. PAGetString ( Defines.StringSheet_GAME, "DIALOG_WP_GOT" ) .. ""..Wp..") "
				isNeedThings = true;
			
				if( 0 < dialogButton:getNeedItemCount() ) then
					itemStaticWrapper = getItemEnchantStaticStatus( ItemEnchantKey(dialogButton:getNeedItemKey()) );
					if ( itemStaticWrapper ~= nil ) then
						needThings = needThings .. " / " .. itemStaticWrapper:getName() .. " " .. tostring(dialogButton:getNeedItemCount()) .. PAGetString ( Defines.StringSheet_GAME, "DIALOG_NEEDCOUNT" )
					end
					_uiNeedWpAni[_dialogCount]:SetShow(false)
				else
					-- 잡템이 아닌 것이 필요하다면, 일단은 기운이다! 기운일 때만 아이콘 표시
					_uiNeedWpAni[_dialogCount]:SetShow(true)
					-- _exchangalbeButtonIndex = _dialogCount
				end
			
			elseif ( 0 < dialogButton:getNeedItemCount() ) then
				itemStaticWrapper = getItemEnchantStaticStatus( ItemEnchantKey(dialogButton:getNeedItemKey()) );
				if ( itemStaticWrapper ~= nil ) then
					needThings = needThings .. itemStaticWrapper:getName() .. " " .. tostring(dialogButton:getNeedItemCount()) .. PAGetString ( Defines.StringSheet_GAME, "DIALOG_NEEDCOUNT" )
					isNeedThings = true
					isExchangeButtonIndex[_dialogCount] = true
					if dialogButton:getNeedItemKey() == promiseTokenKey then			-- 교환템이 약속의 증표면,
						isPromiseToken[_dialogCount] = true
					end
				end
				_uiNeedWpAni[_dialogCount]:SetShow(false)
			else
				_uiNeedWpAni[_dialogCount]:SetShow(false)
			end
				
			if(isNeedThings) then
				if( dialogButton._invenPushable ) then
					_uiNoticeNeedInfo[_dialogCount]:SetText(needThings )
				else
					_uiNoticeNeedInfo[_dialogCount]:SetText( PAGetString ( Defines.StringSheet_GAME, "LUA_PLAYER_INVENTORY_FULL" ) )
				end
				
				_uiNoticeNeedInfo[_dialogCount]:SetSize(_uiNoticeNeedInfo[_dialogCount]:GetTextSizeX()+10, 23)
				_uiNoticeNeedInfo[_dialogCount]:SetAutoResize( true )
				_uiNoticeNeedInfo[_dialogCount]:SetShow(true)

				-- 기운/또는 잡템 교환이 가능할 때만 첫번째 버튼에 R키를 박자!! 단, 받을 수 있는 퀘가 있다면, 퀘가 우선
				-- 컷씬의 경우에는 R키 연타로 여러번의 컷씬재생이 되는 경우가 있으므로 R키를 제외한다 (20141228 : crazy4idea)
				if ( dialogButton._enable ) and ( false == isExchangalbeButtonCheck ) and ( UI_BTN_TYPE.eDialogButton_CutScene ~= dialogButton._dialogButtonType ) and ( UI_BTN_TYPE.eDialogButton_ExceptExchange ~= dialogButton._dialogButtonType ) then
					_exchangalbeButtonPosY = _uiDialogButton[_dialogCount]:GetPosY()
					_rBtnPlusPosX = _uiNoticeNeedInfo[_dialogCount]:GetSizeX()
					isExchangalbeButtonCheck = true
					_btnPositionType = 5
					_exchangalbeButtonIndex = _dialogCount
				end
			elseif ( UI_BTN_TYPE.eDialogButton_Knowledge == dialogButton._dialogButtonType ) and UI_DS.eDialogState_DisplayQuest ~= tostring( linkType ) then		-- 기운을 소모하지 않고, 지식을 얻을 수 있는 대화버튼
				_exchangalbeButtonPosY = _uiDialogButton[_dialogCount]:GetPosY()
				_rBtnPlusPosX = 0
				isExchangalbeButtonCheck = true
				_btnPositionType = 5
				_exchangalbeButtonIndex = _dialogCount
			end
		else
			_uiDialogButton[_dialogCount]:SetMonoTone(false)
			_uiDialogButton[_dialogCount]:SetFontColor(UI_color.C_FFDFDFDF)
			_uiNoticeNeedInfo[_dialogCount]:SetShow(false)
			_uiNeedWpAni[_dialogCount]:SetShow(false)
		end
		_uiDialogButton[_dialogCount]:SetShow(true)
		
		
		if( UI_DS.eDialogState_Talk == tostring(linkType) ) then
			if(0 < dialogButton._dialogButtonType) and (dialogButton._dialogButtonType < CppEnums.DialogButtonType.eDialogButton_Count ) then
				FGlobal_ChangeOnTextureForDialogIcon(_uiDialogIcon[_dialogCount], dialogButton._dialogButtonType)
				_uiDialogIcon[_dialogCount]:SetShow(true)
			else
				_uiDialogIcon[_dialogCount]:SetShow(false)
			end			
		else
			if (0 < dialogButton._dialogButtonType) and (dialogButton._dialogButtonType < CppEnums.DialogQuestButtonType.eDialogButton_QuestCount) then
				FGlobal_ChangeOnTextureForDialogQuestIcon(_uiDialogIcon[_dialogCount], dialogButton._dialogButtonType)
				_uiDialogIcon[_dialogCount]:SetShow(true)
			else
				_uiDialogIcon[_dialogCount]:SetShow(false)
			end
		end
		
		-- 친밀도 보상 체크 부분 -- 
		_uiIntimacyIcon[_dialogCount]:SetShow(false)
		local talker = dialog_getTalker()
		if nil ~= talker then
			local characterKey = talker:getCharacterKey()
			local count = getIntimacyInformationCount( characterKey )
			local intimacyValue = talker:getIntimacy()
			
			for indexIntimacy = 0, count -1 do
				local intimacyInformationData = getIntimacyInformation( characterKey, indexIntimacy )
				local giftDesc = intimacyInformationData:getTypeDescription()
				local intimacyType = intimacyInformationData:getTypeName()

				if ( giftDesc == dialogButton:getText()) and ( 1 < intimacyValue ) then				-- 친밀도가 2 이상일 때만 버튼에 친밀도 아이콘 표시
				-- 친밀도 보상이 퀘스트라면
					if ( intimacyType == PAGetString( Defines.StringSheet_GAME, "INTIMACYINFORMATION_TYPE_QUEST" )) then
						_uiIntimacyIcon[_dialogCount]:SetPosX ( _uiDialogButton[_dialogCount]:GetPosX() + _uiIntimacyIcon[_dialogCount]:GetSizeX() - 8 )
						_uiIntimacyIcon[_dialogCount]:SetPosY ( _uiDialogButton[_dialogCount]:GetPosY() + 1 )
					else
						_uiIntimacyIcon[_dialogCount]:SetPosX ( _uiDialogButton[_dialogCount]:GetPosX() + 3 )
						_uiIntimacyIcon[_dialogCount]:SetPosY ( _uiDialogButton[_dialogCount]:GetPosY() + 1 )
					end
					if ( 0 < dialogButton._dialogButtonType ) then			-- 퀘스트 및 기능 표시 아이콘이 존재하지 않는 경우에만 친밀도 아이콘 표시
						_uiIntimacyIcon[_dialogCount]:SetShow( false )
					else
						_uiIntimacyIcon[_dialogCount]:SetShow( true )
					end
				end
			end
		end
		_dialogCount = _dialogCount + 1
	end
	
	-- 대화버튼 텍스트에 따라 대화버튼 사이즈 및 위치를 새로 잡아준다!
	for i = 0, 3 do
		_uiDialogButton[i]:SetSize( _dialogBtnSizeX, _uiDialogButton[i]:GetSizeY() )
		_uiDialogButton[i]:SetPosX( getScreenSizeX()/2 - _dialogBtnSizeX/2 )
	end
	
	_SpacebarIcon:SetPosX ( _uiDialogButton[0]:GetPosX() + _uiDialogButton[0]:GetSizeX() + 10 )
	_prevPageButton:SetPosX( _uiDialogButton[0]:GetPosX() - _prevPageButton:GetSizeX() * 2 )
	_nextPageButton:SetPosX( _prevPageButton:GetPosX() )
	_pageValue:SetPosX( _prevPageButton:GetPosX() )
	_rBtnPosX = _uiDialogButton[0]:GetPosX() + _uiDialogButton[0]:GetSizeX() - _SpacebarIcon:GetSizeX() - 5
	
	------------------------------------------------------------
	--				퀘스트 넘버를 가져오자
	local totalQuestCount = 0
	local progressQuestCount = questList_getCheckedProgressQuestCount()					-- 퀘스트의 현재 개수

	local groupNo = nil
	local questNo = nil
	local progressQuest = nil
	local groupCount = 0
	for questIndex = 1, progressQuestCount, 1 do
		progressQuest = questList_getCheckedProgressQuestAt( questIndex - 1 )		-- 현재 진행 중인 퀘스트를 체크하기 위함
		
		if( nil == progressQuest) then	-- 현재 진행 중인 퀘스트가 없다면 돌아가라
			return
		end
		
		totalQuestCount = totalQuestCount + 1

		groupCount = progressQuest:getQuestGroupQuestCount()
		if (0 < groupCount) and (progressQuest:getQuestGroupQuestNo() <= groupCount)  then
			groupNo = progressQuest:getQuestGroup()
			questNo = progressQuest:getQuestGroupQuestNo()
		end
	end
	
	-- 기능 버튼
	local funcButtonCount 	=  dialogData:getFuncButtonCount()
	local buttonSize 		= _uiFuncButton[0]:GetSizeX()
	local buttonGap			= 10
	local startPosX 		= ( sizeX - ( buttonSize * funcButtonCount + buttonGap * ( funcButtonCount -1 ))) / 2
	local funcButton 		= nil
	
	local intimacyGame_Alert 		= UI.getChildControl( Panel_Npc_Dialog, "Static_BubbleBox" )
	local intimacyGame_Alert_Txt 	= UI.getChildControl( Panel_Npc_Dialog, "StaticText_BubbleBox" )
		  intimacyGame_Alert		: SetShow( false )
		  intimacyGame_Alert_Txt 	: SetShow( false )

	local investNode_Alert 		= UI.getChildControl( Panel_Npc_Dialog, "Static_BubbleBox2" )
	local investNode_Alert_Txt 	= UI.getChildControl( Panel_Npc_Dialog, "StaticText_BubbleBox2" )
		  investNode_Alert		: SetShow( false )
		  investNode_Alert_Txt 	: SetShow( false )
		  
	for index = 0, 5, 1 do
		local posX = startPosX + ( buttonSize + buttonGap ) * index
		_uiFuncButton[index]:EraseAllEffect()
		_uiFuncButton[index]:addInputEvent("Mouse_On", "")
		_uiFuncButton[index]:addInputEvent("Mouse_Out", "" )
		
		nextQuestFunctionBtnClick[index] = false

		if index < funcButtonCount then
			funcButton = dialogData:getFuncButtonAt(index)
			_uiFuncButton[index]:SetIgnore( false )
			_uiFuncButton[index]:SetFontColor(4291083966)
			_uiFuncButton[index]:ResetVertexAni()
			_uiFuncButton[index]:SetAlpha(1)
			_uiFuncButton[index]:SetPosX(posX)
			_uiFuncButton[index]:SetMonoTone( false )
			-- _uiFuncButton[index]:SetTextVerticalCenter()
			-- _uiFuncButton[index]:SetTextHorizonLeft()

			local funcButtonType = tonumber(funcButton._param)

			Dialog_InterestKnowledgeUpdate()														-- 관심사 지식 업데이트

			local displayExchangeWrapper	= dialogData:getCurrentDisplayExchangeWrapper()
			if nil~= displayExchangeWrapper then
				FGlobal_Exchange_Item()																-- 아이템 교환 목록
			end

			_uiFuncButton[index]:addInputEvent("Mouse_On", "Dialog_MouseToolTips(true, " .. funcButtonType .. "," .. index .. ")")
			_uiFuncButton[index]:addInputEvent("Mouse_Out", "Dialog_MouseToolTips(false, " .. funcButtonType .. "," .. index .. ")" )

			local tempIconSizeX = 23
			if	funcButtonType == CppEnums.ContentsType.Contents_IntimacyGame then					-- 이야기교류 필요 WP 표시 
				local btnIntimacySizeX			= _uiFuncButton[index]:GetSizeX() + tempIconSizeX
				_uiFuncButton[index]:SetText(funcButton:getText() .. " (" .. funcButton:getNeedWp() .. "/" .. Wp .. ")")
				local btnIntimacyPosX			= (btnIntimacySizeX - (btnIntimacySizeX/2) - ( _uiFuncButton[index]:GetTextSizeX() / 2 ))
				_uiFuncButton[index]:SetEnable(funcButton._enable)
				_uiFuncButton[index]:SetTextSpan( btnIntimacyPosX, 0.0 )
			elseif funcButtonType == CppEnums.ContentsType.Contents_NewQuest then
				local btnQuestTextSizeX			= (_uiFuncButton[index]:GetSizeX() + tempIconSizeX) - (_SpacebarIcon:GetSizeX()-2)
				_uiFuncButton[index]:SetText(funcButton:getText())
				local btnQuestTextPosX			= ( (btnQuestTextSizeX - (btnQuestTextSizeX/2)) - ( _uiFuncButton[index]:GetTextSizeX() / 2 ))
				_uiFuncButton[index]:SetTextSpan( btnQuestTextPosX, 0.0 )
				_uiFuncButton[index]:SetEnable( true )
			else
				_uiFuncButton[index]:SetEnable(true)
				_uiFuncButton[index]:SetText( funcButton:getText() )
				local btnTextSizeX			= _uiFuncButton[index]:GetSizeX() + tempIconSizeX
				local btnTextPosX			= (btnTextSizeX - (btnTextSizeX/2) - ( _uiFuncButton[index]:GetTextSizeX() / 2 ))
				_uiFuncButton[index]:SetTextSpan( btnTextPosX, 0.0 )
			end
			
			_uiFuncButton[index]:SetShow(true)
			
			if	funcButtonType == CppEnums.ContentsType.Contents_Quest	then								-- 퀘스트 [0]
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_00.dds" )
				local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 430, 155, 462 )
				_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
				_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_00.dds" )
				local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 430, 310, 462 )
				_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )
				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_00.dds" )

				local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 430, 465, 462 )
				_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )
				_uiFuncButton[index]:SetMonoTone(false)

			elseif	funcButtonType == CppEnums.ContentsType.Contents_NewQuest	then						-- 퀘스트 [1]
				_uiFuncBG[index]:SetPosX(_uiFuncButton[index]:GetPosX()-6)
				_uiFuncBG[index]:SetPosY(_uiFuncButton[index]:GetPosY()-5)
				
				--------------------------------------------------------
				-- 			새로운 퀘스트가 있을 경우 띄워준다!!
				-- ♬ 새로운 퀘스트가 있을 때 이펙트와 함께 사운드 추가!
				audioPostEvent_SystemUi(04,04)
				_uiFuncBG[index]:SetShow(true)
				-- _uiFuncBG[index]:ResetVertexAni()
				_uiFuncBG[index]:SetVertexAniRun( "Ani_Color_1", true )

				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_00.dds" )
				local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 430, 155, 462 )
				_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
				_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_00.dds" )
				local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 430, 310, 462 )
				_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_00.dds" )
				local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 430, 465, 462 )
				_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )

				-- _uiFuncButton[index]:ResetVertexAni()
				_uiFuncButton[index]:SetFontColor(4289626129)
				_uiFuncButton[index]:SetVertexAniRun( "Ani_Color_Bright", true )
				_uiFuncButton[index]:SetMonoTone(false)
				
				isDialogFunctionQuest = true
				_btnPositionType = 3
				
				if true == handleClickedQuestComplete then
					nextQuestFunctionBtnClick[index] = true
				end

			elseif	funcButtonType == CppEnums.ContentsType.Contents_Shop	then							-- 상점 [2]
				if ( funcButton:getText() == PAGetString(Defines.StringSheet_GAME, "DIALOG_BUTTON_EXCHANGEMONEY") ) then		-- 환전소면 버튼 텍스처 교체
					_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_02.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 298, 155, 330 )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())
	
					_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_02.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 298, 310, 330 )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )
	
					_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_02.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 299, 465, 331 )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )
				else
					_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 34, 155, 66 )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())
	
					_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 34, 310, 66 )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )
	
					_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 34, 465, 66 )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )
				end

				_uiFuncButton[index]:SetMonoTone(false)

			elseif	funcButtonType == CppEnums.ContentsType.Contents_Skill	then							-- 스킬 [3]
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
				local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 67, 155, 99 )
				_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
				_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
				local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 67, 310, 99 )
				_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
				local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 67, 465, 99 )
				_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )

				-- 퀘스트 클리어 조건을 검사해서 버튼 활성화 시켜주기!
				-- if ( playerLevel >= 4 ) then
					_uiFuncButton[index]:SetFontColor(4289626129)
					_uiFuncButton[index]:SetIgnore( false )
					-- _uiFuncButton[index]:ResetVertexAni()
					_uiFuncButton[index]:SetVertexAniRun( "Ani_Color_Bright", true )
					_uiFuncButton[index]:SetText( PAGetString(Defines.StringSheet_GAME, "DIALOG_BUTTON_SKILL") )
					_uiFuncButton[index]:SetMonoTone(false)
				-- else
					-- _uiFuncButton[index]:EraseAllEffect()
					-- _uiFuncButton[index]:SetIgnore( true )
					-- _uiFuncButton[index]:SetText( PAGetString(Defines.StringSheet_GAME, "DIALOG_BUTTON_SKILL_LOCK") )
					-- -- _uiFuncButton[index]:ResetVertexAni()
					-- _uiFuncButton[index]:SetAlpha(1)
					-- _uiFuncButton[index]:SetMonoTone(true)
				-- end
				
			----------------------------------------------------------------
			-- 					스킬 버튼 튜토리얼용
			----------------------------------------------------------------
				if ( groupNo == 1067 ) and ( questNo == 4 ) then		-- 워리어
					_uiFuncButton[index]:EraseAllEffect()
					_uiFuncButton[index]:AddEffect( "UI_ArrowMark02", true, 0, - _uiFuncButton[index]:GetSizeY() * 1.7 )
					
				elseif ( groupNo == 1600 ) and ( questNo == 4 ) then		-- 엘프
					_uiFuncButton[index]:EraseAllEffect()
					_uiFuncButton[index]:AddEffect( "UI_ArrowMark02", true, 0, - _uiFuncButton[index]:GetSizeY() * 1.7 )
					
				elseif ( groupNo == 1070 ) and ( questNo == 4 ) then		-- 소서러
					_uiFuncButton[index]:EraseAllEffect()
					_uiFuncButton[index]:AddEffect( "UI_ArrowMark02", true, 0, - _uiFuncButton[index]:GetSizeY() * 1.7 )
					
				elseif ( groupNo == 1071 ) and ( questNo == 4 ) then		-- 좌이안트
					_uiFuncButton[index]:EraseAllEffect()
					_uiFuncButton[index]:AddEffect( "UI_ArrowMark02", true, 0, - _uiFuncButton[index]:GetSizeY() * 1.7 )
				else
					_uiFuncButton[index]:EraseAllEffect()
				end

			elseif	funcButtonType == CppEnums.ContentsType.Contents_Repair	then							-- 수리 [4]
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 1, 155, 33 )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 1, 310, 33 )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 1, 465, 33 )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:SetMonoTone(false)

			elseif	funcButtonType == CppEnums.ContentsType.Contents_Auction	then					-- 경매 [5]
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 100, 155, 132 )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 100, 310, 132 )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 100, 465, 132 )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:SetMonoTone(false)
				isAuctionDialog = true

			elseif	funcButtonType == CppEnums.ContentsType.Contents_Inn	then						-- 여관 [6]
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 364, 155, 396 )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 364, 310, 396 )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 364, 465, 396 )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:SetMonoTone(false)

			elseif	funcButtonType == CppEnums.ContentsType.Contents_Warehouse	then					-- 창고 [7]
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 133, 155, 165 )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 133, 310, 165 )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 133, 465, 165  )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:SetMonoTone(false)

			elseif	funcButtonType == CppEnums.ContentsType.Contents_IntimacyGame then					-- 이야기 교류 [8]
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 232, 155, 264  )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 232, 310, 264  )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 232, 465, 264  )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )

				if ( true == funcButton._enable	) then
					_uiFuncButton[index]:SetMonoTone(false)
					intimacyGame_Alert:SetShow( false )
					intimacyGame_Alert_Txt:SetShow( false )

				else
					_uiFuncButton[index]:SetMonoTone(true)
					local talker = dialog_getTalker()															-- 대상 지정
					local ActorKeyRaw = talker:getActorKey()													-- 대상의 액터키로우
					local npcActorProxyWrapper = getNpcActor(ActorKeyRaw)										-- 래퍼 지정
					local needCount = npcActorProxyWrapper:getNeedCount()										-- 필요 지식
					local currCount = getKnowledgeCountMatchTheme(npcActorProxyWrapper:getNpcThemeKey())		-- 현재 지식
					local text = PAGetStringParam3( Defines.StringSheet_GAME, "HUMANRELATION_TEXT", "getNpcTheme", npcActorProxyWrapper:getNpcTheme(), "currCount", tostring(currCount), "needCount", tostring(needCount) )
					
					intimacyGame_Alert:SetShow			( true )
					intimacyGame_Alert_Txt:SetShow		( true )
					
					intimacyGame_Alert:SetPosX			( _uiFuncButton[index]:GetPosX() - 35 )
					intimacyGame_Alert:SetPosY			( _uiFuncButton[index]:GetPosY() - 60 )
					intimacyGame_Alert_Txt:SetPosX		( intimacyGame_Alert:GetPosX() - 5 )
					intimacyGame_Alert_Txt:SetPosY		( intimacyGame_Alert:GetPosY() )
					
					intimacyGame_Alert_Txt:SetAutoResize	( true )
					-- intimacyGame_Alert_Txt:SetTextMode	( UI_TM.eTextMode_AutoWrap )
					intimacyGame_Alert_Txt:SetText		( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_HUMANRELATION_ALERT_TEXT", "txt", text ) )
					intimacyGame_Alert_Txt:SetSize		( intimacyGame_Alert_Txt:GetTextSizeX(), intimacyGame_Alert_Txt:GetTextSizeY() )
					intimacyGame_Alert:SetSize			( intimacyGame_Alert_Txt:GetSizeX() + 70, intimacyGame_Alert_Txt:GetSizeY() + 34 )
				end

			elseif	funcButtonType == CppEnums.ContentsType.Contents_Stable	then						-- 마구간 [9]
				if	( stable_doHaveRegisterItem() )	then			-- 마패가 있을때 펑션 버튼에 애니메이션
					_uiFuncBG[index]:SetPosX(_uiFuncButton[index]:GetPosX()-6)
					_uiFuncBG[index]:SetPosY(_uiFuncButton[index]:GetPosY()-5)
					_uiFuncBG[index]:SetShow(true)
					-- _uiFuncBG[index]:ResetVertexAni()
					_uiFuncBG[index]:SetVertexAniRun( "Ani_Color_1", true )
				else
					_uiFuncBG[index]:SetShow(false)
				end
						
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 331, 155, 363  )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 331, 310, 363  )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_00.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 331, 465, 363  )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:SetMonoTone(false)

			elseif	funcButtonType == CppEnums.ContentsType.Contents_Transfer	then					-- 수송 [10]
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 100, 155, 132  )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 100, 310, 132  )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 100, 465, 132  )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:SetMonoTone(false)

			elseif	funcButtonType == CppEnums.ContentsType.Contents_Guild	then						-- 길드 창설 [11]
				
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 331, 155, 363  )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 331, 310, 363  )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 331, 465, 363  )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:SetMonoTone(false)

			elseif	funcButtonType == CppEnums.ContentsType.Contents_Explore	then					-- 농장 이용 [12]
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 166, 155, 198  )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 166, 310, 198  )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 166, 465, 198  )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )
				if ( false == dialog_getIsExplorationUseableCurrentTalker() ) then
					investNode_Alert:SetShow			( true )
					investNode_Alert_Txt:SetShow		( true )
					investNode_Alert_Txt:SetText		( PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_INVESTNODE_ALERT_TXT") ) -- "<PAColor0xFF9a6e20>선행 거점<PAOldColor> 연결이 필요합니다.\n버튼을 눌러 <PAColor0xFF9a6e20>선행 거점<PAOldColor>을 확인하세요." )
					
					if ( true == intimacyGame_Alert:GetShow() ) then
						investNode_Alert:SetPosX			( _uiFuncButton[index]:GetPosX() + _uiFuncButton[index]:GetSizeX() - 30 )
					else
						investNode_Alert:SetPosX			( _uiFuncButton[index]:GetPosX() - 35 )
					end
					investNode_Alert:SetPosY			( _uiFuncButton[index]:GetPosY() - 60 )
					investNode_Alert_Txt:SetPosX		( investNode_Alert:GetPosX() - 5 )
					investNode_Alert_Txt:SetPosY		( investNode_Alert:GetPosY() )
					
					investNode_Alert_Txt:SetAutoResize	( true )
					investNode_Alert_Txt:SetSize		( investNode_Alert_Txt:GetTextSizeX(), investNode_Alert_Txt:GetTextSizeY() )
					investNode_Alert:SetSize			( investNode_Alert_Txt:GetSizeX() + 70, investNode_Alert_Txt:GetSizeY() + 34 )
					--_PA_LOG("LUA", "말풍선을 보이게 해준다.")
				else
					investNode_Alert:SetShow			( false )
					investNode_Alert_Txt:SetShow		( false )
					--_PA_LOG("LUA", "말풍선을 안보이게 해준다.")
				end

			-- 추가 품목이다 --(텍스쳐 필요함)--
			elseif	funcButtonType == CppEnums.ContentsType.Contents_DeliveryPerson	then				-- 정류장 [13]
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 199, 155, 231  )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 199, 310, 231   )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 199, 465, 231  )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )

			elseif	funcButtonType == CppEnums.ContentsType.Contents_Enchant	then					-- 강화 [14] 잠재력 돌파
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 232, 155, 264  )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 232, 310, 264  )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 232, 465, 264  )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )
					
					local posX = _uiFuncButton[index]:GetPosX()
					local posY = _uiFuncButton[index]:GetPosY()
					
					-----------------------------
					-- 잠재력 돌파가 가능할 때
					if ( isBlackStone_16001 ) or ( isBlackStone_16002 ) then
						_uiFuncButton[index]:EraseAllEffect()
						_uiFuncButton[index]:AddEffect( "fUI_EnchantButton_Dark", false, 0, 0 )
					end

				
			elseif	funcButtonType == CppEnums.ContentsType.Contents_Socket	then						-- 보석 장착 [15] 잠재력 전이
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 265, 155, 297  )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 265, 310, 297  )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 265, 465, 297  )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )
					
					local posX = _uiFuncButton[index]:GetPosX()
					local posY = _uiFuncButton[index]:GetPosY()
					
					-----------------------------
					-- 잠재력 전이가 가능할 때
					if ( value_IsSocket == true ) then
						_uiFuncButton[index]:EraseAllEffect()
						_uiFuncButton[index]:AddEffect( "fUI_EnchantButton_Jewel", false, 0, 0 )
					end


			elseif	funcButtonType == CppEnums.ContentsType.Contents_Awaken	then						-- 각성 [16]
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 298, 155, 330  )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 298, 310, 330  )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 298, 465, 330  )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )
					
				_uiFuncButton[index]:AddEffect("fUI_Skill_Up_01A", true, 0, 0)
				_uiFuncButton[index]:AddEffect("UI_Skill_Up_1", true, 0, 0)


			elseif	funcButtonType == CppEnums.ContentsType.Contents_ReAwaken	then					-- 재각성 [17]
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 331, 155, 363  )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 331, 310, 363  )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 331, 465, 363  )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:SetMonoTone(false)
				_uiFuncButton[index]:AddEffect("fUI_Skill_ReUp_01A", true, 0, 0)
				_uiFuncButton[index]:AddEffect("UI_Skill_ReUp_1", true, 0, 0)


			elseif	funcButtonType == CppEnums.ContentsType.Contents_LordMenu	then					-- 영주 정보 [18]
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 331, 155, 363  )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 331, 310, 363  )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 331, 465, 363  )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:SetMonoTone(false)
			
			elseif	funcButtonType == CppEnums.ContentsType.Contents_Extract	then					-- 추출 [19]
				
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 331, 155, 363  )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 331, 310, 363  )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 331, 465, 363  )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:SetMonoTone(false)
			
			elseif	funcButtonType == CppEnums.ContentsType.Contents_TerritoryTrade	then					-- 영지 무역(황실 무역) [20]
				
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 331, 155, 363  )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 331, 310, 363  )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 331, 465, 363  )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:SetMonoTone(false)

			elseif	funcButtonType == CppEnums.ContentsType.Contents_TerritorySupply	then					-- 영지 무역(황실 무역) [21]
				
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 331, 155, 363  )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 331, 310, 363  )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 331, 465, 363  )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:SetMonoTone(false)

			elseif	funcButtonType == CppEnums.ContentsType.Contents_GuildShop	then					-- 길드 상점 [22]
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 34, 155, 66 )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())
	
					_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 34, 310, 66 )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )
	
					_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 34, 465, 66 )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:SetMonoTone(false)
			
			elseif	funcButtonType == CppEnums.ContentsType.Contents_ItemMarket	then					-- 아이템 판매소 [23]
				
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 331, 155, 363  )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 331, 310, 363  )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 331, 465, 363  )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:SetMonoTone(false)

			elseif	funcButtonType == CppEnums.ContentsType.Contents_Knowledge	then					-- 지식관리
				
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 331, 155, 363  )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 331, 310, 363  )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 331, 465, 363  )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:SetMonoTone(false)
				
			elseif 	funcButtonType == CppEnums.ContentsType.Contents_HelpDesk	then		-- 길잡이 
			
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 331, 155, 363  )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 331, 310, 363  )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 331, 465, 363  )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:SetMonoTone(false)
			
			elseif funcButtonType == CppEnums.ContentsType.Contents_SupplyShop then
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 331, 155, 363  )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 331, 310, 363  )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 331, 465, 363  )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:SetMonoTone(false)
			
			elseif funcButtonType == CppEnums.ContentsType.Contents_MinorLordMenu then
			--태곤
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_06.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 100, 155, 132 )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_06.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 100, 310, 132 )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_06.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 100, 465, 132 )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:SetMonoTone(false)
	
			elseif funcButtonType == CppEnums.ContentsType.Contents_FishSupplyShop then
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 331, 155, 363  )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 331, 310, 363  )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 331, 465, 363  )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:SetMonoTone(false)

			elseif funcButtonType == CppEnums.ContentsType.Contents_GuildSupplyShop then
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 331, 155, 363  )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 331, 310, 363  )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 331, 465, 363  )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:SetMonoTone(false)				
			
			elseif funcButtonType == CppEnums.ContentsType.Contents_Join then						-- 결전
				_uiFuncButton[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_08.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 1, 34, 155, 66  )
					_uiFuncButton[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
					_uiFuncButton[index]:setRenderTexture(_uiFuncButton[index]:getBaseTexture())

				_uiFuncButton[index]:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_08.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 156, 34, 310, 66  )
					_uiFuncButton[index]:getOnTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_08.dds" )
					local x1, y1, x2, y2 = setTextureUV_Func( _uiFuncButton[index], 311, 34, 465, 66  )
					_uiFuncButton[index]:getClickTexture():setUV(  x1, y1, x2, y2  )

				_uiFuncButton[index]:SetMonoTone(false)
			end
			
		else
			_uiFuncButton[index]:SetShow(false)
		end
	end
	if 6 < funcButtonCount then
		funcButtonCount = 6
	end

	if ( 0 == funcButtonCount ) then
		_uiButtonBack:SetSize( 160, 32 )
		_uiButtonExit:SetSize( 160, 32 )
		_uiButtonBack:ChangeTextureInfoName( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( _uiButtonBack, 1, 364, 155, 396 )
		_uiButtonBack:getBaseTexture():setUV(  x1, y1, x2, y2  )
		_uiButtonBack:setRenderTexture(_uiButtonBack:getBaseTexture())

		_uiButtonBack:ChangeOnTextureInfoName( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( _uiButtonBack, 156, 364, 310, 396 )
		_uiButtonBack:getOnTexture():setUV(  x1, y1, x2, y2  )

		_uiButtonBack:ChangeClickTextureInfoName( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( _uiButtonBack, 311, 364, 465, 396 )
		_uiButtonBack:getClickTexture():setUV(  x1, y1, x2, y2  )


		_uiButtonExit:ChangeTextureInfoName( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( _uiButtonExit, 1, 199, 155, 231 )
		_uiButtonExit:getBaseTexture():setUV(  x1, y1, x2, y2  )
		_uiButtonExit:setRenderTexture(_uiButtonExit:getBaseTexture())

		_uiButtonExit:ChangeOnTextureInfoName( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( _uiButtonExit, 156, 199, 310, 231 )
		_uiButtonExit:getOnTexture():setUV(  x1, y1, x2, y2  )

		_uiButtonExit:ChangeClickTextureInfoName( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_00.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( _uiButtonExit, 311, 199, 465, 231 )
		_uiButtonExit:getClickTexture():setUV(  x1, y1, x2, y2  )


		_uiButtonBack:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NPC_DIALOG_BACK") )
		_uiButtonExit:SetText( PAGetString(Defines.StringSheet_RESOURCE, "DIALOGUE_BTN_EXIT") )
		_uiButtonBack:SetPosX( ( sizeX - ( buttonSize * 2 + buttonGap * ( 2 -1 ))) / 2 )
		_uiButtonExit:SetPosX( ( sizeX - ( buttonSize * 2 + buttonGap * ( 2 -1 ))) / 2 + buttonSize + buttonGap )
	else
		if 0 < ( _uiFuncButton[0]:GetPosX() - buttonSize - buttonGap ) then
			_uiButtonBack:SetSize( 160, 32 )
			_uiButtonExit:SetSize( 160, 32 )
			_uiButtonBack:ChangeTextureInfoName( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( _uiButtonBack, 1, 364, 155, 396 )
			_uiButtonBack:getBaseTexture():setUV(  x1, y1, x2, y2  )
			_uiButtonBack:setRenderTexture(_uiButtonBack:getBaseTexture())

			_uiButtonBack:ChangeOnTextureInfoName( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( _uiButtonBack, 156, 364, 310, 396 )
			_uiButtonBack:getOnTexture():setUV(  x1, y1, x2, y2  )

			_uiButtonBack:ChangeClickTextureInfoName( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( _uiButtonBack, 311, 364, 465, 396 )
			_uiButtonBack:getClickTexture():setUV(  x1, y1, x2, y2  )


			_uiButtonExit:ChangeTextureInfoName( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_00.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( _uiButtonExit, 1, 199, 155, 231 )
			_uiButtonExit:getBaseTexture():setUV(  x1, y1, x2, y2  )
			_uiButtonExit:setRenderTexture(_uiButtonExit:getBaseTexture())

			_uiButtonExit:ChangeOnTextureInfoName( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_00.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( _uiButtonExit, 156, 199, 310, 231 )
			_uiButtonExit:getOnTexture():setUV(  x1, y1, x2, y2  )

			_uiButtonExit:ChangeClickTextureInfoName( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_00.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( _uiButtonExit, 311, 199, 465, 231 )
			_uiButtonExit:getClickTexture():setUV(  x1, y1, x2, y2  )


			_uiButtonBack:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NPC_DIALOG_BACK") )
			_uiButtonExit:SetText( PAGetString(Defines.StringSheet_RESOURCE, "DIALOGUE_BTN_EXIT") )
			_uiButtonBack:SetPosX( _uiFuncButton[0]:GetPosX() - buttonSize - buttonGap )
			_uiButtonExit:SetPosX( _uiFuncButton[funcButtonCount-1]:GetPosX() + buttonSize + buttonGap )
		else
			_uiButtonBack:SetSize( 32, 32 )
			_uiButtonExit:SetSize( 32, 32 )
			_uiButtonBack:ChangeTextureInfoName( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_09.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( _uiButtonBack, 1, 100, 33, 132 )
			_uiButtonBack:getBaseTexture():setUV(  x1, y1, x2, y2  )
			_uiButtonBack:setRenderTexture(_uiButtonBack:getBaseTexture())

			_uiButtonBack:ChangeOnTextureInfoName( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_09.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( _uiButtonBack, 156, 100, 188, 132 )
			_uiButtonBack:getOnTexture():setUV(  x1, y1, x2, y2  )

			_uiButtonBack:ChangeClickTextureInfoName( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_09.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( _uiButtonBack, 311, 100, 343, 132 )
			_uiButtonBack:getClickTexture():setUV(  x1, y1, x2, y2  )

			_uiButtonExit:ChangeTextureInfoName( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_09.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( _uiButtonExit, 1, 133, 33, 165 )
			_uiButtonExit:getBaseTexture():setUV(  x1, y1, x2, y2  )
			_uiButtonExit:setRenderTexture(_uiButtonExit:getBaseTexture())

			_uiButtonExit:ChangeOnTextureInfoName( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_09.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( _uiButtonExit, 156, 133, 188, 165 )
			_uiButtonExit:getOnTexture():setUV(  x1, y1, x2, y2  )

			_uiButtonExit:ChangeClickTextureInfoName( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_09.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( _uiButtonExit, 311, 133, 343, 165 )
			_uiButtonExit:getClickTexture():setUV(  x1, y1, x2, y2  )
			_uiButtonBack:SetText("")
			_uiButtonExit:SetText("")
			_uiButtonBack:SetPosX( _uiFuncButton[0]:GetPosX() - (buttonGap*4) )
			_uiButtonExit:SetPosX( _uiFuncButton[funcButtonCount-1]:GetPosX() + buttonSize + buttonGap )
		end
	end
	

	if ( dialogData:isHaveBeginerQuest() ) then
		_uiButtonBack:SetShow(false)
		_uiButtonExit:SetShow(false)
	else 
		_uiButtonBack:SetShow(true)
		_uiButtonExit:SetShow(true)
	end
	
	Panel_Npc_Quest_Reward:SetPosX( sizeX - Panel_Npc_Quest_Reward:GetSizeX());
	Panel_Npc_Quest_Reward:SetPosY( sizeY - Panel_Npc_Quest_Reward:GetSizeY() - Panel_Npc_Dialog:GetSizeY());

	FGlobal_ShowRewardList(isVisible)
	

	_SpacebarIcon:SetPosX( _rBtnPosX + _SpacebarIcon:GetSizeX() + 10 )
	_SpacebarIcon:SetPosY( _rBtnPosY )
	-- 계속 버튼에도 나올 때에도 R 아이콘 띄워주고 단축키 먹게..
	if ( isShowReContactDialog() ) or ( _uiNextButton:GetShow() ) or ( isShowDialogFunctionQuest() ) or ( -1 < questDialogIndex() ) or ( -1 < exchangalbeButtonIndex() ) then
		_SpacebarIcon:SetShow(true)
		if ( 1 == _btnPositionType ) then
			_SpacebarIcon:SetPosX( _rBtnPosX + _SpacebarIcon:GetSizeX() + 10 )
			_SpacebarIcon:SetPosY( _rBtnPosY )
		elseif ( 2 == _btnPositionType ) then
			_SpacebarIcon:SetPosX( _rBtnPosX + _SpacebarIcon:GetSizeX() + 10 )
			_SpacebarIcon:SetPosY( _rBtnPosY )
		elseif ( 3 == _btnPositionType ) then
			_SpacebarIcon:SetPosX( startPosX + buttonSize - _SpacebarIcon:GetSizeX() - 5 )
			_SpacebarIcon:SetPosY( _uiFuncButton[0]:GetPosY() + 5 )
		elseif ( 4 == _btnPositionType ) then
			_SpacebarIcon:SetPosX( _rBtnPosX + _SpacebarIcon:GetSizeX() + 10 )
			_SpacebarIcon:SetPosY( _questDialogButtonPosY )
		elseif ( 5 == _btnPositionType ) then
			_SpacebarIcon:SetPosX( _rBtnPosX + _SpacebarIcon:GetSizeX() + 10 + _rBtnPlusPosX )
			_SpacebarIcon:SetPosY( _exchangalbeButtonPosY + 2 )
		end
	else
		_SpacebarIcon:SetShow(false)
	end
	
	for i = 0, 5 do
		if true == handleClickedQuestComplete and true == nextQuestFunctionBtnClick[i] then
			handleClickedQuestComplete = false
			nextQuestFunctionBtnClick[i] = false
			-- HandleClickedFuncButton(i)
			Dialog_clickFuncButtonReq(index);
			Panel_Interest_Knowledge_Hide()
			if ( -1 < questDialogIndex()) then
				HandleClickedDialogButton(questDialogIndex())
				handleClickedQuestComplete = false
			end
			break
		end
	end
	
end


-- 대화창 닫기
function FromClient_hideDialog(isSetWait)
	if ( false == Panel_Npc_Dialog:IsShow() ) then
		return
	end
	
	SetUIMode(Defines.UIMode.eUIMode_Default)
	hide_DialogSceneUIPanel() 		-- dialogSceneUI 를 숨겨준다.
	InventoryWindow_Close()			-- 잠재력 전이 후 인벤토리 필터 초기화를 위해 일단 꺼준다.(원래 켜있는 상태로 들어왔다면, 꺼졌다가 켜질 것임.)
	dialog_CloseNpcTalk(isSetWait)

	Panel_Npc_Dialog:ResetVertexAni()

	searchView_Close()
	setIgnoreShowDialog(false)

	FGlobal_ShowRewardList(false)
	setShowLine(true)

	_blackStone_CallingTime = 0
	
	setFullSizeMode( false, FullSizeMode.fullSizeModeEnum.Dialog )

	HandleMLUp_SkillWindow_Close()
	click_DeliveryForPerson_Close()	-- pc운송관련 초기화
	NpcShop_WindowClose()
	
	if isMonsterBarShow then
		Panel_Monster_Bar:SetShow( true, false )
		isMonsterBarShow = false
	end

	if isNpcNaviShow then
		isNpcNaviShow = false
	end
	
	FGlobal_NpcNavi_ShowRequestOuter()		-- 다이알로그 UI 열기 전 NPC찾기 창 상태로 되돌림
	
	AcquireDirecteReShowUpdate()
	isAuctionDialog = false
	
	updateQuestWindowList( FGlobal_QuestWindowGetStartPosition() )
	updateQuestWidgetList( FGlobal_QuestWidgetGetStartPosition() )

	PaGlobalAppliedBuffList:show()
	--AppliedBuffList_Show()

	setShowNpcDialog(false)
	
	ChatInput_Close()
	if Panel_Window_Exchange:IsShow() then
		ExchangePc_MessageBox_CloseConfirm()
	end
	
	Panel_Interest_Knowledge_Hide()
	
	inEnduarance_WeightCheck()	-- 무게 위젯 갱신.
	Inventory_PosLoadMemory()
	
	UIMain_QuestUpdate()
	
	if ToClient_IsSavedUi() then
		ToClient_SaveUiInfo( true )
		ToClient_SetSavedUi( false )
	end
end	

local _indexWhenWorkerShopClicked
function RandomWorkerSelectUseMyWpConfirm( index )
	if nil == index then
		index = _indexWhenWorkerShopClicked
	end
	npcShop_requestList( CppEnums.ContentsType.Contents_Shop )
	Dialog_clickFuncButtonReq(index)
	Panel_Interest_Knowledge_Hide()
end
------------------------------------------------------------------------------------------------------------------------------
function HandleClickedFuncButton(index)
	if Panel_Win_System:GetShow() then
		return
	end
	--"퀘스트" = 0, 1 , "상점", "스킬", "수리", "경매", "여관", "창고", "친해지기", "마구간", "운송", "영주정보", "추출"
	-- 버튼을 클릭할 때에 Dialog에서 열수있는 UI는 전부 닫아준다 (20130830:홍민우)
	NpcShop_WindowClose()						-- 상점(내부에서 인벤 닫음)
	HandleMLUp_SkillWindow_Close()				-- 스킬
	-- FGlobal_AuctionWindow_Hide()				-- 경매 닫기
	Warehouse_Close()							-- 창고(내부에서 인벤 닫음)
	FGlobal_ItemMarketRegistItem_Close()		-- 아이템 거래소
	TerritoryAuth_Auction_Close()				-- 황실 무역 권한
	InventoryWindow_Close()
	Panel_Dialogue_Itemtake:SetShow(false)		-- 아이템 수령
	LordMenu_Hide()								-- 영주 정보
	CreateClan_Close()							-- 길드 창설
	Manufacture_Close()							-- 가공
	WorkerAuction_Close()						-- 일꾼 거래소
	Panel_Exchange_Item_Hide()					-- 아이템 교환 목록
	-- FGlobalEnchant_Hide()						-- 잠재력 추출(내부에서 인벤 닫음)
	-- Socket_WindowClose()						-- 잠재력 전이(내부에서 인벤 닫음)
	---------------------------------------------- 추출
	--(20130830:홍민우)
	--수리,친해지기,마구간은 눌르면 다른거 클릭 못함으로 없다
	local count = 0
	local targetWindowList = {}
	audioPostEvent_SystemUi(00,00)

	local dialogData = ToClient_GetCurrentDialogData()
	if (nil == dialogData) then
		return
	end
	
	local dlgFuncCnt = dialogData:getFuncButtonCount()

	if( dlgFuncCnt <= 0 ) then
		return
	end
	
	local funcButton = dialogData:getFuncButtonAt(index)
	if( nil == funcButton ) then
		return
	end
	
	local funcButtonType = tonumber(funcButton._param)

	local MyWp = getSelfPlayer():getWp()

	if( CppEnums.ContentsType.Contents_Shop == funcButtonType)		then 		-- 상점
		local shopType = dialogData:getShopType()

		if _shopType.eShopType_Worker == shopType then
			_indexWhenWorkerShopClicked = index
			local pcPosition = getSelfPlayer():get():getPosition()
			local regionInfo = getRegionInfoByPosition(pcPosition)

			local region = regionInfo:get()

			local regionPlantKey = regionInfo:getPlantKeyByWaypointKey()
			local waitWorkerCount = ToClient_getPlantWaitWorkerListCount(regionPlantKey, 0)
			local maxWorkerCount = ToClient_getTownWorkerMaxCapacity(regionPlantKey)
			
			if 0 ~= getSelfPlayer():get():checkWorkerWorkingServerNo() then
				local messageboxData3 = { title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"), content = PAGetString( Defines.StringSheet_GAME, "Lua_WorkerShop_Cant_Employ_NotSameServerNo" ),  functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
				MessageBox.showMessageBox( messageboxData3 )
				return 
			end

			if waitWorkerCount == maxWorkerCount then
				local messageboxData = { title = PAGetString( Defines.StringSheet_GAME, "Lua_WorkerShop_ReSelect"), content = PAGetString( Defines.StringSheet_GAME, "Lua_WorkerShop_Cant_Employ" ),  functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
				MessageBox.showMessageBox( messageboxData )
				return
			end
			if 5 <= MyWp then
				local messageboxData2 = { title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"), content = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_CONFIRM_WORKER", "MyWp", MyWp ),  functionYes = RandomWorkerSelectUseMyWpConfirm, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
				MessageBox.showMessageBox( messageboxData2 )
				return
			end
			
			
		end
		if _shopType.eShopType_RandomShop == shopType then  -- 무작위 아이템 뽑기 샵
			local randomShopConsumeWp = FromClient_getRandomShopConsumWp()
			if MyWp < randomShopConsumeWp then
				local messageboxData2 = { title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"), content = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_LACK_WP", "randomShopConsumeWp", randomShopConsumeWp, "MyWp", MyWp ),  functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
				MessageBox.showMessageBox( messageboxData2 )
				return
			elseif randomShopConsumeWp <= MyWp then
				local messageboxData2 = { title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"), content = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_CONFIRM_RANDOMITEM_WP", "randomShopConsumeWp", randomShopConsumeWp, "MyWp", MyWp ),  functionYes = RandomWorkerSelectUseMyWpConfirm, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
				MessageBox.showMessageBox( messageboxData2 )
				return
			end
		end

		if _shopType.eShopType_DayRandomShop == shopType then
			local randomShopConsumeWp = 10
			if MyWp < randomShopConsumeWp then
				local messageboxData2 = { title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"), content = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_LACK_WP", "randomShopConsumeWp", randomShopConsumeWp, "MyWp", MyWp ),  functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
				MessageBox.showMessageBox( messageboxData2 )
				return
			elseif randomShopConsumeWp <= MyWp then
				local messageboxData2 = { title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"), content = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_CONFIRM_RANDOMITEM_WP", "randomShopConsumeWp", randomShopConsumeWp, "MyWp", MyWp ),  functionYes = RandomWorkerSelectUseMyWpConfirm, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
				MessageBox.showMessageBox( messageboxData2 )
				return
			end
		end

		count = 2
		targetWindowList = { Panel_Window_NpcShop, Panel_Window_Inventory }
		show_DialogPanel()							-- dialogScene
	elseif( CppEnums.ContentsType.Contents_Skill == funcButtonType)	then 		-- 스킬
		count = 1
		targetWindowList = { Panel_Window_Skill }

	-- elseif( CppEnums.ContentsType.Contents_Repair == funcButtonType)	then 	-- 수리
	-- 	-- __noop;

	elseif( CppEnums.ContentsType.Contents_Auction == funcButtonType)	then 	-- 경매
		-- __noop;

	elseif( CppEnums.ContentsType.Contents_Inn == funcButtonType)	then 		-- 여관
		--count = 1
		--targetWindowList = { Panel_Inn }

	-- elseif( CppEnums.ContentsType.Contents_Warehouse == funcButtonType)	then 	-- 창고
	-- 	-- count = 1
	-- 	-- targetWindowList = { Panel_Window_Warehouse,--[[ Panel_Window_Inventory]] }
	-- 	Warehouse_OpenPanelFromDialog()

	elseif( CppEnums.ContentsType.Contents_IntimacyGame == funcButtonType)	then -- 친해지기
		-- __noop;
	--elseif( 8 == funcButtonType)	then 										-- 마구간
	--	count = 1
	--	targetWindowList = { Panel_Window_StableList }
	-- elseif( CppEnums.ContentsType.Contents_Transfer == funcButtonType)	then 	-- 운송
		-- count = 1
		-- targetWindowList = { --[[Panel_Window_Delivery_Information,]] Panel_Window_Warehouse }

	elseif CppEnums.ContentsType.Contents_DeliveryPerson == funcButtonType then	-- PC 운송
		count = 1
		targetWindowList = { Panel_Window_DeliveryForPerson }

	elseif( CppEnums.ContentsType.Contents_Guild == funcButtonType)	then 		-- 길드 창설
		FGlobal_GuildCreateManagerPopup();
		--count = 1
		--targetWindowList = { Panel_Window_Delivery, Panel_Window_Warehouse }

	elseif( CppEnums.ContentsType.Contents_Explore == funcButtonType)	then 	-- 길드 창설
		-- UI.debugMessage("농장이용");

	elseif( CppEnums.ContentsType.Contents_Enchant == funcButtonType) then		-- 잠재력 돌파
		FGlobalEnchant_Show()	-- 인벤 내부 오픈

	elseif( CppEnums.ContentsType.Contents_Socket == funcButtonType) then		-- 잠재력 전이
		Socket_Window_Show()	-- 인벤 내부 오픈

	elseif( CppEnums.ContentsType.Contents_LordMenu == funcButtonType) then	-- 영지 정보
		LordMenu_Show()
	
	elseif( CppEnums.ContentsType.Contents_Extract == funcButtonType) then	-- 추출
		extraction_Open()
	elseif( CppEnums.ContentsType.Contents_TerritoryTrade == funcButtonType) then	-- 영지 무역(황실 무역)
		npcShop_requestList( funcButtonType )
	elseif( CppEnums.ContentsType.Contents_TerritorySupply == funcButtonType) then	-- 영지 납품(활실 납품)
		npcShop_requestList( funcButtonType )
	elseif( CppEnums.ContentsType.Contents_GuildShop == funcButtonType ) then -- 길드 상점
		count = 2
		targetWindowList = { Panel_Window_NpcShop, Panel_Window_Inventory }
		--show_DialogPanel()
	elseif( CppEnums.ContentsType.Contents_SupplyShop == funcButtonType ) then
		npcShop_requestList( funcButtonType )
	elseif( CppEnums.ContentsType.Contents_FishSupplyShop == funcButtonType ) then
		npcShop_requestList( funcButtonType )
	elseif( CppEnums.ContentsType.Contents_GuildSupplyShop == funcButtonType ) then
		npcShop_requestList( funcButtonType )
	elseif( CppEnums.ContentsType.Contents_MinorLordMenu == funcButtonType ) then
		--태곤
		FGlobal_NodeWarMenuOpen()
	end

	Dialog_innerPanelShow(count, targetWindowList)

	if( CppEnums.ContentsType.Contents_Shop == funcButtonType)		then
		--NpcShop_WindowShow()				-- 인벤토리가 먼저 뜨고 상점 창이 뜨는 상황문제로 무역시 문제가 있어서 상점 정보를 받아오는 시점에 띄우도록 하였습니다. (20140205 juicepia)

		-- TODO :: lovelyk2 - 상점 목록을 요청하는 코드로 변경해야 함!!!
		npcShop_requestList( funcButtonType )
		FGlobal_NodeWarMenuClose()
	elseif( CppEnums.ContentsType.Contents_Skill == funcButtonType)	then
		HandleMLUp_SkillWindow_OpenForLearn()

	elseif( CppEnums.ContentsType.Contents_Repair == funcButtonType ) then 		-- 수리화면을 보여준다.
		Repair_OpenPanel( true)

	elseif( CppEnums.ContentsType.Contents_Warehouse == funcButtonType)	then	-- 창고
		Warehouse_OpenPanelFromDialog()

	elseif( CppEnums.ContentsType.Contents_Stable == funcButtonType)	then
		if	( isGuildStable() )	then
			GuildStableFunction_Open()
		else
			warehouse_requestInfoFromNpc()
			-- 마구간 기능 버튼과 말 리스트, 2개의 UI를 오픈한다. +@ 길드 마구간.
			if	( CppEnums.ServantType.Type_Vehicle == stable_getServantType() )	then
				StableFunction_Open()
			elseif	( CppEnums.ServantType.Type_Ship == stable_getServantType() )	then
				WharfFunction_Open()
			else
				PetFunction_Open()
				PetList_Open()
			end
		end
		
		-- 상점
		--if	npcShop_isShopContents()	then
		--	npcShop_requestList( funcButtonType )
		--end

		show_DialogPanel()
	elseif( CppEnums.ContentsType.Contents_Transfer == funcButtonType)	then	-- 운송
		-- Warehouse_OpenPanelFromDialogWithoutInventory()
		DeliveryInformation_OpenPanelFromDialog()

	elseif( CppEnums.ContentsType.Contents_Explore == funcButtonType)	then 	-- 길드 창설

	elseif CppEnums.ContentsType.Contents_DeliveryPerson == funcButtonType then	-- 정류장
		--panel_DeliveryForPorson_Show( true )
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "Lua_deliveryPerson_ReMake") )
	elseif CppEnums.ContentsType.Contents_GuildShop == funcButtonType then	-- 길드 상점
		npcShop_requestList( funcButtonType )
		
	elseif CppEnums.ContentsType.Contents_ItemMarket == funcButtonType then	-- 아이템 판매소
		if not Panel_Window_ItemMarket:GetShow() then
			FGolbal_ItemMarket_Function_Open()
		else
			FGolbal_ItemMarket_Function_Close()
		end
	elseif CppEnums.ContentsType.Contents_Knowledge == funcButtonType then	-- 지식 관리
		FGlobal_KnowledgeManagementShow()
	
	elseif CppEnums.ContentsType.Contents_Join == funcButtonType then		-- 참전
		Panel_Join_Show()
	end

	Dialog_clickFuncButtonReq(index);
	Panel_Interest_Knowledge_Hide()
end

function FGlobal_FirstLearnSkill_WindowShow()
	_skillTutorial = true
	HandleClickedFuncButton(1)
	_skillTutorial = false
end

function isSkillLearnTutorial()
	return _skillTutorial
end

function Dialog_innerPanelShow(count, targetWindowList)
	if ( count <= 0 ) then
		return
	end

	dialog_setPositionSelectList(count)
	local index = 0
	for _,v in pairs(targetWindowList) do
		dialog_setPositionSelectSizeSet(index, v:GetSizeX(), v:GetSizeY() )
		index = index +1
	end

	dialog_calcPositionSelectList()

	index = 0
	for _,v in pairs(targetWindowList) do
		if ( false == v:GetShow() ) then
			local pos = dialog_PositionSelect(index)
			if ( 0 ~= pos.x ) or ( 0 ~= pos.y ) then
				if ( v == Panel_Window_Inventory ) then
				--	Inventory_PosSaveMemory()	-- 인벤 위치 저장
				--	Panel_Window_Inventory:SetShow( true, false )
				end
				
				v:ComputePos()
				v:SetPosX( pos.x )
				v:SetPosY( pos.y )	
					
				-- v:SetShow(true, true)
				-- if ( v == Panel_Window_Warehouse ) then
					-- v:SetShow(true, true)
				-- end

				--animation 추가
				index = index + 1
			else
				break
			end
		end
	end

end

function HandleClickedDialogButton(index)
	if Panel_Win_System:GetShow() then
		return
	end
	local _selectRewardItemName = FGlobal_SelectedRewardConfirm()
	_doConfirmIndex = index
	-- 선택보상 아이템 선택한게 있고, 퀘스트가 완료 상태라면 알림창 띄움
	if ( _selectRewardItemName ~= false and _isQuestComplete == true ) then
		local	messageBoxTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS") -- "알 림"
		local	messageBoxMemo	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_NOTIFICATIONS_SELECTREWARD", "_selectRewardItemName", _selectRewardItemName ) -- _selectRewardItemName.."' \n아이템을 선택하시겠습니까?"
		local	messageBoxData	= { title = messageBoxTitle, content = messageBoxMemo, functionYes = _doConfirmYes, functionNo = _doConfirmNo, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData, "middle")
		return
	else
		HandleClickedDialogButtonReal(_doConfirmIndex)
	end
end

function _doConfirmYes()
	FGlobal_SelectRewardItemNameClear()
	HandleClickedDialogButtonReal(_doConfirmIndex)
end

function _doConfirmNo()
end

function HandleClickedDialogButtonReal(index)	
	local dialogData = ToClient_GetCurrentDialogData()
	local dlgBtnCnt = dialogData:getDialogButtonCount()

	if( dlgBtnCnt <= 0 ) then
		_PA_LOG("김창욱", "from. 최대호. 다이얼로그 lua 2011라인. 이런일이 생기면 안됩니다. 확인해주세요")
		return
	end

	index = index + _dialogIndex
	
	local clickDialogButtonReq = function()
		local displayData = Dialog_getButtonDisplayData(index)
		local questInfo = questList_isClearQuest(1038, 2)
		if displayData:empty() then
			Dialog_clickDialogButtonReq(index)
			if questInfo then
				handleClickedQuestComplete = false
			elseif  10 < getSelfPlayer():get():getLevel() then
				handleClickedQuestComplete = false
			else
				handleClickedQuestComplete = true
			end
		else
			TalkPopup_SelectedIndex(index)
			TalkPopup_Show(displayData)
		end
	end
	
	if ( true == isCheckExchangeItemButton( index )) then			-- 잡템 교환 버튼이 눌렸다면 오디오 재생
		audioPostEvent_SystemUi(00,17)
		
		local dialogButton = dialogData:getDialogButtonAt(index)
		if ExpirationItemCheck( dialogButton:getNeedItemKey() ) then
			local CancelExchange = function()	return	end
			local GoExchange = function()
				HandleClickedDialogButton_ShowData(index)
			end
			local stringExchange = PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_ITEMEXCHANGE_EXPIRATIONCHECK")		-- "기간 만료된 아이템은 교환할 수 없습니다.\n계속 하시겠습니까?"
			local messageboxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_ITEMEXCHANGE_TITLE"), content = stringExchange,  functionYes = GoExchange, functionNo = CancelExchange, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
			MessageBox.showMessageBox( messageboxData )
		else
			local needItemCount = dialogButton:getNeedItemCount()
			if ( UI_BTN_TYPE.eDialogButton_Exchange == dialogButton._dialogButtonType ) and ( 0 < needItemCount ) then		-- 버튼 타입이 교환이면
				local itemStaticWrapper = getItemEnchantStaticStatus( ItemEnchantKey(dialogButton:getNeedItemKey()) );
				if ( itemStaticWrapper ~= nil ) then																		-- 잡템 교환이면?
					local itemCount = ExchangeItem_HaveCount( dialogButton:getNeedItemKey() )
					if 0 < itemCount then																					-- 교환할 아이템이 있다면
						local exchangeCount = math.floor(itemCount/needItemCount)
						if 1 < exchangeCount then																			-- 교환할 게 여러 개라면
							if dialogButton._isValidMultipleExchange then													-- 교환할 아이템이 랜덤하게 나오지 않으면,
								local dialogExchangeCountSet = function( inputNum )
									local itemStaticWrapper = getItemEnchantStaticStatus( ItemEnchantKey(dialogButton:getNeedItemKey()) )
									local _exchangeCount = Int64toInt32( inputNum )
									local doExchange = function()
										dialogData:setExchangeCount( _exchangeCount )
										clickDialogButtonReq()
									end
									
									local exchangeOne = function()
										dialogData:setExchangeCount( 1 )
										clickDialogButtonReq()
									end
									
									local	messageBoxTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS") -- "알 림"
									local	messageBoxMemo	= PAGetStringParam2(Defines.StringSheet_GAME, "LUA_DIALOG_EXCHANGEITEM", "itemName", itemStaticWrapper:getName(), "count", _exchangeCount*needItemCount ) -- "<<PAColor0xFF96D4FC>" .. itemStaticWrapper:getName() .. "<PAOldColor>> <PAColor0xFFFFCE22>" .. _exchangeCount*needItemCount .. "<PAOldColor>개를 모두 교환하시겠습니까?\n취소 시 한 번만 교환됩니다."
									local	messageBoxData	= { title = messageBoxTitle, content = messageBoxMemo, functionYes = doExchange, functionNo = exchangeOne, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
									MessageBox.showMessageBox(messageBoxData, "middle")
								end
								
								Panel_NumberPad_Show( true, toInt64(0, exchangeCount), 0, dialogExchangeCountSet )
								return
							end
						end
					end
				end
			end		
			clickDialogButtonReq()
			-- HandleClickedDialogButton_ShowData(index)
		end
	else
		HandleClickedDialogButton_ShowData(index)
	end
end
function ExchangeItem_HaveCount( itemKey )
	local selfProxy		= getSelfPlayer():get()
	if nil == selfProxy then
		return
	end
	
	local itemCount = 0
	local inventory		= selfProxy:getInventory()
	local	invenUseSize		= getSelfPlayer():get():getInventorySlotCount( true )
	local	useStartSlot		= inventorySlotNoUserStart()
	local invenSize = invenUseSize - useStartSlot
	for i = 1, invenSize - 1 do
		if not inventory:empty( i ) then
			local itemWrapper = getInventoryItem( i )
			if nil ~= itemWrapper then
				if itemKey == itemWrapper:get():getKey():getItemKey() then
					itemCount = Int64toInt32(itemWrapper:get():getCount_s64())
					return itemCount
				end
			end
		end
	end
	return itemCount
end
	
function 	HandleClickedDialogButton_ShowData(index)
	local displayData = Dialog_getButtonDisplayData(index)
	-- local questInfo = ToClient_GetQuestInfo(1038, 2)
	local questInfo = questList_isClearQuest(1038, 2)
	if displayData:empty() then
		Dialog_clickDialogButtonReq(index)
		if questInfo then
			-- if questInfo._isCleared then
				handleClickedQuestComplete = false
			-- else
				-- handleClickedQuestComplete = true
			-- end
		elseif  10 < getSelfPlayer():get():getLevel() then
			handleClickedQuestComplete = false
		else
			handleClickedQuestComplete = true
		end
		
		-- local dialogData = ToClient_GetCurrentDialogData()
		-- if (nil == dialogData) then
			-- return
		-- end
		-- local linkType = dialogData:getDialogButtonAt(0)._linkType
		-- if CppEnums.DialogState.eDialogState_QuestComplete == tostring(linkType) then
			-- handleClickedQuestComplete = true
		-- end
	else
		TalkPopup_SelectedIndex(index)
		TalkPopup_Show(displayData)
	end
end

-- 교환 아이템에 기간 만료된 아이템을 갖고 있는지 체크
function ExpirationItemCheck( itemKey )
	local selfProxy		= getSelfPlayer():get()
	if nil == selfProxy then
		return
	end
	
	local inventory		= selfProxy:getInventory()
	local invenSize	= getSelfPlayer():get():getInventorySlotCount( true )
	for i = 1, invenSize - 1 do
		if not inventory:empty( i ) then
			local itemWrapper = getInventoryItem( i )
			if nil ~= itemWrapper then
				if itemKey == itemWrapper:get():getKey():getItemKey() then
					local itemExpiration = itemWrapper:getExpirationDate()
					if (nil ~= itemExpiration) and (false == itemExpiration:isIndefinite()) then
						local remainTime = Int64toInt32(getLeftSecond_s64( itemExpiration ))
						if remainTime <= 0 then					-- 기간 만료된 아이템이 있다면
							return true
						end
					end
				end
			end
		end
	end
	
	return false
end

-- dialog 닫는 글로벌  함수
function FGlobal_HideDialog()
	if Panel_Win_System:GetShow() then
		return
	end

--	FromClient_hideDialog(true)
--	questWidget_updateScrollButtonSize()							-- 퀘스트 위젯 스크롤 버튼 사이즈 다시 계산
--	updateQuestWidgetList( FGlobal_QuestWidgetGetStartPosition() )	-- 퀘스트 위젯 위치 잡아주기.
--	QuickSlot_UpdateData()											-- 퀵슬롯 업데이트

	local dialogData = ToClient_GetCurrentDialogData()
	if (nil ~= dialogData and dialogData:isHaveBeginerQuest()) then
		return
	end
	
	ToClient_PopDialogueFlush()
	FromClient_WarehouseUpdate()
	Dialog_PageButton_Init()
	inventory_FlushRestoreFunc()	-- 가방에 토템 등 버튼 활성화를 시켜야 한다.
	handleClickedQuestComplete = false
	
	if getSelfPlayer():get():getLevel() < 5 then
		Panel_Chat0:SetShow( false )
	end
	-- FGlobal_LocalWar_Show()
	FGlobal_NewLocalWar_Show()
end

function setIgnoreShowDialog( ignoreShowDialog )
	_ignoreShowDialog = ignoreShowDialog
end

-- 대화창이 켜져 있을 때 죽었을 경우 창을 닫아주기 위하여... 따로 분리 함
function dialog_CloseNpcTalk(isSetWait)
	Panel_MainStatus_User_Bar:SetShow( true )
	Panel_SelfPlayerExpGage:SetShow( true )
	Panel_Chat0:SetShow( true )
	Panel_QuickSlot:SetShow( true )
	Panel_UIMain:SetShow( true )
	--Panel_Radar:SetShow( true )
	FGlobal_Panel_Radar_Show( true )
	Panel_TimeBar:SetShow( true )
	UiOpen_All()
	
	if ( FGlobal_IsChecked_SkillCommand() == true ) then
		Panel_SkillCommand:SetShow( true )
		changePositionBySever(Panel_SkillCommand, CppEnums.PAGameUIType.PAGameUIPanel_SkillCommand, true, true, false)
	else
		Panel_SkillCommand:SetShow( false )
		changePositionBySever(Panel_SkillCommand, CppEnums.PAGameUIType.PAGameUIPanel_SkillCommand, true, true, false)
	end

	FruitageItem_HideTooltip()			-- 친밀도 툴팁 닫아주기
	FruitageValue_ShowTooltip(false)	-- 친밀도 툴팁 닫아주기
	Panel_Dialog_RestoreUI()
	Dialog_clickExitReq(isSetWait)
	checkHpAlertPostEvent()		-- 플레이어의 HP를 체크하여 DANGER ALERT 를 호출한다
	handleClickedQuestComplete = false
end


--- 숨겨진 UI 복원
function Panel_Dialog_RestoreUI()
	SetUIMode( Defines.UIMode.eUIMode_Default )	-- 더 좋은 방법이 있기 전까지는 여기에서 UI Mode 를 변경해준다! - 성경
	if Panel_Npc_Dialog:IsShow() then
		UI.restoreFlushedUI()
		Panel_Npc_Dialog:SetShow(false,true)
	end
	
	if true == IsDialogOpen() then
		UiOpen_All()
		Tutorial_UiRestore()
	end
	
	--여기
	local questNo = getTutorialQuestNo();
	if (-1 == questNo) then
		setTutorialQuestNo(-1);
	elseif(0 ~= questNo) then
		Tutorial_Quest(questNo);
		setTutorialQuestNo(0);
	else
		setTutorialQuestNo(-1);
	end
	
	Inven_FindPuzzle()
	Panel_NewEquip_EffectLastUpdate()
	
	if true == FGlobal_CallBlackSpiritCheck() then
		FGlobal_UiRestoreInTutorial()
	end
	
	--  마구간에 말을 맡기면, 말 관련 창을 닫는다.
	if ExitStable_VehicleInfo_Off() == true then
		Panel_ServantInfo:SetShow( false )
		Panel_CarriageInfo:SetShow( false )
		ServantInventory_Close()
	end

	ExitStable_VehicleInfo_Off( false )
	handleClickedQuestComplete = false

	if ( FGlobal_IsChecked_SkillCommand() == true ) then
		Panel_SkillCommand:SetShow( true )
		changePositionBySever(Panel_SkillCommand, CppEnums.PAGameUIType.PAGameUIPanel_SkillCommand, true, true, false)
	else
		Panel_SkillCommand:SetShow( false )
		changePositionBySever(Panel_SkillCommand, CppEnums.PAGameUIType.PAGameUIPanel_SkillCommand, true, true, false)
	end

end

-- 대화창 종료
function HandleClickedExitButton(isSetWait)
	FromClient_hideDialog(isSetWait)
	questWidget_updateScrollButtonSize()							-- 퀘스트 위젯 스크롤 버튼 사이즈 다시 계산
	updateQuestWidgetList( FGlobal_QuestWidgetGetStartPosition() )	-- 퀘스트 위젯 위치 잡아주기.
	--여기에 퀵슬롯 업데이트를 넣자.
	QuickSlot_UpdateData()

	-- 탑승물 정보창, 인벤토리를 닫는다.
	ServantInfo_Close()
	CarriageInfo_Close()
	ServantInventory_Close()
	FGlobal_RaceInfo_Hide()
	GuildServantList_Close()
end

-- 대화 초기 화면 이동
function HandleClickedBackButton()
	if Panel_Win_System:GetShow() then
		return
	end

	if ( check_ShowWindow() ) then
		close_WindowPanelList()
	end
	
	if Panel_Window_Skill:IsShow() then
		HandleMLUp_SkillWindow_Close()
	end
	if Panel_Window_Warehouse:IsShow() then
		Warehouse_Close()
	end
	if Panel_Window_NpcShop:IsShow() then
		NpcShop_WindowClose()
	end
	
	if Panel_AskKnowledge:IsShow() then
		Panel_AskKnowledge:SetShow(false)
	end
	
	if Panel_TerritoryAuth_Auction:IsShow() then
		TerritoryAuth_Auction_Close()
	end
	
	if Panel_Dialog_Search:IsShow() then
		searchView_Close()
	end
	
	_dialogIndex = 0
	Dialog_PageButton_Init()
	ReqeustDialog_retryTalk()
end


-------------------------- 친밀도  --------------------
local DCCOT = CppEnums.DlgCommonConditionOperatorType
local operatorString = {
	[CppEnums.DlgCommonConditionOperatorType.Equal]	= "",
	[CppEnums.DlgCommonConditionOperatorType.Large]	= "<PAColor0xFFFF0000>▲<PAOldColor>",
	[CppEnums.DlgCommonConditionOperatorType.Small]	= "<PAColor0xFF0000FF>▼<PAOldColor>",
}

local giftshowgap = 0.025
function FruitageItem_ShowTooltip( percent )
	local textSum = ""
	for key, value in pairs(intimacyValueBuffer) do
		--뒤집어진 경우도 봐야됨.
		if ( math.abs(value.giftPercent - percent) < giftshowgap ) or ( math.abs(value.giftPercent - (percent - 1)) < giftshowgap ) or ( math.abs(value.giftPercent - (percent + 1)) < giftshowgap ) then
			if ( textSum ~= "" ) then
				textSum = textSum .. "\n"
			end
			textSum = textSum .. value.giftName .." : ".. value.giftDesc .. "(" .. operatorString[value.giftOperator] .. " " .. value.giftPercent * 1000 .. ")"
		end
	end

	Panel_Npc_Dialog:SetChildIndex( giftNotice, 9999 )
	giftNotice:SetText(textSum)
	giftNotice:SetSize(giftNotice:GetTextSizeX() + 15, giftNotice:GetTextSizeY() + 10)
	giftNotice:SetPosX( getMousePosX() + 10)
	giftNotice:SetPosY( getMousePosY() - Panel_Npc_Dialog:GetPosY() - 35)
	giftNotice:SetShow(true)
end

function FruitageItem_HideTooltip()
	giftNotice:SetShow(false)
end

function FruitageValue_ShowTooltip( isShow )
	intimacyNoticeText:SetAutoResize( true )
	intimacyNoticeText:SetTextMode( UI_TM.eTextMode_AutoWrap )
	intimacyNoticeText:SetSize( 200, 250 )
	intimacyNoticeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_DIALOG_INTIMACYNOTICETEXT")) -- 현재 대화중인 대상과의 친밀도입니다. 어떤 NPC는 친밀감을 보상으로 표현하기도 합니다.
	intimacyNotice:SetPosX(_intimacyCircularProgress:GetPosX())
	intimacyNotice:SetPosY(_intimacyCircularProgress:GetPosY() - 150 )
	if isShow == true then
		intimacyNotice:SetSize(intimacyNoticeText:GetSizeX()+20, intimacyNoticeText:GetSizeY()+20)
		intimacyNotice:SetShow(true)
		intimacyNoticeText:SetShow(true)
	else
		intimacyNotice:SetShow(false)
		intimacyNoticeText:SetShow(false)
	end
end

-------------------------- 탑승물-----------------------
--탑승물 정보 창이 열려 있을 때, 마구간에 맡기면 닫아주기 위해 체크하는 변수
local VehicleInfo_Window = nil

function ExitStable_VehicleInfo_Off( value )
	if value == true then	-- 맡기기를 하고 왔다.
		VehicleInfo_Window = value
	elseif value == false then	-- 맡기기를 하고 창을 닫고 나왔으니, 초기화 시킨다.
		VehicleInfo_Window = value
	end
	return VehicleInfo_Window
end


----------------------------------------------------------------------------
--			최초 흑정령 소환시, 화살표가 나온다.
----------------------------------------------------------------------------
function firstTime_MeetDarkSpirit()
	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		_uiFuncButton[0]:EraseAllEffect()
		return
	end
	local playerLevel = selfPlayer:get():getLevel()	
	if  ( nil == dialog_getTalker() ) and ( playerLevel == 1 ) then
		_uiFuncButton[0]:EraseAllEffect()
		_uiFuncButton[0]:AddEffect( "UI_ArrowMark02", true, 0, -50 )
	else
		_uiFuncButton[0]:EraseAllEffect()
	end

end
firstTime_MeetDarkSpirit()
-----------------------------------------------------------------------------
 
 
 
-------------------------------------------------------------------
-- 					스크린 사이즈 계산하기!
-------------------------------------------------------------------
function FromClient_Dialog_onScreenResize()
	local sizeX = getScreenSizeX()
	local sizeY = getScreenSizeY()

	Panel_Npc_Dialog:SetSize( sizeX, Panel_Npc_Dialog:GetSizeY() )
	
	-- 해상도에 따라 대화 영역 사이즈 변경
	if 1200 < getScreenSizeX() then
		_uiNpcDialog:SetSize( getScreenSizeX() - 300 , _uiNpcDialog:GetSizeY() )
	else
		_uiNpcDialog:SetSize( 900, _uiNpcDialog:GetSizeY() )
	end
	_scrollControl:SetSize( sizeX, sizeY )
	_uiHalfLine:SetSize(sizeX, 6)
	_uiHalfLine:SetVerticalMiddle()
	_uiHalfLine:SetPosY( 70 )
	Panel_Npc_Quest_Reward:SetPosY( sizeY - Panel_Npc_Quest_Reward:GetSizeY() - Panel_Npc_Dialog:GetSizeY())

	for index = 0, 3, 1 do
		_uiDialogButton[index]:SetPosX ( sizeX / 2 - 175 )
		_uiNoticeNeedInfo[index]:SetPosX ( sizeX / 2 + 175 )
		_uiNoticeNeedInfo[index]:SetPosY ( _uiDialogButton[index]:GetPosY() )
		_uiNeedWpAni[index]:SetPosX ( sizeX / 2 + 138 )
		_uiNeedWpAni[index]:SetPosY ( _uiDialogButton[index]:GetPosY() )
	end

	_SpacebarIcon:SetPosX ( _uiDialogButton[0]:GetPosX() + _uiDialogButton[0]:GetSizeX() + 10 )
	_uiNextButton:SetPosX ( sizeX / 2 - 175 )
	_uiButtonExit:SetPosX ( sizeX - string.format("%.0f", sizeX / 13 + 100 ))
	_uiButtonBack:SetPosX ( sizeX - string.format("%.0f", sizeX / 13 + 260 ))
	
	_prevPageButton:SetPosX( _uiNextButton:GetPosX() - _prevPageButton:GetSizeX() * 2 )
	_nextPageButton:SetPosX( _prevPageButton:GetPosX() )
	_pageValue:SetPosX( _prevPageButton:GetPosX() )
	
	InterestKnowledge_onScreenResize()
	
	-- 스크린 사이즈가 바뀌면 R버튼 포지션도 변경
	_rBtnPosX = _uiDialogButton[0]:GetPosX() + _uiDialogButton[0]:GetSizeX() - _SpacebarIcon:GetSizeX() - 5
	_rBtnPosY = _uiDialogButton[0]:GetPosY()
end
-----------------------------------------------------------------------------------

------------------------------------------------
-- 			잠재력 돌파 도움말 표시
------------------------------------------------
function Panel_Dialog_EnchantHelp_Func( isOn )
	local mouse_posX = getMousePosX()
	local mouse_posY = getMousePosY()

	local panel_posX = Panel_Npc_Dialog:GetPosX()
	local panel_posY = Panel_Npc_Dialog:GetPosY()
	
	if ( isOn == true ) then
		_txt_EnchantHelp:SetShow( true )
		_txt_EnchantHelp_Desc:SetShow( true )
		_txt_EnchantHelp:SetAutoResize( true )
		_txt_EnchantHelp_Desc:SetTextMode( UI_TM.eTextMode_AutoWrap )
		_txt_EnchantHelp_Desc:SetText( PAGetString( Defines.StringSheet_GAME,"LUA_DIALOGUE_TXT_ENCHANTHELP" ) )		-- 네 가방 안에 블랙스톤이 보이는걸? 네가 가진 무기나 방어구를 내가 더 강하게 만들어줄게.
		_txt_EnchantHelp:SetSize ( _txt_EnchantHelp_Desc:GetSizeX() + 25, _txt_EnchantHelp_Desc:GetSizeY() + 22 )
		_txt_EnchantHelp:SetPosX( mouse_posX - panel_posX  - 200 )
		_txt_EnchantHelp:SetPosY( mouse_posY - panel_posY  - 80 )
		_txt_EnchantHelp_Desc:SetPosX( mouse_posX - panel_posX  - 190 )
		_txt_EnchantHelp_Desc:SetPosY( mouse_posY - panel_posY  - 80 )
	else
		_txt_EnchantHelp:SetShow( false )
		_txt_EnchantHelp_Desc:SetShow( false )
		_txt_EnchantHelp:SetSize( 250, 60 )
		_txt_EnchantHelp_Desc:SetSize( 230, 40 )
	end
end


------------------------------------------------
--			잠재력 전이 도움말 표시
------------------------------------------------
function Panel_Dialog_SocketHelp_Func( isOn )
	local mouse_posX = getMousePosX()
	local mouse_posY = getMousePosY()

	local panel_posX = Panel_Npc_Dialog:GetPosX()
	local panel_posY = Panel_Npc_Dialog:GetPosY()
	
	if ( isOn == true ) then
		_txt_SocketHelp:SetShow( true )
		_txt_SocketHelp_Desc:SetShow( true )
		_txt_SocketHelp:SetAutoResize( true )
		_txt_SocketHelp_Desc:SetTextMode( UI_TM.eTextMode_AutoWrap )
		_txt_SocketHelp_Desc:SetText( PAGetString( Defines.StringSheet_GAME,"LUA_DIALOGUE_TXT_SOCKETHELP" ) )		-- 네 가방 안에 수정은 무기나 방어구에 다양한 효과를 부여하지, 내가 넣어줄까?
		_txt_SocketHelp:SetSize ( _txt_SocketHelp_Desc:GetSizeX() + 25, _txt_SocketHelp_Desc:GetSizeY() + 22 )
		_txt_SocketHelp:SetPosX( mouse_posX - panel_posX  - 200 )
		_txt_SocketHelp:SetPosY( mouse_posY - panel_posY  - 80 )
		_txt_SocketHelp_Desc:SetPosX( mouse_posX - panel_posX  - 190 )
		_txt_SocketHelp_Desc:SetPosY( mouse_posY - panel_posY  - 80 )
	else
		_txt_SocketHelp:SetShow( false )
		_txt_SocketHelp_Desc:SetShow( false )
		_txt_SocketHelp:SetSize( 250, 60 )
		_txt_SocketHelp_Desc:SetSize( 230, 40 )
	end
end


-- 공헌도 도움말 표시
function wpHelp_Func( isOn )
	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		return
	end
	local Wp = selfPlayer:getWp()
	local mouse_posX = getMousePosX()
	local mouse_posY = getMousePosY()

	local panel_posX = Panel_Npc_Dialog:GetPosX()
	local panel_posY = Panel_Npc_Dialog:GetPosY()
	
	

	if ( Wp < 10 ) and ( isOn == true ) then
		_wpHelp:SetAutoResize( true )
		_wpHelp:SetTextMode( UI_TM.eTextMode_AutoWrap )
		_wpHelp:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_DIALOGUE_TXT_WPHELP" ) ) -- tostring(wpData)
		_wpHelp:SetSize ( _wpHelp:GetSizeX(), (_wpHelp:GetSizeY() + 5 ) + ( _wpHelp:GetTextSizeY() * 2 ) )
		_wpHelp:SetPosX( mouse_posX - panel_posX  - 25 )
		_wpHelp:SetPosY( mouse_posY - panel_posY  - 60 )

		if ( isFirstShowTooltip ) then
			_wpHelp:SetAlpha(0)
			_wpHelp:SetFontAlpha(0)
			isFirstShowTooltip = false
		end

		local AniInfo = UIAni.AlphaAnimation( 1, _wpHelp, 0.0, 0.2 )
		_wpHelp:SetShow(true)
	else
		local aniInfo = UIAni.AlphaAnimation( 0, _wpHelp, 0.0, 0.2 )
		aniInfo:SetHideAtEnd(true)
	end
end

---Dialog가 경매 관련인지 여부 전송
function getAuctionState()
	return isAuctionDialog
end


-------------------------------------------------------------
--		NPC 퇴근시 다이얼로그로부터 파생된 창 닫기
-------------------------------------------------------------
function FromClient_CloseAllPanelWhenNpcGoHome()
	if	GetUIMode() == Defines.UIMode.eUIMode_Stable then
		StableFunction_Close()					-- 마구간 창 닫기
	end

	if	Panel_Window_WharfFunction:GetShow() then
		WharfFunction_Close()					-- 나루터 창 닫기
	end

	if GetUIMode() == Defines.UIMode.eUIMode_Trade then
		closeNpcTrade_Basket()					-- 무역 창 닫기
	end
		
	if GetUIMode() == Defines.UIMode.eUIMode_Repair then
		Repair_OpenPanel(false)					-- 수리 창 닫기
	end
	
	if GetUIMode() == Defines.UIMode.eUIMode_Extraction then
		Extraction_OpenPanel(false)				-- 추출 창 닫기
	end
		
	if GetUIMode() == Defines.UIMode.eUIMode_MentalGame then
		MentalGame_Hide()						-- 이야기 교류 창 닫기
	end
	
	-- NPC 다이얼로그는 닫는 함수는 이 함수 호출 후 클라이언트에서 실행된다
end

function Dialog_MouseToolTips( isShow, tipType, index )
	local name, desc, control = nil, nil, nil
	local Wp = 0
	local playerLevel = 0

	local selfPlayer = getSelfPlayer()
	if nil ~= selfPlayer then
		Wp 			= selfPlayer:getWp()
		playerLevel = selfPlayer:get():getLevel()
	end

	local dialogData = ToClient_GetCurrentDialogData()
	if (nil == dialogData) then
		return
	end

	local funcButton = dialogData:getFuncButtonAt(index)
	local funcButtonType = tonumber(funcButton._param)

	if	tipType == CppEnums.ContentsType.Contents_Quest then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_NewQuest then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_Shop then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_Skill then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_Repair then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_Auction then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_Inn then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_Warehouse then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_IntimacyGame then
		name = funcButton:getText() .. " (" .. funcButton:getNeedWp() .. "/" .. Wp .. ")"
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_Stable then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_Transfer then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_Guild then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_Explore then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_DeliveryPerson then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_Enchant then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_Socket then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_Awaken then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_ReAwaken then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_LordMenu then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_Extract then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_TerritoryTrade then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_TerritorySupply then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_GuildShop then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_ItemMarket then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_Knowledge then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_HelpDesk then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_SupplyShop then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_MinorLordMenu then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_FishSupplyShop then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_GuildSupplyShop then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	elseif tipType == CppEnums.ContentsType.Contents_Join then
		name = funcButton:getText()
		control = _uiFuncButton[index]
	-- elseif 9999 == tipType and 9999 == index then
	-- 	name = "대화종료(ESC)"
	-- 	control = _uiButtonExit
	end

	registTooltipControl(control, Panel_Tooltip_SimpleText)
	if isShow == true then
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function Dialog_EtcButtonToolTips( isShow, tipType )
	local name, desc, control = nil, nil, nil

	if 0 == tipType then -- EXIT버튼
		name	= PAGetString(Defines.StringSheet_RESOURCE, "DIALOGUE_BTN_EXIT")
		control	= _uiButtonExit
	elseif 1 == tipType then -- 처음으로 버튼
		name	= PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NPC_DIALOG_BACK")
		control	= _uiButtonBack
	end

	registTooltipControl(control, Panel_Tooltip_SimpleText)
	if isShow == true then
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end

---------------------------------------------------
-- 추출 화면 호출(임시용)
--------------------------------------------------
function extraction_Open()
	-- CppEnums.VirtualKeyCode.KeyCode_J
	if false == Panel_Window_Extraction:GetShow() then
		Extraction_OpenPanel( true )
	else
		Extraction_OpenPanel( false )
	end
end

function isShowReContactDialog()						-- 계속 버튼에 R 띄우기 체크용
	return isReContactDialog
end
function isShowDialogFunctionQuest()					-- 새로운 퀘스트 버튼에 R 띄우기용
	return isDialogFunctionQuest
end
function questDialogIndex()								-- 아직 받지 않은 퀘스트에 R 띄우기용
	return _questDialogButtonIndex
end
function isCheckExchangeItemButton( index )				-- 교환 버튼 클릭 시 소리 넣기용
	return isExchangeButtonIndex[index]
end
function exchangalbeButtonIndex()						-- 클릭 가능한 교환 버튼 인덱스용
	return _exchangalbeButtonIndex
end

registerEvent("FromClient_ShowDialog", "FromClient_ShowDialog")
registerEvent("FromClient_HideDialog", "HandleClickedExitButton")
registerEvent("FromClient_CloseNpcTalkForDead", "FGlobal_HideDialog" ) -- player가 죽었을 때 대화중이라면...
registerEvent("FromClient_CloseAllPanelWhenNpcGoHome", "FromClient_CloseAllPanelWhenNpcGoHome")
registerEvent("onScreenResize", "FromClient_Dialog_onScreenResize")
registerEvent("FromClient_VaryIntimacy", "FromClient_VaryIntimacy_Dialog")