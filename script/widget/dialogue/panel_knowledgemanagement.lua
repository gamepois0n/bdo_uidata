local IM = CppEnums.EProcessorInputMode

Panel_KnowledgeManagement:SetShow(false)

local _textNeed				= UI.getChildControl( Panel_KnowledgeManagement, "StaticText_UseWP" )
local _textHave				= UI.getChildControl( Panel_KnowledgeManagement, "StaticText_HoldWP" )
local _textNeedValue		= UI.getChildControl( Panel_KnowledgeManagement, "StaticText_UseWP_Value" )
local _textHaveValue		= UI.getChildControl( Panel_KnowledgeManagement, "StaticText_HoldWP_Value" )

local _buttonSearch			= UI.getChildControl( Panel_KnowledgeManagement, "Button_Knowledge_SearchBTN" )
local _editSearch			= UI.getChildControl( Panel_KnowledgeManagement, "Edit_Knowledge_SearchBar" )

local _textHelp				= UI.getChildControl( Panel_KnowledgeManagement, "StaticText_Knowledge_Warning" )

local _tabRemoveCard			= UI.getChildControl( Panel_KnowledgeManagement, "Static_Knowledge_DeleteIcon" )
local _tabCreateThemeBook		= UI.getChildControl( Panel_KnowledgeManagement, "Static_Knowledge_BookCaseIcon" )
local _tabCreateBook			= UI.getChildControl( Panel_KnowledgeManagement, "Static_Knowledge_BookIcon" )	_tabCreateBook:SetShow(false)
local _buttonRemoveKnowLedge	= UI.getChildControl( Panel_KnowledgeManagement, "Button_Knowledge_DeleteBTN" )
local _buttonMakeThemeBook		= UI.getChildControl( Panel_KnowledgeManagement, "Button_Knowledge_BookCaseBTN" )

local _buttonWinClose			= UI.getChildControl( Panel_KnowledgeManagement, "Button_Win_Close" )
local _buttonClose				= UI.getChildControl( Panel_KnowledgeManagement, "Button_Knowledge_Close" )

local _treeKnowledgeList		= UI.getChildControl( Panel_KnowledgeManagement, "Tree_KnowledgeManage" )
local _listKnowledgeList		= UI.getChildControl( Panel_KnowledgeManagement, "List_KnowledgeManage" )

local eventInputType = false

