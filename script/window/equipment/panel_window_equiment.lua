Panel_Equipment:SetShow(false, false)
Panel_Equipment:ActiveMouseEventEffect(true)
Panel_Equipment:setMaskingChild(true)
Panel_Equipment:setGlassBackground(true)

Panel_Equipment:RegisterShowEventFunc( true, 'EquipmentWindow_ShowAni()' )
Panel_Equipment:RegisterShowEventFunc( false, 'EquipmentWindow_HideAni()' )

local EquipNoMin		= CppEnums.EquipSlotNo.rightHand
local EquipNoMax		= CppEnums.EquipSlotNo.equipSlotNoCount

local UnUsedEquipNo_01	= 100	--CppEnums.EquipSlotNo._UNUSED_01_
local UnUsedEquipNo_02	= 101	--CppEnums.EquipSlotNo._UNUSED_02_

local UI_ANI_ADV		= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 			= Defines.Color
local IM				= CppEnums.EProcessorInputMode
local CT				= CppEnums.ClassType

local isContentsEnable = ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 35 ) -- 연금석
local awakenWeapon = 
{
	[CT.ClassType_Warrior]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 901 ),		-- 워리어
	[CT.ClassType_Ranger]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 902 ),		-- 레인저
	[CT.ClassType_Sorcerer]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 903 ),		-- 소서러
	[CT.ClassType_Giant]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 904 ),		-- 자이언트
	[CT.ClassType_Tamer]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 905 ),		-- 금수랑
	[CT.ClassType_BladeMaster]	= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 906 ),		-- 무사
	[CT.ClassType_BladeMasterWomen] = ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 907 ),	-- 매화
	[CT.ClassType_Valkyrie]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 908 ),		-- 발키리
	[CT.ClassType_Wizard]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 909 ),		-- 위자드
	[CT.ClassType_WizardWomen]	= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 910 ),		-- 위치
	[CT.ClassType_NinjaMan]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 911 ),		-- 닌자
	[CT.ClassType_NinjaWomen]	= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 912 ),		-- 쿠노이치
}
local classType = getSelfPlayer():getClassType()
local awakenWeaponContentsOpen = awakenWeapon[classType]			-- 해당 직업의 각성 무기가 열려 있나 체크

local equip = {
	slotConfig =
	{
		-- 일단 아이콘, 테두리, 카운트(숫자) 만 적용한다!
		createIcon			= false,
		createBorder		= true,
		createCount			= true,
		createCash			= true,
		createEnduranceIcon = true,
	},
	
	slotNoId = 
	{
		[0] = 'Static_Slot_RightHand',
		[1] = 'Static_Slot_LeftHand',
		[2] = 'Static_Slot_Gather',
		
		[3] = 'Static_Slot_Chest',
		[4] = 'Static_Slot_Glove',
		[5] = 'Static_Slot_Boots',
		[6] = 'Static_Slot_Helm',
		
		[7] = 'Static_Slot_Necklace',
		[8] = 'Static_Slot_Ring1',
		[9] = 'Static_Slot_Ring2',
		[10] = 'Static_Slot_Earing1',
		[11] = 'Static_Slot_Earing2',
		[12] = 'Static_Slot_Belt',
		[13] = 'Static_Slot_Lantern',
		
		[14] = 'Static_Slot_Avatar_Chest',
		[15] = 'Static_Slot_Avatar_Gloves',
		[16] = 'Static_Slot_Avatar_Boots',
		[17] = 'Static_Slot_Avatar_Helm',

		[18] = 'Static_Slot_Avatar_RightHand',
		[19] = 'Static_Slot_Avatar_LeftHand',
		[20] = 'Static_Slot_Avatar_UnderWear',
		[22] = 'Static_Slot_FaceDecoration1',
		[23] = 'Static_Slot_FaceDecoration2',
		[21] = 'Static_Slot_FaceDecoration3',

		[27] = 'Static_Slot_AlchemyStone',	-- 연금석
		[29] = 'Static_Slot_AwakenWeapon',	-- 각성 무기
		[30] = 'Static_Slot_Avatar_AwakenWeapon',
	},
	
	avataEquipSlotId =
	{
		[14] = 'Check_Slot_Avatar_Chest',
		[15] = 'Check_Slot_Avatar_Gloves',
		[16] = 'Check_Slot_Avatar_Boots',
		[17] = 'Check_Slot_Avatar_Helm',

		[18] = 'Check_Slot_Avatar_RightHand',
		[19] = 'Check_Slot_Avatar_LeftHand',
		[20] = 'Check_Slot_Avatar_UnderWear',
		[22] = 'Check_Slot_FaceDecoration1',
		[23] = 'Check_Slot_FaceDecoration2',
		[21] = 'Check_Slot_FaceDecoration3',
		[30] = 'Check_Slot_Avatar_AwakenWeapon',
	},

	equipSlotId =
	{
		[6] = 'Check_Slot_Helm',
	},

	-- 순서에 유의 해야함
	_checkFlag =
	{
		[14]	= 1,			-- chest (avatar)
		[15]	= 2,			-- glove (avatar)
		[16]	= 4,			-- boots (avatar)
		[17]	= 8,			-- helm (avatar)

		[18]	= 32,			-- rightHand (avatar)
		[19]	= 64,			-- leftHand (avatar)
		[20] 	= 16,			-- underwear (avatar)
		[22]	= 256,			-- decoration1 (avatar)
		[23]	= 512,			-- decoration2 (avatar)
		[21]	= 128,			-- decoration3 (avatar)

		[3]		= 1 * 65536,	-- chest
		[4]		= 2 * 65536,	-- glove
		[5]		= 4 * 65536,	-- boots
		[6]		= 8 * 65536,	-- helm

		[0]		= 32 * 65536,	-- rightHand
		[1]		= 64 * 65536,	-- leftHand
		[30]	= 1024,	-- 각성 무기
	},

	slotNoIdToString = 
	{
		[0] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_MAINHAND"),		-- '주무기',
		[1] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_SUBHAND"),		-- '보조무기',
		[2] = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_GATHERTOOLS"),			-- '도구',
		
		[3] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_UPPERBODY"),		-- '갑옷',
		[4] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_GLOVES"),			-- '장갑',
		[5] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_BOOTS"),			-- '신발',
		[6] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_HELM"),			-- '투구',
		
		[7] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_NECKLACE"),		-- '목걸이',
		[8] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_RING"),			-- '반지',
		[9] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_RING"),			-- '반지',
		[10] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_EARRING"),		-- '귀걸이',
		[11] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_EARRING"),		-- '귀걸이',
		[12] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_WAISTBAND"),		-- '벨트',
		[13] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_LANTERN"),		-- '랜턴',
		
		[14] = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_AVATAR_BODY"),	 		-- '갑옷(의상)',
		[15] = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_AVATAR_HANDS"),	 	-- '장갑(의상)',
		[16] = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_AVATAR_BOOTS"),	 	-- '신발(의상)',
		[17] = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_AVATAR_HELM"),	 		-- '투구(의상)',

		[18] = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_AVATAR_MAIN"),	 		-- '주무기(의상)',
		[19] = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_AVATAR_SUB"),	 		-- '보조무기(의상)',
		[20] = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_AVATAR_UNDERWEAR"),	-- '속옷(의상)',
		[22] = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_AVATAR_EYES"),			-- '눈, 코',
		[23] = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_AVATAR_MOUSE"),		-- '입, 턱',
		[21] = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_AVATAR_HEAD"),			-- '머리, 귀',

		[27] = PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_alchemyStone"),			-- "연금석",
		[29] = PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_awakenWeapon" ),			-- 각성 무기
		[30] = PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_avatarAwakenWeapon" ),		-- 각성 무기(의상)
	},
	
	-- 컨트롤들
	slots					= Array.new(),
	slotBGs					= Array.new(),
	avataSlots				= Array.new(),
	defaultSlots			= Array.new(),
	staticTitle				= UI.getChildControl( Panel_Equipment, "Static_Text_Title" ),
	buttonClose				= UI.getChildControl( Panel_Equipment, "Button_Close" ),
	enchantText				= UI.getChildControl( Panel_Equipment, "Static_Text_Slot_Enchant_value" ),
	attackText				= UI.getChildControl( Panel_Equipment, "StaticText_Attack" ),
	attackValue				= UI.getChildControl( Panel_Equipment, "StaticText_Attack_Value" ),
	defenceText				= UI.getChildControl( Panel_Equipment, "StaticText_Defence" ),
	defenceValue			= UI.getChildControl( Panel_Equipment, "StaticText_Defence_Value" ),
	awakenText				= UI.getChildControl( Panel_Equipment, "StaticText_AwakenAttack" ),
	awakenValue				= UI.getChildControl( Panel_Equipment, "StaticText_AwakenAttack_Value" ),
	effectBG				= UI.getChildControl( Panel_Equipment, "Static_Effect" ),
	checkCloak				= UI.getChildControl( Panel_Equipment, "CheckButton_Cloak_Invisual" ),
	checkHelm				= UI.getChildControl( Panel_Equipment, "CheckButton_Helm_Invisual" ),
	checkHelmOpen			= UI.getChildControl( Panel_Equipment, "CheckButton_HelmOpen"),
	btn_PetList				= UI.getChildControl( Panel_Equipment, "Button_PetInfo" ),
	checkUnderwear			= UI.getChildControl( Panel_Equipment, "CheckButton_Underwear_Invisual"),
	checkCamouflage			= UI.getChildControl( Panel_Equipment, "CheckButton_ShowNameWhenCamouflage"),

	btn_ServantInventory	= UI.getChildControl( Panel_Equipment, "Button_ServantInventory" ),
	
	extendedSlotInfoArray	= {},
	checkExtendedSlot		= 0,
	
	checkBox_AlchemyStone	= UI.getChildControl( Panel_Equipment, "CheckBox_AlchemyStone" ),
}

