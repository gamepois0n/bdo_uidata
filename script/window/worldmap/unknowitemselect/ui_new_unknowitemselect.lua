local IM 			= CppEnums.EProcessorInputMode
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local ENT 			= CppEnums.ExplorationNodeType
local UI_color 		= Defines.Color
local UI_TYPE		= CppEnums.PA_UI_CONTROL_TYPE
local UI_TM 		= CppEnums.TextMode
local VCK 			= CppEnums.VirtualKeyCode

Panel_Window_UnknownRandomSelect:SetDragEnable( true )
Panel_Window_UnknownRandomSelect:SetDragAll( true )

local _selectSlotNo = -1

local _itemIcon 					= UI.getChildControl ( Panel_Window_UnknownRandomSelect, "Static_ItemIcon" )				-- 아이템 아이콘

-- value 값
local _itemNameValue				= UI.getChildControl ( Panel_Window_UnknownRandomSelect, "StaticText_UnknowItemName" )			-- 아이템의 이름
local _itemValue 					= UI.getChildControl ( Panel_Window_UnknownRandomSelect, "StaticText_ItemPriceValue" )			-- 아이템의 가치

local _itemButtonReSelect			= UI.getChildControl ( Panel_Window_UnknownRandomSelect, "Button_ItemReSelect" )			-- 아이템 다시 뽑기
local _itemButtonSelect				= UI.getChildControl ( Panel_Window_UnknownRandomSelect, "Button_ItemSelect" )				-- 아이템 구매하기

local _myInven						= UI.getChildControl ( Panel_Window_UnknownRandomSelect, "StaticText_Money" )
local _myWareHouse					= UI.getChildControl ( Panel_Window_UnknownRandomSelect, "StaticText_Money2" )
local _myInvenBtn					= UI.getChildControl ( Panel_Window_UnknownRandomSelect, "RadioButton_Icon_Money" )
local _myWareHouseBtn				= UI.getChildControl ( Panel_Window_UnknownRandomSelect, "RadioButton_Icon_Money2" )

local _iconSilver					= UI.getChildControl ( Panel_Window_UnknownRandomSelect, "StaticText_Gold_Icon3" )
local _itemPriceBG					= UI.getChildControl ( Panel_Window_UnknownRandomSelect, "StaticText_ItemPrice" )




local shopTypeNum = nil
local randomShopItemPrice = 0
function randomShopShow( slotNo, priceRate )
	local sellCount = npcShop_getBuyCount()

	local selfPlayer = getSelfPlayer()
	local MyWp = selfPlayer:getWp()

	for ii = 0, sellCount - 1 do
		local itemwrapper = npcShop_getItemBuy(ii)
		--local itemStatus = itemwrapper:getStaticStatus()

		local shopItem = itemwrapper:get()
		--_PA_LOG( "EEE", "shopItem.shopSlotNo : " .. tostring ( shopItem.shopSlotNo ) )
		if slotNo == shopItem.shopSlotNo then
			_selectSlotNo = shopItem.shopSlotNo
			itemRandomSS = itemwrapper:getStaticStatus()
			sellPrice_64 = itemRandomSS:get()._sellPriceToNpc_s64
			sellPrice_32 = Int64toInt32(sellPrice_64)
			-- efficiency = itemRandomSS:getEfficiency( 2, ItemExchangeKey(0) )
			
			--_PA_LOG( "asdf", " shopItem.price_s64 : " .. tostring( shopItem.price_s64 ) .. " priceRate : " .. tostring( priceRate ) )

			if nil ~= itemRandomSS then
				local itemIconPath = itemRandomSS:getIconPath()
				_itemIcon:ChangeTextureInfoName( "Icon/" .. itemIconPath )
				_itemIcon			:addInputEvent( "Mouse_On", "ItemRandomShowToolTip( " .. ii .. ", " .. slotNo .. " )")

				local price32 = Int64toInt32( shopItem.price_s64 )
				price32 = price32 * priceRate / 1000000
				randomShopItemPrice = price32
				_itemValue:SetText( makeDotMoney(price32) ) -- 아이템의 가격값ㅎ
				_iconSilver:SetPosX( _itemPriceBG:GetPosX()+_itemPriceBG:GetTextSizeX() +10 )
				_itemNameValue:SetText( itemRandomSS:getName() )
			end			
		end
	end
	
	if 12 == shopTypeNum then
		useWp = 50
	elseif 13 == shopTypeNum then
		useWp = 10
	end
	-- Panel_Tooltip_Item_SetPosition(0, _itemIcon, "RandomItem")

	--_PA_LOG( "AAA", "sellCount : " .. sellCount .. " name : " .. itemStatus:getName() .. "itemRandomSS:_actionPoint : " .. itemRandomSS._actionPoint ) -- .. "shopItem._contentsEventParam1 : " .. shopItem._contentsEventParam1
	if MyWp < useWp then
		_itemButtonReSelect:SetEnable( false )
		_itemButtonReSelect:SetMonoTone( true )
	else
		_itemButtonReSelect:SetEnable( true )
		_itemButtonReSelect:SetMonoTone( false )
	end

	randomSelectShow()
end

