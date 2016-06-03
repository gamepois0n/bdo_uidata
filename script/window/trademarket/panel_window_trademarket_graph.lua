--------------- 사용 함수
-- npcShop_getCommerceItemSize( commerceType ) 				해당 무역 타입의 갯수를 가져온다.
-- npcShop_getCommerceItemByIndex( commerceType, index ) 	아이템 키값을 가져온다. 샵에서 파는
-- npcShop_getPriceListSize(itemKey)						아이템키를 넣으면 해당 아이템의 가격 변동된 리스트의 사이즈를 가져온다.
-- npcShop_getTradeGraphPos( itemKey, index )				index 순서대로 위치값을 하나씩 가져온다.

------------------------------------------------------------------------------------------------------------

local debugValue = 0		-- 후에 관련 된 곳은 삭제해야한다. 개발용변수
local last_Tooltip = nil
local index_Tooltip = {}

---------------------------
-- Panel Init
---------------------------
-- Panel_Trade_Market_Graph_Window:SetShow( false, false )	
Panel_Trade_Market_Graph_Window:setGlassBackground(true)

---------------------------
-- Local Variables
---------------------------

-- 데이터의 Index
--[[
0=없음
1=잡화
2=사치품
3=식료품
4=약품
5=군수품 : 종자에서 변경
6=성물
7=의류 : 옷감에서 변경
8=해산물
9=원자재
]]--

local tradeGraphMode = 
{
	eGraphMode_NormalShopGraph = 0,
	eGraphMode_TendGraph = 1,
}

local tradeGraph =
{
	slotConfig =
	{
		createIcon		= true,
		createBorder	= true,
		createCount		= false,
		createCash		= true
	},
	
	_itemMaxCount = 9,
	_isNodeLinked = false,

	_isRefreshData = false,
	_commerceGraph_Max = 2,			-- 무역표시 최대수( 수량이 늘어날수있다면 늘려줘야한다. )
	_currentCommerceIndex = 1,		-- 현재 무역 타입
	_currentCommerceSize = 1,		-- 현재 무역 타입의 물품 갯수
	_buyFromNPCOrSellToNPCOrAll = 3,	-- 1: npc가 판매하는 물품 2: npc가 매입하는 물품 3:ALL
	_currentScrollIndex = 0,		-- 스크롤 상의 위치값
	_commerceItemCount = 0,
	_commerceFirstSelct = 1,
	
	_graphDisplayIndex = {},
	
	_graphBackSizeY = 0,
	
	_intervalValue = 60,
	_graphIntervalValue = 8,
	
	_graphMode = tradeGraphMode.eGraphMode_NormalShopGraph,
	
	_isMouseOn = false,
	_mouseOnIndex = 0,
	_mouseOnCommerceIndexForAll = {},		-- 무역품타입
	_mouseOnOrderIndexForAll = {},			-- 무역품목별 순서 인덱스
	
	_buttonExit = UI.getChildControl( Panel_Trade_Market_Graph_Window, "Button_Win_Close" ),
	
	_buttonQuestion = UI.getChildControl( Panel_Trade_Market_Graph_Window, "Button_Question" ),		--물음표 버튼
	
	_buttonTradeList = 
	{
		[enCommerceType.enCommerceType_Luxury_Miscellaneous] 	= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Button_category_miscellaneous" ),
		[enCommerceType.enCommerceType_Luxury] 					= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Button_category_luxury" ),
		[enCommerceType.enCommerceType_Grocery] 				= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Button_category_grocery" ),
		[enCommerceType.enCommerceType_Cloth] 					= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Button_category_cloth" ),
		[enCommerceType.enCommerceType_ObjectSaint] 			= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Button_category_objetSaint" ),
		--[enCommerceType.enCommerceType_Seed] 					= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Button_category_seed" ),
		[enCommerceType.enCommerceType_MilitarySupplies] 		= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Button_category_militarySupplies" ),
		[enCommerceType.enCommerceType_Medicine] 				= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Button_category_medicine" ),
		[enCommerceType.enCommerceType_SeaFood]		 			= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Button_category_SeaFood" ), 
		[enCommerceType.enCommerceType_RawMaterial]				= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Button_category_RawMaterial" ), 
		[enCommerceType.enCommerceType_Max]		 				= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Button_category_all" )
	},
	
	_dialogSceneIndex =
	{
		[enCommerceType.enCommerceType_Luxury_Miscellaneous] 	= 8,
		[enCommerceType.enCommerceType_Luxury] 					= 7,
		[enCommerceType.enCommerceType_Grocery] 				= 5,
		[enCommerceType.enCommerceType_Cloth] 					= 10,
		[enCommerceType.enCommerceType_ObjectSaint] 			= 11,
		--[enCommerceType.enCommerceType_Seed] 					= 9,
		[enCommerceType.enCommerceType_MilitarySupplies] 		= 12,
		[enCommerceType.enCommerceType_Medicine] 				= 6,
		[enCommerceType.enCommerceType_SeaFood] 				= 14,
		[enCommerceType.enCommerceType_RawMaterial] 			= 13,
		[enCommerceType.enCommerceType_Max]						= 0
	},
	
	_buttonTradePosition = {},

	_staticLines =
	{
		[enCommerceType.enCommerceType_Luxury_Miscellaneous] 	= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Line_category_miscellaneous" ),
		[enCommerceType.enCommerceType_Luxury] 					= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Line_category_luxury" ),
		[enCommerceType.enCommerceType_Grocery] 				= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Line_category_grocery" ),
		[enCommerceType.enCommerceType_Cloth] 					= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Line_category_cloth" ),
		[enCommerceType.enCommerceType_ObjectSaint] 			= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Line_category_objetSaint" ),
		--[enCommerceType.enCommerceType_Seed] 					= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Line_category_seed" ),
		[enCommerceType.enCommerceType_MilitarySupplies] 		= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Line_category_militarySupplies" ),
		[enCommerceType.enCommerceType_Medicine] 				= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Line_category_medicine" ),
		[enCommerceType.enCommerceType_SeaFood]					= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Line_category_seaFood" ),
		[enCommerceType.enCommerceType_RawMaterial]				= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Line_category_rawMaterial" ),
		[enCommerceType.enCommerceType_Max]		 				= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Line_category_All" )
	},
	
	--------
	_graphMiniPanel = {},
	--------
	
	_staticCommerceGraphs = {},
	_staticCurrentPoint = {},
	_staticHighPoint = {},
	_staticLowPoint = {},
	_staticCommceName = {},
	_staticText_PermissionMsg = {},
	_staticPriceRate = {},
	_static_PriceIcon = {},
	_static_OriginalPrice = {},
	_static_SupplyCount = {},
	_static_Condition = {},
	_static_GraphBaseLine = {},
	
	---
	_icons = {},
	_currentBar,
	_graphInfoText = UI.getChildControl( Panel_Trade_Market_Graph_Window, "StaticText_GraphInfo" ),
	
	--- 임시
	-- _pointPoint =
	-- {
	-- },
	----
	
	_staticTitle				= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Panel_Title" ),
	_staticRectangle			= UI.getChildControl( Panel_Trade_Market_Graph_Window, "graphFrame" ),
	
	_staticMiniPanel			= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Static_MiniPanel" ),
	_staticGraph				= UI.getChildControl( Panel_Trade_Market_Graph_Window, "graph_panel" ),
	_staticBaseCurrentPoint		= UI.getChildControl( Panel_Trade_Market_Graph_Window, "graph_currentPoint" ),
	_staticBaseHighPoint		= UI.getChildControl( Panel_Trade_Market_Graph_Window, "graph_LowestPoint" ),
	_staticBaseLowPoint			= UI.getChildControl( Panel_Trade_Market_Graph_Window, "graph_highestPoint" ),
	
	_staticBaseCommerceName		= UI.getChildControl( Panel_Trade_Market_Graph_Window, "item_name" ),
	_staticTextPermission		= UI.getChildControl( Panel_Trade_Market_Graph_Window, "StaticText_Permission" ),
	--_staticBaseSellPrice = UI.getChildControl( Panel_Trade_Market_Graph_Window, "item_sellPrice" ),
	_staticBasePriceRate		= UI.getChildControl( Panel_Trade_Market_Graph_Window, "item_quotationRate" ),
	_static_BasePriceIcon		= UI.getChildControl( Panel_Trade_Market_Graph_Window, "item_sellPrice_goldIcon" ),
	_static_OriginalPriceIcon	= UI.getChildControl( Panel_Trade_Market_Graph_Window, "item_originalPrice_goldIcon" ),
	_static_SupplyCountText		= UI.getChildControl( Panel_Trade_Market_Graph_Window, "item_supply_count" ),
	_static_ConditionText		= UI.getChildControl( Panel_Trade_Market_Graph_Window, "StaticText_ConditionValue" ),
	_static_BaseLine			= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Static_BasePosition" ),
	
	--_staticFrame = UI.getChildControl( Panel_Trade_Market_Graph_Window, "Frame_Graph" ),

	_scroll						= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Scroll_Slot_List" ),
	_currentBar 				= UI.getChildControl( Panel_Trade_Market_Graph_Window, "graph_currentPosition" ),
	
	_button_BuyFromNPC			= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Button_BuyFromNPC" ),
	_button_SellToNPC			= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Button_SellToNPC" ),
	
	_staticTradeItemName		= UI.getChildControl( Panel_Trade_Market_Graph_Window, "StaticText_TradeItemName" ),
	
	------------------------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------------------
	_selectTerritory			= 0,
	_territoryCount				= 0,
	_buttonTerritory 			= {},
	_buttonGoBackGraph			= UI.getChildControl( Panel_Trade_Market_Graph_Window, "Button_Back" ),
}

tradeGraph._staticBaseCommerceName:SetTextMode( CppEnums.TextMode.eTextMode_Limit_AutoWrap )

local territoryCount = getTerritoryInfoCount()
for countIndex = 1, territoryCount do
	tradeGraph._buttonTerritory[countIndex] = UI.getChildControl( Panel_Trade_Market_Graph_Window, "Button_category_Territory_" .. (countIndex - 1) )
	tradeGraph._buttonTerritory[countIndex]:addInputEvent( "Mouse_LUp", "buttonLupTradeGraph_Territory(".. countIndex ..")" )
end

tradeGraph._buttonGoBackGraph:addInputEvent( "Mouse_LUp", "buttonLupGoBackTradeGraph()" )
tradeGraph._buttonGoBackGraph:AddEffect("UI_Trade_Button", true, 0, 0)
tradeGraph._buttonGoBackGraph:SetShow( false )

