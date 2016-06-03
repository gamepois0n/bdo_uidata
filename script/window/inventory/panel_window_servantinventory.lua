Panel_Window_ServantInventory:SetShow(false, false)
Panel_Window_ServantInventory:setMaskingChild(true)
Panel_Window_ServantInventory:ActiveMouseEventEffect(true)
Panel_Window_ServantInventory:setGlassBackground(true)

Panel_Window_ServantInventory:RegisterShowEventFunc( true,	'ServantInventoryShowAni()' )
Panel_Window_ServantInventory:RegisterShowEventFunc( false,	'ServantInventoryHideAni()' )

local UI_ANI_ADV= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color	= Defines.Color
local rowLine	= 0

function 	ServantInventoryShowAni()
	UIAni.fadeInSCR_Down(Panel_Window_ServantInventory)
end

function	ServantInventoryHideAni()
	Panel_Window_ServantInventory:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo1 = Panel_Window_ServantInventory:addColorAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( 16777215 )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)
end

local	servantInventory = {
	_config	=
	{
		-- 아이템
		item	=
		{
			createIcon			= true,
			createBorder		= true,
			createCount			= true,
			createEnchant		= true,
			createCash			= true,
			createEnduranceIcon = true,
		},
		
		-- inventory
		
		inventory	=
		{
			startX		= 15,
			startY		= 60,
			gapY		= 275,
		},
		
		-- 슬롯
		slot =
		{
			count	= 41,
			column	= 8,
			row		= 0,	-- 계산되는 값
			startX	= 9,
			startY	= 40,
			gapX	= 47,
			gapY	= 47,
		},
		
		inventoryCount	= CppEnums.ServantType.Type_Count-1,
	},
	
	_buttonClose		= UI.getChildControl( Panel_Window_ServantInventory, "Button_Close"			),
	_buttonQuestion		= UI.getChildControl( Panel_Window_ServantInventory, "Button_Question"		),		-- 물음표 버튼
	
	_inventory			= Array.new(),
	
	_deleteSlotNo		= nil,
	_s64_deleteCount	= Defines.s64_const.s64_0,
	_targetActorKeyRaw	= nil,
}

