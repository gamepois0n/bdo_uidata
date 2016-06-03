local UI_ANI_ADV 	= CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color 		= Defines.Color
local IM            = CppEnums.EProcessorInputMode
local UI_TM 		= CppEnums.TextMode

Panel_LocalWarInfo:SetShow( false, false )

Panel_LocalWarInfo:RegisterShowEventFunc( true, 'LocalWarInfoShowAni()' )
Panel_LocalWarInfo:RegisterShowEventFunc( false, 'LocalWarInfoHideAni()' )

function LocalWarInfoShowAni()
	Panel_LocalWarInfo:SetAlpha( 0 )
	UIAni.AlphaAnimation( 1, Panel_LocalWarInfo, 0.0, 0.3 )
end
function LocalWarInfoHideAni()
	local ani1 = UIAni.AlphaAnimation( 0, Panel_LocalWarInfo, 0.0, 0.2 )
	ani1:SetHideAtEnd( true )
end

-- function LocalWarInfoShowAni()
-- 	UIAni.fadeInSCR_Down( Panel_LocalWarInfo )

-- 	local aniInfo1 = Panel_LocalWarInfo:addScaleAnimation( 0.0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
-- 	aniInfo1:SetStartScale(0.5)
-- 	aniInfo1:SetEndScale(1.2)
-- 	aniInfo1.AxisX = Panel_LocalWarInfo:GetSizeX() / 2
-- 	aniInfo1.AxisY = Panel_LocalWarInfo:GetSizeY() / 2
-- 	aniInfo1.ScaleType = 2
-- 	aniInfo1.IsChangeChild = true
	
-- 	local aniInfo2 = Panel_LocalWarInfo:addScaleAnimation( 0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
-- 	aniInfo2:SetStartScale(1.2)
-- 	aniInfo2:SetEndScale(1.0)
-- 	aniInfo2.AxisX = Panel_LocalWarInfo:GetSizeX() / 2
-- 	aniInfo2.AxisY = Panel_LocalWarInfo:GetSizeY() / 2
-- 	aniInfo2.ScaleType = 2
-- 	aniInfo2.IsChangeChild = true
-- end
-- function LocalWarInfoHideAni()
-- 	local aniInfo1 = Panel_LocalWarInfo:addColorAnimation( 0.0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
-- 	aniInfo1:SetStartColor( UI_color.C_FFFFFFFF )
-- 	aniInfo1:SetEndColor( UI_color.C_00FFFFFF )
-- 	aniInfo1:SetStartIntensity( 3.0 )
-- 	aniInfo1:SetEndIntensity( 1.0 )
-- 	aniInfo1.IsChangeChild = true
-- 	aniInfo1:SetHideAtEnd(true)
-- 	aniInfo1:SetDisableWhileAni(true)
-- end

local localWarInfo = {
	_blackBG			= UI.getChildControl( Panel_LocalWarInfo, "Static_BlackBG"),
	_txtTitle			= UI.getChildControl( Panel_LocalWarInfo, "StaticText_Title" ),
	_btnClose			= UI.getChildControl( Panel_LocalWarInfo, "Button_Win_Close" ),
	_btnHelp			= UI.getChildControl( Panel_LocalWarInfo, "Button_Question" ),
	_listBg				= UI.getChildControl( Panel_LocalWarInfo, "Static_LocalWarListBG" ),
	_scroll				= UI.getChildControl( Panel_LocalWarInfo, "Scroll_LocalWarList"),

	_txtRule			= UI.getChildControl( Panel_LocalWarInfo, "StaticText_RuleContent"),
	_txtReward			= UI.getChildControl( Panel_LocalWarInfo, "StaticText_RewardContent"),
	_txtInfo			= UI.getChildControl( Panel_LocalWarInfo, "StaticText_InfoContent"),

	_btnInmy			= UI.getChildControl( Panel_LocalWarInfo, "Button_InmyChannel"),

	_txt_M_Level		= UI.getChildControl( Panel_LocalWarInfo, "StaticText_Limit_Level"),
	_txt_M_Ap			= UI.getChildControl( Panel_LocalWarInfo, "StaticText_Limit_AP"),
	_txt_M_Dp			= UI.getChildControl( Panel_LocalWarInfo, "StaticText_Limit_DP"),
	_txt_M_ADSum		= UI.getChildControl( Panel_LocalWarInfo, "StaticText_Limit_ADSum"),

	_icon_Level			= UI.getChildControl( Panel_LocalWarInfo, "Static_M_Limit_Level"),
	_icon_AP			= UI.getChildControl( Panel_LocalWarInfo, "Static_M_Limit_AP"),
	_icon_DP			= UI.getChildControl( Panel_LocalWarInfo, "Static_M_Limit_DP"),
	_icon_AD			= UI.getChildControl( Panel_LocalWarInfo, "Static_M_Limit_AD"),

	_desc_Rule_Title	= UI.getChildControl( Panel_LocalWarInfo, "StaticText_LocalWar_Rule"),
	_desc_rule			= UI.getChildControl( Panel_LocalWarInfo, "Static_BG_1"),

	desc_Rule =
	{
		[0] = UI.getChildControl( Panel_LocalWarInfo, "StaticText_Desc_Rule_1"),
			UI.getChildControl( Panel_LocalWarInfo, "StaticText_Desc_Rule_2"),
			UI.getChildControl( Panel_LocalWarInfo, "StaticText_Desc_Rule_3"),
			UI.getChildControl( Panel_LocalWarInfo, "StaticText_Desc_Rule_4"),
			UI.getChildControl( Panel_LocalWarInfo, "StaticText_Desc_Rule_5"),
			UI.getChildControl( Panel_LocalWarInfo, "StaticText_Desc_Rule_6"),
			UI.getChildControl( Panel_LocalWarInfo, "StaticText_Desc_Rule_7"),
			UI.getChildControl( Panel_LocalWarInfo, "StaticText_Desc_Rule_8"),
			UI.getChildControl( Panel_LocalWarInfo, "StaticText_Desc_Rule_9"),
			UI.getChildControl( Panel_LocalWarInfo, "StaticText_Desc_Rule_10"),
			UI.getChildControl( Panel_LocalWarInfo, "StaticText_Desc_Rule_11"),
			UI.getChildControl( Panel_LocalWarInfo, "StaticText_Desc_Rule_12"),
	},

	desc_RuleText =
	{
		[0] = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_RULETEXT_1"),
			PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_RULETEXT_2"),
			PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_RULETEXT_3"),
			PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_RULETEXT_4"),
			PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_RULETEXT_5"),
			PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_RULETEXT_6"),
			PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_RULETEXT_7"),
			PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_RULETEXT_8"),
			PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_RULETEXT_9"),
			PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_RULETEXT_10"),
			PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_RULETEXT_11"),
			PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_RULETEXT_12"),
	},

	_desc_Reward_Title	= UI.getChildControl( Panel_LocalWarInfo, "StaticText_LocalWar_Reward"),
	_desc_Reward		= UI.getChildControl( Panel_LocalWarInfo, "Static_BG_2"),

	desc_Reward =
	{
		[0] = UI.getChildControl( Panel_LocalWarInfo, "StaticText_Desc_Reward_1"),
		UI.getChildControl( Panel_LocalWarInfo, "StaticText_Desc_Reward_2"),
	},

	desc_RewardText =
	{
		[0] = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_REWARD_1"),
			PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_REWARD_2"),
	},

	_desc_Explanation_Title	= UI.getChildControl( Panel_LocalWarInfo, "StaticText_LocalWar_Explanation"),
	_desc_Explanation		= UI.getChildControl( Panel_LocalWarInfo, "Static_BG_3"),

	desc_Explanation =
	{
		[0] = UI.getChildControl( Panel_LocalWarInfo, "StaticText_Desc_Explanation_1"),
		UI.getChildControl( Panel_LocalWarInfo, "StaticText_Desc_Explanation_2"),
		UI.getChildControl( Panel_LocalWarInfo, "StaticText_Desc_Explanation_3"),
		UI.getChildControl( Panel_LocalWarInfo, "StaticText_Desc_Explanation_4"),
		UI.getChildControl( Panel_LocalWarInfo, "StaticText_Desc_Explanation_5"),
	},

	desc_ExplanationText =
	{
		[0] = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_EXPLANATION_1"),
			PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_EXPLANATION_2"),
			PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_EXPLANATION_3"),
			PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_EXPLANATION_4"),
			PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_EXPLANATION_5"),
	},

	_createListCount	= 14,
	_startIndex			= 0,
	_listPool			= {},

	_openDesc			= -1,
	_maxDescRuleSize	= 40, -- 245,
	_maxDescRewardSize	= 20,
	_maxDescExplanationSize	= 30,

	_posConfig = {
		_listStartPosY 	= 25,
		_iconStartPosY	= 88,
		_listPosYGap 	= 31,
	},
}
local localWarServerCountLimit = 0

function LocalWarInfo_Initionalize()
	--------------------------------------------------------
		
	local self = localWarInfo
	for listIdx = 0, self._createListCount-1 do
	-- for listIdx = 0, 40 do
		local localWar = {}
		-- 각 리스트당 BG
		localWar.BG			= UI.createAndCopyBasePropertyControl( Panel_LocalWarInfo, "StaticText_ListBG", self._listBg, "LocalWarInfo_BG_" .. listIdx )
		localWar.BG			:SetPosX( 5 )
		localWar.BG			:SetPosY( self._posConfig._listStartPosY + ( self._posConfig._listPosYGap * listIdx ) )
		-- Limit Level
		localWar.level		= UI.createAndCopyBasePropertyControl( Panel_LocalWarInfo, "StaticText_Limit_Level", localWar.BG, "localWarInfo_Level_"	.. listIdx )
		localWar.level		:SetPosX( 10 )
		localWar.level		:SetPosY( 4 )
		-- Limit AP
		localWar.ap			= UI.createAndCopyBasePropertyControl( Panel_LocalWarInfo, "StaticText_Limit_AP", localWar.BG, "localWarInfo_AP_"	.. listIdx )
		localWar.ap			:SetPosX( 35 )
		localWar.ap			:SetPosY( 4 )
		-- Limit DP
		localWar.dp			= UI.createAndCopyBasePropertyControl( Panel_LocalWarInfo, "StaticText_Limit_DP", localWar.BG, "localWarInfo_DP_"	.. listIdx )
		localWar.dp			:SetPosX( 60 )
		localWar.dp			:SetPosY( 4 )
		-- Limit AD Sum
		localWar.adSum		= UI.createAndCopyBasePropertyControl( Panel_LocalWarInfo, "StaticText_Limit_ADSum", localWar.BG, "localWarInfo_ADSum_"	.. listIdx )
		localWar.adSum		:SetPosX( 85 )
		localWar.adSum		:SetPosY( 4 )
		-- 제한 없음 멘트
		localWar.unLimit	= UI.createAndCopyBasePropertyControl( Panel_LocalWarInfo, "StaticText_Limit_Unlimit", localWar.BG, "localWarInfo_Unlimit_"	.. listIdx )
		localWar.unLimit	:SetPosX( 45 )
		localWar.unLimit	:SetPosY( 5 )
		-- 채널
		localWar.channel	= UI.createAndCopyBasePropertyControl( Panel_LocalWarInfo, "StaticText_Channel", localWar.BG, "localWarInfo_Channel_"	.. listIdx )
		localWar.channel	:SetPosX( 140 )
		localWar.channel	:SetPosY( 5 )
		-- 참여자 수
		localWar.joinMember	= UI.createAndCopyBasePropertyControl( Panel_LocalWarInfo, "StaticText_JoinMemberCount", localWar.BG, "localWarInfo_JoinMember_" .. listIdx )
		localWar.joinMember	:SetPosX( 278 )
		localWar.joinMember	:SetPosY( 5 )
		-- 남은 시간
		localWar.remainTime	= UI.createAndCopyBasePropertyControl( Panel_LocalWarInfo, "StaticText_RemainTime", localWar.BG, "localWarInfo_RemainTime_" .. listIdx )
		localWar.remainTime	:SetPosX( 340 )
		localWar.remainTime	:SetPosY( 5 )
		-- 입장 버튼
		localWar.join		= UI.createAndCopyBasePropertyControl( Panel_LocalWarInfo, "Button_Join", localWar.BG, "localWarInfo_Join_" .. listIdx )
		localWar.join		:SetPosX( 440 )
		localWar.join		:SetPosY( 5 )

		self._listPool[listIdx] = localWar

		localWar.BG:addInputEvent( "Mouse_UpScroll",				"LocalWarInfo_ScrollEvent( true )"	)
		localWar.BG:addInputEvent( "Mouse_DownScroll",				"LocalWarInfo_ScrollEvent( false )"	)
		localWar.channel:addInputEvent( "Mouse_UpScroll",			"LocalWarInfo_ScrollEvent( true )"	)
		localWar.channel:addInputEvent( "Mouse_DownScroll",			"LocalWarInfo_ScrollEvent( false )"	)
		localWar.joinMember:addInputEvent( "Mouse_UpScroll",		"LocalWarInfo_ScrollEvent( true )" )
		localWar.joinMember:addInputEvent( "Mouse_DownScroll",		"LocalWarInfo_ScrollEvent( false )" )
		localWar.remainTime:addInputEvent( "Mouse_UpScroll",		"LocalWarInfo_ScrollEvent( true )")
		localWar.remainTime:addInputEvent( "Mouse_DownScroll",		"LocalWarInfo_ScrollEvent( false )")
		UIScroll.InputEventByControl( localWar.BG,					"LocalWarInfo_ScrollEvent" )
		UIScroll.InputEventByControl( localWar.channel,				"LocalWarInfo_ScrollEvent" )
		UIScroll.InputEventByControl( localWar.joinMember,			"LocalWarInfo_ScrollEvent" )
		UIScroll.InputEventByControl( localWar.remainTime,			"LocalWarInfo_ScrollEvent" )
	end

	local screenSizeX = getScreenSizeX()
	local screenSizeY = getScreenSizeY()
	Panel_LocalWarInfo:SetPosX( (screenSizeX - Panel_LocalWarInfo:GetSizeX()) / 2 )
	Panel_LocalWarInfo:SetPosY( (screenSizeY - Panel_LocalWarInfo:GetSizeY()) / 2 )

	-- self._desc_rule		:AddChild( self._txtRule )
	-- Panel_LocalWarInfo	:RemoveControl( self._txtRule )


	self._icon_Level	:addInputEvent( "Mouse_On",		"LocalWarInfo_SimpleTooltip( true, 0 )")
	self._icon_Level	:addInputEvent( "Mouse_Out",	"LocalWarInfo_SimpleTooltip( false, 0 )")
	self._icon_AP		:addInputEvent( "Mouse_On",		"LocalWarInfo_SimpleTooltip( true, 1 )")
	self._icon_AP		:addInputEvent( "Mouse_Out",	"LocalWarInfo_SimpleTooltip( false, 1 )")
	self._icon_DP		:addInputEvent( "Mouse_On",		"LocalWarInfo_SimpleTooltip( true, 2 )")
	self._icon_DP		:addInputEvent( "Mouse_Out",	"LocalWarInfo_SimpleTooltip( false, 2 )")
	self._icon_AD		:addInputEvent( "Mouse_On",		"LocalWarInfo_SimpleTooltip( true, 3 )")
	self._icon_AD		:addInputEvent( "Mouse_Out",	"LocalWarInfo_SimpleTooltip( false, 3 )")

	self._icon_Level	:setTooltipEventRegistFunc( "LocalWarInfo_SimpleTooltip( true, 0 )" )
	self._icon_AP		:setTooltipEventRegistFunc( "LocalWarInfo_SimpleTooltip( true, 1 )" )
	self._icon_DP		:setTooltipEventRegistFunc( "LocalWarInfo_SimpleTooltip( true, 2 )" )
	self._icon_AD		:setTooltipEventRegistFunc( "LocalWarInfo_SimpleTooltip( true, 3 )" )

	self._txtRule	:SetTextMode( UI_TM.eTextMode_AutoWrap )
	self._txtReward	:SetTextMode( UI_TM.eTextMode_AutoWrap )
	self._txtInfo	:SetTextMode( UI_TM.eTextMode_AutoWrap )
	--{ 붉은전장 규칙
	for _, control in pairs( self.desc_Rule ) do
		self._desc_rule:AddChild( control )
	end
	for _, control in pairs( self.desc_Rule ) do
		Panel_LocalWarInfo:RemoveControl( control )
	end
	for _, control in pairs( self.desc_Rule ) do
		control:SetTextMode( UI_TM.eTextMode_AutoWrap )
		control:SetAutoResize( true )
	end
	for index=0, #self.desc_RuleText do
		self.desc_Rule[index]:SetText( self.desc_RuleText[index] )
		self._maxDescRuleSize = self._maxDescRuleSize + self.desc_Rule[index]:GetTextSizeY()
	end
	--}
	--{ 붉은전장 보상
	for _, control in pairs( self.desc_Reward ) do
		self._desc_Reward:AddChild( control )
	end
	for _, control in pairs( self.desc_Reward ) do
		Panel_LocalWarInfo:RemoveControl( control )
	end
	for _, control in pairs( self.desc_Reward ) do
		control:SetTextMode( UI_TM.eTextMode_AutoWrap )
		control:SetAutoResize( true )
	end
	for index=0, #self.desc_RewardText do
		self.desc_Reward[index]:SetText( self.desc_RewardText[index] )
		self._maxDescRewardSize = self._maxDescRewardSize + self.desc_Reward[index]:GetTextSizeY()
	end
	--}
	--{ 붉은전장 설명
	for _, control in pairs( self.desc_Explanation ) do
		self._desc_Explanation:AddChild( control )
	end
	for _, control in pairs( self.desc_Explanation ) do
		Panel_LocalWarInfo:RemoveControl( control )
	end
	for _, control in pairs( self.desc_Explanation ) do
		control:SetTextMode( UI_TM.eTextMode_AutoWrap )
		control:SetAutoResize( true )
	end
	for index=0, #self.desc_ExplanationText do
		self.desc_Explanation[index]:SetText( self.desc_ExplanationText[index] )
		self._maxDescExplanationSize = self._maxDescExplanationSize + self.desc_Explanation[index]:GetTextSizeY()
	end
	--}

	self._txtRule	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_RULE") )
	self._txtReward	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_REWARD") )
	self._txtInfo	:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_INFO") )

	self._desc_Reward_Title:SetPosY( 85 )
	self._desc_Explanation_Title:SetPosY( 110 )

	for index=0, #self.desc_RuleText do
		self.desc_Rule[index]:SetPosX( 5 )
	end
	self.desc_Rule[0]:SetPosY( 5 )
	self.desc_Rule[1]:SetPosY( self.desc_Rule[0]:GetPosY()+self.desc_Rule[0]:GetTextSizeY() + 2 )
	self.desc_Rule[2]:SetPosY( self.desc_Rule[1]:GetPosY()+self.desc_Rule[1]:GetTextSizeY() + 2 )
	self.desc_Rule[3]:SetPosY( self.desc_Rule[2]:GetPosY()+self.desc_Rule[2]:GetTextSizeY() + 2 )
	self.desc_Rule[4]:SetPosY( self.desc_Rule[3]:GetPosY()+self.desc_Rule[3]:GetTextSizeY() + 2 )
	self.desc_Rule[5]:SetPosY( self.desc_Rule[4]:GetPosY()+self.desc_Rule[4]:GetTextSizeY() + 2 )
	self.desc_Rule[6]:SetPosY( self.desc_Rule[5]:GetPosY()+self.desc_Rule[5]:GetTextSizeY() + 2 )
	self.desc_Rule[7]:SetPosY( self.desc_Rule[6]:GetPosY()+self.desc_Rule[6]:GetTextSizeY() + 2 )
	self.desc_Rule[8]:SetPosY( self.desc_Rule[7]:GetPosY()+self.desc_Rule[7]:GetTextSizeY() + 2 )
	self.desc_Rule[9]:SetPosY( self.desc_Rule[8]:GetPosY()+self.desc_Rule[8]:GetTextSizeY() + 2 )
	self.desc_Rule[10]:SetPosY( self.desc_Rule[9]:GetPosY()+self.desc_Rule[9]:GetTextSizeY() + 2 )
	self.desc_Rule[11]:SetPosY( self.desc_Rule[10]:GetPosY()+self.desc_Rule[10]:GetTextSizeY() + 2 )

	for index=0, #self.desc_RewardText do
		self.desc_Reward[index]:SetPosX( 5 )
	end
	self.desc_Reward[0]:SetPosY( 5 )
	self.desc_Reward[1]:SetPosY( self.desc_Reward[0]:GetPosY()+self.desc_Reward[0]:GetTextSizeY() + 2 )

	for index=0, #self.desc_ExplanationText do
		self.desc_Explanation[index]:SetPosX( 5 )
	end
	self.desc_Explanation[0]:SetPosY( 5 )
	self.desc_Explanation[1]:SetPosY( self.desc_Explanation[0]:GetPosY()+self.desc_Explanation[0]:GetTextSizeY() + 2 )
	self.desc_Explanation[2]:SetPosY( self.desc_Explanation[1]:GetPosY()+self.desc_Explanation[1]:GetTextSizeY() + 2 )
	self.desc_Explanation[3]:SetPosY( self.desc_Explanation[2]:GetPosY()+self.desc_Explanation[2]:GetTextSizeY() + 2 )
	self.desc_Explanation[4]:SetPosY( self.desc_Explanation[3]:GetPosY()+self.desc_Explanation[3]:GetTextSizeY() + 2 )

	self._txtRule:SetPosX(5)
	self._txtRule:SetPosY(5)
	self._blackBG:SetSize( getScreenSizeX()+250, getScreenSizeY()+250 )
	self._blackBG:SetHorizonCenter()
	self._blackBG:SetVerticalMiddle()

	if isGameTypeKorea() then
		self._icon_Level	:SetShow( true )
		self._icon_Level	:SetSpanSize( 60, 62 )
		self._icon_AP		:SetSpanSize( 87, 62 )
		self._icon_DP		:SetSpanSize( 115, 62 )
		self._icon_AD		:SetSpanSize( 145, 62 )
	else
		self._icon_Level	:SetShow( false )
		-- self._icon_Level	:SetSpanSize( 60, 62 )
		self._icon_AP		:SetSpanSize( 60, 62 )
		self._icon_DP		:SetSpanSize( 100, 62 )
		self._icon_AD		:SetSpanSize( 145, 62 )
	end

	self._scroll:SetControlTop()
end


function localWarInfo:Update()
	for listIdx = 0, self._createListCount-1 do	-- 리스트 초기화.
	-- for listIdx = 0, 15 do	-- 리스트 초기화.
		local list = self._listPool[listIdx]
		list.BG					:SetShow( false )
		list.channel			:SetShow( false )
		list.joinMember			:SetShow( false )
		list.remainTime			:SetShow( false )
		list.join				:SetShow( false )
	end

	local curChannelData		= getCurrentChannelServerData()
	if ( nil == curChannelData ) then
		return
	end

	local localWarServerCount = ToClient_GetLocalwarStatusCount()
	if 6 < localWarServerCount then		-- 북미는 6개 서버만 나와야한다.(4개 일반 채널 / 2개 제한 채널 제한 채널은 각 퍼블에서 서버셋팅 설정을 해서 설정된다.)
		localWarServerCountLimit = 6
	else
		localWarServerCountLimit = ToClient_GetLocalwarStatusCount()
	end
	local count = 0
	for listIdx = self._startIndex, localWarServerCountLimit-1 do
	-- for listIdx = 0, 40 do
		if ( self._createListCount <= count ) then
			break
		end
		local localWarStatusData		= ToClient_GetLocalwarStatusData( listIdx )
		local getServerNo				= localWarStatusData:getServerNo()							-- 붉은 전장 현황 서버넘버를 가져온다.
		local getJoinMemberCount		= localWarStatusData:getTotalJoinCount()					-- 해당 붉은 전장 참여 총 인원
		local getCurrentState			= localWarStatusData:getState()								-- 0: 붉은 전장 참여 알림 / 1: 플레이 중 / 2: 결과 / 3: 종료
		local getRemainTime				= localWarStatusData:getRemainTime()						-- 해당 붉은 전장의 남은 시간
		local warTimeMinute				= math.floor(Int64toInt32(getRemainTime / toInt64(0,60)))	-- 분
		local warTimeSecond				= Int64toInt32(getRemainTime) % 60							-- 초
		local channelName				= getChannelName(curChannelData._worldNo, getServerNo )		-- 서버 넘버로 채널 이름명을 알아온다.
		local isLimitLocalWar			= localWarStatusData:isLimitedLocalWar()					-- 제한 스펙 붉은전장 체크

		-- -1값이 들어오는 경우가 있다.
		if getJoinMemberCount < 0 then
			getJoinMemberCount = 0
		end

		local list = self._listPool[count]

		if isGameTypeKorea() then
			list.level	:SetShow( true )
			list.level	:SetPosX( 0 )
			list.ap		:SetPosX( 25 )
			list.dp		:SetPosX( 55 )
			list.adSum	:SetPosX( 85 )
		else
			list.level:SetShow( false )
			list.ap		:SetPosX( 0 )
			list.dp		:SetPosX( 40 )
			list.adSum	:SetPosX( 85 )
		end

		if isLimitLocalWar then
			list.unLimit:SetShow( false )
			list.level	:SetText( ToClient_GetLevelForLimitedLocalWar()-1 )		-- 정보가 +1되어서 오기 때문에 -1해준다.
			list.ap		:SetText( ToClient_GetAttackForLimitedLocalWar()-1 )	-- 정보가 +1되어서 오기 때문에 -1해준다.
			list.dp		:SetText( ToClient_GetDefenseForLimitedLocalWar()-1 )	-- 정보가 +1되어서 오기 때문에 -1해준다.
			list.adSum	:SetText( ToClient_GetADSummaryForLimitedLocalWar()-1 )	-- 정보가 +1되어서 오기 때문에 -1해준다.
		else
			list.unLimit:SetShow( true )
			list.level	:SetText( "" )
			list.ap		:SetText( "" )
			list.dp		:SetText( "" )
			list.adSum	:SetText( "" )
		end

		if 0 == getCurrentState then
			isCurrentState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_JOIN_WAITING") -- "참여 대기 중"
			isWarTime = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_WAITING") -- "대기중"
			list.join:SetFontColor( Defines.Color.C_FF3B8BBE )
			list.join:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_JOIN") ) -- 입장
			list.join:SetIgnore( false )
		elseif 1 == getCurrentState then
			isCurrentState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_ING") -- "진행중"
			isWarTime = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_LOCALWARINFO_TIME", "warTimeMinute", warTimeMinute, "warTimeSecond", Int64toInt32(warTimeSecond) ) -- warTimeMinute .. "분 " .. Int64toInt32(warTimeSecond) .. "초"
			if 10 <= warTimeMinute then
				list.join:SetFontColor( Defines.Color.C_FF3B8BBE )
				list.join:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_JOIN") ) -- 입장
				list.join:SetIgnore( false )
			else
				list.join:SetFontColor( Defines.Color.C_FFF26A6A )
				list.join:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_CANTJOIN") ) -- 입장불가
				list.join:SetIgnore( true )
			end
		elseif 2 == getCurrentState then
			isCurrentState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_SOONFINISH") -- "곧 종료 예정"
			isWarTime = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_LOCALWARINFO_TIME", "warTimeMinute", warTimeMinute, "warTimeSecond", Int64toInt32(warTimeSecond) ) --warTimeMinute .. "분 " .. Int64toInt32(warTimeSecond) .. "초"
			list.join:SetFontColor( Defines.Color.C_FFF26A6A )
			list.join:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_CANTJOIN") ) -- "입장불가")
			list.join:SetIgnore( true )
		elseif 3 == getCurrentState then
			isCurrentState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_FINISH") -- "종료"
			isWarTime = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_FINISH") -- "종료"
			list.join:SetFontColor( Defines.Color.C_FFF26A6A )
			list.join:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_CANTJOIN") ) -- "입장불가")
			list.join:SetIgnore( true )
		end

		list.BG				:SetShow( true )
		list.channel		:SetShow( true )
		list.joinMember		:SetShow( true )
		list.remainTime		:SetShow( true )
		list.join			:SetShow( true )
		-- 길드 순위
		list.channel		:SetText( channelName )		-- 채널 이름
		list.joinMember		:SetText( getJoinMemberCount )
		list.remainTime		:SetText( isWarTime )
		list.join			:addInputEvent("Mouse_LUp", "LocalWawrInfo_ClickedJoinLocalWar( " .. listIdx .. " )")

		count = count + 1
	end

	local inMyChannelInfo		= ToClient_GetLocalwarStatusDataToServer( curChannelData._serverNo )
	if nil == inMyChannelInfo then
		self._btnInmy:SetFontColor( UI_color.C_FFF26A6A )
		self._btnInmy:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_NOTOPENWAR") ) -- "붉은전장이 열리지 않는 채널입니다."
		self._btnInmy:SetEnable( false )
		self._btnInmy:addInputEvent("Mouse_LUp", "")
	else

		local inMyJoinCount			= inMyChannelInfo:getTotalJoinCount()					-- 해당 붉은 전장 참여 총 인원
		local inMyJoinState			= inMyChannelInfo:getState()								-- 0: 붉은 전장 참여 알림 / 1: 플레이 중 / 2: 결과 / 3: 종료
		local inMyRemainTime		= inMyChannelInfo:getRemainTime()						-- 해당 붉은 전장의 남은 시간
		local inMyRemainTimeMinute	= math.floor(Int64toInt32(inMyRemainTime / toInt64(0,60)))	-- 분
		local inMyRemainTimeSecond	= Int64toInt32(inMyRemainTime) % 60							-- 초
		local inMyChannelName		= getChannelName(curChannelData._worldNo, curChannelData._serverNo )		-- 서버 넘버로 채널 이름명을 알아온다.
		if 0 == inMyJoinState then
			isMyChannelState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_WAITING") -- "대기중"
		elseif 1 == inMyJoinState then
			isMyChannelState = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_LOCALWARINFO_TIME", "warTimeMinute", inMyRemainTimeMinute, "warTimeSecond", Int64toInt32(inMyRemainTimeSecond) )
		elseif 2 == inMyJoinState then
			isMyChannelState = PAGetStringParam2( Defines.StringSheet_GAME, "LUA_LOCALWARINFO_TIME", "warTimeMinute", inMyRemainTimeMinute, "warTimeSecond", Int64toInt32(inMyRemainTimeSecond) )
		elseif 3 == inMyJoinState then
			isMyChannelState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_FINISH")
		end

		self._btnInmy:SetFontColor( UI_color.C_FF00C0D7 )
		self._btnInmy:SetText( PAGetStringParam3( Defines.StringSheet_GAME, "LUA_LOCALWARINFO_OPENWAR_INMYCHANNEL", "inMyChannelName", inMyChannelName, "inMyJoinCount", inMyJoinCount, "isMyChannelState", isMyChannelState ) ) -- "[" .. inMyChannelName .. "]채널( 참여자 수 : " .. inMyJoinCount .. " / " .. isMyChannelState .. " )" )
		self._btnInmy:SetEnable( true )
		self._btnInmy:addInputEvent("Mouse_LUp", "HandleClicked_InMyChannelJoin()")
	end

	UIScroll.SetButtonSize			( self._scroll, self._createListCount, localWarServerCount )
end

function FGlobal_LocalWarInfo_Open()
	local self		= localWarInfo
	local getLevel	= getSelfPlayer():get():getLevel()
	if getLevel < 50 then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_LEVELLIMIT") ) -- 50레벨 부터 붉은전장에 입장 가능합니다.
		return
	end
	ToClient_RequestLocalwarStatus()
	if Panel_LocalWarInfo:GetShow() then
		Panel_LocalWarInfo:SetShow( false, true )
	else
		Panel_LocalWarInfo:SetShow( true, true )
	end

	self._desc_Rule_Title:SetCheck( true )
	self._desc_Reward_Title:SetCheck( false )
	self._desc_Explanation_Title:SetCheck( false )
	-- self._desc_rule:SetSize( self._desc_rule:GetSizeX(), 1 )
	self._desc_rule:SetShow( false )
	self._desc_Reward:SetShow( false )
	self._desc_Explanation:SetShow( false )
	self._desc_rule:SetSize( self._desc_rule:GetSizeX(), 1 )
	self._desc_Reward:SetSize( self._desc_Reward:GetSizeX(), 1 )
	self._desc_Explanation:SetSize( self._desc_Explanation:GetSizeX(), 1 )
	self._startIndex = 0
	self._scroll:SetControlTop()
	self:Update()
end

function FGlobal_LocalWarInfo_Close()
	local self = localWarInfo
	self._openDesc = -1
	-- self._desc_rule:SetSize( self._desc_rule:GetSizeX(), 1 )

	self._desc_Rule_Title:SetCheck( false )
	self._desc_Reward_Title:SetCheck( false )
	self._desc_Explanation_Title:SetCheck( false )
	self._desc_rule:SetShow( false )
	self._desc_Reward:SetShow( false )
	self._desc_Explanation:SetShow( false )
	self._desc_rule:SetSize( self._desc_rule:GetSizeX(), 1 )
	self._desc_Reward:SetSize( self._desc_Reward:GetSizeX(), 1 )
	self._desc_Explanation:SetSize( self._desc_Explanation:GetSizeX(), 1 )
	Panel_LocalWarInfo:SetShow( false, true )
	TooltipSimple_Hide()
	-- TooltipGuild_Hide()
end

function FGlobal_LocalWarInfo_GetOut()
	ToClient_UnJoinLocalWar()	-- 붉은 전장 이탈 함수.
end

function LocalWarInfo_Repos()
	local self = localWarInfo
	local screenSizeX = getScreenSizeX()
	local screenSizeY = getScreenSizeY()
	Panel_LocalWarInfo:SetPosX( (screenSizeX - Panel_LocalWarInfo:GetSizeX()) / 2 )
	Panel_LocalWarInfo:SetPosY( (screenSizeY - Panel_LocalWarInfo:GetSizeY()) / 2 )

	Panel_LocalWarInfo:ComputePos()
	self._blackBG:SetSize( getScreenSizeX()+250, getScreenSizeY()+250 )
	self._blackBG:SetHorizonCenter()
	self._blackBG:SetVerticalMiddle()
end

function LocalWarInfo_ScrollEvent( isScrollUp )	-- 스크롤 추가시 사용
	local self					= localWarInfo
	local localWarServerCount	= ToClient_GetLocalwarStatusCount()
	self._startIndex	= UIScroll.ScrollEvent( self._scroll, isScrollUp, self._createListCount, localWarServerCount, self._startIndex, 1 )
	self:Update()
end

function LocalWawrInfo_ClickedJoinLocalWar( index )
	local curChannelData		= getCurrentChannelServerData()
	local getLevel				= getSelfPlayer():get():getLevel()
	if ( nil == curChannelData ) then
		return
	end
	if getLevel < 50 then
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_LEVELLIMIT") ) -- 50레벨 부터 붉은전장에 입장 가능합니다.
		return
	end
	local localWarStatusData		= ToClient_GetLocalwarStatusData( index )
	local getServerNo				= localWarStatusData:getServerNo()
	local channelName				= getChannelName(curChannelData._worldNo, getServerNo )
	local isGameMaster				= ToClient_SelfPlayerIsGM()
	local channelMemo				= PAGetStringParam1( Defines.StringSheet_GAME, "LUA_LOCALWARINFO_CHANNELMOVE", "channelName", channelName )

	local tempChannel	= getGameChannelServerDataByWorldNo(curChannelData._worldNo, index)
	local joinLocalWar = function()
		local playerWrapper = getSelfPlayer()
		local player		= playerWrapper:get()
		local hp			= player:getHp()
		local maxHp			= player:getMaxHp()

		if player:doRideMyVehicle() then
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_NOT_RIDEHORSE") ) -- "탑승물에 탑승중에는 이용할 수 없습니다." )
		end

		if IsSelfPlayerWaitAction() then
			if (hp == maxHp) then
				if (getServerNo == curChannelData._serverNo) then
					ToClient_JoinLocalWar()
				else
					ToClient_RequestLocalwarJoinToAnotherChannel( getServerNo )
				end
			else
				Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_MAXHP_CHECK") ) -- 생명력을 꽉 채운 상태에서만 입장 가능합니다.
			end
		else
			Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_LOCALWARINFO") ) -- 대기 상태에서만 전장 현황을 이용할 수 있습니다.
		end
	end
	if (getServerNo == curChannelData._serverNo) then
		channelMemo = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_CURRENTCHANNELJOIN") -- "현재 채널에서 붉은전장에 참여합니다.\n붉은전장에 참여 하시겠습니까?"
	else
		channelMemo = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_LOCALWARINFO_CHANNELMOVE", "channelName", channelName ) -- channelName .. "로 이동하여 붉은전장에 참여합니다.\n이동하시겠습니까?"
	end

	local changeChannelTime		= getChannelMoveableRemainTime( curChannelData._worldNo )
	local changeRealChannelTime	= convertStringFromDatetime( changeChannelTime )
	if ( toInt64(0,0) < changeChannelTime ) and (getServerNo ~= curChannelData._serverNo) then
		local messageBoxMemo = PAGetStringParam1( Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANGECHANNEL_PENALTY", "changeRealChannelTime", changeRealChannelTime )
		local messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_TITLE_MSG"), content = messageBoxMemo, functionYes = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
	else
		local	messageBoxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_TITLE_MSG"), content = channelMemo, functionYes = joinLocalWar, functionNo = MessageBox_Empty_function, priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW}
		MessageBox.showMessageBox(messageBoxData)
	end
end

function FromClient_UpdateLocalWarStatus()
	local self = localWarInfo
	self:Update()
end

function HandleClicked_InMyChannelJoin()
	local playerWrapper = getSelfPlayer()
	local player		= playerWrapper:get()
	local hp			= player:getHp()
	local maxHp			= player:getMaxHp()
	if hp == maxHp then
		ToClient_JoinLocalWar()
	else
		Proc_ShowMessage_Ack( PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_MAXHP_CHECK") ) -- 생명력을 꽉 채운 상태에서만 입장 가능합니다.
	end
end

function LocalWarInfo_SimpleTooltip( isShow, tipType )
	local self = localWarInfo
	local name, desc, control = nil, nil, nil
	if 0 == tipType then	-- 레벨 제한
		name	= PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_LIMIT_TOOLTIP_LEVEL_NAME")
		desc	= PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_LIMIT_TOOLTIP_LEVEL_DESC")
		control	= self._icon_Level
	elseif 1 == tipType then	-- 공격력 제한
		name	= PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_LIMIT_TOOLTIP_AP_NAME")
		desc	= PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_LIMIT_TOOLTIP_AP_DESC")
		control	= self._icon_AP
	elseif 2 == tipType then	-- 방어력 제한
		name	= PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_LIMIT_TOOLTIP_DP_NAME")
		desc	= PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_LIMIT_TOOLTIP_DP_DESC")
		control	= self._icon_DP
	elseif 3 == tipType then	-- 공격력 방어력 합산
		name	= PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_LIMIT_TOOLTIP_ADSUM_NAME")
		desc	= PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_LIMIT_TOOLTIP_ADSUM_DESC")
		control	= self._icon_AD
	end

	registTooltipControl(control, Panel_Tooltip_SimpleText)
	if isShow == true then
		TooltipSimple_Show( control, name, desc )
	else
		TooltipSimple_Hide()
	end
end

function LocalWarInfo_RegistEventHandler()
	local self = localWarInfo

	self._btnClose					:addInputEvent("Mouse_LUp", "FGlobal_LocalWarInfo_Close()")
	self._listBg					:addInputEvent(	"Mouse_UpScroll",	"LocalWarInfo_ScrollEvent( true )"	)
	self._listBg					:addInputEvent(	"Mouse_DownScroll",	"LocalWarInfo_ScrollEvent( false )"	)
	self._desc_Rule_Title			:addInputEvent("Mouse_LUp", "LocalWarInfo_DescriptionCheck(0)")
	self._desc_Reward_Title			:addInputEvent("Mouse_LUp", "LocalWarInfo_DescriptionCheck(1)")
	self._desc_Explanation_Title	:addInputEvent("Mouse_LUp", "LocalWarInfo_DescriptionCheck(2)")
	UIScroll.InputEvent( self._scroll,	"LocalWarInfo_ScrollEvent" )

	localWarInfo._btnHelp:SetShow(false)	-- 도움말 추가시 삭제 및 아래 주석처리된 라인 주석 해제
end

function LocalWarInfo_DescriptionCheck( descType )
	local self = localWarInfo
	if 0 == descType then
		self._openDesc = descType
		self._desc_rule:SetShow( true )
	elseif 1 == descType then
		self._openDesc = descType
		self._desc_Reward:SetShow( true )
	elseif 2 == descType then
		self._openDesc = descType
		self._desc_Explanation:SetShow( true )
	else
		self._openDesc = -1
	end
end

local rule_ani_SpeedTime = 5.0
local _desc_Rule_TitleSize = 0
function LocalWarInfo_InformationOpen( deltaTime )
	local self = localWarInfo

	if self._desc_Rule_Title:IsCheck() then
		local value = self._desc_rule:GetSizeY() + ( self._maxDescRuleSize - self._desc_rule:GetSizeY() ) * deltaTime * rule_ani_SpeedTime
		if ( value < 10 ) then
			value = 10
		end
		self._desc_rule:SetSize( self._desc_rule:GetSizeX(), value)
		self._desc_rule:SetShow(true)
	else
		local value = self._desc_rule:GetSizeY() - ( self._maxDescRuleSize + self._desc_rule:GetSizeY() ) * deltaTime * rule_ani_SpeedTime
		if ( value < 10 ) then
			value = 10
		end
		self._desc_rule:SetSize( self._desc_rule:GetSizeX(), value)
		if self._desc_rule:GetSizeY() <= 10 then
			self._desc_rule:SetShow(false)
		end
	end

	if self._desc_Reward_Title:IsCheck() then
		local value = self._desc_Reward:GetSizeY() + ( self._maxDescRewardSize - self._desc_Reward:GetSizeY() ) * deltaTime * rule_ani_SpeedTime
		if ( value < 10 ) then
			value = 10
		end
		self._desc_Reward:SetSize( self._desc_Reward:GetSizeX(), value)
		self._desc_Reward:SetShow(true)
	else
		local value = self._desc_Reward:GetSizeY() - ( self._maxDescRewardSize + self._desc_Reward:GetSizeY() ) * deltaTime * rule_ani_SpeedTime
		if ( value < 10 ) then
			value = 10
		end
		self._desc_Reward:SetSize( self._desc_Reward:GetSizeX(), value)
		if self._desc_Reward:GetSizeY() <= 10 then
			self._desc_Reward:SetShow(false)
		end
	end

	if self._desc_Explanation_Title:IsCheck() then
		local value = self._desc_Explanation:GetSizeY() + ( self._maxDescExplanationSize - self._desc_Explanation:GetSizeY() ) * deltaTime * rule_ani_SpeedTime
		if ( value < 10 ) then
			value = 10
		end
		self._desc_Explanation:SetSize( self._desc_Explanation:GetSizeX(), value)
		self._desc_Explanation:SetShow(true)
	else
		local value = self._desc_Explanation:GetSizeY() - ( self._maxDescExplanationSize + self._desc_Explanation:GetSizeY() ) * deltaTime * rule_ani_SpeedTime
		if ( value < 10 ) then
			value = 10
		end
		self._desc_Explanation:SetSize( self._desc_Explanation:GetSizeX(), value)
		if self._desc_Explanation:GetSizeY() <= 10 then
			self._desc_Explanation:SetShow(false)
		end
	end

	self._desc_rule:SetPosY(self._desc_Rule_Title:GetPosY() + self._desc_Rule_Title:GetSizeY())

	if ( self._desc_rule:GetShow() ) then
		self._desc_Reward_Title:SetPosY(self._desc_rule:GetPosY() + self._desc_rule:GetSizeY() + 10)
	else
		self._desc_Reward_Title:SetPosY(self._desc_Rule_Title:GetPosY() + self._desc_Rule_Title:GetSizeY()+5)
	end
	self._desc_Reward:SetPosY(self._desc_Reward_Title:GetPosY() + self._desc_Reward_Title:GetSizeY())

	if ( self._desc_Reward:GetShow() ) then
		self._desc_Explanation_Title:SetPosY(self._desc_Reward:GetPosY() + self._desc_Reward:GetSizeY() + 10)
	else
		self._desc_Explanation_Title:SetPosY(self._desc_Reward_Title:GetPosY() + self._desc_Reward_Title:GetSizeY()+5)
	end
	self._desc_Explanation:SetPosY(self._desc_Explanation_Title:GetPosY() + self._desc_Explanation_Title:GetSizeY())

	for _, control in pairs( self.desc_Rule ) do
		control:SetShow( control:GetPosY() + control:GetSizeY() < self._desc_rule:GetSizeY() )
	end
	for _, control in pairs( self.desc_Reward ) do
		control:SetShow( control:GetPosY() + control:GetSizeY() < self._desc_Reward:GetSizeY() )
	end
	for _, control in pairs( self.desc_Explanation ) do
		control:SetShow( control:GetPosY() + control:GetSizeY() < self._desc_Explanation:GetSizeY() )
	end
end

function LocalWarInfo_RegistMessageHandler()
	registerEvent("onScreenResize", 						"LocalWarInfo_Repos" )
	registerEvent("FromClient_UpdateLocalWarStatus", 		"FromClient_UpdateLocalWarStatus" )
	Panel_LocalWarInfo:RegisterUpdateFunc("LocalWarInfo_InformationOpen")
end


LocalWarInfo_Initionalize()
LocalWarInfo_RegistEventHandler()
LocalWarInfo_RegistMessageHandler()