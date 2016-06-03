-----------------------------------------------------------
-- Local 변수 설정
-----------------------------------------------------------
local UI_PUCT		= CppEnums.PA_UI_CONTROL_TYPE
local UI_color		= Defines.Color
local UI_TM			= CppEnums.TextMode
local UI_PSFT		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_CT			= CppEnums.ChatType
local UI_CNT		= CppEnums.EChatNoticeType
local UI_Group		= Defines.UIGroup

Panel_ChatOption:SetShow( false )
Panel_ChatOption:SetIgnore( true )
Panel_ChatOption:ActiveMouseEventEffect(true)
Panel_ChatOption:setGlassBackground(true)

Panel_ChatOption:RegisterShowEventFunc( true, 	'ChatOption_ShowAni()' )
Panel_ChatOption:RegisterShowEventFunc( false,	'ChatOption_HideAni()' )

local localWarIsOpen			= ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 43 )
local chanel_Notice 			= false
local chanel_System 			= false
local chanel_World 				= false
local chanel_Public 			= false
local chanel_Private 			= false
local chanel_Party 				= false
local chanel_Guild 				= false
local chanel_WorldWithItem		= false
local channel_Battle			= false
local channel_LocalWar			= false
local channel_RolePlay			= false
local _alphaPosX				= 0

local chatOptionData = {
		makeChatPanelCount		= 5,

		chatFilterCount			= 11,				--
		_slotsCols				= 2,
		slotStartX				= 0,
		slotGapX				= 150,
		slotStartY				= 0,
		slotGapY				= 30,
	}

local _ChatOption_Title			= UI.getChildControl( Panel_ChatOption, 	"StaticText_ChatOptionTitle" )
-- local _chatPanelName			= UI.getChildControl( Panel_ChatOption, 	"InputText_TabName" ) -- 패널이 없다!

local _msgFilter_BG				= UI.getChildControl( Panel_ChatOption, 	"Static_FilterBG" )

local msgFilter_Chkbox			= UI.getChildControl( Panel_ChatOption,		"Template_CheckButton_Filter")

local _msgFilter_Notice			= UI.getChildControl( Panel_ChatOption, 	"RadioButton_filter_Notice" )
local _msgFilter_System			= UI.getChildControl( Panel_ChatOption, 	"RadioButton_filter_System" )
local _msgFilter_World			= UI.getChildControl( Panel_ChatOption, 	"RadioButton_filter_World" )
local _msgFilter_Public			= UI.getChildControl( Panel_ChatOption, 	"RadioButton_filter_Normal" )
local _msgFilter_Private		= UI.getChildControl( Panel_ChatOption, 	"RadioButton_filter_Whisper" )
local _msgFilter_Party			= UI.getChildControl( Panel_ChatOption, 	"RadioButton_filter_Party" )
local _msgFilter_Guild			= UI.getChildControl( Panel_ChatOption, 	"RadioButton_filter_Guild" ) 
local _msgFilter_WorldWithItem	= UI.getChildControl( Panel_ChatOption,		"RadioButton_filter_WorldWithItem" )
local _msgFilter_Battle			= UI.getChildControl( Panel_ChatOption,		"RadioButton_filter_Battle" )
local _msgFilter_LocalWar		= UI.getChildControl( Panel_ChatOption,		"RadioButton_filter_LocalWar" )
local _msgFilter_RolePlay		= UI.getChildControl( Panel_ChatOption,		"RadioButton_filter_RolePlay" )

local _alpha_0					= UI.getChildControl( Panel_ChatOption, 	"StaticText_PanelTransparency_0" ) 
local _alpha_50					= UI.getChildControl( Panel_ChatOption, 	"StaticText_PanelTransparency_50" )
local _alpha_100				= UI.getChildControl( Panel_ChatOption, 	"StaticText_PanelTransparency_100" )
local _alphaSlider_Control		= UI.getChildControl( Panel_ChatOption, 	"Slider_PanelTransparencyControl" ) 
local _alphaSlider_ControlBTN	= UI.getChildControl( _alphaSlider_Control, "Slider_PanelTransparency_Button" ) 

