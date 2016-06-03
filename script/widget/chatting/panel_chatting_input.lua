Panel_Chatting_Input:SetShow(false, false)
Panel_Chatting_Input:SetDragEnable( true )
Panel_Chatting_Input:SetDragAll( true )
Panel_Chatting_Input:RegisterShowEventFunc( true, 'ChattingShowAni()' )
Panel_Chatting_Input:RegisterShowEventFunc( false, 'ChattingHideAni()' )

--local sentChatMsg = Array.new()
local sentChatMsgCnt = 0
local curChatMsgCnt = 0
local lastChatHistory = ''

--local sentWhisperMsg = Array.new()
local sentWhisperMsgCnt = 0
local curWhisperMsgCnt = 0
local lastWhisperHistory = ''
		

local IM		= CppEnums.EProcessorInputMode
local VCK		= CppEnums.VirtualKeyCode
local UI_CT		= CppEnums.ChatType
local UI_PSFT	= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color	= Defines.Color

local isLocalWar	= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 43 )		-- 붉은 전장 컨텐츠

local chatInput =
{
	config =
	{
		startPosX = 7,
		startPosY = 7,
		btnPosYGap = 21
	},
	control =
	{
		edit 				= UI.getChildControl( Panel_Chatting_Input, "Edit_ChatMessage" ),
		dragButton 			= UI.getChildControl( Panel_Chatting_Input, "Button_Drag" ),
		buttons 			= Array.new(),
		whisperEdit 		= UI.getChildControl( Panel_Chatting_Input, "Edit_WhisperName" ),
		noticeShortcut 		= UI.getChildControl( Panel_Chatting_Input, "StaticText_Notice_Shortcut" ),
		whisperNotice 		= UI.getChildControl( Panel_Chatting_Input, "StaticText_Whisper_Notice" ),
		macroButton 		= UI.getChildControl( Panel_Chatting_Input, "RadioButton_Macro" ),
		socialButton		= UI.getChildControl( Panel_Chatting_Input, "RadioButton_SocialAction" )
	},
	buttonIds =
	{
		[0] = nil,
		[1] =	'Button_Anounce',		-- Notice
		[2] =	'Button_World',			-- World
		[3] =	'Button_Normal',		-- Public
		[4] =	'Button_Whisper',		-- Private
		[5] =	'Button_System',		-- System
		[6] =	'Button_Party',			-- Party
		[7] =	'Button_Guild',			-- Guild
		-- [8] =	nil,
		-- [9] =	nil,
		-- [10] =	nil,
		-- [11] =	nil,
		[12] =	'Button_WorldWithItem',	-- WorldServerChat(With Cash)
		[14] =	'Button_LocalWar',
		[15] =	'Button_RolePlay',
	},
	permissions = Array.new(),
	lastChatType = UI_CT.Public,
	isChatTypeChangedMode = false,
	maxEditInput = 100,
	linkedItemCount = 0,
	maxLinkedItemCount = 1,
	linkedItemData = 
	{
		[0] = nil,
	}
	
}

local checkFocusWhisperEdit = false
local toChangeChatType = UI_CT.Public		-- 전체

--[[
-- 포커스 관련 처리
-- 작성자 : who1310
--]]--
function AllowChangeInputMode()
	return not Panel_Chatting_Input:IsShow();
end

function SetFocusChatting()
	SetFocusEdit( chatInput.control.edit ); 
	UI.Set_ProcessorInputMode(CppEnums.EProcessorInputMode.eProcessorInputMode_ChattingInputMode)
end

function FromClient_GroundMouseClickForChatting()
	if( false == AllowChangeInputMode() ) then
		SetFocusChatting();
	end
end

function isFocusInChatting()
	local focusEdit = GetFocusEdit();
	local editControl = chatInput.control.edit;
	local whisperControl = chatInput.control.whisperEdit;
	
	if( nil == focusEdit ) then
		return false;
	end
	
	if( focusEdit:GetID() == editControl:GetID()
	or focusEdit:GetID() == whisperControl:GetID() ) then
		return true
	end

	return false	
end

-- 포커스 관련 처리 끝
-----------------------------------------------------------------