_tabRemoveCard:addInputEvent("Mouse_LUp", 			"HandleClicked_TabRemoveCard()")
_tabRemoveCard:addInputEvent("Mouse_On", 			"Knowledge_Tab_Simpletooltips( true, 0 )")
_tabRemoveCard:addInputEvent("Mouse_Out", 			"Knowledge_Tab_Simpletooltips( false )")
_tabCreateThemeBook:addInputEvent("Mouse_LUp", 		"HandleClicked_TabCreateThemeBook()")
_tabCreateThemeBook:addInputEvent("Mouse_On", 		"Knowledge_Tab_Simpletooltips( true, 1)")
_tabCreateThemeBook:addInputEvent("Mouse_Out", 		"Knowledge_Tab_Simpletooltips( false )")
_buttonRemoveKnowLedge:addInputEvent("Mouse_LUp", 	"HandleClicked_RemoveKnowledge()")
_buttonMakeThemeBook:addInputEvent("Mouse_LUp", 	"HandleClicked_MakeThemeBookMSG()")
_listKnowledgeList:addInputEvent("Mouse_LUp", 		"HandleClicked_SelectCard()")
_buttonSearch:addInputEvent("Mouse_LUp", 			"HandleClicked_SearchCard()")
_buttonWinClose:addInputEvent("Mouse_LUp",			"KnowledgeClose()")
_buttonClose:addInputEvent("Mouse_LUp",				"KnowledgeClose()")
_editSearch:addInputEvent("Mouse_LUp",				"HandleClicked_KnowledgeManagement_Edit()")
_tabRemoveCard:setTooltipEventRegistFunc("Knowledge_Tab_Simpletooltips( true, 0 )")
_tabCreateThemeBook:setTooltipEventRegistFunc("Knowledge_Tab_Simpletooltips( true, 1)")
---------------------------------------------------------------------------
function KnowledgeManagement_updateTheme( parentUIItem, theme )
	-- item들 추가될때 Key를 음수는 mentalTheme 양수는 mentalCard로 한다.
	local childItem = _treeKnowledgeList:createRootItem()
	childItem:SetKey( - theme:getKey() )
	local nameString = theme:getName()
	-- 다 모았으면 [완료]
	local collected_complete = nil
	if ( theme:getCardCollectedCount() == theme:getCardCollectMaxCount() ) then
		collected_complete = PAGetString ( Defines.StringSheet_GAME, "LUA_KNOWLEDGE_LIST_COMPLETE" ) -- [획득]
		childItem:SetFontColor( Defines.Color.C_FF6DC6FF )
	else
		collected_complete = ""
		childItem:SetFontColor( Defines.Color.C_FFFFFFFF )
	end

	nameString = nameString .. " " .. collected_complete

	childItem:SetText( nameString )

	if ( nil == parentUIItem ) then
		_treeKnowledgeList:AddRootItem(childItem)
	else
		_treeKnowledgeList:AddItem(childItem, parentUIItem)
	end
	local childThemeCount = theme:getChildThemeCount()
	for idx = 0, childThemeCount -1 do
		local childTheme = theme:getChildThemeByIndex(idx)
		if( childTheme:isRemovable() ) then
			KnowledgeManagement_updateTheme(childItem, childTheme)
		end
	end

	local childCardCount = theme:getChildCardCount()
	for idx = 0, childCardCount -1 do
		local childCard = theme:getChildCardByIndex(idx)
		if childCard:hasCard() then
			local childCardItem = _treeKnowledgeList:createChildItem()
			childCardItem:SetKey( childCard:getKey() )
			childCardItem:SetText(childCard:getName())
			_treeKnowledgeList:AddItem(childCardItem, childItem)
		end
	end
		
end
---------------------------------------------------------------------------
local updateTreeKnowledge = function()
	_treeKnowledgeList:ClearTree()
	local knowledge = getSelfPlayer():get():getMentalKnowledge()

	local mainTopTheme = knowledge:getMainTheme()
	local childThemeCount = mainTopTheme:getChildThemeCount()
	for index = 0, childThemeCount -1 do
		local theme = mainTopTheme:getChildThemeByIndex(index)
		if(theme:isRemovable()) then
			KnowledgeManagement_updateTheme( nil , theme )
		end		
	end
	_treeKnowledgeList:RefreshOpenList()
end
---------------------------------------------------------------------------

function updateTreeCompletedTheme()
	_listKnowledgeList:DeleteAll()
	
	local themeBook = ToClient_ThemeBookBegin()
	while(nill ~= themeBook) do
		_listKnowledgeList:AddItemWithLineFeed(themeBook:getName(), Defines.Color.C_FF626262)
		themeBook = ToClient_ThemeBookNext()
	end
end


function HandleClicked_RemoveKnowledge()
	local CheckKnowledgeDelete = function()
		local selectItem = _treeKnowledgeList:GetSelectItem()
		if ( nil == selectItem ) then
			return
		end

		local mentalObjectKey = selectItem:GetKey()
		if ( nil == mentalObjectKey ) then
			return
		end

		if ( 0 < mentalObjectKey ) then
			ToClient_RequestRemoveCard(mentalObjectKey)
			updateTreeKnowledge()
		end

		KnowledgeClose()
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_KNOWLEDGEMANAGEMENT_ACK_DELETEKNOWLEDGE") )-- "지식이 삭제되었습니다.")
	end

	local selectItem		= _treeKnowledgeList:GetSelectItem()
	local mentalObjectKey	= selectItem:GetKey()
	if ( mentalObjectKey < 0 ) then
		return
	end
	local selectItemName	= selectItem:GetText()

	if true == eventInputType then
		messageBoxMemo	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_KNOWLEDGEMANAGEMENT_MSGBOX_DELETECONFIRM_ITEM", "selectItemName", selectItemName ) -- selectItemName .. "\n지식 <PAColor0xFFF26A6A>삭제<PAOldColor> 시 망각의 비약이 소모됩니다.\n삭제하시겠습니까?"
	else
		messageBoxMemo	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_KNOWLEDGEMANAGEMENT_MSGBOX_DELETECONFIRM_INTERACTION", "selectItemName", selectItemName ) -- selectItemName .. "\n지식 <PAColor0xFFF26A6A>삭제<PAOldColor> 시 기운 10이 소모됩니다.\n삭제하시겠습니까?"
	end
	local	messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_KNOWLEDGEMANAGEMENT_MSGBOX_DELETECONFIRM_TITLE"), content = messageBoxMemo, functionYes = CheckKnowledgeDelete, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData)
