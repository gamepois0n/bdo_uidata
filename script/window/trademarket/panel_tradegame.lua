Panel_TradeGame:SetShow( false )
Panel_TradeGame:setGlassBackground( true )
Panel_TradeGame:SetDragEnable( true )
Panel_TradeGame:SetDragAll( true )
Panel_TradeGame:SetPosX( getScreenSizeX()/2 - Panel_TradeGame:GetSizeX()/2 )
Panel_TradeGame:SetPosY( getScreenSizeY()/2 - Panel_TradeGame:GetSizeY()/2 )

local VCK = CppEnums.VirtualKeyCode
local UI_TM 		= CppEnums.TextMode
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color

local enTradeGameSwitchType =
{
	enTradeGameSwitchType_Small = 0,
	enTradeGameSwitchType_Large = 1,
}

local enTradeGameResult =
{
	enTradeGameResult_Less = 0,
	enTradeGameResult_More = 1,
	enTradeGameResult_Correct = 2,
	enTradeGameResult_NoTryCount = 3,
	
	enTradeGameResult_None,
}

local enTradeGameState =
{
	enTradeGameState_Play = 1,
	enTradeGameState_Finish = 2,
}

-- 남은 주사위 횟수와 목표치에 얼마나 남았는지를 따져 메시지를 뿌려주자!
local lowDice_Msg = {}
local highDice_Msg = {}
lowDice_Msg[1] =
{
	_low = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_LOWDICE0_LOW"), -- "좀 더 세밀한 조율이 필요하다.",
	_middle = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_LOWDICE0_MIDDLE"), -- "마지막 힘을 다해 설득해보자.",
	_high = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_LOWDICE0_HIGH"), -- "이제 마지막 기회. 최선을 다해보자."
}
lowDice_Msg[2] =
{
	_low = "",
	_middle = "",
	_high = ""
}
lowDice_Msg[3] =
{
	_low = "",
	_middle = "",
	_high = ""
}
lowDice_Msg[4] =
{
	_low = "",
	_middle = "",
	_high = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_LOWDICE4_HIGH"), -- "출발이 좋으니 조급해 하지 말자."
}

highDice_Msg[1] = 
{
	_low = "",
	_middle = "",
	_high = ""
}
highDice_Msg[2] = 
{
	_low = "",
	_middle = "",
	_high = ""
}
highDice_Msg[3] = 
{
	_low = "",
	_middle = "",
	_high = ""
}
highDice_Msg[4] = 
{
	_low = "",
	_middle = "",
	_high = ""
}

local result_Msg =
{
	success = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_RESULT_MSG_SUCCESS"), -- "<PAColor0xFFFFCE22>가져온 무역품에 흔쾌히 값을 더 쳐준다.<PAOldColor>",
	fail	= PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_RESULT_MSG_FAIL"), -- "<PAColor0xFFF26A6A>흥정에 실패해 제값으로 팔 수밖에 없다.<PAOldColor>",
}

local tradeGame =
{
	_tradeGameState			= enTradeGameState.enTradeGameState_Finish,
		
	_minGoalValue 			= 0,											-- 현재 목표 값
	_maxGoalValue 			= 0,
	_tryCount				= 0,											-- 시도 횟수
	
	_currentDiceValue		= 0,											-- 현재 주사위
	
	_updownValue			= 1,												-- 위로 올라가면 1, 아래로 내려가면 -1
	_prevDiceResult 		= enTradeGameResult.enTradeGameResult_Less,			-- 이전 결과값을 저장
	_isRotateSwitch			= false,											-- 저울 움직이게 하는 스위치
}

