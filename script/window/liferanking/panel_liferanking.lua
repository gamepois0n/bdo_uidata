local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color
local IM            = CppEnums.EProcessorInputMode
local UI_TM 		= CppEnums.TextMode

Panel_LifeRanking:SetShow( false, false )

Panel_LifeRanking:RegisterShowEventFunc( true, 'LifeRankingShowAni()' )
Panel_LifeRanking:RegisterShowEventFunc( false, 'LifeRankingHideAni()' )

function LifeRankingShowAni()
	UIAni.fadeInSCR_Down( Panel_LifeRanking )

	local aniInfo1 = Panel_LifeRanking:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.2)
	aniInfo1.AxisX = Panel_LifeRanking:GetSizeX() / 2
	aniInfo1.AxisY = Panel_LifeRanking:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_LifeRanking:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.2)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_LifeRanking:GetSizeX() / 2
	aniInfo2.AxisY = Panel_LifeRanking:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function LifeRankingHideAni()
	local aniInfo1 = Panel_LifeRanking:addColorAnimation( 0.0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)
end

local LifeRanking = {
	_txtTitle			= UI.getChildControl( Panel_LifeRanking, "StaticText_Title" ),
	_btnClose			= UI.getChildControl( Panel_LifeRanking, "Button_Win_Close" ),
	_btnHelp			= UI.getChildControl( Panel_LifeRanking, "Button_Question" ),
	_scroll				= UI.getChildControl( Panel_LifeRanking, "Scroll_RankingList" ),
	_listBg				= UI.getChildControl( Panel_LifeRanking, "Static_BG" ),

	_myRanking			= UI.getChildControl( Panel_LifeRanking, "StaticText_MyRanking" ),
	_inMyRankRate		= UI.getChildControl( Panel_LifeRanking, "Slider_InMyRank" ),
	
	firstRanker			= UI.getChildControl( Panel_LifeRanking, "StaticText_Rank_First" ),
	firstRankerName		= UI.getChildControl( Panel_LifeRanking, "StaticText_FirstCharacterName" ),
	firstRankerGuild	= UI.getChildControl( Panel_LifeRanking, "StaticText_FirstGuildName" ),
	secondRanker		= UI.getChildControl( Panel_LifeRanking, "StaticText_Rank_Second" ),
	secondRankerName	= UI.getChildControl( Panel_LifeRanking, "StaticText_SecondCharacterName" ),
	secondRankerGuild	= UI.getChildControl( Panel_LifeRanking, "StaticText_SecondGuildName" ),
	thirdRanker			= UI.getChildControl( Panel_LifeRanking, "StaticText_Rank_Third" ),
	thirdRankerName		= UI.getChildControl( Panel_LifeRanking, "StaticText_ThirdCharacterName" ),
	thirdRankerGuild	= UI.getChildControl( Panel_LifeRanking, "StaticText_ThirdGuildName" ),
	
	_topGrade			= {
		UI.getChildControl( Panel_LifeRanking, "StaticText_Grade_First" ),
		UI.getChildControl( Panel_LifeRanking, "StaticText_Grade_Second" ),
		UI.getChildControl( Panel_LifeRanking, "StaticText_Grade_Third" ),
	},

	_tab 				= {
		[0]		= UI.getChildControl( Panel_LifeRanking, "RadioButton_Tab_Gathering" ),
		[1]		= UI.getChildControl( Panel_LifeRanking, "RadioButton_Tab_Fishing" ),
		[2]		= UI.getChildControl( Panel_LifeRanking, "RadioButton_Tab_Hunting" ),
		[3]		= UI.getChildControl( Panel_LifeRanking, "RadioButton_Tab_Cook" ),
		[4]		= UI.getChildControl( Panel_LifeRanking, "RadioButton_Tab_Alchemy" ),
		[5]		= UI.getChildControl( Panel_LifeRanking, "RadioButton_Tab_Manufacture" ),
		[6]		= UI.getChildControl( Panel_LifeRanking, "RadioButton_Tab_Mating" ),
		[7]		= UI.getChildControl( Panel_LifeRanking, "RadioButton_Tab_Trade" ),
		[8]		= UI.getChildControl( Panel_LifeRanking, "RadioButton_Tab_Growth" ),
		[9]		= UI.getChildControl( Panel_LifeRanking, "RadioButton_Tab_Wealth" ),
		[10]	= UI.getChildControl( Panel_LifeRanking, "RadioButton_Tab_Combat" ),
		[11]	= UI.getChildControl( Panel_LifeRanking, "RadioButton_Tab_Rally" ),
		[12]	= UI.getChildControl( Panel_LifeRanking, "RadioButton_Tab_LocalWar" ),
	},

	_tabName			= {
		[0]		= PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_TAB_GATHER"),			-- "채집"
	    [1]		= PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_TAB_FISH"),			-- "낚시"
	    [2]		= PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_TAB_HUNT"),			-- "수렵"
	    [3]		= PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_TAB_COOK"),			-- "요리"
	    [4]		= PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_TAB_ALCHEMY"),			-- "연금"
	    [5]		= PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_TAB_MANUFACTURE"),		-- "가공"
	    [6]		= PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_TAB_HORSE"),			-- "조련"
	    [7]		= PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_TAB_TRADE"),			-- "무역"
	    [8]		= PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_TAB_GROWTH"),			-- "재배"
	    [9]		= PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_TAB_WEALTH"),			-- "재화"
	    [10]	= PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_TAB_COMBAT"),			-- "성장"
		[11]	= PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_NAK_PVPMATCH_NAME"),	-- "결투장"
		[12]	= PAGetString(Defines.StringSheet_GAME, "LUA_LIFERANKING_TAB_LOCALWAR"),		-- "국지전"
	},
	
	_createTabCount		= 13,
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

--채집, 가공, 요리, 조련, 연금, 낚시, 수렵, 무역, 재배
local rankingTabId = 
{
	tab_Gathering		= 0,
	tab_Fishing			= 1,
	tab_Hunting			= 2,
	tab_Cook			= 3,
	tab_Alchemy			= 4,
	tab_Manufacture		= 5,
	tab_Mating			= 6,
	tab_Trade			= 7,
	tab_Growth			= 8,
	tab_Wealth			= 9,
	tab_Combat			= 10,
	tab_Rally			= 11,
	tab_LocalWar		= 12,
}

LifeRanking._btnHelp:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"LifeRanking\" )" )			-- 물음표 좌클릭
LifeRanking._btnHelp:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"LifeRanking\", \"true\")" )	-- 물음표 마우스오버
LifeRanking._btnHelp:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"LifeRanking\", \"false\")" )	-- 물음표 마우스아웃

