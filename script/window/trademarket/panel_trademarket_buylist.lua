---------------------------
-- Panel Init
---------------------------

local VCK = CppEnums.VirtualKeyCode

Panel_Trade_Market_BuyItemList:SetShow(false, false)
--Panel_Trade_Market_BuyItemList:SetIgnore( true )
Panel_Trade_Market_BuyItemList:SetAlpha( 1 )
Panel_Trade_Market_BuyItemList:setGlassBackground(true)

---------------------------
-- Local Variables
---------------------------
local UI_TM = CppEnums.TextMode
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE

local _ItemPanel 		= UI.getChildControl ( Panel_Trade_Market_BuyItemList, "Static_Panel" )
local _SlotBG 			= UI.getChildControl ( Panel_Trade_Market_BuyItemList, "Static_Slot" )
local _ItemIcon 		= UI.getChildControl ( Panel_Trade_Market_BuyItemList, "Static_Icon" )
local _RemainCount 		= UI.getChildControl ( Panel_Trade_Market_BuyItemList, "StaticText_remainCount" )
local _ItemName 		= UI.getChildControl ( Panel_Trade_Market_BuyItemList, "StaticText_itemName" )
local _SellPrice 		= UI.getChildControl ( Panel_Trade_Market_BuyItemList, "StaticText_sellPrice" )
local _QuotationRate 	= UI.getChildControl ( Panel_Trade_Market_BuyItemList, "StaticText_QuotationRate" )
local _AddCard 			= UI.getChildControl ( Panel_Trade_Market_BuyItemList, "Button_AddCart" )
local _showTrade		= UI.getChildControl ( Panel_Trade_Market_BuyItemList, "Button_TradeInfoShow" )
local _expiration 		= UI.getChildControl ( Panel_Trade_Market_BuyItemList, "StaticText_Option")
local _TitleName 		= UI.getChildControl ( Panel_Trade_Market_BuyItemList, "StaticText_BuyListTitle" )
local _buyingCondition 	= UI.getChildControl ( Panel_Trade_Market_BuyItemList, "StaticText_BuyingCondition" )
local _supply			= UI.getChildControl ( Panel_Trade_Market_BuyItemList, "StaticText_Supply" )

_ItemPanel:SetShow(false, true)
_SlotBG:SetShow(false, true)
_ItemIcon:SetShow(false, true)
_RemainCount:SetShow(false, true)
_ItemName:SetShow(false, true)
_SellPrice:SetShow(false, true)
_QuotationRate:SetShow(false, true)
_AddCard:SetShow(false, true)
_showTrade:SetShow(false, true)
_buyingCondition:SetShow(false, true)
_supply:SetShow( false )

_ItemName:SetTextMode( CppEnums.TextMode.eTextMode_Limit_AutoWrap )
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local tradeBuyMarket =
{
	isTradeMode = 0,		-- NONE, 구입, 판매
	iconSizeCalcX = 260,
	iconSizeCalcY = 190,
	maxSellCount = 9,
	
	enCommerceIndex = -1,
	
	isOpenShop = false,
	slotConfig =
	{
		createIcon = true,
		createBorder = true,
		createCount = false,
		createCash = true
	},
	
	ListBody = {},
	itemSlot_BG = {},
	remainCount = {},
	itemName = {},
	sellPrice = {},
	Quotation = {},
	AddCart = {},
	trendShow = {},
	expiration = {},
	buyingCondition = {},
	itemEnchantKey = {},
	itemIndex = {},
	supply = {},
	
	icons = {}
}

local territoryName =
{
	[0] = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_TERRITORYNAME_0"),	-- "- 발레노스 자치령",
	PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_TERRITORYNAME_1"), 			-- "- 세렌디아 자치령",
	PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_TERRITORYNAME_2"),			-- "- 칼페온 직할령",
	PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_TERRITORYNAME_3"),			-- "- 메디아 직할령",
	-- PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_5"),			-- "- 발렌시아 직할령"
}
---------------------------
-- Global
---------------------------
function global_buyListExit()
	if Panel_Trade_Market_BuyItemList:IsShow() then
		Panel_Trade_Market_BuyItemList:SetShow( false )
	end
	--tradeBuyMarket.isOpenShop = false
