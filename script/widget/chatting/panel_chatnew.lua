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

local currentPoolIndex		= nil
local clickedMessageIndex	= nil
local clickedName			= nil
local clickedMsg			= nil
local isMouseOnChattingViewIndex	= nil;
local isMouseOn = false

local isReportGoldSellerOpen	= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 89 )	-- 구매 예약 오픈 확인.

local ChatSubMenu =
{
	_mainPanel					= Panel_Chat_SubMenu,
	_uiBg						= UI.getChildControl(Panel_Chat_SubMenu, 'Static_SubMenu'),
	_uiButtonWhisper			= UI.getChildControl(Panel_Chat_SubMenu, 'Button_Whisper'),
	_uiButtonAddFriend			= UI.getChildControl(Panel_Chat_SubMenu, 'Button_AddFriend'),
	_uiButtonInviteParty		= UI.getChildControl(Panel_Chat_SubMenu, 'Button_InviteParty'),
	_uiButtonInviteGuild		= UI.getChildControl(Panel_Chat_SubMenu, 'Button_InviteGuild'),
	_uiButtonBlock				= UI.getChildControl(Panel_Chat_SubMenu, 'Button_Block'),
	_uiButtonReportGoldSeller	= UI.getChildControl(Panel_Chat_SubMenu, 'Button_ReportGoldSeller'),
	_uiButtonBlockVote			= UI.getChildControl(Panel_Chat_SubMenu, 'Button_BlockVote'),
	_uiButtonIntroduce			= UI.getChildControl(Panel_Chat_SubMenu, "Button_ShowIntroduce" ),
	_uiButtonWinClose			= UI.getChildControl(Panel_Chat_SubMenu, 'Button_WinClose'),
}

local partyPosY = ChatSubMenu._uiButtonInviteParty:GetPosY()
local guildPosY = ChatSubMenu._uiButtonInviteGuild:GetPosY()

function ChatSubMenu:initialize()
	self._uiBg						:addInputEvent("Mouse_On", "HandleOn_ChattingSubMenu()" )
	self._uiButtonWhisper			:addInputEvent("Mouse_LUp", "HandleClicked_ChatSubMenu_SendWhisper()")
	self._uiButtonAddFriend			:addInputEvent("Mouse_LUp", "HandleClicked_ChatSubMenu_AddFriend()")
	self._uiButtonInviteParty		:addInputEvent("Mouse_LUp", "HandleClicked_ChatSubMenu_InviteParty()")
	self._uiButtonInviteGuild		:addInputEvent("Mouse_LUp", "HandleClicked_ChatSubMenu_InviteGuild()")
	self._uiButtonWinClose			:addInputEvent("Mouse_LUp", "HandleClicked_ChatSubMenu_Close()")
	self._uiButtonBlock				:addInputEvent("Mouse_LUp", "HandleClicked_ChatSubMenu_Block()")
	self._uiButtonReportGoldSeller	:addInputEvent("Mouse_LUp", "HandleClicked_ChatSubMenu_ReportGoldSeller()")
	self._uiButtonBlockVote			:addInputEvent("Mouse_LUp", "HandleClicked_ChatSubMenu_BlockVote()")
	self._uiButtonIntroduce			:addInputEvent("Mouse_LUp",	"HanldeClicked_ChatSubMenu_Introduce()" )
	self._uiButtonIntroduce			:SetShow( false )
	self._uiBg						:SetIgnore( false )
	self:SetShow( false )
end

function HandleOn_ChattingSubMenu()
	if( nil ~= currentPanelIndex ) then
		Chatting_PanelTransparency( currentPanelIndex, false )
	end
end

function HandleClicked_ChatSubMenu_Close()
	ChatSubMenu:SetShow(false)
end

function ChatSubMenu:SetShow( isShow, isInviteParty, isInviteGuild, clickedName )
	if isShow then
		local bgSizeY		= 145
		local buttonPosY	= 140
		local gapY			= 35
		local isCountryShow = true
		if isGameTypeKorea() then
			isCountryShow = true
		elseif isGameTypeEnglish() then
			isCountryShow = false
		elseif isGameTypeJapan() then
			isCountryShow = false
		elseif isGameTypeRussia() then
			isCountryShow = true
		end
		self._uiButtonBlockVote			:SetShow( isCountryShow )
		self._uiButtonReportGoldSeller	:SetShow( isReportGoldSellerOpen )
		self._uiButtonInviteParty		:SetShow(isInviteParty)
		self._uiButtonInviteGuild		:SetShow(isInviteGuild)

		if self._uiButtonBlockVote:GetShow() then
			self._uiButtonBlockVote:SetPosY( buttonPosY )
			buttonPosY	= buttonPosY + gapY
			bgSizeY		= bgSizeY + gapY
		end

		if self._uiButtonReportGoldSeller:GetShow() then
			self._uiButtonReportGoldSeller:SetPosY( buttonPosY )
			buttonPosY	= buttonPosY + gapY
			bgSizeY		= bgSizeY + gapY
		end

		if self._uiButtonInviteParty:GetShow() then
			self._uiButtonInviteParty:SetPosY( buttonPosY )
			buttonPosY	= buttonPosY + gapY
			bgSizeY		= bgSizeY + gapY
		end

		if self._uiButtonInviteGuild:GetShow() then
			self._uiButtonInviteGuild:SetPosY( buttonPosY )
			buttonPosY	= buttonPosY + gapY
			bgSizeY		= bgSizeY + gapY
		end
		
		self._uiBg:SetText( clickedName )
		self._uiBg:SetSize(self._uiBg:GetSizeX(), bgSizeY )
	else
		currentPoolIndex	= nil
		clickedMessageIndex	= nil
		clickedName			= nil
		clickedMsg			= nil
	end
	self._mainPanel:SetShow( isShow )
end

function ChatSubMenu:SetPos( x, y )
	local screenSizeX = getScreenSizeX()
	local screenSizeY = getScreenSizeY()
	
	if(screenSizeX <= (x + self._uiBg:GetSizeX())) then
		x = screenSizeX - self._uiBg:GetSizeX()
	end
	
	if(screenSizeY <= (y + self._uiBg:GetSizeY())) then
		y = screenSizeY - self._uiBg:GetSizeY()
	end

	self._mainPanel:SetPosX( x )
	self._mainPanel:SetPosY( y )
end

ChatSubMenu:initialize()

local ChatUIPoolManager = 
{
	_poolCount			= 5,
	_listPanel			= {},
	_listChatUIPool		= {},
	_listPopupNameMenu	= {},
	_maxListCount		= 50,
}

local _currentInitPool = 0

function ChatUIPoolManager:createPanel(poolIndex, stylePanel)
	local panel = UI.createPanel("Panel_Chat"..poolIndex, UI_Group.PAGameUIGroup_Chatting)
	CopyBaseProperty(stylePanel, panel)	
	panel:ChangeSpecialTextureInfoName("new_ui_common_forlua/Window/Chatting/Chatting_Win_transparency.dds")
	panel:setMaskingChild( true )
	panel:setGlassBackground( true )
	panel:SetSize( 420, 222 )
	panel:SetPosX( 0 )
	panel:SetPosY( getScreenSizeY() - panel:GetSizeY() - 35 )
	panel:SetColor( UI_color.C_FFFFFFFF )
	panel:SetIgnore( false )
	panel:SetDragAll( false )
	panel:addInputEvent( "Mouse_UpScroll",		"Chatting_ScrollEvent( " .. poolIndex .. ", true )" )
	panel:addInputEvent( "Mouse_DownScroll",	"Chatting_ScrollEvent( " .. poolIndex .. ", false )" )
	panel:addInputEvent( "Mouse_On",			"Chatting_PanelTransparency( " .. poolIndex .. ", true )" )
	panel:addInputEvent( "Mouse_Out",			"Chatting_PanelTransparency( " .. poolIndex .. ", false , " .. 9999 .. ")" )
	if 0 ~= poolIndex then
		panel:SetShow( false )
	else
		panel:SetShow( true )
	end

	return panel
