------------------------------------------------------------------------------------------------------------
--------------- 사용 함수

-- Dialog_getFuncSceneCameraName() 				무역카메라 이름을 가져옴

------------------------------------------------------------------------------------------------------------

---------------------------
-- Panel Init
---------------------------
Panel_Npc_Trade_Market:SetShow( false, false )
Panel_Npc_Trade_Market:setGlassBackground(true)
---------------------------
-- global Variables
---------------------------
global_IsTrading = false

function global_setTrading( istrading )
	global_IsTrading = istrading
end

	
gDialogSceneIndex =
{
	[enCommerceType.enCommerceType_Luxury_Miscellaneous] 	= 8,
	[enCommerceType.enCommerceType_Luxury] 					= 7,
	[enCommerceType.enCommerceType_Grocery] 				= 5,
	[enCommerceType.enCommerceType_Cloth] 					= 10,
	[enCommerceType.enCommerceType_ObjectSaint] 			= 11,
	[enCommerceType.enCommerceType_MilitarySupplies] 		= 12,
	[enCommerceType.enCommerceType_Medicine] 				= 6,
	[enCommerceType.enCommerceType_SeaFood] 				= 14,
	[enCommerceType.enCommerceType_RawMaterial] 			= 13,
	[enCommerceType.enCommerceType_Max]						= 0
}

---------------------------
-- Local Variables
---------------------------
local UI_TM = CppEnums.TextMode
local const_64			= Defines.s64_const

-- 상점에서 클릭시 장바구니에 넣기위한 변수
local currentTradeSlot = 0
local tradeBuyMaxCount = 9

local npcTradeShop =
{
	slotConfig =
	{
		createIcon		= true,
		createBorder	= true,
		createCount		= false,
		createCash		= true
	},

	_TradeBuyListRow = 3,
	_TradeBuyListCol = 3,
	_buySlotMaxCount = 14,
	--_buyMaxCount = 9,
	
	_buyRequest = false,
	
	_selectClickIndex = 1,
	_selectClickItemKey = 0,
	_numpadNumber = toInt64( 0, 1),
	_totalWeight = const_64.s64_0,
	_myRemainWeight = const_64.s64_0,
	_totalCost = const_64.s64_0,

	--_currentTradeSlot = 1,

	buyListFrame,
	buyListFrameContent,

	_buttonExit,-- 			= UI.getChildControl(Panel_Npc_Trade_Market, "Button_Win_Close"),

	_staticCategoryTotal,
	_staticPossessMoneyText,
	_staticPossessMoneyValue,
	_staticPossessMoney,
	_staticTotalMoneyText,
	_staticTotalMoneyValue,
	_staticTotalMoney,
	_staticTotalWeightText,
	_staticTotalWeight,
	_StaticTextCartWeightLT,
	_button_Confirm,
	_button_ClearList,
	_button_Confirm_EnterVihicle,
	_currentWeightText,
	_buttonTradeGameStart,
	_currentWeightLT,
	_vehicleWeightLT,
	_vehicleWeightText,
	_alertpanel,
    _alerttext,
    _btnInvestNode,
	
	preLoadUI =
	{
		_static_Icon = nil,
		_static_TextItemName = nil,
		_static_Multiply = nil,
		_button_Quantity = nil,
		_static_Equal = nil,
		_static_Cost = nil,
		_static_CostIcon = nil
	},
	_slotBuyAmount =
	{
	},

	-- _slotItemWrapper =
	-- {
	-- },

	_buyList = 	{}		-- 장바구니안의 구매할 아이템 리스트
	
}

---------------------------
-- Functions
---------------------------
function global_setTradeUI(refreshGraph)	-- 무역 UI 세팅
	currentTradeSlot = 1
	npcTradeShop._numpadNumber = toInt64( 0, 1)
	npcTradeShop:InitTradeMarket()
	npcTradeShop:initTradeData()
	
	-- Graph UI
	if true == refreshGraph then
		global_CommerceGraphDataInit(false)		-- 무역품 초기화 했을 때 
	end

	npcTradeShop._staticPossessMoneyValue:SetText( makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()) )
	npcTradeShop._staticTotalMoneyValue:SetText( "0" )
	setShowLine(false)									-- 테두리 원 안보이게 설정하기
end

