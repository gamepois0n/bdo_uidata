-- 미니게임 타입 5 (필 게이지 - 게이지 채우기)

local MGKT = CppEnums.MiniGameKeyType
local UIColor = Defines.Color
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local VCK = CppEnums.VirtualKeyCode
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM 			= CppEnums.EProcessorInputMode
local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE

Panel_FillGauge:SetShow(false, false)

-- Panel_FillGauge:RegisterShowEventFunc( true, 'Panel_MiniGame_FillGauge_Show()' )
-- Panel_FillGauge:RegisterShowEventFunc( false, 'Panel_MiniGame_FillGauge_Hide()' )

----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------
local ui = {
	_fillGauge_BG = UI.getChildControl ( Panel_FillGauge, "Static_GaugeBG" ),
	_myGauge = UI.getChildControl ( Panel_FillGauge, "Progress2_MyGauge" ),
	_middleLine = UI.getChildControl ( Panel_FillGauge, "Static_MiddleLine" ),
	_pushGong = UI.getChildControl ( Panel_FillGauge, "Static_Gong" ),
	_mouseL = UI.getChildControl ( Panel_FillGauge, "Static_L_Btn_L" ),
	_mouseR = UI.getChildControl ( Panel_FillGauge, "Static_R_Btn_R" ),
	_text_TitleText = UI.getChildControl ( Panel_FillGauge, "StaticText_TitleText" ),
	_text_RemainTime = UI.getChildControl ( Panel_FillGauge, "StaticText_RemainTimeText" ),
	_text_Timer = UI.getChildControl ( Panel_FillGauge, "StaticText_Timer" ),
	_result_Success = UI.getChildControl ( Panel_FillGauge, "Static_Result_Success" ),
	_result_Failed = UI.getChildControl ( Panel_FillGauge, "Static_Result_Failed" ),
}

local ballGroup = {}
local ball_Index = 1
local sumDeltaTime = 0
local currentPercent = 0
local remainTime = 20

local gameProgress = 
{
	playing = 1,
	ending = 2,
}

local gameProgressValue = gameProgress.ending


local init = function()
	registerEvent( "onScreenResize", "FillGauge_RePosition" )
	FillGauge_RePosition()
	Panel_FillGauge:RegisterUpdateFunc("Panel_Minigame_UpdateFunc")
	
	for k = 1, 50 do
		local ball = UI.createControl( UCT.PA_UI_CONTROL_STATIC, ui._myGauge, "ball_" .. tostring(k) )
		CopyBaseProperty( ui._pushGong, ball )
		ballGroup[k] = ball
		ball:SetPosY(4)
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- 화면 리포지션
function FillGauge_RePosition()
	local scrX = getScreenSizeX()
	local scrY = getScreenSizeY()

	Panel_FillGauge:SetPosX( screenX / 2 - 135.5 )
	Panel_FillGauge:SetPosY( scrY / 2 - 250 )
end

local setProgress = function(isSetProgress)
	if ( currentPercent < 0 ) then
		currentPercent = 0
	elseif ( 100 < currentPercent ) then
		currentPercent = 100
		FillGauge_Result()
	end
	ui._myGauge:SetProgressRate(currentPercent)
	if ( isSetProgress ) then
		ui._myGauge:SetCurrentProgressRate(currentPercent)
	end
end

function Panel_Minigame_FillGauge_Start()
	ui._result_Success:SetShow(false)
	ui._result_Failed:SetShow(false)
	ui._result_Success:ResetVertexAni()
	ui._result_Failed:ResetVertexAni()
	ui._result_Success:SetAlpha(0)
	ui._result_Failed:SetAlpha(0)
	
	gameProgressValue = gameProgress.playing
	remainTime = 20
	Panel_FillGauge:SetShow(true, false)
	currentPercent = 0
	setProgress(true)
end	

function FillGauge_UpdateGauge( deltaTime, isLeft )
	if ( gameProgressValue ~= gameProgress.playing ) then
		return
	end
	currentPercent = currentPercent + 3.7
	setProgress(false)
	
	ui._myGauge:ResetVertexAni()
	ui._mouseL:ResetVertexAni()
	ui._mouseR:ResetVertexAni()
	ui._myGauge:SetVertexAniRun ( "Ani_Color_myGaugeEff", true )
	
	if isLeft then
		-- UI.debugMessage("left")
		ui._mouseL:SetVertexAniRun ( "Ani_Color_Left", true )
	else
		-- UI.debugMessage("right")
		ui._mouseR:SetVertexAniRun ( "Ani_Color_Right", true )
	end

		-- 공 빵빵!
	ballGroup[ball_Index]:SetShow( true )
	ballGroup[ball_Index]:SetPosX(0)
	
	ball_Index = ball_Index +1
	if ( 50 < ball_Index ) then
		ball_Index = 1
	end
end

function FillGauge_UpdatePerFrame( deltaTime )
	if ( gameProgressValue == gameProgress.playing ) then
		sumDeltaTime = sumDeltaTime + deltaTime * 30
		local number, underZero = math.modf(sumDeltaTime)
		sumDeltaTime = underZero
		currentPercent = currentPercent - number
		setProgress(false)
		
		FillGauge_EndTimer( deltaTime )
	elseif ( gameProgressValue == gameProgress.ending ) then
		--noop
	end
	FillGauge_BallUpdate(deltaTime )
end

