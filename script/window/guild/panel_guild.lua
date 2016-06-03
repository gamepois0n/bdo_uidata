local CT2S 			= CppEnums.ClassType2String
local UI_PSFT 		= CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color
local UCT 			= CppEnums.PA_UI_CONTROL_TYPE
local UI_TM 		= CppEnums.TextMode
local IM 			= CppEnums.EProcessorInputMode

Panel_Window_Guild:SetShow ( false )	
Panel_Window_Guild:setMaskingChild( true )
Panel_Window_Guild:setGlassBackground( true )
Panel_Window_Guild:SetDragAll( true )
-- Panel_Guild_Declaration:SetDragAll( true )

Panel_Window_Guild:RegisterShowEventFunc( true, 'guild_ShowAni()' )
Panel_Window_Guild:RegisterShowEventFunc( false, 'guild_HideAni()' )

local isContentsGuildDuel = ToClient_IsContentsGroupOpen( CppEnums.ContentsGroupType.ContentsGroupKey, 69 )


local lifeType = {
					[0] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_GATHERING"),
					[1] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_FISHING"),
					[2] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_HUNTING"),
					[3] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_COOKING"),
					[4] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_ALCHEMY"),
					[5] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_PROCESSING"),
					[6] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_OBEDIENCE"),
					[7] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_TRADE"),
					[8] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_GROWTH"),
					[9] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_WEALTH"),
					[10] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_COMBAT"),
				 }

local tabNumber						= 99
local btn_GuildMasterMandateBG		= UI.getChildControl ( Panel_Window_Guild,	"Static_GuildMandateBG")
local btn_GuildMasterMandate		= UI.getChildControl ( Panel_Window_Guild,	"Button_GuildMandate")

local notice_title					= UI.getChildControl ( Panel_Window_Guild,	"StaticText_NoticeTitle")
local notice_edit					= UI.getChildControl ( Panel_Window_Guild,	"Edit_Notice")
local notice_btn					= UI.getChildControl ( Panel_Window_Guild,	"Button_Notice")
local introduce_btn					= UI.getChildControl ( Panel_Window_Guild,	"Button_Introduce")
local introduce_Reset				= UI.getChildControl ( Panel_Window_Guild,	"Button_IntroReset")
local introduce_edit				= UI.getChildControl ( Panel_Window_Guild,	"MultilineEdit_Introduce")

------------------------------------------------------
--					창 애니메이션
------------------------------------------------------
function guild_ShowAni()
	UIAni.fadeInSCR_Down( Panel_Window_Guild )
	-- audioPostEvent_SystemUi(01,00)
	
	local aniInfo1 = Panel_Window_Guild:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo1:SetStartScale(0.5)
	aniInfo1:SetEndScale(1.2)
	aniInfo1.AxisX = Panel_Window_Guild:GetSizeX() / 2
	aniInfo1.AxisY = Panel_Window_Guild:GetSizeY() / 2
	aniInfo1.ScaleType = 2
	aniInfo1.IsChangeChild = true
	
	local aniInfo2 = Panel_Window_Guild:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
	aniInfo2:SetStartScale(1.2)
	aniInfo2:SetEndScale(1.0)
	aniInfo2.AxisX = Panel_Window_Guild:GetSizeX() / 2
	aniInfo2.AxisY = Panel_Window_Guild:GetSizeY() / 2
	aniInfo2.ScaleType = 2
	aniInfo2.IsChangeChild = true
end

function guild_HideAni()
	Panel_Window_Guild:SetAlpha( 1 )
	local aniInfo = UIAni.AlphaAnimation( 0, Panel_Window_Guild, 0.0, 0.1 )
	aniInfo:SetHideAtEnd(true)
end

------------------------------------------------------------------------------------------------------------------------------------------------

local constCreateWarInfoCount = 4 	-- 총 4개까지만 생성한다
local keyUseCheck = true
local guildCommentsWebUrl	= nil
------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
------------ 좌측 상단 길드 정보 관리
----------------------------------------------------------------------------------------------------------------
local GuildInfoPage = {}
--[[
GuildInfoPage
	initialize()
	UpdateData()	
]]--

-- 초기화
function GuildInfoPage:initialize()
	self._guildMainBG			= UI.getChildControl ( Panel_Window_Guild, "Static_Menu_BG_0")
	self._windowTitle			= UI.getChildControl ( Panel_Window_Guild, "StaticText_Title" )
	self._textGuildInfoTitle	= UI.getChildControl ( Panel_Window_Guild, "StaticText_Title_Info" )
	self._txtGuildName 			= UI.getChildControl ( Panel_Window_Guild, "StaticText_GuildName" )
	self._iconOccupyTerritory	= UI.getChildControl ( Panel_Window_Guild, "Static_GuildIcon_BG" )
	self._iconGuildMark			= UI.getChildControl ( Panel_Window_Guild, "Static_Guild_Icon" )
	self._txtMaster  			= UI.getChildControl ( Panel_Window_Guild, "StaticText_Master" )
	self._txtPersonNo  			= UI.getChildControl ( Panel_Window_Guild, "StaticText_PersonNumber" )
	
	self._txtRGuildName			= UI.getChildControl ( Panel_Window_Guild, "StaticText_R_GuildName" )
	self._txtRMaster  			= UI.getChildControl ( Panel_Window_Guild, "StaticText_R_Master" )
	self._txtRRank_Title		= UI.getChildControl ( Panel_Window_Guild, "StaticText_GuildRank")
	self._txtRRank  			= UI.getChildControl ( Panel_Window_Guild, "StaticText_GuildRank_Value" )
	self._txtRPersonNo	  		= UI.getChildControl ( Panel_Window_Guild, "StaticText_R_PersonNumber" )
	-- self._txtRTendency	  		= UI.getChildControl ( Panel_Window_Guild, "StaticText_R_Tendency" )
	self._txtUnpaidTax	  		= UI.getChildControl ( Panel_Window_Guild, "StaticText_UnpaidTax" )
	
	self._btnGuildDel	  		= UI.getChildControl ( Panel_Window_Guild, "Button_GuildDispersal" )
	self._btnChangeMark  		= UI.getChildControl ( Panel_Window_Guild, "Button_GuildMark" )
	self._btnIncreaseMember  	= UI.getChildControl ( Panel_Window_Guild, "Button_IncreaseMember" )
	
	self._btnTaxPayment			= UI.getChildControl ( Panel_Window_Guild, "Button_TaxPayment" )
	self._txtGuildPoint			= UI.getChildControl ( Panel_Window_Guild, "StaticText_Point")
	self._txtGuildPointValue	= UI.getChildControl ( Panel_Window_Guild, "StaticText_Point_Value" )
	self._txtGuildPointPercent	= UI.getChildControl ( Panel_Window_Guild, "StaticText_Point_Percent" )
	self._progressSkillPoint 	= UI.getChildControl ( Panel_Window_Guild, "Progress2_SkillPointExp" )
	
	self._txtGuildMpValue		= UI.getChildControl ( Panel_Window_Guild, "StaticText_GuildMp_Value" )
	self._txtGuildMpPercent		= UI.getChildControl ( Panel_Window_Guild, "StaticText_GuildMp_Percent" )
	self._progressMpPoint	 	= UI.getChildControl ( Panel_Window_Guild, "Progress2_GuildMp" )

	self._skillPointExpBG		= UI.getChildControl ( Panel_Window_Guild, "Static_SkillPointExp_BG")
	self._guildMpExpBG			= UI.getChildControl ( Panel_Window_Guild, "Static_GuildMp_BG")
	self._guildMp_Title			= UI.getChildControl ( Panel_Window_Guild, "StaticText_GuildMp")

	self._guildIntroduce_Title	= UI.getChildControl ( Panel_Window_Guild, "StaticText_Title_GuildIntroduce")
	self._guildIntroduce_BG		= UI.getChildControl ( Panel_Window_Guild, "Static_GuildIntroduce_BG")

	self._guildBbs_Title		= UI.getChildControl ( Panel_Window_Guild, "StaticText_Title_Bbs")
	self._guildBbs_BG			= UI.getChildControl ( Panel_Window_Guild, "Static_GuildBbs_BG")

	self._planning				= UI.getChildControl ( Panel_Window_Guild, "StaticText_1") -- 구현되면 삭제.
	self._planning				:SetText ( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TODAY_COMMENT") ) -- "오늘의 한 마디를 불러올 수 없습니다.\n잠시 후에 다시 시도해 주십시오." )
	self._txtProtect			= UI.getChildControl ( Panel_Window_Guild, "StaticText_Protect")
	self._txtProtectValue		= UI.getChildControl ( Panel_Window_Guild, "StaticText_ProtectValue")
	self._btnProtectAdd			= UI.getChildControl ( Panel_Window_Guild, "Button_ProtectAdd")
	
	self._txtGuildMoneyTitle	= UI.getChildControl ( Panel_Window_Guild, "StaticText_GuildMoneyTitle")
	self._txtGuildMoney			= UI.getChildControl ( Panel_Window_Guild, "StaticText_GuildMoneyValue")

	-- self._txtInfoHelp			= UI.getChildControl ( Panel_Window_Guild, "StaticText_Description" )

	function self:SetShow(isShow)
		-- self._btnChangeMark:SetShow( isShow )
		-- self._txtInfoHelp:SetShow( isShow )
	end
	
	function self:GetShow()
		return self._btnGuildDel:GetShow();
	end
	
	if isGameTypeEnglish() then
		self._txtGuildName	:SetShow( false )
		self._txtMaster		:SetShow( false )
	else
		self._txtGuildName	:SetShow( false )
		self._txtMaster		:SetShow( false )
	end

	self:SetShow(false)
	
	-- self._txtInfoHelp:SetTextMode( UI_TM.eTextMode_AutoWrap )
	-- self._txtInfoHelp:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_INFOHELP" ) )
	-- self._btnChangeMark:SetShow( false )
	-- btn_GuildMasterMandate:SetShow( true )
	self._btnGuildDel		:addInputEvent("Mouse_LUp",	"HandleClickedGuildDel()")
	self._btnChangeMark		:addInputEvent("Mouse_LUp",	"HandleClickedChangeMark()")
	self._btnTaxPayment		:addInputEvent("Mouse_LUp",	"HandleClicked_TaxPayment()")
	
	self._btnIncreaseMember	:addInputEvent("Mouse_LUp",	"HandleClickedIncreaseMember()")
	self._btnIncreaseMember	:addInputEvent("Mouse_On",	"Panel_Guild_Tab_ToolTip_Func( 6, true )")
	self._btnIncreaseMember	:addInputEvent("Mouse_Out",	"Panel_Guild_Tab_ToolTip_Func( 6, false )" )

	self._btnProtectAdd		:addInputEvent("Mouse_LUp",	"HandleClickedIncreaseProtectMember()")	
	self._btnProtectAdd		:addInputEvent("Mouse_On",	"Panel_Guild_Tab_ToolTip_Func( 8, true )")
	self._btnProtectAdd		:addInputEvent("Mouse_Out",	"Panel_Guild_Tab_ToolTip_Func( 8, false )" )
	
	self._btnChangeMark		:addInputEvent("Mouse_On",	"GuildSimplTooltips(true, 2)")
	self._btnChangeMark		:addInputEvent("Mouse_Out",	"GuildSimplTooltips(false, 2)")

	self._btnGuildDel		:addInputEvent("Mouse_On",	"GuildSimplTooltips(true, 3)")
	self._btnGuildDel		:addInputEvent("Mouse_Out",	"GuildSimplTooltips(false, 3)")

	btn_GuildMasterMandate		:addInputEvent("Mouse_On",	"GuildSimplTooltips( true, 0 )")
	btn_GuildMasterMandate		:addInputEvent("Mouse_Out",	"GuildSimplTooltips( false, 0 )")
	
	btn_GuildMasterMandateBG	:addInputEvent("Mouse_On",	"GuildSimplTooltips( true, 1 )")
	btn_GuildMasterMandateBG	:addInputEvent("Mouse_Out",	"GuildSimplTooltips( false, 1 )")

	if not isGameTypeEnglish() then
		self._txtRGuildName			:addInputEvent("Mouse_On",	"GuildSimplTooltips( true, 4 )")
		self._txtRGuildName			:addInputEvent("Mouse_Out",	"GuildSimplTooltips( false, 4 )")
		self._txtRMaster			:addInputEvent("Mouse_On",	"GuildSimplTooltips( true, 5 )")
		self._txtRMaster			:addInputEvent("Mouse_Out",	"GuildSimplTooltips( false, 5 )")
		self._txtRGuildName			:setTooltipEventRegistFunc("GuildSimplTooltips( true, 4 )")
		self._txtRMaster			:setTooltipEventRegistFunc("GuildSimplTooltips( true, 5 )")
		self._txtRGuildName			:SetIgnore( false )
		self._txtRMaster			:SetIgnore( false )
	else
		self._txtRGuildName			:SetIgnore( true )
		self._txtRMaster			:SetIgnore( true )
	end

	btn_GuildMasterMandate		:setTooltipEventRegistFunc("GuildSimplTooltips( true, 0 )")
	btn_GuildMasterMandateBG	:setTooltipEventRegistFunc("GuildSimplTooltips( true, 1 )")
	self._btnChangeMark			:setTooltipEventRegistFunc("GuildSimplTooltips( true, 2 )" )
	self._btnGuildDel			:setTooltipEventRegistFunc("GuildSimplTooltips( true, 3 )" )
	self._btnIncreaseMember		:setTooltipEventRegistFunc("Panel_Guild_Tab_ToolTip_Func( 6, true )")
	self._btnProtectAdd			:setTooltipEventRegistFunc("Panel_Guild_Tab_ToolTip_Func( 8, true )")
end


local	_Web		= UI.createControl( CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_Window_Guild, 'WebControl_EventNotify_WebLink' )
	_Web:SetShow( true )
	_Web:SetPosX(410)
	_Web:SetPosY(430)
	_Web:SetSize( 323, 272 )
	_Web:ResetUrl()

Panel_Window_Guild:SetChildIndex(_Web, 9999 )
local HandleClickedGuildDelContinue = function ()
	ToClient_RequestDestroyGuild()
	GuildManager:Hide()--FGlobal_guildWindow_Hide()
end

local HandleClickedGuildLeaveContinue = function ()
	ToClient_RequestDisjoinGuild()
	GuildManager:Hide()
end
-- 길드 해산 버튼
function HandleClickedGuildDel()
	
	local myGuildInfo = ToClient_GetMyGuildInfoWrapper();
	if( nil == myGuildInfo ) then
		_PA_ASSERT( false, "ResponseGuildInviteForGuildGrade 에서 길드 정보가 없습니다.");
		return;
	end
	
	local guildGrade	= myGuildInfo:getGuildGrade()
		
	local messageboxData 	
	if true == getSelfPlayer():get():isGuildMaster() then
		if ToClient_GetMyGuildInfoWrapper():getMemberCount() <= 1 then
			messageboxData = { title = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_DISPERSE_GUILD" ) , content = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_DISPERSE_GUILD_ASK" ) , functionYes = HandleClickedGuildDelContinue, functionNo = MessageBox_Empty_function, priority = UCT.PAUIMB_PRIORITY_LOW}
			MessageBox.showMessageBox(messageboxData)
			
		else
			Proc_ShowMessage_Ack( PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_CANT_DISPERSE" ) )
		end
	else
		local tempText;
		if( 0 == guildGrade ) then
			tempText = PAGetString(Defines.StringSheet_GAME,"LUA_GUILD_TEXT_CLANLIST_CLANOUT_ASK") -- '클랜에서 탈퇴 하시겠습니까?'
		else
			tempText = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_WITHDRAW_GUILD_ASK" ) .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_MENTINFO")
		end		
	
		messageboxData = { title = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_WITHDRAW_GUILD" ), content = tempText , functionYes = HandleClickedGuildLeaveContinue, functionNo = MessageBox_Empty_function, priority = UCT.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData)
	end
end



-- 길드 마크 등록 버튼
function HandleClickedChangeMark()
	messageboxData = { title = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_ADDMARK_MESSAGEBOX_TITLE" ), content = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_ADDMARK_MESSAGEBOX_TEXT" ), functionYes = HandleClickedChangeMark_Continue, functionNo = MessageBox_Empty_function, priority = UCT.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData, "top")
end

function HandleClickedChangeMark_Continue()
	guildMarkUpdate()
end

-- 성문 열기
function HandleClickedOpenSiegeGate()
	ToClient_RequestOpenSiegeGate()
end

-- 법인세 납부
function HandleClicked_TaxPayment()
	local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
	if( nil == myGuildInfo ) then
		return;
	end

	local taxValue			=  Int64toInt32( myGuildInfo:getAccumulateTax() )
	local costValue			=  Int64toInt32( myGuildInfo:getAccumulateGuildHouseCost() )
	
	if( 0 < taxValue  ) then
		local msgBox_Title		= PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_GUILDLAWTAX") --"길드 법인세 납부"
		local msgBox_Content	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_GUILDLAWTAX_ASK", "taxValue", taxValue ) -- "길드 법인세 " .. taxValue .. " 실버를 납부하시겠습니까?"
		messageboxData = { title = msgBox_Title, content = msgBox_Content, functionYes = Guild_DoTaxPayment, functionNo = MessageBox_Empty_function, priority = UCT.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData, "middle")
	elseif( 0 < costValue ) then
		local msgBox_Title		= PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_HOUSECOSTS_PAY") -- "길드 하우스 유지 비용 납부"
		local msgBox_Content	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_HOUSECOSTS_PAY_ASK", "taxValue", costValue ) -- "길드 하우스 유지 비용 " .. taxValue .. " 실버를 납부하시겠습니까?"
		messageboxData = { title = msgBox_Title, content = msgBox_Content, functionYes = Guild_DoGuildHouseCost, functionNo = MessageBox_Empty_function, priority = UCT.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData, "middle")
	else
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_UNPAID_CONFIRM") ); -- "미납된 공금(법인세,길드하우스유지비용)이 없습니다."
		return;
	end
	
end
function Guild_DoTaxPayment()
	ToClient_PayComporateTax()
end

-- 길드하우스 유지 비용
function Guild_DoGuildHouseCost()
	ToClient_PayGuildHouseCost()
end


