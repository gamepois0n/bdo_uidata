Panel_CarriageInfo:SetShow(false, false)
Panel_CarriageInfo:ActiveMouseEventEffect(true)
Panel_CarriageInfo:SetDragEnable( true )
Panel_CarriageInfo:setGlassBackground(true)

Panel_CarriageInfo:RegisterShowEventFunc( true,		'CarriageInfoShowAni()' )
Panel_CarriageInfo:RegisterShowEventFunc( false,	'CarriageInfoHideAni()' )

Panel_LinkedHorse_Skill:SetShow( false )
Panel_LinkedHorse_Skill:ActiveMouseEventEffect(true)
Panel_LinkedHorse_Skill:SetDragEnable( true )
Panel_LinkedHorse_Skill:setGlassBackground(true)

local	UI_ANI_ADV	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local	UI_PSFT		= CppEnums.PAUI_SHOW_FADE_TYPE
local	UI_color 	= Defines.Color
local	UI_VT		= CppEnums.VehicleType

function	CarriageInfoShowAni()
	UIAni.fadeInSCR_Right(Panel_CarriageInfo)
	
	audioPostEvent_SystemUi(01,00)
end

function	CarriageInfoHideAni()
	Panel_CarriageInfo:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	
	local aniInfo1 = Panel_CarriageInfo:addColorAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)
	audioPostEvent_SystemUi(01,01)
end

