local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_IT 		= CppEnums.UiInputType
local UI_PUCT 		= CppEnums.PA_UI_CONTROL_TYPE
local IM			= CppEnums.EProcessorInputMode
local UI_TM			= CppEnums.TextMode

local isLocalwarOpen = ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 43 )
local isBlackSpiritAdventure = ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 1015 )	-- 흑정령의 모험(펄마블)

Panel_Menu:SetShow( false )
Panel_Menu:setGlassBackground( true )
Panel_Menu:ActiveMouseEventEffect( true )

Panel_Menu:RegisterShowEventFunc( true, 'Panel_Menu_ShowAni()' )
Panel_Menu:RegisterShowEventFunc( false, 'Panel_Menu_HideAni()' )

-- 메뉴가 추가될 경우, ID 및 텍스처를 등록해주세요!
local MenuButtonId =
{
	btn_HelpGuide			= 1,				-- 도움말
	btn_KeyboardHelp		= 2,				-- 키보드 도움말
	btn_Productnote			= 3,				-- 제작
	btn_CashShop			= 4,				-- (유료화)캐시샵
	btn_Beauty				= 5,				-- (유료화)뷰티
	btn_Dye					= 6,				-- 염색
	btn_ColorMix			= 7,				-- 염료혼합

	btn_Pet					= 8,				-- (유료화)애완동물
	btn_PlayerInfo			= 9,				-- 내 정보
	btn_Inventory			= 10,				-- 가방
	btn_BlackSpirit			= 11,				-- 흑정령
	btn_Quest				= 12,				-- 의뢰
	btn_Skill				= 13,				-- 스킬
	btn_Guild				= 14,				-- (컨텐츠옵션)길드

	btn_Manufacture			= 15,				-- 가공
	btn_FishEncyclopedia	= 16,				-- 어류도감
	btn_Knowledge			= 17,				-- 지식
	btn_WorldMap			= 18,				-- 월드맵
	btn_Rescue				= 19,				-- 탈출
	btn_FriendList			= 20,				-- 친구
	btn_Mail				= 21,				-- 편지

	btn_Worker				= 22,				-- 일꾼관리
	btn_Itemmarket			= 23,				-- 아이템 거래소
	btn_TradeEvent			= 24,				-- 무역 이벤트 정보
	btn_UiSetting			= 25,				-- UI편집
	btn_GuildRanker			= 26,				-- (컨텐츠옵션)길드 순위
	btn_LifeRanker			= 27,				-- 생활 순위
	btn_Event				= 28,				-- 이벤트
	btn_Notice				= 29,				-- 공지사항

	btn_DailyStamp			= 30,				-- 출석 체크
	btn_Siege				= 31,				-- 점령전 현황
	btn_LocalWar			= 32,				-- 붉은전장 현황
	btn_GameOption			= 33,				-- 옵션
	btn_ChattingFilter		= 34,				-- 채팅 필터
	btn_Language			= 35,				-- 언어(북미 전용)
	btn_Channel				= 36,				-- 채널 이동
	btn_GameExit			= 37,				-- 종료
}