function HandleClickedIncreaseMember()
	local skillPointInfo = getSkillPointInfo( 3 )			
	if skillPointInfo._remainPoint < 2 then
		local messageContent	= PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_NEED_GUILDSKILLPOINT" ) .. tostring( skillPointInfo._remainPoint) .. PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_EXPAND_POINT_LACK")
		local messageboxData	= { title = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_EXPAND_MAX_COUNT" ) , content = messageContent, functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData)
	else
		local messageContent	= PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_EXPAND_MAX_COUNT_EXECUTE" ) .. tostring( skillPointInfo._remainPoint) 
		local messageboxData	= { title = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_EXPAND_MAX_COUNT" ) , content = messageContent, functionYes = Guild_IncreaseMember_Confirm, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData, "top")
	end
end

function Guild_IncreaseMember_Confirm()
	ToClient_RequestVaryJoinableGuildMemeberCount();
end

-- 길드 보호인원 증가
function HandleClickedIncreaseProtectMember()
	local skillPointInfo = getSkillPointInfo( 3 )			
	if skillPointInfo._remainPoint < 3 then
		local messageContent	= PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_PROTECTADD_MOREPOINT" ) .. tostring( skillPointInfo._remainPoint) .. PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_EXPAND_POINT_LACK")
		local messageboxData	= { title = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_PROTECTADD_TITLE" ) , content = messageContent, functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData)
	else
		local messageContent	= PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_PROTECTADD_POINT" ) .. tostring( skillPointInfo._remainPoint) 
		local messageboxData	= { title = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_PROTECTADD_TITLE" ) , content = messageContent, functionYes = Guild_IncreaseProtectMember_Confirm, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData, "top")
	end
end

function Guild_IncreaseProtectMember_Confirm()
	ToClient_RequestVaryProtectGuildMemeberCount()
end


-- 길드 정보 업데이트
local maxGuildMp = 1500
function GuildInfoPage:UpdateData()
	SetDATAByGuildGrade()

	local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
	
	if myGuildInfo ~= nil then
		local guildRank			= myGuildInfo:getMemberCountLevel()
		local guildRankString	= ""
		if 1 == guildRank then
			guildRankString = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_SMALL") -- "소형"
		elseif 2 == guildRank then
			guildRankString = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_MIDDLE") -- "중형"
		elseif 3 == guildRank then
			guildRankString = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_BIG") -- "대형"
		elseif 4 == guildRank then
			guildRankString = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_BIGGEST") -- "초대형"
		end
		local skillPointInfo = getSkillPointInfo( 3 )
		self._txtRGuildName			:SetText( myGuildInfo:getName() )
		self._txtRRank				:SetText( guildRankString )
		self._txtRRank:SetSpanSize( self._txtRRank_Title:GetSpanSize().x+self._txtRRank_Title:GetTextSizeX()+10, self._txtRRank:GetSpanSize().y )
		self._txtRMaster			:SetText( myGuildInfo:getGuildMasterName() )
		-- self._txtRTendency			:SetText( myGuildInfo:getGuildTendency() )
		self._txtRPersonNo			:SetText( myGuildInfo:getMemberCount().."/".. myGuildInfo:getJoinableMemberCount() )
		self._txtRPersonNo:SetSpanSize( self._txtPersonNo:GetSpanSize().x+self._txtPersonNo:GetTextSizeX()+10, self._txtRPersonNo:GetSpanSize().y )
		self._txtProtectValue		:SetText( myGuildInfo:getProtectGuildMemberCount().."/".. myGuildInfo:getAvaiableProtectGuildMemberCount() )
		self._txtProtectValue:SetSpanSize( self._txtProtect:GetSpanSize().x+self._txtProtect:GetTextSizeX(), self._txtProtectValue:GetSpanSize().y )
		self._txtGuildPointValue	:SetText( tostring(skillPointInfo._remainPoint) .. "/" .. tostring(skillPointInfo._acquirePoint-1)  );	-- 임시로 -1시켜놨음 함수자체에서 변경되면 -1제거할 것.
		self._txtGuildPointPercent	:SetText( "( "..string.format("%.0f" , (skillPointInfo._currentExp / skillPointInfo._nextLevelExp) * 100 ).."% )" )
		self._progressSkillPoint	:SetProgressRate( (skillPointInfo._currentExp / skillPointInfo._nextLevelExp) * 100 )
		
		local currentGuildMp = myGuildInfo:getGuildMp()
		self._txtGuildMpValue		:SetText( currentGuildMp )
		
		local guildMpGrade = ""
		if 300 > currentGuildMp then
			guildMpGrade = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GULDGRADE_1") -- "( 0단계 )"
		elseif 300 <= currentGuildMp and 600 > currentGuildMp then
			guildMpGrade = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GULDGRADE_2") -- "( 1단계 )"
		elseif 600 <= currentGuildMp and 900 > currentGuildMp then
			guildMpGrade = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GULDGRADE_3") -- "( 2단계 )"
		elseif 900 <= currentGuildMp and 1200 > currentGuildMp then
			guildMpGrade = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GULDGRADE_4") -- "( 3단계 )"
		elseif 1200 <= currentGuildMp and 1500 > currentGuildMp then
			guildMpGrade = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GULDGRADE_5") -- "( 4단계 )"
		elseif 1500 <= currentGuildMp then
			guildMpGrade = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GULDGRADE_6") -- "( 5단계 )"
		end
		
		self._txtGuildMpPercent		:SetText( guildMpGrade )
		-- self._txtGuildMpPercent		:SetText( "( "..string.format("%.0f" , ( currentGuildMp / maxGuildMp) * 100 ).."% )" )
		
		if 0 > currentGuildMp then
			currentGuildMp = 0
		end
		self._progressMpPoint		:SetProgressRate( (currentGuildMp / maxGuildMp) * 100 )
		local getGuildMoney = myGuildInfo:getGuildBusinessFunds_s64()
		self._txtGuildMoney			:SetText( makeDotMoney(getGuildMoney) )

		self._txtGuildMoney:SetSpanSize( self._txtGuildMoneyTitle:GetSpanSize().x+self._txtGuildMoneyTitle:GetTextSizeX()+10, self._txtGuildMoney:GetSpanSize().y )

		if( toInt64(0, 0) < myGuildInfo:getAccumulateTax() ) then
			self._txtUnpaidTax:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_UNPAIDTAX", "getAccumulateTax", tostring( myGuildInfo:getAccumulateTax() ) ) ) -- 미납 법인세 내역
		elseif( toInt64(0, 0) < myGuildInfo:getAccumulateGuildHouseCost() ) then
			self._txtUnpaidTax:SetText( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_UNPAIDTAX_HOUSE", "getAccumulateGuildHouseCost", tostring( myGuildInfo:getAccumulateGuildHouseCost() ) ) ) -- 미납 길드하우스 유지비	
		end
		
		local isGuildMaster = getSelfPlayer():get():isGuildMaster()
		if true == isGuildMaster then	
			self:SetShow(true)
			if 0 == myGuildInfo:getGuildGrade() then
				-- self._btnGuildDel:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_DISPERSE_CLAN") ) -- 길드 해산
			end
			
			local skillPointInfo = getSkillPointInfo( 3 )
			local isEnable =  ( ToClient_GetGuildSkillPointPerIncreaseMember() <= skillPointInfo._remainPoint)
			-- self._btnIncreaseMember:SetEnable( isEnable );
			self._btnIncreaseMember:SetMonoTone( not isEnable );
			
		else
			self:SetShow(false)
			if 0 == myGuildInfo:getGuildGrade() then
				-- self._btnGuildDel:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_WITHDRAW_CLAN") ) -- 길드 탈퇴
			end
		end

		local isSet = setGuildTextureByGuildNo( myGuildInfo:getGuildNo_s64(), GuildInfoPage._iconGuildMark )
		if ( false == isSet ) then
			GuildInfoPage._iconGuildMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
			local x1, y1, x2, y2 = setTextureUV_Func( GuildInfoPage._iconGuildMark, 183, 1, 188, 6 )
			GuildInfoPage._iconGuildMark:getBaseTexture():setUV(  x1, y1, x2, y2  )
			GuildInfoPage._iconGuildMark:setRenderTexture(GuildInfoPage._iconGuildMark:getBaseTexture())
		else	
			GuildInfoPage._iconGuildMark:getBaseTexture():setUV(  0, 0, 1, 1  )
			GuildInfoPage._iconGuildMark:setRenderTexture(GuildInfoPage._iconGuildMark:getBaseTexture())
		end
	else
		GuildManager:Hide()
	end
end



----------------------------------------------------------------------------------------------------------------
------------ 좌측 중간 전쟁 선포 관련 관리
----------------------------------------------------------------------------------------------------------------
local GuildLetsWarPage = {}
--[[
GuildLetsWarPage
	initialize()
	UpdateData()	
]]--

-- 초기화
function GuildLetsWarPage:initialize()
	self._letsWarBG				= UI.getChildControl ( Panel_Guild_Declaration, "Static_Menu_BG_2")			
	self._txtLetsWarTitle 		= UI.getChildControl ( Panel_Guild_Declaration, "StaticText_Title" )
	self._btnLetsWarDoWar 		= UI.getChildControl ( Panel_Guild_Declaration, "Button_LetsWar" )
	self._editLetsWarInputName 	= UI.getChildControl ( Panel_Guild_Declaration, "Edit_InputGuild" )
	self._txtLetsWarHelp 		= UI.getChildControl ( Panel_Guild_Declaration, "StaticText_WarDesc_help" )
	self._btnCose				= UI.getChildControl ( Panel_Guild_Declaration, "Button_Close")	

	function self:SetShow(isShow)
		self._letsWarBG:SetShow(isShow)
		-- self._txtLetsWarTitle:SetShow(isShow)
		self._btnLetsWarDoWar:SetShow(isShow)
		self._editLetsWarInputName:SetShow(isShow)	
		self._txtLetsWarHelp:SetShow(isShow)	
	end
	
	function self:GetShow()
		return self._letsWarBG:GetShow();
	end
	
	self:SetShow(false)
	
	self._txtLetsWarHelp:SetTextMode( UI_TM.eTextMode_AutoWrap )
	if CppEnums.GuildWarType.GuildWarType_Normal == ToClient_GetGuildWarType() then	-- 일방전투일 경우(한국의 경우)
		self._txtLetsWarHelp:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_LETSWARHELP" ) )
	elseif CppEnums.GuildWarType.GuildWarType_Both == ToClient_GetGuildWarType() then -- 쌍방전투일 경우(일본의 경우)
		self._txtLetsWarHelp:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_LETSWARHELP_JP" ) )
	else
		self._txtLetsWarHelp:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_LETSWARHELP" ) )
	end
	
	Panel_Guild_Declaration:SetSize(Panel_Guild_Declaration:GetSizeX(), self._txtLetsWarHelp:GetTextSizeY()+10+self._txtLetsWarTitle:GetSizeY()+self._btnLetsWarDoWar:GetSizeY()+50)
	self._letsWarBG:SetSize( self._letsWarBG:GetSizeX(), self._txtLetsWarHelp:GetTextSizeY()+50 )
	self._txtLetsWarHelp:SetSize( self._txtLetsWarHelp:GetSizeX(), self._txtLetsWarHelp:GetTextSizeY()+10 )
	self._btnLetsWarDoWar		:addInputEvent("Mouse_LUp", "HandleClickedLetsWar()")
	self._editLetsWarInputName	:addInputEvent("Mouse_LUp", "HandleClickedLetsWarEditName()")
	self._btnCose				:addInputEvent("Mouse_LUp", "HandleClicked_LetsWarHide()")

	self._editLetsWarInputName:RegistReturnKeyEvent( "HandleClickedLetsWar()" )
end

-- 전쟁 선포 버튼
function HandleClickedLetsWar()
	local guildName		= GuildLetsWarPage._editLetsWarInputName:GetEditText()
	local myGuildInfo	= ToClient_GetMyGuildInfoWrapper()
	local myGuildName	= myGuildInfo:getName()

	-- 미납 상태를 체크한다.
	local accumulateTax_s32		= Int64toInt32( myGuildInfo:getAccumulateTax() )
	local accumulateCost_s32	= Int64toInt32( myGuildInfo:getAccumulateGuildHouseCost() )
	
	local close_function = function()
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
	if (0 < accumulateTax_s32) or (0 < accumulateCost_s32) then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_RECRUITMENT_TAXFIRST") ) -- "조합세를 먼저 납부해야 합니다.")
		ClearFocusEdit()
		close_function()
		return
	end

	if guildName == myGuildName then
		local messageboxData = { title = "", content = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_LETSWARFAIL" ), functionApply = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
		MessageBox.showMessageBox( messageboxData )
	else
		if ( CppEnums.GuildWarType.GuildWarType_Both == ToClient_GetGuildWarType() ) then
			local messageboxData = { title = "", content = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_DECLAREWAR_DECREASEMONEY" ), functionYes = ConfirmDeclareGuildWar, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW }
			MessageBox.showMessageBox( messageboxData, nil, nil )
		else
			ConfirmDeclareGuildWar()
		end
	end	
	
	ClearFocusEdit()
	close_function()
end

function ConfirmDeclareGuildWar()
	local guildName		= GuildLetsWarPage._editLetsWarInputName:GetEditText()
	ToClient_RequestDeclareGuildWar(0, guildName, false)
	
	GuildLetsWarPage._editLetsWarInputName:SetEditText('', true)
end

-- 전쟁 선포 옆 에디트 
function HandleClickedLetsWarEditName()
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
	SetFocusEdit( GuildLetsWarPage._editLetsWarInputName );

	GuildLetsWarPage._editLetsWarInputName:SetEditText('', true)
end

function FGlobal_CheckGuildLetsWarUiEdit(targetUI)
	return ( nil ~= targetUI ) and ( targetUI:GetKey() == GuildLetsWarPage._editLetsWarInputName:GetKey() )
end

function FGlobal_GuildLetsWarClearFocusEdit()
	GuildLetsWarPage._editLetsWarInputName:SetText("",true)
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
end

-- 전쟁 선포 업데이트
function GuildLetsWarPage:UpdateData()
	local isGuildMaster = getSelfPlayer():get():isGuildMaster()
	local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
	if true == isGuildMaster or true == isGuildSubMaster then
		self:SetShow(true)
	else
		self:SetShow(false)
	end
end

function HandleClicked_LetsWarShow()
	Panel_Guild_Declaration:SetShow( true )
end

function HandleClicked_LetsWarHide()
	Panel_Guild_Declaration:SetShow( false )
end
----------------------------------------------
------------------------------------------------------------------
------------ 좌측 하단 전쟁 현황 관리
----------------------------------------------------------------------------------------------------------------
local GuildWarInfoPage = 
{
	_list			= {},
	_list2			= {},
	slotMaxCount	= 4,
	_listCount		= 0,
	_startIndex		= 0,
}

-- 초기화
function GuildWarInfoPage:initialize()
	local constStartY 	= 450
	
	self._txtWarInfoTitle	= UI.getChildControl ( Panel_Window_Guild, "StaticText_Title_WarInfo" )
	self._static_WarInfoBG	= UI.getChildControl ( Panel_Window_Guild, "Static_Menu_BG_1" )
	self._txtNoWar			= UI.getChildControl ( Panel_Window_Guild, "StaticText_NoWar" )
	self._txtWarHelp		= UI.getChildControl ( Panel_Window_Guild, "StaticText_WarInfo_help" )

	self._btnWarList1		= UI.getChildControl ( Panel_Window_Guild, "RadioButton_WarList1" )
	self._btnWarList2		= UI.getChildControl ( Panel_Window_Guild, "RadioButton_WarList2" )

	self._btnDeclaration	= UI.getChildControl ( Panel_Window_Guild, "Button_Declaration")

	self._scroll			= UI.getChildControl ( Panel_Window_Guild, "Scroll_DeclareGuildWar" )

	local copyWarBG			= UI.getChildControl ( Panel_Window_Guild, "Static_C_WarBG" )
	local copyGuildIconBG	= UI.getChildControl ( Panel_Window_Guild, "Static_C_EnemyGuild_IconBG" )
	local copyGuildIcon		= UI.getChildControl ( Panel_Window_Guild, "Static_C_EnemyGuild_Icon" )
	local copyGuildName		= UI.getChildControl ( Panel_Window_Guild, "StaticText_C_EnemyGuild_Name" )
	local copyKill			= UI.getChildControl ( Panel_Window_Guild, "StaticText_C_Kill" )
	local copyDeath			= UI.getChildControl ( Panel_Window_Guild, "StaticText_C_Death" )
	local copyStopWar		= UI.getChildControl ( Panel_Window_Guild, "Button_C_WarStop" )
	local copyShowbu		= UI.getChildControl ( Panel_Window_Guild, "Button_C_Showbu" )
	local copyWarIcon		= UI.getChildControl ( Panel_Window_Guild, "Static_WarIcon" )
	
	Panel_Window_Guild		:RemoveControl( self._static_WarInfoBG )
	Panel_Window_Guild		:RemoveControl( self._btnWarList1 )
	Panel_Window_Guild		:RemoveControl( self._btnWarList2 )
	Panel_Window_Guild		:RemoveControl( self._btnDeclaration )
	self._txtWarInfoTitle	:AddChild( self._static_WarInfoBG )
	self._txtWarInfoTitle	:AddChild( self._btnWarList1 )
	self._txtWarInfoTitle	:AddChild( self._btnWarList2 )
	self._txtWarInfoTitle	:AddChild( self._btnDeclaration )

	self._static_WarInfoBG	:SetSpanSize( 0, self._txtWarInfoTitle:GetSizeY() + 25 )
	self._static_WarInfoBG	:ComputePos()
	if isGameTypeEnglish() then
		self._btnWarList1		:SetSize( 100, 23 )
		self._btnWarList2		:SetSize( 100, 23 )
		self._btnDeclaration	:SetSize( 120, 23 )
		self._btnDeclaration	:SetSpanSize( 220, 22 )
	else
		self._btnWarList1		:SetSize( 70, 23 )
		self._btnWarList2		:SetSize( 70, 23 )
		self._btnDeclaration	:SetSize( 100, 23 )
		self._btnDeclaration	:SetSpanSize( 240, 22 )
	end
	self._btnWarList1		:SetPosX( 10 )
	self._btnWarList1		:SetPosY( 23 )
	self._btnWarList2		:SetPosX( self._btnWarList1:GetPosX() + self._btnWarList1:GetSizeX() )
	self._btnWarList2		:SetPosY( 23 )

	self._btnDeclaration	:ComputePos()

	self._static_WarInfoBG	:AddChild( self._txtNoWar )
	self._static_WarInfoBG	:AddChild( self._txtWarHelp )
	self._static_WarInfoBG	:AddChild( self._scroll )
	Panel_Window_Guild		:RemoveControl( self._txtNoWar )
	Panel_Window_Guild		:RemoveControl( self._txtWarHelp )
	Panel_Window_Guild		:RemoveControl( self._scroll )
	self._txtNoWar			:SetSpanSize( 30, 120 )
	self._txtNoWar			:ComputePos()
	self._txtWarHelp		:SetSpanSize( 5, 230 )
	self._txtWarHelp		:ComputePos()
	self._scroll			:ComputePos()

	self._btnWarList1		:addInputEvent( "Mouse_LUp", "HandleClicked_WarInfoUpdate( " .. 1 .. " )")
	self._btnWarList2		:addInputEvent( "Mouse_LUp", "HandleClicked_WarInfoUpdate( " .. 2 .. " )")
	self._btnDeclaration	:addInputEvent( "Mouse_LUp", "HandleClicked_LetsWarShow()")

	self._static_WarInfoBG	:SetIgnore( false )
	self._static_WarInfoBG	:addInputEvent(	"Mouse_UpScroll",	"GuildWarInfoPage_ScrollEvent( true )"	)
	self._static_WarInfoBG	:addInputEvent(	"Mouse_DownScroll",	"GuildWarInfoPage_ScrollEvent( false )"	)


	function createWarinfo( pIndex )
		local rtGuildWarInfo = {}
		rtGuildWarInfo._warBG 				= UI.createControl( UCT.PA_UI_CONTROL_STATIC,		self._static_WarInfoBG,	'Static_WarBG_' .. pIndex )
		rtGuildWarInfo._guildIconBG			= UI.createControl( UCT.PA_UI_CONTROL_STATIC,		rtGuildWarInfo._warBG,	'Static_GuildIconBG_' .. pIndex )
		rtGuildWarInfo._guildIcon 			= UI.createControl( UCT.PA_UI_CONTROL_STATIC,		rtGuildWarInfo._warBG,	'Static_GuildIcon_' .. pIndex )
		rtGuildWarInfo._txtGuildName 		= UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT,	rtGuildWarInfo._warBG,	'StaticText_GuildName_' .. pIndex )
		rtGuildWarInfo._guildWarScore 		= UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT,	rtGuildWarInfo._warBG,	'StaticText_Kill_' .. pIndex )
		rtGuildWarInfo._guildShowbuScore	= UI.createControl( UCT.PA_UI_CONTROL_STATICTEXT,	rtGuildWarInfo._warBG,	'StaticText_Death_' .. pIndex )
		rtGuildWarInfo._txtStopWar 			= UI.createControl( UCT.PA_UI_CONTROL_BUTTON,		rtGuildWarInfo._warBG,	'Button_WarStop_' .. pIndex )
		rtGuildWarInfo._txtShowbu 			= UI.createControl( UCT.PA_UI_CONTROL_BUTTON,		rtGuildWarInfo._warBG,	'Button_Showbu_' .. pIndex )
		rtGuildWarInfo._WarIcon 			= UI.createControl( UCT.PA_UI_CONTROL_STATIC,		rtGuildWarInfo._warBG,	'Static_WarIcon_' .. pIndex )
		rtGuildWarInfo._PenaltyType			= 0

		CopyBaseProperty( copyWarBG, 		rtGuildWarInfo._warBG )
		CopyBaseProperty( copyGuildIconBG, 	rtGuildWarInfo._guildIconBG )
		CopyBaseProperty( copyGuildIcon, 	rtGuildWarInfo._guildIcon )
		CopyBaseProperty( copyGuildName, 	rtGuildWarInfo._txtGuildName )
		CopyBaseProperty( copyKill, 		rtGuildWarInfo._guildWarScore )
		CopyBaseProperty( copyDeath, 		rtGuildWarInfo._guildShowbuScore )
		CopyBaseProperty( copyStopWar, 		rtGuildWarInfo._txtStopWar )
		CopyBaseProperty( copyShowbu, 		rtGuildWarInfo._txtShowbu )
		CopyBaseProperty( copyWarIcon, 		rtGuildWarInfo._WarIcon )

		rtGuildWarInfo._warBG				:SetSize( 315, rtGuildWarInfo._warBG:GetSizeY() )
		rtGuildWarInfo._warBG				:ComputePos()
		rtGuildWarInfo._guildIconBG			:ComputePos()
		rtGuildWarInfo._guildIcon			:ComputePos()
		rtGuildWarInfo._txtGuildName		:ComputePos()
		rtGuildWarInfo._guildWarScore		:ComputePos()
		rtGuildWarInfo._guildShowbuScore	:ComputePos()
		rtGuildWarInfo._txtStopWar			:ComputePos()
		rtGuildWarInfo._txtShowbu			:ComputePos()
		rtGuildWarInfo._WarIcon				:ComputePos()
		
		rtGuildWarInfo._warBG				:SetPosY( (pIndex * 51) + 5 )	
		rtGuildWarInfo._guildIconBG			:SetPosY( pIndex + 4 )
		rtGuildWarInfo._guildIcon			:SetPosY( pIndex + 5 )
		rtGuildWarInfo._txtGuildName		:SetPosY( pIndex + 7  )
		rtGuildWarInfo._guildWarScore		:SetPosY( pIndex + 25 )
		rtGuildWarInfo._guildShowbuScore	:SetPosY( pIndex + 25 )
		rtGuildWarInfo._txtStopWar			:SetPosY( pIndex + 5 )	 
		rtGuildWarInfo._WarIcon				:SetPosY( pIndex + 6 )	 
		
		rtGuildWarInfo._txtStopWar			:SetShow( false )
		rtGuildWarInfo._txtShowbu			:SetShow( false )
		
		-- rtGuildWarInfo._txtStopWar		:addInputEvent("Mouse_LUp", "HandleClickedStopWar("..pIndex..")")
		
		function rtGuildWarInfo:SetShow( isShow )
			rtGuildWarInfo._warBG				:SetShow(isShow)
			rtGuildWarInfo._guildIconBG			:SetShow(isShow)
			rtGuildWarInfo._guildIcon			:SetShow(isShow)
			rtGuildWarInfo._txtGuildName		:SetShow(isShow)
			rtGuildWarInfo._guildWarScore		:SetShow(isShow)
			rtGuildWarInfo._WarIcon				:SetShow(isShow)
			rtGuildWarInfo._txtStopWar			:SetShow(isShow)
			if isContentsGuildDuel then
				rtGuildWarInfo._txtShowbu			:SetShow(isShow)
				rtGuildWarInfo._guildShowbuScore	:SetShow(isShow)
			end
		end
		
		function rtGuildWarInfo:GetShow()
			return rtGuildWarInfo._warBG:GetShow()
		end
		
		function rtGuildWarInfo:SetData( pWarringGuild, gIdx )
			local isSet = false
			local guildNo_s64 = pWarringGuild:getGuildNo()
			if pWarringGuild:isExist() then
				isSet = setGuildTextureByGuildNo( guildNo_s64, rtGuildWarInfo._guildIcon )
			end
			
			if ( false == isSet ) then
				rtGuildWarInfo._guildIcon:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
				local x1, y1, x2, y2 = setTextureUV_Func( rtGuildWarInfo._guildIcon, 183, 1, 188, 6 )
				rtGuildWarInfo._guildIcon:getBaseTexture():setUV(  x1, y1, x2, y2  )
				rtGuildWarInfo._guildIcon:setRenderTexture(rtGuildWarInfo._guildIcon:getBaseTexture())
			else	
				rtGuildWarInfo._guildIcon:getBaseTexture():setUV(  0, 0, 1, 1  )
				rtGuildWarInfo._guildIcon:setRenderTexture(rtGuildWarInfo._guildIcon:getBaseTexture())
			end
			
			if pWarringGuild:isExist() then
				rtGuildWarInfo._txtGuildName:SetMonoTone( false )
				rtGuildWarInfo._txtGuildName:SetText( pWarringGuild:getGuildName() )
			else
				rtGuildWarInfo._txtGuildName:SetMonoTone( true )
				rtGuildWarInfo._txtGuildName:SetText( " " .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_DISSOLUTION") ) -- (해산됨)
			end
			
			local guildWarKillScore = tostring( Uint64toUint32( pWarringGuild:getKillCount() ) )
			local guildWarDeathScore = tostring( Uint64toUint32( pWarringGuild:getDeathCount() ) )
			rtGuildWarInfo._guildWarScore:SetText( PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_GUILDWARSCORE", "killCount", guildWarKillScore, "deathCount", guildWarDeathScore ) )	-- 전쟁 : <PAColor0xff00c0d7>{killCount}<PAOldColor> / <PAColor0xfff26a6a>{deathCount}<PAOldColor>
			rtGuildWarInfo._guildShowbuScore:EraseAllEffect()

			if isContentsGuildDuel then
				if( ToClient_IsGuildDuelingGuild(guildNo_s64) ) then	-- 결전 중이면 (컨텐츠 넘버 69)
					local guildDuelKillScore = tostring( ToClient_GetGuildDuelKillCount( guildNo_s64 ) )
					local guildDuelDeathScore = tostring( ToClient_GetGuildDuelDeathCount( guildNo_s64 ) )
					rtGuildWarInfo._guildShowbuScore:SetText( PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_GUILDDUELSCORE", "killCount", guildDuelKillScore, "deathCount", guildDuelDeathScore ) )	-- 결전 : <PAColor0xff00c0d7>{killCount}<PAOldColor> / <PAColor0xfff26a6a>{deathCount}<PAOldColor>

					local deadline	= ToClient_GetGuildDuelDeadline_s64(guildNo_s64)
					if deadline < toInt64(0,3600) then
	  					rtGuildWarInfo._guildShowbuScore:AddEffect("UI_Quest_Complete_GoldAura", true, 0, 0)
					end
				else
					rtGuildWarInfo._guildShowbuScore:addInputEvent( "Mouse_On",		"" )
					rtGuildWarInfo._guildShowbuScore:addInputEvent( "Mouse_Out",	"" )
					rtGuildWarInfo._guildShowbuScore:setTooltipEventRegistFunc(		"" )
					rtGuildWarInfo._guildShowbuScore:SetShow( false )
				end
			end

			local penaltyCount = pWarringGuild:getPenaltyCount()
			if 0 == penaltyCount then
				rtGuildWarInfo._WarIcon :SetShow( false )
			else
				rtGuildWarInfo._WarIcon	:ChangeTextureInfoName("New_UI_Common_forLua/Window/Guild/Guild_WarPenaltyIcon.dds")
				rtGuildWarInfo._WarIcon :SetShow( true )
			end

			rtGuildWarInfo._txtShowbu		:SetIgnore( false )
			rtGuildWarInfo._txtShowbu		:SetMonoTone( false )
			rtGuildWarInfo._txtStopWar		:addInputEvent("Mouse_LUp", "HandleClickedStopWar("..gIdx..")")
			rtGuildWarInfo._txtShowbu		:addInputEvent("Mouse_LUp", "HandleClickedGuildDuel("..gIdx..")")
			if(ToClient_IsGuildDuelingGuild(guildNo_s64)) then	-- 결전 중이면 
				rtGuildWarInfo._txtShowbu:SetIgnore( true )
				rtGuildWarInfo._txtShowbu:SetMonoTone( true )
				rtGuildWarInfo._txtShowbu:addInputEvent("Mouse_LUp", "")
			end
			
			rtGuildWarInfo._PenaltyType	= 7
		end
		 	
		return rtGuildWarInfo
	end
	for index = 0, (constCreateWarInfoCount - 1), 1 do
		self._list[index] = createWarinfo(index)
	end

	function createWarinfo2( pIndex )
		local rtGuildWarInfo = {}
		rtGuildWarInfo._warBG 			= UI.createAndCopyBasePropertyControl( Panel_Window_Guild, "Static_C_WarBG",				self._static_WarInfoBG,	"Static_WarBG2_".. pIndex )
		
		rtGuildWarInfo._guildIconBG 	= UI.createAndCopyBasePropertyControl( Panel_Window_Guild, "Static_C_EnemyGuild_IconBG",		rtGuildWarInfo._warBG,	"Static_GuildIconBG2_".. pIndex )
		rtGuildWarInfo._guildIcon 		= UI.createAndCopyBasePropertyControl( Panel_Window_Guild, "Static_C_EnemyGuild_Icon",		rtGuildWarInfo._warBG,	"Static_GuildIcon2_".. pIndex )
		rtGuildWarInfo._txtGuildName 	= UI.createAndCopyBasePropertyControl( Panel_Window_Guild, "StaticText_C_EnemyGuild_Name",	rtGuildWarInfo._warBG,	"StaticText_GuildName2_".. pIndex )
		rtGuildWarInfo._txtGuildMaster	= UI.createAndCopyBasePropertyControl( Panel_Window_Guild, "StaticText_C_Kill",		rtGuildWarInfo._warBG,	"StaticText_GuildShowbuScore2_".. pIndex )
		
		rtGuildWarInfo._warBG			:ComputePos()
		rtGuildWarInfo._guildIconBG		:ComputePos()
		rtGuildWarInfo._guildIcon		:ComputePos()
		rtGuildWarInfo._txtGuildName	:ComputePos()
		rtGuildWarInfo._txtGuildMaster	:ComputePos()
		
		rtGuildWarInfo._warBG			:SetSize( 315, rtGuildWarInfo._warBG:GetSizeY() )
		rtGuildWarInfo._warBG			:SetPosY( (pIndex * 51) + 5 )	
		rtGuildWarInfo._guildIconBG		:SetPosY( pIndex + 4 )
		rtGuildWarInfo._guildIcon		:SetPosY( pIndex + 5 )
		rtGuildWarInfo._txtGuildName	:SetPosY( pIndex + 7  )
		rtGuildWarInfo._txtGuildMaster	:SetPosY( pIndex + 27 )

		function rtGuildWarInfo:SetShow( isShow )
			rtGuildWarInfo._warBG			:SetShow( isShow )
			rtGuildWarInfo._guildIconBG		:SetShow( isShow )
			rtGuildWarInfo._guildIcon		:SetShow( isShow )
			rtGuildWarInfo._txtGuildName	:SetShow( isShow )
			rtGuildWarInfo._txtGuildMaster	:SetShow( isShow )
		end
		
		function rtGuildWarInfo:GetShow()
			return rtGuildWarInfo._warBG:GetShow()
		end
		
		function rtGuildWarInfo:SetData( guildWrapper )
			if nil ~= guildWrapper then
				local guildNo_s64 = tostring(guildWrapper:getGuildNo_s64())
				local isSet = setGuildTextureByGuildNo( guildWrapper:getGuildNo_s64(), rtGuildWarInfo._guildIcon )
				
				if ( false == isSet ) then
					rtGuildWarInfo._guildIcon:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
					local x1, y1, x2, y2 = setTextureUV_Func( rtGuildWarInfo._guildIcon, 183, 1, 188, 6 )
					rtGuildWarInfo._guildIcon:getBaseTexture():setUV(  x1, y1, x2, y2  )
					rtGuildWarInfo._guildIcon:setRenderTexture(rtGuildWarInfo._guildIcon:getBaseTexture())
				else	
					rtGuildWarInfo._guildIcon:getBaseTexture():setUV(  0, 0, 1, 1  )
					rtGuildWarInfo._guildIcon:setRenderTexture(rtGuildWarInfo._guildIcon:getBaseTexture())
				end
				rtGuildWarInfo._txtGuildName		:SetText( guildWrapper:getName() )
				rtGuildWarInfo._txtGuildMaster		:SetText( guildWrapper:getGuildMasterName() )
			end
		end

		rtGuildWarInfo._warBG			:SetIgnore( false )
		rtGuildWarInfo._guildIconBG		:SetIgnore( false )
		rtGuildWarInfo._guildIcon		:SetIgnore( false )
		rtGuildWarInfo._txtGuildName	:SetIgnore( false )

		rtGuildWarInfo._warBG			:addInputEvent(	"Mouse_UpScroll",	"GuildWarInfoPage_ScrollEvent( true )"	)
		rtGuildWarInfo._warBG			:addInputEvent(	"Mouse_DownScroll",	"GuildWarInfoPage_ScrollEvent( false )"	)
		rtGuildWarInfo._guildIcon		:addInputEvent(	"Mouse_UpScroll",	"GuildWarInfoPage_ScrollEvent( true )"	)
		rtGuildWarInfo._guildIcon		:addInputEvent(	"Mouse_DownScroll",	"GuildWarInfoPage_ScrollEvent( false )"	)
		rtGuildWarInfo._txtGuildName	:addInputEvent(	"Mouse_UpScroll",	"GuildWarInfoPage_ScrollEvent( true )"	)
		rtGuildWarInfo._txtGuildName	:addInputEvent(	"Mouse_DownScroll",	"GuildWarInfoPage_ScrollEvent( false )"	)
	 	
	 	UIScroll.InputEvent( self._scroll, "GuildWarInfoPage_ScrollEvent" )

		return rtGuildWarInfo
	end
	for index = 0, (constCreateWarInfoCount - 1), 1 do
		self._list2[index] = createWarinfo2(index)
	end
	
	self._txtNoWar:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_NOWAR" ) )
	self._txtNoWar:SetShow(false)
	
	self._txtWarHelp:SetTextMode( UI_TM.eTextMode_AutoWrap )
	self._txtWarHelp:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_WARHELP" ) )

	self._scroll:SetShow( false )
	
	UI.deleteControl(copyWarBG)
	UI.deleteControl(copyGuildIcon)
	UI.deleteControl(copyGuildName)
	UI.deleteControl(copyKill)
	UI.deleteControl(copyDeath)
	UI.deleteControl(copyStopWar)
	UI.deleteControl(copyShowbu)
		
	copyWarBG		= nil
	copyGuildIcon	= nil
	copyGuildName	= nil
	copyKill		= nil
	copyDeath		= nil
	copyWarBG		= nil

	self._txtWarInfoTitle:SetSpanSize( 50, 395 )
	self._txtWarInfoTitle:ComputePos()
	self._scroll:SetControlTop()
end

function GuildWarInfoPage_ScrollEvent( isUp )
	local	self		= GuildWarInfoPage
	self._startIndex	= UIScroll.ScrollEvent( self._scroll, isUp, self.slotMaxCount, self._listCount, self._startIndex, 1 )

	self:UpdateData()
end

-- 전쟁 선포 중지 버튼
function HandleClickedStopWar(index)
	ToClient_RequestStopGuildWar(index)
end

-- 전쟁 현황 업데이트
function GuildWarInfoPage:UpdateData()
	for index = 0, (constCreateWarInfoCount - 1), 1 do	-- 선포한 리스트 초기화
		self._list[index]:SetShow(false)
	end
	for index = 0, (constCreateWarInfoCount - 1), 1 do	-- 선포받은 리스트 초기화
		self._list2[index]:SetShow(false)
	end

	self._listCount	= 0
	self._scroll	:SetShow( false )

	-- 선포받은 리스트 요청.
	ToClient_RequestDeclareGuildWarToMyGuild()

	if self._btnWarList1:IsCheck() then
		self._listCount = ToClient_GetWarringGuildListCount()
		UIScroll.SetButtonSize( self._scroll, self.slotMaxCount, self._listCount )	-- 스크롤 버튼 크기
		if 0 == self._listCount then	-- "현재 전쟁중인 길드가 없습니다" 문구 호출 용도
			self._txtNoWar:SetShow(true)
		else
			if constCreateWarInfoCount < self._listCount then
				self._scroll:SetShow( true )
			end

			local uiIdx = 0
			for index=self._startIndex, self._listCount-1 do
				if constCreateWarInfoCount <= uiIdx then
					break
				end
				if index < self._listCount then
					self._txtNoWar:SetShow(false)
					self._list[uiIdx]:SetShow(true)
					self._list[uiIdx]:SetData( ToClient_GetWarringGuildListAt(index), index )

					self._list[uiIdx]._WarIcon		:addInputEvent( "Mouse_On", "Panel_Guild_Tab_ToolTip_Func( " .. self._list[uiIdx]._PenaltyType ..", true, " .. uiIdx .. " )" )
					self._list[uiIdx]._WarIcon		:addInputEvent( "Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( " .. self._list[uiIdx]._PenaltyType ..", false, " .. uiIdx .. " )" )
					self._list[uiIdx]._WarIcon		:setTooltipEventRegistFunc( "Panel_Guild_Tab_ToolTip_Func( " .. self._list[uiIdx]._PenaltyType ..", true, " .. uiIdx .. " )" )

					self._list[uiIdx]._txtStopWar	:addInputEvent( "Mouse_On", "Panel_Guild_Tab_ToolTip_Func( " .. 9 ..", true, " .. uiIdx .. " )" )
					self._list[uiIdx]._txtStopWar	:addInputEvent( "Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( " .. 9 ..", false, " .. uiIdx .. " )" )
					self._list[uiIdx]._txtStopWar	:setTooltipEventRegistFunc( "Panel_Guild_Tab_ToolTip_Func( " .. 9 ..", true, " .. uiIdx .. " )" )
					self._list[uiIdx]._txtShowbu	:addInputEvent( "Mouse_On", "Panel_Guild_Tab_ToolTip_Func( " .. 10 ..", true, " .. uiIdx .. " )" )
					self._list[uiIdx]._txtShowbu	:addInputEvent( "Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( " .. 10 ..", false, " .. uiIdx .. " )" )
					self._list[uiIdx]._txtShowbu	:setTooltipEventRegistFunc( "Panel_Guild_Tab_ToolTip_Func( " .. 10 ..", true, " .. uiIdx .. " )" )

					if isContentsGuildDuel then
						self._list[uiIdx]._guildShowbuScore:addInputEvent( "Mouse_On",	"HandleOnOut_GuildDuelInfo_Tooltip( true,	" .. index .. ", " .. 	uiIdx .. " )" )
						self._list[uiIdx]._guildShowbuScore:addInputEvent( "Mouse_Out",	"HandleOnOut_GuildDuelInfo_Tooltip( false,	" .. index .. ", " .. 	uiIdx .. " )" )
						self._list[uiIdx]._guildShowbuScore:setTooltipEventRegistFunc(	"HandleOnOut_GuildDuelInfo_Tooltip( true,	" .. index .. ", " .. uiIdx .. " )" )
					end

					local isGuildMaster		= getSelfPlayer():get():isGuildMaster()
					local isGuildSubMaster	= getSelfPlayer():get():isGuildSubMaster()
					if true == isGuildMaster or true == isGuildSubMaster then
						self._list[uiIdx]._txtStopWar	:SetShow(true)
						self._list[uiIdx]._txtShowbu	:SetShow( true and isContentsGuildDuel )
					else
						self._list[uiIdx]._txtStopWar	:SetShow(false)
						self._list[uiIdx]._txtShowbu	:SetShow(false )
					end
				else	
					self._list[uiIdx]:SetShow(false)
				end
				uiIdx = uiIdx + 1
			end	
		end
	else
		self._listCount = ToClient_GetCountDeclareGuildWarToMyGuild()
		UIScroll.SetButtonSize( self._scroll, self.slotMaxCount, self._listCount )	-- 스크롤 버튼 크기

		if 0 == self._listCount then	-- "현재 전쟁중인 길드가 없습니다" 문구 호출 용도
			self._txtNoWar:SetShow(true)
		else
			for index = 0, constCreateWarInfoCount - 1 do
				self._list2[index]:SetShow(false)
			end

			if constCreateWarInfoCount < self._listCount then
				self._scroll:SetShow( true )
			end

			local uiIdx = 0
			for index= self._startIndex, self._listCount -1 do
				if constCreateWarInfoCount <= uiIdx then
					break
				end

				self._txtNoWar:SetShow(false)
				local guildNo		= ToClient_GetDeclareGuildWarToMyGuild_s64( index )
				local guildWrapper	= ToClient_GetGuildInfoWrapperByGuildNo( guildNo )
				self._list2[uiIdx]:SetShow(true)
				self._list2[uiIdx]:SetData( guildWrapper )
				uiIdx = uiIdx + 1
			end
		end
		
	end
end

local warInfoTypeIsMine = true
function HandleClicked_WarInfoUpdate( typeNo )
	local self = GuildWarInfoPage
	if 1 == typeNo then
		if true == warInfoTypeIsMine then
			return
		end
		warInfoTypeIsMine = true
		self._startIndex = 0
		self._scroll:SetControlTop()
		-- GuildWarInfoPage._btnWarList1:SetCheck( true )
		-- GuildWarInfoPage._btnWarList2:SetCheck( false )
	else
		if false == warInfoTypeIsMine then
			return
		end
		warInfoTypeIsMine = false
		self._startIndex = 0
		self._scroll:SetControlTop()
		-- GuildWarInfoPage._btnWarList1:SetCheck( false )
		-- GuildWarInfoPage._btnWarList2:SetCheck( true )
	end
	self:UpdateData()
end

----------------------------------------------------------------------------------------------------------------
------------ 길드 창 관리 (최상위)
----------------------------------------------------------------------------------------------------------------
GuildManager = 
{
	_mainTagName		= UI.getChildControl ( Panel_Window_Guild, "StaticText_MenuTag" ),
	_doHaveSeige		= false,
}
--[[
GuildWarfareInfoPage
	initialize()
	TabToggle( index )
	Show()
	Hide()	
]]--

local _txt_Help_History 		= UI.getChildControl ( Panel_Window_Guild, "StaticText_Help_History" )
local _txt_Help_GuildMember 	= UI.getChildControl ( Panel_Window_Guild, "StaticText_Help_GuildMember" )
local _txt_Help_GuildQuest 		= UI.getChildControl ( Panel_Window_Guild, "StaticText_Help_GuildQuest" )
local _txt_Help_GuildSkill 		= UI.getChildControl ( Panel_Window_Guild, "StaticText_Help_GuildSkill" )
local _txt_Help_WarInfo 		= UI.getChildControl ( Panel_Window_Guild, "StaticText_Help_WarInfo" )

------------------------------------------------------
--				최초 초기화 해주는 함수
------------------------------------------------------
function GuildManager:initialize()
	-- 상위 탭 버튼------------------------------------------
	self.mainBtn_Main			= UI.getChildControl ( Panel_Window_Guild, "Button_Tab_Main" )
	self.mainBtn_History		= UI.getChildControl ( Panel_Window_Guild, "Button_Tab_History" )
	self.mainBtn_Info			= UI.getChildControl ( Panel_Window_Guild, "Button_Tab_GuildInfo" )
	self.mainBtn_Quest   		= UI.getChildControl ( Panel_Window_Guild, "Button_Tab_GuildQuest" )
	self.mainBtn_Tree    		= UI.getChildControl ( Panel_Window_Guild, "Button_Tab_Skill" )
	self.mainBtn_Warfare 		= UI.getChildControl ( Panel_Window_Guild, "Button_Tab_Warfare" )
	self.mainBtn_Recruitment	= UI.getChildControl ( Panel_Window_Guild, "Button_Tab_Recruitment" )
	self.mainBtn_CraftInfo		= UI.getChildControl ( Panel_Window_Guild, "Button_Tab_CraftInfo" )
	self.closeButton 			= UI.getChildControl ( Panel_Window_Guild, "Button_Close" )
	self._buttonQuestion		= UI.getChildControl ( Panel_Window_Guild, "Button_Question" )		-- 물음표 버튼
	
	
	self.mainBtn_Main			:addInputEvent( "Mouse_LUp", "GuildManager:TabToggle( 99 )" )
	self.mainBtn_History		:addInputEvent( "Mouse_LUp", "GuildManager:TabToggle( 0 )" )
	self.mainBtn_Info			:addInputEvent( "Mouse_LUp", "GuildManager:TabToggle( 1 )" )
	self.mainBtn_Quest			:addInputEvent( "Mouse_LUp", "GuildManager:TabToggle( 2 )" )
	self.mainBtn_Tree			:addInputEvent( "Mouse_LUp", "GuildManager:TabToggle( 3 )" )
	self.mainBtn_Warfare		:addInputEvent( "Mouse_LUp", "GuildManager:TabToggle( 4 )" )
	self.mainBtn_Recruitment	:addInputEvent( "Mouse_LUp", "GuildManager:TabToggle( 5 )" )
	self.mainBtn_CraftInfo		:addInputEvent( "Mouse_LUp", "GuildManager:TabToggle( 6 )" )
	
	self.closeButton			:addInputEvent("Mouse_LUp", "HandleClickedGuildHideButton()")
	self._buttonQuestion		:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelGuild\" )")					-- 물음표 좌클릭
	self._buttonQuestion		:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelGuild\", \"true\")")			-- 물음표 마우스오버
	self._buttonQuestion		:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelGuild\", \"false\")")			-- 물음표 마우스아웃
	
	self.mainBtn_Main			:addInputEvent( "Mouse_On", "Panel_Guild_Tab_ToolTip_Func( 99, true )" )
	self.mainBtn_History		:addInputEvent( "Mouse_On", "Panel_Guild_Tab_ToolTip_Func( 5, true )" )
	self.mainBtn_Info			:addInputEvent( "Mouse_On", "Panel_Guild_Tab_ToolTip_Func( 0, true )" )
	self.mainBtn_Quest			:addInputEvent( "Mouse_On", "Panel_Guild_Tab_ToolTip_Func( 1, true )" )
	self.mainBtn_Tree			:addInputEvent( "Mouse_On", "Panel_Guild_Tab_ToolTip_Func( 2, true )" )
	self.mainBtn_Warfare		:addInputEvent( "Mouse_On", "Panel_Guild_Tab_ToolTip_Func( 3, true )" )
	self.mainBtn_Recruitment	:addInputEvent( "Mouse_On", "Panel_Guild_Tab_ToolTip_Func( 4, true )" )

	self.mainBtn_Main			:addInputEvent( "Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( 99, false )" )
	self.mainBtn_History		:addInputEvent( "Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( 5, false )" )
	self.mainBtn_Info			:addInputEvent( "Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( 0, false )" )
	self.mainBtn_Quest			:addInputEvent( "Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( 1, false )" )
	self.mainBtn_Tree			:addInputEvent( "Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( 2, false )" )
	self.mainBtn_Warfare		:addInputEvent( "Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( 3, false )" )
	self.mainBtn_Recruitment	:addInputEvent( "Mouse_Out", "Panel_Guild_Tab_ToolTip_Func( 4, false )" )

	self.mainBtn_Main			:setTooltipEventRegistFunc( "Panel_Guild_Tab_ToolTip_Func( 99, true )" )
	self.mainBtn_History		:setTooltipEventRegistFunc( "Panel_Guild_Tab_ToolTip_Func( 5, true )" )
	self.mainBtn_Info			:setTooltipEventRegistFunc( "Panel_Guild_Tab_ToolTip_Func( 0, true )" )
	self.mainBtn_Quest			:setTooltipEventRegistFunc( "Panel_Guild_Tab_ToolTip_Func( 1, true )" )
	self.mainBtn_Tree			:setTooltipEventRegistFunc( "Panel_Guild_Tab_ToolTip_Func( 2, true )" )
	self.mainBtn_Warfare		:setTooltipEventRegistFunc( "Panel_Guild_Tab_ToolTip_Func( 3, true )" )
	self.mainBtn_Recruitment	:setTooltipEventRegistFunc( "Panel_Guild_Tab_ToolTip_Func( 4, true )" )

	GuildInfoPage:initialize()		-- 길드정보 초기화
	GuildLetsWarPage:initialize()	-- 길드 전쟁선포 초기화
	GuildWarInfoPage:initialize()	-- 길드 전쟁 현황 초기화
--	GuildWarInfoPage._scrollBTN	= UI.getChildControl ( GuildWarInfoPage._scroll, "Scroll_CtrlButton" )
--	Panel_Window_Guild:SetChildIndex(GuildWarInfoPage._scroll, 9999 )	-- 스크롤을 가장 위로
	
	-- 다른 lua 파일에 선언됨-------------------------------------------------------
	GuildListInfoPage:initialize()				-- 길드원 현황 초기화
	GuildQuestInfoPage:initialize()				-- 길드 임무 초기화
	-- GuildProgressQuestInfoPage:initialize() 	-- 길드 임무 퀘스트 좌측 상단 표시
	GuildWarfareInfoPage:initialize() 			-- 길드 전쟁 현황 초기화
	GuildSkillFrame_Init()						-- 길드 스킬 초기화
	Guild_Recruitment_Initialize()				-- 길드 모집 초기화.
	FGlobal_Guild_CraftInfo_Init()				-- 길드 하우스 제작 정보 초기화
	---------------------------------------------------------------------------------
		
	function self:ChangeTab( pText, pX1, pY1, pX2, pY2)
		local x1, y1, x2, y2 = setTextureUV_Func( self._mainTagName, pX1, pY1, pX2, pY2 )
		self._mainTagName:SetText( pText )
		self._mainTagName:getBaseTexture():setUV(  x1, y1, x2, y2  )
		self._mainTagName:setRenderTexture(self._mainTagName:getBaseTexture())
	end
end

-- 'x' 버튼 클릭
function HandleClickedGuildHideButton()
	GuildManager:Hide()--FGlobal_guildWindow_Hide()
	-- GuildLetsWarPage._editLetsWarInputName:SetEditText('', true)
end

function Panel_Guild_Tab_ToolTip_Func( tabNo, isOn, inPut_index )
	if true == isOn then
		local uiControl, name, desc = nil
		if 0 == tabNo then
			uiControl	= GuildManager.mainBtn_Info
			name		= PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDLIST" )			-- 길드원 목록
			desc		= nil
		elseif 1 == tabNo then
			uiControl	= GuildManager.mainBtn_Quest
			name		= PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDQUEST" )			-- 길드 의뢰
			desc		= nil
			
		elseif 2 == tabNo then
			uiControl	= GuildManager.mainBtn_Tree
			name		= PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDSKILL" )			-- 길드 기술
			desc		= nil
			
		elseif 3 == tabNo then
			uiControl	= GuildManager.mainBtn_Warfare
			name		= PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDWARFAREINFO" )	-- 점령전 정보
			desc		= nil
			
		elseif 4 == tabNo then
			uiControl	= GuildManager.mainBtn_Recruitment
			name		= PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_RECRUITMENTGUILD")			-- 길드원 모집
			desc		= nil
			
		elseif 5 == tabNo then
			uiControl	= GuildManager.mainBtn_History
			name		= PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDHISTORY" )		-- 길드 연혁
			desc		= nil
			
		elseif 6 == tabNo then
			uiControl	= GuildInfoPage._btnIncreaseMember
			name		= PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_HELP_WARINFO")				-- 길드원 증가
			desc		= nil

		elseif 7 == tabNo then
			uiControl	= GuildWarInfoPage._list[inPut_index]._WarIcon
			name		= PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_PENALTY")					-- 페널티 적용중
			desc		= nil
		elseif 8 == tabNo then
			uiControl	= GuildInfoPage._btnProtectAdd
			name		= PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_HELP_PROTECTADD")			-- 보호 인원 증가
			desc		= PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_PROTECTADD_DESC")
		elseif 9 == tabNo then
			uiControl	= GuildWarInfoPage._list[inPut_index]._txtStopWar
			name		= PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_WARSTOP")					-- "길드 전쟁 중지"
			desc		= nil
		elseif 10 == tabNo then
			uiControl	= GuildWarInfoPage._list[inPut_index]._txtShowbu
			name		= PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_WARREQUEST")					-- "길드 결전 신청"
			desc		= nil
		elseif 99 == tabNo then
			uiControl	= GuildManager.mainBtn_Main
			name		= PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDINFO_TITLE")			-- 길드 정보
			desc		= nil
		end

		registTooltipControl( uiControl, Panel_Tooltip_SimpleText ) 
		TooltipSimple_Show( uiControl, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function GuildSimplTooltips( isShow, tipType )
	local name, desc, control = nil, nil, nil
	if 0 == tipType then
		name	= PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMASTER_MANDATE_TOOLTIP_NAME") -- 대장 위임 받기
		desc	= PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMASTER_MANDATE_TOOLTIP_DESC") -- 길드 대장이 30일 동안 접속하지 않으면 길드를 위임받을 수 있습니다.\n대장 권한을 위임받기 위해서는 천만 길드자금이 있어야합니다.
		control	= btn_GuildMasterMandate
	elseif 1 == tipType then
		name	= PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMASTER_MANDATE_TOOLTIP_NAME") -- 대장 위임 받기
		desc	= PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMASTER_MANDATE_TOOLTIP_DESC") -- 길드 대장이 30일 동안 접속하지 않으면 길드를 위임받을 수 있습니다.\n대장 권한을 위임받기 위해서는 천만 길드자금이 있어야합니다.
		control	= btn_GuildMasterMandateBG
	elseif 2 == tipType then
		name	= PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMARK_BTN_TOOLTIP_NAME") -- 길드 문장 등록/변경
		desc	= PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMARK_BTN_TOOLTIP_DESC") -- 길드 문장 등록 및 변경하기 위해서는 길드상인에게 '길드 문장 등록증'을 구매해야 합니다.\n길드 문장은 매주 월요일에만 변경 및 등록할 수 있습니다.
		control	= GuildInfoPage._btnChangeMark
	elseif 3 == tipType then
		if getSelfPlayer():get():isGuildMaster() then
			name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_DISPERSE_GUILD") -- 길드 해산
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDDEL_BTN_TOOLTIP_DESC") -- 길드원이 없을 경우에만 길드를 해체할 수 있습니다.
		else
			name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_WITHDRAW_GUILD") -- 길드 탈퇴
			desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDDEL_BTN_TOOLTIP_DESC2") -- 길드를 탈퇴할 수 있습니다.\n길드를 탈퇴하게되면 24시간 동안 길드 가입이 제한됩니다.
		end
		control	= GuildInfoPage._btnGuildDel
	elseif 4 == tipType then
		name = "길드 이름"
		control = GuildInfoPage._txtRGuildName
	elseif 5 == tipType then
		name = "길드 대장 가문명"
		control = GuildInfoPage._txtRMaster
	end

	registTooltipControl(control, Panel_Tooltip_SimpleText)
	if true == isShow then
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end

--------------------------------------------------------------------------------
--							탭을 눌렀을 때의 함수
--------------------------------------------------------------------------------
function GuildManager:TabToggle( index )
	self._mainTagName:ChangeTextureInfoName("New_UI_Common_forLua/Window/Guild/Guild_00.dds")
	tabNumber = 99
	
	self.mainBtn_Main		:SetCheck( index == 99 )	-- index = 99
	self.mainBtn_History	:SetCheck( index == 0 )		-- index = 0
	self.mainBtn_Info		:SetCheck( index == 1 )		-- index = 1
	self.mainBtn_Quest		:SetCheck( index == 2 )		-- index = 2
	self.mainBtn_Tree		:SetCheck( index == 3 )		-- index = 3
	self.mainBtn_Warfare	:SetCheck( index == 4 )		-- index = 4
	self.mainBtn_Recruitment:SetCheck( index == 5 )		-- index = 5
	self.mainBtn_CraftInfo	:SetCheck( index == 6 )		-- index = 6
	
	-- 웹 초기화
	FGlobal_ClearCandidate()
	_Web:ResetUrl()

	if ( 0 == index ) then		-- 히스토리
		self:ChangeTab( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDHISTORY" ) , 92, 1, 104, 15 )
		FGlobal_GuildHistory_Show( true )
		GuildListInfoPage:Hide()
		GuildQuestInfoPage:Hide()
		GuildWarfareInfoPage:Hide()
		GuildSkillFrame_Hide()
		Guild_Recruitment_Close()
		GuildMainInfo_Hide()
		btn_GuildMasterMandateBG	:SetShow( false )
		btn_GuildMasterMandate		:SetShow( false )

		tabNumber = 0
	elseif ( 1 == index ) then	-- 길드원 현황
		local myGuildInfo	= ToClient_GetMyGuildInfoWrapper()
		local guildGrade	= nil
		if nil ~= myGuildInfo then
			guildGrade	= myGuildInfo:getGuildGrade()
		end
		if 0 == guildGrade then
			self:ChangeTab( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_CLAN_MEMBERINFO") , 107, 1, 119, 15 )
		else
			self:ChangeTab( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDLIST" ) , 107, 1, 119, 15 )
		end
		FGlobal_GuildHistory_Show( false )
		GuildListInfoPage:Show()
		GuildQuestInfoPage:Hide()
		GuildWarfareInfoPage:Hide()
		GuildSkillFrame_Hide()
		Guild_Recruitment_Close()
		GuildMainInfo_Hide()
		btn_GuildMasterMandateBG	:SetShow( false )
		btn_GuildMasterMandate		:SetShow( false )
		tabNumber = 1
	elseif ( 2 == index ) then	-- 길드 임무
		self:ChangeTab( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDQUEST" ), 122, 1, 134, 15 )
		FGlobal_GuildHistory_Show( false )
		GuildListInfoPage:Hide()
		GuildQuestInfoPage:Show()
		GuildWarfareInfoPage:Hide()
		GuildSkillFrame_Hide()
		GuildMainInfo_Hide()
		Guild_Recruitment_Close()
		btn_GuildMasterMandateBG	:SetShow( false )
		btn_GuildMasterMandate		:SetShow( false )
		tabNumber = 2
	elseif ( 3 == index ) then	-- 길드 스킬
		self:ChangeTab( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDSKILL" ) , 137, 1, 149, 15 )
		FGlobal_GuildHistory_Show( false )
		GuildListInfoPage:Hide()
		GuildQuestInfoPage:Hide()
		GuildWarfareInfoPage:Hide()
		GuildSkillFrame_Show()
		GuildMainInfo_Hide()
		Guild_Recruitment_Close()
		btn_GuildMasterMandateBG	:SetShow( false )
		btn_GuildMasterMandate		:SetShow( false )
		tabNumber = 3
	elseif ( 4 == index ) then	-- 전쟁 정보	
		self:ChangeTab( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDWARFAREINFO" ), 152, 1, 164, 15 )
		FGlobal_GuildHistory_Show( false )
		GuildListInfoPage:Hide()
		GuildQuestInfoPage:Hide()
		GuildWarfareInfoPage:Show()
		GuildSkillFrame_Hide()
		GuildMainInfo_Hide()
		Guild_Recruitment_Close()
		btn_GuildMasterMandateBG	:SetShow( false )
		btn_GuildMasterMandate		:SetShow( false )
		tabNumber = 4
	elseif ( 5 == index ) then	-- 길드원 모집
		-- 길마가 아니면 리턴
		local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
		if not getSelfPlayer():get():isGuildMaster() and not getSelfPlayer():get():isGuildSubMaster() then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_ONLYMASTER") ) -- "길드 대장, 부대장만 이용할 수 있습니다.")
			return
		end

		self:ChangeTab( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_RECRUITMENTGUILD"), 152, 1, 164, 15 )
		FGlobal_GuildHistory_Show( false )
		GuildListInfoPage:Hide()
		GuildQuestInfoPage:Hide()
		GuildWarfareInfoPage:Hide()
		GuildSkillFrame_Hide()
		GuildMainInfo_Hide()
		Guild_Recruitment_Open()
		btn_GuildMasterMandateBG	:SetShow( false )
		btn_GuildMasterMandate		:SetShow( false )
		tabNumber = 5
	elseif ( 99 == index ) then
		GuildMainInfo_Show()
		FGlobal_GuildHistory_Show( false )
		self:ChangeTab( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDINFO_TITLE"), 446, 2, 458, 14 )
		GuildListInfoPage:Hide()
		GuildQuestInfoPage:Hide()
		GuildWarfareInfoPage:Hide()
		GuildSkillFrame_Hide()
		Guild_Recruitment_Close()
		GuildComment_Load()
		tabNumber = 99
	elseif ( 6 == index ) then	-- 길드 하우스 제작 정보
		self:ChangeTab( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDCRAFTINFO_TITLE"), 461, 2, 473, 14 )
		FGlobal_GuildHistory_Show( false )
		GuildMainInfo_Hide()
		GuildListInfoPage:Hide()
		GuildQuestInfoPage:Hide()
		GuildWarfareInfoPage:Hide()
		GuildSkillFrame_Hide()
		Guild_Recruitment_Close()
		btn_GuildMasterMandateBG	:SetShow( false )
		btn_GuildMasterMandate		:SetShow( false )
		
		tabNumber = 6
	end

	FGlobal_Guild_CraftInfo_Open( 6 == index )

	FGlobal_GuildMenuButtonHide()
end


--------------------------------------------------------------------------------
--							길드창 켜고 끄는 함수 (globalKeyBinder.lua 에서 사용)
--------------------------------------------------------------------------------

function GuildManager:Hide()
	if( false == Panel_Window_Guild:IsShow() ) then
		return
	end

	Panel_Window_Guild:SetShow( false, true )
	HelpMessageQuestion_Out()		-- 물음표 버튼 툴팁 끄기
	
	FGlobal_AgreementGuild_Close()
	agreementGuild_Master_Close()
	Panel_GuildIncentiveOption_Close()
	HandleClicked_LetsWarHide()
	FGlobal_GuildMenuButtonHide()
	TooltipSimple_Hide()
	TooltipGuild_Hide()
	
	if( AllowChangeInputMode() ) then
		ClearFocusEdit()
		if( check_ShowWindow() ) then
			UI.Set_ProcessorInputMode( IM.eProcessorInputMode_UiMode )
		else
			UI.Set_ProcessorInputMode( IM.eProcessorInputMode_GameMode)
		end
	else
		SetFocusChatting()
	end

	FGlobal_ClearCandidate()
	_Web:ResetUrl()
end

function GuildManager:Show()
	if false == Panel_Window_Guild:IsShow() then
		local myGuildInfo		= ToClient_GetMyGuildInfoWrapper()
		local isGuildMaster		= getSelfPlayer():get():isGuildMaster()
		local isGuildSubMaster	= getSelfPlayer():get():isGuildSubMaster()
		if myGuildInfo ~= nil then
			GuildManager._doHaveSeige = myGuildInfo:doHaveOccupyingSiege()
		end
		
		local isAdmin = 0 		-- 0 : 길마 or 길마가 아님, 1: 길마 또는 부길마
		if ( isGuildMaster or isGuildSubMaster ) then
			isAdmin = 1
		end

		self.mainBtn_Main:SetCheck( true )
		self.mainBtn_Info:SetCheck( false )
		self.mainBtn_Quest:SetCheck( false )
		self.mainBtn_Tree:SetCheck( false )
		self.mainBtn_Warfare:SetCheck( false )
		self.mainBtn_History:SetCheck( false )
		self.mainBtn_Recruitment:SetCheck( false )

		GuildWarInfoPage._btnWarList1:SetCheck( true )	-- 업데이트보다 먼저 되어야 한다. 선포한 리스트를 기본 값으로 뿌린다.
		GuildWarInfoPage._btnWarList2:SetCheck( false )
		GuildWarInfoPage._startIndex = 0
		GuildWarInfoPage._scroll:SetControlPos(0)

		GuildManager:TabToggle( 99 )

		GuildMainInfo_MandateBtn() -- 길드 마스터 위임 버튼 관련 권한 처리.
		

		GuildInfoPage:UpdateData()
		GuildListInfoPage:UpdateData()
		GuildLetsWarPage:UpdateData()
		GuildWarInfoPage:UpdateData()
		GuildSkillFrame_Update()
		FGlobal_Notice_Update()
		GuildIntroduce_Update()
		FromClient_ResponseGuildNotice()
		FGlobal_GuildListScrollTop()	-- 길드 창을 열고 닫을 때마다 길드리스트 프레임 스크롤이 Top 위치에 있지 않아서 실행해줌.
		-- 길드 리메인 타임을 적용한다.
		guildQuest_ProgressingGuildQuest_UpdateRemainTime()
		-- QuestWidget_ProgressingGuildQuest_UpdateRemainTime()
		-- FGlobal_GuildListOnlineCheck()		-- 사용하지 않기 때문에 주석 처리.
		Panel_Window_Guild:SetShow( true, true )
		ToClient_RequestGuildUnjoinedPlayerList()	-- 길드 가입하지 않은 유저 목록을 가져온다.
		
		GuildComment_Load()
	end
end

function GuildComment_Load()
	local guildWrapper		= ToClient_GetMyGuildInfoWrapper()
	if nil == guildWrapper then
		return
	end
	
	local guildNo_s64	= guildWrapper:getGuildNo_s64()
	local myUserNo		= getSelfPlayer():get():getUserNo()
	local cryptKey		= getSelfPlayer():get():getWebAuthenticKeyCryptString()
	guildCommentsWebUrl	= guildCommentsUrlByServiceType()
	
	-- 오늘의 한 마디 : 한국에만 나오도록 수정
	if nil ~= guildCommentsWebUrl then
		FGlobal_SetCandidate()
		local url	= guildCommentsWebUrl .. "?guildNo=" .. tostring(guildNo_s64) .. "&userNo=" .. tostring(myUserNo) .. "&certKey=" .. tostring(cryptKey) .. "&isMaster=" .. tostring(isAdmin)
		_Web:SetUrl( 323, 272, url )
		_Web:SetIME(true)
	end
end


function GuildMainInfo_MandateBtn()
	if 99 ~= tabNumber then
		return
	end
	local myGuildInfo		= ToClient_GetMyGuildInfoWrapper()
	if nil == myGuildInfo then
		return
	end

	local isGuildMaster		= getSelfPlayer():get():isGuildMaster()
	local isGuildSubMaster	= getSelfPlayer():get():isGuildSubMaster()

	if toInt64(0,-1) == myGuildInfo:getGuildMasterUserNo() then
		if not isGuildMaster then
			btn_GuildMasterMandate:SetShow( true )
			btn_GuildMasterMandateBG:SetShow( false )
			btn_GuildMasterMandate:SetEnable( true )
			btn_GuildMasterMandate:SetMonoTone( false )
			btn_GuildMasterMandate:SetFontColor( UI_color.C_FF00C0D7 )
		end
	else
		if isGuildSubMaster then
			if ToClient_IsAbleChangeMaster() then
				if myGuildInfo:getGuildBusinessFunds_s64() < toInt64(0,20000000) then
					btn_GuildMasterMandate:SetShow( true )
					btn_GuildMasterMandateBG:SetShow( true )
					btn_GuildMasterMandate:SetEnable( false )
					btn_GuildMasterMandate:SetMonoTone( true )
					btn_GuildMasterMandate:SetFontColor( UI_color.C_FFC4BEBE )
				else
					btn_GuildMasterMandate:SetShow( true )
					btn_GuildMasterMandateBG:SetShow( false )
					btn_GuildMasterMandate:SetEnable( true )
					btn_GuildMasterMandate:SetMonoTone( false )
					btn_GuildMasterMandate:SetFontColor( UI_color.C_FF00C0D7 )
				end
			else
				btn_GuildMasterMandate:SetShow( true )
				btn_GuildMasterMandate:SetEnable( false )
				btn_GuildMasterMandateBG:SetShow( true )
				btn_GuildMasterMandate:SetMonoTone( true )
			end	
		else
			btn_GuildMasterMandate:SetShow( false )
			btn_GuildMasterMandateBG:SetShow( false )
			TooltipSimple_Hide()
		end
	end
end


function GuildMainInfo_Show()
	if 99 ~= tabNumber then
		return
	end
	local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
	if nil == myGuildInfo then
		return
	end
	
	local hasOccupyTerritory	= myGuildInfo:getHasSiegeCount()	-- 소유 영지가 있으면 배경이 나옴.
	local isGuildMaster			= getSelfPlayer():get():isGuildMaster()
	local isGuildSubMaster		= getSelfPlayer():get():isGuildSubMaster()
	GuildWarInfoPage._txtWarInfoTitle				:SetShow( true )

	if isGuildMaster then
		-- btn_GuildMasterMandateBG					:SetShow( false )
		-- btn_GuildMasterMandate						:SetShow( false )
		GuildInfoPage._btnChangeMark				:SetShow( true )
		notice_btn									:SetShow( true )
		introduce_btn								:SetShow( true )
		introduce_Reset								:SetShow( true )
		GuildWarInfoPage._btnDeclaration			:SetShow( true )
		GuildInfoPage._btnIncreaseMember			:SetShow( true )
		GuildInfoPage._btnProtectAdd				:SetShow( true )
		introduce_edit								:SetEnable( true )
	elseif isGuildSubMaster then
		-- btn_GuildMasterMandateBG					:SetShow( true )
		-- btn_GuildMasterMandate						:SetShow( true )
		GuildInfoPage._btnChangeMark				:SetShow( false )
		notice_btn									:SetShow( true )
		introduce_btn								:SetShow( true )
		introduce_Reset								:SetShow( true )
		GuildWarInfoPage._btnDeclaration			:SetShow( true )
		GuildInfoPage._btnIncreaseMember			:SetShow( false )
		GuildInfoPage._btnProtectAdd				:SetShow( false )
		introduce_edit								:SetEnable( true )
	else
		-- btn_GuildMasterMandateBG					:SetShow( false )
		-- btn_GuildMasterMandate						:SetShow( false )
		GuildInfoPage._btnChangeMark				:SetShow( false )
		notice_btn									:SetShow( false )
		introduce_btn								:SetShow( false )
		introduce_Reset								:SetShow( false )
		GuildWarInfoPage._btnDeclaration			:SetShow( false )
		GuildInfoPage._btnIncreaseMember			:SetShow( false )
		GuildInfoPage._btnProtectAdd				:SetShow( false )
		introduce_edit								:SetEnable( false )
	end
	if 0 ~=hasOccupyTerritory then
		GuildInfoPage._iconOccupyTerritory			:SetShow( true )
	else
		GuildInfoPage._iconOccupyTerritory			:SetShow( false )
	end
	
	notice_title									:SetShow( true )
	notice_edit										:SetShow( true )

	introduce_edit									:SetShow( true )
	if isGameTypeEnglish() then
		GuildInfoPage._txtMaster						:SetShow( false )
		GuildInfoPage._txtGuildName						:SetShow( false )
	else
		GuildInfoPage._txtMaster						:SetShow( true )
		GuildInfoPage._txtGuildName						:SetShow( true )
	end
	GuildInfoPage._textGuildInfoTitle				:SetShow( true )
	GuildInfoPage._guildMainBG						:SetShow( true )
	GuildInfoPage._iconGuildMark					:SetShow( true )
	GuildInfoPage._txtRGuildName					:SetShow( true )
	GuildInfoPage._txtRMaster						:SetShow( true )
	GuildInfoPage._txtRRank_Title					:SetShow( true )
	GuildInfoPage._txtRRank							:SetShow( true )
	GuildInfoPage._txtPersonNo						:SetShow( true )
	GuildInfoPage._txtRPersonNo						:SetShow( true )
	GuildInfoPage._txtGuildPoint					:SetShow( true )
	GuildInfoPage._txtGuildPointValue				:SetShow( true )
	GuildInfoPage._txtGuildPointPercent				:SetShow( true )
	GuildInfoPage._skillPointExpBG					:SetShow( true )
	GuildInfoPage._progressSkillPoint				:SetShow( true )
	GuildInfoPage._txtGuildMpValue					:SetShow( true )
	GuildInfoPage._txtGuildMpPercent				:SetShow( true )
	GuildInfoPage._guildMp_Title					:SetShow( true )
	GuildInfoPage._guildMpExpBG						:SetShow( true )
	GuildInfoPage._progressMpPoint					:SetShow( true )
	GuildInfoPage._btnGuildDel						:SetShow( true )
	GuildInfoPage._guildIntroduce_Title				:SetShow( true )
	GuildInfoPage._guildIntroduce_BG				:SetShow( true )
	GuildInfoPage._guildBbs_Title					:SetShow( true )
	GuildInfoPage._guildBbs_BG						:SetShow( true )
	GuildInfoPage._planning							:SetShow( true )

	GuildInfoPage._txtProtect						:SetShow( true )
	GuildInfoPage._txtProtectValue					:SetShow( true )

	GuildInfoPage._txtGuildMoneyTitle				:SetShow( true )
	GuildInfoPage._txtGuildMoney					:SetShow( true )

	GuildMainInfo_MandateBtn()
	
	if nil ~= guildCommentsWebUrl then
		_Web:SetShow(true)
	end
	
end

function guildCommentsUrlByServiceType()
	local url = nil
	if CppEnums.CountryType.DEV == getGameServiceType() then				-- 내부 개발
		url = "https://192.168.0.61/guild/guildComments.pa"
	elseif CppEnums.CountryType.KOR_ALPHA == getGameServiceType() then		-- 다음 QA
		url = "https://182.162.18.71:8885/guild/guildComments.pa"
	elseif CppEnums.CountryType.KOR_REAL == getGameServiceType() then		-- 다음 라이브
		url = "https://117.52.6.25:8885/guild/guildComments.pa"
	end
	return url
end

function GuildMainInfo_Hide()
	GuildWarInfoPage._txtWarInfoTitle				:SetShow( false )

	_Web											:SetShow( false )
	-- btn_GuildMasterMandateBG						:SetShow( false )
	-- btn_GuildMasterMandate							:SetShow( false )
	notice_title									:SetShow( false )
	notice_edit										:SetShow( false )
	notice_btn										:SetShow( false )
	introduce_btn									:SetShow( false )
	introduce_Reset									:SetShow( false )

	introduce_edit									:SetShow( false )

	GuildInfoPage._txtMaster						:SetShow( false )
	GuildInfoPage._textGuildInfoTitle				:SetShow( false )
	GuildInfoPage._guildMainBG						:SetShow( false )
	GuildInfoPage._iconOccupyTerritory				:SetShow( false )
	GuildInfoPage._iconGuildMark					:SetShow( false )
	GuildInfoPage._txtGuildName						:SetShow( false )
	GuildInfoPage._txtRGuildName					:SetShow( false )
	GuildInfoPage._txtRMaster						:SetShow( false )
	GuildInfoPage._txtRRank_Title					:SetShow( false )
	GuildInfoPage._txtRRank							:SetShow( false )
	GuildInfoPage._txtPersonNo						:SetShow( false )
	GuildInfoPage._txtRPersonNo						:SetShow( false )
	GuildInfoPage._btnIncreaseMember				:SetShow( false )
	GuildInfoPage._txtGuildPoint					:SetShow( false )
	GuildInfoPage._txtGuildPointValue				:SetShow( false )
	GuildInfoPage._txtGuildPointPercent				:SetShow( false )
	GuildInfoPage._skillPointExpBG					:SetShow( false )
	GuildInfoPage._progressSkillPoint				:SetShow( false )
	GuildInfoPage._txtGuildMpValue					:SetShow( false )
	GuildInfoPage._txtGuildMpPercent				:SetShow( false )
	GuildInfoPage._guildMp_Title					:SetShow( false )
	GuildInfoPage._guildMpExpBG						:SetShow( false )
	GuildInfoPage._progressMpPoint					:SetShow( false )
	GuildInfoPage._btnGuildDel						:SetShow( false )
	GuildInfoPage._btnChangeMark					:SetShow( false )

	GuildInfoPage._guildIntroduce_Title				:SetShow( false )
	GuildInfoPage._guildIntroduce_BG				:SetShow( false )
	GuildInfoPage._guildBbs_Title					:SetShow( false )
	GuildInfoPage._guildBbs_BG						:SetShow( false )
	GuildInfoPage._planning							:SetShow( false )

	GuildInfoPage._txtProtect						:SetShow( false )
	GuildInfoPage._txtProtectValue					:SetShow( false )
	GuildInfoPage._btnProtectAdd					:SetShow( false )

	GuildInfoPage._txtGuildMoneyTitle				:SetShow( false )
	GuildInfoPage._txtGuildMoney					:SetShow( false )

	GuildMainInfo_MandateBtn()
end

----------------------------------------------------------------------------------------------------
GuildManager:initialize()	-- 길드 초기화


function FromClient_ResponseGuildUpdate()
	
	if( true == Panel_Window_Guild:GetShow() ) then
		GuildInfoPage		:UpdateData()
		GuildListInfoPage	:UpdateData()
		-- GuildLetsWarPage	:UpdateData()
		GuildWarInfoPage	:UpdateData()
		GuildSkillFrame_Update()

		-- 길드 리메인 타임을 적용한다.
		guildQuest_ProgressingGuildQuest_UpdateRemainTime()
		-- QuestWidget_ProgressingGuildQuest_UpdateRemainTime()
	elseif ( true == Panel_ClanList:GetShow() ) then
		 FGlobal_ClanList_Update()
	end
end

function FromClient_EventActorChangeGuildInfo()
	GuildInfoPage:UpdateData()
end

local messageBox_guild_accept = function()
	ToClient_RequestAcceptGuildInvite();
end

local messageBox_guild_refuse = function()
	ToClient_RequestRefuseGuildInvite();
end

function FromClient_ResponseGuild_refuse(questName, s64_joinableTime )
	
	if( toInt64(0,0) < s64_joinableTime ) then
	
		local lefttimeText = convertStringFromDatetime(getLeftSecond_TTime64(s64_joinableTime));
		
		local contentString = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_GUILD_MSGBOX_JOINWAITTIME_CONTENT", "questName", questName, "lefttimeText", lefttimeText ) -- questName.."님은 길드가입 대기시간이 " ..lefttimeText.. " 남으셨습니다."
		local messageboxData = { title = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_INVITE" ), content = contentString, functionYes = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData)

	else
		
		local myGuildInfo = ToClient_GetMyGuildInfoWrapper();
		if( nil == myGuildInfo ) then
			_PA_ASSERT( false, "FromClient_ResponseGuild_refuse 에서 길드 정보가 없습니다.");
		end
		
		local textGuild = "";
		local guildGrade	= myGuildInfo:getGuildGrade()
		if( 0 == guildGrade ) then
			textGuild = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_CLAN") -- "클랜"
		else
			textGuild = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD") -- "길드"
		end
		
		local contentString = PAGetStringParam2(  Defines.StringSheet_GAME, "LUA_GUILD_REFUSE_GUILDINVITE", "name", questName, "guild", textGuild )
		local messageboxData = { title = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_INVITE" ), content = contentString, functionYes = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData)

	end
	
end

function FromClient_ResponseGuild_invite( s64_guildNo, hostUsername, hostName, guildName, guildGrade, periodDay, benefit, penalty )	
	if(  0 == guildGrade ) then	-- 길드 등급 클랜
		local luaGuildTextGuildInviteMsg = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_CLAN_INVITE_MSG" )
		local luaGuildTextGuildInvite = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_CLAN_INVITE" )

		local contentString = hostUsername.."("..hostName..")"..luaGuildTextGuildInviteMsg;
		local messageboxData = { title = luaGuildTextGuildInvite, content = contentString, functionYes = messageBox_guild_accept, functionCancel = messageBox_guild_refuse, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageboxData);

	elseif( 1 == guildGrade ) then -- 길드 등급 길드
		-- 고용 계약서를 띄워준다.
		FGlobal_AgreementGuild_Open( true, hostUsername, hostName, guildName, periodDay, benefit, penalty, s64_guildNo )
	end
	
end


function messageBox_guildAlliance_accept()
	ToClient_RequestAcceptGuildAllianceInvite();
end

function messageBox_guildAlliance_refuse()
	ToClient_RequestRefuseGuildAllianceInvite();
end

function FromClient_ResponseGuildAlliance_invite( hostName )
	local luaGuildTextGuildAllianceInviteMsg = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDALLIANCE_INVITE_MSG" )
	local luaGuildTextGuildAllianceInvite = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDALLIANCE_INVITE" )
	
	local contentString = hostName..luaGuildTextGuildAllianceInviteMsg;
	local messageboxData = { title = luaGuildTextGuildAllianceInvite, content = contentString, functionYes = messageBox_guildAlliance_accept, functionCancel = messageBox_guildAlliance_refuse, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData);
end

function FromClient_ResponseGuildAlliance_refuse( guestName )
	local luaGuildTextGuildAllianceRefuseMsg = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDALLIANCE_REFUSE_MSG" )
	local luaGuildTextGuildAllianceRefuse = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDALLIANCE_REFUSE" )
	
	local contentString = guestName..luaGuildTextGuildAllianceRefuseMsg;
	local messageboxData = { title = luaGuildTextGuildAllianceRefuse, content = contentString, functionYes = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageboxData);
end

function FromClient_ResponseUpdateGuildContract( notifyType, userNickName, characterName, strParam1, strParam2, s64_param1, s64_param2, s64_param3 )
	-- notifyType 
	-- 0 : 수당이 지급되었다. 수금할 수 있다.
	-- 1 : 누군가 입금했다
	-- 2 : 누군가 수당을 수금했다.
	-- 3 : 누군가 고용 계약을 갱신했다.
	-- 4 : 누군가의 고용 계약 만료
	-- 5 : 고용 계약 갱신을 위한 계약서 제시
	-- 6 : 길드 법인세 납부/미납부
	-- 7 : 위약금 내고 탈퇴
	-- 8 : 위로금을 주고 강제추방
	-- 9 : 길드 승급
	-- 10 : 길드원 활동량 변경
	-- 11 : 길드 하우스 입찰		param1 : 입찰 금액, param2 : chracterKey param3:최고가입찰인지(1), 아닌지(0)
	-- 12 : 길드 하우스 입찰 결과
	-- 13 : 길드 샵 이용		s64_param1 :0(사기),1(팔기), s64_param2 : 금액
	-- 14 : 길드 인센티브 지급
	-- 15 : 길드 하우스 유지 비용 납부
	-- 16 : 길드 창설 통보
	-- 17 : 길드 퀘스트 수락
	-- 18 : 길드 퀘스트 완료
	-- 19 : 성주가 마을의 세금을 길드 자금으로 가져왔다.
	-- 20 : 길드원이 누구를 PK 했다.
	-- 21 : 길드가 전쟁 선포 하는데 성향치 얼마, 길드자금 얼마 소모 했다.
	-- 22 : 길드원의 기운이 바뀌었다.
	-- 23 : 길드원의 공헌도가 바뀌었다.
	-- 24 : 길드 자금이 변경되었다.
	-- 25 : 길드 MP가 변경되었다.
	-- 26 : 일일 가능한 길드 퀘스트 갯수가 변경되었다.
	-- 27 : 시간마다 길드 자금 획득
	-- 28 : 길드 사기가 변경되었습니다.
	-- 29 : 길드를 응원하였습니다.
	-- 30 : 길드 퀘스트 수행이 불가능합니다.
	-- 31 :
	-- 32 : 길드 텐트 강제 철거
	
	local param1 = Int64toInt32(s64_param1)
	local param2 = Int64toInt32(s64_param2)
	local param3 = Int64toInt32(s64_param3)
	
	
	if( 0  == notifyType ) then
		local tempStr		= PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_PENSION");
		local guildWrapper	= ToClient_GetMyGuildInfoWrapper()
		if nil == guildWrapper then
			return
		end
		local guildGrade	= guildWrapper:getGuildGrade()
		if 1 == guildGrade then
			Proc_ShowMessage_Ack( tempStr ) 
		end
	elseif ( 1 == notifyType ) then
		local tempStr = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_MONEY_DEPOSIT", "userNickName", userNickName, "money", tostring(param1) ); -- userNickName..'이 길드자금' ..tostring(param1)..'을 입금하였습니다..';
		Proc_ShowMessage_Ack( tempStr ) 
	elseif ( 2 == notifyType ) then
		local tempStr = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_MONEY_COLLECTION", "userNickName", userNickName, "money", tostring(param1) ); -- userNickName..'이' ..tostring(param1)..'을 수금하였습니다..';
		-- Proc_ShowMessage_Ack( tempStr ) 
	elseif ( 3 == notifyType ) then
		local tempStr = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_HIRE_RENEWAL", "userNickName", userNickName ) -- userNickName..'이 고용 계약을 갱신하였습니다'
		Proc_ShowMessage_Ack( tempStr ) 
	elseif ( 4 == notifyType ) then
		local tempStr = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_EXPIRATION", "userNickName", userNickName ); -- userNickName..'이 고용 계약이 만료되었습니다.'
		Proc_ShowMessage_Ack( tempStr ) 
	elseif ( 5 == notifyType ) then 	
		local periodDay 	= getTemporaryInformationWrapper():getContractedPeriodDay();
		local benefit		= getTemporaryInformationWrapper():getContractedBenefit();
		local penalty		= getTemporaryInformationWrapper():getContractedPenalty();
		local guildWrapper	= ToClient_GetMyGuildInfoWrapper()
		if( nil == guildWrapper ) then
			_PA_ASSERT(false, "길드원이 고용계약서를 받는데 길드 정보가 없습니다.");
			return;
		end
		
		FGlobal_AgreementGuild_Open( false, userNickName, characterName, PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENTGUILDOPEN_PARAM"), periodDay, benefit, penalty,  guildWrapper:getGuildNo_s64() );
	elseif( 6 == notifyType ) then	
		
		local tempTxt = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_PAYMENTS", "typeMoney", tostring(param2) ) -- tostring(param2)..' 납부'
		if( 0 ~= param1 ) then
			tempTxt = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_UNPAID", "typeMoney", tostring(param2) ) -- tostring(param2)..' 미납'
		end
		
		Proc_ShowMessage_Ack( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_INCOMETAX", "type", tempTxt ) ) --'길드 법인세가' ..tempTxt.. '되었습니다' 
	
	elseif( 7 == notifyType ) then	
		
		local tempTxt = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_LEAVE", "userNickName", userNickName ) -- userNickName .. "님이 탈퇴하였습니다."
		if( 0 < param1 ) then
			tempTxt = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_PENALTIES", "tempTxt", tempTxt, "money", tostring(param1) ) -- tempTxt .."(위약금:" ..tostring(parma1)..")"
		end
		
		Proc_ShowMessage_Ack( tempTxt ) 
		
		Panel_Window_Guild:SetShow( false, true )

	elseif( 8 == notifyType ) then	
		local tempTxt = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_FIRE", "userNickName", userNickName ) -- userNickName .. "님이 추방되었습니다."
		if( 0 < param1 ) then
			tempTxt = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_BONUS", "tempTxt", tempTxt, "money", tostring(param1) ) -- tempTxt .."(위로금:" ..tostring(param1)..")"		
		end
		
		Proc_ShowMessage_Ack( tempTxt ) 
	
	elseif( 9 == notifyType ) then	
	
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_UPGRADES") ); -- "길드가 승급하였습니다"
	
	elseif( 10 == notifyType ) then -- 활동량 변경
		
		--
	
	elseif( 11 == notifyType ) then
	
		local text = ""
		if( 1 == param3 ) then
			text = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_BESTMONEY", "money", makeDotMoney( s64_param1 ) ) -- tostring( param1 ).. "실버에 길드 하우스를 최고가로 입찰하였습니다.";
		else
			text = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_NOTBESTMONEY", "money", makeDotMoney( s64_param1 ) ) -- tostring( param1 ).. "실버에 길드 하우스를 입찰했지만 최고가가 아닙니다.";
		end
		
		Proc_ShowMessage_Ack( text ); 
		
	elseif( 12 == notifyType ) then
		
		local text;
		if( 1 == param1 ) then
			text = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_BIDCANCEL") --"길드 하우스를 입찰금을 회수하였습니다.";
		else
			text = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_BIDSUCCESS") --"길드 하우스 경매에 낙찰되었습니다.";
		end
	
		Proc_ShowMessage_Ack( text ); 

	elseif( 13 == notifyType ) then
		if toInt64(0,0) == s64_param1 then -- 구매
			Proc_ShowMessage_Ack( PAGetStringParam2( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_USEGUILDSHOP_BUY", "userNickName", tostring(userNickName), "param2", makeDotMoney(s64_param2) ) ) -- tostring(userNickName) .. "가문이 길드 상점을 통해 길드 자금(" .. makeDotMoney(s64_param2) .. " 은화)을 사용하였습니다." )
		end
		-- 길드 상점이 열려있는 경우 업데이트
		if Panel_Window_NpcShop:IsShow() then
			NpcShop_UpdateContent();
			return;
		end

	elseif( 14 == notifyType ) then
		
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_INCENTIVE") ); -- '길드 인센티브가 지급되었습니다. 잠시후 우편으로 받으실수 있습니다.'

	elseif( 15 == notifyType ) then
		
		local tempTxt = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_PAYMENTS", "typeMoney", tostring(param2) ) -- tostring(param2)..' 납부'
		if( 0 ~= param1 ) then
			tempTxt = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_UNPAID", "typeMoney", tostring(param2) ) -- tostring(param2)..' 미납'
		end
		
		Proc_ShowMessage_Ack( PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_HOUSECOSTS", "tempTxt", tempTxt ) ) -- '길드 하우스 유지비용 ' ..tempTxt.. '되었습니다'
	elseif( 16 == notifyType ) then
		
		local text = ""
		if( 0 == param1 ) then
			text = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_CREATE_CLAN", "name", userNickName )
		else
			text = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_CREATE_GUILD", "name", userNickName )
		end
		
		Proc_ShowMessage_Ack( text )
		-- GuildListInfoPage:initialize()	-- 만들었으니까. 생성해준다.
	
	elseif( 17 == notifyType ) then
		local text = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_ACCEPT_GUILDQUEST" );
		Proc_ShowMessage_Ack( text ); 		
		
	elseif( 18 == notifyType ) then
		local text = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_COMPLETE_GUILDQUEST" );
		Proc_ShowMessage_Ack( text); 		
		
	elseif( 19 == notifyType ) then	
		
		local regionInfoWrapper = getRegionInfoWrapper(param2)
		if( nil == regionInfoWrapper ) then
			_PA_ASSERT(false, "성주가 마을세금을 수금했는데 마을 정보가 없습니다.");
			return;
		end
		
		local text = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_GUILD_LORD_MOVETAX_TO_GUILDMONEY", "region", regionInfoWrapper:getAreaName(), "silver", makeDotMoney(s64_param1) )
		--local text = "성주가 " ..regionInfoWrapper:getAreaName().."에서 "..makeDotMoney(s64_param1).."실버를 길드자금으로 수령했습니다"
		
		Proc_ShowMessage_Ack( text ); 
	elseif( 20 == notifyType  )then	
		-- userNickName: PK한 길드 멤버의 가문명
		-- strParam1: PK 당한 유저의 길드 이름(param1 == 1) / PK 당한 유저의 가문명(param1 == 0)
		-- strParam2: PK 당한 유저의 가문명(param1 == 1) / PK 당한 유저의 캐릭터 이름(param1 == 0)
		-- param1: PK 당한 유저가 길드에 가입한 경우1, 아닌경우 0

		-- 별도 이벤트로 처리하기로 했다.

		-- local text = ""
		-- if 1 == param1 then
		-- 	-- 다른 길드의 멤버를 죽인 경우		
		-- 	text = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILD_MEMBER_PK_DO_OTHER_GUILD_MEMBER", "username", userNickName, "GuildName", strParam1, "targetUserName", strParam2)
		-- else
		-- 	-- 길드가 없는 유저를 죽인 경우
		-- 	text = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_MEMBER_PK_DO", "username", userNickName )
		-- end
		
		-- Proc_ShowMessage_Ack( text );
		
	elseif( 21 == notifyType  )then	
		
		if( CppEnums.GuildWarType.GuildWarType_Normal == ToClient_GetGuildWarType() ) then
			if( param3 == 1 ) then -- 응전했다.
				
				--local text = "길드전에서 응전시 성향치 감소와 길드자금의 감소는 없습니다."
				local text = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_ACCEPT_BATTLE_NO_RESOURCE" );
				Proc_ShowMessage_Ack( text );			
				
			else
				local tendency = param1
				local text = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_DECLARE_WAR_CONSUME", "silver", makeDotMoney(s64_param2) )
				Proc_ShowMessage_Ack( text );			
			end
		end

	elseif( 22 == notifyType  )then

	elseif( 23 == notifyType  )then
	
	elseif( 24 == notifyType  )then

	elseif( 25 == notifyType  )then
		if Panel_GuildWarInfo:GetShow() then
			-- FromClient_WarInfoContent_Set()
		end
	elseif( 26 == notifyType  )then
		GuildQuestInfoPage:UpdateData()
		
	elseif( 27 == notifyType  )then
	
	elseif( 28 == notifyType  )then
		if(0 == param1) then
			local text = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_GUILDMP_DOWN" );
			Proc_ShowMessage_Ack(userNickName..text)
		else
			local text = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_GUILDMP_UP" );
			Proc_ShowMessage_Ack(userNickName..text)
		end
		-- 길드 사기 변경 시 점령전 현황 창 다시 한 번 세팅
		if Panel_GuildWarInfo:GetShow() then
			FromClient_WarInfoContent_Set()
		end
	elseif( 29 == notifyType  )then
		if(0 == param1) then
			local text = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_CHEER_GUILD" );
			Proc_ShowMessage_Ack(userNickName..text)
			-- local msg = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_CHEER_1", "userNickName", userNickName ) -- "[<PAColor0xFFC8FFC8>" .. userNickName .. "<PAOldColor>] 길드를 응원하였습니다."
			-- GuildWar_LogUpdate( msg )
			FromClient_NotifySiegeScoreToLog()
		else
			--local text = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_CHEER_GUILD" );
			--Proc_ShowMessage_Ack(characterName.."님이 "..userNickName..text)
			-- local msg = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_GUILD_CHEER_2", "characterName", characterName, "userNickName", userNickName ) -- "<<PAColor0xffffe18e>" .. characterName .. "<PAOldColor>> 님이 [<PAColor0xFFC8FFC8>" .. userNickName .. "<PAOldColor>] 길드를 응원하였습니다."
			-- GuildWar_LogUpdate( msg )
			FromClient_NotifySiegeScoreToLog()
		end
		
		
		-- 길드 응원하기가 정상적으로 반영됐다면, 다시 한 번 업데이트해 버튼을 disable 시킨다
		if Panel_GuildWarInfo:GetShow() then
			FromClient_WarInfoContent_Set()
		end
	elseif( 30 == notifyType  )then
		local text = PAGetString( Defines.StringSheet_GAME, "LUA_GUILD_DONOT_GUILDQUEST" );
		Proc_ShowMessage_Ack(text)
	elseif( 31 == notifyType  )then
		-- 다른 메세지 함수 사용
	elseif( 32 == notifyType  )then	-- THouseholdNo householdNo  = param1, gc::CharacterKey characterKey = param2, gc::RegionKey regionKey = param3
		-- local text = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_COMPULSION_DELETE") .. userNickName.. " "	..tostring(param1) .. " " ..tostring( param2 ) .. " " ..tostring(param3)

		local regionInfoWrapper 			= getRegionInfoWrapper( param3 )
		local areaName						= ""
		if nil ~= regionInfoWrapper then
			areaName	= regionInfoWrapper:getAreaName()
		end
		local characterStaticStatusWarpper	= getCharacterStaticStatusWarpper( param2 )
		local characterName					= ""
		if nil ~= characterStaticStatusWarpper then
			characterName = characterStaticStatusWarpper:getName()
		end

		local msg = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_BUILDING_AUTODESTROYBUILD", "areaName", areaName, "characterName", characterName )	-- areaName .. "의 " .. characterName .. "가 강제 철거 됐습니다."

		Proc_ShowMessage_Ack( msg )
	end
	
	-- 열려있다면 업데이트
	FromClient_ResponseGuildUpdate();
end

function FromClient_NotifyGuildMessage( msgType, strParam1, strParam2, s64_param1, s64_param2, s64_param3 )
	--[[ msgType에 따른 설명
	0 	: 나 자신의 탈퇴, param1:길드등급
	1 	: 길드원의 탈퇴, strParam1:유져닉네임, param1:길드 등급
	2 	: 내가 가입
	3 	: 다른이가 가입
	4 	: 길드 해산
	5 	: 추방 strParam1:유져닉네임, strParam2:길드이름, param1:길드 등급, param2:0(나),1(다른길드원)
	6 	: 길드원 가입 가능 인원 증가 param1:이전 카운트, parma2: 현재 카운트, param3 :증가된 값
	7 	: 길드원 로그인/로그아웃, strParam1:유져닉네임, strParam2:가문명, param1:0(로그인),1(로그아웃)
	8 	: 연합원 로그인/로그아웃, strParam1:유져닉네임, strParam2:가문명, param1:0(로그인),1(로그아웃)
	9 	: 길드원 레벨업, strParam1:가문명, param1:레벨
	10  : 길드원 생활 레벨업, strParam1:가문명, param1:생활 타입, param2:생활 레벨
	11  : 길드원 강화 성공, strParam1:가문명, strParam2:강화 아이템, param1:강화 레벨
	12  : 길드 결전 종료
	]]--
	
	local param1 = Int64toInt32(s64_param1)
	local param2 = Int64toInt32(s64_param2)
	local param3 = Int64toInt32(s64_param3)

	if( 0  == msgType ) then 
		
		local	message	= "" 
		if(  0 == param1 ) then
			message =	PAGetString(Defines.StringSheet_GAME, "GAME_MESSAGE_CLAN_OUT")
		else
			message =	PAGetString(Defines.StringSheet_GAME, "GAME_MESSAGE_GUILD_OUT")
		end
		
		Proc_ShowMessage_Ack( message )
		
	elseif( 1 == msgType ) then
		
		local	message	= "" 
		if(  0 == param1 ) then
			message = PAGetStringParam1(Defines.StringSheet_GAME, "GAME_MESSAGE_CLANMEMBER_OUT", "familyName", strParam1 )
		else
			message = PAGetStringParam1(Defines.StringSheet_GAME, "GAME_MESSAGE_GUILDMEMBER_OUT", "familyName", strParam1 )
		end
		Proc_ShowMessage_Ack( message )
	
	elseif( 2 == msgType ) then
	
		local	message	= "" 
		if( 0 == param1 ) then
			message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_JOIN_GUILD", "name", strParam1 )
		else
			message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_JOIN_GUILD", "name", strParam1 )
		end
	
		Proc_ShowMessage_Ack( message )
		
	elseif( 3 == msgType ) then
	
		local	message	= "" 
		if( 0 == param1 ) then
			message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_WHO_JOIN_CLAN", "name", strParam1 )
		else
			message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_WHO_JOIN_GUILD", "name", strParam1 )
		end
	
		Proc_ShowMessage_Ack( message )
	
	elseif( 4 == msgType ) then
	
		local	message	= "" 
		if( 0 == param1 ) then
			message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_DISPERSE_CLAN_MSG", "name", strParam1 )
		else
			message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_DISPERSE_GUILD_MSG", "name", strParam1 )
		end
	
		Proc_ShowMessage_Ack( message )
		
	elseif( 5 == msgType ) then
	
		local textGrade = ""
		if( 0 == param1 ) then
			textGrade = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_CLAN") -- "클랜"
		else
			textGrade = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD") -- "길드"
		end
		
		local	message	= "" 
		if( 0 == param2 ) then -- 나
			--message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_EXPEL_SELF", "guild", textGrade )
			message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_EXPEL_SELF", "guild", strParam2 )
		else -- 다른길드원
			--message = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_EXPEL_OTHER", "name", strParam1, "guild", textGrade )
			message = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_EXPEL_OTHER", "name", strParam1, "guild", strParam2 )
		end
			
		Proc_ShowMessage_Ack( message )
		
	elseif( 6 == msgType ) then

		-- _PA_LOG("유흥신", "6 == msgType param1 param2" .. param1.." ".. param2 )
	
		local message = ""
		if( param1 <= 30 and 30 < param2 ) then
			message = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_COMPORATETAX_GUILDMEMBERCOUNT", "membercount", "30", "silver", PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBERCOUNT_10")) -- "10만"
		elseif ( param1 <= 50 and 50 < param2 ) then
			message = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_COMPORATETAX_GUILDMEMBERCOUNT", "membercount", "50", "silver", PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBERCOUNT_25")) -- "25만"
		elseif ( param1 <= 75 and 75 < param2 ) then
			message = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_COMPORATETAX_GUILDMEMBERCOUNT", "membercount", "75", "silver", PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBERCOUNT_50")) -- "50만"
		else
			message =  PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_INCREASE_GUILDMEMBERCOUNT", "membercount", param2 )
			--message = "길드 가입 최대 인원이 " .. tostring(param2) .."명으로 증가되었습니다"
		end
		
		Proc_ShowMessage_Ack( message )
		
	elseif( 7 == msgType ) then
	
		local message = ""
		local characterName = strParam1
		local userNickName = strParam2
		
		if true == GameOption_ShowGuildLoginMessage() then
			if 0 == param1 then
				message = PAGetStringParam2(Defines.StringSheet_GAME, "GAME_MESSAGE_LOGIN_GUILD_MEMBER", "familyName", userNickName, "characterName", characterName)
			elseif 1 == param1 then
				message = PAGetStringParam2(Defines.StringSheet_GAME, "GAME_MESSAGE_LOGOUT_GUILD_MEMBER", "familyName", userNickName, "characterName", characterName)
			end
			
			Proc_ShowMessage_Ack( message )
		end
		
		
	elseif ( 8 == msgType ) then
	
		local message = ""
		local characterName = strParam1
		local userNickName = strParam2
		
		-- if 0 == param1 then -- 연합원 개념이 현재는 없으므로 주석처리한다.
		-- 	message = PAGetString(Defines.StringSheet_GAME, "GAME_MESSAGE_LOGIN_GUILD_ALLIANCE_MEMBER").." "..userNickName.." "..characterName
		-- else
			if 1 == param1 then
			message = PAGetString(Defines.StringSheet_GAME, "GAME_MESSAGE_LOGOUT_GUILD_ALLIANCE_MEMBER").." "..userNickName.." "..characterName
		end
		
		Proc_ShowMessage_Ack( message )
	
	elseif ( 9 == msgType ) then
	
		local message = {}
		
		if (15 < param1) then
			message.main	= PAGetStringParam2( Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBERLEVELUP_MAIN", "strParam1", strParam1, "param1", param1 ) -- "[" .. strParam1.."]님이 Lv." ..param1.."이 됐습니다."
			message.sub		= PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBER_CHEER") -- "축하해주세요!"
			message.addMsg	= ""
			
			Proc_ShowMessage_Ack_For_RewardSelect( message, 3.2, 22 )
		end
	
	elseif ( 10 == msgType ) then
	
		local message = {}

		if param1 <= 8 then
			local lifeLevel = FGlobal_CraftLevel_Replace( param2, param1 )
			message.main	= PAGetStringParam3( Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBERLIFELEVELUP_MAIN", "strParam1", strParam1, "param1", lifeType[param1], "lifeLevel", lifeLevel ) -- "[" .. strParam1.."]님이 " ..lifeType[param1].." "..lifeLevel.. "이 됐습니다."
			message.sub		= PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBER_CHEER") -- "축하해주세요!"
			message.addMsg	= ""
			
			Proc_ShowMessage_Ack_For_RewardSelect( message, 3.2, 22 )
		end
		
	elseif ( 11 == msgType ) then
		
		local itemSSW = getItemEnchantStaticStatus( ItemEnchantKey(param1) )
		
		if itemSSW == nil then
			return
		end
		
		local itemName			= itemSSW:getName()
		local itemClassify		= itemSSW:getItemClassify()
		local enchantLevel		= itemSSW:get()._key:getEnchantLevel()
		local enchantLevelHigh	= 0
		
		if nil ~= enchantLevel and 0 ~= enchantLevel then
			if 16 <= enchantLevel then
				enchantLevelHigh = HighEnchantLevel_ReplaceString( enchantLevel )
			elseif CppEnums.ItemClassifyType.eItemClassify_Accessory == itemClassify then	-- 악세사리
				enchantLevelHigh = HighEnchantLevel_ReplaceString( enchantLevel + 15 )
			else
				enchantLevelHigh = "+ " .. enchantLevel
			end
		end
		
		local message = {}
		message.main	= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBERENCHANTSUCCESS_MAIN1", "strParam1", strParam1 ) .. " " .. PAGetStringParam2( Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBERENCHANTSUCCESS_MAIN2", "param1", enchantLevelHigh, "strParam2", itemName ) -- "[" .. strParam1.."]님이 +" ..param1.." "..strParam2.. " 강화에 성공했습니다."
		message.sub		= PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDMEMBER_CHEER") -- "축하해주세요!"
		message.addMsg	= ""
		
		Proc_ShowMessage_Ack_For_RewardSelect( message, 3.2, 22 )
	
	elseif ( 12 == msgType ) then
	
		local	message	= "" 
		message = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDDUELWILLBEEND" )
		Proc_ShowMessage_Ack( message )

	end
end

function FromClient_NotifyGuildMemberDoPk( attackerGuildName, attackerUserNickName, attackerCharacterName, deadGuildName, deadUserNickName, deadCharacterName )
	local text = ""
	local myGuildMember	= attackerUserNickName .. "(" .. attackerCharacterName .. ")"
	local deadUser		= deadUserNickName .. "(" .. deadCharacterName .. ")"

	if "" ~= deadGuildName then
		-- 다른 길드의 멤버를 죽인 경우		
		text = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILD_MEMBER_PK_DO_OTHER_GUILD_MEMBER", "username", myGuildMember, "GuildName", deadGuildName, "targetUserName", deadUser)
	else
		-- 길드가 없는 유저를 죽인 경우
		text = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_MEMBER_PK_DO", "username", myGuildMember, "deadUser", deadUser )
	end

	Proc_ShowMessage_Ack( text );
end

function FromClient_NotifyGuildMemberKilledOtherPlayer( attackerGuildName, attackerUserNickName, attackerCharacterName, deadGuildName, deadUserNickName, deadCharacterName )
	local text = ""
	local myGuildMember	= attackerUserNickName .. "(" .. attackerCharacterName .. ")"
	local deadUser		= deadUserNickName .. "(" .. deadCharacterName .. ")"

	if true then
		return
	end

	if "" ~= deadGuildName then
		-- 다른 길드의 멤버에게 죽은 경우
		text = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GUILD_MEMBER_KILLEDBY_OTHER_GUILD_MEMBER", "username", myGuildMember, "GuildName", deadGuildName, "targetUserName", deadUser)
	else
		-- 길드가 없는 유저에게 죽은 경우
		text = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_MEMBER_KILLEDBY_PC", "username", myGuildMember, "deadUser", deadUser )
	end

	Proc_ShowMessage_Ack( text );
end

function FromClient_ResponseGuildInviteForGuildGrade( targetActorKeyRaw, targetName, preGuildActivity )
	
	local myGuildInfo = ToClient_GetMyGuildInfoWrapper();
	if( nil == myGuildInfo ) then
		_PA_ASSERT( false, "ResponseGuildInviteForGuildGrade 에서 길드 정보가 없습니다.");
		return;
	end
	
	local guildGrade	= myGuildInfo:getGuildGrade()
	
	-- 클랜
	if( 0 == guildGrade ) then
		
		toClient_RequestInviteGuild( targetActorKeyRaw, 0, 0, 0)
	
	else -- 길드 
		
		FGlobal_AgreementGuild_Master_Open_ForJoin( targetActorKeyRaw, targetName, preGuildActivity )
	
	end
end

function FromClient_ResponseDeclareGuildWarToMyGuild()	-- 전쟁 선호한 길드 리스트를 받아 왔다.
	if Panel_Window_Guild:GetShow() and GuildWarInfoPage._btnWarList2:IsCheck() then
		GuildWarInfoPage:UpdateData()
	end
end

function SetDATAByGuildGrade()
	local myGuildInfo	= ToClient_GetMyGuildInfoWrapper()
	if nil == myGuildInfo then
		-- _PA_ASSERT(false, "자신의 길드 정보가 없습니다.");
		return;
	end
	
	local guildGrade	= myGuildInfo:getGuildGrade()
	
	local memberData	= nil;
	local memberCount	= myGuildInfo:getMemberCount()
	for memberIdx = 0, memberCount - 1 do
		memberData	= myGuildInfo:getMember( memberIdx )
		if( memberData:isSelf() ) then
			break;
		end
	end
	if( nil == memberData ) then
		-- _PA_ASSERT(false, "자신의 길드 멤버 정보가 없습니다.");
		return;
	end
	
	if 0 == guildGrade then
		GuildManager.mainBtn_Info:SetEnable( true )
		GuildManager.mainBtn_History:SetEnable( false )
		GuildManager.mainBtn_Quest:SetEnable( false )
		GuildManager.mainBtn_Tree:SetEnable( false )
		GuildManager.mainBtn_Warfare:SetEnable( false )
		GuildInfoPage._btnChangeMark:SetEnable( false )
		GuildLetsWarPage._btnLetsWarDoWar:SetEnable( false )
		GuildLetsWarPage._editLetsWarInputName:SetEnable( false )

		GuildManager.mainBtn_Info:SetMonoTone( false )
		GuildManager.mainBtn_History:SetMonoTone( true )
		GuildManager.mainBtn_Quest:SetMonoTone( true )
		GuildManager.mainBtn_Tree:SetMonoTone( true )
		GuildManager.mainBtn_Warfare:SetMonoTone( true )
		GuildInfoPage._btnChangeMark:SetMonoTone( true )
		GuildLetsWarPage._btnLetsWarDoWar:SetMonoTone( true )
		GuildLetsWarPage._editLetsWarInputName:SetMonoTone( true )

		GuildInfoPage._btnTaxPayment:SetShow( false )
		GuildInfoPage._txtUnpaidTax:SetShow( false )
		GuildInfoPage._btnIncreaseMember:SetShow( false )

		GuildListInfoPage._btnPaypal:SetShow( false )
		GuildListInfoPage._btnGiveIncentive:SetShow( false )
		GuildListInfoPage._btnDeposit:SetShow( false )
		GuildListInfoPage._textBusinessFunds:SetShow( false )
		GuildListInfoPage._textBusinessFundsBG:SetShow( false )

		GuildListInfoPage.decoIcon_Guild:SetShow( false )
		GuildListInfoPage.decoIcon_Clan:SetShow( true )

		GuildInfoPage._windowTitle:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_CLANNAME") ) -- "클   랜"
		GuildInfoPage._textGuildInfoTitle:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_CLANINFO") ) -- "- 클랜 정보"
		GuildInfoPage._txtGuildName:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_CLANNAMING") ) -- "클랜명"

	else
		GuildManager.mainBtn_Info:SetEnable( true )
		GuildManager.mainBtn_History:SetEnable( true )
		GuildManager.mainBtn_Quest:SetEnable( true )
		GuildManager.mainBtn_Tree:SetEnable( true )
		GuildManager.mainBtn_Warfare:SetEnable( true )
		GuildInfoPage._btnChangeMark:SetEnable( true )
		-- GuildLetsWarPage._btnLetsWarDoWar:SetEnable( true )
		-- GuildLetsWarPage._editLetsWarInputName:SetEnable( true )

		GuildManager.mainBtn_Info:SetMonoTone( false )
		GuildManager.mainBtn_History:SetMonoTone( false )
		if isGameTypeEnglish() then
			GuildManager.mainBtn_Quest:SetMonoTone( true )
		else
			GuildManager.mainBtn_Quest:SetMonoTone( false )
		end
		GuildManager.mainBtn_Tree:SetMonoTone( false )
		GuildManager.mainBtn_Warfare:SetMonoTone( false )
		GuildInfoPage._btnChangeMark:SetMonoTone( false )
		GuildListInfoPage._btnDeposit	:SetMonoTone( true )
		-- GuildLetsWarPage._btnLetsWarDoWar:SetMonoTone( false )
		-- GuildLetsWarPage._editLetsWarInputName:SetMonoTone( false )

		local accumulateTax_s64		= myGuildInfo:getAccumulateTax()
		local accumulateCost_s64	= myGuildInfo:getAccumulateGuildHouseCost()
		local businessFunds_s64		= myGuildInfo:getGuildBusinessFunds_s64()
		if (toInt64(0,0) < accumulateTax_s64) or (toInt64(0,0) < accumulateCost_s64) then
			GuildInfoPage._txtUnpaidTax		:SetShow( true )
			if ( businessFunds_s64 < accumulateTax_s64 ) or ( businessFunds_s64 < accumulateCost_s64 ) then
				GuildListInfoPage._btnDeposit	:SetMonoTone( false )
				GuildListInfoPage._btnDeposit	:SetEnable( true )
			else
				GuildListInfoPage._btnDeposit	:SetMonoTone( true )
				GuildListInfoPage._btnDeposit	:SetEnable( false )
			end
		else
			GuildInfoPage._txtUnpaidTax		:SetShow( false )
			GuildListInfoPage._btnDeposit	:SetMonoTone( true )
			GuildListInfoPage._btnDeposit	:SetEnable( false )
		end

		if getSelfPlayer():get():isGuildMaster() then
			GuildWarInfoPage._txtWarInfoTitle	:SetSpanSize( 50, 395 )
			-- GuildInfoPage._btnIncreaseMember	:SetShow( true )
			if (toInt64(0,0) < accumulateTax_s64) or (toInt64(0,0) < accumulateCost_s64)  then
				GuildInfoPage._btnTaxPayment:SetShow( true )
			else
				GuildInfoPage._btnTaxPayment:SetShow( false )
			end
			
			if GuildManager._doHaveSeige then
				GuildListInfoPage._btnGiveIncentive	:SetShow( true )
			else
				GuildListInfoPage._btnGiveIncentive	:SetShow( false )
			end

		elseif getSelfPlayer():get():isGuildSubMaster() then
			GuildWarInfoPage._txtWarInfoTitle	:SetSpanSize( 50, 395 )
			GuildInfoPage._btnIncreaseMember	:SetShow( false )
			
			if (toInt64(0,0) < accumulateTax_s64) or (toInt64(0,0) < accumulateCost_s64)  then
				GuildInfoPage._btnTaxPayment:SetShow( true )
			else
				GuildInfoPage._btnTaxPayment:SetShow( false )
			end

			GuildListInfoPage._btnGiveIncentive	:SetShow( false )
		else
			GuildWarInfoPage._txtWarInfoTitle	:SetSpanSize( 50, 395 )
			GuildInfoPage._btnIncreaseMember	:SetShow( false )
			GuildInfoPage._btnTaxPayment		:SetShow( false )
			GuildListInfoPage._btnGiveIncentive	:SetShow( false )
		end

		if memberData:isCollectableBenefit() and ( false == memberData:isFreeAgent() ) and (toInt64(0,0) < memberData:getContractedBenefit()) then
			GuildListInfoPage._btnPaypal:SetEnable( true )
			GuildListInfoPage._btnPaypal:SetMonoTone( false )
			-- 수금 가능한 상태인데, 길드 자금이 없다면.
			if toInt64(0,0) == businessFunds_s64 then
				GuildListInfoPage._btnPaypal:SetFontColor( UI_color.C_FFF26A6A )
			else
				GuildListInfoPage._btnPaypal:SetFontColor( UI_color.C_FFC4A68A )
			end
		else
			GuildListInfoPage._btnPaypal:SetEnable( false )
			GuildListInfoPage._btnPaypal:SetMonoTone( true )
		end

		GuildListInfoPage._btnPaypal:SetShow( true )
		GuildListInfoPage._textBusinessFunds:SetShow( true )
		GuildListInfoPage._textBusinessFundsBG:SetShow( true )

		GuildListInfoPage.decoIcon_Guild:SetShow( true )
		GuildListInfoPage.decoIcon_Clan:SetShow( false )

		GuildInfoPage._windowTitle:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_GUILDNAME") ) -- "길   드"
		GuildInfoPage._textGuildInfoTitle:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_GUILDINFO") ) -- "- 길드 정보"
		GuildInfoPage._txtGuildName:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_GUILDNAMING") ) -- "길드명"
	end
end

function Guild_onScreenResize()
	Panel_Window_Guild:SetPosX( (getScreenSizeX()/2) -  (Panel_Window_Guild:GetSizeX()/2) )
	Panel_Window_Guild:SetPosY( (getScreenSizeY()/2) -  (Panel_Window_Guild:GetSizeY()/2) )
end

----------------------------------------------------------------------------------------------------------------
--									길드 전쟁 요청
----------------------------------------------------------------------------------------------------------------
local targetUserNo 		= nil
local targetGuildNo 	= nil
local targetGuildName 	= nil
function FromClient_RequestGuildWar( userNo, guildNo, guildName )
	if(MessageBox.isPopUp() and (targetGuildNo == guildNo)) then
		return
	end

	if isGameTypeThisCountry( CppEnums.ContryCode.eContryCode_JAP ) then -- 일본 체크.
		keyUseCheck = false
	end

	targetUserNo	= userNo
	targetGuildNo 	= guildNo
	targetGuildName = guildName
	local	messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_DECLAREWAR", "guildName", targetGuildName)
	
	local	messageBoxData = { title = PAGetString ( Defines.StringSheet_GAME, "LUA_WARNING"), content = messageBoxMemo, functionYes = FGlobal_AcceptGuildWar, functionNo = FGlobal_RefuseGuildWar, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
	MessageBox.showMessageBox(messageBoxData, nil, nil, keyUseCheck)
end

function FGlobal_AcceptGuildWar()
	ToClient_RequestDeclareGuildWar(targetGuildNo, targetGuildName, true)
	targetUserNo 	= nil
	targetGuildNo 	= nil
	targetGuildName = nil
end

function FGlobal_RefuseGuildWar()
	ToClient_RequestRefuseGuildWar(targetUserNo, targetGuildName)
	targetUserNo 	= nil
	targetGuildNo 	= nil
	targetGuildName = nil
end

function HandleClickedGuildDuel( index )
	local guildWrapper	= ToClient_GetWarringGuildListAt(index)
	local guildNo_s64	= guildWrapper:getGuildNo()
	FGlobal_GuildDuel_Open( guildNo_s64 )
	--ToClient_RequestAcceptGuildDuel(100000000000000560, 100, 50000)
end

function HandleOnOut_GuildDuelInfo_Tooltip( isShow, gIdx, uiIdx )
	if isShow then
		local guildwarWrapper	= ToClient_GetWarringGuildListAt(gIdx)
		local guildNo_s64		= guildwarWrapper:getGuildNo()
		local deadline     		= ToClient_GetGuildDuelDeadline_s64(guildNo_s64)
		local lefttimeText		= convertStringFromDatetime(getLeftSecond_TTime64(deadline));
		local targetKillCount	= ToClient_GetGuildDuelTargetKillByGuild(guildNo_s64)
		local fightMoney_s64	= ToClient_GetGuildDuelPrizeByGuild_s64(guildNo_s64)

		local control			= GuildWarInfoPage._list[uiIdx]._guildShowbuScore
		local name				= PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_GUILDDUEL_INFOTOOLTIP_TITLE")	-- "결전 정보"
		local desc				= PAGetStringParam3( Defines.StringSheet_GAME, "LUA_GUILD_GUILDDUEL_INFOTOOLTIP_DESC", "targetKillCount", targetKillCount, "fightMoney", makeDotMoney(fightMoney_s64), "time", lefttimeText )	-- "목표 : " .. targetKillCount .. "명 처치\n승리 보상 : " .. makeDotMoney(fightMoney_s64) .. " 은화\n남은 시간 : " .. lefttimeText
		
		registTooltipControl(control, Panel_Tooltip_SimpleText)
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end


----------------------------------------------------------------------------------------------------------------
--									길드 한줄 공지사항
----------------------------------------------------------------------------------------------------------------
function Notice_Init()
	notice_edit:SetMaxInput( 40 )
	notice_btn	:addInputEvent("Mouse_LUp", "Notice_Regist()")
	notice_edit	:addInputEvent("Mouse_LUp", "HandleClicked_NoticeEditSetFocus()")

	notice_edit	:RegistReturnKeyEvent( "Notice_Regist()" )
end

function Notice_Regist()
	local isGuildMaster		= getSelfPlayer():get():isGuildMaster()
	local isGuildSubMaster	= getSelfPlayer():get():isGuildSubMaster()

	if (false == isGuildMaster) and (false == isGuildSubMaster) then
		return
	end

	-- local getNoticeMemo = notice_edit:GetEditText()
	-- if ("" == getNoticeMemo) or (nil == getNoticeMemo) then
	-- 	Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_NOTICE_EMPTY") )
	-- 	return
	-- end

	local close_function = function()
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

	ToClient_RequestSetGuildNotice( tostring(notice_edit:GetEditText()) )
	close_function()
	ClearFocusEdit()
end

function HandleClicked_NoticeEditSetFocus()
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
	SetFocusEdit( notice_edit )
	notice_edit:SetEditText(notice_edit:GetEditText(), true)
end

function FromClient_ResponseGuildNotice()
	local guildWrapper	= ToClient_GetMyGuildInfoWrapper()
	if nil == guildWrapper then
		return
	end
	local guildNotice	= guildWrapper:getGuildNotice()

	notice_edit:SetEditText( guildNotice, false )
end

function FGlobal_Notice_Update()
	FGlobal_Notice_AuthorizationUpdate()
end

function FGlobal_Notice_AuthorizationUpdate()
	local isGuildMaster		= getSelfPlayer():get():isGuildMaster()
	local isGuildSubMaster	= getSelfPlayer():get():isGuildSubMaster()

	if (true == isGuildMaster) or (true == isGuildSubMaster) then
		if isGameTypeEnglish() then
			notice_edit:SetSize( 500, 28 )
			notice_btn:SetSize( 100, 30 )
		else
			notice_edit:SetSize( 550, 28 )
			notice_btn:SetSize( 50, 30 )
		end
		notice_edit:SetIgnore( false )
		-- notice_btn:SetShow( true )
	else
		notice_edit:SetSize( 605, 28 )
		notice_edit:SetIgnore( true )
		-- notice_btn:SetShow( false )
	end
end

function FGlobal_GuildNoticeClearFocusEdit()
	-- notice_edit:SetText("",true)
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
end

function FGlobal_CheckGuildNoticeUiEdit(targetUI)
	return ( nil ~= targetUI ) and ( targetUI:GetKey() == notice_edit:GetKey() )
end
----------------------------------------------------------------------------------------------------------------
--									길드 소개
----------------------------------------------------------------------------------------------------------------
function Introduce_Init()
	introduce_edit	:SetMaxEditLine( 10 )
	introduce_edit	:SetMaxInput( 200 )

	introduce_btn	:addInputEvent("Mouse_LUp", "Introduce_Regist()")
	introduce_Reset	:addInputEvent("Mouse_LUp", "Introduce_Reset()")
	introduce_edit	:addInputEvent("Mouse_LUp", "HandleClicked_IntroduceEditSetFocus()")
	-- introduce_edit	:RegistReturnKeyEvent( "Introduce_Regist()" )
end

function HandleClicked_IntroduceEditSetFocus()
	UI.Set_ProcessorInputMode(IM.eProcessorInputMode_ChattingInputMode)
	SetFocusEdit( introduce_edit )
	introduce_edit:SetEditText(introduce_edit:GetEditText(), true)
end

function FGlobal_GuildIntroduceClearFocusEdit()
	-- notice_edit:SetText("",true)
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
end

function Introduce_Regist()
	local isGuildMaster		= getSelfPlayer():get():isGuildMaster()
	local isGuildSubMaster	= getSelfPlayer():get():isGuildSubMaster()

	if (false == isGuildMaster) and (false == isGuildSubMaster) then
		return
	end

	local close_function = function()
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

	ToClient_RequestSetIntrodution( tostring(introduce_edit:GetEditText()) )
	close_function()
	ClearFocusEdit()
end

function Introduce_Reset()
	local isGuildMaster		= getSelfPlayer():get():isGuildMaster()
	local isGuildSubMaster	= getSelfPlayer():get():isGuildSubMaster()

	if (false == isGuildMaster) and (false == isGuildSubMaster) then
		return
	end
	introduce_edit:SetEditText( "", true )
	ToClient_RequestSetIntrodution( tostring("") )
end

function GuildIntroduce_Update() -- 길드 한줄 공지사항과는 다르게 별도의 이벤트가 없다.
	local guildWrapper = ToClient_GetMyGuildInfoWrapper()
	if nil == guildWrapper then
		return
	end
	local guildIntroduce = guildWrapper:getGuildIntrodution()

	introduce_edit:SetEditText( guildIntroduce, false )
end

function FGlobal_CheckGuildIntroduceUiEdit(targetUI)
	return ( nil ~= targetUI ) and ( targetUI:GetKey() == introduce_edit:GetKey() )
end

function FromWeb_WebPageError( url )
	local startIndex = string.find( url, "?" )
	if nil ~= startIndex then
		local _url = string.sub( url, 1, startIndex - 1 )
		if guildCommentsUrlByServiceType() == _url then				-- 오늘의 한 마디 url 비교
			_Web:SetShow( true )
			return
		end
	end
	_Web:SetShow( false )
end

----------------------------------------------------------------------------------------------------------------
--									클라이언트에서 보내는 이벤트
----------------------------------------------------------------------------------------------------------------
registerEvent("FromClient_ResponseGuildUpdate", 				"FromClient_ResponseGuildUpdate")
registerEvent("ResponseGuild_invite",							"FromClient_ResponseGuild_invite");
registerEvent("ResponseGuild_refuse", 							"FromClient_ResponseGuild_refuse");
registerEvent("ResponseGuildAlliance_invite",					"FromClient_ResponseGuildAlliance_invite");
registerEvent("ResponseGuildAlliance_refuse",					"FromClient_ResponseGuildAlliance_refuse");
registerEvent("EventChangeGuildInfo",							"FromClient_EventActorChangeGuildInfo" )
registerEvent("FromClient_UpdateGuildContract", 				"FromClient_ResponseUpdateGuildContract");
registerEvent("FromClient_NotifyGuildMessage", 					"FromClient_NotifyGuildMessage");
registerEvent("FromClient_GuildInviteForGuildGrade",			"FromClient_ResponseGuildInviteForGuildGrade");
registerEvent("FromClient_ResponseDeclareGuildWarToMyGuild ",	"FromClient_ResponseDeclareGuildWarToMyGuild");
registerEvent("FromClient_RequestGuildWar",						"FromClient_RequestGuildWar");
registerEvent("FromClient_ResponseGuildNotice",					"FromClient_ResponseGuildNotice")

registerEvent("FromWeb_WebPageError",							"FromWeb_WebPageError")


-- registerEvent( "FromClient_NotifyGuildMemberDoPk",				"FromClient_NotifyGuildMemberDoPk" )					-- 길드원이 유저를 죽였다.
-- registerEvent( "FromClient_NotifyGuildMemberKilledOtherPlayer",	"FromClient_NotifyGuildMemberKilledOtherPlayer" )		-- 길드원이 죽었다.

registerEvent("onScreenResize", 		"Guild_onScreenResize" )

-- registerEvent("FromClient_KingOrLordTentDestroy", 			"FromClient_KingOrLordTentDestroy")
-- registerEvent("FromClient_NotifyAttackedKingOrLordTent",		"NotifyAttackedKingOrLoadTent");
-- registerEvent("FromClient_KingOrLordTentCountUpdate",		"NotifyKingOrLoadTentCountUpdate");

GuildMainInfo_Show()
Notice_Init()
Introduce_Init()