local carriageInfo =
{
	_config	=
	{
		_itemSlot=
		{
			createIcon			= false,
			createBorder		= true,
			createCount			= true,
			createEnchant		= true,
			createCash			= true,
			createEnduranceIcon = true,
		},
		
		_slotNo	=
		{
			3,		-- 차체
			4,		-- 바퀴
			5,      -- 깃발
			6,      -- 휘장
			13,     -- 램프
			25,		-- 덮개

			14,		--차체
			15,		--바퀴
			16,		--깃발
			17,		--휘장
			26,		--덮개
		},
		
		_slotID =
		{ 
			[3] 	= 'equipIcon_body',
			[4] 	= 'equipIcon_cover', -- 바퀴
			[5] 	= 'equipIcon_flag',
			[6] 	= 'equipIcon_mark',
			[13]	= 'equipIcon_lamp',
			[25]	= 'equipIcon_wheel', -- 덮개

			[14]	= 'equipIcon_AvatarBody',
			[15]	= 'equipIcon_AvatarCover',
			[16]	= 'equipIcon_AvatarFlag',
			[17]	= 'equipIcon_AvatarMark',
			[26]	= 'equipIcon_AvatarWheel',
		},
		
		_slotEmptyBG =	--마차 아이템 미장착시 BG 이미지 컨트롤
		{ 
			[3] 	= UI.getChildControl(Panel_CarriageInfo, "equipIconEmpty_body"),
			[4] 	= UI.getChildControl(Panel_CarriageInfo, "equipIconEmpty_cover"), -- 바퀴
			[5] 	= UI.getChildControl(Panel_CarriageInfo, "equipIconEmpty_flag"),
			[6] 	= UI.getChildControl(Panel_CarriageInfo, "equipIconEmpty_mark"),
			[13]	= UI.getChildControl(Panel_CarriageInfo, "equipIconEmpty_lamp"),
			[25]	= UI.getChildControl(Panel_CarriageInfo, "equipIconEmpty_wheel"), -- 덮개

			[14]	= UI.getChildControl(Panel_CarriageInfo, "equipIconEmpty_AvatarBody"),
			[15]	= UI.getChildControl(Panel_CarriageInfo, "equipIconEmpty_AvatarCover"),
			[16]	= UI.getChildControl(Panel_CarriageInfo, "equipIconEmpty_AvatarFlag"),
			[17]	= UI.getChildControl(Panel_CarriageInfo, "equipIconEmpty_AvatarMark"),
			[26]	= UI.getChildControl(Panel_CarriageInfo, "equipIconEmpty_AvatarWheel"),
		},		

		_slotText	=
		{
			[3] 	= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Carriage_Armor_25"),	-- "덮개 장비 가능"
			[4] 	= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Carriage_Armor_4"),	-- "바퀴 장비 가능"
			[5] 	= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Carriage_Armor_5"),	-- "깃발 장비 가능"
			[6] 	= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Carriage_Armor_6"),	-- "휘장 장비 가능"
			[13] 	= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Carriage_Armor_13"),	-- "램프 장비 가능"
			[25] 	= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Carriage_Armor_3"),	-- "차체 장비 가능"
			
			
			[14] 	= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Carriage_Armor_26"),	-- "차체 의상 장비 가능"
			[15] 	= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Carriage_Armor_15"),	-- "천막 의상 장비 가능"
			[16] 	= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Carriage_Armor_16"),	-- "깃발 의상 장비 가능"
			[17] 	= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Carriage_Armor_17"),	-- "휘장 의상 장비 가능"
			[26]	= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Carriage_Armor_14"),	-- "덮개 의상 장비 가능"
		},
		
		_skill	=
		{
			startX		= 0,
			startY		= 0,
			startIconX	= 10,
			startIconY	= 5,
			startNameX	= 64,
			startNameY	= 5,
			startDecX	= 64,
			startDecY	= 27,
			startExpBGX	= 7,
			startExpBGY	= 47,
			startExpX	= 12,
			startExpY	= 50,
			gapY		= 52,
			count		= 4,
		},
	},

	_buttonClose					= UI.getChildControl(Panel_CarriageInfo, "close_button"),
	_buttonQuestion					= UI.getChildControl(Panel_CarriageInfo, "Button_Question"),		--물음표 버튼
	
	_staticName						= UI.getChildControl(Panel_CarriageInfo, "name_value"),
	_staticLevel					= UI.getChildControl(Panel_CarriageInfo, "Level_value"),
	
	_staticGaugeBar_Hp				= UI.getChildControl(Panel_CarriageInfo, "HP_GaugeBar"),
	_staticTextValue_Hp				= UI.getChildControl(Panel_CarriageInfo, "StaticText_HP_Value"),

	_staticGaugeBar_Mp				= UI.getChildControl(Panel_CarriageInfo, "MP_GaugeBar"),
	_staticTextValue_Mp				= UI.getChildControl(Panel_CarriageInfo, "StaticText_MP_Value"),

	_staticTextValue_Sus			= UI.getChildControl(Panel_CarriageInfo, "StaticText_Sus_Value"),
	
	_staticGaugeBar_Weight			= UI.getChildControl(Panel_CarriageInfo, "Weight_Gauge"),
	_staticTextValue_Weight			= UI.getChildControl(Panel_CarriageInfo, "StaticText_Weight_Value"),
	
	_staticText_MaxMoveSpeedValue	= UI.getChildControl(Panel_CarriageInfo, "StaticText_MaxMoveSpeedValue" ),
	_staticText_AccelerationValue	= UI.getChildControl(Panel_CarriageInfo, "StaticText_AccelerationValue" ),
	_staticText_CorneringSpeedValue	= UI.getChildControl(Panel_CarriageInfo, "StaticText_CorneringSpeedValue" ),
	_staticText_BrakeSpeedValue		= UI.getChildControl(Panel_CarriageInfo, "StaticText_BrakeSpeedValue" ),

	_staticText_Value_Def			= UI.getChildControl(Panel_CarriageInfo, "StaticText_DefenceValue"),
	
	_deadCountValue					= UI.getChildControl(Panel_CarriageInfo,	"StaticText_DeadCountValue" ),
	
	_carriageHorseBg				= UI.getChildControl(Panel_CarriageInfo,	"Static_CarriageHorseBg" ),
	_carriageHorseSlot				= UI.getChildControl(Panel_CarriageInfo,	"Static_CarriageHorseSlot" ),
	_carriageHorse_Name				= UI.getChildControl(Panel_CarriageInfo,	"StaticText_CarriageHorse_Name" ),
	_btn_Skill						= UI.getChildControl(Panel_CarriageInfo,	"Button_Skill" ),
	_horse_Level					= UI.getChildControl(Panel_CarriageInfo,	"StaticText_Horse_Level" ),
	_EXP_CountData					= UI.getChildControl(Panel_CarriageInfo,	"Horse_EXP_CountData" ),
	_EXP_Bg							= UI.getChildControl(Panel_CarriageInfo,	"Horse_EXP_Bg" ),
	_EXP_GaugeBar					= UI.getChildControl(Panel_CarriageInfo,	"Horse_EXP_GaugeBar" ),
	
	_maxCountValue					= UI.getChildControl(Panel_CarriageInfo,	"StaticText_MaxCountValue" ),
	
	-- 스킬 정보
	_skillBg						= UI.getChildControl(Panel_LinkedHorse_Skill, "Static_SkillBg"),
	_skillIcon						= UI.getChildControl(Panel_LinkedHorse_Skill, "Static_SkillIcon"),
	_skillCondition					= UI.getChildControl(Panel_LinkedHorse_Skill, "StaticText_SkillCondition"),
	_skillName						= UI.getChildControl(Panel_LinkedHorse_Skill, "StaticText_SkillName"),
	_skillPercent					= UI.getChildControl(Panel_LinkedHorse_Skill, "StaticText_LearningPercent"),
	_skillGaugeBg					= UI.getChildControl(Panel_LinkedHorse_Skill, "Static_Texture_Learn_Background"),
	_skillGauge						= UI.getChildControl(Panel_LinkedHorse_Skill, "Progress2_SkillLearn_Gauge"),
	_skillScroll					= UI.getChildControl(Panel_LinkedHorse_Skill, "Scroll_Skill"),
	_staticSkillBG					= UI.getChildControl(Panel_LinkedHorse_Skill, "Static_skillInfoBg" ),
	
	_btnClose						= UI.getChildControl(Panel_LinkedHorse_Skill, "Button_Close" ),
	
	_linkedHorse					= {},
	_linkedHorse_Skill				= {},
	_gapY							= 55,

	_skillStart						= 0,	-- 현제 커서가 있는 skill 슬롯 번호 ( scroll 때문에 임시 저장 )
	_skillCount						= 0,	-- 현제 ActorKeyRaw의 배운 스킬 개수( scroll 때문에 임시 저장 )
	_actorKeyRaw					= nil,
	
	_armorName						= Array.new(),	
	_itemSlots						= Array.new(),
	_skillSlots						= Array.new(),
}

