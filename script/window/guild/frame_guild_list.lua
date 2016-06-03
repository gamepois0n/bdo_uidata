local UI_TM 		= CppEnums.TextMode
local UI_color 		= Defines.Color
local UI_Class		= CppEnums.ClassType
local UCT 			= CppEnums.PA_UI_CONTROL_TYPE
local IM 			= CppEnums.EProcessorInputMode
local VCK			= CppEnums.VirtualKeyCode

----------------------------------------------------------------------------------------------------------------
--	변수 모음
----------------------------------------------------------------------------------------------------------------

local _constGuildListMaxCount 	= 150
local _startMemberIndex 		= 0
local _constStartY 				= 5

local _constStartButtonX		= 8
local _constStartButtonY 		= 5
local _constStartButtonGapY		= 30
local _constCollectionX			= 120
local _constCollectionY			= 80
local _selectIndex				= 0		-- 선택된 길드 멤버 Index
local _onlineGuildMember		= 0

local	_UI_Menu_Button	=
{
	Type_Deportation			= 0,	-- 추방
	Type_AppointCommander		= 1,	-- 분대장 임명
	Type_CancelAppoint			= 2,	-- 임명 해제
	Type_ChangeMaster			= 3,	-- 대장 위임	
	Type_ProtectMember			= 4,	-- 보호 길드원 설정	
	Type_CancelProtectMember	= 5,	-- 보호 길드원 해제
	Type_PartyInvite			= 6,	-- 파티 초대
	Type_Count					= 7,
}

local numberKeyCode =		-- 입금 - 값 실시간 체크를 위한
{
	VCK.KeyCode_0,			
	VCK.KeyCode_1,	
	VCK.KeyCode_2,	
	VCK.KeyCode_3,	
	VCK.KeyCode_4,	
	VCK.KeyCode_5,	
	VCK.KeyCode_6,	
	VCK.KeyCode_7,	
	VCK.KeyCode_8,	
	VCK.KeyCode_9,
	VCK.KeyCode_NUMPAD0,
	VCK.KeyCode_NUMPAD1,
	VCK.KeyCode_NUMPAD2,
	VCK.KeyCode_NUMPAD3,
	VCK.KeyCode_NUMPAD4,
	VCK.KeyCode_NUMPAD5,
	VCK.KeyCode_NUMPAD6,
	VCK.KeyCode_NUMPAD7,
	VCK.KeyCode_NUMPAD8,
	VCK.KeyCode_NUMPAD9
}

local inputGuildDepositNum_s64		= toInt64(0, 0)
local inputGuildDepositMaxNum_s64	= toInt64(0, 0)

local notice_title					= UI.getChildControl ( Panel_Window_Guild,	"StaticText_NoticeTitle")
----------------------------------------------------------------------------------------------------------------
------------ 길드원 현황 관리
----------------------------------------------------------------------------------------------------------------
GuildListInfoPage = 
{
	_frameDefaultBG		= UI.getChildControl ( Panel_Window_Guild,	"Static_Frame_ListBG" ),
	_buttonListBG		= UI.getChildControl ( Panel_Guild_List,	"Static_FunctionBG" ),
	_scrollBar,
--	_scrollBarCtrl,
	_list = {},
	_buttonList = {},
	_textBusinessFunds,
	_btnGiveIncentive,
	_btnDeposit,		
	_btnPaypal,
	decoIcon_Guild,
	decoIcon_Clan,
	_frameGuildList,
	_contentGuildList,
}

local tempGuildList = {}
--[[
GuildWarfareInfoPage
	initialize()
	UpdateData()
	Show()
	Hide()
	_list : rtGuildListInfo의 리스트	
		rtGuildListInfo로 검색해서 맴버 확인 요망	
	_buttonList : rtGuildListInfoButton의 리스트
]]--

--------------------------------------------------------------------------------
-- 지원금 관련 초기화 설정
--------------------------------------------------------------------------------
Panel_GuildIncentive:SetShow( false )
local incentive_InputMoney	= UI.getChildControl ( Panel_GuildIncentive,	"Edit_InputIncentiveValue" )
local btn_incentive_Send	= UI.getChildControl ( Panel_GuildIncentive,	"Button_Confirm" )
local btn_incentive_Cancle	= UI.getChildControl ( Panel_GuildIncentive,	"Button_Cancle" )
local btn_incentive_Help	= UI.getChildControl ( Panel_GuildIncentive,	"Button_Question" )
incentive_InputMoney:SetNumberMode( true )

local txt_incentive_Title			= UI.getChildControl ( Panel_GuildIncentive,	"StaticText_Title" )
local txt_incentive_Deposit			= UI.getChildControl ( Panel_GuildIncentive,	"StaticText_Incentive" )
local txt_incentive_Notify			= UI.getChildControl ( Panel_GuildIncentive,	"StaticText_Notify" )
txt_incentive_Notify:SetTextMode( UI_TM.eTextMode_AutoWrap )

incentive_InputMoney		:addInputEvent("Mouse_LUp", "HandleClicked_SetIncentive()")
btn_incentive_Send			:addInputEvent("Mouse_LUp", "HandleClicked_GuildIncentive_Send()")
btn_incentive_Cancle		:addInputEvent("Mouse_LUp", "HandleClicked_GuildIncentive_Close()")
btn_incentive_Help			:addInputEvent("Mouse_LUp", "")

incentive_InputMoney		:RegistReturnKeyEvent( "FGlobal_SaveGuildMoney_Send()" )

local btn_GuildMasterMandateBG		= UI.getChildControl ( Panel_Window_Guild,		"Static_GuildMandateBG")
local btn_GuildMasterMandate		= UI.getChildControl ( Panel_Window_Guild,		"Button_GuildMandate")

-- 0 이면 지원금에서 사용하는 것이고, 1이면 입급에서 사용된다.
local _incentivePanelType = 0

------------------------------------------------------
--				최초 초기화 해주는 함수 (Panel_Guild.lua 에서 사용)
------------------------------------------------------
local frameSizeY = 0
local contentSizeY = 0

local staticText_Grade					= UI.getChildControl ( Panel_Guild_List,	"StaticText_M_Grade" )
local staticText_Level					= UI.getChildControl ( Panel_Guild_List,	"StaticText_M_Level" )
local staticText_Class					= UI.getChildControl ( Panel_Guild_List,	"StaticText_M_Class" )
local staticText_activity				= UI.getChildControl ( Panel_Guild_List,	"StaticText_M_Activity" )
local staticText_contributedTendency	= UI.getChildControl ( Panel_Guild_List,	"StaticText_M_ContributedTendency" )
local staticText_contract				= UI.getChildControl ( Panel_Guild_List,	"StaticText_M_Contract" )
local staticText_charName				= UI.getChildControl ( Panel_Guild_List, 	"StaticText_M_CharName" )

local _selectSortType = -1
local _listSort	= {
	grade		= false,
	level		= false,
	class		= false,
	name		= false,
	ap			= false,
	expiration	= false,
}

staticText_Grade				:addInputEvent("Mouse_LUp",	"HandleClicked_GuildListSort( " .. 0 .. " )")
staticText_Level				:addInputEvent("Mouse_LUp",	"HandleClicked_GuildListSort( " .. 1 .. " )")
staticText_Class				:addInputEvent("Mouse_LUp",	"HandleClicked_GuildListSort( " .. 2 .. " )")
staticText_charName				:addInputEvent("Mouse_LUp",	"HandleClicked_GuildListSort( " .. 3 .. " )")
staticText_activity				:addInputEvent("Mouse_LUp",	"HandleClicked_GuildListSort( " .. 4 .. " )")
staticText_contract				:addInputEvent("Mouse_LUp",	"HandleClicked_GuildListSort( " .. 5 .. " )")

staticText_activity				:addInputEvent("Mouse_On",	"_guildListInfoPage_titleTooltipShow( true,		" .. 0 .. " )")
staticText_activity				:addInputEvent("Mouse_Out",	"_guildListInfoPage_titleTooltipShow( false,	" .. 0 .. " )")
staticText_activity				:setTooltipEventRegistFunc("_guildListInfoPage_titleTooltipShow( true,		" .. 0 .. " )")
-- staticText_contributedTendency	:addInputEvent("Mouse_On",	"_guildListInfoPage_titleTooltipShow( true,		" .. 1 .. " )")
-- staticText_contributedTendency	:addInputEvent("Mouse_Out",	"_guildListInfoPage_titleTooltipShow( false,	" .. 1 .. " )")
staticText_contract				:addInputEvent("Mouse_On",	"_guildListInfoPage_titleTooltipShow( true,		" .. 2 .. " )")
staticText_contract				:addInputEvent("Mouse_Out",	"_guildListInfoPage_titleTooltipShow( false,	" .. 2 .. " )")
staticText_contract				:setTooltipEventRegistFunc("_guildListInfoPage_titleTooltipShow( true,		" .. 2 .. " )")
staticText_contributedTendency	:addInputEvent("Mouse_On",	"_guildListInfoPage_titleTooltipShow( true,		" .. 3 .. " )")
staticText_contributedTendency	:addInputEvent("Mouse_Out",	"_guildListInfoPage_titleTooltipShow( false,	" .. 3 .. " )")
staticText_contributedTendency	:setTooltipEventRegistFunc("_guildListInfoPage_titleTooltipShow( true,		" .. 3 .. " )")

