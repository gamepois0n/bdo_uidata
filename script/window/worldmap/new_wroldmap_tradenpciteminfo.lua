Panel_TradeNpcItemInfo:SetShow(false)
Panel_TradeNpcItemInfo:SetDragAll( true )

gTradeNpcItemInfo_TerritoryKey = 0

local slotConfig =
{
	createIcon		= true,
	createBorder	= true,
	createCount		= false,
	createCash		= true
}

local maxCount = 6
local _slot = {}
local _slotBG = {}
local _itemStatic = {}
local _basePanel = UI.getChildControl( Panel_TradeNpcItemInfo, "Static_ItemPanel" )
local _buttonClose = UI.getChildControl( Panel_TradeNpcItemInfo, "Button_Close" )
local slotBG = UI.getChildControl( Panel_TradeNpcItemInfo, "Static_SlotBG" )
local nodeNpc = UI.getChildControl( Panel_TradeNpcItemInfo, "nodeMenu_nodeNpc" )
local territoryValue = UI.getChildControl( Panel_TradeNpcItemInfo, "nodeMenu_nodeName" )

local territoryName = {
	[0]	= tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_0")),		-- 발레노스령
	[1] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_1")),		-- 세렌디아령
	[2] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_2")),		-- 칼페온령
	[3] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_3")),		-- 메디아령
	--[4] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_")),		-- 발렌시아령(미정)
}

	local npcName =
{
	[0] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYSUPPLY_NPC_0")),			-- 40073, 벨리아 황실납품
	[1] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYSUPPLY_NPC_1")),			-- 41120, 하이델 황실납품
	[2] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYSUPPLY_NPC_2")),			-- 42311, 칼페온 황실납품
	[3] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYSUPPLY_NPC_3")),			-- 44021, 알티노바 황실납품
	--[4] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYSUPPLY_NPC_4"))		-- 발렌시아 황실납품(미정)
}

function initialize_TradeNpcInfoUI()
	local miniSizeY = _basePanel:GetSizeY()
	local miniPosY = _basePanel:GetPosY()
	
	for count = 1, maxCount do		-- 무역 납품 개수가 6개를 넘지 않는다고 함 20141016(문종씨)
		local miniPanel = UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_TradeNpcItemInfo, "static_ItemPanel_" .. count )
		CopyBaseProperty( _basePanel, miniPanel )
		_itemStatic[count] = miniPanel

		local tempItemSlotBG = UI.createControl ( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_TradeNpcItemInfo, "Static_Slot_".. count )
		CopyBaseProperty( slotBG, tempItemSlotBG )
		_slotBG[count] = tempItemSlotBG
		
		--miniPanel:SetPosY( miniPosY + (miniSizeY * (count-1)) )

		local slot = {}
		slot.icon = {}
		SlotItem.new( slot.icon, 'TradeSupply_Icon' .. count, count, miniPanel, slotConfig )
		slot.icon:createChild()

		slot.icon.icon:addInputEvent( "Mouse_On", "Tooltip_Item_Show_TradeSupply(" .. count .. ", true)" )
		slot.icon.icon:addInputEvent( "Mouse_Out", "Tooltip_Item_Show_TradeSupply(" .. count .. ", false)" )
		
		slot.icon.icon:SetPosX( 3 )
		slot.icon.icon:SetPosY( 3 )
		
		_slot[count] = slot
	end
	
	_buttonClose:addInputEvent( "Mouse_LUp", "close_TradeNpcItemInfo()" )
end

function Tooltip_Item_Show_TradeSupply( count, isShow )
	Panel_Tooltip_Item_Show_GeneralStatic( count, "tradeSupply", isShow)
end

function TradeNpcItemInfo_getTerritoryKey()
	return gTradeNpcItemInfo_TerritoryKey
end

function resetTerritorySupplyUI()
	for count = 1, maxCount do
		_itemStatic[count]:SetShow( false )
		_slot[count].icon.icon:SetShow( false )
		_slotBG[count]:SetShow( false )
	end
end

function refreshTradeSupplyList( clientSpawnInRegionData )
	--initialize_TradeNpcInfoUI()
	resetTerritorySupplyUI()
	Panel_TradeNpcItemInfo_Reposition()
	local regionInfo = getRegionInfoByPosition( clientSpawnInRegionData:FromClient_getSpawnPosition() )
	gTradeNpcItemInfo_TerritoryKey = regionInfo:getTerritoryKeyRaw()
	territoryValue:SetText( territoryName[gTradeNpcItemInfo_TerritoryKey] .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYSUPPLY_MESSAGE_1"))
	nodeNpc:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYSUPPLY_MESSAGE_2") .. " : " .. npcName[gTradeNpcItemInfo_TerritoryKey] )

	local tradeSupplyCount = ToClient_worldmap_getTradeSupplyCount( regionInfo:getTerritoryKeyRaw() )
	local shopItemWrapper = nil

	local sizeX 		= slotBG:GetSizeX()					-- 아이콘 영역 사이즈(기본 48)
	local gap 			= sizeX * (2/5)						-- 아이콘 간격(기본 19)
	local startPosX 	= ( Panel_TradeNpcItemInfo:GetSizeX() - ( sizeX * tradeSupplyCount + gap * ( tradeSupplyCount - 1))) / 2			-- 아이콘 시작 위치

	for count = 1, tradeSupplyCount do
		shopItemWrapper = ToClient_worldmap_getTradeSupplyItem( regionInfo:getTerritoryKeyRaw(), count - 1 )
		
		if nil ~= shopItemWrapper then
			local itemSSWrapper = shopItemWrapper:getStaticStatus()
			--_itemStatic[count]:SetText( itemSSWrapper:getName() )
			_itemStatic[count]:SetShow( true )
			
			_slot[count].icon:setItemByStaticStatus( itemSSWrapper )
			_slot[count].icon.icon:SetShow( true )
			Panel_Tooltip_Item_SetPosition( count, _slot[count].icon, "tradeSupply")

			local posX = startPosX + ( sizeX + gap ) * ( count - 1 )
			_slot[count].icon.icon:SetPosX( posX - gap )
			_slotBG[count]:SetPosX( posX - 2 )
			_slotBG[count]:SetShow( true )
		end
		
	end
end

function Panel_TradeNpcItemInfo_Reposition()
	Panel_TradeNpcItemInfo:SetPosX( (getScreenSizeX() - Panel_TradeNpcItemInfo:GetSizeX()) / 2 )
	Panel_TradeNpcItemInfo:SetPosY( getScreenSizeY() / 2 - Panel_TradeNpcItemInfo:GetSizeY() * 1.5 )
end

-- function FromClientTradeSupplyList()
	
-- end

function close_TradeNpcItemInfo()
	WorldMapPopupManager:pop()
end

initialize_TradeNpcInfoUI()
--registerEvent( "FromClientNotifySupplyTradeStart",		"FromClientTradeSupplyList" )