local alchemyStoneQuickKey	= UI.getChildControl( Panel_Equipment, "Static_Slot_AlchemyStone_Key" )

equip.checkBox_AlchemyStone:SetCheck( false )

local _buttonQuestion	= UI.getChildControl( Panel_Equipment, "Button_Question" )			-- 물음표 버튼
local toolTip_Templete	= UI.getChildControl ( Panel_CheckedQuest, "StaticText_Notice_1")
local toolTip_BlankSlot	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Equipment, "toolTip_BlankSlot_For_Equipment" )
CopyBaseProperty( toolTip_Templete, toolTip_BlankSlot )
toolTip_BlankSlot:SetColor( ffffffff )
toolTip_BlankSlot:SetAlpha( 1.0 )
toolTip_BlankSlot:SetFontColor( UI_color.C_FFC4BEBE )
toolTip_BlankSlot:SetAutoResize( true )
toolTip_BlankSlot:SetTextHorizonCenter()
toolTip_BlankSlot:SetShow( false )
toolTip_BlankSlot:SetIgnore( false )

-- 초기화 함수
function equip_checkUseableSlot( index )
	local returnValue = true
	if index == UnUsedEquipNo_01
		or index == nUsedEquipNo_02
		or index == CppEnums.EquipSlotNo.equipSlotNoCount
		or index == CppEnums.EquipSlotNo.explorationBonus0
		or index == CppEnums.EquipSlotNo.installation4
		or index == CppEnums.EquipSlotNo.body
		or index == CppEnums.EquipSlotNo.avatarBody then
		returnValue = false
	end
	return returnValue
end