end
function ChatUIPoolManager:createPool(poolIndex, poolStylePanel, poolParentPanel)
	local ChatUIPool = 
	{
		_list_PanelBG					= {}, 
		_list_TitleTab					= {}, 
		_list_TitleTabText				= {}, 
		_list_TitleTabConfigButton		= {}, 
		_list_OtherTab					= {}, 
		_list_AddTab					= {}, 
		_list_ResizeButton				= {}, 
		_list_PanelDivision				= {}, 
		_list_PanelDelete				= {}, 
		_list_ChattingIcon				= {},
		-- _list_ChattingSenderHead		= {},
		_list_ChattingSender			= {},
		_list_ChattingContents			= {}, 
		_list_ChattingLinkedItem		= {},
		_list_Scroll					= {}, 
		_list_CloseButton				= {},
		
		_list_SenderMessageIndex		= {},
		_list_LinkedItemMessageIndex	= {},
		
		_count_PanelBG					= 0,	_maxcount_PanelBG					= 5, 
		_count_TitleTab					= 0,	_maxcount_TitleTab					= 5, 
		_count_TitleTabText				= 0,	_maxcount_TitleTabText				= 5, 
		_count_TitleTabConfigButton		= 0,	_maxcount_TitleTabConfigButton		= 5, 
		_count_OtherTab					= 0,	_maxcount_OtherTab					= 4, 
		_count_AddTab					= 0,	_maxcount_AddTab					= 1, 
		_count_PanelDivision			= 0,	_maxcount_PanelDivision				= 5, 
		_count_PanelDelete				= 0,	_maxcount_PanelDelete				= 5, 
		_count_ResizeButton				= 0,	_maxcount_ResizeButton				= 5,
		_count_ChattingIcon				= 0,	_maxcount_ChattingIcon				= self._maxListCount,
		-- _count_ChattingSenderHead		= 0,	_maxcount_ChattingSenderHead		= self._maxListCount,
		_count_ChattingSender			= 0,	_maxcount_ChattingSender			= self._maxListCount,
		_count_ChattingContents			= 0,	_maxcount_ChattingContents			= self._maxListCount,
		_count_ChattingLinkedItem		= 0,	_maxcount_ChattingLinkedItem		= self._maxListCount*2,
		_count_Scroll					= 0,	_maxcount_Scroll					= 1,
		_count_CloseButton				= 0,	_maxcount_CloseButton				= 4,
	}
	function ChatUIPool:prepareControl(Panel, parentControl, createdCotrolList, controlType, controlName, createCount)
		local styleUI = UI.getChildControl(Panel, controlName)
		 for index = 0, createCount, 1 do		
			createdCotrolList[index]	= UI.createControl( controlType, parentControl, controlName .. index)
			CopyBaseProperty(styleUI, createdCotrolList[index])
			createdCotrolList[index]:SetShow(true)
		 end
	end
	function ChatUIPool:initialize(stylePanel, parentControl, poolIndex)
		
		ChatUIPool:prepareControl(stylePanel,	parentControl,	self._list_PanelBG,					UI_PUCT.PA_UI_CONTROL_STATIC, 		"Static_ChattingBG", 		self._maxcount_PanelBG		)
		ChatUIPool:prepareControl(stylePanel,	parentControl,	self._list_TitleTab,				UI_PUCT.PA_UI_CONTROL_BUTTON, 		"Button_TitleButton", 		self._maxcount_TitleTab		)
		ChatUIPool:prepareControl(stylePanel,	parentControl,	self._list_TitleTabText,			UI_PUCT.PA_UI_CONTROL_STATICTEXT, 	"StaticText_chattingText", 	self._maxcount_TitleTabText		)
		ChatUIPool:prepareControl(stylePanel,	parentControl,	self._list_TitleTabConfigButton,	UI_PUCT.PA_UI_CONTROL_BUTTON, 		"Button_Setting", 			self._maxcount_TitleTabConfigButton		)
		ChatUIPool:prepareControl(stylePanel,	parentControl,	self._list_OtherTab,				UI_PUCT.PA_UI_CONTROL_BUTTON, 		"Button_OtherChat", 		self._maxcount_OtherTab		)
		ChatUIPool:prepareControl(stylePanel,	parentControl,	self._list_AddTab,					UI_PUCT.PA_UI_CONTROL_BUTTON, 		"Button_AddChat", 			self._maxcount_AddTab		)
		ChatUIPool:prepareControl(stylePanel,	parentControl,	self._list_PanelDivision,			UI_PUCT.PA_UI_CONTROL_BUTTON, 		"Button_PanelDivision", 	self._maxcount_PanelDivision		)
		ChatUIPool:prepareControl(stylePanel,	parentControl,	self._list_PanelDelete,				UI_PUCT.PA_UI_CONTROL_BUTTON, 		"Button_PanelCombine", 		self._maxcount_PanelDelete		)
		ChatUIPool:prepareControl(stylePanel,	parentControl,	self._list_ResizeButton,			UI_PUCT.PA_UI_CONTROL_BUTTON, 		"Button_Size", 				self._maxcount_ResizeButton		)
		ChatUIPool:prepareControl(stylePanel,	parentControl,	self._list_ChattingIcon,			UI_PUCT.PA_UI_CONTROL_STATIC,		"Static_ChatIcon",			self._maxcount_ChattingIcon	)
		-- ChatUIPool:prepareControl(stylePanel,	parentControl,	self._list_ChattingSenderHead,		UI_PUCT.PA_UI_CONTROL_STATICTEXT,	"StaticText_ChatSenderHead",self._maxcount_ChattingSenderHead	)
		ChatUIPool:prepareControl(stylePanel,	parentControl,	self._list_ChattingSender,			UI_PUCT.PA_UI_CONTROL_STATICTEXT,	"StaticText_ChatSender",	self._maxcount_ChattingSender	)
		ChatUIPool:prepareControl(stylePanel,	parentControl,	self._list_ChattingContents,		UI_PUCT.PA_UI_CONTROL_STATICTEXT, 	"StaticText_ChatContent", 	self._maxcount_ChattingContents		)
		ChatUIPool:prepareControl(stylePanel,	parentControl,	self._list_ChattingLinkedItem,		UI_PUCT.PA_UI_CONTROL_STATICTEXT, 	"StaticText_ChatLinkedItem",	self._maxcount_ChattingLinkedItem		)
		ChatUIPool:prepareControl(stylePanel,	parentControl,	self._list_Scroll,					UI_PUCT.PA_UI_CONTROL_SCROLL, 		"Scroll_Chatting", 			self._maxcount_Scroll		)
		ChatUIPool:prepareControl(stylePanel,	parentControl,	self._list_CloseButton,				UI_PUCT.PA_UI_CONTROL_BUTTON, 		"Button_Close", 			self._maxcount_CloseButton		)
		
		for index = 0, self._maxcount_ChattingLinkedItem, 1 do
			self._list_ChattingLinkedItem[index]:addInputEvent( "Mouse_On", "HandleOn_ChattingLinkedItem(" .. poolIndex ..", " .. index .. ")" )
			self._list_ChattingLinkedItem[index]:addInputEvent( "Mouse_Out", "Chatting_PanelTransparency(" .. poolIndex .. ", false )" )
			self._list_ChattingLinkedItem[index]:addInputEvent( "Mouse_LPress", "Chatting_Transparency(" .. poolIndex .. ")" )
			self._list_ChattingLinkedItem[index]:addInputEvent( "Mouse_RPress", "Chatting_Transparency(" .. poolIndex .. ")" )
			--self._list_ChattingLinkedItem[index]:addInputEvent( "Mouse_Out", "HandleOut_ChattingLinkedItem()")
		end
		
		for index = 0, self._maxcount_ChattingSender, 1 do
			self._list_ChattingSender[index]:addInputEvent( "Mouse_LUp", "HandleClicked_ChattingSender(" .. poolIndex ..", " .. index .. ")" )
			self._list_ChattingSender[index]:addInputEvent( "Mouse_Out", "Chatting_PanelTransparency(" .. poolIndex .. ", false )" )
			self._list_ChattingSender[index]:addInputEvent( "Mouse_LPress", "Chatting_Transparency(" .. poolIndex .. ")" )
			self._list_ChattingSender[index]:addInputEvent( "Mouse_RPress", "Chatting_Transparency(" .. poolIndex .. ")" )
			--self._list_ChattingSender[index]:addInputEvent( "Mouse_Out", "HandleOut_ChattingSender()" )
		end
		
		ChatUIPool:clear()
	end
	function ChatUIPool:newPanelBG()
		self._count_PanelBG = self._count_PanelBG + 1 
		return self._list_PanelBG[self._count_PanelBG - 1]
	end
	function ChatUIPool:newTitleTab()
		self._count_TitleTab = self._count_TitleTab + 1 
		return self._list_TitleTab[self._count_TitleTab - 1]
	end
	function ChatUIPool:newTitleTabText()
		self._count_TitleTabText = self._count_TitleTabText + 1 
		return self._list_TitleTabText[self._count_TitleTabText - 1]
	end
	function ChatUIPool:newTitleTabConfigButton()
		self._count_TitleTabConfigButton = self._count_TitleTabConfigButton + 1 
		return self._list_TitleTabConfigButton[self._count_TitleTabConfigButton - 1]
	end
	function ChatUIPool:newOtherTab()
		self._count_OtherTab = self._count_OtherTab + 1 
		return self._list_OtherTab[self._count_OtherTab - 1]
	end
	function ChatUIPool:newAddTab()
		self._count_AddTab = self._count_AddTab + 1 
		return self._list_AddTab[self._count_AddTab - 1]
	end
	function ChatUIPool:newPanelDivision()
		self._count_PanelDivision = self._count_PanelDivision + 1 
		return self._list_PanelDivision[self._count_PanelDivision - 1]
	end
	function ChatUIPool:newPanelCombine()
		self._count_PanelDelete = self._count_PanelDelete + 1 
		return self._list_PanelDelete[self._count_PanelDelete - 1]
	end
	function ChatUIPool:newResizeButton()
		self._count_ResizeButton = self._count_ResizeButton + 1 
		return self._list_ResizeButton[self._count_ResizeButton - 1]
	end
	function ChatUIPool:newChattingIcon()
		self._count_ChattingIcon = self._count_ChattingIcon + 1 
		return self._list_ChattingIcon[self._count_ChattingIcon - 1]
	end
	-- function ChatUIPool:newChattingSenderHead()
	-- 	self._count_ChattingSenderHead = self._count_ChattingSenderHead + 1 
	-- 	return self._list_ChattingSenderHead[self._count_ChattingSenderHead - 1]
	-- end
	function ChatUIPool:newChattingSender( messageIndex )
		self._count_ChattingSender = self._count_ChattingSender + 1 
		self._list_SenderMessageIndex[self._count_ChattingSender - 1] = messageIndex
		return self._list_ChattingSender[self._count_ChattingSender - 1]
	end
	function ChatUIPool:newChattingContents()
		self._count_ChattingContents = self._count_ChattingContents + 1
		return self._list_ChattingContents[self._count_ChattingContents - 1]
	end
	function ChatUIPool:newChattingLinkedItem( messageIndex )
		self._count_ChattingLinkedItem = self._count_ChattingLinkedItem + 1 
		self._list_LinkedItemMessageIndex[self._count_ChattingLinkedItem - 1] = messageIndex
		return self._list_ChattingLinkedItem[self._count_ChattingLinkedItem - 1]
	end
	function ChatUIPool:newScroll()
		self._count_Scroll = self._count_Scroll + 1 
		return self._list_Scroll[self._count_Scroll - 1]
	end
	function ChatUIPool:newCloseButton()
		self._count_CloseButton = self._count_CloseButton + 1 
		return self._list_CloseButton[self._count_CloseButton - 1]
	end
	function ChatUIPool:clear()
		self._count_PanelBG						= 0
		self._count_TitleTab					= 0
		self._count_TitleTabText				= 0
		self._count_TitleTabConfigButton		= 0
		self._count_OtherTab					= 0
		self._count_AddTab						= 0
		self._count_PanelDivision				= 0
		self._count_PanelDelete					= 0
		self._count_ResizeButton				= 0
		self._count_ChattingIcon				= 0
		-- self._count_ChattingSenderHead			= 0
		self._count_ChattingSender				= 0
		self._count_ChattingContents			= 0
		self._count_ChattingLinkedItem			= 0
		self._count_Scroll						= 0
		self._count_CloseButton					= 0
		
		self._list_SenderMessageIndex		= {}
		self._list_LinkedItemMessageIndex	= {}
		
		--clickedName = nil
		--currentPoolIndex = nil
		--clickedMessageIndex = nil
		
		ChatUIPool:hideNotUse()
	end
	function ChatUIPool:hideNotUse()
		for index = self._count_PanelBG, self._maxcount_PanelBG, 1 do
			self._list_PanelBG[index]:SetShow(false)
		end
		for index = self._count_TitleTab, self._maxcount_TitleTab, 1 do
			self._list_TitleTab[index]:SetShow(false)
		end
		for index = self._count_TitleTabText, self._maxcount_TitleTabText, 1 do
			self._list_TitleTabText[index]:SetShow(false)
		end
		for index = self._count_TitleTabConfigButton, self._maxcount_TitleTabConfigButton, 1 do
			self._list_TitleTabConfigButton[index]:SetShow(false)
		end
		for index = self._count_OtherTab, self._maxcount_OtherTab, 1 do
			self._list_OtherTab[index]:SetShow(false)
		end
		for index = self._count_AddTab, self._maxcount_AddTab, 1 do
			self._list_AddTab[index]:SetShow(false)
		end
		for index = self._count_PanelDivision, self._maxcount_PanelDivision, 1 do
			self._list_PanelDivision[index]:SetShow(false)
		end
		for index = self._count_PanelDelete, self._maxcount_PanelDelete, 1 do
			self._list_PanelDelete[index]:SetShow(false)
		end
		for index = self._count_ResizeButton + 1, self._maxcount_ResizeButton, 1 do
			self._list_ResizeButton[index ]:SetShow(false)
		end		
		for index = self._count_ChattingIcon, self._maxcount_ChattingIcon, 1 do
			self._list_ChattingIcon[index]:SetShow(false)
		end
		-- for index = self._count_ChattingSenderHead, self._maxcount_ChattingSenderHead, 1 do
		-- 	self._list_ChattingSenderHead[index]:SetShow(false)
		-- end
		for index = self._count_ChattingSender, self._maxcount_ChattingSender, 1 do
			self._list_ChattingSender[index]:SetShow(false)
		end
		for index = self._count_ChattingContents, self._maxcount_ChattingContents, 1 do
			self._list_ChattingContents[index]:SetShow(false)
		end
		for index = self._count_ChattingLinkedItem, self._maxcount_ChattingLinkedItem, 1 do
			self._list_ChattingLinkedItem[index]:SetShow(false)
		end
		for index = self._count_Scroll, self._maxcount_Scroll, 1 do
			self._list_Scroll[index]:SetShow(false)
		end
		for index = self._count_CloseButton, self._maxcount_CloseButton, 1 do
			self._list_CloseButton[index]:SetShow(false)
		end
	end

	ChatUIPool:initialize(poolStylePanel, poolParentPanel, poolIndex)

	return ChatUIPool
