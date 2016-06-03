Panel_UIMain:SetShow( true, false )

local UI_ANI_ADV	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM 			= CppEnums.EProcessorInputMode
local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color 		= Defines.Color
local VCK 			= CppEnums.VirtualKeyCode
local UI_IT 		= CppEnums.UiInputType
local UIMode 		= Defines.UIMode
local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE

local animationEndTime 			= 0.15	-- 종료시간
local elapsedTime 				= 0			-- 종료까지 흐른시간
local newQuestDeltaTime 		= 0
local isOn						= false;
local checkNewQuestForEffect 	= false

local blackMsgShowTime = 10

-- UIMain 접고 펴기용 변수
local btn_totalSizeTmp	= 0
local btn_totalSize		= 0
local _fold_UIMain		= true
local _use_ForSimpleUI	= true
local _badgeFriend		= nil

local _badges = {
	Count		= 0,
	Quest		= false,
	BlackSpirit	= false,
	Skill		= false,
	Item		= false,
	Knowledge	= false,
	FriendList	= false,
}

local _badgeWidget = UI.getChildControl ( Panel_UIMain, "StaticText_Number" )
-- _badgeWidget:SetShow(false)

local _gameExitButton = false	-- 종료 버튼을 누르고는 interaction같은 호출을 막기위해 사용

Panel_UIMain:RegisterShowEventFunc( true,	'Panel_UIMain_ShowAni()' )
Panel_UIMain:RegisterShowEventFunc( false,	'Panel_UIMain_HideAni()' )

Panel_UIMain:SetIgnore( true )

function Panel_UIMain_ShowAni()
end
function Panel_UIMain_HideAni()
end

-- local widgetPanel

-- 순서가 중요하다!!! 순서대로 화면의 우측부터 나오게 된다!
local MenuButtonId =
{
	-- 내정보, 의뢰, 스킬, 인벤토리, 흑정령, 커뮤니티(친구/편지), 생활(생산, 제작노트), 지식, 설정, 종료
	Btn_GameExit			= 1,	-- 항상 처음 오도록 설정해주자...
	Btn_Setting				= 2,
	Btn_Menu				= 3,
	Btn_BlackStone			= 4,	
	Btn_Beauty				= 5,
	Btn_CashShop			= 6,
	Btn_Mail				= 7,
	Btn_FriendList			= 8,
	Btn_Guild				= 9,
}

local contry = {
	kr = 0,
	jp = 1,
	ru = 2,
	cn = 3,
}
local cashIconTexture = {
	[0] =	{83,		161,	123,	201},	-- 한국
			{165,		202,	205,	242},	-- 일본
			{83,		161,	123,	201},	-- 러시아
			{83,		161,	123,	201},	-- 중국
}

local cashIcon_UiMainchangeButtonTexture = function( control, contry )
	local x1, y1, x2, y2 = setTextureUV_Func( control, cashIconTexture[contry][1], cashIconTexture[contry][2], cashIconTexture[contry][3], cashIconTexture[contry][4] )
	return x1, y1, x2, y2
end

-- 컨트롤들 목록
-- local Widgets				= Array.new()
local MenuButtons			= Array.new()
local showedMenuButtonList	= Array.new()

local _bubbleNotice = UI.getChildControl ( Panel_UIMain, "StaticText_Notice" )
Panel_UIMain:SetChildIndex(_bubbleNotice, 9999 )


local blackQuestIcon	= UI.getChildControl( Panel_NewQuest_Alarm, "Static_BlackIcon" )
local blackQuestCall	= UI.getChildControl( Panel_NewQuest_Alarm, "StaticText_CallingYou" )

local blackSpritCall	= UI.getChildControl( Panel_UIMain, "StaticText_BlackSpritCall")
blackSpritCall:SetShow( false )
local challengeIcon		= UI.getChildControl( Panel_ChallengeReward_Alert, "Static_Icon" )
-- local challengeCall		= UI.getChildControl( Panel_ChallengeReward_Alert, "StaticText_CallingYou")

local buttonAni			= UI.getChildControl( Panel_UIMain, "Static_NewEffect_Ani")

