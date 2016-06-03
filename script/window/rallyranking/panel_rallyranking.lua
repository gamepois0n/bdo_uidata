Panel_RallyRanking:SetShow( false, false )

local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color
local IM            = CppEnums.EProcessorInputMode


function RallyRankingShowAni()
	UIAni.fadeInSCR_Down( Panel_RallyRanking )

	local aniInfo1 = Panel_RallyRanking:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.2)
	aniInfo1.AxisX = Panel_RallyRanking:GetSizeX() / 2
	aniInfo1.AxisY = Panel_RallyRanking:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_RallyRanking:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.2)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_RallyRanking:GetSizeX() / 2
	aniInfo2.AxisY = Panel_RallyRanking:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end


function RallyRankingHideAni()
	local aniInfo1 = Panel_RallyRanking:addColorAnimation( 0.0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)
end


local RallyRanking = {
	_btnClose			= UI.getChildControl( Panel_RallyRanking, "Button_Win_Close" ),
	-- _btnHelp			= UI.getChildControl( Panel_RallyRanking, "Button_Question" ),	-- 도움말 추가시 사용

	_listBg				= UI.getChildControl( Panel_RallyRanking, "Static_BG" ),

	_myRanking			= UI.getChildControl( Panel_RallyRanking, "StaticText_MyRanking" ),
	_inMyRankRate		= UI.getChildControl( Panel_RallyRanking, "Slider_InMyRank" ),
	
	firstRanker			= UI.getChildControl( Panel_RallyRanking, "StaticText_First_Rank" ),
	firstRankerName		= UI.getChildControl( Panel_RallyRanking, "StaticText_FirstCharacterName" ),
	firstRankerGuild	= UI.getChildControl( Panel_RallyRanking, "StaticText_FirstGuildName" ),
	secondRanker		= UI.getChildControl( Panel_RallyRanking, "StaticText_Second_Rank" ),
	secondRankerName	= UI.getChildControl( Panel_RallyRanking, "StaticText_SecondCharacterName" ),
	secondRankerGuild	= UI.getChildControl( Panel_RallyRanking, "StaticText_SecondGuildName" ),
	thirdRanker			= UI.getChildControl( Panel_RallyRanking, "StaticText_Third_Rank" ),
	thirdRankerName		= UI.getChildControl( Panel_RallyRanking, "StaticText_ThirdCharacterName" ),
	thirdRankerGuild	= UI.getChildControl( Panel_RallyRanking, "StaticText_ThirdGuildName" ),

	-- _scroll				= UI.getChildControl( Panel_RallyRanking, "Scroll_RankingList" ),	-- 스크롤 추가시 사용
	
	_topPoint			= {
		UI.getChildControl( Panel_RallyRanking, "StaticText_FirstPoint" ),
		UI.getChildControl( Panel_RallyRanking, "StaticText_SecondPoint" ),
		UI.getChildControl( Panel_RallyRanking, "StaticText_ThirdPoint" ),
	},

	_tab 				= {
		[0]		= UI.getChildControl( Panel_RallyRanking, "RadioButton_Tab_PartyPvP" ),		-- 3:3 결투장
		[1]		= UI.getChildControl( Panel_RallyRanking, "RadioButton_Tab_Race" ),	-- 말 경주
	},
	
	_tabName			= {
		[0]		= PAGetString(Defines.StringSheet_GAME, "LUA_RALLYRANKING_TAB_PARTYPVP"),	-- "결투장"
	    [1]		= PAGetString(Defines.StringSheet_GAME, "LUA_RALLYRANKING_TAB_RACE"),		-- "말 경주"
	},
	
	_createTabCount		= 2,
	_createListCount	= 30,
	_listCount			= 0,
	_startIndex			= 0,
	_selectedTabIdx		= 0,
	_listPool			= {},

	_posConfig = {
		_tabStartPosX 	= 14,
		_tabPosXGap 	= 100,
		_listStartPosY 	= 190,
		_listPosYGap 	= 15.5,
	},
}

