local UI_TM = CppEnums.TextMode

local deliveryForGameExit =
{
	_buttonClose 			= UI.getChildControl ( Panel_Window_DeliveryForGameExit, "Button_Close" ),
	-- _buttonQuestion 		= UI.getChildControl ( Panel_Window_DeliveryForGameExit, "Button_Question" ),	-- 쿨음표 버튼
	_buttonGetOn 			= UI.getChildControl ( Panel_Window_DeliveryForGameExit, "Button_GetOn" ),
	
	_comboBoxDest			= UI.getChildControl ( Panel_Window_DeliveryForGameExit, "Combobox_Destination" ),
	_comboBoxSwapCharacter	= UI.getChildControl ( Panel_Window_DeliveryForGameExit, "Combobox_Character" ),
	
	_staticText_NoticeMsg 	= UI.getChildControl ( Panel_Window_DeliveryForGameExit, "StaticText_NoticeText" ),
	_staticText_NoticeAlert 	= UI.getChildControl ( Panel_Window_DeliveryForGameExit, "StaticText_Alert" ),
	
	_selectDestinationWaypointKey 	= -1,
	_selectDestCarriageKey			= -1,
	_selectCharacterIndex			= -1,
	
	_selectCharacterIndexPos = -1,
}

function deliveryForGameExit_Init()
	deliveryForGameExit._staticText_NoticeAlert:SetTextMode( UI_TM.eTextMode_AutoWrap )
	deliveryForGameExit._staticText_NoticeAlert:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_DELIVERYFORGAMEEXIT_ALERT") )
end

local changeDelayTime = -1.0
function delivery_GameExit_UpdatePerFrame( deltaTime )
	if changeDelayTime > 0.0 then
		changeDelayTime = changeDelayTime - deltaTime
		
		local remainTime = math.floor( changeDelayTime )
		if prevTime ~= remainTime then
			if 0 > remainTime then
				remainTime = 0
			end
			
			prevTime = remainTime
			deliveryForGameExit._staticText_NoticeMsg:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "Lua_deliveryPerson_ChangeMsg", "changeTime", tostring(remainTime) ) )
			if prevTime <= 0 then
				changeDelayTime = -1
				deliveryForGameExit._staticText_NoticeMsg:SetText( PAGetString( Defines.StringSheet_GAME, "Lua_deliveryPerson_GoChange" ) )
			end
		end
	end
end

function setPlayerDeliveryDelayTime( delayTime )
	if false == Panel_Window_DeliveryForGameExit:GetShow() then
		return
	end
	
	deliveryForGameExit._buttonGetOn:SetShow( false )
	deliveryForGameExit._staticText_NoticeMsg:SetShow( true )
	
	if 0.0 == delayTime then
		deliveryForGameExit._staticText_NoticeMsg:SetText( PAGetString( Defines.StringSheet_GAME, "Lua_deliveryPerson_GoChange" ) )
	else
		deliveryForGameExit._staticText_NoticeMsg:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "Lua_deliveryPerson_ChangeMsg", "changeTime", tostring(delayTime) ) )
	end

	changeDelayTime = delayTime
end

function deliveryForGameExit.fillData()
	local selfProxy = getSelfPlayer()
	if nil == selfProxy then
		return false
	end
	
	if true == selfProxy:get():isTradingPvpable() then
		Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "Lua_deliveryPerson_TradingPvPAble" ) ) --"황실 무역/납품 중에는 이동할 수 없습니다."
		return false
	end
	
	if toInt64( 0, 0 ) < selfProxy:get():getInventory():getTradeItemCount() then
		Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "Lua_deliveryPerson_HaveTradeItem" ) ) --"무역 아이템을 가진 상태에서는 이동 요청을 할 수 없습니다."
		return false
	end

	local characterNo_64 = toInt64( 0, 0 )
	characterNo_64 = selfProxy:getCharacterNo_64()

	deliveryForGameExit._comboBoxDest:DeleteAllItem()
	
	local deliveryPersonInfoList = ToClient_DeliveryPersonInfo()
	local deliverySize = deliveryPersonInfoList:size()
	if deliverySize < 0 then
		return
	end

	for kk = 0, deliverySize - 1 do
		local deliveryPersonInfo = deliveryPersonInfoList:atPointer( kk )
		local destinationRegionInfo = deliveryPersonInfo:getRegionInfo()
		local regionInfoWrapper = getRegionInfoWrapper(destinationRegionInfo._regionKey:get())
		deliveryForGameExit._comboBoxDest:AddItem( regionInfoWrapper:getAreaName() )
	end
		
	-- 현재 플레이어 운송도 아이템 운송과 같은 방식으로 이동하게 하려고 하기 때문에 같은 함수를 사용한다.
	deliveryForGameExit._comboBoxSwapCharacter:DeleteAllItem()
	local count = getCharacterDataCount()
	for idx = 0 , count - 1 do
		local characterData = getCharacterDataByIndex(idx)
		
		if ( nil == characterData ) then
			break
		end
		
		if characterNo_64 ~= characterData._characterNo_s64 then
			local	strLevel		= string.format( "%d", characterData._level )
			local	characterNameLv	= PAGetStringParam2( Defines.StringSheet_GAME, "CHARACTER_SELECT_LV", "character_level", strLevel, "character_name", getCharacterName(characterData) )

			deliveryForGameExit._comboBoxSwapCharacter:AddItem( characterNameLv )
		else
			deliveryForGameExit._selectCharacterIndexPos = idx
		end
	end
	
	return true