function _guildListInfoPage_titleTooltipShow( isShow, titleType )
	local control = nil
	local name = ""
	local desc = ""

	if 0 == titleType then
		name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_ACTIVITY_TITLE")	-- "길드 활동량"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_ACTIVITY_CONTENTS")
		control = staticText_activity
		-- "길드에 속한 시점부터 현재까지 활동한 정도를 수치로 나타낸 항목입니다."
	elseif 1 == titleType then
		control = staticText_contributedTendency
		name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_CONTRIBUTEDTENDENCY_TITLE")	-- "길드 성향 기여도"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_CONTRIBUTEDTENDENCY_CONTENTS")
		-- "길드에 속한 시점부터 현재까지 성향치에 관하여 활동한 정도를 수치로 나타낸 항목입니다."
	elseif 2 == titleType then
		control = staticText_contract
		name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_CONTRACT_TITLE")	-- "길드 계약서 보기"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_CONTRACT_CONTENTS")
		-- "해당 길드원의 길드 계약 내용을 열람할 수 있는 항목입니다."
	elseif 3 == titleType then
		control = staticText_contributedTendency
		name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_CONTRIBUTEDTENDENCY_TOOLTIP_TITLE")
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_CONTRIBUTEDTENDENCY_TOOLTIP_DESC")
	end

	if true == isShow then
		registTooltipControl(control, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function _guildListInfoPage_MandateTooltipShow( isShow, titleType, controlIdx )
	local myGuildListInfo	= ToClient_GetMyGuildInfoWrapper()
	if nil == myGuildListInfo then
		return
	end
	local dataIdx			= tempGuildList[controlIdx+1].idx	-- 새로운 배열에 저장된 정렬을 기반으로 한다.
	local myGuildMemberInfo	= myGuildListInfo:getMember( dataIdx )

	local temporaryWrapper	= getTemporaryInformationWrapper()
	local worldNo			= temporaryWrapper:getSelectedWorldServerNo()
	local channelName		= getChannelName(worldNo, myGuildMemberInfo:getServerNo() )

	local memberChannel		= ""
	if(myGuildMemberInfo:isOnline()) then
		lastLogin			= ( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_ONLINE_MEMBER") )
		memberChannel		= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_CHANNEL_MEMBER", "channelName", channelName ) -- "\n- 현재 접속 채널 : <PAColor0xFF66CC33>" .. channelName .. "<PAOldColor>"
	else
		lastLogin			= GuildLogoutTimeConvert(myGuildMemberInfo:getElapsedTimeAfterLogOut_s64())
		memberChannel		= ""
	end

	if 0 == titleType then	-- 재계약 가능
		control = GuildListInfoPage._list[controlIdx]._contractBtn
		name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_CONTRACT_TITLE")
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_TOOLTIP_TITLETYPE5_DESC") .. PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_LIST_TOOLTIP_LASTLOGOUT", "lastLogin", lastLogin ) .. memberChannel
		--재계약 가능 상태
	elseif 1 == titleType then	-- 계약 중
		control = GuildListInfoPage._list[controlIdx]._contractBtn
		name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_CONTRACT_TITLE")	-- "길드 계약서 보기"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_TOOLTIP_TITLETYPE3_DESC") .. PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_LIST_TOOLTIP_LASTLOGOUT", "lastLogin", lastLogin ) .. memberChannel
		-- "해당 길드원의 길드 계약 내용을 열람할 수 있는 항목입니다."
	elseif 2 == titleType then	-- 계약 만료
		control = GuildListInfoPage._list[controlIdx]._contractBtn
		name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_CONTRACT_TITLE")	-- "길드 계약서 보기"
		desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_TOOLTIP_TITLETYPE4_DESC") .. PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_LIST_TOOLTIP_LASTLOGOUT", "lastLogin", lastLogin ) .. memberChannel
		-- "해당 길드원의 길드 계약 내용을 열람할 수 있는 항목입니다. 계약 기간이 만료된 상태입니다."
	end

	if true == isShow then
		registTooltipControl(control, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function GuildLogoutTimeConvert( s64_datetime )


	local s64_dayCycle 		= toInt64(0, (24*60*60) );
	local s64_hourCycle 	= toInt64(0, (60*60) );
	
	local s64_day				= s64_datetime / s64_dayCycle;
	local s64_hour			= (s64_datetime - (s64_dayCycle*s64_day)) / s64_hourCycle;
	
	local	strDate	= "";
	if( Defines.s64_const.s64_0 < s64_day ) then
		strDate	= ( tostring(s64_day).. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_DAY") )
	elseif( Defines.s64_const.s64_0 < s64_hour ) then
		strDate	= (  PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_DAY_IN") )
	else
		strDate	= ( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_HOUR_IN") )
	end
	return(strDate)
end

function GuildListInfoPage:initialize()
	self._frameGuildList				= UI.getChildControl ( Panel_Guild_List, 	"Frame_GuildList" )
	self._contentGuildList				= UI.getChildControl ( self._frameGuildList, 	"Frame_1_Content" )

	local _copyGrade					= UI.getChildControl ( self._contentGuildList, 	"StaticText_C_Grade" )
	local _copyLevel					= UI.getChildControl ( self._contentGuildList, 	"StaticText_C_Level" )
	local _copyClass					= UI.getChildControl ( self._contentGuildList, 	"StaticText_C_Class" )
	local _copyCharName					= UI.getChildControl ( self._contentGuildList, 	"StaticText_C_CharName" )
	local _copyContributedTendency		= UI.getChildControl ( self._contentGuildList, 	"StaticText_C_ContributedTendency" )
	local _copyActivity					= UI.getChildControl ( self._contentGuildList,	"StaticText_C_Activity" )
	
	local _copyPartLine					= UI.getChildControl ( self._contentGuildList, 	"Static_C_PartLine" )	
	local _copyContractButton			= UI.getChildControl ( self._contentGuildList, 	"Button_C_Contract" )
	local _copyGuardHim					= UI.getChildControl ( self._contentGuildList, 	"Static_C_GuardHim" )
	
	local _copyButton					= UI.getChildControl ( Panel_Guild_List, 	"Button_Function" )

	GuildListInfoPage._textBusinessFundsBG	= UI.getChildControl ( Panel_Guild_List, 	"StaticText_GuildMoney" )
	GuildListInfoPage._textBusinessFunds	= UI.getChildControl ( Panel_Guild_List, 	"StaticText_GuildMoney_Value" )
	
	GuildListInfoPage._btnGiveIncentive		= UI.getChildControl ( Panel_Guild_List,	"Button_Incentive" )
	GuildListInfoPage._btnDeposit			= UI.getChildControl ( Panel_Guild_List, 	"Button_Deposit" )
	GuildListInfoPage._btnPaypal			= UI.getChildControl ( Panel_Guild_List, 	"Button_Paypal" )

	GuildListInfoPage.decoIcon_Guild		= UI.getChildControl ( self._contentGuildList, 	"Static_DecoIcon_Guild" )
	GuildListInfoPage.decoIcon_Clan			= UI.getChildControl ( self._contentGuildList, 	"Static_DecoIcon_Clan" )

	GuildListInfoPage._btnGiveIncentive	:addInputEvent("Mouse_LUp",	"HandleCLicked_IncentiveOption()")
	GuildListInfoPage._btnDeposit		:addInputEvent("Mouse_LUp",	"HandleCLicked_GuildListIncentive_Deposit()")
	GuildListInfoPage._btnPaypal		:addInputEvent("Mouse_LUp",	"HandleCLicked_GuildListIncentive_Paypal()")

	-- 스크롤 관련 부분------------------------------------------------
	self._scrollBar = UI.getChildControl ( self._frameGuildList,		"VerticalScroll" )
	UIScroll.InputEvent( self._scrollBar, "GuildListMouseScrollEvent" )
	
	self._contentGuildList:addInputEvent("Mouse_UpScroll", 		"GuildListMouseScrollEvent(true)")
	self._contentGuildList:addInputEvent("Mouse_DownScroll", 	"GuildListMouseScrollEvent(false)")
	---------------------------------------------------------------------
	
	-- 리스트 생성
	function createListInfo( pIndex )
		local rtGuildListInfo = {}
		
		rtGuildListInfo._grade 					= UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT, 	self._contentGuildList, 'StaticText_Grade_' .. pIndex )	
		rtGuildListInfo._level 					= UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT, 	self._contentGuildList, 'StaticText_Level_' .. pIndex )
		rtGuildListInfo._class 					= UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT, 	self._contentGuildList, 'StaticText_Class_' .. pIndex )
		rtGuildListInfo._charName 				= UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT, 	self._contentGuildList, 'StaticText_CharName_' .. pIndex )
		rtGuildListInfo._contributedTendency	= UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT, 	self._contentGuildList, 'StaticText_ContributedTendency_' .. pIndex )	-- 성향치 기여도
		rtGuildListInfo._activity				= UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT, 	self._contentGuildList, 'StaticText_Activity_' .. pIndex )	-- 활동량
		rtGuildListInfo._partLine 				= UI.createControl( UCT.PA_UI_CONTROL_STATIC, 		self._contentGuildList, "Static_C_PartLine_".. pIndex )
		rtGuildListInfo._contractBtn 			= UI.createControl( UCT.PA_UI_CONTROL_BUTTON, 		self._contentGuildList, "Button_C_Contract_".. pIndex )
		rtGuildListInfo._guardHim	 			= UI.createControl( UCT.PA_UI_CONTROL_STATIC, 		self._contentGuildList, "Static_C_GuardHim_".. pIndex )

		
			
		CopyBaseProperty( _copyGrade, 					rtGuildListInfo._grade )	
		CopyBaseProperty( _copyLevel, 					rtGuildListInfo._level )
		CopyBaseProperty( _copyClass, 					rtGuildListInfo._class )
		CopyBaseProperty( _copyCharName, 				rtGuildListInfo._charName )
		CopyBaseProperty( _copyContributedTendency, 	rtGuildListInfo._contributedTendency )
		CopyBaseProperty( _copyActivity, 				rtGuildListInfo._activity)
		CopyBaseProperty( _copyPartLine, 				rtGuildListInfo._partLine )
		CopyBaseProperty( _copyContractButton, 			rtGuildListInfo._contractBtn )
		CopyBaseProperty( _copyGuardHim, 				rtGuildListInfo._guardHim )
	
		rtGuildListInfo._grade					:SetPosY( _constStartY + pIndex * 30 )	
		rtGuildListInfo._level					:SetPosY( _constStartY + pIndex * 30 )
		rtGuildListInfo._class					:SetPosY( _constStartY + pIndex * 30 )
		rtGuildListInfo._charName				:SetPosY( _constStartY + pIndex * 30 )
		rtGuildListInfo._contributedTendency	:SetPosY( _constStartY + pIndex * 30 )
		rtGuildListInfo._activity				:SetPosY( _constStartY + pIndex * 30 )
		rtGuildListInfo._partLine				:SetPosY( pIndex * 30 )
		rtGuildListInfo._contractBtn			:SetPosY( (pIndex * 30) + 6 )
		rtGuildListInfo._guardHim				:SetPosY( (pIndex * 30) + 8 )
		rtGuildListInfo._guardHim				:SetPosX( rtGuildListInfo._grade:GetTextSizeX()+20 )
		
		rtGuildListInfo._grade					:SetIgnore( false )
		rtGuildListInfo._level					:SetIgnore( false )
		rtGuildListInfo._class					:SetIgnore( false )
		rtGuildListInfo._charName				:SetIgnore( false )
		rtGuildListInfo._contributedTendency	:SetIgnore( false )
		rtGuildListInfo._activity				:SetIgnore( false )
		rtGuildListInfo._partLine				:SetIgnore( false )
		
		-- rtGuildListInfo._grade					:addInputEvent( "Mouse_LUp",		"HandleClickedGuildMemberMenuButton(" .. pIndex .. ")"	)
		-- rtGuildListInfo._level					:addInputEvent( "Mouse_LUp",		"HandleClickedGuildMemberMenuButton(" .. pIndex .. ")"	)
		-- rtGuildListInfo._class					:addInputEvent( "Mouse_LUp",		"HandleClickedGuildMemberMenuButton(" .. pIndex .. ")"	)
		rtGuildListInfo._charName				:addInputEvent( "Mouse_LUp",		"HandleClickedGuildMemberMenuButton(" .. pIndex .. ")"	)
		rtGuildListInfo._charName				:addInputEvent( "Mouse_On",			"HandleToolTipChannelName( true,	" .. pIndex .. ")"	)
		rtGuildListInfo._charName				:addInputEvent( "Mouse_Out",		"HandleToolTipChannelName( false,	" .. pIndex .. ")"	)
		rtGuildListInfo._charName				:addInputEvent("Mouse_LUp", "HandleToolTipChannelName( true, " .. pIndex .. " )")
		-- rtGuildListInfo._contributedTendency	:addInputEvent( "Mouse_LUp",		"HandleClickedGuildMemberMenuButton(" .. pIndex .. ")"	)
		-- rtGuildListInfo._activity				:addInputEvent( "Mouse_LUp",		"HandleClickedGuildMemberMenuButton(" .. pIndex .. ")"	)
		rtGuildListInfo._contractBtn			:addInputEvent( "Mouse_LUp",		"HandleClickedGuildMemberContractButton(" .. pIndex .. ")"	)
		-- rtGuildListInfo._guardHim				:addInputEvent( "Mouse_LUp",		"HandleClickedGuildMemberMenuButton(" .. pIndex .. ")"	)
		
		rtGuildListInfo._grade					:addInputEvent( "Mouse_UpScroll", 	"GuildListMouseScrollEvent(true)")
		rtGuildListInfo._level					:addInputEvent( "Mouse_UpScroll", 	"GuildListMouseScrollEvent(true)")
		rtGuildListInfo._class					:addInputEvent( "Mouse_UpScroll", 	"GuildListMouseScrollEvent(true)")
		rtGuildListInfo._charName				:addInputEvent( "Mouse_UpScroll", 	"GuildListMouseScrollEvent(true)")
		rtGuildListInfo._contributedTendency	:addInputEvent( "Mouse_UpScroll", 	"GuildListMouseScrollEvent(true)")
		rtGuildListInfo._activity				:addInputEvent( "Mouse_UpScroll", 	"GuildListMouseScrollEvent(true)")
		rtGuildListInfo._partLine				:addInputEvent( "Mouse_UpScroll", 	"GuildListMouseScrollEvent(true)")
		rtGuildListInfo._contractBtn			:addInputEvent( "Mouse_UpScroll", 	"GuildListMouseScrollEvent(true)")
		rtGuildListInfo._guardHim				:addInputEvent( "Mouse_UpScroll", 	"GuildListMouseScrollEvent(true)")
		
		rtGuildListInfo._grade					:addInputEvent( "Mouse_DownScroll",	"GuildListMouseScrollEvent(false)")
		rtGuildListInfo._level					:addInputEvent( "Mouse_DownScroll",	"GuildListMouseScrollEvent(false)")
		rtGuildListInfo._class					:addInputEvent( "Mouse_DownScroll",	"GuildListMouseScrollEvent(false)")
		rtGuildListInfo._charName				:addInputEvent( "Mouse_DownScroll",	"GuildListMouseScrollEvent(false)")
		rtGuildListInfo._contributedTendency	:addInputEvent( "Mouse_DownScroll",	"GuildListMouseScrollEvent(false)")
		rtGuildListInfo._activity				:addInputEvent( "Mouse_DownScroll",	"GuildListMouseScrollEvent(false)")
		rtGuildListInfo._partLine				:addInputEvent( "Mouse_DownScroll",	"GuildListMouseScrollEvent(false)")
		rtGuildListInfo._contractBtn			:addInputEvent( "Mouse_DownScroll",	"GuildListMouseScrollEvent(false)")
		rtGuildListInfo._guardHim				:addInputEvent( "Mouse_UpScroll", 	"GuildListMouseScrollEvent(false)")

		function rtGuildListInfo:SetShow( isShow )
			rtGuildListInfo._grade					:SetShow(isShow)
			rtGuildListInfo._level					:SetShow(isShow)
			rtGuildListInfo._class					:SetShow(isShow)
			rtGuildListInfo._charName				:SetShow(isShow)
			rtGuildListInfo._contributedTendency	:SetShow(isShow)
			rtGuildListInfo._activity				:SetShow(isShow)
			rtGuildListInfo._partLine				:SetShow(isShow)
			rtGuildListInfo._contractBtn			:SetShow(isShow)
			rtGuildListInfo._guardHim				:SetShow(isShow)	-- 따로 제어 해야 한다.
		end
		
		function rtGuildListInfo:SetIgnore( isIgnore )
			rtGuildListInfo._grade					:SetIgnore( isIgnore )	
			rtGuildListInfo._level					:SetIgnore( isIgnore )	
			rtGuildListInfo._class					:SetIgnore( isIgnore )	
			rtGuildListInfo._charName				:SetIgnore( isIgnore )	
			rtGuildListInfo._contributedTendency	:SetIgnore( isIgnore )	
			rtGuildListInfo._activity				:SetIgnore( isIgnore )	
			rtGuildListInfo._partLine				:SetIgnore( isIgnore )	
			-- rtGuildListInfo._contractBtn			:SetIgnore( isIgnore )
			rtGuildListInfo._guardHim				:SetIgnore( isIgnore )	-- 따로 제어 해야 한다.
		end
			
		return rtGuildListInfo
	end
	
	-- 버튼 생성
	function createListInfoButton( pIndex )
		local rtGuildListInfoButton = {}
		
		local rtGuildListInfoButton	= UI.createControl( UCT.PA_UI_CONTROL_BUTTON, self._buttonListBG, 'Guild_Menu_Button_' .. pIndex )
		CopyBaseProperty( _copyButton, rtGuildListInfoButton )
		
		rtGuildListInfoButton:SetText( PAGetString( Defines.StringSheet_GAME,  "GULD_BUTTON" .. tostring(pIndex)) )
		rtGuildListInfoButton:SetPosX( _constStartButtonX )
		--rtGuildListInfoButton:SetPosY( _constStartButtonY + (pIndex * _constStartButtonGapY) )
		rtGuildListInfoButton:SetShow( true )
		
		rtGuildListInfoButton:addInputEvent( "Mouse_LUp", "HandleClickedGuildMenuButton(" .. pIndex .. ")"	)
		
		return rtGuildListInfoButton
	end
	
	-- 버튼 창에서 마우스 벗어날 시에 창 닫기
	self._buttonListBG:addInputEvent( "Mouse_Out", "MouseOutGuildMenuButton()"	)
	
	for index = 0, _constGuildListMaxCount - 1, 1 do
		self._list[index] = createListInfo(index)
	end

	for	index = 0, (_UI_Menu_Button.Type_Count-1), 1 do
		self._buttonList[index] = createListInfoButton(index)
		self._buttonList[index]:addInputEvent( "Mouse_Out", "MouseOutGuildMenuButton()"	)
	end
	
	Panel_Guild_List:SetChildIndex(staticText_Grade, 9999)
	Panel_Guild_List:SetChildIndex(staticText_Level, 9999)
	Panel_Guild_List:SetChildIndex(staticText_Class, 9999)
	Panel_Guild_List:SetChildIndex(staticText_charName, 9999)
	Panel_Guild_List:SetChildIndex(staticText_activity, 9999)
	Panel_Guild_List:SetChildIndex(staticText_contract, 9999)

	GuildListInfoPage._buttonList[0]:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_BUTTONLIST_TEXT_1" ) )   --추방
	GuildListInfoPage._buttonList[1]:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_BUTTONLIST_TEXT_2" ) )	--임명
	GuildListInfoPage._buttonList[2]:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_BUTTONLIST_TEXT_3" ) )	--임명취소
	GuildListInfoPage._buttonList[3]:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_BUTTONLIST_TEXT_0" ) )	--대장위임
	GuildListInfoPage._buttonList[4]:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_BUTTONLIST_TEXT_4" ) )	--길드원 보호
	GuildListInfoPage._buttonList[5]:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_BUTTONLIST_TEXT_5" ) )	--길드원 보호 해제
	GuildListInfoPage._buttonList[6]:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_BUTTONLIST_TEXT_6" ) )	--길드원 파티 초대
	
	UI.deleteControl( _copyGrade )
	UI.deleteControl( _copyLevel )
	UI.deleteControl( _copyClass )
	UI.deleteControl( _copyCharName )
	UI.deleteControl( _copyContributedTendency )
	UI.deleteControl( _copyActivity )
	UI.deleteControl( _copyPartLine )
	UI.deleteControl( _copyContractButton )
	UI.deleteControl( _copyButton )
	UI.deleteControl( _copyGuardHim )
		
	_copyGrade					= nil
	_copyLevel					= nil
	_copyClass					= nil
	_copyCharName				= nil
	_copyContributedTendency	= nil
	_copyPartLine				= nil
	_copyContractButton			= nil
	_copyButton					= nil
	_copyGuardHim				= nil

	frameSizeY = self._frameGuildList:GetSizeY()	-- 업데이트문에서 스크롤 노출 여부를 계산 하기 위해 쓰임

	self._frameGuildList:UpdateContentScroll()		-- 프레임 내 스크롤 적용.
	self._frameGuildList:UpdateContentPos()			-- 프레임 내용 갱신

	self._frameDefaultBG:MoveChilds(self._frameDefaultBG:GetID(), Panel_Guild_List)
	UI.deletePanel(Panel_Guild_List:GetID())
	Panel_Guild_List = nil

	GuildListInfoPage._textBusinessFunds:SetSpanSize( GuildListInfoPage._textBusinessFundsBG:GetSpanSize().x+GuildListInfoPage._textBusinessFundsBG:GetTextSizeX(), GuildListInfoPage._textBusinessFunds:GetSpanSize().y )