function RallyRanking_Initionalize()
	for listIdx = 0, RallyRanking._createListCount - 1 do
		local rankList = {}

		rankList.rank = UI.createAndCopyBasePropertyControl( Panel_RallyRanking, "StaticText_PlayerRank", Panel_RallyRanking, "RallyRanking_Rank_"	.. listIdx )
		rankList.rank:SetPosX( 47 )
		rankList.rank:SetPosY( RallyRanking._posConfig._listStartPosY + ( RallyRanking._posConfig._listPosYGap * listIdx ) )

		rankList.name = UI.createAndCopyBasePropertyControl( Panel_RallyRanking, "StaticText_PlayerName", Panel_RallyRanking, "RallyRanking_Name_" .. listIdx )
		rankList.name:SetPosX( 86 )
		rankList.name:SetPosY( RallyRanking._posConfig._listStartPosY + ( RallyRanking._posConfig._listPosYGap * listIdx ) )

		rankList.guild = UI.createAndCopyBasePropertyControl( Panel_RallyRanking, "StaticText_PlayerGuildName", Panel_RallyRanking, "RallyRanking_Guild_" .. listIdx )
		rankList.guild:SetPosX( 467 )
		rankList.guild:SetPosY( RallyRanking._posConfig._listStartPosY + (RallyRanking._posConfig._listPosYGap * listIdx ) )

		rankList.point = UI.createAndCopyBasePropertyControl( Panel_RallyRanking, "StaticText_PlayerPoint", Panel_RallyRanking, "RallyRanking_PointList_" .. listIdx )
		rankList.point:SetPosX( 645 )
		rankList.point:SetPosY( RallyRanking._posConfig._listStartPosY + ( RallyRanking._posConfig._listPosYGap * listIdx ) )
		
		---- 스크롤 추가시 사용  ----------------------------------------------
		-- rankList.rank:addInputEvent( "Mouse_UpScroll",		"RallyRanking_ScrollEvent( true )"	)
		-- rankList.rank:addInputEvent( "Mouse_DownScroll",	"RallyRanking_ScrollEvent( false )"	)
		-- rankList.name:addInputEvent( "Mouse_UpScroll",		"RallyRanking_ScrollEvent( true )" )
		-- rankList.name:addInputEvent( "Mouse_DownScroll",	"RallyRanking_ScrollEvent( false )" )
		-- rankList.guild:addInputEvent( "Mouse_UpScroll",		"RallyRanking_ScrollEvent( true )" )
		-- rankList.guild:addInputEvent( "Mouse_DownScroll",	"RallyRanking_ScrollEvent( false )" )
		-- rankList.point:addInputEvent( "Mouse_UpScroll",		"RallyRanking_ScrollEvent( true )")
		-- rankList.point:addInputEvent( "Mouse_DownScroll",	"RallyRanking_ScrollEvent( false )")
		-- UIScroll.InputEventByControl( rankList.rank,		"RallyRanking_ScrollEvent" )
		-- UIScroll.InputEventByControl( rankList.name,		"RallyRanking_ScrollEvent" )
		-- UIScroll.InputEventByControl( rankList.guild,		"RallyRanking_ScrollEvent" )
		-- UIScroll.InputEventByControl( rankList.point,		"RallyRanking_ScrollEvent" )
		-----------------------------------------------------------------------
		RallyRanking._listPool[listIdx] = rankList
	end

	local screenSizeX = getScreenSizeX()
	local screenSizeY = getScreenSizeY()
	Panel_RallyRanking:SetPosX( (screenSizeX - Panel_RallyRanking:GetSizeX()) / 2 )
	Panel_RallyRanking:SetPosY( (screenSizeY - Panel_RallyRanking:GetSizeY()) / 2 )
end

