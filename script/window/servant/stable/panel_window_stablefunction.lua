Panel_Window_StableFunction:SetShow(false, false)
Panel_Window_StableFunction:setMaskingChild(true)
Panel_Window_StableFunction:ActiveMouseEventEffect(true)
--Panel_Window_StableFunction:setGlassBackground(true)
Panel_Window_StableFunction:RegisterShowEventFunc( true, '' )
Panel_Window_StableFunction:RegisterShowEventFunc( false, '' )

local _stableBG = UI.getChildControl( Panel_Window_StableFunction, 	"Static_StableTitle" )
_stableBG:setGlassBackground(true)

local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color
local IM			= CppEnums.EProcessorInputMode
local	stableFunction	= {
	config	=
	{
		
	},
	
	_buttonRegister	= UI.getChildControl( Panel_Window_StableFunction,	"Button_RegisterByItem"	),	-- 등록( 마패 )
	_textRegist		= UI.getChildControl( Panel_Window_StableFunction,	"StaticText_Purpose"	),	-- 등록 시 텍스트
	_buttonMix		= UI.getChildControl( Panel_Window_StableFunction,	"Button_HorseMix"		),	-- 합성
	_buttonMating	= UI.getChildControl( Panel_Window_StableFunction, 	"Button_ListMating"		),	-- 교배소 보기
	_buttonMarket	= UI.getChildControl( Panel_Window_StableFunction, 	"Button_ListMarket"		),	-- 마시장 보기
	_buttonExit		= UI.getChildControl( Panel_Window_StableFunction,	"Button_Exit"			),	-- 나가기 버튼
	_buttonLink		= UI.getChildControl( Panel_Window_StableFunction,	"Button_HorseLink"		),	-- 말 링크
}
----------------------------------------------------------------------------------------------------

-- Init Function
function	stableFunction:init()
	stableFunction._textRegist:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_STABLEFUNCTION_TEXTREGIST") ) -- "<PAColor0xFFFFCE22>마패<PAOldColor> 또는 <PAColor0xFFFFCE22>등록증<PAOldColor>을 우클릭해 축사에 등록해주세요" )
	stableFunction._textRegist:SetShow(false)
end

function stableFunction:SetBtnPosition()
	local btnRegisterSizeX			= self._buttonRegister:GetSizeX()+23
	local btnRegisterTextPosX		= (btnRegisterSizeX - (btnRegisterSizeX/2) - ( self._buttonRegister:GetTextSizeX() / 2 ))
	local btnMixSizeX				= self._buttonMix:GetSizeX()+23
	local btnMixTextPosX			= (btnMixSizeX - (btnMixSizeX/2) - ( self._buttonMix:GetTextSizeX() / 2 ))
	local btnMatingSizeX			= self._buttonMating:GetSizeX()+23
	local btnMatingTextPosX			= (btnMatingSizeX - (btnMatingSizeX/2) - ( self._buttonMating:GetTextSizeX() / 2 ))
	local btnMarketSizeX			= self._buttonMarket:GetSizeX()+23
	local btnMarketTextPosX			= (btnMarketSizeX - (btnMarketSizeX/2) - ( self._buttonMarket:GetTextSizeX() / 2 ))
	local btnExitSizeX				= self._buttonExit:GetSizeX()+23
	local btnExitTextPosX			= (btnExitSizeX - (btnExitSizeX/2) - ( self._buttonExit:GetTextSizeX() / 2 ))
	local btnLinkSizeX				= self._buttonLink:GetSizeX()+23
	local btnLinkTextPosX			= (btnLinkSizeX - (btnLinkSizeX/2) - ( self._buttonLink:GetTextSizeX() / 2 ))

	self._buttonRegister				:SetTextSpan( btnRegisterTextPosX, 5 )
	self._buttonMix						:SetTextSpan( btnMixTextPosX, 5 )
	self._buttonMating					:SetTextSpan( btnMatingTextPosX, 5 )
	self._buttonMarket					:SetTextSpan( btnMarketTextPosX, 5 )
	self._buttonExit					:SetTextSpan( btnExitTextPosX, 5 )
	self._buttonLink					:SetTextSpan( btnLinkTextPosX, 5 )
end

function stableFunction:registEventHandler()
	self._buttonRegister:addInputEvent(	"Mouse_LUp",	"StableFunction_Button_RegisterReady()"	)
	self._buttonMating:addInputEvent(	"Mouse_LUp",	"StableFunction_Button_Mating()"		)
	self._buttonMarket:addInputEvent(	"Mouse_LUp",	"StableFunction_Button_Market()"		)
	self._buttonMix:addInputEvent(		"Mouse_LUp",	"StableFunction_Button_Mix()"			)
	self._buttonLink:addInputEvent(		"Mouse_LUp",	"StableFunction_Button_Link()"			)
	self._buttonExit:addInputEvent(		"Mouse_LUp",	"StableFunction_Close()"				)