-- 장바구니에 담기
function global_enterBasketInShop( slotItemKey, index, itemCount )
	if tradeBuyMaxCount < currentTradeSlot then
		NotifyDisplay( PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_NOTIFYDISPLAY") ) -- "더 이상 장바구니에 무역품을 담을 수 없습니다." )
		UI.ASSERT( false, "너무 많이 담으려고 합니다." )
		return 0
	end

	if nil ~= npcTradeShop._slotBuyAmount[slotItemKey] then
		-- UI.debugMessage( "이미 장바구니에 있습니다." .. slotItemKey )
		return 0
	end
	
	local slot = npcTradeShop._buyList[ currentTradeSlot ]
	local shopItemWrapper = npcShop_getItemBuy( index )

	local buyData =
	{
		_itemCount = toInt64( 0, 0),
		_slotIndex = 0,
		_itemKey = 0,
		_commerceTypeIndex = 0
	}
	
	local itemSS = shopItemWrapper:getStaticStatus()
		
	buyData._itemCount = itemCount
	buyData._slotIndex = index--shopItemWrapper:get().shopSlotNo	-- 여기서 부터는 상점의 슬롯 번호를 사용해야한다.
	buyData._itemKey = slotItemKey
	buyData._commerceTypeIndex = itemSS:getCommerceType()
	--UI.debugMessage( "장바구니 slotItemKey : " .. slotItemKey .. "  " .. buyData._slotIndex )
	npcTradeShop._slotBuyAmount[slotItemKey] = buyData
	npcTradeShop._selectClickItemKey = slotItemKey
	npcTradeShop._selectClickIndex = currentTradeSlot
	
	--npcTradeShop._slotItemWrapper[slotIndex] = shopItemWrapper

	local s64_inventoryItemCount = nil
	local shopItem = shopItemWrapper:get()

	--UI.debugMessage( "shopItem.leftCount_s64 : " .. tostring( shopItem.leftCount_s64 ) )
	slot:setItem( shopItemWrapper:getStaticStatus(), shopItem.leftCount_s64, shopItem.price_s64, s64_inventoryItemCount )
	currentTradeSlot = currentTradeSlot + 1

	totalCalculateMoney()

	Panel_Tooltip_Item_SetPosition( slot.slotNo, slot, "shop" )
	
	npcTradeShop._buyRequest = false
	return 1
end

	
function global_CheckItem_From_Cart( checkItemKey )
	 return (nil ~= npcTradeShop._slotBuyAmount[checkItemKey] )

	-- for key, value in pairs ( npcTradeShop._slotBuyAmount ) do
		-- if value._itemKey == checkItemKey then
			-- return true
		-- end
	-- end
	
	-- return false
end

--local _const = Defines.s64_const

-- Mouse Quantity button Click
function click_TradeMarket_Quantity( index )
	npcTradeShop._selectClickIndex = index
	--npcTradeShop._selectClickIndex = currentTradeSlot - 1		-- 증가된 값보다 하나 작게...
	local slot = npcTradeShop._buyList[ index ]
	npcTradeShop._selectClickItemKey = slot.itemKey
	
	--UI.debugMessage( "index : " .. index .. "_selectClickIndex : " .. npcTradeShop._selectClickIndex )
	
	-- 현재 무역에서의 구매 제한가격은 없다. 일단 10000개 정도는 살 수 있게 해놓자...
	--local s64_maxNumber = Defines.s64_const.s64_10000 --slot.s64StackCount
	--UI.debugMessage( "slot.s64StackCount : " .. tostring( slot.s64StackCount ) )

	param =
	{
		[0] = npcTradeShop._selectClickItemKey,
		[1] = index,
		[2] = false,								-- 캐릭터 움직일지 여부
		[3] = npcTradeShop._slotBuyAmount[npcTradeShop._selectClickItemKey]._commerceTypeIndex		-- 무역 타입
	}

	local tradeItemWrapper	= npcShop_getTradeItem( param[0] )
	local buyableStack		= tradeItemWrapper:getRemainStackCount()		-- 내가 살수있는 수량
	
	Panel_NumberPad_Show(true, buyableStack, param, TradeMarket_BuySome_ConfirmFunction)
	
	--slot.comboBox_Quantity:ToggleListbox()
end

function TradeMarket_BuySome_ConfirmFunction(inputNumber, param)
	npcTradeShop._numpadNumber = inputNumber
	local rv = global_enterBasketInShop( param[0], param[1], inputNumber )
	
	if 0 == rv and true == param[2] then
		return ;
	end
	
	npcTradeShop._slotBuyAmount[npcTradeShop._selectClickItemKey]._itemCount = inputNumber
	--UI.debugMessage( "npcTradeShop._slotBuyAmount[npcTradeShop._selectClickItemKey]._itemCount : " .. tostring( npcTradeShop._slotBuyAmount[npcTradeShop._selectClickItemKey]._itemCount ) )

	local quentityButton =  npcTradeShop._buyList[ npcTradeShop._selectClickIndex ].button_Quantity

	quentityButton:SetText( tostring( inputNumber ) )
	--totalCalculateMoney()

	local npcSceneCharacterKey = getClientSceneKey()
	if true == param[2] and 0 ~= npcSceneCharacterKey then
		--local workerIndex = getIndexByCharacterKey( 880 )
		--_PA_LOG( "asdf", "param[3] : " .. tostring( param[3] ) )
		callAIHandlerByIndex( 1, gDialogSceneIndex[ param[3] ], "SceneTradeBuy" )
		--global_TradeShopScene()
	else
		totalCalculateMoney()
	end
end

-- 가격 산출
function calculateMoney( index )
	if false == npcTradeShop:checkSlotIndex(index) or index > currentTradeSlot then
		UI.ASSERT( false, "슬롯 번호가 이상합니다." )
		return
	end

	local slot = npcTradeShop._buyList[ index ]
	local shopItemWrapper = npcShop_getItemBuy( slotIndex )
	local shopItem = shopItemWrapper:get()

	local s64itemPrice = slot.s64price * npcTradeShop._slotBuyAmount[ slot.itemKey ]._itemCount --npcTradeShop._numpadNumber
	--UI.debugMessage( "=== money = " .. tostring( slot.s64price ) .. " sellcount : " .. tostring( npcTradeShop._numpadNumber ) .. " = " .. tostring( s64itemPrice ) )
	slot.static_Cost:SetText( makeDotMoney(s64itemPrice) )	--tostring( s64itemPrice )
	
	npcTradeShop._totalWeight = npcTradeShop._totalWeight + (toInt64( 0, slot.itemWeight ) * npcTradeShop._slotBuyAmount[ slot.itemKey ]._itemCount)
	return s64itemPrice
end

-- 총 가격 산출
function totalCalculateMoney()
	npcTradeShop._totalWeight = toInt64( 0, 0 )
	local totalItemPrice = toInt64( 0, 0 )
	for count = 1, currentTradeSlot-1 do
		s64itemPrice = calculateMoney( count )
		totalItemPrice = totalItemPrice + s64itemPrice
	end

	--_PA_LOG("test", "s64itemPriceinSlot - " .. tostring(s64itemPriceinSlot) );
	npcTradeShop._staticTotalMoneyValue:SetText( makeDotMoney(totalItemPrice) )
	npcTradeShop._totalCost = totalItemPrice
	local itemWeight = string.format("%.1f", Int64toInt32( npcTradeShop._totalWeight ) / 10000 )
	--npcTradeShop._StaticTextCartWeightLT:SetFontColor( Defines.Color.C_FF000000 )
	
	if npcTradeShop._myRemainWeight < npcTradeShop._totalWeight then
		npcTradeShop._StaticTextCartWeightLT:SetFontColor( Defines.Color.C_FFD20000 )
	else
		npcTradeShop._StaticTextCartWeightLT:SetFontColor( Defines.Color.C_FFFFBC3A )
	end
	npcTradeShop._StaticTextCartWeightLT:SetText( itemWeight .. " LT" )
	
	--npcTradeShop._totalWeight = npcTradeShop._totalWeight / const_64.s64_100
end

-- 유효한 슬롯인지에 대한 검사
function npcTradeShop:checkSlotIndex( index )
	if 0 > index or index > tradeBuyMaxCount then
		UI.ASSERT( false, "유효하지 않은 슬롯 번호 입니다.(lua)" )
		return false
	end

	return true
end

-- ui등록
function npcTradeShop:registUiControl()
	local index = 0

	npcTradeShop.buyListFrame 			= UI.getChildControl( Panel_Npc_Trade_Market, "Frame_BuyList" )
	npcTradeShop.buyListFrameContent 	= npcTradeShop.buyListFrame:GetFrameContent()
	npcTradeShop.title					= UI.getChildControl( Panel_Npc_Trade_Market, "Panel_title" )
	npcTradeShop._buttonExit			= UI.getChildControl( Panel_Npc_Trade_Market, "Button_Win_Close")
	npcTradeShop._staticEarnProfitText	= UI.getChildControl( Panel_Npc_Trade_Market, "StaticText_Earn_Profit_Title")
	npcTradeShop._staticEarnProfitValue	= UI.getChildControl( Panel_Npc_Trade_Market, "StaticText_Earn_Profit_Value")
	npcTradeShop._staticEarnProfitCoin	= UI.getChildControl( Panel_Npc_Trade_Market, "StaticText_Earn_Profit_Coin")
	npcTradeShop._petInventoryTitle		= UI.getChildControl( Panel_Npc_Trade_Market, "StaticText_Pet_Inventory")
	npcTradeShop._petInventoryValue		= UI.getChildControl( Panel_Npc_Trade_Market, "StaticText_Pet_Inventory_Value")
	npcTradeShop._alertpanel 			= UI.getChildControl( Panel_Npc_Trade_Market, "Static_AlertPanel" )
	npcTradeShop._alerttext 			= UI.getChildControl( Panel_Npc_Trade_Market, "StaticText_Alert_NoticeText" )
	npcTradeShop._btnInvestNode 		= UI.getChildControl( Panel_Npc_Trade_Market, "Button_Node_Invest" )
	npcTradeShop._buttonTradeGameStart	= UI.getChildControl( Panel_Npc_Trade_Market, "Button_TradeGameStart")
	npcTradeShop._buttonTradeGameStart	: SetShow( false )
	--npcTradeShop._buttonTradeGameStart:addInputEvent( "Mouse_LUp", "click_TradeGameStart()" )	
	--npcTradeShop._buttonTradeGameStart	: SetText( PAGetString( Defines.StringSheet_GAME, "LUA_TRADEMARKET_TRADEGAME_MSG_1" ) )
	
	npcTradeShop.preLoadUI =
	{
		_static_Icon 			= UI.getChildControl( npcTradeShop.buyListFrameContent, "list_icon" ),
		_static_TextItemName 	= UI.getChildControl( npcTradeShop.buyListFrameContent, "list_name" ),
		_static_Multiply 		= UI.getChildControl( npcTradeShop.buyListFrameContent, "list_multiply" ),
		_button_Quantity 		= UI.getChildControl( npcTradeShop.buyListFrameContent, "Button_listCount" ),
		_static_Equal 			= UI.getChildControl( npcTradeShop.buyListFrameContent, "list_equal" ),
		_static_Cost 			= UI.getChildControl( npcTradeShop.buyListFrameContent, "StaticText_Cost" ),
		_static_CostIcon	 	= UI.getChildControl( npcTradeShop.buyListFrameContent, "list_totalCost_moneyIcon" )
	}

	npcTradeShop._staticCategoryTotal 		= UI.getChildControl( npcTradeShop.buyListFrameContent, "category_total")
	npcTradeShop._staticPossessMoneyText 	= UI.getChildControl( npcTradeShop.buyListFrameContent, "possessed_money")
	npcTradeShop._staticPossessMoneyValue 	= UI.getChildControl( npcTradeShop.buyListFrameContent, "possessed_money_value")
	npcTradeShop._staticPossessMoney 		= UI.getChildControl( npcTradeShop.buyListFrameContent, "possessed_money_moneyIcon")
	npcTradeShop._staticTotalMoneyText 		= UI.getChildControl( npcTradeShop.buyListFrameContent, "totalCost")
	npcTradeShop._staticTotalMoneyValue		= UI.getChildControl( npcTradeShop.buyListFrameContent, "totalCost_value")
	npcTradeShop._staticTotalMoney 			= UI.getChildControl( npcTradeShop.buyListFrameContent, "totalCost_moneyIcon")
	npcTradeShop._staticTotalWeightText 	= UI.getChildControl( npcTradeShop.buyListFrameContent, "totalWeight")
	npcTradeShop._staticTotalWeight 		= UI.getChildControl( npcTradeShop.buyListFrameContent, "totalWeight_value")
	npcTradeShop._StaticTextCartWeightLT	= UI.getChildControl( npcTradeShop.buyListFrameContent, "totalWeight_LT")
	npcTradeShop._button_Confirm			= UI.getChildControl( npcTradeShop.buyListFrameContent, "Button_confirm")
	npcTradeShop._currentWeightLT			= UI.getChildControl( npcTradeShop.buyListFrameContent, "currentWeight_LT")
	npcTradeShop._vehicleWeightText			= UI.getChildControl( npcTradeShop.buyListFrameContent, "StaticText_Vehicle_Weight")
	npcTradeShop._vehicleWeightLT			= UI.getChildControl( npcTradeShop.buyListFrameContent, "currentVehicleWeight_LT")
	npcTradeShop._button_Confirm:addInputEvent( "Mouse_LUp", "click_Confirm_BasketList()" )
	npcTradeShop._button_ClearList			= UI.getChildControl( npcTradeShop.buyListFrameContent, "Button_clearList")
	npcTradeShop._button_ClearList:addInputEvent( "Mouse_LUp", "click_clear_BasketList()" )
	npcTradeShop._buttonExit:addInputEvent( "Mouse_LUp", "closeNpcTrade_Basket()" )
	npcTradeShop._button_Confirm_EnterVihicle	= UI.getChildControl( npcTradeShop.buyListFrameContent, "Button_confirm_EnterViehicle")
	npcTradeShop._button_Confirm_EnterVihicle:addInputEvent( "Mouse_LUp", "click_Confirm_Enter_Vehicle()" )
	npcTradeShop._currentWeightText			= UI.getChildControl( npcTradeShop.buyListFrameContent, "currentWeight")

	-- 장바구니 목록 UI 복사
	local preloadUIList = npcTradeShop.preLoadUI
	for countCol = 1, npcTradeShop._TradeBuyListCol do
		for countRow = 1, npcTradeShop._TradeBuyListRow do
			index = (countCol - 1) * (npcTradeShop._TradeBuyListCol) + countRow
			--UI.debugMessage( index )

			local buyList =
			{
				slotNo = 0,
				s64price = toInt64( 0, 0),
				s64StackCount = 0,
				itemWeight = 0,
				itemKey
			}

			buyList.slotNo = index - 1

			buyList.static_TextItemName = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, npcTradeShop.buyListFrameContent, "BuyListBuyItemName_" .. index )
			CopyBaseProperty( preloadUIList._static_TextItemName, buyList.static_TextItemName )

			buyList.static_Multiply = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, npcTradeShop.buyListFrameContent, "BuyList_multiply_" .. index )
			CopyBaseProperty( preloadUIList._static_Multiply, buyList.static_Multiply )
			
			
			buyList.button_Quantity = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, npcTradeShop.buyListFrameContent, "BuyList_Quantity" .. index )
			CopyBaseProperty( preloadUIList._button_Quantity, buyList.button_Quantity )
			--buyList.listQuantity = buyList.button_Quantity:GetListControl()

			buyList.button_Quantity:addInputEvent( "Mouse_LUp", "click_TradeMarket_Quantity(".. index ..")" )