function equip:initControl()
	for v = EquipNoMin, EquipNoMax do
		if	true == equip_checkUseableSlot( v )	then
			-- 컨트롤 생성
			--BG슬롯 컨트롤 가져와서 배열에 담는거
			local slotBG = UI.getChildControl( Panel_Equipment, self.slotNoId[v] .. "_BG" )
			slotBG:SetShow( false )
			self.slotBGs[v] = slotBG
			
			-- 각성무기 On/Off로 인해 아바타BG 위치를 다시 잡아준다!
			if 15 == v then				-- 장갑
				if awakenWeaponContentsOpen then
					self.slotBGs[v]:SetPosX( 253 )
					self.slotBGs[v]:SetPosY( 178 )
				else
					self.slotBGs[v]:SetPosX( 255 )
					self.slotBGs[v]:SetPosY( 192 )
				end
			end
			
			if 16 == v then				-- 신발
				if awakenWeaponContentsOpen then
					self.slotBGs[v]:SetPosX( 89 )
					self.slotBGs[v]:SetPosY( 178 )
				else
					self.slotBGs[v]:SetPosX( 87 )
					self.slotBGs[v]:SetPosY( 192 )
				end
			end
			
			if 18 == v then				-- 주무기
				if awakenWeaponContentsOpen then
					self.slotBGs[v]:SetPosX( 89 )
					self.slotBGs[v]:SetPosY( 240 )
				else
					self.slotBGs[v]:SetPosX( 100 )
					self.slotBGs[v]:SetPosY( 260 )
				end
			end
			
			if 19 == v then				-- 보조무기
				if awakenWeaponContentsOpen then
					self.slotBGs[v]:SetPosX( 253 )
					self.slotBGs[v]:SetPosY( 240 )
				else
					self.slotBGs[v]:SetPosX( 242 )
					self.slotBGs[v]:SetPosY( 260 )
				end
			end
			
			if 20 == v then				-- 빤스
				if awakenWeaponContentsOpen then
					self.slotBGs[v]:SetPosX( 208 )
					self.slotBGs[v]:SetPosY( 282 )
				else
					self.slotBGs[v]:SetPosX( 171 )
					self.slotBGs[v]:SetPosY( 290 )
				end
			end
			
			local slot = {}
			slot.icon = UI.getChildControl( Panel_Equipment, self.slotNoId[v] )
			slot.icon:SetPosX( slotBG:GetPosX() + 4 )
			slot.icon:SetPosY( slotBG:GetPosY() - 4 )
			SlotItem.new( slot, 'Equipment_' .. v,  v, Panel_Equipment, self.slotConfig )
			slot:createChild()
		
			slot.icon:addInputEvent( "Mouse_RUp",	"Equipment_RClick(" .. v .. ")" )
			slot.icon:addInputEvent( "Mouse_LUp",	"Equipment_LClick(" .. v .. ")" )
			slot.icon:addInputEvent( "Mouse_On",	"Equipment_MouseOn(" .. v .. ",true)" )
			slot.icon:addInputEvent( "Mouse_Out",	"Equipment_MouseOn(" .. v .. ",false)" )
		
			Panel_Tooltip_Item_SetPosition(v, slot, "equipment")
			self.slots[v] = slot

			local targetControl = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Equipment, "Equip_Enchant_" .. v )
			CopyBaseProperty( equip.enchantText, targetControl )
			targetControl:SetPosX( slot.icon:GetPosX()  )
			targetControl:SetPosY( slot.icon:GetPosY() + 8 )
			targetControl:SetShow(false)
			slot.enchantText = targetControl

			-- Avata Show
			-- avataSlots 사용시 nil 체크를 해주자
			if nil ~= self.avataEquipSlotId[v] then
				self.avataSlots[v] = UI.getChildControl( Panel_Equipment, self.avataEquipSlotId[v] )
				self.avataSlots[v]:SetShow( true )
				self.avataSlots[v]:SetPosX( slot.icon:GetPosX() + slot.icon:GetSizeX() - self.avataSlots[v]:GetSizeX()*2/3 )
				self.avataSlots[v]:SetPosY( slot.icon:GetPosY() + slot.icon:GetSizeY() - self.avataSlots[v]:GetSizeX()*2/3 )
				
				self.avataSlots[v]:addInputEvent( "Mouse_LUp", "AvatarEquipSlot_LClick(" .. v .. ")" )
				
				if v <= 20 or 30 == v then	-- 의상일 경우
					self.avataSlots[v]:addInputEvent( "Mouse_On",	"Equipment_SimpleToolTips( true, 4, " .. v .. " )" )
					self.avataSlots[v]:addInputEvent( "Mouse_Out",	"Equipment_SimpleToolTips( false, 4, " .. v .. " )" )
					self.avataSlots[v]:setTooltipEventRegistFunc("Equipment_SimpleToolTips( true, 4, " .. v .. " )")
				else	-- 악세사리일 경우
					self.avataSlots[v]:addInputEvent( "Mouse_On",	"Equipment_SimpleToolTips( true, 5, " .. v .. " )" )
					self.avataSlots[v]:addInputEvent( "Mouse_Out",	"Equipment_SimpleToolTips( false, 5, " .. v .. " )" )
					self.avataSlots[v]:setTooltipEventRegistFunc("Equipment_SimpleToolTips( true, 5, " .. v .. " )")
				end
				
				if 30 == v then
					self.avataSlots[v]:SetShow( awakenWeaponContentsOpen )
				end
				
			end
			if nil ~= self.equipSlotId[v] then
				self.defaultSlots[v] = UI.getChildControl( Panel_Equipment, self.equipSlotId[v] )
				self.defaultSlots[v]:SetShow( false )

				-- self.defaultSlots[v]:addInputEvent( "Mouse_LUp",	"EquipSlot_LClick(" .. v .. ")" )
				-- self.defaultSlots[v]:addInputEvent( "Mouse_On",		"Equipment_SimpleToolTips( true, 6, " .. v .. " )" )
				-- self.defaultSlots[v]:addInputEvent( "Mouse_Out",	"Equipment_SimpleToolTips( false, 6, " .. v .. " )" )
				-- self.defaultSlots[v]:setTooltipEventRegistFunc("Equipment_SimpleToolTips( true, 6, " .. v .. " )")
			end
		end
	end

	self.checkCloak:SetShow(true)
	self.checkHelm:SetShow(true)
	self.checkHelmOpen:SetShow(true)
	self.enchantText:SetShow(false)
	self.checkUnderwear:SetShow(true)
	self.checkCamouflage:SetShow(true)

	self.checkCloak:SetCheck( not ToClient_IsShowCloak() )
	self.checkHelm:SetCheck(not ToClient_IsShowHelm())
	self.checkHelmOpen:SetCheck(ToClient_IsShowBattleHelm())
	self.checkUnderwear:SetCheck( getSelfPlayer():get():getUnderwearModeInhouse() )
	self.checkCamouflage:SetCheck(Toclient_setShowNameWhenCamouflage())

	selfPlayerShowHelmet(ToClient_IsShowHelm())
	selfPlayerShowBattleHelmet(ToClient_IsShowBattleHelm())

	self.btn_PetList:SetShow( true )

	self.checkHelm				:addInputEvent( "Mouse_On",		"Equipment_SimpleToolTips( true, 0 )" )
	self.checkHelm				:addInputEvent( "Mouse_Out",	"Equipment_SimpleToolTips( false, 0 )" )
	self.checkHelm				:setTooltipEventRegistFunc("Equipment_SimpleToolTips( true, 0 )")
	self.checkHelmOpen			:addInputEvent( "Mouse_On",		"Equipment_SimpleToolTips( true, 1 )" )
	self.checkHelmOpen			:addInputEvent( "Mouse_Out",	"Equipment_SimpleToolTips( false, 1 )" )
	self.checkHelmOpen			:setTooltipEventRegistFunc("Equipment_SimpleToolTips( true, 1 )")
	self.checkCloak				:addInputEvent( "Mouse_On",		"Equipment_SimpleToolTips( true, 6 )" )
	self.checkCloak				:addInputEvent( "Mouse_Out",	"Equipment_SimpleToolTips( false, 6 )" )
	self.checkCloak				:setTooltipEventRegistFunc("Equipment_SimpleToolTips( true, 6 )")
	self.checkUnderwear			:addInputEvent( "Mouse_On",		"Equipment_SimpleToolTips( true, 7 )" )
	self.checkUnderwear			:addInputEvent( "Mouse_Out",	"Equipment_SimpleToolTips( false, 7 )" )
	self.checkUnderwear			:setTooltipEventRegistFunc("Equipment_SimpleToolTips( true, 7 )")
	self.btn_PetList			:addInputEvent( "Mouse_On",		"Equipment_SimpleToolTips( true, 2 )" )
	self.btn_PetList			:addInputEvent( "Mouse_Out",	"Equipment_SimpleToolTips( false, 2 )" )
	self.btn_PetList			:setTooltipEventRegistFunc("Equipment_SimpleToolTips( true, 2 )")
	self.btn_ServantInventory	:addInputEvent( "Mouse_On",		"Equipment_SimpleToolTips( true, 3 )" )
	self.btn_ServantInventory	:addInputEvent( "Mouse_Out",	"Equipment_SimpleToolTips( false, 3 )" )
	self.btn_ServantInventory	:setTooltipEventRegistFunc("Equipment_SimpleToolTips( true, 3 )")
	self.checkCamouflage		:addInputEvent( "Mouse_On",		"Equipment_SimpleToolTips( true, 8 )" )
	self.checkCamouflage		:addInputEvent( "Mouse_Out",	"Equipment_SimpleToolTips( false, 8 )" )
	self.checkCamouflage		:setTooltipEventRegistFunc("Equipment_SimpleToolTips( true, 8 )")	