local _button_Confirm			= UI.getChildControl( Panel_ChatOption, 	"Button_Confirm" )
local _button_Cancle			= UI.getChildControl( Panel_ChatOption, 	"Button_Cancle" )
local _button_Close				= UI.getChildControl( Panel_ChatOption, 	"Button_WinClose" )
local _button_blockList			= UI.getChildControl( Panel_ChatOption,		"Button_BlockList" )
local msgFilterBg_SizeY			= _msgFilter_BG:GetSizeY()
local panelSizeY				= Panel_ChatOption:GetSizeY()
local buttonSizeY 				= _button_Confirm:GetPosY()

local _buttonQuestion	= UI.getChildControl( Panel_ChatOption, "Button_Question" )								--물음표 버튼
_buttonQuestion			: addInputEvent( "Mouse_LUp", "Panel_WebHelper_ShowToggle( \"Chatting\" )" )			--물음표 좌클릭
_buttonQuestion			: addInputEvent( "Mouse_On", "HelpMessageQuestion_Show( \"Chatting\", \"true\")" )		--물음표 마우스오버
_buttonQuestion			: addInputEvent( "Mouse_Out", "HelpMessageQuestion_Show( \"Chatting\", \"false\")" )	--물음표 마우스아웃

local btnFilter = Array.new()
local chatPanel	= Array.new()
for i=0, chatOptionData.makeChatPanelCount-1 do
	chatPanel[i] = false
end


function HandleClicked_ChattingTypeFilter_Notice( panelIdex )
	local self = chatOptionData
	local check = btnFilter[0].chatFilter:IsCheck()
	chanel_Notice = check
end
function HandleClicked_ChattingTypeFilter_System( panelIdex )
	local self = chatOptionData
	local check = btnFilter[1].chatFilter:IsCheck()
	chanel_System = check
end
function HandleClicked_ChattingTypeFilter_World( panelIdex )
	local self = chatOptionData
	local check = btnFilter[3].chatFilter:IsCheck()
	chanel_World = check
end
function HandleClicked_ChattingTypeFilter_Public( panelIdex )
	local self = chatOptionData
	local check = btnFilter[5].chatFilter:IsCheck()
	chanel_Public = check
end
function HandleClicked_ChattingTypeFilter_Private( panelIdex )
	local self = chatOptionData
	local check = btnFilter[7].chatFilter:IsCheck()
	chanel_Private = check
end
function HandleClicked_ChattingTypeFilter_Party( panelIdex )
	local self = chatOptionData
	local check = btnFilter[4].chatFilter:IsCheck()
	chanel_Party = check
end
function HandleClicked_ChattingTypeFilter_Guild( panelIdex )
	local self = chatOptionData
	local check = btnFilter[6].chatFilter:IsCheck()
	chanel_Guild = check
end
function HandleClicked_ChattingTypeFilter_WorldWithItem( panelIdex )
	local self = chatOptionData
	local check = btnFilter[2].chatFilter:IsCheck()
	chanel_WorldWithItem = check
end
function HandleClicked_ChattingTypeFilter_Battle( panelIndex )
	local self = chatOptionData
	local check = btnFilter[8].chatFilter:IsCheck()
	channel_Battle = check
end
function HandleClicked_ChattingTypeFilter_LocalWar( panelIndex )
	local self = chatOptionData
	local check = btnFilter[9].chatFilter:IsCheck()
	channel_LocalWar = check
end
function HandleClicked_ChattingTypeFilter_RolePlay( panelIndex )
	local self = chatOptionData
	local check = btnFilter[10].chatFilter:IsCheck()
	channel_RolePlay = check
end