local tooltip =
{
	_bg		= UI.getChildControl( Panel_LifeRanking, "Static_TooltipBG" ),
	_name	= UI.getChildControl( Panel_LifeRanking, "Tooltip_Name" ),
	_desc	= UI.getChildControl( Panel_LifeRanking, "Tooltip_Description" )
}
tooltip._desc:SetTextMode( UI_TM.eTextMode_AutoWrap )
tooltip._bg:SetIgnore( true )

function LifeRanking_Initionalize()

	for listIdx = 0, LifeRanking._createListCount - 1 do
		local rankList = {}
		rankList.rank = UI.createAndCopyBasePropertyControl( Panel_LifeRanking, "StaticText_PlayerRank", Panel_LifeRanking, "LifeRanking_Rank_"	.. listIdx )
		rankList.rank:SetPosX( 47 )
		rankList.rank:SetPosY( LifeRanking._posConfig._listStartPosY + ( LifeRanking._posConfig._listPosYGap * listIdx ) )

		rankList.name = UI.createAndCopyBasePropertyControl( Panel_LifeRanking, "StaticText_PlayerName", Panel_LifeRanking, "LifeRanking_Name_" .. listIdx )
		rankList.name:SetPosX( 86 )
		rankList.name:SetPosY( LifeRanking._posConfig._listStartPosY + ( LifeRanking._posConfig._listPosYGap * listIdx ) )

		rankList.guild = UI.createAndCopyBasePropertyControl( Panel_LifeRanking, "StaticText_AnotherGuildName", Panel_LifeRanking, "LifeRanking_Guild_" .. listIdx )
		rankList.guild:SetPosX( 467 )
		rankList.guild:SetPosY( LifeRanking._posConfig._listStartPosY + (LifeRanking._posConfig._listPosYGap * listIdx ) )

		rankList.grade = UI.createAndCopyBasePropertyControl( Panel_LifeRanking, "StaticText_MyLifeGrade", Panel_LifeRanking, "LifeRanking_GradeList_" .. listIdx )
		rankList.grade:SetPosX( 645 )
		rankList.grade:SetPosY( LifeRanking._posConfig._listStartPosY + ( LifeRanking._posConfig._listPosYGap * listIdx ) )

		---- 스크롤 추가시 사용  ----------------------------------------------
		-- rankList.rank:addInputEvent( "Mouse_UpScroll",		"LifeRanking_ScrollEvent( true )"	)
		-- rankList.rank:addInputEvent( "Mouse_DownScroll",	"LifeRanking_ScrollEvent( false )"	)		
		-- rankList.name:addInputEvent( "Mouse_UpScroll",		"LifeRanking_ScrollEvent( true )" )
		-- rankList.name:addInputEvent( "Mouse_DownScroll",	"LifeRanking_ScrollEvent( false )" )
		-- rankList.guild:addInputEvent( "Mouse_UpScroll",		"LifeRanking_ScrollEvent( true )" )
		-- rankList.guild:addInputEvent( "Mouse_DownScroll",	"LifeRanking_ScrollEvent( false )" )
		-- rankList.grade:addInputEvent( "Mouse_UpScroll",		"LifeRanking_ScrollEvent( true )")
		-- rankList.grade:addInputEvent( "Mouse_DownScroll",	"LifeRanking_ScrollEvent( false )")
		-- UIScroll.InputEventByControl( rankList.rank,		"LifeRanking_ScrollEvent" )
		-- UIScroll.InputEventByControl( rankList.name,		"LifeRanking_ScrollEvent" )
		-- UIScroll.InputEventByControl( rankList.guild,		"LifeRanking_ScrollEvent" )
		-- UIScroll.InputEventByControl( rankList.grade,		"LifeRanking_ScrollEvent" )
		-----------------------------------------------------------------------
		LifeRanking._listPool[listIdx] = rankList
	end

	LifeRanking._tab[0]:SetCheck( true )	-- 0번 탭 선택

	local screenSizeX = getScreenSizeX()
	local screenSizeY = getScreenSizeY()
	Panel_LifeRanking:SetPosX( (screenSizeX - Panel_LifeRanking:GetSizeX()) / 2 )
	Panel_LifeRanking:SetPosY( (screenSizeY - Panel_LifeRanking:GetSizeY()) / 2 )

	Panel_LifeRanking:SetChildIndex( tooltip._bg, 9999 )
	Panel_LifeRanking:SetChildIndex( tooltip._name, 9999 )
	Panel_LifeRanking:SetChildIndex( tooltip._desc, 9999 )
