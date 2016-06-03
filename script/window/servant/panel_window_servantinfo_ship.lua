Panel_ShipInfo:SetShow(false, false)
Panel_ShipInfo:ActiveMouseEventEffect(true)
Panel_ShipInfo:SetDragEnable( true )
Panel_ShipInfo:setGlassBackground(true)

Panel_ShipInfo:RegisterShowEventFunc( true,		'ShipInfoShowAni()' )
Panel_ShipInfo:RegisterShowEventFunc( false,	'ShipInfoHideAni()' )

local	UI_ANI_ADV	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local	UI_PSFT		= CppEnums.PAUI_SHOW_FADE_TYPE
local	UI_color 	= Defines.Color
local	UI_VT		= CppEnums.VehicleType

function	ShipInfoShowAni()
	UIAni.fadeInSCR_Right(Panel_ShipInfo)
	
	audioPostEvent_SystemUi(01,00)
end

function	ShipInfoHideAni()
	Panel_ShipInfo:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	
	local aniInfo1 = Panel_ShipInfo:addColorAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)
	audioPostEvent_SystemUi(01,01)
end

local shipInfo =
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
			3,		--선체
			4,      --뱃머리
			5,      --화물칸
			25,		--장식
			
			14,		--선체(의상)
			15,		--뱃머리(의상)
			16,		--화물칸(의상)
			26,		--장식(의상)
		},
		
		_slotID =
		{
			[3] 	= 'equipIcon_hull',
			[4] 	= 'equipIcon_gear',
			[5] 	= 'equipIcon_wheel',
			[25] 	= 'equipIcon_body',

			[14] 	= 'equipIcon_AvatarSaddle',
			[15] 	= 'equipIcon_AvatarHull',
			[16] 	= 'equipIcon_AvatarWheel',
			[26] 	= 'equipIcon_AvatarBody',
		},
		
		_slotEmptyBG = -- 미장착 아이템 Icon
		{
			[3] 	= UI.getChildControl(Panel_ShipInfo, "equipIconEmpty_Hull"),
			[4] 	= UI.getChildControl(Panel_ShipInfo, "equipIconEmpty_Gear"),
			[5] 	= UI.getChildControl(Panel_ShipInfo, "equipIconEmpty_Wheel"),
			[25] 	= UI.getChildControl(Panel_ShipInfo, "equipIconEmpty_Body"),

			[14] 	= UI.getChildControl(Panel_ShipInfo, "equipIconEmpty_AvatarSaddle"),
			[15] 	= UI.getChildControl(Panel_ShipInfo, "equipIconEmpty_AvatarHull"),
			[16] 	= UI.getChildControl(Panel_ShipInfo, "equipIconEmpty_AvatarWheel"),
			[26] 	= UI.getChildControl(Panel_ShipInfo, "equipIconEmpty_AvatarBody"),
		},
		
		_slotText	=
		{
			[3] 	= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Ship_Armor_25"),	-- "선체 장비 가능"
			[4] 	= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Ship_Armor_4"),	-- "뱃머리 장비 가능"
			[5] 	= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Ship_Armor_5"),	-- "화물칸 장비 가능"
			[25] 	= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Ship_Armor_3"),	-- "장식 장비 가능"

			[14] 	= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Ship_Armor_13"),	-- "선체 의상 장비 가능"
			[15] 	= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Ship_Armor_15"),	-- "뱃머리 의상 장비 가능"
			[16] 	= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Ship_Armor_16"),	-- "화물칸 의상 장비 가능"
			[26] 	= PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Ship_Armor_14"),	-- "장식 의상 장비 가능"
			
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

	_buttonClose					= UI.getChildControl(Panel_ShipInfo, "close_button"),
	_buttonQuestion					= UI.getChildControl(Panel_ShipInfo, "Button_Question"),		--물음표 버튼
	
	_staticName						= UI.getChildControl(Panel_ShipInfo, "name_value"),
	_staticLevel					= UI.getChildControl(Panel_ShipInfo, "Level_value"),
	
	_staticGaugeBar_Hp				= UI.getChildControl(Panel_ShipInfo, "HP_GaugeBar"),
	_staticTextValue_Hp				= UI.getChildControl(Panel_ShipInfo, "StaticText_HP_Value"),

	_staticGaugeBar_Mp				= UI.getChildControl(Panel_ShipInfo, "MP_GaugeBar"),
	_staticTextValue_Mp				= UI.getChildControl(Panel_ShipInfo, "StaticText_MP_Value"),

	_staticTextValue_Sus			= UI.getChildControl(Panel_ShipInfo, "StaticText_Sus_Value"),
	
	_staticGaugeBar_Weight			= UI.getChildControl(Panel_ShipInfo, "Weight_Gauge"),
	_staticTextValue_Weight			= UI.getChildControl(Panel_ShipInfo, "StaticText_Weight_Value"),

	_staticText_MaxMoveSpeedValue	= UI.getChildControl(Panel_ShipInfo, "StaticText_MaxMoveSpeedValue" ),
	_staticText_AccelerationValue	= UI.getChildControl(Panel_ShipInfo, "StaticText_AccelerationValue" ),
	_staticText_CorneringSpeedValue	= UI.getChildControl(Panel_ShipInfo, "StaticText_CorneringSpeedValue" ),
	_staticText_BrakeSpeedValue		= UI.getChildControl(Panel_ShipInfo, "StaticText_BrakeSpeedValue" ),

	_staticText_Value_Def			= UI.getChildControl(Panel_ShipInfo, "StaticText_DefenceValue"),
	
	_staticSkillBG					= UI.getChildControl(Panel_ShipInfo,	"panel_skillInfo" ),
	_skillScroll					= UI.getChildControl(Panel_ShipInfo,	"skill_scroll" ),
	
	_deadCountValue					= UI.getChildControl(Panel_ShipInfo,	"StaticText_DeadCountValue" ), 

	_skillStart						= 0,	-- 현제 커서가 있는 skill 슬롯 번호 ( scroll 때문에 임시 저장 )
	_skillCount						= 0,	-- 현제 ActorKeyRaw의 배운 스킬 개수( scroll 때문에 임시 저장 )
	_actorKeyRaw					= nil,
	
	_armorName						= Array.new(),	
	_itemSlots						= Array.new(),
	_skillSlots						= Array.new(),
}

