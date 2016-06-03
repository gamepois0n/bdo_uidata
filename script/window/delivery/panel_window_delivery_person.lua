
local deliveryForPerson =
{
	_buttonClose 			= UI.getChildControl ( Panel_Window_DeliveryForPerson, "Button_Close" ),
	_buttonQuestion 		= UI.getChildControl ( Panel_Window_DeliveryForPerson, "Button_Question" ),	-- 쿨음표 버튼
	_buttonGetOn 			= UI.getChildControl ( Panel_Window_DeliveryForPerson, "Button_GetOn" ),
	
	_comboBoxDest			= UI.getChildControl ( Panel_Window_DeliveryForPerson, "Combobox_Destination" ),
	_comboBoxCarriage		= UI.getChildControl ( Panel_Window_DeliveryForPerson, "Combobox_Carriage" ),
	_comboBoxSwapCharacter	= UI.getChildControl ( Panel_Window_DeliveryForPerson, "Combobox_Character" ),
	
	_staticText_NoticeMsg 	= UI.getChildControl ( Panel_Window_DeliveryForPerson, "StaticText_NoticeText" ),
	_staticText_NoticeAlert 	= UI.getChildControl ( Panel_Window_DeliveryForPerson, "StaticText_Alert" ),
	
	_selectDestinationWaypointKey 	= -1,
	_selectDestCarriageKey			= -1,
	_selectCharacterIndex			= -1,
	
	_carriageList ={},
	_selectCharacterIndexPos = -1,
}

local changeDelayTime = -1.0
function delivery_Person_UpdatePerFrame( deltaTime )
	if changeDelayTime > 0.0 then
		changeDelayTime = changeDelayTime - deltaTime
		
		local remainTime = math.floor( changeDelayTime )
		if prevTime ~= remainTime then
			if 0 > remainTime then
				remainTime = 0
			end
			
			prevTime = remainTime
			--deliveryForPerson._staticText_NoticeMsg:SetText( PAGetString( Defines.StringSheet_GAME, "Lua_deliveryPerson_GoChange" ) )
			deliveryForPerson._staticText_NoticeMsg:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "Lua_deliveryPerson_ChangeMsg", "changeTime", tostring(remainTime) ) )
			if prevTime <= 0 then
				changeDelayTime = -1
				--deliveryForPerson._staticText_NoticeMsg:SetShow( false )
				deliveryForPerson._staticText_NoticeMsg:SetText( PAGetString( Defines.StringSheet_GAME, "Lua_deliveryPerson_GoChange" ) )
			end
		end
	end
end

function setPlayerDeliveryDelayTime( delayTime )
	if false == Panel_Window_DeliveryForPerson:GetShow() then
		return
	end
	
	deliveryForPerson._buttonGetOn:SetShow( false )
	deliveryForPerson._staticText_NoticeMsg:SetShow( true )
	deliveryForPerson._staticText_NoticeMsg:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "Lua_deliveryPerson_ChangeMsg", "changeTime", tostring(delayTime) ) )

	changeDelayTime = delayTime
end

function deliveryForPerson.fillData()
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

	deliveryForPerson._comboBoxDest:DeleteAllItem()
	-- 현재 플레이어 운송도 아이템 운송과 같은 방식으로 이동하게 하려고 하기 때문에 같은 함수를 사용한다.
	local	waypointKeyList		= delivery_listWaypointKey( getCurrentWaypointKey(), true )
	if nil == waypointKeyList then
		return false
	end
	local	size				= waypointKeyList:size()
	for count = 1, size do
		deliveryForPerson._comboBoxDest:AddItem( waypointKeyList:atPointer(count-1):getName() )
		--UI.debugMessage( "waypointKeyList:atPointer(count-1):getName() : " .. waypointKeyList:atPointer(count-1):getName() )
	end
	
	--UI.debugMessage( "characterNo_64 : " .. tostring( characterNo_64 ) )
	deliveryForPerson._comboBoxCarriage:DeleteAllItem()
	deliveryForPerson._comboBoxSwapCharacter:DeleteAllItem()
	local count = getCharacterDataCount()
	for idx = 0 , count - 1 do
		local characterData = getCharacterDataByIndex(idx)
		
		if ( nil == characterData ) then
			break
		end
		
		if characterNo_64 ~= characterData._characterNo_s64 then
			local	strLevel		= string.format( "%d", characterData._level )
			local	characterNameLv	= PAGetStringParam2( Defines.StringSheet_GAME, "CHARACTER_SELECT_LV", "character_level", strLevel, "character_name", getCharacterName(characterData) )

			deliveryForPerson._comboBoxSwapCharacter:AddItem( characterNameLv )
		else
			deliveryForPerson._selectCharacterIndexPos = idx
		end
	end
	
	return true