end

----------------------------------------------------------------------
-- 					길드 멤버 클릭시 메뉴창 팝업
----------------------------------------------------------------------

function HandleClickedGuildMemberMenuButton( index )
	local self = GuildListInfoPage
	local dataIdx = tempGuildList[index+1].idx	-- 새로운 배열에 저장된 정렬을 기반으로 한다.
	local guildMember = ToClient_GetMyGuildInfoWrapper():getMember( dataIdx )
	local grade = guildMember:getGrade()		-- 0: 대장 / 1: 부대장 / 2: 일반
	local isProtect = guildMember:isProtectable()
	local isGuildMaster = getSelfPlayer():get():isGuildMaster()	
	local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()	

	local buttonListBgX = self._list[index]._charName:GetParentPosX() - Panel_Window_Guild:GetPosX() -- _constCollectionX
	local buttonListBgY = self._list[index]._charName:GetParentPosY() - Panel_Window_Guild:GetPosY() - _constCollectionY	
	GuildListInfoPage._buttonListBG:SetPosX( buttonListBgX )
	GuildListInfoPage._buttonListBG:SetPosY( buttonListBgY )
	
	for dataIdx = 0, (_UI_Menu_Button.Type_Count-1), 1 do
		GuildListInfoPage._buttonList[dataIdx]:SetShow(false)
	end

	if true == isGuildMaster then
		if 0 == grade then
			GuildListInfoPage._buttonListBG:SetShow(false)
		elseif 1 == grade then
			GuildListInfoPage._buttonListBG:SetShow(true)
			
			GuildListInfoPage._buttonList[6]:SetShow( true )
			GuildListInfoPage._buttonList[6]:SetPosY( _constStartButtonY )

			GuildListInfoPage._buttonList[0]:SetShow( true );
			GuildListInfoPage._buttonList[0]:SetPosY( _constStartButtonY + _constStartButtonGapY );
			
			GuildListInfoPage._buttonList[2]:SetShow( true );
			GuildListInfoPage._buttonList[2]:SetPosY( _constStartButtonY + _constStartButtonGapY * 2 );

			GuildListInfoPage._buttonList[3]:SetShow( true );
			GuildListInfoPage._buttonList[3]:SetPosY( _constStartButtonY + (_constStartButtonGapY * 3) );
			
			GuildListInfoPage._buttonListBG:SetSize(140, 130)
			_selectIndex	= dataIdx
		else
			GuildListInfoPage._buttonListBG:SetShow(true)
			
			GuildListInfoPage._buttonList[6]:SetShow( true )
			GuildListInfoPage._buttonList[6]:SetPosY( _constStartButtonY )

			GuildListInfoPage._buttonList[0]:SetShow( true );
			GuildListInfoPage._buttonList[0]:SetPosY( _constStartButtonY + (_constStartButtonGapY*3) );
			if isProtect == false then 
				GuildListInfoPage._buttonList[1]:SetShow( true );
				GuildListInfoPage._buttonList[1]:SetPosY( _constStartButtonY + _constStartButtonGapY );

				GuildListInfoPage._buttonList[4]:SetShow( true );
				GuildListInfoPage._buttonList[4]:SetPosY( _constStartButtonY + (_constStartButtonGapY * 2) );
				
				GuildListInfoPage._buttonListBG:SetSize(140, 130)
			else
				GuildListInfoPage._buttonList[5]:SetShow( true );
				GuildListInfoPage._buttonList[5]:SetPosY( _constStartButtonY + _constStartButtonGapY );
				
				GuildListInfoPage._buttonListBG:SetSize(140, 100)
			end
			_selectIndex	= dataIdx
		end
	elseif true == isGuildSubMaster then
		if 0 == grade then
			GuildListInfoPage._buttonListBG:SetSize(140, 40)
			GuildListInfoPage._buttonListBG:SetShow(true)

			GuildListInfoPage._buttonList[6]:SetShow( true )
			GuildListInfoPage._buttonList[6]:SetPosY( _constStartButtonY )

			_selectIndex	= dataIdx
		elseif 1 == grade then
			GuildListInfoPage._buttonListBG:SetSize(140, 40)
			GuildListInfoPage._buttonListBG:SetShow(true)

			GuildListInfoPage._buttonList[6]:SetShow( true )
			GuildListInfoPage._buttonList[6]:SetPosY( _constStartButtonY )

			_selectIndex	= dataIdx
		elseif 2 == grade then
			GuildListInfoPage._buttonListBG:SetSize(140, 70)
			GuildListInfoPage._buttonListBG:SetShow(true)

			GuildListInfoPage._buttonList[6]:SetShow( true )
			GuildListInfoPage._buttonList[6]:SetPosY( _constStartButtonY )

			GuildListInfoPage._buttonList[0]:SetShow( true );
			GuildListInfoPage._buttonList[0]:SetPosY( _constStartButtonY + _constStartButtonGapY );
			
			_selectIndex	= dataIdx
		else	
			GuildListInfoPage._buttonListBG:SetShow(false)
		end
	else
		GuildListInfoPage._buttonListBG:SetSize(140, 40)
		GuildListInfoPage._buttonListBG:SetShow(true)

		GuildListInfoPage._buttonList[6]:SetShow( true )
		GuildListInfoPage._buttonList[6]:SetPosY( _constStartButtonY )

		_selectIndex	= dataIdx
	end