end

local rankerData = {}
function LifeRanking:Update()
	
	local levelFlotFunc = function( lifeRankerWrp )		-- 레벨 소수점 자리 함수
		if nil == lifeRankerWrp then
			return
		end
		
		local _const		= Defines.s64_const
		local rate			= 0
		local rateDisplay	= 0
		local s64_needExp	= lifeRankerWrp:getNeedExp_s64()
		local s64_exp		= lifeRankerWrp:getExperience_s64()

		if _const.s64_10000 < s64_needExp then
			rate = Int64toInt32( s64_exp / ( s64_needExp / _const.s64_100 ))
		elseif _const.s64_0 ~= s64_needExp then
			rate = Int64toInt32( (s64_exp * _const.s64_100) / s64_needExp )
		end		
		if 10 > rate then
			rateDisplay = (".0") .. rate
		else
			rateDisplay = (".") .. rate
		end

		return rateDisplay
	end

	for listIdx = 0, LifeRanking._createListCount - 1 do	-- 리스트 초기화.
		local list = LifeRanking._listPool[listIdx]
		list.rank						:SetShow( false )
		list.name						:SetShow( false )
		list.guild						:SetShow( false )
		list.grade						:SetShow( false )
		LifeRanking.firstRanker			:SetShow( false )
		LifeRanking.secondRanker		:SetShow( false )
		LifeRanking.thirdRanker			:SetShow( false )
		LifeRanking.firstRankerName		:SetShow( false )
		LifeRanking.secondRankerName	:SetShow( false )
		LifeRanking.thirdRankerName		:SetShow( false )
		LifeRanking.firstRankerGuild	:SetShow( false )
		LifeRanking.secondRankerGuild	:SetShow( false )
		LifeRanking.thirdRankerGuild	:SetShow( false )
		LifeRanking._topGrade[1]		:SetShow( false )
		LifeRanking._topGrade[2]		:SetShow( false )
		LifeRanking._topGrade[3]		:SetShow( false )
	end

	local count				= 0
	local lifeType			= nil
	local lifeRanker		= nil	
	local rankerMoney		= nil
	local myLifeRanker		= nil
	local servnerUserCnt	= nil
	local myLifeRankerRate	= nil

	---- 재화, 성장는 함수가 다르기 때문에 구별 필요함 ( _selectedTabIdx = 9 재화, 10 = 성장 )
	if LifeRanking._selectedTabIdx <= 8 then	-- 채집, 가공, 요리, 조련, 연금, 낚시, 수렵, 무역, 재배
		LifeRanking._listCount	= ToClient_GetLifeRankerCount()
		myLifeRanker			= ToClient_GetLifeMyRank()
		servnerUserCnt			= ToClient_GetLifeRankerUserCount()			-- 동접자수 확인할 수 있는 함수이니 절대 그냥 사용하지 말 것.(로그를 쓰더라도 커밋하기전에 삭제할 것.)
	elseif 9 == LifeRanking._selectedTabIdx then	-- 재화
		LifeRanking._listCount	= ToClient_GetContentsRankCount( 1 )
		myLifeRanker			= ToClient_GetContentsMyRank( 1 )
		servnerUserCnt			= ToClient_GetContentsRankUserCount( 1 )	-- 동접자수 확인할 수 있는 함수이니 절대 그냥 사용하지 말 것.(로그를 쓰더라도 커밋하기전에 삭제할 것.)
	elseif 10 == LifeRanking._selectedTabIdx then	-- 성장
		LifeRanking._listCount	= ToClient_GetContentsRankCount( 0 )
		myLifeRanker			= ToClient_GetContentsMyRank( 0 )
		servnerUserCnt			= ToClient_GetContentsRankUserCount( 0 )	-- 동접자수 확인할 수 있는 함수이니 절대 그냥 사용하지 말 것.(로그를 쓰더라도 커밋하기전에 삭제할 것.)
	elseif 11 == LifeRanking._selectedTabIdx then	-- 결투장
		LifeRanking._listCount	= math.max(ToClient_GetMatchRankerCount( 1 ), 1)
		myLifeRanker			= ToClient_GetMyMatchRank( 0 )
		servnerUserCnt			= ToClient_GetMatchRankerUserCount( 0 )		-- 동접자수 확인할 수 있는 함수이니 절대 그냥 사용하지 말 것.(로그를 쓰더라도 커밋하기전에 삭제할 것.)
	elseif 12 == LifeRanking._selectedTabIdx then	-- 국지전
		LifeRanking._listCount	= ToClient_GetContentsRankCount( 2 )
		myLifeRanker			= ToClient_GetContentsMyRank( 2 )
		servnerUserCnt			= ToClient_GetContentsRankUserCount( 2 )		-- 동접자수 확인할 수 있는 함수이니 절대 그냥 사용하지 말 것.(로그를 쓰더라도 커밋하기전에 삭제할 것.)
	end
	myLifeRankerRate			= tonumber(myLifeRanker / servnerUserCnt * 100)
	
	rankerData = {}
	for listIdx = LifeRanking._startIndex , LifeRanking._listCount - 1 do
		
		if LifeRanking._selectedTabIdx <= 8 then	-- 채집, 가공, 요리, 조련, 연금, 낚시, 수렵, 무역, 재배
			lifeRanker	= ToClient_GetLifeRankerAt( listIdx )
		elseif 9 == LifeRanking._selectedTabIdx then	-- 재화
			lifeRanker	= ToClient_GetMoneyRankAt( listIdx )
			-- rankerMoney	= Int64toInt32(lifeRanker:getMoneyCount_s64())
		elseif 10 == LifeRanking._selectedTabIdx then	-- 성장
			lifeRanker	= ToClient_GetBattleRankAt( listIdx )
		elseif 11 == LifeRanking._selectedTabIdx then	-- 결투장
			lifeRanker	= ToClient_GetMatchRankerAt( 0, listIdx )
		elseif 12 == LifeRanking._selectedTabIdx then	-- 국지전
			lifeRanker	= ToClient_GetLocalWarRankAt( listIdx )
		end
		
		if nil == lifeRanker then
			break
		end
		
		local lifeRankerName		= lifeRanker:getUserName()
		local lifeRankerCharName	= lifeRanker:getCharacterName()
		local lifeRankerGuild		= lifeRanker:getGuildName()
		local lifeRankerIntroDesc	= lifeRanker:getUserIntroduction()
		rankerData[listIdx] = {}
		rankerData[listIdx]._name = lifeRankerName
		rankerData[listIdx]._desc = lifeRankerIntroDesc
		
		local lifeRankerLv			= nil
		if 11 == LifeRanking._selectedTabIdx then	-- 결투장
			lifeRankerLv = lifeRanker:getMatchPoint()
		elseif 12 == LifeRanking._selectedTabIdx then	-- 국지전
			lifeRankerLv = lifeRanker:getAccumulatedKillCount()
		else
			lifeRankerLv = lifeRanker:getLevel()
		end
		
		if ( LifeRanking._createListCount <= count ) or ( 0 == lifeRankerLv ) then
			break;
		end
	
		local list = LifeRanking._listPool[count]
		
		if 0 == listIdx then
			LifeRanking.firstRanker			:SetShow( true )
			LifeRanking.firstRankerName		:SetShow( true )
			LifeRanking.firstRankerGuild	:SetShow( true )
			LifeRanking._topGrade[1]		:SetShow( true )
			LifeRanking.firstRanker			:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_LIFERANKING_RANK", "listIdx", listIdx+1 ) ) -- listIdx+1 .. "위 " )
			LifeRanking.firstRankerName		:SetText( lifeRankerName .. "(" .. lifeRankerCharName .. ")" )
			LifeRanking.firstRankerGuild	:SetText( lifeRankerGuild )
			
			if LifeRanking._selectedTabIdx <= 8 then	-- 채집, 가공, 요리, 조련, 연금, 낚시, 수렵, 무역, 재배
				LifeRanking._topGrade[1]	:SetText( FGlobal_CraftLevel_Replace( lifeRankerLv, LifeRanking._selectedTabIdx ) )
			elseif 9 == LifeRanking._selectedTabIdx then							-- 재화
				LifeRanking._topGrade[1]	:SetShow( false )	-- 재화는 임시로 감춤
				-- LifeRanking._topGrade[1]	:SetText( tostring(rankerMoney) )		-- 은화
			elseif 10 == LifeRanking._selectedTabIdx then							-- 성장
				local levelFlot = levelFlotFunc(lifeRanker)
				LifeRanking._topGrade[1]	:SetText( "Lv " .. tostring(lifeRankerLv) ..  tostring(levelFlot))
			elseif 11 == LifeRanking._selectedTabIdx then							-- 결투장
				LifeRanking._topGrade[1]	:SetText( lifeRankerLv )
			elseif 12 == LifeRanking._selectedTabIdx then							-- 국지전
				LifeRanking._topGrade[1]	:SetText( lifeRankerLv )
			end
			
			LifeRanking.firstRanker			:SetFontColor( UI_color.C_FFEF5378 )
			LifeRanking.firstRankerName		:SetFontColor( UI_color.C_FFEF5378 )
			LifeRanking.firstRankerGuild	:SetFontColor( UI_color.C_FFEF5378 )
			LifeRanking._topGrade[1]		:SetFontColor( UI_color.C_FFEF5378 )
			LifeRanking.firstRankerName		:addInputEvent( "Mouse_LUp", "LifeRanking_RankerWhisper( " .. listIdx .. " )" )
			LifeRanking.firstRankerName		:addInputEvent( "Mouse_On", "LifeRanking_Tooltip( " .. listIdx .. ")" )
			LifeRanking.firstRankerName		:addInputEvent( "Mouse_Out", "LifeRanking_Tooltip()" )
		elseif 1 == listIdx then
			LifeRanking.secondRanker		:SetShow( true )
			LifeRanking.secondRankerName	:SetShow( true )
			LifeRanking.secondRankerGuild	:SetShow( true )
			LifeRanking._topGrade[2]		:SetShow( true )
			LifeRanking.secondRanker		:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_LIFERANKING_RANK", "listIdx", listIdx+1 ) ) -- listIdx+1 .. "위 " )
			LifeRanking.secondRankerName	:SetText( lifeRankerName .. "(" .. lifeRankerCharName .. ")" )
			LifeRanking.secondRankerGuild	:SetText( lifeRankerGuild )
			
			if LifeRanking._selectedTabIdx <= 8 then	-- 채집, 가공, 요리, 조련, 연금, 낚시, 수렵, 무역, 재배
				LifeRanking._topGrade[2]	:SetText( FGlobal_CraftLevel_Replace( lifeRankerLv, LifeRanking._selectedTabIdx ) )
			elseif 9 == LifeRanking._selectedTabIdx then							-- 재화
				LifeRanking._topGrade[2]	:SetShow( false )	-- 재화는 임시로 감춤
				-- LifeRanking._topGrade[2]	:SetText( tostring(rankerMoney) )		-- 은화
			elseif 10 == LifeRanking._selectedTabIdx then							-- 성장
				local levelFlot = levelFlotFunc(lifeRanker)
				LifeRanking._topGrade[2]	:SetText( "Lv " .. tostring(lifeRankerLv) ..  tostring(levelFlot))
			elseif 11 == LifeRanking._selectedTabIdx then							-- 결투장
				LifeRanking._topGrade[2]	:SetText( lifeRankerLv )
			elseif 12 == LifeRanking._selectedTabIdx then							-- 국지전
				LifeRanking._topGrade[2]	:SetText( lifeRankerLv )
			end
			
			LifeRanking.secondRanker		:SetFontColor( UI_color.C_FF88DF00 )
			LifeRanking.secondRankerName	:SetFontColor( UI_color.C_FF88DF00 )
			LifeRanking.secondRankerGuild	:SetFontColor( UI_color.C_FF88DF00 )
			LifeRanking._topGrade[2]		:SetFontColor( UI_color.C_FF88DF00 )
			LifeRanking.secondRankerName	:addInputEvent( "Mouse_LUp", "LifeRanking_RankerWhisper( " .. listIdx .. " )" )
			LifeRanking.secondRankerName		:addInputEvent( "Mouse_On", "LifeRanking_Tooltip( " .. listIdx .. ")" )
			LifeRanking.secondRankerName		:addInputEvent( "Mouse_Out", "LifeRanking_Tooltip()" )
		elseif 2 == listIdx then
			LifeRanking.thirdRanker			:SetShow( true )
			LifeRanking.thirdRankerName		:SetShow( true )
			LifeRanking.thirdRankerGuild	:SetShow( true )
			LifeRanking._topGrade[3]		:SetShow( true )
			LifeRanking.thirdRanker			:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_LIFERANKING_RANK", "listIdx", listIdx+1 ) ) -- listIdx+1 .. "위 " )
			LifeRanking.thirdRankerName		:SetText( lifeRankerName .. "(" .. lifeRankerCharName .. ")" )
			LifeRanking.thirdRankerGuild	:SetText( lifeRankerGuild )
			
			if LifeRanking._selectedTabIdx <= 8 then	-- 채집, 가공, 요리, 조련, 연금, 낚시, 수렵, 무역, 재배
				LifeRanking._topGrade[3]	:SetText( FGlobal_CraftLevel_Replace( lifeRankerLv, LifeRanking._selectedTabIdx ) )
			elseif 9 == LifeRanking._selectedTabIdx then							-- 재화
				LifeRanking._topGrade[3]	:SetShow( false )	-- 재화는 임시로 감춤
				-- LifeRanking._topGrade[3]	:SetText( tostring(rankerMoney) )		-- 은화
			elseif 10 == LifeRanking._selectedTabIdx then							-- 성장
				local levelFlot = levelFlotFunc(lifeRanker)
				LifeRanking._topGrade[3]	:SetText( "Lv " .. tostring(lifeRankerLv) ..  tostring(levelFlot))
			elseif 11 == LifeRanking._selectedTabIdx then							-- 결투장
				LifeRanking._topGrade[3]	:SetText( lifeRankerLv )
			elseif 12 == LifeRanking._selectedTabIdx then							-- 국지전
				LifeRanking._topGrade[3]	:SetText( lifeRankerLv )
			end

			LifeRanking.thirdRanker			:SetFontColor( UI_color.C_FF6DC6FF )
			LifeRanking.thirdRankerName		:SetFontColor( UI_color.C_FF6DC6FF )
			LifeRanking.thirdRankerGuild	:SetFontColor( UI_color.C_FF6DC6FF )
			LifeRanking._topGrade[3]		:SetFontColor( UI_color.C_FF6DC6FF )
			LifeRanking.thirdRankerName		:addInputEvent( "Mouse_LUp", "LifeRanking_RankerWhisper( " .. listIdx .. " )" )
			LifeRanking.thirdRankerName		:addInputEvent( "Mouse_On", "LifeRanking_Tooltip( " .. listIdx .. ")" )
			LifeRanking.thirdRankerName		:addInputEvent( "Mouse_Out", "LifeRanking_Tooltip()" )
		else
			list.rank	:SetShow( true )
			list.name	:SetShow( true )
			list.guild	:SetShow( true )
			list.grade	:SetShow( true )
			list.rank	:SetFontColor(UI_color.C_FFC4BEBE)
			list.name	:SetFontColor(UI_color.C_FFC4BEBE)
			list.guild	:SetFontColor(UI_color.C_FFC4BEBE)
			list.grade	:SetFontColor(UI_color.C_FFC4BEBE)
			list.rank	:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_LIFERANKING_RANK", "listIdx", listIdx+1 ) ) -- listIdx+1 .. "위 " )
			list.name	:SetText( lifeRankerName .. "(" .. lifeRankerCharName .. ")" )
			list.guild	:SetText( lifeRankerGuild )
			
			if LifeRanking._selectedTabIdx <= 8 then	-- 채집, 가공, 요리, 조련, 연금, 낚시, 수렵, 무역, 재배
				list.grade	:SetText( FGlobal_CraftLevel_Replace( lifeRankerLv, LifeRanking._selectedTabIdx ) )
			elseif 9 == LifeRanking._selectedTabIdx then			-- 재화
				list.grade	:SetShow( false )	-- 재화는 임시로 감춤
				-- list.grade	:SetText( tostring(rankerMoney) )	-- 은화
			elseif 10 == LifeRanking._selectedTabIdx then			-- 성장
				local levelFlot = levelFlotFunc(lifeRanker)
				list.grade	:SetText( "Lv " .. tostring(lifeRankerLv) ..  tostring(levelFlot))
			elseif 11 == LifeRanking._selectedTabIdx then							-- 결투장
				list.grade	:SetText( lifeRankerLv )
			elseif 12 == LifeRanking._selectedTabIdx then							-- 국지전
				list.grade	:SetText( lifeRankerLv )
			end

			list.name	:addInputEvent( "Mouse_LUp", "LifeRanking_RankerWhisper( " .. listIdx .. " )" )
			list.name	:addInputEvent( "Mouse_On", "LifeRanking_Tooltip( " .. listIdx .. ")" )
			list.name	:addInputEvent( "Mouse_Out", "LifeRanking_Tooltip()" )
		end	
		count = count + 1
	end
	
	-- 30등 이내면 등수로 표시하고 30등 초과면 상위 몇 %인지 표현
	lifeType = LifeRanking._tabName[LifeRanking._selectedTabIdx]

	local lifeRankerLv			= nil
	if 11 == LifeRanking._selectedTabIdx then		-- 결투장
		lifeRankerLv = ToClient_GetMyMatchPoint(0)
	elseif 12 == LifeRanking._selectedTabIdx then	-- 국지전
		lifeRankerLv = ToClient_GetMyAccumulatedKillCount()
	else
		lifeRankerLv = 1
	end
	if myLifeRanker <= 30 and 0 < lifeRankerLv then
		if 12 == LifeRanking._selectedTabIdx then
			myLifeRankGroup = PAGetStringParam3( Defines.StringSheet_GAME, "LUA_LIFERANKING_MYRANKING2_LOCALWAR", "lifeType", lifeType, "myLifeRanker", myLifeRanker, "point", lifeRankerLv )
		else
			myLifeRankGroup = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_LIFERANKING_MYRANKING2", "lifeType", lifeType, "myLifeRanker", myLifeRanker )
		end
		LifeRanking._inMyRankRate:SetShow( false )		-- 30위 내에 존재하면 등급 위치 표시를 해주지 않는다.
	elseif 0 == lifeRankerLv then	-- 나의 점수가 0점일 경우
		myLifeRankGroup = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_RALLYRANKING_MYRANK_NOPOINT", "rallyType", lifeType )	-- "rallyType.. 점수를 획득하지 않아 나의 순위가 표시되지 않습니다."
		LifeRanking._inMyRankRate:SetShow( false )
	else
		-- 구간 등급별로 표현할 때
		if 0 <= myLifeRankerRate and myLifeRankerRate <= 20 then
			lifeGrade = "A"
		elseif 20 < myLifeRankerRate and myLifeRankerRate <= 40 then
			lifeGrade = "B"
		elseif 40 < myLifeRankerRate and myLifeRankerRate <= 60 then
			lifeGrade = "C"
		elseif 60 < myLifeRankerRate and myLifeRankerRate <= 80 then
			lifeGrade = "D"
		elseif 80 < myLifeRankerRate and myLifeRankerRate <= 100 then
			lifeGrade = "E"
		end
		myLifeRankGroup = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_LIFERANKING_GRADETYPE", "lifeType", lifeType, "lifeGrade", tostring(lifeGrade) )
		LifeRanking._inMyRankRate:SetShow( true )
	end

	LifeRanking._myRanking		:SetText( myLifeRankGroup )
	LifeRanking._inMyRankRate	:SetControlPos( myLifeRankerRate )

	-- UIScroll.SetButtonSize			( LifeRanking._scroll, LifeRanking._createListCount, LifeRanking._listCount )