end

function deliveryForPerson.resetData()
	deliveryForPerson._selectDestinationWaypointKey = -1
	deliveryForPerson._selectDestCarriageKey = -1
	deliveryForPerson._selectCharacterIndex = -1
	
	--deliveryForPerson._comboBoxDest:SetText( "abc" )
	deliveryForPerson._comboBoxDest:DeleteAllItem()
	deliveryForPerson._comboBoxDest:SetText( PAGetString( Defines.StringSheet_RESOURCE, "DELIVERY_PERSON_SELECT_DESTINATION"))
	deliveryForPerson._comboBoxCarriage:DeleteAllItem()
	deliveryForPerson._comboBoxCarriage:SetText( PAGetString( Defines.StringSheet_RESOURCE, "DELIVERY_PERSON_SELECT_CARRIAGE"))
	deliveryForPerson._comboBoxSwapCharacter:DeleteAllItem()
	deliveryForPerson._comboBoxSwapCharacter:SetText( PAGetString( Defines.StringSheet_RESOURCE, "DELIVERY_PERSON_SELECT_CHANRACTER"))
end

function panel_DeliveryForPorson_Show( show )
	if true == show then
		local rv = deliveryForPerson.fillData()
		if false == rv then
			return
		end
		--UI.Set_ProcessorInputMode(CppEnums.EProcessorInputMode.eProcessorInputMode_UiModeNotInput)
	else
		deliveryForPerson.resetData()
		deliveryForPerson._staticText_NoticeMsg:SetShow( false )
		--UI.Set_ProcessorInputMode(CppEnums.EProcessorInputMode.eProcessorInputMode_UiMode)
	end
	
	Panel_Window_DeliveryForPerson:SetShow( show )
end

function click_DeliveryForPerson_Close()
	if -1 ~= changeDelayTime then
		sendGameDelayExitCancel()
	end
	changeDelayTime = -1
	
	panel_DeliveryForPorson_Show( false )
	deliveryForPerson._buttonGetOn:SetShow( true )
end


