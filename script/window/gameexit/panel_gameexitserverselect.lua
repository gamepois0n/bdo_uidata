local UI_PUCT 			= CppEnums.PA_UI_CONTROL_TYPE

Panel_ChannelSelect:SetShow( false )

local channelSelect = {
	_BlockBG		= UI.getChildControl(Panel_ChannelSelect, "Static_BlockBG"),
	_frame			= UI.getChildControl(Panel_ChannelSelect, "Frame_ChannelSelect" ),
	_close_btn		= UI.getChildControl(Panel_ChannelSelect, "Button_Close"),
	_question_btn	= UI.getChildControl(Panel_ChannelSelect, "Button_Question"),
	_allBG			= UI.getChildControl(Panel_ChannelSelect, "Static_AllBG"),
}
channelSelect.FrameContents = UI.getChildControl(channelSelect._frame, "Frame_1_Content")
channelSelect.Frame_Scroll	= UI.getChildControl(channelSelect._frame,	"Frame_1_VerticalScroll")
local templete	= {
	channel_BG				= UI.getChildControl(Panel_ChannelSelect, "Static_Channel_BG" ),
	channel_Name			= UI.getChildControl(Panel_ChannelSelect, "StaticText_ChannelName"),
	channel_Status			= UI.getChildControl(Panel_ChannelSelect, "StaticText_Status"),
	channel_Btn				= UI.getChildControl(Panel_ChannelSelect, "Button_Join"),
}

local channelSelectData = {
	
}

local channelSelectUIPool = {}
local _selectChannel = -1
function ChannelSelect_Init()
	local self = channelSelect
	local curChannelData		= getCurrentChannelServerData()
	if ( nil == curChannelData ) then
		return
	end

	local curWorldData			= getGameWorldServerDataByWorldNo( curChannelData._worldNo )
	local channelCount			= getGameChannelServerDataCount( curWorldData._worldNo )

	for index = 0, channelCount-1 do
		local channelList = {}
		channelList.baseBG			= UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT,	channelSelect.FrameContents,	"create_ChannelSlot_" .. index )
		channelList.channelName		= UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT,	channelList.baseBG,				"create_ChannelName_" .. index )
		channelList.channelStatus	= UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT,	channelList.baseBG,				"create_ChannelStatus_" .. index )
		channelList.channelBtn		= UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON,		channelList.baseBG,				"create_ChannelBtn_" .. index )

		CopyBaseProperty( templete.channel_BG,				channelList.baseBG )
		CopyBaseProperty( templete.channel_Name,			channelList.channelName )
		CopyBaseProperty( templete.channel_Status,			channelList.channelStatus )
		CopyBaseProperty( templete.channel_Btn,				channelList.channelBtn )

		channelList.baseBG			:SetShow( true )
		channelList.channelName		:SetShow( true )
		channelList.channelStatus	:SetShow( true )
		channelList.channelBtn		:SetShow( true )

		channelList.baseBG			:SetPosX( 3 )
		channelList.baseBG			:SetPosY( 0 + 45 * index )
		channelList.channelName		:SetPosX( 10 )
		channelList.channelName		:SetPosY( 9 )
		channelList.channelStatus	:SetPosX( 235 )
		channelList.channelStatus	:SetPosY( 9 )
		channelList.channelBtn		:SetPosX( 290 )
		channelList.channelBtn		:SetPosY( 5 )

		channelSelectUIPool[index] = channelList
		self.FrameContents:SetSize( self._allBG:GetSizeX(), (templete.channel_BG:GetSizeY()+5) * (index+1) )
	end
	self._frame:UpdateContentPos()
	if self._frame:GetSizeY() < self.FrameContents:GetSizeY() then
		self.Frame_Scroll:SetShow( true )
	else
		self.Frame_Scroll:SetShow( false )
	end

	self._BlockBG:SetSize( getScreenSizeX()+250, getScreenSizeY()+250 )
	self._BlockBG:SetHorizonCenter()
	self._BlockBG:SetVerticalMiddle()

end