function	servantInventory:init()
	local	slotConfig		= self._config.slot
	local	inventoryConfig	= self._config.inventory
	local	useStartSlot	= inventorySlotNoUserStart()
	slotConfig.row = slotConfig.count / slotConfig.column
	
	for ii = 0, self._config.inventoryCount do
		local	inventory	= {}
		inventory._staticBG			= UI.createAndCopyBasePropertyControl( Panel_Window_ServantInventory, "Static_BG",				Panel_Window_ServantInventory,	"ServantInventory_BG_"				.. ii )
		inventory._staticTitle		= UI.createAndCopyBasePropertyControl( Panel_Window_ServantInventory, "StaticText_SubTitle",	inventory._staticBG,			"ServantInventory_Title_"			.. ii )
		inventory._staticCapacity	= UI.createAndCopyBasePropertyControl( Panel_Window_ServantInventory, "StaticText_Capacity",	inventory._staticBG,			"ServantInventory_Capacity_"		.. ii )
		-- inventory._checkSort		= UI.createAndCopyBasePropertyControl( Panel_Window_ServantInventory, "Check_Sort",				inventory._staticBG,			"ServantInventory_CheckSort_"		.. ii )
		-- inventory._buttonSort		= UI.createAndCopyBasePropertyControl( Panel_Window_ServantInventory, "Button_Sort",			inventory._staticBG,			"ServantInventory_ButtonSort_"		.. ii )
				
		inventory._staticMoney		= UI.createAndCopyBasePropertyControl( Panel_Window_ServantInventory, "StaticText_Money",		inventory._staticBG,			"ServantInventory_StaticMoney_"		.. ii )
		inventory._buttonMoney		= UI.createAndCopyBasePropertyControl( Panel_Window_ServantInventory, "Button_Money",			inventory._staticBG,			"ServantInventory_ButtonMoney_"		.. ii )
	
		inventory._iconWeight		= UI.createAndCopyBasePropertyControl( Panel_Window_ServantInventory, "StaticIcon_Weight",		inventory._staticBG,			"ServantInventory_Weight_Icon_"		.. ii )
		inventory._staticWeight		= UI.createAndCopyBasePropertyControl( Panel_Window_ServantInventory, "StaticText_Weight",		inventory._staticBG,			"ServantInventory_Weight_Text_"		.. ii )
		inventory._weightInventory	= UI.createAndCopyBasePropertyControl( Panel_Window_ServantInventory, "Progress2_Weight",		inventory._staticBG,			"ServantInventory_Weight_Inventory_".. ii )
		inventory._weightEquipment	= UI.createAndCopyBasePropertyControl( Panel_Window_ServantInventory, "Progress2_Equipment",	inventory._staticBG,			"ServantInventory_Weight_Equip_"	.. ii )
		inventory._weightMoney		= UI.createAndCopyBasePropertyControl( Panel_Window_ServantInventory, "Progress2_Money",		inventory._staticBG,			"ServantInventory_Weight_Money_"	.. ii )
			
		inventory._staticMoney:SetShow( false )
		inventory._buttonMoney:SetShow( false )
			
		inventory._slot				= Array.new()
		inventory._type				= nil
		inventory._actorKeyRaw		= nil
		for jj = 0, slotConfig.count -1 do
			local	slotNo	= jj + useStartSlot
			local	slot	= {}
		
			slot.empty		= UI.createAndCopyBasePropertyControl( Panel_Window_ServantInventory, "Static_Slot",		inventory._staticBG, "ServantInventory_Inventory_Empty_"	.. ii .. "_" .. jj )
			slot.lock		= UI.createAndCopyBasePropertyControl( Panel_Window_ServantInventory, "Static_LockedSlot",	inventory._staticBG, "ServantInventory_Inventory_Lock_"		.. ii .. "_" .. jj )
			slot.useless	= UI.createAndCopyBasePropertyControl( Panel_Window_ServantInventory, "Static_UselessSlot",	inventory._staticBG, "ServantInventory_Inventory_Useless_"	.. ii .. "_" .. jj )
			slot.enchantText= UI.createAndCopyBasePropertyControl( Panel_Window_ServantInventory, "Static_Enchant",		inventory._staticBG, "ServantInventory_Inventory_Enchant_"	.. ii .. "_" .. jj )
			
			SlotItem.new( slot, 'ItemIcon_' .. jj, jj, inventory._staticBG, self._config.item )
			slot:createChild()
			
			-- position Set
			local column= jj % slotConfig.column
			local row	= math.floor( jj / slotConfig.column )
			slot.empty:SetPosX(			slotConfig.startX + (slotConfig.gapX * column)	)
			slot.empty:SetPosY(			slotConfig.startY + (slotConfig.gapY * row)		)
			slot.lock:SetPosX(			slotConfig.startX + (slotConfig.gapX * column)	)
			slot.lock:SetPosY(			slotConfig.startY + (slotConfig.gapY * row)		)
			slot.useless:SetPosX(		slotConfig.startX + (slotConfig.gapX * column)	)
			slot.useless:SetPosY(		slotConfig.startY + (slotConfig.gapY * row)		)
			slot.icon:SetPosX(			slotConfig.startX + (slotConfig.gapX * column)	)
			slot.icon:SetPosY(			slotConfig.startY + (slotConfig.gapY * row)		)
			slot.enchantText:SetPosX(	slotConfig.startX + (slotConfig.gapX * column)	)
			slot.enchantText:SetPosY(	slotConfig.startY + (slotConfig.gapY * row)		)

			inventory._staticBG:SetChildIndex( slot.enchantText, 9999 )
			slot.enchantText:SetSize(	slot.icon:GetSizeX(), slot.icon:GetSizeY() )
			slot.enchantText:SetTextHorizonCenter()
			slot.enchantText:SetTextVerticalCenter()
			
			slot.icon:SetIgnore(false)
			slot.icon:SetEnableDragAndDrop(true)
			slot.icon:SetAutoDisableTime( 2.0 )
			
			slot.icon:SetShow( true )
			slot.empty:SetShow( false )
			slot.lock:SetShow( false )
			slot.useless:SetShow( false )
			slot.enchantText:SetShow( false )
			
			slot.icon:addInputEvent("Mouse_LUp",		"ServantInventory_DropHandler("	.. ii .. ", " .. slotNo .. ")"	)
			slot.icon:addInputEvent("Mouse_RUp",		"ServantInventory_SlotRClick("	.. ii .. ", " .. slotNo .. ")"	)
			slot.icon:addInputEvent("Mouse_PressMove",	"ServantInventory_SlotDrag("	.. ii .. ", " .. slotNo .. ")"	)
			slot.icon:addInputEvent("Mouse_On",			"Panel_Tooltip_Item_Show_GeneralNormal(" .. slotNo .. ", \"servant_inventory\",true, " .. ii .. ")"	)
			slot.icon:addInputEvent("Mouse_Out",		"Panel_Tooltip_Item_Show_GeneralNormal(" .. slotNo .. ", \"servant_inventory\",false," .. ii .. ")"	)
			
			Panel_Tooltip_Item_SetPosition( slotNo, slot, "servant_inventory" )

			inventory._slot[jj]	= slot
		end
		
		inventory._staticBG:SetPosX(	inventoryConfig.startX									)
		inventory._staticBG:SetPosY(	inventoryConfig.startY		+ inventoryConfig.gapY * ii	)
		
		inventory._staticBG:SetShow( true )
		inventory._staticTitle:SetShow( true )
		inventory._staticTitle:SetText( ii )
		inventory._buttonMoney:addInputEvent("Mouse_LUp", "ServantInventory_SlotRClick( " .. ii .. ", 0 )"	)
		
		-- inventory._checkSort:addInputEvent("Mouse_LUp", "")

		self._inventory[ii]	= inventory
	end
