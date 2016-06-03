Panel_Popup_MoveItem:SetShow(false, false)
Panel_Popup_MoveItem:setMaskingChild(true)
Panel_Popup_MoveItem:ActiveMouseEventEffect(true)
Panel_Popup_MoveItem:SetDragEnable( true )
Panel_Popup_MoveItem:setGlassBackground(true)

Panel_Popup_MoveItem:RegisterShowEventFunc( true,	'Popup_MoveItemShowAni()' )
Panel_Popup_MoveItem:RegisterShowEventFunc( false,	'Popup_MoveItemHideAni()' )

local UI_ANI_ADV= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PSFT	= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color 	= Defines.Color

local	popupMoveItem	=
{
	_config	=
	{
		constSlotStartX	= 6,
		constSlotStartY	= 5,
		constSlotGapY	= 35,
	},
	
	_staticBG		= UI.getChildControl(Panel_Popup_MoveItem,	"Static_FunctionBG"),
	
	_whereType		= nil,									-- Player 인벤토리만 사용 ( 노멀/유료 )
	_slotNo			= nil,	
	_s64_count		= Defines.s64_const.s64_0,
	_fromWindowType	= CppEnums.MoveItemToType.Type_Count,
	_fromActorKeyRaw= nil,
	_toActorKeyRaw	= nil,
	_slots			= Array.new()
}

function	Popup_MoveItemShowAni()
	UIAni.fadeInSCR_Right(Panel_Popup_MoveItem)
	--audioPostEvent_SystemUi(01,00)
end

function	Popup_MoveItemHideAni()
	Panel_Popup_MoveItem:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo1 = Panel_Popup_MoveItem:addColorAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo1:SetStartIntensity( 3.0 )
	aniInfo1:SetEndIntensity( 1.0 )
	aniInfo1.IsChangeChild = true
	aniInfo1:SetHideAtEnd(true)
	aniInfo1:SetDisableWhileAni(true)
	--audioPostEvent_SystemUi(01,01)
end

----------------------------------------------------------------------
--	popupMoveItem
----------------------------------------------------------------------
function	popupMoveItem:init()
	UI.ASSERT( nil ~= self._staticBG		and 'number' ~= type(self._staticBG),	"Static_FunctionBG" )

	for	ii=0, CppEnums.MoveItemToType.Type_Count-1	do
		local	slot	= {}
		slot.button	= UI.createAndCopyBasePropertyControl( Panel_Popup_MoveItem, "Button_Function",	Panel_Popup_MoveItem,	"PopupMoveItem_Button_"				.. ii )

		if ( (ii == 0) or (ii == 1) or (ii == 2) ) then							-- 말, 마차
			slot.button:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( slot.button, 1, 397, 155, 429 )
			slot.button:getBaseTexture():setUV(  x1, y1, x2, y2  )
			slot.button:setRenderTexture(slot.button:getBaseTexture())

			slot.button:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( slot.button, 156, 397, 310, 429 )
			slot.button:getOnTexture():setUV(  x1, y1, x2, y2  )

			slot.button:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( slot.button, 311, 397, 465, 429 )
			slot.button:getClickTexture():setUV(  x1, y1, x2, y2  )
		elseif ( ii == 3 ) then								-- 인벤토리
			slot.button:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( slot.button, 1, 430, 155, 462 )
			slot.button:getBaseTexture():setUV(  x1, y1, x2, y2  )
			slot.button:setRenderTexture(slot.button:getBaseTexture())

			slot.button:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( slot.button, 156, 430, 310, 462 )
			slot.button:getOnTexture():setUV(  x1, y1, x2, y2  )

			slot.button:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( slot.button, 311, 430, 465, 462 )
			slot.button:getClickTexture():setUV(  x1, y1, x2, y2  )
				
		elseif ( ii == 4 ) then							-- 창고
			slot.button:ChangeTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( slot.button, 1, 133, 155, 165 )
			slot.button:getBaseTexture():setUV(  x1, y1, x2, y2  )
			slot.button:setRenderTexture(slot.button:getBaseTexture())

			slot.button:ChangeOnTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( slot.button, 156, 133, 310, 165 )
			slot.button:getOnTexture():setUV(  x1, y1, x2, y2  )

			slot.button:ChangeClickTextureInfoName ( "New_UI_Common_forLua/Widget/Dialogue/Dialogue_Btn_01.dds" )
			local x1, y1, x2, y2 = setTextureUV_Func( slot.button, 311, 133, 465, 165 )
			slot.button:getClickTexture():setUV(  x1, y1, x2, y2  )
		end

		slot.button:SetPosX( self._config.constSlotStartX )
		slot.button:SetPosY( self._config.constSlotStartY + self._config.constSlotGapY * ii )
		slot.button:SetShow(true)		
		slot.button:addInputEvent( "Mouse_LUp", "HandleClickedMoveItemButton(" .. ii .. ")"	)
		slot._toType		= nil
		slot._toActorKeyRaw	= nil
		
		self._slots[ii]		= slot
	end
	self._staticBG:SetShow(true)
