local UI_color	= Defines.Color
local UI_TM		= CppEnums.TextMode

Panel_Window_ItemMarket_RegistItem:SetShow( false )
Panel_Window_ItemMarket_RegistItem:setGlassBackground( true )
Panel_Window_ItemMarket_RegistItem:ActiveMouseEventEffect( true )

local ItemMarketRegistItem  = {
	slotConfig =
		{
			createIcon			= true,
			createBorder		= true,
			createCount			= true,
			createEnchant		= true,
			createCash			= true,
		},

	btn_Close					= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"Button_Win_Close"),
	btn_Cancle					= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"Button_Cancle"),
	btn_Confirm					= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"Button_Confirm"),

	slotBG						= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"Static_SlotBG"),
	itemName					= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"StaticText_ItemName"),
	priceEdit					= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"Edit_SellPrice"),
	btn_MinPrice				= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"Button_MinPrice"),
	btn_MaxPrice				= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"Button_MaxPrice"),
	btn_CheckPrice				= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"Button_CheckSum"),
	SellSumPrice				= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"StaticText_SellSumPriceValue"),
	sellItemTitle				= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"StaticText_SubTitle1"),
	
	
	averagePriceIcon			= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"Static_AveragePrice_TitleIcon"),
	recentPriceIcon				= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"Static_RecentPrice_TitleIcon"),
	maxPriceIcon				= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"Static_MaxPrice_TitleIcon"),
	minPriceIcon				= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"Static_MinPrice_TitleIcon"),
	registHighPriceIcon			= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"Static_RegistHighPrice_TitleIcon"),
	registLowPriceIcon			= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"Static_RegistLowPrice_TitleIcon"),
	registListCountIcon			= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"Static_RegistListCount_TitleIcon"),
	registItemCountIcon			= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"Static_RegistItemCount_TitleIcon"),

	guideText					= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"StaticText_GuideText"),

	titleText					= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"StaticText_Title" ),				-- 창 제목
	averagePrice_Value			= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"StaticText_AveragePrice_Value"),	-- 거래 평균가
	recentPrice_Value			= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"StaticText_RecentPrice_Value"),	-- 최근 거래가
	max_Value					= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"StaticText_Max_Value"),			-- 상한가
	minPrice_Value				= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"StaticText_MinPrice_Value"),		-- 하한가
	registHighPrice_Value		= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"StaticText_RegistHighPrice_Value"),-- 등록 최고가
	registLowPrice_Value		= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"StaticText_RegistLowPrice_Value"),	-- 등록 최저가
	registListCount_Value		= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"StaticText_RegistListCount_Value"),-- 등록 건수
	registItemCount_Value		= UI.getChildControl( Panel_Window_ItemMarket_RegistItem,	"StaticText_RegistItemCount_Value"),-- 등록 개수

	_buttonQuestion 			= UI.getChildControl( Panel_Window_ItemMarket_RegistItem, 	"Button_Question" ),		-- 물음표 버튼

	itemSlot					= {},
	_invenWhereType				= 0,
	_invenSlotNo				= 0,
	_registerCount				= 0,
	_minPrice					= 0,
	_maxPrice					= 0,
	_isByMaid					= false,
	_priceCheck					= false,
	_isAblePearlProduct			= false,	
}
local territoryKey =
{
	[0]	= tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_0")),		-- 발레노스령
	[1] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_1")),		-- 세렌디아령
	[2] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_2")),		-- 칼페온령
	[3] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_3")),		-- 메디아령
}

function ItemMarketRegistItem:Initialize()
	self.priceEdit:SetNumberMode()
	self.priceEdit:SetMaxInput(13)
	
	SlotItem.new( self.itemSlot, 'ItemMarketRegistItem_Icon', 0, self.slotBG, self.slotConfig )
	self.itemSlot:createChild()

	self._isAblePearlProduct = requestCanRegisterPearlItemOnMarket()
end
function ItemMarketRegistItem:SetPostion()
	local scrSizeX      = getScreenSizeX()
	local scrSizeY      = getScreenSizeY()
	local panelSizeX    = Panel_Window_ItemMarket_RegistItem:GetSizeX()
	local panelSizeY    = Panel_Window_ItemMarket_RegistItem:GetSizeY()

	Panel_Window_ItemMarket_RegistItem:SetPosX( (scrSizeX / 2) - (panelSizeX / 2) )
	Panel_Window_ItemMarket_RegistItem:SetPosY( (scrSizeY / 2) - (panelSizeY / 2) )
end

function ItemMarketRegistItem:Clear()
	local self = ItemMarketRegistItem
	local emptyText = nil
	emptyText = ""

	self.priceEdit				:SetEditText( emptyText, true )
	self.priceEdit				:SetNumberMode( true )
	self.averagePrice_Value		:SetText( "0" )		
	self.recentPrice_Value		:SetText( "0" )			
	self.max_Value				:SetText( "0" )					
	self.minPrice_Value			:SetText( "0" )				
	self.registHighPrice_Value	:SetText( "0" )		
	self.registLowPrice_Value	:SetText( "0" )		
	self.registListCount_Value	:SetText( "0" )		
	self.registItemCount_Value	:SetText( "0" )
	self.SellSumPrice			:SetText( "" )

	self._invenWhereType= -1
	self._invenSlotNo	= -1
