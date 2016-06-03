local UI_TM			= CppEnums.TextMode
local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE
local UI_color		= Defines.Color
local UI_classType	= CppEnums.ClassType
local UI_PreviewType= CppEnums.InGameCashShopPreviewType
local CT			= CppEnums.ClassType

Panel_IngameCashShop_SetEquip:SetShow( false )

-- local awakenWeapon = 
-- {
	-- [CT.ClassType_Warrior]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 901 ),		-- 워리어
	-- [CT.ClassType_Ranger]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 902 ),		-- 레인저
	-- [CT.ClassType_Sorcerer]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 903 ),		-- 소서러
	-- [CT.ClassType_Giant]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 904 ),		-- 자이언트
	-- [CT.ClassType_Tamer]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 905 ),		-- 금수랑
	-- [CT.ClassType_BladeMaster]	= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 906 ),		-- 무사
	-- [CT.ClassType_BladeMasterWomen] = ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 907 ),	-- 매화
	-- [CT.ClassType_Valkyrie]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 908 ),		-- 발키리
	-- [CT.ClassType_Wizard]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 909 ),		-- 위자드
	-- [CT.ClassType_WizardWomen]	= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 910 ),		-- 위치
	-- [CT.ClassType_NinjaMan]		= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 911 ),		-- 닌자
	-- [CT.ClassType_NinjaWomen]	= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 912 ),		-- 쿠노이치
-- }
-- local classType = getSelfPlayer():getClassType()
local awakenWeaponContentsOpen = ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 901 )			-- 해당 직업의 각성 무기가 열려 있나 체크

local CashShopSetEquip = {
	BTN_BuyAll			= UI.getChildControl( Panel_IngameCashShop_SetEquip, "Button_BuyAll"),
	BTN_Exit			= UI.getChildControl( Panel_IngameCashShop_SetEquip, "Button_Exit"),
	BTN_QNA				= UI.getChildControl( Panel_IngameCashShop_SetEquip, "Button_QNA"),
	
	SlotUIPool			= {},

	beforProductNoRaw	= -1,
	nowProductNoRaw		= -1,
	beforSetClass		= -1,
	nowSetClass			= -1,

	serventType			= {
		horse	= 0,
		ship	= 1,
		carriage= 2,
	},
	hasServantType			= -1,

	SetEquipSlotNo		= {
		14, 	-- 갑옷(의상)
		15, 	-- 장갑(의상)
		16, 	-- 신발(의상)
		17, 	-- 투구(의상)
		18, 	-- '주무기(의상)',
		19, 	-- '보조무기(의상)',
		20, 	-- '속옷(의상)',
		21, 	-- '속옷(의상)',
		22, 	-- '속옷(의상)',
		23, 	-- '속옷(의상)',
		13,		-- 등불
	},
	SetCharacterEquipName 		= {
		[14]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_BODY"), -- '갑옷(의상)',
		[15]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HANDS"), -- '장갑(의상)',
		[16]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_BOOTS"), -- '신발(의상)',
		[17]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HELM"), -- '투구(의상)',
		[18]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_MAINHANDS"), -- '주무기(의상)',
		[19]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_SUBHANDS"), -- '보조무기(의상)',
		[20]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_UNDERWEAR"), -- '속옷(의상)',
		[21]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_EARING"), -- '귀 장신구',
		[22]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_EYE"), -- '눈 장신구',
		[23]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_MOUTH"), -- '입 장신구',
		[13]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_LAMPLIGHT"), -- '등불',
	},
	SetHorseEquipName 		= {
		[14]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_BARD"), -- '마갑',
		[15]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_SADDLE"), -- '안장',
		[16]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_STIRRUP"), -- '등자',
		[17]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HORSEHEAD"), -- '마면',
		[18]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_EMPTYSLOT"), -- '빈 슬롯',
		[19]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_EMPTYSLOT"), -- '빈 슬롯',
		[20]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_EMPTYSLOT"), -- '빈 슬롯',
		[21]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_EMPTYSLOT"), -- '빈 슬롯',
		[22]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_EMPTYSLOT"), -- '빈 슬롯',
		[23]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_EMPTYSLOT"), -- '빈 슬롯',
	},
	SetCarriageEquipName 		= {
		[14]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_CARRIAGEAVATAR") .. '14', -- '마차_의상14',
		[15]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_CARRIAGEAVATAR") .. '15', -- '마차_의상15',
		[16]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_CARRIAGEAVATAR") .. '16', -- '마차_의상16',
		[17]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_CARRIAGEAVATAR") .. '17', -- '마차_의상17',
		[18]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_CARRIAGEAVATAR") .. '18', -- '마차_의상18',
		[19]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_CARRIAGEAVATAR") .. '19', -- '마차_의상19',
		[20]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_CARRIAGEAVATAR") .. '20', -- '마차_의상20',
		[21]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_CARRIAGEAVATAR") .. '21', -- '마차_의상21',
		[22]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_CARRIAGEAVATAR") .. '22', -- '마차_의상22',
		[23]	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_CARRIAGEAVATAR") .. '23', -- '마차_의상23',
	},
}

local TemplateSetEquip = {
	ItemBG		= UI.getChildControl( Panel_IngameCashShop_SetEquip, "Static_ItemBG"),
	ItemName	= UI.getChildControl( Panel_IngameCashShop_SetEquip, "StaticText_ItemName"),
	BTN_UnSet	= UI.getChildControl( Panel_IngameCashShop_SetEquip, "Button_UnSet"),
}

function CashShopSetEquip:Initialize()
	local startPosY = 40 
	local slotYGap	= 32
	local sizeY		= 0
	for	index, value in pairs(self.SetEquipSlotNo) do
		local tempSlot = {}
		local CreateItemBG = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Panel_IngameCashShop_SetEquip, 'CashShop_SetEquip_ItemBG_' .. value )
		CopyBaseProperty( TemplateSetEquip.ItemBG, CreateItemBG )
		CreateItemBG:SetPosX( 10 )
		CreateItemBG:SetPosY( startPosY )
		CreateItemBG:SetShow( false )
		tempSlot.ItemBG = CreateItemBG

		local CreateItemName = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, CreateItemBG, 'CashShop_SetEquip_ItemName_' .. value )
		CopyBaseProperty( TemplateSetEquip.ItemName, CreateItemName )
		CreateItemName:SetPosX( 0 )
		CreateItemName:SetPosY( 0 )
		CreateItemName:SetText( self.SetCharacterEquipName[value] )
		CreateItemName:SetShow( false )
		tempSlot.ItemName = CreateItemName

		local CreateBTN_UnSet = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, CreateItemBG, 'CashShop_SetEquip_UnSetBTN_' .. value )
		CopyBaseProperty( TemplateSetEquip.BTN_UnSet, CreateBTN_UnSet )
		CreateBTN_UnSet:SetPosX( CreateItemBG:GetSizeX() - CreateBTN_UnSet:GetSizeX() )
		CreateBTN_UnSet:SetPosY( 5 )
		CreateBTN_UnSet:SetShow( false )
		CreateBTN_UnSet:addInputEvent("Mouse_LUp", "HandleClicked_CashShopSetEquip_UnSetEquip(" .. value .. ")")
		tempSlot.BTN_UnSet = CreateBTN_UnSet

		startPosY				= startPosY + slotYGap
		sizeY					= sizeY + CreateItemBG:GetSizeY() + 2
		self.SlotUIPool[value]	= tempSlot
	end

	-- 사이즈/포지션 설정
	Panel_IngameCashShop_SetEquip:SetSize( Panel_IngameCashShop_SetEquip:GetSizeX(), sizeY + 85 )

	self.BTN_BuyAll:SetPosY( Panel_IngameCashShop_SetEquip:GetSizeY() - self.BTN_BuyAll:GetSizeY() - 7 )
	self.BTN_BuyAll:addInputEvent("Mouse_LUp", "HandleClicked_CashShopMoveCart()")

	cashShop_SetEquip_SetPosition()

	-- 일단 초기화
	getIngameCashMall():clearCart()
	-- getIngameCashMall():changeViewMyCharacter()