end

function	stableFunction:registMessageHandler()
	registerEvent("onScreenResize",				"StableFunction_Resize" )
	registerEvent("FromClient_ServantUpdate",	"StableFunction_RegisterAck")
end

function	StableFunction_Resize()
	local	self	= stableFunction
	
	local	screenX	= getScreenSizeX()
	local	screenY	= getScreenSizeY()

	Panel_Window_StableFunction:SetSize(screenX, Panel_Window_StableFunction:GetSizeY() )
	_stableBG:SetSize(screenX, Panel_Window_StableFunction:GetSizeY() )
	
	Panel_Window_StableFunction:ComputePos()
	_stableBG:ComputePos()
	self._buttonRegister:ComputePos()
	self._buttonMating:ComputePos()
	self._buttonMarket:ComputePos()
	self._buttonMix:ComputePos()
	self._buttonExit:ComputePos()
	self._textRegist:ComputePos()
	self._buttonMix:ComputePos()
	self._textRegist:SetSpanSize( 0, - screenY * 3 / 4 )
end

----------------------------------------------------------------------------------------------------
-- Button Function
function	StableFunction_Button_RegisterReady( slotNo )
	-- if Panel_Win_System:GetShow() then
	-- 	return
	-- end

	if Panel_Window_StableMarket:GetShow() then
		StableMarket_Close()
	end
	if Panel_Window_StableMating:GetShow() then
		StableMating_Close()
	end
	if Panel_Window_StableMix:GetShow() then
		StableMix_Close()
	end
	Inventory_SetFunctor( InvenFiler_Mapae, StableFunction_Button_Register, Servant_InventoryClose, nil )
	Inventory_ShowToggle()
	
	audioPostEvent_SystemUi(00,00)
end

function	StableFunction_Button_Register( slotNo, itemWrapper, count_s64, inventoryType )
	StableRegister_OpenByInventory( inventoryType, slotNo )
end

function	StableFunction_Button_Mating()
	-- if Panel_Win_System:GetShow() then
	-- 	return
	-- end

	audioPostEvent_SystemUi(00,00)
	StableList_ButtonClose()

	audioPostEvent_SystemUi(01,00)
	StableMating_Open( CppEnums.AuctionType.AuctionGoods_ServantMating )
end

function	StableFunction_Button_Market()
	-- if Panel_Win_System:GetShow() then
	-- 	return
	-- end

	audioPostEvent_SystemUi(00,00)
	StableList_ButtonClose()

	audioPostEvent_SystemUi(01,00)
	StableMarket_Open()
end

function	StableFunction_Button_Mix()
	-- if Panel_Win_System:GetShow() then
	-- 	return
	-- end

	StableList_ButtonClose()
	
	StableMix_Open()
end

function	StableFunction_Button_Link()
	-- if Panel_Win_System:GetShow() then
	-- 	return
	-- end

	StableList_ButtonClose()
	
	stableCarriage_Open()
end

----------------------------------------------------------------------------------------------------
-- FromClient Function
function	StableFunction_RegisterAck()
	if GetUIMode() == Defines.UIMode.eUIMode_Default then
		return
	end

	if false == Panel_Window_StableList:GetShow() then
		return
	end

	Inventory_SetFunctor( nil )
	InventoryWindow_Close()
	
	StableRegister_Close()
	
	local	self	= stableFunction
	self._buttonRegister:EraseAllEffect()
end

