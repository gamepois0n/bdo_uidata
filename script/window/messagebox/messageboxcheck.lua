local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE

Panel_Win_Check:RegisterShowEventFunc( true, 'MessageBoxCheck_ShowAni()' )
Panel_Win_Check:RegisterShowEventFunc( false, 'MessageBoxCheck_HideAni()' )

---------------------------
-- Panel Init
---------------------------
Panel_Win_Check:SetShow(false, false)
Panel_Win_Check:setMaskingChild(true)
Panel_Win_Check:setGlassBackground(true)
---------------------------
-- Local Variables
---------------------------
local UI_TM 		= CppEnums.TextMode
local UI_PP	 		= CppEnums.PAUIMB_PRIORITY
local UI_color 		= Defines.Color
local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE

local textTitle 		= UI.getChildControl(Panel_Win_Check, "Static_Text_Title")
local textBG 			= UI.getChildControl(Panel_Win_Check, "Static_Text")
local textContent 		= UI.getChildControl(Panel_Win_Check, "StaticText_Content")
local buttonApply 		= UI.getChildControl(Panel_Win_Check, "Button_Apply")
local buttonCancel 		= UI.getChildControl(Panel_Win_Check, "Button_Cancel")
local buttonClose 		= UI.getChildControl(Panel_Win_Check, "Button_Close")

local iconInven			= UI.getChildControl(Panel_Win_Check, "RadioButton_Icon_Inven")
local iconWarehouse		= UI.getChildControl(Panel_Win_Check, "RadioButton_Icon_Warehouse")
local checkInven		= UI.getChildControl(Panel_Win_Check, "Static_Text_InvenMoney")
local checkWarehouse	= UI.getChildControl(Panel_Win_Check, "Static_Text_WarehouseMoney")

local globalButtonShowCount		= 0

MessageBoxCheck = {}
local MessageCheckData = {
	title = nil,
	content = nil,
	functionApply = nil,
	functionCancel = nil,
	priority = UI_PP.PAUIMB_PRIORITY_LOW,
	clientMessage = nil,
	exitButton = true,
	isTimeCount = false,	-- messageBox Timer
	countTime = 10.0,
	timeString = nil,
	isStartTimer = nil,
	afterFunction = nil,
	isCancelClose = false, 	-- 메시지 박스 종료시 cancel 함수를 사용한다.
}

local functionKeyUse = true	-- 해당 값이 false이면 메시지 박스 창에서 단축키가 적용되지않는다!

--MessageBoxData = {}
local list = nil

local elapsedTime = 0.0

local _currentMessageBoxCheckData = nil
---------------------------
-- Functions
---------------------------

function setCurrentMessageCheckData(currentData, position)
	if currentData ~= nil then
		buttonApply:SetShow(false)
		buttonCancel:SetShow(false)
		buttonClose:SetShow(false)

		-- 메세지 박스는 애니 설정하지 마세요~
		Panel_Win_Check:SetShow(true, false)
		Panel_Win_Check:SetScaleChild(1.0, 1.0)
		if currentData.title ~= nil then
			textTitle:SetText(currentData.title)
		end
		
		if currentData.content ~= nil then
			textContent:SetTextMode(UI_TM.eTextMode_AutoWrap)
			textContent:SetText(currentData.content)
			if ("top" == position) then
				textContent:SetTextVerticalTop()
				textContent:SetSpanSize( 0, 37 )
				textContent:ComputePos()
			else
				textContent:SetTextVerticalCenter()
				textContent:SetSpanSize( 0, 37 )
				textContent:ComputePos()
			end
		end

		local buttonShowCount = 0 
		if currentData.functionApply ~= nil then
			buttonApply:SetShow(true)
			buttonShowCount = buttonShowCount + 1 
		end

		if currentData.functionCancel ~= nil then
			buttonCancel:SetShow(true)
			buttonShowCount = buttonShowCount + 1 
		end

		if currentData.exitButton == true then
			buttonClose:SetShow(true)
		end

		globalButtonShowCount = buttonShowCount

		if (1 == buttonShowCount) then
			buttonApply:SetPosX( ( Panel_Win_Check:GetSizeX() / 2 ) - ( buttonApply:GetSizeX() / 2 ) )

			buttonCancel:SetPosX( ( Panel_Win_Check:GetSizeX() / 2 ) - ( buttonCancel:GetSizeX() / 2 ) )
		elseif (2 == buttonShowCount) then

			buttonApply:SetPosX( ( Panel_Win_Check:GetSizeX() / 2 ) - 95 )

			buttonCancel:SetPosX( ( Panel_Win_Check:GetSizeX() / 2 ) + 4 )

		elseif (3 == buttonShowCount) then
			local buttonSize = buttonApply:GetSizeX()

			buttonApply:SetPosX(5)
			buttonCancel:SetPosX((buttonSize * 2) + 15)
		end
		--_PA_LOG( "lua_debug", "setCurrentMessageData  _currentMessageBoxData set ");
		_currentMessageBoxCheckData = currentData;
	end
