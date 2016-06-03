-- 미니게임 타입 6 (기울기 Y축 버전)

Panel_MiniGame_Gradient_Y:SetShow(false, false)

local MGKT = CppEnums.MiniGameKeyType

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local ui = {
	_keyUp		 		= UI.getChildControl ( Panel_MiniGame_Gradient_Y, "Static_Key_Up" ),
	_keyDown 			= UI.getChildControl ( Panel_MiniGame_Gradient_Y, "Static_Key_Down" ),
	_keyUp_Eff 			= UI.getChildControl ( Panel_MiniGame_Gradient_Y, "Static_Key_Up_Eff" ),
	_keyDown_Eff 		= UI.getChildControl ( Panel_MiniGame_Gradient_Y, "Static_Key_Down_Eff" ),
	_gaugeBG	 		= UI.getChildControl ( Panel_MiniGame_Gradient_Y, "Static_GradientY_BG" ),
	_gaugeCursor 		= UI.getChildControl ( Panel_MiniGame_Gradient_Y, "Static_GradientY_Cur" ),
	_fontGood			= UI.getChildControl ( Panel_MiniGame_Gradient_Y, "Static_Result_Good" ),
	_fontBad 			= UI.getChildControl ( Panel_MiniGame_Gradient_Y, "Static_Result_Bad" ),
}

local KeyDirection =
{
	None = 0,
	Up = -1,
	Down = 1,
}

local _math_random = math.random
local _math_randomseed = math.randomseed
local _math_lerp = Util.Math.Lerp

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- 설정하는 고정값.
local define =
{
	sequenceClickTimeSpan = 1.1,	-- 초단위. 이 시간 이내에 다른 클릭이 들어오면, 가속도 가중치를 더 크게 한다! 더블 클릭을 인식하는 시간.
	ClickTimeSpanMaxWeight = 0.25,	-- sequenceClickTimeSpan 이내에 재클릭이 들어왔을 때, 최대 속도 변경량
	ClickTimeSpanMinWeight = 0.15,	-- sequenceClickTimeSpan 이내에 재클릭이 들어왔을 때, 최소 속도 변경량
	speedWeight = 5,				-- 클릭이 없을시, 기본 속도 변경 가중치 (난이도 조정용 : 클 수록 커서가 빨리 움직인다)

	gageSize = Panel_MiniGame_Gradient_Y:GetSizeY()
}
ui._gaugeCursor:SetPosX ( -42 )

-- 연산되는 변경되는 값.
local data = 
{
	currentPos = 0.5,				-- 현재 position 0 <= x <= 1
	lastClickTime = 0,				-- 마지막 클릭이 일어난 후의 누적시간!
	lastKeyDirection = 0,			-- 마지막 클릭 방향. -1 이면 왼쪽, 1 이면 오른쪽. 0 이면 첫 클릭임.
	currentSpeed = 0,				-- 현재 Gage 의 초당 이동 속도. 음수이면 왼쪽으로, 양수이면 오른쪽으로 기우는 중이다!
}

local isGradientYPlay = false

function MiniGame_GaugeBarMoveCalcY( fDeltaTime )
	data.lastClickTime = data.lastClickTime + fDeltaTime		-- 클릭 타임 누적!
	local currentPos = data.currentPos + data.currentSpeed * fDeltaTime
	if currentPos < 0 then
		currentPos = 0
	elseif 1 < currentPos then
		currentPos = 1
	end
	data.currentPos = currentPos
	-- 현재 위치에 따라 속도를 재계산
	-- 0.5 기준으로 왼쪽에 게이지가 있으면 왼쪽으로 치우치도록 한다! (중앙에서 밀어내는 구조!)
	data.currentSpeed = data.currentSpeed - (0.5 - currentPos) * define.speedWeight * fDeltaTime

	local controlPos = _math_lerp( 7, 254, currentPos )
	if ( controlPos < 58 ) or ( 184 < controlPos) then
		if ui._fontBad:GetShow() == false then
			-- ♬ 실패 사운드
			audioPostEvent_SystemUi(11,02)
				
			ui._fontBad:SetShow(true, true)
			ui._fontGood:SetShow(false, true)
			ui._fontBad:ResetVertexAni()
			ui._fontBad:SetVertexAniRun( "Bad_Ani", true )
			ui._fontBad:SetVertexAniRun( "Bad_ScaleAni", true )

			if ( controlPos < 58 ) then
				-- ♬ 어어어어 넘어갈라
				audioPostEvent_SystemUi(11,02)
				
				getSelfPlayer():get():SetMiniGameResult( 1 )		-- 말이 앞으로 자빠진다!
			elseif ( 184 < controlPos) then
				-- ♬ 어어어어 넘어갈라
				audioPostEvent_SystemUi(11,02)
				
				getSelfPlayer():get():SetMiniGameResult( 2 )		-- 말이 뒤로 자빠진다!
			end
		end
	else
		if ui._fontGood:GetShow() == false then
			-- ♬ 성공 사운드
			audioPostEvent_SystemUi(11,01)
			
			ui._fontBad:SetShow(false, true)
			ui._fontGood:SetShow(true, true)
			ui._fontGood:ResetVertexAni()
			ui._fontGood:SetVertexAniRun( "Good_Ani", true )
			ui._fontGood:SetVertexAniRun( "Good_ScaleAni", true )
		end
	end
	ui._gaugeCursor:SetPosY ( controlPos )