end

function	popupMoveItem:update()

	for	ii=0, CppEnums.MoveItemToType.Type_Count-1	do
		local	slot	= self._slots[ii]
		slot.button:SetShow(false)
	end
	
	local	count	= 0
	local	index	= 0
	for	ii=0, CppEnums.MoveItemToType.Type_Count-1	do
		if	(ii ~= self._fromWindowType)then
			local	slot		= self._slots[ii]
			slot._toType		= nil
			slot._toActorKeyRaw	= nil

			if	( PopupMoveItem_IsButtonShow(slot, ii) )	then
				slot.button:SetPosX(self._config.constSlotStartX)
				slot.button:SetPosY(self._config.constSlotStartY + self._config.constSlotGapY * count)
				if 0 == ii then
					local	temporaryWrapper= getTemporaryInformationWrapper()
					local	vehicleWrapper	= temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Vehicle )
					if nil ~= temporaryWrapper and nil ~= vehicleWrapper then
						slot.button:SetText( vehicleWrapper:getName() )
					end
				elseif 1 == ii then
					local	temporaryWrapper= getTemporaryInformationWrapper()
					local	vehicleWrapper	= temporaryWrapper:getUnsealVehicle( CppEnums.ServantType.Type_Ship )
					if nil ~= temporaryWrapper and nil ~= vehicleWrapper then
						slot.button:SetText( vehicleWrapper:getName() )
					end
				elseif 2 == ii then
					slot.button:SetText( PAGetString( Defines.StringSheet_GAME,  "LUA_MOVEITEM_TO_BUTTON_TOPET") )
				else
					slot.button:SetText( PAGetString( Defines.StringSheet_GAME,  "LUA_MOVEITEM_TO_BUTTON" .. tostring(ii)) )
				end
				slot.button:SetShow(true)
				count		= count + 1
				index		= ii
			end
		end
	end
	-- 창고이면 운송창에 옮길 수는 있어야 한다...
	if( 0 == count )	then
		if	( CppEnums.MoveItemToType.Type_Warehouse == self._fromWindowType )	then
			HandleClickedMoveItemButtonXXX( nil, nil )
		end
		return(false)
	elseif(	1 == count )	then
		HandleClickedMoveItemButton( index )
		return(false)
	end
	
	return(true)
end

function	popupMoveItem:registEventHandler()

end

function	popupMoveItem:registMessageHandler()

end

----------------------------------------------------------------------
--	Open Function
----------------------------------------------------------------------
--	SetFunctor
function	FGlobal_PopupMoveItem_InitByInventory( slotNo, itemWrapper, s64_count, inventoryType )
	FGlobal_PopupMoveItem_Init( inventoryType, slotNo, CppEnums.MoveItemToType.Type_Player, getSelfPlayer():getActorKey(), true )
end

function	FGlobal_PopupMoveItem_Init( whereType, slotNo, fromWindowType, fromActorKeyRaw, isOpen )
	local	self		= popupMoveItem
	local	itemWrapper	= getItemFromTypeAndSlot( fromWindowType, fromActorKeyRaw, whereType, slotNo )
	if	( nil == itemWrapper )	then
		return
	end
	
	self._whereType			= whereType
	self._slotNo			= slotNo
	self._fromWindowType	= fromWindowType
	self._fromActorKeyRaw	= fromActorKeyRaw
	self._s64_count			= itemWrapper:get():getCount_s64()
	
	if	(not isOpen)	then
		return
	end

	local	isShow		= self:update()
	local	mousePosX	= getMousePosX()
	local	scrX		= getScreenSizeX()
	
	if	( isShow )	then
		if ( scrX < mousePosX + Panel_Popup_MoveItem:GetSizeX() ) then
			Panel_Popup_MoveItem:SetPosX( scrX - Panel_Popup_MoveItem:GetSizeX() - 5 )
		else
			Panel_Popup_MoveItem:SetPosX( getMousePosX() )
		end
		Panel_Popup_MoveItem:SetPosY( getMousePosY() + 5 )
		PopupMoveItem_Open()
	end
	-- Sound
	--{
		-- ♬ 창고 > 인벤으로 아이템 옮길 때 사운드
		audioPostEvent_SystemUi(01,00)
		
		local	itemWrapper	= nil
		if	( CppEnums.MoveItemToType.Type_Player		 == fromWindowType )	then
			itemWrapper = getInventoryItemByType( whereType, slotNo )
		elseif	( CppEnums.MoveItemToType.Type_Warehouse == fromWindowType )	then
			itemWrapper = Warehouse_GetItem( slotNo )
		elseif	( CppEnums.MoveItemToType.Type_Vehicle	== fromWindowType )
			or	( CppEnums.MoveItemToType.Type_Ship		== fromWindowType )	then
			itemWrapper	= getServantInventoryItemBySlotNo( self._fromActorKeyRaw, slotNo )
		end
		if	( nil ~= itemWrapper )	then
			Item_Move_Sound( itemWrapper )
		end
	--}