end

function global_isShopOpen()
	return tradeBuyMarket.isOpenShop
end

function global_buyListOpen( enCommerceIndex )
	-- 살수 있는 아이템이 있는지 체크
	local rv = npcShop_CheckBuyListByCommerceType( enCommerceIndex )
	if false == rv then
		-- 살수 있는 물품이 존재하지 않는다.
		return
	end

	tradeBuyMarket.enCommerceIndex = enCommerceIndex
	Panel_Trade_Market_BuyItemList:SetShow( true )
	
	for count = 1, tradeBuyMarket.maxSellCount do
		tradeBuyMarket:setShowTradeIcon( count, false )
	end
		
	global_setBuyList()
end


---------------------------
-- Functions
---------------------------
local tradeBuyMarketList_Position = function()
	local basePosX = Panel_Trade_Market_Graph_Window:GetSizeX() + 50
	Panel_Trade_Market_BuyItemList:SetPosX( basePosX )
end



function global_setBuyList()
	tradeBuyMarketList_Position()
	local sellCount = npcShop_getBuyCount()
	local commerceIndex = 1
	local itemOrderIndex

	for index = 1, sellCount do
		if -1 ~= tradeBuyMarket.enCommerceIndex then
			itemOrderIndex = index-1
			local itemwrapper = npcShop_getItemBuy(itemOrderIndex)
			local itemSell = itemwrapper:get()
			local itemStatus = itemwrapper:getStaticStatus()
		
			local itemCommerceType = itemStatus:getCommerceType()
			if itemCommerceType == tradeBuyMarket.enCommerceIndex or enCommerceType.enCommerceType_Max == tradeBuyMarket.enCommerceIndex then
				if tradeBuyMarket.maxSellCount < commerceIndex then
					return
				end
				
				tradeBuyMarket:setShowTradeIcon( commerceIndex, true )

				local itemSS = itemStatus:get()
				tradeBuyMarket.itemEnchantKey[commerceIndex] = itemSS._key:get()
				tradeBuyMarket.itemIndex[commerceIndex] = itemOrderIndex

				-- 번호, 이름, 남은 수량, 가격 데이터 가져오기
				local originalPrice = itemStatus:getOriginalPriceByInt64()
				local tradeItemWrapper = npcShop_getTradeItem( tradeBuyMarket.itemEnchantKey[commerceIndex] )
				
				--local sellRate = (tradeItemWrapper:getTradeSellPrice() / originalPrice) * toInt64( 0, 100 )	-- 기존 문제가 있었음
				local sellRate = string.format( "%.f", npcShop_GetTradeGraphRateOfPrice(itemSS._key:get()))							-- 변경
				local buyableStack = tradeItemWrapper:getRemainStackCount()
				tradeBuyMarket:setBuyItemDataInfo( commerceIndex, itemStatus:getName(), itemSell.leftCount_s64, tradeItemWrapper, buyableStack, sellRate )
				--_PA_LOG( "asdf", "itemStatus:getName() : " .. itemStatus:getName() .. tostring( itemSell.leftCount_s64 ) )
				tradeBuyMarket.icons[commerceIndex]:setItemByStaticStatus( itemwrapper:getStaticStatus() )
				
				tradeBuyMarket.icons[commerceIndex].icon:addInputEvent( "Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(" .. itemOrderIndex .. ", \"tradeMarket_Buy\", true)" )
				tradeBuyMarket.icons[commerceIndex].icon:addInputEvent( "Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(" .. itemOrderIndex .. ", \"tradeMarket_Buy\", false)" )
				Panel_Tooltip_Item_SetPosition(itemOrderIndex, tradeBuyMarket.icons[commerceIndex], "tradeMarket_Buy")

				if 0 == itemStatus:get()._expirationPeriod then	-- 유통기한이 없으면
					tradeBuyMarket.expiration[commerceIndex]:SetShow( false )
				end
				tradeBuyMarket.expiration[commerceIndex]:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_WARRANTY", "expirationPeriod", tostring(tradeItemWrapper:getStaticStatus():get()._expirationPeriod / 60) ) ) -- 가격 보증 기간 : " .. tostring(tradeItemWrapper:getStaticStatus():get()._expirationPeriod / 60) .. "시간
				tradeBuyMarket.expiration[commerceIndex]:SetPosY( tradeBuyMarket.itemName[commerceIndex]:GetPosY() + tradeBuyMarket.itemName[commerceIndex]:GetSizeY() + 5 )
				
				-- 해당 아이템이 황실납품 아이템인지 체크
				local territorySupplyKey = FGlobal_TradeSupplyItemInfo_Compare( tradeBuyMarket.itemEnchantKey[commerceIndex] )
				if nil ~= territorySupplyKey then
					tradeBuyMarket.supply[commerceIndex]:SetShow( true )
					local supplyText = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_SUPPLY", "territoryName", territoryName[territorySupplyKey] )
					tradeBuyMarket.supply[commerceIndex]:SetText( supplyText )	-- "황실 납품 진행중\n(" .. territoryName[territorySupplyKey] .. ")" )
				else
					tradeBuyMarket.supply[commerceIndex]:SetShow( false )
				end

				-- 아이콘 위치 잡아주기
				tradeBuyMarket.icons[commerceIndex].icon:SetShow(true)
				local iconPosX = tradeBuyMarket.ListBody[commerceIndex]:GetPosX()
				local iconPosY = tradeBuyMarket.ListBody[commerceIndex]:GetPosY()

				tradeBuyMarket.icons[commerceIndex].icon:SetPosX( 14 )	--iconPosX +
				tradeBuyMarket.icons[commerceIndex].icon:SetPosY( 11 ) 	--iconPosY +
				commerceIndex = commerceIndex + 1
			end
		end
	end
