Panel_Guild_IncentiveOption:SetShow( false )
Panel_Guild_IncentiveOption:ActiveMouseEventEffect(true)
Panel_Guild_IncentiveOption:setMaskingChild(true)
Panel_Guild_IncentiveOption:setGlassBackground(true)
Panel_Guild_IncentiveOption:SetDragEnable( true )
Panel_Guild_IncentiveOption:SetDragAll( true )

local UCT 						= CppEnums.PA_UI_CONTROL_TYPE

local	maxGuildList			= 20							-- 한 프레임에 노출 가능한 길드원 수
local	maxIncentiveGrade		= 4								-- 인센티브 구분 등급 수
local	_guildList				= {}
local   _selectedMemberIndex    = 0;


local	_frameGuildList			= UI.getChildControl( Panel_Guild_IncentiveOption, "Frame_GuildList" )
local	_contentGuildList		= UI.getChildControl( _frameGuildList, "Frame_1_Content" )
local	_scroll					= UI.getChildControl( _frameGuildList, "VerticalScroll" )
	
local	_guildMoney				= UI.getChildControl( Panel_Guild_IncentiveOption, "StaticText_GuildMoney_Value" )
local	_totalIncentiveValue	= UI.getChildControl( Panel_Guild_IncentiveOption, "StaticText_Incentive_Value" )
local	_leftTime				= UI.getChildControl( Panel_Guild_IncentiveOption, "StaticText_Incentive_LeftTime" )
local	_leftTimeValue			= UI.getChildControl( Panel_Guild_IncentiveOption, "StaticText_Incentive_LeftTimeValue" )
local	_btnIncentive			= UI.getChildControl( Panel_Guild_IncentiveOption, "Button_Incentive" )
local	_btnClose				= UI.getChildControl( Panel_Guild_IncentiveOption, "Button_WinClose" )
local	_btnQuestion			= UI.getChildControl( Panel_Guild_IncentiveOption, "Button_Question" )

_btnIncentive	:addInputEvent( "Mouse_LUp",	"Give_Incentive()" )											-- 인센티브 지급 버튼
_btnClose		:addInputEvent( "Mouse_LUp",	"Panel_GuildIncentiveOption_Close()" )							-- 닫기
_btnQuestion	:addInputEvent(	"Mouse_LUp",	"Panel_WebHelper_ShowToggle( \"PanelGuild\" )")					-- 물음표 좌클릭
_btnQuestion	:addInputEvent(	"Mouse_On",		"HelpMessageQuestion_Show( \"PanelGuild\", \"true\")")			-- 물음표 마우스오버
_btnQuestion	:addInputEvent(	"Mouse_Out",	"HelpMessageQuestion_Show( \"PanelGuild\", \"false\")")			-- 물음표 마우스아웃

local Guild_Incentive =
{
	_memberGrade				= UI.getChildControl( Panel_Guild_IncentiveOption, "StaticText_C_Grade" ),				-- 직위
	_memberName					= UI.getChildControl( Panel_Guild_IncentiveOption, "StaticText_C_CharName" ),				-- 캐릭명
	_memberContribution			= UI.getChildControl( Panel_Guild_IncentiveOption, "StaticText_C_ContributedTendency" ),	-- 활동량
	_memberIncentiveValue		= UI.getChildControl( Panel_Guild_IncentiveOption, "StaticText_C_IncentiveValue" ),		-- 분배금
	_comboboxRank				= UI.getChildControl( Panel_Guild_IncentiveOption, "Combobox_Destination" )				-- 분배 등급
}

Guild_Incentive._memberGrade:SetShow(false);
Guild_Incentive._memberName:SetShow(false);
Guild_Incentive._memberContribution:SetShow(false);
Guild_Incentive._memberIncentiveValue:SetShow(false);
Guild_Incentive._comboboxRank:SetShow(false);

local	_ySize					= Guild_Incentive._memberGrade:GetSizeY()
local	frameTextGap			= 10
local 	_memberCtrlCount		= 0

