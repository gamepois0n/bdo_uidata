---------------------------
-- Panel Init
---------------------------

local VCK = CppEnums.VirtualKeyCode

Panel_Trade_Market_ItemList:SetShow(false, false)
Panel_Trade_Market_ItemList:SetIgnore( true )
Panel_Trade_Market_ItemList:SetAlpha( 1 )
Panel_Trade_Market_ItemList:setGlassBackground(true)

---------------------------
-- Local Variables
---------------------------
local UI_TM 		= CppEnums.TextMode
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color

local _ItemPanel 		= UI.getChildControl ( Panel_Trade_Market_ItemList, "Static_Panel" ); 											_ItemPanel:SetShow(false, true);
local _SlotBG 			= UI.getChildControl ( Panel_Trade_Market_ItemList, "Static_Slot" ); 												_SlotBG:SetShow(false, true);
local _ItemIcon 		= UI.getChildControl ( Panel_Trade_Market_ItemList, "Static_Icon" ); 												_ItemIcon:SetShow(false, true);
local _RemainCount 		= UI.getChildControl ( Panel_Trade_Market_ItemList, "StaticText_remainCount" ); 						_RemainCount:SetShow(false, true);
local _ItemName 		= UI.getChildControl ( Panel_Trade_Market_ItemList, "StaticText_itemName" ); 								_ItemName:SetShow(false, true);
local _SellPrice 		= UI.getChildControl ( Panel_Trade_Market_ItemList, "StaticText_sellPrice" ); 									_SellPrice:SetShow(false, true);
local _QuotationRate 	= UI.getChildControl ( Panel_Trade_Market_ItemList, "StaticText_QuotationRate" ); 					_QuotationRate:SetShow(false, true);
local _AddCard 			= UI.getChildControl ( Panel_Trade_Market_ItemList, "Button_AddCart" ); 										_AddCard:SetShow(false, true);

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local tradeMarket =
{
	isTradeMode = 0,		-- NONE, 구입, 판매
	iconSizeCalcX = 175,
	iconSizeCalcY = 165,
	maxSellCount = 9,
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
	itemEnchantKey = {},
	itemIndex = {},
	
	icons = {}
}

---------------------------
-- Functions
---------------------------
local tradeMarketList_Position = function()
	local basePosX = Panel_Trade_Market_Graph_Window:GetSizeX()
	Panel_Trade_Market_ItemList:SetPosX( basePosX )
end

function global_setBuyList()
	Panel_Trade_Market_ItemList:SetShow( true )
	tradeMarketList_Position()

	for count = 1, tradeMarket.maxSellCount do
		tradeMarket:setShowTradeIcon( count, false )
	end
	
	local sellCount = npcShop_getBuyCount()
	
	tradeMarket.isTradeMode = 1	-- 구입 모드

	local commerceIndex = 1

	for index = 1, sellCount do
		if -1 ~= global_SelectCommerceType then
			local itemwrapper = npcShop_getItemBuy(index-1)
			local itemSell = itemwrapper:get()
			local itemStatus = itemwrapper:getStaticStatus()
		
			local itemCommerceType = itemStatus:getCommerceType()
			if itemCommerceType == global_SelectCommerceType then
				if tradeMarket.maxSellCount < commerceIndex then
					-- UI.debugMessage( "too much" )
					return
				end
				tradeMarket:setShowTradeIcon( commerceIndex, true )
				
				local itemSS = itemStatus:get()
				tradeMarket.itemEnchantKey[commerceIndex] = itemSS._key:get()
				tradeMarket.itemIndex[commerceIndex] = index-1
				
				-- 번호, 이름, 남은 수량, 가격 데이터 가져오기
				tradeMarket:setBuyItemDataInfo( commerceIndex, itemStatus:getName(), itemSell.leftCount_s64, itemSell.price_s64 )
				tradeMarket.icons[commerceIndex]:setItemByStaticStatus( itemwrapper:getStaticStatus() )
				
				-- 아이콘 위치 잡아주기
				tradeMarket.icons[commerceIndex].icon:SetShow(true)
				local iconPosX = tradeMarket.ListBody[commerceIndex]:GetPosX()
				local iconPosY = tradeMarket.ListBody[commerceIndex]:GetPosY()

				tradeMarket.icons[commerceIndex].icon:SetPosX( 52 )		--iconPosX +
				tradeMarket.icons[commerceIndex].icon:SetPosY( 9 ) 		--iconPosY +
				commerceIndex = commerceIndex + 1
			end
		end
	end
