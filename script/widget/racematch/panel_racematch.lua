local raceResult	= {}
local returnTime	= 0
local raceCheck		= false
local isContentsEnable = ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 41 ) -- 말경주 컨텐츠 옵션.

local raceResultControl =
{
	_Back_BG				= UI.getChildControl(Panel_RaceResult, "Back_BG"),
	_Line_Bottom			= UI.getChildControl(Panel_RaceResult, "Line_Bottom_Win"),
	_Button_Close			= UI.getChildControl(Panel_RaceResult, "Button_Close" ),
	_Txt_EndTime			= UI.getChildControl(Panel_RaceResult, "StaticText_EndInfo" ),

	resultList = {},
}

local raceStart = {
	_Txt_time				= UI.getChildControl(Panel_RaceTimeAttack, "StaticText_TimeCount"),
	_Txt_FinishTime			= UI.getChildControl(Panel_RaceFinishTime, "StaticText_FinishTime"),

}

function FromClient_UpdateRace( raceState, nodeName )
	if not isContentsEnable then
		return
	end
	local self = raceStart
	-- 0: 실격, 1: 출발, 2: 체크포인트, 3: 골인, 4: 변동없음.
	local messages	= { main = "", sub="", addMsg ="" }
	local msgType	= 36
	local nextNodeName = ""
	if 0 == raceState then
		messages	= { main = PAGetString(Defines.StringSheet_GAME, "LUA_RACEMATCH_RACEUPDATE_MSG1"), sub="", addMsg ="" } --"경주에서 실격 처리되었습니다."
		msgType		= 36
		raceCheck	= true
	elseif 1 == raceState then
		messages	= { main = PAGetString(Defines.StringSheet_GAME, "LUA_RACEMATCH_RACEUPDATE_MSG2"), sub="", addMsg ="" } --"경주가 시작되었습니다."
		msgType		= 40
		raceCheck	= true
		RaceWindowToggleCheck()
		Panel_RaceTimeAttack:SetShow( true )
		Panel_RaceFinishTime:SetShow( false )
	elseif 2 == raceState then
		if ("" == nodeName) or (nil == nodeName) or (" " == nodeName) then
			nextNodeName = PAGetString(Defines.StringSheet_GAME, "LUA_RACEMATCH_GOAL_IN") -- 도착지
		else
			nextNodeName = nodeName
		end
		messages	= { main = PAGetString(Defines.StringSheet_GAME, "LUA_RACEMATCH_RACEUPDATE_MSG3"), sub=PAGetStringParam1( Defines.StringSheet_GAME, "LUA_RACEMATCH_NEXTNODE", "nextNodeName", nextNodeName ), addMsg ="" } --"부분 지점을 지났습니다."
		msgType		= 41
		raceCheck	= true
	elseif 3 == raceState then
		messages	= { main = PAGetString(Defines.StringSheet_GAME, "LUA_RACEMATCH_RACEUPDATE_MSG4"), sub="", addMsg ="" } --"경주 도착지점에 도착하였습니다."
		msgType		= 37
		self._Txt_time:SetShow( false )
		raceCheck	= false
	elseif 4 == raceSTate then
		messages	= { main = PAGetString(Defines.StringSheet_GAME, "LUA_RACEMATCH_RACEUPDATE_MSG5"), sub="", addMsg ="" } --"변동이 없습니다."
		msgType		= 36
		raceCheck	= true
	end
	Proc_ShowMessage_Ack_For_RewardSelect( messages, 10, msgType )
end

