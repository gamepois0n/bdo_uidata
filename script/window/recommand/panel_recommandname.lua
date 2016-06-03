local IM = CppEnums.EProcessorInputMode

Panel_RecommandName:SetShow( false, false )
Panel_RecommandName:SetDragAll( true )
Panel_RecommandName:setGlassBackground( true )
Panel_RecommandName:ActiveMouseEventEffect( true )
Panel_RecommandName:setMaskingChild( true )

local HelpMailType = {
	eHelpMailType_Repay  		= 0,
	eHelpMailType_Thanks 		= 1,
	eHelpMailType_Valentine  	= 2,	
}

local _helpMailType 			= HelpMailType.eHelpMailType_Thanks

local uiButtonCloseX			= UI.getChildControl( Panel_RecommandName, "Button_Win_Close" )
local uiButtonApply				= UI.getChildControl( Panel_RecommandName, "Button_Apply" )
local uiButtonClose				= UI.getChildControl( Panel_RecommandName, "Button_Cancel" )
local uiEditName				= UI.getChildControl( Panel_RecommandName, "Edit_Nickname" )

local uiStaticTitle				= UI.getChildControl( Panel_RecommandName, "StaticText_Title" )

local uiStaticContentHelper		= UI.getChildControl( Panel_RecommandName, "StaticText_ToRecommander" )
local uiStaticWarnning			= UI.getChildControl( Panel_RecommandName, "StaticText_Warnning" )

uiStaticWarnning:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)

uiButtonCloseX:addInputEvent("Mouse_LUp", "FGlobal_SendMailForHelpClose()")
uiButtonApply:addInputEvent("Mouse_LUp", "HandleClicked_SendMailForHelp()")
uiButtonClose:addInputEvent("Mouse_LUp", "FGlobal_SendMailForHelpClose()")

function SendMailForHelpInit()
	uiEditName:SetMaxInput(getGameServiceTypeCharacterNameLength())
end

function HandleClicked_SendMailForHelp()
	local content	= uiStaticContentHelper:GetText()
	local title		= PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_RECOMMANDGIFT")
	if(_helpMailType == HelpMailType.eHelpMailType_Thanks) then
		-- content = uiStaticContentHelper:GetText()
		title	= PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_RECOMMANDGIFT")
		content = PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_SENDMAIL2") -- "선물을 보내주신 감사의 표시로 작은 선물을 준비하였으니 유용하게 사용해주세요."
	elseif(_helpMailType == HelpMailType.eHelpMailType_Repay) then
		title	= PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_RECOMMANDGIFT")
		content = PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_SENDMAIL1") -- "저를 도와주신 것에 대한 감사의 표시로 조금이나마 작은 선물을 준비하였습니다."
	else
		title	= PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_VALENTINE") -- "달콤한 선물이 도착했습니다."
		content = PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_SENDMAIL_BALENTINE") -- "발렌타인 데이를 맞아서 작은 선물을 준비하였습니다."
	end

	ToClient_SendMailForHelp(uiEditName:GetEditText(), title, content);
	
	Panel_RecommandName:SetShow(false, false)
	
	--제대로 넣어주세요
	if( AllowChangeInputMode() ) then
		if( check_ShowWindow() ) then
			UI.Set_ProcessorInputMode( IM.eProcessorInputMode_UiMode )
		else
			UI.Set_ProcessorInputMode( IM.eProcessorInputMode_GameMode)
		end
	else
		SetFocusChatting()
	end

	uiEditName:SetEditText("", true)
	ClearFocusEdit()
end

function FromClient_SendMailForHelp(helpMailType)
	Panel_RecommandName:SetShow(true, false)
	_helpMailType = helpMailType
	
	uiStaticContentHelper:SetShow(true)
	uiButtonApply:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_RECOMMAND_BTN") )
	if (_helpMailType == HelpMailType.eHelpMailType_Thanks) then
		uiStaticContentHelper:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_TONEWBIE") ) -- 자신을 도와주거나 추천해준 분에게\n보답으로 선물을 담아 편지를 보냅니다.
		uiStaticTitle:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_THANKSGIFTMAIL") ) -- "감사의 선물 편지" )
		uiStaticWarnning:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_EDITCHARACTERNAME") ) -- "※ 편지를 보낼 캐릭터 이름을 입력하세요." )
	elseif (_helpMailType == HelpMailType.eHelpMailType_Repay) then
		uiStaticContentHelper:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_TORECOMMANDER") ) -- 보답의 선물을 보내준 분에게 선물을 담아\n감사의 편지를 보내는건 어떨까요?
		uiStaticTitle:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_PAYMAIL") ) -- "보답의 선물 편지" )
		uiStaticWarnning:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_EDITCHARACTERNAME") ) -- "※ 편지를 보낼 캐릭터 이름을 입력하세요." )
	else
		uiStaticContentHelper:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_BALENTINEMAIL") )
		uiStaticTitle:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_BALENTINEMAIL") ) -- "발렌타인 데이의 선물 편지" )
		uiStaticWarnning:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_EDITCHARACTERNAME") ) -- "※ 편지를 보낼 캐릭터 이름을 입력하세요." )
		uiButtonApply:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_SEND_BTN") )
	end
	
	-- 제대로 넣어주세요
	SetFocusEdit( uiEditName )
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
end	

function FromClient_SendMailForHelpComplete(isSender, helpMailType)
	if (helpMailType == HelpMailType.eHelpMailType_Thanks) then
		if(isSender) then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_COMPLETE") ) -- "추천이 완료되었습니다.")
		else
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_GETRECOMMAND") ) -- "추천을 받았습니다.")
		end
	elseif (helpMailType == HelpMailType.eHelpMailType_Repay) then
		
	else
		if(isSender) then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_SENDCOMPLETE_BALENTINE") ) -- "발렌타인 데이 선물을 보냈습니다.")
		else
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_RECOMMANDNAME_GETBALENTINE") ) -- "발렌타인 데이 선물을 받았습니다.")
		end
		
	end
	-- isSender true이면 추천완료, false면 추천받았습니다. 출력
end

function FGlobal_SendMailForHelpClose()
	Panel_RecommandName:SetShow(false, false)
	if( AllowChangeInputMode() ) then
		if( check_ShowWindow() ) then
			UI.Set_ProcessorInputMode( IM.eProcessorInputMode_UiMode )
		else
			UI.Set_ProcessorInputMode( IM.eProcessorInputMode_GameMode)
		end
	else
		SetFocusChatting()
	end
	uiEditName:SetEditText("", true)
	ClearFocusEdit()
end

registerEvent("FromClient_SendMailForHelp",			"FromClient_SendMailForHelp")
registerEvent("FromClient_SendMailForHelpComplete",	"FromClient_SendMailForHelpComplete")

SendMailForHelpInit()