end

function	servantInventory:update()	
	for	ii = 0, self._config.inventoryCount	do
		self:updateByIndex( ii )
	end
	
	--{
		local	sizeY			= 0
		local	inventoryConfig	= self._config.inventory
		for	ii = 0, self._config.inventoryCount	do
			local	data	= self._inventory[ii]
			if	( nil ~= data._actorKeyRaw )	then
				data._staticBG:SetPosY(	inventoryConfig.startY + sizeY	)
				sizeY	= sizeY + data._staticBG:GetSizeY() + 10
			end
		end
		
		sizeY	= sizeY + 70
		Panel_Window_ServantInventory:SetSize( Panel_Window_ServantInventory:GetSizeX(), sizeY )
		Panel_Window_ServantInventory:SetEnableArea( 10, 10, 400, Panel_Window_ServantInventory:GetSizeY() - 10)
	--}
end

function	servantInventory:updateByIndex( index )
	local	data				= self._inventory[index]
	data._staticBG:SetShow( false )
	
	local	vehicleActorWrapper	= getVehicleActor(data._actorKeyRaw)
	if	(nil == vehicleActorWrapper)	then
		return
	end

	local	vehicleActor= vehicleActorWrapper:get()
	if( nil == vehicleActor )	then
		return
	end
	
	local	inventory	= vehicleActor:getInventory()
	if( nil == inventory )	then
		return
	end

	-- Item Count
	--{
		local	useStartSlot		= inventorySlotNoUserStart()
		local	fullCount			= inventory:size() - useStartSlot
		local	freeCount			= inventory:getFreeCount()
		
		data._staticTitle:SetText(		vehicleActorWrapper:getName()							)
		data._staticCapacity:SetText(	tostring((fullCount - freeCount) .. '/' .. fullCount)	)
		data._staticMoney:SetText(		tostring(inventory:getMoney_s64())						)
	--}

	-- Weight
	--{
		local	s64_weightMax		= vehicleActor:getPossessableWeight_s64()
		local	s64_weightAll		= vehicleActor:getCurrentWeight_s64()
		local	s64_weightInventory	= inventory:getWeight_s64()
		local	s64_weightMoney		= inventory:getMoneyWeight_s64()
		local	s64_weightEquip		= Defines.s64_const.s64_0
		local	s64_weightMoneyEquip= Defines.s64_const.s64_0
		local	equip				= vehicleActor:getEquipment()

		if	( nil ~= equip )	then
			s64_weightEquip	= equip:getWeight_s64()
		end
		s64_weightMoneyEquip		= s64_weightMoney + s64_weightEquip

		local	s64_weightMax_div	= s64_weightMax / Defines.s64_const.s64_100
		local	s64_weightAll_div	= (s64_weightAll) / Defines.s64_const.s64_100

		data._weightMoney:SetProgressRate(		Int64toInt32(s64_weightMoney		/ s64_weightMax_div) )
		data._weightEquipment:SetProgressRate(	Int64toInt32(s64_weightMoneyEquip	/ s64_weightMax_div) )
		data._weightInventory:SetProgressRate(		Int64toInt32(s64_weightAll			/ s64_weightMax_div) )

		local	str_AllWeight = string.format("%.1f", Int64toInt32(s64_weightAll_div) / 100 )
		local	str_MaxWeight = string.format("%.0f", Int64toInt32(s64_weightMax_div) / 100 )
		
		data._staticWeight:SetText( str_AllWeight .. ' /' .. str_MaxWeight.." LT" )
		data._weightInventory:SetProgressRate( 	Int64toInt32(s64_weightAll			/ s64_weightMax_div) )
		data._weightEquipment:SetProgressRate(	Int64toInt32(s64_weightMoneyEquip	/ s64_weightMax_div) )
		data._weightMoney:SetProgressRate(		Int64toInt32(s64_weightMoney		/ s64_weightMax_div) )
	--}

	--Empty & Lock Slot
	--{
		for ii = 0, self._config.slot.count -1 do
			local	slot	= data._slot[ii]
			
			slot.empty:SetShow( false )
			slot.lock:SetShow( false )
			slot.useless:SetShow( false )
			
			slot.icon:SetIgnore( true )

			if( ii < fullCount )	then
				slot.empty:SetShow( true )
				slot.icon:SetIgnore( false )
			elseif( fullCount <= ii )	then
				slot.useless:SetShow( true )
			end
			slot:clearItem()	-- 초기화
		end
	--}

	-- Item Slot
	-- 0 번 슬롯은 돈이다 그러므로 1부터 보여준다.!
	--{
		for ii = 0, fullCount - 1 	do
			local	slot		= data._slot[ii]
			local	slotNo		= ii + useStartSlot
			
			local	itemWrapper	= getServantInventoryItemBySlotNo( data._actorKeyRaw, slotNo )
			if	(nil ~= itemWrapper) then
				slot:setItem( itemWrapper )
				--isFiltered = (nil ~= self.filterFunc) and self.filterFunc( itemWrapper );
				--slot.icon:SetEnable( not isFiltered )
				--slot.icon:SetMonoTone( isFiltered )
			-- else
			-- 	slot:clearItem()
			end
		end
	--}	
	
	-- BG Size
	--{
		local	row	= fullCount / 8
		if	( 0 <= fullCount % 8 )	then
			row	= row + 1
		end
		
		data._staticBG:SetSize( data._staticBG:GetSizeX(), 60 + (50 * row) )
		
		-- 패널 사이즈 변경 후 콘트롤 위치 재정렬
		data._staticTitle:ComputePos()
		data._staticCapacity:ComputePos()
		-- data._checkSort:ComputePos()
		-- data._buttonSort:ComputePos()
		data._staticMoney:ComputePos()
		data._buttonMoney:ComputePos()
		data._iconWeight:ComputePos()
		data._staticWeight:ComputePos()
		data._weightInventory:ComputePos()
		data._weightEquipment:ComputePos()
		data._weightMoney:ComputePos()
	--}
	data._staticBG:SetShow( true )
	ServantInfo_Update()				-- 말 가방과 말 정보창을 열어놓은 상태에서 무게 정보가 갱신이 안되어서 업데이를 해준다.
