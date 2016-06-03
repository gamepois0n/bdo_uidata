-- 미니게임 타입 11 (타이밍 맞추기 게임)

local MGKT = CppEnums.MiniGameKeyType
local UI_color 		= Defines.Color

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local ui = {
	_timingBG		 				= UI.getChildControl ( Panel_MiniGame_Timing, "Static_Timing_BG" ),
	_timingProgress		 			= UI.getChildControl ( Panel_MiniGame_Timing, "Progress2_Timing" ),
	_timingProgress_Head			= nil,
	_timing		 					= UI.getChildControl ( Panel_MiniGame_Timing, "Static_Timing" ),
	_helpArrow		 				= UI.getChildControl ( Panel_MiniGame_Timing, "Static_Arrows" ),
	_spaceBar		 				= UI.getChildControl ( Panel_MiniGame_Timing, "Static_SpaceBar" ),
	_spaceBar_Eff		 			= UI.getChildControl ( Panel_MiniGame_Timing, "Static_SpaceBar_Eff" ),
	_purposeText		 			= UI.getChildControl ( Panel_MiniGame_Timing, "StaticText_Purpose" ),
	
	_result_Good		 			= UI.getChildControl ( Panel_MiniGame_Timing, "Static_Result_Good" ),
	_result_Bad		 				= UI.getChildControl ( Panel_MiniGame_Timing, "Static_Result_Bad" ),
	_resultText		 				= UI.getChildControl ( Panel_MiniGame_Timing, "StaticText_ResultTxt" ),
}

local _math_random = math.random
local _math_randomSeed = math.randomseed
local _math_lerp = Util.Math.Lerp

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 설정하는 고정값.
local define =
{
	progressBar_SpeedPerSec = 0.95,
	progressBar_speedValue3 = 0.9,
	progressBar_speedValue2 = 0.1,
	progressBar_speedValue1 = 0.0, 	-- 1,2,3들의 합이 1이어야함.
	timing_min = 0.3,				-- 성공 칸의 최소 사이즈
	timing_max = 0.4,				-- 성공 칸의 최대 사이즈
	timing_Middle = 0.75,			-- 성공 칸의 위치
	timing_Movingmax = 0.95,
	timing_movingSpeed = 2.0,
	timing_Speed = 2.0,				-- 성공 칸이 움직이는 속도
	endAnimationTime = 2.0
}

local currentTimingValue = 0
local currentProgressValue = 0
local isUpTiming = true
local isUpProgress = true
local doMoving = true
local playMode = 0
	-- 0 Ready
	-- 1 play
	-- 2 end Animation
	-- 3 end
local progressBarSpeed = 0
local sumTime = 0 
local isWin = false
local herbMachine_WinCount = 0

-- 바가 이동시작하는지 여부 ( 스페이스바를 누르면 이동하기 시작함 )
local isBarMoveStart = false

-- 게임 스텝이 처음으로 돌아갔을때 값 초기화 하는 부분
local initValue = function()
	isBarMoveStart = false
	isUpTiming = true
	isUpProgress = true
	sumTime = 0 
	progressBarSpeed = 0
	isWin = false
end

local init_HerbMachine = function()
	ui._timingProgress_Head = UI.getChildControl ( ui._timingProgress, "Progress2_1_Timing_Head" )

	Panel_MiniGame_Timing:SetShow(false, false)
	Panel_MiniGame_Timing:RegisterUpdateFunc("Panel_Minigame_UpdateFunc")
	-- Panel_Minigame_Timing_Start()
end

function ScreenSize_RePosition_HerbMachineGame()
	local scrX = getScreenSizeX()
	local scrY = getScreenSizeY()
	
	Panel_MiniGame_Timing:SetPosX( scrX / 2 + 200 )
	Panel_MiniGame_Timing:SetPosY ( scrY / 2 - 150 )
end

local endUIShow_HerbMachine = function( controlText, controlResult, color, text, aniText )
	ui._resultText:ResetVertexAni()
	ui._resultText:SetVertexAniRun("Ani_Color_empty", true)
	ui._resultText:SetVertexAniRun("Ani_Color_1", true)
	ui._resultText:SetVertexAniRun("Ani_Scale_0", true)
	ui._resultText:SetVertexAniRun("Ani_Scale_1", true)
	ui._resultText:SetVertexAniRun("Ani_Scale_End", true)
	ui._resultText:SetVertexAniRun("Ani_Color_End", true)
	
	controlText:SetShow(true)
	controlText:SetText (text)
	controlText:SetFontColor(color)
	
	controlResult:SetShow(true)
	controlResult:ResetVertexAni()
	controlResult:SetVertexAniRun( aniText .. "_Ani", true)
	controlResult:SetVertexAniRun( aniText .. "_ScaleAni", true)