---------------------------
-- Functions
---------------------------

local _miniPanel = {}
local _byWorldmapForGraph = false
local miniPanelPosY = 0
local _graphPosY = 0
function tradeGraph:registUIControl()
	local sizeRow = tradeGraph._staticGraph:GetSizeX()
	local sizeCol = tradeGraph._staticGraph:GetSizeY()
	
	local graphPanelPosX = tradeGraph._staticGraph:GetPosX() - tradeGraph._staticMiniPanel:GetPosX()
	local graphPanelPosY = tradeGraph._staticGraph:GetPosY() - tradeGraph._staticMiniPanel:GetPosY()
	
	local itemNamePosX = tradeGraph._staticBaseCommerceName:GetPosX() - tradeGraph._staticMiniPanel:GetPosX()
	local itemNamePosY = tradeGraph._staticBaseCommerceName:GetPosY() - tradeGraph._staticMiniPanel:GetPosY()
	
	local ratePosX = tradeGraph._staticBasePriceRate:GetPosX() - tradeGraph._staticMiniPanel:GetPosX()
	local ratePosY = tradeGraph._staticBasePriceRate:GetPosY() - tradeGraph._staticMiniPanel:GetPosY()
	
	local currentPricePosX = tradeGraph._static_BasePriceIcon:GetPosX() - tradeGraph._staticMiniPanel:GetPosX()
	local currentPricePosY = tradeGraph._static_BasePriceIcon:GetPosY() - tradeGraph._staticMiniPanel:GetPosY()
	
	local OriginalPricePosX = tradeGraph._static_OriginalPriceIcon:GetPosX() - tradeGraph._staticMiniPanel:GetPosX()
	local OriginalPricePosY = tradeGraph._static_OriginalPriceIcon:GetPosY() - tradeGraph._staticMiniPanel:GetPosY()
	
	local permissionMsgPosX = graphPanelPosX
	local permissionMsgPosY = graphPanelPosY + (sizeCol / 2) - 15
	
	--tradeGraph._commerceGraph_Max = 3
	for count = 1, tradeGraph._itemMaxCount do	-- tradeGraph._commerceGraph_Max
		local miniPanel = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Trade_Market_Graph_Window, "static_MiniPanel_" .. count )
		CopyBaseProperty( tradeGraph._staticMiniPanel, miniPanel )
		_miniPanel[count] = miniPanel
		
		miniPanel:SetPosX( tradeGraph._staticRectangle:GetPosX() + 3 )
		local staticSizeInterval = tradeGraph._staticRectangle:GetPosY() + sizeCol * (count-1)
		local posY = staticSizeInterval + (tradeGraph._intervalValue * (count-1))
		miniPanel:SetPosY( posY + 3)
		miniPanel:SetShow( false )
		tradeGraph._graphMiniPanel[ count ] = miniPanel
		
		basePosX = miniPanel:GetPosX()
		basePosY = miniPanel:GetPosY()

		local staticGraph = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, miniPanel, "static_Graph" .. count )
		CopyBaseProperty( tradeGraph._staticGraph, staticGraph )
		tradeGraph._staticCommerceGraphs[count] = staticGraph
		tradeGraph._staticCommerceGraphs[count]:addInputEvent( "Mouse_On",  "NpcTradeGraph_StaticMouseOn(" .. count .. ")" )
		tradeGraph._staticCommerceGraphs[count]:addInputEvent( "Mouse_Out",  "NpcTradeGraph_StaticMouseOut(" .. count .. ")" )
		tradeGraph._staticCommerceGraphs[count]:addInputEvent( "Mouse_UpScroll", "NpcTradeGraph_ScrollEvent(true)" )
		tradeGraph._staticCommerceGraphs[count]:addInputEvent( "Mouse_DownScroll", "NpcTradeGraph_ScrollEvent(false)" )

		staticGraph:SetPosX( graphPanelPosX )
		staticGraph:SetPosY( graphPanelPosY )

		local slot = {}
		slot.icon = {}
		SlotItem.new( slot.icon, 'GraphItem_' .. count, count, miniPanel, tradeGraph.slotConfig )
		slot.icon:createChild()
		
		slot.icon.icon:addInputEvent( "Mouse_On", "Tooltip_Item_Show_TradeMarket(" .. count .. ", true)" )
		slot.icon.icon:addInputEvent( "Mouse_Out", "Tooltip_Item_Show_TradeMarket(" .. count .. ", false)" )
		slot.icon.icon:addInputEvent( "Mouse_UpScroll", "NpcTradeGraph_ScrollEvent(true)" )
		slot.icon.icon:addInputEvent( "Mouse_DownScroll", "NpcTradeGraph_ScrollEvent(false)" )

		tradeGraph._icons[count] = slot
		
		slot.icon.icon:SetPosX( 3 )
		slot.icon.icon:SetPosY( 3 )

		local staticCommerceName = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, miniPanel, "static_ItemName" .. count )
		CopyBaseProperty( tradeGraph._staticBaseCommerceName, staticCommerceName )
		tradeGraph._staticCommceName[count] = staticCommerceName

		staticCommerceName:SetPosX( slot.icon.icon:GetPosX() + slot.icon.icon:GetSizeX() + 3 )
		staticCommerceName:SetPosY( -4 )

		local staticTextPermission = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, miniPanel, "StaticText_Permission" .. count )
		CopyBaseProperty( tradeGraph._staticTextPermission, staticTextPermission )
		tradeGraph._staticText_PermissionMsg[count] = staticTextPermission
		staticTextPermission:SetPosX( permissionMsgPosX )
		staticTextPermission:SetPosY( permissionMsgPosY )
		staticTextPermission:SetShow( false )

		local staticPriceRate = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, miniPanel, "item_quotationRate" .. count )
		CopyBaseProperty( tradeGraph._staticBasePriceRate, staticPriceRate )
		tradeGraph._staticPriceRate[count] = staticPriceRate
		staticPriceRate:SetPosX( ratePosX + 30 )
		staticPriceRate:SetPosY( ratePosY - 3 )
		staticPriceRate:SetShow( false )

		local static_PriceIcon = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, miniPanel, "item_sellPrice_goldIcon_" .. count )
		CopyBaseProperty( tradeGraph._static_BasePriceIcon, static_PriceIcon )
		tradeGraph._static_PriceIcon[count] = static_PriceIcon
		static_PriceIcon:SetPosX( ratePosX - 10 )	-- currentPricePosX
		static_PriceIcon:SetPosY( ratePosY - 5 ) -- currentPricePosY
		static_PriceIcon:SetShow( false )
		-- static_PriceIcon:SetAutoResize( true )
		
		local static_OriginalPrice = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, miniPanel, "item_Original_goldIcon_" .. count )
		CopyBaseProperty( tradeGraph._static_OriginalPriceIcon, static_OriginalPrice )
		tradeGraph._static_OriginalPrice[count] = static_OriginalPrice
		static_OriginalPrice:SetPosX( OriginalPricePosX )
		static_OriginalPrice:SetPosY( OriginalPricePosY - 3 )
		static_OriginalPrice:SetShow( false )
		
		local static_SupplyCount = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, miniPanel, "item_Supply_count_" .. count )
		CopyBaseProperty( tradeGraph._static_SupplyCountText, static_SupplyCount )
		tradeGraph._static_SupplyCount[count] = static_SupplyCount
		static_SupplyCount:SetPosX( OriginalPricePosX + static_OriginalPrice:GetSizeX() )
		static_SupplyCount:SetPosY( OriginalPricePosY + 14 )
		static_SupplyCount:SetShow( false )
		
		local static_ConditionText = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, miniPanel, "item_Condition_" .. count )
		CopyBaseProperty( tradeGraph._static_ConditionText, static_ConditionText )
		tradeGraph._static_Condition[count] = static_ConditionText
		static_ConditionText:SetPosX( ratePosX - 10 )
		static_ConditionText:SetPosY( OriginalPricePosY + 14 )
		static_ConditionText:SetShow( false )
		
		local staticCurrentPoint = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, miniPanel, "static_CurrentPoint" .. count )
		CopyBaseProperty( tradeGraph._staticBaseCurrentPoint, staticCurrentPoint )
		tradeGraph._staticCurrentPoint[count] = staticCurrentPoint

		local staticHighPoint = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, miniPanel, "static_HigePoint" .. count )
		CopyBaseProperty( tradeGraph._staticBaseHighPoint, staticHighPoint )
		tradeGraph._staticHighPoint[count] = staticHighPoint

		local staticLowPoint = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, miniPanel, "static_LowPoint" .. count )
		CopyBaseProperty( tradeGraph._staticBaseLowPoint, staticLowPoint )
		tradeGraph._staticLowPoint[count] = staticLowPoint

		local staticBaseLine = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, miniPanel, "static_BaseLine" .. count )
		CopyBaseProperty( tradeGraph._static_BaseLine, staticBaseLine )
		tradeGraph._static_GraphBaseLine[count] = staticBaseLine
	end

	tradeGraph._graphBackSizeY = tradeGraph._staticCommerceGraphs[1]:GetSizeY()
	miniPanelPosY = _miniPanel[1]:GetPosY()
	_graphPosY = tradeGraph._staticCommerceGraphs[1]:GetPosY()
	
	for btnIndex = 1, enCommerceType.enCommerceType_Max - 1 do
		local position =
		{
			x = 0,
			y = 0
		}
		position.x = tradeGraph._buttonTradeList[btnIndex]:GetPosX()
		position.y = tradeGraph._buttonTradeList[btnIndex]:GetPosY()

		tradeGraph._buttonTradePosition[btnIndex] = position
	end

	tradeGraph._scroll:SetPosX( tradeGraph._staticRectangle:GetPosX() + tradeGraph._staticRectangle:GetSizeX() )
	tradeGraph._scroll:SetPosY( tradeGraph._staticRectangle:GetPosY() )
	tradeGraph._scroll:SetControlPos(0)
	tradeGraph._staticGraph:SetShow( false )
	tradeGraph._button_SellToNPC:AddEffect("UI_Trade_Button", true, 0, 0)
	tradeGraph._button_BuyFromNPC:EraseAllEffect()
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------------------------------

end