----------------------------------------------------------------------------------------------------
-- Init Function
function	carriageInfo:init()
	
	-- self._skillScroll:SetControlPos( 0 )
	
	for	index,value in pairs(self._config._slotNo) do
		local	slot= {}
		slot.icon	= UI.getChildControl( Panel_CarriageInfo, self._config._slotID[value] )
		
		SlotItem.new( slot, 'CarriageInfoEquipment_' .. value, value, Panel_CarriageInfo, self._config._itemSlot )
		slot:createChild()
		
		slot.icon:addInputEvent( "Mouse_RUp", "CarriageInfo_RClick(" .. value .. ")"					)
		slot.icon:addInputEvent( "Mouse_LUp", "CarriageInfo_LClick(" .. value .. ")"					)
		slot.icon:addInputEvent( "Mouse_On",  "CarriageInfo_EquipItem_MouseOn("	.. value .. ", true)"	)
		slot.icon:addInputEvent( "Mouse_Out", "CarriageInfo_EquipItem_MouseOn("	.. value .. ", false)"	)

		Panel_Tooltip_Item_SetPosition(value, slot, "ServantEquipment")

		self._itemSlots[value]	= slot
		self._armorName[value]	= UI.getChildControl( Panel_CarriageInfo,	"StaticText_ArmorName" .. index )
	end
	
	for idx = 0, 3 do
		local temp = {}
		temp._carriageHorseBg = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_CarriageInfo, "Static_CarriageHorseBg_" .. idx )
		CopyBaseProperty( self._carriageHorseBg, temp._carriageHorseBg )
		temp._carriageHorseBg:SetPosY( self._carriageHorseBg:GetPosY() + self._gapY * idx )
	
		temp._carriageHorseSlot = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_CarriageInfo, "Static_CarriageHorseSlot_" .. idx )
		CopyBaseProperty( self._carriageHorseSlot, temp._carriageHorseSlot )
		temp._carriageHorseSlot:SetPosY( self._carriageHorseSlot:GetPosY() + self._gapY * idx )
	
		temp._carriageHorse_Name = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_CarriageInfo, "StaticText_CarriageHorse_Name_" .. idx )
		CopyBaseProperty( self._carriageHorse_Name, temp._carriageHorse_Name )
		temp._carriageHorse_Name:SetPosY( self._carriageHorse_Name:GetPosY() + self._gapY * idx )
		
		temp._btn_Skill = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, Panel_CarriageInfo, "Button_CarriageHorse_Skill_" .. idx )
		CopyBaseProperty( self._btn_Skill, temp._btn_Skill )
		temp._btn_Skill:SetPosY( self._btn_Skill:GetPosY() + self._gapY * idx )
		temp._btn_Skill:addInputEvent( "Mouse_LUp", "HandleClicked_LinkedServant_SkillShow(" .. idx .. ", true )" )
	
		temp._horse_Level = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_CarriageInfo, "StaticText_Horse_Level_" .. idx )
		CopyBaseProperty( self._horse_Level, temp._horse_Level )
		temp._horse_Level:SetPosY( self._horse_Level:GetPosY() + self._gapY * idx )
	
		temp._EXP_CountData = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_CarriageInfo, "Horse_EXP_CountData_" .. idx )
		CopyBaseProperty( self._EXP_CountData, temp._EXP_CountData )
		temp._EXP_CountData:SetPosY( self._EXP_CountData:GetPosY() + self._gapY * idx )
	
		temp._EXP_Bg = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_CarriageInfo, "Horse_EXP_Bg_" .. idx )
		CopyBaseProperty( self._EXP_Bg, temp._EXP_Bg )
		temp._EXP_Bg:SetPosY( self._EXP_Bg:GetPosY() + self._gapY * idx )
	
		temp._EXP_GaugeBar = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_CarriageInfo, "Horse_EXP_GaugeBar_" .. idx )
		CopyBaseProperty( self._EXP_GaugeBar, temp._EXP_GaugeBar )
		temp._EXP_GaugeBar:SetPosY( self._EXP_GaugeBar:GetPosY() + self._gapY * idx )
	
		self._linkedHorse[idx] = temp
	end
	
	for idx = 0, 3 do
		local tempSkill = {}
		tempSkill._skillBg = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_LinkedHorse_Skill, "Static_SkillBg_" .. idx )
		CopyBaseProperty( self._skillBg, tempSkill._skillBg )
		tempSkill._skillBg:SetPosY( self._skillBg:GetPosY() + (self._gapY) * idx )
		
		tempSkill._skillIcon = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempSkill._skillBg, "Static_SkillIcon_" .. idx )
		CopyBaseProperty( self._skillIcon, tempSkill._skillIcon )
		tempSkill._skillIcon:SetPosX( 5 )
		tempSkill._skillIcon:SetPosY( 0 )
		tempSkill._skillIcon:SetShow( true )
		
		tempSkill._skillCondition = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempSkill._skillBg, "Static_SkillCondition_" .. idx )
		CopyBaseProperty( self._skillCondition, tempSkill._skillCondition )
		tempSkill._skillCondition:SetPosX( self._skillIcon:GetSizeX() + 15 )
		tempSkill._skillCondition:SetPosY( 25 )
		tempSkill._skillCondition:SetShow( true )
		
		tempSkill._skillName = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempSkill._skillBg, "Static_SkillName_" .. idx )
		CopyBaseProperty( self._skillName, tempSkill._skillName )
		tempSkill._skillName:SetPosX( self._skillIcon:GetSizeX() + 15 )
		tempSkill._skillName:SetPosY( 0 )
		tempSkill._skillName:SetShow( true )
		
		tempSkill._skillPercent = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempSkill._skillBg, "Static_SkillPercent_" .. idx )
		CopyBaseProperty( self._skillPercent, tempSkill._skillPercent )
		tempSkill._skillPercent:SetPosY( 30 )
		tempSkill._skillPercent:SetShow( true )
		
		tempSkill._skillGaugeBg = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempSkill._skillBg, "Static_SkillGaugeBg_" .. idx )
		CopyBaseProperty( self._skillGaugeBg, tempSkill._skillGaugeBg )
		tempSkill._skillGaugeBg:SetPosX( 3 )
		tempSkill._skillGaugeBg:SetPosY( 45 )
		tempSkill._skillGaugeBg:SetShow( true )
		
		tempSkill._skillGauge = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_PROGRESS2, tempSkill._skillBg, "Static_SkillGauge_" .. idx )
		CopyBaseProperty( self._skillGauge, tempSkill._skillGauge )
		tempSkill._skillGauge:SetPosX( 8 )
		tempSkill._skillGauge:SetPosY( 48 )
		tempSkill._skillGauge:SetShow( true )
		
		self._linkedHorse_Skill[idx] = tempSkill
	end
	
	
	
	-- for ii=0, self._config._skill.count-1	do
	-- 	local	slot	= {}
		
	-- 	slot.button	= UI.createAndCopyBasePropertyControl( Panel_CarriageInfo, "skill_static",					self._staticSkillBG,	"CarriageInfo_Skill_"		.. ii )
	-- 	slot.icon	= UI.createAndCopyBasePropertyControl( Panel_CarriageInfo, "skill_icon",						slot.button,			"CarriageInfo_Skill_Icon_"	.. ii )
	-- 	slot.name	= UI.createAndCopyBasePropertyControl( Panel_CarriageInfo, "skill_name",						slot.button,			"CarriageInfo_Skill_Name_"	.. ii )
	-- 	slot.dec	= UI.createAndCopyBasePropertyControl( Panel_CarriageInfo, "skill_condition",					slot.button,			"CarriageInfo_Skill_Dec_"	.. ii )
	-- 	slot.expBG	= UI.createAndCopyBasePropertyControl( Panel_CarriageInfo, "Static_Texture_Learn_Background",	slot.button,			"CarriageInfo_Skill_ExpBG_"	.. ii )
	-- 	slot.exp	= UI.createAndCopyBasePropertyControl( Panel_CarriageInfo, "SkillLearn_Gauge",				slot.button,			"CarriageInfo_Skill_Exp_"	.. ii )
		
	-- 	-- 좌표 설정
	-- 	local skillConfig	= self._config._skill
			
	-- 	slot.button:SetPosX( skillConfig.startX )
	-- 	slot.button:SetPosY( skillConfig.startY + skillConfig.gapY * ii )
		
	-- 	slot.icon:SetPosX(	skillConfig.startIconX	)
	-- 	slot.icon:SetPosY(	skillConfig.startIconY	)
	-- 	slot.name:SetPosX(	skillConfig.startNameX	)
	-- 	slot.name:SetPosY(	skillConfig.startNameY	)
	-- 	slot.dec:SetPosX(	skillConfig.startDecX	)
	-- 	slot.dec:SetPosY(	skillConfig.startDecY	)
	-- 	slot.expBG:SetPosX( skillConfig.startExpBGX	)
	-- 	slot.expBG:SetPosY( skillConfig.startExpBGY	)
	-- 	slot.exp:SetPosX(	skillConfig.startExpX	)
	-- 	slot.exp:SetPosY(	skillConfig.startExpY	)		

	-- 	UIScroll.InputEventByControl( slot.button,	"CarriageInfo_ScrollEvent" )
		
	-- 	self._skillSlots[ii]	= slot
	-- end