end

function ItemMarketRegistItem:Update()
	local self = ItemMarketRegistItem

	local registedItemCount = getItemMarketMyItemsCount()
	self.sellItemTitle:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_ENABLE_REGISTCOUNT", "itemCount", (30 - registedItemCount) ) )	-- - 판매 아이템({itemCount} 건 등록 가능)

	local itemWrapper = nil
	if CppEnums.ItemWhereType.eInventory == self._invenWhereType or CppEnums.ItemWhereType.eCashInventory == self._invenWhereType then
		itemWrapper 	= getInventoryItemByType( self._invenWhereType, self._invenSlotNo )
	elseif CppEnums.ItemWhereType.eWarehouse == self._invenWhereType then
		local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
		if nil == regionInfo then
			return
		end
		local regionInfoWrapper = getRegionInfoWrapper( regionInfo:getAffiliatedTownRegionKey() )		-- 내가 있는 곳의 소속 영지 래퍼
		local regionKey = regionInfoWrapper:getPlantKeyByWaypointKey():getWaypointKey()					-- 소속 영지의 웨이포인트키
		local	warehouseWrapper	= warehouse_get( regionKey )
		itemWrapper			= warehouseWrapper:getItem( self._invenSlotNo )
	end

	if( nil == itemWrapper ) then
		_PA_ASSERT( false, "itemWrapper 없습니다. 비정상입니다." );
		return 
	end
	
	local itemSS		= itemWrapper:getStaticStatus()	
	
	local summaryInfo 	= getItemMarketSummaryInClientByItemEnchantKey( itemSS:get()._key:get() )
	local masterInfo	= getItemMarketMasterByItemEnchantKey( itemSS:get()._key:get() )
	if( nil == summaryInfo or nil == masterInfo ) then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_NOREGISTITEM_ACK") ); -- "등록할 수 없는 아이템입니다."
		return;
	end

	local registHighPrice	= summaryInfo:getDisplayedHighestOnePrice() -- 등록 최고가
	local registLowPrice	= summaryInfo:getDisplayedLowestOnePrice()	-- 등록 최저가
	local marketConditions	= (masterInfo:getMinPrice() + masterInfo:getMaxPrice()) / toInt64(0,2)	-- 시세
	local recentPrice		= summaryInfo:getLastTradedOnePrice()		-- 최근 거래가
	local registListCount	= summaryInfo:getTradedTotalAmount()		-- 거래된 아이템 갯수
	local registItemCount	= summaryInfo:getDisplayedTotalAmount()		-- 등록 아이템 갯수
	local itemMaxPrice		= masterInfo:getMaxPrice()					-- 아이템 상한가
	local itemMinPrice		= masterInfo:getMinPrice()					-- 아이템 하한가
	self._minPrice			= masterInfo:getMinPrice()
	self._maxPrice			= masterInfo:getMaxPrice()

	self.itemSlot.icon:addInputEvent("Mouse_On",	"_ItemMarketRegistItem_ShowToolTip( " .. self._invenSlotNo .. ", " .. self._invenWhereType .. " )")
	self.itemSlot.icon:addInputEvent("Mouse_Out",	"_ItemMarketRegistItem_HideToolTip()")

	local replaceCount = function( num )
		local count = Int64toInt32( num )
		if 0 == count then
			count = "-"
		else
			count = makeDotMoney( num )
		end
		return count
	end

	self.registHighPrice_Value	:SetText( replaceCount( registHighPrice ) )
	self.registLowPrice_Value	:SetText( replaceCount( registLowPrice ) )
	self.averagePrice_Value		:SetText( replaceCount( marketConditions ) )
	self.recentPrice_Value		:SetText( replaceCount( recentPrice ) )
	self.registListCount_Value	:SetText( replaceCount( registListCount ) )
	self.registItemCount_Value	:SetText( replaceCount( registItemCount ) )

	self.max_Value				:SetText( makeDotMoney( itemMaxPrice ) )
	self.minPrice_Value			:SetText( makeDotMoney( itemMinPrice ) )

	-- 거래소 선택된 아이템의 최근 거래가가 있다면 개당 가격입력란에 최근 거래가를
	----------------------------------------없다면 상한가와 하한가 중간 가격을 입력해준다.

	local highAndLowAvgPrice = ( masterInfo:getMaxPrice() + masterInfo:getMinPrice()) / toInt64(0, 2)
	if toInt64(0,0) < recentPrice then
		self.priceEdit:SetEditText( tostring(recentPrice), true )
	end
	
	-- 상한가보다 최근거래가가 낮으면 상한가와 하한가의 중간값을 적어준다.
	if ( itemMaxPrice  <  recentPrice ) or ( recentPrice  <  itemMinPrice ) then
		self.priceEdit:SetEditText( tostring(highAndLowAvgPrice), true )
	end
