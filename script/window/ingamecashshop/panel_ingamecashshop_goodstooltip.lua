local UI_TM			= CppEnums.TextMode
local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE
local UI_color		= Defines.Color

Panel_IngameCashShop_GoodsTooltip:SetShow( false )
Panel_IngameCashShop_GoodsTooltip:setGlassBackground( true )
Panel_IngameCashShop_GoodsTooltip:ActiveMouseEventEffect( true )

local GoodsTooltipInfo 		= {
	SlotBG					= UI.getChildControl( Panel_IngameCashShop_GoodsTooltip, "Static_GoodsSlotBG"),
	Slot					= UI.getChildControl( Panel_IngameCashShop_GoodsTooltip, "Static_GoodsSlot"),
	Name					= UI.getChildControl( Panel_IngameCashShop_GoodsTooltip, "StaticText_GoodsName"),
	BindType				= UI.getChildControl( Panel_IngameCashShop_GoodsTooltip, "StaticText_GoodsBindType"),
	ClassType				= UI.getChildControl( Panel_IngameCashShop_GoodsTooltip, "StaticText_GoodsClassType"),
	EnchantLimitedType		= UI.getChildControl( Panel_IngameCashShop_GoodsTooltip, "StaticText_GoodsLimitedType"),
	SalesPeriod				= UI.getChildControl( Panel_IngameCashShop_GoodsTooltip, "StaticText_GoodsSalesPeriod"),
	DiscountPeriod			= UI.getChildControl( Panel_IngameCashShop_GoodsTooltip, "StaticText_GoodsDiscountPeriod"),
	Desc					= UI.getChildControl( Panel_IngameCashShop_GoodsTooltip, "StaticText_GoodsDesc"),
	Warning					= UI.getChildControl( Panel_IngameCashShop_GoodsTooltip, "StaticText_Warning"),
	ItemListTitle			= UI.getChildControl( Panel_IngameCashShop_GoodsTooltip, "StaticText_ItemListTitle"),

	PackingItemUIPool		= {},
	PackingItemUIMaxCount	= 0,

	SelectedProductKeyRaw	= -1,
}

local TemplateTooltipInfo	= {
	PackingItemSlotBG		= UI.getChildControl( Panel_IngameCashShop_GoodsTooltip, "Static_ItemSlotBG"),
	PackingItemSlot			= UI.getChildControl( Panel_IngameCashShop_GoodsTooltip, "Static_ItemSlot"),
	PackingItemName			= UI.getChildControl( Panel_IngameCashShop_GoodsTooltip, "StaticText_ItemName"),
}

function GoodsTooltipInfo:Initialize()
	self.Name				:SetAutoResize( true )
	self.Name				:SetTextMode( UI_TM.eTextMode_AutoWrap )
	self.Desc				:SetAutoResize( true )
	self.Desc				:SetTextMode( UI_TM.eTextMode_AutoWrap )
	self.Desc				:SetFontColor( UI_color.C_FFC4A68A )

	self.BindType			:SetShow( false )
	self.ClassType			:SetShow( false )
	self.EnchantLimitedType	:SetShow( false )
	self.SalesPeriod		:SetShow( false )	-- 판매기간 일단 안씀.
	self.Warning			:SetShow( false )

	self.BindType			:SetFontColor( UI_color.C_FF748CAB )
	self.ClassType			:SetFontColor( UI_color.C_FF999999 )
	self.EnchantLimitedType	:SetFontColor( UI_color.C_FF999999 )
	self.DiscountPeriod		:SetFontColor( UI_color.C_FF748CAB )
	self.Warning			:SetFontColor( UI_color.C_FFF26A6A )

	local startPosY		= 25
	local PosYGap		= 25
	local itemNamePosX	= 40
	for itemIdx = 0, 9 do
		local tempSlot = {}
		local CreatePackingItemBG = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, self.ItemListTitle, 'CashShop_GoodsTooltipInfo_PackingItemBG_' .. itemIdx )
		CopyBaseProperty( TemplateTooltipInfo.PackingItemSlotBG, CreatePackingItemBG )
		CreatePackingItemBG:SetPosX( 15 )
		CreatePackingItemBG:SetPosY( startPosY )
		CreatePackingItemBG:SetShow( false )
		tempSlot.SlotBG = CreatePackingItemBG
		
		local CreatePackingItem = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, CreatePackingItemBG, 'CashShop_GoodsTooltipInfo_PackingItem_' .. itemIdx )
		CopyBaseProperty( TemplateTooltipInfo.PackingItemSlot, CreatePackingItem )
		CreatePackingItem:SetPosX( 0 )
		CreatePackingItem:SetPosY( 0 )
		CreatePackingItem:SetShow( false )
		tempSlot.Slot = CreatePackingItem

		local CreatePackingItemName = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, CreatePackingItemBG, 'CashShop_GoodsTooltipInfo_PackingItemName_' .. itemIdx )
		CopyBaseProperty( TemplateTooltipInfo.PackingItemName, CreatePackingItemName )
		CreatePackingItemName:SetPosX( itemNamePosX )
		CreatePackingItemName:SetPosY( 0 )
		CreatePackingItemName:SetAutoResize( true )
		CreatePackingItemName:SetTextMode( UI_TM.eTextMode_AutoWrap )
		CreatePackingItemName:SetText("아이템이름이 나옵니다 야하하하")
		CreatePackingItemName:SetShow( false )
		tempSlot.ItemName = CreatePackingItemName

		startPosY = startPosY + PosYGap

		self.PackingItemUIPool[itemIdx] = tempSlot
	end