end

function MessageBoxCheck.showMessageBox(MessageCheckData, position, keyUse)
	local Front = list
	local preList = nil
	local selfPlayer = getSelfPlayer()
	if nil == selfPlayer then
		return
	end
	local myInvenMoney = selfPlayer:get():getInventory():getMoney_s64()
	functionKeyUse = keyUse
	while true do
		if list == nil or list.data.priority > MessageCheckData.priority then
			list = {next = list, pre = preList, data = MessageCheckData}
			
			if list.pre == nil then
				setCurrentMessageCheckData(list.data, position)
			else
				list.pre.next = list
				list = Front
			end
			break
		else
			preList = list
			list = list.next
		end
	end

	iconInven		:SetCheck( true )
	iconWarehouse	:SetCheck( false )
	checkInven		:SetText( makeDotMoney(myInvenMoney) )
	checkWarehouse	:SetText( makeDotMoney(warehouse_moneyFromNpcShop_s64()) )
	iconInven		:SetEnableArea( 0, 0, iconInven:GetTextSizeX() + checkInven:GetTextSizeX() + 100, iconInven:GetSizeY() + 3 )
	iconWarehouse	:SetEnableArea( 0, 0, iconWarehouse:GetTextSizeX() + checkWarehouse:GetTextSizeX() + 100, iconWarehouse:GetSizeY() + 3 )
	--확인용 코드
	--local temp = list
	--local ii = 1
	--while temp do
	--	UI.debugMessage(temp.data.title.."/"..tostring(ii))
	--	temp = temp.next
	--	ii = ii + 1
	--end
	
	-- 게임종료창에서 초보 모험가인 경우 보상창 보여줌
	-- if true == isGameExit and ToClient_GetUserPlayMinute() < 1440 then
	-- 	Panel_Win_Check		:SetSize(441,317)
	-- 	textBG					:SetSize(420,120)
	-- else
	-- 	Panel_Win_Check		:SetSize(350,220)
	-- 	textBG					:SetSize(334,153)
	-- end
	messageBoxCheckComputePos()
end

function messageBoxCheckComputePos()
	Panel_Win_Check			:ComputePos()
	textTitle				:ComputePos()
	textContent				:ComputePos()
	textBG					:ComputePos()
	buttonApply				:ComputePos()
	buttonCancel			:ComputePos()
	buttonClose				:ComputePos()
	iconInven				:ComputePos()
	iconWarehouse			:ComputePos()
	checkInven				:ComputePos()
	checkWarehouse			:ComputePos()
	
	if (1 == globalButtonShowCount) then
		buttonApply:SetPosX( ( Panel_Win_Check:GetSizeX() / 2 ) - ( buttonApply:GetSizeX() / 2 ) )
		
		
		buttonCancel:SetPosX( ( Panel_Win_Check:GetSizeX() / 2 ) - ( buttonCancel:GetSizeX() / 2 ) )
	elseif (2 == globalButtonShowCount) then
		
		buttonApply:SetPosX( ( Panel_Win_Check:GetSizeX() / 2 ) - 95 )

		buttonCancel:SetPosX( ( Panel_Win_Check:GetSizeX() / 2 ) + 4 )

	elseif (3 == globalButtonShowCount) then
		local buttonSize = buttonApply:GetSizeX()
		
		buttonApply:SetPosX(5)
		
		buttonCancel:SetPosX((buttonSize * 2) + 15)
	end
end

function postProcessMessageCheckData()
	-- 하우징에서 사용하는 확인창의 경우 애니메이션을 하면 안닫히는 문제가 있다.
	-- 문제가 수정되기 전까지 임시로 setShow(false)로 닫아 준다.
	Panel_Win_Check:SetShow(false, false)
	
	_currentMessageBoxCheckData = nil
	
	if list ~= nil and list.data ~= nil then
		list.data = nil
		list = list.next
		
		if list ~= nil then
			setCurrentMessageCheckData(list.data)
		end
	end