local MenuButton_CheckEnAble = function( buttonType )
	local returnValue = false
	if buttonType == MenuButtonId.Btn_CashShop or buttonType == MenuButtonId.Btn_Beauty then
		if getContentsServiceType() ~= CppEnums.ContentsServiceType.eContentsServiceType_Commercial then
			returnValue = false
		else
			returnValue = true
		end
	else
		returnValue = true
	end
	return returnValue
end

function initMenuButtons()
	-- 메뉴 버튼들 Id 는 여기에 기록해주세요!
	local MenuButtonControlId =
	{
		[MenuButtonId.Btn_GameExit]		= "Button_GameExit",
		[MenuButtonId.Btn_Setting]		= "Button_Setting",
		[MenuButtonId.Btn_Menu]			= "Button_Menu",
		[MenuButtonId.Btn_BlackStone]	= "Button_BlackStone",
		[MenuButtonId.Btn_Beauty]		= "Button_Beauty",
		[MenuButtonId.Btn_CashShop]		= "Button_CashShop",
		[MenuButtonId.Btn_Mail]			= "Button_Mail",
		[MenuButtonId.Btn_FriendList]	= "Button_FriendList",
		[MenuButtonId.Btn_Guild]		= "Button_Guild",
	}
	
	-- 메뉴 버튼들 Mouse_LUp 이벤트 핸들러들은 여기에 기록해주세요!!
	local MenuButtonEventFunction =
	{
		[MenuButtonId.Btn_GameExit]				= "GameExitShowToggle(false)",
		[MenuButtonId.Btn_Setting]				= "showGameOption()",
		[MenuButtonId.Btn_Menu]					= "Panel_Menu_ShowToggle()",
		[MenuButtonId.Btn_BlackStone]			= "GlobalKeyBinder_MouseKeyMap("..UI_IT.UiInputType_BlackSpirit..")",
		[MenuButtonId.Btn_Beauty]				= "IngameCustomize_Show()", 
		[MenuButtonId.Btn_CashShop]				= "GlobalKeyBinder_MouseKeyMap("..UI_IT.UiInputType_CashShop..")", 
		[MenuButtonId.Btn_Mail]					= "GlobalKeyBinder_MouseKeyMap("..UI_IT.UiInputType_Mail..")",
		[MenuButtonId.Btn_FriendList]			= "GlobalKeyBinder_MouseKeyMap("..UI_IT.UiInputType_FriendList..")",
		[MenuButtonId.Btn_Guild]				= "GlobalKeyBinder_MouseKeyMap("..UI_IT.UiInputType_Guild..")",
	}

	MenuButtons:resize( #MenuButtonId, nil )		-- {} 로 채운다!

	local panel = Panel_UIMain
	-- 컨트롤들 Load
	for idx,controlId in ipairs(MenuButtonControlId) do
		-- 컨트롤을 미리 읽어놓는다!

		local button = UI.getChildControl( panel, controlId )
		-- Mouse_On/Out 이벤트 지정!
		button:addInputEvent( "Mouse_On",	"UIMain_MouseOverEvent(" .. idx .. ")" )
		button:addInputEvent( "Mouse_Out",	"UIMain_MouseOutEvent(" .. idx .. ")" )
		button:ActiveMouseEventEffect( true )
		
		-- Mouse_LUp 이벤트 지정
		local eventFunction = MenuButtonEventFunction[idx]
		if nil ~= eventFunction then
			button:addInputEvent( "Mouse_LUp", eventFunction )
		end

		if MenuButtonId.Btn_CashShop == idx then	-- 국가별 펄 상점 버튼 텐스쳐 변경.
			button:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/UIControl/UI_Control_00.dds" )
			local x1, y1, x2, y2 = 0, 0, 0, 0
			if 0 == getGameServiceType() or 1 == getGameServiceType() or 2 == getGameServiceType() or 3 == getGameServiceType() or 4 == getGameServiceType() then										-- 한국
				x1, y1, x2, y2 = cashIcon_UiMainchangeButtonTexture( button, contry.kr )
			elseif 5 == getGameServiceType() or 6 == getGameServiceType() then	-- 일본
				x1, y1, x2, y2 = cashIcon_UiMainchangeButtonTexture( button, contry.jp )
			elseif 7 == getGameServiceType() or 8 == getGameServiceType() then	-- 러시아
				x1, y1, x2, y2 = cashIcon_UiMainchangeButtonTexture( button, contry.ru )
			elseif 9 == getGameServiceType() or 10 == getGameServiceType() then	-- 중국
				x1, y1, x2, y2 = cashIcon_UiMainchangeButtonTexture( button, contry.cn )
			else																-- 그외
				x1, y1, x2, y2 = cashIcon_UiMainchangeButtonTexture( button, contry.kr )
			end
			button:getBaseTexture():setUV(  x1, y1, x2, y2  )
			button:setRenderTexture(button:getBaseTexture())
		end
		
		-- 버튼 이펙트 교체
		buttonAni[idx] = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, button , 'Static_ButtonAni' .. idx )
		CopyBaseProperty( buttonAni,	buttonAni[idx] )
		
		buttonAni[idx]:SetPosX( button[idx]:GetPosX() - 2 )
		buttonAni[idx]:SetPosY( button:GetPosY() )
		buttonAni[idx]:SetShow( false )

		if MenuButton_CheckEnAble(idx) then	-- 유료화에 대한 체크
			button:SetShow( true )
		else
			button:SetShow( false )
		end
		
		MenuButtons[idx] = button
	end