end

-- 이벤트 핸들러들
function EquipmentWindow_Close()
	-- 꺼준다
	if Panel_Equipment:IsShow() then
		Panel_Equipment:SetShow(false, false);
		CharacterInfoWindow_Hide()
		
		if ToClient_IsSavedUi() then
			ToClient_SaveUiInfo( true )
			ToClient_SetSavedUi( false )
		end
	end	
	
	HelpMessageQuestion_Out()		-- 물음표 버튼 툴팁 끄기
end


function EquipmentWindow_ShowAni()
	UIAni.fadeInSCR_Left(Panel_Equipment)
	
	local aniInfo1 = Panel_Equipment:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.05)
	aniInfo1.AxisX = Panel_Equipment:GetSizeX() / 2
	aniInfo1.AxisY = Panel_Equipment:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_Equipment:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.05)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_Equipment:GetSizeX() / 2
	aniInfo2.AxisY = Panel_Equipment:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function EquipmentWindow_HideAni()
	-- 꺼준다
	Panel_Equipment:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo1 = Panel_Equipment:addColorAnimation( 0.0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)
end

function Equipment_MouseOn( slotNo, isOn )
	Panel_Tooltip_Item_Show_GeneralNormal(slotNo, "equipment", isOn)
	-- 비어있을 때!
	-- Equipment_NilSlot_MouseOn( slotNo, isOn )
end

function Equipment_NilSlot_MouseOn( slotNo, isOn )
	local self = equip
	if true == isOn then
		toolTip_BlankSlot:SetText( self.slotNoIdToString[slotNo] )
		toolTip_BlankSlot:SetSize( toolTip_BlankSlot:GetTextSizeX() + 30, toolTip_BlankSlot:GetSizeY() )
		toolTip_BlankSlot:SetPosX( self.slots[slotNo].icon:GetPosX() - toolTip_BlankSlot:GetTextSizeX() )
		toolTip_BlankSlot:SetPosY( self.slots[slotNo].icon:GetPosY() - toolTip_BlankSlot:GetSizeY() )
		toolTip_BlankSlot:SetShow( true )
	else
		toolTip_BlankSlot:SetShow( false )
	end
end

local _offenceValue, _awakenOffecnValue, _defenceValue
function Equipment_RClick( slotNo )
	local itemWrapper = getEquipmentItem( slotNo )
	if nil ~= itemWrapper then
		if( Panel_Window_Repair:IsShow() ) and not Panel_FixEquip:GetShow() then	-- 수리UI에서 수리 모드인 경우.
			Repair_EquipWindowRClick( slotNo, itemWrapper );
		elseif Panel_Window_Repair:IsShow() and Panel_FixEquip:GetShow() then	 	-- 수리UI에서 최대 내구 수리 모드인 경우.
			equipmentDoUnequip( slotNo )
		else
			equipmentDoUnequip( slotNo )
		end
	end
end

function Equipment_LClick( slotNo )
	if DragManager.dragStartPanel == Panel_Window_Inventory then
		--장착 가능한 슬롯인지 체크코드 삽입해야한다.
		local dragSlotNo = DragManager.dragSlotInfo
		local itemWrapper = getInventoryItem( dragSlotNo )
		if (nil ~= itemWrapper) then
			local itemStatic = itemWrapper:getStaticStatus()
			if itemStatic:isEquipable() then 
				Inventory_SlotRClickXXX(DragManager.dragSlotInfo, slotNo)
				DragManager:clearInfo()
			end
		end
			-- local itemWrapper = getEquipmentItem( slotNo )
			-- if nil ~= itemWrapper then
			-- 	equipmentDoUnequip( slotNo )
		 --  	end
	end
end