end

function HandleClickedGuildMemberContractButton( index )	-- 계약서 보기
	local memberIndex		= index
	local myGuildListInfo	= ToClient_GetMyGuildInfoWrapper()
	local dataIdx = tempGuildList[index+1].idx	-- 새로운 배열에 저장된 정렬을 기반으로 한다.
	local myGuildMemberInfo = myGuildListInfo:getMember(dataIdx)
	-- local grade				= ToClient_GetMyGuildInfoWrapper():getMember(memberIndex):getGrade()

	local isGuildMaster		= getSelfPlayer():get():isGuildMaster()
	local isGuildSubMaster	= getSelfPlayer():get():isGuildSubMaster()
	local usableActivity	= myGuildMemberInfo:getUsableActivity()
	
	if true == isGuildMaster then
		FGlobal_AgreementGuild_Master_Open( dataIdx , 0, usableActivity );
	
	elseif true == isGuildSubMaster then
		FGlobal_AgreementGuild_Master_Open( dataIdx , 1, usableActivity );
	
	else
		FGlobal_AgreementGuild_Master_Open( dataIdx, 2, usableActivity );
	
	end
end

function HandleCLicked_IncentiveOption()
	Panel_GuildIncentiveOption_ShowToggle()
end

function HandleCLicked_GuildListIncentive_Open()
	_incentivePanelType = 0
	incentive_InputMoney:SetEditText('', true)
	Panel_GuildIncentive:SetShow( true )
	
	txt_incentive_Title		:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_INCENTIVE_TITLE") ) -- "지원금 지급"
	txt_incentive_Deposit	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_INCENTIVE_DEPOSIT") ) -- "지급 금액"
	txt_incentive_Notify	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_INCENTIVE_NOTIFY") ) -- "모든 길드원에게 지원금를 지급합니다."
end