local balanceArm		= UI.getChildControl( Panel_TradeGame, "Static_ScaleBalance_Arm" )					-- 저울 팔
local balancePlateLeft	= UI.getChildControl( Panel_TradeGame, "Static_ScaleBalance_Plate_Left" )			-- 저울 왼쪽 접시
local balancePlateRight	= UI.getChildControl( Panel_TradeGame, "Static_ScaleBalance_Plate_Right" )			-- 저울 오른쪽 접시
local balancePoll		= UI.getChildControl( Panel_TradeGame, "Static_ScaleBalance_Poll" )
local btnLowDice		= UI.getChildControl( Panel_TradeGame, "Button_TradeGame_LowDice" )					-- 흥정 버튼(소)
local btnHighDice		= UI.getChildControl( Panel_TradeGame, "Button_TradeGame_HighDice" )				-- 흥정 버튼(대)
local remainCount		= UI.getChildControl( Panel_TradeGame, "StaticText_RemainCount" )					-- 남은 횟수
local processMsg		= UI.getChildControl( Panel_TradeGame, "StaticText_ProcessMsg" )					-- 진행 메시지
local resultMsg			= UI.getChildControl( Panel_TradeGame, "StaticText_ResultMsg" )						-- 결과 메시지

local btnClose			= UI.getChildControl( Panel_TradeGame, "Button_Close" )
local btnQuestion		= UI.getChildControl( Panel_TradeGame, "Button_Question" )

local msgTooltipType = 0

btnLowDice:addInputEvent( "Mouse_LUp", "tradeGame_LowDice()" )
btnLowDice:addInputEvent( "Mouse_On", "TradeGame_HelpDesc(true," ..  1 .. ")" )
btnLowDice:addInputEvent( "Mouse_Out", "TradeGame_HelpDesc(false)" )
btnHighDice:addInputEvent( "Mouse_LUp", "tradeGame_HighDice()" )
btnHighDice:addInputEvent( "Mouse_On", "TradeGame_HelpDesc(true," ..  2 .. ")" )
btnHighDice:addInputEvent( "Mouse_Out", "TradeGame_HelpDesc(false)" )
processMsg:addInputEvent( "Mouse_On",	"TradeGame_HelpDesc(true, " .. msgTooltipType .. ")" )
processMsg:addInputEvent( "Mouse_Out",	"TradeGame_HelpDesc( false )")
btnClose:addInputEvent( "Mouse_LUp", "Fglobal_TradeGame_Close()" )
processMsg:SetAutoResize( true )
if (7 == getGameServiceType() or 8 == getGameServiceType()) and getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_CBT then
	processMsg:SetTextMode( UI_TM.eTextMode_LimitText )
else
	processMsg:SetTextMode( UI_TM.eTextMode_AutoWrap )
end

local isLowDiceClicked = nil
local tradeGameSuccess = false
local isTradeGameEnd = false
local applyRotateValue = 0.0
local deltaTimeElapsed = 0.0

local fixedDegree = 30					-- 저울 움직임 값의 고정각 30도
local startRadian = 0.0
local startDegree = -30									-- 시작 시 저울의 기울기 값

local elapsedAngle = 0.0

local leftStartPosX = 0
local leftStartPosY = 0

local rightStartPosX = 0
local rightStartPosY = 0

local centerPosX = 0
local centerPosY = 0

local halfSizeX = balancePlateRight:GetSizeX()/2

local limitAngle = 60 *  math.pi / 180

leftStartPosX = balancePlateLeft:GetPosX() + halfSizeX
leftStartPosY = balancePlateLeft:GetPosY()

rightStartPosX = balancePlateRight:GetPosX() + halfSizeX
rightStartPosY = balancePlateRight:GetPosY()

centerPosX = balanceArm:GetPosX() + (balanceArm:GetSizeX()/2)
centerPosY = balanceArm:GetPosY() + (balanceArm:GetSizeY()/2)

local resetTradeGameInfo = function()
	tradeGame._currentDiceValue = 0
	
	tradeGame._minGoalValue 	= 0
	tradeGame._maxGoalValue 	= 0
	tradeGame._updownValue		= 1

	deltaTimeElapsed = 0.0
	balanceArm:SetRotate( 0 )
	tradeGame._isRotateSwitch = false
	
	tradeGame._tradeGameState	= enTradeGameState.enTradeGameState_Finish
	tradeGame._prevDiceResult 	= enTradeGameResult.enTradeGameResult_Less
