Panel_Window_GuildStable_Info:SetShow(false, false)
Panel_Window_GuildStable_Info:setMaskingChild(true)
Panel_Window_GuildStable_Info:ActiveMouseEventEffect(true)
Panel_Window_GuildStable_Info:SetDragEnable( true )

Panel_Window_GuildStable_Info:RegisterShowEventFunc( true,	'StableInfoShowAni()' )
Panel_Window_GuildStable_Info:RegisterShowEventFunc( false,	'StableInfoHideAni()' )

local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color

UI.getChildControl( Panel_Window_GuildStable_Info, "Stable_Info_Ability"):setGlassBackground(true)
UI.getChildControl( Panel_Window_GuildStable_Info, "Panel_Skill"):setGlassBackground(true)

function	GuildStableInfoShowAni()
	Panel_Window_GuildStable_Info:SetShow(true, false)

	UIAni.fadeInSCR_Right(Panel_Window_GuildStable_Info)
	local aniInfo3 = Panel_Window_GuildStable_Info:addColorAnimation( 0.0, 0.20, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo3:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo3:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo3.IsChangeChild = false
end

function	GuildStableInfoHideAni()
	Panel_Window_GuildStable_Info:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo1 = Panel_Window_GuildStable_Info:addColorAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)
end

local guildStableInfo	=
{
	_config	=
	{
		slot	=
		{
			startX			= 5,
			startY			= 5,
			startBGX		= 10,
			startBGY		= 38,
			startScrollX	= 319,
			startScrollY	= 13,
			buttonSizeX		= 60,
			halfButtonSizeY	= 28,
			
			gapY			= 66,
			
			count			= 4,
		},
		
		skill	=
		{
			startIconX	= 5,
			startIconY	= 7,
			startNameX	= 59,
			startNameY	= 7,
			startDecX	= 59,
			startDecY	= 28,
			startExpBGX	= 0,
			startExpBGY	= 2,
			startExpX	= 2,
			startExpY	= 4,
			startButtonX= 251,
			startButtonY= 4,			
		},
	},
	----------------------------------------------------------------------
	-- 기본 정보
	_maleIcon						= UI.getChildControl( Panel_Window_GuildStable_Info,	"Static_MaleIcon"					),	-- 수컷 아이콘
	_femaleIcon						= UI.getChildControl( Panel_Window_GuildStable_Info,	"Static_FemaleIcon"					),	-- 암컷 아이콘
	
	_staticName						= UI.getChildControl(Panel_Window_GuildStable_Info,	"StaticText_Name"					),
	_staticLevel					= UI.getChildControl(Panel_Window_GuildStable_Info,	"Static_Text_Level"					),
	
	_staticHpGauge					= UI.getChildControl(Panel_Window_GuildStable_Info,	"HP_GaugeBar"						),
	_staticMpGauge					= UI.getChildControl(Panel_Window_GuildStable_Info,	"MP_GaugeBar"						),
	_staticExpGauge					= UI.getChildControl(Panel_Window_GuildStable_Info,	"EXP_GaugeBar"						),
	_staticWeightGauge				= UI.getChildControl(Panel_Window_GuildStable_Info,	"Weight_GaugeBar"					),

	_staticHPTitle					= UI.getChildControl(Panel_Window_GuildStable_Info,	"HP"								),
	_staticMPTitle					= UI.getChildControl(Panel_Window_GuildStable_Info,	"MP"								),
	
	_staticHP						= UI.getChildControl( Panel_Window_GuildStable_Info,	"HP_CountData"						),
	_staticMP						= UI.getChildControl( Panel_Window_GuildStable_Info,	"MP_CountData"						),
	_staticEXP						= UI.getChildControl( Panel_Window_GuildStable_Info,	"EXP_CountData"						),
	_staticWeight					= UI.getChildControl( Panel_Window_GuildStable_Info,	"WHT_CountData"						),

	_staticTitleMaxMoveSpeed		= UI.getChildControl( Panel_Window_GuildStable_Info,	"MaxMoveSpeed"						),
	_staticTitleAcceleration		= UI.getChildControl( Panel_Window_GuildStable_Info,	"Acceleration"						),
	_staticTitleCorneringSpeed		= UI.getChildControl( Panel_Window_GuildStable_Info,	"CorneringSpeed"					),
	_staticTitleBrakeSpeed			= UI.getChildControl( Panel_Window_GuildStable_Info,	"BrakeSpeed"						),
	
	_staticMoveSpeed				= UI.getChildControl(Panel_Window_GuildStable_Info,		"MaxMoveSpeedValue"					),
	_staticAcceleration				= UI.getChildControl(Panel_Window_GuildStable_Info,		"AccelerationValue"					),
	_staticCornering				= UI.getChildControl(Panel_Window_GuildStable_Info,		"CorneringSpeedValue"				),
	_staticBrakeSpeed				= UI.getChildControl(Panel_Window_GuildStable_Info,		"BrakeSpeedValue"					),
	
	_staticLife						= UI.getChildControl( Panel_Window_GuildStable_Info,	"Static_LifeCount"					),
	_staticLifeValue				= UI.getChildControl( Panel_Window_GuildStable_Info,	"Static_LifeCountValue"				),
	
	_staticSkillPanel				= UI.getChildControl( Panel_Window_GuildStable_Info,	"Panel_Skill"						),

	_deadCount						= UI.getChildControl( Panel_Window_GuildStable_Info,	"StaticText_DeadCount"				),
	_deadCountValue					= UI.getChildControl( Panel_Window_GuildStable_Info,	"StaticText_DeadCountValue"			),
	
	_startSlotIndex					= 0,
	_temporaySlotCount				= 0,
	_temporayLearnSkillCount		= 0,
	_skill							= Array.new(),
	
	-- 스킬 슬롯 번호 임시 저장 변수 초기화
	_fromSkillKey					= nil,
	_toSkillKey						= nil,
}

