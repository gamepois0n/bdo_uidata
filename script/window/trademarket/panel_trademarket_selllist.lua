---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ShopItemWrapper npcShop_getItemSell( slogNo )
-- checkSelfplayerNode( waypointkye, bool )	 노드 발견 : false 노드 투자 : true
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------
-- Panel Init
---------------------------

local VCK		= CppEnums.VirtualKeyCode
local UI_color	= Defines.Color
local isNA		= isGameTypeEnglish()

Panel_Trade_Market_Sell_ItemList:SetShow(false, false)
--Panel_Trade_Market_Sell_ItemList:SetIgnore( true )
Panel_Trade_Market_Sell_ItemList:SetAlpha( 1 )
Panel_Trade_Market_Sell_ItemList:setGlassBackground(true)

---------------------------
-- Local Variables
---------------------------
local UI_TM					= CppEnums.TextMode
local UI_ANI_ADV			= CppEnums.PAUI_ANIM_ADVANCE_TYPE

local _ItemPanel			= UI.getChildControl ( Panel_Trade_Market_Sell_ItemList, "Static_MiniPanel" )
local _TradeGamePanel		= UI.getChildControl ( Panel_Trade_Market_Sell_ItemList, "Static_MiniPanel_forTradeGame" )
local _SlotBG				= UI.getChildControl ( Panel_Trade_Market_Sell_ItemList, "Static_Slot" )				_SlotBG:SetShow( false )
local _ItemIcon				= UI.getChildControl ( Panel_Trade_Market_Sell_ItemList, "Static_Icon" )				_ItemIcon:SetShow( false )
local _RemainCount			= UI.getChildControl ( Panel_Trade_Market_Sell_ItemList, "StaticText_remainCount" )
local _NpcRemainCount		= UI.getChildControl ( Panel_Trade_Market_Sell_ItemList, "StaticText_NpcRemainCount" )
local _ItemName				= UI.getChildControl ( Panel_Trade_Market_Sell_ItemList, "StaticText_itemName" )
local _SellPrice			= UI.getChildControl ( Panel_Trade_Market_Sell_ItemList, "StaticText_sellPrice_Value" )
local _QuotationRate		= UI.getChildControl ( Panel_Trade_Market_Sell_ItemList, "StaticText_MarketPriceRate" )
local _AddCard				= UI.getChildControl ( Panel_Trade_Market_Sell_ItemList, "Button_AddCart" )
local _sellScroll			= UI.getChildControl ( Panel_Trade_Market_Sell_ItemList, "Frame_Scroll" )
local _distanceBonus		= UI.getChildControl ( Panel_Trade_Market_Sell_ItemList, "StaticText_DistanceBonus" )
local _distanceBonusValue	= UI.getChildControl ( Panel_Trade_Market_Sell_ItemList, "StaticText_DistanceBonusValue" )
local _distanceNoBonus		= UI.getChildControl ( Panel_Trade_Market_Sell_ItemList, "StaticText_NoBonus" )
local _desertBuff			= UI.getChildControl ( Panel_Trade_Market_Sell_ItemList, "StaticText_DesertBuff" )

local _profitStatic			= UI.getChildControl ( Panel_Trade_Market_Sell_ItemList, "StaticText_MySellPrice" )
local _profitGold			= UI.getChildControl ( Panel_Trade_Market_Sell_ItemList, "StaticText_Profit_Value" )	-- 이윤
local _noLink				= UI.getChildControl ( Panel_Trade_Market_Sell_ItemList, "StaticText_LinkedExplorationNode" )

local _expiration			= UI.getChildControl ( Panel_Trade_Market_Sell_ItemList, "StaticText_Option" )
local _tradePrice			= UI.getChildControl ( Panel_Trade_Market_Sell_ItemList, "StaticText_TradePrice" )
local _btnSellAllItem		= UI.getChildControl ( Panel_Trade_Market_Sell_ItemList, "Button_AllTradeItemSell" )
local _btnTradeGame			= UI.getChildControl ( Panel_Trade_Market_Sell_ItemList, "Button_TradeGameStart" )
_btnSellAllItem:addInputEvent( "Mouse_LUp", "HandleClicked_TradeItem_AllSellQuestion()" )
_btnTradeGame:addInputEvent( "Mouse_LUp", "click_TradeGameStart()" )

local e1Percent = 10000
local e100Percent = 1000000
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local tradeSellMarket =
{
	maxSellCount			= 7,
	currentItemCount		= 0,
	scrollIndex				= 0,
	
	itemsStartPosY			= 25,
	intervalPanel			= 10,
	_isNoLinkedNodeOne		= false, 		-- 판매할 아이템중 하나라도 노드 연결이 안된 아이템이 있을 경우 메시지 박스를 띄워주기 위한 용도임
	_isLinkedNode			= {},			-- 
	
	remainItemCount			= {},
	itemProfit				= {},
	vehicleItem				= {},
	vehicleActorKey			= {},
	expirationDate			= {},
	
	slotConfig =
	{
		createIcon			= true,
		createBorder		= true,
		createCount			= false,
		createExpiration	= true,
		createCash			= true,
	},
	
	ListBody				= {},
	ListBodyGame			= {},
	itemSlot_BG				= {},
	remainCount				= {},
	npcRemainCount			= {},
	itemName				= {},
	sellPrice				= {},
	Quotation				= {},
	AddCart					= {},
	profitStatic			= {},
	profitGold				= {},	-- 이윤
	noLink					= {},	-- 연결안됨
	desertBuff				= {},	-- 사막 버프
	itemEnchantKey			= {},
	itemIndex				= {},
	expiration				= {},
	DistanceBonus			= {},
	DistanceBonusValue		= {},
	DistanceNoBonus			= {},
	tradePrice				= {},
	
	icons					= {},
	
	totalProfit				= toInt64( 0, 0 ),
}

---------------------------
-- Global
---------------------------
function global_tradeSellListExit()
	if Panel_Trade_Market_Sell_ItemList:IsShow() then
		Panel_Trade_Market_Sell_ItemList:SetShow( false )
	end
	FGlobal_isTradeGameSuccess()
end

function global_tradeSellListOpen()
	FGlobal_isTradeGameSuccess()
	
	-- 밀 무역상이면 셀리스트 열지 않음
	local talker = dialog_getTalker()
	if nil ~= talker then
		local actorKeyRaw = talker:getActorKey()
		local actorProxyWrapper = getNpcActor(actorKeyRaw)
		local actorProxy = actorProxyWrapper:get()
		local characterStaticStatus = actorProxy:getCharacterStaticStatus()
		if true == characterStaticStatus:isSmuggleMerchant() then
			return
		end
	end
	
	Panel_Trade_Market_Sell_ItemList:SetShow( true )
	tradeSellMarket.totalProfit = toInt64( 0, 0 )

	for count = 1, 10 do
		tradeSellMarket:setShowTradeIcon( count, false )
	end
	
	tradeSellMarket._isNoLinkedNodeOne = false

	_sellScroll:SetControlPos( 0 )
	tradeSellMarket.scrollIndex = 0
	global_sellItemFromPlayer()
	
	local talker = dialog_getTalker()

	local npcActorproxy = talker:get()
	local npcPosition = npcActorproxy:getPosition()
	local npcRegionInfo = getRegionInfoByPosition(npcPosition)

	local npcTradeOriginRegion = npcRegionInfo:get():getTradeOriginRegion()
	local boolValue = checkSelfplayerNode( npcTradeOriginRegion._waypointKey, false )
end