function FromClient_MatchRaceResult()											-- 말경주 결과창
	audioPostEvent_SystemUi(17,02)
	local self			= raceResultControl
	local resultCount	= ToClient_RaceMatchResultCount()
	local resultBg		= 1

	raceResult = {}
	for idx = 0, resultCount -1 do
		local raceResultInfo	= ToClient_RaceMatchResultAt( idx )
		if false == raceResultInfo:isEmpty() and 0 ~= raceResultInfo:getRank() then
			local _rank				= raceResultInfo:getRank()	-- 순위
			local _name				= raceResultInfo:getName()
			local _recordTime		= raceResultInfo:getRecordTime()
			local raceResultList = {}
			raceResultList.bg		= UI.createAndCopyBasePropertyControl( Panel_RaceResult, "Static_RankBG",			self._Back_BG, "raceResultList_BG_"			.. idx )
			raceResultList.rankIcon	= UI.createAndCopyBasePropertyControl( Panel_RaceResult, "Static_TopRankIcon",		self._Back_BG, "raceResultList_rankIcon_"	.. idx )
			raceResultList.rankTxt	= UI.createAndCopyBasePropertyControl( Panel_RaceResult, "StaticText_LowRank",		self._Back_BG, "raceResultList_rankTxt_"	.. idx )
			raceResultList.name		= UI.createAndCopyBasePropertyControl( Panel_RaceResult, "StaticText_RankerName",	self._Back_BG, "raceResultList_name_"		.. idx )
			raceResultList.time		= UI.createAndCopyBasePropertyControl( Panel_RaceResult, "StaticText_RankerTime",	self._Back_BG, "raceResultList_time_"		.. idx )
			raceResultList.goods	= UI.createAndCopyBasePropertyControl( Panel_RaceResult, "StaticText_Goods",		self._Back_BG, "raceResultList_goods_"		.. idx )

			raceResult[idx]	= {
				rank		= _rank,
				name		= _name,
				recordTime	= _recordTime,
			}
			self.resultList[idx] = raceResultList

			self.resultList[idx].bg:ChangeTextureInfoName("New_UI_Common_forLua/Widget/Party/Matchresult_00.dds")
			local x1, y1, x2, y2 = 0, 0, 0, 0
			if (1 == resultBg % 2) then							
				x1, y1, x2, y2 = setTextureUV_Func( self.resultList[idx].bg, 130, 406, 244, 440 )
				self.resultList[idx].bg:getBaseTexture():setUV(  x1, y1, x2, y2  )
				self.resultList[idx].bg:setRenderTexture(self.resultList[idx].bg:getBaseTexture())
			else
				x1, y1, x2, y2 = setTextureUV_Func( self.resultList[idx].bg, 246, 406, 360, 440 )
				self.resultList[idx].bg:getBaseTexture():setUV(  x1, y1, x2, y2  )
				self.resultList[idx].bg:setRenderTexture(self.resultList[idx].bg:getBaseTexture())
			end

			self.resultList[idx].bg:SetPosY( ( 34 * idx ) )
			self.resultList[idx].bg:SetShow( true )
			self.resultList[idx].name:SetText( _name )
			self.resultList[idx].name:SetPosY( ( 34 * idx ) )
			if 3 < _rank then
				self.resultList[idx].rankIcon	:SetShow( false )
				self.resultList[idx].rankTxt	:SetShow( true )
				self.resultList[idx].rankTxt	:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_LIFERANKING_RANK", "listIdx", _rank ) ) -- _rank .. "위" )
				self.resultList[idx].rankTxt	:SetPosY( 0 + ( 34 * idx ) )
				self.resultList[idx].goods		:SetText("x1")
			else
				self.resultList[idx].rankTxt	:SetShow( false )
				self.resultList[idx].rankIcon	:SetShow( true )

				self.resultList[idx].rankIcon:ChangeTextureInfoName("New_UI_Common_forLua/Widget/Party/MatchResult_00.dds")
				local x1, y1, x2, y2 = 0, 0, 0, 0
				if 1 == _rank then
					x1, y1, x2, y2 = setTextureUV_Func( self.resultList[idx].rankIcon, 218, 104, 259, 145 )
					self.resultList[idx].rankIcon	:getBaseTexture():setUV(  x1, y1, x2, y2  )
					self.resultList[idx].rankIcon	:SetPosY( ( 34 * idx ) -4 )
					self.resultList[idx].rankIcon	:setRenderTexture(self.resultList[idx].rankIcon:getBaseTexture())
					self.resultList[idx].goods		:SetText("x5")
				elseif 2 == _rank then
					x1, y1, x2, y2 = setTextureUV_Func( self.resultList[idx].rankIcon, 218, 146, 259, 187 )
					self.resultList[idx].rankIcon	:getBaseTexture():setUV(  x1, y1, x2, y2  )
					self.resultList[idx].rankIcon	:SetPosY( ( 34 * idx ) -4 )
					self.resultList[idx].rankIcon	:setRenderTexture(self.resultList[idx].rankIcon:getBaseTexture())
					self.resultList[idx].goods		:SetText("x3")
				elseif 3 == _rank then
					x1, y1, x2, y2 = setTextureUV_Func( self.resultList[idx].rankIcon, 218, 188, 259, 229 )
					self.resultList[idx].rankIcon	:getBaseTexture():setUV(  x1, y1, x2, y2  )
					self.resultList[idx].rankIcon	:SetPosY( ( 34 * idx ) -4 )
					self.resultList[idx].rankIcon	:setRenderTexture(self.resultList[idx].rankIcon:getBaseTexture())
					self.resultList[idx].goods		:SetText("x2")
				end
			end
			self.resultList[idx].goods	:SetPosY( ( 34 * idx ) -2 )
			self.resultList[idx].time	:SetText( _recordTime )
			self.resultList[idx].time	:SetPosY( ( 34 * idx ) )

			self._Back_BG				:SetSize( self._Back_BG:GetSizeX(), 34*(_rank) )
			self._Line_Bottom			:SetPosY( self._Back_BG:GetSizeY()+self._Back_BG:GetPosY() )
			self._Txt_EndTime			:SetPosY( self._Line_Bottom:GetPosY()+10 )
			self._Button_Close			:SetPosY( self._Txt_EndTime:GetPosY()+10 )
			resultBg = resultBg + 1
		end
	end
	-- local tableSortDo = function( a, b )
	-- 	return a.rank < b.rank
	-- end

	-- table.sort( raceResult, tableSortDo )

	-- for idx = 0, resultCount -1 do
	-- 	-- _PA_LOG("말경주", "순위 소팅 체크 : " .. idx .. "/_rank : " .. raceResult[idx].rank .. "/_name : " .. raceResult[idx].name)
	-- end
	-- 이상 없으면 위 배열을 결과 창에 업데이트 한다.
	-- 창 켜기
	Panel_RaceResult:SetShow( true )
	Panel_RaceTimeAttack:SetShow( false )
	Panel_RaceFinishTime:SetShow( false )
	-- 업데이트