function	guildStableInfo:clear()
	self._fromSkillKey	= nil
	self._toSkillKey	= nil
end

function	guildStableInfo:init()

	self._staticSkillTitle	= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_Info,	"Skill_Title",						self._staticSkillPanel,	"StableInfo_SkillTitle"		)
	self._staticSkillBG		= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_Info,	"Static_SkillBG",					self._staticSkillPanel,	"StableInfo_SkillBG"		)	
	self._scrollSkill		= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_Info,	"Scroll_Skill",						self._staticSkillBG,	"StableInfo_SkillScroll"	)
	
	local	slotConfig	= self._config.slot
	self._staticSkillBG:SetPosX(slotConfig.startBGX		)
	self._staticSkillBG:SetPosY(slotConfig.startBGY		)
	self._scrollSkill:SetPosX(	slotConfig.startScrollX	)
	self._scrollSkill:SetPosY(	slotConfig.startScrollY	)
	
	self._staticSkillBG:addInputEvent(	"Mouse_UpScroll",		"StableInfo_ScrollEvent( true )"	)
	self._staticSkillBG:addInputEvent(	"Mouse_DownScroll",		"StableInfo_ScrollEvent( false )"	)
	
	for ii=0, (self._config.slot.count-1)	do
		local slot	= {}
		
		slot.base		= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_Info,	"Button_Skill",					self._staticSkillBG,	"GuildStableInfo_Skill_"		.. ii )
		slot.expBG		= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_Info,	"Static_SkillExpBG",			slot.base,				"GuildStableInfo_SkillExpBG_"	.. ii )
		slot.exp		= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_Info,	"Gauge_SkillExp",				slot.base,				"GuildStableInfo_SkillExp_"		.. ii )
		slot.icon		= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_Info,	"Static_SkillIcon",				slot.base,				"GuildStableInfo_SkillIcon"		.. ii )
		slot.expStr		= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_Info,	"SkillLearn_PercentString",		slot.base,				"GuildStableInfo_SkillExpStr_"	.. ii )
		slot.name		= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_Info,	"Static_Text_SkillName",		slot.base,				"GuildStableInfo_SkillName_"	.. ii )
		slot.dec		= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_Info,	"Static_Text_SkillCondition",	slot.base,				"GuildStableInfo_SkillDec_"		.. ii )
		slot.buttonLock	= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_Info,	"Button_SkillLock",				slot.base,				"GuildStableIngo_SkillLock_"	.. ii )

		slot.base:SetPosX( slotConfig.startX )
		slot.base:SetPosY( slotConfig.startY + slotConfig.gapY * ii )
		
		local	skillConfig	= self._config.skill
		slot.icon			:SetPosX( skillConfig.startIconX )
		slot.icon			:SetPosY( skillConfig.startIconY )
		slot.name			:SetPosX( skillConfig.startNameX )
		slot.name			:SetPosY( skillConfig.startNameY )
		slot.dec			:SetPosX( skillConfig.startDecX )
		slot.dec			:SetPosY( skillConfig.startDecY )
		slot.expBG			:SetPosX( skillConfig.startExpBGX )
		slot.expBG			:SetPosY( skillConfig.startExpBGY )
		slot.exp			:SetPosX( skillConfig.startExpX )
		slot.exp			:SetPosY( skillConfig.startExpY )
		slot.expStr			:SetPosX( (skillConfig.startIconX) + 10 )
		slot.expStr			:SetPosY( (skillConfig.startIconY) + 30 )
		slot.buttonLock		:SetPosX( skillConfig.startButtonX + 10 )
		slot.buttonLock		:SetPosY( skillConfig.startButtonY )
		
		slot.base			:addInputEvent(		"Mouse_UpScroll",		"GuildStableInfo_ScrollEvent( true )"	)
		slot.base			:addInputEvent(		"Mouse_DownScroll",		"GuildStableInfo_ScrollEvent( false )"	)
		
		slot.key	= 0
		self._skill[ii]	= slot
	end
	-- 스킬을 덮어야 하기 때문에 아래서 선언함.
	self._staticSkillEffect	= UI.createAndCopyBasePropertyControl( Panel_Window_GuildStable_Info,	"Static_SkillIChange_EffectPanel",	self._staticSkillBG,	"StableInfo_SkillEffect"	)