end

function CashShopSetEquip:Update()
	local nowClass = self.nowSetClass
	-- 슬롯 이름 초기화
	for index, value in pairs(self.SetEquipSlotNo) do
		local UiBase = self.SlotUIPool[value]
		local previewAvatar	= getIngameCashMall():getCashShopPreviewType()
		if UI_PreviewType.SelfPlayer == previewAvatar or UI_PreviewType.NormalPlayerCharacter == previewAvatar or UI_PreviewType.Others == previewAvatar then
			UiBase.ItemName:SetText( self.SetCharacterEquipName[value] )
		elseif UI_PreviewType.SelflVehicleCharacter == previewAvatar or UI_PreviewType.NormalVehicleCharacter == previewAvatar then
			if CppEnums.ServantKind.Type_Horse == self.hasServantType then
				UiBase.ItemName:SetText( self.SetHorseEquipName[value] )
			elseif CppEnums.ServantKind.Type_Ship == self.hasServantType then
				UiBase.ItemName:SetText( self.SetCarriageEquipName[value] )
			elseif CppEnums.ServantKind.Type_FourWheeledCarriage == self.hasServantType then
				UiBase.ItemName:SetText( self.SetCarriageEquipName[value] )
			end
		end
		UiBase.ItemName:SetFontColor( UI_color.C_FFFFFFFF )
	end

	local cartListCount = getIngameCashMall():getViewListCount()
	for equipItem_Idx = 0, cartListCount - 1 do
		local iGCSelectedItem	= getIngameCashMall():getViewItemByIndex( equipItem_Idx ) -- iGCSelectedItem = inGameCashShopSelectedItem
		local CPSSW				= iGCSelectedItem:getCashProductStaticStatus()
		local productNoRaw		= CPSSW:getNoRaw()
		local itemCount			= CPSSW:getInnerItemListCount()
		for itemIdx = 0, itemCount - 1 do
			local itemSSW		= CPSSW:getInnerItemByIndex( itemIdx )
			if itemSSW:isEquipable() then
				local equipSlotNo	= itemSSW:getEquipSlotNo()
				local UiBase		= self.SlotUIPool[equipSlotNo]
				local itemName		= itemSSW:getName()
				local itemGrade		= itemSSW:getGradeType()
				CashShopSetEquip:SetEquipSlot( equipSlotNo, itemName, itemGrade )
				UiBase.ItemName:addInputEvent("Mouse_On", "cashShop_SetEquip_ShowTooltip( true, " .. equipSlotNo .. " )")
				UiBase.ItemName:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
			end
		end
	end
end

function CashShopSetEquip:SetEquipSlot( equipSlotNo, itemName, itemGrade )
	local colorCode	= nil
	if ( 0 == itemGrade ) then
		colorCode = UI_color.C_FFFFFFFF
	elseif ( 1 == itemGrade ) then
		colorCode = 4284350320
	elseif ( 2 == itemGrade ) then
		colorCode = 4283144191
	elseif ( 3 == itemGrade ) then
		colorCode = 4294953010
	elseif ( 4 == itemGrade ) then
		colorCode = 4294929408
	else
		colorCode = UI_color.C_FFFFFFFF
	end
	self.SlotUIPool[equipSlotNo].ItemName:SetText( itemName )
	self.SlotUIPool[equipSlotNo].ItemName:SetFontColor( colorCode )
end
function cashShop_SetEquip_ShowTooltip( isshow, equipSlotNo )
	local self			= CashShopSetEquip
	local cartListCount = getIngameCashMall():getViewListCount()
	local UiBase		= self.SlotUIPool[equipSlotNo].ItemName
	for equipItem_Idx = 0, cartListCount - 1 do
		local iGCSelectedItem	= getIngameCashMall():getViewItemByIndex( equipItem_Idx ) -- iGCSelectedItem = inGameCashShopSelectedItem
		local CPSSW				= iGCSelectedItem:getCashProductStaticStatus()
		local productNoRaw		= CPSSW:getNoRaw()
		local itemCount			= CPSSW:getInnerItemListCount()
		for itemIdx = 0, itemCount - 1 do
			local itemSSW		= CPSSW:getInnerItemByIndex( itemIdx )
			if itemSSW:isEquipable() then
				local tempEquipSlotNo	= itemSSW:getEquipSlotNo()
				if equipSlotNo == tempEquipSlotNo then
					Panel_Tooltip_Item_Show( itemSSW, UiBase, true, false )
				end
			end
		end
	end
end
function CashShopSetEquip:Return_ServantType( itemSSW, servantType )
	-- servantType == CashShopSetEquip.serventType.horse, CashShopSetEquip.serventType.ship, CashShopSetEquip.serventType.Carriage
	local returnValue = nil
	if	CppEnums.ServantKind.Type_Ship == servantType then -- 배다
		returnValue = itemSSW:get():isServantTypeUsable( CppEnums.ServantKind.Type_Ship ) or itemSSW:get():isServantTypeUsable( CppEnums.ServantKind.Type_Raft )
	elseif	CppEnums.ServantKind.Type_FourWheeledCarriage == servantType then -- 마차다.
		returnValue = itemSSW:get():isServantTypeUsable( CppEnums.ServantKind.Type_TwoWheelCarriage ) or itemSSW:get():isServantTypeUsable( CppEnums.ServantKind.Type_FourWheeledCarriage )
	else
		returnValue = itemSSW:get():isServantTypeUsable( servantType )
	end
	return returnValue
end

function cashShop_SetEquip_SetPosition()
	local scrSizeX		= getScreenSizeX()
	local scrSizeY		= getScreenSizeY()
	local panelSizeX 	= Panel_IngameCashShop_SetEquip:GetSizeX()
	local panelSizeY 	= Panel_IngameCashShop_SetEquip:GetSizeY()

	Panel_IngameCashShop_SetEquip:SetPosX( scrSizeX - panelSizeX - 20 )
	Panel_IngameCashShop_SetEquip:SetPosY( scrSizeY - panelSizeY - 60 )
end

function HandleClicked_CashShopSetEquip_UnSetEquip( equipSlotNo )
	local self = CashShopSetEquip
	local productNoRaw = getIngameCashMall():getEquipCartItemByIndex( equipSlotNo )
	getIngameCashMall():popProductInEquipCart( productNoRaw )
	self:Update()
end

function HandleClicked_CashShopMoveCart()
	getIngameCashMall():insertToCartFromViewList()
	if( FGlobal_IsShow_IngameCashShop_NewCart() ) then
		FGlobal_Update_IngameCashShop_NewCart()
	else
		FGlobal_Open_IngameCashShop_NewCart()
	end
end