-- 판매 되고 난후 갱신 되어야 할 정보들...
function global_refreshScrollIndex()
	if false == global_IsTrading then
		return
	end
	
	local mySellCount = npcShop_getSellCount()
	local vhicleSellCount = npcShop_getVehicleSellCount()
	local isValidDistance = getDistanceFromVehicle()
	
	if false == isValidDistance then
		vhicleSellCount = 0
	end
	
	local sellCount = mySellCount + vhicleSellCount
	
	if tradeSellMarket.maxSellCount < sellCount and	sellCount < tradeSellMarket.scrollIndex + tradeSellMarket.maxSellCount then
		tradeSellMarket.scrollIndex = tradeSellMarket.scrollIndex - 1
		local controlPos = tradeSellMarket.scrollIndex / (sellCount - tradeSellMarket.maxSellCount)
		if 1 < controlPos then
			controlPos = 1
		end
		_sellScroll:SetControlPos( controlPos )
	end
end

local _sellCount = 0
---------------------------
-- Functions
---------------------------
local showTradeItemList = {}
local _commerceIndex = 1
function global_sellItemFromPlayer()
	_sellCount = 0

	local mySellCount = npcShop_getSellCount()
	local vhicleSellCount = npcShop_getVehicleSellCount()
	local isValidDistance = getDistanceFromVehicle()
	
	if false == isValidDistance then
		vhicleSellCount = 0
	end
	local sellCount = mySellCount + vhicleSellCount

	-- 밀 무역상이면 셀리스트 열지 않음
	local talker = dialog_getTalker()
	if nil ~= talker then
		local actorKeyRaw = talker:getActorKey()
		local actorProxyWrapper = getNpcActor(actorKeyRaw)
		local actorProxy = actorProxyWrapper:get()
		local characterStaticStatus = actorProxy:getCharacterStaticStatus()
		if true == characterStaticStatus:isSmuggleMerchant() then
			return
		end
	end	
	
	if 0 < sellCount then
		Panel_Trade_Market_Sell_ItemList:SetShow( true )
	else
		Panel_Trade_Market_Sell_ItemList:SetShow( false )
	end
	
	_sellCount = sellCount
	
	if 0 >= sellCount then
		return
	end

	for count = 1, 10 do
		tradeSellMarket:setShowTradeIcon( count, false )
	end

	local commerceIndex = 1
	local inventory = getSelfPlayer():get():getInventory()
	
	--local showTradeItemList = {}
	table.remove( showTradeItemList )

	local addScrollIndex = 1
	for ii = 1, tradeSellMarket.maxSellCount do
		addScrollIndex = ii
		local indexNum = tradeSellMarket.scrollIndex + addScrollIndex -1
		
		if indexNum >= mySellCount then
			break
		end
		
		local shopItemWrapper = npcShop_getItemSell( indexNum )		-- shopItemWrapper
		
		if nil ~= shopItemWrapper then
			local tradeItemInfo =
			{
				_isMyInventory	= true,
				_indexNumber	= indexNum,
				_itemKey		= shopItemWrapper:getStaticStatus():get()._key:get(),
			}

			showTradeItemList[commerceIndex] = tradeItemInfo
			commerceIndex = commerceIndex + 1
		else
			--UI.debugMessage( "break" )
			break
		end
	end
	
	local	vehicleIndex		= 0
	local	servertInventorySize= 0
	local	temporaryWrapper	= getTemporaryInformationWrapper()
	local	servantInfo			= temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
	if	nil ~= servantInfo	then
		local	servertinventory	= servantInfo:getInventory()
		if	nil ~= servertinventory	then
			servertInventorySize = servertinventory:size()
			if true == isValidDistance and commerceIndex <= tradeSellMarket.maxSellCount then
				vehicleIndex = tradeSellMarket.scrollIndex + tradeSellMarket.maxSellCount - mySellCount	-- 표시될 탈것 아이템 갯수
				local slotCountIndex = 1
				local clucValue = vehicleIndex - tradeSellMarket.maxSellCount
				if clucValue > 0 then
					slotCountIndex = slotCountIndex + clucValue
				end
		
				local vehicleTradeItemCount = slotCountIndex
				for slotCount = slotCountIndex, servertInventorySize - 1 do		-- 0은 돈
					if not servertinventory:empty( slotCount ) then --and nil ~= npcShop_getVehicleSellItem( slotCount - 1 ) then	-- npcShop_getVehicleSellItem 체크 값은 0 부터
						local servertitemWrapper = npcShop_getVehicleSellItem( vehicleTradeItemCount - 1 )
						if nil == servertitemWrapper then
						end
						if vehicleTradeItemCount > vhicleSellCount then
							break
						end
						local itemStaticStaus = servertitemWrapper:getStaticStatus()			-- itemWrapper 를 반환
						if true == itemStaticStaus:isForJustTrade() then
							addScrollIndex = addScrollIndex + 1
							local indexNum = tradeSellMarket.scrollIndex + addScrollIndex - 1
							local tradeItemInfo =
							{
								_isMyInventory	= false,
								_indexNumber	= vehicleTradeItemCount - 1,		-- 탈것의 무역품은 다시 count한다.
								_itemKey		= itemStaticStaus:get()._key:get(),
							}
		
							showTradeItemList[commerceIndex] = tradeItemInfo

							commerceIndex = commerceIndex + 1
							vehicleTradeItemCount = vehicleTradeItemCount + 1
		
							if commerceIndex > tradeSellMarket.maxSellCount then
								break
							end
						else
						end
					end
				end
			end
		end
	end

	local myLandVehicleActorKey	= nil
	local landVehicleActorProxy	= nil
	local isLinkedNode			= false
	
	if nil ~= servantInfo	then
		myLandVehicleActorKey	= servantInfo:getActorKeyRaw()
	end
	
	if nil ~= myLandVehicleActorKey then
		landVehicleActorProxy = getVehicleActor( myLandVehicleActorKey )
	end
	
	local selfPlayer = getSelfPlayer()
	local selfPlayerRegion = getRegionInfoByPosition( selfPlayer:get():getPosition() )
	local selfPlayerTradeOriginRegion = selfPlayerRegion:get():getTradeOriginRegion()
	local selfPlayerPosition = selfPlayerTradeOriginRegion:getWaypointInGamePosition()
	local tradeBonusPercent = FromClient_getTradeBonusPercent()
	local isExistTradeOrigin = true
	local characterStaticStatusWrapper = npcShop_getCurrentCharacterKeyForTrade()
	local characterStaticStatus = characterStaticStatusWrapper:get()
	local _isSupplyMerchant = characterStaticStatus:isSupplyMerchant()
	local _isFishSupplyMerchant = characterStaticStatus:isFishSupplyMerchant()

	for count = 1, commerceIndex - 1 do
		local tradeItemInfoList	= showTradeItemList[ count ]
		local indexNum			= tradeItemInfoList._indexNumber
		tradeSellMarket._isLinkedNode[count]	= false

		tradeSellMarket.itemEnchantKey[count]	= tradeItemInfoList._itemKey
		tradeSellMarket.itemIndex[count]		= indexNum
		
		local tradeItemWrapper = npcShop_getTradeItem( tradeItemInfoList._itemKey )
			
		if nil == tradeItemWrapper then
			break
		end
		
		tradeSellMarket:setShowTradeIcon( count, true )

		local _leftPeriod
		local s64_TradeItemNo = toInt64( 0, 0 )
		local s64_inventoryItemCount = toInt64( 0, 0 )
		local itemValueType = nil
		local f_sellRate = 0.0
		local profitItemGold = toInt64( 0, 0 )
		local realPrice = 0
		if true == tradeItemInfoList._isMyInventory then			-- 자기 인벤토리 아이템
			s64_TradeItemNo			= npcShop_getItemNo(indexNum)
			s64_inventoryItemCount	= inventory:getItemCountByItemNo_s64( s64_TradeItemNo )
			itemValueType = inventory:getItemByItemNo( s64_TradeItemNo )

			realPrice = fillSellTradeItemInfo( count, indexNum, itemValueType, tradeItemWrapper, characterStaticStatus, selfPlayerPosition, 0 )

			tradeSellMarket.vehicleItem[count]		= 0
			tradeSellMarket.vehicleActorKey[count]	= 0
			
			tradeSellMarket:setBuyItemDataInfo( count, tradeItemWrapper:getStaticStatus():getName(), s64_inventoryItemCount, realPrice, tradeItemWrapper:getLeftCount() )	--  itemStatus:getSellPriceCalculate()

			local itemWrapper	= npcShop_getItemWrapperByShopSlotNo( indexNum )			
			tradeSellMarket.noLink[count]:SetText( itemWrapper:getProductionRegion() ) -- "원산지 : " .. itemWrapper:getProductionRegion())
			tradeSellMarket.icons[count]:setItemByStaticStatus( tradeItemWrapper:getStaticStatus(), nil, tradeSellMarket.expirationDate[ count ] )
			tradeSellMarket.icons[count].icon:addInputEvent( "Mouse_On", "tradeItem_toolTip_Show(" .. indexNum .. ", \"tradeMarket_Sell\" )" )
			tradeSellMarket.icons[count].icon:addInputEvent( "Mouse_Out", "tradeItem_toolTip_Hide()" )
			Panel_Tooltip_Item_SetPosition(indexNum, tradeSellMarket.icons[count], "tradeMarket_Sell")
			tradeSellMarket.expiration[count]:SetShow( true )
		else 														-- 다른 물품관련( 탈것 인벤 )
			s64_TradeItemNo = npcShop_getVehicleInvenItemNoByShopSlotNo( indexNum )
			
			if nil == landVehicleActorProxy then
				-- 탈것 정보가 없습니다.
				break
			end
			
			local vehicleInven = landVehicleActorProxy:get():getInventory()
			s64_inventoryItemCount = vehicleInven:getItemCountByItemNo_s64( s64_TradeItemNo )
			
			itemValueType = vehicleInven:getItemByItemNo( s64_TradeItemNo )
			
			realPrice = fillSellTradeItemInfo( count, indexNum, itemValueType, tradeItemWrapper, characterStaticStatus, selfPlayerPosition, 4 )
			
			tradeSellMarket.vehicleItem[ count ] = 4		-- toWhere
			tradeSellMarket.vehicleActorKey[ count ] = myLandVehicleActorKey
			tradeSellMarket:setBuyItemDataInfo( count, PAGetStringParam1( Defines.StringSheet_GAME, "LUA_TRADEMARKET_RIDE", "getName", tradeItemWrapper:getStaticStatus():getName() ), s64_inventoryItemCount, realPrice, tradeItemWrapper:getLeftCount() )

			local vehilcleItemWrapper = npcShop_getVehicleItemWrapper( indexNum )
			tradeSellMarket.noLink[count]:SetText( vehilcleItemWrapper:getProductionRegion() ) -- "원산지 : " .. vehilcleItemWrapper:getProductionRegion() )
			tradeSellMarket.icons[count]:setItemByStaticStatus( vehilcleItemWrapper:getStaticStatus(), nil, tradeSellMarket.expirationDate[ count ] )
			tradeSellMarket.icons[count].icon:addInputEvent( "Mouse_On", "tradeItem_toolTip_Show(" .. indexNum .. ", \"tradeMarket_VehicleSell\")" )
			tradeSellMarket.icons[count].icon:addInputEvent( "Mouse_Out", "tradeItem_toolTip_Hide()" )
			Panel_Tooltip_Item_SetPosition(indexNum, tradeSellMarket.icons[count], "tradeMarket_VehicleSell")
			tradeSellMarket.expiration[count]:SetShow( true )
		end
	end

	tradeSellMarket.currentItemCount = sellCount
	_sellScroll:SetInterval( commerceIndex )
	
	if sellCount < commerceIndex then
		_sellScroll:SetShow( false )
	else
		_sellScroll:SetShow( true )
	end
	
	_commerceIndex = commerceIndex