end

function deliveryForGameExit.resetData()
	deliveryForGameExit._selectDestinationWaypointKey = -1
	deliveryForGameExit._selectDestCarriageKey = -1
	deliveryForGameExit._selectCharacterIndex = -1
	
	--deliveryForGameExit._comboBoxDest:SetText( "abc" )
	deliveryForGameExit._comboBoxDest:DeleteAllItem()
	deliveryForGameExit._comboBoxDest:SetText( PAGetString( Defines.StringSheet_RESOURCE, "DELIVERY_PERSON_SELECT_DESTINATION"))
	deliveryForGameExit._comboBoxSwapCharacter:DeleteAllItem()
	deliveryForGameExit._comboBoxSwapCharacter:SetText( PAGetString( Defines.StringSheet_RESOURCE, "DELIVERY_PERSON_SELECT_CHANRACTER"))
end

function FGlobal_DeliveryForGameExit_Show( show )
	if true == show then
		local rv = deliveryForGameExit.fillData()
		if false == rv then
			return
		end
		--UI.Set_ProcessorInputMode(CppEnums.EProcessorInputMode.eProcessorInputMode_UiModeNotInput)
	else
		deliveryForGameExit.resetData()
		deliveryForGameExit._staticText_NoticeMsg:SetShow( false )
		--UI.Set_ProcessorInputMode(CppEnums.EProcessorInputMode.eProcessorInputMode_UiMode)
	end
	
	Panel_Window_DeliveryForGameExit:SetShow( show )
end

function click_DeliveryForGameExit_Close()
	if -1 ~= changeDelayTime then
		sendGameDelayExitCancel()
	end
	changeDelayTime = -1
	
	FGlobal_DeliveryForGameExit_Show( false )
	deliveryForGameExit._buttonGetOn:SetShow( true )
end