end

local successUIShow = function()
	-- ♬ 성공 사운드
	audioPostEvent_SystemUi(11,01)
	
	endUIShow_HerbMachine( ui._resultText, ui._result_Good, UI_color.C_FF96D4FC, PAGetString(Defines.StringSheet_GAME, "Lua_Minigame_HerbMachine_0"), "Good" )	-- "기계를 성공적으로 작동 시켰습니다!"
end

local failedUIShow_HerbMachine = function()
	-- ♬ 실패 사운드
	audioPostEvent_SystemUi(11,02)
			
	endUIShow_HerbMachine( ui._resultText, ui._result_Bad, UI_color.C_FFF26A6A, PAGetString(Defines.StringSheet_GAME, "Lua_Minigame_HerbMachine_1"), "Bad" )	-- "기계 작동에 실패 했습니다!"
end

local timing_update_HerbMachine = function(deltaTime)
	local sizeY = ui._timingProgress:GetSizeY() * ( define.timing_min + ( define.timing_max - define.timing_min ) * currentTimingValue )
	ui._timing:SetSize( ui._timing:GetSizeX(), sizeY )
	
	local percent = 1 - ( define.timing_Middle ) 
	ui._timing:SetPosY( percent * ui._timingProgress:GetSizeY() - sizeY /2 )
	
	ui._helpArrow:SetPosY(percent * ui._timingProgress:GetSizeY() - ui._helpArrow:GetSizeY() /2)
	ui._spaceBar:SetPosY(percent * ui._timingProgress:GetSizeY() - ui._spaceBar:GetSizeY() /2)
	ui._spaceBar_Eff:SetPosY(percent * ui._timingProgress:GetSizeY() - ui._spaceBar_Eff:GetSizeY() /2)
end

local progressbar_update_HurbMachine = function( deltaTime )
	ui._timingProgress:SetProgressRate( currentProgressValue * 100 )
	ui._timingProgress:SetCurrentProgressRate( currentProgressValue * 100 )
end

local playingUpdate_HurbMachine = function(deltaTime)
	if isUpTiming then
		currentTimingValue = currentTimingValue + deltaTime * define.timing_Speed
		if ( 1 < currentTimingValue ) then
			currentTimingValue = 2 - ( currentTimingValue )
			isUpTiming = false
		end
	else
		currentTimingValue = currentTimingValue - deltaTime * define.timing_Speed
		if ( currentTimingValue < 0 ) then
			currentTimingValue = - currentTimingValue
			isUpTiming = true
		end
	end
	
	if isUpProgress then
		sumTime = sumTime + deltaTime * define.progressBar_SpeedPerSec
		if ( 1 < sumTime ) then
			sumTime = 1
			isUpProgress = false
		end
	else
		sumTime = sumTime - deltaTime * define.progressBar_SpeedPerSec
		if ( sumTime <= 0 ) then
			sumTime = 0
			isUpProgress = true
			failedUIShow_HerbMachine()
			
			playMode = 2
			sumTime = 0
			isWin = false
			getSelfPlayer():get():SetMiniGameResult( 1 )
		end
	end

	currentProgressValue = sumTime * sumTime * sumTime * define.progressBar_speedValue3
	currentProgressValue = currentProgressValue + sumTime * sumTime * define.progressBar_speedValue2
	currentProgressValue = currentProgressValue + sumTime * define.progressBar_speedValue1

	if ( 1 <= currentProgressValue ) then
		currentProgressValue = 1
	elseif ( currentProgressValue <= 0 ) then
		currentProgressValue = 0
	end

	timing_update_HerbMachine(deltaTime)
	progressbar_update_HurbMachine(deltaTime)
end