-- 랜덤 아이템 열기
function randomSelectShow()
	Panel_Window_UnknownRandomSelect:SetShow( true )
	_myInvenBtn:SetCheck( true )
	_myWareHouseBtn:SetCheck( false )
end

function randomSelectHide()
	Panel_Window_UnknownRandomSelect:SetShow( false )
end

-- 랜덤 아이템 다시 돌리기
function click_ItemReSelect()
	messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_UNKNOWITEMSELECT_RESELECT_TITLE") -- "아이템 뽑기"
	if 12 == shopTypeNum then
		contentString	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_UNKNOWITEMSELECT_RESELECT_STRING", "getWp", getSelfPlayer():getWp() ) -- "아이템을 다시 뽑으시겠습니까?\n다시 뽑을 때 기운 50이 소모됩니다.\n현재 기운 : " .. getSelfPlayer():getWp()
	elseif 13 == shopTypeNum then
		contentString	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_UNKNOWITEMSELECT_RESELECT_STRING2", "getWp", getSelfPlayer():getWp() )
	end

	local messageboxData = { title = messageTitle, content = contentString, functionYes = Item_RequestShopList,  functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
	MessageBox.showMessageBox( messageboxData )
end

-- 다시 요청한다는 것은 상점을 다시 열도록 하자
function Item_RequestShopList()
	local myWp = getSelfPlayer():getWp()

	if 12 == shopTypeNum then
		useWp = 50
	elseif 13 == shopTypeNum then
		useWp = 10
	end

	if myWp < useWp then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_UNKNOWITEMSELECT_WP_SHORTAGE_ACK") ) -- "기운이 부족합니다." )
		randomSelectHide()
	else
		npcShop_requestList( CppEnums.ContentsType.Contents_Shop )
		if myWp < useWp then
			_itemButtonReSelect:SetEnable( false )
			_itemButtonReSelect:SetMonoTone( true )
		else
			_itemButtonReSelect:SetEnable( true )
			_itemButtonReSelect:SetMonoTone( false )
		end
	end
end

-- 선택한 아이템을 구매 요청하자
function click_ItemSelect()
	messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_UNKNOWITEMSELECT_RESELECT_TITLE") -- "아이템 뽑기"
	messageMemo = PAGetString(Defines.StringSheet_GAME, "LUA_UNKNOWITEMSELECT_BUYITEMCONFIRM") -- "해당 아이템을 구매하시겠습니까?"
	local messageboxData = { title = messageTitle, content = messageMemo, functionYes = Item_RequestDoBuy,  functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
	MessageBox.showMessageBox( messageboxData )
end

function Item_RequestDoBuy()
	local invenCheck		= _myInvenBtn:IsCheck()
	local wareHouseMoney	= warehouse_moneyFromNpcShop_s64()

	local moneyWhereType = CppEnums.ItemWhereType.eInventory
	if invenCheck then
		moneyWhereType = CppEnums.ItemWhereType.eInventory
		if getSelfPlayer():get():getInventory():getMoney_s64() < toInt64(0,randomShopItemPrice) then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarket_Not_Enough_Money") )
		end
	else
		moneyWhereType = CppEnums.ItemWhereType.eWarehouse
		
		if wareHouseMoney < toInt64(0,randomShopItemPrice) then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_RANDOMITEM_WAREHOUSEMONEY") )
			return
		else
	end

	end
	npcShop_doBuy( _selectSlotNo, 1, moneyWhereType, 0 )
	_selectSlotNo = -1
	Panel_Window_UnknownRandomSelect:SetShow( false )
	--FGlobal_HideDialog()
end

function FGlobal_ItemRandom_Money_Update()
	_myInven		:SetText( makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()) )
	_myWareHouse	:SetText( makeDotMoney(warehouse_moneyFromNpcShop_s64()) )
end

function ItemRandomShowToolTip( ii, slotNo )
	local itemwrapper = npcShop_getItemBuy(ii)
	local itemRandomSS = itemwrapper:getStaticStatus()
	Panel_Tooltip_Item_Show( itemRandomSS, _itemIcon, true, false, nil )
end

function ItemRandomHideToolTip()
	Panel_Tooltip_Item_hideTooltip()
end

function itemShop_registEventHandler()
	_itemButtonReSelect	:addInputEvent( "Mouse_LUp", "click_ItemReSelect()" )
	_itemButtonSelect	:addInputEvent( "Mouse_LUp", "click_ItemSelect()" )
	-- _itemIcon			:addInputEvent( "Mouse_On", "ItemRandomShowToolTip()")
	_itemIcon			:addInputEvent( "Mouse_Out", "ItemRandomHideToolTip()")
end

function FromClient_EventRandomShopShow_Random( shopType, slotNo, priceRate )
	shopTypeNum = shopType
	if 12 == shopType or 13 == shopType then

		randomShopShow( slotNo, priceRate )
	end
end
registerEvent("FromClient_EventRandomShopShow", "FromClient_EventRandomShopShow_Random")
registerEvent("EventWarehouseUpdate",			"FGlobal_ItemRandom_Money_Update")
itemShop_registEventHandler()
FGlobal_ItemRandom_Money_Update()