local MenuButtonTextId = 
{
	[MenuButtonId.btn_HelpGuide]		= PAGetString( Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_HELP"), 				-- "도움말
	[MenuButtonId.btn_KeyboardHelp]		= PAGetString( Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_KEY"),					-- 키보드 도움말
	[MenuButtonId.btn_PlayerInfo]		= PAGetString( Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_MYINFO"),				-- "내 정보
	[MenuButtonId.btn_Inventory]		= PAGetString( Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_BAG"),					-- "가방
	[MenuButtonId.btn_Skill]			= PAGetString( Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_SKILL"), 				-- "스킬
	[MenuButtonId.btn_Guild]			= PAGetString( Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_GUILD"), 				-- "길드
	[MenuButtonId.btn_WorldMap]			= PAGetString( Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_WORLDMAP"),				-- "월드맵
	[MenuButtonId.btn_BlackSpirit]		= PAGetString( Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_BLACKSPIRIT"),			-- "흑정령
	[MenuButtonId.btn_Quest]			= PAGetString( Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_QUESTHISTORY"),			-- "의뢰
	[MenuButtonId.btn_Knowledge]		= PAGetString( Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_MENTALKNOWLEDGE"),		-- "지식
	[MenuButtonId.btn_Productnote]		= PAGetString( Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_PRODUCTIONNOTE"),		-- "제작
	[MenuButtonId.btn_FriendList]		= PAGetString( Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_FRIENDLIST"),			-- "친구
	[MenuButtonId.btn_Mail]				= PAGetString( Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_MAIL"),					-- "편지
	[MenuButtonId.btn_Pet]				= PAGetString(Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_PET"),					-- "애완동물",
	[MenuButtonId.btn_Dye]				= PAGetString( Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_DYE"),					-- "염색
	[MenuButtonId.btn_CashShop]			= PAGetString( Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_CASHSHOP"),				-- "캐시샵
	[MenuButtonId.btn_Beauty]			= PAGetString(Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_BEAUTY"),				-- "뷰티(F4)"
	[MenuButtonId.btn_GameOption]		= PAGetString(Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_OPTION"),				-- "게임 설정",
	[MenuButtonId.btn_GameExit]			= PAGetString(Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_EXIT"),					-- "접속 종료",
	[MenuButtonId.btn_Language]			= "Language",																				-- "게임 설정",
	[MenuButtonId.btn_Rescue]			= PAGetString(Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_ESCAPE"),				-- "탈출",
	[MenuButtonId.btn_UiSetting]		= PAGetString(Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_INTERFACEMOVE"),			-- UI편집
	[MenuButtonId.btn_Manufacture]		= PAGetString( Defines.StringSheet_GAME, "LUA_MENU_BTN_MANUFACTURE"),						-- 가공
	[MenuButtonId.btn_FishEncyclopedia]	= PAGetString(Defines.StringSheet_GAME, "LUA_MENU_BTN_FISHENCYCLOPEDIA"),					-- 어류도감
	[MenuButtonId.btn_ColorMix]			= PAGetString(Defines.StringSheet_GAME, "LUA_MENU_BTN_COLORMIX"),							-- 염색약 혼합
	[MenuButtonId.btn_Event]			= PAGetString(Defines.StringSheet_GAME, "LUA_MENU_BTN_EVENT"),								-- 이벤트
	[MenuButtonId.btn_DailyStamp]		= PAGetString(Defines.StringSheet_GAME, "LUA_MENU_BLACKSPIRIT_TRESURE"),					-- 흑정령 모험
	[MenuButtonId.btn_GuildRanker]		= PAGetString(Defines.StringSheet_GAME, "LUA_MENU_BTN_GUILDRANKER"),						-- 길드 순위
	[MenuButtonId.btn_LifeRanker]		= PAGetString(Defines.StringSheet_GAME, "LUA_MENU_BTN_LIFERANKER"),							-- 생활랭킹
	[MenuButtonId.btn_Siege]			= PAGetString(Defines.StringSheet_GAME, "LUA_MENU_BTN_SIEGE"),								-- 점령전 현황
	[MenuButtonId.btn_Worker]			= PAGetString(Defines.StringSheet_GAME, "LUA_MENU_WORKERTITLE"), 							-- "일꾼목록",
	[MenuButtonId.btn_TradeEvent]		= PAGetString(Defines.StringSheet_RESOURCE, "TRADEMARKET_GRAPH_TXT_COMMERCE"),				-- 무역 정보
	[MenuButtonId.btn_Channel]			= PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_TITLE_MSG"),				-- 채널 이동
	[MenuButtonId.btn_Notice]			= PAGetString(Defines.StringSheet_GAME, "CHATTING_NOTICE"),									-- 공지사항
	[MenuButtonId.btn_LocalWar]			= PAGetString(Defines.StringSheet_GAME, "LUA_MENU_LOCALWAR_INFO"),							-- 전장 현황
	[MenuButtonId.btn_Itemmarket]		= PAGetString(Defines.StringSheet_GAME, "LUA_MENU_ITEMMARKET"),								-- 거래소
	[MenuButtonId.btn_ChattingFilter]	= PAGetString(Defines.StringSheet_GAME, "LUA_MENU_CHATTING_FILTER"),						-- 채팅 필터	
}

local MenuButtonHotKeyID =
{
	[MenuButtonId.btn_HelpGuide]		= "",
	[MenuButtonId.btn_KeyboardHelp]		= keyCustom_GetString_UiKey(UI_IT.UiInputType_Help),					-- 키보드 도움말
	[MenuButtonId.btn_PlayerInfo]		= keyCustom_GetString_UiKey(UI_IT.UiInputType_PlayerInfo),				-- "내 정보
	[MenuButtonId.btn_Inventory]		= keyCustom_GetString_UiKey(UI_IT.UiInputType_Inventory),				-- "가방
	[MenuButtonId.btn_Skill]			= keyCustom_GetString_UiKey(UI_IT.UiInputType_Skill), 					-- "스킬
	[MenuButtonId.btn_Guild]			= keyCustom_GetString_UiKey(UI_IT.UiInputType_Guild), 					-- "길드
	[MenuButtonId.btn_WorldMap]			= keyCustom_GetString_UiKey(UI_IT.UiInputType_WorldMap),				-- "월드맵
	[MenuButtonId.btn_BlackSpirit]		= keyCustom_GetString_UiKey(UI_IT.UiInputType_BlackSpirit),				-- "흑정령
	[MenuButtonId.btn_Quest]			= keyCustom_GetString_UiKey(UI_IT.UiInputType_QuestHistory),			-- "의뢰
	[MenuButtonId.btn_Knowledge]		= keyCustom_GetString_UiKey(UI_IT.UiInputType_MentalKnowledge),			-- "지식
	[MenuButtonId.btn_Productnote]		= keyCustom_GetString_UiKey(UI_IT.UiInputType_ProductionNote),			-- "제작
	[MenuButtonId.btn_FriendList]		= keyCustom_GetString_UiKey(UI_IT.UiInputType_FriendList),				-- "친구
	[MenuButtonId.btn_Mail]				= keyCustom_GetString_UiKey(UI_IT.UiInputType_Mail),					-- "편지
	[MenuButtonId.btn_Pet]				= "",
	[MenuButtonId.btn_Dye]				= keyCustom_GetString_UiKey(UI_IT.UiInputType_Dyeing),					-- "염색
	[MenuButtonId.btn_CashShop]			= keyCustom_GetString_UiKey(UI_IT.UiInputType_CashShop),				-- "캐시샵
	[MenuButtonId.btn_Beauty]			= "F4",																	-- 뷰티샵 단축키는 문자열
	[MenuButtonId.btn_GameOption]		= "",
	[MenuButtonId.btn_GameExit]			= "",
	[MenuButtonId.btn_Rescue]			= "",
	[MenuButtonId.btn_Language]			= "",
	[MenuButtonId.btn_UiSetting]		= "",
	[MenuButtonId.btn_Manufacture]		= keyCustom_GetString_UiKey(UI_IT.UiInputType_Manufacture),				-- 가공
	[MenuButtonId.btn_FishEncyclopedia]	= "",
	[MenuButtonId.btn_ColorMix]			= "",
	[MenuButtonId.btn_Event]			= "",
	[MenuButtonId.btn_DailyStamp]		= "",
	[MenuButtonId.btn_GuildRanker]		= "",
	[MenuButtonId.btn_LifeRanker]		= "",
	[MenuButtonId.btn_Siege]			= "",
	[MenuButtonId.btn_Worker]			= "",
	[MenuButtonId.btn_TradeEvent]		= "",
	[MenuButtonId.btn_Channel]			= "",
	[MenuButtonId.btn_Notice]			= "",
	[MenuButtonId.btn_LocalWar]			= "",
	[MenuButtonId.btn_Itemmarket]		= "",
	[MenuButtonId.btn_ChattingFilter]	= "",
}

local contry = {
	kr = 0,
	jp = 1,
	ru = 2,
	cn = 3,
}
local cashIconTexture = {
	[0] =	{94,		173,	138,	217},	-- 한국
			{232,		357,	276,	401},	-- 일본
			{94,		173,	138,	217},	-- 러시아
			{94,		173,	138,	217},	-- 중국
}

local cashIcon_changeButtonTexture = function( control, contry )
	local x1, y1, x2, y2 = setTextureUV_Func( control, cashIconTexture[contry][1], cashIconTexture[contry][2], cashIconTexture[contry][3], cashIconTexture[contry][4] )
	return x1, y1, x2, y2
end

local _badges = {
	[MenuButtonId.btn_Quest]		= { count = 0, isShow = false },
	[MenuButtonId.btn_BlackSpirit]	= { count = 0, isShow = false },
	[MenuButtonId.btn_Skill]		= { count = 0, isShow = false },
	[MenuButtonId.btn_Inventory]	= { count = 0, isShow = false },
	[MenuButtonId.btn_Knowledge]	= { count = 0, isShow = false },
	[MenuButtonId.btn_FriendList]	= { count = 0, isShow = false },
}

local btn_Close		= UI.getChildControl( Panel_Menu, "Button_Win_Close" )
btn_Close:addInputEvent( "Mouse_LUp", "Panel_Menu_ShowToggle()" )

local menu_Bg			= UI.getChildControl( Panel_Menu, "Static_MenuBG" )
local menuIconBg		= UI.getChildControl( Panel_Menu, "Static_MenuIconBG" )
local menuIcon			= UI.getChildControl( Panel_Menu, "StaticText_MenuIcon" )
local menuBadge			= UI.getChildControl( Panel_CheckedQuest, "StaticText_Number" )
local menuHotkey		= UI.getChildControl( Panel_Menu, "StaticText_MenuHotkey" )
local menuTitleBar		= UI.getChildControl( Panel_Menu, "StaticText_Title" )
local menuText			= UI.getChildControl( Panel_Menu, "StaticText_MenuText" )

local maxButtonCount	= #MenuButtonTextId
local menuButtonBG		= {}
local menuButtonIcon	= {}
local menuBadgePool		= {}
local menuTextPool		= {}
local menuButtonHotkey	= {}
local iconBgPosX		= menuIconBg:GetPosX()
local iconBgPosY		= menuIconBg:GetPosY()
local iconPosX			= menuIcon:GetPosX()
local iconPosY			= menuIcon:GetPosY()

local buttonTexture = {
	[MenuButtonId.btn_HelpGuide]		= { 2,		81,		46,		125 },
	[MenuButtonId.btn_KeyboardHelp]		= {	48,		357,	92,		401	},
	[MenuButtonId.btn_UiSetting]		= { 2,		219,	46,		263 },
	[MenuButtonId.btn_PlayerInfo]		= { 48,		81,		92,		125 },
	[MenuButtonId.btn_Inventory]		= { 94,		81,		138,	125 },
	[MenuButtonId.btn_Skill]			= { 140,	81,		184,	125 },
	[MenuButtonId.btn_Guild]			= { 186,	81,		230,	125 },
	[MenuButtonId.btn_WorldMap]			= { 232,	81,		276,	125 },
	[MenuButtonId.btn_BlackSpirit]		= { 2,		127,	46,		171 },
	[MenuButtonId.btn_Quest]			= { 48,		127,	92,		171 },
	[MenuButtonId.btn_Knowledge]		= { 94,		127,	138,	171 },
	[MenuButtonId.btn_Productnote]		= { 140,	127,	184,	171 },
	[MenuButtonId.btn_FriendList]		= { 186,	127,	230,	171 },
	[MenuButtonId.btn_Mail]				= { 232,	127,	276,	171 },
	[MenuButtonId.btn_Pet]				= { 2,		173,	46,		217 },
	[MenuButtonId.btn_Dye]				= { 48,		173,	92,		217 },
	[MenuButtonId.btn_CashShop]			= { 94,		173,	138,	217 },
	[MenuButtonId.btn_Beauty]			= { 140,	173,	184,	217 },
	[MenuButtonId.btn_GameOption]		= { 186,	173,	230,	217 },
	[MenuButtonId.btn_Language]			= { 140,	449,	184,	493 },
	[MenuButtonId.btn_GameExit]			= { 232,	173,	276,	217 },
	[MenuButtonId.btn_Rescue]			= { 48,		219,	92,		263 },
	[MenuButtonId.btn_Manufacture]		= { 140,	219,	184,	263 },
	[MenuButtonId.btn_FishEncyclopedia]	= {	94,		219,	138,	263 },
	[MenuButtonId.btn_ColorMix]			= {	186,	219,	230,	263 },
	[MenuButtonId.btn_Event]			= {	232,	219,	276, 	263 },
	[MenuButtonId.btn_DailyStamp]		= {	186,	449,	230, 	493 },
	[MenuButtonId.btn_GuildRanker]		= { 140,	357,	184,	401 },
	[MenuButtonId.btn_LifeRanker]		= { 2,		265,	46,		309 },
	[MenuButtonId.btn_Siege]			= { 2,		357,	46,		401 },
	[MenuButtonId.btn_Worker]			= { 94,		357,	138,	401 },
	[MenuButtonId.btn_TradeEvent]		= { 94,		403,	138,	447 },
	[MenuButtonId.btn_Channel]			= { 140,	403,	184,	447 },
	[MenuButtonId.btn_Notice]			= { 186,	403,	230,	447 },
	[MenuButtonId.btn_LocalWar]			= { 202,	403,	276,	447 },
	[MenuButtonId.btn_Itemmarket]		= { 2,		449,	46,		493 },
	[MenuButtonId.btn_ChattingFilter]	= { 278,	449,	322,	493 },
}


function TargetWindow_ShowToggle( index )
	Panel_UIControl_SetShow( false )								-- 컨트롤 창 끄기
	--Panel_Menu:SetShow( false, false )

	if		( MenuButtonId.btn_GameExit == index ) then
		GameExitShowToggle( false )
	elseif	( MenuButtonId.btn_Rescue == index ) then
		HandleClicked_RescueConfirm()
	elseif	( MenuButtonId.btn_GameOption == index ) then
		showGameOption()
	elseif	( MenuButtonId.btn_UiSetting == index ) then
		FGlobal_UiSet_Open()
	elseif	( MenuButtonId.btn_FriendList == index ) then
		GlobalKeyBinder_MouseKeyMap( UI_IT.UiInputType_FriendList )
	elseif	( MenuButtonId.btn_Mail == index ) then
		GlobalKeyBinder_MouseKeyMap( UI_IT.UiInputType_Mail )
	elseif	( MenuButtonId.btn_Pet == index ) then
		FGlobal_PetListNew_Toggle()
	elseif	( MenuButtonId.btn_Knowledge == index ) then
		GlobalKeyBinder_MouseKeyMap( UI_IT.UiInputType_MentalKnowledge )
	elseif	( MenuButtonId.btn_Productnote == index ) then
		Panel_ProductNote_ShowToggle()
	elseif	( MenuButtonId.btn_Inventory == index ) then
		GlobalKeyBinder_MouseKeyMap( UI_IT.UiInputType_Inventory )
	elseif	( MenuButtonId.btn_Skill == index ) then
		GlobalKeyBinder_MouseKeyMap( UI_IT.UiInputType_Skill )
	elseif	( MenuButtonId.btn_BlackSpirit == index ) then
		GlobalKeyBinder_MouseKeyMap( UI_IT.UiInputType_BlackSpirit )
	elseif	( MenuButtonId.btn_Quest == index ) then
		GlobalKeyBinder_MouseKeyMap( UI_IT.UiInputType_QuestHistory )
	elseif	( MenuButtonId.btn_WorldMap == index ) then
		GlobalKeyBinder_MouseKeyMap( UI_IT.UiInputType_WorldMap )
	elseif	( MenuButtonId.btn_PlayerInfo == index ) then
		GlobalKeyBinder_MouseKeyMap( UI_IT.UiInputType_PlayerInfo )
	elseif	( MenuButtonId.btn_Guild == index ) then
		GlobalKeyBinder_MouseKeyMap( UI_IT.UiInputType_Guild )
	elseif	( MenuButtonId.btn_HelpGuide == index ) then
		-- GlobalKeyBinder_MouseKeyMap( UI_IT.UiInputType_Help )
		FGlobal_Panel_WebHelper_ShowToggle()
	elseif	( MenuButtonId.btn_Dye == index ) then
		GlobalKeyBinder_MouseKeyMap( UI_IT.UiInputType_Dyeing )
	elseif	( MenuButtonId.btn_Beauty == index ) then
		GlobalKeyBinder_MouseKeyMap( UI_IT.UiInputType_BeautyShop )
	elseif	( MenuButtonId.btn_CashShop == index ) then
		GlobalKeyBinder_MouseKeyMap( UI_IT.UiInputType_CashShop )
	elseif	( MenuButtonId.btn_Manufacture == index ) then
		GlobalKeyBinder_MouseKeyMap( UI_IT.UiInputType_Manufacture )
	elseif	( MenuButtonId.btn_FishEncyclopedia == index ) then
		FGlobal_FishEncyclopedia_Open()	-- Panel_FishEncyclopedia
	elseif	( MenuButtonId.btn_ColorMix == index ) then
		Panel_ColorBalance_Show()	-- Panel_FishEncyclopedia
	elseif ( MenuButtonId.btn_Event == index ) then
		EventNotify_Open( true, true )
	elseif ( MenuButtonId.btn_DailyStamp == index ) then
		-- DailyStamp_ShowToggle()
		FGlobal_BlackSpiritAdventure_Open()
	elseif ( MenuButtonId.btn_GuildRanker == index ) then
		FGlobal_guildRanking_Open()
	elseif ( MenuButtonId.btn_LifeRanker == index ) then
		FGlobal_LifeRanking_Open()
	elseif ( MenuButtonId.btn_KeyboardHelp == index ) then
		FGlobal_KeyboardHelpShow()
	elseif ( MenuButtonId.btn_Siege == index ) then
		FGlobal_GuildWarInfo_Show()
		if Panel_Menu:GetShow() then
			Panel_Menu:SetShow( false, false )
		end
	elseif MenuButtonId.btn_Worker == index then
		workerManager_Toggle()
	elseif MenuButtonId.btn_TradeEvent == index then
		TradeEventInfo_Show()
	elseif MenuButtonId.btn_Channel == index then
		FGlobal_ChannelSelect_Show()
	elseif MenuButtonId.btn_Notice == index then
		EventNotify_Open( true, true )				-- 일단 북미에서 이벤트 창을 공지사항으로 사용한다고하여 임시로 사용한다.	
	elseif MenuButtonId.btn_LocalWar == index then
		local playerWrapper = getSelfPlayer()
		local player		= playerWrapper:get()
		local hp			= player:getHp()
		local maxHp			= player:getMaxHp()

		if IsSelfPlayerWaitAction() then
			if (hp == maxHp) then
				if 0 == ToClient_GetMyTeamNoLocalWar() then
					FGlobal_LocalWarInfo_Open()
				else
					local	messageBoxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_MENU_LOCALWAR_GETOUT_MEMO")
					local	messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"), content = messageBoxMemo, functionYes = FGlobal_LocalWarInfo_GetOut, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
					MessageBox.showMessageBox(messageBoxData, "middle")
				end
			else
				Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_MAXHP_CHECK") ) -- 생명력을 꽉 채운 상태에서만 입장 가능합니다.
			end
		else
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_LOCALWARINFO") ) -- 대기 상태에서만 전장 현황을 이용할 수 있습니다.
		end
	elseif MenuButtonId.btn_Language == index then
		FGlobal_GameOptionOpen()
	elseif MenuButtonId.btn_Itemmarket == index then
		FGlobal_ItemMarket_Open_ForWorldMap(1,true)
		audioPostEvent_SystemUi(01,30)
	elseif MenuButtonId.btn_ChattingFilter == index then
		if isGameTypeEnglish() or isGameServiceTypeDev() then
			FGlobal_ChattingFilterList_Open()
		end
	end
	if Panel_Menu:GetShow() then
		Panel_Menu:SetShow( false, false )
	end
end

function Panel_Menu_ShowAni()
	Panel_Menu:SetAlpha( 0 )
	UIAni.AlphaAnimation( 1, Panel_Menu, 0.0, 0.15 )

	local aniInfo1 = Panel_Menu:addScaleAnimation( 0.0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(1.5)
	aniInfo1:SetEndScale(0.8)
	aniInfo1.AxisX = Panel_Menu:GetSizeX() / 2
	aniInfo1.AxisY = Panel_Menu:GetSizeY() / 2
	aniInfo1.ScaleType = 0
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_Menu:addScaleAnimation( 0.15, 0.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(0.8)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_Menu:GetSizeX() / 2
	aniInfo2.AxisY = Panel_Menu:GetSizeY() / 2
	aniInfo2.ScaleType = 0
	aniInfo2.IsChangeChild = true
end
function Panel_Menu_HideAni()
	Panel_Menu:SetAlpha( 1 )
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_Menu, 0.0, 0.1 )
	aniInfo:SetHideAtEnd(true)
end

function GameMenu_Init()
	local columnCount		= 0
	local columnCountByRaw	= 7
	local rowCount			= 0
	local iconGap			= 46
	local countrySizeNum	= 68

	local posIndex = 1		-- 유료화 처리용 posIndex
	for index = 1, maxButtonCount do
		if ( GameMenu_CheckEnAble( index ) ) then	-- 유료화 체크
			local tempBg	= UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, menu_Bg, "Static_MenuBg_" .. index )
			CopyBaseProperty( menuIconBg, tempBg )
			menuButtonBG[index] = tempBg
			menuButtonBG[index]:SetShow( true )
			menuButtonBG[index]:ResetVertexAni()

			if isGameTypeEnglish() then
				menuButtonBG[index]:SetSize( 83, 83 )
				countrySizeNum = 83
			else
				menuButtonBG[index]:SetSize( 68, 68 )
				countrySizeNum = 68
			end
			menuButtonBG[index]:SetPosX( iconBgPosX + ( menuButtonBG[index]:GetSizeX() ) * columnCount )
			menuButtonBG[index]:SetPosY( iconBgPosY + ( menuButtonBG[index]:GetSizeY() ) * rowCount )
			menuButtonBG[index]:addInputEvent( "Mouse_LUp",		"TargetWindow_ShowToggle(" .. index .. ")" )
			menuButtonBG[index]:addInputEvent( "Mouse_On",		"HandleOn_SlotBg(" .. index .. ")" )
			menuButtonBG[index]:addInputEvent( "Mouse_Out",		"HandleOn_SlotBg()" )
				
			local tempIcon	= UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, menuButtonBG[index], "StaticText_MenuIcon_" .. index )
			CopyBaseProperty( menuIcon, tempIcon )
			menuButtonIcon[index] = tempIcon
			menuButtonIcon[index]:SetShow( true )
			
			local tempHotkeyIcon	= UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, menuButtonBG[index], "StaticText_MenuHotKey_" .. index )
			CopyBaseProperty( menuHotkey, tempHotkeyIcon )
			menuButtonHotkey[index] = tempHotkeyIcon
			menuButtonHotkey[index]:SetShow( true )
			menuButtonHotkey[index]:SetText( MenuButtonHotKeyID[index] )
			menuButtonHotkey[index]:ComputePos()
			
			local badgeIcon	= UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, menuButtonBG[index], "StaticText_MenuBadge_" .. index )
			CopyBaseProperty( menuBadge, badgeIcon )
			badgeIcon:SetPosX( tempBg:GetSizeX() - badgeIcon:GetSizeX() - 43)
			badgeIcon:SetPosY( 5 )
			menuBadgePool[index] = badgeIcon
			menuBadgePool[index]:SetShow( false )

			local tempText	= UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, menuButtonBG[index], "StaticText_MenuText_" .. index )
			CopyBaseProperty( menuText, tempText )
			tempText:SetTextMode( UI_TM.eTextMode_AutoWrap )
			menuTextPool[index] = tempText
			menuTextPool[index]:SetShow( true )
			menuTextPool[index]:ComputePos()

			if not isGameTypeEnglish() then
				menuButtonIcon[index]:SetTextMode( UI_TM.eTextMode_AutoWrap )
				menuButtonIcon[index]:SetSize( 70, 70 )
				menuButtonIcon[index]:SetTextVerticalBottom()
				menuButtonIcon[index]:SetTextSpan( 0, -3 )
			else
				menuButtonIcon[index]:SetSize( 44, 44 )
				-- menuButtonIcon[index]:SetSpanSize( menuButtonIcon[index]:GetSpanSize().x, 15 )
				menuTextPool[index]:SetSize( 70, menuTextPool[index]:GetSizeY() )
				menuTextPool[index]:SetSpanSize( 0, 55 )
			end
			menuTextPool[index]:SetText( MenuButtonTextId[index] )
			GameMenu_ChangeButtonTexture( index )	-- 버튼 텍스쳐 변경
			
			if ( 0 == posIndex % columnCountByRaw ) then	-- 유료화 처리용 posIndex
				columnCount = 0
				rowCount = rowCount + 1
			else
				columnCount = columnCount + 1
			end
			posIndex = posIndex + 1
		end
	end

	local totalRaw		= math.ceil((posIndex-1) / columnCountByRaw)
	local buttonSizeX	= menuButtonBG[2]:GetSizeX()
	local buttonGapX	= 7
	local bgSizeX		= ( buttonSizeX ) * columnCountByRaw
	menu_Bg		:SetSize( bgSizeX + (buttonGapX * 2) , ( countrySizeNum + 2 ) * totalRaw + buttonGapX )
	Panel_Menu	:SetSize( menu_Bg:GetSizeX() + ( buttonGapX * 6 ) , menu_Bg:GetSizeY() + 70 )
	menuTitleBar:SetSize( Panel_Menu:GetSizeX() - 16, menuTitleBar:GetSizeY() )
end

function GameMenu_CheckEnAble( buttonType )
	local returnValue = false
	if isGameTypeKorea() then
		if (buttonType == MenuButtonId.btn_Notice) or (buttonType == MenuButtonId.btn_Language) then
			returnValue = false
		else
			returnValue = true
		end
	elseif isGameTypeJapan() then -- 일본은 이벤트가 진행중이지 않으면 해당 항목을 노출시키지 않는다.
		if (buttonType == MenuButtonId.btn_DailyStamp) or (buttonType == MenuButtonId.btn_Event)
			or (buttonType == MenuButtonId.btn_Notice) or (buttonType == MenuButtonId.btn_Language) then
			returnValue = false
		else
			returnValue = true
		end
	elseif isGameTypeRussia() then
		if (buttonType == MenuButtonId.btn_HelpGuide) or (buttonType == MenuButtonId.btn_DailyStamp)
			or (buttonType == MenuButtonId.btn_Event) or (buttonType == MenuButtonId.btn_Productnote)
			or (buttonType == MenuButtonId.btn_FishEncyclopedia) or (buttonType == MenuButtonId.btn_Notice) or (buttonType == MenuButtonId.btn_Language) then
			returnValue = false
		else
			returnValue = true
		end
		if (getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_CBT)
			or (getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_OBT) then
			if ( buttonType == MenuButtonId.btn_Dye ) then
				returnValue = false
			else
				returnValue = true
			end
		end
	elseif isGameTypeEnglish() then
		if (buttonType == MenuButtonId.btn_Event) or (buttonType == MenuButtonId.btn_DailyStamp) then
			returnValue = false
		else
			returnValue = true
		end
	elseif isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_CHI ) then
		returnValue = true
	else
		returnValue = true
	end
	-- 붉은 전장은 컨텐츠 옵션이 열려있냐 아니냐에 따른 판단을 할 수 있으므로 따로 판단한다.
	if (buttonType == MenuButtonId.btn_LocalWar) then
		if (not isLocalwarOpen) then
			returnValue = false
		else
			returnValue = true
		end
	end
--{	상용화가 아니면 캐쉬샵, 뷰티샵 두가지만 막는다!(상용화 아닌 경우에도 이벤트성으로 캐쉬템을 우편으로 보내는 경우도 있기 때문!)
	if (buttonType == MenuButtonId.btn_CashShop or buttonType == MenuButtonId.btn_Beauty) then
		if (getContentsServiceType() ~= CppEnums.ContentsServiceType.eContentsServiceType_Commercial) then
			returnValue = false
		else
			returnValue = true
		end
	end
--}
	-- 황실납품 NPC가 열려 있으면,
	if (buttonType == MenuButtonId.btn_TradeEvent) then
		if ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 22 ) then
			returnValue = true
		else
			returnValue = false
		end
	end
	
	-- 북미/개발만 언어 버튼을 넣는다.
	if buttonType == MenuButtonId.btn_Language or buttonType == MenuButtonId.btn_ChattingFilter then
		if (isGameTypeEnglish() or isGameServiceTypeDev()) then
			returnValue = true
		else
			returnValue = false
		end
	end
	
	return returnValue
end

function GameMenu_ChangeButtonTexture( index )
	menuButtonIcon[index]:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Menu/Menu_01.dds" )
	local x1, y1, x2, y2 = 0, 0, 0, 0
	if index == MenuButtonId.btn_CashShop then
		if 0 == getGameServiceType() or 1 == getGameServiceType() or 2 == getGameServiceType() or 3 == getGameServiceType() or 4 == getGameServiceType() then
		-- 한국
			x1, y1, x2, y2 = cashIcon_changeButtonTexture( menuButtonIcon[index], contry.kr )
		elseif 5 == getGameServiceType() or 6 == getGameServiceType() then
			-- 일본
			x1, y1, x2, y2 = cashIcon_changeButtonTexture( menuButtonIcon[index], contry.jp )
		elseif 7 == getGameServiceType() or 8 == getGameServiceType() then
			-- 러시아
			x1, y1, x2, y2 = cashIcon_changeButtonTexture( menuButtonIcon[index], contry.ru )
		elseif 9 == getGameServiceType() or 10 == getGameServiceType() then
			-- 중국
			x1, y1, x2, y2 = cashIcon_changeButtonTexture( menuButtonIcon[index], contry.cn )
		else	-- 그외
			x1, y1, x2, y2 = cashIcon_changeButtonTexture( menuButtonIcon[index], contry.kr )
		end
	elseif index == MenuButtonId.btn_LocalWar then
		if 0 == ToClient_GetMyTeamNoLocalWar() then
			x1, y1, x2, y2 = setTextureUV_Func( menuButtonIcon[index], 232, 403, 276, 447 )
			menuTextPool[MenuButtonId.btn_LocalWar]:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MENU_LOCALWAR_INFO") ) -- 전장 현황
		else
			x1, y1, x2, y2 = setTextureUV_Func( menuButtonIcon[index], 232, 449, 276, 493 )
			menuTextPool[MenuButtonId.btn_LocalWar]:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MENU_LOCALWAR_GETOUT") ) -- 전장 이탈
		end
	else
		x1, y1, x2, y2 = setTextureUV_Func( menuButtonIcon[index], buttonTexture[index][1], buttonTexture[index][2], buttonTexture[index][3], buttonTexture[index][4] )	
	end
	menuButtonIcon[index]:getBaseTexture():setUV(  x1, y1, x2, y2  )
	menuButtonIcon[index]:setRenderTexture(menuButtonIcon[index]:getBaseTexture())
end

function HandleOn_SlotBg( index )
	GameMenu_ResetVertexAni()
	if nil ~= index then
		menuButtonBG[index]:SetVertexAniRun( "Ani_Color_New", true )
	end
end

function GameMenu_ResetVertexAni()
	for i = 1, maxButtonCount  do
		if ( GameMenu_CheckEnAble( i ) ) then	-- 유료화 체크
			menuButtonBG[i]:ResetVertexAni()
			menuButtonBG[i]:SetVertexAniRun( "Ani_Color_Reset", true )
		end
	end
end

function mainUI_Badges_Count()
	if true == _badges[MenuButtonId.btn_Quest].isShow then
		_badges[MenuButtonId.btn_Quest].count = _badges[MenuButtonId.btn_Quest].count +1
	end
	if true == _badges[MenuButtonId.btn_BlackSpirit].isShow then
		_badges[MenuButtonId.btn_BlackSpirit].count = _badges[MenuButtonId.btn_BlackSpirit].count +1
	end
	if true == _badges[MenuButtonId.btn_Skill].isShow then
		_badges[MenuButtonId.btn_Skill].count = _badges[MenuButtonId.btn_Skill].count +1
	end
	if true == _badges[MenuButtonId.btn_FriendList].isShow then
		_badges[MenuButtonId.btn_FriendList].count = _badges[MenuButtonId.btn_FriendList].count +1
	end

	menuBadgePool[MenuButtonId.btn_Quest]		:SetText( _badges[MenuButtonId.btn_Quest].count )
	menuBadgePool[MenuButtonId.btn_BlackSpirit]	:SetText( _badges[MenuButtonId.btn_BlackSpirit].count )
	menuBadgePool[MenuButtonId.btn_Skill]		:SetText( _badges[MenuButtonId.btn_Skill].count )
	menuBadgePool[MenuButtonId.btn_FriendList]	:SetText( _badges[MenuButtonId.btn_FriendList].count )
end

--------------------------------------------------------------------------------
function UIMain_ItemUpdate()	-- 슬롯 수만큼 돌아서 넘어온다.
	local newItemCount = Inventory_GetFirstItemCount()
	if not menuBadgePool[MenuButtonId.btn_Inventory]:GetShow() then
		menuBadgePool[MenuButtonId.btn_Inventory]:SetShow( true )
	end
	menuBadgePool[MenuButtonId.btn_Inventory]:SetText( newItemCount )
end
function UIMain_ItemUpdateRemove()
	menuBadgePool[MenuButtonId.btn_Inventory]:SetText( 0 )
	menuBadgePool[MenuButtonId.btn_Inventory]:SetShow( false )
end
function UIMain_FriendListUpdate()
	if false == _badges[MenuButtonId.btn_FriendList].isShow then
		_badges[MenuButtonId.btn_FriendList].isShow = true
		menuBadgePool[MenuButtonId.btn_FriendList]:SetShow( true )
		mainUI_Badges_Count()
	end
end
function UIMain_FriendListUpdateRemove()
	_badges[MenuButtonId.btn_FriendList].isShow = false
	_badges[MenuButtonId.btn_FriendList].count	= 0
	menuBadgePool[MenuButtonId.btn_FriendList]:SetShow( false )
	mainUI_Badges_Count()
end

-- 지식 버튼 처리
local knowledgePoint = 0
function UIMain_KnowledgeUpdate()
	knowledgePoint = knowledgePoint + 1
	if 0 ~= knowledgePoint then
		if 1 < knowledgePoint then
			return
		end
		menuBadgePool[MenuButtonId.btn_Knowledge]:SetShow( true )
		menuBadgePool[MenuButtonId.btn_Knowledge]:SetText("N")
	end
end
function UIMain_KnowledgeUpdateRemove()
	knowledgePoint = 0
	menuBadgePool[MenuButtonId.btn_Knowledge]:SetShow( false )
end


-- 스킬 버튼 처리
function UI_MAIN_checkSkillLearnable()	-- 스킬을 배울 수 있나?
	local isLearnable = PaGlobal_Skill:SkillWindow_PlayerLearnableSkill()
	if( isLearnable ) then
		menuBadgePool[MenuButtonId.btn_Skill]:SetShow( true )
		menuBadgePool[MenuButtonId.btn_Skill]:SetText("N")
	end
end
function UIMain_SkillPointUpdateRemove()
	menuBadgePool[MenuButtonId.btn_Skill]:SetShow( false )
end


--------------------------------------------------------------------------------
function Panel_Menu_ShowToggle()
	local scrSizeX = getScreenSizeX()
	local scrSizeY = getScreenSizeY()

	if GetUIMode() == Defines.UIMode.eUIMode_Gacha_Roulette then
		return
	end

	if ( Panel_Menu:IsShow() == true ) then
		Panel_Menu_Close()
		return false;
	else
		_Panel_Menu_OpenLimit()

		Panel_Menu:SetPosX( scrSizeX - (scrSizeX/2) - ( Panel_Menu:GetSizeX() / 2 ) )
		Panel_Menu:SetPosY( Panel_Menu:GetSizeY() * 0.35 )
		Panel_Menu:SetShow( true, true )
		Panel_Menu:SetDragAll( true )
		Panel_Menu:SetIgnore( false )
		audioPostEvent_SystemUi(01,37)

		return true;
	end

	return false
end

function _Panel_Menu_OpenLimit()
	local playerLevel = getSelfPlayer():get():getLevel()
	if nil ~= getSelfPlayer() then
		if 5 <= playerLevel then
			for index=1, maxButtonCount do
				if ( GameMenu_CheckEnAble( index ) ) then	-- 유료화 체크
					menuButtonBG[index]		:SetEnable( true )
					menuButtonBG[index]		:SetMonoTone( false )
					menuButtonIcon[index]	:SetEnable( true )
					menuButtonIcon[index]	:SetMonoTone( false )
					menuButtonHotkey[index]	:SetEnable( true )
					menuButtonHotkey[index]	:SetMonoTone( false )
				end
			end
		else
			for index=1, maxButtonCount do
				if ( GameMenu_CheckEnAble( index ) ) then	-- 유료화 체크
					menuButtonBG[index]		:SetEnable( true )
					menuButtonBG[index]		:SetMonoTone( false )
					menuButtonIcon[index]	:SetEnable( true )
					menuButtonIcon[index]	:SetMonoTone( false )
					menuButtonHotkey[index]	:SetEnable( true )
					menuButtonHotkey[index]	:SetMonoTone( false )
				end
			end
			menuButtonBG[MenuButtonId.btn_UiSetting]		:SetEnable( false )
			menuButtonBG[MenuButtonId.btn_UiSetting]		:SetMonoTone( true )
			menuButtonIcon[MenuButtonId.btn_UiSetting]		:SetEnable( false )
			menuButtonIcon[MenuButtonId.btn_UiSetting]		:SetMonoTone( true )
			menuButtonHotkey[MenuButtonId.btn_UiSetting]	:SetEnable( false )
			menuButtonHotkey[MenuButtonId.btn_UiSetting]	:SetMonoTone( true )
		end
	end
	
	local curChannelData	= getCurrentChannelServerData()
	if ( GameMenu_CheckEnAble( MenuButtonId.btn_Siege ) ) then	-- 유료화 체크
		-- if ( true == curChannelData._isMain ) then
			menuButtonBG[MenuButtonId.btn_Siege]		:SetEnable( true )
			menuButtonBG[MenuButtonId.btn_Siege]		:SetMonoTone( false )
			menuButtonIcon[MenuButtonId.btn_Siege]		:SetEnable( true )
			menuButtonIcon[MenuButtonId.btn_Siege]		:SetMonoTone( false )
			menuButtonHotkey[MenuButtonId.btn_Siege]	:SetEnable( true )
			menuButtonHotkey[MenuButtonId.btn_Siege]	:SetMonoTone( false )
		-- elseif ToClient_IsDevelopment() then
			-- menuButtonBG[MenuButtonId.btn_Siege]		:SetEnable( true )
			-- menuButtonBG[MenuButtonId.btn_Siege]		:SetMonoTone( false )
			-- menuButtonIcon[MenuButtonId.btn_Siege]		:SetEnable( true )
			-- menuButtonIcon[MenuButtonId.btn_Siege]		:SetMonoTone( false )
			-- menuButtonHotkey[MenuButtonId.btn_Siege]	:SetEnable( true )
			-- menuButtonHotkey[MenuButtonId.btn_Siege]	:SetMonoTone( false )
		-- else
			-- menuButtonBG[MenuButtonId.btn_Siege]		:SetEnable( false )
			-- menuButtonBG[MenuButtonId.btn_Siege]		:SetMonoTone( true )
			-- menuButtonIcon[MenuButtonId.btn_Siege]		:SetEnable( false )
			-- menuButtonIcon[MenuButtonId.btn_Siege]		:SetMonoTone( true )
			-- menuButtonHotkey[MenuButtonId.btn_Siege]	:SetEnable( false )
			-- menuButtonHotkey[MenuButtonId.btn_Siege]	:SetMonoTone( true )
		-- end
	end
	if isGameTypeKorea() then	
		-- if ToClient_isAttendanceEvent() then			-- 출석체크 이벤트 기간이 아니면 막아둔다!
		if isBlackSpiritAdventure then
			menuButtonBG[MenuButtonId.btn_DailyStamp]		:SetIgnore(false)
			menuButtonBG[MenuButtonId.btn_DailyStamp]		:SetMonoTone(false)
			menuButtonIcon[MenuButtonId.btn_DailyStamp]		:SetMonoTone(false)
		else
			menuButtonBG[MenuButtonId.btn_DailyStamp]		:SetIgnore(true)
			menuButtonBG[MenuButtonId.btn_DailyStamp]		:SetMonoTone(true)
			menuButtonIcon[MenuButtonId.btn_DailyStamp]		:SetMonoTone(true)
		end
	end
end

function Panel_Menu_Close()
	Panel_Menu:SetShow( false, true )
	Panel_Menu:SetDragAll( false )
	Panel_Menu:SetIgnore( true )
	if false == check_ShowWindow() then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
	end
end

function HandleClicked_RescueConfirm()
	local	messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS") -- "알 림"
	local	messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_MSGBOX_RESCUE") -- "탈출 하시겠습니까?\n탈출하게 되면 가까운 마을로 캐릭터가 이동합니다."
	local	messageBoxData = { title = messageBoxTitle, content = messageBoxMemo, functionYes = RescueExecute, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
end

function RescueExecute()
	callRescue()
end

function panelMenu_OnScreenResize()
	local scrSizeX = getScreenSizeX()
	Panel_Menu:SetPosX( scrSizeX - (scrSizeX/2) - ( Panel_Menu:GetSizeX() / 2 ) )
	Panel_Menu:SetPosY( Panel_Menu:GetSizeY() * 0.35 )
end

GameMenu_Init()
registerEvent("onScreenResize", 			"panelMenu_OnScreenResize" )