local UI_PUCT 		= CppEnums.PA_UI_CONTROL_TYPE
local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color
local UI_TM			= CppEnums.TextMode

Panel_ColorBalance:setGlassBackground( true )
Panel_ColorBalance:ActiveMouseEventEffect( true )

Panel_ColorBalance:RegisterShowEventFunc( true, 'Panel_ColorBalance_ShowAni()' )
Panel_ColorBalance:RegisterShowEventFunc( false, 'Panel_ColorBalance_HideAni()' )


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local ui = {
	_btn_Close 				= UI.getChildControl( Panel_ColorBalance, "Button_Close"),
	_btn_Question 			= UI.getChildControl( Panel_ColorBalance, "Button_Question"),
	
	_static_colorArrow 		= UI.getChildControl( Panel_ColorBalance, "Static_ColorArrow"),
	
	_static_slot1 			= UI.getChildControl( Panel_ColorBalance, "Static_Mix1_Slot"),
	_static_slot2 			= UI.getChildControl( Panel_ColorBalance, "Static_Mix2_Slot"),
	_static_CompleteSlot 	= UI.getChildControl( Panel_ColorBalance, "Static_CompleteSlot"),
	
	_btn_StartMix 			= UI.getChildControl( Panel_ColorBalance, "Button_StartMix"),
	_txt_HelpDesc 			= UI.getChildControl( Panel_ColorBalance, "StaticText_Desc"),
	
	_txt_WarningDesc 		= UI.getChildControl( Panel_ColorBalance, "StaticText_WarningDesc"),
}

ui._btn_Close:addInputEvent( "Mouse_LUp", "Panel_ColorBalance_Close()" )
ui._btn_Question:addInputEvent( "Mouse_LUp", "" )
ui._btn_StartMix:addInputEvent( "Mouse_LUp", "Panel_ColorBalance_CombineDyeItem()" )

local _slotConfig =
{	-- 일단 아이콘, 테두리, 카운트(숫자) 만 적용한다!
	createIcon		= true,
	createBorder	= false,
	createCount		= true,
	createCash		= true
}


local _slotCount = 3

local _slotList = {}
for index = 1, _slotCount, 1 do
	local createdSlot = {}
	SlotItem.new( createdSlot, 'ItemIconSlot'..index , 0, Panel_ColorBalance, _slotConfig )
	createdSlot:createChild()
	createdSlot.icon:addInputEvent( "Mouse_RUp",  	"Panel_ColorBalance_SlotRClick(" ..index.. ")" )
	createdSlot.icon:addInputEvent( "Mouse_On",  	"Panel_ColorBalance_ShowTooltip(" ..index.. ")" )
	createdSlot.icon:addInputEvent( "Mouse_Out",  	"Panel_ColorBalance_HideTooltip()" )
	if index ~= _slotCount then
		createdSlot.icon:addInputEvent( "Mouse_LUp",  	"Panel_ColorBalance_DropHandler(" ..index.. ")" )
	end
	_slotList[index] = createdSlot
end


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