function AvatarEquipSlot_LClick( slotNo )
	local self = equip
	
	local selfPlayer = getSelfPlayer()
	if selfPlayer ~= nil then
		if selfPlayer:get():getUnderwearModeInhouse() then
			local isCheckedTemp = self.avataSlots[slotNo]:IsCheck()
			if isCheckedTemp then
				isCheckedTemp = false;
			else
				isCheckedTemp = true;
			end
			self.avataSlots[slotNo]:SetCheck( isCheckedTemp )
			return
		end
	end
	
	local isChecked = self.avataSlots[slotNo]:IsCheck()		-- 현재 시점에서는 아직 클릭으로 오지 않는다. 반대로 해야한다....
	if true == isChecked then
		ToClient_SetAvatarEquipSlotFlag( self._checkFlag[slotNo] )
	else
		ToClient_ResetAvatarEquipSlotFlag( self._checkFlag[slotNo] )
	end
	
	Toclient_setShowAvatarEquip()
	
	-- _PA_LOG( "asdf", "isChecked : " .. tostring( isChecked ) .. " slotNo : " .. tostring( slotNo ) )
end

--[[ 일반 장비의 투구 숨기기 버튼 기능 동작을 막는다.(2015.10.03)
function EquipSlot_LClick( slotNo )
	local self = equip
	
	local selfPlayer = getSelfPlayer()
	if selfPlayer ~= nil then
		if selfPlayer:get():getUnderwearModeInhouse() then
			local isCheckedTemp = self.defaultSlots[slotNo]:IsCheck()
			if isCheckedTemp then
				isCheckedTemp = false;
			else
				isCheckedTemp = true;
			end
			self.defaultSlots[slotNo]:SetCheck( isCheckedTemp )
			return
		end
	end
	
	local isChecked = self.defaultSlots[slotNo]:IsCheck()		-- 현재 시점에서는 아직 클릭으로 오지 않는다. 반대로 해야한다....
	if true == isChecked then
		ToClient_SetAvatarEquipSlotFlag( self._checkFlag[slotNo] )
	else
		ToClient_ResetAvatarEquipSlotFlag( self._checkFlag[slotNo] )
	end
	
	Toclient_setShowAvatarEquip()
	
	-- _PA_LOG( "asdf", "isChecked : " .. tostring( isChecked ) .. " slotNo : " .. tostring( slotNo ) )
end
--]]

--[[
function Equipment_ShowToggle()
	local isShow = Panel_Equipment:IsShow()
	Equipment_SetShow( not false )
end]]--
local equipMentPosX = 0
local equipMentPosY = 0
function Equipment_PosSaveMemory()
	equipMentPosX = Panel_Equipment:GetPosX()
	equipMentPosY = Panel_Equipment:GetPosY()
end
function Equipment_PosLoadMemory()
	Panel_Equipment:SetPosX(equipMentPosX)
	Panel_Equipment:SetPosY(equipMentPosY)
end

function Equipment_SetShow( isShow )
	local self = equip
	if true == isShow then
		if GetUIMode() == Defines.UIMode.eUIMode_NpcDialog then
			Panel_Equipment:SetShow(false, false)
		else
			Panel_Equipment:SetShow(true, true)
		end
	else
		Panel_Equipment:SetShow(false, false)
		if ToClient_IsSavedUi() then
			ToClient_SaveUiInfo( true )
			ToClient_SetSavedUi( false )
		end
	end
	Inventory_SetFunctor( nil, nil, EquipmentWindow_Close, nil )
	
		
	for v = EquipNoMin, EquipNoMax do
		if	true == equip_checkUseableSlot( v )	then
			if nil ~= self.avataSlots[v] and nil ~= self._checkFlag[v] then
				local isCheck = ToClient_IsSetAvatarEquipSlotFlag( self._checkFlag[v] )
				self.avataSlots[v]:SetCheck( isCheck )			
			end
		end
	end

	-- if Panel_Equipment:IsShow() ~= isShow then
	-- 	if isShow then
	-- 		Panel_Equipment:SetShow(false, false)
	-- 	end
	-- 	Panel_Equipment:SetShow(isShow, isShow)

	-- 	if isShow then
	-- 		Inventory_SetFunctor( nil, nil, EquipmentWindow_Close, nil );
	-- 	end
	-- end

	local alchemyStoneQuickKeyString = keyCustom_GetString_UiKey( CppEnums.UiInputType.UiInputType_AlchemySton )
	alchemyStoneQuickKey:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_QUICKCOMMAND", "keyString", alchemyStoneQuickKeyString ) )
	local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
	local isSafeZone = regionInfo:get():isSafeZone()
	if not isSafeZone then
		self.checkUnderwear:SetEnable( true )
		self.checkUnderwear:SetCheck( false )
	end
	Equipment_updateSlotData()
end

function FGlobal_Equipment_SetHide( isShow )
	Equipment_SetShow( isShow )
end

function FGlobal_Equipment_SetFunctionButtonHide( isShow )
	equip.btn_PetList			:SetShow( isShow )
	equip.checkUnderwear		:SetShow( isShow )
	equip.checkCamouflage		:SetShow( isShow )
	equip.btn_ServantInventory	:SetShow( isShow )
	equip.checkBox_AlchemyStone	:SetShow( isShow )
end

function equip:registEventHandler()
	self.buttonClose	:addInputEvent( "Mouse_LUp",	"EquipmentWindow_Close()" )
	self.checkCloak		:addInputEvent( "Mouse_LUp",	"Check_Cloak()" )
	self.checkHelm		:addInputEvent( "Mouse_LUp",	"Check_Helm()" )
	self.checkHelmOpen	:addInputEvent( "Mouse_LUp",	"Check_HelmOpen()")
	self.checkUnderwear	:addInputEvent( "Mouse_LUp",	"Check_Underwear()")
	self.checkCamouflage:addInputEvent( "Mouse_LUp",	"Check_ShowNameWhenCamouflage()" )
	_buttonQuestion		:addInputEvent( "Mouse_LUp",	"Panel_WebHelper_ShowToggle( \"PanelWindowEquipment\" )" )						-- 물음표 좌클릭
	_buttonQuestion		:addInputEvent( "Mouse_On",		"HelpMessageQuestion_Show( \"PanelWindowEquipment\", \"true\")" )			-- 물음표 마우스오버
	_buttonQuestion		:addInputEvent( "Mouse_Out",	"HelpMessageQuestion_Show( \"PanelWindowEquipment\", \"false\")" )			-- 물음표 마우스아웃

	self.btn_PetList	:addInputEvent( "Mouse_LUp",	"FGlobal_PetListNew_Toggle()" )	-- 펫 리스트를 연다.

	self.btn_ServantInventory:addInputEvent( "Mouse_LUp", "HandleClicked_ServantInventoryOpen()")