end

function	carriageInfo:update()
	-- 당장 사용하지 않는 것 주석
	local	temporaryWrapper= getTemporaryInformationWrapper()
	local	servantWrapper	= temporaryWrapper:getUnsealVehicleByActorKeyRaw( self._actorKeyRaw )
	if	(nil == servantWrapper)	then
		return
	end
	
	local	vehicleInfo	= getVehicleActor( self._actorKeyRaw )
	if	(nil == vehicleInfo)	then
		return
	end
	-- 기본 정보
	--{
		self._staticName:SetText( servantWrapper:getName() )
		self._staticLevel:SetText( tostring(servantWrapper:getLevel()) )
	
		self._staticGaugeBar_Hp:SetSize(155 / 100 * (( servantWrapper:getHp() / servantWrapper:getMaxHp())*100)	,4)
		self._staticTextValue_Hp:SetText(makeDotMoney(servantWrapper:getHp()) .. " / " .. makeDotMoney(servantWrapper:getMaxHp()))
		
		-- 내구도
		self._staticGaugeBar_Mp:SetSize(155 / 100 * (( servantWrapper:getMp() / servantWrapper:getMaxMp())*100)	,5)
		self._staticTextValue_Mp:SetText(makeDotMoney(servantWrapper:getMp()) .. " / " .. makeDotMoney(servantWrapper:getMaxMp()))
		
		-- 서스펜션
		self._staticTextValue_Sus:SetText( servantWrapper:getSuspension() )

		-- self._staticGaugeBar_Exp:SetSize(155 * (Int64toInt32(servantWrapper:getExp_s64())) / (Int64toInt32(servantWrapper:getNeedExp_s64())) ,4)
		
		local	max_weight		= Int64toInt32(servantWrapper:getMaxWeight_s64() / Defines.s64_const.s64_10000)
		local	total_weight	= Int64toInt32((servantWrapper:getInventoryWeight_s64() + servantWrapper:getEquipWeight_s64() + servantWrapper:getMoneyWeight_s64()) / Defines.s64_const.s64_10000)
		local	weightPercent	= total_weight / max_weight * 100 
		
		-- 무게가 100%이상이면 뚫고  나가는 것을 막자.
		-- 가지고 있는 무게가 최대를 초과하는 경우 현재 무게를 빨간색으로 
		local	weightValue	= ""
		if	( max_weight < total_weight )	then
			weightPercent	= 100
			weightValue		= "<PAColor0xFFD20000>" .. makeDotMoney(total_weight) .. "<PAOldColor> / " .. makeDotMoney( max_weight )
		else
			weightValue		=  makeDotMoney(total_weight) .. " / " .. makeDotMoney(max_weight)
		end	
	
		self._staticGaugeBar_Weight:SetSize( weightPercent * 155 / 100, 4)
		self._staticTextValue_Weight:SetText( weightValue )
		
	--}

	-- 죽은 횟수
		local deadCount = servantWrapper:getDeadCount()
		self._deadCountValue:SetText( deadCount )
	
	-- 스탯
		self._staticText_MaxMoveSpeedValue:SetText(		string.format( "%.1f",(servantWrapper:getStat(CppEnums.ServantStatType.Type_MaxMoveSpeed)/10000)	)	.. "%"	)
		self._staticText_AccelerationValue:SetText(		string.format( "%.1f",(servantWrapper:getStat(CppEnums.ServantStatType.Type_Acceleration)/10000)	)	.. "%"	)
		self._staticText_CorneringSpeedValue:SetText(	string.format( "%.1f",(servantWrapper:getStat(CppEnums.ServantStatType.Type_CorneringSpeed)/10000)	)	.. "%"	)
		self._staticText_BrakeSpeedValue:SetText(		string.format( "%.1f",(servantWrapper:getStat(CppEnums.ServantStatType.Type_BrakeSpeed)/10000)		)	.. "%"	)
		self._staticText_Value_Def:SetText( vehicleInfo:get():getEquipment():getDefense() )

	
	-- 수명 입력
	-- --{
	-- 	if	( servantWrapper:isPeriodLimit() )	then
	-- 		self._staticText_LifeValue:SetText( convertStringFromDatetime(servantWrapper:getExpiredTime()) )
	-- 	else
	-- 		self._staticText_LifeValue:SetText( PAGetString(Defines.StringSheet_RESOURCE, "STABLE_INFO_TEXT_LIFEVALUE") )
	-- 	end	
	-- --}	
	
	-- 성별
	-- --{
	-- 	self._staticIconMale:SetShow(false)
	-- 	self._staticIconFemale:SetShow(false)
		
	-- 	if( servantWrapper:isMale() )	then
	-- 		self._staticIconMale:SetShow(true)
	-- 	else
	-- 		self._staticIconFemale:SetShow(true)
	-- 	end
	-- --}
	
	-- 장비
	--{
		for	index, value in pairs(self._config._slotNo)	do
			local	slot		= self._itemSlots[value]
			local	slotText	= self._armorName[value]
			local	itemWrapper	= servantWrapper:getEquipItem( value )
			if	( nil ~= itemWrapper )	then
				carriageInfo._config._slotEmptyBG[value]:SetShow( false )				-- 장비 슬롯 BG Off
				slot:setItem( itemWrapper )
				--slotText:SetText( itemWrapper:getStaticStatus():getName() )
			else
				slot:clearItem()
				carriageInfo._config._slotEmptyBG[value]:SetShow( true )					-- 장비 슬롯 BG On
				--slotText:SetText( "<PAColor0xFF888888>" .. self._config._slotText[value] )
			end
		end
	--}
	
	-- 연결된 말 정보
	--{
		self._maxCountValue:SetText( "( " .. servantWrapper:getCurrentLinkCount() .. " / " .. servantWrapper:getLinkCount() .. " )" )
		
		-- 일단 컨트롤 다 꺼줌
		for li = 0, 3 do
			for v, control in pairs( self._linkedHorse[li] ) do
				control:SetShow( false )
			end
		end
		
		for linkedIndex = 0, servantWrapper:getCurrentLinkCount() - 1 do
			for v, control in pairs( self._linkedHorse[linkedIndex] ) do
				control:SetShow( true )
			end
			
			-- local servantCount = stable_count()
			local servantCount = servantWrapper:getLinkCount()
			-- local linkedCount = 0
			for index = 0, servantCount -1 do
				local sInfo = stable_getServantFromOwnerServant( servantWrapper:getServantNo(), index )
				if nil ~= sInfo then
					-- if sInfo:isLink() then
						-- if servantWrapper:getServantNo() == sInfo:getOwnerServantNo_s64() then
							
							-- 붙은 말 정보 세팅
							local linkedHorse				= self._linkedHorse[index]
							linkedHorse._carriageHorseSlot	:ChangeTextureInfoName( sInfo:getIconPath1() )
							linkedHorse._carriageHorse_Name	:SetText( sInfo:getName() )
							linkedHorse._horse_Level		:SetText( "Lv."..tostring(sInfo:getLevel()) )
							linkedHorse._EXP_CountData		:SetText( makeDotMoney(sInfo:getExp_s64()).." / "..makeDotMoney(sInfo:getNeedExp_s64()) )
							
							-- 경험치
							local s64_exp			= sInfo:getExp_s64()
							local s64_needexp		= sInfo:getNeedExp_s64()
							local s64_exp_percent	= Defines.s64_const.s64_0
							if	Defines.s64_const.s64_0 < s64_exp	then
								s64_exp_percent	= ( 170 / 100 ) * ( (Int64toInt32(s64_exp) / Int64toInt32(s64_needexp)) * 100 )
							end
							linkedHorse._EXP_GaugeBar	:SetSize( s64_exp_percent, 6 )
							
							local skillCount		= sInfo:getSkillCount()
							
							if 0 < skillCount then
								linkedHorse._btn_Skill:SetShow( true )
								linkedHorse._btn_Skill:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_MENU_MENUBUTTONTEXTID_SKILL") )
								linkedHorse._btn_Skill:SetSize( linkedHorse._btn_Skill:GetTextSizeX() + 15, linkedHorse._btn_Skill:GetSizeY() )
								linkedHorse._btn_Skill:SetTextHorizonCenter()
								linkedHorse._btn_Skill:SetPosX( linkedHorse._carriageHorse_Name:GetPosX() + linkedHorse._carriageHorse_Name:GetTextSizeX() + 5 )
							else
								linkedHorse._btn_Skill:SetShow( false )
							end
							
							if Panel_LinkedHorse_Skill:GetShow() then
								Skill_Update()
							end
							
							-- linkedCount = linkedCount + 1
						-- end
					-- end
				end
			end
		end
	--}
	
	-- 스킬
	-- --{
	-- 	self._skillCount	= 0
	-- 	for	ii=0, self._config._skill.count-1	do
	-- 		local	slot= self._skillSlots[ii]
	-- 		slot.button:SetShow(false)
	-- 	end
				
	-- 	local	slotNo		= 0
	-- 	local	skillCount	= servantWrapper:getSkillCount()
		
	-- 	for	ii=1, (skillCount - 1)	do
	-- 		local	skillWrapper= servantWrapper:getSkill(ii)
	-- 		if	( nil ~= skillWrapper )	then
	-- 			if	( (self._skillStart <= self._skillCount) and (slotNo < self._config._skill.count) )	then
	-- 				local	slot	= self._skillSlots[slotNo]
	-- 				slot.icon:ChangeTextureInfoName( "Icon/" .. skillWrapper:getIconPath() )
	-- 				slot.name:SetText( skillWrapper:getName() )
	-- 				slot.dec:SetText( skillWrapper:getDescription() )
	-- 				slot.exp:SetProgressRate( servantWrapper:getSkillExp(ii) / (skillWrapper:get()._maxExp/100)) -- 숙련도
	-- 				slot.exp:SetAniSpeed(0.0)
					
	-- 				slot.button:SetShow(true)
					
	-- 				slotNo	 = slotNo + 1
	-- 			end
				
	-- 			self._skillCount	= self._skillCount + 1
	-- 		end
	-- 	end
	-- --}

	-- scroll 설정