local setGraphMiniPanel = function( index, isShow )
	tradeGraph._graphMiniPanel[ index ]:SetShow( isShow )
	local staticGraph = tradeGraph._staticCommerceGraphs[index]
	staticGraph:SetShow( isShow )
	staticGraph:SetGraphMode( isShow )
	tradeGraph._icons[index].icon.icon:SetShow( isShow )
	tradeGraph._staticCurrentPoint[index]:SetShow( isShow )
	tradeGraph._staticLowPoint[index]:SetShow( isShow )
	tradeGraph._staticHighPoint[index]:SetShow( isShow )
	tradeGraph._staticCommceName[index]:SetShow( isShow )
	tradeGraph._staticText_PermissionMsg[index]:SetShow( isShow )
	tradeGraph._staticPriceRate[index]:SetShow( isShow )
	tradeGraph._static_PriceIcon[index]:SetShow( isShow )
	tradeGraph._static_OriginalPrice[index]:SetShow( isShow )
	tradeGraph._static_GraphBaseLine[index]:SetShow( isShow )
end

function NpcTradeGraph_StaticMouseOn( index )
	if false == isGraphMode( tradeGraphMode.eGraphMode_NormalShopGraph ) then
		return
	end

	tradeGraph._isMouseOn = true
	tradeGraph._mouseOnIndex = index
	tradeGraph._currentBar:SetShow( true )
	tradeGraph._graphInfoText:SetShow( true )
end

function NpcTradeGraph_StaticMouseOut( index )
	if false == isGraphMode( tradeGraphMode.eGraphMode_NormalShopGraph ) then
		return
	end

	tradeGraph._isMouseOn = false
	tradeGraph._mouseOnIndex = 0
	tradeGraph._currentBar:SetShow( false )
	tradeGraph._graphInfoText:SetShow( false )
end

function setChangeGraphMode( graphMode )
	tradeGraph._graphMode = graphMode
end

function isGraphMode( graphMode )
	if tradeGraph._graphMode == graphMode then
		return true
	end
	
	return false
end

function updateTradeMarketGraphData( deltaTime )
	if false == tradeGraph._isMouseOn then
		return
	end
	
	if false == isGraphMode( tradeGraphMode.eGraphMode_NormalShopGraph ) then
		return
	end
	
	tradeGraph._staticTradeItemName:SetShow( false )
	local mousePosX = getMousePosX()
	local mousePosY = getMousePosY()

	local commerceUI = tradeGraph._staticCommerceGraphs[ tradeGraph._mouseOnIndex ]
	
	if nil == commerceUI then
		-- UI.debugMessage( "nil" )
		return
	end

	local mousePosXInUI = commerceUI:GetPosX() + mousePosX - commerceUI:GetParentPosX() - 3
	local mousePosYInUI = commerceUI:GetPosY()

	tradeGraph._currentBar:SetPosX( commerceUI:GetParentPosX() + mousePosXInUI )
	tradeGraph._currentBar:SetPosY( commerceUI:GetParentPosY() )

	tradeGraph._graphInfoText:SetPosX( commerceUI:GetParentPosX() + mousePosXInUI + 8 )
	tradeGraph._graphInfoText:SetPosY( commerceUI:GetParentPosY() + tradeGraph._currentBar:GetSizeY()/2 )

	local posIndex = math.floor( mousePosXInUI / tradeGraph._graphIntervalValue )

	--	UI.debugMessage( "==  posIndex : " .. posIndex .. "  == " )

	if posIndex < 0 or 30 < posIndex then
		return
	end
	
	local findCommercetType = -1
	local findOrderIndex = -1
	-- if enCommerceType.enCommerceType_Max == tradeGraph._currentCommerceIndex then
		-- findCommercetType = tradeGraph._mouseOnCommerceIndexForAll[ tradeGraph._currentScrollIndex + tradeGraph._mouseOnIndex ]
		-- findOrderIndex = tradeGraph._mouseOnOrderIndexForAll[ tradeGraph._currentScrollIndex + tradeGraph._mouseOnIndex ]
	-- else
		if nil == tradeGraph._graphDisplayIndex[ tradeGraph._mouseOnIndex ] then
			-- UI.debugMessage( "tradeGraph._mouseOnIndex : " .. tradeGraph._mouseOnIndex )
			return
		end
		findOrderIndex = tradeGraph._graphDisplayIndex[ tradeGraph._mouseOnIndex ]--tradeGraph._mouseOnIndex - 1
		findCommercetType = tradeGraph._currentCommerceIndex
	--end

	if nil == findOrderIndex then
		return
	end
	local itemKey = npcShop_GetCommerceItemByIndexAndSellOrBuy( findCommercetType, tradeGraph._buyFromNPCOrSellToNPCOrAll, findOrderIndex - 1 )
	
	if 0 ~= itemKey then
		local currentPosPrice = npcShop_getTadePastPrice( itemKey, posIndex )

		-- 임시
		local itemESSW = getItemEnchantStaticStatus( ItemEnchantKey( itemKey ) )
		if -1 == currentPosPrice then
			if 1 == debugValue then
				local sellPrice = npcShop_getTradeItem( itemKey )
				tradeGraph._graphInfoText:SetText( "PositionX : " .. mousePosXInUI ..  "\n  posIndex : " .. posIndex ..  "\n  Price : " .. tostring( sellPrice ) )
			else
				tradeGraph._graphInfoText:SetText( "" )
			end
			return 
		end

		if 1 == debugValue then
			tradeGraph._graphInfoText:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_GRAPH_NAME") .. itemESSW:getName() .. "(" .. itemKey .. ")" .. "\n PositionX : " .. mousePosXInUI ..  "\n  posIndex : " .. posIndex ..  "\n  Price : " .. currentPosPrice .. "\n commerceType : " .. findCommercetType .. "\n index : " .. findOrderIndex )
		else
			tradeGraph._graphInfoText:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "Lua_TradeMarketGraph_currentPrice", "currentPosPrice", currentPosPrice ) )
		end
	end
end

local commerceGraphInitialize = function()
	for count = 1, tradeGraph._itemMaxCount do
		setGraphMiniPanel( count, false )
	end
	
	-- for lineCount = 1, enCommerceType.enCommerceType_Max do
		-- tradeGraph._staticLines[lineCount]:SetShow( false )
	-- end

	tradeGraph._currentBar:SetShow( false )
end

function global_updateCommerceInfoByType( commerceIndex, isSellorBuy )
	Panel_Trade_Market_Graph_Window:ResetRadiobutton( tradeGraph._buttonTradeList[1]:GetGroupNumber() )
	--Panel_Trade_Market_Graph_Window:ResetRadiobutton( tradeGraph._button_BuyFromNPC:GetGroupNumber() )
	if 1 == isSellorBuy then
		tradeGraph._currentScrollIndex = 0
	end
	
	tradeGraph._buyFromNPCOrSellToNPCOrAll = isSellorBuy

	for lineCount = 1, enCommerceType.enCommerceType_Max - 1 do
		tradeGraph._staticLines[lineCount]:SetShow( false )
	end	
	
	check_Empty_CommerceDataALL()
	tradeGraph.updateCommerceInfo( commerceIndex )
	local commerceCount = check_Empty_CommerceData( commerceIndex )
	if 0 == commerceCount then
		tradeGraph._staticLines[ tradeGraph._currentCommerceIndex ]:SetShow( false )	
	end
	
	setBuySellButtonClick()
end

function tradeGraph.updateCommerceInfo( commerceIndex )
	commerceGraphInitialize()
	
	-- 무역품 갯수
	local commerceItemSize = npcShop_getCommerceItemSize( commerceIndex )

	if 0 >= commerceItemSize then
		return
	end

	tradeGraph._currentCommerceIndex = commerceIndex
	tradeGraph._currentCommerceSize = commerceItemSize

	setCommerceButtonClick( tradeGraph._currentCommerceIndex )
	tradeGraph._staticLines[ tradeGraph._currentCommerceIndex ]:SetShow( true )	

	tradeGraph.updateTradeProduct()
end

-- 제일 먼저 호출 되어 진다.
local territorySupplyCheck = false
local _byWorldmap = false
function global_CommerceGraphDataInit(byWorldmap)
	local characterStaticStatusWrapper = npcShop_getCurrentCharacterKeyForTrade()
	local characterStaticStatus = characterStaticStatusWrapper:get()
	
	local talker = dialog_getTalker()
	if nil ~= talker then
		local npcActorproxy = talker:get()
		if nil ~= npcActorproxy then
			local npcPosition = npcActorproxy:getPosition()
			local npcRegionInfo = getRegionInfoByPosition(npcPosition)

			local npcTradeNodeName = npcRegionInfo:getTradeExplorationNodeName()
			local npcTradeOriginRegion = npcRegionInfo:get():getTradeOriginRegion()
			tradeGraph._isNodeLinked = checkSelfplayerNode( npcTradeOriginRegion._waypointKey, true )
		end
	end

	setChangeGraphMode( tradeGraphMode.eGraphMode_NormalShopGraph )
	if characterStaticStatus:isTerritorySupplyMerchant() then				-- 황실 납품 NPC냐?
		tradeGraph._buyFromNPCOrSellToNPCOrAll = 2
		tradeGraph._button_SellToNPC:SetShow( false )
		tradeGraph._button_BuyFromNPC:SetShow( false )
		Panel_Trade_Market_BuyItemList:SetShow( false )
		territorySupplyCheck = true
		eventResetScreenSizeTrade( true )
	elseif characterStaticStatus:isTerritoryTradeMerchant() then			-- 황실 무역 NPC냐?
		tradeGraph._buyFromNPCOrSellToNPCOrAll = 1
		tradeGraph._button_SellToNPC:SetShow( true )
		tradeGraph._button_BuyFromNPC:SetShow( true )
		territorySupplyCheck = false
		eventResetScreenSizeTrade( false )
	elseif characterStaticStatus:isSupplyMerchant() or characterStaticStatus:isFishSupplyMerchant() or characterStaticStatus:isGuildSupplyShopMerchant() then					-- 황실 요리/연금 NPC냐?
		tradeGraph._buyFromNPCOrSellToNPCOrAll = 3
		tradeGraph._button_SellToNPC:SetShow( false )
		tradeGraph._button_BuyFromNPC:SetShow( false )
		Panel_Trade_Market_BuyItemList:SetShow( false )
		territorySupplyCheck = true
		if characterStaticStatus:isGuildSupplyShopMerchant() then
			territorySupplyCheck = false
		end
		eventResetScreenSizeTrade( true )
	else 					-- characterStaticStatus:isNormalTradeMerchant() 일반 무역상이냐?
		tradeGraph._buyFromNPCOrSellToNPCOrAll = 1
		tradeGraph._button_SellToNPC:SetShow( true )
		tradeGraph._button_BuyFromNPC:SetShow( true )
		territorySupplyCheck = false
		eventResetScreenSizeTrade( false )
	end
	if ( nil == byWorldmap ) then
	    byWorldmap = false
	end
	
	if ( true == byWorldmap ) then
    	Panel_Trade_Market_Graph_Window:SetPosX( getScreenSizeX() - Panel_Trade_Market_Graph_Window:GetSizeX() )
    	Panel_Trade_Market_Graph_Window:SetPosY( 50 )
	else
    	Panel_Trade_Market_Graph_Window:SetPosX( 0 )
    	Panel_Trade_Market_Graph_Window:SetPosY( 0 )
	end

	refreshGraphData()

	local territoryCount = getTerritoryInfoCount()
	for countIndex = 1, territoryCount do		-- tradeGraph._territoryCount
		local trendItemSizeInTerritory = ToClient_TrendTradeItemSize(countIndex-1)--( ii - 1 )
		tradeGraph._buttonTerritory[countIndex]:SetShow( false )
	end
	--if false == isGraphMode( tradeGraphMode.eGraphMode_NormalShopGraph ) then
		
	if isGraphMode( tradeGraphMode.eGraphMode_NormalShopGraph ) then
		Panel_Trade_Market_Graph_Window:SetEnableArea( 0, 0, Panel_Trade_Market_Graph_Window:GetSizeX(), Panel_Trade_Market_Graph_Window:GetSizeY() )
		
		if characterStaticStatus:isNormalTradeMerchant() then
			resetTrendGraphButton( false )
			tradeGraph._buttonGoBackGraph:SetShow( false )
		end
	end
	
	--_byWorldmapForGraph = byWorldmap
	_byWorldmap = byWorldmap
	tradeGraph.updateTradeProduct()

	Panel_Trade_Market_Graph_Window:ResetRadiobutton( tradeGraph._buttonTradeList[1]:GetGroupNumber() )
	Panel_Trade_Market_Graph_Window:ResetRadiobutton( tradeGraph._button_BuyFromNPC:GetGroupNumber() )
	
	setCommerceButtonClick( tradeGraph._currentCommerceIndex )
	tradeGraph._staticLines[ tradeGraph._currentCommerceIndex ]:SetShow( true )
	setBuySellButtonClick()	-- 판매 목록 선택

	local typeIndex = tradeGraph._dialogSceneIndex[tradeGraph._currentCommerceIndex]
	if 0 ~= typeIndex and ( false == byWorldmap ) and (true==tradeGraph._isNodeLinked) then
		if not characterStaticStatus:isTerritorySupplyMerchant() then
			global_buyListOpen( commerceCategory[typeIndex].Type )
		end
	end