function Guild_Incentive:ResetControl()

	local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
	if nil == myGuildListInfo then
		return
	end
	
	_guildMoney:SetText( 0 .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_INCENTIVE_MONEY") )
	
	_memberCtrlCount = myGuildListInfo:getMemberCount()

	if ( maxGuildList < _memberCtrlCount ) then
		_scroll:SetShow( true )
	else
		_scroll:SetShow( false )
	end
	
	-- 새로 생성해 주기전에 지우기
	_contentGuildList:DestroyAllChild()
	
	-- 프레임 리사이징
	-- _contentGuildList:SetSize( _contentGuildList:GetSizeX(), Guild_Incentive._memberGrade:GetSizeY() * _memberCtrlCount + frameTextGap * ( _memberCtrlCount - 1) )
	
	-- 길드원 항목 업데이트
	for i = 1, _memberCtrlCount do
		
		local index = i-1
	
		-- 필 수!!!!!!
		_guildList[index] = {}
		
		_guildList[index]._memberGrade			= UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT,	_contentGuildList, "StaticText_Grade_".. i )
		_guildList[index]._memberName			= UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT,	_contentGuildList, "StaticText_MemberName_".. i )
		_guildList[index]._memberContribution	= UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT,	_contentGuildList, "StaticText_MemberContribution_".. i )
		_guildList[index]._memberIncentiveValue = UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT,	_contentGuildList, "StaticText_memberIncentiveValue_".. i )
		_guildList[index]._comboboxRank			= UI.createControl( UCT.PA_UI_CONTROL_COMBOBOX,		_contentGuildList, "Combobox_Rank_".. i )

		CopyBaseProperty( Guild_Incentive._memberGrade,				_guildList[index]._memberGrade )
		CopyBaseProperty( Guild_Incentive._memberName,				_guildList[index]._memberName )
		CopyBaseProperty( Guild_Incentive._memberContribution,		_guildList[index]._memberContribution )
		CopyBaseProperty( Guild_Incentive._memberIncentiveValue,	_guildList[index]._memberIncentiveValue )
		CopyBaseProperty( Guild_Incentive._comboboxRank,			_guildList[index]._comboboxRank )
		
		local guildMemberInfo = myGuildListInfo:getMember( i-1 )
		local gradeType = guildMemberInfo:getGrade()
		local gradeValue = ""
		if ( 0 == gradeType ) then
			gradeValue = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDMASTER" )
		elseif ( 1 == gradeType ) then
			gradeValue = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDSUBMASTER" )
		elseif ( 2 == gradeType ) then
			gradeValue = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDMEMBER" )
		end
		
		_guildList[index]._memberGrade			:SetText( gradeValue )
		_guildList[index]._memberName			:SetText( guildMemberInfo:getName().. " (" ..guildMemberInfo:getCharacterName().. ")" )
		
		local tempActivityText = "0" -- guildMemberInfo:getTotalActivity().."(+"..guildMemberInfo:getTotalActivity()..")";
		_guildList[index]._memberContribution	:SetText( tempActivityText )
	
		local posY = 0;
		posY = ( _ySize + frameTextGap/2 ) * ( index ) + frameTextGap 
		
		_guildList[index]._memberGrade:SetPosY(posY) 
		_guildList[index]._memberGrade:SetShow(true)
		
		_guildList[index]._memberName:SetPosY(posY)				
		_guildList[index]._memberName:SetShow(true)				
		
		_guildList[index]._memberContribution:SetPosY(posY)	
		_guildList[index]._memberContribution:SetShow(true)	
		
		_guildList[index]._memberIncentiveValue:SetPosY(posY) 
		_guildList[index]._memberIncentiveValue:SetShow(true) 
		
		_guildList[index]._comboboxRank:SetPosY(posY)		
		_guildList[index]._comboboxRank:SetShow(true)		
		
		_guildList[index]._comboboxRank:DeleteAllItem()
		
		for i = 1, maxIncentiveGrade do
			_guildList[index]._comboboxRank:AddItem( i )
		end

		_guildList[index]._comboboxRank:SetText( 1 )
		_guildList[index]._comboboxRank:addInputEvent( "Mouse_LUp", "click_Incentive_GradeList("..index..")" )
		_guildList[index]._comboboxRank:GetListControl():addInputEvent( "Mouse_LUp", "Set_Incentive_Grade("..index..")"  )
		
	end
	
	_frameGuildList:UpdateContentScroll()
	_scroll:SetControlTop()
	_frameGuildList:UpdateContentPos()
	
end