function HandleCLicked_GuildListIncentive_Deposit()
	_incentivePanelType = 1

	local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
	if nil == myGuildListInfo then
		return
	end
	local businessFunds_s64		= myGuildListInfo:getGuildBusinessFunds_s64() 	-- 현재 길드 자금.
	local unpaidTax_s64			= myGuildListInfo:getAccumulateTax()			-- 미납 법인세.
	local unpaidCost_s64		= myGuildListInfo:getAccumulateGuildHouseCost() -- 미납 법인세.
	
	local maxInputValue_s64 = toInt64(0,0);
	if( toInt64(0,0) < unpaidTax_s64 ) then
		maxInputValue_s64	= myGuildListInfo:getAccumulateTax() - myGuildListInfo:getGuildBusinessFunds_s64()
	elseif( toInt64(0,0) < unpaidCost_s64 ) then
		maxInputValue_s64	= myGuildListInfo:getAccumulateGuildHouseCost() - myGuildListInfo:getGuildBusinessFunds_s64()
	end
	
	inputGuildDepositMaxNum_s64 = maxInputValue_s64	-- 자동 검사를 위해 넣는다.

	incentive_InputMoney:SetEditText( maxInputValue_s64, true)
	Panel_GuildIncentive:SetShow( true )
	
	txt_incentive_Title		:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_DEPOSIT_TITLE") ) -- "입금"
	txt_incentive_Deposit	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_DEPOSIT_DEPOSIT") ) -- "입금 금액"
	txt_incentive_Notify	:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILDLIST_DEPOSIT_NOTIFY", "maxInput", makeDotMoney(maxInputValue_s64) ) ) -- 미납 조합세에서 현재 길드가 보유한 자금을 뺀 나머지({maxInput} 은화)만 입금이 가능하고, 누구나 입금은 가능합니다.
end

function HandleCLicked_GuildListIncentive_Paypal()
	ToClient_TakeMyGuildBenefit()
end

