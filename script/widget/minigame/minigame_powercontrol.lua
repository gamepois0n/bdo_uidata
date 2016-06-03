-- 미니게임 14 ( 젖짜기 )


local MGKT = CppEnums.MiniGameKeyType
local MGT = CppEnums.MiniGameType


Panel_MiniGame_PowerControl:SetShow( false )
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local ui =
{
	_gauge_L_BG			= UI.getChildControl ( Panel_MiniGame_PowerControl, "Static_PowerGauge_BG_L" ),
	_gauge_R_BG			= UI.getChildControl ( Panel_MiniGame_PowerControl, "Static_PowerGauge_BG_R" ),
	_gaugeDanger_L		= UI.getChildControl ( Panel_MiniGame_PowerControl, "Static_Danger_L" ),
	_gaugeDanger_R		= UI.getChildControl ( Panel_MiniGame_PowerControl, "Static_Danger_R" ),
	_gauge_L			= UI.getChildControl ( Panel_MiniGame_PowerControl, "Progress2_PowerGauge_L" ),
	_gauge_R			= UI.getChildControl ( Panel_MiniGame_PowerControl, "Progress2_PowerGauge_R" ),
	_gaugeDeco_L		= UI.getChildControl ( Panel_MiniGame_PowerControl, "Static_Cow_Deco_L" ),
	_gaugeDeco_R		= UI.getChildControl ( Panel_MiniGame_PowerControl, "Static_Cow_Deco_R" ),
	_milky_L			= UI.getChildControl ( Panel_MiniGame_PowerControl, "Static_MilkyLeft" ),
	_milky_R			= UI.getChildControl ( Panel_MiniGame_PowerControl, "Static_MilkyRight" ),
	
	_txt_MilkyRate		= UI.getChildControl ( Panel_MiniGame_PowerControl, "StaticText_MilkyRate" ),

	_mouse_L			= UI.getChildControl ( Panel_MiniGame_PowerControl, "Static_L_Btn_L" ),
	_mouse_R			= UI.getChildControl ( Panel_MiniGame_PowerControl, "Static_R_Btn_R" ),
	
	_gameTimer			= UI.getChildControl ( Panel_MiniGame_PowerControl, "StaticText_Timer" ),
	
	_result_Success		= UI.getChildControl ( Panel_MiniGame_PowerControl, "Static_Result_Success" ),
	_resultFailed		= UI.getChildControl ( Panel_MiniGame_PowerControl, "Static_Result_Failed" ),
	
	_progress_Milk		= UI.getChildControl ( Panel_MiniGame_PowerControl, "Progress2_Milk" ),
	
}


local gameMode = 0

local directionType = 0
-- 0 : 마우스 왼쪽만 먹음
-- 1 : 마우스 오른쪽만 먹음

local milkRate = -1				-- 토탈 우유량
local leftMilkyRate 	= 1 	-- 왼쪽 우유량
local rightMilkyRate 	= 1 	-- 오른쪽 우유량

local isPlayingMilky = false
local currTime = -1
local gameEndTimer = 21
local endTimer = 0
local isSuccess = false

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------
--					젖짜기 초기화 함수
---------------------------------------------------------
local isPressed_L = false
local isPressed_R = false

local onKeyDown = function( keyType )
	if ( MGKT.MiniGameKeyType_M0 == keyType ) then
		isPressed_L = true
	elseif ( MGKT.MiniGameKeyType_M1 == keyType ) then
		isPressed_R = true
	end
end

local onKeyUp = function( keyType )
	if ( MGKT.MiniGameKeyType_M0 == keyType ) then
		-- ♬ 젖짜
		audioPostEvent_SystemUi(11,05)
	
		isPressed_L = false
		directionType = 1

		ui._gauge_L_BG:SetAlpha( 0.6 )
		ui._gauge_L:SetAlpha( 0.6 )
		ui._gaugeDeco_L:SetAlpha( 0.6 )
		ui._gauge_R_BG:SetAlpha( 1 )
		ui._gauge_R:SetAlpha( 1 )
		ui._gaugeDeco_R:SetAlpha( 1 )

		
	elseif ( MGKT.MiniGameKeyType_M1 == keyType ) then
		-- ♬ 젖짜
		audioPostEvent_SystemUi(11,05)
		
		isPressed_R = false
		directionType = 0

		ui._gauge_L_BG:SetAlpha( 1 )
		ui._gauge_L:SetAlpha( 1 )
		ui._gaugeDeco_L:SetAlpha( 1 )
		ui._gauge_R_BG:SetAlpha( 0.6 )
		ui._gauge_R:SetAlpha( 0.6 )
		ui._gaugeDeco_R:SetAlpha( 0.6 )
	end