end

local finishedRace = false
function FromClient_CheckRetire()
	finishedRace = true
	Panel_RaceFinishTime:SetShow( true )
	Panel_RaceFinishTime:RegisterUpdateFunc("RaceFinishTimeCount")									-- 말레이스 결과창 카운트 다운
end

function HandleClicked_RaceResultClose()										-- 결투 결과창 닫기
	Panel_RaceResult:SetShow( false )
end

local startDeltaTime	= 0
local startMinuteTime	= 0
local finishDeltaTime	= 0
function RaceStartTimeCount( deltaTime )
	local self = raceStart
	if not raceCheck then
		return
	end
	Panel_RaceTimeAttack:SetShow( true )
	-- startDeltaTime	= startDeltaTime + deltaTime
	-- local subSecond	= startDeltaTime - startDeltaTime % 0.01
	-- local second	= (subSecond - (subSecond % 1))%60
	-- local milSecond	= math.floor((subSecond * 100)%100)

	-- if 60 < startDeltaTime then
	-- 	startMinuteTime = math.floor(startDeltaTime / 60)
	-- end
	-- local minute = "00"
	-- local secondTime = "00"
	-- local milSec = "00"
	-- if startMinuteTime < 10 then
	-- 	minute = "0" .. startMinuteTime
	-- else
	-- 	minute = "" .. startMinuteTime
	-- end
	-- if second < 10 then
	-- 	secondTime = "0" .. second
	-- else
	-- 	secondTime = "" .. second
	-- end
	-- if milSecond < 10 then
	-- 	milSec = "0" .. milSecond
	-- else
	-- 	milSec = "" .. milSecond
	-- end
	-- self._Txt_time:SetText( minute .. " : " .. secondTime .." : " .. milSec )
	self._Txt_time:SetText( ToClient_GetCurrentTime() )
end

local finishTimeCheck = false
function RaceFinishTimeCount( deltaTime )
	local self = raceStart
	if finishTimeCheck then
		return
	end
	if finishedRace then
		Panel_RaceFinishTime:SetShow( true )
		finishDeltaTime = finishDeltaTime + deltaTime
		local finishTime = 30 - math.ceil( finishDeltaTime )
		self._Txt_FinishTime:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_RACEMATCH_FINISH_TIME_COUNT", "finishTime", finishTime ) ) -- "종료 " .. finishTime .. "초 전!" )
		if 30 < finishDeltaTime then
			self._Txt_FinishTime:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RACEMATCH_FINISH_TIME_RESULT") ) -- "잠시 후 결과가 나옵니다." )
			finishTimeCheck = true
		end
	end
end