----------------------------------------------------------------------
-- 					길드 멤버 클릭시 메뉴창 팝업
----------------------------------------------------------------------
function HandleClickedGuildMenuButton( index )

	local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
	if nil == myGuildListInfo then
		return
	end
	
	local myGuildMemberInfo = myGuildListInfo:getMember(_selectIndex)
	if nil == myGuildMemberInfo then
		return
	end	
			
	local messageTitle		= "";
	local messageContent	= ""; 
	local yesFunction;
	local targetName		= myGuildMemberInfo:getName();
	local characterName		= myGuildMemberInfo:getCharacterName();
	local isOnlineMember	= myGuildMemberInfo:isOnline();
	
	if		(index == _UI_Menu_Button.Type_ChangeMaster)	then
	
		messageTitle 	= 	PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_DELEGATE_MASTER" )
		messageContent 	=	PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_DELEGATE_MASTER_QUESTION", "target", "'"..tostring(targetName).."'" )
		yesFunction		=	MessageBoxYesFunction_ChangeGuildMaster	
		--ToClient_RequestChangeGuildMaster( _selectIndex )

		local messageboxData	= { title = messageTitle, content = messageContent, functionYes = yesFunction, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData, "top")
		return
		
	elseif	(index == _UI_Menu_Button.Type_Deportation)		then
	
		messageTitle 	= PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_EXPEL_GUILDMEMBER" )
		messageContent 	=	"'"..tostring(targetName).."'".. PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_EXPEL_GUILDMEMBER_QUESTION" )
		yesFunction		=	MessageBoxYesFunction_ExpelMember
		--ToClient_RequestExpelMemberFromGuild( _selectIndex )
	
	elseif	(index == _UI_Menu_Button.Type_AppointCommander)then
	
		messageTitle 	= 	PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_APPOINT_GUILDSUBMASTER" )
		messageContent 	=	"'"..tostring(targetName).."'"..PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_APPOINT_GUILDSUBMASTER_QUESTION" )
		yesFunction		=	MessageBoxYesFunction_AppointCommander
		--ToClient_RequestChangeGuildMemberGrade( _selectIndex, 1 );

	elseif	(index == _UI_Menu_Button.Type_CancelAppoint)	then		
	
		messageTitle 	= 	PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_APPOINT_GUILDMEMBER" )
		messageContent 	=	"'"..tostring(targetName).."'".. PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_APPOINT_GUILDMEMBER_QUESTION" )
		yesFunction		=	MessageBoxYesFunction_CancelAppoint
		--ToClient_RequestChangeGuildMemberGrade( _selectIndex, 2 );

	elseif	(index == _UI_Menu_Button.Type_ProtectMember)	then
		local protectRate				= 10
		local currentProtectMemberCount = myGuildListInfo:getProtectGuildMemberCount()
		local maxProtectMemberCount		= math.floor((myGuildListInfo:getMemberCount()/protectRate) + 0.5) - 1
		messageTitle 	= 	PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_PROTECT_GUILDMEMBER" )
		-- messageContent 	=	PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_PROTECT_GUILDMEMBER_DESC" )
		messageContent 	=	PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_PROTECT_GUILDMEMBER_DESC")
		yesFunction		=	MessageBoxYesFunction_ProtectMember

		GuildListInfoPage._buttonListBG:SetShow(false)

		local messageboxData	= { title = messageTitle, content = messageContent, functionYes = yesFunction, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData, "top")
		return

	elseif	(index == _UI_Menu_Button.Type_CancelProtectMember)	then		

		messageTitle 	= 	PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_CANCEL_PROTECT_GUILDMEMBER" )
		messageContent 	=	PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_CANCEL_PROTECT_GUILDMEMBER_DESC" )
		yesFunction		=	MessageBoxYesFunction_CancelProtectMember

	elseif (index == _UI_Menu_Button.Type_PartyInvite) then
		local guildMemberPartyInvite = function()
			RequestParty_inviteCharacter( characterName )
		end
		messageTitle 	= 	PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS")

		GuildListInfoPage._buttonListBG:SetShow(false)

		if isOnlineMember then
			messageContent 	=	PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILDLIST_GUILDMEMBERPARTYINVITE_MSG", "targetName", characterName ) --"길드원 [<PAColor0xFFF26A6A>" .. targetName .. "<PAOldColor>]을(를) 파티로 초대합니다.\n길드원을 파티로 초대하려면 서로 같은 채널에 접속해 있어야합니다."
			local messageboxData	= { title = messageTitle, content = messageContent, functionYes = guildMemberPartyInvite, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
			MessageBox.showMessageBox(messageboxData, "middle")
			return
		else
			messageContent 	= PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_PARTYINVITE_NOTJOINMEMBER") -- "해당 길드원이 접속중이 아닙니다."
			local messageboxData	= { title = messageTitle, content = messageContent, functionYes = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
			MessageBox.showMessageBox(messageboxData, "middle")
			return
		end

	else
		UI.ASSERT( false, "작업해야합니다!" )
		return
	end

	GuildListInfoPage._buttonListBG:SetShow(false)

	local messageboxData	= { title = messageTitle, content = messageContent, functionYes = yesFunction, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData)
end

function HandleToolTipChannelName( isShow, index )
	local self = GuildListInfoPage
	local myGuildListInfo	= ToClient_GetMyGuildInfoWrapper()
	if nil == myGuildListInfo then
		return
	end
	local dataIndex			= tempGuildList[index+1].idx
	local myGuildMemberInfo	= myGuildListInfo:getMember( dataIndex )
	local guildMemberName	= myGuildMemberInfo:getCharacterName()
	local isOnline			= myGuildMemberInfo:isOnline()
	local temporaryWrapper	= getTemporaryInformationWrapper()
	local worldNo			= temporaryWrapper:getSelectedWorldServerNo()
	local channelName		= getChannelName(worldNo, myGuildMemberInfo:getServerNo() )

	if isOnline then
		name	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILDLIST_JOINCHANNEL_FOR", "guildMemberName", guildMemberName ) -- guildMemberName .. "님의 접속 채널"
		desc	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_CHANNEL_MEMBER", "channelName", channelName )
		control	= self._list[index]._charName
		registTooltipControl(control, Panel_Tooltip_SimpleText)
		if isShow == true then
			TooltipSimple_Show( control, name, desc )
		else
			TooltipSimple_Hide()
		end
	end
end

function MessageBoxYesFunction_ChangeGuildMaster()
	ToClient_RequestChangeGuildMemberGradeForMaster( _selectIndex )
	FGlobal_Notice_AuthorizationUpdate()
end

function MessageBoxYesFunction_ExpelMember()
	ToClient_RequestExpelMemberFromGuild( _selectIndex )
end

function MessageBoxYesFunction_AppointCommander()
	ToClient_RequestChangeGuildMemberGrade( _selectIndex, 1 );
	FGlobal_Notice_AuthorizationUpdate()
end

function MessageBoxYesFunction_CancelAppoint()
	ToClient_RequestChangeGuildMemberGrade( _selectIndex, 2 );
	FGlobal_Notice_AuthorizationUpdate()
end

function MessageBoxYesFunction_ProtectMember()
	ToClient_RequestChangeProtectMember( _selectIndex, true );
end

function MessageBoxYesFunction_CancelProtectMember()
	ToClient_RequestChangeProtectMember( _selectIndex, false );
end

-- 버튼 창에서 마우스 벗어날 시에 창닫기
function MouseOutGuildMenuButton()
	local self = GuildListInfoPage
	
	local sizeX = self._buttonListBG:GetSizeX();
	local sizeY = self._buttonListBG:GetSizeY();
	local posX	= self._buttonListBG:GetPosX();
	local posY	= self._buttonListBG:GetPosY();
	--local mousePosX = getMousePosX();
	--local mousePosY = getMousePosY();
	
	local xxxx = Panel_Window_Guild:GetPosX() + posX + 42
	local yyyy = Panel_Window_Guild:GetPosY() + posY + 95
	local mousePosX = getMousePosX() - Panel_Window_Guild:GetPosX() - _constCollectionX
	local mousePosY = getMousePosY() - Panel_Window_Guild:GetPosY() - _constCollectionY

	if( 	( xxxx <= getMousePosX()) and ( getMousePosX() <= (xxxx+sizeX) ) 
		and ( yyyy <= getMousePosY()) and ( getMousePosY() <= (yyyy+sizeY) ) ) then
		-- 영역 안에 있다.
	else
		self._buttonListBG:SetShow(false)
	end
end

----------------------------------------------------------------------
-- 			스크롤 버튼 사용시
----------------------------------------------------------------------
function GuildListMouseScrollEvent( isUpScroll )
	local memberCount = ToClient_GetMyGuildInfoWrapper():getMemberCount()

	UIScroll.ScrollEvent( GuildListInfoPage._scrollBar, isUpScroll, memberCount, memberCount, 0, 1 )

	GuildListInfoPage:UpdateData()
end

	
----------------------------------------------------------------------
-- { 정렬 관련

	function GuildListInfoPage:TitleLineReset()
		staticText_Grade		:SetText( PAGetString( Defines.StringSheet_RESOURCE, "GUILD_TEXT_POSITION" ) )
		staticText_Level		:SetText( PAGetString( Defines.StringSheet_RESOURCE, "GUILD_TEXT_LEVEL" ) )
		staticText_Class		:SetText( PAGetString( Defines.StringSheet_RESOURCE, "GUILD_TEXT_CLASS" ) )
		staticText_charName		:SetText( PAGetString( Defines.StringSheet_RESOURCE, "GUILD_TEXT_CHARNAME" ) )
		staticText_activity		:SetText( PAGetString( Defines.StringSheet_RESOURCE, "GUILD_TEXT_ACTIVITY" ) )
		staticText_contract		:SetText( PAGetString( Defines.StringSheet_RESOURCE, "GUILD_TEXT_HIRE" ) )
	end
	function GuildListInfoPage:SetGuildList()	-- 길드원 리스트 기본 배열 생성.
		-- 정렬 : 직책, 캐릭터명, 레벨
		local myGuildListInfo	= ToClient_GetMyGuildInfoWrapper()
		if nil == myGuildListInfo then
			return
		end
		local memberCount		= myGuildListInfo:getMemberCount()
		tempGuildList = {}
		for index = 1, memberCount do
			local myGuildMemberInfo = myGuildListInfo:getMember( index-1 )
			tempGuildList[index] = {
				idx			= index-1,
				online		= myGuildMemberInfo:isOnline(),
				grade		= myGuildMemberInfo:getGrade(),
				level		= myGuildMemberInfo:getLevel(),
				class		= myGuildMemberInfo:getClassType(),
				name		= myGuildMemberInfo:getName(),
				ap			= Int64toInt32(myGuildMemberInfo:getTotalActivity()),
				expiration	= myGuildMemberInfo:getContractedExpirationUtc(),
			}
		end
	end

	local guildListCompareGrade = function ( w1, w2 )
		if true == _listSort.grade then -- 처리하는 것들이 있어서 반대로 셈한다.
			if w1.grade < w2.grade then
				return true
			end
		else
			if w2.grade < w1.grade then
				return true
			end
		end
	end
	local guildListCompareLev = function ( w1, w2 )
		if true == _listSort.level then -- 처리하는 것들이 있어서 반대로 셈한다.
			if w2.level < w1.level then
				return true
			end
		else
			if w1.level < w2.level then
				return true
			end
		end
	end
	local guildListCompareClass = function ( w1, w2 )
		if true == _listSort.class then -- 처리하는 것들이 있어서 반대로 셈한다.
			if w2.class < w1.class then
				return true
			end
		else
			if w1.class < w2.class then
				return true
			end
		end
	end
	local guildListCompareName = function ( w1, w2 )
		if true == _listSort.name then -- 처리하는 것들이 있어서 반대로 셈한다.
			if w1.name < w2.name then
				return true
			end
		else
			if w2.name < w1.name then
				return true
			end
		end
	end
	local guildListCompareAp = function ( w1, w2 )
		if true == _listSort.ap then -- 처리하는 것들이 있어서 반대로 셈한다.
			if w2.ap < w1.ap then
				return true
			end
		else
			if w1.ap < w2.ap then
				return true
			end
		end
	end
	local guildListCompareExpiration = function ( w1, w2 )
		if true == _listSort.expiration then -- 처리하는 것들이 있어서 반대로 셈한다.
			if w2.expiration < w1.expiration then
				return true
			end
		else
			if w1.expiration < w2.expiration then
				return true
			end
		end
	end

	function HandleClicked_GuildListSort( sortType )	-- 정렬 버튼.
		_selectSortType = sortType
		GuildListInfoPage:TitleLineReset()
		if 0 == sortType then
			if false == _listSort.grade then
				staticText_Grade:SetText( PAGetString( Defines.StringSheet_RESOURCE, "GUILD_TEXT_POSITION" ) .. "▲" )
				_listSort.grade = true
			else
				staticText_Grade:SetText( PAGetString( Defines.StringSheet_RESOURCE, "GUILD_TEXT_POSITION" ) .. "▼" )
				_listSort.grade = false
			end
			table.sort( tempGuildList, guildListCompareGrade )	
		elseif 1 == sortType then
			if false == _listSort.level then
				staticText_Level:SetText( PAGetString( Defines.StringSheet_RESOURCE, "GUILD_TEXT_LEVEL" ) .. "▲" )
				_listSort.level = true
			else
				staticText_Level:SetText( PAGetString( Defines.StringSheet_RESOURCE, "GUILD_TEXT_LEVEL" ) .. "▼" )
				_listSort.level = false
			end
			table.sort( tempGuildList, guildListCompareLev )	
		elseif 2 == sortType then
			if false == _listSort.class then
				staticText_Class:SetText( PAGetString( Defines.StringSheet_RESOURCE, "GUILD_TEXT_CLASS" ) .. "▲" )
				_listSort.class = true
			else
				staticText_Class:SetText( PAGetString( Defines.StringSheet_RESOURCE, "GUILD_TEXT_CLASS" ) .. "▼" )
				_listSort.class = false
			end
			table.sort( tempGuildList, guildListCompareClass )
		elseif 3 == sortType then
			if false == _listSort.name then
				staticText_charName:SetText( PAGetString( Defines.StringSheet_RESOURCE, "GUILD_TEXT_CHARNAME" ) .. "▲" )
				_listSort.name = true
			else
				staticText_charName:SetText( PAGetString( Defines.StringSheet_RESOURCE, "GUILD_TEXT_CHARNAME" ) .. "▼" )
				_listSort.name = false
			end
			table.sort( tempGuildList, guildListCompareName )
		elseif 4 == sortType then
			if false == _listSort.ap then
				staticText_activity:SetText( PAGetString( Defines.StringSheet_RESOURCE, "GUILD_TEXT_ACTIVITY" ) .. "▲" )
				_listSort.ap = true
			else
				staticText_activity:SetText( PAGetString( Defines.StringSheet_RESOURCE, "GUILD_TEXT_ACTIVITY" ) .. "▼" )
				_listSort.ap = false
			end
			table.sort( tempGuildList, guildListCompareAp )
		elseif 5 == sortType then
			if false == _listSort.expiration then
				staticText_contract:SetText( PAGetString( Defines.StringSheet_RESOURCE, "GUILD_TEXT_HIRE" )  .. "▲" )
				_listSort.expiration = true
			else
				staticText_contract:SetText( PAGetString( Defines.StringSheet_RESOURCE, "GUILD_TEXT_HIRE" )  .. "▼" )
				_listSort.expiration = false
			end
			table.sort( tempGuildList, guildListCompareExpiration )
		end
		GuildListInfoPage:UpdateData()
	end

	function GuildListInfoPage:GuildListSortSet()
		GuildListInfoPage:TitleLineReset()
		staticText_Grade:SetText( PAGetString( Defines.StringSheet_RESOURCE, "GUILD_TEXT_POSITION" ) .. "▲" )
		_listSort.grade = true
		table.sort( tempGuildList, guildListCompareGrade )
	end

	function GuildListInfoPage:updateSort()
		if 0 == _selectSortType then
			table.sort( tempGuildList, guildListCompareGrade )
		elseif 1 == _selectSortType then
			table.sort( tempGuildList, guildListCompareLev )
		elseif 2 == _selectSortType then
			table.sort( tempGuildList, guildListCompareClass )
		elseif 3 == _selectSortType then
			table.sort( tempGuildList, guildListCompareName )
		elseif 4 == _selectSortType then
			table.sort( tempGuildList, guildListCompareAp )
		elseif 5 == _selectSortType then
			table.sort( tempGuildList, guildListCompareExpiration )
		end
	end
-- }
----------------------------------------------------------------------


----------------------------------------------------------------------
-- 		길드원 현황 업데이트
----------------------------------------------------------------------

function GuildListInfoPage:UpdateData()
	GuildListInfoPage:SetGuildList()
	GuildListInfoPage:updateSort()

	local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
	
	if nil == myGuildListInfo then
		return
	end
	
	local businessFunds_s64		= myGuildListInfo:getGuildBusinessFunds_s64()
	local guildGrade			= myGuildListInfo:getGuildGrade()
	GuildListInfoPage._textBusinessFunds:SetText( makeDotMoney(businessFunds_s64) );
	
	local memberCount		= myGuildListInfo:getMemberCount()
	local isGuildMaster		= getSelfPlayer():get():isGuildMaster()
	local isGuildSubMaster	= getSelfPlayer():get():isGuildSubMaster()

	contentSizeY = 0	-- 초기화
	for index = 0, _constGuildListMaxCount - 1, 1 do
		self._list[index]:SetShow( false )
	end

	for index = 0, memberCount - 1, 1 do
		local dataIdx = tempGuildList[index+1].idx	-- 새로운 배열에 저장된 정렬을 기반으로 한다.
		local myGuildMemberInfo = myGuildListInfo:getMember( dataIdx )
		if( nil == myGuildMemberInfo ) then
			_PA_ASSERT( false, "멤버 데이터가 없을 수 있나? 확인 바랍니다.");
			return;
		end
		local gradeType = myGuildMemberInfo:getGrade()
		if 0 == gradeType then
			self._list[index]._grade:SetText(PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDMASTER" ))
		elseif 1 == gradeType then
			self._list[index]._grade:SetText(PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDSUBMASTER" ))
		elseif 2 == gradeType then
			self._list[index]._grade:SetText(PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDMEMBER" ))
		end
		
		if myGuildMemberInfo:isSelf() then
			self._list[index]:SetIgnore(true)
		else
			self._list[index]:SetIgnore(false)
		end
			
--{		파티 초대가 들어가면서 모든 등급에 ignore처리가 필요가 없어졌따!
		-- if isGuildMaster then
		-- 	if (1 == gradeType) or (2 == gradeType) then
		-- 	end
		-- elseif isGuildSubMaster then
		-- 	if (2 == gradeType) then
				-- self._list[index]:SetIgnore(false)
		-- 	end
		-- end
--}
		self._list[index]._level:SetText( myGuildMemberInfo:getLevel() )
			
		local classType = myGuildMemberInfo:getClassType()
		if UI_Class.ClassType_Warrior == classType then 
			self._list[index]._class:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_WARRIOR" ))
		elseif UI_Class.ClassType_Ranger == classType then
			self._list[index]._class:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_RANGER" ))
		elseif UI_Class.ClassType_Sorcerer == classType then
			self._list[index]._class:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_SORCERER" ))
		elseif UI_Class.ClassType_Giant == classType then
			self._list[index]._class:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_GIANT" ))
		elseif UI_Class.ClassType_Tamer == classType then
			self._list[index]._class:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_TAMER" ))
		elseif UI_Class.ClassType_BladeMaster == classType then
			self._list[index]._class:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_BLADEMASTER" ))
		elseif UI_Class.ClassType_Valkyrie == classType then
			self._list[index]._class:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_VALKYRIE") )
		elseif UI_Class.ClassType_BladeMasterWomen == classType then
			self._list[index]._class:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_BLADEMASTERWOMAN") )
		elseif UI_Class.ClassType_Kunoichi == classType then
			self._list[index]._class:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_KUNOICHI" ))
		elseif UI_Class.ClassType_Wizard == classType then
			self._list[index]._class:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_WIZARD" ))
		elseif UI_Class.ClassType_WizardWomen == classType then
			self._list[index]._class:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_WIZARDWOMAN" ))
		elseif UI_Class.ClassType_NinjaWomen == classType then
			self._list[index]._class:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_NINJAWOMEN" ) )
		elseif UI_Class.ClassType_NinjaMan == classType then
			self._list[index]._class:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_NINJAMAN" ) )
		end
		
		-- local contributedTendency = myGuildMemberInfo:getContributedTendency()

		local maxWp				= myGuildMemberInfo:getMaxWp()
		if 0 == maxWp then
			maxWp = "-"
		end
		local explorationPoint	= myGuildMemberInfo:getExplorationPoint()
		self._list[index]._contributedTendency:SetText( maxWp .. "/" .. explorationPoint )
		
		if myGuildMemberInfo:isOnline() == true then
			local usableActivity = myGuildMemberInfo:getUsableActivity()
			if 10000 < usableActivity then
				usableActivity = 10000
			end
			local textActivity = tostring(myGuildMemberInfo:getTotalActivity()).."(<PAColor0xfface400>+".. tostring( usableActivity ).."<PAOldColor>)"
			self._list[index]._activity:SetText( textActivity )
			
			-- local tendencyColor = UI_color.C_FFC4BEBE
			-- if 0 < contributedTendency then
			-- 	tendencyColor = UI_color.C_FF2478FF
			-- elseif contributedTendency < 0 then
			-- 	tendencyColor = UI_color.C_FFFF0000
			-- end
			-- self._list[index]._contributedTendency:SetFontColor( tendencyColor )
			self._list[index]._activity:SetFontColor( UI_color.C_FFC4BEBE )
			self._list[index]._level:SetFontColor( UI_color.C_FFC4BEBE )
			self._list[index]._class:SetFontColor( UI_color.C_FFC4BEBE )
			self._list[index]._contributedTendency:SetFontColor( UI_color.C_FFC4BEBE )
			
			if myGuildMemberInfo:isSelf() then
				self._list[index]._charName:SetFontColor( UI_color.C_FFEF9C7F )
			else
				self._list[index]._charName:SetFontColor( UI_color.C_FFC4BEBE )	
			end

			self._list[index]._charName:SetText( myGuildMemberInfo:getName().." ("..myGuildMemberInfo:getCharacterName()..")" )
		else
			local textActivity = tostring(myGuildMemberInfo:getTotalActivity()).."(+".. tostring(myGuildMemberInfo:getUsableActivity())..")"
			self._list[index]._activity:SetText( textActivity )
			self._list[index]._contributedTendency:SetFontColor( UI_color.C_FF515151 )
			self._list[index]._activity:SetFontColor( UI_color.C_FF515151 )
			self._list[index]._level:SetFontColor( UI_color.C_FF515151 )
			self._list[index]._class:SetFontColor( UI_color.C_FF515151 )
			self._list[index]._charName:SetFontColor( UI_color.C_FF515151 )
			self._list[index]._charName:SetText(myGuildMemberInfo:getName().." ( - )")

			self._list[index]._level:SetText("-")
			self._list[index]._class:SetText("-")
		end

		-- 접속 여부와 상관 없이 추방/임명 등 기능의 동작을 막아야 함.
		-- self._list[index]._grade				:addInputEvent("Mouse_LUp", "HandleClickedGuildMemberMenuButton( " .. index .. " )")
		-- self._list[index]._level				:addInputEvent("Mouse_LUp", "HandleClickedGuildMemberMenuButton( " .. index .. " )")
		-- self._list[index]._class				:addInputEvent("Mouse_LUp", "HandleClickedGuildMemberMenuButton( " .. index .. " )")
		self._list[index]._charName				:addInputEvent("Mouse_LUp", "HandleClickedGuildMemberMenuButton( " .. index .. " )")
		-- self._list[index]._activity				:addInputEvent("Mouse_LUp", "HandleClickedGuildMemberMenuButton( " .. index .. " )")
		-- self._list[index]._contributedTendency	:addInputEvent("Mouse_LUp", "HandleClickedGuildMemberMenuButton( " .. index .. " )")

		local contractAble = myGuildMemberInfo:getContractableUtc()
		local expiration = myGuildMemberInfo:getContractedExpirationUtc()

		local isContractState = 0

		if ( 0 < Int64toInt32(getLeftSecond_TTime64(expiration)) ) then	-- 계약기간 중 ( 빨간 색 )
			isContractState = 1
			if ( Int64toInt32(getLeftSecond_TTime64(contractAble)) <= 0 ) then		-- 재계약 가능 여부(노란색)		
				isContractState = 0
			end	
		else	-- 만료( 파란 색 )
			isContractState = 2
		end

		GuildListControl_ChangeTexture_Expiration( self._list[index]._contractBtn, isContractState )
 		self._list[index]._contractBtn:addInputEvent( "Mouse_On", 	"_guildListInfoPage_MandateTooltipShow( true, " .. isContractState .. ", " .. index .. ")")
		self._list[index]._contractBtn:addInputEvent( "Mouse_Out", 	"_guildListInfoPage_MandateTooltipShow( false, " .. isContractState .. ", " .. index .. ")")
		self._list[index]._contractBtn:setTooltipEventRegistFunc("_guildListInfoPage_MandateTooltipShow( true, " .. isContractState .. ", " .. index .. ")")

		self._list[index]._contractBtn:addInputEvent("Mouse_LUp", "HandleClickedGuildMemberContractButton( " .. index .. " )")
		self._list[index]:SetShow(true)

		-- self._list[index]:SetShow(true) 는 전부를 켜버리니까;; 그 뒤에;
		self._list[index]._guardHim:SetShow( myGuildMemberInfo:isProtectable() )	-- 보호상태

		-- 길드 등급에 따라 계약서 버튼을 노출.
		if 0 == ToClient_GetMyGuildInfoWrapper():getGuildGrade() then
			self._list[index]._contractBtn:SetIgnore( true )
			self._list[index]._contractBtn:SetMonoTone( true )
		else
			self._list[index]._contractBtn:SetIgnore( false )
			self._list[index]._contractBtn:SetMonoTone( false )
		end

		contentSizeY = contentSizeY + self._list[index]._charName:GetSizeY() + 2

		btn_GuildMasterMandate:addInputEvent("Mouse_LUp", "HandleClicked_GuildMasterMandate( " .. index .. " )")
	end
	
	self._contentGuildList:SetSize( self._frameGuildList:GetSizeX(), contentSizeY )	-- 프레임 컨텐츠 영역 사이즈 지정.

	if ( contentSizeY <= frameSizeY ) then
		self._scrollBar:SetShow( false )
	else
		self._scrollBar:SetShow( true )
	end
	if not notice_title:GetShow() then
		GuildMainInfo_Hide()
	end
	self._frameGuildList:UpdateContentScroll()	-- 스크롤 갱신
	self._frameGuildList:UpdateContentPos()		-- 내용 갱신
end
-- 길드원 온라인 인원 수를 체크하기 위해서 존재한다.(G를 눌러 길드창을 열었을 때 한번 실행.(실시간 갱신 x))
function FGlobal_GuildListOnlineCheck()
	local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
	if nil == myGuildListInfo then
		return
	end

	local memberCount		= myGuildListInfo:getMemberCount()
	for index = 0, memberCount - 1, 1 do
		local myGuildMemberInfo = myGuildListInfo:getMember( index )
		if nil == myGuildMemberInfo then
			return
		end

		if myGuildMemberInfo:isOnline() == true then
			_onlineGuildMember = _onlineGuildMember + 1
		end
	end
end

-- 길드 마스터 위임 받기
function HandleClicked_GuildMasterMandate( index )
	local self = GuildListInfoPage
	if not ToClient_IsAbleChangeMaster() then
		return
	end

	ToClient_RequestChangeGuildMaster( index )
	self:UpdateData()
end

function GuildListControl_ChangeTexture_Expiration( control, state )
	control:ChangeTextureInfoName( "new_ui_common_forlua/window/guild/guild_00.dds" )
	if 2 == state then	-- 계약 만료.(파란색)
		local x1, y1, x2, y2 = setTextureUV_Func( control, 376, 24, 398, 46 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture( control:getBaseTexture() )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 399, 24, 421, 46 )
		control:getOnTexture():setUV(  x1, y1, x2, y2  )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 422, 24, 444, 46 )
		control:getClickTexture():setUV(  x1, y1, x2, y2  )
	elseif 0 == state then	-- 재계약 가능(노란색)
		local x1, y1, x2, y2 = setTextureUV_Func( control, 422, 47, 444, 69 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture( control:getBaseTexture() )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 445, 47, 467, 69 )
		control:getOnTexture():setUV(  x1, y1, x2, y2  )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 468, 47, 490, 69 )
		control:getClickTexture():setUV(  x1, y1, x2, y2  )
	elseif 1 == state then	-- 계약 기간중.(빨간색)
		local x1, y1, x2, y2 = setTextureUV_Func( control, 376, 1, 398, 23 )
		control:getBaseTexture():setUV(  x1, y1, x2, y2  )
		control:setRenderTexture( control:getBaseTexture() )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 399, 1, 421, 23 )
		control:getOnTexture():setUV(  x1, y1, x2, y2  )
		local x1, y1, x2, y2 = setTextureUV_Func( control, 422, 1, 444, 23 )
		control:getClickTexture():setUV(  x1, y1, x2, y2  )
	end
end

----------------------------------------------------------------------
-- 					길드 현황을 켜고 끄는 함수 (Panel_Guild.lua 에서 사용)
----------------------------------------------------------------------

function GuildListInfoPage:Show()
	if false == self._frameDefaultBG:GetShow() then
		self._frameDefaultBG:SetShow( true )	
		self._scrollBar:SetControlPos( 0 )
		self:SetGuildList()
		_selectSortType = 0		-- 기본 정렬을 직책으로 하기 위해.
		self:GuildListSortSet()	-- 기본 정렬을 직책으로 하기 위해.
		self:UpdateData()
		FGlobal_Notice_Update()
	end
end

function GuildListInfoPage:Hide()
	if true == self._frameDefaultBG:GetShow() then
		self._frameDefaultBG:SetShow( false )
		if ( AllowChangeInputMode() ) then
			if( UI.checkShowWindow() ) then
				UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode) 
			else
				UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
			end
		else
			SetFocusChatting()
		end
		ClearFocusEdit()
	end
end

function FGlobal_GuildListScrollTop()
	local self = GuildListInfoPage
	self._scrollBar:SetControlTop()
end

--------------------------------------------------------------------------------
-- 길드 지원금 관련 함수
--------------------------------------------------------------------------------
function HandleClicked_SetIncentive()
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
	SetFocusEdit( incentive_InputMoney );
	inputGuildDepositNum_s64	= toInt64(0, 0) -- 어떤 값을 넣어도 초기화 되는 현상 때문에 리셋 시킨다.
	incentive_InputMoney:SetEditText('', true)
	incentive_InputMoney:SetNumberMode( true )
end
function FGlobal_GuildIncentive_Close()
	if( not Panel_GuildIncentive:GetShow() ) then
		return;
	end
	
	ClearFocusEdit()
	Panel_GuildIncentive:SetShow( false )
	if ( AllowChangeInputMode() ) then
		if( UI.checkShowWindow() ) then
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode) 
		else
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
		end
	else
		SetFocusChatting()
	end
