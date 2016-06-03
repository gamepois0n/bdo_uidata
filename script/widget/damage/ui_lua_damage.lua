local UI_ANI_ADV		= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_AV				= CppEnums.PA_UI_ALIGNVERTICAL
local UI_TT				= CppEnums.PAUI_TEXTURE_TYPE

local RED_A0 			= Defines.Color.C_00FF0000
local RED_A1 			= Defines.Color.C_FFFF0000

local WHITE_A0 			= Defines.Color.C_00FFFFFF
local WHITE_A1 			= Defines.Color.C_FFFFFFFF

local GREEN_A0 			= Defines.Color.C_00B5FF6D
local GREEN_A1 			= Defines.Color.C_FFB5FF6D

local SKY_BLUE_A0 		= Defines.Color.C_006DC6FF
local SKY_BLUE_A1 		= Defines.Color.C_FF6DC6FF

local LIGHT_ORANGE_A0 	= Defines.Color.C_00FFD46D
local LIGHT_ORANGE_A1 	= Defines.Color.C_FFFFD46D

local ORANGE_A0 		= Defines.Color.C_00FFAB6D
local ORANGE_A1 		= Defines.Color.C_FFFFAB6D

local ORANGE_B0 		= Defines.Color.C_00FF4729
local ORANGE_B1 		= Defines.Color.C_FFFF4729

local PURPLE_A0 		= Defines.Color.C_00B75EDD
local PURPLE_A1 		= Defines.Color.C_FFB75EDD

local uiGruopValue 		= Defines.UIGroup.PAGameUIGroup_ScreenEffect
local OPT 				= CppEnums.OtherListType
local UCT 				= CppEnums.PA_UI_CONTROL_TYPE
local UI_ANI_ADV 		= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_AH 			= CppEnums.PA_UI_ALIGNHORIZON


local DamagePanel = {}
local DamagePanel_Index = 1
local DamagePanel_Count = 20

local isShowAttackEffect = ToClient_getRenderHitEffect()


local effectControlSetting =
{
			   { _name = 'Critical',		},	-- [1] Critical
			   { _name = 'Block',			},	-- [2] Block
			   { _name = 'Guard',			},	-- [3] Guard
			   { _name = 'Immune',			},	-- [4] Immune
			   { _name = 'Miss',			},	-- [5] Miss
			   { _name = 'Exp',				},	-- [6] exp
			   { _name = 'BackAttack',		},	-- [7] BackAttack
			   { _name = 'CounterAttack',	},	-- [8] CounterAttack
			   { _name = 'DownAttack',		},	-- [9] DownAttack
			   { _name = 'SpeedAttack',		},	-- [10] SpeedAttack
			   { _name = 'SkillPoint',		},	-- [11] SkillPoint
			   { _name = 'AirAttack',		},	-- [12] AirAttack
			   { _name = 'KindDamage',		},	-- [13] KindDamage
		[93] = { _name = 'Static_Wp',		},	-- [93] 여력 증가
		[94] = { _name = 'Static_Plus',		},	-- [94] Plus
		[95] = { _name = 'Static_Minus',	},	-- [95] Minus
		[96] = { _name = 'Static_Karma',	},  -- [96] 성향
		[97] = { _name = 'Static_Intimacy',	},	-- [97] 친밀도
		[99] = { _name = 'Contribute',		},	-- [99] 공헌도
}


local UpdatePanel = nil		-- 업데이트 전용 패널


----------------------
-- 지역 함수 
----------------------
local createUIData = function()
	for key , value in pairs(effectControlSetting) do
		local control = UI.getChildControl(Panel_Damage, value._name)
		if ( nil ~= control ) then
			value._sizeX = control:GetSizeX()
			value._sizeY = control:GetSizeY()
		end
	end
end


local createDamageControl = function( target )
	local effectControl, effectData
	for idx,value in pairs(effectControlSetting) do
		effectControl = UI.createControl( UCT.PA_UI_CONTROL_STATIC, target._panel, value._name )

		CopyBaseProperty(UI.getChildControl(Panel_Damage, value._name), effectControl)
		target.effectList[idx] = effectControl
	end
end