end

-- for idx = 0, 500 do
-- 	chatting_sendMessage( "", tostring(idx) , CppEnums.ChatType.System )
-- end

local ChattingViewManager = 
{
	_mainPanelSelectPanelIndex = 0,
	_maxHistoryCount = ( ToClient_getChattingMaxContentsCount() - 50 ), 
	_cacheSimpleUI = false,
	_addChattingIdx = nil,
	_srollPosition = {
		[0] = 0,
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 0
	},
	_transparency = {
		[0] = 0.5,
		[1] = 0.5,
		[2] = 0.5,
		[3] = 0.5,
		[4] = 0.5
	},
	_scroll_BTNPos = {
		[0] = 1,
		[1] = 1,
		[2] = 1,
		[3] = 1,
		[4] = 1,
	}

}

function Chatting_Transparency( index )
	if( -1 == index ) then
		if( nil == currentPanelIndex ) then
			return
		end

		index =	currentPanelIndex;
	end
	--_PA_LOG("이문종", "Chatting_Transparency == " .. index )
	Chatting_PanelTransparency( index, false )
end
	
function ChatUIPoolManager:initialize()
	local divisionPanel, panel, panelSizeX, panelSizeY, chatUI
	for poolIndex = 0, self._poolCount-1, 1 do
		self._listPanel[poolIndex]		= self:createPanel(poolIndex, Panel_Chat)
		--_PA_ASSERT(nil ~= self._listPanel[poolIndex], "머야")
		self._listChatUIPool[poolIndex] = self:createPool(poolIndex, Panel_Chat, self._listPanel[poolIndex] )
	
		divisionPanel 	= ToClient_getChattingPanel( poolIndex )
		panel 			= self._listPanel[poolIndex]	
		chatUI 			= self._listChatUIPool[poolIndex]
		
		if(0 < divisionPanel:getPanelSizeX()) then
			panelSizeX = divisionPanel:getPanelSizeX()
			panelSizeY = divisionPanel:getPanelSizeY()
			
			panel:SetSize(panelSizeX, panelSizeY)
			
			chatUI._list_PanelBG[0]:SetSize(panelSizeX, panelSizeY)
			chatUI._list_Scroll[0]:SetSize( chatUI._list_Scroll[0]:GetSizeX(), panelSizeY - 25 )
			
			for chattingContents_idx = 0, chatUI._maxcount_ChattingContents - 1, 1 do
				chatUI._list_ChattingContents[chattingContents_idx]:SetSize( panelSizeX - 25 , chatUI._list_ChattingContents[chattingContents_idx]:GetSizeY() )
			end
			
			chatUI._list_ResizeButton[0]:SetPosX( panelSizeX - (chatUI._list_ResizeButton[0]:GetSizeX() + 5) )
			chatUI._list_Scroll[0]:SetPosX( panelSizeX - (chatUI._list_Scroll[0]:GetSizeX() + 5) )
			chatUI._list_Scroll[0]:SetControlBottom()
		else
			panelSizeX = 420
			panelSizeY = 222
			
			panel:SetSize(panelSizeX, panelSizeY)
			
			chatUI._list_PanelBG[0]:SetSize(panelSizeX, panelSizeY)
			chatUI._list_Scroll[0]:SetSize( chatUI._list_Scroll[0]:GetSizeX(), panelSizeY - 25 )
			
			for chattingContents_idx = 0, chatUI._maxcount_ChattingContents - 1, 1 do
				chatUI._list_ChattingContents[chattingContents_idx]:SetSize( panelSizeX - 25 , chatUI._list_ChattingContents[chattingContents_idx]:GetSizeY() )
			end
			
			chatUI._list_ResizeButton[0]:SetPosX( panelSizeX - (chatUI._list_ResizeButton[0]:GetSizeX() + 5) )
			chatUI._list_Scroll[0]:SetPosX( panelSizeX - (chatUI._list_Scroll[0]:GetSizeX() + 5) )
			chatUI._list_Scroll[0]:SetControlBottom()
		end
		
		if(divisionPanel:getPositionX() < 0) and (divisionPanel:getPositionY() < 0) then
			panel:SetPosX( 0 )
			panel:SetPosY( getScreenSizeY() - panel:GetSizeY() - 35 )
		else
			panel:SetPosX( divisionPanel:getPositionX())
			panel:SetPosY( divisionPanel:getPositionY() )
		end
		
		ChattingViewManager._transparency[poolIndex] = divisionPanel:getTransparency();
		
		FGlobal_PanelMove(panel, true)

	end
	-- Panel_Chat삭제
end

function ChatUIPoolManager:getPool( poolIndex )
	return self._listChatUIPool[poolIndex]
end

function ChatUIPoolManager:getPanel( poolIndex )
	return self._listPanel[poolIndex]
end

function ChatUIPoolManager:getPopupNameMenu( poolIndex )
	return self._listPopupNameMenu[poolIndex]
end

ChatUIPoolManager:initialize()


------------------------------------------------------------------
------------------------------------------------------------------
------------------------------------------------------------------

-- 채팅창 수만큼 호출됨

local _tabButton_PosX	= 0
local addChat_PosX 		= 0
function ChattingViewManager:update(chatPanel, panelIndex, isShow )
	-- 튜토리얼 중에는 채팅창을 업데이트하지 않는다!
	if ( getSelfPlayer():get():getLevel() < 5 ) or false == isTutorialEnd() then
		return
	end
	
	-- 어떤 Panel에 그려질지 선택한다. 메인 패널에 붙어있으면 미리 할당해둔 패널을 숨겨주고 메인패널(0)에 그린다
	local isCombinedMainPanel 	= chatPanel:isCombinedToMainPanel()
	local drawPanelIndex 		= panelIndex
	local bgAlpah				= self._transparency[drawPanelIndex]
	if ( true == isCombinedMainPanel ) then
		drawPanelIndex 			= 0	
	end

	local currentPanel = ChatUIPoolManager:getPanel(drawPanelIndex)	-- 그려질 패널
	local poolCurrentUI = ChatUIPoolManager:getPool(drawPanelIndex)	-- 사용할 컨트롤 풀
	self._currentPoolIndex = drawPanelIndex

	local IsMouseOver = UI.checkIsInMouseAndEventPanel( currentPanel );

	if nil == isShow then
		isShow = false
	end

	if( isMouseOnChattingViewIndex ~= nil and isMouseOnChattingViewIndex == drawPanelIndex ) then
		isShow = isMouseOn;
		if( isShow ) then
			bgAlpah = 1.0
		end
	else
		isShow = IsMouseOver;
	end

	-- 월드맵 복귀 후 투명도 조정
	currentPanel:SetColor( ffffffff )

	local isActivePanel = ( panelIndex == self._mainPanelSelectPanelIndex )
	_tabButton_PosX = self:createTab( poolCurrentUI, panelIndex, isActivePanel, drawPanelIndex, isCombinedMainPanel, _tabButton_PosX, isShow )
	addChat_PosX = _tabButton_PosX

	if ( isCombinedMainPanel ) then
		-- 여기서 탭버튼을 생성해야함  함수를 추가하는게 좋을듯

		if( 0 ~= panelIndex ) then
			ChatUIPoolManager:getPanel(panelIndex):SetShow( false )
			ChatUIPoolManager:getPanel(panelIndex):SetIgnore( true )
		end
		
		if ( false == isActivePanel ) then	-- 활성화된 탭이 아니면 탭버튼만 만들고 넘김
			return
		end

	elseif false == isCombinedMainPanel and true == chatPanel:isOpen() then
		if ChatUIPoolManager:getPanel(0):GetShow() then							-- 0번 패널이 열려 있어야 열릴 수 있다.
			ChatUIPoolManager:getPanel(panelIndex):SetShow( true )
			ChatUIPoolManager:getPanel(panelIndex):SetIgnore( false )
		end

	elseif false == isCombinedMainPanel and false == chatPanel:isOpen() then
		ChatUIPoolManager:getPanel(panelIndex):SetShow( false )
		ChatUIPoolManager:getPanel(panelIndex):SetIgnore( true )
	end
	
	-- 여기는 한번만 들어옵니다.
	-- 여기부터 채팅창 그리기	

	-- 채팅창 추가 버튼 생성
	
	-- local	isUIControlShow = Panel_UIControl:GetShow()	-- UIControl이 켜 있어야, 리사이즈 버튼 나온다. 
	local	panel_resizeButton = poolCurrentUI:newResizeButton()
			panel_resizeButton:SetNotAbleMasking( true )
			panel_resizeButton:SetShow( isShow )		--
			panel_resizeButton:addInputEvent( "Mouse_LDown",	"HandleClicked_Chatting_ResizeStartPos( "  .. drawPanelIndex ..  " )")
			panel_resizeButton:addInputEvent( "Mouse_LPress",	"HandleClicked_Chatting_Resize( "  .. drawPanelIndex ..  " )" )
			panel_resizeButton:addInputEvent( "Mouse_RPress",	"Chatting_PanelTransparency( "  .. drawPanelIndex ..  ", false )" )
			panel_resizeButton:addInputEvent( "Mouse_LUp",		"HandleClicked_Chatting_ResizeStartPosEND(" .. drawPanelIndex .. ")" )	-- 놓을 때 저장한다.
			panel_resizeButton:addInputEvent( "Mouse_RUp",		"Chatting_PanelTransparency( "  .. drawPanelIndex ..  ", false )" )
			panel_resizeButton:addInputEvent( "Mouse_Out",		"Chatting_PanelTransparency(" .. drawPanelIndex .. ", false )" )
	local	panel_Bg = poolCurrentUI:newPanelBG()
			panel_Bg:SetNotAbleMasking( true )
			panel_Bg:SetShow( true )
			panel_Bg:SetIgnore( true )
			panel_Bg:SetAlpha( bgAlpah )
			panel_Bg:SetSize( panel_Bg:GetSizeX(), currentPanel:GetSizeY() - 30 )
			panel_Bg:SetPosY( 30 )
	local 	panel_Scroll = poolCurrentUI:newScroll()
			panel_Scroll:SetShow( isShow )		--
			panel_Scroll:SetInterval( self._maxHistoryCount )
			panel_Scroll:SetPosX( panel_Bg:GetSizeX() - panel_Scroll:GetSizeX() - 3 )
			panel_Scroll:SetControlPos( self._scroll_BTNPos[panelIndex] )
			panel_Scroll:addInputEvent( "Mouse_LUp", "HandleClicked_ScrollBtnPosY( " .. panelIndex .. " )" )
			panel_Scroll:addInputEvent( "Mouse_Out",		"Chatting_PanelTransparency(" .. panelIndex .. ", false )" )
	local	panel_ScrollBtn = panel_Scroll:GetControlButton()
			panel_ScrollBtn:addInputEvent( "Mouse_LPress", "HandleClicked_ScrollBtnPosY( " .. panelIndex .. " )" )
			panel_ScrollBtn:addInputEvent( "Mouse_RPress", "HandleClicked_ScrollBtnPosY( " .. panelIndex .. " )" )
			panel_ScrollBtn:addInputEvent( "Mouse_Out",		"Chatting_PanelTransparency(" .. panelIndex .. ", false )" )
			
			if getEnableSimpleUI() then
				-- panel_resizeButton:SetShow( self._cacheSimpleUI )
				panel_Scroll:SetShow( self._cacheSimpleUI )
				panel_ScrollBtn:SetShow( self._cacheSimpleUI )
			end

	local messageIndex = self._srollPosition[panelIndex]			-- 이건 스크롤해서 얻어오시길
	local chattingMessage = chatPanel:beginMessage( messageIndex )
	local chatting_content_PosY = currentPanel:GetSizeY() - 10					-- 채팅 콘텐츠 기본 위치(아래서부터 위로 출력)

	while nil ~= chattingMessage do
		-- 채팅 메시지를 뿌리고, 위치 값을 반환
		chatting_content_PosY = self:CreateChattingContent( chattingMessage, poolCurrentUI, chatting_content_PosY, messageIndex )

		if 45 > chatting_content_PosY then
			break
		else
			chattingMessage = chatPanel:nextMessage()
			messageIndex = messageIndex + 1
		end
	end
