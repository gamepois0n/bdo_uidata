local UI_TYPE		= CppEnums.PA_UI_CONTROL_TYPE
local ENT 			= CppEnums.ExplorationNodeType
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color
local UI_TM 		= CppEnums.TextMode

local viewWorldMapTradeNpcKey = -1

function FromClient_OnWorldMapTradeNpc( tradeNpcStatic )
	local uiHeadStatic = tradeNpcStatic:FromClient_getTradeListHead()
	--uiHeadStatic:SetShow(true)
end

function FromClient_OutWorldMapTradeNpc( tradeNpcStatic )
	local uiHeadStatic = tradeNpcStatic:FromClient_getTradeListHead()
	uiHeadStatic:SetShow(false)
end

function FromClient_LClickWorldMapTradeNpc( tradeNpcStatic )
	local clientSpawnInRegionData = tradeNpcStatic:getClientSpawnInRegionData()
	--local characterSS = clientSpawnInRegionData:FromClient_getCharacterSS()
	if true == clientSpawnInRegionData:FromClient_isTerritorySupply() then
		WorldMapPopupManager:increaseLayer(false)
		refreshTradeSupplyList( clientSpawnInRegionData )
		WorldMapPopupManager:push(Panel_TradeNpcItemInfo, true)
		--Panel_TradeNpcItemInfo:SetShow(true)
	elseif clientSpawnInRegionData:FromClient_isTerritoryTrade() then
		-- 황실 무역은 시세 보여주지 않는다.
		return
	else
		local wp = npcShop_demandWpByRequestShop( clientSpawnInRegionData:get():getKeyRaw() )
		
		viewWorldMapTradeNpcKey = clientSpawnInRegionData:get():getKeyRaw()

		local messageboxTitle = PAGetString( Defines.StringSheet_GAME, "Lua_WorldMap_TradeList_Show_Title" )						-- "무역 시세 확인"
		local messageboxMemo = PAGetStringParam1( Defines.StringSheet_GAME, "Lua_WorldMap_TradeList_Show_Question", "Usewp", wp )	--"무역 시세를 확인하기 위해서는 기운이 " .. wp .. " 소모됩니다.\n확인하시겠습니까?"
		local messageboxData	= { title = messageboxTitle, content = messageboxMemo, functionYes = ViewTradeShopGraphList, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox( messageboxData )
	end
end

function FromClient_RClickWorldMapTradeNpc( tradeNpcStatic )
	local npcData = tradeNpcStatic:getClientSpawnInRegionData()
	local pos3D = npcData:getPosition()
	FromClient_RClickWorldmapPanel( pos3D, true )
end

function ViewTradeShopGraphList()
	ToClient_npcShop_requestShopItemListByWorldMap( viewWorldMapTradeNpcKey )
end

function FromClient_ResponseWorldMapTradeNpc( clientSpawnInRegionData, tradeNpcStatic )
	if( false == ToClient_WorldMapIsShow() ) then
		return
	end
	WorldMapPopupManager:increaseLayer(false)
	WorldMapPopupManager:push(Panel_Trade_Market_Graph_Window, true)
	global_CommerceGraphDataInit(true)
end

registerEvent("FromClient_OnWorldMapTradeNpc",		"FromClient_OnWorldMapTradeNpc")
registerEvent("FromClient_OutWorldMapTradeNpc",		"FromClient_OutWorldMapTradeNpc")
registerEvent("FromClient_LClickWorldMapTradeNpc",	"FromClient_LClickWorldMapTradeNpc")
registerEvent("FromClient_RClickWorldMapTradeNpc",	"FromClient_RClickWorldMapTradeNpc")
registerEvent("FromClient_ResponseWorldMapTradeNpc","FromClient_ResponseWorldMapTradeNpc")