end

function tradeGraph.updateTradeProduct()
	tradeGraph._scroll:SetShow( true )
	local commerceCount = 0
	
	if 1 == tradeGraph._buyFromNPCOrSellToNPCOrAll then
		commerceCount = check_Empty_CommerceData( tradeGraph._currentCommerceIndex )
	else
		commerceCount = npcShop_getCommerceItemSize(tradeGraph._currentCommerceIndex)
	end
	
	--local commerceCount = check_Empty_CommerceData( tradeGraph._currentCommerceIndex )
	local showCount = 0
	local scrollIndex = tradeGraph._currentScrollIndex
	
	--UI.debugMessage( "commerceCount : " .. commerceCount )
	--_PA_LOG( "asdf", "commerceCount : " .. commerceCount .. " tradeGraph._currentCommerceIndex : " .. tostring( tradeGraph._currentCommerceIndex ) )
	index_Tooltip = {}
	for count = 1, commerceCount do
		if showCount == tradeGraph._commerceGraph_Max then
			break
		end
		
		local itemKey = npcShop_GetCommerceItemByIndexAndSellOrBuy( tradeGraph._currentCommerceIndex, tradeGraph._buyFromNPCOrSellToNPCOrAll, scrollIndex + count - 1 )
		if 0 ~= itemKey then
			showCount = showCount + 1
			tradeGraph.tradeMarket_DrawGraph( tradeGraph._currentCommerceIndex, itemKey, showCount, scrollIndex + count )
			tradeGraph._graphDisplayIndex[ showCount ] = scrollIndex + count
		end
	end

	tradeGraph._commerceItemCount = commerceCount
	UIScroll.SetButtonSize( tradeGraph._scroll, tradeGraph._commerceGraph_Max, commerceCount )
	
	tradeGraph:registTradeGraphEvent()
end

local itemset = {}
local itemsetIndex = 0

function global_TradeMarketGraph_StaticStatus( index )
	local itemKey = npcShop_GetCommerceItemByIndexAndSellOrBuy( itemset[index].commerceIndex, tradeGraph._buyFromNPCOrSellToNPCOrAll, itemset[index].index )
	if 0 == itemKey  then
		return
	end
	return getItemEnchantStaticStatus( ItemEnchantKey(itemKey) )
end

local calcuateY = function( src, dest )
	if src <= dest then
		dest = dest - src
	elseif src >= dest then
		dest = src - dest
	else
		dest = src
	end
	
	return dest
end

