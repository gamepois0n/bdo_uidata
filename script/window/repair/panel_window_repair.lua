local UI_ANI_ADV 		= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 			= Defines.Color
local UI_Group			= Defines.UIGroup
local UI_PUCT 			= CppEnums.PA_UI_CONTROL_TYPE

Panel_Window_Repair:SetShow(false, false)
Panel_Window_Repair:setMaskingChild(true)
Panel_Window_Repair:ActiveMouseEventEffect(true)
--Panel_Window_Repair:setGlassBackground(true)

Panel_LuckyRepair_Result:SetShow(false)

Panel_Window_Repair:RegisterShowEventFunc( true, 'RepairShowAni()' )
Panel_Window_Repair:RegisterShowEventFunc( false, 'RepairHideAni()' )

local isContentsEnable = ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 36 ) -- 코끼리 컨텐츠 옵션.

function RepairShowAni()
end

function RepairHideAni()
end

local screenX				= nil
local screenY				= nil
local repairWhereType		= nil
local repairSlotNo			= nil
local _repairCursor 		= UI.getChildControl( Panel_Window_Repair, "Static_Cursor" )
local repairMessageBG 		= UI.getChildControl( Panel_Equipment, "Static_Repair_Message" )
local repairMessage 		= UI.getChildControl( repairMessageBG, "StaticText_Repair_Message" )
local repairMessageJP 		= UI.getChildControl( repairMessageBG, "StaticText_Repair_MessageJP" )

local repairInven			= UI.getChildControl( Panel_Equipment, "Static_Text_Money")
local repairWareHouse		= UI.getChildControl( Panel_Equipment, "Static_Text_Money2")
local repairInvenMoney		= UI.getChildControl( Panel_Equipment, "RadioButton_Icon_Money")
local repairWareHouseMoney	= UI.getChildControl( Panel_Equipment, "RadioButton_Icon_Money2")

local _repairBG = UI.getChildControl( Panel_Window_Repair, 	"RepairBackGround" )
_repairBG:setGlassBackground(true)
_repairBG:SetShow(true)

-- 탑승물(지상 탈것) 장비 수리
local _repairStableEquippedItemButton = UI.getChildControl( Panel_Window_Repair, "Button_Repair_Servant")
_repairStableEquippedItemButton:addInputEvent("Mouse_LUp", "MessageBoxRepairAllServantEquippedItemByLand()")

-- 탑승물(수상 탈것) 장비 수리
local _repairWharfEquippedItemButton = UI.getChildControl( Panel_Window_Repair, "Button_Repair_Ship")
_repairWharfEquippedItemButton:addInputEvent("Mouse_LUp", "MessageBoxRepairAllServantEquippedItemBySea()")

-- 탑승물(코끼리) 장비 수리
local _repairElephantButton = UI.getChildControl( Panel_Window_Repair, "Button_Repair_Elephant")
_repairElephantButton:addInputEvent( "Mouse_LUp", "RepairElephantBtn_LUp()" )

if getContentsServiceType() ~= CppEnums.ContentsServiceType.eContentsServiceType_Commercial then
	_repairStableEquippedItemButton:SetShow( false )
	_repairWharfEquippedItemButton:SetShow( false )
else
	_repairStableEquippedItemButton:SetShow( true )
	_repairWharfEquippedItemButton:SetShow( true )
end

if isGameTypeRussia() then
	_repairStableEquippedItemButton	:SetTextSpan( 40, 5 )
	_repairWharfEquippedItemButton	:SetTextSpan( 35, 5 )
elseif isGameTypeKorea() then
	_repairStableEquippedItemButton	:SetTextSpan( 55, 5 )
	_repairWharfEquippedItemButton	:SetTextSpan( 40, 5 )
elseif isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_JAP ) then
	_repairStableEquippedItemButton	:SetTextSpan( 55, 5 )
	_repairWharfEquippedItemButton	:SetTextSpan( 40, 5 )