end


function Panel_MiniGame_PowerControl_Initialize()
	ui._gauge_L:SetProgressRate( 100 )
	ui._gauge_R:SetProgressRate( 100 )
	
	leftMilkyRate = 100
	rightMilkyRate = 100
	
	ui._gauge_L_BG:SetAlpha( 1 )
	ui._gauge_L:SetAlpha( 1 )
	ui._gaugeDeco_L:SetAlpha( 1 )
	ui._gauge_R_BG:SetAlpha( 0.6 )
	ui._gauge_R:SetAlpha( 0.6 )
	ui._gaugeDeco_R:SetAlpha( 0.6 )
	ui._gameTimer:SetShow( true )
	
	ui._milky_L:SetShow( false )
	ui._milky_R:SetShow( false )
	
	directionType = 0
	milkRate = 0
	gameEndTimer = 31
	endTimer = 0
	
	ui._progress_Milk:SetProgressRate( milkRate )
	
	ui._result_Success:SetShow( false )
	ui._resultFailed:SetShow( false )
	
	AddMiniGameKeyDownOnce( MGT.MiniGameType_14, onKeyDown )
	AddMiniGameKeyUp( MGT.MiniGameType_14, onKeyUp )

end


---------------------------------------------------------
--					젖짜기 시작~
---------------------------------------------------------
function Panel_MiniGame_PowerControl_Start()
	Panel_MiniGame_PowerControl_Initialize()
	Panel_MiniGame_PowerControl:SetShow( true )
	
	isPlayingMilky = true
	isSuccess = false
end


---------------------------------------------------------
--					젖짜기 종료~
---------------------------------------------------------
function Panel_MiniGame_PowerControl_End()
	getSelfPlayer():get():SetMiniGameResult( 4 )	-- 종료할 때 플레이어 상태를 원상복구 시켜준다
	Panel_MiniGame_PowerControl:SetShow( false )
	isPlayingMilky = false
	isSuccess = false

end


---------------------------------------------------------
--			결과 함수를 매시간 체크한다~!
---------------------------------------------------------
function Panel_MIniGame_PowerControl_Result( deltaTime )
	endTimer = endTimer + deltaTime
	local _endTimer =  math.floor( endTimer )

	gameEndTimer = 0
	ui._gameTimer:SetText( "" )

	---------------------------------------
	--		우유의 양을 직접 계산해본다
	if ( milkRate == 100 ) and ( 0.01 > _endTimer ) then
		Panel_MiniGame_PowerControl_Success()
	elseif ( 99 >= milkRate ) and ( 0.01 > _endTimer ) then
		Panel_MiniGame_PowerControl_Failed()
	end

	---------------------------------------
	--			끝내기 위한 조건
	if ( _endTimer >= 2 ) then
		Panel_MiniGame_PowerControl_End()
	end
end

local isFullMilk = false
---------------------------------------------------------
--				미니게임에 성공했을 때
---------------------------------------------------------
function Panel_MiniGame_PowerControl_Success()
	-- 여러 번 함수가 실행돼도 한 번만 돌도록 구문 추가, 게임 스타트 시 변수 초기화
	if false == isSuccess then
		isSuccess = true
	else
		return
	end

	-- ♬ 젖짜 성공 사운드
	audioPostEvent_SystemUi(11,13)
	
	if(true == isPlayingMilky) then
		ToClient_MinigameResult(1, true)
		FGlobal_MiniGame_PowerControl()						-- 퀘스트 클리어 체크용
	end
	
	isPlayingMilky = false
	ui._gameTimer:SetShow( false )
	getSelfPlayer():get():SetMiniGameResult( 0 )		-- 성공
	ui._result_Success:ResetVertexAni()
	ui._result_Success:SetVertexAniRun( "Good_Ani", true )
	ui._result_Success:SetShow( true )
	
	ui._milky_L:SetShow( false )
	ui._milky_R:SetShow( false )
	
	isFullMilk = true
end


---------------------------------------------------------
--				미니게임에 실패했을 때
---------------------------------------------------------
function Panel_MiniGame_PowerControl_Failed()
	-- ♬ 젖짜 실패 사운드
	audioPostEvent_SystemUi(11,02)
	
	if(true == isPlayingMilky) then
		ToClient_MinigameResult(1, false)
	end
	
	isPlayingMilky = false
	directionType = -1
	isPressed_L = false
	isPressed_R = false
	ui._gameTimer:SetShow( false )
	getSelfPlayer():get():SetMiniGameResult( 1 )		-- 실패
	ui._resultFailed:ResetVertexAni()
	ui._resultFailed:SetVertexAniRun( "Bad_Ani", true )
	ui._resultFailed:SetShow( true )
	
	ui._milky_L:SetShow( false )
	ui._milky_R:SetShow( false )
