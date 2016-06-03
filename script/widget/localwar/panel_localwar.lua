local UI_TM 		= CppEnums.TextMode
local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE
local UI_color		= Defines.Color
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM 			= CppEnums.EProcessorInputMode

Panel_LocalWar:SetShow(false)									-- 가급적 꺼두고 시작
Panel_LocalWar:setMaskingChild(true)									-- 자식까지 masking 할지 여부 설정(masking 사용 시 true)
Panel_LocalWar:ActiveMouseEventEffect(true)								-- 패널에 마우스 가져갈 때 이펙트 줄지 설정
Panel_LocalWar:setGlassBackground( true )								-- 패널의 반투명 설정(뒤가 보임), 기본적으로 true
Panel_LocalWar:RegisterShowEventFunc( true, 'LocalWar_ShowAni()' )			-- 패널이 show 될 때 애니메이션
Panel_LocalWar:RegisterShowEventFunc( false, 'LocalWar_HideAni()' )			-- 패널이 hide 될 때 애니메이션

function LocalWar_ShowAni()
end
function LocalWar_HideAni()
end

local isLocalwarOpen				= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 43 )

local myTeam						= UI.getChildControl( Panel_LocalWar, "StaticText_MyTeam" )
local accumulateKillCount			= UI.getChildControl( Panel_LocalWar, "StaticText_AccumulateKillCountIcon" )
local currentContinuityKillCount	= UI.getChildControl( Panel_LocalWar, "StaticText_CurrentContinuityKillCountIcon" )
local maxContinuityKillCount		= UI.getChildControl( Panel_LocalWar, "StaticText_MaxContinuityKillCountIcon" )
local buttonQuestion				= UI.getChildControl( Panel_LocalWar, "Button_Question" )
buttonQuestion:SetShow( false )

--{	새로운 국지전이다.
local _txt_LocalWarTime				= UI.getChildControl( Panel_LocalWarTeam, "StaticText_TimeLine" )
local _txt_LocalWarBlack			= UI.getChildControl( Panel_LocalWarTeam, "StaticText_TeamBlackDesert")
local _txt_LocalWarRed				= UI.getChildControl( Panel_LocalWarTeam, "StaticText_TeamRedDesert")
local _txt_TeamBlack				= UI.getChildControl( Panel_LocalWarTeam, "StaticText_MyTeamBlack")
local _txt_TeamRed					= UI.getChildControl( Panel_LocalWarTeam, "StaticText_MyTeamRed")
local _icon_TeamBlackBuff			= UI.getChildControl( Panel_LocalWarTeam, "Static_BlackTeamBuff")
local _icon_TeamRedBuff				= UI.getChildControl( Panel_LocalWarTeam, "Static_RedTeamBuff")
_icon_TeamBlackBuff	:SetShow( false )
_icon_TeamRedBuff	:SetShow( false )
--}

function LocalWar_Icon_Tooltip_Event()
	accumulateKillCount			:addInputEvent( "Mouse_On", "Panel_LocalWar_Icon_ToolTip_Show(" .. 0 .. ")" )
	accumulateKillCount			:addInputEvent( "Mouse_Out", "Panel_LocalWar_Icon_ToolTip_Show()" )
	currentContinuityKillCount	:addInputEvent( "Mouse_On", "Panel_LocalWar_Icon_ToolTip_Show(" .. 1 .. ")" )
	currentContinuityKillCount	:addInputEvent( "Mouse_Out", "Panel_LocalWar_Icon_ToolTip_Show()" )
	maxContinuityKillCount		:addInputEvent( "Mouse_On", "Panel_LocalWar_Icon_ToolTip_Show(" .. 2 .. ")" )
	maxContinuityKillCount		:addInputEvent( "Mouse_Out", "Panel_LocalWar_Icon_ToolTip_Show()" )
	buttonQuestion				:addInputEvent( "Mouse_On", "Panel_LocalWar_Icon_ToolTip_Show(" .. 3 .. ")" )
	buttonQuestion				:addInputEvent( "Mouse_Out", "Panel_LocalWar_Icon_ToolTip_Show()" )
end

