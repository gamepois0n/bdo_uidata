Panel_MainStatus_User_Bar:SetShow(true )
-- Panel_MainStatus_User_Bar:ActiveMouseEventEffect( true )
Panel_MainStatus_User_Bar:RegisterShowEventFunc( true, 'mainStatus_AniOpen()' )
Panel_MainStatus_User_Bar:RegisterShowEventFunc( false, 'mainStatus_AniClose()' )


local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_AH = CppEnums.PA_UI_ALIGNHORIZON
local UI_color = Defines.Color
local UI_classType = CppEnums.ClassType
local _damageByOtherPlayer_Time = 0	-- 다른 유저에게 대미지를 입은 최초 시간 설정.

local now_HpBarBurn	= false	-- 피격시 이팩트 상태를 저장하는 변수
local HpBarBurnTimer = 0	-- 피격시 이팩트가 켜진 시간을 저장하는 변수
local now_PercentHp	= 100

local _alertDanger = UI.getChildControl (Panel_Danger, "Static_Alert" )									-- HP 없을 때 번쩍번쩍 (화면)
local _alertGauge = UI.getChildControl (Panel_MainStatus_User_Bar, "Static_GaugeAlert" )				-- HP 없을 때 번쩍번쩍 (게이지)
local _gauge100per = UI.getChildControl (Panel_MainStatus_User_Bar, "Static_100per" )					-- HP 100% 때 번쩍번쩍 (게이지)
--local _close_MainStatus = UI.getChildControl ( Panel_MainStatus_User_Bar, "Button_Win_Close" )
local mainBarText = UI.getChildControl ( Panel_MainStatus_User_Bar, "StaticText_MainBarText" )

local SimpleUIFadeRate = 1.0;

local selfPlayerStatusBar =
{
	-- 컨트롤
	-- _staticSkillExp = UI.getChildControl( Panel_MainStatus_User_Bar, "CircularProgress_SkillExp" ),
	-- _staticSkillPoint = UI.getChildControl( Panel_MainStatus_User_Bar, "StaticText_SkillPoint" ),
	-- _staticSkillIcon = UI.getChildControl( Panel_MainStatus_User_Bar, "Static_SkillIcon" ),

	_staticHP_BG 			= UI.getChildControl( Panel_MainStatus_User_Bar, "Static_HP_MainBG" ),
	_staticMP_BG 			= UI.getChildControl( Panel_MainStatus_User_Bar, "Static_MP_MainBG" ),
	
	_staticText_HP 			= UI.getChildControl( Panel_MainStatus_User_Bar, "StaticText_HP" ),
	_staticText_MP 			= UI.getChildControl( Panel_MainStatus_User_Bar, "StaticText_MP" ),

	_staticTexture_MP 		= UI.getChildControl( Panel_MainStatus_User_Bar, "Static_Texture_MP" ),
	_staticTexture_FP 		= UI.getChildControl( Panel_MainStatus_User_Bar, "Static_Texture_FP" ),
	_staticTexture_CP 		= UI.getChildControl( Panel_MainStatus_User_Bar, "Static_Texture_CP" ),
	_staticTexture_EP 		= UI.getChildControl( Panel_MainStatus_User_Bar, "Static_Texture_EP" ),
	_staticTexture_BP 		= UI.getChildControl( Panel_MainStatus_User_Bar, "Static_Texture_BP" ),

	_staticGage_HP 			= UI.getChildControl( Panel_MainStatus_User_Bar, "Progress_HPGauge" ),
	_staticGage_HP_Later 	= UI.getChildControl( Panel_MainStatus_User_Bar, "Progress2_HpGaugeLater" ),
	_staticShowHp	 		= UI.getChildControl( Panel_MainStatus_User_Bar, "StaticText_HPText" ),
	_staticShowMp	 		= UI.getChildControl( Panel_MainStatus_User_Bar, "StaticText_MPText" ),
	_staticGage_CombatResource = nil,

	define =
	{
		MP = 0,
		FP = 1,
		EP = 2,
		BP = 3,
	},
	_combatResources = 
	{
		-- 순서가 중요하다!
		[0] = UI.getChildControl( Panel_MainStatus_User_Bar, "Progress_MPGauge" ),
		UI.getChildControl( Panel_MainStatus_User_Bar, "Progress_FPGauge" ),
		UI.getChildControl( Panel_MainStatus_User_Bar, "Progress_EPGauge" ),
		UI.getChildControl( Panel_MainStatus_User_Bar, "Progress_BPGauge" ),
	},
	-- MP용 흰색 게이지
	_combatResources_Later 		= UI.getChildControl( Panel_MainStatus_User_Bar, "Progress2_MpGaugeLater" ),
	_combatResources_LaterHead 	= UI.getChildControl( UI.getChildControl( Panel_MainStatus_User_Bar, "Progress2_MpGaugeLater" ), "Progress2_1_Bar_Head" ),
	
	config =
	{
		hpGageMaxSize = 0,
		mpGageMaxSize = 0
	},

	posX = Panel_MainStatus_User_Bar:GetPosX(),
	posY = Panel_MainStatus_User_Bar:GetPosY(),
	initPosX = Panel_MainStatus_User_Bar:GetPosX(),
	initPosY = Panel_MainStatus_User_Bar:GetPosY(),
}

