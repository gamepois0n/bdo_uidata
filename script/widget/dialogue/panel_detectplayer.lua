Panel_DetectPlayer:SetShow(false, false)
Panel_DetectPlayer:ActiveMouseEventEffect(true)
Panel_DetectPlayer:setGlassBackground(true)

local UI_TM = CppEnums.TextMode
local IM 	= CppEnums.EProcessorInputMode
local UI_color 		= Defines.Color
local DetectPlayer =
{
	_buttonFind				= UI.getChildControl( Panel_DetectPlayer, "ButtonFind"			),
	_editPlayerName			= UI.getChildControl( Panel_DetectPlayer, "Edit_PlayerName"		),
	_static_GuideMsg		= UI.getChildControl( Panel_DetectPlayer, "StaticText_GuideMsg" ),
	_buttonClose 			= UI.getChildControl( Panel_DetectPlayer, "Button_WinClose"		),
	_buttonHelp 			= UI.getChildControl( Panel_DetectPlayer, "Button_Question"		),
}
DetectPlayer._buttonHelp:SetShow( false )				-- 도움말 내용을 넣을 때까지 꺼둔다.
local editBoxClear = true

function DetectPlayer:initialize()
	self._static_GuideMsg:SetTextMode( UI_TM.eTextMode_AutoWrap )
	self._static_GuideMsg:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_DETECTPLAYER_GUIDEMSG") )
	-- "접속 중인 플레이어의 위치를 확인 할 수 있습니다.\n위치 확인에는 <PAColor0xFFFFD649>10,000 실버<PAOldColor>가 필요합니다."
	self._editPlayerName:	addInputEvent( "Mouse_LUp", "DetectPlayer_EditClear()" )
	self._buttonFind:		addInputEvent( "Mouse_LUp", "HandleClicked_DetectPlayer()" )
	self._buttonClose:		addInputEvent( "Mouse_LUp", "DetectPlayer_Close()" )
	self._buttonHelp:		addInputEvent( "Mouse_LUp", "" )
end

function DetectPlayer:show()
	Panel_DetectPlayer:SetShow(true, false)
	DetectPlayer._editPlayerName:SetMaxInput( getGameServiceTypeCharacterNameLength() )
	DetectPlayer._editPlayerName:SetEditText( PAGetString(Defines.StringSheet_GAME, "LUA_DETECTPLAYER_EDITPLAYERNAME_DEFAULTMSG"), true)
	-- "플레이어 이름을 입력하세요."

	editBoxClear = true
end

function DetectPlayer_Close()
	Panel_DetectPlayer:SetShow(false, false)
	DetectPlayer._editPlayerName:SetEditText("", true)
	editBoxClear = true
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
	ClearFocusEdit()
end

function DetectPlayer_reload()
	DetectPlayer_Close()
	DetectPlayer:show()
end

function DetectPlayer_EditClear()
	if editBoxClear == true then
		DetectPlayer._editPlayerName:SetEditText("", true)
		editBoxClear = false
	end
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
	SetFocusEdit(DetectPlayer._editPlayerName)
end

function HandleClicked_DetectPlayer()
	-- 이름 체크
	local msgDefault = PAGetString(Defines.StringSheet_GAME, "LUA_DETECTPLAYER_EDITPLAYERNAME_DEFAULTMSG")
	if (nil == DetectPlayer._editPlayerName:GetEditText()) or ("" == DetectPlayer._editPlayerName:GetEditText()) 
		or ( msgDefault == DetectPlayer._editPlayerName:GetEditText() ) then
		local	messageBoxTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
		local	messageBoxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_DETECTPLAYER_ERRORMSG_PLAYERNAME_NIL")
								-- 플레이어 이름을 입력해야 합니다.
  		local	messageboxData = { title = messageBoxTitle, content = messageBoxMemo, functionApply = DetectPlayer_reload, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
  		MessageBox.showMessageBox(messageboxData)
	-- 공백 체크
	elseif (nil ~= (string.find(DetectPlayer._editPlayerName:GetEditText(), " "))) then
		local	messageBoxTitle	= PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
		local	messageBoxMemo	= PAGetString(Defines.StringSheet_GAME, "LUA_DETECTPLAYER_ERRORMSG_PLAYERNAME_SPACE")
								-- 플레이어 이름에 공백이 있습니다.
  		local	messageboxData = { title = messageBoxTitle, content = messageBoxMemo, functionApply = DetectPlayer_reload, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
  		MessageBox.showMessageBox(messageboxData)	
	else
		-- 입력한 플레이어의 이름으로 찾아보시겠습니까?
		ToClient_DetectPlayer(DetectPlayer._editPlayerName:GetEditText());
		Panel_DetectPlayer:SetShow(false, false)	
	end
end

function FromClient_OpenDetectPlayer()
	DetectPlayer:show()
end

function FromClient_CompleteDetectPlayer(position)
	FGlobal_PushOpenWorldMap();
	FromClient_RClickWorldmapPanel( position, true );
end

registerEvent("FromClient_OpenDetectPlayer", "FromClient_OpenDetectPlayer")
registerEvent("FromClient_CompleteDetectPlayer", "FromClient_CompleteDetectPlayer")

DetectPlayer:initialize()