local optionCount = 0
function ChattingOption_Initialize( panelIdex, _transparency, isCombinedMainPanel )
	local self = chatOptionData
	_ChatOption_Title:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_CHATTING_OPTION_TITLE", "panel_Index", panelIdex+1  ) )
	_msgFilter_BG:SetAlpha( 0.5 )
	local chat = ToClient_getChattingPanel( panelIdex )

	_msgFilter_Notice			:SetShow( false )
	_msgFilter_System			:SetShow( false )
	_msgFilter_World			:SetShow( false )
	_msgFilter_Public			:SetShow( false )
	_msgFilter_Private			:SetShow( false )
	_msgFilter_Party			:SetShow( false )
	_msgFilter_Guild			:SetShow( false )
	_msgFilter_WorldWithItem	:SetShow( false )
	_msgFilter_Battle			:SetShow( false )
	_msgFilter_LocalWar			:SetShow( false )
	_msgFilter_RolePlay			:SetShow( false )

	local roleplayTypeOpen = isGameTypeEnglish() or isGameServiceTypeDev()		-- 롤플레이 타입은 북미와 개발만 보인다!
	if not chatPanel[panelIdex] then
		optionCount = 0
		for idx=0, self.chatFilterCount-1 do
			local btn = {}
			btn.chatFilter	= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_CHECKBUTTON, _msgFilter_BG, "ChatOption_Btn_" .. idx )
			CopyBaseProperty( msgFilter_Chkbox, btn.chatFilter	)

			btn.chatFilter:SetShow( false )

			local isOpen = isGameTypeJapan() -- 일본만 서버군이다...
			if 1 < idx and isOpen then
				index = idx - 1
			else
				index = idx
			end
			
			if 10 == idx and not roleplayTypeOpen then
				break
			end

			local row = math.floor( index / self._slotsCols )
			local col = index % self._slotsCols
			optionCount = index + 1

			btn.chatFilter:SetPosX( self.slotStartX + self.slotGapX * col )
			btn.chatFilter:SetPosY( self.slotStartY + self.slotGapY * row )

			btnFilter[idx] = btn

			if 0 == idx then
				btnFilter[0].chatFilter:SetCheck( chat:isShowChatType( UI_CT.Notice ) )
				btnFilter[0].chatFilter:SetText( PAGetString(Defines.StringSheet_GAME, "CHATTING_NOTICE") ) -- 공지사항
				btnFilter[0].chatFilter:SetShow( true )
				btnFilter[0].chatFilter:addInputEvent( "Mouse_LUp", "HandleClicked_ChattingTypeFilter_Notice( " .. panelIdex .. " )" )
			elseif 1 == idx then
				btnFilter[1].chatFilter:SetCheck( chat:isShowChatType( UI_CT.System ) )
				btnFilter[1].chatFilter:SetText( PAGetString(Defines.StringSheet_GAME, "CHATTING_TAB_SYSTEM") ) -- 시스템
				btnFilter[1].chatFilter:SetShow( true )
				btnFilter[1].chatFilter:addInputEvent( "Mouse_LUp", "HandleClicked_ChattingTypeFilter_System( " .. panelIdex .. " )" )
			elseif 2 == idx then
				btnFilter[2].chatFilter:SetCheck( chat:isShowChatType( UI_CT.WorldWithItem) )
				btnFilter[2].chatFilter:SetText( PAGetString(Defines.StringSheet_GAME, "CHATTING_TAB_WORLD") )
				btnFilter[2].chatFilter:SetShow( not isOpen )
				btnFilter[2].chatFilter:addInputEvent( "Mouse_LUp", "HandleClicked_ChattingTypeFilter_WorldWithItem( " .. panelIdex .. " )" )
			elseif 3 == idx then
				btnFilter[3].chatFilter:SetCheck( chat:isShowChatType( UI_CT.World ) )
				if not isOpen then
					btnFilter[3].chatFilter:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHATTING_OPTION_FILTER_CHANNELGROUP") ) -- 채널그룹
				else
					btnFilter[3].chatFilter:SetText( PAGetString(Defines.StringSheet_GAME, "CHATTING_TAB_WORLD") ) -- 월드
				end
				btnFilter[3].chatFilter:SetShow( true )
				btnFilter[3].chatFilter:addInputEvent( "Mouse_LUp", "HandleClicked_ChattingTypeFilter_World( " .. panelIdex .. " )" )
			elseif 4 == idx then
				btnFilter[4].chatFilter:SetCheck( chat:isShowChatType( UI_CT.Party ) )
				btnFilter[4].chatFilter:SetText( PAGetString(Defines.StringSheet_GAME, "CHATTING_TAB_PARTY") ) -- 파티
				btnFilter[4].chatFilter:SetShow( true )
				btnFilter[4].chatFilter:addInputEvent( "Mouse_LUp", "HandleClicked_ChattingTypeFilter_Party( " .. panelIdex .. " )" )
			elseif 5 == idx then
				btnFilter[5].chatFilter:SetCheck( chat:isShowChatType( UI_CT.Public ) )
				btnFilter[5].chatFilter:SetText( PAGetString(Defines.StringSheet_GAME, "CHATTING_TAB_GENERAL") ) -- 일반
				btnFilter[5].chatFilter:SetShow( true )
				btnFilter[5].chatFilter:addInputEvent( "Mouse_LUp", "HandleClicked_ChattingTypeFilter_Public( " .. panelIdex .. " )" )
			elseif 6 == idx then
				btnFilter[6].chatFilter:SetCheck( chat:isShowChatType( UI_CT.Guild ) )
				btnFilter[6].chatFilter:SetText( PAGetString(Defines.StringSheet_GAME, "CHATTING_TAB_GUILD") ) -- 길드
				btnFilter[6].chatFilter:SetShow( true )
				btnFilter[6].chatFilter:addInputEvent( "Mouse_LUp", "HandleClicked_ChattingTypeFilter_Guild( " .. panelIdex .. " )" )
			elseif 7 == idx then
				btnFilter[7].chatFilter:SetCheck( chat:isShowChatType( UI_CT.Private) )
				btnFilter[7].chatFilter:SetText( PAGetString(Defines.StringSheet_GAME, "CHATTING_TAB_WHISPER") ) -- 귓속말
				btnFilter[7].chatFilter:SetShow( true )
				btnFilter[7].chatFilter:addInputEvent( "Mouse_LUp", "HandleClicked_ChattingTypeFilter_Private( " .. panelIdex .. " )" )
			elseif 8 == idx then
				btnFilter[8].chatFilter:SetCheck( chat:isShowChatType( UI_CT.Battle) )
				btnFilter[8].chatFilter:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHATTING_OPTION_FILTER_BATTLE") ) -- 전투
				btnFilter[8].chatFilter:SetShow( true )
				btnFilter[8].chatFilter:addInputEvent( "Mouse_LUp", "HandleClicked_ChattingTypeFilter_Battle( " .. panelIdex .. " )" )
			elseif 9 == idx then
				btnFilter[9].chatFilter:SetCheck( chat:isShowChatType( UI_CT.LocalWar) )
				btnFilter[9].chatFilter:SetText( PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHATTING_OPTION_FILTER_LOCALWAR") ) -- 전장 채팅
				btnFilter[9].chatFilter:SetShow( true )
				btnFilter[9].chatFilter:addInputEvent( "Mouse_LUp", "HandleClicked_ChattingTypeFilter_LocalWar( " .. panelIdex .. " )" )
			elseif 10 == idx then
				btnFilter[10].chatFilter:SetCheck( chat:isShowChatType( UI_CT.LocalWar) )
				btnFilter[10].chatFilter:SetText( "RolePlay" ) -- 전장 채팅
				btnFilter[10].chatFilter:SetShow( true )
				btnFilter[10].chatFilter:addInputEvent( "Mouse_LUp", "HandleClicked_ChattingTypeFilter_RolePlay( " .. panelIdex .. " )" )
			end
		end
		chatPanel[panelIdex] = true
	end
	local optionLineCount = math.ceil(optionCount/2)
	local lineGapY = 30
	if optionLineCount <= 5 then
		optionLineCount = 5
	end
	Panel_ChatOption:SetSize( Panel_ChatOption:GetSizeX(), panelSizeY + (optionLineCount-5)*lineGapY )
	_msgFilter_BG:SetSize( _msgFilter_BG:GetSizeX(), msgFilterBg_SizeY + (optionLineCount-5)*lineGapY )
	_button_Confirm:SetPosY( buttonSizeY + (optionLineCount-5)*lineGapY )
	_button_Cancle:SetPosY( buttonSizeY + (optionLineCount-5)*lineGapY )
	_button_blockList:SetPosY( buttonSizeY + (optionLineCount-5)*lineGapY )
	_PA_LOG("이문종", "buttonSizeY : " .. buttonSizeY)

	btnFilter[0].chatFilter			:SetCheck( chat:isShowChatType( UI_CT.Notice ) )
	btnFilter[1].chatFilter			:SetCheck( chat:isShowChatType( UI_CT.System ) )
	btnFilter[3].chatFilter			:SetCheck( chat:isShowChatType( UI_CT.World ) )
	btnFilter[5].chatFilter			:SetCheck( chat:isShowChatType( UI_CT.Public ) )
	btnFilter[7].chatFilter			:SetCheck( chat:isShowChatType( UI_CT.Private ) )
	btnFilter[4].chatFilter			:SetCheck( chat:isShowChatType( UI_CT.Party ) )
	btnFilter[6].chatFilter			:SetCheck( chat:isShowChatType( UI_CT.Guild ) )
	btnFilter[2].chatFilter			:SetCheck( chat:isShowChatType( UI_CT.WorldWithItem) )
	btnFilter[8].chatFilter			:SetCheck( chat:isShowChatType( UI_CT.Battle) )
	btnFilter[9].chatFilter			:SetCheck( chat:isShowChatType( UI_CT.LocalWar) )
	if roleplayTypeOpen then
		btnFilter[10].chatFilter		:SetCheck( chat:isShowChatType( UI_CT.RolePlay) )
	end

	-- _msgFilter_Notice:	SetFontColor( UI_color.C_FFFFEF82 )
	-- _msgFilter_System:	SetFontColor( UI_color.C_FFC4BEBE )
	-- _msgFilter_World:	SetFontColor( UI_color.C_FFFF973A )
	-- _msgFilter_Public:	SetFontColor( UI_color.C_FFE7E7E7 )
	-- _msgFilter_Private:	SetFontColor( UI_color.C_FFF601FF )
	-- _msgFilter_Party:	SetFontColor( UI_color.C_FF84D2FF )
	-- _msgFilter_Guild:	SetFontColor( UI_color.C_FF926CFF )

	chanel_Notice			= chat:isShowChatType( UI_CT.Notice )
	chanel_System			= chat:isShowChatType( UI_CT.System )
	chanel_World			= chat:isShowChatType( UI_CT.World )
	chanel_Public			= chat:isShowChatType( UI_CT.Public )
	chanel_Private			= chat:isShowChatType( UI_CT.Private )
	chanel_Party			= chat:isShowChatType( UI_CT.Party )
	chanel_Guild			= chat:isShowChatType( UI_CT.Guild )
	chanel_WorldWithItem	= chat:isShowChatType( UI_CT.WorldWithItem )
	channel_Battle			= chat:isShowChatType( UI_CT.Battle )
	channel_LocalWar		= chat:isShowChatType( UI_CT.LocalWar )
	if roleplayTypeOpen then
		channel_RolePlay		= chat:isShowChatType( UI_CT.RolePlay )
	end

	-- _msgFilter_Notice:	addInputEvent( "Mouse_LUp", "HandleClicked_ChattingTypeFilter_Notice( " .. panelIdex .. " )" )
	-- _msgFilter_System:	addInputEvent( "Mouse_LUp", "HandleClicked_ChattingTypeFilter_System( " .. panelIdex .. " )" )
	-- _msgFilter_World:	addInputEvent( "Mouse_LUp", "HandleClicked_ChattingTypeFilter_World( " .. panelIdex .. " )" )
	-- _msgFilter_Public:	addInputEvent( "Mouse_LUp", "HandleClicked_ChattingTypeFilter_Public( " .. panelIdex .. " )" )
	-- _msgFilter_Private:	addInputEvent( "Mouse_LUp", "HandleClicked_ChattingTypeFilter_Private( " .. panelIdex .. " )" )
	-- _msgFilter_Party:	addInputEvent( "Mouse_LUp", "HandleClicked_ChattingTypeFilter_Party( " .. panelIdex .. " )" )
	-- _msgFilter_Guild:	addInputEvent( "Mouse_LUp", "HandleClicked_ChattingTypeFilter_Guild( " .. panelIdex .. " )" )
	-- _msgFilter_WorldWithItem:	addInputEvent( "Mouse_LUp", "HandleClicked_ChattingTypeFilter_WorldWithItem( " .. panelIdex .. " )" )
	-- _msgFilter_Battle:	addInputEvent( "Mouse_LUp", "HandleClicked_ChattingTypeFilter_Battle( " .. panelIdex .. " )" )

	_alphaSlider_ControlBTN:addInputEvent( "Mouse_LPress",  "HandleClicked_ChattingSetTransparency(" .. panelIdex .. ")" )
	_alphaSlider_ControlBTN:SetPosX( ( ( _alphaSlider_Control:GetSizeX() - _alphaSlider_ControlBTN:GetSizeX() ) / 100 ) * _transparency * 100 )
	
	-- 콤바인 패널인데, 0번이 아니면 투명도 조절 불가
	if true == isCombinedMainPanel and 0 ~= panelIdex then
		_alphaSlider_Control:SetEnable( false )
		_alphaSlider_Control:SetMonoTone( true )
		_alphaSlider_ControlBTN:SetEnable( false )
		_alphaSlider_ControlBTN:SetMonoTone( true )
		_alpha_0:SetShow( false )
		_alpha_50:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_CHATTING_OPTION_SUBPANEL_TRANSPARENCY_NOTIFY") )
		_alpha_100:SetShow( false )
	else
		_alphaSlider_Control:SetEnable( true )
		_alphaSlider_Control:SetMonoTone( false )
		_alphaSlider_ControlBTN:SetEnable( true )
		_alphaSlider_ControlBTN:SetMonoTone( false )
		_alpha_0:SetShow( true )
		_alpha_50:SetText("50%")
		_alpha_100:SetShow( true )
	end

	_button_Confirm:	addInputEvent( "Mouse_LUp", "HandleClicked_ChattingOption_SetFilter( "  .. panelIdex .. " )" )
	_button_Cancle:		addInputEvent( "Mouse_LUp", "ChattingOption_Close()" )
	_button_Close:		addInputEvent( "Mouse_LUp", "ChattingOption_Close()" )
	_button_blockList:	addInputEvent( "Mouse_LUp", "ChattingOption_ShowBlockList()" )
end

function HandleClicked_ChattingSetTransparency( penelIdex )
	local _transparency = ( _alphaSlider_ControlBTN:GetPosX() / ( _alphaSlider_Control:GetSizeX() - _alphaSlider_ControlBTN:GetSizeX() ))
	FGlobal_Chatting_PanelTransparency( penelIdex, _transparency )
end

function HandleClicked_ChattingOption_SetFilter( panelIdex )
	local chat = ToClient_getChattingPanel( panelIdex )
	chat:setShowChatType( UI_CT.Notice,			chanel_Notice )
	chat:setShowChatType( UI_CT.System,			chanel_System )
	chat:setShowChatType( UI_CT.World,			chanel_World )
	chat:setShowChatType( UI_CT.Public,			chanel_Public )
	chat:setShowChatType( UI_CT.Private,		chanel_Private )
	chat:setShowChatType( UI_CT.Party,			chanel_Party )
	chat:setShowChatType( UI_CT.Guild,			chanel_Guild )
	chat:setShowChatType( UI_CT.WorldWithItem,	chanel_WorldWithItem )
	chat:setShowChatType( UI_CT.Battle,			channel_Battle )
	chat:setShowChatType( UI_CT.LocalWar,		channel_LocalWar )
	chat:setShowChatType( UI_CT.RolePlay,		channel_RolePlay )
	
	local _transparency = ( _alphaSlider_ControlBTN:GetPosX() / ( _alphaSlider_Control:GetSizeX() - _alphaSlider_ControlBTN:GetSizeX() ))
	chat:setTransparency( _transparency )
	
	ToClient_SaveUiInfo(true)
	
	ChattingOption_Close()
end

function ChattingOption_Open( penelIdex, drawPanelIndex, isCombinedMainPanel )
	if false == Panel_ChatOption:GetShow() then
		Panel_ChatOption:SetShow( true, true )
		Panel_ChatOption:SetIgnore( false )
	end
	local _transparency = FGlobal_Chatting_PanelTransparency_Chk( drawPanelIndex )
	ChattingOption_Initialize( penelIdex, _transparency, isCombinedMainPanel )
end

function ChattingOption_Close()
	Panel_ChatOption:SetShow( false, false )
	Panel_ChatOption:SetIgnore( true )
end

function ChatOption_ShowAni()
	UIAni.fadeInSCR_Left(Panel_ChatOption)
end

function ChattingOption_ShowBlockList()
	clickRequestShowBlockList()
end

function ChatOption_HideAni()
	Panel_ChatOption:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
	local mailHideAni = Panel_ChatOption:addColorAnimation( 0.0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
	mailHideAni:SetStartColor( UI_color.C_FFFFFFFF )
	mailHideAni:SetEndColor( UI_color.C_00FFFFFF )
	mailHideAni:SetStartIntensity( 3.0 )
	mailHideAni:SetEndIntensity( 1.0 )
	mailHideAni.IsChangeChild = true
	mailHideAni:SetHideAtEnd(true)
	mailHideAni:SetDisableWhileAni(true)
end

----------------------------------------------
-- 차단 리스트 (임시) 
----------------------------------------------
local BlockList = 
{
	_uiBlockList  			= UI.getChildControl( Panel_ChatOption, "Listbox_Block" ),
	_uiBackGround			= UI.getChildControl( Panel_ChatOption, "Static_OfferWindow" ),
	_uiBlackListTItle		= UI.getChildControl( Panel_ChatOption, "StaticText_ChatOptionOfferTitle"),
	_uiClose				= UI.getChildControl( Panel_ChatOption, "Block_Close" ),	
	_uiDelete				= UI.getChildControl( Panel_ChatOption, "Button_Delete" ),
	_uiAllDelete				= UI.getChildControl( Panel_ChatOption, "Button_AllDelete" ),	
	_uiScroll 				= nil,
	_uiScrollCtrlButton 	= nil,
	_selectDeleteIndex,
	_slotRows 				= 12
}

function BlockList:SetShow(isShow)
	BlockList._uiBlockList:SetShow(isShow);
	BlockList._uiBackGround:SetShow(isShow);
	BlockList._uiBlackListTItle:SetShow(isShow)
	BlockList._uiClose:SetShow(isShow);
	BlockList._uiDelete:SetShow(isShow);
	BlockList._uiAllDelete:SetShow(isShow);
end

function BlockList:initialize()
	self._uiScroll = UI.getChildControl( self._uiBlockList, "Block_Scroll" )
	self._uiScroll:SetControlTop()
	self._uiBlockList:addInputEvent( "Mouse_LUp", "clickBlockList()" );
	self._uiClose:addInputEvent( "Mouse_LUp", "clickCloseBlockList()" )
	self._selectDeleteIndex = -1;
	self._uiDelete:addInputEvent( "Mouse_LUp", "clickDeleteBlock()" )
	self._uiAllDelete:addInputEvent( "Mouse_LUp", "clickAllDeleteBlock()" )
	self:SetShow(false);
end

function clickCloseBlockList()
	BlockList_hide();
end

function clickDeleteBlock()
	if( -1 ~= BlockList._selectDeleteIndex ) then
		local deleteName = BlockList._uiBlockList:GetItemText(BlockList._selectDeleteIndex)
		ToClient_RequestDeleteBlockName(deleteName);
	end
end

function clickAllDeleteBlock()
	BlockList._selectDeleteIndex = -1
	ToClient_RequestDeleteAllBlockList()
end

function clickBlockList()
	BlockList._selectDeleteIndex = BlockList._uiBlockList:GetSelectIndex()
end

function BlockList:updateList()	
	local listControl = self._uiBlockList
	listControl:DeleteAll() 

	local blockCount = ToClient_RequestBlockCount()	
	for i = 0, blockCount-1, 1 do
		local blockName = ToClient_RequestGetBlockName(i)
		listControl:AddItemWithLineFeed( blockName, UI_color.C_FFFFF3AF)
	end
	UIScroll.SetButtonSize( self._uiScroll, self._slotRows, blockCount )
end

BlockList:initialize();
registerEvent( "FromClient_UpdateBlockList",	"FromClient_UpdateBlockList")

function BlockList_show()
	self._selectDeleteIndex = -1
	BlockList:SetShow(true)	
	BlockList:updateList();
end

function BlockList_hide()
	BlockList:SetShow(false)
end

function FromClient_UpdateBlockList()
	BlockList:updateList();
end

function clickRequestShowBlockList()
	if BlockList._uiBackGround:GetShow() then
		BlockList_hide()
	else
		BlockList_show()
	end
end