-------------------------------
-- Panel Init
-------------------------------
Panel_Login_Password:SetShow(false, false)
Panel_Login_Password:setGlassBackground(true)

-------------------------------
-- Control Regist & Init
-------------------------------
local	loginPassword	= {
	config	=		-- 이 값들은 추후에 메시지로 빼어내어 세팅해야 할까?
	{
		indexMax	= 10,
		
		startX		= 30,
		startY		= 95,
		
		gapX		= 70,
		gapY		= 40,
		
		row			= 2,
		column		= 5,
	},
	
	const	=
	{
		type_CreatePassword	= 0,	-- 생성
		type_Reconfirm		= 1,	-- 생성시 재확인
		type_Authentic		= 2		-- 비밀번호 확인
	},
	
	Edit_Password		= UI.getChildControl( Panel_Login_Password, "Edit_DisplayNumber" ),
	StaticText_Title	= UI.getChildControl( Panel_Login_Password, "Static_Text_Title_Import" ),
	Button_Keypad_Back	= UI.getChildControl( Panel_Login_Password, "Button_Back_Import" ),
	Button_Keypad_Clear	= UI.getChildControl( Panel_Login_Password, "Button_Clear_Import" ),
	Button_Apply		= UI.getChildControl( Panel_Login_Password, "Button_Apply_Import" ),
	Button_Cancel		= UI.getChildControl( Panel_Login_Password, "Button_Cancel_Import" ),
	Check_PasswordView	= UI.getChildControl( Panel_Login_Password, "CheckButton_NumberView" ),
	
	indexs				= Array.new(),
	
	state			= 0,
	isChangeTexture	= false
}
local UI_color = Defines.Color

function	loginPassword:init()
	UI.ASSERT( nil ~= self.Edit_Password		and 'number' ~= type(self.Edit_Password),		"Static_DisplayNumber_Import" )
	UI.ASSERT( nil ~= self.Button_Keypad_Back	and 'number' ~= type(self.Button_KeyPad_Back),	"Button_Back_Import" )
	UI.ASSERT( nil ~= self.Button_Keypad_Clear	and 'number' ~= type(self.Button_KeyPad_Clea),	"Button_Clear_Import" )
	UI.ASSERT( nil ~= self.Button_Apply			and 'number' ~= type(self.Button_Apply),		"Button_Apply_Import" )
	UI.ASSERT( nil ~= self.Button_Cancel		and 'number' ~= type(self.Button_Cancel),		"Button_Cancel_Import" )
	UI.ASSERT( nil ~= self.StaticText_Title		and 'number' ~= type(self.StaticText_Title),	"Static_Text_Title_Import" )
	UI.ASSERT( nil ~= self.Check_PasswordView	and 'number' ~= type(self.Check_PasswordView),	"CheckButton_NumberView" )
	
	for	ii = 0, self.config.indexMax-1	do
		local index = {}
		index.index	= ii
		index.button= UI.getChildControl( Panel_Login_Password, "Button_" .. ii .. "_Import" )
		index.button:addInputEvent("Mouse_Out",		"LoginPassword_ButtonMouseOut(" .. ii .. ")" )
		index.button:addInputEvent("Mouse_LDown",	"LoginPassword_ButtonBlind("..ii..")" )
		index.button:addInputEvent("Mouse_LUp",		"LoginPassword_Input(" .. ii .. ")" )
		index.baseText	= tostring(ii)
		UI.ASSERT( nil ~= index.button		and 'number' ~= type(index.button),		"Button_" .. ii .. "_Import" )
		self.indexs[ii]	= index
	end
	
	self.Button_Keypad_Back:SetPosX( self.config.startX + (self.config.gapX * (self.config.column-2)) )
	self.Button_Keypad_Back:SetPosY( self.config.startY + (self.config.gapY * self.config.row) )
	self.Button_Keypad_Clear:SetPosX( self.config.startX + (self.config.gapX * (self.config.column-1)) )
	self.Button_Keypad_Clear:SetPosY( self.config.startY + (self.config.gapY * self.config.row) )
	
	--registEventHandler()
	self.Button_Keypad_Back:addInputEvent(		"Mouse_LUp", "LoginPassword_Input_Back()")
	self.Button_Keypad_Clear:addInputEvent(		"Mouse_LUp", "LoginPassword_Input_Clear()")
	self.Button_Apply:addInputEvent(			"Mouse_LUp", "LoginPassword_Enter()")
	self.Button_Cancel:addInputEvent(			"Mouse_LUp", "LoginPassword_Cancel()")

	self.Button_Apply:ActiveMouseEventEffect( true )
	self.Button_Cancel:ActiveMouseEventEffect( true )
	
	self.Check_PasswordView:addInputEvent(		"Mouse_LUp", "CheckButton_Sound()" )
	--self.Edit_Password:SetSafeMode( true )
	--registMessageHandler()
	registerEvent( "EventOpenPassword",	"LoginPassword_Open" )