local saveBlackScore	= 0
local saveRedScore		= 0
local blackTeam			= 0
local redTeam			= 0
local killCheck			= false
local teamCheck			= false
local killCount			= { _accumulate, _current, _max }

local displayTime = function(timeValue)
	timeValue = timeValue / 1000
	if 3600 < timeValue then
		timeValue = timeValue / 3600
		return tostring(timeValue) .. PAGetString(Defines.StringSheet_GAME, "LUA_CONSIGNMENTSALE_HOUR" )
	elseif 120 < timeValue then
		timeValue = timeValue / 60
		return tostring(timeValue) .. PAGetString(Defines.StringSheet_GAME, "LUA_CONSIGNMENTSALE_MINUTE" )
	elseif 0 < timeValue then
		return PAGetString(Defines.StringSheet_GAME, "LUA_CONSIGNMENTSALE_DEADLINE" )
	else
		return PAGetString(Defines.StringSheet_GAME, "LUA_CONSIGNMENTSALE_SALECLOSE" )
	end
end

-- 킬 카운트 초기화
function LocalWar_KillCount_Init()
	local team = ""
	_txt_TeamBlack:SetShow( false )
	_txt_TeamRed:SetShow( false )
	if 1 == ToClient_GetMyTeamNoLocalWar() then
		team = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_BELONG_1")
		_txt_TeamBlack:SetShow( true )
	else
		team = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_BELONG_2")
		_txt_TeamRed:SetShow( true )
	end
	myTeam:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LOCALWAR_BELONG_3", "team", team) )
end

-- 아이콘 툴팁
function Panel_LocalWar_Icon_ToolTip_Show( index )
	local isShow, name, desc, uiControl = true
	if 0 == index then			-- 누적킬
		name = "누적 처치 횟수"
		uiControl = accumulateKillCount
	elseif 1 == index then		-- 현재 연속킬
		name = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_ACCUMULATEKILLCOUNT")		-- "현재 연속 처치 횟수"
		uiControl = currentContinuityKillCount
	elseif 2 == index then		-- 최대 연속킬
		name = "최대 연속 처치 횟수"
		uiControl = maxContinuityKillCount
	elseif 3 == index then		-- 물음표 버튼(현재 꺼둠)
		name = "국지전이란?"
		desc = "국지전에 대한 설명이 들어갑니다.\n국지전 설명! 국지전 설명! 국지전 설명!" 
		uiControl = buttonQuestion
	else
		isShow = false
	end
	
	if isShow then
		registTooltipControl( uiControl, Panel_Tooltip_SimpleText )
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end	
end

-- 위젯 Show
-- function LocalWar_Show()
-- 	if not Panel_LocalWar:GetShow() then
-- 		Panel_LocalWar:SetShow( true )
-- 		Panel_LocalWar_Repos()
-- 		LocalWar_KillCount_Init()
-- 	else
-- 		return
-- 	end
-- end

--위젯 Hide
-- function LocalWar_Hide()
-- 	if Panel_LocalWar:GetShow() then
-- 		Panel_LocalWar:SetShow( false )
-- 		Panel_LocalWar_Repos()
-- 		FGlobal_Panel_Monster_Bar_RePos()
-- 	end
-- end

-- function FGlobal_LocalWar_Show()
-- 	if 0 == ToClient_GetMyTeamNoLocalWar() then			-- 국지전 참가중이 아니면 리턴
-- 		LocalWar_Hide()
-- 		return
-- 	end
-- 	LocalWar_Show()
-- 	FGlobal_Panel_Monster_Bar_RePos()
-- end
------------------------------------------------------------------------------------------------
--	새로운 국지전
------------------------------------------------------------------------------------------------
function NewLocalWar_Show()
	if not Panel_LocalWarTeam:GetShow() then
		Panel_LocalWarTeam	:SetShow( true )
	else
		return
	end
end

function NewLocalWar_Hide()
	if Panel_LocalWarTeam:GetShow() then
		Panel_LocalWarTeam:GetShow( false )
	end
end

function FGlobal_NewLocalWar_Show()
	if 0 == ToClient_GetMyTeamNoLocalWar() then
		NewLocalWar_Hide()
		return
	end
	saveBlackScore		= 0
	saveRedScore		= 0
	NewLocalWar_Show()
end

