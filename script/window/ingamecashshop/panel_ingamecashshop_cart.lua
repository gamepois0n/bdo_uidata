local UI_PreviewType= CppEnums.InGameCashShopPreviewType
local IM 		= CppEnums.EProcessorInputMode
local UI_CCC	= CppEnums.CashProductCategory

Panel_IngameCashShop_NewCart:SetShow( false )
Panel_IngameCashShop_NewCart:SetIgnore(false)

--------------------------------------------------------------------------------
-- dataGroup

local CashShopCart = {
	_makeSlotCount		= 20,
	_maxShowSlotCount	= 7,	-- 최대 슬롯 카운트
	_currentSlotIndex	= 0,	-- 현재 슬롯 인덱스 (스크롤 효과용)
	_remainSizeY		= 0,	-- 리스트를 노출할 수 있는 공간 값
	_activeEditBoxUI	= nil,	-- 활성화된 editBoxUI
	_activeEditBoxRow	= -1,	-- 활성화된 editBoxUI의 Row
	_defaultUI = {},
	_uiData	= {},

	_button_CartClear			= UI.getChildControl( Panel_IngameCashShop_NewCart, "Button_CartClear"),
	_button_BuyAll				= UI.getChildControl( Panel_IngameCashShop_NewCart, "Button_CartBuyAll"),
	_button_CartClose			= UI.getChildControl( Panel_IngameCashShop_NewCart, "Button_CartClose"),
	_scroll						= UI.getChildControl( Panel_IngameCashShop_NewCart, "Scroll_IngameCashCart"),

	_static_PearlBox			= UI.getChildControl( Panel_IngameCashShop_NewCart, "Static_PearlBox"),
	_static_NowPearlIcon		= UI.getChildControl( Panel_IngameCashShop_NewCart, "Static_NowPearlIcon"),
	_staticText_TotalCount		= UI.getChildControl( Panel_IngameCashShop_NewCart, "StaticText_TotalCount"),

	_staticText_NowPearlCount	= UI.getChildControl( Panel_IngameCashShop_NewCart, "StaticText_NowPearlCount"),
	
}
CashShopCart._scrollBTN		= UI.getChildControl( CashShopCart._scroll, "Scroll_CtrlButton")

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

--------------------------------------------------------------------------------
-- local function
local convertDateStr = function( ttime64 )
	local paTime	= PATime(ttime64)
	return tostring( paTime:GetYear() ) .. "." .. tostring( paTime:GetMonth() ) .. "." .. tostring( paTime:GetDay() )
end

local getSumPrice = function()
	local cartListCount = getIngameCashMall():getCartListCount()

	local sumPrice = toInt64(0,0)
	
	for index = 0 , cartListCount -1 do
		local selectItem = getIngameCashMall():getCartItemByIndex(index)
		selectItem:applySelectedItem()

		sumPrice = sumPrice + selectItem:getSelectedItemPrice() * toInt64(0, selectItem:getCount())
	end

	return sumPrice
end

local changePearIcon = function( pearIconUI, cashProductSSW )
	local serviceContry 	= nil
	local iconType			= nil
	local categoryIdx		= cashProductSSW:getCategory()
	local isEnableSilver	= cashProductSSW:isMoneyPrice()
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
	cashIcon_changeTextureForList( pearIconUI, serviceContry, iconType )
end