end
function HandleClicked_GuildIncentive_Close()
	if( not Panel_GuildIncentive:GetShow() ) then
		return;
	end
	
	ClearFocusEdit()
	if ( AllowChangeInputMode() ) then
		if( UI.checkShowWindow() ) then
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_UiMode) 
		else
			UI.Set_ProcessorInputMode(IM.eProcessorInputMode_GameMode)
		end
	else
		SetFocusChatting()
	end
	Panel_GuildIncentive:SetShow( false )
end

function HandleClicked_GuildIncentive_Send()
	local tempMoney = tonumber( incentive_InputMoney:GetEditText() )
 	
	if( nil == tempMoney) or ( tempMoney <= 0) or (tempMoney == "") then  -- 입력 받은 값이 0보다 작거나 같으면 조건 추가. by 태곤
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_PERFORM_MESSAGE_0") )
		ClearFocusEdit()
		return;
	end
	
	if( 0 == _incentivePanelType ) then
	
	else
		ToClient_DepositToGuildWareHouse( tempMoney );
	end

	ClearFocusEdit()
	FGlobal_GuildIncentive_Close()
end

function FGlobal_SaveGuildMoney_Send()
	HandleClicked_GuildIncentive_Send()
end

function FGlobal_CheckSaveGuildMoneyUiEdit(targetUI)
	return ( nil ~= targetUI ) and ( targetUI:GetKey() == incentive_InputMoney:GetKey() )