end

-- 아이템 정보 표시
function tradeBuyMarket:setBuyItemDataInfo( index, itemName, leftCount, tradeItemWrapper, buyableStackCount, sellRate )
	tradeBuyMarket.itemName[index]:SetAutoResize( true )
	tradeBuyMarket.itemName[index]:SetTextMode( UI_TM.eTextMode_Limit_AutoWrap )
	tradeBuyMarket.itemName[index]:setLineCountByLimitAutoWrap(2)			-- 2줄째 이후 .... 표시
	tradeBuyMarket.itemName[index]:SetText(tostring(itemName))

	if true == tradeItemWrapper:isTradableItem() then
		tradeBuyMarket.remainCount[index]:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "Lua_TradeMarketBuyList_RemainCount", "Count", tostring( buyableStackCount ) ) )
		tradeBuyMarket.sellPrice[index]:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_PRICE_ONEPIECE", "price", makeDotMoney( tradeItemWrapper:getTradeSellPrice())))
		tradeBuyMarket.sellPrice[index]:SetPosX( tradeBuyMarket.sellPrice[index]:GetTextSizeX() + 13 )
		-- - 개당 가격 : xx 실버		
		tradeBuyMarket.Quotation[index]:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "Lua_TradeMarketBuyList_Percents", "Percent", tostring( sellRate ) ) )
		-- - 시세 : XX%
		tradeBuyMarket.AddCart[index]:SetText( PAGetString( Defines.StringSheet_GAME, "Lua_TradeMarketBuyList_AddtoCart" ) )

		local needLifeType			= tradeItemWrapper:get():getNeedLifeType()
		local needLifeLevel			= tradeItemWrapper:get():getNeedLifeLevel()
		local conditionLevel		= FGlobal_CraftLevel_Replace( needLifeLevel + 1, needLifeType )
		local conditionTypeName		= FGlobal_CraftType_ReplaceName( needLifeType )
		local buyingConditionValue = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_BUYING_CONDITIONTITLE") .. " "

		if 0 == needLifeLevel or nil == needLifeLevel then
			buyingConditionValue = buyingConditionValue .. PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_BUYING_CONDITION_NIL")
			tradeBuyMarket.buyingCondition[index]:SetText( buyingConditionValue )
			tradeBuyMarket.buyingCondition[index]:SetFontColor( Defines.Color.C_FFC4BEBE )
			--tradeBuyMarket.buyingCondition[index]:SetText( "- 지식 : 없음" .. "  " .. "  " .. "  " .. "  ".. "  " .. " - 할인률 : 0 %" )
			tradeBuyMarket.AddCart[index]:SetEnable( true )
			tradeBuyMarket.AddCart[index]:SetMonoTone( false )
			tradeBuyMarket.trendShow[index]:SetEnable( true )
			tradeBuyMarket.trendShow[index]:SetMonoTone( false )
		else
			local player				= getSelfPlayer()
			local playerGet				= player:get()
			local playerThisCraftLevel	= playerGet:getLifeExperienceLevel( needLifeType )

			if needLifeLevel < playerThisCraftLevel then
				tradeBuyMarket.AddCart[index]:SetEnable( true )
				tradeBuyMarket.AddCart[index]:SetMonoTone( false )
				tradeBuyMarket.trendShow[index]:SetEnable( true )
				tradeBuyMarket.trendShow[index]:SetMonoTone( false )
				tradeBuyMarket.buyingCondition[index]:SetFontColor( Defines.Color.C_FFC4BEBE )
				buyingConditionValue = "<PAColor0xFFC4BEBE>" .. buyingConditionValue .. PAGetStringParam2( Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_BUYING_CONDITION", "craftName", conditionTypeName, "craftLevel", conditionLevel ) .. "<PAOldColor>"
				--tradeBuyMarket.buyingCondition[index]:SetText( "- 지식 : 없음" .. "  " .. "  " .. "  " .. "  ".. "  " .. " - 할인률 : 0 %" )
			else
				tradeBuyMarket.AddCart[index]:SetEnable( false )
				tradeBuyMarket.AddCart[index]:SetMonoTone( true )
				tradeBuyMarket.AddCart[index]:SetShow( false )
				tradeBuyMarket.trendShow[index]:SetEnable( false )
				tradeBuyMarket.trendShow[index]:SetMonoTone( true )
				tradeBuyMarket.trendShow[index]:SetShow( false )
				buyingConditionValue = "<PAColor0xFFa91000>" .. buyingConditionValue .. PAGetStringParam2( Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_BUYING_CONDITION", "craftName", conditionTypeName, "craftLevel", conditionLevel ) .. "<PAOldColor>"
				tradeBuyMarket.buyingCondition[index]:SetFontColor( Defines.Color.C_FF775555 )
			end
			tradeBuyMarket.buyingCondition[index]:SetText( buyingConditionValue )
		end
		-- 남은 수량이 0이면 담기 버튼을 누르지 못한다.
		if ( 0 < Int64toInt32(buyableStackCount) ) then
			tradeBuyMarket.AddCart[index]:SetEnable( true )
		else
			tradeBuyMarket.AddCart[index]:SetEnable( false )
		end
	else
		tradeBuyMarket.remainCount[index]:SetShow( false )
		tradeBuyMarket.sellPrice[index]:SetShow( false )
		tradeBuyMarket.Quotation[index]:SetShow( false )
		tradeBuyMarket.AddCart[index]:SetShow( false )
		tradeBuyMarket.trendShow[index]:SetShow( false )
		-- tradeBuyMarket.expiration[index]:SetShow( true )
	end
end


-- 상품 위치 셋팅
function createBuyItemList()
	local index  = 1
	for col = 1 , 3 do
		for row = 1, 3 do
			createItemList( index, row, col - 1 )
			index = index + 1
		end
	end
	
	local posX = tradeBuyMarket.ListBody[1]:GetPosX()
	local posY = tradeBuyMarket.ListBody[1]:GetPosY()
	_TitleName:SetPosX( posX )
	_TitleName:SetPosY( posY - 50 )
end

function updateMarketList()
	if false == Panel_Trade_Market_BuyItemList:GetShow() then
		return
	end
	
	if false == isKeyDown_Once( VCK.KeyCode_LBUTTON ) then
		return
	end
	
	local eventControl = getEventControl()
	if nil ~= eventControl then
		local parentControl = eventControl:getParent()
		if nil ~= parentControl and parentControl:GetKey() == Panel_Window_Exchange_Number:GetKey() then
			return
		end
	end
	
	local mousePosX = getMousePosX()
	local mousePosY = getMousePosY()
	
	local enableStart = Panel_Trade_Market_BuyItemList:getEnableStart()
	local enableEnd = Panel_Trade_Market_BuyItemList:getEnableEnd()
	
	local checkStartPosX = Panel_Trade_Market_BuyItemList:GetParentPosX() + enableStart.x
	local checkStartPosY = Panel_Trade_Market_BuyItemList:GetParentPosY() + enableStart.y
	local checkEndPosX = Panel_Trade_Market_BuyItemList:GetParentPosX() + enableEnd.x
	local checkEndPosY = Panel_Trade_Market_BuyItemList:GetParentPosY() + enableEnd.y

	if false == ((checkStartPosX < mousePosX and checkEndPosX > mousePosX) and ( checkStartPosY < mousePosY and checkEndPosY > mousePosY )) then
		Panel_Window_Exchange_Number:SetShow( false )
	end
end

-- 실제 control 생성하는 부분
function createItemList( index, row, col )
	local tempListBody = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Trade_Market_BuyItemList, "Static_Panel_"..index )
	CopyBaseProperty( _ItemPanel, tempListBody )
	tradeBuyMarket.ListBody[index] = tempListBody
	
	local tempItemSlotBG = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempListBody, "Static_Slot_"..index )
	CopyBaseProperty( _SlotBG, tempItemSlotBG )
	tradeBuyMarket.itemSlot_BG[index] = tempItemSlotBG
	
	local icon = {}
	SlotItem.new( icon, 'TradeShopItem_' .. index, index, tempListBody, tradeBuyMarket.slotConfig )
	icon:createChild()

	local tempRemainCount = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_remainCount_"..index )
	CopyBaseProperty( _RemainCount, tempRemainCount )
	tradeBuyMarket.remainCount[index] = tempRemainCount
	
	local tempItemName = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_itemName_"..index )
	CopyBaseProperty( _ItemName, tempItemName )
	tradeBuyMarket.itemName[index] = tempItemName
	
	local tempSellPrice = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_sellPrice_"..index )
	CopyBaseProperty( _SellPrice, tempSellPrice )
	tradeBuyMarket.sellPrice[index] = tempSellPrice
	
	local tempQuotation = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_QuotationRate_"..index )
	CopyBaseProperty( _QuotationRate, tempQuotation )
	tradeBuyMarket.Quotation[index] = tempQuotation
	
	local tempAddCart = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, tempListBody, "Button_AddCart_"..index )
	tempAddCart:addInputEvent( "Mouse_LUp", "click_tradeBuyMarket_BuyItemAddCart(".. index ..")" )
	CopyBaseProperty( _AddCard, tempAddCart )
	tradeBuyMarket.AddCart[index] = tempAddCart
	
	local tempTrendShow = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, tempListBody, "Button_TrendShow"..index )
	tempTrendShow:addInputEvent( "Mouse_LUp", "click_tradeBuyMarket_BuyItemTrendShow(".. index ..")" )
	CopyBaseProperty( _showTrade, tempTrendShow )
	tradeBuyMarket.trendShow[index] = tempTrendShow
	
	local tempExpiration = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_Expiration"..index )
	CopyBaseProperty( _expiration, tempExpiration )
	tradeBuyMarket.expiration[index] = tempExpiration

	local tempBuyingCondition = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_BuyingCondition"..index )
	CopyBaseProperty( _buyingCondition, tempBuyingCondition )
	tradeBuyMarket.buyingCondition[index] = tempBuyingCondition
	
	local tempSupply = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_Supply_" .. index )
	CopyBaseProperty( _supply, tempSupply )
	tradeBuyMarket.supply[index] = tempSupply

	tradeBuyMarket.icons[index] = icon
	tradeBuyMarket:setShowTradeIcon( index, true)

	posX = (row -1) * tradeBuyMarket.iconSizeCalcX
	posY = col * tradeBuyMarket.iconSizeCalcY
	tempListBody:SetPosX ( posX )
	tempListBody:SetPosY ( posY )
