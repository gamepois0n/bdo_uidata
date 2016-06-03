Panel_MatchResult:SetShow(false)
Panel_MatchResult:SetDragEnable(false)
Panel_MatchResult:ActiveMouseEventEffect(true)
Panel_MatchResult:setGlassBackground(true)

local isContentsEnablePvp = ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 38 )
local isContentsEnableRace = ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 41 )

local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color

local returnTime 			= 0
local partyMemberCount		= nil
local isLeader				= nil
local registerState			= nil
-- local isMainChannel			= nil
-- local isDevServer			= nil
local matchType				= 0		-- 0:pvp

local regionInfo			= getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
local regionName			= regionInfo:getAreaName()
-- local regionKeyRaw			= getSelfPlayer():getRegionKeyRaw()

-- local raceResult = {}		-- 말경주 순위 저장 배열


----- 현재 채널 정보를 얻어옴 (3:3 PvP가 메인채널인 1채널 및 개발서버에서만 가능하도록) ----------------
-- if isContentsEnable then
-- 	isMainChannel			= getCurrentChannelServerData()._isMain
-- 	isDevServer				= ToClient_IsDevelopment()
-- end	
--------------------------------------------------------------------------------------------------------


local matchInfo =	-- 전투정보 컨트롤 선언
{
	_Button_Info			= UI.getChildControl( Panel_Party, "Match_Button_MatchInfo" ),
	_Button_Combat			= UI.getChildControl( Panel_Party, "Match_Button_Combat" ),
	_BG						= UI.getChildControl( Panel_Party, "Match_BG" ),
	_Party_Icon				= UI.getChildControl( Panel_Party, "Match_Party_Icon" ),
	_Party_Text				= UI.getChildControl( Panel_Party, "Match_Party_Text" ),
	_Party_Value			= UI.getChildControl( Panel_Party, "Match_Party_Value" ),
	_Time_Icon				= UI.getChildControl( Panel_Party, "Match_Time_Icon" ),
	_RemainTime_Text		= UI.getChildControl( Panel_Party, "Match_RemainTime_Text" ),
	_RemainTime_Value		= UI.getChildControl( Panel_Party, "Match_RemainTime_Value" ),
	_State_BG				= UI.getChildControl( Panel_Party, "Match_State_BG" ),
	_State					= UI.getChildControl( Panel_Party, "Match_State" ),
	_RegStatus_Text			= UI.getChildControl( Panel_Party, "Match_RegStatus_Text" ),
	
	config =	-- 전투정보창 위치값
	{
		sizeX			= 170,
		sizeY			= 75,
		bgX				= 3,
		stateBGminiX	= 1,
		stateBGminiY	= 0,
		stateminiX		= 1,
		stateminiY		= 6,
	},
}


local matchResult =	-- 결투결과창 컨트롤 선언
{
	_Button_Close			= UI.getChildControl( Panel_MatchResult, "Button_Close" ),
	_Ace					= UI.getChildControl( Panel_MatchResult, "Icon_Ace" ),
	_Title					= UI.getChildControl( Panel_MatchResult, "Text_Title" ),
	_Result_Title_Back_Win	= UI.getChildControl( Panel_MatchResult, "Result_Title_Back_Win" ),
	_Result_Title_Back_Lose	= UI.getChildControl( Panel_MatchResult, "Result_Title_Back_Lose" ),
	_Line_Top_Win			= UI.getChildControl( Panel_MatchResult, "Line_Top_Win" ),
	_Line_Bottom_Win		= UI.getChildControl( Panel_MatchResult, "Line_Bottom_Win" ),
	_Line_Top_Lose			= UI.getChildControl( Panel_MatchResult, "Line_Top_Lose" ),
	_Line_Bottom_Lose		= UI.getChildControl( Panel_MatchResult, "Line_Bottom_Lose" ),
	_Back_Actor				= UI.getChildControl( Panel_MatchResult, "Back_Actor" ),
	_TotalPoint_Ali			= UI.getChildControl( Panel_MatchResult, "TotalPoint_Ali" ),
	_TotalPoint_Ene			= UI.getChildControl( Panel_MatchResult, "TotalPoint_Ene" ),
	_EndInfo_Sec			= UI.getChildControl( Panel_MatchResult, "Text_EndInfo_Sec" ),

	_Icon_Class =	-- 0~2 아군 슬롯, 3~5 적군 슬롯	
	{
		[0] = UI.getChildControl( Panel_MatchResult, "Icon_Class_Ali_1" ),
		[1] = UI.getChildControl( Panel_MatchResult, "Icon_Class_Ali_2" ),
		[2] = UI.getChildControl( Panel_MatchResult, "Icon_Class_Ali_3" ),
		[3] = UI.getChildControl( Panel_MatchResult, "Icon_Class_Ene_1" ),
		[4] = UI.getChildControl( Panel_MatchResult, "Icon_Class_Ene_2" ),
		[5] = UI.getChildControl( Panel_MatchResult, "Icon_Class_Ene_3" ),
	},
	
	_Name =
	{
		[0] = UI.getChildControl( Panel_MatchResult, "Text_Ali_Name_1" ),
		[1] = UI.getChildControl( Panel_MatchResult, "Text_Ali_Name_2" ),
		[2] = UI.getChildControl( Panel_MatchResult, "Text_Ali_Name_3" ),
		[3] = UI.getChildControl( Panel_MatchResult, "Text_Ene_Name_1" ),
		[4] = UI.getChildControl( Panel_MatchResult, "Text_Ene_Name_2" ),
		[5] = UI.getChildControl( Panel_MatchResult, "Text_Ene_Name_3" ),
	},
	
	_Kill =
	{
		[0] = UI.getChildControl( Panel_MatchResult, "Text_Ali_Kill_1" ),
		[1] = UI.getChildControl( Panel_MatchResult, "Text_Ali_Kill_2" ),
		[2] = UI.getChildControl( Panel_MatchResult, "Text_Ali_Kill_3" ),
		[3] = UI.getChildControl( Panel_MatchResult, "Text_Ene_Kill_1" ),
		[4] = UI.getChildControl( Panel_MatchResult, "Text_Ene_Kill_2" ),
		[5] = UI.getChildControl( Panel_MatchResult, "Text_Ene_Kill_3" ),
	},
	
	_Point =
	{
		[0] = UI.getChildControl( Panel_MatchResult, "Text_Ali_Point_1" ),
		[1] = UI.getChildControl( Panel_MatchResult, "Text_Ali_Point_2" ),
		[2] = UI.getChildControl( Panel_MatchResult, "Text_Ali_Point_3" ),
		[3] = UI.getChildControl( Panel_MatchResult, "Text_Ene_Point_1" ),
		[4] = UI.getChildControl( Panel_MatchResult, "Text_Ene_Point_2" ),
		[5] = UI.getChildControl( Panel_MatchResult, "Text_Ene_Point_3" ),
	},
	_Icon_Kill =
	{
		[0] = UI.getChildControl( Panel_MatchResult, "Icon_Kill_Ali_1" ),
		[1] = UI.getChildControl( Panel_MatchResult, "Icon_Kill_Ali_2" ),
		[2] = UI.getChildControl( Panel_MatchResult, "Icon_Kill_Ali_3" ),
		[3] = UI.getChildControl( Panel_MatchResult, "Icon_Kill_Ene_1" ),
		[4] = UI.getChildControl( Panel_MatchResult, "Icon_Kill_Ene_2" ),
		[5] = UI.getChildControl( Panel_MatchResult, "Icon_Kill_Ene_3" ),
	},
	_Icon_Point	=
	{
		[0] = UI.getChildControl( Panel_MatchResult, "Icon_Point_Ali_1" ),
		[1] = UI.getChildControl( Panel_MatchResult, "Icon_Point_Ali_2" ),
		[2] = UI.getChildControl( Panel_MatchResult, "Icon_Point_Ali_3" ),
		[3] = UI.getChildControl( Panel_MatchResult, "Icon_Point_Ene_1" ),
		[4] = UI.getChildControl( Panel_MatchResult, "Icon_Point_Ene_2" ),
		[5] = UI.getChildControl( Panel_MatchResult, "Icon_Point_Ene_3" ),
	},
	_acePosX =
	{
		[0] = 145,
		[1] = 145,
		[2] = 145,
		[3] = 438,
		[4] = 438,
		[5] = 438,
	},
	_acePosY =
	{
		[0] = 132,
		[1] = 185,
		[2] = 238,
		[3] = 132,
		[4] = 185,
		[5] = 238,
	},
	_selfBackPosX = 16,
	_selfBackPosY =
	{
		[0]		= 143,
		[1]		= 196,
		[2]		= 249,
		[3]		= 143,
		[4]		= 196,
		[5]		= 249,
	},
}