----------------------------------------------------------------------------------------------------
-- Init Function
function	shipInfo:init()
	
	-- self._skillScroll:SetControlPos( 0 )
	for	index,value in pairs(self._config._slotNo) do
		local	slot= {}
		slot.icon	= UI.getChildControl( Panel_ShipInfo, self._config._slotID[value] )
		
		SlotItem.new( slot, 'ShipInfoEquipment_' .. value, value, Panel_ShipInfo, self._config._itemSlot )
		slot:createChild()
		
		slot.icon:addInputEvent( "Mouse_RUp", "ShipInfo_RClick(" .. value .. ")"					)
		slot.icon:addInputEvent( "Mouse_LUp", "ShipInfo_LClick(" .. value .. ")"					)
		slot.icon:addInputEvent( "Mouse_On",  "ShipInfo_EquipItem_MouseOn("	.. value .. ", true)"	)
		slot.icon:addInputEvent( "Mouse_Out", "ShipInfo_EquipItem_MouseOn("	.. value .. ", false)"	)

		Panel_Tooltip_Item_SetPosition(value, slot, "ServantShipEquipment")

		self._itemSlots[value]	= slot
		self._armorName[value]	= UI.getChildControl( Panel_ShipInfo,	"StaticText_ArmorName" .. index )
	end
	
	-- for ii=0, self._config._skill.count-1	do
	-- 	local	slot	= {}
		
	-- 	slot.button	= UI.createAndCopyBasePropertyControl( Panel_ShipInfo, "skill_static",					self._staticSkillBG,	"ShipInfo_Skill_"		.. ii )
	-- 	slot.icon	= UI.createAndCopyBasePropertyControl( Panel_ShipInfo, "skill_icon",						slot.button,			"ShipInfo_Skill_Icon_"	.. ii )
	-- 	slot.name	= UI.createAndCopyBasePropertyControl( Panel_ShipInfo, "skill_name",						slot.button,			"ShipInfo_Skill_Name_"	.. ii )
	-- 	slot.dec	= UI.createAndCopyBasePropertyControl( Panel_ShipInfo, "skill_condition",					slot.button,			"ShipInfo_Skill_Dec_"	.. ii )
	-- 	slot.expBG	= UI.createAndCopyBasePropertyControl( Panel_ShipInfo, "Static_Texture_Learn_Background",	slot.button,			"ShipInfo_Skill_ExpBG_"	.. ii )
	-- 	slot.exp	= UI.createAndCopyBasePropertyControl( Panel_ShipInfo, "SkillLearn_Gauge",				slot.button,			"ShipInfo_Skill_Exp_"	.. ii )
		
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

	-- 	UIScroll.InputEventByControl( slot.button,	"ShipInfo_ScrollEvent" )
		
	-- 	self._skillSlots[ii]	= slot
	-- end
