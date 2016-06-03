local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE

Panel_Win_System:RegisterShowEventFunc( true, 'MessageBox_ShowAni()' )
Panel_Win_System:RegisterShowEventFunc( false, 'MessageBox_HideAni()' )

---------------------------
-- Panel Init
---------------------------
Panel_Win_System:SetShow(false, false)
Panel_Win_System:setMaskingChild(true)
Panel_Win_System:setGlassBackground(true)
---------------------------
-- Local Variables
---------------------------
local UI_TM 		= CppEnums.TextMode
local UI_PP	 		= CppEnums.PAUIMB_PRIORITY
local UI_color 		= Defines.Color
local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE

local textTitle 		= UI.getChildControl(Panel_Win_System, "Static_Text_Title")
local textBG 			= UI.getChildControl(Panel_Win_System, "Static_Text")
local textContent 		= UI.getChildControl(Panel_Win_System, "StaticText_Content")
local buttonYes 		= UI.getChildControl(Panel_Win_System, "Button_Yes")
local buttonApply 		= UI.getChildControl(Panel_Win_System, "Button_Apply")
local buttonNo 			= UI.getChildControl(Panel_Win_System, "Button_No")
local buttonIgnore 		= UI.getChildControl(Panel_Win_System, "Button_Ignore")
local buttonCancel 		= UI.getChildControl(Panel_Win_System, "Button_Cancel")
local buttonClose 		= UI.getChildControl(Panel_Win_System, "Button_Close")

local static_Beginner_BG 		= UI.getChildControl(Panel_Win_System, "Static_Beginner_BG")
local static_BeginnerTitleBG 	= UI.getChildControl(Panel_Win_System, "Static_BeginnerTitleBG")
local staticText_BeginnerTxt1 	= UI.getChildControl(Panel_Win_System, "StaticText_BeginnerTxt1")
local staticText_BeginnerTxt2 	= UI.getChildControl(Panel_Win_System, "StaticText_BeginnerTxt2")
local globalButtonShowCount		= 0

-- 텍스트 사이즈가 버튼 사이즈보다 큰 경우, 버튼 사이즈를 늘려준다.
local buttonTextSizeX = buttonYes:GetTextSizeX()
buttonTextSizeX = math.max( buttonTextSizeX, buttonApply:GetTextSizeX())
buttonTextSizeX = math.max( buttonTextSizeX, buttonNo:GetTextSizeX())
buttonTextSizeX = math.max( buttonTextSizeX, buttonIgnore:GetTextSizeX())
buttonTextSizeX = math.max( buttonTextSizeX, buttonCancel:GetTextSizeX())
buttonTextSizeX = math.min( buttonTextSizeX, 150 )

if buttonYes:GetSizeX() < buttonTextSizeX+20 then		-- 여백을 위해 10픽셀을 더 준다
	buttonYes		:SetSize( buttonTextSizeX+20, buttonYes:GetSizeY() )
	buttonApply		:SetSize( buttonTextSizeX+20, buttonApply:GetSizeY() )
	buttonNo		:SetSize( buttonTextSizeX+20, buttonNo:GetSizeY() )
	buttonIgnore	:SetSize( buttonTextSizeX+20, buttonIgnore:GetSizeY() )
	buttonCancel	:SetSize( buttonTextSizeX+20, buttonCancel:GetSizeY() )
end