local miniPanelSizeY = tradeGraph._staticMiniPanel:GetSizeY()
function tradeGraph.tradeMarket_DrawGraph( commerceIndexForGraph, itemKey, UIIndex, itemOrderIndex )
	local commerceUI = tradeGraph._staticCommerceGraphs[ UIIndex ]
	commerceUI:ClearGraphList()

	--local graphRate = commerceUI:GetSizeY()
	local intervalPosY = tradeGraph._graphBackSizeY/2
	
	commerceUI:setGraphBasePos( intervalPosY )
	
	tradeGraph._graphMiniPanel[ UIIndex ]:SetShow( true )

	local itemESSW = getItemEnchantStaticStatus( ItemEnchantKey( itemKey ) )
	local itemStatus = itemESSW:get()
	
	tradeGraph._icons[UIIndex].icon:setItemByStaticStatus( itemESSW )
	tradeGraph._icons[UIIndex].icon.icon:SetShow( true )
	

	itemset[itemsetIndex] = { commerceIndex = commerceIndexForGraph , index = itemOrderIndex - 1 }
	Panel_Tooltip_Item_SetPosition(itemsetIndex, tradeGraph._icons[UIIndex].icon, "tradeMarket")
	index_Tooltip[UIIndex] = itemsetIndex
	itemsetIndex = itemsetIndex + 1

	-- 원가
	local originalPrice = itemESSW:getOriginalPriceByInt64()
	
	tradeGraph._static_OriginalPrice[UIIndex]:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "Lua_TradeMarketGraph_OriginalPrice", "OriginalPrice", makeDotMoney( originalPrice ) ))	-- tostring( originalPrice )
	--tradeGraph._static_OriginalPrice[UIIndex]:SetText( "commerceIndexForGraph : " .. commerceIndexForGraph .. " itemOrderIndex : " .. itemOrderIndex - 1 )

	-- 판매가
	local tradeItemWrapper = npcShop_getTradeItem( itemKey )
	local sellPrice = tradeItemWrapper:getTradeSellPrice()
	tradeGraph._static_PriceIcon[UIIndex]:SetText( makeDotMoney( sellPrice ) )	-- tostring( sellPrice )
	tradeGraph._static_PriceIcon[UIIndex]:SetPosX( tradeGraph._staticBasePriceRate:GetPosX() - tradeGraph._staticMiniPanel:GetPosX() + tradeGraph._static_PriceIcon[UIIndex]:GetTextSizeX() - 2 )
	
	if ( true == territorySupplyCheck ) then									-- 황실 납품인지 체크
		local _s64_leftCount = tradeItemWrapper:getLeftCount()
		if ( Defines.s64_const.s64_0 == _s64_leftCount ) then
			tradeGraph._static_SupplyCount[UIIndex]:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_5"))
		else
			local _leftCount = Int64toInt32(_s64_leftCount)
			--tradeGraph._static_SupplyCount[UIIndex]:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_6"))
			tradeGraph._static_SupplyCount[UIIndex]:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_TRADEMARKET_GRAPH_SUPPLYCOUNT", "leftCount", _leftCount ) ) -- "<PAColor0xFF96D4FC>남은 수량 : " .. _leftCount .. "개<PAOldColor>")
		end
		tradeGraph._static_SupplyCount[UIIndex]:SetShow( true )
		
		local _gap = tradeGraph._static_SupplyCount[UIIndex]:GetSizeY() + tradeGraph._static_SupplyCount[UIIndex]:GetPosY() - tradeGraph._static_OriginalPrice[UIIndex]:GetPosY()
		_miniPanel[UIIndex]:SetSize( _miniPanel[UIIndex]:GetSizeX(), miniPanelSizeY + _gap )			-- 텍스트가 추가되는 만큼 다른 컨트롤 위치 재계산
		_miniPanel[UIIndex]:SetPosY( miniPanelPosY + ( UIIndex -1 ) * (miniPanelSizeY + _gap) )
		commerceUI:SetPosY( _graphPosY + _gap )
		tradeGraph._staticTitle:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_7") )
		tradeGraph._staticTradeItemName:SetShow( false )
		tradeGraph._static_Condition[UIIndex]:SetShow( false )
	elseif ( 1 == tradeGraph._buyFromNPCOrSellToNPCOrAll ) and ( true == _byWorldmap ) then
		local buyableStack = tradeItemWrapper:getRemainStackCount()
		
		tradeGraph._static_SupplyCount[UIIndex]:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_TRADEMARKET_GRAPH_BUYABLESTACK", "buyableStack", tostring(buyableStack) ) ) -- "<PAColor0xFF96D4FC>최대 재고 : " .. tostring(buyableStack) .. "개<PAOldColor>")
		tradeGraph._static_SupplyCount[UIIndex]:SetShow( true )
		
		local needLifeType			= tradeItemWrapper:get():getNeedLifeType()
		local needLifeLevel			= tradeItemWrapper:get():getNeedLifeLevel()
		local conditionLevel		= FGlobal_CraftLevel_Replace( needLifeLevel + 1, needLifeType )
		local conditionTypeName		= FGlobal_CraftType_ReplaceName( needLifeType )
		local buyingConditionValue	= ""

		if 0 == needLifeLevel or nil == needLifeLevel then
			buyingConditionValue = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_GRAPH_NOPE") -- "구입조건 없음"
			tradeGraph._static_Condition[UIIndex]:SetText( buyingConditionValue )
			tradeGraph._static_Condition[UIIndex]:SetFontColor( Defines.Color.C_FFC4BEBE )
		else
			local player				= getSelfPlayer()
			local playerGet				= player:get()
			local playerThisCraftLevel	= playerGet:getLifeExperienceLevel( needLifeType )

			if needLifeLevel < playerThisCraftLevel then
				tradeGraph._static_Condition[UIIndex]:SetFontColor( Defines.Color.C_FFC4BEBE )
				buyingConditionValue = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_TRADEMARKET_GRAPH_BUYINGCONDITION", "conditionTypeName", conditionTypeName, "conditionLevel", conditionLevel ) -- "<PAColor0xFFC4BEBE>" .. conditionTypeName .. " : " .. conditionLevel .. " 이상<PAOldColor>"
			else
				buyingConditionValue = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_TRADEMARKET_GRAPH_BUYINGCONDITION", "conditionTypeName", conditionTypeName, "conditionLevel", conditionLevel ) -- "<PAColor0xFFa91000>" .. conditionTypeName .. " : " .. conditionLevel .. " 이상<PAOldColor>"
				tradeGraph._static_Condition[UIIndex]:SetFontColor( Defines.Color.C_FF775555 )
			end
			tradeGraph._static_Condition[UIIndex]:SetText( buyingConditionValue )
		end	
		
		tradeGraph._static_Condition[UIIndex]:SetShow( true )

		local _gap = tradeGraph._static_SupplyCount[UIIndex]:GetSizeY() --+ tradeGraph._static_SupplyCount[UIIndex]:GetPosY() - tradeGraph._static_OriginalPrice[UIIndex]:GetPosY()
		_miniPanel[UIIndex]:SetSize( _miniPanel[UIIndex]:GetSizeX(), miniPanelSizeY + _gap )			-- 텍스트가 추가되는 만큼 다른 컨트롤 위치 재계산
		_miniPanel[UIIndex]:SetPosY( miniPanelPosY + ( UIIndex -1 ) * (miniPanelSizeY + _gap) )
		commerceUI:SetPosY( _graphPosY + _gap )
	else
		tradeGraph._static_SupplyCount[UIIndex]:SetShow( false )
		tradeGraph._static_Condition[UIIndex]:SetShow( false )
		_miniPanel[UIIndex]:SetSize( tradeGraph._staticMiniPanel:GetSizeX(), miniPanelSizeY )			-- 원래 위치로 돌려주기
		_miniPanel[UIIndex]:SetPosY( miniPanelPosY + ( UIIndex -1 ) * miniPanelSizeY )
		commerceUI:SetPosY( _graphPosY )
		tradeGraph._staticTitle:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_8") )
	end

	-- 원가 대비
	local sellRate = string.format( "%.f", npcShop_GetTradeGraphRateOfPrice( itemKey ))
	--local str_sellRate = string.format( "%.f", sellRate )
	if 1 == debugValue then
		tradeGraph._staticPriceRate[UIIndex]:SetText( "[ " .. tostring(sellRate) .. "% ]" .. "(" .. itemKey ..")" .. commerceIndexForGraph .. " " .. itemOrderIndex  )
		tradeGraph._staticPriceRate[UIIndex]:SetText( "[ " .. tostring(sellRate) .. "% ]" .. "(" .. tostring( sellPrice ) ..")" .. tostring( originalPrice ) )
	else
		local priceRate_Value = PAGetStringParam1( Defines.StringSheet_GAME, "Lua_TradeMarketGraph_SellRate", "Percent", tostring(sellRate) )
		if 100 < tonumber(tostring(sellRate)) then
			priceRate_Value = "(<PAColor0xFFFFCE22>" .. priceRate_Value .. "▲<PAOldColor>)"
		else
			priceRate_Value = "(<PAColor0xFFF26A6A>" .. priceRate_Value .. "▼<PAOldColor>)"
		end
		tradeGraph._staticPriceRate[UIIndex]:SetText( priceRate_Value )
		tradeGraph._staticPriceRate[UIIndex]:SetPosX( tradeGraph._static_PriceIcon[UIIndex]:GetPosX() --[[+ tradeGraph._static_PriceIcon[UIIndex]:GetTextSizeX()--]] + 15 )
	end

	tradeGraph._static_GraphBaseLine[UIIndex]:SetPosX( commerceUI:GetPosX() )
	tradeGraph._static_GraphBaseLine[UIIndex]:SetPosY( commerceUI:GetPosY() + commerceUI:GetSizeY()/2 )
	tradeGraph._static_GraphBaseLine[UIIndex]:SetShow( true )

	-----
	commerceUI:SetGraphMode( true )
	commerceUI:SetShow( true )
	if 1 == debugValue then
		tradeGraph._staticCommceName[UIIndex]:SetText(itemESSW:getName() .. "(" .. itemKey .. ")")
	else
		tradeGraph._staticCommceName[UIIndex]:SetText( itemESSW:getName() )
	end
	
	if itemStatus._tradeType == 1 then	
		tradeGraph._staticCommceName[UIIndex]:SetFontColor( Defines.Color.C_FFB75EDD )
	else
		tradeGraph._staticCommceName[UIIndex]:SetFontColor( Defines.Color.C_FFE7E7E7 )
	end


	tradeGraph._staticCommceName[UIIndex]:SetShow( true )
	tradeGraph._static_OriginalPrice[UIIndex]:SetShow( true )
	
	if true == tradeItemWrapper:isTradableItem() and ((true == tradeGraph._isNodeLinked) or (true==_byWorldmap)) then
		tradeGraph._staticPriceRate[UIIndex]:SetShow( true )
		tradeGraph._static_PriceIcon[UIIndex]:SetShow( true )
	else
		if itemStatus._tradeType == 1 then
			tradeGraph._staticText_PermissionMsg[UIIndex]:SetText( PAGetString( Defines.StringSheet_RESOURCE, "TRADEMARKET_GRAPH_TXT_PERMISSION2"))			
		else
			tradeGraph._staticText_PermissionMsg[UIIndex]:SetText( PAGetString( Defines.StringSheet_RESOURCE, "TRADEMARKET_GRAPH_TXT_PERMISSION"))
		end		
		tradeGraph._staticText_PermissionMsg[UIIndex]:SetShow( true )
	end
	-----
	
	tradeGraph.tradeMarket_DrawGraphXX( commerceUI, itemKey, UIIndex, tradeItemWrapper, intervalPosY )
end

function tradeGraph.tradeMarket_DrawGraphXX( commerceUI, itemKey, UIIndex, tradeItemWrapper, intervalPosY )
	--local priceCountSize = npcShop_getPriceListSize( itemKey )
	local priceCountSize = tradeItemWrapper:getGraphSize()
	
	local minPosition = -1.0
	local checkMinPos = 9999999.0
	local maxPosition = -1.0
	local checkMaxPos = 0.0

	--drawPos = npcShop_getTradeGraphPos( itemKey, 0 )
	drawPos = tradeItemWrapper:getGraphPosAt( 0 )
	if nil == drawPos then
		return
	end
	
	if ( false == _byWorldmap ) and (false == tradeGraph._isNodeLinked) then
		return
	end

	minPosition = tradeGraph._graphIntervalValue
	maxPosition = tradeGraph._graphIntervalValue

	local value1 = 0
	local value2 = 0
	local value3 = 0
	for count = 1, priceCountSize do
		drawPos = tradeItemWrapper:getGraphPosAt( count - 1 )
		if drawPos.y > 100 then
			drawPos.y = 100
		end
		if drawPos.y < -100 then
			drawPos.y = -100
		end
		--value1=drawPos.y
		drawPos.x = tradeGraph._graphIntervalValue * count
		drawPos.y = drawPos.y*intervalPosY
		--value2=drawPos.y		
		drawPos.y = drawPos.y/100
		--value3=drawPos.y
		
		drawPos.y = calcuateY( intervalPosY, drawPos.y )
		commerceUI:AddGraphPos( drawPos )
		
		if checkMaxPos <= drawPos.y then
			maxPosition = drawPos.x		
			checkMaxPos = drawPos.y
		end
		
		if checkMinPos > drawPos.y then
			minPosition = drawPos.x
			checkMinPos = drawPos.y
		end		
		
		-- 테스트용 임시 포인트 찍어줌
		-- tradeGraph._pointPoint[UIIndex].pp[count]:SetPosX( commerceUI:GetPosX() + drawPos.x )
		-- tradeGraph._pointPoint[UIIndex].pp[count]:SetPosY( commerceUI:GetPosY() + drawPos.y )
		-- tradeGraph._pointPoint[UIIndex].pp[count]:SetShow( true )	
	end
	commerceUI:interpolationGraph()
	-- 현재 위치
	local curPostionUI = tradeGraph._staticCurrentPoint[UIIndex]
	curPostionUI:SetPosX( commerceUI:GetPosX() + drawPos.x - (curPostionUI:GetSizeX()/2) )
	curPostionUI:SetPosY( commerceUI:GetPosY() + drawPos.y - (curPostionUI:GetSizeX()/2) )
	curPostionUI:SetShow( tradeItemWrapper:isTradableItem() )

	if 2 < priceCountSize then
		-- 최저점
		if drawPos.y ~= checkMinPos then
			local lowPostionUI = tradeGraph._staticLowPoint[UIIndex]
			local graphPosY = commerceUI:getinterpolationGraphValue( minPosition )
			lowPostionUI:SetPosX( commerceUI:GetPosX() + minPosition - (lowPostionUI:GetSizeX()/2) )
			lowPostionUI:SetPosY( commerceUI:GetPosY() + graphPosY - (lowPostionUI:GetSizeY()/2) )
			lowPostionUI:SetShow( true )
		end

		-- 최고점
		if drawPos.y ~= checkMaxPos then
			local highPostionUI = tradeGraph._staticHighPoint[UIIndex]
			graphPosY = commerceUI:getinterpolationGraphValue( maxPosition )
			highPostionUI:SetPosX( commerceUI:GetPosX() + maxPosition - (highPostionUI:GetSizeX()/2) )
			highPostionUI:SetPosY( commerceUI:GetPosY() + graphPosY - (highPostionUI:GetSizeY()/2) )
			highPostionUI:SetShow( true )
		end
	end
end