--	registerKeyEvent( CppEnums.VirtualKeyCode.KeyCode_I, "KeyDown", "Equipment_ShowToggle")
end

local function extendedSlotInfo( itemWrapper, SlotNo )	
	
	local itemSSW = itemWrapper:getStaticStatus()
	local itemName = itemSSW:getName()
	local slotNoMax = itemSSW:getExtendedSlotCount()
	local extendedSlotString = ""
	local compareSlot = {}

	for i = 1, slotNoMax do
		local extendSlotNo = itemSSW:getExtendedSlotIndex(i-1)		
		if( slotNoMax ~= extendSlotNo ) then
			equip.extendedSlotInfoArray[extendSlotNo] = SlotNo
			setItemCount = equip.extendedSlotInfoArray[extendSlotNo]
			equip.checkExtendedSlot = 1
			compareSlot[i] = extendSlotNo
			extendedSlotString = extendedSlotString .. ", " .. equip.slotNoId[extendSlotNo] .. "_BG"
		end
	end
end

local function setItemInfoUseWrapper( slot, itemWrapper, isMono, isExtended )
	slot:setItem( itemWrapper )

	local itemSSW = itemWrapper:getStaticStatus()
	local enchantCount = itemSSW:get()._key:getEnchantLevel()
	
	if (0 < enchantCount) and (enchantCount < 16) and (false == isExtended) then
		slot.enchantText:SetText( "+" .. tostring(enchantCount) )		-- 인챈트 수치
		slot.enchantText:SetShow(true)
	elseif 16 == enchantCount and (false == isExtended) then
		slot.enchantText:SetText( "I" )		-- 인챈트 수치
		slot.enchantText:SetShow(true)
	elseif 17 == enchantCount and (false == isExtended) then
		slot.enchantText:SetText( "II" )		-- 인챈트 수치
		slot.enchantText:SetShow(true)
	elseif 18 == enchantCount and (false == isExtended) then
		slot.enchantText:SetText( "III" )		-- 인챈트 수치
		slot.enchantText:SetShow(true)
	elseif 19 == enchantCount and (false == isExtended) then
		slot.enchantText:SetText( "IV" )		-- 인챈트 수치
		slot.enchantText:SetShow(true)
	elseif 20 == enchantCount and (false == isExtended) then
		slot.enchantText:SetText( "V" )		-- 인챈트 수치
		slot.enchantText:SetShow(true)
	-- elseif 20 <= enchantCount and (false == isExtended) then
	-- 	slot.enchantText:SetText( "VI" )		-- 인챈트 수치
	-- 	slot.enchantText:SetShow(true)
	else
		slot.enchantText:SetShow(false)
	end
	
	-- 캐시 아이템은 인챈트 수치를 노출하지 않는다!!
	if itemSSW:get():isCash() then
		slot.enchantText:SetShow(false)
	end
	
	-- 액세서리일 경우 인챈트 표기를 달리 해준다!
	if CppEnums.ItemClassifyType.eItemClassify_Accessory == itemWrapper:getStaticStatus():getItemClassify() then
		if 1 == enchantCount and (false == isExtended) then
			slot.enchantText:SetText( "I" )		-- 인챈트 수치
			slot.enchantText:SetShow(true)
		elseif 2 == enchantCount and (false == isExtended) then
			slot.enchantText:SetText( "II" )		-- 인챈트 수치
			slot.enchantText:SetShow(true)
		elseif 3 == enchantCount and (false == isExtended) then
			slot.enchantText:SetText( "III" )		-- 인챈트 수치
			slot.enchantText:SetShow(true)
		elseif 4 == enchantCount and (false == isExtended) then
			slot.enchantText:SetText( "IV" )		-- 인챈트 수치
			slot.enchantText:SetShow(true)
		elseif 5 == enchantCount and (false == isExtended) then
			slot.enchantText:SetText( "V" )		-- 인챈트 수치
			slot.enchantText:SetShow(true)
		end
	end
	
	if ( false == isExtended ) then
		slot.icon:SetEnable( true )
	else
		slot.icon:SetEnable( false )
	end	
	
	if ( true == isMono ) then
		slot.icon:SetMonoTone(true)
		slot.enchantText:SetMonoTone(true)
	elseif ( false == isMono ) then
		slot.icon:SetMonoTone(false)
		slot.enchantText:SetMonoTone(false)
	end
end