end

function	shipInfo:update()
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

	-- 스탯
		self._staticText_MaxMoveSpeedValue:SetText(		string.format( "%.1f",(servantWrapper:getStat(CppEnums.ServantStatType.Type_MaxMoveSpeed)/10000)	)	.. "%"	)
		self._staticText_AccelerationValue:SetText(		string.format( "%.1f",(servantWrapper:getStat(CppEnums.ServantStatType.Type_Acceleration)/10000)	)	.. "%"	)
		self._staticText_CorneringSpeedValue:SetText(	string.format( "%.1f",(servantWrapper:getStat(CppEnums.ServantStatType.Type_CorneringSpeed)/10000)	)	.. "%"	)
		self._staticText_BrakeSpeedValue:SetText(		string.format( "%.1f",(servantWrapper:getStat(CppEnums.ServantStatType.Type_BrakeSpeed)/10000)		)	.. "%"	)

		self._staticText_Value_Def:SetText( vehicleInfo:get():getEquipment():getDefense() )
		
	--}

	-- 죽은횟수
		local deadCount = servantWrapper:getDeadCount()
		self._deadCountValue:SetText( deadCount )

	-- 장비
	--{
		for	index, value in pairs(self._config._slotNo)	do
			local	slot		= self._itemSlots[value]
			local	slotText	= self._armorName[value]
			local	itemWrapper	= servantWrapper:getEquipItem( value )
			if	( nil ~= itemWrapper )	then
				shipInfo._config._slotEmptyBG[value]:SetShow( false )				-- 장비 슬롯 BG Off
				slot:setItem( itemWrapper )
				--slotText:SetText( itemWrapper:getStaticStatus():getName() )
			else
				slot:clearItem()
				shipInfo._config._slotEmptyBG[value]:SetShow( true )				-- 장비 슬롯 BG Off
				--slotText:SetText( "<PAColor0xFF888888>" .. self._config._slotText[value] )
			end
		end
	--}
	
	-- scroll 설정
	UIScroll.SetButtonSize( self._skillScroll, self._config._skill.count, self._skillCount )
end

function	shipInfo:registEventHandler()
	self._buttonClose:addInputEvent(	"Mouse_LUp",		"ShipInfo_Close()" )
	self._buttonQuestion:addInputEvent(	"Mouse_LUp",		"Panel_WebHelper_ShowToggle( \"PanelServantinfo\" )" )					--물음표 좌클릭
	self._buttonQuestion:addInputEvent(	"Mouse_On",			"HelpMessageQuestion_Show( \"PanelServantinfo\", \"true\")" )			--물음표 마우스오버
	self._buttonQuestion:addInputEvent(	"Mouse_Out",		"HelpMessageQuestion_Show( \"PanelServantinfo\", \"false\")" )			--물음표 마우스아웃
	
	self._staticSkillBG:addInputEvent(	"Mouse_UpScroll",	"ShipInfo_ScrollEvent( true )" )
	self._staticSkillBG:addInputEvent(	"Mouse_DownScroll",	"ShipInfo_ScrollEvent( false )" )
	
	UIScroll.InputEvent( self._skillScroll,					"ShipInfo_ScrollEvent" )