----------------------------------------------------------------------------------------------------
-- Window Open/Close
local funcBtnCount = 0				-- 합성/나가기/마패등록은 기본 옵션
local funcBtnRePos = {}
function	StableFunction_Open()
	if	( not stable_doHaveRegisterItem() )	then
		stableFunction._textRegist:SetShow( false )
	end

	if	( Panel_Window_StableFunction:GetShow() )	then
		-- return
	end

	-- ♬ 마구간이 열릴때

	Servant_SceneOpen( Panel_Window_StableFunction )

	StableList_Open()

	stableFunction._textRegist:SetShow( false )
	stableFunction:SetBtnPosition()

	funcBtnRePos = {}
	funcBtnCount = 0
	
	local self			= stableFunction
	local talker		= dialog_getTalker()
	local npcActorproxy = talker:get()
	local npcPosition	= npcActorproxy:getPosition()
	local npcRegionInfo	= getRegionInfoByPosition(npcPosition)
	
	local horseCheck = false			-- 마차에 붙일 수 있는 말인지 체크
	local carriageCheck = false			-- 마차에 말을 붙일 공간이 있는지 체크
	local isCarriage = false
	for index = 0, stable_count() -1 do
		local servantInfo = stable_getServant( index )
		if npcRegionInfo:getAreaName() == servantInfo:getRegionName() then			-- NPC와 리전이 같은 곳의 서번트만 체크
			local	isUnLinkedHorse	= not servantInfo:isLink() and (CppEnums.VehicleType.Type_Horse == servantInfo:getVehicleType())
			if isUnLinkedHorse then
				horseCheck = true
			end
			
			if CppEnums.VehicleType.Type_Carriage == servantInfo:getVehicleType() then
				local maxLinkCount = servantInfo:getLinkCount()
				local currentLinkCount = servantInfo:getCurrentLinkCount()
				if currentLinkCount < maxLinkCount then
					carriageCheck = true
				end
				isCarriage = true
			end
		end
	end
	
	-- if horseCheck and carriageCheck then				-- 업데이트 시점이 맞지 않음
		-- self._buttonLink:SetShow(true)
		-- funcBtnCount = funcBtnCount + 1
	-- else
		-- self._buttonLink:SetShow(false)
	-- end
	
	-- if isCarriage then
		self._buttonLink:SetShow(true)
		funcBtnRePos[funcBtnCount] = self._buttonLink
		funcBtnCount = funcBtnCount + 1
	-- else
		-- self._buttonLink:SetShow(false)
	-- end
	self._buttonMix:SetShow( true )
	funcBtnRePos[funcBtnCount] = self._buttonMix
	funcBtnCount = funcBtnCount + 1
	
	self._buttonMating:SetShow(false)
	self._buttonMarket:SetShow(false)
	if	( stable_isMating() )	then
		self._buttonMating:SetShow(true)
		funcBtnRePos[funcBtnCount] = self._buttonMating
		funcBtnCount = funcBtnCount + 1
	end
	if	( stable_isMarket() )	then
		self._buttonMarket:SetShow(true)
		funcBtnRePos[funcBtnCount] = self._buttonMarket
		funcBtnCount = funcBtnCount + 1
	end
	
	if	( stable_doHaveRegisterItem() )	then
		local	messageboxTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
		local	messageboxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_REGISTERITEM_MSG")
		local	messageboxData	= { title = messageboxTitle, content = messageboxMemo, functionApply = FGlobal_NeedStableRegistItem_Print, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData)
		-- UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)

		stableFunction._buttonRegister:EraseAllEffect()
		stableFunction._buttonRegister:AddEffect("UI_ArrowMark01", true, 25, -38)
	else
		stableFunction._buttonRegister:EraseAllEffect()
	end
	
	funcBtnRePos[funcBtnCount] = self._buttonRegister
	funcBtnCount = funcBtnCount + 1
	
	funcBtnRePos[funcBtnCount] = self._buttonExit
	funcBtnCount = funcBtnCount + 1

	funcButtonRePosition(funcBtnCount)
end

function funcButtonRePosition(funcBtnCount)
	local gapX = 16
	local startPosX = getScreenSizeX()/2 - ( stableFunction._buttonExit:GetSizeX() / 2 * funcBtnCount + ( funcBtnCount - 1 ) * gapX )
	
	for index = 0, funcBtnCount - 1 do
		funcBtnRePos[index]:SetPosX( startPosX + index * ( stableFunction._buttonExit:GetSizeX() + gapX ) )
	end
end

function FGlobal_NeedStableRegistItem_Print()
	if	( stable_doHaveRegisterItem() )	then
		stableFunction._textRegist:SetShow( true )
	else
		stableFunction._textRegist:SetShow( false )
	end
end

function	StableFunction_Close()
	-- if Panel_Win_System:GetShow() then
	-- 	return
	-- end
	
	-- ♬ 마구간이 닫힐 때
	audioPostEvent_SystemUi(00,00)

	local	self	= stableFunction
	self._buttonRegister:EraseAllEffect()

	InventoryWindow_Close()
	StableList_Close()
	StableInfo_Close()
	--StableInfoWindow_Close()
	--StableEquipInfoWindow_Hide()
	--StableRegister_Close()
	StableShop_Close()
	StableMating_Close()
	StableMarket_Close()
	StableMix_Close()
	
	if	( not Panel_Window_StableFunction:GetShow() )	then
		return
	end
	
	Servant_SceneClose( Panel_Window_StableFunction )
	Dialog_updateButtons( true )			-- 마패를 사용한 후 다시 마패 있는지 체크해서 마굿간 버튼에 이펙트 부여 여부 결정
end

stableFunction:init()
stableFunction:registEventHandler()
stableFunction:registMessageHandler()

StableFunction_Resize()