end

function click_tradeBuyMarket_BuyItemAddCart( index )
	param =
	{
		[0] = tradeBuyMarket.itemEnchantKey[index],
		[1] = tradeBuyMarket.itemIndex[index],					-- 목록 listIndex
		[2] = true,												-- 캐릭터 이동을 사용할 지 여부
		[3] = tradeBuyMarket.enCommerceIndex					-- 무역 타입
	}
	
	--_PA_LOG( "asdf", " tradeBuyMarket.enCommerceIndex : " .. tostring( tradeBuyMarket.enCommerceIndex ) )

	-- local shopItemWrapper = npcShop_getItemBuy( param[1] )
	-- local shopItemPrice = shopItemWrapper:get().price_s64
	-- local s64_maxNumber = getSelfPlayer():get():getInventory():getMoney_s64() / shopItemPrice	-- 현재 돈으로 살수있는 수량

	local tradeItemWrapper	= npcShop_getTradeItem( param[0] )
	local buyableStack		= tradeItemWrapper:getRemainStackCount()		-- 내가 살수있는 수량
	
	if global_CheckItem_From_Cart(param[0]) then
		--_PA_LOG( "CheckTradeItem", "있다 있어~~~~~" )
		NotifyDisplay( PAGetString( Defines.StringSheet_GAME, "Lua_TradeMarketBuyList_Already_Exist_In_Barket" ) )
		return
	end
	
	-- local numpadMaxCount = toInt64( 0, 0 )
	-- if s64_maxNumber < buyableStack then						-- 돈과 살수있는 수량중 작은 수량
		-- numpadMaxCount = s64_maxNumber
	-- else
		-- numpadMaxCount = buyableStack
	-- end
	
	-- local selfPlayer = getSelfPlayer():get()
	-- local selfPlayerPossessableWeigh = selfPlayer:getPossessableWeight_s64()
	-- local selfPlayerCurrentWeigh = selfPlayer:getCurrentWeight_s64()
	
	-- local remainWeight = selfPlayerPossessableWeigh - selfPlayerCurrentWeigh

	-- local SSItem = tradeItemWrapper:getStaticStatus()
	-- local buyableWeightCount = math.floor( Int64toInt32(remainWeight) / SSItem:get()._weight )
	
	-- if buyableWeightCount < Int64toInt32( numpadMaxCount ) then
		-- numpadMaxCount = toInt64( 0, buyableWeightCount )
	-- end
	
	--UI.debugMessage( "buyableWeightCount : " .. tostring( buyableWeightCount ) .. "  : " .. tostring( SSItem:get()._weight ) .. " : " .. tostring( remainWeight ) )
	--UI.debugMessage( "buyableStack : " .. tostring( buyableStack ) .. " s64_maxNumber : " .. tostring( s64_maxNumber ) )
	
	-- 살수있는 수량은 내가 살수 있는 수량을 숫자 패드에 띄어 주도록 하자...
	Panel_NumberPad_Show(true, buyableStack, param, TradeMarket_BuySome_ConfirmFunction)