end

function	guildStableInfo:update()
	local servantInfo	= guildStable_getServant( GuildStableList_SelectSlotNo() )
	if	( nil == servantInfo )	then
		GuildStableInfo_Close()
		return
	end

	self._staticName:SetText(	servantInfo:getName()																)
	self._staticLevel:SetText(	"Lv."..tostring(servantInfo:getLevel())												)
	self._staticLevel:SetShow( false )
	self._staticHP:SetText(		makeDotMoney(servantInfo:getHp()).. " / " ..makeDotMoney(servantInfo:getMaxHp())				)
	self._staticMP:SetText(		makeDotMoney(servantInfo:getMp()).. " / " ..makeDotMoney(servantInfo:getMaxMp())				)
	-- self._staticWeight:SetText(	makeDotMoney(servantInfo:getMaxWeight_s64() / Defines.s64_const.s64_10000)				)
	self._staticWeight:SetShow( false )
	-- self._staticEXP:SetText(	makeDotMoney(servantInfo:getExp_s64()).." / "..makeDotMoney(servantInfo:getNeedExp_s64())	)
	self._staticEXP:SetShow( false )
	
	self._staticHpGauge:SetSize(250 / 100 * (( servantInfo:getHp() / servantInfo:getMaxHp())*100)	,6)
	self._staticMpGauge:SetSize(250 / 100 * (( servantInfo:getMp() / servantInfo:getMaxMp())*100)	,6)
	-- 경험치
	local	s64_exp			= servantInfo:getExp_s64()
	local	s64_needexp		= servantInfo:getNeedExp_s64()
	local	s64_exp_percent	= Defines.s64_const.s64_0
	if	Defines.s64_const.s64_0 < s64_exp	then
		s64_exp_percent	= ( 250 / 100 ) * ( (Int64toInt32(s64_exp) / Int64toInt32(s64_needexp)) * 100 )
	end

	-- self._staticExpGauge:SetSize( s64_exp_percent, 6 )
	self._staticExpGauge:SetShow( false )
	
	-- 스텟 입력
	self._staticMoveSpeed:SetText(		string.format( "%.1f",((servantInfo:getStat(CppEnums.ServantStatType.Type_MaxMoveSpeed))/10000))	.. "%" )	-- 속도
	self._staticAcceleration:SetText(	string.format( "%.1f",((servantInfo:getStat(CppEnums.ServantStatType.Type_Acceleration))/10000))	.. "%" )	-- 가속도
	self._staticCornering:SetText(		string.format( "%.1f",((servantInfo:getStat(CppEnums.ServantStatType.Type_CorneringSpeed))/10000))	.. "%" )	-- 코너링
	self._staticBrakeSpeed:SetText(		string.format( "%.1f",((servantInfo:getStat(CppEnums.ServantStatType.Type_BrakeSpeed))/10000))		.. "%" )	-- 브레이크
	self._staticTitleMaxMoveSpeed:SetShow( true )
	self._staticTitleAcceleration:SetShow( true )
	self._staticTitleCorneringSpeed:SetShow( true )
	self._staticTitleBrakeSpeed:SetShow( true )
	self._staticMoveSpeed:SetShow( true )
	self._staticAcceleration:SetShow( true )
	self._staticCornering:SetShow( true )
	self._staticBrakeSpeed:SetShow( true )

	-- 죽은 횟수
	self._deadCount:SetShow( false )
	self._deadCountValue:SetShow( false )

	self._deadCount:SetShow( true )
	self._deadCountValue:SetShow( true )

	local deadCount = servantInfo:getDeadCount()		
	self._deadCount:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_KILLCOUNT") ) -- "죽은 횟수")
	self._deadCountValue:SetText( deadCount )

	-- 수명 입력
	if	( servantInfo:isPeriodLimit() )	then
		self._staticLifeValue:SetText( convertStringFromDatetime(servantInfo:getExpiredTime()) )
	else
		self._staticLifeValue:SetText( PAGetString(Defines.StringSheet_RESOURCE, "STABLE_INFO_TEXT_LIFEVALUE") )
	end
	
	-- 탑승물 성별 정보
	--{
		self._maleIcon:SetShow(false)
		self._femaleIcon:SetShow(false)

		-- 말 일 경우 성별 아이콘 표시 (캐쉬말 때문에 doMating() 이전에 설정) --------------------------
		if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse then
			if ( servantInfo:isMale() ) then
				self._maleIcon	:SetShow( true )
				self._femaleIcon:SetShow( false )
			else
				self._maleIcon	:SetShow( false )
				self._femaleIcon:SetShow( true )
			end
		else
			self._maleIcon		:SetShow( false )
			self._femaleIcon	:SetShow( false )
		end
	--}

	--{ 탑승물 HP, MP 툴팁 처리 / 일단 코끼리 한마리 이기 때문에 else문 없음.
	if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Elephant then
		self._staticHPTitle:addInputEvent("Mouse_On",	"GuildStableInfo_SimpleTooltip( true, 0 )")
		self._staticHPTitle:addInputEvent("Mouse_Out",	"GuildStableInfo_SimpleTooltip( false, 0 )")
		self._staticHPTitle:setTooltipEventRegistFunc("GuildStableInfo_SimpleTooltip( true, 0 )")

		self._staticMPTitle:addInputEvent("Mouse_On",	"GuildStableInfo_SimpleTooltip( true, 1 )")
		self._staticMPTitle:addInputEvent("Mouse_On",	"GuildStableInfo_SimpleTooltip( false, 1 )")
		self._staticMPTitle:setTooltipEventRegistFunc("GuildStableInfo_SimpleTooltip( true, 1 )")
	end
	--}
	-- 스킬
	self:updateSkill( unsealType )