function RallyRanking:Update()
	for listIdx = 0, RallyRanking._createListCount - 1 do	-- 초기화
		local list = RallyRanking._listPool[listIdx]
		list.rank						:SetShow( false )
		list.name						:SetShow( false )
		list.guild						:SetShow( false )
		list.point						:SetShow( false )
		RallyRanking.firstRanker		:SetShow( false )
		RallyRanking.secondRanker		:SetShow( false )
		RallyRanking.thirdRanker		:SetShow( false )
		RallyRanking.firstRankerName	:SetShow( false )
		RallyRanking.secondRankerName	:SetShow( false )
		RallyRanking.thirdRankerName	:SetShow( false )
		RallyRanking.firstRankerGuild	:SetShow( false )
		RallyRanking.secondRankerGuild	:SetShow( false )
		RallyRanking.thirdRankerGuild	:SetShow( false )
		RallyRanking._topPoint[1]		:SetShow( false )
		RallyRanking._topPoint[2]		:SetShow( false )
		RallyRanking._topPoint[3]		:SetShow( false )
	end
	
	RallyRanking._listCount = ToClient_GetMatchRankerCount( RallyRanking._selectedTabIdx )

	local count			= 0
	local rallyType		= nil
	
	for listIdx = RallyRanking._startIndex , RallyRanking._listCount - 1 do
		local rallyRanker			= ToClient_GetMatchRankerAt(RallyRanking._selectedTabIdx, listIdx)
		local rallyRankerName		= rallyRanker:getUserName()
		local rallyRankerCharName	= rallyRanker:getCharacterName()
		local rallyRankerPoint		= rallyRanker:getMatchPoint()
		local rallyRankerGuild		= rallyRanker:getGuildName()
		local rallyRankerisMyGuild	= rallyRanker:isGuildMember()

		if (RallyRanking._createListCount <= count ) or ( 0 == rallyRankerPoint ) then
			break;
		end
		
		local list = RallyRanking._listPool[count]

		if 0 == listIdx then
			RallyRanking.firstRanker		:SetShow( true )
			RallyRanking.firstRankerName	:SetShow( true )
			RallyRanking.firstRankerGuild	:SetShow( true )
			RallyRanking._topPoint[1]		:SetShow( true )
			RallyRanking.firstRanker		:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_RALLYRANKING_RANK", "listIdx", listIdx+1 ) )	-- "listIdx+1 .. "위 "
			RallyRanking.firstRankerName	:SetText( rallyRankerName .. "(" .. rallyRankerCharName .. ")" )
			RallyRanking.firstRankerGuild	:SetText( rallyRankerGuild )
			RallyRanking._topPoint[1]		:SetText( rallyRankerPoint )
			RallyRanking.firstRanker		:SetFontColor( UI_color.C_FFEF5378 )
			RallyRanking.firstRankerName	:SetFontColor( UI_color.C_FFEF5378 )
			RallyRanking.firstRankerGuild	:SetFontColor( UI_color.C_FFEF5378 )
			RallyRanking._topPoint[1]		:SetFontColor( UI_color.C_FFEF5378 )
			RallyRanking.firstRankerName	:addInputEvent( "Mouse_LUp", "RallyRanking_RankerWhisper( " .. listIdx .. " )" )
		elseif 1 == listIdx then
			RallyRanking.secondRanker		:SetShow( true )
			RallyRanking.secondRankerName	:SetShow( true )
			RallyRanking.secondRankerGuild	:SetShow( true )
			RallyRanking._topPoint[2]		:SetShow( true )
			RallyRanking.secondRanker		:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_RALLYRANKING_RANK", "listIdx", listIdx+1 ) )	-- "listIdx+1 .. "위 "
			RallyRanking.secondRankerName	:SetText( rallyRankerName .. "(" .. rallyRankerCharName .. ")" )
			RallyRanking.secondRankerGuild	:SetText( rallyRankerGuild )
			RallyRanking._topPoint[2]		:SetText( rallyRankerPoint )
			RallyRanking.secondRanker		:SetFontColor( UI_color.C_FF88DF00 )
			RallyRanking.secondRankerName	:SetFontColor( UI_color.C_FF88DF00 )
			RallyRanking.secondRankerGuild	:SetFontColor( UI_color.C_FF88DF00 )
			RallyRanking._topPoint[2]		:SetFontColor( UI_color.C_FF88DF00 )
			RallyRanking.secondRankerName	:addInputEvent( "Mouse_LUp", "RallyRanking_RankerWhisper( " .. listIdx .. " )" )
		elseif 2 == listIdx then
			RallyRanking.thirdRanker		:SetShow( true )
			RallyRanking.thirdRankerName	:SetShow( true )
			RallyRanking.thirdRankerGuild	:SetShow( true )
			RallyRanking._topPoint[3]		:SetShow( true )
			RallyRanking.thirdRanker		:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_RALLYRANKING_RANK", "listIdx", listIdx+1 ) )	-- "listIdx+1 .. "위 "
			RallyRanking.thirdRankerName	:SetText( rallyRankerName .. "(" .. rallyRankerCharName .. ")" )
			RallyRanking.thirdRankerGuild	:SetText( rallyRankerGuild )
			RallyRanking._topPoint[3]		:SetText( rallyRankerPoint )
			RallyRanking.thirdRanker		:SetFontColor( UI_color.C_FF6DC6FF )
			RallyRanking.thirdRankerName	:SetFontColor( UI_color.C_FF6DC6FF )
			RallyRanking.thirdRankerGuild	:SetFontColor( UI_color.C_FF6DC6FF )
			RallyRanking._topPoint[3]		:SetFontColor( UI_color.C_FF6DC6FF )
			RallyRanking.thirdRankerName	:addInputEvent( "Mouse_LUp", "RallyRanking_RankerWhisper( " .. listIdx .. " )" )
		else
			list.rank		:SetShow( true )
			list.name		:SetShow( true )
			list.guild		:SetShow( true )
			list.point		:SetShow( true )
			list.rank		:SetFontColor(UI_color.C_FFC4BEBE)
			list.name		:SetFontColor(UI_color.C_FFC4BEBE)
			list.guild		:SetFontColor(UI_color.C_FFC4BEBE)
			list.point		:SetFontColor(UI_color.C_FFC4BEBE)
			list.rank		:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_RALLYRANKING_RANK", "listIdx", listIdx+1 ) )	-- "listIdx+1 .. "위 "
			list.name		:SetText( rallyRankerName .. "(" .. rallyRankerCharName .. ")" )
			list.guild		:SetText( rallyRankerGuild )
			list.point		:SetText( rallyRankerPoint )
			list.name		:addInputEvent( "Mouse_LUp", "RallyRanking_RankerWhisper( " .. listIdx .. " )" )
		end	
		count = count + 1
	end
	
	local myRallyPoint			= ToClient_GetMyMatchPoint( RallyRanking._selectedTabIdx )
	local myRallyRanker			= ToClient_GetMyMatchRank( RallyRanking._selectedTabIdx )
	local servnerUserCnt		= ToClient_GetMatchRankerUserCount( RallyRanking._selectedTabIdx ) -- 동접자수 확인할 수 있는 함수이니 절대 그냥 사용하지 말 것.(로그를 쓰더라도 커밋하기전에 삭제할 것.)
	local myRallyRankerRate		= tonumber(myRallyRanker / servnerUserCnt * 100)	
	local rallyGrade 			= nil

	rallyType = RallyRanking._tabName[RallyRanking._selectedTabIdx]
	
	RallyRanking._inMyRankRate	:SetShow( false )	-- 순위 표시바를 우선 감춤
	
	if (30 >= myRallyRanker) and (0 ~= myRallyPoint) then		-- 나의 순위가 30위 이내이고 0점이 아닐 경우
		RallyRanking._myRanking		:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_RALLYRANKING_MYRANK", "rallyType", rallyType, "myRallyRanker", myRallyRanker ) )	-- "나의..rallyType..순위 : ..myRallyRanker위"
	elseif 0 == myRallyPoint then	-- 나의 점수가 0점일 경우
		RallyRanking._myRanking		:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_RALLYRANKING_MYRANK_NOPOINT", "rallyType", rallyType ) )	-- "rallyType.. 점수를 획득하지 않아 나의 순위가 표시되지 않습니다."
	else							-- 나의 순위가 30위를 넘어갈 경우
		if 0 <= myRallyRankerRate and myRallyRankerRate <= 20 then
			rallyGrade = "A"
		elseif 20 < myRallyRankerRate and myRallyRankerRate <= 40 then
			rallyGrade = "B"
		elseif 40 < myRallyRankerRate and myRallyRankerRate <= 60 then
			rallyGrade = "C"
		elseif 60 < myRallyRankerRate and myRallyRankerRate <= 80 then
			rallyGrade = "D"
		elseif 80 < myRallyRankerRate and myRallyRankerRate <= 100 then
			rallyGrade = "E"
		end
		RallyRanking._myRanking		:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_RALLYRANKING_GRADETYPE", "rallyType", rallyType, "rallyGrade", rallyGrade ) )	-- "나의 .. rallyType .. 순위는 .. rallyGrade .. 등급 구간에 위치하고 있습니다."
		RallyRanking._inMyRankRate	:SetShow( true )
		RallyRanking._inMyRankRate	:SetControlPos( myRallyRankerRate )
	end
	
	-- UIScroll.SetButtonSize			( RallyRanking._scroll, RallyRanking._createListCount, RallyRanking._listCount )	-- 스크롤 추가시 사용