function tradeGraph.CommerceDataShowAll()
	commerceGraphInitialize()

	table.remove( tradeGraph._mouseOnCommerceIndexForAll )
	table.remove( tradeGraph._mouseOnOrderIndexForAll )

	local uiIndexAll = 1
	for commerceIndex = 1, enCommerceType.enCommerceType_Max - 1 do
		local commerceItemSize = npcShop_getCommerceItemSize( commerceIndex )
		for commerceItemCount = 1, commerceItemSize do
			local itemKey = npcShop_GetCommerceItemByIndexAndSellOrBuy( commerceIndex, tradeGraph._buyFromNPCOrSellToNPCOrAll, commerceItemCount - 1 )
			
			if 0 ~= itemKey then
				tradeGraph._mouseOnCommerceIndexForAll[ uiIndexAll ] = commerceIndex	-- 무역품타입
				tradeGraph._mouseOnOrderIndexForAll[ uiIndexAll ] = commerceItemCount	-- 무역품목별 순서 인덱스
				uiIndexAll = uiIndexAll + 1
			end
		end
	end

	tradeGraph._currentCommerceSize = uiIndexAll                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
	local npcKey = dialog_getTalkNpcKey()
	if 0 ~= npcKey then
		tradeGraph.updateTradeProduct()
	end
end

function npcShop_luaGetCommerceItemByIndexAndCheckSellOrBuy( commerceType, index )
	local itemKey = npcShop_GetCommerceItemByIndex( commerceType, index - 1 )

	local checkResult = false
	if 0 ~= itemKey then
		if 1 == tradeGraph._buyFromNPCOrSellToNPCOrAll then
			checkResult = npcShop_CheckBuyFromNPCItem( itemKey )
		elseif 2 == tradeGraph._buyFromNPCOrSellToNPCOrAll then
			checkResult = npcShop_CheckSellToNPCItem( itemKey )
		elseif 3 == tradeGraph._buyFromNPCOrSellToNPCOrAll then
			checkResult = true
		else
			UI.ASSERT( false, "비정상적인 값입니다." )
		end
	end
	
	return checkResult
end

function check_Empty_CommerceData( commerceType )
	local commerceItemSize = npcShop_getCommerceItemSize( commerceType )

	local UICount = 0
	for ii = 1, commerceItemSize do
		local boolValue = npcShop_luaGetCommerceItemByIndexAndCheckSellOrBuy( commerceType, ii )
		if true == boolValue then
			UICount = UICount + 1
		end			
	end
	
	return UICount
end

function check_Empty_CommerceDataALL()
	local commerceButtonIndex = 1;
	local bFirstCommerceType = false	-- 처음 시작시 선택될 무역품 타입 bool... 전체가 없어져서...
	for commerceIndex = 1, enCommerceType.enCommerceType_Max - 1 do
		--local commerceItemSize = npcShop_getCommerceItemSize( commerceIndex )

		local UICount = check_Empty_CommerceData( commerceIndex )
		local lineUI = tradeGraph._buttonTradeList[ commerceIndex ]
		if 0 == UICount then
			lineUI:SetShow( false )
		else
			if false == bFirstCommerceType then
				bFirstCommerceType = true
				tradeGraph._currentCommerceIndex = commerceIndex
			end
			lineUI:SetShow( true )
			lineUI:SetPosX( tradeGraph._buttonTradePosition[ commerceButtonIndex ].x )
			lineUI:SetPosY( tradeGraph._buttonTradePosition[ commerceButtonIndex ].y )
			
			tradeGraph._staticLines[ commerceIndex ]:SetPosX( tradeGraph._buttonTradePosition[ commerceButtonIndex ].x + lineUI:GetSizeX() - 5 )
			tradeGraph._staticLines[ commerceIndex ]:SetPosY( tradeGraph._buttonTradePosition[ commerceButtonIndex ].y + 7)
			
			commerceButtonIndex = commerceButtonIndex + 1
		end		
	end
	-- local lineMaxUI = tradeGraph._buttonTradeList[ enCommerceType.enCommerceType_Max ]
	-- lineMaxUI:SetShow( true )
	-- lineMaxUI:SetPosX( tradeGraph._buttonTradePosition[ commerceButtonIndex ].x )
	-- lineMaxUI:SetPosY( tradeGraph._buttonTradePosition[ commerceButtonIndex ].y )
	
	-- tradeGraph._staticLines[ enCommerceType.enCommerceType_Max ]:SetPosX( tradeGraph._buttonTradePosition[ commerceButtonIndex ].x + lineMaxUI:GetSizeX() - 5)
	-- tradeGraph._staticLines[ enCommerceType.enCommerceType_Max ]:SetPosY( tradeGraph._buttonTradePosition[ commerceButtonIndex ].y + 7)
end

function buttonLupTradeGraph_CommerceType( commerceIndex )
	if commerceIndex == tradeGraph._currentCommerceIndex then
		if 1 == tradeGraph._buyFromNPCOrSellToNPCOrAll then
			local typeIndex = tradeGraph._dialogSceneIndex[commerceIndex]
			if 0 ~= typeIndex and ( false == _byWorldmap ) and(true==tradeGraph._isNodeLinked) then
				global_buyListOpen( commerceCategory[typeIndex].Type )
			end
		end
		
		return
	end
	
	tradeGraph._scroll:SetControlPos( 0 )
	tradeGraph._currentScrollIndex = 0

	for lineCount = 1, enCommerceType.enCommerceType_Max - 1 do
		tradeGraph._staticLines[lineCount]:SetShow( false )
	end	
	
	-- if enCommerceType.enCommerceType_Max == commerceIndex then
		-- tradeGraph._currentCommerceIndex = enCommerceType.enCommerceType_Max
		-- tradeGraph.CommerceDataShowAll()

		-- tradeGraph._staticLines[ commerceIndex ]:SetShow( true )
	-- else
		tradeGraph._currentCommerceIndex = commerceIndex
		local characterStaticStatusWrapper = npcShop_getCurrentCharacterKeyForTrade()
		if 0 ~= characterStaticStatusWrapper then
			tradeGraph.updateCommerceInfo( commerceIndex )
		end
	-- end
	
	if 1 == tradeGraph._buyFromNPCOrSellToNPCOrAll then
		local typeIndex = tradeGraph._dialogSceneIndex[commerceIndex]
		if 0 ~= typeIndex and ( false == _byWorldmap ) and ( true == tradeGraph._isNodeLinked ) then
			global_buyListOpen( commerceCategory[typeIndex].Type )
		end
	end
	
	-- if 1 == tradeGraph._buyFromNPCOrSellToNPCOrAll or 3 == tradeGraph._buyFromNPCOrSellToNPCOrAll then
		-- global_buyListOpen( commerceIndex )
	-- end
end

function global_SellPanel_Refresh( Sell_itemSSS )	-- commerceTypeIndex
	local clickSellItemKey = Sell_itemSSS:get()._key:get()
	local clickSellCommerceType = Sell_itemSSS:getCommerceType()
	if 2 ~= tradeGraph._buyFromNPCOrSellToNPCOrAll then
		click_SellToNPC()
		setBuySellButtonClick()
	end

	local commerceItemSize = npcShop_getCommerceItemSize( clickSellCommerceType )
	local commerceCount = check_Empty_CommerceData( clickSellCommerceType )
	local tempScrollIndex = 0
	if tradeGraph._commerceGraph_Max < commerceItemSize then
		tempScrollIndex = npcShop_getTradeItemIndex( clickSellCommerceType, clickSellItemKey )
		
		if commerceItemSize < tempScrollIndex + tradeGraph._commerceGraph_Max - 1 then
			tempScrollIndex = commerceItemSize - tradeGraph._commerceGraph_Max
		end
	end
	
	tradeGraph._currentScrollIndex = tempScrollIndex
	UIScroll.ScrollEvent( tradeGraph._scroll, true, tradeGraph._commerceGraph_Max, commerceCount, tradeGraph._currentScrollIndex, 1 )
	global_updateCommerceInfoByType( clickSellCommerceType, 2 )
end

-- 무역품 현재 설정으로 갱신시켜주기
function global_updateCurrentCommerce()
	if nil == tradeGraph._currentCommerceIndex then
		return true
	end
	
	if false == isGraphMode( tradeGraphMode.eGraphMode_NormalShopGraph ) then
		return false
	end
	
	-- if tradeGraph._currentCommerceIndex == enCommerceType.enCommerceType_Max then
		-- tradeGraph.CommerceDataShowAll()
	-- else
	if tradeGraph._currentCommerceIndex > 0 and tradeGraph._currentCommerceIndex < enCommerceType.enCommerceType_Max then
		tradeGraph.updateCommerceInfo( tradeGraph._currentCommerceIndex )
	end
	
	return true
end

function eventResetScreenSizeTrade( supplyShop )
	Panel_Trade_Market_Graph_Window:SetSize( Panel_Trade_Market_Graph_Window:GetSizeX(), getScreenSizeY() - Panel_Npc_Trade_Market:GetSizeY() )
	
	tradeGraph._staticRectangle:SetPosY( Panel_Trade_Market_Graph_Window:GetPosY() + 80 )
	local rtSizeY = Panel_Trade_Market_Graph_Window:GetSizeY() - 90
	tradeGraph._staticRectangle:SetSize( tradeGraph._staticRectangle:GetSizeX(), rtSizeY )
	tradeGraph._scroll:SetSize( tradeGraph._scroll:GetSizeX(), rtSizeY )
	
	-- miniPanel 사이즈에 따라 보여줄 개수를 조절해 주도록 하자( 해상도 변경에 따라 달라질 수 있다. )
	local _gap = tradeGraph._static_SupplyCount[1]:GetSizeY() + tradeGraph._static_SupplyCount[1]:GetPosY() - tradeGraph._static_OriginalPrice[1]:GetPosY()
	if nil == supplyShop or not supplyShop then
		_gap = 0
	end
	local miniPanelSizeY = tradeGraph._staticMiniPanel:GetSizeY() + _gap
	local showMiniPanelCount = 0
	tradeGraph._commerceGraph_Max = 1
	for count = 1, tradeGraph._itemMaxCount do
		if rtSizeY > miniPanelSizeY * count then
			showMiniPanelCount = showMiniPanelCount + 1
		else
			break
		end
	end

	for count = 1, tradeGraph._itemMaxCount do
		setGraphMiniPanel( count, false )
	end
	tradeGraph._commerceGraph_Max = showMiniPanelCount
end

function refreshGraphData()
	check_Empty_CommerceDataALL()

	--tradeGraph._currentCommerceIndex = enCommerceType. --enCommerceType.enCommerceType_Max
	tradeGraph.CommerceDataShowAll()		-- 여기서 처음 갱신됨
	tradeGraph._scroll:SetControlPos( 0 )
	tradeGraph._currentScrollIndex = 0
	
	for lineCount = 1, enCommerceType.enCommerceType_Max - 1 do
		tradeGraph._staticLines[lineCount]:SetShow( false )
	end
	
	Panel_Trade_Market_Graph_Window:ResetRadiobutton( tradeGraph._buttonTradeList[1]:GetGroupNumber() )
	
	setCommerceButtonClick( tradeGraph._currentCommerceIndex )
	tradeGraph._staticLines[ tradeGraph._currentCommerceIndex ]:SetShow( true )
