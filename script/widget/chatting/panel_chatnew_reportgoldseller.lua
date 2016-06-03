-----------------------------------------------------------
-- Local 변수 설정
-----------------------------------------------------------
local UI_PUCT 		= CppEnums.PA_UI_CONTROL_TYPE
local UI_color 		= Defines.Color
local UI_TM			= CppEnums.TextMode
local UI_CT 		= CppEnums.ChatType
local UI_CNT	 	= CppEnums.EChatNoticeType
local UI_Group 		= Defines.UIGroup
local IM			= CppEnums.EProcessorInputMode

local reportSeller =
{
	panel_Title				= UI.getChildControl(Panel_Chatting_Block_GoldSeller, 'StaticText_Title'),
	inputNameBG				= UI.getChildControl(Panel_Chatting_Block_GoldSeller, 'Static_BG'),
	title_UserName			= UI.getChildControl(Panel_Chatting_Block_GoldSeller, 'StaticText_Title_UserName'),
	edit_UserName			= UI.getChildControl(Panel_Chatting_Block_GoldSeller, 'Edit_Value_UserName'),
	report_Notify			= UI.getChildControl(Panel_Chatting_Block_GoldSeller, 'StaticText_ReportNotice'),
	chattingMsgBG			= UI.getChildControl(Panel_Chatting_Block_GoldSeller, 'Static_ChattingMsgBG'),
	str_ChatLog				= UI.getChildControl(Panel_Chatting_Block_GoldSeller, 'StaticText_ChattingMsg'),
	btn_Confirm				= UI.getChildControl(Panel_Chatting_Block_GoldSeller, 'Button_Confirm'),
	btn_Cancel				= UI.getChildControl(Panel_Chatting_Block_GoldSeller, 'Button_Cancel'),

	data					= {
		reportUserName	= nil,
		reportUserMsg	= nil,
	}
}

function reportSeller:init()
	self.report_Notify:SetTextMode( UI_TM.eTextMode_AutoWrap )
	self.report_Notify:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_CHAT_REPORT_GOLD_SELLER_NOTIFY") )
		-- "Enter the Gold Seller Spam Bots name in the field above to flag it for GM review.\nThis report Should be only for Gold Seller Spam Bots, abuse of this report against players will result in a suspension of your account." 
	self.str_ChatLog:SetTextMode( UI_TM.eTextMode_Limit_AutoWrap )
	self.str_ChatLog:setLineCountByLimitAutoWrap(7)
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
end

function reportSeller:update()
	if nil ~= self.data.reportUserName and nil ~= self.data.reportUserMsg then
		self.panel_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_CHAT_REPORT_GOLD_SELLER_TITLE", "name", self.data.reportUserName ) )	-- "Report Gold Seller : " .. self.data.reportUserName
		self.edit_UserName:SetEditText( "" )
		SetFocusEdit( self.edit_UserName )
		self.str_ChatLog:SetText( self.data.reportUserMsg )
		self.chattingMsgBG:SetSize( self.chattingMsgBG:GetSizeX(), self.str_ChatLog:GetTextSizeY()+20 )
		self.str_ChatLog:SetSize(self.str_ChatLog:GetSizeX(), self.str_ChatLog:GetTextSizeY())
		Panel_Chatting_Block_GoldSeller:SetSize( Panel_Chatting_Block_GoldSeller:GetSizeX(), self.inputNameBG:GetSizeY()+self.str_ChatLog:GetTextSizeY()+150 )
		self.btn_Confirm	:SetSpanSize( self.btn_Confirm:GetSpanSize().x, 15 )
		self.btn_Cancel		:SetSpanSize( self.btn_Cancel:GetSpanSize().x, 15 )
	end
end

function reportSeller:Open()
	Panel_Chatting_Block_GoldSeller:SetShow( true )
	self:update()
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
end

function reportSeller:Close()
	self.data.reportUserName	= nil
	self.data.reportUserMsg		= nil
	ClearFocusEdit()
	Panel_Chatting_Block_GoldSeller:SetShow( false )
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
end

function HandleClicked_reportSeller_Close()
	reportSeller:Close()
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
end

function HandleClicked_reportSeller_Confirm()
	if "" == reportSeller.edit_UserName:GetEditText() or nil == reportSeller.edit_UserName:GetEditText() then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CHAT_REPORT_GOLD_SELLER_NO_NAME") )	--	"Not Input Character Name"
		return
	end

	local typeSpell			= reportSeller.edit_UserName:GetEditText()
	local typeSpellCheck	= ( "Yes" == typeSpell ) or ( "YES" == typeSpell ) or ( "yes" == typeSpell ) or ( "Ja" == typeSpell ) or ( "ja" == typeSpell ) or ( "JA" == typeSpell ) or ( "Oui" == typeSpell ) or ( "oui" == typeSpell ) or ( "OUI" == typeSpell )
	if false == typeSpellCheck then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CHAT_REPORT_GOLD_SELLER_NOT_MATCH") )	--	"Not Match Character Name"
		return
	end

	local messageContent = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_CHAT_REPORT_GOLD_SELLER_CHECK_AGAIN", "name", reportSeller.data.reportUserName )	-- "Are you sure Report [" .. reportSeller.data.reportUserName .. "] ?"
	local messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "GUILD_MESSAGEBOX_TITLE"), content = messageContent, functionYes = _reportSeller_ConfirmDo, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData)

	ClearFocusEdit()
end

function _reportSeller_ConfirmDo()
	ToClient_BlockChatWithItem( reportSeller.data.reportUserName, reportSeller.data.reportUserMsg )
	reportSeller:Close()
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
end

function FGlobal_reportSeller_Open( userName, userMsg )
	reportSeller.data.reportUserName	= userName
	reportSeller.data.reportUserMsg		= userMsg

	reportSeller:Open()
end

function FGlobal_reportSeller_Close()
	reportSeller:Close()
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
end

function reportSeller_OnscreenResize()
	Panel_Chatting_Block_GoldSeller:ComputePos()
end

function HandleClicked_reportSeller_EditBox()
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
end

function reportSeller:registEventHandler()
	self.btn_Cancel		:addInputEvent( "Mouse_LUp",	"HandleClicked_reportSeller_Close()")
	self.btn_Confirm	:addInputEvent( "Mouse_LUp",	"HandleClicked_reportSeller_Confirm()")
	self.edit_UserName	:addInputEvent( "Mouse_LUp",	"HandleClicked_reportSeller_EditBox()")
	self.edit_UserName	:RegistReturnKeyEvent(			"HandleClicked_reportSeller_Confirm()" )
end

function reportSeller:registMessageHandler()
	registerEvent( "onScreenResize", "reportSeller_OnscreenResize" )
end

reportSeller:init()
reportSeller:registEventHandler()
reportSeller:registMessageHandler()