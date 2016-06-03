local MGT = CppEnums.MiniGameType
local IM = CppEnums.EProcessorInputMode
local currentMiniGame = -1
local lastUIMode = nil

function ActionMiniGame_Main( gameIndex )
	if (gameIndex < MGT.MiniGameType_0) or (MGT.MiniGameType_16 < gameIndex) or (currentMiniGame == gameIndex) then
		return
	end

	if MGT.MiniGameType_0 == gameIndex then
		Panel_Minigame_Gradient_Start()				-- 기울기
	elseif MGT.MiniGameType_1 == gameIndex then
		Panel_Minigame_SinGauge_Start()				-- SIN 게이지
	elseif MGT.MiniGameType_2 == gameIndex then
		Panel_Minigame_Command_Start()				-- 커맨드 입력
	elseif MGT.MiniGameType_3 == gameIndex then
		Panel_Minigame_Rhythm_Start()				-- 리듬 게임
	elseif MGT.MiniGameType_4 == gameIndex then
		Panel_Minigame_BattleGauge_Start()			-- 배틀 게이지
	elseif MGT.MiniGameType_5 == gameIndex then
		Panel_Minigame_FillGauge_Start()			-- 채우기 게이지
	elseif MGT.MiniGameType_6 == gameIndex then
		Panel_Minigame_GradientY_Start()			-- 기울기 Y축
	elseif MGT.MiniGameType_7 == gameIndex then
		Panel_Minigame_Timing_Start()				-- 타이밍 맞추기
	elseif MGT.MiniGameType_8 == gameIndex then
		-- Panel_Minigame_Drag_Start()					-- 드래그 게임
	elseif MGT.MiniGameType_9 == gameIndex then
		-- Panel_Skill_Elf_Snipe_Start()				-- 스킬용 테스트 (게임 아님)
	elseif MGT.MiniGameType_10 == gameIndex then
		Panel_Minigame_RhythmForAction_Start()		-- 사냥용 리듬게임
	elseif MGT.MiniGameType_11 == gameIndex then
		Panel_Minigame_HerbMachine_Start()			-- 타이밍 게임 ( 점프 )
	elseif MGT.MiniGameType_12 == gameIndex then
		Panel_Minigame_Buoy_Start()					-- 부표 게임
	elseif MGT.MiniGameType_13 == gameIndex then
		Panel_Minigame_Steal_Start()				-- 주머니 도둑
	elseif MGT.MiniGameType_14 == gameIndex then
		Panel_MiniGame_PowerControl_Start()			-- 젖짜
	elseif MGT.MiniGameType_15 == gameIndex then
		Panel_MiniGame_Jaksal_Start()				-- 작살 게임
	elseif MGT.MiniGameType_16 == gameIndex then
		Panel_Minigame_Rhythm_Drum_Start()			-- 리듬 게임
	end

	lastUIMode = GetUIMode()
	SetUIMode( Defines.UIMode.eUIMode_MiniGame )
	currentMiniGame = gameIndex
end

function ActionMiniGame_Stop()
	if currentMiniGame < MGT.MiniGameType_0 or MGT.MiniGameType_16 < currentMiniGame then
		return
	end

	if MGT.MiniGameType_0 == currentMiniGame then
		Panel_Minigame_Gradient_End()
	elseif MGT.MiniGameType_1 == currentMiniGame then
		Panel_Minigame_SinGauge_End()
	elseif MGT.MiniGameType_2 == currentMiniGame then
		Panel_Minigame_Command_End()
	elseif MGT.MiniGameType_3 == currentMiniGame then
		Panel_Minigame_Rhythm_End()
	elseif MGT.MiniGameType_4 == currentMiniGame then
		Panel_Minigame_BattleGauge_End()
	elseif MGT.MiniGameType_5 == currentMiniGame then
		Panel_Minigame_FillGauge_End()
	elseif MGT.MiniGameType_6 == currentMiniGame then
		Panel_Minigame_GradientY_End()
	elseif MGT.MiniGameType_7 == currentMiniGame then
		Panel_Minigame_Timing_End()
	elseif MGT.MiniGameType_8 == currentMiniGame then
		-- Panel_Minigame_Drag_End()
	elseif MGT.MiniGameType_9 == currentMiniGame then
		Panel_Skill_Elf_Snipe_End()
	elseif MGT.MiniGameType_10 == currentMiniGame then
		Panel_Minigame_RhythmForAction_End()
	elseif MGT.MiniGameType_11 == currentMiniGame then
		Panel_Minigame_HerbMachine_End()
	elseif MGT.MiniGameType_12 == currentMiniGame then
		Panel_Minigame_Buoy_End()
	elseif MGT.MiniGameType_13 == currentMiniGame then
		Panel_Minigame_Steal_End()
	elseif MGT.MiniGameType_14 == currentMiniGame then
		Panel_MiniGame_PowerControl_End()
	elseif MGT.MiniGameType_15 == currentMiniGame then
		Panel_MiniGame_Jaksal_End()
	elseif MGT.MiniGameType_16 == currentMiniGame then
		Panel_Minigame_Rhythm_Drum_End()
	end

	
		SetUIMode( Defines.UIMode.eUIMode_Default )
	if( AllowChangeInputMode() ) then
		if( check_ShowWindow() ) then
			UI.Set_ProcessorInputMode( IM.eProcessorInputMode_UiMode )
		else
			UI.Set_ProcessorInputMode( IM.eProcessorInputMode_GameMode)
		end
	else
		SetFocusChatting()
	end
	lastUIMode = nil
	currentMiniGame = -1