end

function HandleClicked_MakeThemeBookMSG()
local	messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "GUILD_MESSAGEBOX_TITLE") -- "알 림"
local	messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_KNOWLEDGEMANAGEMENT_MSGBOX_MAKEBOOK_MEMO") -- "지식 책장을 만드시겠습니까?\n해당 지식은 <PAColor0xFFF26A6A>삭제<PAOldColor>됩니다."
local	messageBoxData = { title = messageBoxTitle, content = messageBoxMemo, functionYes = HandleClicked_MakeThemeBook, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
 	MessageBox.showMessageBox(messageBoxData)
end

function HandleClicked_MakeThemeBook()
	local index = _listKnowledgeList:GetSelectIndex()
	local selfMoney	= Int64toInt32( getSelfPlayer():get():getInventory():getMoney_s64() )
	local themeBook = ToClient_GetThemeBookAt(index)
	ToClient_RequestMakeThemeBook(index)

	if tonumber(Int64toInt32(selfMoney)) < tonumber(Int64toInt32(themeBook:getNeedMoney())) then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_KNOWLEDGEMANAGEMENT_ACK_MAKEBOOK") )-- "보유 은화가 부족합니다.")
	end
end
function HandleClicked_SelectCard()
	local index = _listKnowledgeList:GetSelectIndex()
	local themeBook = ToClient_GetThemeBookAt(index)
	if( themeBook ) then
		_textNeedValue:SetText(makeDotMoney(themeBook:getNeedMoney()))
	end
end
function HandleClicked_SearchCard()
	local index = _listKnowledgeList:GetSelectIndex()

	_treeKnowledgeList:SetFilterString( _editSearch:GetText() )
	_treeKnowledgeList:RefreshOpenList()

	_treeKnowledgeList:SetSelectItem( index+2 )

	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
	ClearFocusEdit()
end

local changeTab = function(tabNo)
	if( 0 == tabNo ) then
		_buttonRemoveKnowLedge:SetShow(true)
		_buttonMakeThemeBook:SetShow(false)		
		_treeKnowledgeList:SetShow(true)
		_treeKnowledgeList:SetFilterString("")
		_listKnowledgeList:SetShow(false)
		_buttonSearch:SetShow(true)
		_editSearch:SetShow(true)
		_textHelp:SetShow(false)
		_textNeed:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_KNOWLEDGEMANAGEMENT_TEXT_NEED") ) -- "필요 기운"
		_textHave:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_KNOWLEDGEMANAGEMENT_TEXT_HAVE") ) -- "보유 기운"
		_textNeedValue:SetText("10")
		_textHaveValue:SetText(tostring(getSelfPlayer():getWp()))
		updateTreeKnowledge()
	elseif( 1 == tabNo ) then
		_buttonRemoveKnowLedge:SetShow(false)
		_buttonMakeThemeBook:SetShow(true)		
		_treeKnowledgeList:SetShow(false)
		_listKnowledgeList:SetShow(true)
		_buttonSearch:SetShow(false)
		_editSearch:SetShow(false)
		_textHelp:SetShow(true)
		_textNeed:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_KNOWLEDGEMANAGEMENT_TEXT_NEEDMONEY") ) -- "필요 은화"
		_textHave:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_KNOWLEDGEMANAGEMENT_TEXT_HAVEMONEY") ) -- "보유 은화"
		_textNeedValue:SetText("0")
		local selfMoney	= getSelfPlayer():get():getInventory():getMoney_s64()
		_textHaveValue:SetText(makeDotMoney(selfMoney))
		updateTreeCompletedTheme()
	end	
end

function HandleClicked_TabRemoveCard()
	changeTab(0)
end
function HandleClicked_TabCreateThemeBook()
	changeTab(1)
end


function FGlobal_KnowledgeManagementShow()				-- 안노리사 로지를 통하여 들어왔을 경우.
	if Panel_KnowledgeManagement:IsShow() then
		Panel_KnowledgeManagement:SetShow(false)
	else
		changeTab(0)
		Panel_KnowledgeManagement:SetShow(true)
		_textNeed:SetShow( true )
		_textNeedValue:SetShow( true )
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
		_tabCreateThemeBook:SetShow(true)
		_buttonRemoveKnowLedge:SetSpanSize( 0, _buttonRemoveKnowLedge:GetSpanSize().y )
		_buttonClose:SetShow( false )
		KnowledgeManagementPosition()

		eventInputType = false
	end
end

function FromClient_RemoveKnowledgeByItem() -- 망각의 비약을 사용하면 이쪽으로 이벤트가 들어온다.
	changeTab(0)
	_tabCreateThemeBook:SetShow(false)
	_textNeed:SetShow( false )
	_textNeedValue:SetShow( false )
	Panel_KnowledgeManagement:SetShow(true)
	_buttonClose:SetShow( true )
	_buttonRemoveKnowLedge:SetSpanSize( -80, _buttonRemoveKnowLedge:GetSpanSize().y )
	_buttonClose:SetSpanSize( 80, _buttonClose:GetSpanSize().y )
	KnowledgeManagementPosition()

	eventInputType = true
end

function FromClient_UpdateKnowledgeManage(isByItem)
	changeTab(0)
end

function HandleClicked_KnowledgeManagement_Edit()
	SetFocusEdit( _editSearch )
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
end

function KnowledgeManagementPosition()
	Panel_KnowledgeManagement:GetPosX( (getScreenSizeX() - Panel_KnowledgeManagement:GetSizeX())/2 )
	Panel_KnowledgeManagement:GetPosY( (getScreenSizeY() - Panel_KnowledgeManagement:GetSizeY())/3 )
end

function KnowledgeClose()
	Panel_KnowledgeManagement:SetShow( false, false )
	ClearFocusEdit()
	_editSearch:SetEditText( "", true )
	if ( AllowChangeInputMode() ) then
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode)
	else
		SetFocusChatting()
	end