local updateUI = function( uiGroup, selectItem, uiSlot )
	local cashProductSSW = selectItem:getCashProductStaticStatus()
	local count = selectItem:getCount()

	selectItem:applySelectedItem()

	local iconUI		= uiGroup[2]
	local prductNameUI	= uiGroup[3]
	local discountMsgUI = uiGroup[4]
	local priceUI		= uiGroup[5]
	local pearIconUI	= uiGroup[6]
	local countEditUI	= uiGroup[7]
	
	prductNameUI:SetTextMode( CppEnums.TextMode.eTextMode_LimitText )
	discountMsgUI:SetTextMode( CppEnums.TextMode.eTextMode_LimitText )

	iconUI:ChangeTextureInfoName( "icon/" .. cashProductSSW:getIconPath() )
	iconUI:SetIgnore( false )
	iconUI:addInputEvent("Mouse_On", "InGameShop_CartProductShowToolTip( " .. cashProductSSW:getNoRaw() .. ", " .. uiSlot .. " )")
	iconUI:addInputEvent("Mouse_Out", "FGlobal_CashShop_GoodsTooltipInfo_Close()")
	
	prductNameUI:SetText(cashProductSSW:getDisplayName())	-- 디스플레이명으로 교체

	local originalPrice = cashProductSSW:getOriginalPrice() * toInt64(0, count)
	local price = selectItem:getSelectedItemPrice() * toInt64(0, count)
	if ( selectItem:isDiscountApplied() ) then
		local remainTime = convertStringFromDatetime(cashProductSSW:getRemainDiscountTime())
		-- local   remainTime = "Modify me"

		discountMsgUI:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_DISCOUNT", "endDiscountTime", remainTime) )-- "<PAColor0xfface400>할인 기간 : " .. endDiscountTime .. "까지<PAOldColor>" 
		discountMsgUI:SetShow(true)
		priceUI:SetText( makeDotMoney(originalPrice) .. "→" .. makeDotMoney(price) )
	else
		discountMsgUI:SetText( cashProductSSW:getDescription() )
		discountMsgUI:SetShow(true)
		priceUI:SetText( makeDotMoney(price) )
	end

	-- { 정액 서버용 펄 아이콘 처리
		changePearIcon( pearIconUI, cashProductSSW )
	-- }

	countEditUI:SetText(tostring(count))
end


--------------------------------------------------------------------------------
-- member function
function CashShopCart:initialize( gapY )
	CashShopCart._defaultUI = {
		[0]  = { 
			_name = "TemplateCart_Static_GoodsBG",				
			_type = CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC,		
			_owner = nil,	
			_lDownCallFunc = function( self, index )
				--
			end,
		},
		[1]  = { 
			_name = "TemplateCart_Static_SlotBG",				
			_type = CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC,		
			_owner = 0,		
		},
		[2]  = { 
			_name = "TemplateCart_Static_Slot",				
			_type = CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC,		
			_owner = 0,		
		},
		[3]  = { 
			_name = "TemplateCart_StaticText_ItemName",		
			_type = CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT,	
			_owner = 0,		
		},
		[4]  = { 
			_name = "TemplateCart_StaticText_DiscountPeriod",	
			_type = CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT,	
			_owner = 0,		
		},
		[5]  = { 
			_name = "TemplateCart_StaticText_ItemPrice",		
			_type = CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT,	
			_owner = 0,		
		},
		[6]  = { 
			_name = "TemplateCart_Static_PearlIcon",			
			_type = CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC,		
			_owner = 0,		
		},
		[7]  = { 
			_name = "TemplateCart_EditProductCount",			
			_type = CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_EDIT,			
			_owner = 0,		
			_lDownCallFunc = function( self, index )
				CashShopCart:OnEditInputMode(index)
			end,
			_lUpCallFunc = function( self, index )
				CashShopCart:OnEditInputMode(index)
			end,
		},
		[8]  = { 
			_name = "TemplateCart_Button_CountPlus",			
			_type = CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON,		
			_owner = 0,		
			_lUpCallFunc = function( self, index )
				CashShopCart:countUp(index)
			end,
		},
		[9]  = { 
			_name = "TemplateCart_Button_CountMinus",			
			_type = CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON,		
			_owner = 0,		
			_lUpCallFunc = function( self, index )
				CashShopCart:countDown(index)
			end,
		},
		[10] = { 
			_name = "TemplateCart_Button_DeleteItem",			
			_type = CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON,		
			_owner = 0,		
			_lUpCallFunc = function( self, index )
				CashShopCart:countErase(index)
			end,
		},
	}


	for key, value in pairs(self._defaultUI) do
		value._ui = UI.getChildControl(Panel_IngameCashShop_NewCart, value._name)
		if ( nil ~= value._owner ) then
			value._diffY = value._ui:GetPosY() - self._defaultUI[ value._owner ]._ui:GetPosY()
		else
			value._diffY = 0
		end
	end


	local offset = 0
	for index = 0, self._makeSlotCount -1 do
		self._uiData[index] = {}
		local uiGroup = self._uiData[index]
		for key, value in pairs( self._defaultUI ) do
			local original = value._ui
			local ownerControl = Panel_IngameCashShop_NewCart
			if ( nil ~= value._owner ) then
				ownerControl = uiGroup[value._owner]
			end


			local copyControl = UI.createControl(value._type, ownerControl, value._name .. "_" .. tostring(index) )
			CopyBaseProperty( original, copyControl )
			copyControl:SetShow(true)
			copyControl:SetIgnore(false)
			if ( nil ~= value._owner ) then
				copyControl:SetPosY( value._diffY )
			else
				copyControl:SetPosX(0)
				copyControl:SetPosY(offset)
				offset = offset + gapY
			end

			if 8 == key or 9 == key then	-- +,- 버튼이면!
				copyControl:SetAutoDisableTime(0)
			elseif 7 == key then			-- 입력칸에 5자 이상 입력 금지.
				copyControl:SetNumberMode( true )
				copyControl:SetMaxInput( 5 )
				copyControl:RegistReturnKeyEvent( "FGlobal_EscapeEditBox_IngameCashShop_NewCart( true )" )
			end


			copyControl:SetIgnore((nil ~= value._owner) and ( nil == value._lDownCallFunc ) and ( nil == value._lUpCallFunc ))
			copyControl:addInputEvent("Mouse_UpScroll",			"FGlobal_Scroll_IngameCashShop_NewCart( -1 )")
			copyControl:addInputEvent("Mouse_DownScroll",		"FGlobal_Scroll_IngameCashShop_NewCart(  1 )")
			copyControl:addInputEvent("Mouse_LUp",				"FGlobal_LUp_IngameCashShop_NewCart(" .. tostring(key) .. "," .. tostring(index) ..")")

			uiGroup[key] = copyControl
		end
	end

	Panel_IngameCashShop_NewCart:SetChildIndex(self._scroll, 9999 ) 
	Panel_IngameCashShop_NewCart:addInputEvent("Mouse_UpScroll",		"FGlobal_Scroll_IngameCashShop_NewCart( -1 )")
	Panel_IngameCashShop_NewCart:addInputEvent("Mouse_DownScroll",		"FGlobal_Scroll_IngameCashShop_NewCart(  1 )")

	for key, value in pairs(self._defaultUI) do
		value._ui:SetShow( false )
	end