end

--[[-- ---- 스크롤 추가시 사용  -----------------------------------------------
function RallyRanking_ScrollEvent( isScrollUp )
	RallyRanking._startIndex	= UIScroll.ScrollEvent( RallyRanking._scroll, isScrollUp, RallyRanking._createListCount, RallyRanking._listCount, RallyRanking._startIndex, 1 )
	RallyRanking:Update()
end
---------------------------------------------------------------------------]]--

function RallyRanking_SelectTab( idx )	-- 이후 타입 추가시 탭 항목 사용
	for listIdx = 0, RallyRanking._createListCount - 1 do	-- 리스트 초기화.
		local list = RallyRanking._listPool[listIdx]
		list.rank		:SetShow( false )
		list.name		:SetShow( false )
		list.guild		:SetShow( false )
		list.point		:SetShow( false )
	end

	RallyRanking._startIndex = 0
	RallyRanking._selectedTabIdx = idx
	
	ToClient_RequestMatchRanker( RallyRanking._selectedTabIdx )

	-- RallyRanking._scroll:SetControlTop()	-- 스크롤 추가시
	-- UIScroll.SetButtonSize			( RallyRanking._scroll, RallyRanking._createListCount, 0 )
end

function FGlobal_RallyRanking_Open( reFresh )	-- reFresh : true = 순위 목록 갱신

	if not reFresh then
		local isMainChannel		= getCurrentChannelServerData()._isMain
		local isDevServer		= ToClient_IsDevelopment()
		if (isMainChannel) or (isDevServer) then
			if Panel_RallyRanking:GetShow() then
				Panel_RallyRanking:SetShow( false, false )
			end
			
			RallyRanking._selectedTabIdx = 0	-- 0-결투

			for idx, value in pairs(RallyRanking._tab) do
				RallyRanking._tab[idx]:SetCheck( false )
			end
			
			RallyRanking._tab[0]:SetCheck( true )

			ToClient_RequestMatchRanker( RallyRanking._selectedTabIdx )
		else
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_RALLYRANKING_MSG_ONLYMAINCHANNEL") )	-- "1채널에서만 대회 순위 확인이 가능합니다."
			return
		end	

	elseif (true == reFresh) then	-- 60초마다 순위 갱신용
		ToClient_RequestMatchRanker( RallyRanking._selectedTabIdx )
	end
