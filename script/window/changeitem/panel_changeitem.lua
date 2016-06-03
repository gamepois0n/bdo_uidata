Panel_ChangeItem:SetShow( false )
Panel_ChangeItem:RegisterShowEventFunc( true, 'Panel_ChangeItem_ShowAni()' )
Panel_ChangeItem:RegisterShowEventFunc( false, 'Panel_ChangeItem_HideAni()' )

local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE

local title			= UI.getChildControl( Panel_ChangeItem, "StaticText_Title")
local btn_CloseIcon	= UI.getChildControl( Panel_ChangeItem, "Button_CloseIcon")
local btn_Close		= UI.getChildControl( Panel_ChangeItem, "Button_Close")
local btn_Apply		= UI.getChildControl( Panel_ChangeItem, "Button_Apply")
local runEffect		= UI.getChildControl( Panel_ChangeItem, "Static_BackEffect")
local equipIcon		= UI.getChildControl( Panel_ChangeItem, "equipIcon_1")
local avatarIcon	= UI.getChildControl( Panel_ChangeItem, "equipIcon_2")

local 	_buttonQuestion	= UI.getChildControl( Panel_ChangeItem, "Button_Question" )							-- 물음표 버튼
	_buttonQuestion:	addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"ClothExchange\" )" )			-- 물음표 좌클릭
	_buttonQuestion:	addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"ClothExchange\", \"true\")" )	-- 물음표 마우스오버
	_buttonQuestion:	addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"ClothExchange\", \"false\")" )	-- 물음표 마우스아웃

local equipSlot		= {}
local avatarSlot	= {}

local selectedItemSlotNo	= nil
local selectedItemWhere		= nil
local elapsTime				= 0
local doChange				= false
-- local resultComplete		= false
local resultItemKey			= 0
local isChangeDoing			= false

local slotConfig = {	-- 일단 아이콘, 테두리, 카운트(숫자) 만 적용한다!
	createIcon		= true,
	createBorder	= true,
	createCount		= true,
	createCash		= false
}


local initiallize = function()
	btn_Apply		:addInputEvent("Mouse_LUp", "ItemChange_ApplyChangeItem()")
	btn_Close		:addInputEvent("Mouse_LUp", "ItemChange_Close()")
	btn_CloseIcon	:addInputEvent("Mouse_LUp", "ItemChange_Close()")

	SlotItem.new( equipSlot, "ChangeItem_equipSlot", 0, equipIcon, slotConfig )
	equipSlot:createChild()
	equipSlot.icon:SetPosX(0)
	equipSlot.icon:SetPosY(0)
	equipSlot.icon:addInputEvent( "Mouse_On",	"ItemChange_IconOver( true, " .. 0 .. " )" )
	equipSlot.icon:addInputEvent( "Mouse_Out",	"ItemChange_IconOver( false, " .. 0 .. " )" )

	SlotItem.new( avatarSlot, "ChangeItem_avatarSlot", 0, avatarIcon, slotConfig )
	avatarSlot:createChild()
	avatarSlot.icon:SetPosX(0)
	avatarSlot.icon:SetPosY(0)
	avatarSlot.icon:addInputEvent( "Mouse_On",	"ItemChange_IconOver( true, " .. 1 .. " )" )
	avatarSlot.icon:addInputEvent( "Mouse_Out",	"ItemChange_IconOver( false, " .. 1 .. " )" )

	runEffect:SetShow( false )
	
	btn_Apply:SetShow( true )
	btn_Close:SetShow( false )
end
initiallize()

function Panel_ChangeItem_ShowAni()
	UIAni.fadeInSCR_Down( Panel_ChangeItem )
	
	local aniInfo1 = Panel_ChangeItem:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.1)
	aniInfo1.AxisX = Panel_ChangeItem:GetSizeX() / 2
	aniInfo1.AxisY = Panel_ChangeItem:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_ChangeItem:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.1)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_ChangeItem:GetSizeX() / 2
	aniInfo2.AxisY = Panel_ChangeItem:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function Panel_ChangeItem_HideAni()
	Panel_ChangeItem:SetAlpha( 1 )
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_ChangeItem, 0.0, 0.1 )
	aniInfo:SetHideAtEnd(true)
end

function FromClient_ShowItemChange()	-- 아이템을 사용해 이벤트가 왔다. 열린다.
	selectedItemSlotNo	= nil
	selectedItemWhere	= nil
	elapsTime			= 0
	doChange			= false
	-- resultComplete		= false
	resultItemKey		= 0

	btn_Apply:SetShow( true )
	btn_Close:SetShow( false )
	runEffect:SetShow( false )

	btn_Apply:SetMonoTone( true )
	btn_Apply:SetEnable( false )
	btn_Apply:SetIgnore( true )

	avatarSlot.icon:EraseAllEffect()

	Panel_ChangeItem:SetShow( true, true )
	Inventory_SetFunctor( ItemChange_SetFilter, ItemChange_Rclick, nil, nil )	-- 업데이트는 자동으로 된다.
	Inventory_SetShow( true )
