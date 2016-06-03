-------------------------- Panel 설정 -------------------------
Panel_ClearVested:SetShow( false, false )
Panel_ClearVested:ActiveMouseEventEffect( true )

local UI_TM	= CppEnums.TextMode

local ClearVestedWindow =
{
	_buttonApply		= UI.getChildControl( Panel_ClearVested, "Button_Apply" ),
	_buttonCancel		= UI.getChildControl( Panel_ClearVested, "Button_Cancel" ),
	
	_slotVestedItem		=
	{
		icon			= UI.getChildControl( Panel_ClearVested, "Static_Slot_0" ),
		isEmpty			= true
	},
	
	_slotConfig	=
	{
		createIcon 		= false,
		createBorder 	= true,
		createCount 	= true,
		createCash		= true,
	},
	
	_toWhereType		= nil,	-- 귀속을 해제할 아이템의 whereType
	_toSlotNo			= nil,	-- 귀속을 해제할 아이템의 슬롯 번호
	_fromWhereType		= nil,	-- 귀속 해제 아이템의 whereType
	_fromSlotNo			= nil	-- 귀속 해제 아이템의 슬롯 번호
}

function ClearVestedWindow:initialize()
	SlotItem.new( self._slotVestedItem, 'Slot_0', 0, Panel_ClearVested, self._slotConfig )
	self._slotVestedItem:createChild()
	self._slotVestedItem.isEmpty = true
	
	self._buttonApply:addInputEvent( "Mouse_LUp", "HandleClicked_ApplyButton()" )
	self._buttonCancel:addInputEvent( "Mouse_LUp", "HandleClicked_CancelButton()" )
	
	self._slotVestedItem.icon:addInputEvent( "Mouse_On", "HandleOn_SlotVestedItem()" )
	self._slotVestedItem.icon:addInputEvent( "Mouse_Out", "HandleOut_SlotVestedItem()" )
end

-- 귀속 해제
function HandleClicked_ApplyButton()
	if false == ClearVestedWindow._slotVestedItem.isEmpty then
		ToClient_ClearVestedRequest(ClearVestedWindow._toWhereType, ClearVestedWindow._toSlotNo, ClearVestedWindow._fromWhereType, ClearVestedWindow._fromSlotNo)
	end
end

function HandleClicked_CancelButton()
	FromClient_HideWindow()
end

function HandleOn_SlotVestedItem()
	if nil == ClearVestedWindow._slotVestedItem then
	else
		local itemWrapper = getInventoryItemByType( ClearVestedWindow._toWhereType, ClearVestedWindow._toSlotNo )
		if nil ~= itemWrapper then
			Panel_Tooltip_Item_Show( itemWrapper:getStaticStatus(), ClearVestedWindow._slotVestedItem.icon, true, false )
		end
	end
end

function HandleOut_SlotVestedItem()
	if nil == ClearVestedWindow._slotVestedItem then
	else
		Panel_Tooltip_Item_hideTooltip()
	end
end

function FromClient_ShowWindow( fromWhereType, fromSlotNo )
	Inventory_SetFunctor( InvenFiler_VestedItem, VestedItem_InteractionFromInventory, nil, nil )
	ClearVestedWindow._fromWhereType = fromWhereType
	ClearVestedWindow._fromSlotNo = fromSlotNo
	Panel_ClearVested:SetShow( true )
end

function FromClient_HideWindow()
	Inventory_SetFunctor( nil, nil, nil, nil )
	ClearVestedWindow._slotVestedItem.isEmpty = true
	ClearVestedWindow._slotVestedItem:clearItem()
	Panel_ClearVested:SetShow( false )
end

function InvenFiler_VestedItem( slotNo, itemWrapper )
	if nil == itemWrapper then
		return true
	end
	
	-- 귀속 가능한 아이템이면 false, 불가능하면 true 리턴
	return (false == itemWrapper:checkToClearVested())
end

function VestedItem_InteractionFromInventory( slotNo, itemWrapper, stackCount, inventoryType )
	if itemWrapper:checkToClearVested() then
		ClearVestedWindow._toSlotNo = slotNo
		ClearVestedWindow._toWhereType = inventoryType
		ClearVestedWindow._slotVestedItem.isEmpty = false
		ClearVestedWindow._slotVestedItem:setItem( itemWrapper )
	end
end

ClearVestedWindow:initialize()

registerEvent("FromClient_ShowWindow", "FromClient_ShowWindow")
registerEvent("FromClient_HideWindow", "FromClient_HideWindow")