end


---------------------------------------------------------------------------

function Panel_UIMain_CheckBtnVisibility()	-- 메뉴 버튼들의 Show 여부를 결정한다!
	-- 길드에 속해있을 시
	local selfPlayerWrapper = getSelfPlayer()
	local guildShow = (nil ~= selfPlayerWrapper) and selfPlayerWrapper:get():isGuildMember()
	MenuButtons[MenuButtonId.Btn_Guild]:SetShow( guildShow )
	
	-- 보여줘야 할 버튼들의 목록을 만듬!
	showedMenuButtonList = Array.new()
	for idx, button in ipairs( MenuButtons ) do
		if button:GetShow() and ( MenuButton_CheckEnAble(idx) ) then	-- 유료화에 대한 체크
			showedMenuButtonList:push_back( button )
		end
	end
end



-----------------------------------------------------------------
-- 					스크린 사이즈에 맞추기
-----------------------------------------------------------------
function Panel_UIMain_SetScreenSize()
	local ScrX = getScreenSizeX()
	local btn_Count = 10
	Panel_UIMain:SetSize( MenuButtons[MenuButtonId.Btn_GameExit]:GetSizeX() * btn_Count , 38)
	Panel_UIMain:ComputePos()

	-- 화면 크기가 갱신되면, Ani 기준 위치도 변경해줘야 한다!
	local count = showedMenuButtonList:length()
	if 0 == count then
		return
	end

	local _styleInfo		= UI.getChildControl( Panel_UIMain, "Button_PlayerInfo" )
	local startPos_FirstRaw	= (Panel_UIMain:GetSizeX() - _styleInfo:GetSizeX() )
	local gapPos			= -(_styleInfo:GetSizeX() + (_styleInfo:GetSizeX()*0.1))

	local buttonSpanY = 0
	for key,button in ipairs(showedMenuButtonList) do
		button:SetScale(1.0, 1.0)
		button:SetVerticalBottom()
		button:SetPosX( startPos_FirstRaw )
		button:SetSpanSize( button:GetSpanSize().x, 0 )

		btn_totalSizeTmp = btn_totalSizeTmp + button:GetSizeX()
	end

	btn_totalSize = btn_totalSizeTmp
	btn_totalSizeTmp = 0
	
	local SpanY = Panel_UIMain:GetSizeY()
	Panel_NewQuest_Alarm:SetSpanSize(-33, SpanY)	
end