end

function FGlobal_KnowledgeClose()
	KnowledgeClose()
end

function Knowledge_Tab_Simpletooltips( isShow, tabType )
	local name, desc, uiControl = nil, nil, nil
	if 0 == tabType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_KNOWLEDGEMANAGEMENT_TOOLTIP_DELETE_TITLE") -- "지식 삭제"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_KNOWLEDGEMANAGEMENT_TOOLTIP_DELETE_DESC") -- "지식을 삭제할 수 있습니다. 삭제된 지식은 복구되지 않으니 신중하게 결정하여 삭제해야 합니다."
		uiControl = _tabRemoveCard
	elseif 1 == tabType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_KNOWLEDGEMANAGEMENT_TOOLTIP_MAKEBOOK_TITLE") -- "지식 책장 제작"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_KNOWLEDGEMANAGEMENT_TOOLTIP_MAKEBOOK_DESC") -- "지식 책장을 제작합니다. 지식 책장으로 제작한 지식은 삭제됩니다."
		uiControl = _tabCreateThemeBook
	end

	if isShow == true then
		registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end
end

registerEvent("FromClient_RemoveKnowledgeByItem", "FromClient_RemoveKnowledgeByItem")
registerEvent("FromClient_UpdateKnowledgeManage", "FromClient_UpdateKnowledgeManage")