---------------------------------------------------------------
--					SHOW / HIDE ANIMATION
---------------------------------------------------------------
function Panel_ColorBalance_ShowAni()
	Panel_ColorBalance:SetAlpha( 0 )
	UIAni.AlphaAnimation( 1, Panel_ColorBalance, 0.0, 0.15 )
	
	local scaleAni = Panel_ColorBalance:addScaleAnimation( 0.0, 0.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	scaleAni:SetStartScale(0.8)
	scaleAni:SetEndScale(1.0)
	scaleAni.AxisX = Panel_ColorBalance:GetPosX() / 2
	scaleAni.AxisY = Panel_ColorBalance:GetPosY() / 2
	scaleAni.IsChangeChild = true
end

function Panel_ColorBalance_HideAni()
	Panel_ColorBalance:SetAlpha( 1 )
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_ColorBalance, 0.0, 0.12 )
	aniInfo:SetHideAtEnd(true)
	
	local scaleAni2 = Panel_ColorBalance:addScaleAnimation( 0.0, 0.12, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	scaleAni2:SetStartScale(1.0)
	scaleAni2:SetEndScale(0.8)
	scaleAni2.AxisX = Panel_ColorBalance:GetPosX() / 2
	scaleAni2.AxisY = Panel_ColorBalance:GetPosY() / 2
	scaleAni2.IsChangeChild = true
end

---------------------------------------------------------------
--					최초 초기화 함수
---------------------------------------------------------------
local Panel_ColorBalance_ClearSlot = function()
	_slotList[1].icon:SetPosX(ui._static_slot1:GetPosX())
	_slotList[1].icon:SetPosY(ui._static_slot1:GetPosY())
	_slotList[1].icon:SetShow(false)
	_slotList[1]:clearItem()
	_slotList[2].icon:SetPosX(ui._static_slot2:GetPosX())
	_slotList[2].icon:SetPosY(ui._static_slot2:GetPosY())
	_slotList[2].icon:SetShow(false)
	_slotList[2]:clearItem()
	_slotList[3].icon:SetPosX(ui._static_CompleteSlot:GetPosX())
	_slotList[3].icon:SetPosY(ui._static_CompleteSlot:GetPosY())
	_slotList[3].icon:SetShow(false)
	_slotList[3]:clearItem()
	
	ui._static_colorArrow:SetColor(UI_color.C_FFFFFFFF)
end

function Panel_ColorBalance_Initialize()
	ui._txt_HelpDesc:SetTextMode( UI_TM.eTextMode_AutoWrap )
	ui._txt_HelpDesc:SetText( PAGetString( Defines.StringSheet_GAME, "LUA_DYE_COLORBAL_DESC" ) ) -- - 두 개의 염색약을 혼합하여 미지의 염색약 상자를 만듭니다.\n- 혼합에 사용된 두 개의 염색약은 사라집니다.

	Panel_ColorBalance_ClearSlot()
end


---------------------------------------------------------------
--					패널 SHOW TOGGLE 함수
---------------------------------------------------------------
function Panel_ColorBalance_Show()
	audioPostEvent_SystemUi(01,24)
	Panel_ColorBalance:SetShow( true, true )	
	Panel_ColorBalance:SetPosX( (getScreenSizeX() / 2) - (Panel_ColorBalance:GetSizeX() / 2) )
	Panel_ColorBalance:SetPosY( (getScreenSizeY() / 2) - (Panel_ColorBalance:GetSizeY() / 2) )
	
	Inventory_SetFunctor( Panel_ColorBalance_InvenFilter_IsDyeItem, Panel_ColorBalance_InvenRClick, Panel_ColorBalance_Close, nil );
	InventoryWindow_Show()
	Panel_ColorBalance_ClearSlot()
end

function Panel_ColorBalance_Close()
	Panel_ColorBalance:SetShow( false, false )
	Inventory_SetFunctor( nil, nil, nil, nil );
	InventoryWindow_Close()
end

function Panel_ColorBalance_InvenFilter_IsDyeItem(slotNo, itemWrapper, currentWhereType)
	if nil == itemWrapper then
		return true
	end
	local isAble = ToClient_IsDyeItem(currentWhereType, slotNo);
	return (not isAble);
end

function Panel_ColorBalance_InvenRClick(slotNo, itemWrapper, itemCount, currentWhereType)
	if (not _slotList[1].icon:GetShow()) then
		_slotList[1]:setItemByStaticStatus( itemWrapper:getStaticStatus(), itemWrapper:get():getCount_s64() )
		_slotList[1].icon:SetShow(true)
		_slotList[1].slotNo = slotNo
		_slotList[1].itemWhereType = currentWhereType
	elseif (not _slotList[2].icon:GetShow()) then
		-- 1개짜리가 이미 꼽혀 있으면! 리턴한다.
		if 1 == tonumber(_slotList[1].count:GetText()) and _slotList[1].slotNo == slotNo then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_COLORBALENCE_INVENRCLICK") ) -- "개수가 1인 아이템을 2번 선택할 수 없습니다. 다시 선택해주세요." )
			return
		end

		_slotList[2]:setItemByStaticStatus( itemWrapper:getStaticStatus(), itemWrapper:get():getCount_s64() )
		_slotList[2].icon:SetShow(true)
		_slotList[2].slotNo = slotNo
		_slotList[2].itemWhereType = currentWhereType
	else
		-- 1개짜리가 이미 꼽혀 있으면! 리턴한다.
		if 1 == tonumber(_slotList[1].count:GetText()) and _slotList[1].slotNo == slotNo then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_COLORBALENCE_INVENRCLICK") ) -- "개수가 1인 아이템을 2번 선택할 수 없습니다. 다시 선택해주세요." )
			return
		end

		_slotList[2]:setItemByStaticStatus( itemWrapper:getStaticStatus(), itemWrapper:get():getCount_s64() )
		_slotList[2].icon:SetShow(true)
		_slotList[2].slotNo = slotNo
		_slotList[2].itemWhereType = currentWhereType
	end
	
	ui._static_colorArrow:SetColor(UI_color.C_FFFFFFFF)
	_slotList[3].icon:SetShow(false)		
	_slotList[3]:clearItem()		
end

function Panel_ColorBalance_SlotRClick(index)
	_slotList[index].icon:SetShow(false)		
	_slotList[index]:clearItem()
	_slotList[index].itemWhereType = nil
	_slotList[index].slotNo = nil
	
	if Panel_Tooltip_Item:GetShow() then
		Panel_ColorBalance_HideTooltip()
	end
end

function Panel_ColorBalance_DropHandler(index)
	if nil == DragManager.dragStartPanel then
		return(false)
	end
	
	local	fromSlotNo	= DragManager.dragSlotInfo
	
	if (Panel_Window_Inventory == DragManager.dragStartPanel)	then
		local itemWrapper = getInventoryItemByType( DragManager.dragWhereTypeInfo, DragManager.dragSlotInfo  )
		if	(nil == itemWrapper)	then
			return(false)
		end
		
		_slotList[index]:setItemByStaticStatus( itemWrapper:getStaticStatus(), itemWrapper:get():getCount_s64() )
		_slotList[index].icon:SetShow(true)
		_slotList[index].slotNo 		= DragManager.dragSlotInfo
		_slotList[index].itemWhereType 	= DragManager.dragWhereTypeInfo
		
		_slotList[3].icon:SetShow(false)		
		_slotList[3]:clearItem()
			
		DragManager:clearInfo()
		return(true)
	end
	
	return(false)
end

function Panel_ColorBalance_ShowTooltip(index)
	local itemWrapper	= getInventoryItemByType( _slotList[index].itemWhereType, _slotList[index].slotNo )
	
	Panel_Tooltip_Item_Show( itemWrapper:getStaticStatus(), _slotList[index].icon, true, false )
end

function Panel_ColorBalance_HideTooltip()
	Panel_Tooltip_Item_hideTooltip()
end

function Panel_ColorBalance_CombineDyeItem()
	if nil == _slotList[1].itemWhereType or nil == _slotList[2].itemWhereType then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_COLORBALENCE_COMBINEDYEITEM") ) -- "선택된 염색약이 없습니다.")
		return
	end
	ToClient_CombineDyeItem(_slotList[1].itemWhereType, _slotList[1].slotNo, _slotList[2].itemWhereType, _slotList[2].slotNo)
end

function FromClient_ColorBalance_SlotUpdate(itemWhereType, itemSlotNo)
	local itemWrapper 	= nil
	
	for index=1, _slotCount -1 , 1 do
		itemWrapper	= getInventoryItemByType( _slotList[index].itemWhereType, _slotList[index].slotNo )
		if (nil ~= itemWrapper) then
			_slotList[index]:setItemByStaticStatus( itemWrapper:getStaticStatus(), itemWrapper:get():getCount_s64() )
		else
			_slotList[index].icon:SetShow(false)		
			_slotList[index]:clearItem()
		end
	end
	
	itemWrapper	= getInventoryItemByType( itemWhereType, itemSlotNo )
	_slotList[3]:setItemByStaticStatus( itemWrapper:getStaticStatus(), 1 )
	_slotList[3].icon:SetShow(true)	
	_slotList[3].slotNo			= itemSlotNo
	_slotList[3].itemWhereType	= itemWhereType
	
	ui._static_colorArrow:SetColor(itemWrapper:getStaticStatus():get():getItemColor())

	-- 앰플 리스트를 업데이트 해야 한다.
	FGlobal_Panel_DyeNew_updateColorAmpuleList()
	FGlobal_UpdateInventorySlotData()
end


function ColorBalance_RestoreFlush()
	if Panel_ColorBalance:GetShow() then
		Inventory_SetFunctor( Panel_ColorBalance_InvenFilter_IsDyeItem, Panel_ColorBalance_InvenRClick, Panel_ColorBalance_Close, nil );
	end
end
UI.addRunPostRestorFunction( ColorBalance_RestoreFlush )


Panel_ColorBalance_Initialize()

registerEvent("FromClient_ColorBalance_SlotUpdate",				"FromClient_ColorBalance_SlotUpdate")