end

function FGlobal_RallyRanking_Close()
	Panel_RallyRanking:SetShow( false, false )
end

function RallyRanking_RankerWhisper( rankIdx )
	local rallyRanker			= ToClient_GetMatchRankerAt( RallyRanking._selectedTabIdx, rankIdx )
	local rallyRankerCharName	= rallyRanker:getCharacterName()

	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
	FGlobal_ChattingInput_ShowWhisper( rallyRankerCharName )
end

-- function RallyRanking_Simpletooltips( isShow, contolNo )	-- 툴팁 추가시
	-- local control, name = nil, nil
	-- if isShow == true then
		-- contol	= RallyRanking._tab[contolNo]
		-- name	= RallyRanking._tabName[contolNo]
		-- registTooltipControl(contol, Panel_Tooltip_SimpleText)
		-- TooltipSimple_Show( contol, name, nil )
	-- else
		-- TooltipSimple_Hide()
	-- end
-- end

function RallyRanking_Repos()
	local screenSizeX = getScreenSizeX()
	local screenSizeY = getScreenSizeY()
	Panel_RallyRanking:SetPosX( (screenSizeX - Panel_RallyRanking:GetSizeX()) / 2 )
	Panel_RallyRanking:SetPosY( (screenSizeY - Panel_RallyRanking:GetSizeY()) / 2 )
