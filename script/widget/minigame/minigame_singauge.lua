-- 미니게임 타입 1 (낚시 게임)

local MGKT = CppEnums.MiniGameKeyType
local UIColor = Defines.Color

Panel_SinGauge:SetShow(false, false)

-- Panel_SinGauge:RegisterShowEventFunc( true, 'HudTimerShowAni()' )

local gameOptionActionKey = {
	Forward		= 0,
	Back		= 1,
	Left		= 2,
	Right		= 3,
	Attack		= 4,
	SubAttack	= 5,
	Dash		= 6,
	Jump		= 7,
}

local _math_random = math.random
local _math_randomSeed = math.randomseed

------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
local _sinGaugeBG 					= UI.getChildControl ( Panel_SinGauge, "Static_SinGaugeBG")
local _sinGaugeBar 					= UI.getChildControl ( Panel_SinGauge, "Static_SinGauge")
local _sinGaugeBarEffect			= UI.getChildControl ( Panel_SinGauge, "Static_SinGaugeEffect")
local _spaceBar 					= UI.getChildControl ( Panel_SinGauge, "Static_SpaceBar" )
local _spaceBarEff 					= UI.getChildControl ( Panel_SinGauge, "Static_SpaceBar_Eff" )
local _sinGauge_Result_Perfect 		= UI.getChildControl ( Panel_SinGauge, "Static_Result_Perfect" )
local _sinGauge_Result_Good 		= UI.getChildControl ( Panel_SinGauge, "Static_Result_Good" )
local _sinGauge_Result_Bad 			= UI.getChildControl ( Panel_SinGauge, "Static_Result_Bad" )
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
-- 텍스트 랜덤 생성 ( 클리어 했을 경우 낚시 성공! )
-- 50% 이하일 때 failed
-- 50% 이상일 때 good
-- 100% 일 때 perfect
-- 키를 입력했을 때 게이지 멈추고 판정 시작

local gaugeBarSizeX = 0
local gaugeIsGrowing = true
local checkGaugeCount = 0
local preTick = getTickCount32()
_sinGaugeBar:SetSize( 0, 20 )

local sinGaugeBarStart = false
local isFinished = true


local actionString = "";
if getGamePadEnable() then
	actionString = keyCustom_GetString_ActionPad( gameOptionActionKey.Jump );
else
	actionString = keyCustom_GetString_ActionKey( gameOptionActionKey.Jump );
end
_spaceBar:SetText( actionString )

-- 화면 리포지션
function SinGauge_RePosition()
	screenX = getScreenSizeX()
	sizeX = Panel_SinGauge:GetSizeX() / 2

--	Panel_SinGauge:SetPosX( screenX / 2 - 250 )
	Panel_SinGauge:SetPosX( screenX / 2 - sizeX )
	Panel_SinGauge:SetPosY( 400 )
end

local SinGaugeBar_OnFail = function()
	-- ♬ 실패 사운드
	audioPostEvent_SystemUi(11,07)
				
	isFinished = true
	Panel_SinGauge:RegisterUpdateFunc("")
	getSelfPlayer():get():SetMiniGameResult( 0 )
	
	_sinGauge_Result_Bad:ResetVertexAni()
	_sinGauge_Result_Bad:SetVertexAniRun("Bad_Ani", true)
	_sinGauge_Result_Bad:SetVertexAniRun("Bad_ScaleAni", true)
	_sinGauge_Result_Bad:SetVertexAniRun("Bad_AniEnd", true)
	
	-- UI.debugMessage('FAIL !!!!!!!!!!!!')

	_sinGauge_Result_Bad:SetShow(true)
end

--------------------------------------------------------
--			게이지바 업데이트용 함수
--------------------------------------------------------
local gaugeSpeed = 0.8;
function SinGaugeBar_UpdateGauge()
	local currentTick = getTickCount32()
	local deltaTick = currentTick - preTick
	local deltaTime = deltaTick / 1000.0 * gaugeSpeed
	
	------------------------------
	-- 		늘어나는 녀석
	if (sinGaugeBarStart == true) then
		if gaugeBarSizeX >= 0 and gaugeIsGrowing == true and gaugeBarSizeX < 273 then
			gaugeBarSizeX =  gaugeBarSizeX + ( ( gaugeBarSizeX + 1 ) / 273 ) * 273 * 10.0 * deltaTime
			if gaugeBarSizeX > 273 then
				gaugeBarSizeX = 273
				gaugeIsGrowing = false
			end
			_sinGaugeBar:SetSize( gaugeBarSizeX, 20 )
			
		------------------------------
		-- 		줄어드는 녀석
		elseif gaugeIsGrowing == false and gaugeBarSizeX > 10 and ( 5 > checkGaugeCount ) then
			gaugeBarSizeX =  gaugeBarSizeX - ( ( gaugeBarSizeX + 1 ) / 273 ) * 273 * 2.5 * deltaTime
			if gaugeBarSizeX < 10 then
				gaugeBarSizeX = 10
				gaugeIsGrowing = true
				checkGaugeCount = checkGaugeCount + 1
				-- UI.debugMessage("CheckCount"..tostring(checkGaugeCount).. "asdfasdf")
			end 
			_sinGaugeBar:SetSize( gaugeBarSizeX, 20 )
		elseif gaugeIsGrowing == true and gaugeBarSizeX >= 273 then
			gaugeIsGrowing = false
			gaugeBarSizeX = 273
		elseif gaugeIsGrowing == false and gaugeBarSizeX <= 0 and ( 5 > checkGaugeCount ) then
			-- UI.debugMessage("CheckCount"..tostring(checkGaugeCount))
			gaugeIsGrowing = true
			gaugeBarSizeX = 0
			checkGaugeCount = checkGaugeCount + 1
		end
	end
	preTick = currentTick

	if 3 == checkGaugeCount then
		-- UI.debugMessage("3 Count")
		isFinished = true
		SinGaugeBar_OnFail()
	end
