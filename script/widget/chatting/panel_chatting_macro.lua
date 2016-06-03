local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local StyleUI = {
	_c_macroBG				= UI.getChildControl ( Panel_Chatting_Macro, "Static_C_MacroBG" ),
	_c_macroKey				= UI.getChildControl ( Panel_Chatting_Macro, "StaticText_C_MacroKey" ),
	
	_c_btn_Normal			= UI.getChildControl ( Panel_Chatting_Macro, "Button_C_Normal" ),
	_c_btn_Party			= UI.getChildControl ( Panel_Chatting_Macro, "Button_C_Party" ),
	_c_btn_Guild			= UI.getChildControl ( Panel_Chatting_Macro, "Button_C_Guild" ),
	_c_btn_World			= UI.getChildControl ( Panel_Chatting_Macro, "Button_C_World" ),
	_c_btn_WorldWithItem	= UI.getChildControl ( Panel_Chatting_Macro, "Button_C_WorldWithItem"),
	
	_c_edit_InputMacro		= UI.getChildControl ( Panel_Chatting_Macro, "Edit_C_InputMacro" ),
}


Panel_Chatting_Macro:RegisterShowEventFunc( true, 'Panel_Chatting_Macro_ShowAni()' )
Panel_Chatting_Macro:RegisterShowEventFunc( false, 'Panel_Chatting_Macro_HideAni()' )

local macroCount = 10
local macroChatTypeCount = 5
local maxEditInput = 100

if isGameTypeKorea() then
	macroChatTypeCount = 5
else
	macroChatTypeCount = 4
end

local startPosY = 7
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local ChatMacro = 
{
	_chatType			= {},
	_buttonChatType		= {},
	_editChatMessage 	= {},
}

--local ChatMacroLinkedItemData = {}
local currentInputEditIndex = -1
----------------------------------------------------------------
--				껐다 켜기 애니메이션 함수
function Panel_Chatting_Macro_ShowAni()
	Panel_Chatting_Macro:SetAlpha( 0 )
	UIAni.AlphaAnimation( 1, Panel_Chatting_Macro, 0.0, 0.2 )
end

function Panel_Chatting_Macro_HideAni()
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_Chatting_Macro, 0.0, 0.2 )
	aniInfo:SetHideAtEnd(true)
end

function ChatMacro:initialize()
	local ui = {}
	
	for idx = 0, macroCount - 1, 1 do
		-- BG 맹글기
		ui._macroBG = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATIC, Panel_Chatting_Macro, 'Static_MacroBG_' .. idx )
		CopyBaseProperty( StyleUI._c_macroBG,	ui._macroBG )
		ui._macroBG:SetShow( true )
		ui._macroBG:SetPosY( startPosY + idx * ( ui._macroBG:GetSizeY() + 2 ) )
		
		-- CTRL 텍스트
		ui._macroKey = UI.createControl( UI_PUCT.PA_UI_CONTROL_STATICTEXT, ui._macroBG, 'StaticText_MacroKey_' .. idx )
		CopyBaseProperty( StyleUI._c_macroKey,	ui._macroKey )
		ui._macroKey:SetShow( true )
		ui._macroKey:SetPosX( 5 )
		if ( 9 > idx ) then
			ui._macroKey:SetText( "Alt+Shift+" .. idx+1 )
		elseif ( idx == 9 ) then
			ui._macroKey:SetText( "Alt+Shift+0" )
		end
		
		-- 일반 버튼
		ChatMacro._buttonChatType[idx] = UI.createControl( UI_PUCT.PA_UI_CONTROL_BUTTON, ui._macroBG, 'Button_Normal_' .. idx )
		CopyBaseProperty( StyleUI._c_btn_Normal,	ChatMacro._buttonChatType[idx] )
		ChatMacro._buttonChatType[idx]:SetShow( true )		
		ChatMacro._buttonChatType[idx]:addInputEvent("Mouse_LUp", "HandleClicked_ChatMacroType("..idx..")")
		-- ChatMacro._buttonChatType[idx]:SetPosX( 60 )

		-- 입력창
		ChatMacro._editChatMessage[idx] = UI.createControl( UI_PUCT.PA_UI_CONTROL_EDIT, ui._macroBG, 'Edit_InputMacro_' .. idx )
		CopyBaseProperty( StyleUI._c_edit_InputMacro,	ChatMacro._editChatMessage[idx] )
		ChatMacro._editChatMessage[idx]:SetShow( true )
		ChatMacro._editChatMessage[idx]:SetPosX( 125 )
		ChatMacro._chatType[idx] = 0
		ChatMacro._editChatMessage[idx]:SetMaxInput( maxEditInput )
		ChatMacro._editChatMessage[idx]:addInputEvent( "Mouse_LDown", "HandleClicked_ChatMacroInputEdit(" .. idx .. ")" )
		
		--local linkedItemData = 
		--{
		--	_linkedItemCount = 0,
		--	_startIndex = -1,
		--	_endIndex = -1,
		--}
		--ChatMacroLinkedItemData[idx] = linkedItemData
	end
	
	Panel_Chatting_Macro:RemoveControl ( StyleUI._c_macroBG )
	Panel_Chatting_Macro:RemoveControl ( StyleUI._c_macroKey )
	Panel_Chatting_Macro:RemoveControl ( StyleUI._c_edit_InputMacro )
	StyleUI._c_btn_Normal:SetShow(false)
	StyleUI._c_btn_Party:SetShow(false)
	StyleUI._c_btn_Guild:SetShow(false)
	StyleUI._c_btn_World:SetShow(false)
	StyleUI._c_btn_WorldWithItem:SetShow(false)