function FGlobal_CashShop_SetEquip_Update( productNoRaw )
	local self 		= CashShopSetEquip
	local myClass	= getSelfPlayer():getClassType()

	local CPSSW			= ToClient_GetCashProductStaticStatusWrapperByKeyRaw( productNoRaw )
	if nil == CPSSW then
		return
	end
	local itemCount		= CPSSW:getInnerItemListCount()
	local checkClass	= -1
	local itemType		= nil

	local listClass		= {}
	for classIdx = 0, getCharacterClassCount() -1 do
		local classType = getCharacterClassTypeByIndex( classIdx )
		listClass[classType] = true
	end

	local hasEquipment		= false
	local hasUsableServant	= false
	local hasUsableHorse	= false
	local hasUsableCarriage	= false
	local hasUsableBoat		= false
	local hasFishingBoat	= false
	local hasLantern		= false
	local hasCamel			= false

	for itemIdx = 0, itemCount - 1 do
		local itemSSW	= CPSSW:getInnerItemByIndex( itemIdx )
		itemType		= itemSSW:getItemType()
		if CppEnums.EquipSlotNo.lantern == itemSSW:getEquipSlotNo() then
			hasLantern = true
		elseif itemSSW:isUsableServant() then
			hasUsableServant = true
			if self:Return_ServantType( itemSSW, CppEnums.ServantKind.Type_Horse ) then
				hasUsableHorse = true
				self.hasServantType = CppEnums.ServantKind.Type_Horse
			elseif self:Return_ServantType( itemSSW, CppEnums.ServantKind.Type_Ship ) then	-- 나룻배
				hasUsableBoat = true
				self.hasServantType = CppEnums.ServantKind.Type_Ship
			elseif self:Return_ServantType( itemSSW, CppEnums.ServantKind.Type_FishingBoat ) then	-- 어선
				hasFishingBoat = true
				self.hasServantType = CppEnums.ServantKind.Type_FishingBoat
			elseif self:Return_ServantType( itemSSW, CppEnums.ServantKind.Type_FourWheeledCarriage )then	-- 마차
				hasUsableCarriage = true
				self.hasServantType = CppEnums.ServantKind.Type_FourWheeledCarriage
			elseif self:Return_ServantType( itemSSW, CppEnums.ServantKind.Type_Camel )then	-- 낙타
				hasCamel = true
				self.hasServantType = CppEnums.ServantKind.Type_Camel
			end
		elseif itemSSW:isEquipable() then
			hasEquipment = true
			for classType, _ in pairs( listClass ) do
				if ( false == itemSSW:get()._usableClassType:isOn( classType ) ) then
					listClass[classType] = nil
				end
			end
		else
			-- 아바타 변경이 없는 상품이다.
		end
	end

	if ( true == listClass[myClass] ) then
		checkClass = myClass
	else
		for key, _ in pairs( listClass ) do
			checkClass = key
			break
		end
	end

		-- 슬롯 이름 초기화
	for index, value in pairs(self.SetEquipSlotNo) do
		self.SlotUIPool[value].ItemName:SetText( self.SetCharacterEquipName[value] )
		self.SlotUIPool[value].ItemName:SetFontColor( UI_color.C_FFFFFFFF )
	end

	-- 상품의 아이템이 어떤 클래스용인가?
	if not (true == hasEquipment and ( false == hasLantern )) and true == hasUsableServant then
		self.beforSetClass	= self.nowSetClass
		self.nowSetClass	= checkClass

		-- servantKey 가 못차는 장비를 빼준다.
		local cartProductKeyList = Array.new()
		local cartListCount = getIngameCashMall():getViewListCount()
		for equipItem_Idx = 0, cartListCount - 1 do
			local iGCSelectedItem	= getIngameCashMall():getViewItemByIndex( equipItem_Idx )
			local CPSSW				= iGCSelectedItem:getCashProductStaticStatus()
			cartProductKeyList:push_back(CPSSW:getNoRaw())
		end
		for key, noRaw in pairs(cartProductKeyList) do
			local CPSSW 		= ToClient_GetCashProductStaticStatusWrapperByKeyRaw(noRaw)
			local itemCount		= CPSSW:getInnerItemListCount()
			for itemIdx = 0, itemCount - 1 do
				local itemSSW = CPSSW:getInnerItemByIndex( itemIdx )
				if ( false == self:Return_ServantType( itemSSW, self.hasServantType ) ) then
					getIngameCashMall():popProductInEquipCart( noRaw )
					break
				end
			end
		end

		self.nowSetClass	= -1

		local characterKeyRaw = getIngameCashMall():getDelegateServantKey( self.hasServantType )
		CashShopController_ForceOffAllButton()
		getIngameCashMall():changeViewVehicleCharacter( characterKeyRaw )
		getIngameCashMall():pushProductInEquipCart( productNoRaw )
	elseif true == hasEquipment and ( false == hasLantern ) then
		self.beforSetClass	= self.nowSetClass
		self.nowSetClass	= checkClass

		if self.beforSetClass == self.nowSetClass then
			-- 그대로 쓴다.
		else
			-- 여기서 뺀다.
			local cartProductKeyList = Array.new()
			local cartListCount = getIngameCashMall():getViewListCount()
			for equipItem_Idx = 0, cartListCount - 1 do
				local iGCSelectedItem	= getIngameCashMall():getViewItemByIndex( equipItem_Idx )
				local CPSSW				= iGCSelectedItem:getCashProductStaticStatus()
				cartProductKeyList:push_back(CPSSW:getNoRaw())
			end

			for key, noRaw in pairs(cartProductKeyList) do
				local CPSSW 		= ToClient_GetCashProductStaticStatusWrapperByKeyRaw(noRaw)
				local itemCount		= CPSSW:getInnerItemListCount()
				for itemIdx = 0, itemCount - 1 do
					local itemSSW = CPSSW:getInnerItemByIndex( itemIdx )
					if itemSSW:isEquipable() then
						if ( false == itemSSW:get()._usableClassType:isOn( self.nowSetClass ) ) then
							getIngameCashMall():popProductInEquipCart( noRaw )
							break
						end
					end
				end
			end

			if myClass == self.nowSetClass then
				getIngameCashMall():changeViewMyCharacter()
			--속옷->마네킹 모드로 바뀔때 풀어줄것
			--elseif (CashSHop_IsUnderWearItem(productNoRaw)) then
			--	CashShopController_ForceOffAllButton()
			--	getIngameCashMall():changeViewCharacter( productNoRaw )
			else
				local characterSSW		= getCharacterStaticStatusWrapperByClassType( self.nowSetClass )
				local characterKeyRaw	= characterSSW:getCharacterKey()
				getIngameCashMall():changeViewPlayerCharacter( characterKeyRaw )
			end
		end

		-- 속옷인 경우에 속옷 보기 버튼을 활성화 한다. 
		--속옷->마네킹 모드로 바뀔때 주석처리할것
		CashShop_SetEquip_AutoUnderWearShow( productNoRaw )
		-- 귀걸이나 피어싱의 경우 잘보이게 하기위해 올림머리로 해준다.
		CashShop_SetEquip_AutoUpHair( productNoRaw )

		getIngameCashMall():pushProductInEquipCart( productNoRaw )
	else
		-- 모든아이템을 보여줄것이기때문에 타입은 무시합니다.
		-- 4 == 설치도구, 7 == 등록증
		--if itemType == 4 or itemType == 7 then
			-- 슬롯 이름 초기화
			self.nowSetClass	= -1
			CashShopController_ForceOffAllButton()
			getIngameCashMall():changeViewCharacter( productNoRaw )
		--end
	end
	-- self:Update()