end

function ItemChange_SetFilter( slotNo, itemWrapper, currentWhereType )
	local itemKey = itemWrapper:get():getKey()
	local isUseableItem = getItemChange( itemKey )

	if nil == isUseableItem then
		return true
	else
		return false
	end
end

function ItemChange_Rclick( slotNo, itemWrapper, count_s64, inventoryType )
	selectedItemSlotNo	= slotNo
	selectedItemWhere	= inventoryType
	elapsTime = 0

	equipSlot:clearItem()
	equipSlot:setItem( itemWrapper )

	btn_Apply:SetMonoTone( false )
	btn_Apply:SetEnable( true )
	btn_Apply:SetIgnore( false )

	local itemKey	= itemWrapper:get():getKey()
	local itemSSW	= getItemChange( itemKey )
	resultItemKey	= itemSSW:get()._key

	avatarSlot:clearItem()
	avatarSlot:setItemByStaticStatus( itemSSW, 1, nil, nil, true )
	avatarSlot.icon:SetMonoTone( true )
end

function ItemChange_ApplyChangeItem()
	if nil == selectedItemWhere or nil == selectedItemSlotNo then
		Proc_ShowMessage_Ack("아이템을 선택해야 합니다.")
		return
	end
	elapsTime	= 0
	doChange	= true
	isChangeDoing = true

	audioPostEvent_SystemUi(13,15)
	runEffect:SetShow( true )

	-- 여러번 누르지 못하도록 막는다.
	btn_Apply:SetMonoTone( true )
	btn_Apply:SetEnable( false )
	btn_Apply:SetIgnore( true )
	-- 실제 변환은 프레임 체크 함수에서 한다.
end

function FromClient_ItemChange( itemSSW )	-- 결과가 날아온다.
	equipSlot:clearItem()
	avatarSlot:clearItem()

	selectedItemSlotNo	= nil
	selectedItemWhere	= nil
	elapsTime			= 0
	doChange			= false
	-- resultComplete		= true

	resultItemKey		= itemSSW:get()._key

	avatarSlot:setItemByStaticStatus( itemSSW, 1, nil, nil, true )
	avatarSlot.icon:SetMonoTone( false )
end

function ItemChange_IconOver( isShow, controlId )

	if isShow then
		local control = nil
		if 0 == controlId then
			if nil == selectedItemWhere or nil == selectedItemSlotNo then
				return
			end

			control = equipSlot.icon
			local itemWrapper	= getInventoryItemByType( selectedItemWhere, selectedItemSlotNo )
			Panel_Tooltip_Item_Show( itemWrapper, control, false, true, nil, nil, nil )
		elseif 1 == controlId then -- and true == resultComplete
			control = avatarSlot.icon
			local itemSSW	= getItemEnchantStaticStatus( resultItemKey )
			Panel_Tooltip_Item_Show( itemSSW, control, true, false, nil, nil, nil )
		else
			return
		end
	else
		Panel_Tooltip_Item_hideTooltip()
	end
end

function ItemChange_Close()
	if true == isChangeDoing then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CHANGEITEM_DONOT_CLOSE") )	-- "아이템 전환 중에는 창을 닫을 수 없습니다."
		return
	end

	equipSlot:clearItem()
	avatarSlot:clearItem()
	selectedItemSlotNo	= nil
	selectedItemWhere	= nil
	elapsTime			= 0
	doChange			= false
	-- resultComplete		= false
	resultItemKey		= 0
	isChangeDoing		= false

	btn_Apply:SetShow( true )
	btn_Close:SetShow( false )
	runEffect:SetShow( false )

	Inventory_SetFunctor(nil, nil, nil, nil)
	Panel_ChangeItem:SetShow( false, false )
end

function ItemChange_updateTime( deltaTime )
	elapsTime = elapsTime + deltaTime

	if 3 < elapsTime then
		if nil == selectedItemSlotNo or nil == selectedItemWhere or false == doChange then
			return
		end
		runEffect:SetShow( false )
		avatarSlot.icon:AddEffect("UI_ItemEnchant01", false, -5, -5)
		useItemChange( selectedItemWhere, selectedItemSlotNo )
		doChange		= false
		isChangeDoing	= false

		btn_Apply:SetShow( false )
		btn_Close:SetShow( true )
	end

	if 4 < elapsTime then
		elapsTime = 0
	end
end

function FGlobal_ItemChange_IsDoing()
	return isChangeDoing
end

Panel_ChangeItem:RegisterUpdateFunc("ItemChange_updateTime")

registerEvent( "FromClient_ShowItemChange",		"FromClient_ShowItemChange" )
registerEvent( "FromClient_ItemChange",			"FromClient_ItemChange" )