else
	_repairStableEquippedItemButton	:SetTextSpan( 55, 5 )
	_repairWharfEquippedItemButton	:SetTextSpan( 40, 5 )
end

-- 길드 컨텐츠가 36번이고 여기에 코끼리 관련 컨텐츠가 포함된다고 정의되어있다.(기획게시판)
if isContentsEnable then
	_repairElephantButton:SetShow( true )
else
	_repairElephantButton:SetShow( false )
end

local _repairAllEquippedItemButton = UI.getChildControl ( Panel_Window_Repair, "Button_Repair_EquipItem" )
_repairAllEquippedItemButton:SetShow(true)
_repairAllEquippedItemButton:addInputEvent( "Mouse_LUp", "RepairAllEquippedItemBtn_LUp()"	)

local _repairAllInvenItemButton = UI.getChildControl ( Panel_Window_Repair, "Button_Repair_InvenItem" )
_repairAllInvenItemButton:SetShow(true)
_repairAllInvenItemButton:addInputEvent( "Mouse_LUp", "RepairAllInvenItemBtn_LUp()"	)

local _fixEquipItemButton = UI.getChildControl ( Panel_Window_Repair, "Button_FixEquip" )
_fixEquipItemButton:SetShow(true)
_fixEquipItemButton:addInputEvent( "Mouse_LUp", "FixEquipItemBtn_LUp()"	)

local _repairExitButton 			= UI.getChildControl ( Panel_Window_Repair, "Button_Exit" )
_repairExitButton:SetShow(true)
_repairExitButton:addInputEvent( "Mouse_LUp", "RepairExitBtn_LUp()"	)


local LuckyRepairTamplate	= {
	ResultMsgBG		= UI.getChildControl(Panel_Window_Extraction_Result, "Static_Finish"),
	ResultMsg		= UI.getChildControl(Panel_Window_Extraction_Result, "StaticText_Finish"),
}
local LuckyRepairMSG = {}
local LuckyRepair_Set = function()
	Panel_LuckyRepair_Result:SetSize( getScreenSizeX(), getScreenSizeY() )
	Panel_LuckyRepair_Result:SetPosX( 0 )
	Panel_LuckyRepair_Result:SetPosY( 0 )
	Panel_LuckyRepair_Result:SetColor( UI_color.C_00FFFFFF )
	Panel_LuckyRepair_Result:SetIgnore(true)

	local tempSlot = {}
	local MSGBG = UI.getChildControl( Panel_LuckyRepair_Result, 'LuckyRepair_BG' )
	tempSlot.MSGBG = MSGBG
	
	local MSG = UI.getChildControl( Panel_LuckyRepair_Result, 'LuckyRepair_MSG' )
	tempSlot.MSG = MSG

	MSG:SetSize( getScreenSizeX(), 90 )
	MSG:ComputePos()
	MSGBG:SetSize( (getScreenSizeX() + 40), 90 )
	MSGBG:SetPosX( -20 )
	MSGBG:ComputePos()

	-- 애니 초기화
	MSGBG:ResetVertexAni()
	MSGBG:SetVertexAniRun( "Ani_Scale_0", true )

	LuckyRepairMSG = tempSlot
end
LuckyRepair_Set()

local  ResultMsg_ShowTime = 0
function FromClient_LuckyRepair_resultShow()
	if false == Panel_LuckyRepair_Result:GetShow() then
		LuckyRepairMSG.MSG:SetText( PAGetString(Defines.StringSheet_GAME, "REPAIR_LUCKY_TEXT") ) -- "최대 내구도가 1만큼 증가했습니다."
		Panel_LuckyRepair_Result:SetShow( true )
		ResultMsg_ShowTime = 0
	end
end
function Chk_LuckyRepair_ResultMsg_ShowTime( deltaTime )
	ResultMsg_ShowTime = ResultMsg_ShowTime + deltaTime
	if (3 < ResultMsg_ShowTime) and (true == Panel_LuckyRepair_Result:GetShow()) then
		Panel_LuckyRepair_Result:SetShow(false)
	end

	if (5 < ResultMsg_ShowTime) then
		ResultMsg_ShowTime = 0
	end
