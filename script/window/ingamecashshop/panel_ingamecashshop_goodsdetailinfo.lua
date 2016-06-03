local UI_TM			= CppEnums.TextMode
local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE
local UI_color		= Defines.Color
local UI_PLT		= CppEnums.CashPurchaseLimitType
local UI_CCC		= CppEnums.CashProductCategory

Panel_IngameCashShop_GoodsDetailInfo:SetShow( false )
Panel_IngameCashShop_GoodsDetailInfo:setGlassBackground( true )
Panel_IngameCashShop_GoodsDetailInfo:ActiveMouseEventEffect( true )

local	inGameShopDetailInfo	= {
	_config	=
	{
		-- _product	=
		-- {
		-- 	_startX		= 5,
		-- 	_startY		= 60,
		-- 	_gapY		= 37,
		-- },
		_FixedPanelSize		= 190,
		_FixedPanelBGSize	= 155,
		_item	=
		{
			_startX		= 0,
			_startY		= 25,
			_gapX		= 35,
		},

		_relatedItem	=
		{
			_startX		= 0,
			_startY		= 25,
			_gapX		= 35,
		},
		
		_desc	=
		{
			_startY		= 185,
			_gapY		= 20,
		},
		
		_sizeLine			= -5,
		_sizeBG				= 180,
		_sizePanel			= 230,
		
		_productViewCount	= 3,
	},
	
	_static_MainBG				= UI.getChildControl( Panel_IngameCashShop_GoodsDetailInfo,	"Static_LeftBG"					),
	_button_Close   			= UI.getChildControl( Panel_IngameCashShop_GoodsDetailInfo, "Button_Win_Close"				),
	
	-- 그룹 상품 관련
	_static_GroupName			= UI.getChildControl( Panel_IngameCashShop_GoodsDetailInfo, "StaticText_ProductName"		),
	_static_ItemNameCombo		= UI.getChildControl( Panel_IngameCashShop_GoodsDetailInfo, "Combobox_ItemNameByGroup"		),

	-- 상품 기본 정보
	_static_SlotBG				= UI.getChildControl( Panel_IngameCashShop_GoodsDetailInfo, "Static_GoodsSlotBG"			),
	_static_Slot				= UI.getChildControl( Panel_IngameCashShop_GoodsDetailInfo, "Static_GoodsSlot"				),
	_static_Name				= UI.getChildControl( Panel_IngameCashShop_GoodsDetailInfo, "StaticText_GoodsName"			),
	_static_Desc				= UI.getChildControl( Panel_IngameCashShop_GoodsDetailInfo, "StaticText_GoodsDesc"			),
	-- 상품 추가 정보
	_staticText_PurchaseLimit	= UI.getChildControl( Panel_IngameCashShop_GoodsDetailInfo, "StaticText_PurchaseLimit"		),
	_static_VestedDesc			= UI.getChildControl( Panel_IngameCashShop_GoodsDetailInfo, "StaticText_VestedDesc"			),
	_static_TradeDesc			= UI.getChildControl( Panel_IngameCashShop_GoodsDetailInfo, "StaticText_TradeDesc"			),
	_static_ClassDesc			= UI.getChildControl( Panel_IngameCashShop_GoodsDetailInfo, "StaticText_ClassDesc"			),
	_static_WarningDesc			= UI.getChildControl( Panel_IngameCashShop_GoodsDetailInfo, "StaticText_WarningDesc"		),
	_static_DiscountPeriodDesc	= UI.getChildControl( Panel_IngameCashShop_GoodsDetailInfo, "StaticText_DiscountPeriod"		),
	_static_ItemListTitle		= UI.getChildControl( Panel_IngameCashShop_GoodsDetailInfo, "StaticText_ItemListTitle"		),
	
	-- 상품 구매 버튼 라인
	_static_PiceBG				= UI.getChildControl( Panel_IngameCashShop_GoodsDetailInfo, "Static_BuyLineBG"				),
	_static_PriceIcon			= UI.getChildControl( Panel_IngameCashShop_GoodsDetailInfo, "Static_PearlIcon"				),
	_static_Price				= UI.getChildControl( Panel_IngameCashShop_GoodsDetailInfo, "StaticText_GoodsPrice"			),
	_button_Cart				= UI.getChildControl( Panel_IngameCashShop_GoodsDetailInfo, "Button_Cart"					),
	_button_Buy					= UI.getChildControl( Panel_IngameCashShop_GoodsDetailInfo, "Button_Buy"					),
	_button_Gift				= UI.getChildControl( Panel_IngameCashShop_GoodsDetailInfo, "Button_Gift"					),

	-- 관련 상품
	_static_RelatedItemTitle	= UI.getChildControl( Panel_IngameCashShop_GoodsDetailInfo, "StaticText_RelatedItemTitle"	),
		
	
	_productCount				= 10,
	_itemCount					= 10,
	
	
	_items						= Array.new(),
	_relatedItems				= Array.new(),
	
	-- 상품 목록
	_selectedProductIndex		= 0,

	_productNoRaw				= nil,
	_list						= Array.new(),
	_listCount					= 1,
}

local contry = {
	kr = 0,
	jp = 1,
	ru = 2,
	cn = 3,
}

local cashIconType = {
	cash	= 0,
	pearl	= 1,
	mileage	= 2,
	silver	= 3,
}