end

function ItemMarketRegistItem:RegistDO()
	if( (-1 == self._invenWhereType) or	( -1 == self._invenSlotNo ) ) then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_REGISTITEM_ACK") ) -- "아이템을 등록해 주세요"
		return;
	end
		
	local pricePerOne = nil
	pricePerOne = tonumber64( self.priceEdit:GetEditText() )
	
	if( nil == pricePerOne or  pricePerOne <= toInt64(0,0) ) then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_PERITEMPRICE_ACK") ) -- "개당 가격을 입력해주세요"
		return;
	end

	local self = ItemMarketRegistItem
	
	local itemWrapper = nil
	if CppEnums.ItemWhereType.eInventory == self._invenWhereType or CppEnums.ItemWhereType.eCashInventory == self._invenWhereType then
		itemWrapper 	= getInventoryItemByType( self._invenWhereType, self._invenSlotNo )
	elseif CppEnums.ItemWhereType.eWarehouse == self._invenWhereType then
		local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
		if nil == regionInfo then
			return
		end
		local regionInfoWrapper = getRegionInfoWrapper( regionInfo:getAffiliatedTownRegionKey() )		-- 내가 있는 곳의 소속 영지 래퍼
		local regionKey = regionInfoWrapper:getPlantKeyByWaypointKey():getWaypointKey()					-- 소속 영지의 웨이포인트키
		local	warehouseWrapper	= warehouse_get( regionKey )
		itemWrapper			= warehouseWrapper:getItem( self._invenSlotNo )
	end

	if( nil == itemWrapper ) then
		_PA_ASSERT( false, "itemWrapper 없습니다. 비정상입니다." );
		return 
	end
	
	local itemSS		= itemWrapper:getStaticStatus()	
	local masterInfo	= getItemMarketMasterByItemEnchantKey( itemSS:get()._key:get() )
	if ( masterInfo:getMaxPrice() < pricePerOne ) or ( masterInfo:getMinPrice() > pricePerOne ) then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_ERRORPRICE_ACK") ) -- "비정상적인 가격입니다. 가격을 다시 등록해주세요"
		return
	end
	
	local doBroadCast	= requestDoBroadcastRegister( pricePerOne )
	if doBroadCast then
		local messageBoxTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_MESSAGEBOX_ALERT")
		local messageBoxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_CANCELITEM_MSGBOX") -- "해당 아이템은 등록 게시 후 5분간 취소할 수 없습니다.\n등록 하시겠습니까?"
		local messageBoxData = { title = messageBoxTitle, content = messageBoxMemo, functionYes = ItemMarketItemSet_RegistDo_FromDoBroadcast, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData, "top")
		return
	end
	
	-- 캐쉬아이템이면 2차 비번을 입력하게 한다.
	if( itemWrapper:isCash() ) then -- CppEnums.ItemWhereType.eCashInventory == self._invenWhereType
		PaymentPassword(ItemMarketItemSet_RegistDo_FromPaymentPassword)
	else
		if self._isByMaid then
			local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
			if nil == regionInfo then
				return
			end
			
			if checkMaid_SubmitMarket(true) then
				requestRegisterItemForItemMarketByMaid( self._invenWhereType, self._invenSlotNo, self._registerCount, pricePerOne )
			else
				Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_COOLTIME")) -- "재사용 대기중입니다." )
				return
			end
		else
			requestRegisterItemForItemMarket( self._invenWhereType, self._invenSlotNo, self._registerCount, pricePerOne )
		end
		self._priceCheck = false	-- 체크 여부를 리셋한다.

		itemMarket_afterRegist()
	end
end

function itemMarket_afterRegist()
	local self = ItemMarketRegistItem
	-- if not Panel_Window_Warehouse:GetShow() then
	-- 	Panel_Window_ItemMarket_RegistItem:SetShow( false )

	-- 	if Panel_Window_Inventory:GetShow() then
	-- 		InventoryWindow_Close()
	-- 	end
	-- 	FGlobal_ItemMarketItemSet_Open()
	-- else
		self.itemSlot.icon	:addInputEvent( "Mouse_On", "" )
		self.itemSlot.icon	:addInputEvent( "Mouse_Out", "" )
		self:Clear()						-- 정보 초기화 로컬 함수
		self.itemSlot		:clearItem()	-- 인벤 초기화.
		self.itemName		:SetTextMode( UI_TM.eTextMode_AutoWrap )
		self.itemName		:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_ITEMSELECT_TEXT") )
		ClearFocusEdit()

		local registedItemCount = getItemMarketMyItemsCount()
		self.sellItemTitle:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_ENABLE_REGISTCOUNT", "itemCount", (30 - registedItemCount) ) )	-- - 판매 아이템({itemCount} 건 등록 가능)
	-- end