function matchInfo:init( isEnableChannel )										-- 초기화 (1채널이거나 개발자 서버가 아닐경우 버튼 텍스트 회색처리)
	matchInfo:setPosition()		-- 위치 잡기
	Party_MatchClose()	-- 정보창 닫기
	
	-- 결투정보 버튼 초기화
	matchInfo._Button_Info:SetEnable( true )
	matchInfo._Button_Info:SetIgnore( false )
	matchInfo._Button_Info:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_BUTTON_INFO"))	-- "결투정보"
	
	-- 1채널이 아닌경우 버튼 색상 변경 (false = 이용불가 채널)
	if (nil == isEnableChannel) or (true == isEnableChannel) then
		matchInfo._Button_Info:SetFontColor( UI_color.C_FFE7E7E7 )
		matchInfo._Button_Info:SetOverFontColor( UI_color.C_FFE7E7E7 )
		matchInfo._Button_Info:SetMonoTone( false )
	elseif (false == isEnableChannel) then
		matchInfo._Button_Info:SetFontColor( UI_color.C_FFC4BEBE )
		matchInfo._Button_Info:SetOverFontColor( UI_color.C_FFC4BEBE )
		matchInfo._Button_Info:SetMonoTone( true )
	end
	Panel_RecentMemory:SetShow( false )	-- 결투 시작전 이전기억창 닫아주기
end

function matchInfo:setPosition()												-- 결투정보창 위치잡기
	local backBGY = matchInfo._Button_Info:GetPosY() + 30	-- 파티원 인원수에 따라 가변
	matchInfo._BG				:SetSize(matchInfo.config.sizeX, matchInfo.config.sizeY)	-- 170, 75
	matchInfo._BG				:SetPosX(matchInfo.config.bgX)	-- 3
	matchInfo._BG				:SetPosY(backBGY)
	matchInfo._Party_Icon		:SetPosX(matchInfo.config.bgX + 6)
	matchInfo._Party_Icon		:SetPosY(backBGY + 4)
	matchInfo._Party_Text		:SetPosX(matchInfo.config.bgX + 31)
	matchInfo._Party_Text		:SetPosY(backBGY + 6)
	matchInfo._Time_Icon		:SetPosX(matchInfo.config.bgX + 4)
	matchInfo._Time_Icon		:SetPosY(backBGY + 25)
	matchInfo._RemainTime_Text	:SetPosX(matchInfo.config.bgX + 31)
	matchInfo._RemainTime_Text	:SetPosY(backBGY + 26)
	matchInfo._Party_Value		:SetPosX(matchInfo.config.bgX + 112)
	matchInfo._Party_Value		:SetPosY(backBGY + 6)
	matchInfo._RemainTime_Value	:SetPosX(matchInfo.config.bgX + 112)
	matchInfo._RemainTime_Value	:SetPosY(backBGY + 26)
	matchInfo._Button_Combat	:SetPosX(matchInfo.config.bgX + 109)
	matchInfo._Button_Combat	:SetPosY(backBGY + 47)
	
	if isLeader then
		matchInfo._RegStatus_Text	:SetPosX(matchInfo.config.bgX + 10)
		matchInfo._RegStatus_Text	:SetPosY(backBGY + 49)
	else
		matchInfo._RegStatus_Text	:SetPosX(matchInfo.config.bgX + 82)
		matchInfo._RegStatus_Text	:SetPosY(backBGY + 48)
	end