end

-- function LifeRanking_ScrollEvent( isScrollUp )	-- 스크롤 추가시 사용
	-- local LifeRanking = LifeRanking
	-- LifeRanking._startIndex	= UIScroll.ScrollEvent( LifeRanking._scroll, isScrollUp, LifeRanking._createListCount, LifeRanking._listCount, LifeRanking._startIndex, 1 )
	-- LifeRanking:Update()
-- end

function FromClient_ShowLifeRank()
	audioPostEvent_SystemUi(01,00)
	Panel_LifeRanking:SetShow( true, true )

	LifeRanking:Update()
end

function FromClient_ShowContentsRank( contentsRankType )
	if nil == contentsRankType then
		return
	end
	FromClient_ShowLifeRank()
end

function LifeRanking_SelectTab( idx )
	for listIdx = 0, LifeRanking._createListCount - 1 do	-- 리스트 초기화.
		local list = LifeRanking._listPool[listIdx]
		list.rank		:SetShow( false )
		list.name		:SetShow( false )
		list.guild		:SetShow( false )
		list.grade		:SetShow( false )
	end
	LifeRanking._startIndex = 0
	LifeRanking._selectedTabIdx = idx
	
	if idx <= 8 then	-- 채집, 가공, 요리, 조련, 연금, 낚시, 수렵, 무역, 재배
		ToClient_RequestLifeRanker( idx )
	elseif 9 == idx then	-- 재화
		ToClient_RequestContentsRank( 1 )
	elseif 10 == idx then	-- 성장
		ToClient_RequestContentsRank( 0 )
	elseif 11 == idx then	-- 결투장
		ToClient_RequestMatchRanker( 0 )
	elseif 12 == idx then	-- 국지전
		ToClient_RequestContentsRank( 2 )
	end

	-- LifeRanking._scroll:SetControlTop()
	-- UIScroll.SetButtonSize			( LifeRanking._scroll, LifeRanking._createListCount, 0 )