function NewLocalWar_Update()
	local teamBlackPoint			= ToClient_GetLocalwarTeamPoint(0)
	local teamRedPoint				= ToClient_GetLocalwarTeamPoint(1)
	local isTeam					= ToClient_GetMyTeamNoLocalWar()

	_txt_LocalWarBlack	:EraseAllEffect()
	_txt_LocalWarRed	:EraseAllEffect()

	if saveBlackScore < teamBlackPoint then
		if 99 < teamBlackPoint and teamBlackPoint < 1000 then
			_txt_LocalWarBlack:AddEffect("UI_GuildWar_ArrowMark_Big01", false, 5, -1.5)
		elseif 9 < teamBlackPoint and teamBlackPoint < 100 then
			_txt_LocalWarBlack:AddEffect("UI_GuildWar_ArrowMark_Big01", false, -1, -1.5)
		elseif teamBlackPoint < 10 then
			_txt_LocalWarBlack:AddEffect("UI_GuildWar_ArrowMark_Big01", false, -5, -1.5)
		else
			_txt_LocalWarBlack:AddEffect("UI_GuildWar_ArrowMark_Big01", false, 0.0, 0.0)
		end
		saveBlackScore = teamBlackPoint
	end

	if saveRedScore < teamRedPoint then
		if 99 < teamRedPoint and teamRedPoint < 1000 then
			_txt_LocalWarRed:AddEffect("UI_GuildWar_ArrowMark_Big01", false, -4, -1.5)
		elseif 9 < teamRedPoint and teamRedPoint < 100 then
			_txt_LocalWarRed:AddEffect("UI_GuildWar_ArrowMark_Big01", false, 1, -1.5)
		elseif teamRedPoint < 10 then
			_txt_LocalWarRed:AddEffect("UI_GuildWar_ArrowMark_Big01", false, 5, -1.5)
		else
			_txt_LocalWarRed:AddEffect("UI_GuildWar_ArrowMark_Big01", false, 0.0, 0.0)
		end
		saveRedScore = teamRedPoint
	end

	_txt_LocalWarBlack		:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_LOCALWAR_BLACKDESERTTEAM", "teamBlackPoint", teamBlackPoint ) ) -- "검은사막 : " .. teamBlackPoint )
	_txt_LocalWarRed		:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_LOCALWAR_REDDESERTTEAM", "teamRedPoint", teamRedPoint ) ) -- teamRedPoint .. " : 붉은사막" )
end

local _winningTeam = 2;
function LocalwarReloadUI()
	local teamBlackPoint			= ToClient_GetLocalwarTeamPoint(0)
	local teamRedPoint				= ToClient_GetLocalwarTeamPoint(1)

	if( teamBlackPoint < teamRedPoint ) then
		_winningTeam = 0
	elseif( teamRedPoint < teamBlackPoint )	then
		_winningTeam = 1
	else
		_winningTeam = 2
	end

--{	붉은 전장 현재 상태 체크하여 준비중, 곧 종료됨, 종료됨 SetText 부분.
	if 0 == ToClient_GetLocalwarState() then
		-- _txt_LocalWarTime:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_READY") ) -- 준비중
	elseif 1 == ToClient_GetLocalwarState() then
		_txt_LocalWarTime:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_SOONFINISH") )
	elseif 2 == ToClient_GetLocalwarState() then
		_txt_LocalWarTime:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_FINISH") ) -- 종료
		if 0 == ToClient_GetMyTeamNoLocalWar() then
			NewLocalWar_Hide()
		end
	end
--}

	if 0 == ToClient_GetMyTeamNoLocalWar() then
		NewLocalWar_Hide()
	end
end
LocalwarReloadUI()