end

-- 키 입력 받는 미니게임 글로벌 펑션
function Panel_Minigame_EventKeyPress( keyType )
	if currentMiniGame < MGT.MiniGameType_0 or MGT.MiniGameType_16 < currentMiniGame then
		return
	end

	if MGT.MiniGameType_0 == currentMiniGame then
		
	elseif MGT.MiniGameType_1 == currentMiniGame then
		
	elseif MGT.MiniGameType_2 == currentMiniGame then
		
	elseif MGT.MiniGameType_3 == currentMiniGame then
		
	elseif MGT.MiniGameType_4 == currentMiniGame then
		
	elseif MGT.MiniGameType_5 == currentMiniGame then
		
	elseif MGT.MiniGameType_6 == currentMiniGame then
		
	elseif MGT.MiniGameType_7 == currentMiniGame then
		Panel_Minigame_Timing_Freeze( keyType )
	elseif MGT.MiniGameType_8 == currentMiniGame then
		
	elseif MGT.MiniGameType_9 == currentMiniGame then
		
	elseif MGT.MiniGameType_10 == currentMiniGame then
		
	elseif MGT.MiniGameType_11 == currentMiniGame then
		Panel_Minigame_HerbMachine_Freeze( keyType )
	elseif MGT.MiniGameType_12 == currentMiniGame then
		Panel_Minigame_Buoy_Freeze( keyType )
	elseif MGT.MiniGameType_13 == currentMiniGame then
		Minigame_Steal_PressKey( keyType )
	elseif MGT.MiniGameType_14 == currentMiniGame then
		-- Panel_MiniGame_PowerControl_CheckKey( keyType )
	elseif MGT.MiniGameType_15 == currentMiniGame then
		Panel_MiniGame_Jaksal_KeyPressCheck( keyType )
	elseif MGT.MiniGameType_16 == currentMiniGame then

	end
end
registerEvent("EventActionMiniGameKeyDownOnce",	"Panel_Minigame_EventKeyPress")

-- 패널 업데이트 펑션 모음 (패널을 중복해서 사용하는 경우에 적용)
function Panel_Minigame_UpdateFunc( deltaTime )
	if currentMiniGame < MGT.MiniGameType_0 or MGT.MiniGameType_16 < currentMiniGame then
		return
	end

	if MGT.MiniGameType_0 == currentMiniGame then
		MiniGame_GaugeBarMoveCalc( deltaTime )
	elseif MGT.MiniGameType_1 == currentMiniGame then
		
	elseif MGT.MiniGameType_2 == currentMiniGame then
		Command_UpdateText( deltaTime )
	elseif MGT.MiniGameType_3 == currentMiniGame then
		RhythmGame_UpdateFunc( deltaTime )
	elseif MGT.MiniGameType_4 == currentMiniGame then
		
	elseif MGT.MiniGameType_5 == currentMiniGame then
		FillGauge_UpdatePerFrame( deltaTime )
	elseif MGT.MiniGameType_6 == currentMiniGame then
		MiniGame_GaugeBarMoveCalcY( deltaTime )
	elseif MGT.MiniGameType_7 == currentMiniGame then
		Panel_Minigame_Timing_Perframe( deltaTime )
	elseif MGT.MiniGameType_8 == currentMiniGame then
		
	elseif MGT.MiniGameType_9 == currentMiniGame then
		
	elseif MGT.MiniGameType_10 == currentMiniGame then
		
	elseif MGT.MiniGameType_11 == currentMiniGame then
		Panel_Minigame_HerbMachine_Perframe( deltaTime )
	elseif MGT.MiniGameType_12 == currentMiniGame then
		Panel_Minigame_Buoy_Perframe( deltaTime )
	elseif MGT.MiniGameType_13 == currentMiniGame then
		
	elseif MGT.MiniGameType_14 == currentMiniGame then
		
	elseif MGT.MiniGameType_15 == currentMiniGame then

	elseif MGT.MiniGameType_16 == currentMiniGame then
		RhythmGame_Drum_UpdateFunc( deltaTime )
	end
end

local keyDownFunctorList = {}
local keyUpFunctorList = {}

function AddMiniGameKeyDownOnce( miniGameType, functor )
	keyDownFunctorList[miniGameType] = functor
end

function AddMiniGameKeyUp( miniGameType, functor )
	keyUpFunctorList[miniGameType] = functor
end

function EventActionMiniGameKeyDownOnce( keyType )
	local functor = keyDownFunctorList[currentMiniGame]
	if ( nil ~= functor ) then
		functor( keyType )
	end
end

function EventActionMiniGameKeyUp( keyType )
	local functor = keyUpFunctorList[currentMiniGame]
	if ( nil ~= functor ) then
		functor( keyType )
	end
end

registerEvent("EventStartActionMiniGame",				"ActionMiniGame_Main")
registerEvent("EventEndActionMiniGame",					"ActionMiniGame_Stop")

registerEvent( "EventActionMiniGameKeyDownOnce",	"EventActionMiniGameKeyDownOnce" )
registerEvent( "EventActionMiniGameKeyUp",			"EventActionMiniGameKeyUp" )