end

function	servantInventory:clearActorKey()
	for	ii = 0, self._config.inventoryCount	do
		self._inventory[ii]._actorKeyRaw	= nil
	end
end

function	servantInventory:getInventoryCount()
	local	count	= 0
	for	ii = 0, self._config.inventoryCount	do
		local	inventory	= self._inventory[ii]
		if	( nil ~= inventory._actorKeyRaw )	then
			count	= count + 1
		end
	end
	return(count)
end
----------------------------------------------------------------------------
--	FromClient 이벤트
----------------------------------------------------------------------------
function	servantInventory:registMessageHandler()
	registerEvent("FromClient_ServantInventoryOpenWithInventory", 	"ServantInventoryOpenWithInventory"	)
	registerEvent("FromClient_ServantInventoryUpdate",				"ServantInventory_updateSlotData"	)
	registerEvent("EventServantEquipmentUpdate",					"ServantInventory_updateSlotData"			)
end

----------------------------------------------------------------------------
-- Control 이벤트
----------------------------------------------------------------------------
function	servantInventory:registEventHandler()
	self._buttonClose:addInputEvent(	"Mouse_LUp",	"ServantInventory_Close()"											)
	self._buttonQuestion:addInputEvent(	"Mouse_LUp",	"Panel_WebHelper_ShowToggle( \"PanelServantInventory\" )"			)	-- 물음표 좌클릭
	self._buttonQuestion:addInputEvent(	"Mouse_On",		"HelpMessageQuestion_Show( \"PanelServantInventory\", \"true\")"	)	-- 물음표 마우스오버
	self._buttonQuestion:addInputEvent(	"Mouse_Out",	"HelpMessageQuestion_Show( \"PanelServantInventory\", \"false\")"	)	-- 물음표 마우스아웃