end

function	carriageInfo:registEventHandler() 
	self._buttonClose:addInputEvent(	"Mouse_LUp",		"CarriageInfo_Close()" )
	self._btnClose:addInputEvent(		"Mouse_LUp",		"Panel_LinkedHorse_Skill_Close()" )
	self._buttonQuestion:addInputEvent(	"Mouse_LUp",		"Panel_WebHelper_ShowToggle( \"PanelServantinfo\" )" )					--물음표 좌클릭
	self._buttonQuestion:addInputEvent(	"Mouse_On",			"HelpMessageQuestion_Show( \"PanelServantinfo\", \"true\")" )			--물음표 마우스오버
	self._buttonQuestion:addInputEvent(	"Mouse_Out",		"HelpMessageQuestion_Show( \"PanelServantinfo\", \"false\")" )			--물음표 마우스아웃
	
	self._staticSkillBG:addInputEvent(	"Mouse_UpScroll",	"CarriageInfo_ScrollEvent( true )" )
	self._staticSkillBG:addInputEvent(	"Mouse_DownScroll",	"CarriageInfo_ScrollEvent( false )" )
	
	UIScroll.InputEvent( self._skillScroll,					"CarriageInfo_ScrollEvent" )
end

function	carriageInfo:registMessageHandler()
	-- registerEvent("FromClient_OpenServantInformation",	"CarriageInfo_OpenByActorKeyRaw"	)
	registerEvent("EventSelfServantUpdate",				"CarriageInfo_Update()"			)
	registerEvent("EventServantEquipmentUpdate",		"CarriageInfo_Update()"			)
	registerEvent("EventServantEquipItem",				"CarriageInfo_ChangeEquipItem"	)