end

function CashShopCart:registEventHandler()
	self._button_BuyAll			:addInputEvent(	"Mouse_LUp",		"InGameShop_CartBuyAll()" 					)
	self._button_CartClear		:addInputEvent(	"Mouse_LUp",		"InGameShop_CartClear()" 					)
	self._button_CartClose		:addInputEvent(	"Mouse_LUp",		"FGlobal_Close_IngameCashShop_NewCart()" 	)
end


function CashShopCart:SetPosition( posX, posY, sizeY, gapY ) -- , topIcon, bottomIcon
	Panel_IngameCashShop_NewCart:SetPosX( posX )
	Panel_IngameCashShop_NewCart:SetPosY( posY )
	Panel_IngameCashShop_NewCart:SetSize( Panel_IngameCashShop_NewCart:GetSizeX(), sizeY )

	self._button_CartClear			:ComputePos()
	self._button_BuyAll				:ComputePos()
	self._button_CartClose			:ComputePos()
	self._static_PearlBox			:ComputePos()
	self._static_NowPearlIcon		:ComputePos()
	self._staticText_TotalCount		:ComputePos()
	self._staticText_NowPearlCount	:ComputePos()

	self._remainSizeY	= sizeY - (self._static_PearlBox:GetSpanSize().y + self._static_PearlBox:GetSizeY() )
end