end
function CashSHop_IsUnderWearItem( productNoRaw )
	local CPSSW			= ToClient_GetCashProductStaticStatusWrapperByKeyRaw( productNoRaw )
	-- 속옷인 경우에 속옷 보기 버튼을 활성화 한다.
	local count		= CPSSW:getInnerItemListCount()
	for key = 0 , count - 1 do
		local itemSSW	= CPSSW:getInnerItemByIndex( 0 )
		local itemType	= itemSSW:getEquipSlotNo()
		if ( CppEnums.EquipSlotNo.avatarUnderWear == itemType ) then
			return true
		end
	end

	return false
end
function CashShop_SetEquip_AutoUnderWearShow( productNoRaw )
	if CashSHop_IsUnderWearItem(productNoRaw) then
		HandleClicked_CashShopController_AutoToggleUnderWear()
	else
		HandleClicked_CashShopController_AutoToggleOffAll()
	end
end
function CashShop_SetEquip_AutoUpHair( productNoRaw )
	local CPSSW			= ToClient_GetCashProductStaticStatusWrapperByKeyRaw( productNoRaw )
	-- 올림머리인 경우에 버튼을 활성화 한다.
	local count		= CPSSW:getInnerItemListCount()
	local isUpHairMode = false
	for key = 0 , count - 1 do
		local itemSSW	= CPSSW:getInnerItemByIndex( key )
		local itemType	= itemSSW:getEquipSlotNo()

		if ( 
			CppEnums.EquipSlotNo.faceDecoration1 == itemType or
			CppEnums.EquipSlotNo.faceDecoration2 == itemType or
			CppEnums.EquipSlotNo.faceDecoration3 == itemType ) then
			isUpHairMode = true
			break
		end
	end
--	_PA_LOG("LUA", "isUpHairMode : " .. tostring(isUpHairMode) )
--	HandleClicked_CashShopController_AutoToggleUpHair(isUpHairMode)

	CashShopController_HideHairBtnCheck( isUpHairMode )
end

function FGlobal_CashShop_SetEquip_Open()
	local self = CashShopSetEquip
	cashShop_SetEquip_SetPosition()
	self:Update()
	Panel_IngameCashShop_SetEquip:SetShow( true )
	self.nowSetClass = -1
end
function FGlobal_CashShop_SetEquip_Close()
	cashShop_SetEquip_Close()
end
function cashShop_SetEquip_Close()
	Panel_IngameCashShop_SetEquip:SetShow( false )
end
function HandleClicked_CashShop_Close()
	InGameShop_Close()
end
function HandleClicked_QNAWebLink_Open()
	FGlobal_QnAWebLink_Open()
end

function FromClient_CashShopSetEquip_Resize()
	cashShop_SetEquip_SetPosition()
end

function CashShopSetEquip:registEventHandler()
	self.BTN_Exit	:addInputEvent("Mouse_LUp",			"HandleClicked_CashShop_Close()")
	self.BTN_QNA	:addInputEvent("Mouse_LUp",			"HandleClicked_QNAWebLink_Open()")
	
	registerEvent( "onScreenResize", "FromClient_CashShopSetEquip_Resize" )
end

CashShopSetEquip:Initialize()
CashShopSetEquip:registEventHandler()



--------------------------------------------------------------------------------
-- 캐릭터 컨트롤러 시작
--------------------------------------------------------------------------------

Panel_IngameCashShop_Controller:SetShow( false )
Panel_CustomizationMessage:SetShow( false, false )
Panel_CustomizationMessage:SetIgnore( true )

local CashShopController = {
	-- tempBG			= UI.getChildControl( Panel_IngameCashShop_Controller, "Static_BG"),
	-- SliderName		= UI.getChildControl( Panel_IngameCashShop_Controller, "StaticText_SliderTitle"),
	GameTime_Slider		= UI.getChildControl( Panel_IngameCashShop_Controller, "Slider_GameTime"),
	BTN_Light			= UI.getChildControl( Panel_IngameCashShop_Controller, "CheckButton_Light"),
	BTN_EyeSee			= UI.getChildControl( Panel_IngameCashShop_Controller, "CheckButton_EyeSee"),
	BTN_ShowUI			= UI.getChildControl( Panel_IngameCashShop_Controller, "CheckButton_ShowUI"),
	SunIcon				= UI.getChildControl( Panel_IngameCashShop_Controller, "Button_Sun"),
	MoonIcon			= UI.getChildControl( Panel_IngameCashShop_Controller, "Button_Moon"),

	--{ 날씨 구분 아이콘 6개
	SunShine1			= UI.getChildControl( Panel_IngameCashShop_Controller, "Button_SunShine1"),
	SunShine2			= UI.getChildControl( Panel_IngameCashShop_Controller, "Button_SunShine2"),
	SunShine3			= UI.getChildControl( Panel_IngameCashShop_Controller, "Button_SunShine3"),
	SunShine4			= UI.getChildControl( Panel_IngameCashShop_Controller, "Button_SunShine4"),
	SunShine5			= UI.getChildControl( Panel_IngameCashShop_Controller, "Button_SunShine5"),
	SunShine6			= UI.getChildControl( Panel_IngameCashShop_Controller, "Button_SunShine6"),
	--}

	ChaCTR_Area			= UI.getChildControl( Panel_IngameCashShop_Controller, "Static_CharacterController"),
	RotateArrow_L		= UI.getChildControl( Panel_IngameCashShop_Controller, "Static_Left_RotateArrow"),
	RotateArrow_R		= UI.getChildControl( Panel_IngameCashShop_Controller, "Static_Right_RotateArrow"),

	static_SetOptionBG	= UI.getChildControl( Panel_IngameCashShop_Controller, "Static_SetOptionBG"),
	txt_Endurance		= UI.getChildControl( Panel_IngameCashShop_Controller, "StaticText_Endurance"),
	Slider_Endurance	= UI.getChildControl( Panel_IngameCashShop_Controller, "Slider_Endurance"),
	btn_ShowUnderwear	= UI.getChildControl( Panel_IngameCashShop_Controller, "CheckButton_ShowUnderWear"),
	btn_HideAvatar		= UI.getChildControl( Panel_IngameCashShop_Controller, "CheckButton_HideAvatar"),
	btn_HideHair		= UI.getChildControl( Panel_IngameCashShop_Controller, "CheckButton_HideHair"),
	btn_HideHelm		= UI.getChildControl( Panel_IngameCashShop_Controller, "CheckButton_HideHelm"),		-- 투구 선언
	btn_AwakenWeapon	= UI.getChildControl( Panel_IngameCashShop_Controller, "CheckButton_AwakenWeapon"),	-- 각성 무기 선언
	btn_WarStance		= UI.getChildControl( Panel_IngameCashShop_Controller, "CheckButton_WarStance"),	-- 전투 자세 선언

	btn_AllDoff			= UI.getChildControl( Panel_IngameCashShop_Controller, "Button_AllDoff"),

	isLdown			= false,
	isRdown			= false,
	lMovePos		= 0,
	yMovePos		= 0,
	isShowUI		= true,
	xStartPos		= 0,
	yStartPos		= 0,
}

CashShopController.btn_AwakenWeapon:SetShow( awakenWeaponContentsOpen )

CashShopController.GameTime_SliderCtrlBTN	= UI.getChildControl( CashShopController.GameTime_Slider, "Slider_GameTime_Button")
CashShopController.Slider_EnduranceCtrlBTN	= CashShopController.Slider_Endurance:GetControlButton()
local StaticText_CustomizationMessage = UI.getChildControl( Panel_CustomizationMessage, "StaticText_CustomizationMessage" )