end

function ItemMarketItemSet_RegistDo_FromDoBroadcast()
	local self = ItemMarketRegistItem
	
	local itemWrapper = nil
	if CppEnums.ItemWhereType.eInventory == self._invenWhereType or CppEnums.ItemWhereType.eCashInventory == self._invenWhereType then
		itemWrapper 	= getInventoryItemByType( self._invenWhereType, self._invenSlotNo )
	elseif CppEnums.ItemWhereType.eWarehouse == self._invenWhereType then
		local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
		if nil == regionInfo then
			return
		end
		local regionInfoWrapper = getRegionInfoWrapper( regionInfo:getAffiliatedTownRegionKey() )		-- 내가 있는 곳의 소속 영지 래퍼
		local regionKey = regionInfoWrapper:getPlantKeyByWaypointKey():getWaypointKey()					-- 소속 영지의 웨이포인트키
		local	warehouseWrapper	= warehouse_get( regionKey )
		itemWrapper			= warehouseWrapper:getItem( self._invenSlotNo )
	end

	if( nil == itemWrapper ) then
		_PA_ASSERT( false, "itemWrapper 없습니다. 비정상입니다." );
		return 
	end
	
	local pricePerOne = nil
	pricePerOne = tonumber( self.priceEdit:GetEditText() )
	
	if( itemWrapper:isCash() ) then -- CppEnums.ItemWhereType.eCashInventory == self._invenWhereType
		PaymentPassword(ItemMarketItemSet_RegistDo_FromPaymentPassword)
	else
		if self._isByMaid then
			local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
			if nil == regionInfo then
				return
			end
			
			if checkMaid_SubmitMarket(true) then
				requestRegisterItemForItemMarketByMaid( self._invenWhereType, self._invenSlotNo, self._registerCount, pricePerOne )
			else
				Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_COOLTIME")) -- "재사용 대기중입니다." )
				return
			end
		else
			requestRegisterItemForItemMarket( self._invenWhereType, self._invenSlotNo, self._registerCount, pricePerOne )
		end

		self._priceCheck = false	-- 체크 여부를 리셋한다.

		itemMarket_afterRegist()
	end
end

function ItemMarketItemSet_RegistDo_FromPaymentPassword()
	
	local self = ItemMarketRegistItem
	
	local pricePerOne = nil
	pricePerOne = tonumber( self.priceEdit:GetEditText() )
	
	if self._isByMaid then
		local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
		if nil == regionInfo then
			return
		end
		
		if checkMaid_SubmitMarket(true) then
			requestRegisterItemForItemMarketByMaid( self._invenWhereType, self._invenSlotNo, self._registerCount, pricePerOne )
		else
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_COOLTIME")) -- "재사용 대기중입니다." )
			return
		end
	else
		requestRegisterItemForItemMarket( self._invenWhereType, self._invenSlotNo, self._registerCount, pricePerOne )
	end
	
	self._priceCheck = false	-- 체크 여부를 리셋한다.
	
	itemMarket_afterRegist()
end
local savedConfirmPrice = 0
function _ItemMarketRegistItem_RegistDO()
	local self = ItemMarketRegistItem
	local onePrice	= self.priceEdit:GetEditText()
	local itemCount	= self._registerCount

	if not self._priceCheck then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_PERITEMPRICECONFIRM_ACK") ) -- "먼저 개당 가격 확인을 해야합니다." )
		return
	elseif "" == onePrice then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_ITEMSELECT_TEXT") ) -- "먼저 개당 가격 확인을 해야합니다." )
		return
	end

	local sumItemPrice = onePrice * itemCount
	if ( toUint64(0,savedConfirmPrice) ~= toUint64(0,sumItemPrice) ) then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKETREGIST_CONFIRMPRICE") ) -- 개당 가격을 다시 확인해주세요.
		-- return
	else
		ItemMarketRegistItem:RegistDO()
	end

	-- ItemMarketRegistItem:RegistDO()
end
function HandleClicked_ItemMarketRegistItem_RegistDO()
	_ItemMarketRegistItem_RegistDO()
end
function HandleClicked_ItemMarketRegistItem_EditReset()
	local self = ItemMarketRegistItem
	self.priceEdit:SetEditText("", true)
end
function HandleClicked_ItemMarketRegistItem_SellPriceMin()
	local self 			= ItemMarketRegistItem		
		
	self.priceEdit:SetEditText( tostring(self._minPrice), true )
end
function HandleClicked_ItemMarketRegistItem_SellPriceMax()
	local self 			= ItemMarketRegistItem		
		
	self.priceEdit:SetEditText( tostring(self._maxPrice), true )