end

function setBuySellButtonClick()
	local buttonBaseTexture = tradeGraph._button_BuyFromNPC:getBaseTexture()
	local buttonClickTexture = tradeGraph._button_BuyFromNPC:getClickTexture()
	if 1 == tradeGraph._buyFromNPCOrSellToNPCOrAll then
		tradeGraph._button_BuyFromNPC:setRenderTexture( buttonClickTexture )
		tradeGraph._button_SellToNPC:setRenderTexture( buttonBaseTexture )
	elseif 2 == tradeGraph._buyFromNPCOrSellToNPCOrAll or 3 == tradeGraph._buyFromNPCOrSellToNPCOrAll then
		tradeGraph._button_BuyFromNPC:setRenderTexture( buttonBaseTexture )
		tradeGraph._button_SellToNPC:setRenderTexture( buttonClickTexture )
	else
		UI.ASSERT( false, "비정상적인 번호 입니다." )
	end 
end

function setCommerceButtonClick( buttonIndex )
	local buttonUI = tradeGraph._buttonTradeList[ buttonIndex ]
	local btnClickTexture = buttonUI:getClickTexture()
	buttonUI:setRenderTexture( btnClickTexture )

	if 1 == tradeGraph._buyFromNPCOrSellToNPCOrAll then
		tradeGraph._button_BuyFromNPC:EraseAllEffect()
		tradeGraph._button_BuyFromNPC:AddEffect("UI_Trade_Button", true, 0, 0)
		tradeGraph._button_SellToNPC:EraseAllEffect()
	elseif 2 == tradeGraph._buyFromNPCOrSellToNPCOrAll then
		tradeGraph._button_SellToNPC:EraseAllEffect()
		tradeGraph._button_SellToNPC:AddEffect("UI_Trade_Button", true, 0, 0)
		tradeGraph._button_BuyFromNPC:EraseAllEffect()
	end
end

function click_BuyFromNPC()
	tradeGraph._buyFromNPCOrSellToNPCOrAll = 1
	tradeGraph._button_BuyFromNPC:AddEffect("UI_Trade_Button", true, 0, 0)
	tradeGraph._button_SellToNPC:EraseAllEffect()
	refreshGraphData()
	
	local typeIndex = tradeGraph._dialogSceneIndex[tradeGraph._currentCommerceIndex]
	if 0 ~= typeIndex and ( false == _byWorldmap ) and ( true == tradeGraph._isNodeLinked ) then
		global_buyListOpen( commerceCategory[typeIndex].Type )
	end
	
	commerceGraphInitialize()
	tradeGraph.updateTradeProduct()
end

function click_SellToNPC()
	tradeGraph._buyFromNPCOrSellToNPCOrAll = 2
	tradeGraph._button_SellToNPC:AddEffect("UI_Trade_Button", true, 0, 0)
	tradeGraph._button_BuyFromNPC:EraseAllEffect()
	Panel_Trade_Market_BuyItemList:SetShow( false )
	refreshGraphData()
	
	commerceGraphInitialize()
	tradeGraph.updateTradeProduct()
end

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- TrendGraph
function trendTradeItemInfoInShop()
	setChangeGraphMode( tradeGraphMode.eGraphMode_TendGraph )
	
	for count = 1, enCommerceType.enCommerceType_Max - 1 do
		tradeGraph._buttonTradeList[ count ]:SetShow( false )
	end
	
	tradeGraph._territoryCount = getTerritoryInfoCount()

	resetTrendGraphButton( true )
	Panel_Trade_Market_Graph_Window:SetEnableArea( -30000, -30000, 30000, 30000 )
	
	commerceGraphInitialize()	
	tradeGraph._currentScrollIndex = 0	
	tradeGraph.updateTrendTradeItem()
	buttonLupTradeGraph_Territory(1)
end

function tradeGraph.updateTrendTradeItem()

	tradeGraph._staticTradeItemName:SetShow( true )
	
	local scrollIndex = tradeGraph._currentScrollIndex
	local UIIndex = 1
	
	tradeGraph._scroll:SetShow( true )
	
	--_PA_LOG( "TrendGraph", "scrollIndex : " .. tostring( scrollIndex ) )
	--local territoryCount = getTerritoryInfoCount()
	local trendItemSizeInTerritory = ToClient_TrendTradeItemSize(tradeGraph._selectTerritory)--( ii - 1 )
	--_PA_LOG( "TrendGraph", "trendItemSizeInTerritory : " .. tostring( trendItemSizeInTerritory ) .. "  " ..  tostring( tradeGraph._commerceGraph_Max ) )
	local territoryInfoWrapper = getTerritoryInfoWrapperByIndex(tradeGraph._selectTerritory)--(ii-1)

	tradeGraph._commerceItemCount = trendItemSizeInTerritory
	local territoryKey = territoryInfoWrapper:getKeyRaw()
	for itemCountInTerritory = 1, trendItemSizeInTerritory do
		if itemCountInTerritory + scrollIndex - 1 == trendItemSizeInTerritory then
			break
		end
		local tradeItemWrapper = ToClient_GetTrendTradeItemAt( territoryKey, itemCountInTerritory + scrollIndex - 1 )
		if nil ~= tradeItemWrapper then
			local itemSS = tradeItemWrapper:getStaticStatus()
			local itemKey = itemSS:get()._key

			if UIIndex == tradeGraph._commerceGraph_Max + 1 then
				-- _PA_LOG( "TrendGraph", "UIIndex : " .. tostring( UIIndex ) )
				break
			end
			
			local commerceUI = tradeGraph._staticCommerceGraphs[ UIIndex ]
			commerceUI:ClearGraphList()

			local intervalPosY = tradeGraph._graphBackSizeY/2
			
			commerceUI:setGraphBasePos( intervalPosY )
			
			tradeGraph._graphMiniPanel[ UIIndex ]:SetShow( true )

			local itemESSW = getItemEnchantStaticStatus( itemKey )
			local itemStatus = itemESSW:get()
			
			tradeGraph._icons[UIIndex].icon:setItemByStaticStatus( itemESSW )
			tradeGraph._icons[UIIndex].icon.icon:SetShow( true )
			tradeGraph._icons[UIIndex].icon.icon:addInputEvent( "Mouse_On", "Tooltip_Item_Show_TradeMarket(" .. UIIndex .. ", true)" )
			tradeGraph._icons[UIIndex].icon.icon:addInputEvent( "Mouse_Out", "Tooltip_Item_Show_TradeMarket(" .. UIIndex .. ", false)" )
			
			local originalPrice = itemESSW:getOriginalPriceByInt64()
			tradeGraph._static_OriginalPrice[UIIndex]:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "Lua_TradeMarketGraph_OriginalPrice", "OriginalPrice", makeDotMoney( originalPrice ) ))	-- tostring( originalPrice )

			local sellPrice = tradeItemWrapper:getTradeSellPrice()
			tradeGraph._static_PriceIcon[UIIndex]:SetText( makeDotMoney( sellPrice ) )
			tradeGraph._static_PriceIcon[UIIndex]:SetPosX( tradeGraph._staticBasePriceRate:GetPosX() - tradeGraph._staticMiniPanel:GetPosX() + tradeGraph._static_PriceIcon[UIIndex]:GetTextSizeX() - 2 )
			
			local sellRate = Int64toInt32(sellPrice) / Int64toInt32(originalPrice) * 100
			local str_sellRate = string.format( "%.f", sellRate )
			local priceRate_Value = PAGetStringParam1( Defines.StringSheet_GAME, "Lua_TradeMarketGraph_SellRate", "Percent", tostring(str_sellRate) )
			if 100 < tonumber(tostring(str_sellRate)) then
				priceRate_Value = "(<PAColor0xFFFFCE22>" .. priceRate_Value .. "▲<PAOldColor>)"
			else
				priceRate_Value = "(<PAColor0xFFF26A6A>" .. priceRate_Value .. "▼<PAOldColor>)"
			end
			tradeGraph._staticPriceRate[UIIndex]:SetText( priceRate_Value )
			tradeGraph._staticPriceRate[UIIndex]:SetPosX( tradeGraph._static_PriceIcon[UIIndex]:GetPosX() + 15 ) --tradeGraph._static_PriceIcon[UIIndex]:GetSizeX() + 20 )
			tradeGraph._staticPriceRate[UIIndex]:SetShow(false)

			tradeGraph._static_GraphBaseLine[UIIndex]:SetPosX( commerceUI:GetPosX() )
			tradeGraph._static_GraphBaseLine[UIIndex]:SetPosY( commerceUI:GetPosY() + commerceUI:GetSizeY()/2 )
			tradeGraph._static_GraphBaseLine[UIIndex]:SetShow( true )

			commerceUI:SetGraphMode( true )
			commerceUI:SetShow( true )
			local trendItemRegion = tradeItemWrapper:getTrendRegionInfo()
			if 1 == debugValue then
				tradeGraph._staticCommceName[UIIndex]:SetText(trendItemRegion:getAreaName() .. "(" .. itemKey .. ")")
			else
				tradeGraph._staticCommceName[UIIndex]:SetText( trendItemRegion:getAreaName() )					-- 아이템 이름이 들어가야 하지만 trendgraph 일경우 지역명을 넣는다.
				--tradeGraph._staticCommceName[UIIndex]:SetText( itemESSW:getName() )
			end
			
			if itemStatus._tradeType == 1 then	
				tradeGraph._staticCommceName[UIIndex]:SetFontColor( Defines.Color.C_FFB75EDD )
			else
				tradeGraph._staticCommceName[UIIndex]:SetFontColor( Defines.Color.C_FFE7E7E7 )
			end


			tradeGraph._staticCommceName[UIIndex]:SetShow( true )
			tradeGraph._static_OriginalPrice[UIIndex]:SetShow( true )
			
			if true == tradeItemWrapper:isTradableItem() and ((true == tradeGraph._isNodeLinked) or (true==_byWorldmap)) then
				tradeGraph._staticPriceRate[UIIndex]:SetShow( true )
				tradeGraph._static_PriceIcon[UIIndex]:SetShow( true )
			else
				if itemStatus._tradeType == 1 then
					tradeGraph._staticText_PermissionMsg[UIIndex]:SetText( PAGetString( Defines.StringSheet_RESOURCE, "TRADEMARKET_GRAPH_TXT_PERMISSION2"))			
				else
					tradeGraph._staticText_PermissionMsg[UIIndex]:SetText( PAGetString( Defines.StringSheet_RESOURCE, "TRADEMARKET_GRAPH_TXT_PERMISSION"))
				end		
				tradeGraph._staticText_PermissionMsg[UIIndex]:SetShow( true )
			end
			
			local graphSize = tradeItemWrapper:getGraphSize()
			tradeGraph.tradeMarket_DrawGraphXX( commerceUI, itemKey:get(), UIIndex, tradeItemWrapper, intervalPosY )
			--tradeGraph.tradeMarket_DrawGraph( tradeGraph._currentCommerceIndex, itemKey, showCount, scrollIndex + UIIndex )
			tradeGraph._graphDisplayIndex[ UIIndex ] = scrollIndex + UIIndex
			
			UIIndex = UIIndex + 1
		else
			-- _PA_LOG( "TrendGraph", "nil" )
		end			
	end

	local _tradeItemWrapper = ToClient_GetTrendTradeItemAt( territoryKey, 1 + scrollIndex )
	if nil ~= _tradeItemWrapper then
		local itemSS = _tradeItemWrapper:getStaticStatus()
		local itemKey = itemSS:get()._key
		local itemESSW = getItemEnchantStaticStatus( itemKey )
		local itemStatus = itemESSW:get()
		local trendName = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_GRAPH_TRENDNAME") -- "<PAColor0xFFFFCE22>" .. itemESSW:getName() .. "<PAOldColor> 시세 확인"
		tradeGraph._staticTradeItemName:SetText( trendName )
		tradeGraph._staticTradeItemName:SetShow( true )
	end

	UIScroll.SetButtonSize( tradeGraph._scroll, tradeGraph._commerceGraph_Max, trendItemSizeInTerritory )