function NewLocalWar_TurnAround()
	local teamBlackPoint			= ToClient_GetLocalwarTeamPoint(0)
	local teamRedPoint				= ToClient_GetLocalwarTeamPoint(1)
	local myTeamIndex				= ToClient_GetMyTeamNoLocalWar() - 1

	local prevWinningTeam = _winningTeam

	if( teamBlackPoint < teamRedPoint ) then
		_winningTeam = 0
	elseif( teamRedPoint < teamBlackPoint )	then
		_winningTeam = 1
	else
		return
	end

	if( prevWinningTeam == _winningTeam or 2 == prevWinningTeam ) then
		return
	end

	if( 0 == _winningTeam ) then
		msg = { main=PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_REDTEAM_TURNAROUND"),	sub="", addMsg ="" }	-- 붉은 사막군 역전!
		Proc_ShowMessage_Ack_For_RewardSelect( msg, 1.8, 47, false )
		teamCheck = true
	elseif( 1 == _winningTeam ) then
		msg = { main=PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_BLACKTEAM_TURNAROUND"),	sub="", addMsg ="" }	-- 검은 사막군 역전!
		Proc_ShowMessage_Ack_For_RewardSelect( msg, 1.8, 47, false )
		teamCheck = false
	end
end

local saveLocalWarTime	= 0
local delayTime = 1
local localwarDeltaTime = 0
function NewLocalWar_TimeUpdate( deltaTime )
	localwarDeltaTime = localwarDeltaTime + deltaTime
	if ( delayTime <= localwarDeltaTime  )then
		local warTime			= ToClient_GetLocalwarRemainedTime()
		if 0 < saveLocalWarTime then
			if 0 == warTime then
				_txt_LocalWarTime:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_SOONFINISH") )
			end
		end
		saveLocalWarTime = warTime
		if 0 == warTime then
			if 1 == ToClient_GetLocalwarState() then
				_txt_LocalWarTime:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_SOONFINISH") )
			end
			return
		end
		local warTimeMinute		= math.floor(warTime / 60)
		local warTimeSecond		= warTime % 60
		if warTimeMinute < 10 then
			warTimeMinute = "0" .. warTimeMinute
		end
		if warTimeSecond < 10 then
			warTimeSecond = "0" .. warTimeSecond
		end
		localwarDeltaTime = 0
		_txt_LocalWarTime	:SetText( tostring(warTimeMinute) .. " : " .. tostring(warTimeSecond) )
	end
end

function FromClient_KillLocalWar( killPlayer, deadPlayer, killPlayerTeam, getScore )
	if (nil == killPlayer) or (nil == deadPlayer) then
		return
	end
	local teamBlackPoint	= ToClient_GetLocalwarTeamPoint(0)
	local teamRedPoint		= ToClient_GetLocalwarTeamPoint(1)
	-- if (blackTeam < teamRedPoint) then -- and (false == teamCheck) then
	-- 	teamCheck = true
	-- end
	-- if (redTeam < teamBlackPoint) then -- and (true == teamCheck) then
	-- 	teamCheck = false
	-- end
	blackTeam				= teamBlackPoint
	redTeam					= teamRedPoint
	local isTeam			= ToClient_GetMyTeamNoLocalWar()
-- _PA_LOG("정태곤", "팀을 체크한다[teamCheck] : " .. tostring(teamCheck) .. " / killPlayerTeam : " .. tostring(killPlayerTeam))
-- 	if (isTeam == killPlayerTeam) then
-- 		teamCheck = false
-- 	else
-- 		teamCheck = true
-- 	end
	-- teamCheck				= killPlayerTeam

	local mainMessage = nil
	if isTeam == killPlayerTeam then	-- 내 팀인가?
		if 100 <= getScore then
			local isMsg = { main="[".. killPlayer .."]",	sub=PAGetStringParam1( Defines.StringSheet_GAME, "LUA_LOCALWAR_GETSCROE_ALOT", "getScore", getScore ), addMsg ="" }	-- 검은 사막군 역전!
			Proc_ShowMessage_Ack_For_RewardSelect( isMsg, 5, 49, false )
		end
		mainMessage = "<PAColor0xFF2C7BFF>" .. PAGetStringParam3( Defines.StringSheet_GAME, "LUA_LOCALWAR_KILLPLAYER", "killPlayer", killPlayer, "deadPlayer", deadPlayer, "score", getScore ) .. "<PAOldColor>"
	else
		if 100 <= getScore then
			local isMsg2 = { main="[".. killPlayer .."]",	sub=PAGetStringParam1( Defines.StringSheet_GAME, "LUA_LOCALWAR_GETSCROE_ALOT", "getScore", getScore ), addMsg ="" }	-- 검은 사막군 역전!
			Proc_ShowMessage_Ack_For_RewardSelect( isMsg2, 5, 48, false )
		end
		mainMessage = "<PAColor0xFFC02A2A>" .. PAGetStringParam3( Defines.StringSheet_GAME, "LUA_LOCALWAR_KILLPLAYER", "killPlayer", killPlayer, "deadPlayer", deadPlayer, "score", getScore ) .. "<PAOldColor>"
	end
-- _PA_LOG("정태곤", "blackTeam : " .. tostring(blackTeam) .. " / teamRedPoint : " .. tostring(teamRedPoint))
-- 	if blackTeam < teamRedPoint then
-- 		_PA_LOG("정태곤", "Red팀역전!?")
-- 	else
-- 		_PA_LOG("정태곤", "Black팀역전!?")
-- 	end
-- _PA_LOG("정태곤", "redTeam : " .. tostring(redTeam) .. " / teamBlackPoint : " .. tostring(teamBlackPoint))
	-- if redTeam < teamBlackPoint then
	-- end

	local msg = { main=mainMessage, sub = "", addMsg = "" }
	-- msg = { msg.main = mainMessage }
	-- msg = { msg.main = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_LOCALWAR_KILLPLAYER", "killPlayer", killPlayer, "deadPlayer", deadPlayer ) }

	if nil ~= msg.main then
		-- Proc_ShowMessage_Ack_For_RewardSelect( msg, 5, 34 )
		chatting_sendMessage( "", msg.main, CppEnums.ChatType.Battle )
	end

	NewLocalWar_Update()
	NewLocalWar_TurnAround()
end

function FromClient_MultiKillLocalWar( killerName, deadPlayerName, killCount, posX, posY, posZ )
	if 5 <= killCount then
		local killPlayerPos3D = float3( posX, posY, posZ )
		LocalWar_MultiKillPlayerIcon_WorldMap( killerName, killCount, killPlayerPos3D )
	end	
end

function FromClient_UpdateLocalwarState( state )
	-- 0: 붉은 전장 참여 알림 / 1: 플레이 중 / 2: 결과 / 3: 종료
	if nil == state or "" == state then
		return
	end
	if not isLocalwarOpen then
		return
	end
	local msg = { main="", sub = "", addMsg = "" }
	if 0 == state then
		msg = { main=PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_RECRUITMENT_MAIN"),	sub=PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_RECRUITMENT_SUB"), addMsg ="" }
		Proc_ShowMessage_Ack_For_RewardSelect( msg, 5, 34, false )
	elseif 1 == state then
		msg = { main=PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_START_MAIN"),			sub=PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_START_SUB"), addMsg ="" }
		Proc_ShowMessage_Ack_For_RewardSelect( msg, 5, 34, false )
	elseif 2 == state then
		local teamBlackPoint			= ToClient_GetLocalwarTeamPoint(0)
		local teamRedPoint				= ToClient_GetLocalwarTeamPoint(1)
		local winnerTeamNo				= 2
		if teamBlackPoint < teamRedPoint then
			winnerTeamNo = 2
		elseif teamRedPoint < teamBlackPoint then
			winnerTeamNo = 1
		end

		if winnerTeamNo == ToClient_GetMyTeamNoLocalWar() then
			msg = { main=PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_WARWIN"), sub=PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_MOVEBEFOREREGION"), addMsg ="" }
			Proc_ShowMessage_Ack_For_RewardSelect( msg, 5, 45, false )	-- 승리
		else
			msg = { main=PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_WARLOSE"), sub=PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_MOVEBEFOREREGION"), addMsg ="" }
			Proc_ShowMessage_Ack_For_RewardSelect( msg, 5, 46, false )	-- 패배
		end

		_txt_LocalWarTime:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_FINISH") ) -- 종료
	elseif 3 == state then
		msg = { main=PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_FINISH_MAIN"),			sub=PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_FINISH_SUB"), addMsg ="" }
		Proc_ShowMessage_Ack_For_RewardSelect( msg, 5, 34, false )
	end