end

----------------------------------------------------------------------------------------------------
-- FromClient Function

function	CarriageInfo_ChangeEquipItem( slotNo )
	local	self	= carriageInfo
	local	slot	= self._itemSlots[ slotNo ]
	
	local	temporaryWrapper= getTemporaryInformationWrapper()
	local	vehicleWrapper	= temporaryWrapper:getUnsealVehicleByActorKeyRaw( self._actorKeyRaw )
	if	( nil == vehicleWrapper )	then
		return
	end	

	local vehicleType = vehicleWrapper:getVehicleType()
	if UI_VT.Type_Carriage ~= vehicleType or UI_VT.Type_CowCarriage ~= vehicleType then
		return
	end

	slot.icon:AddEffect("UI_ItemInstall", false, 0.0, 0.0)
	slot.icon:AddEffect("fUI_SkillButton01", false, 0.0, 0.0)
	
	local	itemWrapper		= vehicleWrapper:getEquipItem( slotNo )
	if	( nil == itemWrapper )	then
		return
	end
		
	local defence	= itemWrapper:getStaticStatus():getDefence(0)
	if	( 0 < defence )	then
		self._staticText_Value_Def:AddEffect("fUI_SkillButton01", false, -6, 2)
		self._staticText_Value_Def:AddEffect("UI_SkillButton01", false, -6, 2)
	end