end

function ChattingViewManager:CreateChattingContent( chattingMessage, poolCurrentUI, PosY, messageIndex )
	local panelSizeX 			= poolCurrentUI._list_PanelBG[0]:GetSizeX() - 20
	local panelSizeY 			= poolCurrentUI._list_PanelBG[0]:GetSizeY()
	local sender 				= chattingMessage:getSender()
	local chatType 				= chattingMessage.chatType
	local noticeType 			= chattingMessage.noticeType
	local isMe					= chattingMessage.isMe
	local isGameManager 		= chattingMessage.isGameManager
	local msgColor 				= Chatting_MessageColor(chatType, noticeType)
	local msg 					= nil
	local msgData				= nil
	local isLinkedItem			= chattingMessage:isLinkedItem()
	local chatting_Icon			= poolCurrentUI:newChattingIcon()
	-- local chatting_senderHead	= poolCurrentUI:newChattingSenderHead()
	local chatting_sender		= poolCurrentUI:newChattingSender( messageIndex )
	local isDev					= ToClient_IsDevelopment()
	local chatting_contents		= {}

	if true == isGameManager and (not isDev) then	-- GM이면 녹색
		msgColor = 4282515258
	end

	chatting_Icon:SetShow( true )

	if chatType == CppEnums.ChatType.Private and false == chattingMessage.isMe then
		ChatInput_SetLastWhispersUserId( sender )
		if (Int64toInt32(getUtc64() - chattingMessage._time_s64) < 1) then
			local isSoundAlert = true;
			if ChatInput_GetLastWhispersUserId() == sender then
				if ( (getTickCount32() - ChatInput_GetLastWhispersTick()) > 1000 ) then
					ChatInput_SetLastWhispersTick();
				else
					isSoundAlert = false;
				end
			else
				ChatInput_SetLastWhispersTick();
			end
			
					
			if isSoundAlert and isPhotoMode() then					-- 포토 모드/화면보고히 모드라면 다른 소리가 난다
				audioPostEvent_SystemUi(08,14)
			elseif isSoundAlert and not isFocusInChatting() then	-- 이미 채팅중이면 소리를 낼 필요가 없다. 관심을 가지고 있다는 의미
				-- ♬ 귓속말 올 때 소리난다요
				--audioPostEvent_SystemUi(08,13)
			end
		end
	--elseif chatType == CppEnums.ChatType.Party then
	--	if (Int64toInt32(getUtc64() - chattingMessage._time_s64) < 1) then
	--		if ( (getTickCount32() - ChatInput_GetLastPartyTick()) > 5000 and (not isFocusInChatting()) ) then -- 이미 채팅중이면 소리를 낼 필요가 없다. 관심을 가지고 있다는 의미
	--			-- ♬ 파티 채팅 올 때 소리난다요
	--			ChatInput_SetLastPartyTick();
	--			audioPostEvent_SystemUi(08,13)
	--		end
	--	end
	--elseif chatType == CppEnums.ChatType.Guild then
	--	if (Int64toInt32(getUtc64() - chattingMessage._time_s64) < 1) then
	--		if ( (getTickCount32() - ChatInput_GetLastGuildTick()) > 5000 and (not isFocusInChatting()) ) then -- 이미 채팅중이면 소리를 낼 필요가 없다. 관심을 가지고 있다는 의미
	--			-- ♬ 길드 채팅 올 때 소리난다요
	--			ChatInput_SetLastGuildTick();
	--			audioPostEvent_SystemUi(08,13)
	--		end
	--	end
	end

	if (UI_CT.System == chatType)		then
		sender		= PAGetString( Defines.StringSheet_GAME, "CHATTING_TAB_SYSTEM" )
	elseif (UI_CT.Notice == chatType)	then
		sender		= PAGetString( Defines.StringSheet_GAME, "CHATTING_NOTICE" )
		chatType	= UI_CT.System
	elseif (UI_CT.Battle == chatType) then
		sender		= PAGetString( Defines.StringSheet_GAME, "CHATTING_BATTLE" )
	end
	
	local senderStr = "[" .. sender .. "] : "
	if UI_CT.Private == chatType then
		if not isMe then
			senderStr = "◀ " .. senderStr
		end
	end

	local chatting_sender_sizeX = 80 -- chatting_sender:GetTextSizeX()
	
	if isLinkedItem and ( ( UI_CT.World == chatType ) or ( UI_CT.Guild == chatType ) or ( UI_CT.System == chatType ) or (UI_CT.Public == chatType) or (UI_CT.Party == chatType) or (UI_CT.WorldWithItem == chatType) ) then
		chatting_sender:SetTextHorizonRight()
		chatting_sender:SetText( senderStr )
		chatting_sender:SetFontColor( msgColor )

		local senderSizeX			= chatting_sender:GetTextSizeX()
		local senderDefaultSizeX	= 88
		local senderAddOverSizeX	= senderSizeX - senderDefaultSizeX
		local chattingContentPosX	= 0
		local senderDefaultPosX		= 30

		if senderDefaultSizeX < senderSizeX then
			chatting_sender	:SetPosX( senderDefaultPosX + senderAddOverSizeX )
			chatting_Icon:SetPosX( 3 )
			chattingContentPosX = chatting_sender:GetTextSizeX() - 8
		else
			chatting_sender	:SetPosX( senderDefaultPosX )
			chatting_Icon:SetPosX( senderDefaultPosX + chatting_sender:GetSizeX() - chatting_sender:GetTextSizeX() - chatting_Icon:GetSizeX() - 3 )
			chattingContentPosX = chatting_sender:GetSizeX()
			senderAddOverSizeX = 0
		end
		---

		chatting_sender:SetSize(chatting_sender_sizeX, chatting_sender:GetSizeY())
		chatting_sender:SetShow( true )
		
		if false == isMe then
			chatting_sender:SetIgnore( false )
		else
			chatting_sender:SetIgnore( true )
		end
		
		if UI_CT.Public == chatType then
			chatting_sender:SetOverFontColor(UI_color.C_FFC4BEBE)
		else
			chatting_sender:SetOverFontColor(UI_color.C_FFFFFFFF)
		end
		
		msg = chattingMessage:getContent()
		local linkedMsgSplit = {}
		local linkedMsgCount = 0
		local linkedItemIndex = 0
		local startIndex = chattingMessage:getLinkedItemStartIndex()
		local endIndex = chattingMessage:getLinkedItemEndIndex()
		
		if 0 < startIndex then
			linkedMsgSplit[0] = string.sub(msg, 1, startIndex)
			linkedMsgSplit[1] = string.sub(msg, startIndex+1, endIndex)
			linkedMsgCount = 2
			linkedItemIndex = 1
			if endIndex < string.len(msg) then	-- 한 줄에 끝나지 않았다.
				linkedMsgSplit[2] = string.sub(msg, endIndex+1, string.len(msg))
				linkedMsgCount = 3
			end
		else	-- 한 줄에 끝났다.
			linkedMsgSplit[0] = string.sub(msg, 1, endIndex)
			linkedMsgCount = 1
			linkedItemIndex = 0
			if endIndex < string.len(msg) then
				linkedMsgSplit[1] = string.sub(msg, endIndex+1, string.len(msg))
				linkedMsgCount = 2
			end
		end
		
		-- linkedMsgSplit[0] = " : " .. linkedMsgSplit[0]
		chatting_contents[0] = chatting_sender
		local currentStaticIndex = 1
		for index = 0, linkedMsgCount-1, 1 do
			msgData = linkedMsgSplit[index]
			local msgDataLen = string.len(msgData)
			while 0 < msgDataLen do
				if index == linkedItemIndex then
					chatting_contents[currentStaticIndex] = poolCurrentUI:newChattingLinkedItem( messageIndex )
					chatting_contents[currentStaticIndex]:SetIgnore( false )
					chatting_contents[currentStaticIndex]:SetFontColor( UI_color.C_FFFFCF4C )
				else
					chatting_contents[currentStaticIndex] = poolCurrentUI:newChattingContents()
					chatting_contents[currentStaticIndex]:SetIgnore( true )
					chatting_contents[currentStaticIndex]:SetFontColor( msgColor )
				end
				
				--chatting_contents[currentStaticIndex]:SetFontColor( msgColor )
				
				local textStaticSizeX = panelSizeX - 3 - chatting_sender_sizeX - senderDefaultPosX - senderAddOverSizeX
				local textStaticPosX = 5 + chatting_sender_sizeX + senderDefaultPosX + senderAddOverSizeX
				local j = 1
				local isWhile = false

				while ( 2 <= currentStaticIndex ) and ( ( chatting_contents[currentStaticIndex-j]:GetSizeX() ) < (panelSizeX - 3 - chatting_sender_sizeX - senderDefaultPosX - senderAddOverSizeX) ) do
					isWhile = true
					textStaticSizeX = textStaticSizeX - chatting_contents[currentStaticIndex-j]:GetSizeX()
					textStaticPosX = textStaticPosX + chatting_contents[currentStaticIndex-j]:GetSizeX()
					if 5 + chatting_sender_sizeX + senderDefaultPosX + senderAddOverSizeX == chatting_contents[currentStaticIndex-j]:GetPosX() then
						break
					end
					j = j + 1
				end
				
				if 0 == textStaticSizeX or isWhile == false then
					textStaticSizeX = panelSizeX - 3 - chatting_sender_sizeX - senderDefaultPosX
					textStaticPosX = 5 + chatting_sender_sizeX + senderDefaultPosX + senderAddOverSizeX
				end
				chatting_contents[currentStaticIndex]:SetSize( textStaticSizeX, chatting_sender:GetSizeY() )
				chatting_contents[currentStaticIndex]:SetPosX( textStaticPosX )
				

				msg = chatting_contents[currentStaticIndex]:GetTextLimitWidth( msgData )
				chatting_contents[currentStaticIndex]:SetText( msg )
				
				if string.len( msg ) < string.len( msgData ) then
					local msgStr = string.sub(msgData, string.len(msg)+1, string.len(msgData))
					msgData = msgStr
					msgDataLen = string.len( msgData )
				else
					msgDataLen = 0
				end
				currentStaticIndex = currentStaticIndex + 1
			end
			chatting_contents[currentStaticIndex-1]:SetSize(chatting_contents[currentStaticIndex-1]:GetTextSizeX(), chatting_sender:GetSizeY())
		end
		
		for index = currentStaticIndex - 1, 1, -1 do
			chatting_contents[index]:SetPosY( PosY - chatting_contents[index]:GetSizeY() )
			chatting_contents[index]:SetShow(true)
			if 5 + chatting_sender_sizeX + senderDefaultPosX + senderAddOverSizeX  == chatting_contents[index]:GetPosX() then
				PosY = PosY - chatting_contents[index]:GetSizeY()
				if 1 ~= index then
					chatting_contents[index]:SetPosX( chatting_sender_sizeX + senderDefaultPosX )
				end
			end
		end
		chatting_Icon:SetPosY( PosY + 3 )
		chatting_contents[0]:SetPosY(PosY)
		PosY = PosY - 3
	else
		chatting_sender:SetTextHorizonRight()
		chatting_sender:SetText( senderStr )
		chatting_sender:SetFontColor( msgColor )	
		
		chatting_sender:SetSize(chatting_sender_sizeX, chatting_sender:GetSizeY())

		local senderSizeX			= chatting_sender:GetTextSizeX()
		local senderDefaultSizeX	= 88
		local senderAddOverSizeX	= senderSizeX - senderDefaultSizeX
		local chattingContentPosX	= 0
		local senderDefaultPosX		= 30

		if senderDefaultSizeX < senderSizeX then
			chatting_sender	:SetPosX( senderDefaultPosX + senderAddOverSizeX )
			chatting_Icon:SetPosX( 3 )
			chattingContentPosX = chatting_sender:GetTextSizeX() - 8
		else
			chatting_sender	:SetPosX( senderDefaultPosX )
			chatting_Icon:SetPosX( senderDefaultPosX + chatting_sender:GetSizeX() - chatting_sender:GetTextSizeX() - chatting_Icon:GetSizeX() - 3 )
			chattingContentPosX = chatting_sender:GetSizeX()
			senderAddOverSizeX = 0
		end

		chatting_sender:SetShow( true )
		
		msg = chattingMessage:getContent()
		
		-- msg = " : " .. msg
		local remainSizeX = panelSizeX - chattingContentPosX
		chatting_contents[0] = poolCurrentUI:newChattingContents()
		chatting_contents[0]:SetSize( remainSizeX - senderDefaultPosX, chatting_sender:GetSizeY() )

		chatting_contents[0]:SetTextMode( UI_TM.eTextMode_AutoWrap )
		
		chatting_contents[0]:SetAutoResize( true )
		chatting_contents[0]:SetText( msg )
		chatting_contents[0]:SetShow( true )
		chatting_contents[0]:SetFontColor( msgColor )
				
		chatting_Icon:SetPosY( PosY - chatting_contents[0]:GetSizeY() + 3 )
		chatting_sender:SetPosY( PosY - chatting_contents[0]:GetSizeY() )
		chatting_contents[0]:SetPosY( chatting_sender:GetPosY() )	-- chatting_sender:GetPosY()
		chatting_contents[0]:SetPosX( senderDefaultPosX + chattingContentPosX )

		PosY = PosY - chatting_contents[0]:GetSizeY() - 3
		
		if UI_CT.System == chatType or UI_CT.Notice == chatType or isMe then
			chatting_sender:SetIgnore( true )
		else
			chatting_sender:SetIgnore( false )
		end
		
		if UI_CT.Public == chatType then
			chatting_sender:SetOverFontColor(UI_color.C_FFC4BEBE)
		else
			chatting_sender:SetOverFontColor(UI_color.C_FFFFFFFF)
		end
	end
	

	if getEnableSimpleUI() then
		if ChattingViewManager._cacheSimpleUI then
			chatting_sender:SetFontAlpha( 1.0 );
			chatting_contents[0]:SetFontAlpha( 1.0 );
			for _,contents in ipairs(chatting_contents) do
				contents:SetFontAlpha( 1.0 );
			end
		else
			local alphaRate = math.pow( math.max(math.min( 1.0 - ((panelSizeY - PosY) / panelSizeY), 1 ), 0.01), 0.2 );
			chatting_sender:SetFontAlpha( alphaRate );
			chatting_contents[0]:SetFontAlpha( alphaRate );
			for _,contents in ipairs(chatting_contents) do
				contents:SetFontAlpha( alphaRate );
			end
		end
	end
	
	return PosY -3