end

function FromClient_UpdateMatchInfo( matchType, matchState )					-- 결투 상태 메세지
	---- 0 대기상태, 1 등록하세요, 2 경기장으로 이동됩니다, 3 전투가 시작됩니다, 4 결과, 5 종료, -2 상대팀 매칭 실패
	local messages = { main = "", sub="", addMsg ="" }
	if CppEnums.MatchType.Pvp == matchType then
		if (0 == matchState) then
			matchInfo:updateRegisterState()	-- 결투 대기 신청 확인
		elseif (-2 == matchState) then
			messages = { main = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_NAK_NOTEAM"), sub="", addMsg ="" }	-- 상대팀을 찾을 수 없어 결투가 지연되었습니다.
			matchInfo._Button_Info	:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_BUTTON_INFO"))	-- "결투정보"
			matchInfo._Button_Info	:SetEnable( true )
			matchInfo._Button_Info	:SetIgnore( false )
			matchInfo._Button_Info	:SetFontColor( UI_color.C_FFE7E7E7 )
			HandleClicked_MatchClose()
			matchInfo:updateRegisterState()	-- 결투 대기 신청 확인
		elseif (1 == matchState) then
			matchInfo._State		:SetFontColor( UI_color.C_FFE7E7E7 )
			matchInfo._Button_Info	:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_BUTTON_INFO"))	-- "결투정보"
			matchInfo._Button_Info	:SetEnable( true )
			matchInfo._Button_Info	:SetIgnore( false )
			matchInfo._Button_Info	:SetFontColor( UI_color.C_FFE7E7E7 )
		elseif (2 == matchState) then
			messages = { main = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_NAK_WAITWARP"), sub="", addMsg ="" }	-- "1분 후 결투장으로 이동됩니다."
			matchInfo._State		:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_WAITWARP"))	-- "결투장 이동 대기 중..."
			matchInfo._State		:SetFontColor( UI_color.C_FF84FFF5 )
			matchInfo._State		:SetEnable( false )
			-- matchInfo._Button_Info	:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_BUTTON_WAITWARP"))	-- "이동대기"
			-- matchInfo._Button_Info	:SetEnable( false )
			-- matchInfo._Button_Info	:SetIgnore( true )
			-- matchInfo._Button_Info	:SetFontColor( UI_color.C_FF84FFF5 )
			HandleClicked_MatchOpen( true )
		elseif (3 == matchState) then
			messages = { main = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_NAK_WAITFIGHT"), sub="", addMsg ="" }	-- "잠시 후 결투가 시작됩니다."
			matchInfo._State		:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_WAITFIGHT"))	-- "결투 대기 중..."
			matchInfo._State		:SetFontColor( UI_color.C_FFFF973A )
			matchInfo._State		:SetEnable( false )
			matchInfo._Button_Info	:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_BUTTON_WAITFIGHT"))	-- "결투대기"
			matchInfo._Button_Info	:SetEnable( false )
			matchInfo._Button_Info	:SetIgnore( true )
			matchInfo._Button_Info	:SetFontColor( UI_color.C_FFFF973A )
			HandleClicked_MatchOpen( true )
			Panel_RecentMemory:SetShow( false )	-- 결투 시작전 이전기억창 닫아주기
		elseif (4 == matchState) then
			messages = { main = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_NAK_STARTFIGHT"), sub="", addMsg ="" }	-- "결투가 시작되었습니다."
			matchInfo._State		:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_STARTFIGHT"))	-- "결투 진행 중..."
			matchInfo._State		:SetFontColor( UI_color.C_FFFF4B4B )
			matchInfo._State		:SetEnable( false )
			matchInfo._Button_Info	:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_BUTTON_STARTFIGHT"))	-- "결투시작"
			matchInfo._Button_Info	:SetEnable( false )
			matchInfo._Button_Info	:SetIgnore( true )
			matchInfo._Button_Info	:SetFontColor( UI_color.C_FFFF4B4B )
			HandleClicked_MatchOpen( true )
			Panel_RecentMemory:SetShow( false )	-- 결투 시작전 이전기억창 닫아주기
		elseif (5 == matchState) then
		end
		Proc_ShowMessage_Ack_For_RewardSelect( messages, 10, 31 )

	elseif CppEnums.MatchType.Race == matchType then
		local messages = { main = "", sub="", addMsg ="" }
		-- if 0 == matchState then
		-- 	messages = { main="경주 대기 상태입니다.", sub="", addMsg="" }
		-- 	Proc_ShowMessage_Ack_For_RewardSelect( messages, 10, 41 )
		-- elseif 1 == matchState then
		-- 	messages = { main="경주 등록하세요.", sub="", addMsg="" }
		-- 	Proc_ShowMessage_Ack_For_RewardSelect( messages, 10, 39 )
		if 2 == matchState then
			messages = { main=PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHINFO_RACESTARTWAITING"), sub="", addMsg="" }
			Proc_ShowMessage_Ack_For_RewardSelect( messages, 10, 41 )
		elseif 3 == matchState then
			messages = { main=PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHINFO_RACEREADY"), sub=PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHINFO_WAITING"), addMsg="" }
			Proc_ShowMessage_Ack_For_RewardSelect( messages, 10, 39 )
	-- 	elseif 4 == matchState then
	-- 		Proc_ShowMessage_Ack( "경주 시작!" )
	-- 		_PA_LOG("말경주", "경주 시작! 이 때부터 카운트 해주자!")
	-- 	elseif 5 == matchState then
	-- 		Proc_ShowMessage_Ack( "경주가 종료됐습니다." )
	-- 		_PA_LOG("말경주", "경주가 종료됐습니다.")
	-- 	elseif -2 == matchState then
	-- 		Proc_ShowMessage_Ack( "경주 매칭에 실패했습니다." )
	-- 		_PA_LOG("말경주", "경주 매칭에 실패했습니다.")
	-- 	else
	-- 		Proc_ShowMessage_Ack( "알 수 없는 메시지(말경주)" )
	-- 		_PA_LOG("말경주", "알 수 없는 메시지(말경주)")
		end
	end
end

function FromClient_MatchPvpResult( isWin )
	local messages = { main = "", sub="", addMsg ="" }
	
	if (isWin) then	-- 승리시
		messages = { main = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHRESULT_NAK_WIN"), sub="", addMsg ="" }	-- "결투에서 승리 했습니다."
		matchResult._Title		:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHRESULT_TITLE_WIN"))	-- "승리"
		matchResult._Title		:SetFontColor( UI_color.C_FFE7E7E7 )
		matchInfo._Button_Info	:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_WIN"))	-- "결투승리"
		matchInfo._Button_Info	:SetFontColor( UI_color.C_FF84FFF5 )
		matchInfo._State		:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_WIN"))	-- "결투승리"
		matchInfo._State		:SetFontColor( UI_color.C_FF84FFF5 )
	else			-- 패배시
		messages = { main = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHRESULT_NAK_LOOSE"), sub="", addMsg ="" }	-- "결투에서 패배 했습니다."
		matchResult._Title		:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHRESULT_TITLE_LOOSE"))	-- "패배"
		matchResult._Title		:SetFontColor( UI_color.C_FFFF4B4B )
		matchInfo._Button_Info	:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_LOOSE"))	-- "결투패배"
		matchInfo._Button_Info	:SetFontColor( UI_color.C_FFFF4B4B )
		matchInfo._State		:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_LOOSE"))	-- "결투패배"
		matchInfo._State		:SetFontColor( UI_color.C_FFFF4B4B )
	end	
	Proc_ShowMessage_Ack_For_RewardSelect( messages, 10, 31 )
	
	-- matchInfo._Button_Info		:SetEnable( false )
	-- matchInfo._Button_Info		:SetIgnore( true )
	HandleClicked_MatchOpen( true )
	
	matchResult._Result_Title_Back_Win		:SetShow(false)
	matchResult._Result_Title_Back_Lose		:SetShow(false)
	matchResult._Line_Top_Win				:SetShow(false)
	matchResult._Line_Bottom_Win			:SetShow(false)
	matchResult._Line_Top_Lose				:SetShow(false)
	matchResult._Line_Bottom_Lose			:SetShow(false)
	
	---- 결투결과
	local selfPlayerName	= getSelfPlayer():getName()
	local resultCount		= ToClient_PvPMatchResultCount()
	
	local totalPointAli		= 0
	local totalPointEne		= 0

	for countidx = 0, resultCount-1 do
		local tempcountidx		= countidx
		local pvpResultInfo		= ToClient_PvPMatchResultAt(tempcountidx)
		local resultEmpty		= pvpResultInfo:isEmpty()
		local resultName		= pvpResultInfo:getName()
		local resultKillCount	= pvpResultInfo:getKillCount()
		local resultVariedPoint	= pvpResultInfo:getVariedPoint()
		local resultTotalPoint	= pvpResultInfo:getTotalPoint()
		-- local resultisWin		= pvpResultInfo:isWin()
		
		if not resultEmpty then
			if isWin then	-- 아군 idx가 항상 0~2 이도록 변경
				if 0 == countidx then
					tempcountidx = 3
				elseif 1 == countidx then
					tempcountidx = 4
				elseif 2 == countidx then
					tempcountidx = 5
				elseif 3 == countidx then
					tempcountidx = 0
				elseif 4 == countidx then
					tempcountidx = 1
				elseif 5 == countidx then
					tempcountidx = 2
				end
			end
			
			-- if isWin and (resultName == selfPlayerName) then
				-- matchResult._Back_Actor:SetPosX(matchResult._selfBackPosX)
				-- matchResult._Back_Actor:SetPosY(matchResult._selfBackPosY[tempcountidx])
				-- matchResult._Back_Actor:SetShow( true )
			-- elseif not isWin and (resultName == selfPlayerName) then
				-- matchResult._Back_Actor:SetPosX(matchResult._selfBackPosX)
				-- matchResult._Back_Actor:SetPosY(matchResult._selfBackPosY[countidx])
				-- matchResult._Back_Actor:SetShow( true )
			-- else
				-- matchResult._Back_Actor:SetShow( false )
			-- end
		
			if 2 >= tempcountidx then	-- 아군 및 적군의 종합 점수
				totalPointAli = totalPointAli + resultVariedPoint
			elseif 3 <= tempcountidx then
				totalPointEne = totalPointEne + resultVariedPoint
			end

			-- if acePoint.point < resultVariedPoint then
				-- acePoint.idx	= tempcountidx
				-- acePoint.point	= resultVariedPoint
			-- elseif acePoint.point == resultVariedPoint then
				-- acePoint.idx	= nil
			-- end
			
			matchResult._Name[tempcountidx]			:SetText(resultName)
			matchResult._Kill[tempcountidx]			:SetText(tostring(resultKillCount))
			matchResult._Point[tempcountidx]		:SetText("+" .. tostring(resultVariedPoint) .. " (" .. tostring(resultTotalPoint) .. ")")
			
			matchResult._Name[tempcountidx]			:SetShow( false )
			matchResult._Kill[tempcountidx]			:SetShow( false )
			matchResult._Point[tempcountidx]		:SetShow( false )
			matchResult._Icon_Kill[tempcountidx]	:SetShow( false )
			matchResult._Icon_Point[tempcountidx]	:SetShow( false )
			matchResult._Icon_Class[tempcountidx]	:SetShow( false )
		else
			matchResult._Name[tempcountidx]			:SetShow( false )
			matchResult._Kill[tempcountidx]			:SetShow( false )
			matchResult._Point[tempcountidx]		:SetShow( false )
			matchResult._Icon_Kill[tempcountidx]	:SetShow( false )
			matchResult._Icon_Point[tempcountidx]	:SetShow( false )
			matchResult._Icon_Class[tempcountidx]	:SetShow( false )
		end
	end

	matchResult._TotalPoint_Ali		:SetText(tostring(totalPointAli))
	matchResult._TotalPoint_Ene		:SetText(tostring(totalPointEne))
	
	-- if nil ~= acePoint.idx then
		-- matchResult._Ace:SetPosX(matchResult._acePosX[acePoint.idx])
		-- matchResult._Ace:SetPosY(matchResult._acePosY[acePoint.idx])
		-- matchResult._Ace:SetShow( true )
	-- else
		-- matchResult._Ace:SetShow( false )
	-- end
	
	Panel_MatchResult:SetShow( false )
end

-------------------	정환씨 코드	---------------------------------------------------------------------------------------------------------------------------------------
-- local setResult = function( index, pvpResultInfo )	-- 결투결과창 결과 표시
	-- local isEmpty = pvpResultInfo:isEmpty()
	-- if false == isEmpty then
		-- matchResult._Name[index]		:SetText( pvpResultInfo:getName() )
		-- matchResult._Kill[index]		:SetText( tostring(pvpResultInfo:getKillCount()) )
		-- matchResult._Point[index]		:SetText( "+" .. tostring(pvpResultInfo:getVariedPoint()) .. " (" .. tostring(pvpResultInfo:getTotalPoint()) .. ")" )
	-- end	
	-- matchResult._Name[index]			:SetShow( false == isEmpty )
	-- matchResult._Kill[index]			:SetShow( false == isEmpty )
	-- matchResult._Point[index]			:SetShow( false == isEmpty )
	-- matchResult._Icon_Kill[index]		:SetShow( false == isEmpty )
	-- matchResult._Icon_Point[index]		:SetShow( false == isEmpty )
	-- matchResult._Icon_Class[index]		:SetShow( false == isEmpty )
-- end

-- local acePlayerPoint = 0
-- function FromClient_MatchPvpResult( isWin )	-- 결투결과 리턴
	-- local messages = { main = "", sub="", addMsg ="" }
	
	-- if (isWin) then	-- 승리시
		-- messages = { main = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHRESULT_NAK_WIN"), sub="", addMsg ="" }	-- "결투에서 승리 했습니다."
		-- matchResult._Title		:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHRESULT_TITLE_WIN"))	-- "승리"
		-- matchResult._Title		:SetFontColor( UI_color.C_FFE7E7E7 )
		-- matchInfo._Button_Info	:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_WIN"))	-- "결투승리"
		-- matchInfo._Button_Info	:SetFontColor( UI_color.C_FF84FFF5 )
		-- matchInfo._State		:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_WIN"))	-- "결투승리"
		-- matchInfo._State		:SetFontColor( UI_color.C_FF84FFF5 )
	-- else			-- 패배시
		-- messages = { main = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHRESULT_NAK_LOOSE"), sub="", addMsg ="" }	-- "결투에서 패배 했습니다."
		-- matchResult._Title		:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHRESULT_TITLE_LOOSE"))	-- "패배"
		-- matchResult._Title		:SetFontColor( UI_color.C_FFFF4B4B )
		-- matchInfo._Button_Info	:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_LOOSE"))	-- "결투패배"
		-- matchInfo._Button_Info	:SetFontColor( UI_color.C_FFFF4B4B )
		-- matchInfo._State		:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MATCHSTATUS_LOOSE"))	-- "결투패배"
		-- matchInfo._State		:SetFontColor( UI_color.C_FFFF4B4B )
	-- end	
	-- matchInfo._Button_Info		:SetEnable( false )
	-- matchInfo._Button_Info		:SetIgnore( true )
	-- HandleClicked_MatchOpen( true )
	
	-- Panel_MatchResult			:SetShow( true )

	-- matchResult._Result_Title_Back_Win		:SetShow(true == isWin)
	-- matchResult._Result_Title_Back_Lose		:SetShow(false == isWin)
	-- matchResult._Line_Top_Win				:SetShow(true == isWin)
	-- matchResult._Line_Bottom_Win			:SetShow(true == isWin)
	-- matchResult._Line_Top_Lose				:SetShow(false == isWin)
	-- matchResult._Line_Bottom_Lose			:SetShow(false == isWin)
	
	-- Proc_ShowMessage_Ack_For_RewardSelect( messages, 10, 31 )
	
	-- 결투결과 ----------------------------------------------------------------
	-- local selfPlayerName	= getSelfPlayer():getName()
	-- local resultCount		= ToClient_PvPMatchResultCount()
	-- local totalPointAli		= 0
	-- local totalPointEne		= 0
	
	-- for index = 0, 2, 1 do
		-- if(isWin) then
			-- local pvpResultInfo = ToClient_PvPMatchResultAt(index+3)
			-- setResult(index, pvpResultInfo)
			-- if(false == pvpResultInfo:isEmpty()) then
				-- totalPointAli = totalPointAli + pvpResultInfo:getVariedPoint()
			-- end
			
			-- pvpResultInfo = ToClient_PvPMatchResultAt(index)
			-- setResult(index+3, pvpResultInfo)
			-- if(false == pvpResultInfo:isEmpty()) then
				-- totalPointEne = totalPointEne + pvpResultInfo:getVariedPoint()
			-- end			
		-- else
			-- local pvpResultInfo = ToClient_PvPMatchResultAt(index)
			-- setResult(index, pvpResultInfo)
			-- if(false == pvpResultInfo:isEmpty()) then
				-- totalPointAli = totalPointAli + pvpResultInfo:getVariedPoint()
			-- end
			
			-- pvpResultInfo = ToClient_PvPMatchResultAt(index+3)
			-- setResult(index+3, pvpResultInfo)
			-- if(false == pvpResultInfo:isEmpty()) then
				-- totalPointEne = totalPointEne + pvpResultInfo:getVariedPoint()
			-- end
		-- end
	-- end
	
	-- matchResult._TotalPoint_Ali		:SetText(tostring(totalPointAli))
	-- matchResult._TotalPoint_Ene		:SetText(tostring(totalPointEne))
-- end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

function HandleClicked_MatchOpen( compactInfo )									-- 결투정보창 열기 (ture = 작은 위젯)
	
	matchInfo:setPosition()
	
	local backBGX = matchInfo.config.bgX
	local backBGY = matchInfo._Button_Info:GetPosY() + 30

	matchInfo._BG						:SetPosX(backBGX)
	matchInfo._BG						:SetPosY(backBGY)
	
	if compactInfo then	-- 미니정보창
		matchInfo._State_BG				:SetPosX(backBGX + matchInfo.config.stateBGminiX)
		matchInfo._State_BG             :SetPosY(backBGY + matchInfo.config.stateBGminiY)
		matchInfo._State				:SetPosX(backBGX + matchInfo.config.stateminiX)
		matchInfo._State                :SetPosY(backBGY + matchInfo.config.stateminiY)
		matchInfo._State_BG				:SetShow( false )
		matchInfo._State				:SetShow( false )
		matchInfo._RegStatus_Text		:SetShow( false )
		matchInfo._BG					:SetShow( false )
		matchInfo._Party_Icon			:SetShow( false )
		matchInfo._Party_Text			:SetShow( false )
		matchInfo._Party_Value			:SetShow( false )
		matchInfo._Time_Icon			:SetShow( false )
		matchInfo._RemainTime_Text		:SetShow( false )
		matchInfo._RemainTime_Value		:SetShow( false )
		matchInfo._Button_Combat		:SetShow( false )
		matchInfo._State_BG				:SetIgnore( false )
	else
		matchInfo._State_BG				:SetShow( false )
		matchInfo._State				:SetShow( false )
		matchInfo._RegStatus_Text		:SetShow( false )
		matchInfo._BG					:SetShow( false )
		matchInfo._Party_Icon			:SetShow( false )
		matchInfo._Party_Text			:SetShow( false )
		matchInfo._Party_Value			:SetShow( false )
		matchInfo._Time_Icon			:SetShow( false )
		matchInfo._RemainTime_Text		:SetShow( false )
		matchInfo._RemainTime_Value		:SetShow( false )
		matchInfo._Button_Combat		:SetShow( false )	-- 파티장일 경우 신청버튼 보이기
		matchInfo._BG					:SetIgnore( false )
	end
	FGlobal_PartyListUpdate()
end

function HandleClicked_MatchClose()												-- 결투정보 위젯 닫기
	matchInfo._BG					:SetShow( false )
	matchInfo._State_BG				:SetShow( false )
	matchInfo._State				:SetShow( false )
	matchInfo._Party_Icon			:SetShow( false )
	matchInfo._Party_Text			:SetShow( false )
	matchInfo._Party_Value			:SetShow( false )
	matchInfo._Time_Icon			:SetShow( false )
	matchInfo._RemainTime_Text		:SetShow( false )
	matchInfo._RemainTime_Value		:SetShow( false )
	matchInfo._RegStatus_Text		:SetShow( false )
	matchInfo._Button_Combat		:SetShow( false )
	FGlobal_PartyListUpdate()
end

function Party_MatchClose()
	matchInfo._BG					:SetShow( false )
	matchInfo._State_BG				:SetShow( false )
	matchInfo._State				:SetShow( false )
	matchInfo._Party_Icon			:SetShow( false )
	matchInfo._Party_Text			:SetShow( false )
	matchInfo._Party_Value			:SetShow( false )
	matchInfo._Time_Icon			:SetShow( false )
	matchInfo._RemainTime_Text		:SetShow( false )
	matchInfo._RemainTime_Value		:SetShow( false )
	matchInfo._RegStatus_Text		:SetShow( false )
	matchInfo._Button_Combat		:SetShow( false )
end

function HandleClicked_MatchResultClose()										-- 결투 결과창 닫기
	Panel_MatchResult:SetShow( false )
end

-- function HandleClicked_RaceResultClose()										-- 결투 결과창 닫기
-- 	Panel_RaceResult:SetShow( false )
-- end

function matchInfo:RequestInfo()												-- 결투정보 요청
	ToClient_RequestMatchInfo( matchType )
	matchInfo:setPosition()
	matchInfo:updateRegisterState()	
end

function HandleClicked_RequestMatchInfoOpen()									-- 결투정보 버튼 클릭시
	-- if (matchInfo._BG:GetShow()) or (matchInfo._State:GetShow()) then
	if matchInfo._BG:GetShow() then
		HandleClicked_MatchClose()
	else
		matchInfo:RequestInfo()	
	end
end

function HandleClicked_RegisterMatch()											-- 결투신청 버큰 클릭시
	if 0 < ToClient_GetMyTeamNoLocalWar() then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_REGISTER_MATCH") )
		return
	end
	
	registerState = ToClient_IsRequestedPvP()
	
	if registerState == false then	-- 신청되었을 경우
		ToClient_RegisterPvPMatch()
	else							-- 신청 안된 경우
		ToClient_UnRequestMatchInfo()
	end
	matchInfo:RequestInfo()	-- 결투정보 요청(리프레쉬용)
end

function matchInfo:updateRegisterState()										-- 결투 대기 신청 확인
	registerState	= ToClient_IsRequestedPvP()
	
	if registerState then	-- 결투 등록
		matchInfo._Button_Combat	:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_BUTTON_COMBAT2"))	-- "신청취소"
		matchInfo._Button_Combat	:SetFontColor( UI_color.C_FFFF4B4B )
		matchInfo._Button_Combat	:SetOverFontColor( UI_color.C_FFFF4B4B )
		matchInfo._Button_Info		:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_BUTTON_INFO2"))	-- "결투대기"
		matchInfo._Button_Info		:SetFontColor( UI_color.C_FFFF4B4B )
		matchInfo._Button_Info      :SetOverFontColor( UI_color.C_FFFF4B4B )
		matchInfo._RegStatus_Text	:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_STATUS_REG2"))	-- "결투 대기중"
		matchInfo._RegStatus_Text	:SetFontColor( UI_color.C_FFFF4B4B )
	else	-- 결투 미등록
		matchInfo._Button_Combat	:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_BUTTON_COMBAT"))	-- "결투신청"
		matchInfo._Button_Combat	:SetFontColor( UI_color.C_FFE7E7E7 )
		matchInfo._Button_Combat	:SetOverFontColor( UI_color.C_FFE7E7E7 )
		matchInfo._Button_Info		:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_BUTTON_INFO"))	-- "결투정보"
		matchInfo._Button_Info		:SetFontColor( UI_color.C_FFE7E7E7 )
		matchInfo._Button_Info      :SetOverFontColor( UI_color.C_FFE7E7E7 )
		matchInfo._RegStatus_Text	:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_STATUS_REG"))	-- "결투 미신청"
		matchInfo._RegStatus_Text	:SetFontColor( UI_color.C_FFC4BEBE )
	end
end

function FromClient_MatchInfo( matchType, isRegister, registerCount, remainedMinute, matchState, param1 )	-- 결투정보 받음

	matchInfo:updateRegisterState()

	if CppEnums.MatchType.Pvp == matchType then			-- pvp 3on3
		if isRegister then
			matchInfo._Party_Value			:SetText( tostring(registerCount) .. PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_PARTY_VALUE") )	-- " 팀"
			matchInfo._RemainTime_Value		:SetText( tostring(remainedMinute) .. PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_REMAINTIME_VALUE") )	-- " 분"
			HandleClicked_MatchOpen()
		else
			matchInfo_ShowMessage_Ack( 1 )	-- "잠시 후 결투정보 확인이 가능합니다."
		end
	elseif CppEnums.MatchType.Race == matchType then	-- 말 경주
		FGlobal_RaceInfo_Open( isRegister, registerCount, remainedMinute, matchState, param1 )
	end
end

function FromClient_PvPRegisterComplete( matchType )							-- 결투 신청 등록 리턴
	if CppEnums.MatchType.Pvp == matchType then
		matchInfo_ShowMessage_Ack( 2 )	-- "결투 대기 신청이 되었습니다."
		matchInfo:updateRegisterState()
		ResponseParty_updatePartyList()	-- 파티옵션 버튼을 즉시 꺼주기 위해 Panel_Party.lua의 파티 업데이트 함수를 한번 호출 해줌 (해당 함수는 자동으로 반복됨)
	elseif CppEnums.MatchType.Race == matchType then
		FGlobal_RaceInfo_MessageManager( 0 )
	end
end

function FromClient_PvPUnRegisterComplete( matchType )							-- 결투 신청 취소 리턴
	if CppEnums.MatchType.Pvp == matchType then
		matchInfo_ShowMessage_Ack( 3 )	-- "결투 대기 신청이 취소되었습니다."
		matchInfo:updateRegisterState()
	elseif CppEnums.MatchType.Race == matchType then
		FGlobal_RaceInfo_MessageManager( 1 )
	end
end

function matchInfoJoinBTSimpletooltips( isShow, contolNo )						-- 결투신청 버튼 심플툴팁
	local name, desc, control = nil, nil, nil
	if isShow == true then
		if 0 == contolNo then
			control = UI.getChildControl( Panel_Party, "Match_Button_MatchInfo" )					-- 결투정보 버튼
			name 	= PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_NAK_PVPMATCH_NAME")	-- "결투장"
			desc	= PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_NAK_PVPMATCH_DESC")	-- "3인 파티 시 결투장으로\n이동되어 다른 파티와\n결투를 진행하게 됩니다."
		elseif 1 == contolNo then
			control = UI.getChildControl( Panel_Party, "Match_Button_Combat" )						-- 결투신청 버튼
			name 	= PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_TOOLTIPS_NAME")		-- "결투 대기 신청"
			desc	= PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_TOOLTIPS_DESC")		-- "신청한 팀이 6팀이 되거나\n2팀 이상일 경우 10분마다\n결투가 진행됩니다."
		elseif 2 == contolNo then
			control = UI.getChildControl( Panel_Party, "Match_State_BG" )							-- 결투 진행상태 정보창
			name 	= PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_NAK_PVPMATCH_NAME")	-- "결투장"
			desc	= PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_TOOLTIPS_TIMEINFO")	-- "결투 제한시간인 10분이 지나면 결투가 자동으로 종료됩니다."
		end
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function matchResultTimeCount( deltaTime )										-- 결투 결과창 자동이동 60초 카운트다운
	returnTime = returnTime + deltaTime
	local totalTime = 60 - math.ceil( returnTime )
	matchResult._EndInfo_Sec:SetText( convertStringFromDatetime(toInt64(0,totalTime)) )
	if 60 < returnTime then
		returnTime = 0
		HandleClicked_MatchResultClose()
	end
end

function FGlobal_UpdatePartyState( inPartyMemberCount, inisLeader )				-- 파티원, 파티장 변경시 업데이트
	if nil == inPartyMemberCount or nil == inisLeader then
		return
	end

	if (inPartyMemberCount ~= partyMemberCount) or (inisLeader ~= isLeader) then
		partyMemberCount	= inPartyMemberCount
		isLeader			= inisLeader
		
		if (4 <= partyMemberCount) and (true == registerState) then	-- 파티원이 4명 이상이고 결투 등록중이면 결투 등록 취소(클라단에서 처리되었지만 예외 상황을 위해 추가)
			ToClient_UnRequestMatchInfo()
		end		
		
		if (matchInfo._BG:GetShow()) then
			matchInfo._Button_Combat:SetShow(isLeader)
		end
		
		matchInfo:setPosition()
		matchInfo:updateRegisterState()
	end
end

function matchInfo:registEventHandler()
	matchInfo._Button_Info		:addInputEvent("Mouse_On",	"matchInfoJoinBTSimpletooltips( true, 0 )")	-- 심플툴팁
	matchInfo._Button_Info		:setTooltipEventRegistFunc( "matchInfoJoinBTSimpletooltips( true, 0 )")
	matchInfo._Button_Info      :addInputEvent("Mouse_Out",	"matchInfoJoinBTSimpletooltips( false )")
	matchInfo._Button_Combat	:addInputEvent("Mouse_On",	"matchInfoJoinBTSimpletooltips( true, 1 )")
	matchInfo._Button_Combat	:setTooltipEventRegistFunc( "matchInfoJoinBTSimpletooltips( true, 1 )")
	matchInfo._Button_Combat	:addInputEvent("Mouse_Out",	"matchInfoJoinBTSimpletooltips( false )")
	matchInfo._State_BG			:addInputEvent("Mouse_On",	"matchInfoJoinBTSimpletooltips( true, 2 )")
	matchInfo._State_BG			:setTooltipEventRegistFunc( "matchInfoJoinBTSimpletooltips( true, 2 )")
	matchInfo._State_BG			:addInputEvent("Mouse_Out",	"matchInfoJoinBTSimpletooltips( false )")

	matchInfo._Button_Info		:addInputEvent("Mouse_LUp", "HandleClicked_RequestMatchInfoOpen()")		-- 결투정보 요청
	matchInfo._BG				:addInputEvent("Mouse_LUp", "HandleClicked_MatchClose()")				-- 결투정보창 클릭시 닫기
	matchInfo._Button_Combat	:addInputEvent("Mouse_LUp", "HandleClicked_RegisterMatch()")			-- 결투등록 버튼
	matchResult._Button_Close	:addInputEvent("Mouse_LUp", "HandleClicked_MatchResultClose()")			-- 결투 결과창 닫기 버튼
end

function matchInfo:registMessageHandler()
	registerEvent("FromClient_UpdateMatchInfo",			"FromClient_UpdateMatchInfo")			-- 결투 상태 메세지
	registerEvent("FromClient_MatchPvpResult",			"FromClient_MatchPvpResult")			-- 결투 결과
	registerEvent("FromClient_MatchInfo",				"FromClient_MatchInfo")					-- 결투 정보
	
	registerEvent("FromClient_PvPRegisterComplete",		"FromClient_PvPRegisterComplete")		-- 결투신청 등록됨
	registerEvent("FromClient_PvPUnRegisterComplete",	"FromClient_PvPUnRegisterComplete")		-- 결투신청 취소됨

	Panel_MatchResult	:RegisterUpdateFunc("matchResultTimeCount")								-- 결투 결과창 카운트 다운
end

function matchInfo_ShowMessage_Ack( showMsgType )								-- 시스템 메시지 출력
	if 0 == showMsgType then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MSG_ONLYMAINCHANNEL") )	-- "1채널에서만 결투장 이용이 가능합니다."
	elseif 1 == showMsgType then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MSG_NOREGISTERINFO") )	-- new = "잠시 후 결투정보 확인이 가능합니다."	org = "결투 정보 확인이 불가능한 상태입니다."
	elseif 2 == showMsgType then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MSG_REGISTERMATCH") )		-- "결투 대기 신청이 등록되었습니다."
	elseif 3 == showMsgType then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_PARTYCOMBAT_MSG_UNREGISTERMATCH") )	-- "결투 대기 신청이 취소되었습니다."
	end
end

function isShow_PartyMatchBg()
	local sizeY = 0
	if matchInfo._BG:GetShow() then
		sizeY = matchInfo._BG:GetSizeY() + 10
	end
	return sizeY
end

---- 1채널이거나 개발자 서버에서만 3:3 PvP 가능하도록 -------------------------------------------------------------------
if isContentsEnablePvp then
	matchInfo:init()
	matchInfo:updateRegisterState()
	matchInfo:registEventHandler()
	-- matchInfo_CheckRegion()
	-- matchInfo:init( false )
	-- matchInfo._Button_Info:addInputEvent("Mouse_LUp", "matchInfo_ShowMessage_Ack( 0 )")	-- "1채널에서만 결투장 이용이 가능합니다."
else
	Party_MatchClose()
end
if isContentsEnablePvp or isContentsEnableRace then
	matchInfo:registMessageHandler()
end

-------------------------------------------------------------------------------------------------------------------------