end

function HandleClicked_ChatMacroType(index)
	ChatMacro._chatType[index] = ChatMacro._chatType[index]+1
	
	if( macroChatTypeCount <= ChatMacro._chatType[index] ) then
		ChatMacro._chatType[index] = 0
	end	
	
	local copyUI = StyleUI._c_btn_Normal
	if(1 == ChatMacro._chatType[index]) then
		copyUI = StyleUI._c_btn_Party
	elseif(2 == ChatMacro._chatType[index]) then
		copyUI = StyleUI._c_btn_Guild
	elseif(3 == ChatMacro._chatType[index]) then
		copyUI = StyleUI._c_btn_World
	elseif(4 == ChatMacro._chatType[index]) then
		copyUI = StyleUI._c_btn_WorldWithItem
	end

	CopyBaseProperty( copyUI, ChatMacro._buttonChatType[index] )
	ChatMacro._buttonChatType[index]:SetShow(true)
end

function HandleClicked_ChatMacroInputEdit(index)
	currentInputEditIndex = index
	UI.Set_ProcessorInputMode(CppEnums.EProcessorInputMode.eProcessorInputMode_ChattingInputMode)
end

function ChatMacro:update()
	for index = 0, macroCount - 1, 1 do		
		local text = ToClient_getMacroChatMessage(index);
		self._editChatMessage[index]:SetEditText(text);
		
		self._chatType[index] = ToClient_getMacroChatType(index)
		
		local copyUI = StyleUI._c_btn_Normal
		if(1 == self._chatType[index]) then
			copyUI = StyleUI._c_btn_Party
		elseif(2 == self._chatType[index]) then
			copyUI = StyleUI._c_btn_Guild
		elseif(3 == self._chatType[index]) then
			copyUI = StyleUI._c_btn_World
		elseif (4 == self._chatType[index]) then
			copyUI = StyleUI._c_btn_WorldWithItem
		end

		CopyBaseProperty( copyUI,	self._buttonChatType[index] )
		self._buttonChatType[index]:SetShow(true)
	end
end

function ChatMacro:saveMacro()
	for index = 0, macroCount - 1, 1 do
		ToClient_SetChatMacro(index, self._chatType[index], self._editChatMessage[index]:GetEditText())
	end
	
	ToClient_SaveChatMacro()
end

ChatMacro:initialize();

function FGlobal_Chatting_Macro_ShowToggle()
	if ( Panel_Chatting_Macro:IsShow() ) then
		ChatMacro:saveMacro()
		Panel_Chatting_Macro:SetShow( false, true )
		FGlobal_Chatting_Macro_SetCHK( false )
		ChatInput_Show()
	elseif Panel_Chat_SocialMenu:GetShow() then
		Panel_Chat_SocialMenu:SetShow( false )
		Panel_Chatting_Macro:SetShow( true, true )
		ChatMacro:update()
	else
		Panel_Chatting_Macro:SetShow( true, true )
		ChatMacro:update()
	end
	Panel_Chatting_Macro:SetPosY( Panel_Chatting_Input:GetPosY() - Panel_Chatting_Macro:GetSizeY() - 5 )
	Panel_Chatting_Macro:SetPosX( Panel_Chatting_Input:GetSizeX() + Panel_Chatting_Input:GetPosX() )
end


function ChatMacro_CheckCurrentUiEdit(targetUI)
	if -1 == currentInputEditIndex then
		return false
	end
	
	return ( nil ~= targetUI ) and ( targetUI:GetKey() == ChatMacro._editChatMessage[currentInputEditIndex]:GetKey() )
end