end


---------------------------------------------------------
--				우측 게이지 채워주기
---------------------------------------------------------
local leftMilkyRate_Timer = 0
local rightMilkyRate_Timer = 0
local updateRightMilky = function( value )
	rightMilkyRate =  math.max( math.min( rightMilkyRate + value, 100 ), 0 )
	ui._gauge_R:SetProgressRate( rightMilkyRate )
	ui._gaugeDanger_L:SetAlpha( 0.88 - (leftMilkyRate * 0.01) )
end


---------------------------------------------------------
--				좌측 게이지 채워주기
---------------------------------------------------------
local updateLeftMilky = function( value )
	leftMilkyRate = math.max(math.min(leftMilkyRate + value, 100), 0)
	ui._gauge_L:SetProgressRate( leftMilkyRate )
	ui._gaugeDanger_R:SetAlpha( 0.88 - (rightMilkyRate * 0.01) )
end


---------------------------------------------------------
--			마우스를 누를 때마다 젖을 짠다!
---------------------------------------------------------
function Panel_MiniGame_PowerControl_MouseClick_UpdateFunc( deltaTime )
	currTime = currTime + deltaTime
	gameEndTimer = gameEndTimer - deltaTime
	local _gameEndTimer =  math.floor( gameEndTimer )
	
	----------------------------------------------------------------
	--				실제 입력하고 있는 버튼 체크
	ui._txt_MilkyRate:SetText( math.floor(milkRate) .. " %" )
	-- UI.debugMessage( tostring(isPressed_L) .. "    " ..tostring(isPressed_R) .. "    " .. directionType )
	if ( isPressed_L ) and ( 0 == directionType ) then
		updateLeftMilky( -175 * deltaTime )		-- 숫자가 작아질 수록 더 많이 단다
		updateRightMilky( 65 * deltaTime )		-- 수치가 늘어날 수록 게이지가 빨리 찬다
		milkRate = milkRate + 0.3

		ui._mouse_L:ResetVertexAni()
		ui._mouse_L:SetVertexAniRun( "Ani_Color_Left", true )
		ui._milky_L:SetShow( true )
		ui._milky_R:SetShow( false )
		
		ui._progress_Milk:SetProgressRate( milkRate )
	elseif ( isPressed_R ) and ( 1 == directionType ) then
		updateRightMilky( -175 * deltaTime )	-- 숫자가 작아질 수록 더 많이 단다
		updateLeftMilky( 65 * deltaTime )		-- 수치가 늘어날 수록 게이지가 빨리 찬다
		milkRate = milkRate + 0.3
		
		ui._mouse_R:ResetVertexAni()
		ui._mouse_R:SetVertexAniRun( "Ani_Color_Right", true )
		ui._milky_L:SetShow( false )
		ui._milky_R:SetShow( true )
		
		ui._progress_Milk:SetProgressRate( milkRate )
		
	else
		updateLeftMilky( 65 * deltaTime )		-- 수치가 늘어날 수록 게이지가 빨리 찬다
		updateRightMilky( 65 * deltaTime )		-- 수치가 늘어날 수록 게이지가 빨리 찬다
		ui._milky_L:SetShow( false )
		ui._milky_R:SetShow( false )
	end
	
	
	----------------------------------------
	--			타이머를 보여준다
	if ( isPlayingMilky == true ) then
		ui._gameTimer:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MINIGAME_POWERCONTROL_REMAINTIME", "gameEndTimer", _gameEndTimer ) ) -- 남은 시간: {gameEndTimer}초
	end
	
	-----------------------------------------------
	--		좌/우를 구분하여 게이지를 채운다!!
	isFullMilk = false
	if ( milkRate >= 100 ) then
		milkRate = 100
		isFullMilk = true
		--Panel_MiniGame_PowerControl_Success()
	end
	
	---------------------------------------
	--		우유를 다 짰다! 실패!
	if ( 1 >= leftMilkyRate ) then
		Panel_MiniGame_PowerControl_Failed()
	elseif ( 1 >= rightMilkyRate ) then
		Panel_MiniGame_PowerControl_Failed()
	end
	
	---------------------------------------
	--			시간을 검사한다!
	if ( 0.0 >= _gameEndTimer ) or ( true == isFullMilk )then
		Panel_MIniGame_PowerControl_Result( deltaTime )
	end
end


---------------------------------------------------------
--			어떤 마우스를 눌렀는지 체크하자!
---------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Panel_MiniGame_PowerControl_Initialize()
Panel_MiniGame_PowerControl:RegisterUpdateFunc("Panel_MiniGame_PowerControl_MouseClick_UpdateFunc")

