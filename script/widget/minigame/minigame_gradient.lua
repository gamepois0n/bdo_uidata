-- 미니게임 타입 0 (기울기)

Panel_Minigame_Gradient:SetShow(false, false)

local MGKT = CppEnums.MiniGameKeyType

local _LButton_L 		= UI.getChildControl ( Panel_Minigame_Gradient, "Static_L_Btn_L" )
local _RButton_R 		= UI.getChildControl ( Panel_Minigame_Gradient, "Static_R_Btn_R" )
local _gaugeBG	 		= UI.getChildControl ( Panel_Minigame_Gradient, "Static_GaugeBG" )
local _gaugeBar 		= UI.getChildControl ( Panel_Minigame_Gradient, "Static_GaugeBar" )

local _fontGood			= UI.getChildControl ( Panel_Minigame_Gradient, "Static_Result_Good" )
local _fontBad 			= UI.getChildControl ( Panel_Minigame_Gradient, "Static_Result_Bad" )

local _math_random = math.random
local _math_randomseed = math.randomseed
local _math_lerp = Util.Math.Lerp

local ClickDirection =
{
	None = 0,
	Left = -1,
	Right = 1,
}

-- 설정하는 고정값.
local define =
{
	sequenceClickTimeSpan = 1.0,	-- 초단위. 이 시간 이내에 다른 클릭이 들어오면, 가속도 가중치를 더 크게 한다! 더블 클릭을 인식하는 시간.
	ClickTimeSpanMaxWeight = 0.35,	-- sequenceClickTimeSpan 이내에 재클릭이 들어왔을 때, 최대 속도 변경량
	ClickTimeSpanMinWeight = 0.15,	-- sequenceClickTimeSpan 이내에 재클릭이 들어왔을 때, 최소 속도 변경량
	speedWeight = 1,				-- 클릭이 없을시, 기본 속도 변경 가중치 (난이도 조정용 : 클 수록 커서가 빨리 움직인다)

	gageSize = Panel_Minigame_Gradient:GetSizeX()
}
_gaugeBar:SetPosY ( 4 )

-- 연산되는 변경되는 값.
local data = 
{
	currentPos = 0.5,				-- 현재 position 0 <= x <= 1
	lastClickTime = 0,				-- 마지막 클릭이 일어난 후의 누적시간!
	lastClickDirection = 0,			-- 마지막 클릭 방향. -1 이면 왼쪽, 1 이면 오른쪽. 0 이면 첫 클릭임.
	currentSpeed = 0,				-- 현재 Gage 의 초당 이동 속도. 음수이면 왼쪽으로, 양수이면 오른쪽으로 기우는 중이다!
}

local isGradientPlay = false

function MiniGame_GaugeBarMoveCalc( fDeltaTime )
	data.lastClickTime = data.lastClickTime + fDeltaTime		-- 클릭 타임 누적!
	local currentPos = data.currentPos + data.currentSpeed * fDeltaTime
	-- UI.debugMessage( 'CurPos : ' .. currentPos .. ' / CurSpeed : ' .. data.currentSpeed .. ' / fDeltaTime : ' .. fDeltaTime )
	if currentPos < 0 then
		currentPos = 0
		getSelfPlayer():get():SetMiniGameResult( 0 )
		-- UI.debugMessage( 'Left End!!!!' )
		-- 끝났을 때 추가 코드
	elseif 1 < currentPos then
		currentPos = 1
		getSelfPlayer():get():SetMiniGameResult( 3 )
		-- 끝났을 때 추가 코드
	end
	data.currentPos = currentPos
	-- 현재 위치에 따라 속도를 재계산
	-- 0.5 기준으로 왼쪽에 게이지가 있으면 왼쪽으로 치우치도록 한다! (중앙에서 밀어내는 구조!)
	data.currentSpeed = data.currentSpeed - (0.5 - currentPos) * define.speedWeight * fDeltaTime

	local controlPos = _math_lerp( 33, 250, currentPos )
	if (controlPos < 90) or (195 < controlPos) then
		if _fontBad:GetShow() == false then
			-- ♬ 실패 사운드
			audioPostEvent_SystemUi(11,02)
			
			_fontBad:SetShow(true, true)
			_fontGood:SetShow(false, true)
			_fontBad:ResetVertexAni()
			_fontBad:SetVertexAniRun( "Bad_Ani", true )
			_fontBad:SetVertexAniRun( "Bad_ScaleAni", true )

			if (controlPos < 90) then
				-- ♬ 어어어어 넘어간다
				audioPostEvent_SystemUi(11,02)
				
				getSelfPlayer():get():SetMiniGameResult( 1 )		-- 좌로 삐끗
			else
				-- ♬ 어어어어 넘어간다
				audioPostEvent_SystemUi(11,02)
				
				getSelfPlayer():get():SetMiniGameResult( 2 )		-- 우로 삐끗
			end
		end
	else
		if _fontGood:GetShow() == false then
			-- ♬ 성공 사운드
			audioPostEvent_SystemUi(11,01)
			
			getSelfPlayer():get():SetMiniGameResult( 4 )
			_fontBad:SetShow(false, true)
			_fontGood:SetShow(true, true)
			_fontGood:ResetVertexAni()
			_fontGood:SetVertexAniRun( "Good_Ani", true )
			_fontGood:SetVertexAniRun( "Good_ScaleAni", true )
		end
	end
	_gaugeBar:SetPosX ( controlPos )