end

----------------------------------------------------------------------------
-- Control 이벤트 함수
----------------------------------------------------------------------------
function	ServantInventory_SlotRClick( index, slotNo )
	if	ServantInventory_DropHandler( index, slotNo )	then
		return
	end
	
	local	self		= servantInventory
	local	type		= self._inventory[index]._type
	local	actorKeyRaw	= self._inventory[index]._actorKeyRaw
	
	local	vehicleActor	= getVehicleActor( actorKeyRaw )
	if	(nil == vehicleActor)	then
		return
	end
	
	FGlobal_PopupMoveItem_Init( CppEnums.ItemWhereType.eServantInventory, slotNo, type, actorKeyRaw, true )
end

----------------------------------------------------------------------------
-- Drag 관련 함수
----------------------------------------------------------------------------
function	ServantInventory_SlotDrag( index, slotNo )
	local	self			= servantInventory
	self._targetActorKeyRaw	= self._inventory[index]._actorKeyRaw
	
	local	vehicleWrapper	= getVehicleActor( self._targetActorKeyRaw )
	if	(nil == vehicleWrapper)	then
		return
	end
	
	local vehicle	= vehicleWrapper:get()
	local inventory	= vehicle:getInventory()
	
	if	(inventory:empty(slotNo))	then
		return
	end
	
	local itemWrapper = getServantInventoryItemBySlotNo( self._targetActorKeyRaw, slotNo )
	if	(nil == itemWrapper)	then
		return
	end
	
	DragManager:setDragInfo( Panel_Window_ServantInventory, CppEnums.ItemWhereType.eServantInventory, slotNo, "Icon/" .. itemWrapper:getStaticStatus():getIconPath(), ServantInventory_GroundClick, self._targetActorKeyRaw )