end

function Repair_BtnResize()
	local btnRepairStableSizeX						= _repairStableEquippedItemButton:GetSizeX()+23
	local btnRepairStableTextPosX					= (btnRepairStableSizeX - (btnRepairStableSizeX/2) - ( _repairStableEquippedItemButton:GetTextSizeX() / 2 ))
	local btnRepairWharfSizeX						= _repairWharfEquippedItemButton:GetSizeX()+23
	local btnRepairWharfTextPosX					= (btnRepairWharfSizeX - (btnRepairWharfSizeX/2) - ( _repairWharfEquippedItemButton:GetTextSizeX() / 2 ))
	local btnRepairElephantSizeX					= _repairElephantButton:GetSizeX()+23
	local btnRepairElephantTextPosX					= (btnRepairElephantSizeX - (btnRepairElephantSizeX/2) - ( _repairElephantButton:GetTextSizeX() / 2 ))
	local btnRepairAllSizeX							= _repairAllEquippedItemButton:GetSizeX()+23
	local btnRepairAllTextPosX						= (btnRepairAllSizeX - (btnRepairAllSizeX/2) - ( _repairAllEquippedItemButton:GetTextSizeX() / 2 ))
	local btnRepairAllInvenSizeX					= _repairAllInvenItemButton:GetSizeX()+23
	local btnRepairAllInvenTextPosX					= (btnRepairAllInvenSizeX - (btnRepairAllInvenSizeX/2) - ( _repairAllInvenItemButton:GetTextSizeX() / 2 ))
	local btnFixEquipSizeX							= _fixEquipItemButton:GetSizeX()+23
	local btnFixEquipTextPosX						= (btnFixEquipSizeX - (btnFixEquipSizeX/2) - ( _fixEquipItemButton:GetTextSizeX() / 2 ))
	local btnExitSizeX								= _repairExitButton:GetSizeX()+23
	local btnExitTextPosX							= (btnExitSizeX - (btnExitSizeX/2) - ( _repairExitButton:GetTextSizeX() / 2 ))

	_repairStableEquippedItemButton					:SetTextSpan( btnRepairStableTextPosX, 5 )
	_repairWharfEquippedItemButton					:SetTextSpan( btnRepairWharfTextPosX, 5 )
	_repairElephantButton							:SetTextSpan( btnRepairElephantTextPosX, 5 )
	_repairAllEquippedItemButton					:SetTextSpan( btnRepairAllTextPosX, 5 )
	_repairAllInvenItemButton						:SetTextSpan( btnRepairAllInvenTextPosX, 5 )
	_fixEquipItemButton								:SetTextSpan( btnFixEquipTextPosX, 5 )
	_repairExitButton								:SetTextSpan( btnExitTextPosX, 5 )
end

function Repair_Resize()
	screenX = getScreenSizeX()
	screenY = getScreenSizeY()

	Panel_Window_Repair:SetSize(screenX, Panel_Window_Repair:GetSizeY() )
	Panel_Window_Repair:ComputePos()

	_repairBG:SetSize( screenX, _repairBG:GetSizeY() )
	_repairBG:ComputePos()
	
	_repairStableEquippedItemButton:ComputePos()
	_repairWharfEquippedItemButton:ComputePos()
	_repairElephantButton:ComputePos()
	_repairAllEquippedItemButton:ComputePos()
	_repairAllInvenItemButton:ComputePos()	
	_repairExitButton:ComputePos()
	_fixEquipItemButton:ComputePos()
	
	Panel_LuckyRepair_Result:SetSize( getScreenSizeX(), getScreenSizeY() )
	Panel_LuckyRepair_Result:SetPosX( 0 )
	Panel_LuckyRepair_Result:SetPosY( 0 )
	Panel_LuckyRepair_Result:SetColor( UI_color.C_00FFFFFF )
	Panel_LuckyRepair_Result:SetIgnore(true)

	
	LuckyRepairMSG.MSGBG:SetSize( (getScreenSizeX() + 40), 90 )
	LuckyRepairMSG.MSGBG:SetPosX( -20 )
	LuckyRepairMSG.MSGBG:ComputePos()
	LuckyRepairMSG.MSG:SetSize( getScreenSizeX(), 90 )
	LuckyRepairMSG.MSG:ComputePos()
	-- 애니 초기화
	LuckyRepairMSG.MSGBG:ResetVertexAni()
	LuckyRepairMSG.MSGBG:SetVertexAniRun( "Ani_Scale_0", true )