end

function FromClient_LocalWarKickOut()
	-- 붉은 전장이 곧 종료될 예정 메시지 이벤트.
	local msg = { main=PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_KICKOUT"),	sub=PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_KICKOUT_SUB"), addMsg ="" }
	Proc_ShowMessage_Ack_For_RewardSelect( msg, 5, 34, false )
end

function FromClient_LocalWarAdvantage( teamNo )
	local advantageMsg = { main="",	sub="", addMsg ="" }
	if nil == teamNo then
		return
	end

	if 0 == teamNo then
		advantageMsg = { main=PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_ADVANTAGEMSG_PARAM0_MAIN"),	sub=PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_ADVANTAGEMSG_PARAM0_SUB"), addMsg ="" }
	elseif 1 == teamNo then
		advantageMsg = { main=PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_ADVANTAGEMSG_PARAM1_MAIN"),	sub=PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_ADVANTAGEMSG_PARAM1_SUB"), addMsg ="" }
	elseif 2 == teamNo then
		advantageMsg = { main=PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_ADVANTAGEMSG_PARAM2_MAIN"),	sub=PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_ADVANTAGEMSG_PARAM2_SUB"), addMsg ="" }
	end

	Proc_ShowMessage_Ack_For_RewardSelect( advantageMsg, 5, 34, false )