Panel_Danger:SetIgnore( true )
_alertDanger:SetIgnore( true )
_gauge100per:SetIgnore( true )
--_close_MainStatus:SetShow( false )
selfPlayerStatusBar._staticHP_BG:SetIgnore( false )
selfPlayerStatusBar._staticMP_BG:SetIgnore( false )

local _hpGaugeHead = UI.getChildControl ( selfPlayerStatusBar._staticGage_HP, "Progress_HPHead" )

-- MP류 가져오기
local _mpGauge = UI.getChildControl( Panel_MainStatus_User_Bar, "Progress_MPGauge")
local _fpGauge = UI.getChildControl( Panel_MainStatus_User_Bar, "Progress_FPGauge" )
local _epGauge = UI.getChildControl( Panel_MainStatus_User_Bar, "Progress_EPGauge" )
local _bpGauge = UI.getChildControl( Panel_MainStatus_User_Bar, "Progress_BPGauge" )

local _mpGaugeHead = UI.getChildControl ( _mpGauge, "Progress_MPHead" )
local _fpGaugeHead = UI.getChildControl ( _fpGauge, "Progress_FPHead" )
local _epGaugeHead = UI.getChildControl ( _epGauge, "Progress_EPHead" )
local _bpGaugeHead = UI.getChildControl ( _bpGauge, "Progress_BPHead" )

local _hpGauge_Back = UI.getChildControl( Panel_MainStatus_User_Bar, "Static_HPGage_Back")
local _mpGauge_Back = UI.getChildControl( Panel_MainStatus_User_Bar, "Static_MPGage_Back")


function selfPlayerStatusBar:init()
	self._staticGage_CombatResource = self._combatResources[self.define.MP]				-- 일단은 기본 값으로 MP 를 설정.

	self.config.hpGageMaxSize = self._staticGage_HP:GetSizeX()
	self.config.mpGageMaxSize = self._staticGage_CombatResource:GetSizeX()
	
	Panel_MainStatus_User_Bar:addInputEvent("Mouse_PressMove", "SelfPlayerStatusBar_RefleshPosition()")
	Panel_MainStatus_User_Bar:addInputEvent("Mouse_LUp", "SelfPlayerStatusBar_RefleshPosition()")

end

function selfPlayerStatusBar:checkLoad()
	-- UI.ASSERT( nil ~= self._staticSkillExp		and self._staticSkillExp.__name == 'PAUICircularProgress',		"Fail to load control" )
	-- UI.ASSERT( nil ~= self._staticSkillPoint	and self._staticSkillPoint.__name == 'PAUIStatic',				"Fail to load control" )
	-- UI.ASSERT( nil ~= self._staticSkillIcon		and self._staticSkillIcon.__name == 'PAUIPureStatic',			"Fail to load control" )

	UI.ASSERT( nil ~= self._staticText_HP		and self._staticText_HP.__name == 'PAUIStatic',					"Fail to load control" )
	UI.ASSERT( nil ~= self._staticText_MP		and self._staticText_MP.__name == 'PAUIStatic',					"Fail to load control" )

	UI.ASSERT( nil ~= self._staticGage_HP		and self._staticGage_HP.__name == 'PAUIProgress',				"Fail to load control" )
	UI.ASSERT( nil ~= self._combatResources[0]	and self._combatResources[0].__name == 'PAUIProgress',			"Fail to load control" )
	UI.ASSERT( nil ~= self._combatResources[1]	and self._combatResources[1].__name == 'PAUIProgress',			"Fail to load control" )
	UI.ASSERT( nil ~= self._combatResources[2]	and self._combatResources[2].__name == 'PAUIProgress',			"Fail to load control" )
	UI.ASSERT( nil ~= self._combatResources[3]	and self._combatResources[3].__name == 'PAUIProgress',			"Fail to load control" )
end

