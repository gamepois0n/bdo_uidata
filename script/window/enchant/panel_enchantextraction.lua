Panel_EnchantExtraction:SetShow( false)
Panel_EnchantExtraction:ActiveMouseEventEffect( true )
Panel_EnchantExtraction:setMaskingChild(true)
Panel_EnchantExtraction:setGlassBackground(true)
Panel_EnchantExtraction:RegisterShowEventFunc( true, 'EnchantExtractionShowAni()' )
Panel_EnchantExtraction:RegisterShowEventFunc( false, 'EnchantExtractionHideAni()' )

function EnchantExtractionShowAni()
end
function EnchantExtractionHideAni()
end

local slotConfig = {	
	createIcon		= true,
	createBorder	= true,
	createCount		= false,
	createCash		= false,
}

local elapsTime = 4
local doExtraction = false
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local item_1 = {}
local item_2 = {}

local btn_Close			= UI.getChildControl( Panel_EnchantExtraction, "Button_Close" )
local btn_Extraction	= UI.getChildControl( Panel_EnchantExtraction, "Button_Extraction" )

local effect_Arrow		= UI.getChildControl( Panel_EnchantExtraction, "Static_BackEffect" )
local effect_Process	= UI.getChildControl( Panel_EnchantExtraction, "Static_ProcessEffect" )

local slot_1			= UI.getChildControl( Panel_EnchantExtraction, "equipIcon_1" )
local slot_2			= UI.getChildControl( Panel_EnchantExtraction, "equipIcon_2" )
local enchantNumber		= UI.getChildControl( Panel_Window_Inventory, "Static_Text_Slot_Enchant_value" )
local enchantCount		= UI.getChildControl( Panel_EnchantExtraction, "StaticText_Slot2" )


btn_Close		:addInputEvent( "Mouse_LUp", "Panel_EnchantExtraction_Close()" )
btn_Extraction	:addInputEvent( "Mouse_LUp", "HandleClicked_Extraction()" )

SlotItem.new( item_1, "Static_Icon_1", 0, slot_1, slotConfig )
item_1:createChild()
item_1.icon:SetPosX(0)
item_1.icon:SetPosY(0)
item_1.icon:addInputEvent( "Mouse_On", "EnchantExtraction_IconOver( true, " .. 0 .. ")" )
item_1.icon:addInputEvent( "Mouse_Out", "EnchantExtraction_IconOver( false )" )

SlotItem.new( item_2, "Static_Icon_2", 0, slot_2, slotConfig )
item_2:createChild()
item_2.icon:SetPosX(0)
item_2.icon:SetPosY(0)
item_2.icon:addInputEvent( "Mouse_On", "EnchantExtraction_IconOver( true, " .. 1 .. ")" )
item_2.icon:addInputEvent( "Mouse_Out", "EnchantExtraction_IconOver( false )" )

slot_2:EraseAllEffect()

local enchantText_1 = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, slot_1, "StaticText_Enchant_1")
CopyBaseProperty( enchantNumber, enchantText_1 )
enchantText_1:SetSize( slot_1:GetSizeX(), slot_1:GetSizeY() )
enchantText_1:SetPosX( 0 )
enchantText_1:SetPosY( 0 )
enchantText_1:SetTextHorizonCenter()
enchantText_1:SetTextVerticalCenter()
enchantText_1:SetIgnore(true)
enchantText_1:SetShow( false )

local enchantText_2 = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, slot_2, "StaticText_Enchant_1")
CopyBaseProperty( enchantNumber, enchantText_2 )
enchantText_2:SetSize( slot_2:GetSizeX(), slot_2:GetSizeY() )
enchantText_2:SetPosX( 0 )
enchantText_2:SetPosY( 0 )
enchantText_2:SetTextHorizonCenter()
enchantText_2:SetTextVerticalCenter()
enchantText_2:SetIgnore(true)
enchantText_2:SetShow( false )

function HandleClicked_Extraction()
	doExtraction = true
	effect_Arrow:SetShow( true )
	effect_Arrow:AddEffect( "fUI_Extraction01", false )
	audioPostEvent_SystemUi(05,11)
	-- effect_Process:SetShow( true )
	elapsTime = 0
end

function Panel_EnchantExtraction_Show()
	if not Panel_EnchantExtraction:GetShow() then
		Panel_EnchantExtraction:SetShow( true )
	end
	elapsTime = 4
	doExtraction = false
end

function Panel_EnchantExtraction_Close()
	Panel_EnchantExtraction:SetShow( false )
	elapsTime = 4
	doExtraction = false
end