end

function FGlobal_LifeRanking_Open()
	if Panel_LifeRanking:GetShow() then
		Panel_LifeRanking:SetShow( false, false )
	end

	for idx, value in pairs(LifeRanking._tab) do
		LifeRanking._tab[idx]:SetCheck( false )
	end

	local setShowCount = 0
	-- for _, index in pairs(rankingTabId) do
	for index=0, 12 do
		if FGlobal_LifeRanking_CheckEnAble( index ) then
			LifeRanking._tab[index]:SetShow(true)
			LifeRanking._tab[index]:SetSpanSize(35+(35*setShowCount)+5, 60)
			setShowCount = setShowCount + 1
		else
			LifeRanking._tab[index]:SetShow(false)
		end
	end

	LifeRanking._selectedTabIdx = 0
	LifeRanking._tab[0]:SetCheck( true )

	ToClient_RequestLifeRanker( LifeRanking._selectedTabIdx )
end

function FGlobal_LifeRanking_Close()
	Panel_LifeRanking:SetShow( false, false )
end

function LifeRanking_RankerWhisper( rankIdx )
	local lifeRanker = nil
	
	if LifeRanking._selectedTabIdx <= 8 then	-- 채집, 가공, 요리, 조련, 연금, 낚시, 수렵, 무역, 재배
		lifeRanker	= ToClient_GetLifeRankerAt( rankIdx )
	elseif (10 == LifeRanking._selectedTabIdx) then	-- 재화, 성장
		lifeRanker	= ToClient_GetBattleRankAt( rankIdx )
	elseif (9 == LifeRanking._selectedTabIdx)  then
		lifeRanker = ToClient_GetMoneyRankAt( rankIdx )
	elseif (12 == LifeRanking._selectedTabIdx) then
		lifeRanker = ToClient_GetLocalWarRankAt( rankIdx )
	elseif 11 == LifeRanking._selectedTabIdx then
		lifeRanker	= ToClient_GetMatchRankerAt( 0, listIdx )
	end
	
	local lifeRankerCharName = lifeRanker:getCharacterName()
	
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
	FGlobal_ChattingInput_ShowWhisper( lifeRankerCharName )