--			buyList.listQuantity:addInputEvent( "Mouse_LUp", "TradeMarket_Quantity_List(".. index ..")" )

			buyList.static_Equal = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, npcTradeShop.buyListFrameContent, "BuyList_Equal" .. index )
			CopyBaseProperty( preloadUIList._static_Equal, buyList.static_Equal )

			buyList.static_Cost = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, npcTradeShop.buyListFrameContent, "BuyList_Cost" .. index )
			CopyBaseProperty( preloadUIList._static_Cost, buyList.static_Cost )

			buyList.static_CostIcon = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, npcTradeShop.buyListFrameContent, "BuyListIcon_Cost" .. index )
			CopyBaseProperty( preloadUIList._static_CostIcon, buyList.static_CostIcon )

			buyList.icon = {}
			SlotItem.new( buyList.icon, 'ShopItem_' .. index, index, npcTradeShop.buyListFrameContent, npcTradeShop.slotConfig )
			buyList.icon:createChild()

			function buyList:setItem( itemStaticWrapper, s64_stackCount, s64_price, s64_invenCount, disable )
				local enable = (const_64.s64_0 ~= s64_stackCount) and (not disable)

				self.icon:setItemByStaticStatus( itemStaticWrapper )
				self.icon.icon:SetMonoTone( not enable )

				self.static_TextItemName:SetText( itemStaticWrapper:getName() )
				self.s64price = s64_price
				self.s64StackCount = s64_stackCount
				self.itemWeight = itemStaticWrapper:get()._weight
				self.itemKey = itemStaticWrapper:get()._key:get()

				self:setShow( true )
			end

			function buyList:clearSlot()
				self:setShow( false )
				self.button_Quantity:SetText( "1" )

				--self.static_TextItemName:SetText( "" )
				self.static_Cost:SetText( "0" )
			end

			function buyList:setShow( bShow )
				local bShow = bShow or false
				self.static_TextItemName:SetShow(bShow)
				self.static_Multiply:SetShow(bShow)
				self.button_Quantity:SetShow(bShow)
				self.static_Equal:SetShow(bShow)
				self.static_Cost:SetShow(bShow)
				self.static_CostIcon:SetShow(bShow)
				self.icon.icon:SetShow(bShow)
			end

			npcTradeShop._buyList[index] = buyList
		end
	end

	npcTradeShop.buyListFrame:SetSize( getScreenSizeX() * 0.8, npcTradeShop.buyListFrame:GetSizeY() )
	npcTradeShop.buyListFrameContent:SetSize( npcTradeShop.buyListFrame:GetSizeX(), npcTradeShop.buyListFrame:GetSizeY() )

	eventResetTradeUI()