end

function RepairAllEquippedItemBtn_LUp()
	MessageBoxRepairAllEquippedItem()
	Cursor_PosUpdate()
	_repairCursor:AddEffect("fUI_Repair01", false, -8, -8)
end

function RepairAllInvenItemBtn_LUp()
	MessageBoxRepairAllInvenItem()
	Cursor_PosUpdate()
	_repairCursor:AddEffect("fUI_Repair01", false, -8, -8)
end

function RepairExitBtn_LUp()
	Repair_OpenPanel(false)
	FixEquip_Close()
end

function Repair_InvenFilter(slotNo, itemWrapper)
	if nil == itemWrapper then
		return true
	end
	local isAble = itemWrapper:checkToRepairItem();
	return (not isAble);
end

function	Repair_InvenRClick( slotNo, itemWrapper, s64_itemCount, itemWhereType )
	local isAble = itemWrapper:checkToRepairItem();
	if( not isAble )then
		return
	end

	Cursor_PosUpdate()
	_repairCursor:AddEffect("fUI_Repair01", false, -8, -8)
	
	local	repairPrice = repair_getRepairPrice_s64( itemWhereType, slotNo, CppEnums.ServantType.Type_Count )
	if( Defines.s64_const.s64_0 < repairPrice ) then
		local	strPrice		= string.format( "%d", Int64toInt32(repairPrice) )
		local	messageboxMemo	= PAGetStringParam1( Defines.StringSheet_GAME, "REPAIR_MESSAGEBOX_MEMO", "price", strPrice )
		local	messageboxData	= { title = PAGetString( Defines.StringSheet_GAME, "REPAIR_MESSAGEBOX_TITLE" ), content = messageboxMemo, functionYes = Repair_Item_MessageBox_Confirm, functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData);
		
		repairWhereType = itemWhereType
		repairSlotNo	= slotNo
	end
end

function	Repair_EquipWindowRClick( equipSlotNo, itemWrapper )
	local isAble = itemWrapper:checkToRepairItem();
	if( not isAble )then
		return;
	end
	Cursor_PosUpdate()
	_repairCursor:AddEffect("fUI_Repair01", false, -8, -8)
	
	local	repairPrice	= repair_getRepairPrice_s64( CppEnums.ItemWhereType.eEquip, equipSlotNo, CppEnums.ServantType.Type_Count )
	if( Defines.s64_const.s64_0 < repairPrice ) then
		local	strPrice		= string.format( "%d", Int64toInt32(repairPrice) )
		local	messageboxMemo	= PAGetStringParam1( Defines.StringSheet_GAME, "REPAIR_MESSAGEBOX_MEMO", "price", strPrice )	--"수리비가 " .. tostring(repairPrice) .. "실버입니다 수리하시겠습니까?";
		local	messageboxData = { title = PAGetString( Defines.StringSheet_GAME, "REPAIR_MESSAGEBOX_TITLE" ), content = messageboxMemo, functionYes = Repair_Item_MessageBox_Confirm, functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData);
		
		repairWhereType = CppEnums.ItemWhereType.eEquip
		repairSlotNo	= equipSlotNo
	end
end