function click_DeliveryForPerson_GetOn()
	local talkerNpc = dialog_getTalker()
	if nil == talkerNpc then
		UI.debugMessage( "nil talks" )
	end
	
	if -1 == deliveryForPerson._selectDestinationWaypointKey then
		Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "Lua_deliveryPerson_NotDestination" ) )	-- "목적지가 설정되지 않았습니다."
		return
	end
	
	if -1 == deliveryForPerson._selectDestCarriageKey then
		Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "Lua_deliveryPerson_SelectMove" ) )	-- "운송 수단이 설정되지 않았습니다."
		return
	end
	
	if -1 == deliveryForPerson._selectCharacterIndex then
		Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "Lua_deliveryPerson_SelectCharacter" ) )		-- "교체할 캐릭터가 설정되지 않았습니다."
		return
	end
	
	local characterData = getCharacterDataByIndex(deliveryForPerson._selectCharacterIndex)
	
	if nil == characterData then
		return
	end
	
	if characterData._level < 5 then
		NotifyDisplay( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GAMEEXIT_DONT_CHAGECHARACTER", "iLevel", 4 ) )
		return
	end
	
	local	removeTime	= getCharacterDataRemoveTime(deliveryForPerson._selectCharacterIndex)
	if nil ~= removeTime then
		NotifyDisplay( PAGetString( Defines.StringSheet_GAME, "GAMEEXIT_TEXT_CHARACTER_DELETE" ) )
		return
	end
	--_PA_LOG( "KKK", "name : " .. getCharacterName(characterData) )
	
	----------------------------------------
	-- 이동 예약의 전송 버튼을 누르면, 내용을 확인한다.
	-- DELIVERY_PERSON_READY_CHK
	-- 이동할 캐릭터 : {now_character}\n교체할 캐릭터 : {change_character}\n현재 캐릭터는 접속이 해제됩니다. \n이상 없습니까?
	-- PAGetStringParam2( Defines.StringSheet_RESOURCE, "DELIVERY_PERSON_READY_CHK", "now_character", getSelfPlayer():getName(), "change_character", getCharacterName(getCharacterDataByIndex(deliveryForPerson._selectCharacterIndex)) )

	local messageContent    = PAGetStringParam2( Defines.StringSheet_RESOURCE, "DELIVERY_PERSON_READY_CHK", "now_character", getSelfPlayer():getName(), "change_character", getCharacterName(getCharacterDataByIndex(deliveryForPerson._selectCharacterIndex)) )
	local messageboxData    = { title = PAGetString( Defines.StringSheet_GAME,"Lua_deliveryPerson_Information") , content = messageContent, functionYes = DeliveryForPerson_YouSure, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
    	MessageBox.showMessageBox(messageboxData)

end

function DeliveryForPerson_YouSure()
	-- 전송을 시작한다.
	deliveryPerson_SendReserve( deliveryForPerson._selectDestinationWaypointKey, deliveryForPerson._selectDestCarriageKey, dialog_getTalker():getActorKey() )
end

---------------------------------------------------
-- Destination
function click_DeliveryForPerson_Dest()
	deliveryForPerson._comboBoxDest:ToggleListbox()

	local destList = deliveryForPerson._comboBoxDest:GetListControl()
	destList:addInputEvent( "Mouse_LUp", "click_DeliveryForPerson_DestList()" )
end

function click_DeliveryForPerson_DestList()
	local DestSelectIndex = deliveryForPerson._comboBoxDest:GetSelectIndex()
	
	if -1 == DestSelectIndex then
		return
	end

	local currentWaypointKey	= getCurrentWaypointKey()
	local waypointKeyList		= delivery_listWaypointKey( currentWaypointKey, true )
	local destWaypointKey = waypointKeyList:atPointer(DestSelectIndex):getWaypointKey()
	deliveryForPerson._selectDestinationWaypointKey = destWaypointKey
	--UI.debugMessage( "deliveryForPerson._selectDestinationWaypointKey : " .. deliveryForPerson._selectDestinationWaypointKey )
	
	deliveryForPerson._comboBoxDest:SetSelectItemIndex( DestSelectIndex )
	deliveryForPerson._comboBoxDest:ToggleListbox()
	
	-- 운송 종류 리스트 갱신
	local carriageList 	= delivery_listCarriage( currentWaypointKey, deliveryForPerson._selectDestinationWaypointKey, true )
	
	if nil == carriageList then
		return
	end
	
	local size		  	= carriageList:size()

	deliveryForPerson._comboBoxCarriage:DeleteAllItem()
	deliveryForPerson._carriageList = nil

	for ii=0, size-1	do
		local carriageData = carriageList:atPointer(ii)
		deliveryForPerson._comboBoxCarriage:AddItem( carriageData:getName() )
		deliveryForPerson._carriageList[ii] = carriageData:getCharacterKeyRaw()
	end
end

function on_DeliveryForPerson_DestList()
	local onSelectIndex = deliveryForPerson._comboBoxDest:GetSelectIndex()
	
	if -1 == onSelectIndex then
		return
	end
		--local backStatic = deliveryForPerson._comboBoxDest:getSelectBackStatic()
		--backStatic:SetPosX()
		--backStatic:SetPosY()
end
--------------------------------
------------------------------------------------------
-- Carriage
function click_DeliveryForPerson_Carriage()
	deliveryForPerson._comboBoxCarriage:ToggleListbox()
	
	local characterList = deliveryForPerson._comboBoxCarriage:GetListControl()
	characterList:addInputEvent( "Mouse_LUp", "click_DeliveryForPerson_CarriageList()" )
end

function click_DeliveryForPerson_CarriageList()
	local carriageSelectIndex = deliveryForPerson._comboBoxCarriage:GetSelectIndex()
	
	-- if nil == deliveryForPerson._carriageList then
		-- UI.debugMessage( "deliveryForPerson._carriageList : nil" )
		-- return
	-- end
	
	-- if #deliveryForPerson._carriageList <= carriageSelectIndex then
		-- UI.debugMessage( "이상하다. carriageSelectIndex :" .. carriageSelectIndex )
		-- return
	-- end
	
	--UI.debugMessage( "carriageSelectIndex : " .. carriageSelectIndex )
	
	deliveryForPerson._comboBoxCarriage:SetSelectItemIndex( carriageSelectIndex )
	deliveryForPerson._comboBoxCarriage:ToggleListbox()

	deliveryForPerson._selectDestCarriageKey = deliveryForPerson._carriageList[ carriageSelectIndex ]
end
-------------------------------
-------------------------------------------------------
-- swapCharacter
function click_DeliveryForPerson_SwapCharacter()
	deliveryForPerson._comboBoxSwapCharacter:ToggleListbox()

	local swapCharacterList = deliveryForPerson._comboBoxSwapCharacter:GetListControl()
	swapCharacterList:addInputEvent( "Mouse_LUp", "click_DeliveryForPerson_SwapCharacterList()" )
end

function click_DeliveryForPerson_SwapCharacterList()
	local characterSelectIndex = deliveryForPerson._comboBoxSwapCharacter:GetSelectIndex()

	deliveryForPerson._comboBoxSwapCharacter:SetSelectItemIndex( characterSelectIndex )
	deliveryForPerson._comboBoxSwapCharacter:ToggleListbox()

	if deliveryForPerson._selectCharacterIndexPos <= characterSelectIndex then
		characterSelectIndex = characterSelectIndex + 1
	end
	
	deliveryForPerson._selectCharacterIndex = characterSelectIndex
end

function deliveryForPersonChangeCharacter()
	if -1 == deliveryForPerson._selectCharacterIndex then
		return
	end
	
	-- 운송은 안전 지역에서만 수행되어져야 합니다.
	local rv = swapCharacter_Select( deliveryForPerson._selectCharacterIndex, true )
	if false == rv then
		return
	end
end
-------------------------------

local initialize = function()
	deliveryForPerson._buttonClose:addInputEvent( "Mouse_LUp", "click_DeliveryForPerson_Close()" )
	deliveryForPerson._buttonQuestion:addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"DeliveryPerson\" )" )						-- 물음표 좌클릭
	deliveryForPerson._buttonQuestion:addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"DeliveryPerson\", \"true\")" )	-- 물음표 마우스오버
	deliveryForPerson._buttonQuestion:addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"DeliveryPerson\", \"false\")" )	-- 물음표 마우스아웃
	deliveryForPerson._buttonGetOn:addInputEvent( "Mouse_LUp", "click_DeliveryForPerson_GetOn()" )
	
	deliveryForPerson._comboBoxDest:addInputEvent( "Mouse_LUp", "click_DeliveryForPerson_Dest()" )
	deliveryForPerson._comboBoxCarriage:addInputEvent( "Mouse_LUp", "click_DeliveryForPerson_Carriage()" )
	deliveryForPerson._comboBoxSwapCharacter:addInputEvent( "Mouse_LUp", "click_DeliveryForPerson_SwapCharacter()" )
	
	registerEvent("EventDeliveryForPersonChangeCharacter", "deliveryForPersonChangeCharacter()");
	registerEvent("EventGameExitDelayTime", "setPlayerDeliveryDelayTime")			-- gameExit 와 함께사용한다.
	
	Panel_Window_DeliveryForPerson:RegisterUpdateFunc("delivery_Person_UpdatePerFrame")
end

initialize()