end

function check_Servant()
	local	myLandVehicle			= getTemporaryInformationWrapper()
	local	servantInfoWrapper		= myLandVehicle:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
	
	if nil ~= servantInfoWrapper	then
		local myLandVehicleActorKey	= servantInfoWrapper:getActorKeyRaw()
		if nil ~= myLandVehicleActorKey then
			local landVehicleActorProxy = getActor( myLandVehicleActorKey )
			local selfProxy = getSelfPlayer()
			
			if nil ~= landVehicleActorProxy then
				
				local isAbleDistance = getDistanceFromVehicle()
				if isAbleDistance then
					-- 가까이 있다.
					local vehicleInventory = servantInfoWrapper:getInventory()
					--local maxInventorySlot = vehicleInventory:size()
					local maxInventorySlot	= vehicleInventory:size()-2
					local freeInventorySlot	= maxInventorySlot - vehicleInventory:getFreeCount()
					local myLandVehicleActorKey = myLandVehicle:getUnsealVehicle(false):getActorKeyRaw()
					local servantWrapper	= myLandVehicle:getUnsealVehicleByActorKeyRaw( myLandVehicleActorKey )
					
					local max_weight		= Int64toInt32(servantWrapper:getMaxWeight_s64() / Defines.s64_const.s64_10000)
					local total_weight	= Int64toInt32((servantWrapper:getInventoryWeight_s64() + servantWrapper:getEquipWeight_s64() + servantWrapper:getMoneyWeight_s64()) / Defines.s64_const.s64_10000)
					local vehicleRemainWeightValue = string.format( "%.1f", max_weight - total_weight )
					
					return true, maxInventorySlot, freeInventorySlot, vehicleRemainWeightValue
				else
					-- 떨어져 있다.
					return false, 0, 0
				end
			else
				-- 탈것이 없다.
				return nil, 0, 0
			end
		else
			-- 탈것이 없다.
			return nil, 0, 0
		end
	else
		-- 탈것이 없다.
		return nil, 0, 0
	end
end

function check_Servant_Inventory()

	local checkServant, maxInventorySlot, freeInventorySlot, remainWeight = check_Servant()
	
	if ( true == checkServant ) then
		npcTradeShop._petInventoryTitle:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarketList_Servant_Inventory" ))
		npcTradeShop._petInventoryValue:SetText(freeInventorySlot .. " / " .. maxInventorySlot)
		npcTradeShop._vehicleWeightLT:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "Lua_WindowTradeMarket_Weight", "Weight", tostring( remainWeight )))
		npcTradeShop._petInventoryTitle:SetShow(true)
		npcTradeShop._petInventoryValue:SetShow(true)
		npcTradeShop._vehicleWeightText:SetShow(true)
		npcTradeShop._vehicleWeightLT:SetShow(true)
		npcTradeShop._petInventoryTitle:SetSpanSize( 155, 137 )
	elseif ( false == checkServant ) then
		npcTradeShop._petInventoryTitle:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarketList_Servant_NotNear" ))
		npcTradeShop._petInventoryValue:SetText(freeInventorySlot .. " / " .. maxInventorySlot)
		npcTradeShop._petInventoryTitle:SetShow(true)
		npcTradeShop._petInventoryValue:SetShow(false)
		npcTradeShop._vehicleWeightText:SetShow(false)
		npcTradeShop._vehicleWeightLT:SetShow(false)
		npcTradeShop._petInventoryTitle:SetSpanSize( 70, 137 )
	elseif ( nil == checkServant ) then								-- 탑승물이 없으면, 탑승물 메시지 출력 off
		npcTradeShop._petInventoryTitle:SetShow(false)
		npcTradeShop._petInventoryValue:SetShow(false)
		npcTradeShop._vehicleWeightText:SetShow(false)
		npcTradeShop._vehicleWeightLT:SetShow(false)
	end
end

function npcTradeShop:InitTradeMarket()
	currentTradeSlot = 1
	npcTradeShop._buyRequest = false
	for count = 1, tradeBuyMaxCount do
		npcTradeShop._buyList[count]:clearSlot()
	end
end

function npcTradeShop:initTradeData()
	npcTradeShop._slotBuyAmount = {}

	npcTradeShop._staticPossessMoneyValue:SetText( "0" )
	npcTradeShop._staticTotalMoneyValue:SetText( "0" )
	npcTradeShop._StaticTextCartWeightLT:SetText( "0" .. " LT" )
	
	TradeShopMoneyRefresh()
	-- local _const = Defines.s64_const
	-- local selfPlayerWrapper = getSelfPlayer()
	-- local selfPlayer = selfPlayerWrapper:get()
	-- local itemWeightDiv100 = selfPlayer:getPossessableWeight_s64() / _const.s64_100
	
	-- local str_int32weight = string.format( "%.1f", Int64toInt32( itemWeightDiv100 ) / 100 )
	-- --UI.debugMessage( "selfPlayer:getCurrentWeight_s64() : " .. tostring( selfPlayer:getCurrentWeight_s64() ) )
	-- local s64_CurrentWeight = selfPlayer:getCurrentWeight_s64() / _const.s64_100
	-- --UI.debugMessage( "s64_CurrentWeight : " .. tostring( s64_CurrentWeight ) )
	-- local str_CurrentWeight = string.format("%.1f", Int64toInt32(s64_CurrentWeight) / 100 )
	-- npcTradeShop._currentWeightLT:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "Lua_WindowTradeMarket_Weight", "Weight", tostring( str_CurrentWeight ) .. " / " .. tostring( str_int32weight ) ) )