end

----------------------------------------------------------------------------------------------------
-- Control Function
function	CarriageInfo_RClick( slotNo )
	local	self			= carriageInfo
	
	local	temporaryWrapper= getTemporaryInformationWrapper()
	if	(not temporaryWrapper:isSelfVehicle())	then
		return
	end
	
	local	servantWrapper	= temporaryWrapper:getUnsealVehicleByActorKeyRaw(self._actorKeyRaw)
	if	( nil == servantWrapper )	then
		return
	end
	
	local itemWrapper = servantWrapper:getEquipItem( slotNo )
	if	( nil == itemWrapper )	then
		return
	end
	
	servant_doUnequip( servantWrapper:getActorKeyRaw(), slotNo )
end

function	CarriageInfo_LClick( slotNo )
	if	( DragManager.dragStartPanel == Panel_Window_Inventory )	then
		Inventory_SlotRClick( DragManager.dragSlotInfo )
		DragManager.clearInfo()
	end
end

function	CarriageInfo_EquipItem_MouseOn( slotNo, isOn )
	local self = carriageInfo
	local slot = self._itemSlots[slotNo]
	Panel_Tooltip_Item_SetPosition( slotNo, slot, "ServantEquipment" )
	Panel_Tooltip_Item_Show_GeneralNormal(slotNo, "ServantEquipment", isOn)
end