end

-------------------------------
-- 구현부
-------------------------------

function	LoginPassword_Open( isCreatePassword )
	LoginNickname_Close()
	
	if	( not lobbyPassword_UsePassword() )	then
		loginToGame()
		return
	end
	
	if ( isGameServiceTypeDev() ) then
		if( ToClient_UseConfigPassword() )	then
			loginToGame()
			return
		end
	end
	
	lobbyPassword_ClearIndexString( true )
	lobbyPassword_ClearIndexString( false )
	
	local	self		= loginPassword
	local	shuffleIndex= 0
	local	posX		= 0
	local	posY		= 0
	
	for	ii = 0, self.config.indexMax-1	do
		posX	= self.config.startX + ( self.config.gapX * (ii % self.config.column) )
		posY	= self.config.startY + ( self.config.gapY * math.floor(ii / self.config.column) )
		
		shuffleIndex	= lobbyPassword_getShuffleIndex( ii )
		self.indexs[shuffleIndex].index	= ii
		self.indexs[shuffleIndex].button:SetPosX( posX )
		self.indexs[shuffleIndex].button:SetPosY( posY )
		
	end
	
	self.Check_PasswordView:SetCheck( false )
	if	isCreatePassword	then
		self.state	= self.const.type_CreatePassword
	else
		self.state	= self.const.type_Authentic
	end
	
	if	self.const.type_CreatePassword	== self.state	then
		self.StaticText_Title:SetText( PAGetString(Defines.StringSheet_GAME, "SECONDARYPASSWORD_CREATE") )
	elseif	self.const.type_Authentic	== self.state	then
		self.StaticText_Title:SetText( PAGetString(Defines.StringSheet_GAME, "SECONDARYPASSWORD_INPUT") )
	end
	Panel_Login_ButtonDisable( true )
	LoginPassword_Update()
	
	if	not Panel_Login_Password:GetShow()	then
		Panel_Login_Password:SetShow(true)
	end
end

function	LoginPassword_Close()
	lobbyPassword_ClearIndexString( true )
	lobbyPassword_ClearIndexString( false )
	
	if	Panel_Login_Password:IsShow()	then
		Panel_Login_Password:SetShow(false)
	end
	Panel_Login_ButtonDisable( false )
end

function	LoginPassword_Enter()
	local	self		= loginPassword
	local	isTemporary	= (self.const.type_Reconfirm	== self.state)
	if	not lobbyPassword_checkPasswordLength( isTemporary )	then
		return;
	end
		
	if	self.const.type_CreatePassword	== self.state	then
		self.state	= self.const.type_Reconfirm
		self.StaticText_Title:SetText( PAGetString(Defines.StringSheet_GAME, "SECONDARYPASSWORD_IDENTIFY") )
		LoginPassword_Update()
		return;
	end
	
	if	self.const.type_Reconfirm == self.state	then
		if	not lobbyPassword_isEqualPassword()	then
			local	messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "SECONDARYPASSWORD_DIFFERENCE")
			local	messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "SECONDARYPASSWORD_NOTICE"), content = messageBoxMemo, functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
			MessageBox.showMessageBox(messageBoxData)
			
			LoginPassword_Open( true )
			return
		end
	end
	
	loginToGame()
	LoginPassword_Close()
end