end

function fillSellTradeItemInfo( count, indexNum, itemValueType, tradeItemWrapper, characterStaticStatus, selfPlayerPosition, inventoryType )
	local isSupplyMerchant = characterStaticStatus:isSupplyMerchant()
	local isFishSupplyMerchant = characterStaticStatus:isFishSupplyMerchant()

	local itemExpiration = itemValueType:getExpirationDate()
	-- 가격 보증 기간
	
	local _displayleftPeriod
	local leftPeriod = FromClient_getTradeItemExpirationDate( itemExpiration, tradeItemWrapper:getStaticStatus():get()._expirationPeriod )
	if isFishSupplyMerchant then				-- 황실 낚시 납품이면,
		if 300000 < leftPeriod then			-- 가격 보증 기간은 30 아니면 100이다
			leftPeriod = 1000000
		end
	end
	
	_displayleftPeriod = leftPeriod / e1Percent
	local leftPeriodString = _displayleftPeriod .. "%"
	
	if itemExpiration:isDefined() and false == itemExpiration:isIndefinite() then
		local s64_Time = itemExpiration:get_s64()
		local s64_remainTime = getLeftSecond_s64( itemExpiration )

		if ( Defines.s64_const.s64_0 == s64_remainTime ) then
			tradeSellMarket.expirationDate[count] = 1
		else
			tradeSellMarket.expirationDate[count] = 0
		end
	else
		tradeSellMarket.expirationDate[count] = -1
	end
	tradeSellMarket.expiration[count]:SetText( leftPeriodString ) -- "가격 보증 : " .. leftPeriod .. " %")

	-- item region
	local regionInfo = itemValueType:getItemRegionInfo()		-- regionInfo			
	local fromPosition = float3(0,0,0)
	if 0 ~= regionInfo._waypointKey then
		fromPosition = regionInfo:getWaypointInGamePosition()
	end
	
	local f_sellRate = 0.0
	local isExistTradeOrigin = true
	local profitItemGold = toInt64( 0, 0 )
	f_sellRate		= tradeItemWrapper:getSellPriceRate()						-- 시세
	local realPrice = getCalculateTradeItemPrice( tradeItemWrapper:getTradeSellPrice(), tradeItemWrapper:getStaticStatus():getCommerceType(), fromPosition, selfPlayerPosition, tradeItemWrapper:getTradeGroupType(), characterStaticStatus:getTradeGroupType(), leftPeriod, isTradeGameSuccess() )

	local fromToDistanceNavi = 0
	if 0 ~= regionInfo._waypointKey then
		fromToDistanceNavi = getFromToDistanceTradeShop()
	else
		isExistTradeOrigin = false
	end
	
	-- 사막 버프 아이콘 표시
	local desertBuffPercent = ToClient_TradeGroupFromToAddPercent( tradeItemWrapper:getTradeGroupType(), characterStaticStatus:getTradeGroupType() )
	if 100 < desertBuffPercent then
		tradeSellMarket.desertBuff[count]:SetShow(true)
	else
		tradeSellMarket.desertBuff[count]:SetShow(false)
	end

	-- 거리 보너스
	local bonusPercent = 0
	bonusPercent = math.floor((fromToDistanceNavi/100)*FromClient_getTradeBonusPercent() )
	local bonosPercentString = (bonusPercent/e1Percent)-(bonusPercent/e1Percent)%1 .."%"
	tradeSellMarket.DistanceBonusValue[count]:SetText( bonosPercentString )
	tradeSellMarket.DistanceNoBonus[count]:SetShow( false )

	local isLinkedNode			= false
	isLinkedNode = npcShop_CheckLinkedItemExplorationNode( indexNum, inventoryType )
	if not isLinkedNode then
		tradeSellMarket._isNoLinkedNodeOne = true
		realPrice = Int64toInt32( tradeItemWrapper:getStaticStatus():get()._originalPrice_s64 ) * getNotLinkNodeSellPercent() / e1Percent / 100
		f_sellRate = getNotLinkNodeSellPercent() / e1Percent
		
		if false == isExistTradeOrigin then
			realPrice = Int64toInt32( tradeItemWrapper:getStaticStatus():get()._originalPrice_s64 )
			f_sellRate = 100
		end
		
		profitItemGold = toInt64( 0, realPrice ) - itemValueType:getBuyingPrice()
		tradeSellMarket.DistanceNoBonus[count]:SetShow( true )
		tradeSellMarket.DistanceBonusValue[count]:SetShow( false )
		tradeSellMarket.DistanceBonus[count]:SetShow( false )
		tradeSellMarket._isLinkedNode[count] = false
	else
		profitItemGold = realPrice - itemValueType:getBuyingPrice()
		tradeSellMarket._isLinkedNode[count] = true
	end
	
	-- 이하 공통
	-- 시세가 300,000%로 나오는 것에 대한 방어코드, 시세가 1000%를 넘으면 30%로 바꿔준다! 일단은 미봉책!
	local str_sellRate = string.format( "%.f", f_sellRate )
	local str_sellRate_Value = PAGetStringParam1( Defines.StringSheet_GAME, "Lua_TradeMarketSellList_Percents", "Percent", str_sellRate )
	if 100 < tonumber(tostring(str_sellRate)) then
		str_sellRate_Value = "<PAColor0xFFFFCE22>" .. str_sellRate_Value .. "▲<PAOldColor>"
	else
		str_sellRate_Value = "<PAColor0xFFF26A6A>" .. str_sellRate_Value .. "▼<PAOldColor>"
	end
	tradeSellMarket.Quotation[count]:SetText( str_sellRate_Value )
	if profitItemGold < toInt64( 0, 0 ) then	 -- 이윤
		local profitItemGold_abs = toInt64(0, math.abs(Int64toInt32(profitItemGold)))		-- 형 변환 유의. math.abs는 int32만 가능
		tradeSellMarket.profitGold[count]:SetFontColor( UI_color.C_FFD20000 )
		tradeSellMarket.profitGold[count]:SetText( "-" .. makeDotMoney(profitItemGold_abs))	-- makeDotMoney에는 양수만 넣자!, makeDotMoney는 int64
	else
		tradeSellMarket.profitGold[count]:SetFontColor( UI_color.C_FFFFCE22 )
		tradeSellMarket.profitGold[count]:SetText( makeDotMoney(profitItemGold) )		-- 여기에 진짜 이윤을 넣자. 100% - 현시세
	end

	tradeSellMarket.noLink[count]:SetShow(true)

	tradeSellMarket.AddCart[count]:SetPosY( tradeSellMarket.noLink[count]:GetPosY() + tradeSellMarket.noLink[count]:GetTextSizeY() + 10 )

	tradeSellMarket.itemProfit[count] = profitItemGold
	tradeSellMarket.icons[count].icon:SetShow(true)
	
	-- 황실 요리납품일 경우 세팅을 변경해준다
	if true == isSupplyMerchant or (isFishSupplyMerchant) then
		local profitRate = string.format( "%.f", tradeItemWrapper:getSellPriceRate() )
		if not isLinkedNode and isFishSupplyMerchant then
			profitRate = 30
		end
		local sellPrice = Int64toInt32( tradeItemWrapper:getStaticStatus():get()._originalPrice_s64 )
		str_sellRate_Value = "<PAColor0xFFFFCE22>" .. profitRate .. "%▲<PAOldColor>"
		tradeSellMarket.Quotation[count]:SetText( str_sellRate_Value )
		tradeSellMarket.profitGold[count]:SetFontColor( UI_color.C_FFFFCE22 )
		tradeSellMarket.profitGold[count]:SetText( makeDotMoney( sellPrice * profitRate/100 * _displayleftPeriod/100 ))
		tradeSellMarket.sellPrice[count]:SetText( makeDotMoney( sellPrice * profitRate/100 * _displayleftPeriod/100 ))
	end
	
	return realPrice