end

function LifeRanking_Simpletooltips( isShow, contolNo )
	local control, name = nil, nil
	if isShow == true then
		contol	= LifeRanking._tab[contolNo]
		name	= LifeRanking._tabName[contolNo]
		registTooltipControl(contol, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( contol, name, nil )
	else
		TooltipSimple_Hide()
	end
end

function LifeRanking_Repos()
	local screenSizeX = getScreenSizeX()
	local screenSizeY = getScreenSizeY()
	Panel_LifeRanking:SetPosX( (screenSizeX - Panel_LifeRanking:GetSizeX()) / 2 )
	Panel_LifeRanking:SetPosY( (screenSizeY - Panel_LifeRanking:GetSizeY()) / 2 )
end

function LifeRanking_registEventHandler()
	LifeRanking._btnClose	:addInputEvent("Mouse_LUp", "FGlobal_LifeRanking_Close()")
	
	----- 도움말이 없으므로 임시 감추기 ----------------
	-- LifeRanking._btnHelp	:SetShow(false)
	----------------------------------------------------
	
	for idx, value in pairs(LifeRanking._tab) do
		LifeRanking._tab[idx]:addInputEvent("Mouse_LUp", "LifeRanking_SelectTab( " .. idx .. " )")
		LifeRanking._tab[idx]:addInputEvent("Mouse_On", "LifeRanking_Simpletooltips( true, " .. idx .. " )")
		LifeRanking._tab[idx]:setTooltipEventRegistFunc( "LifeRanking_Simpletooltips( true, " .. idx .. ")")
		LifeRanking._tab[idx]:addInputEvent("Mouse_Out", "LifeRanking_Simpletooltips( false )")
	end

	-- LifeRanking._listBg	:addInputEvent(	"Mouse_UpScroll",	"LifeRanking_ScrollEvent( true )"	)
	-- LifeRanking._listBg	:addInputEvent(	"Mouse_DownScroll",	"LifeRanking_ScrollEvent( false )"	)
	-- UIScroll.InputEvent( LifeRanking._scroll,	"LifeRanking_ScrollEvent" )
end  

function FromClient_ResponseMatchRank_()
	-- 채널 제한이 필요해지면 주석을 풀면 됨! 랭킹은 일단 모든 채널에서 보이게 함! 2015-06-30 문종
	-- local isMainChannel		= getCurrentChannelServerData()._isMain
	-- local isDevServer		= ToClient_IsDevelopment()
	-- if isMainChannel or isDevServer then
		LifeRanking:Update()
	-- else
		-- Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_RALLYRANKING_MSG_ONLYMAINCHANNEL") )	-- "1채널에서만 대회 순위 확인이 가능합니다."
		-- return
	-- end
end

function FGlobal_LifeRanking_CheckEnAble( rankType )
	local self = rankingTabId
	local returnValue = true

	if self.tab_Hunting == rankType then
		if ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 28 ) then		-- 수렵
			returnValue = true
		else
			returnValue = false
		end
	elseif self.tab_Rally == rankType then
		if ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 38 ) then		-- 결투장
			returnValue = true
		else
			returnValue = false
		end
	elseif self.tab_LocalWar == rankType then
		if ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 43 ) then		-- 붉은 전장
			returnValue = true
		else
			returnValue = false
		end
	end

	return returnValue
