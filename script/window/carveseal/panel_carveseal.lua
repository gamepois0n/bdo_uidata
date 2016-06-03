Panel_CarveSeal:SetShow( false, false )
Panel_CarveSeal:ActiveMouseEventEffect( true )

local SealWindow = {
	_buttonApply		= UI.getChildControl( Panel_CarveSeal, "Button_Apply" ),
	_buttonCancel		= UI.getChildControl( Panel_CarveSeal, "Button_Close" ),
	
	_slotTargetItem = 
	{
		icon	= UI.getChildControl( Panel_CarveSeal, "Static_Slot_0" ),
		empty	= true
	},
	
	_slotConfig	=
	{
		createIcon 		= false,
		createBorder 	= true,
		createCount 	= true,
		createCash		= true
	},
	
	_inventoryTypeSealItem		= nil,
	_slotNoSealItem				= nil,	-- 각인 아이템 슬롯 번호
	_inventoryTypeTargetItem	= nil,
	_slotNoTargetItem			= nil	-- 각인을 적용할 아이템 슬롯 번호
}

local SealWindowHelpMessage = {}

function SealWindow:initialize()
	SlotItem.new( SealWindow._slotTargetItem, 'Slot_0', 0, Panel_CarveSeal, self._slotConfig )
	self._slotTargetItem:createChild()
	self._slotTargetItem.empty = true
	
	self._buttonApply:addInputEvent( "Mouse_LUp", "HandleClickedApplyButton()" )
	self._buttonCancel:addInputEvent( "Mouse_LUp", "FromClient_SealWindowHide()" )
	
	self._slotTargetItem.icon:addInputEvent( "Mouse_On", "HandleOnTargetItem()" )
	self._slotTargetItem.icon:addInputEvent( "Mouse_Out", "HandleOutTargetItem()" )
end

function HandleOnTargetItem()
	if nil == SealWindow._slotNoTargetItem then
		-- 여기에 도움말 출력...
	else
		local itemWrapper = getInventoryItemByType( SealWindow._inventoryTypeTargetItem, SealWindow._slotNoTargetItem )
		if	( nil ~= itemWrapper )	then
			Panel_Tooltip_Item_Show( itemWrapper, SealWindow._slotTargetItem.icon, false, true )
		end
	end
end

function HandleOutTargetItem()
	if nil == SealWindow._slotNoTargetItem then
		-- 여기에 도움말 리셋...
	else
		Panel_Tooltip_Item_hideTooltip()
	end
end

function FromClient_SealWindowShow( inventoryType, slotNoSealItem )
	Inventory_SetFunctor( Seal_InvenFiler, HandleSeal_InteractionFromInventory, nil, nil )
	SealWindow._inventoryTypeSealItem	= inventoryType
	SealWindow._slotNoSealItem			= slotNoSealItem
	Panel_CarveSeal:SetShow( true )
end

function FromClient_SealWindowHide()
	Inventory_SetFunctor( nil, nil, nil, nil )
	SealWindow._slotTargetItem.empty = true
	SealWindow._slotTargetItem:clearItem()
	Panel_CarveSeal:SetShow( false )
end

-- 각인 시작
function HandleClickedApplyButton()	
	if false == SealWindow._slotTargetItem.empty then
		ToClient_CarveSealRequest( SealWindow._inventoryTypeSealItem, SealWindow._slotNoSealItem, SealWindow._inventoryTargetItem, SealWindow._slotNoTargetItem, true )
	end
end

function Seal_InvenFiler( slotNo, itemWrapper )
	if nil == itemWrapper then
		return true
	end
	
	local staticStatus = itemWrapper:getStaticStatus()
	if nil == staticStatus then
		return true
	end
	
	if itemWrapper:isSealed() then
		return true
	end
	
	-- 각인이 가능한 아이템이면 false, 각인이 불가능한 아이템이면 true
	return (false == staticStatus:isPossibleCarveSeal())
end

function HandleSeal_InteractionFromInventory( slotNo, itemWrapper, count, inventoryType )
	local staticStatus = itemWrapper:getStaticStatus()
	if nil == staticStatus then
		return
	end
	
	-- 한번 더 체크하자(각인 가능한템이 올라가야됨)
	if staticStatus:isPossibleCarveSeal() then
		SealWindow._slotTargetItem.empty	= false
		SealWindow._inventoryTypeTargetItem	= inventoryType
		SealWindow._slotNoTargetItem		= slotNo
		SealWindow._slotTargetItem:setItem( itemWrapper )
	end
end

SealWindow:initialize()

registerEvent("FromClient_CarveSeal_Show", "FromClient_SealWindowShow")
registerEvent("FromClinet_CarveSeal_Hide", "FromClient_SealWindowHide")