end

function FGlobal_MySellCount()
	return _sellCount
end

function HandleClicked_TradeItem_AllSellQuestion()
	local	messageBoxMemo = ""
	if true == tradeSellMarket._isNoLinkedNodeOne then
		messageBoxMemo = PAGetString( Defines.StringSheet_GAME, "Lua_TradeMarketSellList_TradeItemAllSellQuestion_NodeLink" )
	else
		messageBoxMemo = PAGetString( Defines.StringSheet_GAME, "Lua_TradeMarketSellList_TradeItemAllSellQuestion" )
	end
	
	local	messageBoxData = { title = PAGetString( Defines.StringSheet_GAME, "Lua_TradeMarketSellList_NeedNodeLinkTitle" ), content = messageBoxMemo, functionYes = HandleClicked_TradeItem_AllSell, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData)
end

function HandleClicked_TradeItem_AllSell()
	local inventory			= getSelfPlayer():get():getInventory()
	local s64_inventoryItemCount = toInt64( 0, 0 )
	local s64_TradeItemNo	= toInt64( 0, 0 )
	local temporaryWrapper	= getTemporaryInformationWrapper()
	local servantInfo		= temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
	
	local talker = dialog_getTalker()
	if nil ~= talker then
		local actorKeyRaw = talker:getActorKey()
		local actorProxyWrapper = getNpcActor(actorKeyRaw)
		local actorProxy = actorProxyWrapper:get()
		local characterStaticStatus = actorProxy:getCharacterStaticStatus()
		if true == characterStaticStatus:isSupplyMerchant() or true == characterStaticStatus:isFishSupplyMerchant() then
			if 0 < math.floor( Int64toInt32(inventory:getWeight_s64()) / Int64toInt32(getSelfPlayer():get():getPossessableWeight_s64()) ) then
				Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarket_Not_Enough_Weight") )
				return
			end
		end
	end
	
	local myInventortySellAbleCount = npcShop_getSellCount()
	
	for ii = 0, myInventortySellAbleCount do
		local shopItemWrapper = npcShop_getItemSell(ii)
		
		if nil ~= shopItemWrapper then
			local tradeType = shopItemWrapper:getStaticStatus():get()._tradeType			-- tradeType이 5면 길드 납품템. 길드 창고로 돈이 들어감!
			s64_TradeItemNo = npcShop_getItemNo(ii)
			s64_inventoryItemCount = inventory:getItemCountByItemNo_s64( s64_TradeItemNo )

			for kk = 1, Int64toInt32( s64_inventoryItemCount ) do
				if 5 == tradeType then
					npcShop_doSellInTradeShop( ii, 1, 0, 14 )
				else
					npcShop_doSellInTradeShop( ii, 1, 0, 0 )
				end
			end
			--end
		end
	end

	if	nil ~= servantInfo	then
		local	servertinventory	= servantInfo:getInventory()
		if	nil ~= servertinventory	then
			local servertInventorySize = servertinventory:size()

			local emptyCount = 0
			for slotCount = 2, servertInventorySize - 1 do			-- 0은 돈
				if not servertinventory:empty( slotCount ) then	 	--and nil ~= npcShop_getVehicleSellItem( slotCount - 1 ) then	-- npcShop_getVehicleSellItem 체크 값은 0 부터
					local s64_VehicleItemNo = npcShop_getVehicleInvenItemNoByShopSlotNo( slotCount - 2 - emptyCount )
					if nil ~= s64_VehicleItemNo then
						local vehicleItemCount = Int64toInt32( servertinventory:getItemCountByItemNo_s64( s64_VehicleItemNo ) )
						local servertitemWrapper = npcShop_getVehicleSellItem( slotCount - 2 - emptyCount )
						if nil ~= servertitemWrapper then
						--	if 0 ~= regionInfo._waypointKey then
							for vehicleCnt = 1, vehicleItemCount do
								npcShop_doSellInTradeShop( slotCount - 2 - emptyCount, 1, 4, 0 )
							end
						--	end
						end						
					end
				else
					emptyCount = emptyCount + 1
				end
			end
			--end
		end
	end
	
	tradeSellMarket._isNoLinkedNodeOne = false
end