------------------------------------------------------------------------------------------
--									컨트롤 만들기
------------------------------------------------------------------------------------------
local createDamagePanel = function()
	for index = 1, DamagePanel_Count do
		local panel = UI.createPanel("damagePanel_" .. tostring( index ), Defines.UIGroup.PAGameUIGroup_ScreenEffect)
		CopyBaseProperty(Panel_Damage, panel)
		if ( nil == panel ) then
			return
		end

		local target =
		{
			effectList = {},
			damage = nil,
			_posX = 0,
			_posY = 0,
			_posZ = 0,
			_panel = panel
		}
		createDamageControl( target )
		DamagePanel[index] = target

		panel:setFlushAble(false)
		panel:SetIgnore(true)
		panel:SetIgnoreChild(true)
		panel:SetShow( false, false )
	end
end

------------------------------------------------------------------------------------------
--						애니메이션 및 애니메이션 시작 위치
------------------------------------------------------------------------------------------
local SetAnimationPanel = function(targetPanel, startendColor, middleColor, timeRate)
	local aniInfo0 = targetPanel:addColorAnimation( 0.0 * timeRate, 0.1 * timeRate, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo0:SetStartColor( startendColor )
	aniInfo0:SetEndColor( middleColor )
	aniInfo0:SetStartIntensity(1.0)
	aniInfo0:SetEndIntensity(2.0)
	aniInfo0.IsChangeChild = true

	local aniInfo1 = targetPanel:addColorAnimation( 0.3 * timeRate, 0.5 * timeRate, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
	aniInfo1:SetStartColor( middleColor )
	aniInfo1:SetEndColor( startendColor )
	aniInfo1:SetStartIntensity(2.0)
	aniInfo1:SetEndIntensity(1.0)
	aniInfo1:SetHideAtEnd(true)
	aniInfo1.IsChangeChild = true
end

local SetAnimationControl = function(targetStatic, posX, posY, timeRate)
	targetStatic:SetPosX( posX )
	targetStatic:SetPosY( posY + 500 )
	targetStatic:SetShow( isShowAttackEffect )
	targetStatic:SetAlpha( 0 )
	-- targetStatic:AddEffect("Ui_Damage_Backattack", false, 0, 0 )

	local aniInfo2 = targetStatic:addMoveAnimation( 0.0 * timeRate, 0.2 * timeRate, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR )
	aniInfo2.StartHorizonType = UI_AH.PA_UI_HORIZON_LEFT
	aniInfo2.EndHorizonType = UI_AH.PA_UI_HORIZON_LEFT
	aniInfo2:SetStartPosition( posX, posY - 150 )
	aniInfo2:SetEndPosition( posX, posY - 200 )

	local aniInfo3 = targetStatic:addMoveAnimation( 0.2 * timeRate, 0.5 * timeRate, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR )
	aniInfo3.StartHorizonType = UI_AH.PA_UI_HORIZON_LEFT
	aniInfo3.EndHorizonType = UI_AH.PA_UI_HORIZON_LEFT
	aniInfo3:SetStartPosition( posX, posY - 200 )
	aniInfo3:SetEndPosition( posX, posY - 250 )
end


-----------------------------------------------------------------------------
--						카운터 어택용 애니메이션 함수
-----------------------------------------------------------------------------
local SetAnimation_CounterAttack = function(targetStatic, posX, posY, timeRate)
	targetStatic:SetPosX( posX )
	targetStatic:SetPosY( posY + 500 )
	targetStatic:SetShow( isShowAttackEffect )
	targetStatic:SetAlpha( 0 )

	local aniInfo2 = targetStatic:addMoveAnimation( 0.0 * timeRate, 0.2 * timeRate, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR )
	aniInfo2.StartHorizonType = UI_AH.PA_UI_HORIZON_LEFT
	aniInfo2.EndHorizonType = UI_AH.PA_UI_HORIZON_LEFT
	aniInfo2:SetStartPosition( posX, posY - 200 )
	aniInfo2:SetEndPosition( posX, posY - 200 )

	local aniInfo3 = targetStatic:addMoveAnimation( 0.2 * timeRate, 0.5 * timeRate, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR )
	aniInfo3.StartHorizonType = UI_AH.PA_UI_HORIZON_LEFT
	aniInfo3.EndHorizonType = UI_AH.PA_UI_HORIZON_LEFT
	aniInfo3:SetStartPosition( posX, posY - 200 )
	aniInfo3:SetEndPosition( posX, posY - 200 )
	
	local aniInfo4 = targetStatic:addScaleAnimation( 0.0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo4:SetStartScale(1.5)
	aniInfo4:SetEndScale(1.0)
	aniInfo4.AxisX = 83
	aniInfo4.AxisY = 16.5
end


-----------------------------------------------------------------------------
--					종족 때렸을 때 나오는 이펙이펙용
-----------------------------------------------------------------------------
local SetAnimation_KindDamage = function(targetStatic, posX, posY, timeRate)
	targetStatic:SetPosX( posX - 120 )
	targetStatic:SetPosY( posY + 200 )
	targetStatic:SetShow( isShowAttackEffect )
	targetStatic:SetAlpha( 0 )

	local aniInfo2 = targetStatic:addMoveAnimation( 0.0 * timeRate, 0.1 * timeRate, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI )
	aniInfo2.StartHorizonType = UI_AH.PA_UI_HORIZON_LEFT
	aniInfo2.EndHorizonType = UI_AH.PA_UI_HORIZON_LEFT
	aniInfo2:SetStartPosition( posX, posY - 50 )
	aniInfo2:SetEndPosition( posX, posY - 150 )

	local aniInfo3 = targetStatic:addMoveAnimation( 0.4 * timeRate, 0.6 * timeRate, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI )
	aniInfo3.StartHorizonType = UI_AH.PA_UI_HORIZON_LEFT
	aniInfo3.EndHorizonType = UI_AH.PA_UI_HORIZON_LEFT
	aniInfo3:SetStartPosition( posX, posY - 150 )
	aniInfo3:SetEndPosition( posX, posY - 200 )
end

local postflushAndRestoreFunction = function()
	UpdatePanel:SetShow( true, false )
end

local initialize = function()
	----------------------
	-- 업데이트 전용 패널
	----------------------
	UpdatePanel = UI.createPanel( "Panel_DamageDisplay", uiGruopValue )
	UpdatePanel:SetShow( true, false )
	UpdatePanel:SetIgnore( true )
	UpdatePanel:SetPosX( 0 )
	UpdatePanel:SetPosY( 0 )
	UpdatePanel:SetAlpha( 0 )
	UpdatePanel:SetSize( 1, 1 )
	UpdatePanel:RegisterUpdateFunc("DamageOutputFunction_UpdatePosition")
	UpdatePanel:RegisterShowEventFunc(true, " ")
	UpdatePanel:RegisterShowEventFunc(false, " ")
	createUIData()
	createDamagePanel()

	UI.addRunPostFlushFunction( postflushAndRestoreFunction )
	UI.addRunPostRestorFunction( postflushAndRestoreFunction )

end




----------------------------------
-- 글로벌 함수 ( 이벤트 리스너 )
----------------------------------

function DamageOutputFunction_UpdatePosition()
	local cameraRotation = getCameraYawPitchRoll()
	local cameraPosition = getCameraPosition()

	for index = 1, DamagePanel_Count do
		local damageData = DamagePanel[index]
		local panel = damageData._panel
		if panel:GetShow() then
			local posX = damageData._posX
			local posY = damageData._posY + 150
			local posZ = damageData._posZ

			local transformData = getTransformRevers( posX, posY, posZ )

			if ( transformData.x > -1 ) and (transformData.y > -1 ) then
				panel:SetPosX(transformData.x)
				panel:SetPosY(transformData.y)
			else
				panel:SetPosX(-1000)
				panel:SetPosY(-1000)
			end
		end
	end
end

function FromClient_TendencyChanged( actorKeyRaw, tendencyValue )
	local selfWrapper		= getSelfPlayer()
	local selfProxy			= selfWrapper:get()
	local selfActorKeyRaw	= selfWrapper:getActorKey()
	local selfPosition		= float3(selfProxy:getPositionX(), selfProxy:getPositionY(), selfProxy:getPositionZ())
	if ( selfActorKeyRaw == actorKeyRaw ) and ( ( tendencyValue < 0 ) or ( 100 <= tendencyValue ) ) then
		if ( tendencyValue < 0 ) then
			Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_DAMAGE_TENDENCYCHANGED"))
		end
		DamageOutputFunction_OnDamage( getSelfPlayer():getActorKey(), tendencyValue, 96, 10, selfPosition, false, getSelfPlayer():getActorKey(), true)
	end
end

function FromClient_VaryIntimacy( actorKeyRaw, intimacyValue )
	local actorProxy		= getActor(actorKeyRaw):get()
	local actorPosition		= float3(actorProxy:getPositionX(), actorProxy:getPositionY(), actorProxy:getPositionZ())

	if ( 0 ~= intimacyValue ) then
		audioPostEvent_SystemUi(07,00)
		DamageOutputFunction_OnDamage( actorKeyRaw, intimacyValue, 97, 10, actorPosition, false, getSelfPlayer():getActorKey(), true)
	end
end

function DamageOutputFunction_gainExperience( experience )
	local selfProxy			= getSelfPlayer():get()
	local selfPosition		= float3(selfProxy:getPositionX(), selfProxy:getPositionY(), selfProxy:getPositionZ())
	if ( 0 < experience ) then
		DamageOutputFunction_OnDamage( getSelfPlayer():getActorKey(), experience, 99, 10, selfPosition, false, getSelfPlayer():getActorKey(), false)
	end
end

function FromClient_WpChanged(prevWp, wp)
	local selfProxy			= getSelfPlayer():get()
	local selfPosition		= float3(selfProxy:getPositionX(), selfProxy:getPositionY(), selfProxy:getPositionZ())
	local varyWp = wp - prevWp
	if ( varyWp < 0 ) or ( 1 < varyWp ) then
		DamageOutputFunction_OnDamage( getSelfPlayer():getActorKey(), varyWp, 93, 10, selfPosition, false, getSelfPlayer():getActorKey(), false)
	end
end

function DamageOutputFunction_OnDamage( attakeeKeyRaw, effectNumber, effectType, additionalDamageType, posFloat3, isTribeAttack, attackerActorKeyRaw, isNotRandom )
	local target = DamagePanel[DamagePanel_Index]

	-- 다음 사용을 위해 index 를 1 증가 시켜준다.
	DamagePanel_Index = DamagePanel_Index + 1
	if ( DamagePanel_Count < DamagePanel_Index ) then
		DamagePanel_Index = 1
	end

	if ( true == isNotRandom ) then
		target._posX = posFloat3.x
		target._posY = posFloat3.y
		target._posZ = posFloat3.z
	else
		target._posX = posFloat3.x + getRandomValue( -50, 50 )
		target._posY = posFloat3.y
		target._posZ = posFloat3.z + getRandomValue( -50, 50 )
	end

	if ( 90 < effectType ) then
		local talker = dialog_getTalker()
		if ( nil ~= talker ) then
			local talkerRaw = talker:get()
			target._posX = talkerRaw:getPositionX()
			target._posY = talkerRaw:getPositionY()
			target._posZ = talkerRaw:getPositionZ()
		end
	end

	for _,control in pairs(target.effectList) do
		control:SetShow( false )
	end

	if ( 96 == effectType ) or ( 97 == effectType ) or ( 93 == effectType ) then
		if ( 0 ==effectNumber ) then
			return
		end
	end

	local selfPlayer = getSelfPlayer()
	local attackeeIsSelfPlayer = (nil ~= selfPlayer) and (selfPlayer:getActorKey() == attakeeKeyRaw)

	local baseX = 000
	local baseY = 000

	if ( true == isNotRandom ) then
		baseX = 160
		baseY = 130
	end

	local startendColor	= WHITE_A0
	local middleColor	= WHITE_A1
	if attackeeIsSelfPlayer then
		startendColor	= RED_A0
		middleColor		= RED_A1
	end
	
    if ( 8 == effectType ) and ( effectNumber <= 0 ) then
        return
    end

	local timeRate = 2
	local showSymbol = 0
	local isDamageShow = true
	local isShowKindDamage = ( effectType <= 2 and isTribeAttack )

	if ( effectType == 0) then				--0 = 일반
	
	elseif ( effectType == 1) then			--1 = 크리티컬
		startendColor = ORANGE_A0
		middleColor = ORANGE_A1
	elseif ( effectType == 2) then			--2 = 방패가드로 데미지감소
		isDamageShow = false
	elseif ( effectType == 3) then			--3 = 타격성공이나 상대 보호로 데미지 0
		isDamageShow = false
	elseif ( effectType == 4) then			--4 = 속성저항치가 최고치라 데미지를 무효화하는 상태(이뮨)
		isDamageShow = false
	elseif ( effectType == 5) then			--5 = 공격자체가 실패
		isDamageShow = false
	elseif ( effectType == 6) then			--6 = hp회복
		startendColor = GREEN_A0
		middleColor = GREEN_A1
		isDamageShow = false
	elseif ( effectType == 7) then			--7 = mp회복
		startendColor = SKY_BLUE_A0
		middleColor = SKY_BLUE_A1
		isDamageShow = false
	elseif ( effectType == 8) then			--8 = exp획득
		startendColor = LIGHT_ORANGE_A0
		middleColor = LIGHT_ORANGE_A1
		timeRate = 4
		showSymbol = 0
	elseif ( effectType == 93 ) then		--93 = 여력 변화
		startendColor	= WHITE_A0
		middleColor		= WHITE_A1
		timeRate = 4
		showSymbol = 1
		isDamageShow = false

	elseif ( effectType == 96 ) then		--97 = intimacy 변화
		startendColor	= WHITE_A0
		middleColor		= WHITE_A1
		timeRate = 4
		showSymbol = 1
		isDamageShow = false
	elseif ( effectType == 97 ) then		--97 = intimacy 변화
		startendColor	= WHITE_A0
		middleColor		= WHITE_A1
		timeRate = 4
		showSymbol = 1
		isDamageShow = false
	elseif ( effectType == 99 ) then		--99 = 공헌도 획득
		startendColor	= WHITE_A0
		middleColor		= WHITE_A1
		timeRate = 4
		showSymbol = 1
		isDamageShow = false
	else
		UI.ASSERT(false, "이상한 효과번호가 들어옴.")
	end

	----------------------
	-- Panel 세팅
	----------------------
	local targetPanel = target._panel
	targetPanel:SetShow( isShowAttackEffect, false )
	targetPanel:SetWorldPosX( target._posX )
	targetPanel:SetWorldPosY( target._posY )
	targetPanel:SetWorldPosZ( target._posZ )
	SetAnimationPanel( targetPanel, startendColor, middleColor, timeRate )
	
	----------------------
	-- 컨트롤들 세팅
	----------------------
	if (0 == effectType) or (6 == effectType) or (7 == effectType) then
		-- 0 = 일반
		-- 6 = hp회복
		-- 7 = mp회복
		-- NULL; do Nothing!!!
	elseif (1 == effectType) or (2 == effectType) or (3 == effectType) or (4 == effectType) then
		-- 1 = 크리티컬
		-- 3 = 타격성공이나 상대 보호로 데미지 0
		-- 4 = 속성저항치가 최고치라 데미지를 무효화하는 상태(이뮨)
		-- 5 = 공격자체가 실패
		baseX = baseX - effectControlSetting[effectType]._sizeX / 2
		SetAnimationControl(target.effectList[effectType], baseX, baseY, timeRate)
		-- if 2 == effectType then -- ♬방어 성공 사운드
		-- 	audioPostEvent_SystemUi(14,07)
		-- end
	elseif (5 == effectType) then
		-- 2 = 방패가드로 데미지감소
		-- NULL; do Nothing!!!
	elseif 8 == effectType then
		-- 8 = exp획득
		baseX = baseX - effectControlSetting[6]._sizeX
		SetAnimationControl(target.effectList[6], baseX, baseY - 60, timeRate)
	elseif 93 == effectType then
		-- 93 = 여력
		baseX = baseX - effectControlSetting[effectType]._sizeX
		baseY = baseY + 5
		SetAnimationControl(target.effectList[effectType], baseX, baseY, timeRate)
		--target.effectList[99]:SetShow(true)
	elseif 96 == effectType then	-- 화살표
		-- 96 = 친밀도
		baseX = baseX - effectControlSetting[96]._sizeX
		baseY = baseY + 5
		SetAnimationControl(target.effectList[96], baseX, baseY, timeRate)
		--target.effectList[99]:SetShow(true)
	elseif 97 == effectType then	-- 화살표
		-- 97 = intimacy
		baseX = baseX - effectControlSetting[97]._sizeX
		baseY = baseY + 5
		SetAnimationControl(target.effectList[97], baseX, baseY, timeRate)
		--target.effectList[99]:SetShow(true)
	elseif 99 == effectType then
		-- 99 = 공헌도
		baseX = baseX - effectControlSetting[99]._sizeX
		baseY = baseY + 50
		SetAnimationControl(target.effectList[99], baseX, baseY - 50, timeRate)
	else
		UI.ASSERT(false, "이상한 효과번호가 들어옴.")
	end

	
	------------------------------------------------------------
	--				Additional Damage 처리
	------------------------------------------------------------
	if isDamageShow then
		if ( 0 == additionalDamageType ) and ( 1 == effectType ) then
			if attackeeIsSelfPlayer then
				target.effectList[7]:AddEffect( "Ui_Damage_CriticalBackattack_Red", false, 0, 0 )
				render_setPointBlur( 0.04, 0.03 )
				render_setColorBypass( 0.8, 0.15 )
				render_setColorBalance( float3 (-0.3, 0.0, 0.0), 0.12 )
			else
				target.effectList[7]:AddEffect( "Ui_Damage_CriticalBackattack_White", false, 0, 0 )
				-- ♬ 크리티컬 사운드!
				audioPostEvent_SystemUi3D(14,02, attackerActorKeyRaw)
				render_setChromaticBlur( 50, 0.10 )
				render_setPointBlur( 0.025, 0.03 )
				render_setColorBypass( 0.3, 0.08 )
			end
			baseX = baseX - ( effectControlSetting[7]._sizeX ) / 2
			SetAnimationControl(target.effectList[7], baseX, baseY , 10.0)
			
		elseif ( 0 == additionalDamageType ) then
			if attackeeIsSelfPlayer then
				target.effectList[7]:AddEffect( "Ui_Damage_Backattack_red", false, 0, 0 )
				render_setPointBlur( 0.04, 0.03 )
				render_setColorBypass( 0.8, 0.15 )
				render_setColorBalance( float3 (-0.3, 0.0, 0.0), 0.12 )
			else
				target.effectList[7]:AddEffect( "Ui_Damage_Backattack", false, 0, 0 )
				-- ♬ 백어택 사운드!
				audioPostEvent_SystemUi3D(14,00, attackerActorKeyRaw)
				render_setChromaticBlur( 50, 0.10 )
				render_setPointBlur( 0.025, 0.03 )
				render_setColorBypass( 0.3, 0.08 )
			end
			baseX = baseX - ( effectControlSetting[7]._sizeX ) / 2
			SetAnimationControl(target.effectList[7], baseX, baseY , 10.0)
			
		elseif ( 1 == additionalDamageType ) then
			-- UI.debugMessage('카운터 어택')
			if ( 1 == effectType ) then
				if attackeeIsSelfPlayer then
					target.effectList[8]:AddEffect( "Ui_Damage_CriticalCounter_Red", false, 0, 0 )
					render_setPointBlur( 0.04, 0.03 )
					render_setColorBypass( 0.8, 0.15 )
					render_setColorBalance( float3 (-0.3, 0.0, 0.0), 0.12 )
				else
					target.effectList[8]:AddEffect( "Ui_Damage_CriticalCounter_White", false, 0, 0 )
					-- ♬ 카운터 어택 사운드!
					audioPostEvent_SystemUi3D(14,02, attackerActorKeyRaw)
					-- audioPostEvent_SystemUi(14,01)
					render_setChromaticBlur( 65, 0.15 )
					render_setPointBlur( 0.025, 0.03 )
					render_setColorBypass( 0.3, 0.08 )
				end
			else
				if attackeeIsSelfPlayer then
					target.effectList[8]:AddEffect( "Ui_Damage_Counter", false, 0, 0 )
					render_setPointBlur( 0.04, 0.03 )
					render_setColorBypass( 0.8, 0.15 )
					render_setColorBalance( float3 (-0.3, 0.0, 0.0), 0.12 )
				else
					target.effectList[8]:AddEffect( "Ui_Damage_Counter", false, 0, 0 )
					-- ♬ 카운터 어택 사운드!
					audioPostEvent_SystemUi3D(14,02, attackerActorKeyRaw)
					-- audioPostEvent_SystemUi(14,01)
					render_setChromaticBlur( 65, 0.15 )
					render_setPointBlur( 0.025, 0.03 )
					render_setColorBypass( 0.3, 0.08 )
				end
			end
			CounterAttack_Show()
			baseX = baseX - ( effectControlSetting[8]._sizeX ) / 2
			SetAnimation_CounterAttack(target.effectList[8], baseX, baseY , timeRate)
			
		elseif ( 2 == additionalDamageType ) then
			-- UI.debugMessage('다운 어택')
			if ( 1 == effectType ) then
				if attackeeIsSelfPlayer then
					target.effectList[9]:AddEffect( "Ui_Damage_CriticalDownattack_Red", false, 0, 0 )
					render_setPointBlur( 0.04, 0.03 )
					render_setColorBypass( 0.8, 0.15 )
					render_setColorBalance( float3 (-0.3, 0.0, 0.0), 0.12 )
				else
					target.effectList[9]:AddEffect( "Ui_Damage_CriticalDownattack_White", false, 0, 0 )
					-- ♬ 다운 어택 사운드!
					audioPostEvent_SystemUi3D(14,03, attackerActorKeyRaw)
					render_setChromaticBlur( 55, 0.15 )
					render_setPointBlur( 0.025, 0.03 )
					render_setColorBypass( 0.3, 0.08 )
				end
			else
				if attackeeIsSelfPlayer then
					target.effectList[9]:AddEffect( "Ui_Damage_Downattack", false, 0, 0 )
					render_setPointBlur( 0.04, 0.03 )
					render_setColorBypass( 0.8, 0.15 )
					render_setColorBalance( float3 (-0.3, 0.0, 0.0), 0.12 )
				else
					target.effectList[9]:AddEffect( "Ui_Damage_Downattack", false, 0, 0 )
					-- ♬ 다운 어택 사운드!
					audioPostEvent_SystemUi3D(14,03, attackerActorKeyRaw)
					render_setChromaticBlur( 55, 0.15 )
					render_setPointBlur( 0.025, 0.03 )
					render_setColorBypass( 0.3, 0.08 )
				end
			end
			baseX = baseX - ( effectControlSetting[9]._sizeX ) / 2
			SetAnimation_CounterAttack(target.effectList[9], baseX, baseY , timeRate)
			
		elseif ( 3 == additionalDamageType ) then
			-- UI.debugMessage('스피드 어택')
			if ( 1 == effectType ) then
				if attackeeIsSelfPlayer then
					target.effectList[10]:AddEffect( "Ui_Damage_CriticalSpeedattack_Red", false, 0, 0 )
					render_setPointBlur( 0.04, 0.03 )
					render_setColorBypass( 0.8, 0.15 )
					render_setColorBalance( float3 (-0.3, 0.0, 0.0), 0.12 )
				else
					target.effectList[10]:AddEffect( "Ui_Damage_CriticalSpeedattack_White", false, 0, 0 )
					-- ♬ 스피드 어택 사운드!
					audioPostEvent_SystemUi3D(14,04, attackerActorKeyRaw)
					render_setChromaticBlur( 55, 0.15 )
					render_setPointBlur( 0.025, 0.03 )
					render_setColorBypass( 0.3, 0.08 )
				end
			else
				if attackeeIsSelfPlayer then
					target.effectList[10]:AddEffect( "Ui_Damage_Speedattack", false, 0, 0 )
					render_setPointBlur( 0.04, 0.03 )
					render_setColorBypass( 0.8, 0.15 )
					render_setColorBalance( float3 (-0.3, 0.0, 0.0), 0.12 )
				else
					target.effectList[10]:AddEffect( "Ui_Damage_Speedattack", false, 0, 0 )
					-- ♬ 스피드 어택 사운드!
					audioPostEvent_SystemUi3D(14,04, attackerActorKeyRaw)
					render_setChromaticBlur( 55, 0.15 )
					render_setPointBlur( 0.025, 0.03 )
					render_setColorBypass( 0.3, 0.08 )
				end
			end
			baseX = baseX - ( effectControlSetting[10]._sizeX ) / 2
			SetAnimation_CounterAttack(target.effectList[10], baseX, baseY , timeRate)

		elseif ( 4 == additionalDamageType ) then
			if ( 1 == effectType ) then
				if attackeeIsSelfPlayer then
					target.effectList[12]:AddEffect( "Ui_Damage_CriticalAirattack_Red", false, 0, 0 )
					render_setPointBlur( 0.04, 0.03 )
					render_setColorBypass( 0.8, 0.15 )
					render_setColorBalance( float3 (-0.3, 0.0, 0.0), 0.12 )
				else
					target.effectList[12]:AddEffect( "Ui_Damage_CriticalAirattack_White", false, 0, 0 )
					-- ♬ 에어 어택 사운드!
					audioPostEvent_SystemUi3D(14,05, attackerActorKeyRaw)
					render_setChromaticBlur( 55, 0.15 )
					render_setPointBlur( 0.025, 0.03 )
					render_setColorBypass( 0.3, 0.08 )
				end
			else
				if attackeeIsSelfPlayer then
					target.effectList[12]:AddEffect( "Ui_Damage_Airattack", false, 0, 0 )
					render_setPointBlur( 0.04, 0.03 )
					render_setColorBypass( 0.8, 0.15 )
					render_setColorBalance( float3 (-0.3, 0.0, 0.0), 0.12 )
				else
					target.effectList[12]:AddEffect( "Ui_Damage_Airattack", false, 0, 0 )
					-- ♬ 에어 어택 사운드!
					audioPostEvent_SystemUi3D(14,05, attackerActorKeyRaw)
					render_setChromaticBlur( 55, 0.15 )
					render_setPointBlur( 0.025, 0.03 )
					render_setColorBypass( 0.3, 0.08 )
				end
			end
			baseX = baseX - ( effectControlSetting[12]._sizeX ) / 2
			SetAnimation_CounterAttack(target.effectList[12], baseX, baseY , timeRate)
			
		elseif ( 1 == effectType ) then
			if attackeeIsSelfPlayer then
				target.effectList[1]:AddEffect( "Ui_Damage_Critical", false, 0, 0 )
				render_setPointBlur( 0.045, 0.05 )
				render_setColorBypass( 0.8, 0.15 )
				-- render_setColorBalance( 0.5, 0.0, 0.0, 5.5 )
			else
				target.effectList[1]:AddEffect( "Ui_Damage_Critical", false, 0, 0 )
				-- ♬ 크리티컬 사운드!
				audioPostEvent_SystemUi3D(14,02, attackerActorKeyRaw)
				render_setChromaticBlur( 70, 0.09 )
				render_setPointBlur( 0.025, 0.03 )
				render_setColorBypass( 0.5, 0.08 )
			end
			baseX = baseX - ( effectControlSetting[1]._sizeX ) / 2
			SetAnimation_CounterAttack(target.effectList[1], baseX, baseY , timeRate)

		elseif ( 99 == additionalDamageType ) then
			-- _PA_LOG("LUA", "addtional")
		end
	end
	
	local actorWrapper = getActor(attakeeKeyRaw)
	if ( isShowKindDamage ) then
		if ( nil ~= actorWrapper ) then
			local checkMonsterType = actorWrapper:getCharacterStaticStatusWrapper():getTribeType()
			target.effectList[13]:EraseAllEffect()
			
			if ( CppEnums.TribeType.eTribe_Human == checkMonsterType ) then				-- 인간족
				target.effectList[13]:AddEffect( "UI_Tribe_Hit_Human", true, 0, 0 )
			elseif ( CppEnums.TribeType.eTribe_Ain == checkMonsterType ) then			-- 아인
				target.effectList[13]:AddEffect( "UI_Tribe_Hit_Ain", true, 0, 0 )
			elseif ( CppEnums.TribeType.eTribe_Animal == checkMonsterType ) then		-- 동물
				target.effectList[13]:AddEffect( "UI_Tribe_Hit_Animal", true, 0, 0 )
			elseif ( CppEnums.TribeType.eTribe_Undead == checkMonsterType ) then		-- 언데드
				target.effectList[13]:AddEffect( "UI_Tribe_Hit_Undead", true, 0, 0 )
			elseif ( CppEnums.TribeType.eTribe_Reptile == checkMonsterType ) then		-- 파충류
				target.effectList[13]:AddEffect( "UI_Tribe_Hit_Reptile", true, 0, 0 )
			elseif ( CppEnums.TribeType.eTribe_Untribe == checkMonsterType ) then		-- 무분류
				target.effectList[13]:AddEffect( "UI_Tribe_Hit_Solidity", true, 0, 0 )
			else	
				target.effectList[13]:AddEffect( "UI_Tribe_Hit_Solidity", true, 0, 0 )
				--UI_Tribe_Hit_Solidity -- 견고함
			end
		end

		baseX = baseX - ( effectControlSetting[13]._sizeX ) / 2
		SetAnimation_KindDamage(target.effectList[13], baseX, baseY, timeRate)
		-- _PA_LOG("LUA", "여기까지 오긴 하네?")
	end
	

	if ( 96 == effectType ) or ( 97 == effectType ) or ( 93 == effectType ) then
		local arrowControl = target.effectList[94]
		if ( effectNumber < 0 ) then
			arrowControl = target.effectList[95]
			target.effectList[94]:ResetVertexAni(true)
		else
			arrowControl = target.effectList[94]
			target.effectList[95]:ResetVertexAni(true)
		end

		baseX = baseX + ( effectControlSetting[effectType]._sizeX )
		SetAnimationControl(arrowControl, baseX, (baseY + 10), timeRate)
	end
end


function FGlobal_SetMamageShow()
	isShowAttackEffect = ToClient_getRenderHitEffect()
end

registerEvent("addDamage",							"DamageOutputFunction_OnDamage")
registerEvent("gainExplorationExperience",			"DamageOutputFunction_gainExperience")
registerEvent("FromClient_VaryIntimacy",			"FromClient_VaryIntimacy")
registerEvent("FromClient_TendencyChanged",			"FromClient_TendencyChanged")
registerEvent("FromClient_WpChangedWithParam",		"FromClient_WpChanged")
registerEvent("update_Monster_Info_Req", 			"panel_Update_Monster_Info")

initialize()