end

function allClearMessageCheckData()
	Panel_Win_Check:SetShow(false, false)
	if list == nil then
		return
	end
	while list ~= nil and list.data ~= nil do
		list.data = nil
		list = list.next
	end
end

function MessageBoxCheck.doHaveMessageBoxData( title )

	--_PA_LOG( "lua_debug", "MessageBox.doHaveMessageBoxData pre : " .. title );
	
	while list ~= nil and list.data ~= nil do
	
		--_PA_LOG( "lua_debug", "MessageBox.doHaveMessageBoxData for : " .. list.data.title );
		
		if( list.data.title == title ) then
			return true;
		end
		list = list.next
	end
	
	if ( MessageBoxCheck.isCurrentOpen( title ) ) then
		return true;
	end
	
	return false;
end

function MessageBoxCheck.isPopUp()
	return Panel_Win_Check:IsShow()
end

function MessageBoxCheck.isCheck()
	local isMoneyWhereType = CppEnums.ItemWhereType.eInventory

	if iconInven:IsCheck() then
		isMoneyWhereType = CppEnums.ItemWhereType.eInventory
	elseif iconWarehouse:IsCheck() then
		isMoneyWhereType = CppEnums.ItemWhereType.eWarehouse
	else
		isMoneyWhereType = CppEnums.ItemWhereType.eInventory
	end
	return isMoneyWhereType
end

function MessageBoxCheck.isCurrentOpen( title )
	
	if( nil ~= _currentMessageBoxCheckData  ) then
	
		--_PA_LOG( "lua_debug", "MessageBox.isCurrentOpen : _currentMessageBoxData.title :" .. _currentMessageBoxData.title );
		
		if( _currentMessageBoxCheckData.title == title ) then
		
			--_PA_LOG( "lua_debug", "MessageBox.isCurrentOpen  return true : " .. _currentMessageBoxData.title );
			
			return true;
		end
	end

	return false;
end

function MessageBoxCheck.keyProcessEnter()
	if (not functionKeyUse) and (nil ~= functionKeyUse) then -- 단축키 사용 여부 체크.
		return
	end

	if list ~= nil and list.data.functionApply ~= nil then
		list.data.functionApply()
	end
	
	if list ~= nil and nil == list.data.functionApply then
		return
	end

	if list ~= nil and list.data.clientMessage ~= nil then
		sendGameMessageParam0(list.data.clientMessage)
	end
	
	postProcessMessageCheckData()
end

function MessageBoxCheck.keyProcessEscape()
	if (not functionKeyUse) and (nil ~= functionKeyUse) then -- 단축키 사용 여부 체크.
		return
	end

	if list ~= nil and (list.data.exitButton or list.data.functionCancel) then
		messageBoxCheck_CloseButtonUp()
	end
end

-- 애니메이션 처리
function MessageBoxCheck_ShowAni()
	-- UIAni.fadeInSCR_Down( Panel_Win_Check )

	local aniInfo8 = Panel_Win_Check:addColorAnimation( 0.0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo8:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo8:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo8:SetStartIntensity( 5.0 )
	aniInfo8:SetEndIntensity( 1.0 )

	local aniInfo1 = Panel_Win_Check:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.1)
	aniInfo1:SetEndScale(1.1)
	aniInfo1.AxisX = Panel_Win_Check:GetSizeX() / 2
	aniInfo1.AxisY = Panel_Win_Check:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_Win_Check:addScaleAnimation( 0.08, 0.14, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.1)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_Win_Check:GetSizeX() / 2
	aniInfo2.AxisY = Panel_Win_Check:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function MessageBoxCheck_HideAni()
	Panel_Win_Check:SetShow(false, false)
end


------------------------------------------------------------------------------------------------
function messageBoxCheck_ApplyButtonUp()
	local functionApply = nil
	if list ~= nil and list.data.functionApply ~= nil then
		elapsedTime = 0
		functionApply = list.data.functionApply
	end
	
	if list ~= nil and list.data.clientMessage ~= nil then
		sendGameMessageParam0(list.data.clientMessage)
	end
	
	postProcessMessageCheckData()
	if (functionApply ~= nil) then
		functionApply()
	end
end

function messageBoxCheck_CancelButtonUp()
	local functionCancel = nil
	if list ~= nil and list.data.functionCancel ~= nil then
		elapsedTime = 0
		functionCancel = list.data.functionCancel
	end
	postProcessMessageCheckData()
	if (functionCancel ~= nil) then
		functionCancel()
	end