end

local tradeGameSet = 0
local setTradeGameCountrySet = function()
	if (7 == getGameServiceType() or 8 == getGameServiceType()) and getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_CBT then
		tradeGameSet = 1
		processMsg:SetIgnore( false )
	else
		tradeGameSet = 0
		processMsg:SetIgnore( true )
	end
end

----------------------------------------------------------------------------
--흥정 게임 룰
----------------------------------------------------------------------------
-- startDegree로 시작 시 저울의 기울기 설정
-- tradeGame._currentDiceValue로 시작 시 주사위 값 설정
-- lowDice 버튼 클릭 시 해당 범위에 해당하는 랜덤 값 반환(contentsOption에 있음. 현재 1~35)해서 currentDiceValue 값에 더함
-- highDice 버튼 클릭 시 해당 범위에 해당하는 랜덤 값 반환(contentsOption에 있음. 현재 35~70)해서 currentDiceValue 값에 더함
-- 기본 횟수는 4(contentsOption에서 조절 가능), 친밀도 오를 때마다 횟수 증가(contentsOption에서 조절 가능)
-- 성공 조건 : 횟수를 모두 소모하기 전에 0 +- 범위(contentsOption에 있음. 현재 5)에 _currentDiceValue가 맞춰지면 성공. 그 이외는 실패
-- 현재 기본 설정으로도 성공할 수 있음(성공 확률은 10% 미만. 횟수가 늘수록 성공확률은 비약적으로 올라감)
-- currentDiceValue가 0을 넘어가면 다음 주사위 값은 - 상태가 됨
function FromClient_TradeGameStart( minGoal, maxGoal, tryCount, startDice )
	tradeGameSuccess = false
	isTradeGameEnd = false
	resultMsg:SetShow( false )
	processMsg:SetShow( true )
	processMsg:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_PROCESSMSG") ) -- "아래 버튼을 눌러 흥정을 시작해주세요." )
	resetTradeGameInfo()
	isLowDiceClicked = nil
	
	balancePoll:EraseAllEffect()
	balanceArm:EraseAllEffect()
	resultMsg:EraseAllEffect()
	
	SetUIMode( Defines.UIMode.eUIMode_TradeGame )
	tradeGame._currentDiceValue = startDice						-- 스타트 주사위(값)
	tradeGame._minGoalValue = minGoal
	tradeGame._maxGoalValue = maxGoal
	tradeGame._tryCount = tryCount
	
	remainCount:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_TRADEGAME_REMAINCOUNT", "tryCount", tradeGame._tryCount ) ) -- "남은 횟수 : " .. tradeGame._tryCount .. "회" )
	
	Panel_TradeGame:SetShow( true )
	tradeGame._tradeGameState = enTradeGameState.enTradeGameState_Play
	
	if ( 0 < startDice ) then
		tradeGame._prevDiceResult = enTradeGameResult.enTradeGameResult_More
	else
		tradeGame._prevDiceResult = enTradeGameResult.enTradeGameResult_Less
	end
	
	startDegree = fixedDegree * startDice / 100							-- 최대 기울기 30도(100 또는 -100일 때)
	
	startRadian = startDegree *  math.pi / 180
	elapsedAngle = startDegree
	
	move_TradeGameControl(startRadian)
	processMsg:EraseAllEffect()
end

function global_Update_TradeGame( deltaTime )
	if true == tradeGame._isRotateSwitch then
		deltaTimeElapsed = deltaTimeElapsed + (deltaTime * tradeGame._updownValue)
		
		local tmepApplyAngle = startRadian + deltaTimeElapsed

		if 1 == tradeGame._updownValue then
			if applyRotateValue < tmepApplyAngle then
				tradeGame._isRotateSwitch = false
			end
		else
			if tmepApplyAngle < applyRotateValue then
				tradeGame._isRotateSwitch = false
			end
		end

		move_TradeGameControl( tmepApplyAngle )
	end
end