end

function RallyRanking_registEventHandler()
	Panel_RallyRanking:RegisterShowEventFunc( true, 'RallyRankingShowAni()' )
	Panel_RallyRanking:RegisterShowEventFunc( false, 'RallyRankingHideAni()' )
	
	RallyRanking._btnClose	:addInputEvent("Mouse_LUp", "FGlobal_RallyRanking_Close()")

	for idx, value in pairs(RallyRanking._tab) do
		RallyRanking._tab[idx]	:addInputEvent("Mouse_LUp", "RallyRanking_SelectTab( " .. idx .. " )")
	end
	
	-- registerEvent("FromClient_ResponseMatchRank", "FromClient_ResponseMatchRank")
	registerEvent("onScreenResize", 				"RallyRanking_Repos" )

	Panel_RallyRanking:RegisterUpdateFunc("RallyRankingTimeCount")	-- 60초마다 순위 갱신
	
	---- 스크롤 추가시 ----------------- ----------------------------------------------------------------
	-- RallyRanking._listBg	:addInputEvent(	"Mouse_UpScroll",	"RallyRanking_ScrollEvent( true )"	)
	-- RallyRanking._listBg	:addInputEvent(	"Mouse_DownScroll",	"RallyRanking_ScrollEvent( false )"	)
	-- UIScroll.InputEvent( RallyRanking._scroll,	"RallyRanking_ScrollEvent" )
	-----------------------------------------------------------------------------------------------------
end  

function FromClient_ResponseMatchRank(responsed_RallyType)	-- 클라 호출로 대회 순위창을 염 (순위 요청을 하면 클라에서 호출됨)
	if not Panel_RallyRanking:GetShow() then
		audioPostEvent_SystemUi(01,00)
		Panel_RallyRanking:SetShow( true, true )
	end
	RallyRanking:Update()
end

local returnTime = 0
function RallyRankingTimeCount( deltaTime )	-- 순위 목록 60초마다 갱신
	returnTime = returnTime + deltaTime
	if 60 < returnTime then
		returnTime = 0
		FGlobal_RallyRanking_Open( true )	-- true : 리프레쉬
	end
end

RallyRanking_Initionalize()
RallyRanking_registEventHandler()