end

local _trendIndex = nil
function click_tradeBuyMarket_BuyItemTrendShow( index )
	local talker = dialog_getTalker()
	if nil == talker then
		return
	end
	
	local actorProxyWrapper = getNpcActor(talker:getActorKey())
	local actorProxy = actorProxyWrapper:get()
	local characterStaticStatus = actorProxy:getCharacterStaticStatus()
	
	if characterStaticStatus:isTerritorySupplyMerchant() or characterStaticStatus:isTerritoryTradeMerchant() then
		local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_TERRITORYSUPPLY_MEMO") -- "황실 무역/납품 시세는 볼 수 없습니다."
		local messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_TERRITORYSUPPLY_TITLE"), content = messageBoxMemo, functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
		MessageBox.showMessageBox(messageBoxData)
		return
	end

	-- 기운 수치 체크
	if ( 1 > getSelfPlayer():getWp() ) then							-- 현재의 기운 수치가 소모 기운 수치보다 커야 한다! 바인딩 받으면 바꿔주자
		local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_WPCHECK_MEMO") -- "기운 수치가 부족해 다른 지역 시세를 볼 수 없습니다."
		local messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_TERRITORYSUPPLY_TITLE"), content = messageBoxMemo, functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
		MessageBox.showMessageBox(messageBoxData)
		return
	end

	_trendIndex = index
	
	local	messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_WPUSE_MEMO") -- "다른 지역의 시세를 보려면 기운이 <PAColor0xFF66CC33>1<PAOldColor> 소모됩니다.\n계속하시겠습니까?"
	local	messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_BUYLIST_TERRITORYSUPPLY_TITLE"), content = messageBoxMemo, functionYes = Show_OtherRegion_Trend, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData)