function rotateBalances( scaleControl, startPosX, startPosY, rotCenterPosX, rotCenterPosY, elpasedDeltaTime )
	local rotPosX = startPosX - rotCenterPosX
	local rotPosY = startPosY - rotCenterPosY
	
	local controlPosX = (rotPosX * math.cos(elpasedDeltaTime)) - (rotPosY* math.sin(elpasedDeltaTime))
	local controlPosY = (rotPosX * math.sin(elpasedDeltaTime)) + (rotPosY* math.cos(elpasedDeltaTime))

	scaleControl:SetPosX( controlPosX + rotCenterPosX - halfSizeX )
	scaleControl:SetPosY( controlPosY + rotCenterPosY )
end

function move_TradeGameControl( rateDeltaTime )
	balanceArm:SetRotate( rateDeltaTime )
	
	rotateBalances( balancePlateRight, rightStartPosX, rightStartPosY, centerPosX, centerPosY, rateDeltaTime )
	rotateBalances( balancePlateLeft, leftStartPosX, leftStartPosY, centerPosX, centerPosY, rateDeltaTime )
end

function FromClient_TradeGameReciveDice( diceValue, gameResult )
	if enTradeGameResult.enTradeGameResult_NoTryCount == gameResult or enTradeGameResult.enTradeGameResult_None == gameResult then
		tradeGame._tradeGameState = enTradeGameState.enTradeGameState_Finish
		return
	end
	
	if enTradeGameState.enTradeGameState_Play ~= tradeGame._tradeGameState then
		return
	end
	
	tradeGame._tryCount = tradeGame._tryCount - 1
	remainCount:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_TRADEGAME_REMAINCOUNT", "tryCount", tradeGame._tryCount ) ) -- "남은 횟수 : " .. tradeGame._tryCount .. "회" )
	
	-- 저울의 움직임을 위해 쓴다.
	-- 목표 보다 낮은 값
	if enTradeGameResult.enTradeGameResult_Less == tradeGame._prevDiceResult then
		tradeGame._updownValue = 1
		tradeGame._isRotateSwitch = true
	end
	
	-- 목표 이상의 값
	if enTradeGameResult.enTradeGameResult_More == tradeGame._prevDiceResult then
		tradeGame._updownValue = -1
		tradeGame._isRotateSwitch = true
	end
	
	tradeGame._prevDiceResult = gameResult
	
	elapsedAngle = elapsedAngle + ((diceValue/100*fixedDegree)*tradeGame._updownValue)
	applyRotateValue = elapsedAngle *  math.pi / 180

	-- 실제 주사위 값
	tradeGame._currentDiceValue = tradeGame._currentDiceValue + diceValue * tradeGame._updownValue

	local processText = ""
	if true == isLowDiceBtnClicked() then
		-- 로우 주사위 클릭
		if (-10 < tradeGame._currentDiceValue) and (10 > tradeGame._currentDiceValue) then
			processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICELOWVALUE_1") -- "마지막 조율은 신중히 진행하자."
			msgTooltipType = 1
		elseif (-20 < tradeGame._currentDiceValue) and (20 > tradeGame._currentDiceValue) then
			processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICELOWVALUE_2") -- "이 기세라면 좋은 결과가 기대된다."
			msgTooltipType = 2
		elseif (-30 < tradeGame._currentDiceValue) and (30 > tradeGame._currentDiceValue) then
			processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICELOWVALUE_3") -- "원하는 방향으로 잘 리드하고 있다."
			msgTooltipType = 3
		elseif (-40 < tradeGame._currentDiceValue) and (40 > tradeGame._currentDiceValue) then
			processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICELOWVALUE_4") -- "상대가 흥정에 관심을 갖기 시작했다."
			msgTooltipType = 4
		elseif (-50 < tradeGame._currentDiceValue) and (50 > tradeGame._currentDiceValue) then
			processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICELOWVALUE_5") -- "슬슬 반응을 보이기 시작했다."
			msgTooltipType = 5
		elseif (-60 < tradeGame._currentDiceValue) and (60 > tradeGame._currentDiceValue) then
			processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICELOWVALUE_6") -- "흥정 자체에 흥미가 없어 보인다."
			msgTooltipType = 6
		else
			processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_NOINTEREST") -- "얘기에 귀를 기울이지 않는다."
			msgTooltipType = 7
		end
		
	else
		-- 하이 주사위 클릭
		if (-10 < tradeGame._currentDiceValue) and (10 > tradeGame._currentDiceValue) then
			processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICEHIGHVALUE_1") -- "세부 조율만 남았으니 무리하지 말자."
			msgTooltipType = 8
		elseif (-20 < tradeGame._currentDiceValue) and (20 > tradeGame._currentDiceValue) then
			processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICEHIGHVALUE_2") -- "기세가 너무 좋다. 천천히 숨을 고르자."
			msgTooltipType = 9
		elseif (-30 < tradeGame._currentDiceValue) and (30 > tradeGame._currentDiceValue) then
			processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICEHIGHVALUE_3") -- "흥정이 의도대로 진행되고 있다."
			msgTooltipType = 10
		elseif (-40 < tradeGame._currentDiceValue) and (40 > tradeGame._currentDiceValue) then
			processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICEHIGHVALUE_4") -- "내 무역품에 점점 관심이 높아지고 있다."
			msgTooltipType = 11
		elseif (-50 < tradeGame._currentDiceValue) and (50 > tradeGame._currentDiceValue) then
			processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICEHIGHVALUE_5") -- "슬슬 흥정에 반응을 보이기 시작했다."
			msgTooltipType = 12
		elseif (-60 < tradeGame._currentDiceValue) and (60 > tradeGame._currentDiceValue) then
			processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICEHIGHVALUE_6") -- "아직 큰 관심은 없는 듯 하다."
			msgTooltipType = 13
		else
			processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_NOINTEREST") -- "얘기에 귀를 기울이지 않는다."
			msgTooltipType = 14
		end
	end
	processMsg:SetText( processText )

