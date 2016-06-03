Panel_Window_ServantInfo:SetShow(false, false)
Panel_Window_ServantInfo:ActiveMouseEventEffect(true)
Panel_Window_ServantInfo:SetDragEnable( true )
Panel_Window_ServantInfo:setGlassBackground(true)

Panel_Window_ServantInfo:RegisterShowEventFunc( true,	'ServantInfoShowAni()' )
Panel_Window_ServantInfo:RegisterShowEventFunc( false,	'ServantInfoHideAni()' )

Panel_Window_ServantInfo:RegisterUpdateFunc( "ServantInfoUpdate" )

local	UI_ANI_ADV	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local	UI_PSFT		= CppEnums.PAUI_SHOW_FADE_TYPE
local	UI_color 	= Defines.Color
local	UI_VT		= CppEnums.VehicleType

function	ServantInfoShowAni()
	UIAni.fadeInSCR_Right(Panel_Window_ServantInfo)
	audioPostEvent_SystemUi(01,00)
end

function	ServantInfoHideAni()
	Panel_Window_ServantInfo:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	
	local aniInfo1 = Panel_Window_ServantInfo:addColorAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)
	audioPostEvent_SystemUi(01,01)
end

local	servantInfo =
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
			3,	--마갑
			4,	--등자
			5,	--안장
			6,	--마면
			12,	--편자

			14,	-- 마갑
			15,	-- 등자
			16,	-- 안장
			17,	-- 마면
		},
		
		_slotID =    
		{
			[3]		= 'equipIcon_helm',
			[4]		= 'equipIcon_upperArmor',
			[5]		= 'equipIcon_upperArmor2',
			[6]		= 'equipIcon_stirrups',
			[12]	= 'equipIcon_foot',
			
			[14]	= 'equipIcon_AvatarHelm',
			[15]	= 'equipIcon_AvatarUpperArmor',
			[16]	= 'equipIcon_AvatarUpperArmor2',
			[17]	= 'equipIcon_AvatarStirrups',
		},

		_slotEmptyBG =	--말 아이템 미장착시 BG 이미지 컨트롤
		{
			[3]		= UI.getChildControl( Panel_Window_ServantInfo, "equipIconEmpty_helm"),
			[4]		= UI.getChildControl( Panel_Window_ServantInfo, "equipIconEmpty_upperArmor"),
			[5]		= UI.getChildControl( Panel_Window_ServantInfo, "equipIconEmpty_upperArmor2"),
			[6]		= UI.getChildControl( Panel_Window_ServantInfo, "equipIconEmpty_stirrups"),
			[12]	= UI.getChildControl( Panel_Window_ServantInfo, "equipIconEmpty_foot"),
			
			[14]	= UI.getChildControl( Panel_Window_ServantInfo, "equipIconEmpty_AvatarHelm"),
			[15]	= UI.getChildControl( Panel_Window_ServantInfo, "equipIconEmpty_AvatarUpperArmor"),
			[16]	= UI.getChildControl( Panel_Window_ServantInfo, "equipIconEmpty_AvatarUpperArmor2"),
			[17]	= UI.getChildControl( Panel_Window_ServantInfo, "equipIconEmpty_AvatarStirrups"),
		},
		
		_checkButtonID =
		{
			[3]		= 'CheckButton_EquipSlot_Helm',
			[4]		= 'CheckButton_EquipSlot_upperAmor',
			[5]		= 'CheckButton_EquipSlot_upperAmor2',
			[6]		= 'CheckButton_EquipSlot_stirrups',
			[12]	= 'CheckButton_EquipSlot_foot',
			
			[14]	= 'CheckButton_EquipSlot_AvatarHelm',
			[15]	= 'CheckButton_EquipSlot_AvatarUpperAmor',
			[16]	= 'CheckButton_EquipSlot_AvatarUpperAmor2',
			[17]	= 'CheckButton_EquipSlot_AvatarStirrups',
		},
		
		_checkFlag =
		{
			[3]		= 1,
			[4]		= 2,
			[5]		= 4,
			[6]		= 8,
			[12]	= 0,			-- 신발은 없음
			
			[14]	= 16,
			[15]	= 32,
			[16]	= 64,
			[17]	= 128,
		},
		
		_slotText	=
		{
			[3]		= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Horse_Armor_3"),	-- "마갑 장비 가능"
			[4]		= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Horse_Armor_4"),	-- "안장 장비 가능"
			[5]		= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Horse_Armor_5"),	-- "등자 장비 가능"
			[6]		= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Horse_Armor_6"),	-- "마면 장비 가능"
			[12]	= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Horse_Armor_12"),	-- "편자 장비 가능"

			[14]	= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Horse_Armor_14"),	-- "마갑 의상 장비 가능"
			[15]	= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Horse_Armor_15"),	-- "안장 의상 장비 가능"
			[16]	= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Horse_Armor_16"),	-- "등자 의상 장비 가능"
			[17]	= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Horse_Armor_17"),	-- "마면 의상 장비 가능"
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
			startExpBGX	= 4,
			startExpBGY	= -1,
			startExpX	= 6,
			startExpY	= 1,
			startExpStrX= 18,
			startExpStrY= 35,
			gapY		= 52,
			count		= 4,
		},
	},

	_buttonClose					= UI.getChildControl(Panel_Window_ServantInfo, "close_button"),
	_buttonQuestion					= UI.getChildControl(Panel_Window_ServantInfo, "Button_Question"),
	
	_staticIconMale					= UI.getChildControl(Panel_Window_ServantInfo, "Static_MaleIcon"),
	_staticIconFemale				= UI.getChildControl(Panel_Window_ServantInfo, "Static_FemaleIcon"),
	_staticName						= UI.getChildControl(Panel_Window_ServantInfo, "horse_name_value"),
	_staticGrade					= UI.getChildControl(Panel_Window_ServantInfo, "StaticText_Grade"),
	_lv								= UI.getChildControl(Panel_Window_ServantInfo, "Lv"),
	_staticLevel					= UI.getChildControl(Panel_Window_ServantInfo, "Level_value"),
	
	_staticGaugeBar_Hp				= UI.getChildControl(Panel_Window_ServantInfo, "HP_GaugeBar"),
	_staticTextValue_Hp				= UI.getChildControl(Panel_Window_ServantInfo, "StaticText_HP_Value"),
	
	_mp								= UI.getChildControl(Panel_Window_ServantInfo, "MP"),
	_staticGaugeBar_Mp				= UI.getChildControl(Panel_Window_ServantInfo, "MP_GaugeBar"),
	_staticTextValue_Mp				= UI.getChildControl(Panel_Window_ServantInfo, "StaticText_MP_Value"),
	
	_exp							= UI.getChildControl(Panel_Window_ServantInfo, "EXP"),
	_staticGaugeBar_ExpBG			= UI.getChildControl(Panel_Window_ServantInfo, "EXP_Gauge_Back"),
	_staticGaugeBar_Exp				= UI.getChildControl(Panel_Window_ServantInfo, "EXP_GaugeBar"),
	_staticTextValue_Exp			= UI.getChildControl(Panel_Window_ServantInfo, "StaticText_EXP_Value"),
	
	_weight							= UI.getChildControl(Panel_Window_ServantInfo, "Weight"),
	_staticGaugeBar_WeightBG		= UI.getChildControl(Panel_Window_ServantInfo, "Static_Texture_Weight_Background"),
	_staticGaugeBar_Weight			= UI.getChildControl(Panel_Window_ServantInfo, "Weight_Gauge"),
	_staticTextValue_Weight			= UI.getChildControl(Panel_Window_ServantInfo, "StaticText_Weight_Value"),
	
	_staticText_MaxMoveSpeedValue	= UI.getChildControl(Panel_Window_ServantInfo, "MaxMoveSpeedValue"),
	_staticText_AccelerationValue	= UI.getChildControl(Panel_Window_ServantInfo, "AccelerationValue"),
	_staticText_CorneringSpeedValue	= UI.getChildControl(Panel_Window_ServantInfo, "CorneringSpeedValue"),
	_staticText_BrakeSpeedValue		= UI.getChildControl(Panel_Window_ServantInfo, "BrakeSpeedValue"),
	
	_staticText_Life				= UI.getChildControl(Panel_Window_ServantInfo, "category_Life"),
	_staticText_LifeValue			= UI.getChildControl(Panel_Window_ServantInfo, "category_LifeValue"),
	_staticText_Value_Def			= UI.getChildControl(Panel_Window_ServantInfo, "StaticText_DefenceValue"),
	
	_staticSkilltitle				= UI.getChildControl(Panel_Window_ServantInfo,	"category_skillList" ),
	_staticSkillBG					= UI.getChildControl(Panel_Window_ServantInfo,	"panel_skillInfo" ),
	_skillScroll					= UI.getChildControl(Panel_Window_ServantInfo,	"skill_scroll" ),
	
	deadCountValue					= UI.getChildControl(Panel_Window_ServantInfo,	"StaticText_DeadCountValue"),
	_staticMatingCount				= UI.getChildControl(Panel_Window_ServantInfo,	"Static_MatingCount"),
	_staticMatingCountValue			= UI.getChildControl(Panel_Window_ServantInfo,	"Static_MatingCountValue"),
	
	_skillStart						= 0,	-- 현제 커서가 있는 skill 슬롯 번호 ( scroll 때문에 임시 저장 )
	_skillCount						= 0,	-- 현제 ActorKeyRaw의 배운 스킬 개수( scroll 때문에 임시 저장 )
	_actorKeyRaw					= nil,

	_armorName						= Array.new(),	
	_itemSlots						= Array.new(),
	_skillSlots						= Array.new(),
	_checkButton					= Array.new(),
	_prevCheckButton				= Array.new(),
	
	_functionGet					= nil,			-- 말, 낙타 or 마차 or 배 등 파일이 다르기 떄문에 아이템 툴팁에서 현재 사용중인 정보창의 아이템을 보여줄때 사용.
}