end

function messageBoxCheck_CloseButtonUp()
	local functionCancel = nil
	if list ~= nil and list.data.functionCancel ~= nil then
		functionCancel = list.data.functionCancel
	elseif true == isCancelClose then
		MessageBoxCheck_Empty_function()
	end
	postProcessMessageCheckData()

	if (functionCancel ~= nil) then
		functionCancel()
	end
end

----------------------------------------------------------------------------------------------------
-- 알림 용도로만 사용하는 메세지 박스.
-- 다른 루아에서 가져다 쓰지 마시오~

function Event_MessageBoxCheck_NotifyMessage_CashAlert( message )
	local titleText = PAGetString( Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY" )
	local messageboxData = { title = titleText, content = message, functionApply = MessageBox_Empty_function , priority = UI_PP.PAUIMB_PRIORITY_LOW, exitButton = false }
	MessageBoxCheck.showMessageBox(messageboxData, "top")
end

function Event_MessageBoxCheck_NotifyMessage( message )
	local titleText = PAGetString( Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY" )
	local messageboxData = { title = titleText, content = message, functionApply = MessageBox_Empty_function , priority = UI_PP.PAUIMB_PRIORITY_LOW, exitButton = false }
	MessageBoxCheck.showMessageBox(messageboxData)
end

function Event_MessageBox_NotifyMessage_FreeButton( message )
	local messageboxData = { title = "", content = message, priority = UI_PP.PAUIMB_PRIORITY_1, exitButton = false}
	MessageBoxCheck.showMessageBox(messageboxData)
end

function Event_MessageBox_NotifyMessage_With_ClientMessage( message, gameMessageType)
	local titleText = PAGetString( Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY" )
	local messageboxData = { title = titleText, content = message, functionApply = MessageBox_Empty_function , priority = UI_PP.PAUIMB_PRIORITY_1, clientMessage = gameMessageType, exitButton = false}
	MessageBoxCheck.showMessageBox(messageboxData)
end
----------------------------------------------------------------------------------------------------

function MessageBoxCheck_Empty_function()
	--allClearMessageData()
end

-- 메시지 박스에 타이머 설정
function messageBoxCheck_UpdatePerFrame( deltaTime )
	if nil == list or nil == list.data or nil == list.data.isTimeCount or false == list.data.isStartTimer then
		return
	end
	
	elapsedTime = elapsedTime + deltaTime
	
	if elapsedTime < list.data.countTime then
		if nil ~= list.data.timeString then
			local remainTime = math.floor( list.data.countTime - elapsedTime )
			textTitle:SetText( remainTime .. list.data.timeString )
		end
	elseif nil ~= list.data.afterFunction then
		-- UI.debugMessage( "함수콜" )
		list.data.isTimeCount = false
		list.data.afterFunction()
	end
end

-- Restore Event
local postRestoreEvent = function()
	if( nil == _currentMessageBoxCheckData ) then
		return;
	end
	setCurrentMessageCheckData(_currentMessageBoxCheckData );
end

UI.addRunPostFlushFunction( postRestoreEvent );

buttonApply:addInputEvent( "Mouse_LUp", "messageBoxCheck_ApplyButtonUp()" )
buttonCancel:addInputEvent( "Mouse_LUp", "messageBoxCheck_CancelButtonUp()" )
buttonClose:addInputEvent( "Mouse_LUp", "messageBoxCheck_CloseButtonUp()" )

--{	MessageBoxCheck는 Client메시지를 처리하지 않기 떄문에 해당이벤트를 주석처리한다.
-- registerEvent("EventNotifyMessage", 					"Event_MessageBoxCheck_NotifyMessage" )
-- registerEvent("EventNotifyMessageFreeButton", 			"Event_MessageBoxCheck_NotifyMessage_FreeButton" )
-- registerEvent("EventNotifyFreeButtonMessageProcess", 	"postProcessMessageCheckData" )
-- registerEvent("EventNotifyAllClearMessageData", 		"allClearMessageCheckData" )
-- registerEvent("EventNotifyMessageWithClientMessage", 	"Event_MessageBoxCheck_NotifyMessage_With_ClientMessage" );
--}
registerEvent("EventNotifyMessageCashAlert", 	"Event_MessageBoxCheck_NotifyMessage_CashAlert" )

Panel_Win_Check:RegisterUpdateFunc("messageBoxCheck_UpdatePerFrame")