-- 메시지 핸들러들
-- 슬롯 정보 갱신. 한번에 전체를 모두 갱신한다.!
function Equipment_updateSlotData()
	local self = equip

	self.extendedSlotInfoArray = {}
	self.checkExtendedSlot = 0

	for v = EquipNoMin, EquipNoMax do
		if	true == equip_checkUseableSlot( v ) then
			local itemWrapper = getEquipmentItem( v )
			local slot = self.slots[v]
			local slotBG = self.slotBGs[v]
			if nil ~= itemWrapper then
				extendedSlotInfo( itemWrapper, v )
				setItemInfoUseWrapper( slot, itemWrapper, false, false)

				local itemss = itemWrapper:getStaticStatus()
				local name = itemss:getName()
				slotBG:SetShow( false )

				slot.icon:addInputEvent( "Mouse_On", "Equipment_MouseOn(" .. v .. ",true)" )
				slot.icon:addInputEvent( "Mouse_Out","Equipment_MouseOn(" .. v .. ",false)" )
			else
				slot.enchantText:SetShow(false)
				slot:clearItem()
				slot.icon:SetEnable( true )
				slotBG:SetShow( true )

				if CppEnums.EquipSlotNo.awakenWeapon == v or CppEnums.EquipSlotNo.avatarAwakenWeapon == v then		-- 각성 무기는 컨텐츠 옵션이 열려 있어야 보인다
					slotBG:SetShow( awakenWeaponContentsOpen )
					slot.icon:SetEnable( awakenWeaponContentsOpen )
					slot.icon:SetShow( awakenWeaponContentsOpen )
				end

				slot.icon:addInputEvent( "Mouse_On", "Equipment_NilSlot_MouseOn(" .. v .. ",true)" )
				slot.icon:addInputEvent( "Mouse_Out","Equipment_NilSlot_MouseOn(" .. v .. ",false)" )
			end
		end
	end		
	
	local isSetAwakenWeapon = getEquipmentItem( CppEnums.EquipSlotNo.awakenWeapon )
	if awakenWeaponContentsOpen and nil ~= isSetAwakenWeapon then
		equip.awakenText:SetShow( true )
		equip.awakenValue:SetShow( true )
		equip.attackText:SetSpanSize( 35, equip.attackText:GetSpanSize().y )
		equip.defenceText:SetSpanSize( 35, equip.defenceText:GetSpanSize().y )
		equip.attackValue:SetSpanSize( 25, equip.attackValue:GetSpanSize().y )
		equip.defenceValue:SetSpanSize( 25, equip.defenceValue:GetSpanSize().y )
	else
		equip.awakenText:SetShow( false )
		equip.awakenValue:SetShow( false )
		equip.attackText:SetSpanSize( 105, equip.attackText:GetSpanSize().y )
		equip.defenceText:SetSpanSize( 105, equip.defenceText:GetSpanSize().y )
		equip.attackValue:SetSpanSize( 95, equip.attackValue:GetSpanSize().y )
		equip.defenceValue:SetSpanSize( 95, equip.defenceValue:GetSpanSize().y )
	end
	
	if( self.checkExtendedSlot == 1 ) then
		for  extendSlotNo, parentSlotNo in pairs(self.extendedSlotInfoArray) do
			local itemWrapper = getEquipmentItem( parentSlotNo )
			local setSlotBG = self.slotBGs[extendSlotNo]
			slot = self.slots[extendSlotNo]
			setSlotBG:SetShow( false )
			setItemInfoUseWrapper( slot, itemWrapper, true, true )
		end
	end
--{ 컨텐츠 옵션에 의해서 연금석 슬롯 사용여부를 결정한다.
	if not isContentsEnable then
		self.slotBGs[27]		:SetShow( false )
		self.slots[27].icon		:SetShow( false )
		alchemyStoneQuickKey	:SetShow( false )
	end
--}
	interaction_Forceed()	-- 채집 도구 유무에 따른 인터렉션 갱신용.
	updateAttackStat();		-- 공격력, 방어력 계산
		
	self.attackValue:SetText(tostring(getOffence()))
	self.defenceValue:SetText( tostring(getDefence()))
	self.awakenValue:SetText(tostring(getAwakenOffence()))

	_offenceValue = getOffence()
	_awakenOffecnValue = getAwakenOffence()
	_defenceValue = getDefence()
	
	if Panel_Global_Manual:GetShow() then
		setFishingResourcePool_text()
	end
	
	if nil == getEquipmentItem( 27 ) then			-- 연금석이 장착돼 있는지 체크
		equip.checkBox_AlchemyStone:SetShow( false )
		equip.checkBox_AlchemyStone:SetCheck( false )
	else
		if Panel_Window_Repair:GetShow() then
			equip.checkBox_AlchemyStone:SetShow( false )
		else
			equip.checkBox_AlchemyStone:SetShow( true )
		end
	end

	local alchemyStoneQuickKeyString = keyCustom_GetString_UiKey( CppEnums.UiInputType.UiInputType_AlchemySton )
	alchemyStoneQuickKey:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_QUICKCOMMAND", "keyString", alchemyStoneQuickKeyString ) )
end

local _awakenValue = 0
function	Equipment_equipItem( slotNo )
	local self = equip
	local slot = self.slots[slotNo]
	if 13 < slotNo and slotNo < 24 then
		slot.icon:AddEffect("UI_ItemInstall_Cash", false, 0.0, 0.0)
	else
		slot.icon:AddEffect("UI_ItemInstall", false, 0.0, 0.0)
	end
	slot.icon:AddEffect("fUI_SkillButton01", false, 0.0, 0.0)
	if slotNo < 14 or 29 == slotNo then
		self.effectBG:AddEffect("UI_ItemInstall_BigRing", false, -0.9, -58.0)
	else
		self.effectBG:AddEffect("UI_ItemInstall_BigRing02", false, -0.9, -58.0)
	end
	
	updateAttackStat();		-- 공격력, 방어력 계산
	local itemWrapper = getEquipmentItem( slotNo )
	if nil ~= itemWrapper then
		
		if _offenceValue ~= getOffence() then
			self.attackValue:AddEffect("fUI_SkillButton01", false, 0, 0)
			self.attackValue:AddEffect("UI_SkillButton01", false, 0, 0)
		end
		if _awakenOffecnValue ~= getAwakenOffence() and awakenWeaponContentsOpen then
			self.awakenValue:AddEffect("fUI_SkillButton01", false, 0, 0)
			self.awakenValue:AddEffect("UI_SkillButton01", false, 0, 0)
		end
		if _defenceValue ~= getDefence() then
			self.defenceValue:AddEffect("fUI_SkillButton01", false, 0, 0)
			self.defenceValue:AddEffect("UI_SkillButton01", false, 0, 0)
		end
		
		-- local meleeAttack = itemWrapper:getStaticStatus():getMaxDamage(0)
		-- local rangeAttack = itemWrapper:getStaticStatus():getMaxDamage(1)
		-- local magicAttack = itemWrapper:getStaticStatus():getMaxDamage(2)
		-- local defence = itemWrapper:getStaticStatus():getDefence(0)
		
		-- if 0 < meleeAttack or 0 < rangeAttack or 0 < magicAttack then
			-- self.attackValue:AddEffect("fUI_SkillButton01", false, 0, 0)
			-- self.attackValue:AddEffect("UI_SkillButton01", false, 0, 0)
		-- end
	
		-- if 0 < defence then
			-- self.defenceValue:AddEffect("fUI_SkillButton01", false, -1, 0)
			-- self.defenceValue:AddEffect("UI_SkillButton01", false, -1, 0)
		-- end
		
	end
end

function	Equipment_onScreenResize()
	Panel_Equipment:SetPosX( Panel_Window_Inventory:GetPosX() - Panel_Equipment:GetSizeX() )
	Panel_Equipment:SetPosY( getScreenSizeY() - (getScreenSizeY()/2) - (Panel_Equipment:GetSizeY()/2) )