end

------------------------------------------------------------------------------------------------
--	새로운 국지전 끝
------------------------------------------------------------------------------------------------
function FromClient_UpdateMyKillCountLocalWar()
	-- LocalWar_KillCount_Update()
end

function LocalWar_MultiKillPlayerIcon_WorldMap( name, count, pos )
	local showTime = 180.0			-- 노출 시간 3분
	
	-- if 1 == ToClient_GetMyTeamNoLocalWar() then
		ToClient_worldmapAddIcon( "Static_RedIcon_LocalWar", pos, showTime )		-- UI_New_WorldMap_Template 내 콘트롤 명 직접 입력
	-- elseif 2 == ToClient_GetMyTeamNoLocalWar() then
		-- ToClient_worldmapAddIcon( "Static_BlackIcon_LocalWar", pos, showTime )
	-- end
end

local sizeX = Panel_LocalWar:GetSizeX()
local sizeY = Panel_LocalWar:GetSizeY()
local iconPosX = accumulateKillCount:GetPosX()
local gapX = 60
local gapY = 30
function Panel_NewLocalWar_Repos()
	Panel_LocalWarTeam:SetPosX( getScreenSizeX()/2 - Panel_LocalWarTeam:GetSizeX()/2 )
	Panel_LocalWarTeam:SetPosY( 0 )
end

function NewLocalWar_Init()
	if 0 == ToClient_GetMyTeamNoLocalWar() then
		NewLocalWar_Hide()
		return
	end
end

NewLocalWar_Init()
LocalWar_Icon_Tooltip_Event()
FGlobal_NewLocalWar_Show()
NewLocalWar_Update()
LocalWar_KillCount_Init()
-- LocalWar_KillCount_Update()
registerEvent( "onScreenResize",						"Panel_NewLocalWar_Repos" )
registerEvent( "FromClient_UpdateMyKillCountLocalWar",	"FromClient_UpdateMyKillCountLocalWar" )	-- 킬 카운트 변경 시 이벤트
registerEvent( "FromClient_KillLocalWar",				"FromClient_KillLocalWar" )					-- 킬 알림( 죽인사람이름, 죽은사람이름 )
registerEvent( "FromClient_MultiKillLocalWar",			"FromClient_MultiKillLocalWar" )			-- 킬 알림( 죽인사람이름, 죽은사람이름 )
registerEvent( "FromClient_UpdateLocalwarState",		"FromClient_UpdateLocalwarState" )			-- 붉은 전장 상태 업데이트.
registerEvent( "FromClient_LocalWarKickOut",			"FromClient_LocalWarKickOut" )				-- 곧 붉은 전장이 종료될 예정임 메시지.
-- registerEvent( "FromClient_LocalWarAdvantage",			"FromClient_LocalWarAdvantage" )			-- 어드밴티지 받는 이벤트.(1분마다 이벤트가 와서 메시지를 뿌리므로 임시로 막음.)
Panel_LocalWarTeam	:RegisterUpdateFunc("NewLocalWar_TimeUpdate")									-- 붉은 전장 시간.