end

-- 켜기
function Panel_Minigame_SinGauge_Start()
	_math_randomSeed( os.time() )
	
	gaugeSpeed = 0.88 + _math_random(0, 200) / 1000 + getSelfPlayer():get():getFishGrade() * 0.03

	isFinished = false
	gaugeBarSizeX = 0
	_sinGaugeBar:SetSize( 0, 20 )
	_sinGaugeBarEffect:AddEffect( "UI_Fishing_Aura01", false, 0, 0 )
	Panel_SinGauge:SetShow( true, false )
	Panel_SinGauge:RegisterUpdateFunc("SinGaugeBar_UpdateGauge")

	_sinGauge_Result_Bad:SetShow( false )
	_sinGauge_Result_Good:SetShow( false )
	_sinGauge_Result_Perfect:SetShow( false )

	sinGaugeBarStart = true;
	checkGaugeCount = 0
	gaugeIsGrowing = true
	preTick = getTickCount32()
end

-- 끄기
function Panel_Minigame_SinGauge_End()
	Panel_SinGauge:RegisterUpdateFunc("")
	Panel_SinGauge:SetShow( false, false )
	_sinGaugeBarEffect:EraseAllEffect()
	isFinished = true

	sinGaugeBarStart = false;
end

function MiniGame_SinGauge_KeyPress( keyType )
	if isFinished then
		return
	end
	
	-- UI.debugMessage('Aurah - 1 !!!!!!!!!!!!!!!!!')
	
	if MGKT.MiniGameKeyType_Space == keyType then
		_sinGaugeBar:SetSize( gaugeBarSizeX, 20 )
		sinGaugeBarStart = false
		
		Panel_SinGauge:RegisterUpdateFunc("")
		if 273 == gaugeBarSizeX then
			-- ♬ 퍼펙트 사운드
			audioPostEvent_SystemUi(11,00)
			audioPostEvent_SystemUi(11,13)
			
			-- PERFECT!!!!!
			getSelfPlayer():get():SetMiniGameResult( 3 )
			isFinished = true
			
			_sinGauge_Result_Perfect:ResetVertexAni()
			_sinGauge_Result_Perfect:SetVertexAniRun("Perfect_Ani", true)
			_sinGauge_Result_Perfect:SetVertexAniRun("Perfect_ScaleAni", true)
			_sinGauge_Result_Perfect:SetVertexAniRun("Perfect_AniEnd", true)

			_sinGauge_Result_Perfect:SetShow(true)

			-- UI.debugMessage('PERFECT !!!!!!!!!!!!')
		elseif 167 < gaugeBarSizeX then
			-- GOOD!!!!
			-- ♬ 굳 사운드
			audioPostEvent_SystemUi(11,00)
			audioPostEvent_SystemUi(11,13)
			
			getSelfPlayer():get():SetMiniGameResult( 11 )
			isFinished = true

			_sinGauge_Result_Good:ResetVertexAni()
			_sinGauge_Result_Good:SetVertexAniRun("Good_Ani", true)
			_sinGauge_Result_Good:SetVertexAniRun("Good_ScaleAni", true)
			_sinGauge_Result_Good:SetVertexAniRun("Good_AniEnd", true)
			
			_sinGauge_Result_Good:SetShow(true)

			-- UI.debugMessage('GOOD !!!!!!!!!!!!')
		else
			-- FAIL !!!
			isFinished = true
			SinGaugeBar_OnFail()
		end
	end
end

registerEvent( "onScreenResize", "SinGauge_RePosition" )
registerEvent("EventActionMiniGameKeyDownOnce",	"MiniGame_SinGauge_KeyPress")
SinGauge_RePosition()