end

function ChattingViewManager:createTab( poolCurrentUI, panelIndex, isActivePanel, drawPanelIndex, isCombinedMainPanel, PosX, isShow )
	if isCombinedMainPanel then													-- 해당 채팅 패널이 메인창에 붙어 있다면,
		if isActivePanel then													-- 패널 인덱스가 활성화 된 상태라면 큰 버튼
			local	mainTab	= poolCurrentUI:newTitleTab()						-- 메인탭 생성
					mainTab:SetTextHorizonLeft( true )
					mainTab:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_CHATTING_MAINTAB_TITLE", "panel_Index", (panelIndex + 1) ) )
					mainTab:SetNotAbleMasking( true )
					mainTab:SetPosX( PosX )
					mainTab:SetTextSpan( 40, 9 )
					mainTab:SetShow( isShow )		--
					mainTab:addInputEvent( "Mouse_Out", "Chatting_PanelTransparency(" .. drawPanelIndex .. ", false )" )
			local	settingButton = poolCurrentUI:newTitleTabConfigButton()		-- 탭설정 버튼 생성
					settingButton:SetShow( isShow )		--
					settingButton:SetNotAbleMasking( true )
					settingButton:SetPosX( PosX + 3 )
					settingButton:addInputEvent( "Mouse_LUp",	"ChattingOption_Open( " .. panelIndex .. ", " .. drawPanelIndex .. ", " .. tostring(isCombinedMainPanel) .." )" )
					settingButton:addInputEvent( "Mouse_Out",	"Chatting_PanelTransparency(" .. drawPanelIndex .. ", false )" )
					settingButton:addInputEvent( "Mouse_LPress", "Chatting_Transparency(" .. drawPanelIndex .. ")" )
					settingButton:addInputEvent( "Mouse_RPress", "Chatting_Transparency(" .. drawPanelIndex .. ")" )
					
					if getEnableSimpleUI() then
						if ChattingViewManager._cacheSimpleUI then
							mainTab:SetFontAlpha( 1.0 );
							mainTab:SetAlpha( 1.0 );
							settingButton:SetAlpha( 1.0 );
						else
							mainTab:SetFontAlpha( 0.8 );
							mainTab:SetAlpha( 0.7 );
							settingButton:SetAlpha( 0.7 );
						end
					end
			if 0 ~= panelIndex then
				local 	divisionButton = poolCurrentUI:newPanelDivision()		-- 분리버튼 생성
						divisionButton:SetShow( isShow )		--
						divisionButton:SetNotAbleMasking( true )
						divisionButton:SetPosX( PosX + mainTab:GetSizeX() - ( divisionButton:GetSizeX() * 2 ) - 5 )
						divisionButton:addInputEvent( "Mouse_LUp", "HandleClicked_Chatting_Division( " .. panelIndex .. " )" )
						divisionButton:addInputEvent( "Mouse_Out",		"Chatting_PanelTransparency(" .. drawPanelIndex .. ", false )" )
						divisionButton:addInputEvent( "Mouse_LPress", "Chatting_Transparency(" .. drawPanelIndex .. ")" )
						divisionButton:addInputEvent( "Mouse_RPress", "Chatting_Transparency(" .. drawPanelIndex .. ")" )
				local 	deleteButton = poolCurrentUI:newCloseButton()			-- 삭제버튼 생성
						deleteButton:SetShow( isShow )		--
						deleteButton:SetNotAbleMasking( true )
						deleteButton:SetIgnore( false )
						deleteButton:SetPosX(  PosX + mainTab:GetSizeX() - deleteButton:GetSizeX() - 5  )
						deleteButton:addInputEvent( "Mouse_LUp", "HandleClicked_Chatting_Close( " .. panelIndex .. " )" )
						deleteButton:addInputEvent( "Mouse_Out",		"Chatting_PanelTransparency(" .. drawPanelIndex .. ", false )" )
						deleteButton:addInputEvent( "Mouse_LPress", "Chatting_Transparency(" .. drawPanelIndex .. ")" )
						deleteButton:addInputEvent( "Mouse_RPress", "Chatting_Transparency(" .. drawPanelIndex .. ")" )
					
						if getEnableSimpleUI() then
							if ChattingViewManager._cacheSimpleUI then
								divisionButton:SetAlpha( 1.0 );
								deleteButton:SetAlpha( 1.0 );
							else
								divisionButton:SetAlpha( 0.7 );
								deleteButton:SetAlpha( 0.7 );
							end
						end
			end
			
			PosX = PosX + mainTab:GetSizeX()
		else																	-- 패널 인덱스가 비활성화 된 상태라면 작은 버튼
			local	subTab	= poolCurrentUI:newOtherTab()						-- 작은탭 생성
					subTab:SetTextHorizonCenter( true )
					subTab:SetText( panelIndex + 1 )
					subTab:SetNotAbleMasking( true )
					subTab:SetPosX( PosX )
					local penal = ToClient_getChattingPanel( 0 )
					subTab:SetShow( isShow )				--
					if getEnableSimpleUI() then
						if ChattingViewManager._cacheSimpleUI then
							subTab:SetFontAlpha( 1.0 );
							subTab:SetAlpha( 1.0 );
						else
							subTab:SetFontAlpha( 0.8 );
							subTab:SetAlpha( 0.7 );
						end
					end
					subTab:addInputEvent( "Mouse_LUp",	"HandleClicked_Chatting_ChangeTab( " .. panelIndex .. " )" )
					-- subTab:addInputEvent( "Mouse_On",	"Chatting_PanelTransparency(" .. panelIndex .. ", true )" )
					subTab:addInputEvent( "Mouse_Out",	"Chatting_PanelTransparency(" .. drawPanelIndex .. ", false )" )
					PosX = PosX + subTab:GetSizeX()
		end
	else																		-- 해당 채팅 패널이 새창으로 열려있다면,
		local	mainTab	= poolCurrentUI:newTitleTab()							-- 메인탭 생성
				mainTab:SetTextHorizonLeft( true )
				mainTab:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_CHATTING_MAINTAB_TITLE", "panel_Index", (panelIndex + 1) ) )
				mainTab:SetNotAbleMasking( true )
				mainTab:SetPosX( 0 )
				mainTab:SetTextSpan( 40, 8 )
				mainTab:SetShow( isShow )			--
				mainTab:addInputEvent( "Mouse_On", "Chatting_PanelTransparency(" .. panelIndex .. ", true )" )
				mainTab:addInputEvent( "Mouse_Out", "Chatting_PanelTransparency(" .. panelIndex .. ", false )" )
		local	settingButton = poolCurrentUI:newTitleTabConfigButton()			-- 설정 버튼 생성
				settingButton:SetShow( isShow )			--
				settingButton:SetNotAbleMasking( true )
				settingButton:SetPosX( 3 )
				settingButton:addInputEvent( "Mouse_LUp",	"ChattingOption_Open( " .. panelIndex .. ", " .. drawPanelIndex .. ", " .. tostring(isCombinedMainPanel) .." )" )
				settingButton:addInputEvent( "Mouse_Out",		"Chatting_PanelTransparency(" .. drawPanelIndex .. ", false )" )
				settingButton:addInputEvent( "Mouse_LPress", "Chatting_Transparency(" .. drawPanelIndex .. ")" )
				settingButton:addInputEvent( "Mouse_RPress", "Chatting_Transparency(" .. drawPanelIndex .. ")" )
		local 	combineButton = poolCurrentUI:newPanelCombine()					-- 결합버튼 생성
				combineButton:SetShow( isShow )			--
				combineButton:SetNotAbleMasking( true )
				combineButton:SetPosX(  mainTab:GetSizeX() - ( combineButton:GetSizeX() * 2 ) - 5  )
				combineButton:addInputEvent( "Mouse_LUp", "HandleClicked_Chatting_CombineTab( " .. panelIndex .. " )" )
				combineButton:addInputEvent( "Mouse_Out",		"Chatting_PanelTransparency(" .. drawPanelIndex .. ", false )" )
				combineButton:addInputEvent( "Mouse_LPress", "Chatting_Transparency(" .. drawPanelIndex .. ")" )
				combineButton:addInputEvent( "Mouse_RPress", "Chatting_Transparency(" .. drawPanelIndex .. ")" )
		local 	deleteButton = poolCurrentUI:newCloseButton()					-- 삭제버튼 생성
				deleteButton:SetShow( isShow )			--
				deleteButton:SetNotAbleMasking( true )
				deleteButton:SetIgnore( false )
				deleteButton:SetPosX(  mainTab:GetSizeX() - deleteButton:GetSizeX() - 5  )
				deleteButton:addInputEvent( "Mouse_LUp",	"HandleClicked_Chatting_Close( " .. panelIndex .. " )" )
				deleteButton:addInputEvent( "Mouse_Out",		"Chatting_PanelTransparency(" .. drawPanelIndex .. ", false )" )
				deleteButton:addInputEvent( "Mouse_LPress", "Chatting_Transparency(" .. drawPanelIndex .. ")" )
				deleteButton:addInputEvent( "Mouse_RPress", "Chatting_Transparency(" .. drawPanelIndex .. ")" )
				
				if getEnableSimpleUI() then
					if ChattingViewManager._cacheSimpleUI then
						mainTab:SetFontAlpha( 1.0 );
						mainTab:SetAlpha( 1.0 );
						settingButton:SetAlpha( 1.0 );
						combineButton:SetAlpha( 1.0 );
						deleteButton:SetAlpha( 1.0 );
					else
						mainTab:SetFontAlpha( 0.8 );
						mainTab:SetAlpha( 0.7 );
						settingButton:SetAlpha( 0.7 );
						combineButton:SetAlpha( 0.7 );
						deleteButton:SetAlpha( 0.7 );
					end
					-- mainTab:SetAlpha( ChattingViewManager._transparency[drawPanelIndex] )
				end
	end
	return PosX