-- 12:03 유병화 setAwakenWeaponView
-- 12:03 유병화 getAwakenWeaponView

function CashShopController:Initialize()
	self.GameTime_Slider	:SetInterval( 23 )
	self.Slider_Endurance	:SetInterval( 100 )

	self.static_SetOptionBG			:AddChild( self.txt_Endurance )
	self.static_SetOptionBG			:AddChild( self.btn_ShowUnderwear )
	self.static_SetOptionBG			:AddChild( self.btn_HideAvatar )
	self.static_SetOptionBG			:AddChild( self.Slider_Endurance )
	self.static_SetOptionBG			:AddChild( self.btn_HideHair )
	self.static_SetOptionBG			:AddChild( self.btn_HideHelm )
	self.static_SetOptionBG			:AddChild( self.btn_AwakenWeapon )
	self.static_SetOptionBG			:AddChild( self.btn_WarStance )
	self.static_SetOptionBG			:AddChild( self.btn_AllDoff )

	Panel_IngameCashShop_Controller	:RemoveControl( self.txt_Endurance )
	Panel_IngameCashShop_Controller	:RemoveControl( self.btn_ShowUnderwear )
	Panel_IngameCashShop_Controller	:RemoveControl( self.btn_HideAvatar )
	Panel_IngameCashShop_Controller	:RemoveControl( self.Slider_Endurance )
	Panel_IngameCashShop_Controller	:RemoveControl( self.btn_HideHair )
	Panel_IngameCashShop_Controller	:RemoveControl( self.btn_HideHelm )
	Panel_IngameCashShop_Controller	:RemoveControl( self.btn_AwakenWeapon )
	Panel_IngameCashShop_Controller	:RemoveControl( self.btn_WarStance )
	Panel_IngameCashShop_Controller	:RemoveControl( self.btn_AllDoff )

	self.txt_Endurance				:SetPosX(5)
	self.txt_Endurance				:SetPosY(10)
	self.Slider_Endurance			:SetPosX(self.txt_Endurance:GetPosX() + self.txt_Endurance:GetSizeX() +3 )
	self.Slider_Endurance			:SetPosY(17)
	self.btn_AllDoff				:SetPosX( self.Slider_Endurance:GetPosX() - 57 )
	self.btn_AllDoff				:SetPosY(45)
	self.btn_ShowUnderwear			:SetPosX(self.btn_AllDoff:GetPosX() + self.btn_AllDoff:GetSizeX() -1)
	self.btn_ShowUnderwear			:SetPosY(45)
	self.btn_HideAvatar				:SetPosX(self.btn_ShowUnderwear:GetPosX() + self.btn_ShowUnderwear:GetSizeX() -1 )
	self.btn_HideAvatar				:SetPosY(45)
	self.btn_HideHair				:SetPosX(self.btn_HideAvatar:GetPosX() + self.btn_HideAvatar:GetSizeX() -1 )
	self.btn_HideHair				:SetPosY(45)
	self.btn_HideHelm				:SetPosX(self.btn_HideHair:GetPosX() + self.btn_HideHair:GetSizeX() -1 )		-- 투구 포지션
	self.btn_HideHelm				:SetPosY(45)
	self.btn_AwakenWeapon			:SetPosX(self.btn_HideHelm:GetPosX() + self.btn_HideHelm:GetSizeX() -1 )		-- 각성무기 포지션
	self.btn_AwakenWeapon			:SetPosY(45)
	self.btn_WarStance				:SetPosX(self.btn_AwakenWeapon:GetPosX() + self.btn_AwakenWeapon:GetSizeX() -1 )-- 전투태세 포지션
	self.btn_WarStance				:SetPosY(45)

	------- 임시로 꺼줬다.
	self.GameTime_Slider:SetShow( false )
	self.BTN_Light:SetShow( false )
	self.SunIcon:SetShow( true ) -- 임시로 껐지만 이건 킨다.(사용할거니까...)
	self.MoonIcon:SetShow( false )
	------- 임시로 꺼줬음.

	self.ChaCTR_Area:AddChild( self.RotateArrow_L )
	self.ChaCTR_Area:AddChild( self.RotateArrow_R )
	Panel_IngameCashShop_Controller:RemoveControl( self.RotateArrow_L )
	Panel_IngameCashShop_Controller:RemoveControl( self.RotateArrow_R )
end
function CashShopController:Open()
	local nowTime		= getIngameCashMall():getWeatherTime()
	getIngameCashMall():setWeatherTime(6, nowTime)
	local controlPos	= 100 / 24 * nowTime
	self.GameTime_Slider:SetControlPos( controlPos )
	
	local isLightOn = getIngameCashMall():getLight()
	self.BTN_Light:SetCheck( isLightOn )

	local isCharacterViewCamera = getIngameCashMall():getCharacterViewCamera()
	self.BTN_EyeSee:SetCheck( isCharacterViewCamera )

	local endurancePercents = getIngameCashMall():getEquipmentEndurancePercents()
	self.Slider_Endurance:SetControlPos( endurancePercents * 100 )

	local isShowUnderwear = getIngameCashMall():getIsShowUnderwear()
	self.btn_ShowUnderwear:SetCheck( isShowUnderwear )

	local isShowWithoutAvatar = getIngameCashMall():getIsShowWithoutAvatar()
	self.btn_HideAvatar:SetCheck( isShowWithoutAvatar )

	local isFaceVisibleHair = getIngameCashMall():getFaceVisibleHair()
	self.btn_HideHair:SetCheck( isFaceVisibleHair )

	local isAwakenWeapon	= getIngameCashMall():getAwakenWeaponView()
	self.btn_AwakenWeapon:SetCheck( isAwakenWeapon )

	local isWarStance	= getIngameCashMall():getBattleView()
	self.btn_WarStance:SetCheck( isWarStance )
	

	-- local isFaceVisibleHelm = getIngameCashMall():getFaceVisibleHair()	-- 투구 클라 저장 값.
	-- self.btn_HideHelm:SetCheck( isFaceVisibleHelm )
	
	-- 내 캐릭터 세팅
	Panel_IngameCashShop_Controller:SetShow( true )
	Panel_CustomizationMessage:SetShow( true, false )
	
	local message = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_CONTROLLER_MSG") -- "기본 조작 : 마우스 좌 클릭( 카메라 위치 이동 ), 마우스 우 클릭( 캐릭터 회전 ), 마우스 스크롤( 줌 인/아웃 )"
	StaticText_CustomizationMessage:SetText(message)
	StaticText_CustomizationMessage:SetSize( (StaticText_CustomizationMessage:GetTextSizeX() + 10 ) + StaticText_CustomizationMessage:GetSpanSize().x, 25 )
	StaticText_CustomizationMessage:SetSpanSize( 0, 0 )
	StaticText_CustomizationMessage:SetShow(true)
	StaticText_CustomizationMessage:SetIgnore( true )

	self.isShowUI = true
	self:ResetViewCharacterPosition()
	self.BTN_ShowUI:SetCheck( false )
	self:SetPosition()
end
function CashShopController:Close()
	Panel_IngameCashShop_Controller:SetShow( false )
	Panel_CustomizationMessage:SetShow( false, false )
	self.SunShine1:SetShow( false )
	self.SunShine2:SetShow( false )
	self.SunShine3:SetShow( false )
	self.SunShine4:SetShow( false )
	self.SunShine5:SetShow( false )
	self.SunShine6:SetShow( false )