end

function GoodsTooltipInfo:Update()
	-- 초기화
	for itemIdx = 0, 9 do
		local itemUI = self.PackingItemUIPool[itemIdx]
		itemUI.SlotBG	:SetShow( false )
		itemUI.Slot		:SetShow( false )
		itemUI.ItemName	:SetShow( false )
	end

	-- data set	
	local productNoRaw	= self.SelectedProductKeyRaw
	local cashProduct	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw(productNoRaw)

	self.Slot		:ChangeTextureInfoName( "Icon/" .. cashProduct:getIconPath() )
	self.Name		:SetText( cashProduct:getName() )

	local isEnchantable	= 0		-- 강화
	local isBind		= 0		-- 귀속
	local isEnableClass	= 0		-- 직업

	-- local 남은제한수량 = getIngameCashMall():getRemainingLimitCount(productNoRaw)
	-- local 제한타입 = CashProductStaticStatusWrapper:getCashPurchaseLimitType()
	-- local 제한갯수 = CashProductStaticStatusWrapper:getCashPurchaseCount()

	for itemIdx = 0, cashProduct:getItemListCount() - 1 do


		local itemSSW	= cashProduct:getItemByIndex( itemIdx )
		if itemSSW:isEquipable() then	-- 장비 일 때.
			local _isEnchantable = itemSSW:get():isEnchantable()
			if _isEnchantable then
				isEnchantable = isEnchantable + 1
			end
		end
		local itemBindType = itemSSW:get()._vestedType:getItemKey()	-- itemBindType == 1(획귀), itemBindType == 2(착귀)
		if 1 == itemBindType or 2 == itemBindType then
			isBind = isBind + 1
		end

		local isAllClass = true	-- 클래스 귀속
		local classNameList = nil
		for idx = 0, getCharacterClassCount() -1 do
			local className = getCharacterClassName( idx )
			if ( nil ~= className ) and ( "" ~= className ) and ( " " ~= className ) then
				if ( itemSSW:get()._usableClassType:isOn( idx ) ) then
					isEnableClass = isEnableClass + 1
				end
			end
		end

		local itemUI		= self.PackingItemUIPool[itemIdx]
		local itemCount_S64	= cashProduct:getItemCountByIndex( itemIdx )
		local itemCount_S32	= Int64toInt32(itemCount_S64)
		if 1 == itemCount_S32 then
			itemCount_S32 = ""
		end
		
		itemUI.SlotBG	:SetShow( true )
		itemUI.Slot		:ChangeTextureInfoName( "icon/" .. itemSSW:getIconPath() )
		-- itemUI.Slot		:addInputEvent( "Mouse_On",		"cashShop_GoodsDetailInfo_ShowTooltip(true, " .. itemIdx .. ")" )
		-- itemUI.Slot		:addInputEvent( "Mouse_Out",	"Panel_Tooltip_Item_hideTooltip()" )
		itemUI.Slot		:SetText( tostring(itemCount_S32) )
		itemUI.Slot		:SetShow( true )

		local nameColorGrade = itemSSW:getGradeType()
		if ( 0 == nameColorGrade ) then
			itemUI.ItemName:SetFontColor(UI_color.C_FFFFFFFF)
		elseif ( 1 == nameColorGrade ) then
			itemUI.ItemName:SetFontColor(4284350320)
		elseif ( 2 == nameColorGrade ) then
			itemUI.ItemName:SetFontColor(4283144191)
		elseif ( 3 == nameColorGrade ) then
			itemUI.ItemName:SetFontColor(4294953010)
		elseif ( 4 == nameColorGrade ) then
			itemUI.ItemName:SetFontColor(4294929408)
		else
			itemUI.ItemName:SetFontColor(UI_color.C_FFFFFFFF)
		end
		itemUI.ItemName :SetText( itemSSW:getName() )
		itemUI.ItemName	:SetShow( true )
	end

	if 0 < isBind then
		local vestedDesc	= IngameShopDetailInfo_ConvertFromCategoryToVestedDesc( cashProduct )
		if(	nil ~= vestedDesc )	then
			self.BindType			:SetText( vestedDesc )
			self.BindType			:SetShow( true )
		else
			self.BindType			:SetShow( false )
		end
	else
		self.BindType			:SetShow( false )
	end

	local	classDesc	= IngameShopDetailInfo_ConvertFromCategoryToClassDesc( cashProduct )
	if(	nil ~= classDesc )	then
		self.ClassType			:SetText( classDesc )
		self.ClassType			:SetShow( true )
	else
		self.ClassType			:SetShow( false )
	end

	if 0 < isEnchantable then
		self.EnchantLimitedType	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSTOOLTIP_ENCHANTLIMITEDTYPE") )  -- "- 일부 아이템 강화 불가" )
		self.EnchantLimitedType	:SetShow( true )
	else
		self.EnchantLimitedType	:SetText( "" )
		self.EnchantLimitedType	:SetShow( false )
	end

	-- 세일 기간이 있으면 나온다.
	if ( not cashProduct:isApplyDiscount() ) then
		self.DiscountPeriod:SetShow( false )
	else
		local	endDiscountTimeValue	= PATime( cashProduct:getEndDiscountTime():get_s64() )
		local	endDiscountTime			= PAGetStringParam3( Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_DISCOUNTTIME", "GetYear", tostring( endDiscountTimeValue:GetYear() ), "GetMonth", tostring( endDiscountTimeValue:GetMonth() ), "GetDay", tostring( endDiscountTimeValue:GetDay() ) ) .. " " .. string.format( "%.02d", endDiscountTimeValue:GetHour() ) .. ":" .. string.format( "%.02d", endDiscountTimeValue:GetMinute() )

		self.DiscountPeriod:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSTOOLTIP_DISCOUNT", "endDiscountTime", endDiscountTime ) )-- "<PAColor0xfface400>- 할인 기간 : " .. endDiscountTime .. "까지<PAOldColor>" )
		self.DiscountPeriod	:SetShow( true )
	end

 	self.Desc		:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSTOOLTIP_PRODUCTDESC", "getDescription", cashProduct:getDescription() ) )-- "- 상품 설명 : " .. cashProduct:getDescription() )

 	local tradeDesc	= IngameShopDetailInfo_ConvertFromCategoryToTradeDesc( cashProduct )
	if(	nil ~= tradeDesc )	then
		self.Warning	:SetText( tradeDesc )
		self.Warning	:SetShow( true )
	else
		self.Warning	:SetShow( false )
	end

	-- position set
	local controlPosY	= 14		-- 각 컨트롤의 Y좌표 설정을 위한 시작 점
	self.SlotBG:SetPosY( controlPosY )
	self.Slot:SetPosY( controlPosY )
	self.Name:SetPosY( controlPosY + 1 )
	controlPosY = controlPosY + ( self.Name:GetSizeY() * 2.2 )

	if self.BindType:GetShow() then
		self.BindType:SetPosY( controlPosY )
		controlPosY = controlPosY + self.BindType:GetSizeY()
	end
	if self.ClassType:GetShow() then
		self.ClassType:SetPosY( controlPosY )
		controlPosY = controlPosY + self.ClassType:GetSizeY()
	end
	if self.EnchantLimitedType:GetShow() then
		self.EnchantLimitedType:SetPosY( controlPosY )
		controlPosY = controlPosY + self.EnchantLimitedType:GetSizeY()
	end
	if self.SalesPeriod:GetShow() then
		self.SalesPeriod:SetPosY( controlPosY )
		controlPosY = controlPosY + self.SalesPeriod:GetSizeY()
	end
	if self.DiscountPeriod:GetShow() then
		self.DiscountPeriod:SetPosY( controlPosY )
		controlPosY = controlPosY + self.DiscountPeriod:GetSizeY()
	end
	if self.Desc:GetShow() then
		self.Desc:SetPosY( controlPosY )
		controlPosY = controlPosY + self.Desc:GetTextSizeY() + 5
	end
	if self.Warning:GetShow() then
		self.Warning:SetPosY( controlPosY )
		controlPosY = controlPosY + self.Warning:GetSizeY()
	end
	if self.ItemListTitle:GetShow() then
		self.ItemListTitle:SetPosY( controlPosY )
		controlPosY = controlPosY + self.ItemListTitle:GetSizeY()
	end

	local itemListStartPosY = 22
	for itemIdx = 0, cashProduct:getItemListCount() - 1 do
		local itemUI = self.PackingItemUIPool[itemIdx]
		if itemUI.SlotBG:GetShow() then
			itemUI.SlotBG:SetPosY( itemListStartPosY )
			itemListStartPosY = itemListStartPosY + itemUI.SlotBG:GetSizeY() + 3
		end
	end
	controlPosY = controlPosY + itemListStartPosY - 22

	Panel_IngameCashShop_GoodsTooltip:SetSize( Panel_IngameCashShop_GoodsTooltip:GetSizeX(), controlPosY + 10 )
end

function GoodsTooltipInfo:Open()
	self:Update()
	Panel_IngameCashShop_GoodsTooltip:SetShow( true )
end

function GoodsTooltipInfo:SetPosition( icon )
	local itemShow		= Panel_IngameCashShop_GoodsTooltip:GetShow()
	if ( not itemShow ) then
		return
	end

	local screenSizeX = getScreenSizeX()
	local screenSizeY = getScreenSizeY()
	
	local itemPosX = Panel_IngameCashShop_GoodsTooltip:GetSizeX()
	local itemPosY = Panel_IngameCashShop_GoodsTooltip:GetSizeY()

	local posX = icon:GetParentPosX()
	local posY = icon:GetParentPosY()
	if	parent	then
		posX = icon:getParent():GetParentPosX()
		posY = icon:getParent():GetParentPosY() - 500
	end

	local isLeft= (screenSizeX / 2) < posX
	local isTop	= (screenSizeY / 2) < posY

	local tooltipSize			= { width = 0, height = 0 }
	local tooltipEquipped		= { width = 0, height = 0 }
	local sumSize				= { width = 0, height = 0 }

	if ( Panel_IngameCashShop_GoodsTooltip:GetShow() ) then
		tooltipSize.width	= Panel_IngameCashShop_GoodsTooltip:GetSizeX()
		tooltipSize.height	= Panel_IngameCashShop_GoodsTooltip:GetSizeY()

		sumSize.width	= sumSize.width + tooltipSize.width
		sumSize.height	= math.max( sumSize.height, tooltipSize.height )
	end

	if not isLeft then
		posX = posX + icon:GetSizeX()
	end

	if isTop then
		posY = posY + icon:GetSizeY()
		local yDiff = posY - sumSize.height
		if yDiff < 0 then
			posY = posY - yDiff
		end
	else
		local yDiff = screenSizeY - (posY + sumSize.height)
		if yDiff < 0 then
			posY = posY + yDiff
		end
	end

	if Panel_IngameCashShop_GoodsTooltip:GetShow() then
		if isLeft then
			posX = posX - tooltipSize.width
		end

		local yTmp = posY
		if isTop then
			yTmp = yTmp - tooltipSize.height
		end

		Panel_IngameCashShop_GoodsTooltip:SetPosX(posX)
		Panel_IngameCashShop_GoodsTooltip:SetPosY(yTmp)
	end
end

function FGlobal_CashShop_GoodsTooltipInfo_Open( productKeyRaw, slotIcon )
	local self					= GoodsTooltipInfo
	self.SelectedProductKeyRaw	= productKeyRaw
	self:Open()
	self:SetPosition( slotIcon )
end
function FGlobal_CashShop_GoodsTooltipInfo_Close()
	Panel_IngameCashShop_GoodsTooltip:SetShow( false )
end


GoodsTooltipInfo:Initialize()