end

function Show_OtherRegion_Trend()
	local talker = dialog_getTalker()
	if nil == talker then
		return
	end

	ToClient_SendTrendInfo( talker:getActorKey(), tradeBuyMarket.itemEnchantKey[trendIndex()] )
end

function trendIndex()
	return _trendIndex
end

function tradeBuyMarket:setShowTradeIcon( index, isShow )
	tradeBuyMarket.ListBody[index]:SetShow(isShow)
	tradeBuyMarket.itemSlot_BG[index]:SetShow(isShow)
	tradeBuyMarket.remainCount[index]:SetShow(isShow)
	tradeBuyMarket.icons[index].icon:SetShow(isShow)
	tradeBuyMarket.itemName[index]:SetShow(isShow)
	tradeBuyMarket.sellPrice[index]:SetShow(isShow)
	tradeBuyMarket.Quotation[index]:SetShow(isShow)
	tradeBuyMarket.AddCart[index]:SetShow(isShow)
	tradeBuyMarket.trendShow[index]:SetShow(isShow)
	tradeBuyMarket.expiration[index]:SetShow(isShow)
	tradeBuyMarket.buyingCondition[index]:SetShow(isShow)
end

function eventBuyFromNpcListRefesh()
	if false == global_IsTrading then
		return
	end

	for count = 1, tradeBuyMarket.maxSellCount do
		tradeBuyMarket:setShowTradeIcon( count, false )
	end
	
	global_setBuyList()
end

createBuyItemList()
Panel_Trade_Market_BuyItemList:RegisterUpdateFunc( "updateMarketList" )
registerEvent("EventNpcShopUpdate", "eventBuyFromNpcListRefesh")
registerEvent("ToClient_SendTrendInfo", "ToClient_SendTrendInfo")

--registerEvent("FromClient_GroundMouseClick",	"updateMarketList");