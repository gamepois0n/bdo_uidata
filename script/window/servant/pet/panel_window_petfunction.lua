Panel_Window_PetFunction:SetShow(false, false)
Panel_Window_PetFunction:setMaskingChild(true)
Panel_Window_PetFunction:ActiveMouseEventEffect(true)
--Panel_Window_PetFunction:setGlassBackground(true)
Panel_Window_PetFunction:RegisterShowEventFunc( true, '' )
Panel_Window_PetFunction:RegisterShowEventFunc( false, '' )

local _petBG = UI.getChildControl( Panel_Window_PetFunction, 	"Static_PetTitle" )
_petBG:setGlassBackground( true )

local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color

local	PetFunction	= {
	_config	=
	{
		
	},
	_buttonRegister			= UI.getChildControl( Panel_Window_PetFunction,		"Button_Register"			),	-- 등록 버튼
	_buttonExit				= UI.getChildControl( Panel_Window_PetFunction,		"Button_Exit"				),	-- 나가기 버튼
	_buttonMating			= UI.getChildControl( Panel_Window_PetFunction, 	"Button_ListMating"			),	-- 교배시장
	_buttonMarket			= UI.getChildControl( Panel_Window_PetFunction, 	"Button_ListMarket"			),	-- 거래시장
	_buttonMix				= UI.getChildControl( Panel_Window_PetFunction,		"Button_HorseMix"			),	-- 말 합성
}

----------------------------------------------------------------------------------------------------
-- Init Function
function	PetFunction:init()
end


function	PetFunction:registEventHandler()
	self._buttonRegister:addInputEvent(	"Mouse_LUp", "PetFunction_Button_RegisterReady()"	)
	self._buttonExit:addInputEvent(		"Mouse_LUp", "PetFunction_Button_Exit()"			)
	self._buttonMating:addInputEvent(	"Mouse_LUp", "PetFunction_Button_Mating()"		)
	self._buttonMarket:addInputEvent(	"Mouse_LUp", "PetFunction_Button_Market()"		)
end

function	PetFunction:registMessageHandler()
	registerEvent("onScreenResize",				"PetFunction_Resize"		)
	registerEvent("FromClient_ServantUpdate",	"PetFunction_RegisterAck"	)
end

function	PetFunction_Resize()
	local	self	= PetFunction

	local	screenX = getScreenSizeX()
	local	screenY = getScreenSizeY()

	Panel_Window_PetFunction:SetSize(	screenX, Panel_Window_PetFunction:GetSizeY()	)
	_petBG:SetSize(	screenX, Panel_Window_PetFunction:GetSizeY()	)
	
	Panel_Window_PetFunction:ComputePos()
	_petBG:ComputePos()
	self._buttonRegister:ComputePos()
	self._buttonExit:ComputePos()
	self._buttonMating:ComputePos()
	self._buttonMarket:ComputePos()
	self._buttonMix:ComputePos()
end

----------------------------------------------------------------------------------------------------
-- Button
function	PetFunction_Button_RegisterReady()
	PetList_ClosePopup()
	
	Inventory_SetFunctor( InvenFiler_Mapae, PetFunction_Register, PetFunction_InventoryClose, nil )
	Inventory_ShowToggle()
	
	audioPostEvent_SystemUi(00,00)
end

function	PetFunction_Register( slotNo,  itemWrapper, count_s64, inventoryType )
	PetRegister_OpenByInventory( inventoryType, slotNo )
end

function	PetFunction_InventoryClose()
	Inventory_SetFunctor( nil )
end

function	PetFunction_Button_Exit()
	audioPostEvent_SystemUi(00,00)
	if	( not Panel_Window_PetFunction:IsShow() )	then
		return
	end

	PetList_ClosePopup()	
	
	local	self	= PetFunction
	self._buttonRegister:EraseAllEffect()
	
	SetUIMode( Defines.UIMode.eUIMode_NpcDialog )	-- 더 좋은 방법이 있기 전까지는 여기에서 UI Mode 를 변경해준다! - 성경
	setIgnoreShowDialog( false )
	
	Panel_Window_PetFunction:SetShow(false)

	InventoryWindow_Close()

	PetList_Close()
	PetInfo_Close()
	PetRegister_Close()
	PetMating_Close()
	
	Panel_Npc_Dialog:SetShow(true)
		
	local npcKey = dialog_getTalkNpcKey()
	if 0 ~= npcKey then
		closeClientChangeScene( npcKey )
	end

	local mainCameraName = Dialog_getMainSceneCameraName()
	changeCameraScene( mainCameraName, 0.5 )