function ChannelSelect_Update()
	local curChannelData		= getCurrentChannelServerData()
	if ( nil == curChannelData ) then
		return
	end

	local curWorldData				= getGameWorldServerDataByWorldNo( curChannelData._worldNo )
	local channelCount				= getGameChannelServerDataCount( curWorldData._worldNo )
	local restrictedServerNo		= curWorldData._restrictedServerNo
	local curServerNo				= curChannelData._serverNo
	-- local changeChannelTime			= getChannelMoveableRemainTime( curChannelData._worldNo )
	-- local changeRealChannelTime		= convertStringFromDatetime( changeChannelTime )
	local channelMoveableGlobalTime = getChannelMoveableTime( curWorldData._worldNo )
	local channelMoveableRemainTime = getChannelMoveableRemainTime( curWorldData._worldNo ) --converStringFromLeftDateTime( channelMoveableGlobalTime )
	local _worldServerCount =  getGameWorldServerDataCount()
	local _serverData = nil
	-- _serverData = getGameChannelServerDataByIndex( idx, chIndex )
	
	for chIndex = 0, channelCount - 1, 1 do

		_serverData = getGameChannelServerDataByWorldNo(curChannelData._worldNo, chIndex)
		
		if nil ~= _serverData then
			local busyState = _serverData._busyState
			if( busyState == 0 ) then
				tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_0") -- "<PAColor0xff868686>점 검<PAOldColor>"
			elseif( busyState == 1 ) then	 -- 재희형의 요청으로 2016-02-19에 원활은 표기 안하기로 작업함.
				tempStr = "" -- PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_1") -- "<PAColor0xffd0ee68>원 활<PAOldColor>"
			elseif( busyState == 2 ) then
				tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_2") -- "<PAColor0xffeabf4c>혼 잡<PAOldColor>"
			elseif( busyState == 3 ) then
				tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_3") -- "<PAColor0xffed6363>매우혼잡<PAOldColor>"
			elseif( busyState == 4 ) then
				tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_BUSYSTATE_4") -- "<PAColor0xffed6363>만 원<PAOldColor>"
			end

			local tempChannel = getGameChannelServerDataByWorldNo(curChannelData._worldNo, chIndex)

			local isAdmission = true
			
			-- 공성중이고 공성 비참여자이면 채널이동을 무조건한다.
			local isSiegeBeing 		= deadMessage_isSiegeBeingMyChannel();
			local isInSiegeBattle 	= deadMessage_isInSiegeBattle();
			
			if( (true == isSiegeBeing) and (false == isInSiegeBattle) ) then
			
				isAdmission = true;
			
			elseif( restrictedServerNo ~= 0 and (toInt64(0,0) ~= channelMoveableGlobalTime) ) then
				if( restrictedServerNo == tempChannel._serverNo ) then
					isAdmission = true
				else
					if toInt64(0,0) < channelMoveableRemainTime then
						isAdmission = false
					else
						isAdmission = true
					end
				end
			end

			local channelName	= getChannelName(tempChannel._worldNo, tempChannel._serverNo )
			if nil == channelName then
				channelName = ""
			end
			if (curChannelData._worldNo == tempChannel._worldNo) and (curChannelData._serverNo == tempChannel._serverNo) then
				channelName = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELNAME_CURRENT") .. channelName
			end

			if tempChannel._isMain then
				channelName = channelName --  .. "(Main)" -- 섭통합 이후로 Main채널에 대한 메리트나 컨텐츠가 없기 때문에 Main표시를 해주지 않는다.
			else
				channelName = channelName
			end

			if not isAdmission then
				channelName = channelName .. PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELNAME_LIMIT") 
			else
				channelName = channelName
			end
			channelSelectUIPool[chIndex].channelName		:SetText( channelName )
			channelSelectUIPool[chIndex].channelStatus		:SetText( tempStr )
			channelSelectUIPool[chIndex].channelBtn			:addInputEvent("Mouse_LUp",	"HandleClicked_ChannelSelect( " .. chIndex .. " )")
		end
	end
end

function HandleClicked_ChannelSelect( selectChannel )
	if isChannelMoveOnlySafe() then
		local regionInfo = getRegionInfoByPosition( getSelfPlayer():get():getPosition() )
		if not regionInfo:get():isSafeZone() and false == ToClient_SelfPlayerIsGM() then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXITSERVERSELECT_SAFEREGION") )
			return
		end
	end
	
	local curChannelData		= getCurrentChannelServerData()
	local curWorldData			= getGameWorldServerDataByWorldNo( curChannelData._worldNo )
	local channelCount			= getGameChannelServerDataCount( curWorldData._worldNo )

	_selectChannel				= selectChannel
	local tempChannel			= getGameChannelServerDataByWorldNo(curChannelData._worldNo, selectChannel)
	local channelName			= getChannelName(tempChannel._worldNo, tempChannel._serverNo )

	local changeChannelTime		= getChannelMoveableRemainTime( curChannelData._worldNo )
	local changeRealChannelTime	= convertStringFromDatetime( changeChannelTime )
	
	-- 공성중이고 공성 비참여자이면 채널이동을 무조건한다.
	local isSiegeBeing 		= deadMessage_isSiegeBeingMyChannel();
	local isInSiegeBattle 	= deadMessage_isInSiegeBattle();
	if( (true == isSiegeBeing) and (false == isInSiegeBattle) ) then
	
		local	messageBoxMemo	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_MSG", "channelName", tostring(channelName) )
		local	messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_TITLE_MSG"), content = messageBoxMemo, functionYes = moveChannelMsg, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
	
	else
		if ( toInt64(0,0) < changeChannelTime ) then
			local	messageBoxMemo = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANGECHANNEL_PENALTY", "changeRealChannelTime", changeRealChannelTime )
			local	messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_TITLE_MSG"), content = messageBoxMemo, functionYes = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
			MessageBox.showMessageBox(messageBoxData)
		else
			local	messageBoxMemo	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_MSG", "channelName", tostring(channelName) )
			local	messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_TITLE_MSG"), content = messageBoxMemo, functionYes = moveChannelMsg, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
			MessageBox.showMessageBox(messageBoxData)
		end
	end	
	
	-- 현재 종료창을 닫아 준다.
	--GameExitShowToggle()