end

function	ServantInventory_GroundClick( whereType, slotNo )
	if false == Panel_Window_ServantInventory:GetShow() then
		return
	end
	local	self		= servantInventory
	local	itemWrapper = getServantInventoryItemBySlotNo( self._targetActorKeyRaw, slotNo )
	if	(nil == itemWrapper)	then
		return
	end
	
	itemCount	= itemWrapper:get():getCount_s64()
	itemName	= itemWrapper:getStaticStatus():getName()
	if( Defines.s64_const.s64_1 == itemCount ) then
		ServantInventory_GroundClick_Message( Defines.s64_const.s64_1, slotNo)
	else
		Panel_NumberPad_Show(  true, itemCount, slotNo, ServantInventory_GroundClick_Message) 
	end
end

function	ServantInventory_GroundClick_Message(s64_itemCount, slotNo)
	local	self			= servantInventory
	self._deleteSlotNo		= slotNo
	self._s64_deleteCount	= s64_itemCount

	local luaDeleteItemMsg	= PAGetStringParam2( Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_DELETEITEM_MSG", "itemName", itemName, "itemCount", tostring(itemCount) )
	local luaDelete			= PAGetString( Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_DELETE")
	
	local messageContent	= luaDeleteItemMsg
	local messageboxData	= { title = luaDelete, content = messageContent, functionYes = ServantInventory_Delete_Yes, functionNo = ServantInventory_Delete_No, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox( messageboxData )
end

function	ServantInventory_Delete_Yes()
	local	self	= servantInventory
	if	(nil == self._deleteSlotNo)	then
		return
	end
	
	local itemWrapper = getServantInventoryItemBySlotNo( self._targetActorKeyRaw, self._deleteSlotNo )
	if	(nil == itemWrapper)	then
		return
	end
	
	if	( itemWrapper:isCash() )	then
		PaymentPassword( ServantInventory_Delete_YesXXX )
		return
	end
	
	ServantInventory_Delete_YesXXX()
	
	--self._deleteSlotNo		= nil
	--self._s64_deleteCount	= Defines.s64_const.s64_0
end

function	ServantInventory_Delete_YesXXX()
	local	self	= servantInventory
	deleteItem( self._targetActorKeyRaw, CppEnums.ItemWhereType.eServantInventory, self._deleteSlotNo, self._s64_deleteCount )
end

function	ServantInventory_Delete_No()
	local	self			= servantInventory
	self._deleteSlotNo		= nil
	self._s64_deleteCount	= Defines.s64_const.s64_0
end

function	ServantInventory_DropHandler( index, toSlotNo )
	local	self		= servantInventory
	
	if nil == DragManager.dragStartPanel then
		return(false)
	end
	
	return( DragManager:itemDragMove( self._inventory[index]._type, self._inventory[index]._actorKeyRaw ) )
end

----------------------------------------------------------------------------
-- Client Call Function
----------------------------------------------------------------------------
function	ServantInventoryOpenWithInventory( actorKeyRaw )		
	local	self	= servantInventory
	self:clearActorKey()
	-- Cannon 이면 Cannon의 인벤토리만 보여주고,
	-- 내 소유물 이라면 말, 배, 펫(예정)의 거리를 체크해서 주위에 있는 탈것의 인벤토리를 다 보여준다.
	
	-- Servant Inventory
	--{
		local	vehicleActorWrapper	= getVehicleActor(actorKeyRaw)
		if	(nil == vehicleActorWrapper)	then
			return
		end
		
		local	vehicleActor= vehicleActorWrapper:get()
		if( nil == vehicleActor )	then
			return
		end

		if	( not vehicleActor:isCannon() )	then
			ServantInventory_OpenAll()
		else
			self._inventory[0]._actorKeyRaw	= actorKeyRaw
			self._inventory[0]._type		= CppEnums.MoveItemToType.Type_Vehicle
			ServantInventory_Open()
		end
				
		Panel_Window_ServantInventory:SetHorizonCenter()
		Panel_Window_ServantInventory:SetSpanSize( 200, Panel_Window_ServantInventory:GetSpanSize().y )
	--}

	-- Player Inventory
	--{
		Inventory_SetFunctor(nil, FGlobal_PopupMoveItem_InitByInventory, ServantInventory_Close, nil)
		--Inventory_SetFunctor( nil , nil, nil, nil)
		InventoryWindow_Show()
	--}
end

function	ServantInventory_updateSlotData()
	local	self	= servantInventory
	self:update()
end

----------------------------------------------------------------------------
-- Util Function
----------------------------------------------------------------------------
function	ServantInventory_GetActorKeyRawFromIndex( index )
	local	self	= servantInventory
	return( self._inventory[index]._actorKeyRaw )
end

function	ServantInventory_getInventoryFromType( index )
	local	self	= servantInventory

	return(self._inventory[index])
end

----------------------------------------------------------------------------
--	Window Open / Close
----------------------------------------------------------------------------
function	ServantInventory_OpenAll()
	local	self			= servantInventory
	
	local	index	= 0
	for	ii = 0, self._config.inventoryCount	do
		if	servant_checkDistance(ii)	then -- 거리가 멀어도 탑승물 가방을 보여줄 것이기 때문에 주석 처리.
			local	vehicle	= getTemporaryInformationWrapper():getUnsealVehicle( ii )
			if	(nil ~= vehicle)	then
				if	( 0 < vehicle:getInventory():size() )	then
					self._inventory[ii]._actorKeyRaw	= vehicle:getActorKeyRaw()
					self._inventory[ii]._type			= ii
					--self._inventory[ii+1]._actorKeyRaw	= vehicle:getActorKeyRaw()
					index	= index + 1
				end
			end
		end
	end

	if	( 0 < index )	then
		ServantInventory_Open()
	end
	-- 탑승물에 타고 있지 않아도 탑승물이 가까이 있으면 탑승물 인벤토리가 열리는데 PC인벤토리의 아이템을 탑승물 인벤으로 옮기기 위해서 존재.
	if Panel_Window_ServantInventory:GetShow() then
		Inventory_SetFunctor(nil, FGlobal_PopupMoveItem_InitByInventory, nil, nil)
	end
end

function	ServantInventory_Open()
	Inventory_SetIgnoreMoneyButton( true )		-- 탑승물 인벤이 뜨면 인벤에 돈 버튼을 ignore 시킨다!
	if	(Panel_Window_ServantInventory:GetShow())	then
		return
	end

	if GetUIMode() == Defines.UIMode.eUIMode_NpcDialog then
		Panel_Window_ServantInventory:SetPosX( (getScreenSizeY()/2) - (Panel_Window_Warehouse:GetSizeY()/2) )
	end

	local	self= servantInventory
	self:update()
	


	Panel_Window_ServantInventory:SetShow( true )
end

function	ServantInventory_Close()
	Inventory_SetIgnoreMoneyButton( false )		-- 해지 합니다
	if	(not Panel_Window_ServantInventory:GetShow())	then
		return
	end
	
	local	self	= servantInventory
	self:clearActorKey()
	if Panel_Tooltip_Item:GetShow() then
		Panel_Tooltip_Item_hideTooltip()
	end
	Panel_Window_ServantInventory:SetShow( false )
	
	if not isFlushedUI() and not Panel_Window_Warehouse:GetShow() then
		Inventory_SetFunctor( nil , nil, nil, nil )
	end
end

----------------------------------------------------------------------------
--	Init
----------------------------------------------------------------------------
servantInventory:init()
servantInventory:registEventHandler()
servantInventory:registMessageHandler()

--ServantInventory_Open()