end

function Panel_Minigame_GradientY_Start()
	Panel_MiniGame_Gradient_Y:SetShow( true, false )
	Panel_MiniGame_Gradient_Y:RegisterUpdateFunc("Panel_Minigame_UpdateFunc")

	ui._keyUp_Eff:SetShow(false)
	ui._keyDown_Eff:SetShow(false)
	
	ui._gaugeCursor:SetPosY ( centerPos )
	_math_randomseed( os.time() )
	local speed = _math_random()
	data.currentSpeed = (speed - 0.35) / 1.6

	data.lastKeyDirection = KeyDirection.None
	data.lastClickTime = 0
	data.currentPos = 0.5
	isGradientYPlay = true
end

function Panel_Minigame_GradientY_End()
	-- UI.debugMessage("end")
	Panel_MiniGame_Gradient_Y:RegisterUpdateFunc("")
	Panel_MiniGame_Gradient_Y:SetShow( false, false )
	isGradientYPlay = false
end

--위로 눌렀을 때
local Panel_Minigame_GradientY_GaugeMove_Up = function()
	local lastKeyDirection = data.lastKeyDirection
	data.lastKeyDirection = KeyDirection.Up

	local speedWeight = define.ClickTimeSpanMinWeight
	if (KeyDirection.Up == lastKeyDirection) and (data.lastClickTime < define.sequenceClickTimeSpan) then
		speedWeight = _math_lerp( define.ClickTimeSpanMaxWeight, define.ClickTimeSpanMinWeight, data.lastClickTime / define.sequenceClickTimeSpan )
		data.lastKeyDirection = KeyDirection.None
		-- UI.debugMessage( tostring(data.lastKeyDirection) .. '/' .. speedWeight)
	end
	data.currentSpeed = data.currentSpeed - speedWeight
	data.lastClickTime = 0

	ui._keyUp:ResetVertexAni()
	ui._keyUp:SetVertexAniRun( "Ani_Color_Up", true )
	ui._keyUp_Eff:SetShow(true)
	ui._keyUp_Eff:ResetVertexAni()
	ui._keyUp_Eff:SetVertexAniRun( "Ani_Color_UpEff", true )
end

--아래로 눌렀을 때
local Panel_Minigame_GradientY_GaugeMove_Down = function()
	local lastKeyDirection = data.lastKeyDirection
	data.lastKeyDirection = KeyDirection.Down

	local speedWeight = define.ClickTimeSpanMinWeight
	if (KeyDirection.Down == lastKeyDirection) and (data.lastClickTime < define.sequenceClickTimeSpan) then
		speedWeight = _math_lerp( define.ClickTimeSpanMaxWeight, define.ClickTimeSpanMinWeight, data.lastClickTime / define.sequenceClickTimeSpan )
		data.lastKeyDirection = KeyDirection.None
	end
	data.currentSpeed = data.currentSpeed + speedWeight
	data.lastClickTime = 0

	ui._keyDown:ResetVertexAni()
	ui._keyDown:SetVertexAniRun( "Ani_Color_Down", true )
	ui._keyDown_Eff:SetShow(true)
	ui._keyDown_Eff:ResetVertexAni()
	ui._keyDown_Eff:SetVertexAniRun( "Ani_Color_DownEff", true )
end

function MiniGame_GradientY_KeyPress( keyType )
	if not isGradientYPlay then
		return;
	end

	if MGKT.MiniGameKeyType_W == keyType then
		Panel_Minigame_GradientY_GaugeMove_Up()
	elseif MGKT.MiniGameKeyType_S == keyType then
		Panel_Minigame_GradientY_GaugeMove_Down()
	end
end

registerEvent("EventActionMiniGameKeyDownOnce",	"MiniGame_GradientY_KeyPress")