end

function equip:registMessageHandler()
	registerEvent("EventEquipmentUpdate",	"Equipment_updateSlotData");
	registerEvent("EventEquipItem",			"Equipment_equipItem");
	registerEvent("EventPCEquipSetShow",	"Equipment_SetShow");
	registerEvent("onScreenResize",			"Equipment_onScreenResize" )
end

function Check_Cloak()
	selfPlayerShowCloak( not equip.checkCloak:IsCheck() )
end

function Check_Helm()
	selfPlayerShowHelmet( not equip.checkHelm:IsCheck() )
end

function Check_HelmOpen()
	selfPlayerShowBattleHelmet( equip.checkHelmOpen:IsCheck() )
end

function Check_ShowNameWhenCamouflage()
	Toclient_setShowNameWhenCamouflage(not getSelfPlayer():get():isShowNameWhenCamouflage())
end



function Check_Underwear()
	local selfPlayer = getSelfPlayer()
	local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
	local isSafeZone = regionInfo:get():isSafeZone()

	if isSafeZone then
		if selfPlayer:get():getUnderwearModeInhouse() then
			selfPlayer:get():setUnderwearModeInhouse( false )
			Toclient_setShowAvatarEquip()
		else
			selfPlayer:get():setUnderwearModeInhouse( true )
		end
	else
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_EQUIP_UNDERWARE_ALERT")) -- "안전지역에서만 설정할 수 있습니다." )
		equip.checkUnderwear:SetCheck( false )
	end
end

function FGlobal_CheckUnderwear()
	local self			= equip
	local regionInfo	= getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
	local isSafeZone	= regionInfo:get():isSafeZone()

	if not isSafeZone then
		self.checkUnderwear:SetCheck( false )
	end
end

function Equipment_SimpleToolTips( isShow, btnType, flagControl )
	if btnType == 0 then -- 투구 벗기	-- 의상 감추기와 겹치므로 제거
		name = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_TOOLTIPS_CHECKHELM_NAME") -- "머리 부위 장비 설정"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_TOOLTIPS_CHECKHELM_DESC") -- "머리 부위의 장비를 가리거나 보이게 합니다."
		uiControl = equip.checkHelm
	elseif btnType == 1 then -- 안면 투구 열기
		name = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_TOOLTIPS_CHECKHELMOPEN_NAME") -- "안면 보호대 설정"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_TOOLTIPS_CHECKHELMOPEN_DESC") -- "안면 보호대를 열거나 닫습니다."
		uiControl = equip.checkHelmOpen
	elseif btnType == 2 then -- 펫 버튼
		name = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_TOOLTIPS_BTN_PETLIST_NAME") -- "애완동물"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_TOOLTIPS_BTN_PETLIST_DESC") -- "애완동물 목록을 볼 수 있습니다."
		uiControl = equip.btn_PetList
	elseif btnType == 3 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_TOOLTIPS_BTN_SERVANTINVENTORY_NAME") -- "탑승물 가방 보기"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_TOOLTIPS_BTN_SERVANTINVENTORY_DESC") -- "탑승물의 가방을 볼 수 있습니다. 탑승물과 일정 거리가 멀어지면 가방은 열리지 않습니다."
		uiControl = equip.btn_ServantInventory
	elseif btnType == 4 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_TOOLTIPS_BTN_CHECKFLAG_NAME")	-- "의상 감추기"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_TOOLTIPS_BTN_CHECKFLAG_DESC")	-- "의상을 감출 수 있습니다."
		uiControl = UI.getChildControl( Panel_Equipment, equip.avataEquipSlotId[flagControl] )
	elseif btnType == 5 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_TOOLTIPS_BTN_CHECKFLAG_DECO_NAME")	-- "장신구 감추기"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_TOOLTIPS_BTN_CHECKFLAG_DECO_DESC")	-- "장신구를 감출 수 있습니다."
		uiControl = UI.getChildControl( Panel_Equipment, equip.avataEquipSlotId[flagControl] )
	elseif btnType == 6 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_TOOLTIP_CLOAK_NAME") -- 망토 설정
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_TOOLTIP_CLOAK_DESC") -- 망토를 숨기거나 보이게 합니다.
		uiControl = equip.checkCloak
	elseif btnType == 7 then		-- 속옷
		name = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_UNDERWEAR_TOOLTIP_NAME") -- "속옷 설정"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_UNDERWEAR_TOOLTIP_DESC") -- "속옷 차림 상태로 바꿀 수 있습니다.\n안전 지역에서만 설정 가능합니다."
		uiControl = equip.checkCloak
	elseif btnType == 8 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_CAMOUFLAGE_TOOLTIP_NAME") -- "이름"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_CAMOUFLAGE_TOOLTIP_DESC") -- "위장복 착용시 아군에게 이름을 노출하지 않습니다"
		uiControl = equip.checkCamouflage
	end

	registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
	if true == isShow then
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function HandleClicked_ServantInventoryOpen()
	if GetUIMode() == Defines.UIMode.eUIMode_Repair then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_REPAIRMODENOOPENINVENTORY") ) -- "수리 중에는 탑승물 가방을 열 수 없습니다.")
		return
	end

	Panel_Window_ServantInventory:SetPosX( getScreenSizeX() - Panel_Equipment:GetSizeX() - Panel_Equipment:GetPosX() )
	Panel_Window_ServantInventory:SetPosY( getScreenSizeY() - Panel_Equipment:GetSizeY() - Panel_Equipment:GetPosY() )
	ServantInventory_OpenAll()
end

-- 파괴 : 3분
-- 수호 : 3분
-- 생명 : 10분
function FGlobal_AlchemyStonCheck()
	local itemWrapper = getEquipmentItem( 27 )
	local coolTime = 0
	if nil ~= itemWrapper then
		if equip.checkBox_AlchemyStone:IsCheck() then
			local alchemyStoneType = itemWrapper:getStaticStatus():get()._contentsEventParam1
			if 0 == alchemyStoneType then
				coolTime = 182
			elseif 1 == alchemyStoneType then
				coolTime = 182
			elseif 2 == alchemyStoneType then
				coolTime = 602
			end
		end
	end
	return coolTime
end

-- 초기화 코드
equip:initControl()
equip:registEventHandler()
equip:registMessageHandler()