function CashShopCart:SetScroll()
	self._scroll:SetSize( self._scroll:GetSizeX(), self._remainSizeY )
	local cartListCount = getIngameCashMall():getCartListCount()

	local scrollSizeY		= self._scroll:GetSizeY()
	local pagePercent		= (self._maxShowSlotCount / cartListCount) * 100
	local btn_scrollSizeY	= ( scrollSizeY / 100 ) * pagePercent

	if btn_scrollSizeY < 10 then
		btn_scrollSizeY = 10
	end

	if scrollSizeY <= btn_scrollSizeY then
		btn_scrollSizeY = scrollSizeY * 0.99
	end

	self._scrollBTN:SetSize( self._scrollBTN:GetSizeX(), btn_scrollSizeY )

	if self._maxShowSlotCount < cartListCount then
		self._scroll:SetShow( true )
	else
		self._scroll:SetShow( false )
	end
	self._scroll:SetInterval( (cartListCount - self._maxShowSlotCount) )
	self._scroll:SetControlTop()
end

function CashShopCart:open()
	local scrSizeY			= getScreenSizeY()
	local remainingSizeY	= self._remainSizeY
	local possiableList		= math.floor(remainingSizeY / (self._uiData[0][0]:GetSizeY() + ( self._uiData[1][0]:GetPosY() - self._uiData[0][0]:GetPosY() - self._uiData[1][0]:GetSizeY() )))
	self._maxShowSlotCount	= possiableList

	Panel_IngameCashShop_NewCart:SetShow( true, false )
	self:SetScroll()
	self:fillSlots()
end

function CashShopCart:close()
	Panel_IngameCashShop_NewCart:SetShow( false, false )
end

function CashShopCart:fillSlots()
	local cartListCount = getIngameCashMall():getCartListCount()

	local uiSlot = 0
	for index = self._currentSlotIndex , cartListCount -1 do
		local selectItem = getIngameCashMall():getCartItemByIndex(index)
		if ( nil == selectItem ) then
			break
		end

		local uiGroup = self._uiData[uiSlot]
		updateUI( uiGroup, selectItem, uiSlot )
		if ( uiSlot == self._activeEditBoxRow ) and ( nil ~= _activeEditBoxUI ) then
			FGlobal_EscapeEditBox_IngameCashShop_NewCart(false)
		end


		uiSlot = uiSlot +1
		if ( self._maxShowSlotCount <= uiSlot ) then
			break
		end
	end

	for index = 0, self._makeSlotCount - 1 do
		local uiGroup = self._uiData[index]
		for key, value in pairs( uiGroup ) do
			if ( nil ~= self._defaultUI[key]._owner ) then
				value:SetShow( index < uiSlot )
			else
				value:SetShow( index < self._maxShowSlotCount )
			end
		end
	end

	-- { 정액 서버용 펄 아이콘 처리
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
		cashIcon_changeTextureForList( self._static_NowPearlIcon, serviceContry, iconType )
	-- }
	self._staticText_NowPearlCount:SetText( makeDotMoney(getSumPrice()) )
end

function CashShopCart:pushCart( productNoRaw, count )
	local isSuccess = getIngameCashMall():pushProductInCart(productNoRaw, count)
	if ( false == isSuccess ) then
		return
	end

	if ( false == Panel_IngameCashShop_NewCart:IsShow() ) then
		return
	end

	CashShopCart:fillSlots()
end

function CashShopCart:setCart( productNoRaw, count )
	local isSuccess = getIngameCashMall():setProductInCart(productNoRaw, count)
	if ( false == isSuccess ) then
		return
	end

	if ( false == Panel_IngameCashShop_NewCart:IsShow() ) then
		return
	end

	CashShopCart:fillSlots()
end

function CashShopCart:Scrolling( value )
	self._scroll:SetCtrlPosByInterval( value )
	local cartListCount = getIngameCashMall():getCartListCount()

	if ( cartListCount < self._maxShowSlotCount ) then
		self._currentSlotIndex = 0
	else
		self._currentSlotIndex = self._currentSlotIndex + value
		if ( self._currentSlotIndex < 0 ) then
			self._currentSlotIndex = 0
		elseif ( cartListCount <= self._currentSlotIndex + self._maxShowSlotCount ) then
			self._currentSlotIndex = cartListCount - self._maxShowSlotCount
		end
	end

	if ( false == Panel_IngameCashShop_NewCart:IsShow() ) then
		return
	end

	CashShopCart:fillSlots()
	InGameShop_UpdateCartButton()
end