function FillGauge_BallUpdate(deltaTime)
	for _, value in pairs(ballGroup) do
		if ( value:GetShow() ) then
			value:SetPosX( value:GetPosX() + value:GetSizeX() )
			if ( ui._myGauge:GetSizeX() * currentPercent / 100 <= value:GetPosX() + value:GetSizeX()) then
				value:SetShow(false)
			end
		end
	end
end


function FillGauge_EndTimer( deltaTime )
	remainTime = remainTime - deltaTime
	local remainSec =  math.floor( remainTime )
	
	if ( 0 < remainTime ) then
		ui._text_Timer:SetText( remainSec .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_SECOND") )		-- 시간 표시
	elseif 0 >= remainTime then
			-- 오쉣 타임이즈 아웃!
		if currentPercent >= 100 then
				-- 요 퍽킹 굿 맨~
			-- UI.debugMessage("Success!!")
			-- ♬ 성공 사운드
			audioPostEvent_SystemUi(11,01)
			
			ui._result_Success:SetShow(true)
			ui._result_Success:ResetVertexAni()
			ui._result_Success:SetVertexAniRun( "Ani_Scale_Result_Success_empty", true )
			ui._result_Success:SetVertexAniRun( "Ani_Scale_Result_Success", true )
			ui._result_Success:SetVertexAniRun( "Ani_Color_Result_Success_empty", true )
			ui._result_Success:SetVertexAniRun( "Ani_Color_Result_Success", true )
			getSelfPlayer():get():SetMiniGameResult( 0 )
		elseif 99 >= currentPercent then
				-- 권호형 같네
			-- UI.debugMessage("Failed!!")
			-- ♬ 실패 사운드
			audioPostEvent_SystemUi(11,02)
			
			ui._result_Failed:SetShow(true)
			ui._result_Failed:ResetVertexAni()
			ui._result_Failed:SetVertexAniRun( "Ani_Scale_Result_Failed_empty", true )
			ui._result_Failed:SetVertexAniRun( "Ani_Scale_Result_Failed", true )
			ui._result_Failed:SetVertexAniRun( "Ani_Color_Result_Failed_empty", true )
			ui._result_Failed:SetVertexAniRun( "Ani_Color_Result_Failed", true )
			getSelfPlayer():get():SetMiniGameResult( 3 )
		end
		Panel_Minigame_FillGauge_End()
	end
end

function FillGauge_Result()
	gameProgressValue = gameProgress.ending
	if currentPercent >= 100 then
			-- 요 퍽킹 굿 맨~
		-- UI.debugMessage("Success!!")
		-- ♬ 성공 사운드
		audioPostEvent_SystemUi(11,01)
			
		ui._result_Success:SetShow(true)
		ui._result_Success:ResetVertexAni()
		ui._result_Success:SetVertexAniRun( "Ani_Scale_Result_Success_empty", true )
		ui._result_Success:SetVertexAniRun( "Ani_Scale_Result_Success", true )
		ui._result_Success:SetVertexAniRun( "Ani_Color_Result_Success_empty", true )
		ui._result_Success:SetVertexAniRun( "Ani_Color_Result_Success", true )
		getSelfPlayer():get():SetMiniGameResult( 0 )
	else
			-- 아 권호형 진짜
		-- UI.debugMessage("Failed!!")
		-- ♬ 실패 사운드
		audioPostEvent_SystemUi(11,02)
			
		ui._result_Failed:SetShow(true)
		ui._result_Failed:ResetVertexAni()
		ui._result_Failed:SetVertexAniRun( "Ani_Scale_Result_Failed_empty", true )
		ui._result_Failed:SetVertexAniRun( "Ani_Scale_Result_Failed", true )
		ui._result_Failed:SetVertexAniRun( "Ani_Color_Result_Failed_empty", true )
		ui._result_Failed:SetVertexAniRun( "Ani_Color_Result_Failed", true )
		getSelfPlayer():get():SetMiniGameResult( 3 )
	end
	Panel_Minigame_FillGauge_End()
end

function Panel_Minigame_FillGauge_End()
	-- UI.debugMessage("Fill Gauge End!!")
	Panel_FillGauge:SetShow(false, false)
end

function Panel_MiniGame_FillGauge_Hide()
	Panel_FillGauge:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
	local fillGauge_Hide = Panel_FillGauge:addColorAnimation( 2.4, 2.75, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	fillGauge_Hide:SetStartColor( UIColor.C_FFFFFFFF )
	fillGauge_Hide:SetEndColor( UIColor.C_00FFFFFF )
	fillGauge_Hide:SetStartIntensity( 3.0 )
	fillGauge_Hide:SetEndIntensity( 1.0 )
	fillGauge_Hide.IsChangeChild = true
	fillGauge_Hide:SetHideAtEnd(true)
	fillGauge_Hide:SetDisableWhileAni(true)
end
function Panel_MiniGame_FillGauge_Show()
	local fillGauge_Show = Panel_FillGauge:addColorAnimation( 0.0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	fillGauge_Show:SetStartColor( UIColor.C_00FFFFFF )
	fillGauge_Show:SetEndColor( UIColor.C_FFFFFFFF )
	fillGauge_Show:SetStartIntensity( 3.0 )
	fillGauge_Show:SetEndIntensity( 1.0 )
	fillGauge_Show.IsChangeChild = true
	fillGauge_Show:SetHideAtEnd(false)
	fillGauge_Show:SetDisableWhileAni(true)
end


function Panel_MiniGame_FillGauge_IsPlaying()
	return ( gameProgressValue == gameProgress.playing )
end

init()