end

function FGlobal_GuildStableInfoUpdate()
	local self = guildStableInfo
	local servantInfo		= guildStable_getServant( GuildStableList_SelectSlotNo() ) -- (태곤) 작업 필요
	if nil ~= servantInfo then
		return
	end
	
	self._staticHP:SetText(		tostring(servantInfo:getHp()).. " / " ..tostring(servantInfo:getMaxHp()) )
	self._staticMP:SetText(		tostring(servantInfo:getMp()).. " / " ..tostring(servantInfo:getMaxMp()) )
	self._staticHpGauge:SetSize(250 / 100 * (( servantInfo:getHp() / servantInfo:getMaxHp())*100) ,6)
	self._staticMpGauge:SetSize(250 / 100 * (( servantInfo:getMp() / servantInfo:getMaxMp())*100) ,6)
end

function	guildStableInfo:updateSkill()
	local servantInfo		= guildStable_getServant( GuildStableList_SelectSlotNo() )
	if	( nil == servantInfo )	then
		return
	end
	
	for ii=0, (self._config.slot.count-1)	do
		local	slot	= self._skill[ii]
		slot.base		:SetShow(false)
		slot.exp		:SetShow(false)
		slot.expStr		:SetShow(false)
		slot.buttonLock	:SetShow(false)
	end
	
	if nil == servantInfo then
		return
	end
	
	if	( not servantInfo:doHaveVehicleSkill() )	then
		self._staticSkillPanel:SetShow(true)
		self._scrollSkill:SetShow(false)
		return
	end

	-- 업데이트
	local	temporarySlotIndex		= 0
	local	slotNo					= 0
	self._temporayLearnSkillCount	= 0	--배운 스킬 갯수
	self._temporaySlotCount			= servantInfo:getSkillCount()

	local	regionInfo			= getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
	local	regionName			= regionInfo:getAreaName()
	local	servantRegionName	= servantInfo:getRegionName()
	
	for	ii=1, (self._temporaySlotCount - 1)	do
		local	skillWrapper= servantInfo:getSkill(ii)
		if	(nil ~=	skillWrapper)	then
			if	slotNo < self._config.slot.count	then
				if	self._startSlotIndex <= temporarySlotIndex	then
					local	slot	= self._skill[slotNo]
					slot.key		= ii
					slot.icon:ChangeTextureInfoName( "Icon/" .. skillWrapper:getIconPath() )
					slot.name:SetText( skillWrapper:getName() )
					slot.dec:SetText( skillWrapper:getDescription() )
					
					-- 스킬 경험치
					slot.exp:SetProgressRate( servantInfo:getSkillExp(ii) / (skillWrapper:getMaxExp() / 100) ) -- 숙련도
					slot.exp:SetAniSpeed(0.0)
					local	expTxt = tonumber(string.format( "%.0f", (servantInfo:getSkillExp(ii) / (skillWrapper:getMaxExp() / 100)) ) )
					if	(100 <= expTxt)	then
						expTxt = 100
					end
					slot.expStr:SetText( expTxt .. "%" )
					slot.exp:SetShow(true)
					slot.expStr:SetShow(true)

					if	( servantInfo:isSkillLock(ii) )	then
						if servantInfo:getStateType() ~= CppEnums.ServantStateType.Type_SkillTraining then
							slot.buttonLock:SetShow(true)
						end
					end

					slot.base:SetShow(true)

					slotNo	 = slotNo + 1
				end
				temporarySlotIndex	 = temporarySlotIndex + 1
			end
			self._temporayLearnSkillCount	= self._temporayLearnSkillCount + 1		-- 스킬 갯수 증가
		end
	end
	
	-- 배울 수 있는 스킬들.
	--{
		for	ii=1, (self._temporaySlotCount - 1)	do
			local	skillWrapper= servantInfo:getSkillXXX(ii)
			if	(nil ~=	skillWrapper)	and servantInfo:getStateType() ~= CppEnums.ServantStateType.Type_SkillTraining then
				if	slotNo < self._config.slot.count	then
					if	self._startSlotIndex <= temporarySlotIndex	then
						local	slot	= self._skill[slotNo]
						slot.key		= ii
						slot.icon	:ChangeTextureInfoName( "Icon/" .. skillWrapper:getIconPath() )
						slot.name	:SetText( skillWrapper:getName() )
						slot.dec	:SetText( skillWrapper:getDescription() )
						slot.base:SetShow(true)
						slotNo	 = slotNo + 1
					end
					temporarySlotIndex	 = temporarySlotIndex + 1
				end
				self._temporayLearnSkillCount	= self._temporayLearnSkillCount + 1		-- 스킬 갯수 증가
			end
		end
	--}
	
	-- 스크롤 설정
	if	( 0 < self._temporayLearnSkillCount )	then
		self._staticSkillPanel:SetShow(true)
		UIScroll.SetButtonSize( self._scrollSkill, self._config.slot.count, self._temporayLearnSkillCount )
	end