MessageBox = {}
local MessageData = {
	title = nil,
	content = nil,
	functionYes = nil,
	functionApply = nil,
	functionNo = nil,
	functionIgnore = nil,
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
local functionYes = nil

--MessageBoxData = {}
local list = nil

local elapsedTime = 0.0

local _currentMessageBoxData = nil
---------------------------
-- Functions
---------------------------

function setCurrentMessageData(currentData, position)
	if currentData ~= nil then
		buttonYes:SetShow(false)
		buttonApply:SetShow(false)
		buttonNo:SetShow(false)
		buttonIgnore:SetShow(false)
		buttonCancel:SetShow(false)
		buttonClose:SetShow(false)

		-- 메세지 박스는 애니 설정하지 마세요~
		Panel_Win_System:SetShow(true, false)
		Panel_Win_System:SetScaleChild(1.0, 1.0)
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
		if currentData.functionYes ~= nil then
			buttonYes:SetShow(true)
			buttonShowCount = buttonShowCount + 1 
		elseif currentData.functionApply ~= nil then
			buttonApply:SetShow(true)
			buttonShowCount = buttonShowCount + 1 
		end
		
		if currentData.functionNo ~= nil then
			buttonNo:SetShow(true)
			buttonShowCount = buttonShowCount + 1 
		elseif currentData.functionIgnore ~= nil then
			buttonIgnore:SetShow(true)
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
			buttonYes:SetPosX( ( Panel_Win_System:GetSizeX() / 2 ) - ( buttonYes:GetSizeX() / 2 ) )
			buttonApply:SetPosX( ( Panel_Win_System:GetSizeX() / 2 ) - ( buttonApply:GetSizeX() / 2 ) )
			
			buttonNo:SetPosX( ( Panel_Win_System:GetSizeX() / 2 ) - ( buttonNo:GetSizeX() / 2 ) )
			buttonIgnore:SetPosX( ( Panel_Win_System:GetSizeX() / 2 ) - ( buttonIgnore:GetSizeX() / 2 ) )
			
			buttonCancel:SetPosX( ( Panel_Win_System:GetSizeX() / 2 ) - ( buttonCancel:GetSizeX() / 2 ) )
		elseif (2 == buttonShowCount) then
			buttonYes:SetPosX( ( Panel_Win_System:GetSizeX() / 2 ) - ( buttonYes:GetSizeX()/2+5 ) )
			buttonNo:SetPosX( ( Panel_Win_System:GetSizeX() / 2 ) + ( buttonNo:GetSizeX()/2+5 ) )
			
			buttonApply:SetPosX( ( Panel_Win_System:GetSizeX() / 2 ) - ( buttonApply:GetSizeX()/2+5 ) )
			buttonIgnore:SetPosX( ( Panel_Win_System:GetSizeX() / 2 ) + ( buttonIgnore:GetSizeX()/2+5 ) )

			buttonCancel:SetPosX( ( Panel_Win_System:GetSizeX() / 2 ) + ( buttonCancel:GetSizeX()/2+5 ) )

		elseif (3 == buttonShowCount) then
			local buttonSize = buttonYes:GetSizeX()
			buttonYes:SetPosX(5)
			buttonNo:SetPosX(buttonSize + 10)
			
			buttonApply:SetPosX(5)
			buttonIgnore:SetPosX(buttonSize + 10)
			
			buttonCancel:SetPosX((buttonSize * 2) + 15)
		end
		--_PA_LOG( "lua_debug", "setCurrentMessageData  _currentMessageBoxData set ");
		_currentMessageBoxData = currentData;
	end
end

function MessageBox.showMessageBox(MessageData, position, isGameExit, keyUse)
	if Panel_Win_System:GetShow() then
		return
	end
	local Front = list
	local preList = nil
	functionKeyUse = keyUse
	while true do
		if list == nil or list.data.priority > MessageData.priority then
			list = {next = list, pre = preList, data = MessageData}
			
			if list.pre == nil then
				setCurrentMessageData(list.data, position)
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

	--확인용 코드
	--local temp = list
	--local ii = 1
	--while temp do
	--	UI.debugMessage(temp.data.title.."/"..tostring(ii))
	--	temp = temp.next
	--	ii = ii + 1
	--end
	
	-- 게임종료창에서 초보 모험가인 경우 보상창 보여줌
	if true == isGameExit and ToClient_GetUserPlayMinute() < 1440 then
		Panel_Win_System		:SetSize(441,317)
		textBG					:SetSize(420,120)
		static_Beginner_BG		:SetShow(true)
		static_BeginnerTitleBG	:SetShow(true)
		staticText_BeginnerTxt1	:SetShow(true)
		staticText_BeginnerTxt2	:SetShow(true)
		static_Beginner_BG		:ComputePos()
		static_BeginnerTitleBG	:ComputePos()
		staticText_BeginnerTxt1	:ComputePos()
		staticText_BeginnerTxt2	:ComputePos()
	else
		static_Beginner_BG		:SetShow(false)
		static_BeginnerTitleBG	:SetShow(false)
		staticText_BeginnerTxt1	:SetShow(false)
		staticText_BeginnerTxt2	:SetShow(false)
		Panel_Win_System		:SetSize(350,220)
		textBG					:SetSize(334,153)
	end
	messageBoxComputePos()
		
		
end

function messageBoxComputePos()
	Panel_Win_System		:ComputePos()
	textTitle				:ComputePos()
	textContent				:ComputePos()
	textBG					:ComputePos()
	buttonYes				:ComputePos()
	buttonApply				:ComputePos()
	buttonNo				:ComputePos()
	buttonIgnore			:ComputePos()
	buttonCancel			:ComputePos()
	buttonClose				:ComputePos()
	
	if (1 == globalButtonShowCount) then
		buttonYes:SetPosX( ( Panel_Win_System:GetSizeX() / 2 ) - ( buttonYes:GetSizeX() / 2 ) )
		buttonApply:SetPosX( ( Panel_Win_System:GetSizeX() / 2 ) - ( buttonApply:GetSizeX() / 2 ) )
		
		buttonNo:SetPosX( ( Panel_Win_System:GetSizeX() / 2 ) - ( buttonNo:GetSizeX() / 2 ) )
		buttonIgnore:SetPosX( ( Panel_Win_System:GetSizeX() / 2 ) - ( buttonIgnore:GetSizeX() / 2 ) )
		
		buttonCancel:SetPosX( ( Panel_Win_System:GetSizeX() / 2 ) - ( buttonCancel:GetSizeX() / 2 ) )
	elseif (2 == globalButtonShowCount) then
		buttonYes:SetPosX( ( Panel_Win_System:GetSizeX() / 2 ) - ( buttonYes:GetSizeX()+5 ) )
		buttonNo:SetPosX( ( Panel_Win_System:GetSizeX() / 2 ) + 5 )
		
		buttonApply:SetPosX( ( Panel_Win_System:GetSizeX() / 2 ) - ( buttonApply:GetSizeX()+5 ) )
		buttonIgnore:SetPosX( ( Panel_Win_System:GetSizeX() / 2 ) + 5 )

		buttonCancel:SetPosX( ( Panel_Win_System:GetSizeX() / 2 ) + 5 )

	elseif (3 == globalButtonShowCount) then
		local buttonSize = buttonYes:GetSizeX()
		buttonYes:SetPosX(5)
		buttonNo:SetPosX(buttonSize + 10)
		
		buttonApply:SetPosX(5)
		buttonIgnore:SetPosX(buttonSize + 10)
		
		buttonCancel:SetPosX((buttonSize * 2) + 15)
	end
end

function postProcessMessageData()
	-- 하우징에서 사용하는 확인창의 경우 애니메이션을 하면 안닫히는 문제가 있다.
	-- 문제가 수정되기 전까지 임시로 setShow(false)로 닫아 준다.
	Panel_Win_System:SetShow(false, false)
	
	_currentMessageBoxData = nil
	
	if list ~= nil and list.data ~= nil then
		list.data = nil
		list = list.next
		
		if list ~= nil then
			setCurrentMessageData(list.data)
		end
	end
end

function allClearMessageData()
	Panel_Win_System:SetShow(false, false)
	if list == nil then
		return
	end
	while list ~= nil and list.data ~= nil do
		list.data = nil
		list = list.next
	end
end

function MessageBox.doHaveMessageBoxData( title )

	--_PA_LOG( "lua_debug", "MessageBox.doHaveMessageBoxData pre : " .. title );
	
	while list ~= nil and list.data ~= nil do
	
		--_PA_LOG( "lua_debug", "MessageBox.doHaveMessageBoxData for : " .. list.data.title );
		
		if( list.data.title == title ) then
			return true;
		end
		list = list.next
	end
	
	if ( MessageBox.isCurrentOpen( title ) ) then
		return true;
	end
	
	return false;
end

function MessageBox.isPopUp()
	return Panel_Win_System:IsShow()
end

function MessageBox.isCurrentOpen( title )
	
	if( nil ~= _currentMessageBoxData  ) then
	
		--_PA_LOG( "lua_debug", "MessageBox.isCurrentOpen : _currentMessageBoxData.title :" .. _currentMessageBoxData.title );
		
		if( _currentMessageBoxData.title == title ) then
		
			--_PA_LOG( "lua_debug", "MessageBox.isCurrentOpen  return true : " .. _currentMessageBoxData.title );
			
			return true;
		end
	end

	return false;
end

function MessageBox.keyProcessEnter()
	if (not functionKeyUse) and (nil ~= functionKeyUse) then -- 단축키 사용 여부 체크.
		return
	end

	if list ~= nil and list.data.functionYes ~= nil then
		list.data.isStartTimer = true
		list.data.functionYes()
	end

	if list ~= nil and list.data.functionApply ~= nil then
		list.data.functionApply()
	end
	
	if list ~= nil and nil == list.data.functionYes and nil == list.data.functionApply then
		return
	end

	if list ~= nil and list.data.clientMessage ~= nil then
		sendGameMessageParam0(list.data.clientMessage)
	end
	
	postProcessMessageData()
end

function MessageBox.keyProcessEscape()
	if (not functionKeyUse) and (nil ~= functionKeyUse) then -- 단축키 사용 여부 체크.
		return
	end

	if list ~= nil and (list.data.exitButton or list.data.functionCancel or list.data.functionNo) then
		messageBox_CloseButtonUp()
	end
end

-- 애니메이션 처리
function MessageBox_ShowAni()
	-- UIAni.fadeInSCR_Down( Panel_Win_System )

	local aniInfo8 = Panel_Win_System:addColorAnimation( 0.0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo8:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo8:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo8:SetStartIntensity( 5.0 )
	aniInfo8:SetEndIntensity( 1.0 )

	local aniInfo1 = Panel_Win_System:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.1)
	aniInfo1:SetEndScale(1.1)
	aniInfo1.AxisX = Panel_Win_System:GetSizeX() / 2
	aniInfo1.AxisY = Panel_Win_System:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_Win_System:addScaleAnimation( 0.08, 0.14, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.1)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_Win_System:GetSizeX() / 2
	aniInfo2.AxisY = Panel_Win_System:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function MessageBox_HideAni()
	Panel_Win_System:SetShow(false, false)
end


------------------------------------------------------------------------------------------------
function messageBox_YesButtonUp()
	local functionYes = nil
	if list ~= nil and list.data.functionYes ~= nil then
		list.data.isStartTimer = true
		functionYes = list.data.functionYes
	end
	
	if list ~= nil and list.data.clientMessage ~= nil then
		sendGameMessageParam0(list.data.clientMessage)
	end
	
	postProcessMessageData()
	if (functionYes ~= nil) then
		functionYes()
	end
end

function messageBox_ApplyButtonUp()
	local functionApply = nil
	if list ~= nil and list.data.functionApply ~= nil then
		elapsedTime = 0
		functionApply = list.data.functionApply
	end
	
	if list ~= nil and list.data.clientMessage ~= nil then
		sendGameMessageParam0(list.data.clientMessage)
	end
	
	postProcessMessageData()
	if (functionApply ~= nil) then
		functionApply()
	end
end

function messageBox_NoButtonUp()
	local functionNo = nil
	if list ~= nil and list.data.functionNo ~= nil then
		functionNo = list.data.functionNo
	end
	postProcessMessageData()
	if (functionNo ~= nil) then
		functionNo()
	end
end

function messageBox_IgnoreButtonUp()
	local functionIgnore = nil
	if list ~= nil and list.data.functionIgnore ~= nil then
		functionIgnore = list.data.functionIgnore
	end
	postProcessMessageData()
	if (functionIgnore ~= nil) then
		functionIgnore()
	end
end

function messageBox_CancelButtonUp()
	local functionCancel = nil
	if list ~= nil and list.data.functionCancel ~= nil then
		elapsedTime = 0
		functionCancel = list.data.functionCancel
	end
	postProcessMessageData()
	if (functionCancel ~= nil) then
		functionCancel()
	end
end

function messageBox_CloseButtonUp()
	local functionNo = nil
	if list ~= nil and list.data.functionNo ~= nil --[[and nil == list.data.isCancelClose--]] then				-- no와 cancel이 같이 사용될 일은 없으니 조건서 빼준다
		functionNo = list.data.functionNo
	end
	
	local functionCancel = nil
	if list ~= nil and list.data.functionCancel ~= nil then
		functionCancel = list.data.functionCancel
	elseif true == isCancelClose then
		MessageBox_Empty_function()
	end
	postProcessMessageData()
	if (functionNo ~= nil) then
		functionNo()
	end
	if (functionCancel ~= nil) then
		functionCancel()
	end
end

----------------------------------------------------------------------------------------------------
-- 알림 용도로만 사용하는 메세지 박스.
-- 다른 루아에서 가져다 쓰지 마시오~

function Event_MessageBox_NotifyMessage_CashAlert( message )
	local titleText = PAGetString( Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY" )
	local messageboxData = { title = titleText, content = message, functionApply = MessageBox_Empty_function , priority = UI_PP.PAUIMB_PRIORITY_LOW, exitButton = false }
	MessageBox.showMessageBox(messageboxData, "top")
end

function Event_MessageBox_NotifyMessage( message )
	local titleText = PAGetString( Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY" )
	local messageboxData = { title = titleText, content = message, functionApply = MessageBox_Empty_function , priority = UI_PP.PAUIMB_PRIORITY_LOW, exitButton = false }
	MessageBox.showMessageBox(messageboxData)
end

function Event_MessageBox_NotifyMessage_FreeButton( message )
	local messageboxData = { title = "", content = message, priority = UI_PP.PAUIMB_PRIORITY_1, exitButton = false}
	MessageBox.showMessageBox(messageboxData)
end

function Event_MessageBox_NotifyMessage_With_ClientMessage( message, gameMessageType)
	local titleText = PAGetString( Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY" )
	local messageboxData = { title = titleText, content = message, functionApply = MessageBox_Empty_function , priority = UI_PP.PAUIMB_PRIORITY_1, clientMessage = gameMessageType, exitButton = false}
	MessageBox.showMessageBox(messageboxData)
end
----------------------------------------------------------------------------------------------------

function MessageBox_Empty_function()
	--allClearMessageData()
end

-- 메시지 박스에 타이머 설정
function messageBox_UpdatePerFrame( deltaTime )
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
	if( nil == _currentMessageBoxData ) then
		return;
	end
	setCurrentMessageData(_currentMessageBoxData );
end

UI.addRunPostFlushFunction( postRestoreEvent );

buttonYes:addInputEvent( "Mouse_LUp", "messageBox_YesButtonUp()" )
buttonApply:addInputEvent( "Mouse_LUp", "messageBox_ApplyButtonUp()" )
buttonNo:addInputEvent( "Mouse_LUp", "messageBox_NoButtonUp()" )
buttonIgnore:addInputEvent( "Mouse_LUp", "messageBox_IgnoreButtonUp()" )
buttonCancel:addInputEvent( "Mouse_LUp", "messageBox_CancelButtonUp()" )
buttonClose:addInputEvent( "Mouse_LUp", "messageBox_CloseButtonUp()" )

registerEvent("EventNotifyMessage", 					"Event_MessageBox_NotifyMessage" )
registerEvent("EventNotifyMessageFreeButton", 			"Event_MessageBox_NotifyMessage_FreeButton" )
registerEvent("EventNotifyFreeButtonMessageProcess", 	"postProcessMessageData" )
registerEvent("EventNotifyAllClearMessageData", 		"allClearMessageData" )
registerEvent("EventNotifyMessageWithClientMessage", 	"Event_MessageBox_NotifyMessage_With_ClientMessage" );

registerEvent("EventNotifyMessageCashAlert", 	"Event_MessageBox_NotifyMessage_CashAlert" )

Panel_Win_System:RegisterUpdateFunc("messageBox_UpdatePerFrame")