local cashIconTexture = {
	[0] =	{310,	479,	329,	498},	-- 한국
			{267,	479,	286,	498},	-- 일본
			{310,	479,	329,	498},	-- 러시아
			{310,	479,	329,	498},	-- 중국
}

local eCountryType		= CppEnums.CountryType
local gameServiceType	= getGameServiceType()
local isKorea			= (eCountryType.NONE == gameServiceType) or (eCountryType.DEV == gameServiceType) or (eCountryType.KOR_ALPHA == gameServiceType) or (eCountryType.KOR_REAL == gameServiceType) or (eCountryType.KOR_TEST == gameServiceType)
local isNaver			= ( CppEnums.MembershipType.naver == getMembershipType() )

function	inGameShopDetailInfo:init()
	--{ 상품 결제 부분
		self._static_PiceBG						:AddChild( self._static_PriceIcon )
		self._static_PiceBG						:AddChild( self._static_Price )
		self._static_PiceBG						:AddChild( self._button_Cart )
		self._static_PiceBG						:AddChild( self._button_Buy )
		self._static_PiceBG						:AddChild( self._button_Gift )
		Panel_IngameCashShop_GoodsDetailInfo	:RemoveControl( self._static_PriceIcon )
		Panel_IngameCashShop_GoodsDetailInfo	:RemoveControl( self._static_Price )
		Panel_IngameCashShop_GoodsDetailInfo	:RemoveControl( self._button_Cart )
		Panel_IngameCashShop_GoodsDetailInfo	:RemoveControl( self._button_Buy )
		Panel_IngameCashShop_GoodsDetailInfo	:RemoveControl( self._button_Gift )
	
		self._static_PriceIcon					:SetPosX( 5 )
		self._static_PriceIcon					:SetPosY( 7 )
		self._static_Price						:SetPosX( self._static_PriceIcon:GetPosX() + self._static_PriceIcon:GetSizeX() + 5 )
		self._static_Price						:SetPosY( 3 )
		
		self._button_Gift						:SetPosX( self._static_PiceBG:GetSizeX() - ((self._button_Gift:GetSizeX() + 2) * 3) -5 )
		self._button_Gift						:SetPosY( 4 )
		self._button_Cart						:SetPosX( self._button_Gift:GetPosX() + self._button_Gift:GetSizeX() + 2 )
		self._button_Cart						:SetPosY( 4 )
		self._button_Buy						:SetPosX( self._button_Cart:GetPosX() + self._button_Cart:GetSizeX() + 2 )
		self._button_Buy						:SetPosY( 4 )
	--}

	--{	관련 상품 부분
	-- self._static_RelatedItemTitle				:AddChild( self._static_RelatedItemBG )
	-- Panel_IngameCashShop_GoodsDetailInfo		:RemoveControl( self._static_RelatedItemBG )

	-- self._static_RelatedItemBG					:SetPosX( 0 )
	-- self._static_RelatedItemBG					:SetPosY( 30 )
	--}

	self._static_Name					:SetAutoResize( true )
	self._static_Desc					:SetAutoResize( true )
	
	self._static_Name					:SetTextMode( UI_TM.eTextMode_AutoWrap )
	self._static_Desc					:SetTextMode( UI_TM.eTextMode_AutoWrap )

	self._static_Desc					:SetFontColor( UI_color.C_FFC4A68A )
	self._staticText_PurchaseLimit		:SetFontColor( UI_color.C_FF748CAB )
	self._static_VestedDesc				:SetFontColor( UI_color.C_FF748CAB )
	self._static_TradeDesc				:SetFontColor( UI_color.C_FFF26A6A )
	self._static_ClassDesc				:SetFontColor( UI_color.C_FF999999 )
	self._static_WarningDesc			:SetFontColor( UI_color.C_FFF26A6A )
	self._static_DiscountPeriodDesc		:SetFontColor( UI_color.C_FF748CAB )
	
	-- 구성 아이템 목록
	--{
		local	itemConfig	= self._config._item
		for	ii = 0, self._itemCount-1	do
			local	slot		= {}
			slot.iconBG	= UI.createAndCopyBasePropertyControl( Panel_IngameCashShop_GoodsDetailInfo, "Static_ItemSlotBG",	self._static_ItemListTitle,	"InGameShopDetailInfo_Item_"		.. ii )
			slot.icon	= UI.createAndCopyBasePropertyControl( Panel_IngameCashShop_GoodsDetailInfo, "Static_ItemSlot",		slot.iconBG,				"InGameShopDetailInfo_Item_Icon_"	.. ii )
			
			-- 좌표 설정.
			--{
				slot.iconBG	:SetPosX( itemConfig._startX + itemConfig._gapX * ii )
				slot.iconBG	:SetPosY( itemConfig._startY )
			--}
			
			self._items[ii]	=	slot
		end
	--}

	-- 관련 아이템 목록
	--{
		local	itemConfig	= self._config._relatedItem
		for	ii = 0, self._itemCount-1	do
			local	slot		= {}
			slot.iconBG	= UI.createAndCopyBasePropertyControl( Panel_IngameCashShop_GoodsDetailInfo, "Static_RelatedItemSlotBG",	self._static_RelatedItemTitle,	"InGameShopDetailInfo_RelatedItem_"		.. ii )
			slot.icon	= UI.createAndCopyBasePropertyControl( Panel_IngameCashShop_GoodsDetailInfo, "Static_RelatedItemSlot",		slot.iconBG,				"InGameShopDetailInfo_RelatedItem_Icon_"	.. ii )
			
			-- 좌표 설정.
			--{
				slot.iconBG	:SetPosX( itemConfig._startX + itemConfig._gapX * ii )
				slot.iconBG	:SetPosY( itemConfig._startY )
				slot.icon	:SetPosX( 0 )
				slot.icon	:SetPosY( 0 )
			--}
			
			self._relatedItems[ii]	=	slot
		end
	--}

	self:defaultPosition()