end
function CashShopController:SetPosition()
	local scrSizeX		= getScreenSizeX()
	local scrSizeY		= getScreenSizeY()
	local panelSizeX 	= Panel_IngameCashShop_Controller:GetSizeX()
	local panelSizeY 	= Panel_IngameCashShop_Controller:GetSizeY()

	local ControllerSizeX = nil
	local ControllerSizeY = nil
	local ControllerPosX = nil
	local ControllerPosY = nil

	if self.BTN_ShowUI:IsCheck() then
		ControllerSizeX	= scrSizeX
		ControllerSizeY	= scrSizeY
		ControllerPosX	= 0
		ControllerPosY	= 0
	else
		ControllerSizeX	= scrSizeX - (Panel_IngameCashShop:GetPosX() + Panel_IngameCashShop:GetSizeX() + 130)
		ControllerSizeY	= scrSizeY
		ControllerPosX	= Panel_IngameCashShop:GetPosX() + Panel_IngameCashShop:GetSizeX() + 130
		ControllerPosY	= 0
	end

	Panel_IngameCashShop_Controller:SetSize( ControllerSizeX, ControllerSizeY )
	Panel_IngameCashShop_Controller:SetPosX( ControllerPosX )
	Panel_IngameCashShop_Controller:SetPosY( ControllerPosY )

	self.ChaCTR_Area				:SetSize( ControllerSizeX - 10, ControllerSizeY - 10 )
	self.ChaCTR_Area				:SetPosX( 10 )
	self.ChaCTR_Area				:SetPosY( 10 )

	self.SunIcon			:SetSpanSize( 110, 38 )
	self.SunShine1			:SetSpanSize( 250, 88 )
	self.SunShine2			:SetSpanSize( 200, 88 )
	self.SunShine3			:SetSpanSize( 150, 88 )
	self.SunShine4			:SetSpanSize( 100, 88 )
	self.SunShine5			:SetSpanSize( 50, 88 )
	self.SunShine6			:SetSpanSize( 0, 88 )

	self.static_SetOptionBG	:ComputePos()
	self.GameTime_Slider	:ComputePos()
	self.BTN_Light			:ComputePos()
	self.BTN_EyeSee			:ComputePos()
	self.BTN_ShowUI			:ComputePos()
	self.SunIcon			:ComputePos()
	self.MoonIcon			:ComputePos()
	self.SunShine1			:ComputePos()
	self.SunShine2			:ComputePos()
	self.SunShine3			:ComputePos()
	self.SunShine4			:ComputePos()
	self.SunShine5			:ComputePos()
	self.SunShine6			:ComputePos()

	CashShopController:ResetViewCharacterPosition()
end
function CashShopController:ResetViewCharacterPosition()
	if ( self.isShowUI ) then
		local leftWindowSize = Panel_IngameCashShop:GetSizeX()
		local screenSize = getScreenSizeX()
		
		getIngameCashMall():setCreatePosition((screenSize + leftWindowSize) / 2 / screenSize, 0.5, 320.0)
	else
		getIngameCashMall():setCreatePosition(0.5, 0.5, 320.0)
	end
end

--------------------------------------------------------------------------------
function HandleClicked_CashShopController_SetTime()
	local self		= CashShopController
	local ttIndex	= self.GameTime_Slider:GetSelectIndex()
	getIngameCashMall():setWeatherTime(6, ttIndex)
end
function HandleClicked_CashShopController_SetLight()
	local self = CashShopController
	-- local isLightOn = getIngameCashMall():getLight()
	if not self.BTN_Light:IsCheck() then
		-- UI.debugMessage( "라이트를 끈다." )
		getIngameCashMall():setLight( false )
	else
		-- UI.debugMessage( "라이트를 켠다." )
		getIngameCashMall():setLight( true )
	end
end

function HandleClicked_CashShopController_SetCharacterViewCamera()
	local self = CashShopController
	getIngameCashMall():setCharacterViewCamera( self.BTN_EyeSee:IsCheck() )
end

function HandleClicked_CashShopController_SetShowUIToggle()
	local self = CashShopController
	if true == self.isShowUI then
		Panel_IngameCashShop:SetShow( false )
		Panel_IngameCashShop_SetEquip:SetShow( false )
		FGlobal_Close_IngameCashShop_NewCart()
		if Panel_IngameCashShop_GoodsDetailInfo:GetShow() then
			InGameShopDetailInfo_Close()
		end
		self.isShowUI = false
	else
		Panel_IngameCashShop:SetShow( true )
		Panel_IngameCashShop_SetEquip:SetShow( true )
		InGameShop_ReShowByHideUI()
		self.isShowUI = true
	end
	self:ResetViewCharacterPosition()
	self:SetPosition()
end
function HandleClicked_CashShopController_SetCharacterRotate_Start(isLDown)
	local self = CashShopController
	if ( isLDown ) then
		self.isLdown = true
	else
		self.isRdown = true
	end
	self.lMovePos = getMousePosX()
	self.yMovePos = getMousePosY()

	self.xStartPos = getMousePosX()
	self.yStartPos = getMousePosY()
	-- UI.debugMessage("영역에서 눌렀다.")
end
function HandleClicked_CashShopController_SetCharacterRotate_End(isLDown)
	local self = CashShopController
	if ( nil == isLDown ) then
		self.isLdown = false
		self.isRdown = false
	elseif ( isLDown ) then
		if ( math.abs(self.xStartPos - getMousePosX()) + math.abs(self.yStartPos - getMousePosY()) < 20 ) then
			local randValue = math.random(0, getIngameCashMall():getCharacterActionCount()-1)
			getIngameCashMall():setCharacterActionKey( randValue )
		end
		
		self.isLdown = false
	else
		self.isRdown = false
	end
	-- UI.debugMessage("영역에서 떼었다.")
end
function HandleClicked_CashShopController_SetCharacterScroll( isUp )
	local upValue = 25;
	if ( true == isUp ) then
		upValue = -upValue
	end
	getIngameCashMall():varyCameraZoom( upValue )
end

function HandleClicked_CashShopController_UpdateEndurance()
	local self		= CashShopController
	local ttIndex	= self.Slider_Endurance:GetSelectIndex()
	getIngameCashMall():setEquipmentEndurancePercents( ttIndex / 100 )
end

function HandleClicked_CashShopController_OffAllEquip()
	getIngameCashMall():clearEquipViewList()
end

function HandleClicked_CashShopController_ToggleUnderWear()
	local self = CashShopController
	local isChecked = self.btn_ShowUnderwear:IsCheck()
	getIngameCashMall():setIsShowUnderwear( isChecked )
	if ( isChecked ) then
		self.btn_HideAvatar:SetCheck( false )
	end
end

function HandleClicked_CashShopController_ToggleAvatar()
	local self = CashShopController
	local isChecked = self.btn_HideAvatar:IsCheck()
	getIngameCashMall():setIsShowWithoutAvatar( isChecked )
	if ( isChecked ) then
		self.btn_ShowUnderwear:SetCheck( false )
	end
end

function HandleClicked_CashShopController_ToggleHideHair()
	local self = CashShopController
	local isChecked = self.btn_HideHair:IsCheck()
	if isChecked then
		self.btn_HideHair:EraseAllEffect()
	end
	getIngameCashMall():setFaceVisibleHair( isChecked )
end