function click_DeliveryForGameExit_GetOn()
	-- local talkerNpc = dialog_getTalker()
	-- if nil == talkerNpc then
		-- UI.debugMessage( "nil talks" )
	-- end
	
	if -1 == deliveryForGameExit._selectDestinationWaypointKey then
		Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "Lua_deliveryPerson_NotDestination" ) )	-- "목적지가 설정되지 않았습니다."
		return
	end
	
	if -1 == deliveryForGameExit._selectCharacterIndex then
		Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "Lua_deliveryPerson_SelectCharacter" ) )		-- "교체할 캐릭터가 설정되지 않았습니다."
		return
	end
	
	local characterData = getCharacterDataByIndex(deliveryForGameExit._selectCharacterIndex)
	
	if nil == characterData then
		return
	end
	
	if characterData._level < 5 then
		NotifyDisplay( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GAMEEXIT_DONT_CHAGECHARACTER", "iLevel", 4 ) )
		return
	end
	
	local	removeTime	= getCharacterDataRemoveTime(deliveryForGameExit._selectCharacterIndex)
	if nil ~= removeTime then
		NotifyDisplay( PAGetString( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_CHARACTER_DELETE" ) )
		return
	end
	
	local preText = ""
	local serverUtc64 = getServerUtc64()
	if 0 ~= characterData._arrivalRegionKey:get() and serverUtc64 < characterData._arrivalTime then
		preText = PAGetString( Defines.StringSheet_GAME, "Lua_deliveryPerson_SelectPcDelivery2" ) .. "\n"
	end
	
	----------------------------------------
	-- 이동 예약의 전송 버튼을 누르면, 내용을 확인한다.
	-- DELIVERY_PERSON_READY_CHK
	-- 이동할 캐릭터 : {now_character}\n교체할 캐릭터 : {change_character}\n현재 캐릭터는 접속이 해제됩니다. \n이상 없습니까?
	-- PAGetStringParam2( Defines.StringSheet_RESOURCE, "DELIVERY_PERSON_READY_CHK", "now_character", getSelfPlayer():getName(), "change_character", getCharacterName(getCharacterDataByIndex(deliveryForGameExit._selectCharacterIndex)) )

	local messageContent    = preText .. PAGetStringParam2( Defines.StringSheet_RESOURCE, "DELIVERY_PERSON_READY_CHK", "now_character", getSelfPlayer():getName(), "change_character", getCharacterName(getCharacterDataByIndex(deliveryForGameExit._selectCharacterIndex)) )
	local messageboxData    = { title = PAGetString( Defines.StringSheet_GAME,"Lua_deliveryPerson_Information") , content = messageContent, functionYes = DeliveryForGameExit_YouSure, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
    	MessageBox.showMessageBox(messageboxData)
end

function DeliveryForGameExit_YouSure()
	-- 전송을 시작한다.
	deliveryPerson_SendReserve( deliveryForGameExit._selectDestinationWaypointKey )
end

---------------------------------------------------
-- Destination
function click_DeliveryForGameExit_Dest()
	deliveryForGameExit._comboBoxDest:ToggleListbox()

	local destList = deliveryForGameExit._comboBoxDest:GetListControl()
	destList:addInputEvent( "Mouse_LUp", "click_DeliveryForGameExit_DestList()" )
end

function click_DeliveryForGameExit_DestList()
	local destSelectIndex = deliveryForGameExit._comboBoxDest:GetSelectIndex()
	
	if -1 == destSelectIndex then
		return
	end
	
	local deliveryPersonInfoList = ToClient_DeliveryPersonInfo()
	local deliveryPersonInfo = deliveryPersonInfoList:atPointer( destSelectIndex )
	
	local destRegionInfo = deliveryPersonInfo:getRegionInfo()

	deliveryForGameExit._selectDestinationWaypointKey = destRegionInfo._regionKey:get()
	deliveryForGameExit._comboBoxDest:SetSelectItemIndex( destSelectIndex )
	deliveryForGameExit._comboBoxDest:ToggleListbox()
end

function on_DeliveryForGameExit_DestList()
	local onSelectIndex = deliveryForGameExit._comboBoxDest:GetSelectIndex()
	
	if -1 == onSelectIndex then
		return
	end
end

-------------------------------
-------------------------------------------------------
-- swapCharacter
function click_DeliveryForGameExit_SwapCharacter()
	deliveryForGameExit._comboBoxSwapCharacter:ToggleListbox()

	local swapCharacterList = deliveryForGameExit._comboBoxSwapCharacter:GetListControl()
	swapCharacterList:addInputEvent( "Mouse_LUp", "click_DeliveryForGameExit_SwapCharacterList()" )
end

function click_DeliveryForGameExit_SwapCharacterList()
	local characterSelectIndex = deliveryForGameExit._comboBoxSwapCharacter:GetSelectIndex()

	deliveryForGameExit._comboBoxSwapCharacter:SetSelectItemIndex( characterSelectIndex )
	deliveryForGameExit._comboBoxSwapCharacter:ToggleListbox()

	if deliveryForGameExit._selectCharacterIndexPos <= characterSelectIndex then
		characterSelectIndex = characterSelectIndex + 1
	end
	
	deliveryForGameExit._selectCharacterIndex = characterSelectIndex
end

function deliveryForGameExitChangeCharacter()
	if -1 == deliveryForGameExit._selectCharacterIndex then
		return
	end
	
	-- 운송은 안전 지역에서만 수행되어져야 합니다.
	local rv = swapCharacter_Select( deliveryForGameExit._selectCharacterIndex, true )
	if false == rv then
		return
	end
end
-------------------------------

local initialize = function()
	deliveryForGameExit._buttonClose:addInputEvent( "Mouse_LUp", "click_DeliveryForGameExit_Close()" )
	deliveryForGameExit._buttonGetOn:addInputEvent( "Mouse_LUp", "click_DeliveryForGameExit_GetOn()" )
	
	deliveryForGameExit._comboBoxDest:addInputEvent( "Mouse_LUp", "click_DeliveryForGameExit_Dest()" )
	deliveryForGameExit._comboBoxSwapCharacter:addInputEvent( "Mouse_LUp", "click_DeliveryForGameExit_SwapCharacter()" )
	
	registerEvent("EventDeliveryForPersonChangeCharacter", "deliveryForGameExitChangeCharacter()");
	registerEvent("EventGameExitDelayTime", "setPlayerDeliveryDelayTime")			-- gameExit 와 함께사용한다.
	
	Panel_Window_DeliveryForGameExit:RegisterUpdateFunc("delivery_GameExit_UpdatePerFrame")
end

initialize()
deliveryForGameExit_Init()