end

function buttonLupTradeGraph_Territory( buttonIndex )
	tradeGraph._selectTerritory	= buttonIndex - 1
	tradeGraph._currentScrollIndex = 0
	
	commerceGraphInitialize()
	for lineCount = 1, enCommerceType.enCommerceType_Max - 1 do
		tradeGraph._staticLines[lineCount]:SetShow( false )
	end
	
	tradeGraph._staticLines[ buttonIndex ]:SetShow( true )

	tradeGraph.updateTrendTradeItem()
	tradeGraph._scroll:SetControlPos( 0 )
end

function buttonLupGoBackTradeGraph()
	tradeGraph._currentCommerceIndex = 1
	resetTrendGraphButton( false )

	click_BuyFromNPC()
	setChangeGraphMode( tradeGraphMode.eGraphMode_NormalShopGraph )
	
	Panel_Trade_Market_Graph_Window:SetEnableArea( 0, 0, Panel_Trade_Market_Graph_Window:GetSizeX(), Panel_Trade_Market_Graph_Window:GetSizeY() )
	npcShop_requestList()			-- 시세보고 난후에 클라 가격이 비정상으로 저장되어 있기때문에 정보를 다시 받아와야합니다.
	--global_CommerceGraphDataInit( false )
end

function resetTrendGraphButton( isShow )
	if true == isShow then
		for countIndex = 1, tradeGraph._territoryCount do		-- tradeGraph._territoryCount
			local trendItemSizeInTerritory = ToClient_TrendTradeItemSize(countIndex-1)--( ii - 1 )
			if 0 <= trendItemSizeInTerritory - 1 then
				_PA_LOG( "TrendGraph", countIndex - 1 .. " trendItemSizeInTerritory: " .. tostring( trendItemSizeInTerritory ) )
				local territoryInfoWrapper = getTerritoryInfoWrapperByIndex(countIndex-1)--(ii-1)
				tradeGraph._buttonTerritory[countIndex]:SetText( territoryInfoWrapper:getTerritoryName() )

				tradeGraph._buttonTerritory[countIndex]:SetShow( true )
			else
				tradeGraph._buttonTerritory[countIndex]:SetShow( false )
			end
		end
	else
		local territoryCount = getTerritoryInfoCount()
		for countIndex = 1, territoryCount do		-- tradeGraph._territoryCount
			local trendItemSizeInTerritory = ToClient_TrendTradeItemSize(countIndex-1)--( ii - 1 )
			tradeGraph._buttonTerritory[countIndex]:SetShow( false )
		end
	end
	
	tradeGraph._buttonGoBackGraph:SetShow( isShow )
	tradeGraph._staticTradeItemName:SetShow( false )
	
	if true == isShow then
		tradeGraph._button_BuyFromNPC:SetShow( false )
		tradeGraph._button_SellToNPC:SetShow( false )
	else
		tradeGraph._button_BuyFromNPC:SetShow( true )
		tradeGraph._button_SellToNPC:SetShow( true )
	end
end

function tradeGraph:registTradeGraphEvent()
	Panel_Trade_Market_Graph_Window:RegisterUpdateFunc("updateTradeMarketGraphData")
	registerEvent( "onScreenResize", "eventResetScreenSizeTrade" )
	
	tradeGraph._buttonExit:addInputEvent( "Mouse_LUp", "closeNpcTrade_BasketByGraph()" )
	
	local talker = dialog_getTalker()
	if nil ~= talker then
		local actorKeyRaw = talker:getActorKey()
		local actorProxyWrapper = getNpcActor(actorKeyRaw)
		local actorProxy = actorProxyWrapper:get()
		local characterStaticStatus = actorProxy:getCharacterStaticStatus()
		
		-- 밀무역상은 팔기 버튼을 없앤다!
		if characterStaticStatus:isSmuggleMerchant() then
			tradeGraph._button_SellToNPC:SetShow( false )
		end

		if characterStaticStatus:isTerritorySupplyMerchant() then																	-- 황실 납품 NPC냐?
			tradeGraph._buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"TerritorySupply\" )" )			--물음표 좌클릭
		elseif characterStaticStatus:isTerritoryTradeMerchant() then																-- 황실 무역 NPC냐?
			tradeGraph._buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"TerritoryTrade\" )" )				--물음표 좌클릭
		else 																														-- 일반 무역상이냐?
			tradeGraph._buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelTradeMarketGraph\" )" )		--물음표 좌클릭
		end
	else
		local characterStaticStatusWrapper = npcShop_getCurrentCharacterKeyForTrade()
		if ( nil == characterStaticStatusWrapper ) then
			return
		end
		local characterStaticStatus = characterStaticStatusWrapper:get()
		
		if characterStaticStatus:isTerritorySupplyMerchant() then				-- 황실 납품 NPC냐?
			tradeGraph._buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"TerritorySupply\" )" )			--물음표 좌클릭
		elseif characterStaticStatus:isTerritoryTradeMerchant() then			-- 황실 무역 NPC냐?
			tradeGraph._buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"TerritoryTrade\" )" )				--물음표 좌클릭
		else 						-- characterStaticStatus:isNormalTradeMerchant() 일반 무역상이냐?
			tradeGraph._buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelTradeMarketGraph\" )" )		--물음표 좌클릭
		end
	end
	
	tradeGraph._buttonQuestion:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"PanelTradeMarketGraph\", \"true\")" )			--물음표 마우스오버
	tradeGraph._buttonQuestion:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"PanelTradeMarketGraph\", \"false\")" )			--물음표 마우스아웃
	tradeGraph._button_BuyFromNPC:addInputEvent( "Mouse_LUp", "click_BuyFromNPC()" )
	tradeGraph._button_SellToNPC:addInputEvent( "Mouse_LUp", "click_SellToNPC()" )
	
	UIScroll.InputEvent( tradeGraph._scroll, "NpcTradeGraph_ScrollEvent" )

	tradeGraph._staticRectangle:addInputEvent( "Mouse_UpScroll", "NpcTradeGraph_ScrollEvent(true)" )
	tradeGraph._staticRectangle:addInputEvent( "Mouse_DownScroll", "NpcTradeGraph_ScrollEvent(false)" )
	
	for count = 1, enCommerceType.enCommerceType_Max - 1 do
		tradeGraph._buttonTradeList[ count ]:addInputEvent( "Mouse_LUp", "buttonLupTradeGraph_CommerceType(".. count ..")" )
	end
	
	registerEvent("FromClient_TrendInfoInShop", "trendTradeItemInfoInShop")
end

function NpcTradeGraph_ScrollEvent( isUpScroll )
	local pre_Index = tradeGraph._currentScrollIndex
	tradeGraph._currentScrollIndex	= UIScroll.ScrollEvent( tradeGraph._scroll, isUpScroll, tradeGraph._commerceGraph_Max, tradeGraph._commerceItemCount, tradeGraph._currentScrollIndex, 1 )
	local cur_Index = tradeGraph._currentScrollIndex
	-- _PA_LOG( "TrendGraph", " tradeGraph._currentScrollIndex: " .. tostring( tradeGraph._currentScrollIndex ) )
	commerceGraphInitialize()
	
	if isGraphMode( tradeGraphMode.eGraphMode_NormalShopGraph ) then
		tradeGraph.updateTradeProduct()
	elseif isGraphMode( tradeGraphMode.eGraphMode_TendGraph ) then
		tradeGraph.updateTrendTradeItem()
	end

	if last_Tooltip ~= nil and Panel_Tooltip_Item:GetShow() == true then
		Tooltip_Item_Show_TradeMarket(last_Tooltip, true)
	end
end

function Tooltip_Item_Show_TradeMarket(UIIndex ,isShow)
	if false == isGraphMode( tradeGraphMode.eGraphMode_NormalShopGraph ) then
		return
	end

	if true == isShow then
		last_Tooltip = UIIndex
	elseif false == isShow then
		if last_Tooltip ~= UIIndex then
			return
		end
		last_Tooltip = nil
	end
	local _itemsetIndex = index_Tooltip[UIIndex]
	if _itemsetIndex ~= nil then
		Panel_Tooltip_Item_Show_GeneralStatic(_itemsetIndex , "tradeMarket", isShow)
	end
end

function closeNpcTrade_BasketByGraph()
	if ( Defines.UIMode.eUIMode_Trade == GetUIMode() ) then
		closeNpcTrade_Basket()
	else
		WorldMapPopupManager:pop()
		--Panel_Trade_Market_Graph_Window:SetShow( false, false )
	end
end

tradeGraph:registUIControl()
tradeGraph:registTradeGraphEvent()