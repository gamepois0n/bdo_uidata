Panel_ChangeWeapon:SetShow( false )
Panel_ChangeWeapon:setMaskingChild(true)
Panel_ChangeWeapon:setGlassBackground(true)
Panel_ChangeWeapon:RegisterShowEventFunc( true, 'Panel_ChangeWeapon_ShowAni()' )
Panel_ChangeWeapon:RegisterShowEventFunc( false, 'Panel_ChangeWeapon_HideAni()' )

local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE

local title			= UI.getChildControl( Panel_ChangeWeapon, "StaticText_Title")
local btn_CloseIcon	= UI.getChildControl( Panel_ChangeWeapon, "Button_CloseIcon")
local btn_Close		= UI.getChildControl( Panel_ChangeWeapon, "Button_Close")
local btn_Apply		= UI.getChildControl( Panel_ChangeWeapon, "Button_Apply")
local runEffect		= UI.getChildControl( Panel_ChangeWeapon, "Static_BackEffect")
local equipIcon		= UI.getChildControl( Panel_ChangeWeapon, "equipIcon_1")
local avatarIcon	= UI.getChildControl( Panel_ChangeWeapon, "equipIcon_2")

local 	_buttonQuestion	= UI.getChildControl( Panel_ChangeWeapon, "Button_Question" )							-- 물음표 버튼
	_buttonQuestion:	addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"ClothExchange\" )" )			-- 물음표 좌클릭
	_buttonQuestion:	addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"ClothExchange\", \"true\")" )	-- 물음표 마우스오버
	_buttonQuestion:	addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"ClothExchange\", \"false\")" )	-- 물음표 마우스아웃
	_buttonQuestion:SetShow( false )

local equipSlot		= {}
local avatarSlot	= {}

local selectedItemSlotNo	= nil
local selectedItemWhere		= nil
local elapsTime				= 0
local doChange				= false
local resultItemKey			= 0
local isChangeDoing			= false

local slotConfig = {	-- 일단 아이콘, 테두리, 카운트(숫자) 만 적용한다!
	createIcon		= true,
	createBorder	= true,
	createCount		= true,
	createCash		= false,
	createEnchant	= true,
}


local initiallize = function()
	btn_Apply		:addInputEvent("Mouse_LUp", "WeaponChange_ApplyChangeItem()")
	btn_Close		:addInputEvent("Mouse_LUp", "WeaponChange_Close()")
	btn_CloseIcon	:addInputEvent("Mouse_LUp", "WeaponChange_Close()")

	SlotItem.new( equipSlot, "ChangeWeapon_equipSlot", 0, equipIcon, slotConfig )
	equipSlot:createChild()
	equipSlot.icon:SetPosX(0)
	equipSlot.icon:SetPosY(0)
	equipSlot.icon:addInputEvent( "Mouse_On",	"WeaponChange_IconOver( true, " .. 0 .. " )" )
	equipSlot.icon:addInputEvent( "Mouse_Out",	"WeaponChange_IconOver( false, " .. 0 .. " )" )

	SlotItem.new( avatarSlot, "ChangeWeapon_avatarSlot", 0, avatarIcon, slotConfig )
	avatarSlot:createChild()
	avatarSlot.icon:SetPosX(0)
	avatarSlot.icon:SetPosY(0)
	avatarSlot.icon:addInputEvent( "Mouse_On",	"WeaponChange_IconOver( true, " .. 1 .. " )" )
	avatarSlot.icon:addInputEvent( "Mouse_Out",	"WeaponChange_IconOver( false, " .. 1 .. " )" )

	runEffect:SetShow( false )
	
	btn_Apply:SetShow( true )
	btn_Close:SetShow( false )
end
initiallize()

function Panel_ChangeWeapon_ShowAni()
	UIAni.fadeInSCR_Down( Panel_ChangeWeapon )
	
	local aniInfo1 = Panel_ChangeWeapon:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.1)
	aniInfo1.AxisX = Panel_ChangeWeapon:GetSizeX() / 2
	aniInfo1.AxisY = Panel_ChangeWeapon:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_ChangeWeapon:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.1)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_ChangeWeapon:GetSizeX() / 2
	aniInfo2.AxisY = Panel_ChangeWeapon:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function Panel_ChangeWeapon_HideAni()
	Panel_ChangeWeapon:SetAlpha( 1 )
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_ChangeWeapon, 0.0, 0.1 )
	aniInfo:SetHideAtEnd(true)
end

local materialWhereType, materialSlotno
function FromClient_UseItemExchangeToClass( whereType, SlotNo )	-- 아이템을 사용해 이벤트가 왔다. 열린다.
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
	
	materialWhereType = whereType
	materialSlotno = SlotNo
	Panel_ChangeWeapon:SetShow( true, true )
	Inventory_SetFunctor( WeaponChange_SetFilter, WeaponChange_Rclick, nil, nil )	-- 업데이트는 자동으로 된다.
	Inventory_SetShow( true )