end

function moveChannelMsg()
	FGlobal_gameExit_saveCurrentData()
	gameExit_MoveChannel(_selectChannel);
	
	local	messageBoxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELWAIT_MSG") -- "채널 이동 대기중 입니다"
	local	messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_TITLE_MSG"), content = messageBoxMemo, functionYes = nil, functionClose = nil, exitButton = true, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData)
end

function EventUpdateServerInformation_Exit()
	local isShow = Panel_ChannelSelect:IsShow()	-- 서버 데이터를 업데이트했다.
	if( false == isShow ) then
		return;
	end

	local curChannelData		= getCurrentChannelServerData()
	if ( nil == curChannelData ) then
		return;
	end

	local curWorldData				= getGameWorldServerDataByWorldNo( curChannelData._worldNo )
	local channelCount				= getGameChannelServerDataCount( curWorldData._worldNo )
	local restrictedServerNo		= curWorldData._restrictedServerNo	-- restrictedServerNo 있을 때만 타임 체크를 한다.
	local curServerNo				= curChannelData._serverNo
	local channelMoveableGlobalTime	= getChannelMoveableTime()
	local channelMoveableRemainTime	= converStringFromLeftDateTime( channelMoveableGlobalTime )

	for chIndex = 0, channelCount - 1, 1 do
		local tempChannel = getGameChannelServerDataByWorldNo(curChannelData._worldNo, chIndex)
		if nil == tempChannel then
			return
		end

		local isAdmission = true
		
		if( restrictedServerNo ~= 0 and (toInt64(0,0) ~= channelMoveableGlobalTime) ) then
			if( restrictedServerNo == tempChannel._serverNo ) then
				isAdmission = true
			else
				if 0 < channelMoveableRemainTime then
					isAdmission = true
				else
					isAdmission = false
				end
			end
		end

		local channelName	= getChannelName(tempChannel._worldNo, tempChannel._serverNo )
		if nil == channelName then
			channelName = ""
		end

		if (curChannelData._worldNo == tempChannel._worldNo) and (curChannelData._serverNo == tempChannel._serverNo) then
			channelName = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELNAME_CURRENT") .. channelName
		end

		if tempChannel._isMain then
			channelName = channelName  -- .. "(Main)"
		else
			channelName = channelName
		end

		if not isAdmission then
			channelName = channelName .. PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELNAME_LIMIT")
		else
			channelName = channelName
		end
		channelSelectUIPool[chIndex].channelName:SetText(channelName)
		channelSelectUIPool[chIndex].channelBtn:addInputEvent("Mouse_LUp",	"HandleClicked_ChannelSelect( " .. chIndex .. " )")
	end
end

function FGlobal_ChannelSelect_Show()
	Panel_ChannelSelect:SetShow( true )
	ChannelSelect_Update()
end

function FGlobal_ChannelSelect_Hide()
	Panel_ChannelSelect:SetShow( false )
end

function ChannelSelect_onScreenResize()
	local self = channelSelect
	Panel_ChannelSelect:ComputePos()
	self._BlockBG:SetSize( getScreenSizeX()+200, getScreenSizeY()+200 )
	self._BlockBG:SetHorizonCenter()
	self._BlockBG:SetVerticalMiddle()
end

function ChannelSelect_EventHandler()
	local self = channelSelect
	self._close_btn:addInputEvent("Mouse_LUp", "FGlobal_ChannelSelect_Hide()")
end

function ChannelSelect_RegisterEventHandler()
	registerEvent("onScreenResize",							"ChannelSelect_onScreenResize")
end

ChannelSelect_Init()
ChannelSelect_EventHandler()