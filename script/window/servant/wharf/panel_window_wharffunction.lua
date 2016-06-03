Panel_Window_WharfFunction:SetShow(false, false)
Panel_Window_WharfFunction:setMaskingChild(true)
Panel_Window_WharfFunction:ActiveMouseEventEffect(true)
--Panel_Window_WharfFunction:setGlassBackground(true)
-- Panel_Window_WharfFunction:RegisterShowEventFunc( true, '' )
-- Panel_Window_WharfFunction:RegisterShowEventFunc( false, '' )
local _wharfBG = UI.getChildControl( Panel_Window_WharfFunction, 	"Static_WharfTitle" )
_wharfBG:setGlassBackground(true)

local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color
local IM			= CppEnums.EProcessorInputMode

local	wharfFunction	= {
	_config	=
	{
		
	},
	_buttonRegister	= UI.getChildControl( Panel_Window_WharfFunction,	"Button_Register"	),	-- 등록 버튼
	_buttonExit		= UI.getChildControl( Panel_Window_WharfFunction,	"Button_Exit"		),	-- 나가기 버튼
}

----------------------------------------------------------------------------------------------------
-- Init Function
function	wharfFunction:init()
end


function	wharfFunction:registEventHandler()
	self._buttonRegister:addInputEvent(	"Mouse_LUp", "WharfFunction_Button_RegisterReady()"	)
	self._buttonExit:addInputEvent(		"Mouse_LUp", "WharfFunction_Close()"			)
end

function	wharfFunction:registMessageHandler()
	registerEvent("onScreenResize",				"WharfFunction_Resize"		)
	registerEvent("FromClient_ServantUpdate",	"WharfFunction_RegisterAck"	)
end

function	WharfFunction_Resize()
	local	self	= wharfFunction

	local	screenX = getScreenSizeX()
	local	screenY = getScreenSizeY()

	Panel_Window_WharfFunction:SetSize(	screenX, Panel_Window_WharfFunction:GetSizeY()	)
	_wharfBG:SetSize(	screenX, Panel_Window_WharfFunction:GetSizeY()	)

	Panel_Window_WharfFunction:ComputePos()
	_wharfBG:ComputePos()
	self._buttonRegister:ComputePos()
	self._buttonExit:ComputePos()	
end

----------------------------------------------------------------------------------------------------
-- Button
function	WharfFunction_Button_RegisterReady()	
	Inventory_SetFunctor( InvenFiler_Mapae, WharfFunction_Register, Servant_InventoryClose, nil )
	Inventory_ShowToggle()
	
	audioPostEvent_SystemUi(00,00)
end

function	WharfFunction_Register( slotNo, itemWrapper, count_s64, inventoryType )
	WharfRegister_OpenByInventory( inventoryType, slotNo )
end

----------------------------------------------------------------------------------------------------
-- From Client

function	WharfFunction_RegisterAck()
	if GetUIMode() == Defines.UIMode.eUIMode_Default then
		return
	end

	if false == Panel_Window_WharfList:GetShow() then
		return
	end

	Inventory_SetFunctor( nil )
	InventoryWindow_Close()
	
	WharfRegister_Close()
	
	local	self	= wharfFunction
	self._buttonRegister:EraseAllEffect()
end

----------------------------------------------------------------------------------------------------
-- Window Open/Close
function	WharfFunction_Open()
	if	( Panel_Window_WharfFunction:GetShow() )	then
		return
	end
	
	-- ♬ 선착장이 열릴 때

	Servant_SceneOpen( Panel_Window_WharfFunction )
	
	WharfList_Open()
	
	local	self	= wharfFunction
	if	( stable_doHaveRegisterItem() )	then
		local	messageboxTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
		local	messageboxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_WHARF_REGISTERITEM_MSG")
		local	messageboxData	= { title = messageboxTitle, content = messageboxMemo, functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData)
		-- UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)

		self._buttonRegister:EraseAllEffect()
		self._buttonRegister:AddEffect("UI_ArrowMark01", true, 25, -38)
	else
		self._buttonRegister:EraseAllEffect()
	end
end

function	WharfFunction_Close()
	-- ♬ 선착장이 닫힐 때
	audioPostEvent_SystemUi(00,00)
	
	local	self	= wharfFunction
	self._buttonRegister:EraseAllEffect()
	
	InventoryWindow_Close()
	WharfList_Close()
	
	if	(not Panel_Window_WharfFunction:GetShow() )	then
		return
	end
	
	Servant_SceneClose( Panel_Window_WharfFunction )
end

----------------------------------------------------------------------------------------------------
-- Init

wharfFunction:init()
wharfFunction:registEventHandler()
wharfFunction:registMessageHandler()

WharfFunction_Resize()