local _fromWhereType, _fromSlotNo
local failCount = 0
function FromClient_ConvertEnchantFailCountToItem( fromWhereType, fromSlotNo )
	
	failCount = getSelfPlayer():get():getEnchantFailCount()		-- 일반적인 실패 카운팅
	if failCount < 2 then
		local message = PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANTCOUNTEXTRACTION_1")	-- "추출할 잠재력 돌파 확률이 부족합니다."
		Proc_ShowMessage_Ack_WithOut_ChattingMessage(message)
		if Panel_EnchantExtraction:GetShow() then
			Panel_EnchantExtraction:SetShow( false )
		end
		return
	end
	enchantCount:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ENCHANTCOUNTEXTRACTION_2", "count", "+" .. failCount )) -- "현재 잠재력 돌파 확률 : +" .. failCount )
	Panel_EnchantExtraction_Show()
	enchantText_1:SetText( "+" .. failCount )
	enchantText_2:SetText( "+" .. failCount )
	enchantText_1:SetShow( true )
	enchantText_2:SetShow( false )
	_fromWhereType = fromWhereType
	_fromSlotNo = fromSlotNo
	
	local itemWrapper = getInventoryItemByType( fromWhereType, fromSlotNo )
	if nil == itemWrapper then
		return
	end
	item_1:setItem( itemWrapper )
	item_1.icon:SetShow( true )
	
	local itemKey = ToClient_GetConvertEnchantFailItemKey( failCount )
	local resultItemStaticWrapper = getItemEnchantStaticStatus( ItemEnchantKey( itemKey ))
	if nil == resultItemStaticWrapper then
		return
	end
	item_2:setItemByStaticStatus( resultItemStaticWrapper, 1, nil, nil, false )
	item_2.icon:SetMonoTone( true )
end

function EnchantExtraction_IconOver( isShow, controlId )
	if isShow then
		local control = nil
		if 0 == controlId then
			control = item_1.icon
			local itemWrapper	= getInventoryItemByType( _fromWhereType, _fromSlotNo )
			Panel_Tooltip_Item_Show( itemWrapper, control, false, true, nil, nil, nil )
		elseif 1 == controlId then
			control = item_2.icon
			local itemSSW	= getItemEnchantStaticStatus( ItemEnchantKey(ToClient_GetConvertEnchantFailItemKey(failCount)) )
			Panel_Tooltip_Item_Show( itemSSW, control, true, false, nil, nil, nil )
		else
			return
		end
	else
		Panel_Tooltip_Item_hideTooltip()
	end
end


function FromClient_ConvertEnchantFailItemToCount( fromWhereType, fromSlotNo )
	local doItemUse = function()
		ToClient_ConvertEnchantFailItemToCount( fromWhereType, fromSlotNo )
	end
	local failCount = getSelfPlayer():get():getEnchantFailCount()
	local itemWrapper = getInventoryItemByType( fromWhereType, fromSlotNo )

	if 0 < failCount then
		local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_VALKS_NOUSE") -- "<PAColor0xFFF26A6A>잠재력 돌파 기본 확률이 0일 때만 사용할 수 있습니다.<PAOldColor>"
		local messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANTCOUNTEXTRACTION_4"), content = messageBoxMemo, functionYes = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
	else
		local messageBoxMemo = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_ENCHANTCOUNTEXTRACTION_3", "failCount", failCount, "itemName", itemWrapper:getStaticStatus():getName() )
		local messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANTCOUNTEXTRACTION_4"), content = messageBoxMemo, functionYes = doItemUse, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
	end
end

function EnchantExtraction_updateTime( deltaTime )
	elapsTime = elapsTime + deltaTime

	if 3 < elapsTime then
		if false == doExtraction then
			return
		end
		effect_Arrow:SetShow( false )
		effect_Process:SetShow( false )
		enchantText_1:SetShow( false )
		enchantText_2:SetShow( true )
		slot_2:AddEffect("UI_ItemEnchant01", false, -5, -5)
		item_1.icon:SetShow( false )
		item_2.icon:SetMonoTone( false )
		doExtraction	= false
		elapsTime = 0
		ToClient_ConvertEnchantFailCountToItem( _fromWhereType, _fromSlotNo )
		enchantCount:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ENCHANTCOUNTEXTRACTION_2", "count", "0" )) -- "현재 잠재력 돌파 확률 : 0" )
	end
end

function FromClient_ConvertEnchantFailCountToItemAck()
	Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANTCOUNTEXTRACTION_5") ) -- "잠재력 돌파 확률이 정상적으로 추출되었습니다." )
end

function FromClient_ConvertEnchantFailItemToCountAck()
	-- Proc_ShowMessage_Ack( "발크스의 외침 정상적으로 적용 완료" )
end

function FGlobal_ItemChange_IsDoing()
	return isChangeDoing
end

Panel_EnchantExtraction:RegisterUpdateFunc("EnchantExtraction_updateTime")
registerEvent( "FromClient_ConvertEnchantFailCountToItem",		"FromClient_ConvertEnchantFailCountToItem" )
registerEvent( "FromClient_ConvertEnchantFailItemToCount",		"FromClient_ConvertEnchantFailItemToCount" )
registerEvent( "FromClient_ConvertEnchantFailCountToItemAck",	"FromClient_ConvertEnchantFailCountToItemAck" )
registerEvent( "FromClient_ConvertEnchantFailItemToCountAck",	"FromClient_ConvertEnchantFailItemToCountAck" )