end


function Panel_Minigame_Gradient_Start()
	Panel_Minigame_Gradient:SetShow( true, false )
	Panel_Minigame_Gradient:RegisterUpdateFunc("Panel_Minigame_UpdateFunc")

	_gaugeBar:SetPosX ( centerPos )
	_math_randomseed( os.time() )
	local speed = _math_random()
	data.currentSpeed = (speed - 0.5) / 4

	data.lastClickDirection = ClickDirection.None
	data.lastClickTime = 0
	data.currentPos = 0.5
	isGradientPlay = true

end

function Panel_Minigame_Gradient_End()
	Panel_Minigame_Gradient:RegisterUpdateFunc("")
	Panel_Minigame_Gradient:SetShow( false, false )
	isGradientPlay = false
end

local Panel_Minigame_Gradient_GaugeMove_Left = function()
	local lastClickDirection = data.lastClickDirection
	data.lastClickDirection = ClickDirection.Left

	local speedWeight = define.ClickTimeSpanMinWeight
	if (ClickDirection.Left == lastClickDirection) and (data.lastClickTime < define.sequenceClickTimeSpan) then
		speedWeight = _math_lerp( define.ClickTimeSpanMaxWeight, define.ClickTimeSpanMinWeight, data.lastClickTime / define.sequenceClickTimeSpan )
		data.lastClickDirection = ClickDirection.None
	end
	data.currentSpeed = data.currentSpeed - speedWeight
	data.lastClickTime = 0

	_LButton_L:ResetVertexAni()
	_LButton_L:SetVertexAniRun( "Ani_Color_Left", true )
end

local Panel_Minigame_Gradient_GaugeMove_Right = function()
	local lastClickDirection = data.lastClickDirection
	data.lastClickDirection = ClickDirection.Right

	local speedWeight = define.ClickTimeSpanMinWeight
	if (ClickDirection.Right == lastClickDirection) and (data.lastClickTime < define.sequenceClickTimeSpan) then
		speedWeight = _math_lerp( define.ClickTimeSpanMaxWeight, define.ClickTimeSpanMinWeight, data.lastClickTime / define.sequenceClickTimeSpan )
		data.lastClickDirection = ClickDirection.None
	end
	data.currentSpeed = data.currentSpeed + speedWeight
	data.lastClickTime = 0

	_RButton_R:ResetVertexAni()
	_RButton_R:SetVertexAniRun( "Ani_Color_Right", true )
end

function MiniGame_Gradient_KeyPress( keyType )
	if not isGradientPlay then
		return;
	end

	if MGKT.MiniGameKeyType_M0 == keyType then
		Panel_Minigame_Gradient_GaugeMove_Left()
	elseif MGKT.MiniGameKeyType_M1 == keyType then
		Panel_Minigame_Gradient_GaugeMove_Right()
	end
end

registerEvent("EventActionMiniGameKeyDownOnce",	"MiniGame_Gradient_KeyPress")