end


----------------------------------------------------------------------
--	Control Event Function
----------------------------------------------------------------------
function	HandleClickedMoveItemButton( index )
	--UI.debugMessage( "HandleClickedMoveItemButton( " ..  index .. " )" )
	
	local	self	= popupMoveItem
	if	(CppEnums.MoveItemToType.Type_Count == self._fromWindowType)	then
		return
	end
	
	if	(nil == self._slots[index])	then
		return
	end
	
	
	local	toWhereType		= self._slots[index]._toType
	local	toActorKeyRaw	= self._slots[index]._toActorKeyRaw
	
	HandleClickedMoveItemButtonXXX( toWhereType, toActorKeyRaw )
end

function	HandleClickedMoveItemButtonXXX( toWhereType, toActorKeyRaw )
	local	self			= popupMoveItem
	local	fromWhereType	= self._fromWindowType
	local	fromActorKeyRaw	= self._fromActorKeyRaw
	
	--UI.debugMessage( 'From : ' .. tostring(fromWhereType)	.. " / ActorKey : " .. tostring(fromActorKeyRaw))
	--UI.debugMessage( 'To   : ' .. tostring(toWhereType)		.. " / ActorKey : " .. tostring(toActorKeyRaw)	)
	
	if	(CppEnums.MoveItemToType.Type_Player			== fromWhereType)then
		if	(CppEnums.MoveItemToType.Type_Vehicle		== toWhereType)						-- Player -> Vehicle
		 or	(CppEnums.MoveItemToType.Type_Ship			== toWhereType)						-- Player -> Vehicle
		 or	(CppEnums.MoveItemToType.Type_Pet			== toWhereType)	then				-- Player -> Vehicle
		 
			PopupMoveItem_MoveInventoryItemFromActorToActor( toActorKeyRaw, self._s64_count, self._whereType, self._slotNo )
			
		elseif(CppEnums.MoveItemToType.Type_Warehouse	== toWhereType )			then	-- Player -> Warehouse
		
			Warehouse_PushFromInventoryItem( self._s64_count, self._whereType, self._slotNo, fromActorKeyRaw )
			
		end
	elseif	(CppEnums.MoveItemToType.Type_Vehicle		== fromWhereType)
	 or		(CppEnums.MoveItemToType.Type_Ship			== fromWhereType)
	 or		(CppEnums.MoveItemToType.Type_Pet			== fromWhereType)	then
		if	(CppEnums.MoveItemToType.Type_Vehicle		== toWhereType)
			or	(CppEnums.MoveItemToType.Type_Ship		== toWhereType)						-- Vehicle -> Vehicle
			or	(CppEnums.MoveItemToType.Type_Pet		== toWhereType)						-- Vehicle -> Vehicle
			or	(CppEnums.MoveItemToType.Type_Player	== toWhereType)	then				-- Vehicle -> Player
			
			PopupMoveItem_MoveInventoryItemFromActorToActor( toActorKeyRaw, self._s64_count, self._whereType, self._slotNo )
			
		elseif	(CppEnums.MoveItemToType.Type_Warehouse	== toWhereType)	then				-- Vehicle -> Warehouse
		
			Warehouse_PushFromInventoryItem( self._s64_count, self._whereType, self._slotNo, fromActorKeyRaw )
			
		end
	elseif	(CppEnums.MoveItemToType.Type_Warehouse		== fromWhereType)	then
		Warehouse_PopToSomewhere( self._s64_count, self._slotNo, toActorKeyRaw )
	else
		UI.ASSERT( false, "아이템 이동 타입이 정상적이지 않습니다!!!")
	end
	
	PopupMoveItem_Close()
	
	-- 사운드
	--{
		-- ♬ 아이템이 옮겨진 후 나는 사운드
		audioPostEvent_SystemUi(01,01)
	--}
end