function RaceResultTimeCount( deltaTime )										-- 말 레이스 결과창 자동이동 60초 카운트다운
	returnTime = returnTime + deltaTime
	local totalTime = 60 - math.ceil( returnTime )
	raceResultControl._Txt_EndTime:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_RACEMATCH_RESULT_TIME_COUNT", "totalTime", convertStringFromDatetime(toInt64(0,totalTime)) ) ) -- "<PAColor0xFFF26A6A>" .. convertStringFromDatetime(toInt64(0,totalTime)) .. "<PAOldColor> 후 이전 위치로 이동됩니다." )
	if 60 < returnTime then
		returnTime = 0
		HandleClicked_RaceResultClose()
	end
end

function RaceWindowToggleCheck()
	-- 월드맵이 열려있으면 닫는다.
	if( ToClient_WorldMapIsShow() ) then
		FGlobal_PopCloseWorldMap();
	end
	-- 캐쉬샵이 열려있으면 닫는다.
	if( Panel_IngameCashShop:GetShow() ) then
		InGameShop_Close()
	end
	IngameCustomize_Hide() -- 인게임 커마샵을 닫는다.
	Panel_Knowledge_Hide() -- 지식 UI가 열려있으면 닫는다.
	FGlobal_Panel_DyeNew_Hide() -- 염색 UI가 열려있으면 닫는다.

end

function RaceResultPanel_Resize()
	local scrSizeY = getScreenSizeY()
	Panel_RaceResult:SetPosY( scrSizeY - ( Panel_RaceResult:GetPosY()-Panel_RaceResult:GetSizeY() ) )
	Panel_RaceResult:ComputePos()

	Panel_RaceFinishTime:SetSpanSize( Panel_RaceTimeAttack:GetSpanSize().x, Panel_RaceTimeAttack:GetSpanSize().y+100 )
end

function raceResultControl:registEventHandler()
	self._Button_Close:addInputEvent("Mouse_LUp", "HandleClicked_RaceResultClose()")
end

function FromClient_OpenRaceStart( needTier )
	if not isContentsEnable then
		return
	end
	messages	= { main = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_RACEMATCH_OPENRACESTART_TIER", "needTier", needTier ), sub=PAGetString(Defines.StringSheet_GAME, "LUA_RACEMATCH_OPENRACESTART_POSSIBLE"), addMsg ="" }
	Proc_ShowMessage_Ack_For_RewardSelect( messages, 10, 39 )
end

function FromClient_RaceRegisterComplete()
	Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_RACEMATCH_RACE_REGIST") ) -- "경주에 등록되었습니다.")
end

function FromClient_RaceUnRegisterComplete()
	Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_RACEMATCH_RACE_CANCEL") ) -- "경주 등록이 취소되었습니다.")
end

local nodeText = ""
function FromClient_RaceNotifyPassCheckPoint( characterName, nodeName )
	if not isContentsEnable then
		return
	end

	if "" == nodeName then
		nodeText = PAGetString(Defines.StringSheet_GAME, "LUA_RACEMATCH_GOAL") -- 도착
	else
		nodeText = nodeName
	end

	local messages	= { main = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_RACEMATCH_RACENOTIFYPASS_MAIN", "characterName", characterName ), sub = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_RACEMATCH_RACENOTIFYPASS_SUB", "nodeName", nodeText ), addMsg = "" }
	Proc_ShowMessage_Ack_For_RewardSelect( messages, 10, 43 )
end

function raceResultControl:registMessageHandler()
	registerEvent("FromClient_MatchRaceResult",				"FromClient_MatchRaceResult")			-- 말경주 결과
	registerEvent("FromClient_UpdateRace",					"FromClient_UpdateRace")				-- 말경주 정보 업데이트.
	registerEvent("FromClient_CheckRetire",					"FromClient_CheckRetire")
	registerEvent("FromClient_OpenRaceStart",				"FromClient_OpenRaceStart")
	registerEvent("FromClient_RaceRegisterComplete",		"FromClient_RaceRegisterComplete")		-- 말 경주가 등록되면 이벤트가 온다.
	registerEvent("FromClient_RaceNotifyPassCheckPoint",	"FromClient_RaceNotifyPassCheckPoint")
	registerEvent("FromClient_RaceUnRegisterComplete",		"FromClient_RaceUnRegisterComplete")	-- 말 경주에 등록 취소되면 이벤트가 온다.
	registerEvent("onScreenResize",							"RaceResultPanel_Resize" )

	Panel_RaceResult		:RegisterUpdateFunc("RaceResultTimeCount")									-- 말레이스 결과창 카운트 다운
	Panel_RaceTimeAttack	:RegisterUpdateFunc("RaceStartTimeCount")
end

RaceResultPanel_Resize()
raceResultControl:registEventHandler()
raceResultControl:registMessageHandler()