function CashShopCart:countUp( index )
	local selectedItem = getIngameCashMall():getCartItemByIndex(self._currentSlotIndex + index)
	if ( nil == selectedItem ) then
		return
	end
	
	local prodcutNoRaw = selectedItem:getCashProductStaticStatus():getNoRaw()
	getIngameCashMall():pushProductInCart(prodcutNoRaw, 1)

	-- -- 해당 가격을 + 한다.
	-- self._uiData[index][6]:

	if ( false == Panel_IngameCashShop_NewCart:IsShow() ) then
		return
	end
	CashShopCart:Scrolling(0)
end

function CashShopCart:countDown(index)  
	local selectedItem = getIngameCashMall():getCartItemByIndex(self._currentSlotIndex + index)
	if ( nil == selectedItem ) then
		return
	end

	if ( selectedItem:getCount() -1 <= 0 ) then
		return
	end

	local prodcutNoRaw = selectedItem:getCashProductStaticStatus():getNoRaw()
	getIngameCashMall():popProductInCart(prodcutNoRaw, 1)

	if ( false == Panel_IngameCashShop_NewCart:IsShow() ) then
		return
	end
	CashShopCart:Scrolling(0)
end

function CashShopCart:countErase(index)
	local selectedItem = getIngameCashMall():getCartItemByIndex(self._currentSlotIndex + index)
	if ( nil == selectedItem ) then
		return
	end

	local prodcutNoRaw = selectedItem:getCashProductStaticStatus():getNoRaw()
	getIngameCashMall():popProductInCartAllCount(prodcutNoRaw)

	if ( false == Panel_IngameCashShop_NewCart:IsShow() ) then
		return
	end

	CashShopCart:fillSlots()
	CashShopCart:Scrolling(0)
end

function CashShopCart:OnEditInputMode(index)
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
	self._activeEditBoxUI = self._uiData[index][7]
	SetFocusEdit( self._activeEditBoxUI )
	self._activeEditBoxUI:SetEditText("")
	self._activeEditBoxRow = index
end

function CashShopCart:OutEditInputMode(isOkay)
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
	local selectItem = getIngameCashMall():getCartItemByIndex(self._currentSlotIndex + self._activeEditBoxRow)
	if ( isOkay ) then
		local productNoRaw = selectItem:getCashProductStaticStatus():getNoRaw()
		self:setCart( productNoRaw, tonumber(self._activeEditBoxUI:GetEditText()) )
	end
	if ( nil == self._activeEditBoxUI ) or ( self._activeEditBoxRow < 0 ) then
		return
	end
	self._activeEditBoxUI:SetEditText("")
	local uiGroup = self._uiData[self._activeEditBoxRow]
	self._activeEditBoxUI = nil
	self._activeEditBoxRow = -1
	ClearFocusEdit( nil )

	updateUI( uiGroup, selectItem, self._activeEditBoxRow )
end

function InGameShop_CartProductShowToolTip( NoRaw, uiSlot )
	local self = CashShopCart
	local icon = self._uiData[uiSlot][2]
	FGlobal_CashShop_GoodsTooltipInfo_Open( NoRaw, icon )
end

function	InGameShop_CartBuyAll()
	FGlobal_IngameCashShop_MakePaymentsFromCart_Open()
	-- getIngameCashMall():requestBuyCart()
end

function InGameShop_CartClear()
	getIngameCashMall():clearCart()
	CashShopCart:fillSlots()
	CashShopCart:Scrolling(0)
end


--------------------------------------------------------------------------------
-- global function

function FGlobal_Open_IngameCashShop_NewCart()
	CashShopCart:open()
end

function FGlobal_Close_IngameCashShop_NewCart()
	CashShopCart:close()
	FGlobal_EscapeEditBox_IngameCashShop_NewCart(false)
end

function FGlobal_IsShow_IngameCashShop_NewCart()
	return Panel_IngameCashShop_NewCart:IsShow()
end

function FGlobal_Update_IngameCashShop_NewCart()
	if ( false == Panel_IngameCashShop_NewCart:IsShow() ) then
		return
	end

	CashShopCart:Scrolling(0)
end

function FGlobal_PushCart_IngameCashShop_NewCart( productNoRaw, count )
	CashShopCart:pushCart( productNoRaw, count )
	InGameShop_UpdateCartButton()
	FGlobal_Update_IngameCashShop_CartEffect()	-- 이팩트 빤짝!!
	FGlobal_Update_IngameCashShop_NewCart()
