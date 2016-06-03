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

local _itemInventoryMoney			= UI.getChildControl ( Panel_Window_UnknownRandomSelect, "StaticText_MyMoney" )		-- 보유 금액

local _itemButtonReSelect			= UI.getChildControl ( Panel_Window_UnknownRandomSelect, "Button_ItemReSelect" )			-- 아이템 다시 뽑기
local _itemButtonSelect				= UI.getChildControl ( Panel_Window_UnknownRandomSelect, "Button_ItemSelect" )				-- 아이템 구매하기

local shopTypeNum = nil

function randomShopShow( slotNo )
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

			if nil ~= itemRandomSS then
				local itemIconPath = itemRandomSS:getIconPath()
				_itemIcon:ChangeTextureInfoName( "Icon/" .. itemIconPath )

				_itemIcon			:addInputEvent( "Mouse_On", "ItemRandomShowToolTip( " .. ii .. ", " .. slotNo .. " )")


				_itemValue:SetText( makeDotMoney(shopItem.price_s64) ) -- 아이템의 가격값ㅎ
				_itemNameValue:SetText( itemRandomSS:getName() )
				local myInvenMoney	= Int64toInt32(selfPlayer:get():getInventory():getMoney_s64())
				-- local myWareHouseMoney	= Int64toInt32(warehouse_moneyFromNpcShop_s64())
				
				_itemInventoryMoney:SetText( tostring( makeDotMoney( myInvenMoney ) ) )
				-- _itemWareHouseInventoryMoney:SetText( tostring( makeDotMoney( myWareHouseMoney ) ) )

				--_PA_LOG( "BBB", "myInvenMoney : " .. tostring( myInvenMoney ) .. "myWareHouseMoney : " .. tostring( myWareHouseMoney ) .. "region._waypointKey : " .. tostring(region._waypointKey) .. "waitWorkerCount : " .. waitWorkerCount .. " / " .. maxWorkerCount )
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
	npcShop_doBuy( _selectSlotNo, 1, 0, 0 )
	_selectSlotNo = -1
	Panel_Window_UnknownRandomSelect:SetShow( false )
	--FGlobal_HideDialog()
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

function FromClient_EventRandomShopShow_Random( shopType, slotNo )
	shopTypeNum = shopType
	if 12 == shopType or 13 == shopType then

		randomShopShow( slotNo )
	end
end
registerEvent("FromClient_EventRandomShopShow", "FromClient_EventRandomShopShow_Random")
itemShop_registEventHandler()