end

function	inGameShopDetailInfo:update()
	local	cashProduct	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw( self._productNoRaw )
	if	( nil == cashProduct )	then
		return
	end
	
	--초기화
	--{
		-- 구성 아이템
		for	ii = 0, self._itemCount-1	do
			local	slot	= self._items[ii]
			slot.iconBG:SetShow(false)
		end

		-- 관련 상품
		self._static_RelatedItemTitle:SetShow( false )
		for	ii = 0, self._itemCount-1	do
			local	slot	= self._relatedItems[ii]
			slot.iconBG:SetShow(false)
		end
	--}

	--{	구성 아이템
		local	itemCount	= cashProduct:getItemListCount()
		local	itemConfig	= self._config._relatedItem

		if itemCount < 10 then
			itemConfig._startX	= 0
			itemConfig._gapX	= 35
		else
			itemConfig._startX	= -7
			itemConfig._gapX	= 33
		end
		
		for ii = 0, itemCount - 1 do
			local	slot		= self._items[ii]
			local	item		= cashProduct:getItemByIndex( ii )
			local	itemCount	= cashProduct:getItemCountByIndex( ii )
			local	itemGrade	= item:getGradeType()

			slot.iconBG	:SetPosX( itemConfig._startX + itemConfig._gapX * ii )
			slot.iconBG	:SetPosY( itemConfig._startY )
			
			slot.icon	:ChangeTextureInfoName( "icon/" .. item:getIconPath() )
			slot.icon	:SetText( tostring(itemCount) )
			slot.icon	:addInputEvent( "Mouse_On", "InGameShopDetailInfo_ShowItemToolTip( true, " .. ii .. " )" )
			slot.icon	:addInputEvent( "Mouse_Out", "InGameShopDetailInfo_ShowItemToolTip( false, " .. ii .. " )" )
			slot.iconBG	:SetShow(true)
		end
	--}

	--{ 관련 아이템
		local	relatedItemCount	= cashProduct:getCashRelatedCount()
		if 0 < relatedItemCount then
			for ii = 0, relatedItemCount - 1 do
				local	slot		= self._relatedItems[ii]
				local	item		= cashProduct:getCashRelatedItemByIndex( ii )
				slot.icon	:ChangeTextureInfoName( "icon/" .. item:getIconPath() )
				slot.iconBG	:SetShow(true)
			end
			self._static_RelatedItemTitle:SetShow( true )
		end
	--}

	--{
		local	descCount	= 0
		local	descConfig	= self._config._desc
		
		self._static_VestedDesc			:SetShow( false )
		self._static_TradeDesc			:SetShow( false )
		self._static_ClassDesc			:SetShow( false )
		self._static_WarningDesc		:SetShow( false )
		self._static_DiscountPeriodDesc	:SetShow( false )
		
		self._static_Slot				:ChangeTextureInfoName( "Icon/" .. cashProduct:getIconPath() )

		self._static_GroupName			:SetTextMode( UI_TM.eTextMode_LimitText )
		self._static_GroupName			:SetText( cashProduct:getDisplayName() )
		self._static_Name				:SetText( cashProduct:getName() )
		self._static_Desc				:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_STATIC_DESC", "getDes", cashProduct:getDescription() ) )-- "- 상품 설명 : " .. cashProduct:getDescription() 
		self._static_Price				:SetText( makeDotMoney(cashProduct:getPrice()) )

		local list				= self._static_ItemNameCombo:GetListControl()
		local _scroll			= list:GetScroll()
		local listCount			= list:GetItemQuantity()
		local listTotalCount	= list:GetItemSize()

		if listCount <= listTotalCount then
			_scroll:SetShow( true )
		else
			_scroll:SetShow( false )
		end

		-- 상품 카테고리에 따라 펄 아이콘을 변경.
		InGameShop_ProductInfo_ChangeMoneyIconTexture( cashProduct:getCategory(), cashProduct:isMoneyPrice() )

		local optionDesc_PosY = descConfig._startY + self._static_Desc:GetTextSizeY() + 10	-- desc 길이에 따른 대응

		-- 구매 횟수 제한
		self._staticText_PurchaseLimit	:SetShow( false )
		local limitType		= cashProduct:getCashPurchaseLimitType()
		if UI_PLT.None ~= limitType then
			local limitCount	= cashProduct:getCashPurchaseCount()
			local mylimitCount	= getIngameCashMall():getRemainingLimitCount( self._productNoRaw )
			local typeString = ""
			if UI_PLT.AtCharacter == limitType then
				typeString = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_CHARACTER") -- "캐릭터"
			elseif UI_PLT.AtAccount == limitType then
				typeString = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_FAMILY") -- "가문"
			end
			self._staticText_PurchaseLimit	:SetText( PAGetStringParam3( Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_PURCHASELIMIT", "typeString", typeString, "limitCount", limitCount, "mylimitCount", mylimitCount ) )-- "- 구입 제한 : " .. typeString .. " 당 " .. limitCount .. "개(" .. mylimitCount .."개 남음)" 
			self._staticText_PurchaseLimit:SetFontColor( UI_color.C_FFF26A6A )	-- 붉은색
			
			self._staticText_PurchaseLimit	:SetShow( true )
			self._staticText_PurchaseLimit	:SetPosY( optionDesc_PosY + descConfig._gapY * descCount )
			descCount	= descCount + 1
		end

		local	vestedDesc	= IngameShopDetailInfo_ConvertFromCategoryToVestedDesc( cashProduct )
		if(	nil ~= vestedDesc )	then
			self._static_VestedDesc:SetText(vestedDesc)
			self._static_VestedDesc:SetShow(true)
			
			self._static_VestedDesc:SetPosY( optionDesc_PosY + descConfig._gapY * descCount)
			descCount	= descCount + 1
		end
		
		local	tradeDesc	= IngameShopDetailInfo_ConvertFromCategoryToTradeDesc( cashProduct )
		if(	nil ~= tradeDesc )	then
			self._static_TradeDesc	:SetText(tradeDesc)
			self._static_TradeDesc	:SetShow(true)
			self._static_TradeDesc	:SetPosY( optionDesc_PosY + descConfig._gapY * descCount)
			descCount	= descCount + 1
		end
	
		local	classDesc	= IngameShopDetailInfo_ConvertFromCategoryToClassDesc( cashProduct )
		if(	nil ~= classDesc )	then
			self._static_ClassDesc	:SetText(classDesc)
			self._static_ClassDesc	:SetShow(true)
			self._static_ClassDesc	:SetPosY( optionDesc_PosY + descConfig._gapY * descCount)
			descCount	= descCount + 1
		end
		
		-- 세일기간이면 끝나는 날짜만 보여준다.
		if ( cashProduct:isApplyDiscount() ) then
			local	startDiscountTimeValue	= PATime( cashProduct:getStartDiscountTime():get_s64() )
			local	endDiscountTimeValue	= PATime( cashProduct:getEndDiscountTime():get_s64() )
			local	startDiscountTime		= tostring( startDiscountTimeValue:GetYear() )	.. "." .. tostring( startDiscountTimeValue:GetMonth() ) .. "." .. tostring( startDiscountTimeValue:GetDay()	)
			local	endDiscountTime			= PAGetStringParam3(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_DISCOUNTTIME", "GetYear", tostring( endDiscountTimeValue:GetYear() ), "GetMonth", tostring( endDiscountTimeValue:GetMonth() ), "GetDay", tostring( endDiscountTimeValue:GetDay())) .. " " .. string.format( "%.02d", endDiscountTimeValue:GetHour() ) .. ":" .. string.format( "%.02d", endDiscountTimeValue:GetMinute() ) -- tostring( endDiscountTimeValue:GetYear() )	.. "년" .. tostring( endDiscountTimeValue:GetMonth() )	.. "월" .. tostring( endDiscountTimeValue:GetDay() .. "일 "
			self._static_DiscountPeriodDesc:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_DISCOUNTPERIODDESC", "endDiscountTime", endDiscountTime) )-- "<PAColor0xfface400>- 할인 기간 : " .. endDiscountTime .. "까지<PAOldColor>"
			self._static_DiscountPeriodDesc:SetShow( true )
			self._static_DiscountPeriodDesc:SetPosY( optionDesc_PosY + descConfig._gapY * descCount)

			self._static_Price				:SetText( "<PAColor0xFF626262>" .. makeDotMoney(cashProduct:getOriginalPrice()) .. "<PAOldColor> <PAColor0xffefefef>→ " .. makeDotMoney(cashProduct:getPrice()) .. "<PAOldColor>" )

			descCount	= descCount + 1
		end

		self._static_ItemListTitle		:SetPosY( (optionDesc_PosY + descConfig._gapY * descCount) )
		descCount	= descCount + 1
		optionDesc_PosY = optionDesc_PosY + self._items[0].iconBG:GetSizeY() + 20	-- 패키지 아이템 사이즈를 더해야 한다.

		self._static_PiceBG				:SetPosY( (optionDesc_PosY + descConfig._gapY * descCount) )
		descCount	= descCount + 1
		optionDesc_PosY = optionDesc_PosY + 15										-- 펄 배경 높이를 더해야 한다.

		if UI_CCC.eCashProductCategory_Pearl == cashProduct:getCategory() or UI_CCC.eCashProductCategory_Mileage == cashProduct:getCategory() then
			self._button_Buy:SetMonoTone( false )
			self._button_Buy:SetEnable( true )
			self._button_Gift:SetMonoTone( true )
			self._button_Gift:SetEnable( false )
			self._button_Cart:SetMonoTone( true )
			self._button_Cart:SetEnable( false )
		else
			if UI_PLT.None ~= limitType then
				local limitCount	= cashProduct:getCashPurchaseCount()
				local mylimitCount	= getIngameCashMall():getRemainingLimitCount( self._productNoRaw )
				if 0 < limitCount then
					self._button_Buy	:SetMonoTone( false )
					self._button_Gift	:SetMonoTone( true )
					self._button_Cart	:SetMonoTone( false )

					self._button_Buy	:SetEnable( true )
					self._button_Gift	:SetEnable( false )
					self._button_Cart	:SetEnable( true )

					if mylimitCount <= 0 then
						self._button_Buy	:SetMonoTone( true )
						self._button_Cart	:SetMonoTone( true )
						
						self._button_Buy	:SetEnable( false )
						self._button_Cart	:SetEnable( false )
					end
				else
					self._button_Buy:SetMonoTone( true )
					self._button_Buy:SetEnable( false )
					self._button_Gift:SetMonoTone( true )
					self._button_Gift:SetEnable( false )
					self._button_Cart:SetMonoTone( true )
					self._button_Cart:SetEnable( false )
				end
			else
				self._button_Buy:SetMonoTone( false )
				self._button_Buy:SetEnable( true )
				self._button_Gift:SetMonoTone( false )
				self._button_Gift:SetEnable( true )
				self._button_Cart:SetMonoTone( false )
				self._button_Cart:SetEnable( true )
			end
		end

		if self._static_RelatedItemTitle:GetShow() then
			self._static_RelatedItemTitle	:SetPosY( (optionDesc_PosY + descConfig._gapY * descCount) )
			descCount	= descCount + 1
		end
	--}
	
	--크기 및 사이즈 조절
	--{
		local bg_sizeY		= self._static_PiceBG:GetPosY()
		if self._static_RelatedItemTitle:GetShow() then
			bg_sizeY	= self._static_RelatedItemTitle:GetPosY() + 30
		end
		local panel_SizeY	= bg_sizeY + 55
		self._static_MainBG	:SetSize( self._static_MainBG:GetSizeX(), bg_sizeY )
		Panel_IngameCashShop_GoodsDetailInfo:SetSize( Panel_IngameCashShop_GoodsDetailInfo:GetSizeX(), panel_SizeY )
	--}
end

function	inGameShopDetailInfo:registEventHandler()
	self._button_Close							:addInputEvent(	"Mouse_LUp",	"InGameShopDetailInfo_Close()"	)
	self._button_Buy							:addInputEvent(	"Mouse_LUp",	"InGameShopDetailInfo_Buy()"	)
	self._button_Gift							:addInputEvent(	"Mouse_LUp",	"InGameShopDetailInfo_Gift()"	)
	self._button_Cart							:addInputEvent(	"Mouse_LUp",	"InGameShopDetailInfo_Cart()"	)
	self._static_ItemNameCombo					:addInputEvent(	"Mouse_LUp",	"HandleClicked_InGameShopDetailInfo_ShowSubList()"	)
	self._static_ItemNameCombo:GetListControl()	:addInputEvent( "Mouse_LUp",	"HandleClicked_InGameShopDetailInfo_SelectedSubList()"	)
end

function	inGameShopDetailInfo:registMessageHandler()
end

----------------------------------------------------------------------------------------------------
-- Data
function	inGameShopDetailInfo:initData()
	self._list		= Array.new()
	self._listCount	= 1
	local	count		= getIngameCashMall():getCashProductStaticStatusListCount()
	for ii=0, count -1 do
		local	cashProduct	= getIngameCashMall():getCashProductStaticStatusByIndex(ii)
		if	nil ~= cashProduct	then
			if	self:filterData( cashProduct )	then
				self._list[self._listCount]	= cashProduct:getNoRaw()
				self._listCount		= self._listCount + 1
			end
		end
	end
	
	self:sortData()
	
	self._static_ItemNameCombo:DeleteAllItem()
	self._static_ItemNameCombo:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_ITEMNAMECOMBO") )-- "선택 옵션이 없습니다."
	self._static_ItemNameCombo:SetMonoTone( true )
	self._static_ItemNameCombo:SetEnable( false )
	
	for ii=self._listCount-1, 0, -1 do
		local subProduct	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw( self._list[ii] )
		if	( nil ~= subProduct )	then
			self._static_ItemNameCombo:AddItemWithKey( subProduct:getName(), subProduct:getNoRaw() )
			self._static_ItemNameCombo:SetMonoTone( false )
			self._static_ItemNameCombo:SetEnable( true )
		end
	end
	
	if	( 0 < count )	then
		self._static_ItemNameCombo:SetSelectItemIndex( self._selectedProductIndex )
	end
end

function	InGameShopDetailInfo_SortCash( lhs, rhs )
	local	self	= inGameShop
	local	lhsNo	= nil
	local	rhsNo	= nil
		
	local	lhsWrapper	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw( lhs )
	if	( nil ~= lhsWrapper )	then
		lhsNo		= lhsWrapper:getNoRaw()
	end
	
	local	rhsWrapper	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw( rhs )
	if	( nil ~= rhsWrapper )	then
		rhsNo		= rhsWrapper:getNoRaw()
	end
	
	return( lhsNo > rhsNo )
end

function	inGameShopDetailInfo:sortData()
	table.sort( self._list, InGameShopDetailInfo_SortCash )
end

function	inGameShopDetailInfo:filterData( cashProduct )
	if	( not CheckCashProduct(cashProduct) )	then
		return(false)
	end
	
	local	currentCashProduct	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw( self._productNoRaw )
	if	( nil == currentCashProduct )	then
		return(false)
	end
		
	-- OfferGroup
	if	( 0 == cashProduct:getOfferGroup() )	then
		return(false)
	end
	
	if	( cashProduct:getOfferGroup() ~= currentCashProduct:getOfferGroup() )	then
		return(false)
	end
	
	return(true)
end

----------------------------------------------------------------------------------------------------
-- Position
function	inGameShopDetailInfo:defaultPosition()
	local scrSizeX			= getScreenSizeX()
	local scrSizeY			= getScreenSizeY()

	local parentPanelPosX	= Panel_IngameCashShop:GetPosX()
	local parentPanelPosY	= Panel_IngameCashShop:GetPosY()
	local parentPanelSizeX	= Panel_IngameCashShop:GetSizeX()
	local parentPanelSizeY	= Panel_IngameCashShop:GetSizeY()

	local panelSizeX 		= Panel_IngameCashShop_GoodsDetailInfo:GetSizeX()
	local panelSizeY 		= Panel_IngameCashShop_GoodsDetailInfo:GetSizeY()

	Panel_IngameCashShop_GoodsDetailInfo:SetPosX( parentPanelPosX + (parentPanelSizeX / 2) - (panelSizeX / 2)  )
	Panel_IngameCashShop_GoodsDetailInfo:SetPosY( parentPanelPosY + (parentPanelSizeY / 2) - (panelSizeY / 2) )
end

----------------------------------------------------------------------------------------------------
-- Function
function	InGameShopDetailInfo_Buy()
	local	self	= inGameShopDetailInfo
	
	local cashProduct	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw( self._productNoRaw )
	local isPearl		= CppEnums.CashProductCategory.eCashProductCategory_Pearl == cashProduct:getCategory()

	if isKorea and isNaver and isPearl then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_DETAILINFO_BUY") )	-- "펄 상자는 웹 상점에서만 구입이 가능합니다."
		local naverLink = "http://black.game.naver.com/black/billing/shop/index.daum"
		ToClient_OpenChargeWebPage( naverLink, true )
	else
		FGlobal_InGameShopBuy_Open( self._productNoRaw, false )
	end
end

function	InGameShopDetailInfo_Gift()
	local	self	= inGameShopDetailInfo
	local myLevel = getSelfPlayer():get():getLevel()
	local limitLevel = 20
	if myLevel < limitLevel and isGameTypeEnglish() then
		Proc_ShowMessage_Ack( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_LIMIT_20LEVEL", "level", limitLevel ) ) -- "20레벨부터 선물하기가 가능합니다.")
		return
	end
	
	FGlobal_InGameShopBuy_Open( self._productNoRaw, true )
end

function	InGameShopDetailInfo_Cart()
	local self			= inGameShopDetailInfo
	local cashProduct	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw( self._productNoRaw )

	local doAnotherClassItem = function()
		Proc_ShowMessage_Ack( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CARTITEM_ACK", "getName", cashProduct:getName()) )-- cashProduct:getName() .. " 상품이 장바구니에 담겼습니다." )
		FGlobal_PushCart_IngameCashShop_NewCart( self._productNoRaw, 1 )
		return
	end

	-- { 직업 비교 처리.
		if cashProduct:doHaveDisplayClass() and not cashProduct:isClassTypeUsable(getSelfPlayer():getClassType()) then
			local messageBoxTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_ALERT") -- "알  림"
			local messageBoxMemo	= "<PAColor0xffd0ee68>[" .. PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_BUYORGIFT_MATHCLASS") .. "]\n" .. PAGetStringParam1( Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_CART_MEMO", "getName", cashProduct:getName() ) -- cashProduct:getName() .. " 상품<PAOldColor>을 장바구니에 담으시겠습니까?"
			messageBoxData = { title = messageBoxTitle, content = messageBoxMemo, functionYes = doAnotherClassItem, functionNo = _InGameShopBuy_Confirm_Cancel, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
			MessageBox.showMessageBox(messageBoxData)
		else
			Proc_ShowMessage_Ack( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_CARTITEM_ACK", "getName", cashProduct:getName()) )-- cashProduct:getName() .. " 상품이 장바구니에 담겼습니다." )
			FGlobal_PushCart_IngameCashShop_NewCart( self._productNoRaw, 1 )
		end
	-- }
end

function InGameShopDetailInfo_ShowItemToolTip( isShow, index  )
	local self			= inGameShopDetailInfo
	if true == isShow then
		local cashProduct	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw( self._productNoRaw )
		local itemWrapper	= cashProduct:getItemByIndex( index )
		local slotIcon		= self._items[index].icon
		Panel_Tooltip_Item_Show( itemWrapper, slotIcon, true, false, nil )
	else
		Panel_Tooltip_Item_hideTooltip()
	end
end
function HandleClicked_InGameShopDetailInfo_ShowSubList()
	local self	= inGameShopDetailInfo
	Panel_IngameCashShop_GoodsDetailInfo:SetChildIndex(self._static_ItemNameCombo, 9999 )

	local list	= self._static_ItemNameCombo:GetListControl()
	self._static_ItemNameCombo:ToggleListbox()
end

function HandleClicked_InGameShopDetailInfo_SelectedSubList()
	local	self		= inGameShopDetailInfo
	local	selectIndex	= self._static_ItemNameCombo:GetSelectIndex()
	local	selectKey	= self._static_ItemNameCombo:GetSelectKey()

	if -1 == selectIndex then
		return
	end
	
	self._static_ItemNameCombo:SetSelectItemIndex( selectIndex )
	FGlobal_InGameSHopDetailInfo_Open( selectKey, selectIndex )
end

function InGameShop_ProductInfo_ChangeMoneyIconTexture( categoryIdx, isEnableSilver )
	local self	= inGameShopDetailInfo
	local icon	= self._static_PriceIcon

	local serviceContry = nil
	local iconType		= nil
	-- 국가에 따라, 캐시 아이콘을 달리 한다.
	local eCountryType		= CppEnums.CountryType
	local gameServiceType	= getGameServiceType()

	if eCountryType.NONE == gameServiceType or eCountryType.DEV == gameServiceType or eCountryType.KOR_ALPHA == gameServiceType or eCountryType.KOR_REAL == gameServiceType or eCountryType.KOR_TEST == gameServiceType then
		serviceContry = contry.kr
	elseif eCountryType.JPN_ALPHA == gameServiceType or eCountryType.JPN_REAL == gameServiceType then
		serviceContry = contry.jp
	elseif eCountryType.RUS_ALPHA == gameServiceType or eCountryType.RUS_REAL == gameServiceType then
		serviceContry = contry.ru
	elseif eCountryType.CHI_ALPHA == gameServiceType or eCountryType.CHI_REAL == gameServiceType then
		serviceContry = contry.cn
	else
		serviceContry = contry.kr
	end

	-- 일단은 카테고리에 맞춰 출력한다.
	if UI_CCC.eCashProductCategory_Pearl == categoryIdx then
		iconType = cashIconType.cash
	elseif UI_CCC.eCashProductCategory_Mileage == categoryIdx then
		iconType = cashIconType.mileage
	else
		local isRussia		= ( isGameTypeRussia() or eCountryType.DEV == gameServiceType )
		local isFixedServer	= isServerFixedCharge()
		if true == isRussia and true == isFixedServer then
			if isEnableSilver then
				iconType = cashIconType.silver
			else
				iconType = cashIconType.pearl
			end
		else
			iconType = cashIconType.pearl
		end
	end
	cashIcon_changeTextureForList( icon, serviceContry, iconType )
end

----------------------------------------------------------------------------------------------------
-- Window Convert String
function	IngameShopDetailInfo_ConvertFromCategoryToVestedDesc( cashProduct )
	if	(CppEnums.CashProductCategory.eCashProductCategory_Pearl == cashProduct:getCategory())	then
		return( "- " .. PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_TOVESTEDDESC") ) -- "- 획득 시 귀속"
	else
		-- 구성 아이템 정보를 받아서 리턴한다.
		local	anySomeoneBind	= false
		local	itemCount		= cashProduct:getItemListCount()
		local	getBindCount	= 0
		local	equippBindCount	= 0

		for ii = 0, itemCount - 1 do
			local itemSSW		= cashProduct:getItemByIndex( ii )
			local itemBindType 	= itemSSW:get()._vestedType:getItemKey()
			if 1 == itemBindType then
				getBindCount	= getBindCount + 1
			elseif 2 == itemBindType then
				equippBindCount	= equippBindCount + 1
			end
		end

		local returnValue = "- "
		if 0 < getBindCount then
			returnValue = returnValue .. PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_TOVESTEDDESC") -- " 획득 시 귀속"
		end
		if 0 < equippBindCount then
			if 0 < getBindCount then
				returnValue = returnValue .. ", "
			end
			returnValue = returnValue .. PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_EQUIPBIND") -- " 장착 시 귀속"
		end

		if 1 < itemCount and ( 0 < getBindCount or 0 < equippBindCount ) then
			returnValue = returnValue .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_INCLUSION") --" 포함"
		end

		if "- " == returnValue then
			returnValue = nil
		end

		return returnValue
	end
end

function	IngameShopDetailInfo_ConvertFromCategoryToClassDesc( cashProduct )
	if	(CppEnums.CashProductCategory.eCashProductCategory_Pearl == cashProduct:getCategory())	then
		return( nil )
	end
	
	local	returnString	= nil
	local	valueString		= nil
	if cashProduct:doHaveDisplayClass() then
		if	cashProduct:isClassTypeUsable(CppEnums.ClassType.ClassType_Warrior)	then
			valueString = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_WARRIOR")) -- "- 워리어 전용"
			if	nil ~= returnString	then
				returnString	= tostring(returnString) .. ", " .. valueString
			else
				returnString	= valueString
			end
		end
		
		if	cashProduct:isClassTypeUsable(CppEnums.ClassType.ClassType_Ranger)	then
			valueString = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_RANGER")) -- "- 레인져 전용"
			if	nil ~= returnString	then
				returnString	= tostring(returnString) .. ", " .. valueString
			else
				returnString	= valueString
			end
		end
		
		if	cashProduct:isClassTypeUsable(CppEnums.ClassType.ClassType_Sorcerer)	then
			valueString = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_SORCERER")) -- "- 소서 전용"
			if	nil ~= returnString	then
				returnString	= tostring(returnString) .. ", " .. valueString
			else
				returnString	= valueString
			end
		end
		
		if	cashProduct:isClassTypeUsable(CppEnums.ClassType.ClassType_Giant)	then
			valueString = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_GIANT")) -- "- 자이언트 전용"
			if	nil ~= returnString	then
				returnString	= tostring(returnString) .. ", " .. valueString
			else
				returnString	= valueString
			end
		end
		
		if	cashProduct:isClassTypeUsable(CppEnums.ClassType.ClassType_Tamer)	then
			valueString = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_TAMER")) -- "- 금수랑 전용"
			if	nil ~= returnString	then
				returnString	= tostring(returnString) .. ", " .. valueString
			else
				returnString	= valueString
			end
		end
		if	cashProduct:isClassTypeUsable(CppEnums.ClassType.ClassType_Valkyrie)	then
			valueString = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_VALKYRIE")) -- "- 발키리 전용"
			if	nil ~= returnString	then
				returnString	= tostring(returnString) .. ", " .. valueString
			else
				returnString	= valueString
			end
		end
		if	cashProduct:isClassTypeUsable(CppEnums.ClassType.ClassType_BladeMaster)	then
			valueString = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_BLADER")) -- "- 무사 전용"
			if	nil ~= returnString	then
				returnString	= tostring(returnString) .. ", " .. valueString
			else
				returnString	= valueString
			end
		end
		if	cashProduct:isClassTypeUsable(CppEnums.ClassType.ClassType_BladeMasterWomen)	then
			valueString = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_BLADERWOMEN")) -- "- 매화 전용"
			if	nil ~= returnString	then
				returnString	= tostring(returnString) .. ", " .. valueString
			else
				returnString	= valueString
			end
		end
		if	cashProduct:isClassTypeUsable(CppEnums.ClassType.ClassType_Wizard)	then
			valueString = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_WIZZARD")) -- "- 위자드 전용"
			if	nil ~= returnString	then
				returnString	= tostring(returnString) .. ", " .. valueString
			else
				returnString	= valueString
			end
		end
		if	cashProduct:isClassTypeUsable(CppEnums.ClassType.ClassType_WizardWomen)	then
			valueString = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_WIZZARDWOMEN")) -- "- 위치 전용"
			if	nil ~= returnString	then
				returnString	= tostring(returnString) .. ", " .. valueString
			else
				returnString	= valueString
			end
		end
		if	cashProduct:isClassTypeUsable(CppEnums.ClassType.ClassType_NinjaWomen)	then
			valueString = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_NINJAWOMEN")) -- "- 쿠노이치 전용"
			if	nil ~= returnString	then
				returnString	= tostring(returnString) .. ", " .. valueString
			else
				returnString	= valueString
			end
		end
		if	cashProduct:isClassTypeUsable(CppEnums.ClassType.ClassType_NinjaMan)	then
			valueString = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_NINJA")) -- "- 닌자 전용"
			if	nil ~= returnString	then
				returnString	= tostring(returnString) .. ", " .. valueString
			else
				returnString	= valueString
			end
		end
	end
	
	return(returnString)
end

function	IngameShopDetailInfo_ConvertFromCategoryToTradeDesc( cashProduct )
	if	(CppEnums.CashProductCategory.eCashProductCategory_Pearl == cashProduct:getCategory())	then
		return( PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_IMPOSSIBLE") )-- "- 선물 및 거래 불가, 개봉 후 청약 철회 불가" 
	-- elseif	(CppEnums.CashProductCategory.eCashProductCategory_Costumes == cashProduct:getCategory())	then
	-- 	return( "- 착용 후 거래 불가, 구입 시 청약 철회 불가" )
	-- elseif	(CppEnums.CashProductCategory.eCashProductCategory_Furniture == cashProduct:getCategory())	then
	-- 	return( "- 설치 후 거래 불가, 구입 시 청약 철회 불가" )
	-- elseif	(CppEnums.CashProductCategory.eCashProductCategory_Servant == cashProduct:getCategory())	then
	-- 	return( "- 사용/장착 후 거래 불가, 구입 시 청약 철회 불가" )
	else
		-- return( "- 구입 시 청약 철회 불가" )
		return ( nil )
	end
end
----------------------------------------------------------------------------------------------------
-- Window Open/Close
function	FGlobal_InGameSHopDetailInfo_Open( productNoRaw, selectIndex )
	local self					= inGameShopDetailInfo
	self._productNoRaw			= productNoRaw
	self._selectedProductIndex	= selectIndex
	
	self:initData()
	self:update()
	-- self:defaultPosition()

	if Panel_IngameCashShop_BuyOrGift:GetShow() then
		InGameShopBuy_Close()
	end
	
	InGameShopDetailInfo_Open()
end

function	InGameShopDetailInfo_Open()
	if	( Panel_IngameCashShop_GoodsDetailInfo:GetShow() )	then
		return
	end
	if Panel_IngameCashShop_BuyOrGift:GetShow() then
		InGameShopBuy_Close()
	end

	Panel_IngameCashShop_GoodsDetailInfo:SetShow(true)
end

function	InGameShopDetailInfo_Close()
	if	( not Panel_IngameCashShop_GoodsDetailInfo:GetShow() )	then
		return
	end
	if Panel_IngameCashShop_BuyOrGift:GetShow() then
		InGameShopBuy_Close()
	end
	
	--Panel_Tooltip_Item_hideTooltip()
	FGlobal_IngameCashShop_SelectedItemReset()
	Panel_IngameCashShop_GoodsDetailInfo:SetShow( false )
end

inGameShopDetailInfo:init()
inGameShopDetailInfo:registEventHandler()
inGameShopDetailInfo:registMessageHandler()
