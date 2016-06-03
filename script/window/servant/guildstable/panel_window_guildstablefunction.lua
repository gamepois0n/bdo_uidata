Panel_Window_GuildStableFunction:SetShow(false, false)
Panel_Window_GuildStableFunction:setMaskingChild(true)
Panel_Window_GuildStableFunction:ActiveMouseEventEffect(true)
--Panel_Window_StableFunction:setGlassBackground(true)
Panel_Window_GuildStableFunction:RegisterShowEventFunc( true, '' )
Panel_Window_GuildStableFunction:RegisterShowEventFunc( false, '' )

local _stableBG = UI.getChildControl( Panel_Window_GuildStableFunction, 	"Static_StableTitle" )
_stableBG:setGlassBackground(true)

local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color
local IM			= CppEnums.EProcessorInputMode
local	guildStableFunction	= {
	config	=
	{
		
	},
	
	_buttonRegister	= UI.getChildControl( Panel_Window_GuildStableFunction,	"Button_RegisterByItem"	),	-- 등록( 마패 )
	_textRegist		= UI.getChildControl( Panel_Window_GuildStableFunction,	"StaticText_Purpose"	),	-- 등록 시 텍스트
	_buttonExit		= UI.getChildControl( Panel_Window_GuildStableFunction,	"Button_Exit"			),	-- 나가기 버튼
	
	_funcBtnCount	= 0,				-- 합성/나가기/마패등록은 기본 옵션
	_funcBtnRePos	= {},
}
----------------------------------------------------------------------------------------------------

-- Init Function
function	guildStableFunction:init()
	guildStableFunction._textRegist:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEFUNCTION_TEXTREGIST") ) -- "<PAColor0xFFFFCE22>마패<PAOldColor> 또는 <PAColor0xFFFFCE22>등록증<PAOldColor>을 우클릭해 축사에 등록해주세요" )
	guildStableFunction._textRegist:SetShow(false)
end

function guildStableFunction:registEventHandler()
	self._buttonRegister:addInputEvent(	"Mouse_LUp",	"GuildStableFunction_Button_RegisterReady()"	)
	self._buttonExit:addInputEvent(		"Mouse_LUp",	"GuildStableFunction_Close()"					)
end

function	guildStableFunction:registMessageHandler()
	registerEvent("onScreenResize",				"GuildStableFunction_Resize" )
	registerEvent("FromClient_ServantUpdate",	"GuildStableFunction_RegisterAck")
end

function	GuildStableFunction_Resize()
	local	self	= guildStableFunction
	
	local	screenX	= getScreenSizeX()
	local	screenY	= getScreenSizeY()

	Panel_Window_GuildStableFunction:SetSize(screenX, Panel_Window_GuildStableFunction:GetSizeY() )
	_stableBG:SetSize(screenX, Panel_Window_GuildStableFunction:GetSizeY() )
	
	Panel_Window_GuildStableFunction:ComputePos()
	_stableBG:ComputePos()
	self._buttonRegister:ComputePos()
	self._buttonExit:ComputePos()
	self._textRegist:ComputePos()
	self._textRegist:SetSpanSize( 0, - screenY * 3 / 4 )
end

----------------------------------------------------------------------------------------------------
-- Button Function
function	GuildStableFunction_Button_RegisterReady( slotNo )
	Inventory_SetFunctor( InvenFiler_Mapae, GuildStableFunction_Button_Register, Servant_InventoryClose, nil )
	Inventory_ShowToggle()
	
	audioPostEvent_SystemUi(00,00)
end

function	GuildStableFunction_Button_Register( slotNo, itemWrapper, count_s64, inventoryType )
	GuildStableRegister_OpenByInventory( inventoryType, slotNo )
end

----------------------------------------------------------------------------------------------------
-- FromClient Function
function	GuildStableFunction_RegisterAck()
	if GetUIMode() == Defines.UIMode.eUIMode_Default then
		return
	end

	if false == Panel_Window_GuildStable_List:GetShow() then
		return
	end
	
	Inventory_SetFunctor( nil )
	InventoryWindow_Close()
	
	-- GuildStableRegister_Close()
	
	local	self	= guildStableFunction
	self._buttonRegister:EraseAllEffect()
end

----------------------------------------------------------------------------------------------------
-- Window Open/Close
function	GuildStableFunction_Open()
	local	self	= guildStableFunction

	--리스트 요청
	guildstable_listGuildServant()
	
	-- ♬ 마구간이 열릴때
	Servant_SceneOpen( Panel_Window_GuildStableFunction )
	
	GuildStableList_Open()
	
	-- 버튼 위치 선정
	GuildStablefuncButtonRePosition()
	
	-- 아이템이 있으면 등록하시오 메시지 출력
	FGlobal_NeedGuildStableRegistItem_Print()
end

function	GuildStablefuncButtonRePosition()
	local	self	= guildStableFunction
	
	self._funcBtnRePos = {}
	self._funcBtnCount = 0
	
	if	( stable_doHaveRegisterItem() )	then -- (태곤) 작업 필요
		local	messageboxTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
		local	messageboxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_REGISTERITEM_MSG")
		local	messageboxData	= { title = messageboxTitle, content = messageboxMemo, functionApply = FGlobal_NeedStableRegistItem_Print, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData)
		-- UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)

		self._buttonRegister:EraseAllEffect()
		self._buttonRegister:AddEffect("UI_ArrowMark01", true, 25, -38)
	else
		self._buttonRegister:EraseAllEffect()
	end

	self._funcBtnRePos[self._funcBtnCount] = self._buttonRegister
	self._funcBtnCount = self._funcBtnCount + 1
	
	self._funcBtnRePos[self._funcBtnCount] = self._buttonExit
	self._funcBtnCount = self._funcBtnCount + 1
	
	local	gapX		= 16
	local	startPosX	= getScreenSizeX()/2 - ( guildStableFunction._buttonExit:GetSizeX() / 2 * self._funcBtnCount + ( self._funcBtnCount - 1 ) * gapX )
	for index = 0, self._funcBtnCount - 1 do
		self._funcBtnRePos[index]:SetPosX( startPosX + index * ( guildStableFunction._buttonExit:GetSizeX() + gapX ) )
	end
end

function FGlobal_NeedGuildStableRegistItem_Print()
	local	self	= guildStableFunction
	
	if	( stable_doHaveRegisterItem() )	then -- (태곤) 작업 필요
		self._textRegist:SetShow( true )
	else
		self._textRegist:SetShow( false )
	end
end

function GuildStableFunction_Close()
	-- ♬ 마구간이 닫힐 때
	audioPostEvent_SystemUi(00,00)

	local	self	= guildStableFunction
	self._buttonRegister:EraseAllEffect()

	InventoryWindow_Close()
	GuildStableList_Close()
	
	if	( not Panel_Window_GuildStableFunction:GetShow() )	then
		return
	end
	
	Servant_SceneClose( Panel_Window_GuildStableFunction )
	Dialog_updateButtons( true )			-- 마패를 사용한 후 다시 마패 있는지 체크해서 마굿간 버튼에 이펙트 부여 여부 결정
end

guildStableFunction:init()
guildStableFunction:registEventHandler()
guildStableFunction:registMessageHandler()
GuildStableFunction_Resize()