-- !(일반) @(전체) #(파티) $(매매) %(길드) &(연합)
local chatShortCutKey =
{
	-1,					-- Notice(공지)		// 단축키 없음
	VCK.KeyCode_2,		-- World (전체)		
	VCK.KeyCode_1,		-- Public(일반)		
	VCK.KeyCode_3,	    -- Private(귓속말)	
	-1,					-- System(시스템메시지)	// 단축키 없음
	VCK.KeyCode_4,		-- Party(파티)		
	VCK.KeyCode_5,		-- Guild(길드)
	-1,
	-1,
	-1,
	-1,
	VCK.KeyCode_6,		-- 템 사용 전체 채팅
	-- VCK.KeyCode_6,	-- 연합				
	-- VCK.KeyCode_7,	-- 매매				
	-1,
	VCK.KeyCode_7,
	VCK.KeyCode_8,		-- 북미/롤플레이
}

local chatShortCutKey_Value = 
{
	-1,		-- Notice(공지)		// 단축키 없음
	2,		-- World (전체)		
	1,		-- Public(일반)		
	3,	    -- Private(귓속말)	
	-1,		-- System(시스템메시지)	// 단축키 없음
	4,		-- Party(파티)		
	5,		-- Guild(길드)
	-1,
	-1,
	-1,
	-1,
	6,		-- 서버 전체 메시지(템사용)
	-1,
	7,
	8,
}
chatInput.control.dragButton:SetShow(false)