function click_TradeGameStart()
	local talker = dialog_getTalker()
	if nil == talker then
		return
	end
	
	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		return
	end

	-- 흥정게임 창이 열려 있다면,
	if Panel_TradeGame:GetShow() then
		-- 게임이 끝났으면 창을 닫아주고 리턴, 아니면 그냥 리턴
		if true == isTradeGameFinish() then
			Fglobal_TradeGame_Close()
		end
		return
	end
	
	local wp = selfPlayer:getWp()
	if ( 0 >= FGlobal_MySellCount() ) then			-- 팔 무역품이 없거나 기운 부족 시 게임을 시작할 수 없다.
		local	messageBoxMemo = PAGetString( Defines.StringSheet_GAME, "LUA_TRADEMARKET_TRADEGAME_MSG_2" )				--"판매할 수 있는 무역품이 없어 흥정을\n시작할 수 없습니다."
		local	messageBoxData = { title = PAGetString( Defines.StringSheet_GAME, "LUA_TRADEMARKET_TRADEGAME_MSG_1" ), content = messageBoxMemo, functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
		return
	end

	if  ( 5 > wp ) then
		local	messageBoxMemo = PAGetString( Defines.StringSheet_GAME, "LUA_TRADEMARKET_TRADEGAME_MSG_3" )				--"기운이 부족해 가격을 흥정할 수\n없습니다."
		local	messageBoxData = { title = PAGetString( Defines.StringSheet_GAME, "LUA_TRADEMARKET_TRADEGAME_MSG_1" ), content = messageBoxMemo, functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
		return
	end
	
	local	messageBoxMemo = PAGetString( Defines.StringSheet_GAME, "LUA_TRADEMARKET_TRADEGAME_MSG_4" ) .. " " .. PAGetStringParam1( Defines.StringSheet_GAME, "LUA_WORKERRANDOMSELECT_NOWWP", "getWp", wp )
	local	messageBoxData = { title = PAGetString( Defines.StringSheet_GAME, "LUA_TRADEMARKET_TRADEGAME_MSG_1" ), content = messageBoxMemo, functionYes = TradeGameStart, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData)
end

function TradeGameStart()
	local talker = dialog_getTalker()
	if nil == talker then
		return
	end
	ToClient_TradeGameStart( talker:getActorKey() )
end

-- 아이템 정보 표시
function tradeSellMarket:setBuyItemDataInfo( index, itemName, leftCount, price, possibleCount )

	tradeSellMarket.ListBody[index]:EraseAllEffect()
	_btnTradeGame:EraseAllEffect()
	
	tradeSellMarket.itemName[index]:SetTextMode( UI_TM.eTextMode_Limit_AutoWrap )
	tradeSellMarket.itemName[index]:setLineCountByLimitAutoWrap(2)			-- 2줄째 이후 .... 표시
	
	local wp = getSelfPlayer():getWp()
	local sellPrice = Int64toInt32(price)
	if ( true == isTradeGameSuccess() ) then					-- 흥정 성공??
		_btnTradeGame:SetIgnore( true )
		_btnTradeGame:SetMonoTone( true )
		_btnTradeGame:AddEffect("UI_TradeMarket_Scale", true, -41, -1)				-- 흥정 게임 버튼 이펙트!
		if ( true == checkLinkedNode(index) ) then				-- 노드 연결??
			tradeSellMarket.ListBody[index]:AddEffect("UI_Trade_SellRing", true, 0, 0)	
			tradeSellMarket.itemName[index]:SetText( tostring(itemName) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_SELLLIST_TRADEGAME") )-- <PAColor0xFF66CC33>흥정 보너스 적용<PAOldColor>")
		else													-- 흥정이 성공해도 노드 연결이 돼있지 않으면 이펙트 적용하지 않음
			tradeSellMarket.itemName[index]:SetText( tostring(itemName) )
		end
	elseif wp < 5 then											-- 기운 충분?
		_btnTradeGame:SetIgnore( true )
		_btnTradeGame:SetMonoTone( true )
		if isNA then
			_btnTradeGame:AddEffect("UI_TradeMarket_Scale", true, -95, -1)				-- 흥정 게임 버튼 이펙트!
		else
			_btnTradeGame:AddEffect("UI_TradeMarket_Scale", true, -41, -1)				-- 흥정 게임 버튼 이펙트!
		end
		tradeSellMarket.itemName[index]:SetText( tostring(itemName) )
	else														-- 흥정 게임 가능한 상황!
		_btnTradeGame:SetIgnore( false )
		_btnTradeGame:SetMonoTone( false )
		if isNA then
			-- _btnTradeGame:AddEffect("UI_TradeMarket_ScaleButton", true, -41, -1)			-- 흥정 게임 버튼 이펙트!
			_btnTradeGame:AddEffect("UI_TradeMarket_Scale", true, -95, -1)				-- 흥정 게임 버튼 이펙트!
		else
			_btnTradeGame:AddEffect("UI_TradeMarket_ScaleButton", true, 0, -1)			-- 흥정 게임 버튼 이펙트!
			_btnTradeGame:AddEffect("UI_TradeMarket_Scale", true, -41, -1)				-- 흥정 게임 버튼 이펙트!
		end
		tradeSellMarket.itemName[index]:SetText( tostring(itemName) )
	end
		
	tradeSellMarket.sellPrice[index]:SetText( makeDotMoney(sellPrice) )
	tradeSellMarket.remainItemCount[ index ] = leftCount
	
	tradeSellMarket.remainCount[index]:SetText( tostring( leftCount ) )
	
	if	( possibleCount == Defines.s64_const.toInt64 )	then
		tradeSellMarket.npcRemainCount[index]:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_TRADEMARKET_SELLLIST_NPCREMAINCOUNT", "possibleCount", tostring(possibleCount))) -- "매입 : " .. tostring( possibleCount ) )
	else
		tradeSellMarket.npcRemainCount[index]:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_SELLLIST_REMAININFINITY") ) -- "무제한" )
	end
	
	-- 황실 납품 체크
	local characterStaticStatusWrapper = npcShop_getCurrentCharacterKeyForTrade()
	local characterStaticStatus = characterStaticStatusWrapper:get()

	if true == characterStaticStatus:isTerritorySupplyMerchant() then					-- 황실 납품이냐?
		tradeSellMarket.AddCart[index]:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_SELLLIST_SELLMARKET") ) -- "납 품")
		_btnSellAllItem:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_SELLLIST_SELLALLITEM") ) -- "전체 납품")
	else
		tradeSellMarket.AddCart[index]:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_SELLLIST_TRADLESELLMARKET") ) -- "판 매")
		_btnSellAllItem:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_SELLLIST_TRADLESELLMARKETALL") ) -- "전체 판매")
	end
	
	if true == characterStaticStatus:isSupplyMerchant() or characterStaticStatus:isFishSupplyMerchant() then
		_btnTradeGame:SetShow( false )
		tradeSellMarket.DistanceBonusValue[index]:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_SELLLIST_NOTAPPLY")) -- "미적용" )
	else
		_btnTradeGame:SetShow( true )
	end
end

function checkLinkedNode( index )
	return tradeSellMarket._isLinkedNode[index]
end

function NpcTradeSell_ScrollEvent( isUpscroll )
	tradeSellMarket.scrollIndex	= UIScroll.ScrollEvent( _sellScroll, isUpscroll, tradeSellMarket.maxSellCount, tradeSellMarket.currentItemCount, tradeSellMarket.scrollIndex, 1 )
	global_sellItemFromPlayer()
	-- 툴팁을 끄자
	tradeItem_toolTip_Hide()
end

function NpcTradeSell_LupEvent( index )
	if index < 0 then
		return
	end

	local tradeItemInfo = showTradeItemList[ index ]
	local tradeItemWrapper = npcShop_getTradeItem( tradeItemInfo._itemKey )
	
	local itemSS = tradeItemWrapper:getStaticStatus()
	
	global_SellPanel_Refresh( itemSS )		-- itemSS:getCommerceType()
end

-- 상품 위치 셋팅
function createSellItemList()
	--local index  = 1

	for index = 1, 10 do
		getItemList( index )
		--index = index + 1
	end
	
	UIScroll.InputEvent( _sellScroll, "NpcTradeSell_ScrollEvent" )
	_sellScroll:SetControlPos( 0 )
		
	Panel_Trade_Market_Sell_ItemList:addInputEvent( "Mouse_UpScroll", "NpcTradeSell_ScrollEvent(true)" )
	Panel_Trade_Market_Sell_ItemList:addInputEvent( "Mouse_DownScroll", "NpcTradeSell_ScrollEvent(false)" )
end


-- 실제 control 생성하는 부분
function getItemList( index ) -- , row, col
	local tempListBody = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Trade_Market_Sell_ItemList, "Static_SellMiniPanel_"..index )
	CopyBaseProperty( _ItemPanel, tempListBody )
	tradeSellMarket.ListBody[index] = tempListBody

	tradeSellMarket.ListBody[index]:addInputEvent( "Mouse_UpScroll", "NpcTradeSell_ScrollEvent(true)" )
	tradeSellMarket.ListBody[index]:addInputEvent( "Mouse_DownScroll", "NpcTradeSell_ScrollEvent(false)" )
	tradeSellMarket.ListBody[index]:addInputEvent( "Mouse_LUp", "NpcTradeSell_LupEvent(".. index ..")" )
	
	local tempListBodyGame = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempListBody, "Static_TradeGameMiniPanel_"..index )
	CopyBaseProperty( _TradeGamePanel, tempListBodyGame )
	tradeSellMarket.ListBodyGame[index] = tempListBodyGame

	tradeSellMarket.ListBodyGame[index]:addInputEvent( "Mouse_UpScroll", "NpcTradeSell_ScrollEvent(true)" )
	tradeSellMarket.ListBodyGame[index]:addInputEvent( "Mouse_DownScroll", "NpcTradeSell_ScrollEvent(false)" )
	tradeSellMarket.ListBodyGame[index]:addInputEvent( "Mouse_LUp", "NpcTradeSell_LupEvent(".. index ..")" )
	
	local tempItemSlotBG = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempListBody, "Static_Slot_"..index )
	CopyBaseProperty( _SlotBG, tempItemSlotBG )
	tradeSellMarket.itemSlot_BG[index] = tempItemSlotBG
	tradeSellMarket.itemSlot_BG[index]:addInputEvent( "Mouse_LUp", "NpcTradeSell_LupEvent(".. index ..")" )
	
	tempItemSlotBG:SetIgnore( false )

	local slot = {}
	SlotItem.new( slot, 'TradeShopItem_' .. index, index, tempListBody, tradeSellMarket.slotConfig )
	slot:createChild()
	slot.icon:SetPosY( tempItemSlotBG:GetPosY() + 4 )
	slot.icon:SetPosX( tempItemSlotBG:GetPosX() + 4 )
	
	slot.icon:addInputEvent( "Mouse_UpScroll", "NpcTradeSell_ScrollEvent(true)" )
	slot.icon:addInputEvent( "Mouse_DownScroll", "NpcTradeSell_ScrollEvent(false)" )
	slot.icon:addInputEvent( "Mouse_LUp", "NpcTradeSell_LupEvent(".. index ..")" )

	local tempRemainCount = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_remainCount_"..index )
	CopyBaseProperty( _RemainCount, tempRemainCount )
	tradeSellMarket.remainCount[index] = tempRemainCount
	
	local tempNpcRemainCount = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_npcRemainCount_"..index )
	CopyBaseProperty( _NpcRemainCount, tempNpcRemainCount )
	tradeSellMarket.npcRemainCount[index] = tempNpcRemainCount

	local tempItemName = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_itemName_"..index )
	CopyBaseProperty( _ItemName, tempItemName )
	tempItemName:SetAutoResize( true )
	tempItemName:SetTextMode( CppEnums.TextMode.eTextMode_AutoWrap )
	tradeSellMarket.itemName[index] = tempItemName

	local tempSellPrice = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_sellPrice_"..index )
	CopyBaseProperty( _SellPrice, tempSellPrice )
	tradeSellMarket.sellPrice[index] = tempSellPrice

	local tempQuotation = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_QuotationRate_"..index )
	CopyBaseProperty( _QuotationRate, tempQuotation )
	tradeSellMarket.Quotation[index] = tempQuotation
	tradeSellMarket.Quotation[index]:addInputEvent("Mouse_On", "TradeMarketSellList_SimpleToolTips( true, 2, " .. index .. " )")
	tradeSellMarket.Quotation[index]:addInputEvent("Mouse_Out", "TradeMarketSellList_SimpleToolTips(false)")
	tradeSellMarket.Quotation[index]:setTooltipEventRegistFunc("TradeMarketSellList_SimpleToolTips( true, 2, " .. index .. " )")

	local tempExpiration = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_Expiration_"..index )
	CopyBaseProperty( _expiration, tempExpiration )
	tradeSellMarket.expiration[index] = tempExpiration
	tradeSellMarket.expiration[index]:addInputEvent("Mouse_On", "TradeMarketSellList_SimpleToolTips( true, 5, " .. index .. " )")
	tradeSellMarket.expiration[index]:addInputEvent("Mouse_Out", "TradeMarketSellList_SimpleToolTips(false)")
	tradeSellMarket.expiration[index]:setTooltipEventRegistFunc("TradeMarketSellList_SimpleToolTips( true, 5, " .. index .. " )")
	
	local tempTradePrice = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_TradePrice_"..index ) 
	CopyBaseProperty( _tradePrice, tempTradePrice )
	tradeSellMarket.tradePrice[index] = tempTradePrice

	tradeSellMarket.tradePrice[index]:addInputEvent("Mouse_On", "TradeMarketSellList_SimpleToolTips( true, 0, " .. index .. " )")
	tradeSellMarket.tradePrice[index]:addInputEvent("Mouse_Out", "TradeMarketSellList_SimpleToolTips(false)")
	tradeSellMarket.tradePrice[index]:setTooltipEventRegistFunc("TradeMarketSellList_SimpleToolTips( true, 0, " .. index .. " )")
	
	local tempDistanceBouns = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_Distance_"..index )
	CopyBaseProperty( _distanceBonus, tempDistanceBouns )
	tradeSellMarket.DistanceBonus[index] = tempDistanceBouns
	tradeSellMarket.DistanceBonus[index]:addInputEvent("Mouse_On", "TradeMarketSellList_SimpleToolTips( true, 3, " .. index .. " )")
	tradeSellMarket.DistanceBonus[index]:addInputEvent("Mouse_Out", "TradeMarketSellList_SimpleToolTips(false)")
	tradeSellMarket.DistanceBonus[index]:setTooltipEventRegistFunc("TradeMarketSellList_SimpleToolTips( true, 3, " .. index .. " )")

	local tempDistanceBonusValue = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_DistanceValue_"..index )
	CopyBaseProperty( _distanceBonusValue, tempDistanceBonusValue )
	tradeSellMarket.DistanceBonusValue[index] = tempDistanceBonusValue

	local tempDistanceNoBonus = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_DistanceNoBonus_"..index )
	CopyBaseProperty( _distanceNoBonus, tempDistanceNoBonus )
	tradeSellMarket.DistanceNoBonus[index] = tempDistanceNoBonus
	tradeSellMarket.DistanceNoBonus[index]:addInputEvent("Mouse_On", "TradeMarketSellList_SimpleToolTips( true, 6, " .. index .. " )")
	tradeSellMarket.DistanceNoBonus[index]:addInputEvent("Mouse_Out", "TradeMarketSellList_SimpleToolTips(false)")
	tradeSellMarket.DistanceNoBonus[index]:setTooltipEventRegistFunc("TradeMarketSellList_SimpleToolTips( true, 6, " .. index .. " )")

	local tempAddCart = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, tempListBody, "Button_AddCart_"..index )
	tempAddCart:addInputEvent( "Mouse_LUp", "click_tradeSellMarket_SellItem(".. index ..")" )
	--tempAddCart:addInputEvent( "Mouse_LUp", "allSell()" )
	CopyBaseProperty( _AddCard, tempAddCart )
	tradeSellMarket.AddCart[index] = tempAddCart

	tradeSellMarket.AddCart[index]:addInputEvent( "Mouse_UpScroll", "NpcTradeSell_ScrollEvent(true)" )
	tradeSellMarket.AddCart[index]:addInputEvent( "Mouse_DownScroll", "NpcTradeSell_ScrollEvent(false)" )
	
	local tempProfitStatic = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "Static_Profit_"..index )
	CopyBaseProperty( _profitStatic, tempProfitStatic )
	tradeSellMarket.profitStatic[index] = tempProfitStatic
	tradeSellMarket.profitStatic[index]:addInputEvent("Mouse_On", "TradeMarketSellList_SimpleToolTips( true, 1, " .. index .. " )")
	tradeSellMarket.profitStatic[index]:addInputEvent("Mouse_Out", "TradeMarketSellList_SimpleToolTips(false)")
	tradeSellMarket.profitStatic[index]:setTooltipEventRegistFunc("TradeMarketSellList_SimpleToolTips( true, 1, " .. index .. " )")

	-- 이윤
	local tempProfitGold = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_ProfitGold_"..index )
	CopyBaseProperty( _profitGold, tempProfitGold )
	tradeSellMarket.profitGold[index] = tempProfitGold

	-- 연결안됨
	local tempNoLinked = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_NoLinked_"..index )
	CopyBaseProperty( _noLink, tempNoLinked )
	tradeSellMarket.noLink[index] = tempNoLinked
	tradeSellMarket.noLink[index]:addInputEvent("Mouse_On", "TradeMarketSellList_SimpleToolTips( true, 4, " .. index .. " )")
	tradeSellMarket.noLink[index]:addInputEvent("Mouse_Out", "TradeMarketSellList_SimpleToolTips(false)")
	tradeSellMarket.noLink[index]:setTooltipEventRegistFunc("TradeMarketSellList_SimpleToolTips( true, 4, " .. index .. " )")
	
	local tempDesertBuff = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_DesertBuff_" .. index )
	CopyBaseProperty( _desertBuff, tempDesertBuff )
	tradeSellMarket.desertBuff[index] = tempDesertBuff
	tradeSellMarket.desertBuff[index]:addInputEvent("Mouse_On", "TradeMarketSellList_SimpleToolTips( true, 7, " .. index .. " )")
	tradeSellMarket.desertBuff[index]:addInputEvent("Mouse_Out", "TradeMarketSellList_SimpleToolTips(false)")
	tradeSellMarket.desertBuff[index]:setTooltipEventRegistFunc("TradeMarketSellList_SimpleToolTips( true, 7, " .. index .. " )")

	tradeSellMarket.icons[index] = slot

	local sizeY = tempListBody:GetSizeY()
	local posY = tradeSellMarket.itemsStartPosY + (index - 1) * sizeY + (tradeSellMarket.intervalPanel * index)
	
	tradeSellMarket.ListBody[index]:SetPosY( posY )