function CashShopController_HideHairBtnCheck( isUpHairMode )
	local self = CashShopController
	if isUpHairMode then -- 올림머리 아이템이냐.
		if (not self.btn_HideHair:IsCheck()) then
			self.btn_HideHair:EraseAllEffect()
			self.btn_HideHair:AddEffect( "UI_CashShop_HairChange", true, 0, 0 )
		elseif (self.btn_HideHair:IsCheck()) then
			self.btn_HideHair:EraseAllEffect()
		end
	else
		self.btn_HideHair:EraseAllEffect()
	end
end

function HandleClicked_CashShopController_ToggleHideHelm()	-- 투구 버튼 클릭
	local self = CashShopController
	local isChecked = self.btn_HideHelm:IsCheck()
	getIngameCashMall():setIsShowWithoutHelmet( isChecked )
end

function HandleClicked_CashShopController_ToggleAwakenWeapon()	-- 각성 무기 토글
	local isChecked = CashShopController.btn_AwakenWeapon:IsCheck()
	getIngameCashMall():setAwakenWeaponView( isChecked )
end

function HandleClicked_CashShopController_ToggleWarStance()		-- 전투태세 토글
	local isChecked = CashShopController.btn_WarStance:IsCheck()
	getIngameCashMall():setBattleView( isChecked )
end

function HandleClicked_CashShopController_AutoToggleUnderWear()
	local self = CashShopController
	self.btn_ShowUnderwear:SetCheck( true )
	self.btn_HideAvatar:SetCheck( false )
	getIngameCashMall():setIsShowUnderwear( true )
end

function HandleClicked_CashShopController_AutoToggleOffAll()
	local self = CashShopController
	self.btn_ShowUnderwear:SetCheck( false )
	self.btn_HideAvatar:SetCheck( false )
	getIngameCashMall():setIsShowUnderwear( false )
	getIngameCashMall():setIsShowWithoutAvatar( false )
end

function HandleClicked_CashShopController_AutoToggleUpHair( isUpHairMode )
	local self = CashShopController
	self.btn_HideHair:SetCheck( isUpHairMode )
	getIngameCashMall():setFaceVisibleHair( isUpHairMode )
end

function CashShopController_ForceOffAllButton()
	local self = CashShopController
	if ( self.btn_HideHelm:IsCheck() ) then
		self.btn_HideHelm:SetCheck( false )
		getIngameCashMall():setIsShowWithoutHelmet( false )
	end
	if ( self.btn_AwakenWeapon:IsCheck() ) then
		self.btn_AwakenWeapon:SetCheck( false )
		getIngameCashMall():setAwakenWeaponView( false )
	end
	if ( self.btn_WarStance:IsCheck() ) then
		self.btn_WarStance:SetCheck( false )
		getIngameCashMall():setBattleView( false )
	end
	if ( self.btn_ShowUnderwear:IsCheck() ) then
		self.btn_ShowUnderwear:SetCheck( false )
		getIngameCashMall():setIsShowUnderwear( false )
	end

	if ( self.btn_HideAvatar:IsCheck() ) then
		self.btn_HideAvatar:SetCheck( false )
		getIngameCashMall():setIsShowWithoutAvatar( false )
	end

	if ( self.btn_HideHair:IsCheck() ) then
		self.btn_HideHair:SetCheck( false )
		getIngameCashMall():setFaceVisibleHair( false )
	end
end
--------------------------------------------------------------------------------
function cashShop_Controller_UpdateCharacterRotate( deltatime )
	local self = CashShopController
	if ( false == self.isLdown ) and ( false == self.isRdown ) then
		return
	end
	local currPos = getMousePosX()
	local currPosY = getMousePosY()
	if ( currPos == self.lMovePos ) and ( currPosY == self.yMovePos ) then
		return
	end

	local radianAngle = ( self.lMovePos - currPos ) / (getScreenSizeX()/10)
	local cameraPitch = ( currPosY - self.yMovePos ) / (getScreenSizeY()/2)

	self.lMovePos = currPos
	self.yMovePos = currPosY

	if ( self.isLdown ) then
		getIngameCashMall():varyCameraPositionByUpAndRightVector( radianAngle * 30, cameraPitch * 90 )
	end

	if ( self.isRdown ) then
		getIngameCashMall():rotateViewCharacter( radianAngle )
		getIngameCashMall():varyCameraPitch( -(cameraPitch) / 1.5 )
	end
end

function cashShop_Controller_Open()
	CashShopController:Open()
end
function cashShop_Controller_Close()
	CashShopController:Close()
end
function _cashShopController_ButtonTooltip( isShow, buttonType )
	local self		= CashShopController
	local uiControl, name, desc = nil, nil, nil
	if buttonType == 0 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_SHOWUNDERWEAR") -- "속옷보기"
		uiControl = self.btn_ShowUnderwear
	elseif buttonType == 1 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HIDEAVATAR") -- "의상 숨기기"
		uiControl = self.btn_HideAvatar
	elseif buttonType == 2 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HIDHAIR") -- "올림 머리로 보기"
		uiControl = self.btn_HideHair
	elseif buttonType == 3 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_ALLDOFF") -- "착용중인 의상 벗기"
		uiControl = self.btn_AllDoff
	elseif buttonType == 4 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_EYESEE") -- "플레이어 바라보기"
		uiControl = self.BTN_EyeSee
	elseif buttonType == 5 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_SHOWUI") -- "UI 끄기/켜기"
		uiControl = self.BTN_ShowUI
	elseif buttonType == 6 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HIDEHELM") -- "투구 감추기"
		uiControl = self.btn_HideHelm
	elseif buttonType == 7 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_SUNICON") -- 날씨 선택하기
		uiControl = self.SunIcon
	elseif buttonType == 8 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_AWAKENWEAPON") -- "각성 무기 보이기" 
		uiControl = self.btn_AwakenWeapon
	elseif buttonType == 9 then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_TOOLTIP_WARSTANCE") -- "각성 무기 보이기" 
		uiControl = self.btn_WarStance
	end

	if isShow == true then
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end
end
function FromClient_CashShopController_Resize()
	CashShopController:SetPosition()
end
function FromClient_ChangeAwakenWeapon( isAwakenWeaponView )
	CashShopController.btn_AwakenWeapon:SetCheck( isAwakenWeaponView )
end
function FromClient_ChangeCashshopBattle( isBattle )
	CashShopController.btn_WarStance:SetCheck( isBattle )
end

function HandleClicked_SunShineToggle()
	local self = CashShopController

	local sunShineCheck = self.SunIcon:IsCheck()

	self.SunShine1:SetShow( sunShineCheck )
	self.SunShine2:SetShow( sunShineCheck )
	self.SunShine3:SetShow( sunShineCheck )
	self.SunShine4:SetShow( sunShineCheck )
	self.SunShine5:SetShow( sunShineCheck )
	self.SunShine6:SetShow( sunShineCheck )
end

function HandleClicked_SunShineSetting( weatherType )
	if 1 == weatherType then
		weatherIndex = 0
	elseif 2 == weatherType then
		weatherIndex = 3
	elseif 3 == weatherType then
		weatherIndex = 7
	elseif 4 == weatherType then
		weatherIndex = 11
	elseif 5 == weatherType then
		weatherIndex = 15
	elseif 6 == weatherType then
		weatherIndex = 19
	end

	getIngameCashMall():setWeatherTime(6, weatherIndex )

end