end

function Chatting_ScrollEvent( poolIndex, updown )
	local self = ChattingViewManager

	local drawPoolIndex = poolIndex
	if 0 == poolIndex then
		poolIndex = self._mainPanelSelectPanelIndex 
	end

	local poolCurrentUI = ChatUIPoolManager:getPool( drawPoolIndex )
	
	if true == updown then
		poolCurrentUI._list_Scroll[0]:ControlButtonUp()

		if self._maxHistoryCount > self._srollPosition[poolIndex] then
			self._srollPosition[poolIndex] = self._srollPosition[poolIndex] + 1
		end
	else
		poolCurrentUI._list_Scroll[0]:ControlButtonDown()

		if 0 < self._srollPosition[poolIndex] then
			self._srollPosition[poolIndex] = self._srollPosition[poolIndex] - 1
		end
	end
	local poolDrawUI = ChatUIPoolManager:getPool( drawPoolIndex )
	self._scroll_BTNPos[poolIndex] = poolDrawUI._list_Scroll[0]:GetControlPos()

	FromClient_ChatUpdate( true )
end

function Chatting_OnResize()
	local divisionPanel, panel, chatUI

	-- local haveServerPosotion = 0 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_ChattingWindow, CppEnums.PanelSaveType.PanelSaveType_IsSaved)
	
	-- if haveServerPosotion then
	-- 	-- changePositionBySever(panel, CppEnums.PAGameUIType.PAGameUIPanel_ChattingWindow, true)
	-- 	return
	-- end
	
	for poolIndex = 0, ChatUIPoolManager._poolCount-1, 1 do
		divisionPanel 	= ToClient_getChattingPanel( poolIndex )
		panel 			= ChatUIPoolManager._listPanel[poolIndex]	
		chatUI 			= ChatUIPoolManager._listChatUIPool[poolIndex]
		
		if poolIndex ~= 0 then
			if false == divisionPanel:isOpen() or divisionPanel:isCombinedToMainPanel() then
				panel:SetShow( false )
			end
		end

		local panelSizeX = divisionPanel:getPanelSizeX()
		local panelSizeY = divisionPanel:getPanelSizeY()
		local panelPosX = divisionPanel:getPositionX() --ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_ChattingWindow, poolIndex, CppEnums.PanelSaveType.PanelSaveType_PositionX)
		local panelPosY = divisionPanel:getPositionY() --ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_ChattingWindow, poolIndex, CppEnums.PanelSaveType.PanelSaveType_PositionY)
		if ( -1 ~= panelPosX or -1 ~= panelPosY ) then
			panelPosX = ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_ChattingWindow, poolIndex, CppEnums.PanelSaveType.PanelSaveType_PositionX)
			panelPosY = ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_ChattingWindow, poolIndex, CppEnums.PanelSaveType.PanelSaveType_PositionY)
		end

		if ( 25 < panelSizeX and 50 < panelSizeY ) then	-- contents때문에 최소 25, 스크롤때문에 최소 50
			panel:SetSize(panelSizeX, panelSizeY)
			
			chatUI._list_PanelBG[0]:SetSize(panelSizeX, panelSizeY)
			chatUI._list_Scroll[0]:SetSize( chatUI._list_Scroll[0]:GetSizeX(), panelSizeY - 50 )
			
			for chattingContents_idx = 0, chatUI._maxcount_ChattingContents - 1, 1 do
				chatUI._list_ChattingContents[chattingContents_idx]:SetSize( panelSizeX - 25 , chatUI._list_ChattingContents[chattingContents_idx]:GetSizeY() )
			end
			
			chatUI._list_ResizeButton[0]:SetPosX( panelSizeX - (chatUI._list_ResizeButton[0]:GetSizeX() + 5) )
			chatUI._list_Scroll[0]:SetPosX( panelSizeX - (chatUI._list_Scroll[0]:GetSizeX() + 5) )
			chatUI._list_Scroll[0]:SetPosY( 50 )
			chatUI._list_Scroll[0]:SetControlBottom()
		else
			panelSizeX = 420
			panelSizeY = 222
			
			panel:SetSize(panelSizeX, panelSizeY)
			
			chatUI._list_PanelBG[0]:SetSize(panelSizeX, panelSizeY)
			chatUI._list_Scroll[0]:SetSize( chatUI._list_Scroll[0]:GetSizeX(), panelSizeY - 25 )
			
			for chattingContents_idx = 0, chatUI._maxcount_ChattingContents - 1, 1 do
				chatUI._list_ChattingContents[chattingContents_idx]:SetSize( panelSizeX - 25 , chatUI._list_ChattingContents[chattingContents_idx]:GetSizeY() )
			end
			
			chatUI._list_ResizeButton[0]:SetPosX( panelSizeX - (chatUI._list_ResizeButton[0]:GetSizeX() + 5) )
			chatUI._list_Scroll[0]:SetPosX( panelSizeX - (chatUI._list_Scroll[0]:GetSizeX() + 5) )
			chatUI._list_Scroll[0]:SetPosY( 50 )
			chatUI._list_Scroll[0]:SetControlBottom()
		end

		if(-1 == panelPosX) and (-1 == panelPosY) then
			panelPosX = 0
			panelPosY = getScreenSizeY() - panel:GetSizeY() - 35
		else
			if ( panelPosX < 0) then
				panelPosX = 0
			elseif ( getScreenSizeX() - panel:GetSizeX() < panelPosX ) then
				panelPosX = getScreenSizeX() - panel:GetSizeX()
			end
			
			if ( panelPosY < 0) then
				panelPosY = 0
			elseif ( getScreenSizeY() - panel:GetSizeY() < panelPosY ) then	-- -35의 의미가 툴팁때문일텐데 툴팁을 끄고 그위에 올릴수있으니 가능하도록 한다.
				panelPosY = getScreenSizeY() - panel:GetSizeY()
			end
		end

		panel:SetPosX( panelPosX )
		panel:SetPosY( panelPosY )

		local isCombinePanel = divisionPanel:isCombinedToMainPanel()
		divisionPanel:setPosition(panelPosX, panelPosY, panelSizeX, panelSizeY)
		if ( isCombinePanel ) then
			divisionPanel:combineToMainPanel()
		end
	end	
	
	FromClient_ChatUpdate()