end

local selectIndex = 0
local sellStackCount = 0
local tempTradeType = 0		-- 노드 연결이 안되어 있을 경우 tradeType을 넣어 줄수 없다.
function click_tradeSellMarket_SellItem( index )
	-- UI.debugMessage( "click Cart " .. index )
	selectIndex = index
	local isLinkedNode = npcShop_CheckLinkedItemExplorationNode( tradeSellMarket.itemIndex[index], tradeSellMarket.vehicleItem[index] )
	param =
	{
		[0] = tradeSellMarket.itemIndex[index],
		[1] = tradeSellMarket.itemProfit[index],
		[2] = tradeSellMarket.vehicleItem[index],		-- 탈것에서 파는 것인지 인벤에서 파는 것인지 0 , 4
		[3] = tradeSellMarket.vehicleActorKey[index],
		[4] = tradeSellMarket.expirationDate[index],
		[5] = isLinkedNode,								-- 연결 되지 않아도 팔아보자 테스트	
	}

	Panel_NumberPad_Show(true, tradeSellMarket.remainItemCount[ index ], param, TradeMarket_SellSome_ConfirmFunction)
end

function TradeMarket_SellSome_ConfirmFunction( inputNumber, param )
	local inventory = getSelfPlayer():get():getInventory()
	local s64_TradeItemNo = toInt64( 0, 0 )
	local s64_inventoryItemCount = toInt64( 0, 0 )
	local itemValueType = nil
	local regionInfo = nil
	
	local talker = dialog_getTalker()
	if nil ~= talker then
		local actorKeyRaw = talker:getActorKey()
		local actorProxyWrapper = getNpcActor(actorKeyRaw)
		local actorProxy = actorProxyWrapper:get()
		local characterStaticStatus = actorProxy:getCharacterStaticStatus()
		if true == characterStaticStatus:isSupplyMerchant() or true == characterStaticStatus:isFishSupplyMerchant() then
			if 0 < math.floor( Int64toInt32(inventory:getWeight_s64()) / Int64toInt32(getSelfPlayer():get():getPossessableWeight_s64()) ) then
				Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarket_Not_Enough_Weight") )
				return
			end
		end
	end
	
	if 0 == param[2] then
		s64_TradeItemNo			= npcShop_getItemNo(param[0])
		s64_inventoryItemCount	= inventory:getItemCountByItemNo_s64( s64_TradeItemNo )
		itemValueType = inventory:getItemByItemNo( s64_TradeItemNo )
		regionInfo = itemValueType:getItemRegionInfo()	
		itemWrapper = npcShop_getItemSell( param[0] )
	elseif 4 == param[2] then
		local myLandVehicleActorKey	= nil
		local landVehicleActorProxy	= nil
		local	temporaryWrapper	= getTemporaryInformationWrapper()
		local	servantInfo			= temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
		if	nil ~= servantInfo	then
			local	servertinventory	= servantInfo:getInventory()
			
			s64_TradeItemNo = npcShop_getVehicleInvenItemNoByShopSlotNo( param[0] )
			myLandVehicleActorKey	= servantInfo:getActorKeyRaw()
			
			if nil ~= myLandVehicleActorKey then
				landVehicleActorProxy = getVehicleActor( myLandVehicleActorKey )
			end
			
			local vehicleInven = landVehicleActorProxy:get():getInventory()
			s64_inventoryItemCount = vehicleInven:getItemCountByItemNo_s64( s64_TradeItemNo )
			
			itemValueType = vehicleInven:getItemByItemNo( s64_TradeItemNo )

			-- item region
			regionInfo = itemValueType:getItemRegionInfo()
		end
		itemWrapper = npcShop_getVehicleSellItem( param[0] )
		
	end

	if nil == itemWrapper then
		return
	end
	local tradeType = itemWrapper:getStaticStatus():get()._tradeType
	
	tempTradeType = tradeType

	sellStackCount = inputNumber
	if false == param[5] and 0 ~= regionInfo._waypointKey then
		local itemData = nil
		if 0 == param[2] then
			itemData = npcShop_getItemWrapperByShopSlotNo( param[0] )
		elseif 4 == param[2] then
			itemData = npcShop_getVehicleItemWrapper( param[0] )
		end
		
		if nil ~= itemData then
			local characterStaticStatusWrapper = npcShop_getCurrentCharacterKeyForTrade()
			local characterStaticStatus = characterStaticStatusWrapper:get()
			if true == characterStaticStatus:isSupplyMerchant() then
				TradeMarket_CheckNodeLink_SellSome( tradeType )
				return
			end

			local talker = dialog_getTalker()
			local nodeString = PAGetStringParam3( Defines.StringSheet_GAME, "Lua_TradeMarketSellList_NeedNodeLink", "exploreNode1", talker:getExplorationNodeName(), "exploreNode2", itemData:getProductionRegion(), "sellPercent", getNotLinkNodeSellPercent()/e1Percent )	-- talker:getExplorationNodeName(), "exploreNode2", selfPlayer:getExplorationNodeName() )
			local messageboxData = { title = PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarketSellList_NeedNodeLinkTitle"), content = nodeString, functionYes = TradeMarket_CheckNodeLink_SellSome,  functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }	--functionYes = Panel_Lobby_function_SelectEnterToGame, 
			MessageBox.showMessageBox( messageboxData )
		end
	else
		for ii = 1, Int64toInt32( sellStackCount ) do
			local rv

			if 5 == tradeType then
				rv = npcShop_doSellInTradeShop( param[0], 1, param[2], 14 )			-- 하나씩 판매시킨다.
			else
				rv = npcShop_doSellInTradeShop( param[0], 1, param[2], 0 )			-- 하나씩 판매시킨다.
			end
			if 0 == rv then			-- 정상 판매가 되었습니다.
				tradeSellMarket.totalProfit = tradeSellMarket.totalProfit + (param[1]*inputNumber)
			end
		end
	end
end

function TradeMarket_CheckNodeLink_SellSome()
	if nil == tempTradeType then
		tempTradeType = 0
	end
	for kk = 1, Int64toInt32( sellStackCount ) do		-- Int64toInt32( sellStackCount )
		if 5 == tempTradeType then
			npcShop_doSellInTradeShop( tradeSellMarket.itemIndex[selectIndex], 1, tradeSellMarket.vehicleItem[selectIndex], 14 )
		else
			npcShop_doSellInTradeShop( tradeSellMarket.itemIndex[selectIndex], 1, tradeSellMarket.vehicleItem[selectIndex], 0 )
		end
	end
end

function tradeSellMarket:setShowTradeIcon( index, isShow )
	tradeSellMarket.ListBody[index]:SetShow(isShow)
	tradeSellMarket.itemSlot_BG[index]:SetShow(isShow)
	tradeSellMarket.remainCount[index]:SetShow(isShow)
	tradeSellMarket.npcRemainCount[index]:SetShow(false)
	tradeSellMarket.icons[index].icon:SetShow(isShow)
	tradeSellMarket.itemName[index]:SetShow(isShow)
	tradeSellMarket.sellPrice[index]:SetShow(isShow)
	tradeSellMarket.Quotation[index]:SetShow(isShow)
	tradeSellMarket.profitStatic[index]:SetShow(isShow)
	tradeSellMarket.profitGold[index]:SetShow(isShow)	-- 이윤
	tradeSellMarket.noLink[index]:SetShow(isShow)		-- 연결안됨
	-- tradeSellMarket.desertBuff[index]:SetShow(isShow)	-- 사막버프
	tradeSellMarket.AddCart[index]:SetShow(isShow)
	tradeSellMarket.DistanceBonus[index]:SetShow(isShow)
	tradeSellMarket.DistanceBonusValue[index]:SetShow(isShow)
	tradeSellMarket.DistanceNoBonus[index]:SetShow(isShow)
	tradeSellMarket.tradePrice[index]:SetShow(isShow)
	
	tradeSellMarket.expiration[index]:SetShow( false )
	tradeSellMarket.ListBodyGame[index]:SetShow( false )
end

local temp_InvenSlotNum = nil
local temp_ToolTipType	= nil
function tradeItem_toolTip_Show( InvenSlotNum, toolTiptype )
	temp_InvenSlotNum	= InvenSlotNum
	temp_ToolTipType	= toolTiptype
	Panel_Tooltip_Item_Show_GeneralNormal( InvenSlotNum , toolTiptype, true )
end
function tradeItem_toolTip_Hide()
	if nil == temp_InvenSlotNum then
		return
	end
	Panel_Tooltip_Item_Show_GeneralNormal( temp_InvenSlotNum, temp_ToolTipType, false )
	temp_InvenSlotNum	= nil
	temp_ToolTipType	= nil
end

function eventSellToNpcListRefresh()

	if false == global_IsTrading then
		return
	end

	for count = 1, tradeSellMarket.maxSellCount do
		tradeSellMarket:setShowTradeIcon( count, false )
	end

	global_sellItemFromPlayer()
end

function eventResizeSellList()
	-- 보유 물품 사이즈 25
	local bodySizeY = _ItemPanel:GetSizeY()
	local sellPanelSizeY = getScreenSizeY() - Panel_Npc_Trade_Market:GetSizeY() - 80
	
	local showCount = 0
	local itemsSizeY = 0
	for count = 1, 10 do
		if sellPanelSizeY > (bodySizeY * count) + ((count - 1)*tradeSellMarket.intervalPanel) then
			showCount = showCount + 1
		else
			itemsSizeY = (bodySizeY * (count-1)) + ((count-2)*tradeSellMarket.intervalPanel)
			break
		end
	end
	
	--UI.debugMessage( showCount )
	
	tradeSellMarket.maxSellCount = showCount
	Panel_Trade_Market_Sell_ItemList:SetSize( Panel_Trade_Market_Sell_ItemList:GetSizeX(), itemsSizeY + tradeSellMarket.itemsStartPosY + 50 )
	_btnSellAllItem:SetPosY( Panel_Trade_Market_Sell_ItemList:GetSizeY() + 5 )
	_btnTradeGame:SetPosY( Panel_Trade_Market_Sell_ItemList:GetSizeY() + 5 )
	
	if isNA then
		_btnTradeGame:SetSize( 220, _btnTradeGame:GetSizeY() )
		_btnSellAllItem:SetSize( 220, _btnTradeGame:GetSizeY() )
		_btnSellAllItem:SetPosX( _btnTradeGame:GetPosX() )
		_btnSellAllItem:SetPosY( itemsSizeY + tradeSellMarket.itemsStartPosY + 50 + 5 + _btnTradeGame:GetSizeY() )
	end
	--_btnSellAllItem:ComputePos()
	
	_sellScroll:SetPosX( tradeSellMarket.ListBody[1]:GetPosX() + tradeSellMarket.ListBody[1]:GetSizeX() + 2 )
	_sellScroll:SetPosY( tradeSellMarket.itemsStartPosY )
	_sellScroll:SetSize( _sellScroll:GetSizeX(), itemsSizeY )
end

function TradeMarketSellList_SimpleToolTips( isShow, tipType, index )
	local name, desc, control = nil, nil, nil

	if 0 == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TOOLTIP_TRADEPRICE") -- 거래 가격
		control = tradeSellMarket.tradePrice[index]
	elseif 1 == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TOOLTIP_PROFITSTATIC") -- 이윤
		control = tradeSellMarket.profitStatic[index]
	elseif 2 == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_MARKETPRICE") -- 시세
		control = tradeSellMarket.Quotation[index]
	elseif 3 == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TOOLTIP_DISTANCEBONUS") -- 거리 보너스
		control = tradeSellMarket.DistanceBonus[index]
	elseif 4 == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TOOLTIP_NOLINK") -- 원산지
		control = tradeSellMarket.noLink[index]
	elseif 5 == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TOOLTIP_EXPIRATION") -- 가격 보증
		control = tradeSellMarket.expiration[index]
	elseif 6 == tipType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_NOTDISTANCEBONUS")
		control = tradeSellMarket.DistanceNoBonus[index]
	elseif 7 == tipType then
		name = "사막 버프 적용"
		control = tradeSellMarket.desertBuff[index]
	end

	if true == isShow then
		registTooltipControl(control, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end

end

createSellItemList()
registerEvent("EventNpcShopUpdate", "eventSellToNpcListRefresh")
registerEvent( "onScreenResize", "eventResizeSellList" )

--registerEvent("FromClient_GroundMouseClick", "updateMarketList");