function	LoginPassword_Cancel()
	-- 개발일 경우 비번 취소를 할경우 창이 닫히도록하게 한다.( 김혜조 )
	if true == isGameServiceTypeDev() then
		lobbyPassword_ClearIndexString( true )
		lobbyPassword_ClearIndexString( false )
		Panel_Login_Password:SetShow(false)
	else
		local	messageBoxMemo	= PAGetString(Defines.StringSheet_GAME, "GAME_EXIT_MESSAGEBOX_MEMO")
		local	messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "GAME_EXIT_MESSAGEBOX_TITLE"), content = messageBoxMemo, functionYes = LoginPassword_CancelEnd, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
	end
	Panel_Login_ButtonDisable( false )
end

function	LoginPassword_CancelEnd()
	disConnectToGame()	
	GlobalExitGameClient()
end

function	LoginPassword_ButtonBlind(index)
	local	self		= loginPassword
	
	for	ii = 0, self.config.indexMax-1	do
		--self.indexs[ii].button:SetFontColor(UI_color.C_00341A1B)
		self.indexs[ii].button:SetText( "" )
		-- self.indexs[ii].button:ChangeClickTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
		-- local x1, y1, x2, y2 = setTextureUV_Func( self.indexs[ii].button, 226, 96, 255, 125 )
		-- self.indexs[ii].button:getClickTexture():setUV(  x1, y1, x2, y2  )
		-- self.indexs[ii].button:setRenderTexture(self.indexs[ii].button:getClickTexture())
	end
	
	self.isChangeTexture	= true
end

function	LoginPassword_ButtonInit()
	local	self		= loginPassword
	
	for	ii = 0, self.config.indexMax-1	do
		self.indexs[ii].button:SetText( self.indexs[ii].baseText )
		--self.indexs[ii].button:SetFontColor(UI_color.C_FFFFFFFF)
		-- self.indexs[ii].button:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")	-- 버튼 리스트 노멀
		-- local x1, y1, x2, y2 = setTextureUV_Func( self.indexs[ii].button, 94, 1, 123, 30 )
		-- self.indexs[ii].button:getBaseTexture():setUV(  x1, y1, x2, y2  )
		-- self.indexs[ii].button:setRenderTexture(self.indexs[ii].button:getBaseTexture())
	end
	self.isChangeTexture	= false
end

function	LoginPassword_ButtonMouseOut( index )
	--UI.debugMessage( 'LoginPassword_ButtonMouseOut(' .. index .. ')' )
	-- local	self		= loginPassword
	-- if	self.isChangeTexture	then
		LoginPassword_ButtonInit()
	-- else
		-- self.indexs[index].button:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")	-- 버튼 리스트 노멀
		-- local x1, y1, x2, y2 = setTextureUV_Func( self.indexs[index].button, 94, 1, 123, 30 )
		-- self.indexs[index].button:getBaseTexture():setUV(  x1, y1, x2, y2  )
		-- self.indexs[index].button:setRenderTexture(self.indexs[index].button:getBaseTexture())
	-- end
end

function	LoginPassword_Input( index )
	local	self		= loginPassword
	local	isTemporary	= (self.const.type_Reconfirm	== self.state)
	local	shuffleIndex= self.indexs[index].index
	
	LoginPassword_ButtonInit()
	lobbyPassword_AddIndexString( shuffleIndex, isTemporary )
	LoginPassword_Update()
end

function	LoginPassword_Input_Back()
	local	self		= loginPassword
	local	isTemporary	= (self.const.type_Reconfirm	== self.state)
	
	lobbyPassword_BackIndexString( isTemporary )
	LoginPassword_Update()
end

function	LoginPassword_Input_Clear()
	local	self		= loginPassword
	local	isTemporary	= (self.const.type_Reconfirm	== self.state)

	lobbyPassword_ClearIndexString( isTemporary )
	LoginPassword_Update()
end

function	CheckButton_Sound()
	audioPostEvent_SystemUi(00,00)
	LoginPassword_Update()
end

function	LoginPassword_Update()
	local	self		= loginPassword
	local	isTemporary	= (self.const.type_Reconfirm == self.state)
	
	self.Edit_Password:SetText( lobbyPassword_GetIndexString( not self.Check_PasswordView:IsCheck(), isTemporary) )
end

loginPassword:init()