end

function FGlobal_LifeRanking_Show( index )
	local rankType
	if 0 == index then
		rankType = 12
	elseif 1 == index then
		rankType = 11
	end
	
	if nil ~= rankType then
		FGlobal_LifeRanking_Open()
		LifeRanking_SelectTab( rankType )
		for idx, value in pairs(LifeRanking._tab) do
			LifeRanking._tab[idx]:SetCheck( false )
		end
		LifeRanking._tab[rankType]:SetCheck( true )
	end
end

function LifeRanking_registMessageHandler()
	registerEvent("onScreenResize", 				"LifeRanking_Repos" )
	registerEvent("FromClient_ShowLifeRank",		"FromClient_ShowLifeRank")
	registerEvent("FromClient_ShowContentsRank",	"FromClient_ShowContentsRank")
	registerEvent("FromClient_ResponseMatchRank",	"FromClient_ResponseMatchRank_")
end

local lifeRanking_TooltipHide = function()
	local self = tooltip
	self._bg:SetShow( false )
	self._name:SetShow( false )
	self._desc:SetShow( false )
end

local lifeRanking_TooltipShow = function( uiControl, name, desc, index )
	lifeRanking_TooltipHide()
	
	local self = tooltip
	self._bg:SetShow( true )
	self._name:SetShow( true )
	self._desc:SetShow( true )
	
	self._name:SetText( name .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_RECRUITMENT_PLAYERINTRO") )
	
	local nameLength = math.max( 150, self._name:GetTextSizeX())
	self._desc:SetSize( nameLength, self._desc:GetTextSizeY() )
	self._desc:SetText( desc )
	self._bg:SetSize( nameLength + 10, self._name:GetSizeY() + self._desc:GetTextSizeY() + 15 )

	local posX = 0
	local posY = 0

	if 3 <= index then
		posX = uiControl.name:GetPosX()
		posY = uiControl.name:GetPosY()
	else
		posX = uiControl:GetPosX()
		posY = uiControl:GetPosY()
	end
	
	self._bg:SetPosX( posX + 20 )
	self._bg:SetPosY( posY + 25 )
	self._name:SetPosX( self._bg:GetPosX() + 5 )
	self._name:SetPosY( self._bg:GetPosY() + 5 )
	self._desc:SetPosX( self._name:GetPosX() )
	self._desc:SetPosY( self._name:GetPosY() + self._name:GetSizeY() )
end

function LifeRanking_Tooltip( index )
	if nil == index then
		lifeRanking_TooltipHide()
		return
	end

	local name = rankerData[index]._name
	local desc = rankerData[index]._desc
	
	local uiControl = nil
	if 0 == index then
		uiControl = LifeRanking.firstRankerName
	elseif 1 == index then
		uiControl = LifeRanking.secondRankerName
	elseif 2 == index then
		uiControl = LifeRanking.thirdRankerName	
	else
		uiControl = LifeRanking._listPool[index]
	end
	if nil == desc or "" == desc then
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_RECRUITMENT_PLAYERINTRO_NODATA") -- 자기 소개가 등록되지 않았습니다.
	end
	
	lifeRanking_TooltipShow( uiControl, name, desc, index )
end

LifeRanking_Initionalize()
LifeRanking_registEventHandler()
LifeRanking_registMessageHandler()






-- 이벤트 랭크창을 여시오
-- FromClient_ShowLifeRank 
-- FromClient_ShowContentsRank( int type )
 -- - type: 0(성장), 1(재화)

-- ToClient_RequestLifeRanker(int lifeType)
 -- - 랭킹 리스트 요청
 -- - 인자(생활 레벨 타입)

-- ToClient_RequestContentsRank( int type )
 -- - 성장/재화 랭킹 리스트 요청
 -- - 인자(0: 성장, 1: 재화)

-- int32 			ToClient_GetLifeRankerCount( )
-- int32                  ToClient_GetContentsRankCount( int type )

-- LifeRanker		ToClient_GetLifeRankerAt(int index)
-- BattleRankValue  ToClient_GetBattleRankAt(int index)
-- MoneyRankValue ToClient_GetMoneyRankAt(int index)


-- LifeRanker
 -- - getUserName
 -- - getCharacterName
 -- - getLevel

-- BattleRankValue
 -- - getUserName
 -- - getCharacterName
 -- - getLevel
 -- - getExperience_s64
 -- - getGuildName
 -- - isGuildMember

-- MoneyRankValue
 -- - getUserName
 -- - getCharacterName
 -- - getLevel
 -- - getExperience_s64
 -- - getGuildName
 -- - isGuildMember
 -- - getMoneyCount_s64

-- int 			ToClient_GetLifeMyRank()			내랭킹
-- int			ToClient_GetContentsMyRank(int type)

-- int			ToClient_GetLifeRankerUserCount()	유저수(라이브 서버 동접자수가 확인가능한 부분이니 절대 그냥 쓰지말고 %로 계산해서 사용할 것)
-- int			ToClient_GetContentsRankUserCount(int type)