function	PopupMoveItem_MoveInventoryItemFromActorToActor( toActorKeyRaw, s64_count, whereType, slotNo )
	local	self		= popupMoveItem
	self._toActorKeyRaw	= toActorKeyRaw
	
	Panel_NumberPad_Show( true, s64_count, slotNo, PopupMoveItem_MoveInventoryItemFromActorToActorXXX, nil, whereType ) 
end

function	PopupMoveItem_MoveInventoryItemFromActorToActorXXX( s64_count, slotNo, whereType )
	local	self	= popupMoveItem
	moveInventoryItemFromActorToActor( self._fromActorKeyRaw, self._toActorKeyRaw, whereType, slotNo, s64_count )
end

----------------------------------------------------------------------
--	Util Function
----------------------------------------------------------------------
function	getItemFromTypeAndSlot( type, actorKeyRaw, whereType, slotNo )
	local	itemWrapper	= nil
	if		(CppEnums.MoveItemToType.Type_Player	== type)	then
		itemWrapper	= getInventoryItemByType(whereType, slotNo)
		if	( nil == itemWrapper ) then
			return(false)
		end
	elseif	(CppEnums.MoveItemToType.Type_Vehicle	== type )	
		or	(CppEnums.MoveItemToType.Type_Ship		== type )	then
		itemWrapper	= getServantInventoryItemBySlotNo( actorKeyRaw, slotNo )
	elseif	(CppEnums.MoveItemToType.Type_Warehouse	== type )	then
		itemWrapper	= Warehouse_GetItem( slotNo )
	end
	
	return(itemWrapper)
end

----------------------------------------------------------------------
--	Button Check Active
----------------------------------------------------------------------
function	PopupMoveItem_IsButtonShow( slot, type )
	local	self	= popupMoveItem
	if	(CppEnums.MoveItemToType.Type_Vehicle	== type)
	 or	(CppEnums.MoveItemToType.Type_Ship	 	== type)
	 or	(CppEnums.MoveItemToType.Type_Pet	 	== type) then
		if	( not Panel_Window_ServantInventory:GetShow() )	then
			return(false)
		end
		
		local	inventory	= ServantInventory_getInventoryFromType( type )
		if	( nil == inventory ) then
			return(false)
		end
		
		if	( nil == inventory._actorKeyRaw ) then
			return(false)
		end
		
		if	( getMoneySlotNo() == self._slotNo )	then
			return(false)
		end
		
		slot._toActorKeyRaw	= inventory._actorKeyRaw
		
	elseif	(CppEnums.MoveItemToType.Type_Player	== type )	then
		if	( not Panel_Window_Inventory:GetShow() )	then
			return(false)
		end
		
		slot._toActorKeyRaw	= getSelfPlayer():getActorKey()
		
	elseif	(CppEnums.MoveItemToType.Type_Warehouse == type )	then
		if(	not FGlobal_Warehouse_IsMoveItem() )	then
			return(false)
		end
		
		if	( not Panel_Window_Warehouse:GetShow() )	then
			return(false)
		end
	end
	
	slot._toType		= type
	
	return(true)
end

----------------------------------------------------------------------
--	Item Sount
----------------------------------------------------------------------
function	Item_Move_Sound( itemWrapper )
	local itemSSW		= itemWrapper:getStaticStatus()
	local itemType		= itemSSW:getItemType()
	local isTradeItem	= itemSSW:isTradeAble()

	--드래그 시 아이템 타입에 따라서 사운드 달리함
	if 1 == itemType then
		-- ♬ 장비 아이템 사운드~
	elseif 2 == itemType then
		-- ♬ 소모성 아이템 사운드~
	elseif 3 == itemType then
		-- ♬ 점유지 도구~
	elseif 4 == itemType then
		-- ♬ 설치가구~
	elseif 5 == itemType then
		-- ♬ 소켓아이템(보석, 블랙스톤)~
	elseif 6 == itemType then
		-- ♬ 포탄~
	elseif 8 == itemType then
		-- ♬ 제작재료
	elseif 10 == itemType then
		-- ♬ 특수상품
	elseif isTradeItem == true then
		-- ♬ 무역품
	else
		-- ♬ 일반, 디폴트
	end
end
----------------------------------------------------------------------
--	Open/Close Function
----------------------------------------------------------------------
function	PopupMoveItem_Open()
	if	Panel_Popup_MoveItem:GetShow()	then
		return
	end
	
	Panel_Popup_MoveItem:SetShow(true)
end

function	PopupMoveItem_Close()
	if	not Panel_Popup_MoveItem:GetShow()	then
		return
	end
	
	Panel_Popup_MoveItem:SetShow(false)
end
----------------------------------------------------------------------
--	초기화
----------------------------------------------------------------------

popupMoveItem:init()
popupMoveItem:registEventHandler()
popupMoveItem:registMessageHandler()