local prevIndex = -1
local currentIndex = nil
function	HandleClicked_LinkedServant_SkillShow( index, isShow )
	local	self = carriageInfo
	local	temporaryWrapper = getTemporaryInformationWrapper()
	local	carriageWrapper = temporaryWrapper:getUnsealVehicleByActorKeyRaw( self._actorKeyRaw )
	if nil == carriageWrapper then
		return
	end
	
	local servantInfo = stable_getServantFromOwnerServant( carriageWrapper:getServantNo(), index )
	if nil == servantInfo then
		return
	end
	
	if Panel_LinkedHorse_Skill:GetShow() and prevIndex == index and isShow then
		Panel_LinkedHorse_Skill_Close()
		return
	end
	
	if prevIndex ~= index then
		self._skillStart = 0
		prevIndex = index
	end
	
	Panel_LinkedHorse_Skill_Open()
	for ii = 0, 3 do
		self._linkedHorse_Skill[ii]._skillBg:SetShow( false )
	end
	
	local skillCount = servantInfo:getSkillCount()
	local learnSkillCount = 0
	local startIndexCheck = 0
	self._skillCount = 0
	for skillIndex = 0, skillCount - 1 do
		local skillWrapper = servantInfo:getSkill( skillIndex )
		if nil ~= skillWrapper then
			if startIndexCheck == self._skillStart then
				if 3 >= learnSkillCount then
					local slot = self._linkedHorse_Skill[learnSkillCount]
					slot._skillBg:SetShow( true )
					slot._skillIcon:ChangeTextureInfoName( "Icon/" .. skillWrapper:getIconPath() )
					slot._skillName:SetText( skillWrapper:getName() )
					slot._skillCondition:SetText( skillWrapper:getDescription() )
					slot._skillGauge:SetProgressRate( servantInfo:getSkillExp(skillIndex) / (skillWrapper:get()._maxExp/100)) -- 숙련도
					slot._skillGauge:SetAniSpeed(0.0)
					local percent = tonumber(string.format( "%.0f", servantInfo:getSkillExp(skillIndex) / (skillWrapper:get()._maxExp/100)))
					if 100 < percent then
						percent = 100
					end
					slot._skillPercent:SetText( percent .. "%" )
					-- slot.expText:SetText( expTxt .. "%" )
					
					learnSkillCount = learnSkillCount + 1
				end
			else
				startIndexCheck = startIndexCheck + 1
			end
			self._skillCount = self._skillCount + 1
		end
	end
	
	if 4 < self._skillCount then
		self._skillScroll:SetShow( true )
		UIScroll.SetButtonSize( self._skillScroll, self._config._skill.count, self._skillCount )
	else
		self._skillScroll:SetShow( false )
	end
	
	if 0 == self._skillStart then
		self._skillScroll:SetControlPos( 0 )
	end
end

function Skill_Update()
	HandleClicked_LinkedServant_SkillShow( prevIndex )
end

----------------------------------------------------------------------------------------------------
-- Window Open Function
function	CarriageInfo_ScrollEvent( isScrollUp )
	local	self		= carriageInfo
	
	self._skillStart	= UIScroll.ScrollEvent( self._skillScroll, isScrollUp, self._config._skill.count, self._skillCount, self._skillStart, 1 )
	-- scroll, isScrollUp, configSlotCount, contentsCount, startSlot, scrollCount
	CarriageInfo_Update()
end

function Panel_LinkedHorse_Skill_Open()
	if Panel_LinkedHorse_Skill:GetShow() then
		return
	end
	Panel_LinkedHorse_Skill:SetShow( true )
	Panel_LinkedHorse_Skill:SetPosX( Panel_CarriageInfo:GetPosX() + Panel_CarriageInfo:GetSizeX() - 50)
	--Panel_LinkedHorse_Skill:SetPosX( Panel_CarriageInfo:GetPosX() - Panel_LinkedHorse_Skill:GetSizeX() + 40 )
	Panel_LinkedHorse_Skill:SetPosY( Panel_CarriageInfo:GetPosY() + Panel_CarriageInfo:GetSizeY() - Panel_LinkedHorse_Skill:GetSizeX() - 10 )
end
function Panel_LinkedHorse_Skill_Close()
	Panel_LinkedHorse_Skill:SetShow( false )
	prevIndex = -1
end


----------------------------------------------------------------------------------------------------
-- Window Open Function
function	CarriageInfo_OpenByActorKeyRaw( actorKeyRaw )
	local	self		= carriageInfo
	self._actorKeyRaw	= actorKeyRaw
	
	CarriageInfo_Open()
end

function	CarriageInfo_GetActorKey()
	local	self	= carriageInfo
	return( self._actorKeyRaw )
end

function	CarriageInfo_Update()
	if	( not Panel_CarriageInfo:GetShow() )	then
		return
	end
	
	local	self		= carriageInfo
	self:update()
end


----------------------------------------------------------------------------------------------------
-- Window Open / Close
function	CarriageInfo_Open()
	local	self	= carriageInfo
	self:update()
	if	( Panel_CarriageInfo:GetShow() )	then
		return
	end
	Panel_CarriageInfo:SetShow( true, true )
end

function	CarriageInfo_Close()
	if	( not Panel_CarriageInfo:GetShow() )	then
		return
	end

	Panel_CarriageInfo:SetShow( false, false )
	Panel_LinkedHorse_Skill:SetShow( false )
end

----------------------------------------------------------------------------------------------------
-- Init
carriageInfo:init()
carriageInfo:registEventHandler()
carriageInfo:registMessageHandler()

FGlobal_PanelMove(Panel_CarriageInfo, false)