function CashShopController:registEventHandler()
	self.GameTime_Slider		:addInputEvent("Mouse_LUp",			"HandleClicked_CashShopController_SetTime()")
	self.GameTime_SliderCtrlBTN	:addInputEvent("Mouse_LUp",			"HandleClicked_CashShopController_SetTime()")
	self.GameTime_SliderCtrlBTN	:addInputEvent("Mouse_LPress",		"HandleClicked_CashShopController_SetTime()")
	self.BTN_Light				:addInputEvent("Mouse_LUp",			"HandleClicked_CashShopController_SetLight()")
	self.BTN_EyeSee				:addInputEvent("Mouse_LUp",			"HandleClicked_CashShopController_SetCharacterViewCamera()")
	self.BTN_ShowUI				:addInputEvent("Mouse_LUp",			"HandleClicked_CashShopController_SetShowUIToggle()")

	self.ChaCTR_Area			:addInputEvent("Mouse_LDown",		"HandleClicked_CashShopController_SetCharacterRotate_Start(true)")
	self.ChaCTR_Area			:addInputEvent("Mouse_LUp",			"HandleClicked_CashShopController_SetCharacterRotate_End(true)")
	self.ChaCTR_Area			:addInputEvent("Mouse_Out",			"HandleClicked_CashShopController_SetCharacterRotate_End()")

	self.ChaCTR_Area			:addInputEvent("Mouse_RDown",		"HandleClicked_CashShopController_SetCharacterRotate_Start(false)")
	self.ChaCTR_Area			:addInputEvent("Mouse_RUp",			"HandleClicked_CashShopController_SetCharacterRotate_End(false)")
	self.ChaCTR_Area			:addInputEvent("Mouse_UpScroll",	"HandleClicked_CashShopController_SetCharacterScroll(true)")
	self.ChaCTR_Area			:addInputEvent("Mouse_DownScroll",	"HandleClicked_CashShopController_SetCharacterScroll(false)")

	self.Slider_Endurance		:addInputEvent("Mouse_LPress",		"HandleClicked_CashShopController_UpdateEndurance()")
	self.Slider_EnduranceCtrlBTN:addInputEvent("Mouse_LPress",		"HandleClicked_CashShopController_UpdateEndurance()")
	--self.Slider_EnduranceCtrlBTN:addInputEvent("Mouse_LPress",		"HandleClicked_CashShopController_UpdateEndurance()")
	self.btn_AllDoff			:addInputEvent("Mouse_LUp",			"HandleClicked_CashShopController_OffAllEquip()")
	self.btn_ShowUnderwear		:addInputEvent("Mouse_LUp",			"HandleClicked_CashShopController_ToggleUnderWear()")
	self.btn_HideAvatar			:addInputEvent("Mouse_LUp",			"HandleClicked_CashShopController_ToggleAvatar()")
	self.btn_HideHair			:addInputEvent("Mouse_LUp",			"HandleClicked_CashShopController_ToggleHideHair()")
	self.btn_HideHelm			:addInputEvent("Mouse_LUp",			"HandleClicked_CashShopController_ToggleHideHelm()")		-- 투구 클릭
	self.btn_AwakenWeapon		:addInputEvent("Mouse_LUp",			"HandleClicked_CashShopController_ToggleAwakenWeapon()")	-- 각성무기 클릭
	self.btn_WarStance			:addInputEvent("Mouse_LUp",			"HandleClicked_CashShopController_ToggleWarStance()")		-- 전투자세 클릭

	self.btn_ShowUnderwear		:addInputEvent("Mouse_On",			"_cashShopController_ButtonTooltip( true, " .. 0 .. ")")
	self.btn_ShowUnderwear		:addInputEvent("Mouse_Out",			"_cashShopController_ButtonTooltip( false )")
	self.btn_HideAvatar			:addInputEvent("Mouse_On",			"_cashShopController_ButtonTooltip( true, " .. 1 .. ")")
	self.btn_HideAvatar			:addInputEvent("Mouse_Out",			"_cashShopController_ButtonTooltip( false )")
	self.btn_HideHair			:addInputEvent("Mouse_On",			"_cashShopController_ButtonTooltip( true, " .. 2 .. ")")
	self.btn_HideHair			:addInputEvent("Mouse_Out",			"_cashShopController_ButtonTooltip( false )")
	self.btn_HideHelm			:addInputEvent("Mouse_On",			"_cashShopController_ButtonTooltip( true, " .. 6 .. ")")	-- 투구 툴팁
	self.btn_HideHelm			:addInputEvent("Mouse_Out",			"_cashShopController_ButtonTooltip( false )")
	self.btn_AwakenWeapon		:addInputEvent("Mouse_On",			"_cashShopController_ButtonTooltip( true, " .. 8 .. ")")	-- 각성 툴팁
	self.btn_AwakenWeapon		:addInputEvent("Mouse_Out",			"_cashShopController_ButtonTooltip( false )")
	self.btn_WarStance			:addInputEvent("Mouse_On",			"_cashShopController_ButtonTooltip( true, " .. 9 .. ")")	-- 전투자세 툴팁
	self.btn_WarStance			:addInputEvent("Mouse_Out",			"_cashShopController_ButtonTooltip( false )")
	self.btn_AllDoff			:addInputEvent("Mouse_On",			"_cashShopController_ButtonTooltip( true, " .. 3 .. ")")
	self.btn_AllDoff			:addInputEvent("Mouse_Out",			"_cashShopController_ButtonTooltip( false )")
	self.BTN_EyeSee				:addInputEvent("Mouse_On",			"_cashShopController_ButtonTooltip( true, " .. 4 .. ")")
	self.BTN_EyeSee				:addInputEvent("Mouse_Out",			"_cashShopController_ButtonTooltip( false )")
	self.BTN_ShowUI				:addInputEvent("Mouse_On",			"_cashShopController_ButtonTooltip( true, " .. 5 .. ")")
	self.BTN_ShowUI				:addInputEvent("Mouse_Out",			"_cashShopController_ButtonTooltip( false )")
	self.SunIcon				:addInputEvent("Mouse_On",			"_cashShopController_ButtonTooltip( true, " .. 7 .. ")")
	self.SunIcon				:addInputEvent("Mouse_Out",			"_cashShopController_ButtonTooltip( false )")

--{ 날씨 조종 관련
	self.SunIcon				:addInputEvent("Mouse_LUp",			"HandleClicked_SunShineToggle()")
	self.SunShine1				:addInputEvent("Mouse_LUp",			"HandleClicked_SunShineSetting( 1 )")
	self.SunShine2				:addInputEvent("Mouse_LUp",			"HandleClicked_SunShineSetting( 2 )")
	self.SunShine3				:addInputEvent("Mouse_LUp",			"HandleClicked_SunShineSetting( 3 )")
	self.SunShine4				:addInputEvent("Mouse_LUp",			"HandleClicked_SunShineSetting( 4 )")
	self.SunShine5				:addInputEvent("Mouse_LUp",			"HandleClicked_SunShineSetting( 5 )")
	self.SunShine6				:addInputEvent("Mouse_LUp",			"HandleClicked_SunShineSetting( 6 )")
--}
	Panel_IngameCashShop_Controller:RegisterUpdateFunc("cashShop_Controller_UpdateCharacterRotate")
end

function CashShopController:registMessageHandler()
	registerEvent( "onScreenResize", 				"FromClient_CashShopController_Resize" )
	registerEvent( "FromClient_ChangeAwakenWeapon",	"FromClient_ChangeAwakenWeapon" )
end

CashShopController:Initialize()
CashShopController:registEventHandler()
CashShopController:registMessageHandler()


-- getIngameCashMall():rotateViewCharacter( radianAngle )