end

function global_sellItemFromPlayer()
	Panel_Trade_Market_ItemList:SetShow( true )
	tradeMarketList_Position()
	
	for count = 1, tradeMarket.maxSellCount do
		tradeMarket:setShowTradeIcon( count, false )
	end
	
	local sellCount = npcShop_getSellCount()
	
	tradeMarket.isTradeMode = 2		--	판매 모드
	local itemwrapper
	
	local commerceIndex = 1
	for count = 1, sellCount do
		itemwrapper = npcShop_getItemSell( count - 1 )

		local itemSell = itemwrapper:get()
		local itemStatus = itemwrapper:getStaticStatus()
		
		local itemSS = itemStatus:get()
		tradeMarket.itemEnchantKey[commerceIndex] = itemSS._key:get()
		tradeMarket.itemIndex[commerceIndex] = count-1

		local itemCommerceType = itemStatus:getCommerceType()
		tradeMarket:setShowTradeIcon( commerceIndex, true )

		tradeMarket:setBuyItemDataInfo( commerceIndex, itemStatus:getName(), itemSell.leftCount_s64, itemSell.sellpriceToNpc_s64 )	--  itemStatus:getSellPriceCalculate()
		
		local priceRate = npcShop_getItemSellPriceRate( count - 1 )
		tradeMarket.Quotation[commerceIndex]:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "Lua_TradeMarketList_Percents", "Count", tostring( priceRate ) )
		tradeMarket.icons[commerceIndex]:setItemByStaticStatus( itemwrapper:getStaticStatus() )

		tradeMarket.icons[commerceIndex].icon:SetShow(true)
		local iconPosX = tradeMarket.ListBody[commerceIndex]:GetPosX()
		local iconPosY = tradeMarket.ListBody[commerceIndex]:GetPosY()

		tradeMarket.icons[commerceIndex].icon:SetPosX( 52 )
		tradeMarket.icons[commerceIndex].icon:SetPosY( 9 )
		commerceIndex = commerceIndex + 1		
	end
end

-- 아이템 정보 표시
function tradeMarket:setBuyItemDataInfo( index, itemName, leftCount, price )
	local sellPrice = Int64toInt32 (price)
	tradeMarket.itemName[index]:SetText(tostring(itemName))
	tradeMarket.sellPrice[index]:SetText(tostring( sellPrice ))
	if 1 == tradeMarket.isTradeMode then
		tradeMarket.AddCart[ index ]:SetText( PAGetString( Defines.StringSheet_GAME, "Lua_TradeMarketList_AddtoCart") )
		tradeMarket.remainCount[index]:SetText( PAGetString( Defines.StringSheet_GAME, "Lua_TradeMarketList_RemainCountunLimit") )
	elseif 2 == tradeMarket.isTradeMode then
		tradeMarket.AddCart[ index ]:SetText( PAGetString( Defines.StringSheet_GAME, "Lua_TradeMarketList_Sell") )
		tradeMarket.remainCount[index]:SetText( ""  )
	end
end