local bubbleNoticeData = {
	{ _x = 70,  _y = 50, _text = PAGetString(Defines.StringSheet_GAME, "LUA_UIMAIN_NOTICE_GAMEEND"), },		-- 1
	{ _x = 70,  _y = 50, _text = PAGetString(Defines.StringSheet_GAME, "LUA_UIMAIN_NOTICE_OPTION"), },		-- 2
	{ _x = 70,  _y = 50, _text = PAGetString(Defines.StringSheet_GAME, "LUA_UIMAIN_GAMEMENU"), },			-- 3
	{ _x = 115, _y = 50, _text = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_UIMAIN_NOTICE_BLACKSTONE", "getKey", keyCustom_GetString_UiKey(UI_IT.UiInputType_BlackSpirit) ), },	-- 4
	{ _x = 115, _y = 50, _text = PAGetString(Defines.StringSheet_GAME, "LUA_UIMAIN_NOTICE_BEAUTY"), },		-- 5
	{ _x = 115, _y = 50, _text = PAGetString(Defines.StringSheet_GAME, "LUA_UIMAIN_NOTICE_CASHSHOP"), },	-- 6
	{ _x = 70, _y = 50, _text = PAGetString(Defines.StringSheet_GAME, "LUA_UIMAIN_NOTICE_MAIL"), },		-- 7
	{ _x = 70, _y = 50, _text = PAGetString(Defines.StringSheet_GAME, "LUA_UIMAIN_NOTICE_FRIEND"), },		-- 8
	{ _x = 70, _y = 50, _text = PAGetString(Defines.StringSheet_GAME, "LUA_UIMAIN_NOTICE_GUILD"), },		-- 9
}

-- 마우스 올렸을 때 효과 함수
function UIMain_MouseOverEvent( index )
	-- ♬ 마우스 올렸을 때 사운드 추가
	audioPostEvent_SystemUi(00,13)
	elapsedTime = 0
	isOn = true;

	local button = MenuButtons[index]
	button:SetAlpha( 1.0 )
	button:ResetVertexAni()
	button:SetVertexAniRun("Ani_Color_UIMain_Bright", true)

	if ( nil ~= bubbleNoticeData[index] ) then
		_bubbleNotice:SetText(bubbleNoticeData[index]._text)
		_bubbleNotice:SetSize(bubbleNoticeData[index]._x, bubbleNoticeData[index]._y)
	else
		_bubbleNotice:SetText(bubbleNoticeData[1]._text)
		_bubbleNotice:SetSize(bubbleNoticeData[1]._x, bubbleNoticeData[1]._y)
	end
	
	_bubbleNotice:SetPosX( button:GetPosX() - _bubbleNotice:GetSizeX() )
	if index < 16 then
		_bubbleNotice:SetPosY( -45 )
	else
		_bubbleNotice:SetPosY( -90 )
	end

	_bubbleNotice:ComputePos()
	_bubbleNotice:SetFontAlpha(0)
	_bubbleNotice:SetAlpha(0)
	_bubbleNotice:SetShow(true)
end

-- 마우스 내렸을 때 효과 함수
function UIMain_MouseOutEvent( index )
	-- ♬ 마우스 뺐을 때 사운드 추가
	elapsedTime = 0
	isOn = false;
	
	local button = MenuButtons[index]
	button:ResetVertexAni()

	_bubbleNotice:SetFontAlpha(1)
	_bubbleNotice:SetAlpha(1)
	MenuButtons_SetAlpha()
end

function MenuButtons_SetAlpha()
	for idx, button in ipairs( MenuButtons ) do
		button:SetAlpha( 0.55 )
	end
end

function UIMain_FriendsUpdate()
	MenuButtons[MenuButtonId.Btn_FriendList]:EraseAllEffect()
    MenuButtons[MenuButtonId.Btn_FriendList]:AddEffect("fUI_Friend_01A", true, -0.5, 0)
end

function FGlobal_ChangeEffectCheck()
	checkNewQuestForEffect = false
end

--{ 각 버튼 관련 이벤트
	--	퀘스트가 있으면 이리로 온다
	local deltaTime = 0
	function UIMain_QuestUpdate()
		if Panel_Npc_Dialog:GetShow() then
			return
		end
		local isColorBlindMode	= ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(CppEnums.GlobalUIOptionType.ColorBlindMode)
		if getSelfPlayer():get():getLevel() < 11 then
			blackMsgShowTime = 5
		else
			if 5 == getGameServiceType() or 6 == getGameServiceType() or 7 == getGameServiceType() or 8 == getGameServiceType() then
				blackMsgShowTime = 5
			else
				blackMsgShowTime = 10
			end
		end

		if ( questList_doHaveNewQuest() ) and ( checkNewQuestForEffect == false ) then
			-- 흑정령은 최우측 하단 아이콘만 켜준다.
			Panel_NewQuest_Alarm:SetShow(false)
			-- blackQuestIcon:SetEnableArea( 0, 0, blackQuestIcon:GetSizeX() + blackQuestCall:GetSizeX(), blackQuestIcon:GetSizeY() )
			-- blackQuestIcon:EraseAllEffect()
			-- blackQuestIcon:AddEffect("UI_DarkSprit_Summon", false, 0, 0)
			-- blackQuestIcon:AddEffect("fUI_DarkSprit_Summon", false, 0, 0)
			-- blackQuestIcon:AddEffect("UI_DarkSpirit_RedAura_Icon", true, 0, 0)
			-- blackQuestIcon:addInputEvent( "Mouse_LUp", "_blackSpritCall_byNewQuestAlarm()" )
			FGlobal_MessageHistory_InputMSG( 0, PAGetString(Defines.StringSheet_GAME, "LUA_UIMAIN_MESSAGEHISTORY_NEWSPRITQUEST") ) -- 임시

			-- 흑정령 켜준다.
			FGlobal_NewMainQuest_Alarm_Open()


			buttonAni[MenuButtonId.Btn_BlackStone]:SetShow( false )
			
			-- ♬ 흑정령 나올때 씨불딱 거려야된다.
			audioPostEvent_SystemUi(04,11)
			if (0 == isColorBlindMode) then
				MenuButtons[MenuButtonId.Btn_BlackStone]:EraseAllEffect()
				MenuButtons[MenuButtonId.Btn_BlackStone]:AddEffect("UI_DarkSprit_Summon", false, 0, 0)
				MenuButtons[MenuButtonId.Btn_BlackStone]:AddEffect("fUI_DarkSprit_Summon", false, 0, 0)
				MenuButtons[MenuButtonId.Btn_BlackStone]:AddEffect("UI_DarkSpirit_RedAura_Icon", true, 0, 0)
				MenuButtons[MenuButtonId.Btn_BlackStone]:AddEffect("fUI_BlackSoul_Aura01", true, 0, 0)
			elseif (1 == isColorBlindMode) then
				MenuButtons[MenuButtonId.Btn_BlackStone]:EraseAllEffect()
				-- MenuButtons[MenuButtonId.Btn_BlackStone]:AddEffect("UI_DarkSprit_Summon", false, 0, 0)
				MenuButtons[MenuButtonId.Btn_BlackStone]:AddEffect("fUI_DarkSprit_Summon", false, 0, 0)
				MenuButtons[MenuButtonId.Btn_BlackStone]:AddEffect("UI_DarkSpirit_RedAura_Icon_A", true, 0, 0)
				MenuButtons[MenuButtonId.Btn_BlackStone]:AddEffect("fUI_BlackSoul_Aura02", true, 0, 0)
			elseif (2 == isColorBlindMode) then
				MenuButtons[MenuButtonId.Btn_BlackStone]:EraseAllEffect()
				-- MenuButtons[MenuButtonId.Btn_BlackStone]:AddEffect("UI_DarkSprit_Summon", false, 0, 0)
				MenuButtons[MenuButtonId.Btn_BlackStone]:AddEffect("fUI_DarkSprit_Summon", false, 0, 0)
				MenuButtons[MenuButtonId.Btn_BlackStone]:AddEffect("UI_DarkSpirit_RedAura_Icon_A", true, 0, 0)
				MenuButtons[MenuButtonId.Btn_BlackStone]:AddEffect("fUI_BlackSoul_Aura02", true, 0, 0)
			end
			-- blackSpritCall:SetPosX( MenuButtons[MenuButtonId.Btn_BlackStone]:GetPosX() )
			-- blackSpritCall:SetPosY( MenuButtons[MenuButtonId.Btn_BlackStone]:GetPosY()-15 )
			blackSpritCall:SetShow( true ) -- blackSpritCall이 없어지거나 아예 숨기면 새로운 흑정령 의뢰가 있다는 nak형식 메시지가 노출되지 않는다.
			blackSpritCall:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_UIMAIN_BLACKSPIRIT_TOOLTIP", "getKey", keyCustom_GetString_UiKey(UI_IT.UiInputType_BlackSpirit) ) )
			blackSpritCall:SetPosX( 103 )
			blackSpritCall:SetPosY( -15 )
			checkNewQuestForEffect = true		-- 한번만 체크해서 이펙트를 한번만 뿌려준다
			
		elseif ( questList_doHaveNewQuest() == false ) and ( checkNewQuestForEffect == true ) then
			MenuButtons[MenuButtonId.Btn_BlackStone]:EraseAllEffect()
			buttonAni[MenuButtonId.Btn_BlackStone]:SetShow( false )

			blackSpritCall:SetShow( false )
			Panel_NewQuest_Alarm:SetShow(false)
			blackQuestIcon:EraseAllEffect()
			checkNewQuestForEffect = false

		end
	end

	function UIMain_ChallengeUpdate()
			challengeIcon:SetEnableArea( 0, 0, challengeIcon:GetSizeX(), challengeIcon:GetSizeY() )
			challengeIcon:addInputEvent( "Mouse_LUp", "_challengeCall_byNewChallengeAlarm()" )
	end

	local isBlackSpiritClicked = false
	function _blackSpritCall_byNewQuestAlarm()
		if not IsSelfPlayerWaitAction() then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_SUMMON_BLACKSPIRIT") )
			return
		end
		-- 흑정령 아이콘 누를 때 소리(임시)
		if Panel_Tutorial:GetShow() then
			FGlobal_Tutorial_Close()
		end
		
		audioPostEvent_SystemUi(00,05)
		ToClient_AddBlackSpiritFlush();
	end
	
	function _challengeCall_byNewChallengeAlarm()
		-- 도전 과제 아이콘 누를 때 소리(임시)
		audioPostEvent_SystemUi(00,05)

	if GetUIMode() == Defines.UIMode.eUIMode_Gacha_Roulette then
		return
	end

		if not Panel_Window_CharInfo_Status:GetShow() then
			Panel_Window_CharInfo_Status:SetShow( true )
			FGlobal_CharInfoStatusShowAni()
			-- ♬ 창을 켤 때 소리
			audioPostEvent_SystemUi(01,34)
		end
		HandleClicked_CharacterInfo_Tab(3)
		HandleClickedTapButton( 2 )
	end
-- }

initMenuButtons()
Panel_UIMain_CheckBtnVisibility()
Panel_UIMain_SetScreenSize()


function Tutorial_InventoryOpen()	-- 처리해야 하나?
	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		return
	end
	local playerLevel = selfPlayer:get():getLevel()
	if ( playerLevel <= 3 ) and ( false == Panel_Window_Inventory:GetShow() ) then
		-- buttonAni[MenuButtonId.Btn_Inventory]:SetShow( true )
	end
end



-- 알파 처리 함수
local setAlphaAll = function( alpha )
	_bubbleNotice:SetFontAlpha(alpha)
	_bubbleNotice:SetAlpha(alpha)
end

function uiMainUpdate (updateTime)
	-- SimpleUI 버전에서는 마우스 꺼냄과 아님을 인식하여 UI를 켜준다. 루팅창이 떠 있으면 동작하지 않게 한다!
	
	elapsedTime = elapsedTime + updateTime
	if ( _bubbleNotice:GetShow() == true ) then
		if ( isOn == false ) then
			local temp = animationEndTime - elapsedTime
			if( temp < 0 ) then
				temp = 0
			_bubbleNotice:SetShow(false)
			end
			-- 1 -> 0
			setAlphaAll( temp / animationEndTime )
		else
			local temp = elapsedTime / animationEndTime
			if( 1 < temp  ) then
				temp = 1
			end
			-- 0 -> 1
			setAlphaAll( temp )
		end
	end
	
	
	-- 새로운 퀘스트가 있을 경우 10초 마다 흑정령이 말을 해야 한다.
	
	if( blackSpritCall:GetShow() ) then
		if Panel_RaceTimeAttack:GetShow() then
			Panel_NewQuest:SetShow(false)
			return
		end
		newQuestDeltaTime = newQuestDeltaTime + updateTime
		
		if ( blackMsgShowTime <= newQuestDeltaTime  )then
			-- ♬ 흑정령 나올때 씨불딱 거려야된다.
			audioPostEvent_SystemUi(04,11)
			FGlobal_NewMainQuest_Alarm_Open()
			newQuestDeltaTime = 0
		end
	end	
end


function ResetPos_WidgetButton()
	----------------------------------------------------------------------------------------------------------------
	--	해상도 조절시, 마우스오버툴팁, ON/OFF버튼 위치 초기화 안되서 추가 (Panel_UIMain_SetScreenSize함수에서 가져옴)
	----------------------------------------------------------------------------------------------------------------

	local ScrX = getScreenSizeX()
	local btn_Count = 7
	Panel_UIMain:SetSize( MenuButtons[MenuButtonId.Btn_GameExit]:GetSizeX() * btn_Count , 38)
	Panel_UIMain:ComputePos()
	
	local count = showedMenuButtonList:length()
	if 0 == count then
		return
	end
	
	local _styleInfo			= UI.getChildControl( Panel_UIMain, "Button_PlayerInfo" )
	local startPos_FirstRaw		= (Panel_UIMain:GetSizeX() - _styleInfo:GetSizeX() )

	local gapPos = -(_styleInfo:GetSizeX() + (_styleInfo:GetSizeX()*0.1))

	local buttonSpanY = 0
	for key,button in ipairs(showedMenuButtonList) do
		button:SetScale(1.0, 1.0)
		button:SetVerticalBottom()
		button:SetPosX( startPos_FirstRaw )
		button:SetSpanSize( button:GetSpanSize().x, 0 )
		startPos_FirstRaw = startPos_FirstRaw + gapPos

		btn_totalSizeTmp = btn_totalSizeTmp + button:GetSizeX()
		-- 버튼 사이즈 합 구하기
	end
end
	
function FromClient_NewFriendAlert( param )
	if 1 == param then
		MenuButtons[MenuButtonId.Btn_FriendList]:EraseAllEffect()
		MenuButtons[MenuButtonId.Btn_FriendList]:AddEffect("fUI_Friend_01A",true, 0, 0)
		_badgeFriend = badgeWidgetMake(MenuButtons[MenuButtonId.Btn_FriendList], "StaticText_Number_Friend", "N")
		local sendMsg = {main = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_FRIEND_ALERT"), sub = "", addMsg = "" }	-- 친구 요청이 들어왔습니다.
		Proc_ShowMessage_Ack_For_RewardSelect( sendMsg, 3, 3 )
	else
		local sendMsg = {main = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_FRIEND_COMPLETE"), sub = "", addMsg = "" }	-- 새로운 친구가 생겼습니다.
		Proc_ShowMessage_Ack_For_RewardSelect( sendMsg, 3, 3 )
	end
end

function badgeWidgetMake(parentControl, controlName, text)	-- 뱃지 달기
	local _badgeWidgetChild = UI.createAndCopyBasePropertyControl( Panel_UIMain, "StaticText_Number", parentControl, controlName )
	_badgeWidgetChild:SetPosX( 15 )
	_badgeWidgetChild:SetPosY( parentControl:GetPosY() -2 )
	_badgeWidgetChild:SetText( text )
	_badgeWidgetChild:SetShow(true)
	return _badgeWidgetChild
end

function FGlobal_NewFriendAlertOff()
	if nil == _badgeFriend then
		return
	end
	if true == _badgeFriend:GetShow() then
		MenuButtons[MenuButtonId.Btn_FriendList]:EraseAllEffect()
		_badgeFriend:SetShow( false )
	end
end

UIMain_QuestUpdate()
UIMain_ChallengeUpdate()
MenuButtons_SetAlpha()

Panel_UIMain:RegisterUpdateFunc("uiMainUpdate")

registerEvent("FromClient_UpdateQuestList",	"UIMain_QuestUpdate")
registerEvent("onScreenResize",	"ResetPos_WidgetButton")
registerEvent( "FromClient_NewFriend", "FromClient_NewFriendAlert")

changePositionBySever(Panel_UIMain, CppEnums.PAGameUIType.PAGameUIPanel_UIMenu, true, false, false)