end

function FGlobal_GuildDeposit_InputCheck()
	for idx,val in ipairs(numberKeyCode) do
		if isKeyDown_Once( val ) then
			if (idx > 10) then
				_GuildDeposit_InputCheck_Command( idx - 11 )
			else
				_GuildDeposit_InputCheck_Command( idx - 1 )
			end
		end
	end
	
	if isKeyDown_Once( VCK.KeyCode_BACK ) then
		_GuildDeposit_InputCheck_BackSpaceCommand()
	end
end

function _GuildDeposit_InputCheck_Command( number )
	local str = tostring( inputGuildDepositNum_s64 );
	local newStr = ( str..tostring(number) )
	local s64_newNumber	= tonumber64( newStr )
	local s64_MAX		= inputGuildDepositMaxNum_s64
	if( s64_MAX < s64_newNumber ) then
		inputGuildDepositNum_s64 = inputGuildDepositMaxNum_s64
	else
		inputGuildDepositNum_s64 = s64_newNumber;
	end
	incentive_InputMoney:SetEditText( tostring( inputGuildDepositNum_s64 ), true );	
end

function _GuildDeposit_InputCheck_BackSpaceCommand()
	local str = tostring( inputGuildDepositNum_s64 );
	local length = strlen(str);
	local newStr = "";
	
	if 1 < length  then
		newStr = substring( str, 1, length-1 );
		inputGuildDepositNum_s64= tonumber64(newStr);	
	else
		newStr = "0";
		inputGuildDepositNum_s64 = Defines.s64_const.s64_0;
	end
	
	incentive_InputMoney:SetEditText( newStr, true );
end

function FGlobal_GuildMenuButtonHide()
	GuildListInfoPage._buttonListBG:SetShow( false )
end

----------------------------------------------------------------------------------------------------------------
--									클라이언트에서 보내는 이벤트
----------------------------------------------------------------------------------------------------------------
registerEvent("FromClient_ResponseGuildMasterChange",		"FromClient_ResponseGuildMasterChange")
registerEvent("FromClient_ResponseChangeGuildMemberGrade",	"FromClient_ResponseChangeGuildMemberGrade")
registerEvent("FromClient_RequestExpelMemberFromGuild",		"FromClient_RequestExpelMemberFromGuild")
registerEvent("FromClient_RequestChangeGuildMemberGrade",	"FromClient_RequestChangeGuildMemberGrade")
registerEvent("FromClient_ResponseChangeProtectGuildMember","FromClient_ResponseChangeProtectGuildMember")

function FromClient_ResponseGuildMasterChange(userNo, targetNo)
	local userNum = Int64toInt32( getSelfPlayer():get():getUserNo() )
	
	if userNum == Int64toInt32(userNo) then
		Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_MASTERCHANGE_MESSAGE_0") )
	elseif userNum == Int64toInt32(targetNo) then
		Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_MASTERCHANGE_MESSAGE_1") )
	end
	GuildListInfoPage:UpdateData()
end

function FromClient_ResponseChangeGuildMemberGrade(targetNo, grade)
	local userNum = Int64toInt32( getSelfPlayer():get():getUserNo() )

	if userNum == Int64toInt32(targetNo) then
		if 1 == grade then
			Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_GRADECHANGE_MESSAGE_0") )
		elseif 2 == grade then
			Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_GRADECHANGE_MESSAGE_1") )
		end
	end
	GuildServantList_Close()
	FGlobal_Window_Servant_Update()
	GuildListInfoPage:UpdateData()
end

function FromClient_ResponseChangeProtectGuildMember(targetNo, isProtectable)
	local userNum = Int64toInt32( getSelfPlayer():get():getUserNo() )

	if userNum == Int64toInt32(targetNo) then
		if true == isProtectable then
			Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_PROTECT_GUILDMEMBER_MESSAGE_0") )
		else
			Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_PROTECT_GUILDMEMBER_MESSAGE_1") )
		end
	end
	GuildServantList_Close()
	FGlobal_Window_Servant_Update()
	GuildListInfoPage:UpdateData()
end

function FromClient_RequestExpelMemberFromGuild()
	--Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_EXPELMEMBER_MESSAGE") )
	if( true == Panel_Window_Guild:GetShow() ) then
		GuildListInfoPage:UpdateData()
	elseif ( true == Panel_ClanList:GetShow() ) then
		 FGlobal_ClanList_Update()
	end
	GuildServantList_Close()
	FGlobal_Window_Servant_Update()
end

function FromClient_RequestChangeGuildMemberGrade(grade)
	if 1 == grade then
		Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_GRADECHANGE_MESSAGE_2") )
	elseif 2 == grade then
		Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_GRADECHANGE_MESSAGE_3") )
	end
	GuildServantList_Close()
	FGlobal_Window_Servant_Update()
	GuildListInfoPage:UpdateData()
end