function Guild_Incentive:UpdateData()

	local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
	if nil == myGuildListInfo then
		return
	end

	local businessFunds = myGuildListInfo:getGuildBusinessFunds_s64()
	_guildMoney:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_INCENTIVE_BUSINESSFUNDS", "businessFunds", makeDotMoney(businessFunds) ) ) -- makeDotMoney(businessFunds) .. " 실버"
	
	local totalMoney64 = ToClient_getGuildTotalIncentiveMoney_s64()
	_totalIncentiveValue:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_INCENTIVE_TOTALMONEY32", "totalMoney32", makeDotMoney(totalMoney64) ) ) -- makeDotMoney(totalMoney64) .. " 실버"
	
	local memberCount = myGuildListInfo:getMemberCount()
	
	local leftTime = myGuildListInfo:getIncentiveDate()
	
	if 0 < Int64toInt32(leftTime) then
		local lefttimeText = convertStringFromDatetime(getLeftSecond_TTime64(leftTime));
		_leftTime		:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_INCENTIVE_LEFTTIMETEXT", "lefttimeText", lefttimeText ) ) -- "( 남은 지급 시간 : " .. lefttimeText .. " )")
		_leftTime		:SetShow( true )
		_leftTimeValue	:SetShow( false )
	else
		_leftTimeValue	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_INCENTIVE_LEFTTIMEVALUE") ) -- "지급 가능" )
		_leftTimeValue	:SetShow( true )
		_leftTime		:SetShow( false )
	end	
		
	-- 길드원 항목 업데이트
	for i = 1, memberCount do
		
		local index = i-1
	
		local guildMemberInfo = myGuildListInfo:getMember( index )
		local gradeType = guildMemberInfo:getGrade()
		local gradeValue = ""
		if ( 0 == gradeType ) then
			gradeValue = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDMASTER" )
		elseif ( 1 == gradeType ) then
			gradeValue = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDSUBMASTER" )
		elseif ( 2 == gradeType ) then
			gradeValue = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDMEMBER" )
		end
		
		_guildList[index]._memberGrade			:SetText( gradeValue )
		
		if true == guildMemberInfo:isOnline() then
			_guildList[index]._memberName			:SetText( guildMemberInfo:getName().. " (" ..guildMemberInfo:getCharacterName().. ")" )
			local usableActivity = guildMemberInfo:getUsableActivity()
			if 10000 < usableActivity then
				usableActivity = 10000
			end
			local tempActivityText = tostring(guildMemberInfo:getTotalActivity()).."(<PAColor0xfface400>+".. tostring( usableActivity ).."<PAOldColor>)"
			_guildList[index]._memberContribution	:SetText( tempActivityText )
		else
			_guildList[index]._memberName			:SetText( guildMemberInfo:getName().. " ( - )" )
			local tempActivityText = tostring(guildMemberInfo:getTotalActivity()).."(+".. tostring(guildMemberInfo:getUsableActivity())..")"
			_guildList[index]._memberContribution	:SetText( tempActivityText )
		end
			
		local incentive = ToClient_getGuildMemberIncentiveMoney_s64(index)
		_guildList[index]._memberIncentiveValue:SetText( makeDotMoney(incentive) );
		
		local grade = ToClient_getGuildMemberIncentiveGrade(index)
		_guildList[index]._comboboxRank:SetText( tostring(grade) )
	end
	
end

function click_Incentive_GradeList(index)
	
	_selectedMemberIndex = index
	
	local listCombbox = _guildList[index]._comboboxRank:GetListControl()
	
	if (_frameGuildList:GetSizeY() - _contentGuildList:GetPosY() - listCombbox:GetSizeY()) <  _guildList[index]._comboboxRank:GetPosY() then
		listCombbox:SetPosY( (listCombbox:GetSizeY()) * -1 );
	else
		listCombbox:SetPosY( _guildList[index]._comboboxRank:GetSizeY() );
	end
	
	_guildList[index]._comboboxRank:ToggleListbox()
	
	_contentGuildList:SetChildIndex(_guildList[index]._comboboxRank, 9999 )
	
end

function Set_Incentive_Grade( index )
	
	_guildList[index]._comboboxRank:SetSelectItemIndex( _guildList[index]._comboboxRank:GetSelectIndex() )
	
	local grade = _guildList[index]._comboboxRank:GetSelectIndex() + 1
	_guildList[index]._comboboxRank:SetText( tostring(grade) )
	_guildList[index]._comboboxRank:ToggleListbox()
	
	ToClient_SetGuildMemberIncentiveGrade( index, grade )
	Guild_Incentive:UpdateData()
		
end

function Give_Incentive()
	
	local titleString	= PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_INCENTIVE_PAYMENTS")
	local contentString = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_INCENTIVE_PAYMENTS_CONFIRM")
	local messageboxData = { title = titleString, content = contentString, functionYes = PayIncentiveConfirm, functionCancel = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData);

end

function PayIncentiveConfirm()
	ToClient_PayGuildMemberIncentive()
	Panel_GuildIncentiveOption_Close()
end

function Panel_GuildIncentiveOption_ShowToggle()
	
	if Panel_Guild_IncentiveOption:GetShow() then
		Panel_GuildIncentiveOption_Close()
	else
		ToClient_InitGuildIncentiveList()	-- 클라이언트에서 인센티브 계산을 위한 작업 준비
		
		Panel_Guild_IncentiveOption:SetShow( true )
		
		Guild_Incentive:ResetControl()
		
		Guild_Incentive:UpdateData()
		
		Panel_Guild_IncentiveOption_Resize()
		
	end
end
function Panel_GuildIncentiveOption_Close()
	if Panel_Guild_IncentiveOption:GetShow() then
		Panel_Guild_IncentiveOption:SetShow( false )
	end
end
function Panel_Guild_IncentiveOption_Resize()
	Panel_Guild_IncentiveOption:SetPosX( getScreenSizeX()/2 - Panel_Guild_IncentiveOption:GetSizeX()/2 )
	Panel_Guild_IncentiveOption:SetPosY( getScreenSizeY()/2 - Panel_Guild_IncentiveOption:GetSizeY()/2 - 50 )
end

registerEvent( "onScreenResize", "Panel_Guild_IncentiveOption_Resize" )
