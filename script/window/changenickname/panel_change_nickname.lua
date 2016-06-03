local UIMode 	= Defines.UIMode
local IM 		= CppEnums.EProcessorInputMode
-------------------------------
-- Panel Init
-------------------------------
Panel_ChangeNickname:SetShow(false, false)
Panel_ChangeNickname:setGlassBackground(true)
-------------------------------
-- Control Regist & Init
-------------------------------
local	changeNickname	= {
	edit_Nickname	= UI.getChildControl( Panel_ChangeNickname,	"Edit_Nickname" ),
	button_OK		= UI.getChildControl( Panel_ChangeNickname,	"Button_Apply_Import" ),
	button_Cancel	= UI.getChildControl( Panel_ChangeNickname,	"Button_Cancel_Import" ),
}

function	changeNickname:init()
	UI.ASSERT( nil ~= self.edit_Nickname	and 'number' ~= type(self.edit_Nickname),	"Edit_Nickname" )
	UI.ASSERT( nil ~= self.button_OK		and 'number' ~= type(self.button_OK),		"Button_Apply_Import" )
	UI.ASSERT( nil ~= self.button_Cancel	and 'number' ~= type(self.button_Cancel),	"Button_Cancel_Import" )
	
	--registEventHandler()
	self.button_OK:addInputEvent(		"Mouse_LUp", "handleClicked_ChangeNickname()"		)
	self.button_Cancel:addInputEvent(	"Mouse_LUp", "ChangeNickname_Close()"	)
	self.edit_Nickname:addInputEvent("Mouse_LUp", "handleClicked_ClickEdit()")
	
	--registMessageHandler()
	
	registerEvent( "FromClient_ShowChangeNickname",	"FromClient_ShowChangeNickname" )
end

-------------------------------
-- 구현부
-------------------------------
function	handleClicked_ClickEdit()
	if( not Panel_ChangeNickname:IsShow() ) then
		return
	end

	local	self	= changeNickname
	UI.Set_ProcessorInputMode( IM.eProcessorInputMode_ChattingInputMode )
	self.edit_Nickname:SetMaxInput( getGameServiceTypeUserNickNameLength() );
	SetFocusEdit( self.edit_Nickname );
end

function	handleClicked_ChangeNickname()
	local	self	= changeNickname	
	
	
	ToClient_ChangeNickName(self.edit_Nickname:GetEditText())
	ChangeNickname_Close()
end

function	FromClient_ShowChangeNickname()
	if	not Panel_ChangeNickname:IsShow()	then
		Panel_ChangeNickname:SetShow(true)
		
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
	end
	
	local	self	= changeNickname
	self.edit_Nickname:SetEditText("")
	self.edit_Nickname:SetMaxInput( getGameServiceTypeUserNickNameLength() )

	SetFocusEdit( self.edit_Nickname )
end

function	ChangeNickname_Close()
	local	self	= changeNickname
	self.edit_Nickname:SetEditText("")

	if	Panel_ChangeNickname:IsShow()	then
		Panel_ChangeNickname:SetShow(false)
		
		ClearFocusEdit()
		if( AllowChangeInputMode() ) then
			if( check_ShowWindow() ) then
				UI.Set_ProcessorInputMode( IM.eProcessorInputMode_UiMode )
			else
				UI.Set_ProcessorInputMode( IM.eProcessorInputMode_GameMode)
			end
		else
			SetFocusChatting()
		end
	end	
end

changeNickname:init()

--FromClient_ShowChangeNickname()