end
function HandleClicked_ItemMarketRegistItem_SellPriceSum()
	local self		= ItemMarketRegistItem
	self._priceCheck = true	-- 체크했다.
	local onePrice	= self.priceEdit:GetEditText()
	local itemCount	= self._registerCount

	if nil == onePrice or "" == onePrice or 0 == onePrice then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_PERPRICE_ACK") ) -- "먼저 개당 가격을 입력해주세요."
		return
	end
	if nil == itemCount or 0 == itemCount then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_NOSELECTITEM_ACK") ) -- "아이템이 선탠되지 않았습니다."
		return
	end

	local sumItemPrice = onePrice * itemCount
	savedConfirmPrice = sumItemPrice
	self.SellSumPrice:SetText( makeDotMoney( sumItemPrice ) )
end

function FGlobal_ItemMarketRegistItem_RegistDO()
	_ItemMarketRegistItem_RegistDO()
end
function FGlobal_ItemMarketRegistItem_Open( isOpenWarehouse, isByMaid )
	local self = ItemMarketRegistItem	
	-- 영지 키 입력
	local regionInfoWrapper = getRegionInfoWrapper( getSelfPlayer():getRegionKeyRaw() )
	if (nil == regionInfoWrapper) then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_ERRORAREA_ACK") ) -- "플레이어의 현재위치가 비정상적입니다"
		return
	end	
	
	if isOpenWarehouse then
		requestItemMarketMyItems(true, true)
	end
	
	
	self.titleText:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_ITEMMODIFY_TEXT", "getItem", territoryKey[regionInfoWrapper:getTerritoryKeyRaw()] ) ) -- "물품 등록/수정 : " .. territoryKey[regionInfoWrapper:getTerritoryKeyRaw()]

	self._invenWhereType 	= -1
	self._invenSlotNo		= -1
	self._registerCount		=  0
	if isByMaid == nil then
		self._isByMaid		= false
	else
		self._isByMaid		= isByMaid
	end
	
	-- 인벤 슬롯과 아이템 이름은 꺼준다.
	self.itemName		:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_ITEMSELECT_TEXT") )

	self.itemSlot.icon	:SetShow( true )
	self.itemSlot.icon	:addInputEvent( "Mouse_On", "" )
	self.itemSlot.icon	:addInputEvent( "Mouse_Out", "" )

	self.slotBG			:SetShow( true )
	self.itemName		:SetShow( true )

	self:Clear()						-- 정보 초기화 로컬 함수
	self.itemSlot		:clearItem()	-- 인벤 초기화.
	ClearFocusEdit()

	--Panel_ItemMarket_CombineWindow_Close()
	FGlobal_ItemMarketItemSet_Close()
	ItemMarketRegistItem:SetPostion()	
	Panel_Window_ItemMarket_RegistItem:SetShow( true )

	local selfPlayer = getSelfPlayer();
	local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
	if (nil == regionInfoWrapper) then
		return
	end	
	
	local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(regionInfoWrapper:getAffiliatedTownRegionKey())
	if (nil == siegeWrapper) then
		return
	end	

	local isCountryTypeSet = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_GUIDETEXT2", "forPremium", requestGetRefundPercentForPremiumPackage() )
	if (5 == getGameServiceType() or 6 == getGameServiceType()) then
		isCountryTypeSet = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_GUIDETEXT2_JP", "pcRoom", requestGetRefundPercentForPcRoom() )
	else
		isCountryTypeSet = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_GUIDETEXT2", "forPremium", requestGetRefundPercentForPremiumPackage() )
	end

	local transferTaxRate = siegeWrapper:getTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket) --거래세
	self.guideText:SetText( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_GUIDETEXT", "feePercent", requestGetTradeFeePercent(), "transferTaxRate", transferTaxRate ) .. isCountryTypeSet )
	-- 인벤도 함께 열자.

	-- if nil == isOpenWarehouse then
		Inventory_SetFunctor( FGlobal_ItemMarket_InvenFilter_IsRegistItem, FGlobal_ItemMarket_InvenFilter_RClick, InventoryWindow_Close, nil  )
	if nil == isOpenWarehouse then
		Inventory_SetShow(true)
	end
	
	if (getScreenSizeX() / 2 ) < ( Panel_Window_Inventory:GetSizeX() + ( Panel_Window_ItemMarket_RegistItem:GetSizeX() / 2 ) ) then
		Panel_Window_ItemMarket_RegistItem:SetPosX( getScreenSizeX() - Panel_Window_Inventory:GetSizeX() - Panel_Window_ItemMarket_RegistItem:GetSizeX() )
	end

	local registedItemCount = getItemMarketMyItemsCount()
	self.sellItemTitle:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_ENABLE_REGISTCOUNT", "itemCount", (30 - registedItemCount) ) )	-- - 판매 아이템({itemCount} 건 등록 가능)
end

function FGlobal_ReturnIsByMaid()
	ItemMarketRegistItem._isByMaid = false
end

function FGlobal_ItemMarketRegistItem_Close( isItemMarketItemSet_Show )
	Panel_Window_ItemMarket_RegistItem:SetShow( false )
	ItemMarketRegistItem_SimpleToolTip( false )
	Inventory_SetFunctor( nil, nil, nil, nil )
	if ItemMarketRegistItem._isByMaid then
		if Panel_Window_Inventory:GetShow() then
			InventoryWindow_Close()
		end
		if Panel_Window_Warehouse:GetShow() then
			Warehouse_Close()
		end
		FGlobal_WarehouseOpenByMaid( 0 )	-- 0 : 거래소, 1 : 창고 | 거래소 기능이 남은 메이드가 있다면 거래소 창을 열고, 아니면 닫는다
		return
	end
	
	if not Panel_Window_Warehouse:GetShow() then
		if Panel_Window_Inventory:GetShow() then
			InventoryWindow_Close()
		end
		if (nil ~= isItemMarketItemSet_Show) and (true == isItemMarketItemSet_Show )then
			FGlobal_ItemMarketItemSet_Open()
		end
		_ItemMarketRegistItem_HideToolTip()
	else
		FGlobal_Warehouse_ResetFilter()
		Inventory_SetFunctor( nil, FGlobal_PopupMoveItem_InitByInventory, Warehouse_Close, nil )
		Panel_Window_Warehouse:SetVerticalMiddle()
		Panel_Window_Warehouse:SetHorizonCenter()
		Panel_Window_Warehouse:SetSpanSize(100,0)
	end
end
-- 등록 가능한 아이템인지 여부
function FGlobal_ItemMarket_InvenFilter_IsRegistItem(slotNo, itemWrapper, invenWhereType)
	if nil == itemWrapper then
		return true
	end

	local isAble = requestIsRegisterItemForItemMarket(itemWrapper:get():getKey())
	local itemBindType = itemWrapper:getStaticStatus():get()._vestedType:getItemKey()

	local isVested			= itemWrapper:get():isVested()
	local isPersonalTrade	= itemWrapper:getStaticStatus():isPersonalTrade()

	if (isUsePcExchangeInLocalizingValue()) then
		local isFilter = ( isVested and isPersonalTrade )
		if( isFilter ) then
			return isFilter
		end
	end

	if 2 == itemBindType then	--	 귀속 아이템 처리
		if true ~= itemWrapper:get():isVested() and isAble then -- 아직 귀속전템이며 등록가능한 아이템이라면
			isAble = true
		else
			isAble = false
		end
	end

	if itemWrapper:isCash() then
		if false == isAble and false == ItemMarketRegistItem._isAblePearlProduct then
			isAble = false
		else
			isAble = isAble and ItemMarketRegistItem._isAblePearlProduct
		end
	end

	return (not isAble);
end

-- 인벤토리 우클릭 아이템 등록
function FGlobal_ItemMarket_InvenFilter_RClick(slotNo, itemWrapper, s64_count, inventoryType)
	if(Defines.s64_const.s64_1 == s64_count) then
		FGlobal_ItemMarketRegistItemFromInventory(1, slotNo, inventoryType ) 
	else
		-- 최대 갯수는 마스터 정보의 갯수
		local masterInfo	= getItemMarketMasterByItemEnchantKey( itemWrapper:get():getKey():get() )
		if masterInfo ~= nil then
			if masterInfo:getMaxRegisterCount() < s64_count then
				s64_count = masterInfo:getMaxRegisterCount()
			end
		end
		
		Panel_NumberPad_Show(true, s64_count, slotNo,  FGlobal_ItemMarketRegistItemFromInventory, nil, inventoryType )
	end 
end

function FGlobal_ItemMarketRegistItemFromInventory(s64_count, slotNo, inventoryType)	--Panel_Window_Inventory.lua 에서 사용됨
	local self = ItemMarketRegistItem

	-- 아이템 슬롯에 꼽는다.
	local itemWrapper = nil
	if CppEnums.ItemWhereType.eInventory == inventoryType or CppEnums.ItemWhereType.eCashInventory == inventoryType then
		itemWrapper 	= getInventoryItemByType( inventoryType, slotNo )		
	elseif CppEnums.ItemWhereType.eWarehouse == inventoryType then
		local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
		if nil == regionInfo then
			return
		end
		local regionInfoWrapper = getRegionInfoWrapper( regionInfo:getAffiliatedTownRegionKey() )		-- 내가 있는 곳의 소속 영지 래퍼
		local regionKey = regionInfoWrapper:getPlantKeyByWaypointKey():getWaypointKey()					-- 소속 영지의 웨이포인트키
		local	warehouseWrapper	= warehouse_get( regionKey )
		itemWrapper			= warehouseWrapper:getItem( slotNo )
	end

	if( nil == itemWrapper ) then
		_PA_ASSERT( false, "itemWrapper 없습니다. 비정상입니다." );
		return 
	end
	local itemSS		= itemWrapper:getStaticStatus()
	local summaryInfo 	= getItemMarketSummaryInClientByItemEnchantKey( itemSS:get()._key:get() )
	if( nil == summaryInfo ) then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_REGISTERITEM_MESSAGE_1") ); -- "등록할 수 없는 아이템입니다."
		return;
	end
	
	local iconPath		= itemSS:getIconPath()
	-- 등록 버튼은 끄고, 인벤 슬롯과 아이템 이름은 켜준다.
	self.itemSlot		:setItemByStaticStatus( itemWrapper:getStaticStatus(), Int64toInt32( s64_count ) )

	local nameColorGrade	= itemSS:getGradeType()
	local nameColor			= nil
	if ( 0 == nameColorGrade ) then
		nameColor = UI_color.C_FFEFEFEF
	elseif ( 1 == nameColorGrade ) then
		nameColor = 4284350320
	elseif ( 2 == nameColorGrade ) then
		nameColor = 4283144191
	elseif ( 3 == nameColorGrade ) then
		nameColor = 4294953010
	elseif ( 4 == nameColorGrade ) then
		nameColor = 4294929408
	else
		nameColor = UI_color.C_FFFFFFFF
	end
	self.itemName:SetFontColor( nameColor )
	self.itemName:SetTextMode( UI_TM.eTextMode_AutoWrap )

	local enchantLevel = itemSS:get()._key:getEnchantLevel()
	if 1 == itemSS:getItemType() and 15 < enchantLevel then -- 장비이고, 강화수치가 14보다 크면
		self.itemName:SetText( HighEnchantLevel_ReplaceString(enchantLevel) .. " " .. itemSS:getName() )	-- 아이템 이름
	elseif 0 < enchantLevel and CppEnums.ItemClassifyType.eItemClassify_Accessory == itemSS:getItemClassify() then
		self.itemName:SetText( HighEnchantLevel_ReplaceString(enchantLevel+15) .. " " .. itemSS:getName() )	-- 아이템 이름
	else
		self.itemName:SetText( itemSS:getName() )															-- 아이템 이름
	end
	
	self._invenWhereType 	= 	inventoryType;
	self._invenSlotNo		= 	slotNo
	self._registerCount		=	Int64toInt32( s64_count )	
	
	self:Update();
end

function _ItemMarketRegistItem_ShowToolTip( slotNo, inventoryType )
	local self			= ItemMarketRegistItem

	local itemWrapper = nil
	if CppEnums.ItemWhereType.eInventory == inventoryType or CppEnums.ItemWhereType.eCashInventory == inventoryType then
		itemWrapper 	= getInventoryItemByType( inventoryType, slotNo )
	elseif CppEnums.ItemWhereType.eWarehouse == inventoryType then
		local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
		if nil == regionInfo then
			return
		end
		local regionInfoWrapper = getRegionInfoWrapper( regionInfo:getAffiliatedTownRegionKey() )		-- 내가 있는 곳의 소속 영지 래퍼
		local regionKey = regionInfoWrapper:getPlantKeyByWaypointKey():getWaypointKey()					-- 소속 영지의 웨이포인트키
		local	warehouseWrapper	= warehouse_get( regionKey )
		itemWrapper			= warehouseWrapper:getItem( slotNo )
	end

	-- local itemWrapper 	= getInventoryItemByType( inventoryType, slotNo )
	Panel_Tooltip_Item_Show( itemWrapper, self.itemSlot.icon, false, true, nil )
end
function _ItemMarketRegistItem_HideToolTip()
	Panel_Tooltip_Item_hideTooltip()
end

function ItemMarketRegistItem_SimpleToolTip( isShow, iconType )
	local self = ItemMarketRegistItem
	local name = ""
	local desc = ""
	local uiControl = nil
	-- local UiBase = ItemMarketItemSet.ItemListUiPool[ui_Idx]

	if 0 == iconType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_AVGPRICE_NAME") -- "현재 시세"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_AVGPRICE_DESC") -- "해당 아이템의 현재 시세를 기준으로 등록 최저가와 최고가가 결정됩니다."
		uiControl = self.averagePriceIcon
	elseif 1 == iconType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_RECENTPRICE_NAME") -- "최근 거래가"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_RECENTPRICE_DESC") -- "해당 아이템의 최근 거래가격입니다."
		uiControl = self.recentPriceIcon
	elseif 2 == iconType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_MAXPRICE_NAME") -- "상한가"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_MAXPRICE_DESC") -- "해당 아이템을 등록할 수 있는 최고금액입니다."
		uiControl = self.maxPriceIcon
	elseif 3 == iconType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_MINPRICE_NAME") -- "하한가"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_MINPRICE_DESC") -- "해당 아이템을 등록할 수 있는 최저금액입니다."
		uiControl = self.minPriceIcon
	elseif 4 == iconType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_REGISTHIGH_NAME") -- "등록 최고가"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_REGISTHIGH_DESC") -- "해당 아이템이 등록된 최고가입니다."
		uiControl = self.registHighPriceIcon
	elseif 5 == iconType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_REGISTLOW_NAME") -- "등록 최저가"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_REGISTLOW_DESC") -- "해당 아이템이 등록된 최저가입니다."
		uiControl = self.registLowPriceIcon
	elseif 6 == iconType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_REGISTLIST_NAME") -- "누적 거래량"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_REGISTLIST_DESC") -- "해당 아이템의 누적된 거래량입니다."
		uiControl = self.registListCountIcon
	elseif 7 == iconType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_REGISTITEM_NAME") -- "등록 개수"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGISTITEM_TOOLTIP_REGISTITEM_DESC") -- "해당 아이템이 현재 등록되어있는 수량입니다."
		uiControl = self.registItemCountIcon
	end

	if true == isShow then
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end	
end