----------------------------------------------------------------------------------------------------
-- Init Function
function	servantInfo:init()
	self._skillScroll:SetControlPos( 0 )
	
	for	index, value in pairs(self._config._slotNo) do
		local	slot= {}
		slot.icon	= UI.getChildControl( Panel_Window_ServantInfo, self._config._slotID[value] )
		
		SlotItem.new( slot, 'ServantInfoEquipment_' .. value, value, Panel_Window_ServantInfo, self._config._itemSlot )
		slot:createChild()
		
		slot.icon:addInputEvent( "Mouse_RUp", "ServantInfo_RClick("	.. value .. ")"						)
		slot.icon:addInputEvent( "Mouse_LUp", "ServantInfo_LClick("	.. value .. ")"						)
		slot.icon:addInputEvent( "Mouse_On",  "ServantInfo_EquipItem_MouseOn("	.. value .. ", true)"	)
		slot.icon:addInputEvent( "Mouse_Out", "ServantInfo_EquipItem_MouseOn("	.. value .. ", false)"	)

		Panel_Tooltip_Item_SetPosition(value, slot, "ServantEquipment")

		self._itemSlots[value]		= slot
		self._armorName[value]		= UI.getChildControl( Panel_Window_ServantInfo,	"StaticText_ArmorName" .. index )
		self._checkButton[value]	= UI.getChildControl( Panel_Window_ServantInfo,	self._config._checkButtonID[value] )
		
		self._checkButton[value]:addInputEvent( "Mouse_LUp", "ServantInfo_VehicleEquipSlot_LClick("	.. value .. ")"	)
		
		--slot.icon:addInputEvent( "Mouse_Out", "ServantInfo_CheckSlot("	.. value .. ")"	)
	end
	
	self._checkButton[12]:SetShow( false )

	for ii=0, self._config._skill.count-1	do
		local	slot	= {}
	
		slot.button		= UI.createAndCopyBasePropertyControl( Panel_Window_ServantInfo, "skill_static",					self._staticSkillBG,	"ServantInfo_Skill_"		.. ii )
		slot.expBG		= UI.createAndCopyBasePropertyControl( Panel_Window_ServantInfo, "Static_Texture_Learn_Background",	slot.button,			"ServantInfo_Skill_ExpBG_"	.. ii )
		slot.exp		= UI.createAndCopyBasePropertyControl( Panel_Window_ServantInfo, "SkillLearn_Gauge",				slot.button,			"ServantInfo_Skill_Exp_"	.. ii )
		slot.icon		= UI.createAndCopyBasePropertyControl( Panel_Window_ServantInfo, "skill_icon",						slot.button,			"ServantInfo_Skill_Icon_"	.. ii )
		slot.expText	= UI.createAndCopyBasePropertyControl( Panel_Window_ServantInfo, "SkillLearn_PercentString",		slot.button,			"ServantInfo_Skill_ExpStr_"	.. ii )
		slot.name		= UI.createAndCopyBasePropertyControl( Panel_Window_ServantInfo, "skill_name",						slot.button,			"ServantInfo_Skill_Name_"	.. ii )
		slot.dec		= UI.createAndCopyBasePropertyControl( Panel_Window_ServantInfo, "skill_condition",					slot.button,			"ServantInfo_Skill_Dec_"	.. ii )
	
		
		-- 좌표 설정
		local	skillConfig	= self._config._skill
			
		slot.button:SetPosX( skillConfig.startX )
		slot.button:SetPosY( skillConfig.startY + skillConfig.gapY * ii )
		
		slot.expBG		:SetPosX( 	skillConfig.startExpBGX	)
		slot.expBG		:SetPosY( 	skillConfig.startExpBGY	)
		slot.exp		:SetPosX(	skillConfig.startExpX	)
		slot.exp		:SetPosY(	skillConfig.startExpY	)
		slot.icon		:SetPosX(	skillConfig.startIconX	)
		slot.icon		:SetPosY(	skillConfig.startIconY	)
		slot.expText	:SetPosX(	skillConfig.startExpStrX	)
		slot.expText	:SetPosY(	skillConfig.startExpStrY	)
		slot.name		:SetPosX(	skillConfig.startNameX	)
		slot.name		:SetPosY(	skillConfig.startNameY	)
		slot.dec		:SetPosX(	skillConfig.startDecX	)
		slot.dec		:SetPosY(	skillConfig.startDecY	)

		UIScroll.InputEventByControl( slot.button,	"ServantInfo_ScrollEvent" )
		
		self._skillSlots[ii]	= slot
	end