function selfPlayerStatusBar:resourceTypeCheck( selfPlayerWrapper )
	local resourceType		= selfPlayerWrapper:getCombatResourceType()
	local isColorBlindMode	= ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(CppEnums.GlobalUIOptionType.ColorBlindMode)
	if (self.define.MP <= resourceType) then -- and (resourceType <= self.define.CP) 해당 조건이 뭔진 모르겠지만 있었음...
		self._staticGage_CombatResource = self._combatResources[resourceType]
	else
		UI.ASSERT( false, "SelfPlayer Combat Resource Type is INVALID!!!!" )
	end

	for _,control in pairs(self._combatResources) do
		control:SetShow( false )
	end

	if (0 == isColorBlindMode) then
		-- MP 바
		self._staticGage_CombatResource:ChangeTextureInfoName( "new_ui_common_forlua/default/Default_Gauges_01.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( self._staticGage_CombatResource, 0, 52, 255, 61 )
		if (0 == resourceType) then		-- MP(소서러, 금수랑)
			x1, y1, x2, y2 = setTextureUV_Func( self._staticGage_CombatResource, 0, 52, 255, 61 )
		elseif (1 == resourceType) then	-- FP(워리어, 자이언트, 무사/매화, 닌자,쿠노이치)
			x1, y1, x2, y2 = setTextureUV_Func( self._staticGage_CombatResource, 0, 42, 255, 51 )
		elseif (2 == resourceType) then	-- EP(레인저)
			x1, y1, x2, y2 = setTextureUV_Func( self._staticGage_CombatResource, 0, 62, 255, 71 )
		elseif (3 == resourceType) then	-- BP(발키리)
			x1, y1, x2, y2 = setTextureUV_Func( self._staticGage_CombatResource, 0, 226, 256, 235 )
		end
		self._staticGage_CombatResource:getBaseTexture():setUV(  x1, y1, x2, y2  )
		self._staticGage_CombatResource:setRenderTexture(self._staticGage_CombatResource:getBaseTexture())

		-- HP바
		self._staticGage_HP:ChangeTextureInfoName( "new_ui_common_forlua/default/Default_Gauges_01.dds" )
		local xx1, yy1, xx2, yy2 = setTextureUV_Func( self._staticGage_HP, 0, 0, 255, 9 )
		self._staticGage_HP:getBaseTexture():setUV( xx1, yy1, xx2, yy2 )
		self._staticGage_HP:setRenderTexture(self._staticGage_HP:getBaseTexture())
	elseif (1 == isColorBlindMode) then
		-- MP바
		self._staticGage_CombatResource:ChangeTextureInfoName( "new_ui_common_forlua/default/Default_Gauges_01.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( self._staticGage_CombatResource, 1, 236, 256, 244 )	-- 원래 노란색	206, 96, 255, 99
		self._staticGage_CombatResource:getBaseTexture():setUV(  x1, y1, x2, y2  )
		self._staticGage_CombatResource:setRenderTexture(self._staticGage_CombatResource:getBaseTexture())

		-- HP바
		self._staticGage_HP:ChangeTextureInfoName( "new_ui_common_forlua/default/Default_Gauges_01.dds" )
		local xx1, yy1, xx2, yy2 = setTextureUV_Func( self._staticGage_HP, 1, 226, 256, 234 )
		self._staticGage_HP:getBaseTexture():setUV( xx1, yy1, xx2, yy2 )
		self._staticGage_HP:setRenderTexture(self._staticGage_HP:getBaseTexture())
	elseif (2 == isColorBlindMode) then
		-- MP바
		self._staticGage_CombatResource:ChangeTextureInfoName( "new_ui_common_forlua/default/Default_Gauges_01.dds" )
		local x1, y1, x2, y2 = setTextureUV_Func( self._staticGage_CombatResource, 1, 236, 256, 244 )	-- 원래 노란색	206, 96, 255, 99
		self._staticGage_CombatResource:getBaseTexture():setUV(  x1, y1, x2, y2  )
		self._staticGage_CombatResource:setRenderTexture(self._staticGage_CombatResource:getBaseTexture())

		-- HP바
		self._staticGage_HP:ChangeTextureInfoName( "new_ui_common_forlua/default/Default_Gauges_01.dds" )
		local xx1, yy1, xx2, yy2 = setTextureUV_Func( self._staticGage_HP, 1, 226, 256, 234 )
		self._staticGage_HP:getBaseTexture():setUV( xx1, yy1, xx2, yy2 )
		self._staticGage_HP:setRenderTexture(self._staticGage_HP:getBaseTexture())
	end

	self._staticGage_CombatResource:SetShow( true )
	self._combatResources_Later:SetShow( true )
end

local prevHP = -1
local prevMaxHP = -1
local prevMP = -1
local prevMaxMP = -1

local screenSizeX = getScreenSizeX()
local screenSizeY = getScreenSizeY()
local strongMonsterAlert = false
local checkHpAlert = function( hp, maxHp, isLevelUp )
	local isUpdate = ( Defines.UIMode.eUIMode_Default == GetUIMode() ) --전체화면 모드가 아닐때만 update를 걸수 있다.
	if ( false == isUpdate ) then
		-- _alertDanger:ResetVertexAni()
		_alertDanger:SetShow(false)
		return
	end
	if false == global_danger_MessageShow and false == isLevelUp then
		return
	end
	-- 토탈 HP 를 통해 화면 깜빡이기
	local totalHp = ( hp / maxHp * 100 )
	
	if ( 99.99 >= totalHp ) and false == strongMonsterAlert then
		_hpGaugeHead:SetShow( true )
	end
	
	if ( totalHp == 100 ) and false == strongMonsterAlert then
		_hpGaugeHead:SetShow( false )
	end
	
	if ( totalHp >= 40 ) and false == strongMonsterAlert then
		selfPlayerStatusBar._staticText_HP:SetFontColor(UI_color.C_FFF0EF9D)
		-- _alertGauge:SetShow ( false )
		Panel_Danger:SetShow ( false, false )
		-- _alertDanger:ResetVertexAni()
		_alertDanger:SetAlpha(0)
	end	
	
	if ( totalHp <= 39 ) and ( totalHp >= 20 ) then
		selfPlayerStatusBar._staticText_HP:SetFontColor( UI_color.C_FFF26A6A )

		if false == Panel_Danger:GetShow() then
			Panel_Danger:SetShow ( true, false )
			-- _alertDanger:ResetVertexAni()
			_alertDanger:SetAlpha(1)
		end
		if false == _alertDanger:GetShow() then
			_alertDanger:SetShow ( true )
		end
		_alertDanger:SetVertexAniRun ( "Ani_Color_Danger0", true )
	end
	
	if ( totalHp <= 19 and totalHp >= 0 ) then

		if false == Panel_Danger:GetShow() then
			Panel_Danger:SetShow ( true, false )
			-- _alertDanger:ResetVertexAni()
			_alertDanger:SetAlpha(1)
		end
		if false == _alertDanger:GetShow() then
			_alertDanger:SetShow ( true )
		end		
		_alertDanger:SetVertexAniRun ( "Ani_Color_Danger1", true )
	end
end

function FGlobal_DangerAlert_Show( isShow )
	if false == isShow then
		Panel_Danger:SetShow ( false, false )
		strongMonsterAlert = false
		return
	end
	strongMonsterAlert = true
	if true ~= Panel_Danger:GetShow() then
		Panel_Danger:SetShow ( true, false )
		-- _alertDanger:ResetVertexAni()
		_alertDanger:SetAlpha(1)
	end
	if false == _alertDanger:GetShow() then
		_alertDanger:SetShow ( true )
	end		
	_alertDanger:SetVertexAniRun ( "Ani_Color_Danger1", true )
end

function checkHpAlertPostEvent()
	checkHpAlert(1,1,false)
end

UI.addRunPostFlushFunction( checkHpAlertPostEvent )
UI.addRunPostRestorFunction( checkHpAlertPostEvent )

local checkMpAlert = function( mp, maxMp )
	local totalMp = ( mp / maxMp * 100 )
	if 99.99 >= totalMp then
		_fpGaugeHead:SetShow( true )
		_mpGaugeHead:SetShow( true )
		_epGaugeHead:SetShow( true )
		_bpGaugeHead:SetShow( true )
	end
	if totalMp == 100 then
		_fpGaugeHead:SetShow( false )
		_mpGaugeHead:SetShow( false )
		_epGaugeHead:SetShow( false )
		_bpGaugeHead:SetShow( false )
	end
end

-- 다른 플레이어가 공격하면, 이 함수가 실행된다.
function DamageByOtherPlayer()
	if ( now_HpBarBurn == false ) then	-- 이팩트가 없으면 켠다.
		now_HpBarBurn = selfPlayerStatusBar._staticHP_BG:EraseAllEffect()
		now_HpBarBurn = selfPlayerStatusBar._staticHP_BG:AddEffect("fUI_Gauge_PvP", false, 0, 0)
		HpBarBurnTimer = 0
		
		-- if  isPvpEnable() and (false == isFlushedUI()) and (false == getPvPMode()) then
			-- requestTogglePvP()
		-- end
		--Panel_PvpMode_InputRage(true)
	end
end

-- 다른 플레이어가 공격하면 켜지는 이팩트를 끄기 위해
function DamageByOtherPlayer_chkOnEffectTime( DeltaTime )
	HpBarBurnTimer = HpBarBurnTimer + DeltaTime

	-- 10 이상이고, 이펙트가 있다면, 이팩트를 지운다.
	if ( HpBarBurnTimer > 10) and ( now_HpBarBurn ~= false ) then
		selfPlayerStatusBar._staticHP_BG:EraseEffect(now_HpBarBurn)
		now_HpBarBurn = false
		HpBarBurnTimer = 0
	end

	-- 괜히 카운트 말고 리셋!
	if HpBarBurnTimer > 12 then
		HpBarBurnTimer = 0
	end
end

function Panel_MainStatus_EnableSimpleUI()
	SimpleUIFadeRate = 1.0;
	Panel_MainStatus_SetAlphaAllChild( 1.0 );
end
function Panel_MainStatus_DisableSimpleUI()
	SimpleUIFadeRate = 1.0;
	Panel_MainStatus_SetAlphaAllChild( 1.0 );
end
function Panel_MainStatus_UpdateSimpleUI( DeltaTime )
	SimpleUIFadeRate = SimpleUIFadeRate - DeltaTime;
	if SimpleUIFadeRate < 0.0 then
		SimpleUIFadeRate = 0.0
	end
	
	if getPvPMode() then
		SimpleUIFadeRate = 1.0
	end
	
	local alphaRate = SimpleUIFadeRate;
	if (alphaRate > 1.0) then
		alphaRate = 1.0
	end
	
	Panel_MainStatus_SetAlphaAllChild(alphaRate);
end
registerEvent( "SimpleUI_UpdatePerFrame",		"Panel_MainStatus_UpdateSimpleUI")
registerEvent( "EventSimpleUIEnable",			"Panel_MainStatus_EnableSimpleUI")
registerEvent( "EventSimpleUIDisable",			"Panel_MainStatus_DisableSimpleUI")

function Panel_MainStatus_SetAlphaAllChild( alphaRate )
	local self			= selfPlayerStatusBar
	Panel_MainStatus_User_Bar				:SetAlpha(alphaRate);
				
	self._staticHP_BG 						:SetAlpha(alphaRate);
	self._staticMP_BG 						:SetAlpha(alphaRate);
		
	self._staticText_HP 					:SetAlpha(alphaRate);
	self._staticText_MP 					:SetAlpha(alphaRate);
		
	self._staticTexture_MP 					:SetAlpha(alphaRate);
	self._staticTexture_FP 					:SetAlpha(alphaRate);
	self._staticTexture_CP 					:SetAlpha(alphaRate);
	self._staticTexture_EP 					:SetAlpha(alphaRate);
	self._staticTexture_BP 					:SetAlpha(alphaRate);

	self._staticGage_HP 					:SetAlpha(alphaRate);
	self._staticGage_HP_Later 				:SetAlpha(alphaRate);
	self._staticGage_CombatResource			:SetAlpha(alphaRate);
	self._combatResources_Later			 	:SetAlpha(alphaRate);
	self._combatResources_LaterHead			:SetAlpha(alphaRate);
	
	_hpGaugeHead							:SetAlpha(alphaRate);
	_mpGaugeHead							:SetAlpha(alphaRate);
	_fpGaugeHead							:SetAlpha(alphaRate);
	_epGaugeHead							:SetAlpha(alphaRate);
	_bpGaugeHead							:SetAlpha(alphaRate);
	
	_hpGauge_Back							:SetAlpha(alphaRate);
	_mpGauge_Back							:SetAlpha(alphaRate);
	
	self._staticShowHp	 					:SetFontAlpha(alphaRate);
	self._staticShowMp	 					:SetFontAlpha(alphaRate);
end

function FGlobal_MainStatus_FadeIn( viewTime )
	SimpleUIFadeRate = viewTime
end

-- 시간을 구하기 위해 Loop를 돌린다.
Panel_MainStatus_User_Bar:RegisterUpdateFunc("DamageByOtherPlayer_chkOnEffectTime")

function FGlobal_ImmediatelyResurrection( resurrFunc )
	now_PercentHp = resurrFunc
end

function Panel_MainStatus_User_Bar_CharacterInfoWindowUpdate()
	local self			= selfPlayerStatusBar
	local playerWrapper = getSelfPlayer()
	local player		= playerWrapper:get()

	self:resourceTypeCheck( playerWrapper )

	-- HP
	local hp	= player:getHp()
	local maxHp = math.floor(player:getMaxHp())
	local percentHp = math.floor( hp / maxHp * 100 )
	if 20 > percentHp and now_PercentHp > percentHp then
		-- if 0 ~= percentHp then
			local sendMsg = {main = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTER_HP_WARNING"), sub = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTER_HP_WARNING_SUB"), addMsg = "" }
			Proc_ShowMessage_Ack_For_RewardSelect( sendMsg, 3, 24 )
			now_PercentHp = percentHp
		-- end
	end
	
	if 0 ~= maxHp and (hp ~= prevHP or maxHp ~= prevMaxHP) then
		self._staticShowHp:SetText( tostring(hp).."/"..tostring(maxHp) )
		self._staticGage_HP_Later:SetProgressRate( hp / maxHp * 100 )
		self._staticGage_HP:SetProgressRate( hp / maxHp * 100 )
		
		if ( 5 < hp - prevHP ) then
			local HP_BG_PosX = self._staticHP_BG:GetPosX()
			local HP_BG_PosY = self._staticHP_BG:GetPosY()
			self._staticGage_HP:AddEffect( "fUI_Gauge_Red", false, 0.0, 0.0 )
		end
		FGlobal_MainStatus_FadeIn( 5.0 );
		
		prevHP = hp
		prevMaxHP = maxHp
		checkHpAlert(hp, maxHp, false)
	end

	local effectName		= ""
	local isEP_Character	= (UI_classType.ClassType_Ranger == playerWrapper:getClassType())
	local isFP_Character	= (UI_classType.ClassType_Warrior == playerWrapper:getClassType()) or  (UI_classType.ClassType_Giant == playerWrapper:getClassType())
		or (UI_classType.ClassType_BladeMaster == playerWrapper:getClassType()) or (UI_classType.ClassType_BladeMasterWomen == playerWrapper:getClassType())
		or (UI_classType.ClassType_NinjaWomen == playerWrapper:getClassType())
	local isBP_Character	= (UI_classType.ClassType_Valkyrie == playerWrapper:getClassType())
	local isMP_Character	= (not isEP_Character) and (not isFP_Character) and (not isBP_Character)
	local isColorBlindMode	= ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(CppEnums.GlobalUIOptionType.ColorBlindMode)

	self._staticTexture_EP:SetShow( isEP_Character )
	self._staticTexture_MP:SetShow( isMP_Character )
	self._staticTexture_FP:SetShow( isFP_Character )
	self._staticTexture_BP:SetShow( isBP_Character )

	if isEP_Character then		-- FP
		effectName = "fUI_Gauge_Green"
	elseif isFP_Character then	-- FP
		effectName = "fUI_Gauge_Mental"
	elseif isBP_Character then	-- BP
		effectName = "fUI_Gauge_Blue"	-- 임시
	elseif isMP_Character then	-- MP
		effectName = "fUI_Gauge_Blue"
	end
	
	local mp = player:getMp()
	_prevMPSize = mp
	local maxMp = player:getMaxMp()
	if 0 ~= maxMp and (mp ~= prevMP or maxMp ~= prevMaxMP) then
		self._staticShowMp:SetText( tostring(mp).."/"..tostring(maxMp) )
		self._staticGage_CombatResource:SetProgressRate( mp / maxMp * 100 )
		self._staticGage_CombatResource:SetShow( true )
		self._combatResources_Later:SetProgressRate( mp / maxMp * 100 )
		self._combatResources_Later:SetShow( true )

		if ( 10 < mp - prevMP ) then
			local MP_BG_PosX = self._staticMP_BG:GetPosX()
			local MP_BG_PosY = self._staticMP_BG:GetPosY()
			self._staticGage_CombatResource:AddEffect( effectName, false, 0.0, 0.0 )
		end
		FGlobal_MainStatus_FadeIn( 5.0 );
		
		prevMP = mp
		checkMpAlert(mp, maxMp)
		prevMaxMP = maxMp	
	end
	self._staticText_HP:SetPosX((3.09 * self._staticGage_HP:GetProgressRate()) + 30)
	self._staticText_MP:SetPosX((3.09 * self._staticGage_CombatResource:GetProgressRate()) + 30)
	self._staticShowHp:SetPosX((3.09 * self._staticGage_HP:GetProgressRate()) + 40)
	self._staticShowHp:SetPosY( 10 )
	self._staticShowMp:SetPosX((3.09 * self._staticGage_CombatResource:GetProgressRate()) + 40)
	self._staticShowMp:SetPosY( 55 )


	FGlobal_SettingMpBarTemp()
end

function Panel_MainStatus_User_Bar_Onresize()
	Panel_Danger:SetPosX( 0 )
	_alertDanger:SetSize( getScreenSizeX(), getScreenSizeY() )

	Panel_MainStatus_User_Bar:ComputePos()
	Panel_MainStatus_User_Bar:SetPosX( (getScreenSizeX()/2) - (Panel_MainStatus_User_Bar:GetSizeX()/2) )
	Panel_MainStatus_User_Bar:SetPosY( getScreenSizeY() - Panel_QuickSlot:GetSizeY() - Panel_MainStatus_User_Bar:GetSizeY() )
	changePositionBySever(Panel_MainStatus_User_Bar, CppEnums.PAGameUIType.PAGameUIPanel_MainStatusBar, true, true, false)

	if getScreenSizeX() < Panel_MainStatus_User_Bar:GetPosX() or getScreenSizeY() < Panel_MainStatus_User_Bar:GetPosY() then
		Panel_MainStatus_User_Bar:ComputePos()
		Panel_MainStatus_User_Bar:SetPosX( (getScreenSizeX()/2) - (Panel_MainStatus_User_Bar:GetSizeX()/2) )
		Panel_MainStatus_User_Bar:SetPosY( getScreenSizeY() - Panel_QuickSlot:GetSizeY() - Panel_MainStatus_User_Bar:GetSizeY() )
	end
end

function refreshHpAlertForLevelup()
	local playerWrapper = getSelfPlayer()
	local player = playerWrapper:get()

	local hp = player:getHp()
	local maxHp = player:getMaxHp()

	checkHpAlert(hp, maxHp, true)
end

function selfPlayerStatusBar:registMessageHandler()
	-- 캐릭터정보 업데이트 이벤트 함수 등록
	-- EventCharacterInfoUpdate : UI Reload를 했을 때처럼 UI가 한꺼번에 업데이트 되는 상황일 때만 호출
	registerEvent("EventCharacterInfoUpdate", "Panel_MainStatus_User_Bar_CharacterInfoWindowUpdate")
	
	registerEvent("FromClient_SelfPlayerHpChanged", "Panel_MainStatus_User_Bar_CharacterInfoWindowUpdate")
	registerEvent("FromClient_SelfPlayerMpChanged", "Panel_MainStatus_User_Bar_CharacterInfoWindowUpdate")
	
	registerEvent("onScreenResize", "Panel_MainStatus_User_Bar_Onresize")
	registerEvent("EventSelfPlayerLevelUp", "refreshHpAlertForLevelup")
	registerEvent("FromClient_DamageByOtherPlayer", "DamageByOtherPlayer")	-- 다른 유저한테 대미지를 입으면 이팩트 재생
	
	-- 마우스온 시 수치 표시
	selfPlayerStatusBar._staticHP_BG:addInputEvent( "Mouse_On", "HP_TextOn()" )
	selfPlayerStatusBar._staticHP_BG:addInputEvent( "Mouse_Out", "HP_TextOff()" )
	selfPlayerStatusBar._staticMP_BG:addInputEvent( "Mouse_On", "MP_TextOn()" )
	selfPlayerStatusBar._staticMP_BG:addInputEvent( "Mouse_Out", "MP_TextOff()" )
end

-- 초기화 코드!!!
selfPlayerStatusBar:checkLoad()		-- 서비스 버전에서는 없어도 된다.
selfPlayerStatusBar:init()
selfPlayerStatusBar:registMessageHandler()

function SelfPlayerStatusBar_RefleshPosition()
	selfPlayerStatusBar.posX = Panel_MainStatus_User_Bar:GetPosX()
	selfPlayerStatusBar.posY = Panel_MainStatus_User_Bar:GetPosY()
end


function SelfPlayerStatusBar_Vibrate_ByDamage( damagePercent, isbackAttack, isCritical )
	local periodTime = 0.015
	local moveCount = 6
	local randomizeValue = 7

	for idx = 0 , moveCount do
		local aniInfo0 = Panel_MainStatus_User_Bar:addMoveAnimation( periodTime * idx , periodTime * ( idx + 1 ) , UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
		aniInfo0.StartHorizonType = UI_AH.PA_UI_HORIZON_LEFT
		aniInfo0.EndHorizonType = UI_AH.PA_UI_HORIZON_LEFT
		aniInfo0:SetStartPosition( selfPlayerStatusBar.posX + getRandomValue(-randomizeValue, randomizeValue), selfPlayerStatusBar.posY + getRandomValue(-randomizeValue, randomizeValue))
		aniInfo0:SetEndPosition(selfPlayerStatusBar.posX + getRandomValue(-randomizeValue, randomizeValue), selfPlayerStatusBar.posY + getRandomValue(-randomizeValue, randomizeValue))
	end

	local endTime = periodTime * ( moveCount + 1 )

	local periodTime_vertical = 0.012
	local moveCount_vertical = 4
	local randomizeValue_vertical = 8

	for idx = 0 , moveCount_vertical do
		local aniInfo0 = Panel_MainStatus_User_Bar:addMoveAnimation( endTime + periodTime_vertical * idx , endTime + periodTime_vertical * ( idx + 1 ) , UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
		aniInfo0.StartHorizonType = UI_AH.PA_UI_HORIZON_LEFT
		aniInfo0.EndHorizonType = UI_AH.PA_UI_HORIZON_LEFT
		aniInfo0:SetStartPosition( selfPlayerStatusBar.posX , selfPlayerStatusBar.posY + getRandomValue(-randomizeValue_vertical, randomizeValue_vertical))
		aniInfo0:SetEndPosition(selfPlayerStatusBar.posX , selfPlayerStatusBar.posY + getRandomValue(-randomizeValue_vertical, randomizeValue_vertical))
	end

	endTime = endTime + periodTime_vertical * ( moveCount_vertical + 1 )

	local aniInfo1 = Panel_MainStatus_User_Bar:addMoveAnimation( endTime, endTime + periodTime_vertical , UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
	aniInfo1.StartHorizonType = UI_AH.PA_UI_HORIZON_LEFT
	aniInfo1.EndHorizonType = UI_AH.PA_UI_HORIZON_LEFT
	aniInfo1:SetStartPosition( selfPlayerStatusBar.posX , selfPlayerStatusBar.posY )
	aniInfo1:SetEndPosition(selfPlayerStatusBar.posX , selfPlayerStatusBar.posY )
end

-- 켜고 끄기 이벤트 함수~!
--_close_MainStatus:addInputEvent( "Mouse_LUp", "Panel_MainStatus_User_Bar.MainStatusShowToggle()" )
Panel_MainStatus_User_Bar:addInputEvent( "Mouse_On", "MainStatus_ChangeTexture_On()" )
Panel_MainStatus_User_Bar:addInputEvent( "Mouse_Out", "MainStatus_ChangeTexture_Off()" )
Panel_MainStatus_User_Bar:addInputEvent( "Mouse_LUp", "ResetPos_WidgetButton()" )			--메인UI위젯 위치 초기화

function MainStatus_ChangeTexture_On()
	--_close_MainStatus:SetShow(true)
	Panel_MainStatus_User_Bar:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_drag.dds")
	mainBarText:SetText( PAGetString( Defines.StringSheet_GAME,  "MAINSTATUS_DRAG_BATTLERESOURCE") )
end
function MainStatus_ChangeTexture_Off()
	--_close_MainStatus:SetShow(false)
	if Panel_UIControl:IsShow() then
		Panel_MainStatus_User_Bar:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_isWidget.dds")
		mainBarText:SetText( PAGetString( Defines.StringSheet_GAME,  "MAINSTATUS_BATTLERESOURCE") )
	else
		Panel_MainStatus_User_Bar:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_empty.dds")
	end	
end

Panel_MainStatus_User_Bar.MainStatusShowToggle = function()
	local isShow = Panel_MainStatus_User_Bar:GetShow()
	
	if isShow == true then
		Panel_MainStatus_User_Bar:SetShow ( false, true )
	else
		-- Panel_MainStatus_User_Bar:SetPosX(selfPlayerStatusBar.initPosX)		-- ON/OFF 버튼을 눌러도 위젯 위치 초기화 되지 않도록 주석처리함.
		-- Panel_MainStatus_User_Bar:SetPosY(selfPlayerStatusBar.initPosY)
		Panel_MainStatus_User_Bar:SetShow ( true, true )
	end
end

-- 튜토리얼로 HP바 오픈
function FGlobal_Panel_MainStatus_User_Bar_Show()
	Panel_MainStatus_User_Bar:SetShow ( true, true )
	Panel_MainStatus_User_Bar:AddEffect("UI_Tuto_Hp_1", false, 0, -4)
	Panel_MainStatus_User_Bar:AddEffect("fUI_Tuto_Hp_01A", false, 0, -4)

	local self			= selfPlayerStatusBar
	self._staticGage_HP:AddEffect("fUI_Tuto_Hp_01A", false, 0, -5)
	self._staticGage_HP:AddEffect("UI_Tuto_Hp_1", false, 0, -5)
	self._staticGage_CombatResource:AddEffect("fUI_Tuto_Hp_01A", false, 0, -5)
	self._staticGage_CombatResource:AddEffect("UI_Tuto_Hp_1", false, 0, -5)
end

function mainStatus_AniOpen()
	Panel_MainStatus_User_Bar:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_IN)
	local MainStatusOpen_Alpha = Panel_MainStatus_User_Bar:addColorAnimation( 0.0, 0.35, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	MainStatusOpen_Alpha:SetStartColor( UI_color.C_00FFFFFF )
	MainStatusOpen_Alpha:SetEndColor( UI_color.C_FFFFFFFF )
	MainStatusOpen_Alpha.IsChangeChild = true
end

function mainStatus_AniClose()
	Panel_MainStatus_User_Bar:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
	local MainStatusClose_Alpha = Panel_MainStatus_User_Bar:addColorAnimation( 0.0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	MainStatusClose_Alpha:SetStartColor( UI_color.C_FFFFFFFF )
	MainStatusClose_Alpha:SetEndColor( UI_color.C_00FFFFFF )
	MainStatusClose_Alpha.IsChangeChild = true
	MainStatusClose_Alpha:SetHideAtEnd(true)
	MainStatusClose_Alpha:SetDisableWhileAni(true)
end

function HP_TextOn()
	local playerWrapper = getSelfPlayer()
	local player = playerWrapper:get()
	local hp = player:getHp()
	local maxHp = player:getMaxHp()
	local self = selfPlayerStatusBar
	self._staticShowHp:SetShow( true )
	--self._staticShowHp:SetText( tostring(hp).."/"..tostring(maxHp) )
end

function MP_TextOn()
	local playerWrapper = getSelfPlayer()
	local player = playerWrapper:get()
	local mp = player:getMp()
	local maxMp = player:getMaxMp()
	local self = selfPlayerStatusBar
	self._staticShowMp:SetShow( true )
	--self._staticShowMp:SetText( tostring(mp).."/"..tostring(maxMp) )
end

function HP_TextOff()
	-- selfPlayerStatusBar._staticShowHp:SetShow(false)
end

function MP_TextOff()
	-- selfPlayerStatusBar._staticShowMp:SetShow(false)
end

changePositionBySever(Panel_MainStatus_User_Bar, CppEnums.PAGameUIType.PAGameUIPanel_MainStatusBar, true, true, false)
