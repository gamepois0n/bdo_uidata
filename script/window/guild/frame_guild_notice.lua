local UI_TM 		= CppEnums.TextMode
local UI_color 		= Defines.Color
local UCT 			= CppEnums.PA_UI_CONTROL_TYPE
local IM			= CppEnums.EProcessorInputMode

----------------------------------------------------------------------------------------------------------------
--										공지사항 프레임 불러오기
----------------------------------------------------------------------------------------------------------------
local defaultFrameBG_Notice	= UI.getChildControl ( Panel_Window_Guild, "Static_Frame_NoticeBG" )
local _frame_Notice			= UI.getChildControl ( Panel_Guild_Notice, "Static_NoticeFrame_BG" )

local ui_Notice =
{
	_main_Notice		= UI.getChildControl ( Panel_Guild_Notice, "StaticText_M_Notice" ),
	_main_Comment		= UI.getChildControl ( Panel_Guild_Notice, "StaticText_M_Comment" ),
	
	_edit_Notice		= UI.getChildControl ( Panel_Guild_Notice, "Edit_Notice" ),
	_edit_Comment		= UI.getChildControl ( Panel_Guild_Notice, "Edit_Comment" ),
	_txt_noticeHelp		= UI.getChildControl ( Panel_Guild_Notice, "StaticText_Notice_Help" ),
	
	_btn_NoticeConfirm	= UI.getChildControl ( Panel_Guild_Notice, "Button_Notice_Confirm" ),
	_btn_CommentConfirm	= UI.getChildControl ( Panel_Guild_Notice, "Button_Comment_Confirm" ),
	
	_comment_ID			= UI.getChildControl ( Panel_Guild_Notice, "StaticText_C_ID" ),
	_comment_Comment	= UI.getChildControl ( Panel_Guild_Notice, "StaticText_C_Comment" ),
	_comment_Scroll		= UI.getChildControl ( Panel_Guild_Notice, "VerticalScroll" ),
}

defaultFrameBG_Notice:MoveChilds(defaultFrameBG_Notice:GetID(), Panel_Guild_Notice)
deletePanel(Panel_Guild_Notice:GetID())

ui_Notice._btn_NoticeConfirm:SetShow( false )		-- 공지사항 확인버튼 (길마/분대장에게만 show 되어야 한다)
-- ui_Notice._edit_Notice:SetTextMode( UI_TM.eTextMode_AutoWrap )
----------------------------------------------------------------------------------------------------------------
saved_Guild_Frame_Notice = _frame_Notice


-------------------------------------------------------
--				공지사항 입력모드
function guildNotice_NoticeInputMode()
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)	-- 입력 모드
end
-------------------------------------------------------
--				한줄 코멘트 입력모드
function guildNotice_CommentInputMode()
		UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)	-- 입력 모드
end


-------------------------------------------------------
-- 			모두 입력하거나 취소했다
function guildNotice_Output()
	ClearFocusEdit()
	if ( AllowChangeInputMode() ) then
		if( UI.checkShowWIndow() ) then
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode) 
		else
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
		end
	else
		SetFocusChatting()
	end
end


----------------------------------------------------------------------
-- 					한줄 코멘트 업데이트 함수
----------------------------------------------------------------------
function guildNotice_GetComment_Update()
	-- 한줄 쓸 때마다 컨트롤 복사해줘야함
end


----------------------------------------------------------------------
-- 					길드 현황을 켜고 끄는 함수
----------------------------------------------------------------------
function guild_GuildNotice_Show( isShow )
	if ( isShow == true ) then
		defaultFrameBG_Notice:SetShow( true )
	else
		defaultFrameBG_Notice:SetShow( false )
	end
	
end

----------------------------------------------------------------------------------------------------------------
ui_Notice._edit_Notice:addInputEvent ( "Mouse_LUp", "guildNotice_NoticeInputMode()" )		-- 공지사항 입력모드
ui_Notice._edit_Comment:addInputEvent ( "Mouse_LUp", "guildNotice_CommentInputMode()" )		-- 한줄 코멘트 입력모드