end

function	servantInfo:clear()
	self._skillStart	= 0
	self._skillCount	= 0
end

function	servantInfo:update()
	local	servantWrapper		= getServantInfoFromActorKey( self._actorKeyRaw )
	if	(nil == servantWrapper)	then
		return
	end
	local isVehicleType = servantWrapper:getVehicleType()
--{	코끼리는 의상감추기 기능이 들어가지 않기 때문에 버튼을 숨겨준다.
	for	index, value in pairs(self._config._slotNo) do
		if CppEnums.VehicleType.Type_Elephant == isVehicleType then
			self._checkButton[value]:SetShow( false )
		else
			self._checkButton[value]:SetShow( true )
		end
	end
	self._checkButton[12]:SetShow( false )
--}
	self._staticGaugeBar_Exp		:SetShow( false )
	self._staticTextValue_Exp		:SetShow( false )
	self._staticGaugeBar_Weight		:SetShow( false )
	self._staticTextValue_Weight	:SetShow( false )
	self._staticText_Life			:SetShow( false )
	self._staticText_LifeValue		:SetShow( false )
	self._staticMatingCount			:SetShow( false )
	self._staticMatingCountValue	:SetShow( false )
	self._staticGaugeBar_ExpBG		:SetShow( false )
	self._staticGaugeBar_WeightBG	:SetShow( false )
	self._exp						:SetShow( false )
	self._weight					:SetShow( false )
	self._lv						:SetShow( false )
	self._staticLevel				:SetShow( false )
	if CppEnums.VehicleType.Type_Elephant ~= servantWrapper:getVehicleType() then
		self._staticGaugeBar_Exp		:SetShow( true )
		self._staticTextValue_Exp		:SetShow( true )
		self._staticGaugeBar_Weight		:SetShow( true )
		self._staticTextValue_Weight	:SetShow( true )
		self._staticText_Life			:SetShow( true )
		self._staticText_LifeValue		:SetShow( true )
		self._staticMatingCount			:SetShow( true )
		self._staticMatingCountValue	:SetShow( true )
		self._staticGaugeBar_ExpBG		:SetShow( true )
		self._staticGaugeBar_WeightBG	:SetShow( true )
		self._exp						:SetShow( true )
		self._weight					:SetShow( true )
		self._lv						:SetShow( true )
		self._staticLevel				:SetShow( true )
	end

	-- 기본 정보
	--{
		self._staticName:SetText( servantWrapper:getName() )
		self._staticLevel:SetText( tostring(servantWrapper:getLevel()) )
		
		if CppEnums.VehicleType.Type_Horse == servantWrapper:getVehicleType() then
			self._staticGrade:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", servantWrapper:getTier() ))
			self._staticGrade:SetShow( true )
		else
			self._staticGrade:SetShow( false )
		end

		if CppEnums.VehicleType.Type_Elephant == servantWrapper:getVehicleType() then
			self._mp:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTINFO_ELEPHANT_MP") )
		else
			self._mp:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_HORSEMP_NAME") )
		end
	
		self._staticGaugeBar_Hp:SetSize(155 / 100 * (( servantWrapper:getHp() / servantWrapper:getMaxHp())*100)	,4)
		self._staticTextValue_Hp:SetText(makeDotMoney(servantWrapper:getHp()) .. " / " .. makeDotMoney(servantWrapper:getMaxHp()))
		
		self._staticGaugeBar_Mp:SetSize(155 / 100 * (( servantWrapper:getMp() / servantWrapper:getMaxMp())*100)	,5)
		self._staticTextValue_Mp:SetText(makeDotMoney(servantWrapper:getMp()) .. " / " .. makeDotMoney(servantWrapper:getMaxMp()))

		self._staticGaugeBar_Exp:SetSize(155 * (Int64toInt32(servantWrapper:getExp_s64())) / (Int64toInt32(servantWrapper:getNeedExp_s64())) ,4)
		self._staticTextValue_Exp:SetText((makeDotMoney(servantWrapper:getExp_s64())) .. " / " .. (makeDotMoney(servantWrapper:getNeedExp_s64())))
		
		local	max_weight		= Int64toInt32(servantWrapper:getMaxWeight_s64() / Defines.s64_const.s64_10000)
		local	total_weight	= Int64toInt32((servantWrapper:getInventoryWeight_s64() + servantWrapper:getEquipWeight_s64()) / Defines.s64_const.s64_10000)
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
	self.deadCountValue:SetText( servantWrapper:getDeadCount() )
	
	-- 교배 남은 횟수
	local	matingCount	= servantWrapper:getMatingCount()
	self._staticMatingCountValue:SetText( matingCount )
	
	-- 스탯
	--{
		self._staticText_MaxMoveSpeedValue:SetText(		string.format( "%.1f",(servantWrapper:getStat(CppEnums.ServantStatType.Type_MaxMoveSpeed)/10000)	)	.. "%"	)
		self._staticText_AccelerationValue:SetText(		string.format( "%.1f",(servantWrapper:getStat(CppEnums.ServantStatType.Type_Acceleration)/10000)	)	.. "%"	)
		self._staticText_CorneringSpeedValue:SetText(	string.format( "%.1f",(servantWrapper:getStat(CppEnums.ServantStatType.Type_CorneringSpeed)/10000)	)	.. "%"	)
		self._staticText_BrakeSpeedValue:SetText(		string.format( "%.1f",(servantWrapper:getStat(CppEnums.ServantStatType.Type_BrakeSpeed)/10000)		)	.. "%"	)
	--}

	-- 방어도
	local	vehicleInfo	= getVehicleActor( self._actorKeyRaw )
	if	(nil ~= vehicleInfo)	then
		self._staticText_Value_Def:SetText( vehicleInfo:get():getEquipment():getDefense() )
	end
	
	-- 수명 입력
	--{
		if	( servantWrapper:isPeriodLimit() )	then
			self._staticText_LifeValue:SetText( convertStringFromDatetime(servantWrapper:getExpiredTime()) )
			self._staticText_LifeValue:SetShow( true )
		else
			if CppEnums.VehicleType.Type_Elephant ~= servantWrapper:getVehicleType() then
				self._staticText_LifeValue:SetText( PAGetString(Defines.StringSheet_RESOURCE, "STABLE_INFO_TEXT_LIFEVALUE") )
				self._staticText_LifeValue:SetShow( true )
			end
		end	
	--}	
	
	-- 성별
	--{
		self._staticIconMale:SetShow(false)
		self._staticIconFemale:SetShow(false)
		
		if	servantWrapper:doMating() then		
			if( servantWrapper:isMale() )	then
				self._staticIconMale:SetShow(true)
				self._staticName:SetPosX( self._staticIconMale:GetPosX() + self._staticIconMale:GetSizeX() + 3 )
			else
				self._staticIconFemale:SetShow(true)
				self._staticName:SetPosX( self._staticIconFemale:GetPosX() + self._staticIconFemale:GetSizeX() + 3 )
			end
		end
	--}
	
	-- 장비
	--{
		for	index, value in pairs(self._config._slotNo)	do
			local	slot		= self._itemSlots[value]
			local	slotText	= self._armorName[value]
			local	itemWrapper	= servantWrapper:getEquipItem( value )
			if	( nil ~= itemWrapper )	then
				servantInfo._config._slotEmptyBG[value]:SetShow( false )				-- 마구 슬롯 BG Off
				slot:setItem( itemWrapper )
				--slotText:SetText( itemWrapper:getStaticStatus():getName() )
			else
				slot:clearItem()
				servantInfo._config._slotEmptyBG[value]:SetShow( true )					-- 마구 슬롯 BG On
				--slotText:SetText( "<PAColor0xFF888888>" .. self._config._slotText[value] )
			end
		end
	--}
	
	-- 스킬
	--{
		self._skillCount	= 0
		for	ii=0, self._config._skill.count-1	do
			local	slot= self._skillSlots[ii]
			slot.button:SetShow(false)
		end
				
		local	slotNo		= 0
		local	skillCount	= servantWrapper:getSkillCount()
		
		for	ii=1, (skillCount - 1)	do
			local	skillWrapper= servantWrapper:getSkill(ii)
			if	( nil ~= skillWrapper )	then
				if	( (self._skillStart <= self._skillCount) and (slotNo < self._config._skill.count) )	then
					local expTxt = math.floor( servantWrapper:getSkillExp(ii) / (skillWrapper:get()._maxExp/100))
					if 100 <= expTxt then
						expTxt = 100
					end
					local	slot	= self._skillSlots[slotNo]
					slot.icon:ChangeTextureInfoName( "Icon/" .. skillWrapper:getIconPath() )
					slot.name:SetText( skillWrapper:getName() )
					slot.dec:SetText( skillWrapper:getDescription() )
					slot.exp:SetProgressRate( servantWrapper:getSkillExp(ii) / (skillWrapper:get()._maxExp/100)) -- 숙련도
					slot.exp:SetAniSpeed(0.0)
					slot.expText:SetText( expTxt .. "%" )
					
					slot.button:SetShow(true)
					
					slotNo	 = slotNo + 1
				end
				
				self._skillCount	= self._skillCount + 1
			end
		end
		-- 말 스킬 갯수 찍어주기
		self._staticSkilltitle:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_SERVANTINFO_SKILLCOUNT", "servantSkillListCnt", self._skillCount ) )
	--}

	-- scroll 설정
	UIScroll.SetButtonSize( self._skillScroll, self._config._skill.count, self._skillCount )
end

function	servantInfo:registEventHandler() 
	self._buttonClose:addInputEvent(	"Mouse_LUp",		"ServantInfo_Close()" )
	self._buttonQuestion:addInputEvent(	"Mouse_LUp",		"Panel_WebHelper_ShowToggle( \"PanelServantinfo\" )" )					--물음표 좌클릭
	self._buttonQuestion:addInputEvent(	"Mouse_On",			"HelpMessageQuestion_Show( \"PanelServantinfo\", \"true\")" )			--물음표 마우스오버
	self._buttonQuestion:addInputEvent(	"Mouse_Out",		"HelpMessageQuestion_Show( \"PanelServantinfo\", \"false\")" )			--물음표 마우스아웃
	
	self._staticSkillBG:addInputEvent(	"Mouse_UpScroll",	"ServantInfo_ScrollEvent( true )" )
	self._staticSkillBG:addInputEvent(	"Mouse_DownScroll",	"ServantInfo_ScrollEvent( false )" )
	
	UIScroll.InputEvent( self._skillScroll,					"ServantInfo_ScrollEvent" )
end

function	servantInfo:registMessageHandler()
	registerEvent("FromClient_OpenServantInformation",	"ServantInfo_BeforOpenByActorKeyRaw"	)
	registerEvent("EventSelfServantUpdate",				"ServantInfo_Update"			)
	registerEvent("EventServantEquipmentUpdate",		"ServantInfo_Update"			)
	
	registerEvent("EventServantEquipItem",				"ServantInfo_ChangeEquipItem"	)
	registerEvent("FromClient_SelfVehicleLevelUp",		"FromClient_SelfVehicleLevelUp"	)
	
end

----------------------------------------------------------------------------------------------------
-- FromClient Function
function	FromClient_SelfVehicleLevelUp( variedHp, variedMp, variedWeight_s64, variedAcceleration, variedSpeed, variedCornering, variedBrake )
	-- _PA_LOG("정승철", variedHp .. ' / ' ..  variedMp .. ' / ' .. tostring(variedWeight_s64) .. ' / ' .. variedAcceleration .. ' / ' .. variedSpeed .. ' / ' .. variedCornering .. ' / ' .. variedBrake )
	--Todo 창욱씨 작업해주세요.
end


function	ServantInfo_ChangeEquipItem( slotNo )
	local	self			= servantInfo
	local	slot			= self._itemSlots[ slotNo ]
	local	servantWrapper	= getServantInfoFromActorKey( self._actorKeyRaw )
	if	(nil == servantWrapper)	then
		return
	end
	
	slot.icon:AddEffect("UI_ItemInstall", false, 0.0, 0.0)
	slot.icon:AddEffect("fUI_SkillButton01", false, 0.0, 0.0)
	
	local	itemWrapper		= servantWrapper:getEquipItem( slotNo )
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

local isNowEquip = false

function IsNowEquipCheck ()	-- 탑승물 아이템 장착 체크
	return isNowEquip
end

function IsNowEquipReset ()	-- 탑승물 아이템 장착 체크 리셋
	isNowEquip = false
end

-- Control Function
function	ServantInfo_RClick( slotNo )
	local	self			= servantInfo
	local	servantWrapper	= getServantInfoFromActorKey( self._actorKeyRaw )
	if	(nil == servantWrapper)	then
		return
	end
	
	local itemWrapper = servantWrapper:getEquipItem( slotNo )
	if	( nil == itemWrapper )	then
		return
	end
	
	isNowEquip = true	-- 탑승물 아이템 장착 해제 체크
	
	servant_doUnequip( servantWrapper:getActorKeyRaw(), slotNo )
end

function	ServantInfo_LClick( slotNo )
	if	( DragManager.dragStartPanel == Panel_Window_Inventory )	then
		Inventory_SlotRClick( DragManager.dragSlotInfo )
		DragManager.clearInfo()
	end
end

function	ServantInfo_EquipItem_MouseOn( slotNo, isOn )
	local self = servantInfo
	local slot = self._itemSlots[slotNo]
	Panel_Tooltip_Item_SetPosition( slotNo, slot, "ServantEquipment" )
	Panel_Tooltip_Item_Show_GeneralNormal(slotNo, "ServantEquipment", isOn)
end

function ServantInfo_CheckSlot( slotNo )
	local self = servantInfo
	local checkButton = self._checkButton[slotNo]
end

----------------------------------------------------------------------------------------------------
-- Window Open Function
function	ServantInfo_ScrollEvent( isScrollUp )
	local	self		= servantInfo
	
	self._skillStart	= UIScroll.ScrollEvent( self._skillScroll, isScrollUp, self._config._skill.count, self._skillCount, self._skillStart, 1 )
	-- scroll, isScrollUp, configSlotCount, contentsCount, startSlot, scrollCount
	self:update()
end

----------------------------------------------------------------------------------------------------
-- Window Open Function
function	ServantInfo_BeforOpenByActorKeyRaw( actorKeyRaw )
	local	self			= servantInfo

	local	servantWrapper	= getServantInfoFromActorKey( actorKeyRaw )
	if (nil == servantWrapper) then
		return
	end

	local isSelfVehicle = servantWrapper:isSelfVehicle()	-- 탑승물의 동승자인지 아닌지 체크한다.
	local vehicleType	= servantWrapper:getVehicleType()

	if (false == isSelfVehicle) and ( UI_VT.Type_Elephant ~= vehicleType ) then
		return
	end
	
	if		(UI_VT.Type_Horse			== vehicleType)
		or	(UI_VT.Type_Camel			== vehicleType)
		or	(UI_VT.Type_Donkey			== vehicleType)
		or	(UI_VT.Type_Elephant		== vehicleType)
		or	(UI_VT.Type_BabyElephant	== vehicleType) then
		self._functionGet	= ServantInfo_GetActorKey
		ServantInfo_OpenByActorKeyRaw( actorKeyRaw )
	elseif (UI_VT.Type_Carriage			== vehicleType)
		or (UI_VT.Type_CowCarriage		== vehicleType) then
		self._functionGet	= CarriageInfo_GetActorKey
		CarriageInfo_OpenByActorKeyRaw( actorKeyRaw )
	elseif (UI_VT.Type_Boat				== vehicleType)
		or (UI_VT.Type_Raft				== vehicleType)
		or (UI_VT.Type_FishingBoat		== vehicleType)
		or (UI_VT.Type_SailingBoat		== vehicleType) then
		self._functionGet	= ShipInfo_GetActorKey
		ShipInfo_OpenByActorKeyRaw( actorKeyRaw )
	end
end
function	ServantInfo_OpenByActorKeyRaw( actorKeyRaw, vehicleType )
	local	self		= servantInfo
	self._actorKeyRaw	= actorKeyRaw
	
	ServantInfo_Open()
end

function	ServantInfo_Update()
	if	( not Panel_Window_ServantInfo:GetShow() )	then
		return
	end
	
	local	self		= servantInfo
	self:update()
end

----------------------------------------------------------------------------------------------------
-- Window Open / Close
function	ServantInfo_Open()
	local	self	= servantInfo
	self:clear()
	self:update()
	
	self._skillScroll:SetControlPos( 0 ) --  스크롤바 위치 리셋
	
	if	( Panel_Window_ServantInfo:GetShow() )	then
		return
	end

	local	servantWrapper		= getServantInfoFromActorKey( self._actorKeyRaw )
	if	(nil == servantWrapper)	then
		return
	end

	for	index, value in pairs(self._config._slotNo) do
		isCheck = ToClient_IsSetVehicleEquipSlotFlag( servantWrapper:getVehicleType(), self._config._checkFlag[value] )
		self._checkButton[value]:SetCheck( isCheck )
		self._prevCheckButton[value] = isCheck
	end
	
	Panel_Window_ServantInfo:SetShow( true, true )
end

function	ServantInfo_Close()
	if	( not Panel_Window_ServantInfo:GetShow() )	then
		return
	end

	Panel_Window_ServantInfo:SetShow( false, false )
end

function ServantInfo_VehicleEquipSlot_LClick( slotNo )
	local	self		= servantInfo
	local	isChecked	= self._checkButton[slotNo]:IsCheck()
	
	local	servantWrapper		= getServantInfoFromActorKey( self._actorKeyRaw )
	if	(nil == servantWrapper)	then
		return
	end
	
	if true == isChecked then
		ToClient_SetVehicleEquipSlotFlag( servantWrapper:getVehicleType(), self._config._checkFlag[slotNo] )
	else
		ToClient_ResetVehicleEquipSlotFlag( servantWrapper:getVehicleType(), self._config._checkFlag[slotNo] )
	end
	
	ToClient_setShowVehicleEquip()
end

function	ServantInfo_GetActorKey()
	local	self= servantInfo
	return( self._actorKeyRaw )
end

function	Servant_GetActorKeyFromItemToolTip()
	local	self= servantInfo
	return( self._functionGet() )
end

local elapseTime = 0.0
function ServantInfoUpdate( deltaTime )
	if	( not Panel_Window_ServantInfo:GetShow() )	then
		return
	end
	
	elapseTime = elapseTime + deltaTime
	
	local isDiff = false
	
	--_PA_LOG("asdf", "elapseTime : " .. tostring( elapseTime ) )
	if 0.2 < elapseTime then
		elapseTime = 0

		local	self= servantInfo
		local	servantWrapper		= getServantInfoFromActorKey( self._actorKeyRaw )
		if	(nil == servantWrapper)	then
			return
		end
	
		for	index, value in pairs(self._config._slotNo) do
			isCheck = ToClient_IsSetVehicleEquipSlotFlag( servantWrapper:getVehicleType(), self._config._checkFlag[value] )
			if self._prevCheckButton[value] ~= isCheck then
				isDiff = true
				self._prevCheckButton[value] = isCheck
				--_PA_LOG( "asdf", "달라 졌어요..." )
			end
		end
		
		if isDiff then
--			ToClient_SaveVehicleEquipSlots()
		end
	end
end

----------------------------------------------------------------------------------------------------
-- Init
servantInfo:init()
servantInfo:registEventHandler()
servantInfo:registMessageHandler()

FGlobal_PanelMove(Panel_Window_ServantInfo, false)