end

function WeaponChange_SetFilter( slotNo, itemWrapper, whereType )
--	UI.debugMessage( slotNo .. '-' .. tostring(whereType) )
	local itemKey			= itemWrapper:get():getKey()
	local changeItemWrapper = getExchangeItem( whereType, slotNo, materialWhereType, materialSlotno )				-- 변경될 아이템래퍼
	if nil == changeItemWrapper then
		return true
	else
		local itemSSW = changeItemWrapper:getStaticStatus()
		local itemWrapper	= getInventoryItemByType( materialWhereType, materialSlotno ) 			-- 무기 교환권 래퍼
		local filterClassType = itemWrapper:getStaticStatus():getContentsEventParam1()
		local classType = getSelfPlayer():getClassType()
		local itemStaticStatus = getInventoryItemByType( whereType, slotNo ):getStaticStatus()
		if -1 == filterClassType then			-- 기존 무기 교환권(자기 클래스 무기로 변환)
			return itemStaticStatus:get()._usableClassType:isOn( classType )
		else									-- 특정 무기 교환권
			return itemStaticStatus:get()._usableClassType:isOn( filterClassType )
		end
	end
end

function WeaponChange_Rclick( slotNo, itemWrapper, count_s64, inventoryType )
	selectedItemSlotNo	= slotNo
	selectedItemWhere	= inventoryType
	elapsTime = 0
	equipSlot:clearItem()
	equipSlot:setItem( itemWrapper )

	btn_Apply:SetMonoTone( false )
	btn_Apply:SetEnable( true )
	btn_Apply:SetIgnore( false )

	local itemKey		= itemWrapper:get():getKey()
	local toItemWrapper	= getExchangeItem( inventoryType, slotNo, materialWhereType, materialSlotno )
	if nil ~= toItemWrapper then
		resultItemKey		= toItemWrapper:get():getKey():getItemKey()

		avatarSlot:clearItem()
		avatarSlot:setItemByStaticStatus( toItemWrapper:getStaticStatus(), 1, nil, nil, true )
		avatarSlot.icon:SetMonoTone( true )
	end
end

function WeaponChange_ApplyChangeItem()
	if nil == selectedItemWhere or nil == selectedItemSlotNo then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CHANGEWEAPON_SELECTITEM") ) -- "아이템을 선택해야 합니다.")
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

function FromClient_WeaponChange( itemSSW )	-- 결과가 날아온다.
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

function WeaponChange_IconOver( isShow, controlId )

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
			-- local itemSSW	= getItemEnchantStaticStatus( resultItemKey )
			local toItemWrapper	= getExchangeItem( selectedItemWhere, selectedItemSlotNo, materialWhereType, materialSlotno )
			if nil ~= toItemWrapper then
				local itemSSW = toItemWrapper:getStaticStatus()
				Panel_Tooltip_Item_Show( itemSSW, control, true, false, nil, nil, nil )
			end
		else
			return
		end
	else
		Panel_Tooltip_Item_hideTooltip()
	end
end

function WeaponChange_Close()
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
	Panel_ChangeWeapon:SetShow( false, false )
end

function WeaponChange_updateTime( deltaTime )
	elapsTime = elapsTime + deltaTime

	if 3 < elapsTime then
		if nil == selectedItemSlotNo or nil == selectedItemWhere or false == doChange then
			return
		end
		runEffect:SetShow( false )
		avatarSlot.icon:AddEffect("UI_ItemEnchant01", false, -5, -5)
		exchangeItemToClass( selectedItemWhere, selectedItemSlotNo, materialWhereType, materialSlotno )
		doChange		= false
		isChangeDoing	= false

		btn_Apply:SetShow( false )
		btn_Close:SetShow( true )
	end

	if 4 < elapsTime then
		elapsTime = 0
	end
end

function FGlobal_WeaponChange_IsDoing()
	return isChangeDoing
end

function FromClient_UseItemExchangeToClassNotify()
	WeaponChange_Close()
	Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CHANGEWEAPON_SUCCESS_CHANGEITEM") ) --"교환이 성공적으로 진행되었습니다."
end

Panel_ChangeWeapon:RegisterUpdateFunc("WeaponChange_updateTime")

registerEvent( "FromClient_UseItemExchangeToClass",			"FromClient_UseItemExchangeToClass" )			-- 교환권 클릭 시
registerEvent( "FromClient_UseItemExchangeToClassNotify",	"FromClient_UseItemExchangeToClassNotify" )		-- 교환 성공 시

