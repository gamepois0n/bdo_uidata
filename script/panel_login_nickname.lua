-------------------------------
-- Panel Init
-------------------------------
Panel_Login_Nickname:SetShow(false, false)
Panel_Login_Nickname:setGlassBackground(true)
-------------------------------
-- Control Regist & Init
-------------------------------
local	loginNickname	= {
	edit_Nickname	= UI.getChildControl( Panel_Login_Nickname,	"Edit_Nickname" ),
	button_OK		= UI.getChildControl( Panel_Login_Nickname,	"Button_Apply_Import" ),
	-- button_Cancel	= UI.getChildControl( Panel_Login_Nickname,	"Button_Cancel_Import" ),
}

function	loginNickname:init()
	UI.ASSERT( nil ~= self.edit_Nickname	and 'number' ~= type(self.edit_Nickname),	"Edit_Nickname" )
	UI.ASSERT( nil ~= self.button_OK		and 'number' ~= type(self.button_OK),		"Button_Apply_Import" )
	-- UI.ASSERT( nil ~= self.button_Cancel	and 'number' ~= type(self.button_Cancel),	"Button_Cancel_Import" )
	
	--registEventHandler()
	self.button_OK:addInputEvent(		"Mouse_LUp", "LoginNickname_OK()"		)
	-- self.button_Cancel:addInputEvent(	"Mouse_LUp", "LoginNickname_Cancel()"	)
	self.edit_Nickname:RegistReturnKeyEvent("LoginNickname_OK()");
	
	--registMessageHandler()
	
	registerEvent( "EventCreateNickname",	"LoginNickname_Open" )
end

-------------------------------
-- 구현부
-------------------------------
function	LoginNickname_OK()
	ClearFocusEdit()
	local	self	= loginNickname
	if	not lobbyNickname_createNickname( self.edit_Nickname:GetEditText() )	then
		return
	end
	
	registerNickname()
end

-- function	LoginNickname_Cancel()	
	-- local messageboxData = { title = PAGetString(Defines.StringSheet_GAME, "GAME_EXIT_MESSAGEBOX_TITLE"), content = PAGetString(Defines.StringSheet_GAME, "GAME_EXIT_MESSAGEBOX_MEMO"), functionYes = LoginNickname_Cancel_End, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	-- MessageBox.showMessageBox(messageboxData)
-- end

function	LoginNickname_Cancel_End()
	disConnectToGame()
	GlobalExitGameClient()
end

function	LoginNickname_Open()
	if	Panel_Login_Nickname:GetShow()	then
		return
	end
	
	local	self	= loginNickname
	
	self.edit_Nickname:SetEditText("")
	self.edit_Nickname:SetMaxInput( getGameServiceTypeUserNickNameLength() )

	SetFocusEdit( self.edit_Nickname )
	
	Panel_Login_Nickname:SetShow(true)	
end

function	LoginNickname_Close()
	local	self	= loginNickname
	self.edit_Nickname:SetEditText("")
	
	if	Panel_Login_Nickname:GetShow()	then
		Panel_Login_Nickname:SetShow(false)
	end	
end

loginNickname:init()