local endTimeUpdate_HurbMachine = function( deltaTime )
	sumTime = sumTime + deltaTime
	-- UI.debugMessage('sumTime : ' .. sumTime )
	if ( define.endAnimationTime <= sumTime ) then
		Panel_Minigame_HerbMachine_End_UI()
		playMode = 1
		isBarMoveStart = false
		initValue()
		for key, value in pairs(ui) do
			value:SetShow(false)
		end
	end
end

function Panel_Minigame_HerbMachine_Start()
	_math_randomSeed( os.time() )
	ui._resultText:ResetVertexAni()
	ui._resultText:SetAlpha(0)
	ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_Minigame_HerbMachine_2"))	-- "타이밍에 맞춰 점프 해보세요."
	
	Panel_MiniGame_Timing:SetShow( true, false )
	currentTimingValue = _math_random(0, 100) / 100
	currentProgressValue = 0
	isUpTiming = true
	isUpProgress = true
	sumTime = 0
	playMode = 1
	
	for key, value in pairs(ui) do
		value:SetShow(false)
	end
	isBarMoveStart = false
end

function Panel_Minigame_HerbMachine_ResetCount()
	herbMachine_WinCount = 0
end
function Panel_Minigame_HerbMachine_End()
	Panel_MiniGame_Timing:SetShow( false, false )
end
function Panel_Minigame_HerbMachine_End_UI()
	if 5 <= herbMachine_WinCount then
		FGlobal_MiniGame_HerbMachine()							-- 처리가 잘 안되서 글로벌 매뉴얼로 처리함
	end
	
	if ( isWin ) then
		getSelfPlayer():get():SetMiniGameResult( 0 )
	else
		getSelfPlayer():get():SetMiniGameResult( 1 )
	end
	-- 퀘스트랑 인덱스 매칭해야 함!!
	
	--Panel_MiniGame_Timing:SetShow( false, false )
end

function Panel_Minigame_HerbMachine_Perframe(deltaTime)
	-- UI.debugMessage( "endTimeUpdate_HurbMachine : " ..  playMode )
	
	if ( false == isBarMoveStart ) then
		return
	end
	
	if ( playMode == 2 ) then
		endTimeUpdate_HurbMachine(deltaTime)
	elseif ( playMode == 1 ) then
		playingUpdate_HurbMachine(deltaTime)
	end
end

-- 스페이스바를 눌렀을 때
function Panel_Minigame_HerbMachine_Freeze( keyType )
	 
	if ( false == isBarMoveStart ) then
		for key, value in pairs(ui) do
			if ( "_result_Good" ~= key ) and ( "_result_Bad" ~= key ) and ( "_resultText" ~= key ) then			
				value:SetShow(true)
			end
		end
		getSelfPlayer():get():SetMiniGameResult( 2 )

		isBarMoveStart = true
		return
	end
	
	if ( MGKT.MiniGameKeyType_Space == keyType ) and ( Panel_MiniGame_Timing:IsShow() ) and ( 1 == playMode ) then
		local minValue = ui._timing:GetPosY()- ui._timingProgress:GetPosY()
		local maxValue = minValue + ui._timing:GetSizeY()
		local checkPos = ui._timingProgress_Head:GetPosY() + ui._timingProgress_Head:GetSizeY() / 2
		playMode = 2
		sumTime = 0
		isWin = ( minValue <= checkPos ) and ( checkPos <= maxValue )
		
		if isWin then
			-- ♬ 성공 사운드
			audioPostEvent_SystemUi(11,01)
			
			endUIShow_HerbMachine( ui._resultText, ui._result_Good, UI_color.C_FF96D4FC, PAGetString(Defines.StringSheet_GAME, "Lua_Minigame_HerbMachine_0"), "Good" )	-- "기계를 성공적으로 작동 시켰습니다!"
			herbMachine_WinCount = herbMachine_WinCount + 1
			getSelfPlayer():get():SetMiniGameResult( 0 )
		else
			-- ♬ 실패 사운드
			audioPostEvent_SystemUi(11,02)
	
			endUIShow_HerbMachine( ui._resultText, ui._result_Bad, UI_color.C_FFF26A6A, PAGetString(Defines.StringSheet_GAME, "Lua_Minigame_HerbMachine_1"), "Bad" )	-- "기계 작동에 실패 했습니다!"
			getSelfPlayer():get():SetMiniGameResult( 1 )
		end
	end
end


init_HerbMachine()
registerEvent( "onScreenResize", "ScreenSize_RePosition_HerbMachineGame" )