end

function FGlobal_Scroll_IngameCashShop_NewCart( value )
	if ( false == Panel_IngameCashShop_NewCart:IsShow() ) then
		return
	end
	CashShopCart:Scrolling( value )
end

function FGlobal_LDown_IngameCashShop_NewCart( uicategoryIndex, rowIndex )
	if ( nil ~= CashShopCart._defaultUI[uicategoryIndex]._lDownCallFunc ) then
		CashShopCart._defaultUI[uicategoryIndex]:_lDownCallFunc(rowIndex)
	end
end

function FGlobal_LUp_IngameCashShop_NewCart( uicategoryIndex, rowIndex )
	if ( nil ~= CashShopCart._defaultUI[uicategoryIndex]._lUpCallFunc ) then
		CashShopCart._defaultUI[uicategoryIndex]:_lUpCallFunc(rowIndex)
	end
end

function FGlobal_CheckEditBox_IngameCashShop_NewCart( uiEditBox )
	return ( nil ~= uiEditBox ) and ( nil ~= CashShopCart._activeEditBoxUI ) and ( uiEditBox:GetKey() == CashShopCart._activeEditBoxUI:GetKey() )
end

function FGlobal_EscapeEditBox_IngameCashShop_NewCart( isOkay )
	CashShopCart:OutEditInputMode(isOkay)
	ClearFocusEdit()
end

function FGlobal_Init_IngameCashShop_NewCart( gapY )
	CashShopCart:initialize( gapY )
	registerEvent("FromClient_NotifyCompleteBuyProduct",				"FromClient_NotifyCompleteBuyProduct" )
end

function FGlobal_InitPos_IngameCashShop_NewCart( startPosX, startPosY, sizeY, gapY )
	CashShopCart:SetPosition( startPosX, startPosY - gapY, sizeY + gapY, gapY )

end

--------------------------------------------------------------------------------
-- event handler

function FromClient_NotifyCompleteBuyProduct( productNoRaw, isGift, toCharacterName, buyItemReqTrType )
	FGlobal_Update_IngameCashShop_NewCart()
	InGameShop_UpdateCartButton()
	
	local	cashProduct	= getIngameCashMall():getCashProductStaticStatusByProductNoRaw(productNoRaw)
	if	( nil ~= cashProduct )	then
		--UI.debugMessage( tostring(cashProduct:getDisplayName()) )
	end
end

local cumulatedTime = 0
function IngameCashShop_NewCartDiscount( deltaTime )
	local self = CashShopCart
	cumulatedTime = cumulatedTime + deltaTime
	if( 1.0 < cumulatedTime ) then
		cumulatedTime = 0
		local cartListCount = getIngameCashMall():getCartListCount()
		local uiSlot = 0
		for index = self._currentSlotIndex , cartListCount -1 do
			local selectItem = getIngameCashMall():getCartItemByIndex(index)
			if ( nil == selectItem ) then
				break
			end
			local uiGroup = self._uiData[uiSlot]
			local cashProductSSW = selectItem:getCashProductStaticStatus()

			selectItem:applySelectedItem()

			local discountMsgUI = uiGroup[4]
			local pearIconUI	= uiGroup[6]
			if ( selectItem:isDiscountApplied() ) then
				local   remainTime = convertStringFromDatetime(cashProductSSW:getRemainDiscountTime())

				discountMsgUI:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_DISCOUNT", "endDiscountTime", remainTime) )-- "<PAColor0xfface400>할인 기간 : " .. endDiscountTime .. "까지<PAOldColor>" 
				discountMsgUI:SetShow(true)
			else
				discountMsgUI:SetText( cashProductSSW:getDescription() )
				discountMsgUI:SetShow(true)
			end

			changePearIcon( pearIconUI, cashProductSSW )
			uiSlot = uiSlot +1
			if ( self._maxShowSlotCount <= uiSlot ) then
				break
			end
		end
	end
end

CashShopCart:registEventHandler()
Panel_IngameCashShop_NewCart:RegisterUpdateFunc("IngameCashShop_NewCartDiscount")