end

function	shipInfo:registMessageHandler()
	registerEvent("EventSelfServantUpdate",				"ShipInfo_Update()"			)
	registerEvent("EventServantEquipmentUpdate",		"ShipInfo_Update()"			)
	registerEvent("EventServantEquipItem",				"ShipInfo_ChangeEquipItem"	)
end

----------------------------------------------------------------------------------------------------
-- FromClient Function
-- function	ShipInfo_SkillMaster( skillKey )
-- 	UI.ASSERT( false, "말 스킬 숙련도 마스터.! Effect 작업 해주세요!!!!" )
-- end

function	ShipInfo_ChangeEquipItem( slotNo )
	local	self	= shipInfo
	local	slot	= self._itemSlots[ slotNo ]
	
	local	temporaryWrapper= getTemporaryInformationWrapper()
	local	vehicleWrapper	= temporaryWrapper:getUnsealVehicleByActorKeyRaw( self._actorKeyRaw )
	if	( nil == vehicleWrapper )	then
		return
	end	

	local vehicleType = vehicleWrapper:getVehicleType()
	if UI_VT.Type_Boat ~= vehicleType or UI_VT.Type_Raft ~= vehicleType or UI_VT.Type_FishingBoat ~= vehicleType or UI_VT.Type_SailingBoat ~= vehicleType then
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
function	ShipInfo_RClick( slotNo )
	local	self			= shipInfo
	local	temporaryWrapper= getTemporaryInformationWrapper()
	if ( nil == temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Ship ) )	then
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

function	ShipInfo_LClick( slotNo )
	if	( DragManager.dragStartPanel == Panel_Window_Inventory )	then
		Inventory_SlotRClick( DragManager.dragSlotInfo )
		DragManager.clearInfo()
	end
end

function	ShipInfo_EquipItem_MouseOn( slotNo, isOn )
	local self = shipInfo
	local slot = self._itemSlots[slotNo]
	Panel_Tooltip_Item_SetPosition( slotNo, slot, "ServantShipEquipment" )
	Panel_Tooltip_Item_Show_GeneralNormal(slotNo, "ServantShipEquipment", isOn)
end

----------------------------------------------------------------------------------------------------
-- Window Open Function
function	ShipInfo_ScrollEvent( isScrollUp )
	local	self		= shipInfo
	
	self._skillStart	= UIScroll.ScrollEvent( self._skillScroll, isScrollUp, self._config._skill.count, self._skillCount, self._skillStart, 1 )
	-- scroll, isScrollUp, configSlotCount, contentsCount, startSlot, scrollCount
	self:update()
end

----------------------------------------------------------------------------------------------------
-- Window Open Function
function	ShipInfo_OpenByActorKeyRaw( actorKeyRaw )
	local	self		= shipInfo
	self._actorKeyRaw	= actorKeyRaw
	
	ShipInfo_Open()
end

function	ShipInfo_GetActorKey()
	local	self	= shipInfo
	return( self._actorKeyRaw )
end

function	ShipInfo_Update()
	if	( not Panel_ShipInfo:GetShow() )	then
		return
	end
	
	local	self		= shipInfo
	self:update()
end

----------------------------------------------------------------------------------------------------
-- Window Open / Close
function	ShipInfo_Open()
	local	self	= shipInfo
	self:update()
	if	( Panel_ShipInfo:GetShow() )	then
		return
	end
	Panel_ShipInfo:SetShow( true, true )
end

function	ShipInfo_Close()
	if	( not Panel_ShipInfo:GetShow() )	then
		return
	end

	Panel_ShipInfo:SetShow( false, false )
end

----------------------------------------------------------------------------------------------------
-- Init
shipInfo:init()
shipInfo:registEventHandler()
shipInfo:registMessageHandler()

FGlobal_PanelMove(Panel_ShipInfo, false)