end

function	guildStableInfo:registEventHandler()
	self._staticSkillPanel:addInputEvent(		"Mouse_UpScroll",	"GuildStableInfo_ScrollEvent( true )"		)
	self._staticSkillPanel:addInputEvent(		"Mouse_DownScroll",	"GuildStableInfo_ScrollEvent( false )"		)
	UIScroll.InputEvent( self._scrollSkill,							"GuildStableInfo_ScrollEvent"				)
end

function	guildStableInfo:registMessageHandler()
	registerEvent( "onScreenResize",					"GuildStableInfo_Resize"				)
end

function	GuildStableInfo_Resize()
	-- screenX = getScreenSizeX()
	-- screenY = getScreenSizeY()

	Panel_Window_GuildStable_Info:SetSpanSize( 20, 30 )
	Panel_Window_GuildStable_Info:ComputePos()
end

----------------------------------------------------------------------------------------------------
-- Scroll Function
function	GuildStableInfo_ScrollEvent( isScrollUp )
	local	self		= guildStableInfo
	self._startSlotIndex= UIScroll.ScrollEvent( self._scrollSkill, isScrollUp, self._config.slot.count, self._temporayLearnSkillCount, self._startSlotIndex, 1 )

	self:update()
end
----------------------------------------------------------------------------------------------------
-- HP, MP ToolTip Function
function GuildStableInfo_SimpleTooltip( isShow, tipType )
	local self = guildStableInfo
	local name, desc, control = nil, nil, nil

	if 0 == tipType then
		name	= PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_HORSEHP_NAME")
		desc	= PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_ELEPHANTHP_DESC")
		control	= self._staticHPTitle
	elseif 1 == tipType then
		name	= PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_CARRIAGEMP_NAME")
		desc	= PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_ELEPHANTMP_DESC")
		control	= self._staticMPTitle
	end

	registTooltipControl(control, Panel_Tooltip_SimpleText)
	if true == isShow then
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end

----------------------------------------------------------------------------------------------------
-- Window Open / Close
function GuildStableInfo_Open()	
	if	not Panel_Window_GuildStable_Info:GetShow()	then
		Panel_Window_GuildStable_Info:SetShow(true)	
	end

	self	= guildStableInfo
	self:clear()
	self._scrollSkill:SetControlPos( 0 )	-- 맨 위로 올림!
	self:update()
end

function	GuildStableInfo_Close()
	if	( not Panel_Window_GuildStable_Info:GetShow() )	then
		-- return
	end
	
	Panel_Window_GuildStable_Info:SetShow(false)
end
----------------------------------------------------------------------------------------------------
-- Init
guildStableInfo:init()
guildStableInfo:registEventHandler()
guildStableInfo:registMessageHandler()
GuildStableInfo_Resize()