function Repair_OpenPanel( isShow )

	if( true == isShow ) then
		SetUIMode( Defines.UIMode.eUIMode_Repair )	
		repair_SetRepairMode( true )
		setIgnoreShowDialog( true )
		UIAni.fadeInSCR_Down(Panel_Window_Repair)
		Inventory_SetFunctor( Repair_InvenFilter, Repair_InvenRClick, RepairExitBtn_LUp, nil )
		InventoryWindow_Show( true )
		repairInvenMoney:SetCheck( true )
		repairWareHouseMoney:SetCheck( false )
	else
		SetUIMode( Defines.UIMode.eUIMode_NpcDialog )	-- 더 좋은 방법이 있기 전까지는 여기에서 UI Mode 를 변경해준다! - 성경
		repair_SetRepairMode( false )
		setIgnoreShowDialog( false )
		Inventory_SetFunctor( nil, nil, nil, nil )
		InventoryWindow_Close()
	end
	
	-- Inventory_SetFunctor이 설정되면 안되기에 Equipment_SetShow 호출하지 않고직접 해준다.
	Panel_Equipment:SetShow(isShow, true)	
	
	Panel_Npc_Dialog:SetShow(not isShow)
	Panel_Window_Repair:SetShow(isShow, false)
	
	if false == isGameTypeKorea() then
		repairMessageBG:SetShow( isShow )
		repairInven:SetShow( isShow )
		repairWareHouse:SetShow( isShow )
		repairInvenMoney:SetShow( isShow )
		repairWareHouseMoney:SetShow( isShow )
		FGlobal_Equipment_SetFunctionButtonHide( not isShow )
		repairMessage:SetShow( false )
		repairMessageJP:SetShow( true )
		repairMessageJP:SetText( PAGetString(Defines.StringSheet_GAME, "REPAIR_SELECTITEM_TEXT") ) -- "수리할 아이템에 마우스 우클릭하세요."
	else
		repairMessageBG:SetShow( isShow )
		repairInven:SetShow( isShow )
		repairWareHouse:SetShow( isShow )
		repairInvenMoney:SetShow( isShow )
		repairWareHouseMoney:SetShow( isShow )
		FGlobal_Equipment_SetFunctionButtonHide( not isShow )
		repairMessageJP:SetShow( false )
		repairMessage:SetShow( true )
		repairMessage:SetText( PAGetString(Defines.StringSheet_GAME, "REPAIR_SELECTITEM_TEXT") ) -- "수리할 아이템에 마우스 우클릭하세요."
	end

	if not Panel_Equipment:IsShow() then
		repairMessageBG:SetShow( false )
	end
end

function	MessageBoxRepairAllEquippedItem()
	local	s64_totalPrice	= repair_RepairAllPrice_s64(CppEnums.ItemWhereType.eEquip, true, CppEnums.ServantType.Type_Count, false)
	
	if( Defines.s64_const.s64_0 < s64_totalPrice ) then
		local	strPrice		= string.format( "%d", Int64toInt32(s64_totalPrice) )
		local	messageboxMemo	= PAGetStringParam1( Defines.StringSheet_GAME, "REPAIR_EQUIP_MESSAGEBOX_MEMO", "price", makeDotMoney(strPrice) )	--"장착창의 수리비가 " .. tostring(s64_totalPrice) .. "실버입니다 수리하시겠습니까?";
		local	messageboxData	= { title = PAGetString( Defines.StringSheet_GAME, "REPAIR_ALL_MESSAGEBOX_TITLE" ), content = messageboxMemo, functionYes = Repair_AllItem_MessageBox_Confirm, functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData);
	else	
		local	messageboxMemo= PAGetString( Defines.StringSheet_GAME, "REPAIR_NOT_MESSAGEBOX_MEMO" )	--"수리할 아이템이 없습니다.";
		local	messageboxData= { title = PAGetString( Defines.StringSheet_GAME, "REPAIR_ALL_MESSAGEBOX_TITLE" ), content = messageboxMemo, functionYes = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData);
	end
end