end

function HandleClicked_ScrollBtnPosY( panelIndex )
	local poolCurrentUI = ChatUIPoolManager:getPool( panelIndex )
	local PosY = ( math.floor( poolCurrentUI._list_Scroll[0]:GetControlPos() * ( ChattingViewManager._maxHistoryCount - 1 ) + 0.5 ) - (ChattingViewManager._maxHistoryCount -1) ) * ( -1 )
	if PosY ~= ChattingViewManager._srollPosition[panelIndex] then
		ChattingViewManager._srollPosition[panelIndex] = PosY
		ChattingViewManager._scroll_BTNPos[panelIndex] = poolCurrentUI._list_Scroll[0]:GetControlPos()
	end
	FromClient_ChatUpdate( true )
end

function HandleClicked_Chatting_AddTab()
	ChattingViewManager._addChattingIdx = ToClient_openChattingPanel()
	FromClient_ChatUpdate( true )
	ToClient_SaveUiInfo(true)
end

function HandleClicked_Chatting_ChangeTab( panelIndex )
	ChattingViewManager._mainPanelSelectPanelIndex = panelIndex
	FromClient_ChatUpdate( true )
end

function HandleClicked_Chatting_Division( panelIndex )
	local divisionPanel = ToClient_getChattingPanel( panelIndex )
	local panel = ChatUIPoolManager:getPanel( panelIndex )
	divisionPanel:setPosition((getScreenSizeX() / 2) - (panel:GetSizeX() / 2), (getScreenSizeY() / 2) - (panel:GetSizeY() / 2), panel:GetSizeX(), panel:GetSizeY() )
	panel:SetPosX( ( getScreenSizeX() / 2 ) - ( panel:GetSizeX() / 2 ) )
	panel:SetPosY( ( getScreenSizeY() / 2 ) - ( panel:GetSizeY() / 2 ) )
	panel:SetShow( true )
	panel:SetIgnore( false )
	ChattingViewManager._mainPanelSelectPanelIndex = 0
	FromClient_ChatUpdate( true )
	ToClient_SaveUiInfo(true)
end

function HandleClicked_Chatting_CombineTab( panelIndex )
	local penel = ToClient_getChattingPanel( panelIndex )
	penel:combineToMainPanel()
	FromClient_ChatUpdate( true )
	ToClient_SaveUiInfo(true)
end

function HandleClicked_Chatting_Close( panelIndex )
	ToClient_closeChattingPanel( panelIndex )
	ChattingViewManager._mainPanelSelectPanelIndex = 0
	FromClient_ChatUpdate()
	ToClient_SaveUiInfo(true)
end

local orgMouseX = 0
local orgMouseY = 0
local orgPanelSizeX = 0
local orgPanelSizeY = 0
local orgPanelPosY = 0
function HandleClicked_Chatting_ResizeStartPos( drawPanelIndex )
	local panel 	= ChatUIPoolManager:getPanel( drawPanelIndex )
	orgMouseX 		= getMousePosX()
	orgMouseY 		= getMousePosY()
	orgPanelPosY	= panel:GetPosY()
	orgPanelSizeX	= panel:GetSizeX()
	orgPanelSizeY	= panel:GetSizeY()
	FromClient_ChatUpdate( true, drawPanelIndex )
end

function HandleClicked_Chatting_ResizeStartPosEND( drawPanelIndex )
	ToClient_SaveUiInfo( true )
	Chatting_PanelTransparency( drawPanelIndex, false )
end

function HandleClicked_Chatting_Resize( drawPanelIndex )
	local panel 	= ChatUIPoolManager:getPanel( drawPanelIndex )
	local chatUI 	= ChatUIPoolManager:getPool( drawPanelIndex )

	local currentX	= getMousePosX()
	local currentY	= getMousePosY()

	local deltaX 	= currentX - orgMouseX
	local deltaY 	= orgMouseY - currentY
	local sizeX		= orgPanelSizeX + deltaX
	local sizeY		= orgPanelSizeY + deltaY
	--local minX, maxX, minY, maxY = 0, 0, 0, 0
	
	if 600 <= sizeX then
		sizeX = 600
	elseif sizeX <= 200 then
		sizeX = 200
	end
	
	if sizeY <= 100 then
		sizeY = 100
	end
	
	local deltaPosY = orgPanelSizeY - sizeY

	--if ( (orgPanelSizeX + deltaX) < 600 ) and ( 200 < (orgPanelSizeX + deltaX) ) and ( (orgPanelSizeY + deltaY) < 600 ) and ( 100 < (orgPanelSizeY + deltaY) ) then
	panel:SetSize(sizeX, sizeY)
	chatUI._list_PanelBG[0]:SetSize(sizeX, sizeY)
	chatUI._list_Scroll[0]:SetSize( chatUI._list_Scroll[0]:GetSizeX(), sizeY - 25 )
	for chattingContents_idx = 0, chatUI._maxcount_ChattingContents - 1, 1 do
		chatUI._list_ChattingContents[chattingContents_idx]:SetSize( (sizeX) - 25 , chatUI._list_ChattingContents[chattingContents_idx]:GetSizeY() )
	end
	
	
	panel:SetPosY(orgPanelPosY + deltaPosY)
	chatUI._list_ResizeButton[0]:SetPosX( sizeX - (chatUI._list_ResizeButton[0]:GetSizeX() + 5) )
	chatUI._list_Scroll[0]:SetPosX( sizeX - (chatUI._list_Scroll[0]:GetSizeX() + 5) )
	chatUI._list_Scroll[0]:SetControlBottom()
	-- ChattingViewManager._srollPosition[drawPanelIndex] = 0	-- 사이즈를 조절할 때 인덱스를 재설정하면 안된다.
	FromClient_ChatUpdate( true, drawPanelIndex )
	
	ToClient_SaveUiInfo(false)
end

function HandleOn_ChattingLinkedItem( poolIndex, LinkedItemStaticIndex )
	local paramIndex = poolIndex
	if(0 == poolIndex) then
		paramIndex = ChattingViewManager._mainPanelSelectPanelIndex
	end
	local chatPanel = ToClient_getChattingPanel( paramIndex )
	local poolCurrentUI = ChatUIPoolManager:getPool( poolIndex )
	local panelCurrentUI = ChatUIPoolManager:getPanel( poolIndex )
	local messageIndex = poolCurrentUI._list_LinkedItemMessageIndex[LinkedItemStaticIndex]
	local chattingMessage = chatPanel:beginMessage( messageIndex )
	if chattingMessage:isLinkedItem() then
		local chattingLinkedItem = chattingMessage:getLinkedItemInfo()
		local itemSSW = chattingLinkedItem:getLinkedItemStaticStatus()
		if nil ~= itemSSW then
			Panel_Tooltip_Item_Show_ForChattingLinkedItem( itemSSW, panelCurrentUI, true, false, chattingLinkedItem )
		end
	end
end

--function HandleOut_ChattingLinkedItem()
--	Panel_Tooltip_Item_hideTooltip()
--end

function HandleClicked_ChattingSender( poolIndex, senderStaticIndex )
	local paramIndex = poolIndex
	if(0 == poolIndex) then
		paramIndex = ChattingViewManager._mainPanelSelectPanelIndex
	end
	
	local posX = getMousePosX()
	local posY = getMousePosY()
	
	local chatPanel = ToClient_getChattingPanel( paramIndex )
	local poolCurrentUI = ChatUIPoolManager:getPool( poolIndex )
	local messageIndex = poolCurrentUI._list_SenderMessageIndex[senderStaticIndex]
	local chattingMessage = chatPanel:beginMessage( messageIndex )	

	if nil ~= chattingMessage then
		clickedName = chattingMessage:getSender()
		clickedMsg	= chattingMessage:getContent()
		chatType = chattingMessage.chatType
		isSameChannel = chattingMessage.isSameChannel
		currentPoolIndex = paramIndex
		clickedMessageIndex = messageIndex
		if nil ~= clickedName then
			setClipBoardText( clickedName )
			if ChatSubMenu._mainPanel:IsShow() then
				ChatSubMenu:SetShow( false )
			end
			ChatSubMenu:SetShow( true, isInviteParty(chatType, isSameChannel), isInviteGuild(chatType, isSameChannel), clickedName )
			ChatSubMenu:SetPos(posX, posY)
		end
	else
		clickedName = nil
		clickedMsg = nil
		currentPoolIndex = nil
		clickedMessageIndex = nil
	end
end

function isInviteParty(chatType, isSameChannel)
	local selfPlayer = getSelfPlayer()
	local selfActorKeyRaw = selfPlayer:getActorKey()
	local isInvite = ( selfPlayer:isPartyLeader(selfActorKeyRaw) or false == (selfPlayer:isPartyMemberActorKey(selfActorKeyRaw)) )
	
	return ( isSameChannel and (UI_CT.Party ~= chatType) and isInvite )
end

function isInviteGuild(chatType, isSameChannel)
	local selfPlayer = getSelfPlayer()
	local selfActorKeyRaw = selfPlayer:getActorKey()
	
	return ( isSameChannel and (UI_CT.Guild ~= chatType) and (selfPlayer:isSpecialGuildMember(selfActorKeyRaw)) )
end

function HandleClicked_ChatSubMenu_SendWhisper()
	if nil ~= clickedName then
		FGlobal_ChattingInput_ShowWhisper( clickedName )
		ChatSubMenu:SetShow(false)
		
		clickedName = nil
		clickedMsg	= nil
		currentPoolIndex = nil
		clickedMessageIndex = nil
	end
end

function HandleClicked_ChatSubMenu_AddFriend()
	if nil ~= clickedName then
		requestFriendList_addFriend( clickedName, true )
		ChatSubMenu:SetShow(false)
		
		clickedName = nil
		clickedMsg = nil
		currentPoolIndex = nil
		clickedMessageIndex = nil
	end
end

function HandleClicked_ChatSubMenu_InviteParty()
	if nil ~= currentPoolIndex and nil ~= clickedMessageIndex then
		--ToClient_RequestInvitePartyByChatSubMenu( currentPoolIndex, clickedMessageIndex )
		ToClient_RequestInvitePartyByChatSubMenu( currentPoolIndex, clickedName )
		ChatSubMenu:SetShow(false)
		
		clickedName = nil
		clickedMsg = nil
		currentPoolIndex = nil
		clickedMessageIndex = nil
	end
end

function HandleClicked_ChatSubMenu_InviteGuild()
	if nil ~= currentPoolIndex and nil ~= clickedMessageIndex then
		--ToClient_RequestInviteGuildByChatSubMenu( currentPoolIndex, clickedMessageIndex )
		ToClient_RequestInviteGuildByChatSubMenu( currentPoolIndex, clickedName )
		
		ChatSubMenu:SetShow(false)
		
	end
end