end

----------------------------------------------------------------------------------------------------
-- Window Open/Close
function PetRegistration(isHave)
	if isHave then
		PetRegistration = true
	else
		PetRegistration = false
	end
end

function	PetFunction_RegisterAck()
	if false == Panel_Window_PetFunction:GetShow() then
		return
	end
	
	Inventory_SetFunctor( nil )
	InventoryWindow_Close()
	
	PetRegister_Close()
	
	local	self	= PetFunction
	self._buttonRegister:EraseAllEffect()
end

----------------------------------------------------------------------------------------------------
-- Window Open/Close
-- function	todoHavePetItem()
-- 	return (true)
-- end

function	PetFunction_Open()
	if	( Panel_Window_PetFunction:GetShow() )	then
		return
	end
	-- ♬ 애완동물이 열릴 때

	Servant_SceneOpen( Panel_Window_PetFunction )
	PetList_Open()
	
	-- Panel_Window_PetFunction:SetShow(true)
	
	-- PetFunction_ViewScene()
	
	local	self	= PetFunction
	if	( stable_doHaveRegisterItem() )	then
		local	messageboxTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
		local	messageboxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_PET_REGISTERITEM_MSG")
		local	messageboxData	= { title = messageboxTitle, content = messageboxMemo, functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData)
		self._buttonRegister:EraseAllEffect()
		self._buttonRegister:AddEffect("UI_ArrowMark01", true, 25, -38)
	else
		self._buttonRegister:EraseAllEffect()
	end

	if	stable_isMating()	then
		self._buttonMating:SetShow(true)
	end
	if	( stable_isMarket() )	then
		self._buttonMarket:SetShow(true)
	end
end

function	PetFunction_Close()	
	if	(not Panel_Window_PetFunction:IsShow() )	then
		return
	end
	-- ♬ 애완동물이 닫힐 때
	audioPostEvent_SystemUi(00,00)
	
	PetFunction._buttonRegister:EraseAllEffect()

	Inventory_SetFunctor( nil )
	InventoryWindow_Close()
	PetList_Close()
	PetMating_Close()
	PetMarket_Close()

	PetFunction_Button_Exit()
end 

function	PetFunction_Button_Mating()
	audioPostEvent_SystemUi(00,00)
	PetList_ButtonClose()

	PetMating_Open( CppEnums.AuctionType.AuctionGoods_ServantMating )
	audioPostEvent_SystemUi(01,00)
end

function PetFunction_Button_Market()
	audioPostEvent_SystemUi(00,00)
	PetList_ButtonClose()

	audioPostEvent_SystemUi(01,00)
	PetMarket_Open()
end

function PetFunction_Button_ListMarket()
	audioPostEvent_SystemUi(00,00)
	PetList_ClosePopup()

	StableMarket_Open()
	audioPostEvent_SystemUi(01,00)
end

function PetFunction_HideDialog()
	setIgnoreShowDialog( true )
	
	UIAni.fadeInSCR_Down(Panel_Window_PetFunction)
	Panel_Npc_Dialog:SetShow(false)
end

function PetFunction_ViewScene()
	local	npcKey	= dialog_getTalkNpcKey()
	if	( 0 ~= npcKey)	then
		openClientChangeScene( npcKey, 1 )

		local	funcCameraName	= Dialog_getFuncSceneCameraName()
		changeCameraScene( funcCameraName, 0.5 )
	end
end
----------------------------------------------------------------------------------------------------
-- Init

PetFunction:init()
PetFunction:registEventHandler()
PetFunction:registMessageHandler()

PetFunction_Resize()