function	MessageBoxRepairAllServantEquippedItemByLand()
	local	s64_totalPrice	= repair_RepairAllPrice_s64(CppEnums.ItemWhereType.eServantEquip, true, CppEnums.ServantType.Type_Vehicle, false)
	
	if( Defines.s64_const.s64_0 < s64_totalPrice ) then
		local	strPrice		= string.format( "%d", Int64toInt32(s64_totalPrice) )
		local	messageboxMemo	= PAGetStringParam1( Defines.StringSheet_GAME, "REPAIR_EQUIP_MESSAGEBOX_MEMO", "price", makeDotMoney(strPrice) )	--"장착창의 수리비가 " .. tostring(s64_totalPrice) .. "실버입니다 수리하시겠습니까?";
		local	messageboxData	= { title = PAGetString( Defines.StringSheet_GAME, "REPAIR_ALL_MESSAGEBOX_TITLE" ), content = messageboxMemo, functionYes = Repair_AllItem_MessageBox_Confirm, functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData);
	else
		local	messageboxMemo= PAGetString(Defines.StringSheet_GAME, "LUA_REPAIR_SERVANT_DISTANCEREPAIR") -- 수리할 아이템이 없거나 탑승물이 근처에 존재하지 않습니다.
		local	messageboxData= { title = PAGetString( Defines.StringSheet_GAME, "REPAIR_ALL_MESSAGEBOX_TITLE" ), content = messageboxMemo, functionYes = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData);
	end
end

function	MessageBoxRepairAllServantEquippedItemBySea()
	local	s64_totalPrice	= repair_RepairAllPrice_s64(CppEnums.ItemWhereType.eServantEquip, true, CppEnums.ServantType.Type_Ship, false)
	
	if( Defines.s64_const.s64_0 < s64_totalPrice ) then
		local	strPrice		= string.format( "%d", Int64toInt32(s64_totalPrice) )
		local	messageboxMemo	= PAGetStringParam1( Defines.StringSheet_GAME, "REPAIR_EQUIP_MESSAGEBOX_MEMO", "price", makeDotMoney(strPrice) )	--"장착창의 수리비가 " .. tostring(s64_totalPrice) .. "실버입니다 수리하시겠습니까?";
		local	messageboxData	= { title = PAGetString( Defines.StringSheet_GAME, "REPAIR_ALL_MESSAGEBOX_TITLE" ), content = messageboxMemo, functionYes = Repair_AllItem_MessageBox_Confirm, functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData);
	else	
		local	messageboxMemo= PAGetString(Defines.StringSheet_GAME, "LUA_REPAIR_SERVANT_DISTANCEREPAIR") -- 수리할 아이템이 없거나 탑승물이 근처에 존재하지 않습니다.
		local	messageboxData= { title = PAGetString( Defines.StringSheet_GAME, "REPAIR_ALL_MESSAGEBOX_TITLE" ), content = messageboxMemo, functionYes = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData);
	end
end

-- 코끼리 장비 수리
function RepairElephantBtn_LUp()
	local	s64_totalPrice	= repair_RepairAllPrice_s64(CppEnums.ItemWhereType.eServantEquip, true, CppEnums.ServantType.Type_Vehicle, true)

	local GuildMoneyRepairElephant = function()
		repair_AllItem( CppEnums.ItemWhereType.eGuildWarehouse )
	end

	if( Defines.s64_const.s64_0 < s64_totalPrice ) then
		local	strPrice		= string.format( "%d", Int64toInt32(s64_totalPrice) )
		local	messageboxMemo	= PAGetStringParam1( Defines.StringSheet_GAME, "REPAIR_EQUIP_MESSAGEBOX_MEMO_ELEPHANT", "price", makeDotMoney(strPrice) )
		local	messageboxData	= { title = PAGetString( Defines.StringSheet_GAME, "REPAIR_ALL_MESSAGEBOX_TITLE" ), content = messageboxMemo, functionYes = GuildMoneyRepairElephant, functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData);
	else	
		local	messageboxMemo= PAGetString(Defines.StringSheet_GAME, "LUA_REPAIR_SERVANT_DISTANCEREPAIR") -- 수리할 아이템이 없거나 탑승물이 근처에 존재하지 않습니다.
		local	messageboxData= { title = PAGetString( Defines.StringSheet_GAME, "REPAIR_ALL_MESSAGEBOX_TITLE" ), content = messageboxMemo, functionYes = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData);
	end