function FromClient_requestInviteGuildByChatSubMenu( actorKeyRaw )
	local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
	if( nil == myGuildInfo ) then
		return;
	end
	local guildGrade	= myGuildInfo:getGuildGrade()
	-- 클랜
	if( 0 == guildGrade ) then
		toClient_RequestInviteGuild( actorKeyRaw, 0, 0, 0)
	else -- 길드 
		FGlobal_AgreementGuild_Master_Open_ForJoin( actorKeyRaw, clickedName, 0 )
	end
	
	clickedName = nil
	clickedMsg = nil
	currentPoolIndex = nil
	clickedMessageIndex = nil
end

function HandleClicked_ChatSubMenu_Block()
	if nil ~= currentPoolIndex and nil ~= clickedMessageIndex then
		local chatBlock = function()
			ToClient_RequestBlockCharacter( currentPoolIndex, clickedName )
			ChatSubMenu:SetShow(false)
			
			clickedName = nil
			clickedMsg = nil
			currentPoolIndex = nil
			clickedMessageIndex = nil
		end
		
		local messageContent = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_CHNATNEW_INTERCEPTION_MEMO", "clickedName", clickedName ) -- "<" .. clickedName .. ">님을 차단하시겠습니까?"
		local messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_CHNATNEW_INTERCEPTION_TITLE"), content = messageContent, functionYes = chatBlock, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
	end
end

function HandleClicked_ChatSubMenu_ReportGoldSeller()
	local selfProxy		= getSelfPlayer():get()
	local inventory		= selfProxy:getCashInventory()
	local hasItem		= inventory:getItemCount_s64( ItemEnchantKey(65208,0) ) -- 보안관 증표(캐쉬 인벤토리로 들어간다)
	if toInt64(0,0) == hasItem then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CHATNEW_NO_HAVE_ITEM") )
		return
	end
	local limitLevel = 20
	if getSelfPlayer():get():getLevel() < limitLevel then
		Proc_ShowMessage_Ack( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_CHATNEW_GOLDSELLERITEM_LIMITLEVEL", "limitLevel", limitLevel ) ) -- "more than" .. limitLevel .. "level." )
		return
	end

	if nil ~= currentPoolIndex and nil ~= clickedMessageIndex and nil ~= clickedMsg then
		FGlobal_reportSeller_Open( clickedName, clickedMsg )
	end
end

function HandleClicked_ChatSubMenu_BlockVote()
	if nil ~= currentPoolIndex and nil ~= clickedMessageIndex then
		local chatBlockVote = function()
			ToClient_RequestBlockChatByUser( clickedName )
			ChatSubMenu:SetShow(false)

			clickedName = nil
			clickedMsg = nil
			currentPoolIndex = nil
			clickedMessageIndex = nil
		end

		local messageContent = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_CHNATNEW_CHAT_BAN_MEMO", "clickedName", clickedName ) -- "<" .. clickedName .. ">님의 채팅금지를 요청하시겠습니까?"
		local messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_CHNATNEW_CHAT_BAN_TITLE"), content = messageContent, functionYes = chatBlockVote, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
	end
end

function HanldeClicked_ChatSubMenu_Introduce()

end

function FGlobal_ChattingPanel_Reset()
	for index = 0 , ChatUIPoolManager._poolCount - 1 do
		local panel = ToClient_getChattingPanel( index )
		panel:setPosition( -1, -1, -1, -1 )
		if ( 0 ~= index ) then
			panel:combineToMainPanel()
		end
	end
end

function FGlobal_Chatting_ShowToggle()
	local baseChatPanel = ChatUIPoolManager:getPanel( 0 )
	if true == baseChatPanel:GetShow() then
		baseChatPanel:SetShow( false )
	else
		baseChatPanel:SetShow( true )
	end
	FromClient_ChatUpdate()
end

function FGlobal_Chatting_PanelTransparency( panelIndex, _transparency )
	ChattingViewManager._transparency[panelIndex] = _transparency
	local chatPanel = ToClient_getChattingPanel( panelIndex )
	chatPanel:setTransparency(_transparency)
	FromClient_ChatUpdate()
end

function FGlobal_Chatting_PanelTransparency_Chk( panelIndex )
	return ChattingViewManager._transparency[panelIndex]
end

function Chatting_PanelTransparency( panelIndex, transparency )	-- 투명도 임시 저장
	local currentPanel = ChatUIPoolManager:getPanel( panelIndex );
	local IsMouseOver = UI.checkIsInMouseAndEventPanel( currentPanel );

	if true == transparency and true == IsMouseOver then
		if false == isMouseOn then
			ChattingViewManager._cacheSimpleUI = true;
			isMouseOnChattingViewIndex = panelIndex;
			isMouseOn = true
			FromClient_ChatUpdate( IsMouseOver, panelIndex, false )
		end

	elseif (false == transparency and false == IsMouseOver) then
		ChattingViewManager._cacheSimpleUI = false;
		isMouseOn = false
		isMouseOnChattingViewIndex = nil;
		FromClient_ChatUpdate( IsMouseOver, panelIndex, true )
	end
end

function FromClient_ChatUpdate( isShow, currentPanelIndex )
	_tabButton_PosX = 0
	addChat_PosX	= 0
	local openedChattingPanelCount = 0
	local count = ToClient_getChattingPanelCount()
	for panelIndex = 0, count - 1, 1 do
		local chatPanel = ToClient_getChattingPanel( panelIndex )
		if ( chatPanel:isOpen() ) then
			openedChattingPanelCount = openedChattingPanelCount + 1
			if(chatPanel:isUpdated()) then
				ChatUIPoolManager:getPool(panelIndex):clear()
				local isCombinedPanel = chatPanel:isCombinedToMainPanel()
				if currentPanelIndex == panelIndex then
					ChattingViewManager:update( chatPanel, panelIndex, isShow )
				elseif 0 == currentPanelIndex and isCombinedPanel then
					ChattingViewManager:update( chatPanel, panelIndex, isShow )
				else
					ChattingViewManager:update( chatPanel, panelIndex )
				end
			end
		else
			local panel = ChatUIPoolManager:getPanel( panelIndex )
			panel:SetShow( false )
			local poolCurrentUI = ChatUIPoolManager:getPool( panelIndex )
			poolCurrentUI:clear()
		end
	end

	if( openedChattingPanelCount < 5 ) then
		local poolCurrentUI = ChatUIPoolManager:getPool( 0 )
		local panel_addTab = poolCurrentUI:newAddTab()
		local mainPanel = ChatUIPoolManager:getPanel( 0 )	-- 그려질 패널
		panel_addTab:SetNotAbleMasking( true )

		if 0 == currentPanelIndex or nil == currentPanelIndex then
			panel_addTab:SetShow( isMouseOn )
		elseif nil ~= currentPanelIndex and 0 ~= currentPanelIndex then
			panel_addTab:SetShow( false )
		end

		panel_addTab:SetPosX( addChat_PosX )
		panel_addTab:SetPosY( 1 )
		if getEnableSimpleUI() then
			if ChattingViewManager._cacheSimpleUI then
				panel_addTab:SetAlpha( 1.0 );
			else
				panel_addTab:SetAlpha( 0.8 );
			end
		end
		panel_addTab:SetIgnore( false )
		-- panel_addTab:SetAlpha( ChattingViewManager._transparency[0] )
		panel_addTab:addInputEvent( "Mouse_LUp", "HandleClicked_Chatting_AddTab()" )
		if nil ~= currentPanelIndex then
			-- panel_addTab:addInputEvent( "Mouse_On", "Chatting_PanelTransparency(" .. currentPanelIndex .. ", true )" )
			panel_addTab:addInputEvent( "Mouse_Out", "Chatting_PanelTransparency(" .. currentPanelIndex .. ", false )" )
			panel_addTab:addInputEvent( "Mouse_LPress", "Chatting_Transparency(" .. currentPanelIndex .. ")" )
			panel_addTab:addInputEvent( "Mouse_RPress", "Chatting_Transparency(" .. currentPanelIndex .. ")" )
		end
	end

	if nil ~= ChattingViewManager._addChattingIdx then
		ChattingOption_Open( ChattingViewManager._addChattingIdx, 0, true )
		ChattingViewManager._addChattingIdx = nil
	end
end

function FGlobal_getChattingPanel( poolIndex )
	local panel = ChatUIPoolManager:getPanel( poolIndex )
	return panel
end

function FGlobal_getChattingPanelUIPool( panelIndex )
	return ChatUIPoolManager:getPool(panelIndex)
end

local postFlushFunction = function()
	local baseChatPanel = ChatUIPoolManager:getPanel( 0 )
	
	if ( Defines.UIMode.eUIMode_WorldMap == GetUIMode() or Defines.UIMode.eUIMode_Default == GetUIMode() ) then
		baseChatPanel:SetShow( true )
	else
		baseChatPanel:SetShow( false )
	end
	FromClient_ChatUpdate()
end

local postFlushRestoreFunction = function()
	local baseChatPanel = ChatUIPoolManager:getPanel( 0 )
	
	if ( Defines.UIMode.eUIMode_WorldMap == GetUIMode() or Defines.UIMode.eUIMode_Default == GetUIMode() ) then
		baseChatPanel:SetShow( true )
	else
		baseChatPanel:SetShow( false )
	end

	Chatting_OnResize()		-- 플러시를 나올 때, 포지션을 다시 잡아야 한다.펄상점/뷰티샵에서 스케일 조정을 하기 때문.
end

UI.addRunPostFlushFunction(postFlushFunction)
UI.addRunPostRestorFunction(postFlushRestoreFunction)


function Chatting_EnableSimpleUI()
	FromClient_ChatUpdate();
end

function FGlobal_InputModeChangeForChatting()
	local IM = CppEnums.EProcessorInputMode;

	if( IM.eProcessorInputMode_GameMode ==  getInputMode() ) then
		isMouseOn = false;
		FromClient_ChatUpdate( false, ChattingViewManager._mainPanelSelectPanelIndex )
	end
end

local saveWhisperTime = getTime()
local checkWhistperTime = toUint64(0,60000)
local sendPossibleTime = toUint64(0,0)-- getTime() + checkWhistperTime
function FromClient_PrivateChatMessageUpdate()
	if sendPossibleTime <= getTime() then
		audioPostEvent_SystemUi(100,00)
		sendPossibleTime = getTime() + checkWhistperTime
	end
end

registerEvent( "EventSimpleUIEnable",			"Chatting_EnableSimpleUI")
registerEvent( "EventSimpleUIDisable",			"Chatting_EnableSimpleUI")

registerEvent( "EventChattingMessageUpdate",	"FromClient_ChatUpdate" )
registerEvent( "onScreenResize", 				"Chatting_OnResize")
registerEvent( "EventProcessorInputModeChange",	"FGlobal_InputModeChangeForChatting")
registerEvent( "FromClient_requestInviteGuildByChatSubMenu", "FromClient_requestInviteGuildByChatSubMenu" )
registerEvent( "FromClient_PrivateChatMessageUpdate", "FromClient_PrivateChatMessageUpdate" )