function ItemMarketRegistItem:registEventHandler()
	self.btn_Close				:addInputEvent("Mouse_LUp",			"FGlobal_ItemMarketRegistItem_Close()")
	self.btn_Cancle				:addInputEvent("Mouse_LUp",			"FGlobal_ItemMarketRegistItem_Close()")
	self.btn_Confirm			:addInputEvent("Mouse_LUp",			"HandleClicked_ItemMarketRegistItem_RegistDO()")
	self.priceEdit				:addInputEvent("Mouse_LUp",			"HandleClicked_ItemMarketRegistItem_EditReset()")
	self.btn_MinPrice			:addInputEvent("Mouse_LUp",			"HandleClicked_ItemMarketRegistItem_SellPriceMin()")
	self.btn_MaxPrice			:addInputEvent("Mouse_LUp",			"HandleClicked_ItemMarketRegistItem_SellPriceMax()")
	self.btn_CheckPrice			:addInputEvent("Mouse_LUp",			"HandleClicked_ItemMarketRegistItem_SellPriceSum()")
	self.averagePriceIcon		:addInputEvent("Mouse_On",			"ItemMarketRegistItem_SimpleToolTip( true, 0 )")
	self.averagePriceIcon		:addInputEvent("Mouse_Out",			"ItemMarketRegistItem_SimpleToolTip( false )")
	self.recentPriceIcon		:addInputEvent("Mouse_On",			"ItemMarketRegistItem_SimpleToolTip( true, 1 )")
	self.recentPriceIcon		:addInputEvent("Mouse_Out",			"ItemMarketRegistItem_SimpleToolTip( false )")
	self.maxPriceIcon			:addInputEvent("Mouse_On",			"ItemMarketRegistItem_SimpleToolTip( true, 2 )")
	self.maxPriceIcon			:addInputEvent("Mouse_Out",			"ItemMarketRegistItem_SimpleToolTip( false )")
	self.minPriceIcon			:addInputEvent("Mouse_On",			"ItemMarketRegistItem_SimpleToolTip( true, 3 )")
	self.minPriceIcon			:addInputEvent("Mouse_Out",			"ItemMarketRegistItem_SimpleToolTip( false )")
	self.registHighPriceIcon	:addInputEvent("Mouse_On",			"ItemMarketRegistItem_SimpleToolTip( true, 4 )")
	self.registHighPriceIcon	:addInputEvent("Mouse_Out",			"ItemMarketRegistItem_SimpleToolTip( false )")
	self.registLowPriceIcon		:addInputEvent("Mouse_On",			"ItemMarketRegistItem_SimpleToolTip( true, 5 )")
	self.registLowPriceIcon		:addInputEvent("Mouse_Out",			"ItemMarketRegistItem_SimpleToolTip( false )")
	self.registListCountIcon	:addInputEvent("Mouse_On",			"ItemMarketRegistItem_SimpleToolTip( true, 6 )")
	self.registListCountIcon	:addInputEvent("Mouse_Out",			"ItemMarketRegistItem_SimpleToolTip( false )")
	self.registItemCountIcon	:addInputEvent("Mouse_On",			"ItemMarketRegistItem_SimpleToolTip( true, 7 )")
	self.registItemCountIcon	:addInputEvent("Mouse_Out",			"ItemMarketRegistItem_SimpleToolTip( false )")

	self._buttonQuestion		:addInputEvent( "Mouse_LUp",		"Panel_WebHelper_ShowToggle( \"ItemMarket\" )" )								-- 물음표 좌클릭
	self._buttonQuestion		:addInputEvent( "Mouse_On",			"HelpMessageQuestion_Show( \"ItemMarket\", \"true\")" )				-- 물음표 마우스오버
	self._buttonQuestion		:addInputEvent( "Mouse_Out",		"HelpMessageQuestion_Show( \"ItemMarket\", \"false\")" )			-- 물음표 마우스오버

end

function ItemMarketRegistItem:registMessageHandler()
end

ItemMarketRegistItem:Initialize()
ItemMarketRegistItem:registEventHandler()
ItemMarketRegistItem:registMessageHandler()