end

function MessageBoxRepairAllInvenItem()
	local	inventory_s64		= repair_RepairAllPrice_s64(CppEnums.ItemWhereType.eInventory, true, CppEnums.ServantType.Type_Count, false)
	local	totalPrices_64		= repair_RepairAllPrice_s64(CppEnums.ItemWhereType.eCashInventory, false, CppEnums.ServantType.Type_Count, false)
	if( Defines.s64_const.s64_0 < totalPrices_64 ) then
		local	strPrice		= string.format( "%d", Int64toInt32(totalPrices_64) )
		local	messageboxMemo	= PAGetStringParam1( Defines.StringSheet_GAME, "REPAIR_INVENTORY_MESSAGEBOX_MEMO", "price", makeDotMoney(strPrice) )	-- "인벤토리창의 수리비가 " .. tostring(totalPrices_64) .. "실버입니다 수리하시겠습니까?";
		local	messageboxData	= { title = PAGetString( Defines.StringSheet_GAME, "REPAIR_ALL_MESSAGEBOX_TITLE" ), content = messageboxMemo, functionYes = Repair_AllItem_MessageBox_Confirm, functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData);
	else	
		local	messageboxMemo= PAGetString( Defines.StringSheet_GAME, "REPAIR_NOT_MESSAGEBOX_MEMO" )	--"수리할 아이템이 없습니다.";
		local	messageboxData= { title = PAGetString( Defines.StringSheet_GAME, "REPAIR_ALL_MESSAGEBOX_TITLE" ), content = messageboxMemo, functionYes = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData);
	end
end

function	Repair_AllItem_MessageBox_Confirm()
	local invenMoney		= repairInvenMoney:IsCheck()
	local wareHouseMoney	= repairWareHouseMoney:IsCheck()

	local moneyWhereType = CppEnums.ItemWhereType.eInventory
	if invenMoney then
		moneyWhereType = CppEnums.ItemWhereType.eInventory
	else
		moneyWhereType = CppEnums.ItemWhereType.eWarehouse
	end
	
	repair_AllItem( moneyWhereType )
end

function	Repair_Item_MessageBox_Confirm()
	local invenMoney		= repairInvenMoney:IsCheck()
	local wareHouseMoney	= repairWareHouseMoney:IsCheck()

	local moneyWhereType = CppEnums.ItemWhereType.eInventory
	if invenMoney then
		moneyWhereType = CppEnums.ItemWhereType.eInventory
	else
		moneyWhereType = CppEnums.ItemWhereType.eWarehouse
	end
	repair_Item( repairWhereType, repairSlotNo, moneyWhereType, CppEnums.ServantType.Type_Count )
end

function FGlobal_Repair_Money_Update()
	repairInven:SetText( makeDotMoney(getSelfPlayer():get():getInventory():getMoney_s64()) )
	repairWareHouse:SetText( makeDotMoney(warehouse_moneyFromNpcShop_s64()) )
end

function Cursor_PosUpdate()
	_repairCursor:SetPosX(getMousePosX() - Panel_Window_Repair:GetPosX())
	_repairCursor:SetPosY(getMousePosY() - Panel_Window_Repair:GetPosY())
end

local Repair_registEventHandler = function()
end
local Repair_registMessageHandler = function()
	registerEvent("onScreenResize",								"Repair_Resize" )
	registerEvent("FromClient_MaxEnduranceLuckyRepairEvent",	"FromClient_LuckyRepair_resultShow")
	registerEvent("EventWarehouseUpdate",						"FGlobal_Repair_Money_Update")
	Panel_LuckyRepair_Result:RegisterUpdateFunc("Chk_LuckyRepair_ResultMsg_ShowTime")
end

Repair_BtnResize()
Repair_registEventHandler()
Repair_registMessageHandler()
FGlobal_Repair_Money_Update()