-- 상품 위치 셋팅
function createItemList()
	local index  = 1
	for col = 1 , 3 do
		for row = 1, 3 do
			getItemList( index, row, col )
			index = index + 1
		end
	end
	
	--Panel_Trade_Market_ItemList:SetSize( tradeMarket.ListBody[index-1]:GetPosX() + Panel_Trade_Market_ItemList:SetSize( tradeMarket.ListBody[index-1]:GetSize )
end

function updateMarketList()
	if false == Panel_Trade_Market_ItemList:GetShow() then
		-- return
	end
	
	if false == isKeyDown_Once( VCK.KeyCode_LBUTTON ) then
		return
	end
	
	local mousePosX = getMousePosX()
	local mousePosY = getMousePosY()
	
	local enableStart = Panel_Trade_Market_ItemList:getEnableStart()
	local enableEnd = Panel_Trade_Market_ItemList:getEnableEnd()
	
	local checkStartPosX = Panel_Trade_Market_ItemList:GetParentPosX() + enableStart.x
	local checkStartPosY = Panel_Trade_Market_ItemList:GetParentPosY() + enableStart.y
	local checkEndPosX = Panel_Trade_Market_ItemList:GetParentPosX() + enableEnd.x
	local checkEndPosY = Panel_Trade_Market_ItemList:GetParentPosY() + enableEnd.y

	if false == ((checkStartPosX < mousePosX and checkEndPosX > mousePosX) and ( checkStartPosY < mousePosY and checkEndPosY > mousePosY )) then
		Panel_Trade_Market_ItemList:SetShow( false )
	end
end

-- 실제 control 생성하는 부분
function getItemList( index, row, col )
	local tempListBody = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Trade_Market_ItemList, "Static_Panel_"..index )
	CopyBaseProperty( _ItemPanel, tempListBody )
	tradeMarket.ListBody[index] = tempListBody
	
	local tempItemSlotBG = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, tempListBody, "Static_Slot_"..index )
	CopyBaseProperty( _SlotBG, tempItemSlotBG )
	tradeMarket.itemSlot_BG[index] = tempItemSlotBG
	
	local icon = {}
	SlotItem.new( icon, 'TradeShopItem_' .. index, index, tempListBody, tradeMarket.slotConfig )
	icon:createChild()

	local tempRemainCount = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_remainCount_"..index )
	CopyBaseProperty( _RemainCount, tempRemainCount )
	tradeMarket.remainCount[index] = tempRemainCount
	
	local tempItemName = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_itemName_"..index )
	CopyBaseProperty( _ItemName, tempItemName )
	tradeMarket.itemName[index] = tempItemName
	
	local tempSellPrice = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_sellPrice_"..index )
	CopyBaseProperty( _SellPrice, tempSellPrice )
	tradeMarket.sellPrice[index] = tempSellPrice
	
	local tempQuotation = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, tempListBody, "StaticText_QuotationRate_"..index )
	CopyBaseProperty( _QuotationRate, tempQuotation )
	tradeMarket.Quotation[index] = tempQuotation
	
	local tempAddCart = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, tempListBody, "Button_AddCart_"..index )
	tempAddCart:addInputEvent( "Mouse_LUp", "click_TradeMarket_AddCart(".. index ..")" )
	CopyBaseProperty( _AddCard, tempAddCart )
	tradeMarket.AddCart[index] = tempAddCart
	
	tradeMarket.icons[index] = icon
	tradeMarket:setShowTradeIcon( index, true)

	posX = (row -1) * tradeMarket.iconSizeCalcX
	posY = col * tradeMarket.iconSizeCalcY
	tempListBody:SetPosX ( posX )
	tempListBody:SetPosY ( posY )
end

function click_TradeMarket_AddCart( index )
	local rv
	if 1 == tradeMarket.isTradeMode then
		Panel_NumberPad_Show(true, Defines.s64_const.s64_10000, param, TradeMarket_BuySome_ConfirmFunction)
	elseif 2 == tradeMarket.isTradeMode then
		rv = npcShop_doSell( tradeMarket.itemIndex[index], 1, 0 )
	end
end

function tradeMarket:setShowTradeIcon( index, isShow )
		tradeMarket.ListBody[index]:SetShow(isShow)
		tradeMarket.itemSlot_BG[index]:SetShow(isShow)
		tradeMarket.remainCount[index]:SetShow(isShow)
		tradeMarket.icons[index].icon:SetShow(isShow)
		tradeMarket.itemName[index]:SetShow(isShow)
		tradeMarket.sellPrice[index]:SetShow(isShow)
		tradeMarket.Quotation[index]:SetShow(isShow)
		tradeMarket.AddCart[index]:SetShow(isShow)
	
		-- 켜준다
		-- local listBodyShow = tradeMarket.ListBody[index]:addColorAnimation( 0.0, 0.65, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
		-- listBodyShow:SetStartColor( UI_color.C_00FFFFFF )
		-- listBodyShow:SetEndColor( UI_color.C_FFFFFFFF )
		-- listBodyShow.IsChangeChild = true

		-- local listBodyShow_Scale = tradeMarket.ListBody[index]:addScaleAnimation( 0.0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
		-- listBodyShow_Scale:SetStartScale(0.75)
		-- listBodyShow_Scale:SetEndScale(1.0)
		-- listBodyShow_Scale.IsChangeChild = true
end

function eventSellorBuyListRefesh()
	if false == global_IsTrading then
		return
	end
	
	if 1 == tradeMarket.isTradeMode then
		global_setBuyList()
	elseif 2 == tradeMarket.isTradeMode then
		global_sellItemFromPlayer()
	end
end

createItemList()
Panel_Trade_Market_ItemList:RegisterUpdateFunc( "updateMarketList" )
registerEvent("EventNpcShopUpdate", "eventSellorBuyListRefesh")

--registerEvent("FromClient_GroundMouseClick", "updateMarketList");