end

function FromClient_TradeGameResult( isSuccess )
	--_PA_LOG( "TradeG", "FromClient_TradeGameResult => isSuccess : " .. tostring( isSuccess ) )
	tradeGame._tradeGameState = enTradeGameState.enTradeGameState_Finish
	
	if true == isSuccess then
		audioPostEvent_SystemUi(11,08)
		resultMsg:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_BARGAINING_SUCCESS") ) -- "<PAColor0xFF66CC33>흥정 성공<PAOldColor>" )
		processMsg:SetText( result_Msg.success )
		tradeGameSuccess = true
		global_sellItemFromPlayer()
		--FGlobal_TradeGame_Success()
		balancePoll:AddEffect("fUI_TradeGame_BackgroundLight", true, 0, 0)
		balanceArm:AddEffect("fUI_TradeGame_EmeraldLight", true, 0, 0)
	else
		audioPostEvent_SystemUi(11,09)
		resultMsg:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_BARGAINING_FAIL") ) -- "<PAColor0xFFF26A6A>흥정 실패<PAOldColor>" )
		processMsg:SetText( result_Msg.fail )
		tradeGameSuccess = false
		balanceArm:AddEffect("fUI_TradeGame_EmeraldLight_Failed", false, 0, 0 )
	end
	resultMsg:SetVertexAniRun( "Ani_Scale_New", true )
	resultMsg:AddEffect("fUI_TradeGame_Complete", true, 0, 0)
	resultMsg:SetShow( true )
	isTradeGameEnd = true
	

	--결과 메시지

end

function tradeGame_LowDice()
	if enTradeGameState.enTradeGameState_Play ~= tradeGame._tradeGameState then
		return
	end
	
	isLowDiceClicked = true
	ToClient_TradeGameDice(enTradeGameSwitchType.enTradeGameSwitchType_Small)
end

function tradeGame_HighDice()
	if enTradeGameState.enTradeGameState_Play ~= tradeGame._tradeGameState then
		return
	end
	
	isLowDiceClicked = false
	ToClient_TradeGameDice(enTradeGameSwitchType.enTradeGameSwitchType_Large)