function ChattingShowAni()
	-- Panel_Chatting_Input:ResetVertexAni()
	Panel_Chatting_Input:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_IN)
	local aniInfo = Panel_Chatting_Input:addColorAnimation( 0.0, 0.12, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	aniInfo:SetStartColor( UI_color.C_00FFFFFF )
	aniInfo:SetEndColor( UI_color.C_FFFFFFFF )
	aniInfo.IsChangeChild = true

	local aniInfo1 = Panel_Chatting_Input:addScaleAnimation( 0.0, 0.12, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.1)
	aniInfo1:SetEndScale(1.25)
	aniInfo1.AxisX = Panel_Chatting_Input:GetSizeX() / 2
	aniInfo1.AxisY = Panel_Chatting_Input:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_Chatting_Input:addScaleAnimation( 0.12, 0.18, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.25)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_Chatting_Input:GetSizeX() / 2
	aniInfo2.AxisY = Panel_Chatting_Input:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function ChattingHideAni()
	-- Panel_Chatting_Input:ResetVertexAni()
	Panel_Chatting_Input:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
	local aniInfo3 = Panel_Chatting_Input:addColorAnimation( 0.0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo3:SetStartColor( UI_color.C_FFFFFFFF )
	aniInfo3:SetEndColor( UI_color.C_00FFFFFF )
	aniInfo3.IsChangeChild = true
	aniInfo3:SetHideAtEnd(true)
	aniInfo3:SetDisableWhileAni(true)	
end

function chatInput:init()
	for idx,strId in pairs(self.buttonIds) do
		if nil ~= strId then
			local button = UI.getChildControl( Panel_Chatting_Input, strId )
			button:SetPosX( self.config.startPosX )
			button:SetPosY( self.config.startPosY )
			button:SetShow( false )
			self.control.buttons[idx] = button
		end
	end

	if isGameTypeKorea() then
		self.maxEditInput = 100
	elseif isGameTypeEnglish() then
		self.maxEditInput = 350
	else
		self.maxEditInput = 100
	end

	self.control.buttons[ self.lastChatType ]:SetShow( true )
	self.control.edit:SetMaxInput( self.maxEditInput )
	self.permissions:resize( #self.buttonIds, false )
	
	self.control.whisperNotice:SetSize(270, 20)
	self.control.whisperNotice:SetText(PAGetString(  Defines.StringSheet_GAME,  "CHATTING_WHISPER_NOTICE"))
end

function chatInput:checkLoad()
	UI.ASSERT( (nil ~= self.control.edit)			and ('PAUIEdit' == self.control.edit.__name),			"Can't Find Control " .. self.control.edit.__name)
	UI.ASSERT( (nil ~= self.control.dragButton)		and ('PAUIButton' == self.control.dragButton.__name),	"Can't Find Control " .. self.control.dragButton.__name )

	for _,ctrl in pairs(self.control.buttons) do
		UI.ASSERT( (nil ~= ctrl)					and ('PAUIButton' == ctrl.__name),						"Can't Find Control " .. ctrl.__name )
	end
end

function chatInput:clearLinkedItem()
	self.linkedItemCount = 0
	for i=0, self.maxLinkedItemCount-1, 1 do
		self.linkedItemData[i] = nil
	end
	self.control.edit:SetCursorMove( true )
end

-- 마우스로 ChatType 을 바꿀때. 애니메이션 있음.
function ChatInput_TypeButtonClicked( chatType )
	local isWolrdChat	= chatting_isPossibleWorldChatWithItem()
	if 12 == chatType and (not isWolrdChat) then
		return
	end

	local self			= chatInput
	local button		= self.control.buttons[ chatType ]
	if self.isChatTypeChangedMode then
		local permission = self.permissions[ chatType ]
		if permission then
			-- 접는 애니메이션
			for _,btn in pairs(self.control.buttons) do
				btn:SetShow( false )
			end
			button:SetShow( true )
			button:SetPosY( self.config.startPosY )
			-- End of 접는 애니메이션
			self.isChatTypeChangedMode = false
			SetFocusEdit( self.control.edit )
			checkFocusWhisperEdit = false
			if (self.lastChatType == UI_CT.World) or (self.lastChatType == UI_CT.Guild) or (self.lastChatType == UI_CT.Public) or ( self.lastChatType == UI_CT.Party) or ( self.lastChatType == UI_CT.WorldWithItem) or ( self.lastChatType == UI_CT.LocalWar) then
				self.control.edit:SetEditText('', true)
				ToClient_ClearLinkedItemList()
				chatInput:clearLinkedItem()
			end
			self.lastChatType = chatType
			toChangeChatType = chatType
			if (UI_CT.Private == chatType) then  
				--self.control.whisperEdit:SetEditText('', true)
				self.control.whisperEdit:SetShow(true)
				self.control.whisperNotice:SetPosX(self.control.whisperEdit:GetPosX() - 50)
				self.control.whisperNotice:SetPosY(self.control.whisperEdit:GetPosY() - 25)
				self.control.whisperNotice:SetShow(true)
				-- 귓속말 할 때, 매크로 버튼 위치 바꿈
				self.control.macroButton:SetPosX( self.control.whisperEdit:GetPosX() + self.control.whisperEdit:GetSizeX() )
				self.control.socialButton:SetPosX( self.control.whisperEdit:GetPosX() + self.control.whisperEdit:GetSizeX() + 30 )
			else
				self.control.whisperEdit:SetShow(false)
				self.control.whisperNotice:SetShow(false)
				-- 귓속말 안할 때, 매크로 버튼 위치 바꿈
				self.control.macroButton:SetPosX( self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 10 )
				self.control.socialButton:SetPosX( self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 40 )
			end
			
			--[[
			if (UI_CT.World == chatType) or (UI_CT.Guild == chatType) or (UI_CT.Public == chatType) or (UI_CT.Party == chatType) then
				self.control.edit:SetCursorMove( false )
			else
				self.control.edit:SetCursorMove( true )
			end
			]]--
		end
	else
		local posY = self.config.startPosY
		for idx,btn in pairs(self.control.buttons) do
			if true == isWolrdChat then
				if idx ~= chatType then
					if self.permissions[ idx ] then
						posY = posY - self.config.btnPosYGap
						btn:SetPosY( posY )
						btn:SetShow( true )
					end
				end
			else
				if idx ~= chatType and idx ~= 12 then
					if self.permissions[ idx ] then
						posY = posY - self.config.btnPosYGap
						btn:SetPosY( posY )
						btn:SetShow( true )
					end
				end
			end
		end
		self.isChatTypeChangedMode = true
		-- 펼치는 애니메이션. permission 있는 것들만!
	end
end

-- Keyboard 단축키로 ChatType 을 바꿀때. 즉시 변경됨
function ChatInput_ChangeChatType_Immediately( chatType )
	local isWolrdChat	= chatting_isPossibleWorldChatWithItem()
	if 12 == chatType and (not isWolrdChat) then
		return
	end
	local self = chatInput
	local permission = self.permissions[ chatType ]
	local button = self.control.buttons[ chatType ]
	if (self.lastChatType ~= chatType) then
		-- 권한이 있어야 가능함.
		if permission then
			for _,btn in pairs(self.control.buttons) do
				btn:SetShow( false )
			end
			button:SetShow( true )
			button:SetPosY( self.config.startPosY )	
			--self.control.edit:SetEditText('', true)
			SetFocusEdit( self.control.edit )
			checkFocusWhisperEdit = false
			if (self.lastChatType == UI_CT.World) or (self.lastChatType == UI_CT.Guild) or (self.lastChatType == UI_CT.Public) or ( self.lastChatType == UI_CT.Party) or ( self.lastChatType == UI_CT.WorldWithItem) or ( self.lastChatType == UI_CT.LocalWar) then
				self.control.edit:SetEditText('', true)
				ToClient_ClearLinkedItemList()
				chatInput:clearLinkedItem()
			end
			self.lastChatType = chatType
			if (UI_CT.Private == chatType) then  
				--self.control.whisperEdit:SetEditText('', true)
				self.control.whisperEdit:SetShow(true)
				self.control.whisperNotice:SetPosX(self.control.whisperEdit:GetPosX() - 50)
				self.control.whisperNotice:SetPosY(self.control.whisperEdit:GetPosY() - 25)
				self.control.whisperNotice:SetShow(true)
				-- 귓속말 할 때, 매크로 버튼 위치 바꿈
				self.control.macroButton:SetPosX( self.control.whisperEdit:GetPosX() + self.control.whisperEdit:GetSizeX() )
				self.control.socialButton:SetPosX( self.control.whisperEdit:GetPosX() + self.control.whisperEdit:GetSizeX() + 30 )
			else
				self.control.whisperEdit:SetShow(false)
				self.control.whisperNotice:SetShow(false)
				-- 귓속말 안할 때, 매크로 버튼 위치 바꿈
				self.control.macroButton:SetPosX( self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 10 )
				self.control.socialButton:SetPosX( self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 40 )
			end
			
			--[[
			if (UI_CT.World == chatType) or (UI_CT.Guild == chatType) or (UI_CT.Public == chatType) or (UI_CT.Party == chatType) then
				self.control.edit:SetCursorMove( false )
			else
				self.control.edit:SetCursorMove( true )
			end
			]]--
		end
	end	
end

function ChatInput_UpdatePermission()
	-- UI.debugMessage('Permission Update')
	local self = chatInput
	local selfPlayerWrapper = getSelfPlayer()
	self.permissions:resize( #self.buttonIds, false )
	if nil ~= selfPlayerWrapper then
		self.permissions[ UI_CT.World ] = true
		self.permissions[ UI_CT.Public ] = true
		self.permissions[ UI_CT.Private ] = true
		if isGameServiceTypeDev() then
			self.permissions[ UI_CT.WorldWithItem ] = true
			self.permissions[ UI_CT.RolePlay ] = true
		elseif isGameTypeKorea() then
			self.permissions[ UI_CT.WorldWithItem ] = true
		elseif isGameTypeJapan() then
			self.permissions[ UI_CT.WorldWithItem ] = true
		elseif isGameTypeEnglish() then
			local myLevel = getSelfPlayer():get():getLevel()
			if myLevel < 20 then
				self.permissions[ UI_CT.WorldWithItem ] = false
			else
				self.permissions[ UI_CT.WorldWithItem ] = true
			end
			self.permissions[ UI_CT.RolePlay ] = true
		else
			self.permissions[ UI_CT.WorldWithItem ] = false
		end
		--self.permissions[ UI_CT.Market ] = true

		if selfPlayerWrapper:get():isGuildMember() then
			self.permissions[ UI_CT.Guild ] = true
		end

		if selfPlayerWrapper:get():hasParty() then
			self.permissions[ UI_CT.Party ] = true
		end
		if isLocalWar then
			self.permissions[ UI_CT.LocalWar ] = true
		end
	end

	for chatType,btn in pairs(self.control.buttons) do
		-- nil, false => true
		local perm = self.permissions[ chatType ]
		-- UI.debugMessage( tostring(perm) )
		local disAllowed = not self.permissions[ chatType ]
		btn:SetMonoTone( disAllowed )
	end
	-- UI.debugMessage('Permission Update Complete')
end

function chatInput:registEventHandler()
	for chatType,button in pairs(self.control.buttons) do
		button:addInputEvent( "Mouse_On", 'ChatInput_TypeButtonOn(' .. chatType .. ')' )
		button:addInputEvent( "Mouse_Out", 'ChatInput_TypeButtonOut(' .. chatType .. ')' )
		button:addInputEvent( "Mouse_LUp", 'ChatInput_TypeButtonClicked(' .. chatType .. ')' )
	end

	self.control.edit:RegistReturnKeyEvent( "ChatInput_PressedEnter()" )
end

-- 메시지가 있다면, 메시지를 보내고 닫는다.
-- 권한이 없는데 Enter 를 눌렀다면, 에러 메시지를 밷는다.
function ChatInput_SendMessage()
	local self = chatInput
	
	if self.permissions[self.lastChatType] then
		local target = self.control.whisperEdit:GetEditText()
		local message = self.control.edit:GetEditText()
		-- UI.debugMessage('call send Message')
		chatting_sendMessage( target, message, self.lastChatType )
		chatting_saveMessageHistory( target, message )
	end
		
		--[[
		if CppEnums.ChatType.Private == self.lastChatType and '' ~= target and lastWhisperHistory ~= target then		
			--if 10 < sentWhisperMsgCnt then
			--	sentWhisperMsgCnt = 1
			--end
			lastWhisperHistory = target
			sentWhisperMsg[sentWhisperMsgCnt % 10] = target
			sentWhisperMsgCnt = sentWhisperMsgCnt + 1 
			curWhisperMsgCnt = sentWhisperMsgCnt
		end
		
		if '' ~= message and lastChatHistory ~= message then
			--if 10 < sentChatMsgCnt then
			--	sentChatMsgCnt = 0
			--end
			lastChatHistory = message
			sentChatMsg[sentChatMsgCnt % 10] = message
			sentChatMsgCnt = sentChatMsgCnt + 1 
		end
	
	end
	curChatMsgCnt = sentChatMsgCnt
	-- UI.debugMessage('clear Message')
	]]--
	
	
	self.control.edit:SetEditText('', true)
	
end

function ChatInput_CancelMessage()
	local self = chatInput
	curChatMsgCnt = sentChatMsgCnt
	self.control.edit:SetEditText('', true)
end

function ChatInput_PressedEnter()
	if Panel_Chatting_Input:IsShow() then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
		ChatInput_CancelAction()
		ChatInput_SendMessage()
		ChatInput_Close()
		ClearFocusEdit()
--	else
--		ChatInput_Show()
--		curChatMsgCnt 		= chatting_getMessageHistoryCount()
--		curWhisperMsgCnt 	= chatting_getTargetHistoryCount()
	end
end

function ChatInput_PressedUp()
	if checkFocusWhisperEdit then
		curWhisperMsgCnt = curWhisperMsgCnt - 1
		if curWhisperMsgCnt < 0 then
			curWhisperMsgCnt = chatting_getTargetHistoryCount() - 1
		end
		local whisperHistory = chatting_getTargetHistoryByIndex(curWhisperMsgCnt)
		
		if nil ~= whisperHistory then
			chatInput.control.whisperEdit:SetEditText(whisperHistory, true)
		end
	else
		curChatMsgCnt = curChatMsgCnt-1
		if curChatMsgCnt < 0 then
			curChatMsgCnt = chatting_getMessageHistoryCount() - 1
		end
		local messageHistory = chatting_getMessageHistoryByIndex(curChatMsgCnt)
		
		if nil ~= messageHistory then
			chatInput.control.edit:SetEditText(messageHistory, true)
		end
	end
	
end

-- 0 = 일반	,	1=전체	,	3=귓속말     ,4=파티	,	5=길드	,	6=연합	,	7=매매
function ChatInput_TypeButtonOn(chatType)
	local isWolrdChat	= chatting_isPossibleWorldChatWithItem()
	if 12 == chatType and (not isWolrdChat) then
		return
	end
	local self = chatInput
	local button = self.control.buttons[ chatType ]
	
	self.control.noticeShortcut:SetColor(Defines.Color.C_FF000000)
	self.control.noticeShortcut:SetPosX(button:GetPosX() - self.control.noticeShortcut:GetSizeX())
	self.control.noticeShortcut:SetPosY(button:GetPosY() - 10)
	self.control.noticeShortcut:SetText("(ALT + "..tostring(chatShortCutKey_Value[chatType])..")")
	self.control.noticeShortcut:SetShow(true)
end

function ChatInput_TypeButtonOut(chatType)
	local self = chatInput
	self.control.noticeShortcut:SetShow(false)
end

-- Alt Key Pressed 는 호출자에서 확인했다!
function ChatInput_CheckReservedKey()
	local self = chatInput
	local chatMessage = self.control.edit:GetEditText()
	local chatMessageLength = string.len( chatMessage )

	for chatType,KeyCode in pairs(chatShortCutKey) do
		if (-1 ~= KeyCode) and isKeyDown_Once( KeyCode ) then
			toChangeChatType = chatType
		end
	end
	if self.isChatTypeChangedMode then
		-- 마우스로 변경중이었으면, 해당 타입으로 클릭과 동일한 효과를 낸다!
		ChatInput_TypeButtonClicked( toChangeChatType )
	else
		-- 즉시 변경한다!
		ChatInput_ChangeChatType_Immediately( toChangeChatType )
	end
end

local lastWhispersId = ""
local lastWhispersTick = 0
local lastPartyTick = 0
local lastGuildTick = 0
function ChatInput_SetLastWhispersUserId( WhispersId )
	lastWhispersId 		= WhispersId
end
function ChatInput_SetLastWhispersTick()
	lastWhispersTick	= getTickCount32();
end
function ChatInput_GetLastWhispersUserId()
	return lastWhispersId
end
function ChatInput_GetLastWhispersTick()
	return lastWhispersTick
end

function ChatInput_SetLastPartyTick()
	lastPartyTick	= getTickCount32();
end
function ChatInput_GetLastPartyTick()
	return lastPartyTick
end
function ChatInput_SetLastGuildTick()
	lastGuildTick	= getTickCount32();
end
function ChatInput_GetLastGuildTick()
	return lastGuildTick
end



function ChatInput_IsInstantCommand_Whisper( str )
	return (str == "/w" or str == "/ㅈ" or str == "/whisper" or str == "/귓속말" or str == "/귓")
end
function ChatInput_IsInstantCommand_Reply( str )
	return (str == "/r" or str == "/ㄱ" or str == "/reply" or str == "/대답" or str == "/대")
end

function ChatInput_IsInstantCommand_Normal( str )
	return (str == "/s" or str == "/ㄴ" or str == "/일반" or str == "/일")
end
function ChatInput_IsInstantCommand_World( str )
	return (str == "/y" or str == "/ㅛ" or str == "/yell" or str == "/외침" or str == "/외")
end
function ChatInput_IsInstantCommand_Party( str )
	return (str == "/p" or str == "/ㅔ" or str == "/party" or str == "/파티" or str == "/파")
end
function ChatInput_IsInstantCommand_Guild( str )
	return (str == "/g" or str == "/ㅎ" or str == "/guild" or str == "/길드" or str == "/길")
end
function ChatInput_IsInstantCommand_WithItem( str )
	return (str == "/a" or str == "/ㅁ" or str == "/all" or str == "/전체" or str == "/전")
end
function ChatInput_IsInstantCommand_LocalWar( str )
	return (str == "/b" or str == "/ㅠ" or str == "/war" or str == "/전장")
end

function ChatInput_CheckInstantCommand()
	local self = chatInput
	local chatMessage = self.control.edit:GetEditText()
	local chatMessageLength = string.len( chatMessage )
	
	chatMessage = string.lower(string.sub(chatMessage, 1, chatMessageLength - 1))
	
	local isWhisper	= ChatInput_IsInstantCommand_Whisper(chatMessage)
	local isReply	= ChatInput_IsInstantCommand_Reply(chatMessage)
	
	
	local isProcess = false
	
	if ChatInput_IsInstantCommand_Normal(chatMessage) then
		toChangeChatType = CppEnums.ChatType.Public
		isProcess = true
	elseif ChatInput_IsInstantCommand_World(chatMessage) then
		toChangeChatType = CppEnums.ChatType.World
		isProcess = true
	elseif ChatInput_IsInstantCommand_Party(chatMessage) then
		toChangeChatType = CppEnums.ChatType.Party
		isProcess = true
	elseif ChatInput_IsInstantCommand_Guild(chatMessage) then
		toChangeChatType = CppEnums.ChatType.Guild
		isProcess = true
	elseif ChatInput_IsInstantCommand_WithItem(chatMessage) then
		toChangeChatType = CppEnums.ChatType.WorldWithItem
		isProcess = true
	elseif ChatInput_IsInstantCommand_LocalWar(chatMessage) then
		toChangeChatType = CppEnums.ChatType.LocalWar
		isProcess = true
	elseif isWhisper or isReply then
		toChangeChatType = CppEnums.ChatType.Private
		isProcess = true
	else	
		if (UI_CT.Private == self.lastChatType) then 
			if checkFocusWhisperEdit then
				SetFocusEdit( self.control.edit )
				checkFocusWhisperEdit = false
			end
		end
	end

	if isProcess then
		if self.isChatTypeChangedMode then
			-- 마우스로 변경중이었으면, 해당 타입으로 클릭과 동일한 효과를 낸다!
			ChatInput_TypeButtonClicked( toChangeChatType )
		else
			-- 즉시 변경한다!
			ChatInput_ChangeChatType_Immediately( toChangeChatType )
		end
		self.control.edit:SetEditText("", true)
			
		if isWhisper or isReply then
			if "" == lastWhispersId then
				isReply = false
				isWhisper = true
			end
			
			if isWhisper then
				self.control.whisperEdit:SetEditText("", true)
				SetFocusEdit( self.control.whisperEdit )
				checkFocusWhisperEdit = true
			elseif isReply then
				self.control.whisperEdit:SetEditText(lastWhispersId, true)
				SetFocusEdit( self.control.edit )
				checkFocusWhisperEdit = false
			end
		end
	end
end

function FGlobal_ChatInput_CheckReply()
	if "" == lastWhispersId then
		return false
	end
	return true
end

function FGlobal_ChatInput_Reply( isReply )
	local self = chatInput
	if isReply then
		self.control.whisperEdit:SetEditText(lastWhispersId, true)
		SetFocusEdit( self.control.edit )
		checkFocusWhisperEdit = false
	end
end

function ChatInput_Show()
	if( Panel_Chatting_Input:IsShow() ) then
		return;
	end

	local	self	= chatInput
	SetFocusEdit( chatInput.control.edit )	
	-- show animation
	Panel_Chatting_Input:SetShow( true, true )

	if UI_CT.Private == self.lastChatType then
		-- 귓속말 할 때, 매크로 버튼 위치 바꿈
		self.control.macroButton:SetPosX( self.control.whisperEdit:GetPosX() + self.control.whisperEdit:GetSizeX() )
		self.control.socialButton:SetPosX( self.control.whisperEdit:GetPosX() + self.control.whisperEdit:GetSizeX() + 30 )
	else
		-- 귓속말 안할 때, 매크로 버튼 위치 바꿈
		self.control.macroButton:SetPosX( self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 10 )
		self.control.socialButton:SetPosX( self.control.edit:GetPosX() + self.control.edit:GetSizeX() + 40 )
	end
	
	self.control.macroButton:SetCheck( false )
	if Panel_Chat_SocialMenu:GetShow() then
		self.control.socialButton:SetCheck( true )
	else
		self.control.socialButton:SetCheck( false )
	end

	if	chatting_isBlocked()	then
		local blockString = convertStringFromDatetime(chatting_blockedEndDatetime())
		local blockReason = tostring( chatting_blockedReasonMemo())
		local tempString = PAGetStringParam2(  Defines.StringSheet_GAME,  "CHATTING_BLOCK_TIME_REASON",  "time", blockString, "reason", blockReason )
		self.control.edit:SetText( "<PAColor0xFF888888>"..tempString )
	end
	chatting_startAction()
	
	curChatMsgCnt 		= chatting_getMessageHistoryCount()
	curWhisperMsgCnt 	= chatting_getTargetHistoryCount()
end

function ChatInput_CancelAction()
	local self	= chatInput
	local message = self.control.edit:GetEditText()
	if '' == message then
		chatting_cancelAction()
	end
end

function ChatInput_Close()
	ClearFocusEdit()
	ToClient_ClearLinkedItemList()
	chatInput:clearLinkedItem()

	-- hide animation
	if Panel_Chatting_Input:IsShow() then
		Panel_Chatting_Input:SetShow( false, true )
		Panel_Chatting_Macro:SetShow( false )
		--Panel_Chat_SocialMenu:SetShow( false )
	end
end

function ChatInput_CheckCurrentUiEdit(targetUI)
    return ( nil ~= targetUI ) and (( targetUI:GetKey() == chatInput.control.edit:GetKey() ) or ( targetUI:GetKey() == chatInput.control.whisperEdit:GetKey() ))
end

function ChatInput_ChangeInputFocus()
	local self = chatInput
	if (UI_CT.Private == self.lastChatType) then 
		if (not checkFocusWhisperEdit) then
			SetFocusEdit( self.control.whisperEdit )
			checkFocusWhisperEdit = true
		else
			SetFocusEdit( self.control.edit )
			checkFocusWhisperEdit = false
		end	
	end
end

function HandleClicked_ToggleChatMacro( number )
	if ( 0 == number ) then
		FGlobal_Chatting_Macro_ShowToggle()
	else
		FGlobal_SocialAction_ShowToggle()
	end
end

function FGlobal_Chatting_Macro_SetCHK( show )
	if true == show then
		chatInput.control.macroButton:SetCheck( true )
	else
		chatInput.control.macroButton:SetCheck( false )
	end
end

function FGlobal_SocialAction_SetCHK( show )
	if true == show then
		chatInput.control.socialButton:SetCheck( true )
	else
		chatInput.control.socialButton:SetCheck( false )
	end
end


function isChatInputLinkedItem(itemWrapper)
	
	local itemSSW = itemWrapper:getStaticStatus()
	local itemName = itemSSW:getName()
	
	local linkedItemPos =
	{
		startPos = 0,
		endPos = 0,
	}
	
	local oldStr = chatInput.control.edit:GetEditText()
	linkedItemPos.startPos = string.len(oldStr)
	
	local newStr = oldStr .. "[" .. itemName .. "]"
	linkedItemPos.endPos = string.len(newStr)
	
	chatInput.control.edit:SetEditText(newStr, true)
	
	if chatInput.control.edit:GetEditTextSize() <=  chatInput.maxEditInput then
		chatInput.linkedItemData[chatInput.linkedItemCount] = linkedItemPos
		return true
	else
		chatInput.control.edit:SetEditText(oldStr, true)
		return false
	end
end


function FGlobal_ChattingInput_LinkedItemByInventory( slotNo, inventoryType )
	if (UI_CT.World ~= chatInput.lastChatType) and (UI_CT.Guild ~= chatInput.lastChatType) and (UI_CT.Public ~= chatInput.lastChatType) and (UI_CT.Party ~= chatInput.lastChatType) and (UI_CT.WorldWithItem ~= chatInput.lastChatType) then
		return
	end
	
	if chatInput.maxLinkedItemCount <= chatInput.linkedItemCount then
		return
	end
	
	chatInput.linkedItemCount = chatInput.linkedItemCount + 1
	local selfProxy		= getSelfPlayer():get()
	local inventory		= selfProxy:getInventory()
	local itemWrapper	= getInventoryItemByType( inventoryType, slotNo )
	
	if isChatInputLinkedItem(itemWrapper) then
		chatInput.control.edit:SetCursorMove( false )
		chatInput.control.edit:SetCursorPosIndex(0)
		ToClient_SetLinkedItemByInventory( inventoryType, slotNo, chatInput.linkedItemData[chatInput.linkedItemCount].startPos, chatInput.linkedItemData[chatInput.linkedItemCount].endPos )
	end
end

-- 대화창에서 서브 메뉴 오픈 -> 귓속말 보내기 클릭 시 호출
function FGlobal_ChattingInput_ShowWhisper(characterName)
	ChatInput_Show()
	ChatInput_ChangeChatType_Immediately(4)
	chatInput.control.whisperEdit:SetEditText(characterName, true)
	UI.Set_ProcessorInputMode(CppEnums.EProcessorInputMode.eProcessorInputMode_ChattingInputMode)
end

function ChatInput_CheckRemoveLinkedItem()
	if (UI_CT.World ~= chatInput.lastChatType) and (UI_CT.Guild ~= chatInput.lastChatType) and (UI_CT.Public ~= chatInput.lastChatType) and (UI_CT.Party ~= chatInput.lastChatType) and (UI_CT.WorldWithItem ~= chatInput.lastChatType) then
		return
	end
	
	if chatInput.linkedItemCount <= 0 then
		return
	end
	
	local str = chatInput.control.edit:GetEditText()
	local editStrLen = string.len(str)
	if editStrLen < chatInput.linkedItemData[chatInput.linkedItemCount].endPos then
		if 0 == chatInput.linkedItemData[chatInput.linkedItemCount].startPos then
			chatInput.control.edit:SetEditText( '', true )
		else
			chatInput.control.edit:SetEditText( string.sub(str, 1, chatInput.linkedItemData[chatInput.linkedItemCount].startPos), true )
		end
		
		ToClient_ClearLinkedItemList()
		chatInput:clearLinkedItem()
	end
end

function ChatInput_Resize()
	Panel_Chatting_Input:SetSize(352, 30)
	Panel_Chatting_Input:ComputePos()
end

chatInput:init()
chatInput:checkLoad()		-- 서비스 버전에서는 호출하지 않아도 되는 함수
chatInput:registEventHandler()

chatInput.control.macroButton:addInputEvent( "Mouse_LUp", "HandleClicked_ToggleChatMacro(0)" )
chatInput.control.socialButton:addInputEvent( "Mouse_LUp", "HandleClicked_ToggleChatMacro(1)" )
chatInput.control.whisperEdit:addInputEvent( "Mouse_LUp", "HandleClicked_ChatInputEdit()" )
chatInput.control.edit :addInputEvent( "Mouse_LUp", "HandleClicked_ChatInputEdit()" )

function HandleClicked_ChatInputEdit()
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
end

registerEvent("EventChatPermissionChanged", "ChatInput_UpdatePermission")
registerEvent("EventChatInputClose", "ChatInput_Close")
registerEvent("onScreenResize", "ChatInput_Resize")
registerEvent("FromClient_GroundMouseClick", "FromClient_GroundMouseClickForChatting")