end

function click_Confirm_BasketList()
	if currentTradeSlot <= 1 then
		return
	end
	
	local showMessageBox = check_Servant()	 -- 탈것과 자기 인벤을 선택해야할 경우
	
	if ( true == showMessageBox ) then
		local tileString = PAGetString( Defines.StringSheet_GAME, "Lua_TradeMarket_BuyMsg_UseVehicleInvenTitle" )
		local contentString = PAGetString( Defines.StringSheet_GAME, "Lua_TradeMarket_BuyMsg_UseVehicleInvenContent" )
		local messageboxData = { title = tileString, content = contentString,
						functionYes = confirm_VehicleInventory, functionNo = confirm_ToMyInventory, exitButton = true, isCancelClose = false, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
		MessageBox.showMessageBox( messageboxData )
	else
		confirm_ToMyInventory()
	end
end

function confirm_ToMyInventory()
	local titleString = PAGetString( Defines.StringSheet_GAME, "Lua_TradeMarket_BuyMsg_UseInvenTitle" )
	local contentString = PAGetString( Defines.StringSheet_GAME, "Lua_TradeMarket_BuyMsg_UseInvenContent" )
	local messageboxData = { title = titleString, content = contentString,
					functionYes = confirm_MyInventory, functionNo = MessageBox_Empty_function, exitButton = true, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
	MessageBox.showMessageBox( messageboxData )
end

function confirm_MyInventory()
	send_doBuy( 0, 0 )
end

-- 탈것으로 무역품 들어갈 때 무게 조건을 건다! 100%를 초과한 무게를 실을 수 없다!
function confirm_VehicleInventory()
	local	myLandVehicle	= getTemporaryInformationWrapper()
	local	myLandVehicleActorKey = myLandVehicle:getUnsealVehicle(false):getActorKeyRaw()
	local	servantWrapper	= myLandVehicle:getUnsealVehicleByActorKeyRaw( myLandVehicleActorKey )
	
	local	max_weight		= Int64toInt32(servantWrapper:getMaxWeight_s64() / Defines.s64_const.s64_10000)
	local	total_weight	= Int64toInt32((servantWrapper:getInventoryWeight_s64() + servantWrapper:getEquipWeight_s64() + servantWrapper:getMoneyWeight_s64()) / Defines.s64_const.s64_10000)
	
	-- npcTradeShop._totalWeight : 사려는 아이템의 총 무게
	if ( max_weight - total_weight < Int64toInt32(npcTradeShop._totalWeight)/10000 ) then
		local titleString = PAGetString( Defines.StringSheet_GAME, "LUA_TRADEMARKET_VEHICLE_MSG_TITLE" )					-- "탑승물 무게 초과"
		local contentString = PAGetString( Defines.StringSheet_GAME, "LUA_TRADEMARKET_VEHICLE_MSG_CONTENT" )				-- "탑승물의 무게 허용치를 초과해 실을 수 없습니다."
		local messageboxData = { title = titleString, content = contentString, functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
		MessageBox.showMessageBox( messageboxData )
		return
	end
	
	send_doBuy( 0, 4 )
end

function	send_doBuy( fromWhere, toWhere )
	local rv = 0
	rv = check_BuyableTradeItem()
	
	if 0 ~= rv then
		return
	end

	for slotIndex, itemCount in pairs(npcTradeShop._slotBuyAmount) do
		if toInt64( 0, 0 ) ~= npcTradeShop._slotBuyAmount[ slotIndex ]._itemCount then
			local itemCount = npcTradeShop._slotBuyAmount[ slotIndex ]._itemCount
			--UI.debugMessage( "이거 사자" .. slotIndex .. "  "  .. tostring( npcTradeShop._slotBuyAmount[ slotIndex ]._itemCount ) )
			
			-- 무역 템이 단일 아이템이므로 루프를 돌면서 하나씩 사게 바꿔주자... (20140115 juicepia)
			local itemCount32 = Int64toInt32( itemCount )
			for count = 0, itemCount32 - 1 do
				npcShop_doBuy( npcTradeShop._slotBuyAmount[ slotIndex ]._slotIndex, 1, fromWhere, toWhere )		-- 0 이 아니라면 문제가 발생한 것이다. 내부에서 메시지를 띄운다.
				
				-- 실패 메시지가 필요하다면 사용하자
				--if 0 ~= rv then
					--itemCount32 = itemCount32 - count
					--NotifyDisplay( itemCount32 .. " 개 구매를 못했습니다." )		-- PAGetString( Defines.StringSheet_GAME, "" )
					--return
				--end
			end
			
			npcTradeShop._buyRequest = true
		end
	end
end

function check_BuyableTradeItem()
	local myMoney = getSelfPlayer():get():getInventory():getMoney_s64()

--UI.debugMessage( "npcTradeShop._myRemainWeight : " .. tostring( npcTradeShop._myRemainWeight ) .. " npcTradeShop._totalWeight : " .. tostring(npcTradeShop._totalWeight) )	
	if myMoney < npcTradeShop._totalCost then
		-- 가진 돈 보다 크다 
		NotifyDisplay( PAGetString( Defines.StringSheet_GAME, "Lua_TradeMarket_Not_Enough_Money" ) )
		return -1
	end	
	
	-- if npcTradeShop._myRemainWeight < npcTradeShop._totalWeight then
	-- -- 무게가 무겁다.
		-- NotifyDisplay( PAGetString( Defines.StringSheet_GAME, "Lua_TradeMarket_Not_Enough_Weight" ) )
		-- return -1
	-- end

	return 0
end

function click_Confirm_Enter_Vehicle()
	local	myLandVehicle	= getTemporaryInformationWrapper()
	local	myLandVehicleActorKey = myLandVehicle:getUnsealVehicle(false):getActorKeyRaw()
	
	if nil ~= myLandVehicleActorKey then
		local landVehicleActorProxy = getActor( myLandVehicleActorKey )
		local selfProxy = getSelfPlayer()
		
		if nil == landVehicleActorProxy then
			-- 가까운 곳에 탈것이 없다.(로드 되지 않은곳)
			NotifyDisplay( PAGetString( Defines.StringSheet_GAME, "Lua_WindowTradeMarket_NotVehicleNear" ) )
			return
		end

		local isAbleDistance = getDistanceFromVehicle()
		--UI.debugMessage( "distanceToVehicle : " .. distanceToVehicle )
		
		if true == isAbleDistance then
			send_doBuy( 0, 4 )
		end
	else
		UI.debugMessage( "탈 것이 없습니다." )
	end
end

-- 비우기.. 비우기를 할경우는 그래프 초기화를 하지 않는다.ㄴ
function click_clear_BasketList()
	global_setTradeUI(false)
	global_TradeShopReset()
end

-- function click_TradeGameStart()
	-- local talker = dialog_getTalker()
	-- if nil == talker then
		-- return
	-- end
	
	-- local selfPlayer = getSelfPlayer()
	-- if nil == selfPlayer then
		-- return
	-- end

	-- 흥정게임 창이 열려 있다면,
	-- if Panel_TradeGame:GetShow() then
		-- 게임이 끝났으면 창을 닫아주고 리턴, 아니면 그냥 리턴
		-- if true == isTradeGameFinish() then
			-- Fglobal_TradeGame_Close()
		-- end
		-- return
	-- end
	
	-- local wp = selfPlayer:getWp()
	-- if ( 0 >= FGlobal_MySellCount() ) then			-- 팔 무역품이 없거나 기운 부족 시 게임을 시작할 수 없다.
		-- local	messageBoxMemo = PAGetString( Defines.StringSheet_GAME, "LUA_TRADEMARKET_TRADEGAME_MSG_2" )				--"판매할 수 있는 무역품이 없어 흥정을\n시작할 수 없습니다."
		-- local	messageBoxData = { title = PAGetString( Defines.StringSheet_GAME, "LUA_TRADEMARKET_TRADEGAME_MSG_1" ), content = messageBoxMemo, functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		-- MessageBox.showMessageBox(messageBoxData)
		-- return
	-- end

	-- if  ( 5 > wp ) then
		-- local	messageBoxMemo = PAGetString( Defines.StringSheet_GAME, "LUA_TRADEMARKET_TRADEGAME_MSG_3" )				--"기운이 부족해 가격을 흥정할 수\n없습니다."
		-- local	messageBoxData = { title = PAGetString( Defines.StringSheet_GAME, "LUA_TRADEMARKET_TRADEGAME_MSG_1" ), content = messageBoxMemo, functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		-- MessageBox.showMessageBox(messageBoxData)
		-- return
	-- end
	
	-- local	messageBoxMemo = PAGetString( Defines.StringSheet_GAME, "LUA_TRADEMARKET_TRADEGAME_MSG_4" )					--"기운을 5 소모해 가격 흥정을 시작합니다.\n흥정에 성공하면 무역상에게 조금 더 비싼 가격에\n무역품을 팔 수 있습니다."
	-- local	messageBoxData = { title = PAGetString( Defines.StringSheet_GAME, "LUA_TRADEMARKET_TRADEGAME_MSG_1" ), content = messageBoxMemo, functionYes = TradeGameStart, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	-- MessageBox.showMessageBox(messageBoxData)
-- end

-- function TradeGameStart()
	-- local talker = dialog_getTalker()
	-- if nil == talker then
		-- return
	-- end
	-- ToClient_TradeGameStart( talker:getActorKey() )
-- end

-- function FGlobal_TradeGame_Success()
	-- npcTradeShop._buttonTradeGameStart:SetText( "흥정 성공" )
	-- npcTradeShop._buttonTradeGameStart:SetIgnore( true )
-- end

-- Show buyList
function npcTradeShop:setBuyControlShow( index, isShow )
	local resizeControl = npcTradeShop._buyList[index]

	--resizeControl.static_Icon:SetShow( isShow )
	resizeControl.icon.icon:SetShow( isShow )
	resizeControl.static_TextItemName:SetShow( isShow )
	resizeControl.static_Multiply:SetShow( isShow )
	resizeControl.button_Quantity:SetShow( isShow )
	resizeControl.static_Equal:SetShow( isShow )
	--resizeControl.static_Cost:SetShow( isShow )
end

-- Set UI Pos
function npcTradeShop:setControlPos( control, PosX, PosY )
	control:SetPosX( PosX )
	control:SetPosY( PosY )
end

-- 위치 정렬
function npcTradeShop:setSizeBuyListControl( index, posX, posY )
	local resizeControl = npcTradeShop._buyList[index]

	npcTradeShop:setControlPos( resizeControl.icon.icon, posX, posY )
	npcTradeShop.title:ComputePos()
	npcTradeShop._buttonExit:ComputePos()
	npcTradeShop._staticEarnProfitText:ComputePos()
    npcTradeShop._staticEarnProfitValue:ComputePos()
	npcTradeShop._staticEarnProfitCoin:ComputePos()
	npcTradeShop._petInventoryTitle:ComputePos()
	npcTradeShop._petInventoryValue:ComputePos()
	npcTradeShop._staticCategoryTotal:ComputePos()
	npcTradeShop._staticPossessMoneyText:ComputePos()
	npcTradeShop._staticPossessMoneyValue:ComputePos()
	npcTradeShop._staticPossessMoney:ComputePos()
	npcTradeShop._staticTotalMoneyText:ComputePos()
	npcTradeShop._staticTotalMoneyValue:ComputePos()
	npcTradeShop._staticTotalMoney:ComputePos()
	npcTradeShop._staticTotalWeightText:ComputePos()
	npcTradeShop._staticTotalWeight:ComputePos()
	npcTradeShop._StaticTextCartWeightLT:ComputePos()
	npcTradeShop._button_Confirm:ComputePos()
	npcTradeShop._currentWeightLT:ComputePos()
	npcTradeShop._vehicleWeightLT:ComputePos()
	npcTradeShop._vehicleWeightText:ComputePos()
	npcTradeShop._button_ClearList:ComputePos()
	npcTradeShop._button_Confirm_EnterVihicle:ComputePos()
	npcTradeShop._currentWeightText:ComputePos()
	npcTradeShop._buttonTradeGameStart:ComputePos()
	
	local basePosX = resizeControl.icon.icon:GetPosX()
	local basePosY = resizeControl.icon.icon:GetPosY()

	resizeControl.static_TextItemName:SetTextMode (UI_TM.eTextMode_AutoWrap)
	npcTradeShop:setControlPos( resizeControl.static_TextItemName, basePosX + 50, basePosY + 3 )

	basePosX = resizeControl.static_TextItemName:GetPosX()
	basePosY = resizeControl.static_TextItemName:GetPosY()
	npcTradeShop:setControlPos( resizeControl.static_Multiply, basePosX + 120, basePosY + 7 )

	basePosX = resizeControl.static_Multiply:GetPosX()
	basePosY = resizeControl.static_Multiply:GetPosY()
	npcTradeShop:setControlPos( resizeControl.button_Quantity, basePosX + 20, basePosY )

	basePosX = resizeControl.button_Quantity:GetPosX()
	basePosY = resizeControl.button_Quantity:GetPosY()
	npcTradeShop:setControlPos( resizeControl.static_Equal, basePosX + 30, basePosY )

	basePosX = resizeControl.static_Equal:GetPosX()
	basePosY = resizeControl.static_Equal:GetPosY()
	npcTradeShop:setControlPos( resizeControl.static_Cost, basePosX + 30, basePosY )

	basePosX = resizeControl.static_Cost:GetPosX()
	basePosY = resizeControl.static_Cost:GetPosY()
	npcTradeShop:setControlPos( resizeControl.static_CostIcon, basePosX + 40, basePosY )
	
	basePosX = resizeControl.static_CostIcon:GetPosX()
	basePosY = resizeControl.static_CostIcon:GetPosY()
	npcTradeShop:setControlPos( resizeControl.static_CostIcon, basePosX + 20, basePosY + 5 )
end

-- 무역 아이템 UI
function eventResetTradeUI()
	Panel_Npc_Trade_Market:SetPosY( getScreenSizeY() - Panel_Npc_Trade_Market:GetSizeY() )
	Panel_Npc_Trade_Market:SetSize( getScreenSizeX(), Panel_Npc_Trade_Market:GetSizeY() )
	
	npcTradeShop.buyListFrame:SetSize( npcTradeShop.buyListFrame:GetSizeX(), npcTradeShop.buyListFrame:GetSizeY() )
	npcTradeShop.buyListFrameContent:SetSize( npcTradeShop.buyListFrame:GetSizeX(), npcTradeShop.buyListFrame:GetSizeY() )
	Panel_Npc_Trade_Market:ComputePos()
	npcTradeShop.buyListFrame:ComputePos()
	npcTradeShop.buyListFrameContent:ComputePos()
	local tradeFrame = npcTradeShop.buyListFrame
	
	tradeFrame:SetPosX( Panel_Npc_Trade_Market:GetSizeX() - tradeFrame:GetSizeX() - 20 )
	
--	npcTradeShop.buyListFrame:UpdateContentScroll()
--	npcTradeShop.buyListFrame:UpdateContentPos()
	
	local buyListSizeX = npcTradeShop.buyListFrame:GetSizeX() - 300			-- 오른쪽 목록합계 사이즈 200
	local displaySizeX = buyListSizeX / 3;			-- 목록 리스트 그려질 시작 위치
	local displayPosY = npcTradeShop.buyListFrame:GetPosY();
	local posX = 0
	local posY = 0
	local col = -1

	for count = 1, tradeBuyMaxCount do
		local row = (count-1) % 3

		if 0 == row then
			col = col + 1
		end

		local rPosX = posX + (row * displaySizeX)
		local rPosY = posY + (col*50) + 5

		npcTradeShop:setSizeBuyListControl( count, rPosX, rPosY )
	end
end

function closeNpcTrade_Basket()
	SetUIMode( Defines.UIMode.eUIMode_NpcDialog )	-- 더 좋은 방법이 있기 전까지는 여기에서 UI Mode 를 변경해준다! - 성경
	setIgnoreShowDialog( false )
	-- SetUIMode( Defines.UIMode.eUIMode_Default )

	InventoryWindow_Close()		-- 닫을때 인벤도 닫는다.
	Panel_Tooltip_Item_hideTooltip()
	Panel_Npc_Dialog:SetShow( true, false )
	
	if Panel_Trade_Market_Graph_Window:IsShow() then
		Panel_Trade_Market_Graph_Window:SetShow( false )
	end
	
	if Panel_Npc_Trade_Market:IsShow() then
		Panel_Npc_Trade_Market:SetShow( false )
	end
	
	global_buyListExit()
	global_tradeSellListExit()

	--npcShop_SetRenderCharacterEdge(false)
	cutSceneCameraWaveMode(true)
	isNearActorEdgeShow(true)
	
	-- funcCamera 이름을 가져 온다.
	local mainCameraName = Dialog_getMainSceneCameraName()
	changeCameraScene( mainCameraName, 0.5 )

	global_IsTrading = false

	--hide_DialogPanel()
	local npcKey = dialog_getTalkNpcKey()
	if 0 ~= npcKey then
		closeClientChangeScene( npcKey )
	else
		UI.ASSERT( "키 설정이 되어 있지 않습니다. 어떻게 실행을 했을까..." )
	end
	--
end

function InitNpcTradeShopOpen()
	if false == global_IsTrading then
		if false == Panel_Npc_Dialog:IsShow() then	-- 패킷이 늦게 오는 도중에 dialog 창을 닫았을 경우도 있다 이런경우 무역으로 가지 않게 한다.
			return
		end
		-- npc 키가 곧 장면 키가 된다. 가져와서 설정해 주자
		local npcKey = dialog_getTalkNpcKey()
		if 0 ~= npcKey then
			openClientChangeScene( npcKey, 1 )
		end

		SetUIMode( Defines.UIMode.eUIMode_Trade )	-- 더 좋은 방법이 있기 전까지는 여기에서 UI Mode 를 변경해준다! - 성경
		setIgnoreShowDialog( true )
		global_IsTrading = true
		Panel_Npc_Dialog:SetShow( false, false )
		Panel_Npc_Trade_Market:SetShow( true )
		Panel_Trade_Market_Graph_Window:SetShow( true, false )

		global_setTradeUI(true)
		global_tradeSellListOpen()

		-- funcCamera 이름을 가져 온다.
		-- local funcCameraName = Dialog_getFuncSceneCameraName()
		-- changeCameraScene( funcCameraName, 0.5 )

		--npcShop_SetRenderCharacterEdge( true )
		
		------------------------------------------------------------------------------
		cutSceneCameraWaveMode( false )
		isNearActorEdgeShow(false)
		
		check_Servant_Inventory()
		
		npcTradeShop._staticEarnProfitValue:SetText( "0" )	
		npcTradeShop._staticEarnProfitValue:SetShow(false)
		npcTradeShop._staticEarnProfitText:SetShow(false)
		npcTradeShop._staticEarnProfitCoin:SetShow(false)
	end
	
	local talker = dialog_getTalker()
	local npcActorproxy = talker:get()
	local npcPosition = npcActorproxy:getPosition()
	local npcRegionInfo = getRegionInfoByPosition(npcPosition)

	local npcTradeNodeName = npcRegionInfo:getTradeExplorationNodeName()
	local npcTradeOriginRegion = npcRegionInfo:get():getTradeOriginRegion()
	local boolValue = checkSelfplayerNode( npcTradeOriginRegion._waypointKey, true )	-- 무역 상점과 연결된 Node에 PC가 투자한 상태라면 true, 아니면 false 값을 반환
	
	if not boolValue then 
		npcTradeShop._alertpanel:SetShow(true)
		npcTradeShop._alerttext:SetShow(true)		
		npcTradeShop._alertpanel				:SetSpanSize((getScreenSizeX() - npcTradeShop._alertpanel:GetSizeX())/2,(npcTradeShop._alertpanel:GetSizeY() + Panel_Npc_Trade_Market:GetSizeY() - getScreenSizeY())/2)		
		npcTradeShop._alerttext					:SetSpanSize((getScreenSizeX() - npcTradeShop._alerttext:GetSizeX())/2,(npcTradeShop._alerttext:GetSizeY() + Panel_Npc_Trade_Market:GetSizeY() - getScreenSizeY())/2)
		npcTradeShop._alerttext					:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_WindowTradeMarket_NeedInvest" ) .. " <PAColor0xAAFFFFFF>[ " .. npcTradeNodeName .. " ]<PAOldColor> " .. PAGetString(Defines.StringSheet_GAME, "Lua_WindowTradeMarket_NeedInvest2" ))
		
		local isNpcNodeCotrol = getDialogButtonIndexByType( CppEnums.ContentsType.Contents_Explore )	-- '탐험 거점 관리' 기능이 없는 NPC라면 -1 값을 반환한다.
		if ( -1 ~= isNpcNodeCotrol ) then		
			npcTradeShop._btnInvestNode			:SetSpanSize((getScreenSizeX() - npcTradeShop._btnInvestNode:GetSizeX())/2, npcTradeShop._alertpanel:GetPosY() + npcTradeShop._alertpanel:GetSizeY() + 10)
			npcTradeShop._btnInvestNode			:addInputEvent( "Mouse_LUp", "click_OpenWorldMap_InvestNode()" )
			npcTradeShop._btnInvestNode			:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_WindowTradeMarket_NodeButton" ))		
			npcTradeShop._btnInvestNode			:SetShow(true)
		else
			npcTradeShop._btnInvestNode			:SetShow(false)
		end
	else
		npcTradeShop._alertpanel				:SetShow(false)
		npcTradeShop._alerttext					:SetShow(false)
		npcTradeShop._btnInvestNode				:SetShow(false)
	end
	
	--if ( 0 >= FGlobal_MySellCount() ) then			-- 팔 무역품이 없거나 기운 부족 시 게임을 시작할 수 없다.
		--npcTradeShop._buttonTradeGameStart:SetShow( false )
	--else
		--npcTradeShop._buttonTradeGameStart:SetShow( true )
	--end
	
	-- 흥정 게임 버튼 초기화
	--npcTradeShop._buttonTradeGameStart:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_TRADEMARKET_TRADEGAME_MSG_1" ) )
	--npcTradeShop._buttonTradeGameStart:SetIgnore( false )
end

function click_OpenWorldMap_InvestNode()
	closeNpcTrade_Basket()
	local buttonIndex = getDialogButtonIndexByType( CppEnums.ContentsType.Contents_Explore )		-- 12 탐험노드
	HandleClickedFuncButton( buttonIndex )
end

function TradeShopGraphRefresh()
	if true == global_IsTrading then
		local rv = global_updateCurrentCommerce()			-- trendGraph일 경우만 false다 갱신 하지 않는다.
		if true == rv then
			global_sellItemFromPlayer()
			global_setBuyList()
		end
	end
end

function TradeShopMoneyRefresh()
	if true == global_IsTrading then
		if true == npcTradeShop._buyRequest then
			--global_setTradeUI()
			currentTradeSlot = 1
			npcTradeShop._numpadNumber = toInt64( 0 , 1)
			npcTradeShop:InitTradeMarket()
			npcTradeShop:initTradeData()
			TradeItem_BuySuccess()
			-- 여기 오면 구매 성공...
		end
		
		--local _const = Defines.s64_const
		local selfPlayerWrapper = getSelfPlayer()
		local selfPlayer = selfPlayerWrapper:get()
		local selfPlayerPossessableWeigh = selfPlayer:getPossessableWeight_s64()
		local selfPlayerCurrentWeigh = selfPlayer:getCurrentWeight_s64()
		
		npcTradeShop._myRemainWeight = selfPlayerPossessableWeigh - selfPlayerCurrentWeigh
		
		local itemWeightDiv100 = selfPlayerPossessableWeigh / const_64.s64_100
		--local str_int32weight = string.format( "%.1f", Int64toInt32( itemWeightDiv100 ) / 100 )
		local s64_CurrentWeight = selfPlayerCurrentWeigh / const_64.s64_100
		--local str_CurrentWeight = string.format("%.1f", Int64toInt32(s64_CurrentWeight) / 100 )
		
		local str_int32remainWeight = string.format( "%.1f", Int64toInt32( itemWeightDiv100 - s64_CurrentWeight ) / 100 )

		--UI.debugMessage( "str_int32remainWeight : " .. tostring( str_int32remainWeight ) .. " itemWeightDiv100: " .. tostring( itemWeightDiv100 ) .. " s64_CurrentWeight : " .. tostring( s64_CurrentWeight ) )
		--npcTradeShop._currentWeightLT:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "Lua_WindowTradeMarket_Weight", "Weight", tostring( str_CurrentWeight ) .. " / " .. tostring( str_int32weight ) ) )
		npcTradeShop._currentWeightLT:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "Lua_WindowTradeMarket_Weight", "Weight", tostring( str_int32remainWeight ) ) )
		npcTradeShop._staticPossessMoneyValue:SetText( makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()) )
		
		eventBuyFromNpcListRefesh()
		global_refreshScrollIndex()			-- 물품 판매후 UI 정리를 위해 호출
		Panel_Window_Inventory:SetShow( false, false )
	end
end

function TradeItem_BuySuccess()
	local tradeItemMessage		= PAGetString( Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_BUYING_SUCCESS" )
	npcTradeShop._alertpanel	:SetSpanSize((getScreenSizeX() - npcTradeShop._alertpanel:GetSizeX())/2,(npcTradeShop._alertpanel:GetSizeY() + Panel_Npc_Trade_Market:GetSizeY() - getScreenSizeY())/3)		
	npcTradeShop._alerttext		:SetSpanSize((getScreenSizeX() - npcTradeShop._alerttext:GetSizeX())/2,(npcTradeShop._alerttext:GetSizeY() + Panel_Npc_Trade_Market:GetSizeY() - getScreenSizeY())/3)
	npcTradeShop._alertpanel	:SetShow( true )
	npcTradeShop._alerttext		:SetShow( true )
	npcTradeShop._alerttext		:SetText( tradeItemMessage )
end

function npcTradeShop:registTradeShopEvent()
	registerEvent( "onScreenResize", "eventResetTradeUI" )
	--npcTradeShop._buttonExit:addInputEvent( "Mouse_LUp", "closeNpcTrade_Basket()" )
	
	registerEvent("EventNpcTradeShopUpdate", "InitNpcTradeShopOpen")
	registerEvent("EventNpcTradeShopGraphRefresh", "TradeShopGraphRefresh")
	registerEvent("FromClient_InventoryUpdate", "TradeShopMoneyRefresh")
	registerEvent("FromClient_ServantInventoryUpdate", "check_Servant_Inventory");
	-- UI.debugMessage( "등록" )
	

	--registerEvent("EventNpcShopUpdate", "tradeMarket_updateContent")
end

function refreshEarnProfit(profit)
	npcTradeShop._staticEarnProfitValue:SetText(tostring(profit))
	npcTradeShop._staticEarnProfitValue:SetShow(true)
	npcTradeShop._staticEarnProfitText:SetShow(true)
	npcTradeShop._staticEarnProfitCoin:SetShow(true)
end

npcTradeShop:registUiControl()
npcTradeShop:InitTradeMarket()
npcTradeShop:registTradeShopEvent()