end

function TradeGame_HelpDesc( isShow, btnType )
	if false == isShow then
		TooltipSimple_Hide()
		return
	end
	
	local control = nil
	local helpDesc = ""
	if ( 1 == btnType ) then
		control = btnLowDice
		helpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_WARNNING_BARGAIN") -- "상대의 비위를 거스르지 않고 조심스럽게 흥정한다"
	elseif ( 2== btnType ) then
		control = btnHighDice
		helpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_STRONG_BARGAIN") -- "강한 인상을 보이며 자신감있게 흥정한다"
	elseif 0 == msgTooltipType and 1 == tradeGameSet then
		control = processMsg
		helpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_PROCESSMSG")
	elseif 1 == msgTooltipType and 1 == tradeGameSet then
		control = processMsg
		helpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICELOWVALUE_1") -- "마지막 조율은 신중히 진행하자."
	elseif 2 == msgTooltipType and 1 == tradeGameSet then
		control = processMsg
		helpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICELOWVALUE_2")
	elseif 3 == msgTooltipType and 1 == tradeGameSet then
		control = processMsg
		helpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICELOWVALUE_3")
	elseif 4 == msgTooltipType and 1 == tradeGameSet then
		control = processMsg
		helpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICELOWVALUE_4")
	elseif 5 == msgTooltipType and 1 == tradeGameSet then
		control = processMsg
		helpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICELOWVALUE_5")
	elseif 6 == msgTooltipType and 1 == tradeGameSet then
		control = processMsg
		helpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICELOWVALUE_6")
	elseif 7 == msgTooltipType and 1 == tradeGameSet then
		control = processMsg
		helpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_NOINTEREST")
	elseif 8 == msgTooltipType and 1 == tradeGameSet then
		control = processMsg
		helpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICEHIGHVALUE_1")
	elseif 9 == msgTooltipType and 1 == tradeGameSet then
		control = processMsg
		helpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICEHIGHVALUE_2")
	elseif 10 == msgTooltipType and 1 == tradeGameSet then
		control = processMsg
		helpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICEHIGHVALUE_3")
	elseif 11 == msgTooltipType and 1 == tradeGameSet then
		control = processMsg
		helpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICEHIGHVALUE_4")
	elseif 12 == msgTooltipType and 1 == tradeGameSet then
		control = processMsg
		helpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICEHIGHVALUE_5")
	elseif 13 == msgTooltipType and 1 == tradeGameSet then
		control = processMsg
		helpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICEHIGHVALUE_6")
	elseif 14 == msgTooltipType and 1 == tradeGameSet then
		control = processMsg
		helpDesc = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_NOINTEREST")
	end
	
	if nil ~= control then
		TooltipSimple_Show( control, helpDesc )
	end

end

-- 흥정게임 닫기. UI모드도 바꿔준다.
function Fglobal_TradeGame_Close()
	Panel_TradeGame:SetShow( false )
	SetUIMode( Defines.UIMode.eUIMode_Trade )
end

-- 창이 닫히면 흥정 보너스가 리셋되므로, 흥정게임 성공 여부를 false로 바꿔준다.
function FGlobal_isTradeGameSuccess()
	tradeGameSuccess = false
end

-- 흥정게임 성공 여부를 리턴한다.
function isTradeGameSuccess()
	return tradeGameSuccess
end

-- 작은 주사위를 클릭했는지 리턴
function isLowDiceBtnClicked()
	return isLowDiceClicked
end
-- 큰 주사위를 클릭했는지 리턴
function isTradeGameFinish()
	return isTradeGameEnd
end

setTradeGameCountrySet()
registerEvent( "FromClient_TradeGameStart", "FromClient_TradeGameStart" )
registerEvent( "FromClient_TradeGameResult", "FromClient_TradeGameResult" )
registerEvent( "FromClient_TradeGameReciveDice", "FromClient_TradeGameReciveDice" )