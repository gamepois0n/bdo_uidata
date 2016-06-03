local UI_PP 		= CppEnums.PAUIMB_PRIORITY
local UI_TM 		= CppEnums.TextMode
local UI_color      = Defines.Color

-- 진행중 길드 퀘스트 화면 우측 상단 표시
Panel_Current_Guild_Quest:SetShow(false)
Panel_Current_Guild_Quest:SetIgnore( false )
GuildProgressQuestInfoPage = 
{
	_firstUpdate				= true,
	_currentTime 				= 0,
	_RewardPosX					= 0,
	_btnQuestNaviOriginPosX		= 0,
	_btnQuestGiveupOriginPosX	= 0,
	_btnQuestRewardOriginPosX 	= 0,
	_txtQuestTitle,
	_txtQuestCondition 			= {},
	_txtQuestLimitTime,
	_btnQuestNavi,
	_btnQuestGiveup,
	_btnQuestReward,
	-- _questIcon,
	_questBG,
	-- _completeEff1,
}
--[[
GuildProgressQuestInfoPage
	initialize()
	UpdateData()	
]]--

------------------------------------------------------------------
--					최초 초기화 해주는 함수 ( Frame_Guild_Quest.lua 에서 사용)
------------------------------------------------------------------
function GuildProgressQuestInfoPage:initialize()
	self._txtQuestTitle			= UI.getChildControl ( Panel_Current_Guild_Quest, "StaticText_Title" )
	self._txtQuestLimitTime		= UI.getChildControl ( Panel_Current_Guild_Quest, "StaticText_LimitTime" )	
	self._btnQuestNavi			= UI.getChildControl ( Panel_Current_Guild_Quest, "Checkbox_Quest_Navi" )
	self._btnQuestGiveup		= UI.getChildControl ( Panel_Current_Guild_Quest, "Checkbox_Quest_Giveup" )
	self._btnQuestReward		= UI.getChildControl ( Panel_Current_Guild_Quest, "Checkbox_Quest_Reward" )
	self._questBG               = UI.getChildControl ( Panel_Current_Guild_Quest, "Static_BG")

	self._questBG               :SetShow(false)
	
	for index = 0, 4, 1 do
		self._txtQuestCondition[index] = UI.getChildControl( Panel_Current_Guild_Quest, "StaticText_Condition"..tostring(index + 1) )
		self._txtQuestCondition[index]:SetShow(false)
		self._txtQuestCondition[index]:SetAutoResize( true )
		self._txtQuestCondition[index]:SetIgnore( true )	
		self._txtQuestCondition[index]:SetTextMode( UI_TM.eTextMode_AutoWrap )
	end
	
	self._txtQuestTitle:SetTextMode( UI_TM.eTextMode_LimitText )	
	self._txtQuestTitle:SetSize(self._txtQuestTitle:GetSizeX() + 50 ,self._txtQuestTitle:GetSizeY())		
	
	self._btnQuestNaviOriginPosX = self._btnQuestNavi:GetPosX() - 120
	self._btnQuestGiveupOriginPosX = self._btnQuestGiveup:GetPosX() - 120
	self._btnQuestRewardOriginPosX = self._btnQuestReward:GetPosX() - 120
	
	self._btnQuestGiveup:addInputEvent( "Mouse_LUp", "HandleCliekedQuestGiveup()" )
	self._btnQuestReward:addInputEvent( "Mouse_LUp", "HandleCliekedGuildQuestReward()" )
	
	self._btnQuestGiveup:addInputEvent( "Mouse_On", "questGiveUp_Over(true)" )
	self._btnQuestReward:addInputEvent( "Mouse_On", "QuestReward_Over(true)" )
	
	self._btnQuestGiveup:addInputEvent( "Mouse_Out", "questGiveUp_Over(false)" )
	self._btnQuestReward:addInputEvent( "Mouse_Out", "QuestReward_Over(false)" )
end

-- 포기 버튼--------------------------
function HandleCliekedQuestGiveup()
	local messageboxData = { title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_GIVERUP_MESSAGE_0" ), content = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_GIVERUP_MESSAGE_1" ), functionYes = ToClient_RequestGuildQuestGiveup, functionCancel = MessageBox_Empty_function, priority = UI_PP.PAUIMB_PRIORITY_LOW }
	MessageBox.showMessageBox(messageboxData)	
end

------------------------------------------------------------------
--					업데이트 해주는 함수( Frame_Guild_Quest.lua 에서 사용)
------------------------------------------------------------------
local _saveGuildTitle = ""
function FGlobal_getCompleteGuildTitle()
	return _saveGuildTitle
end
function GuildProgressQuestInfoPage:UpdateData() 
	local boolProgressing = ToClient_isProgressingGuildQuest()	-- 진행중인 임무 유무
	
	if true == boolProgressing then	
		if false == Panel_Npc_Dialog:IsShow() and true == Panel_CheckedQuest:IsShow() then	-- 대화창에서 퀘스트 받을때 뜨는 것 방지
			Panel_Current_Guild_Quest:SetShow(true)
		end

		for index = 0, 4 do -- 조건 초기화
			self._txtQuestCondition[index]:SetShow( false )
			self._txtQuestCondition[index]:SetText("")
		end
		
		local stringLen = string.len(ToClient_getCurrentGuildQuestName())
		local guildQuestTitle = ToClient_getCurrentGuildQuestName()
		_saveGuildTitle = guildQuestTitle
		self._txtQuestTitle:SetText( guildQuestTitle )
		
		local remainTime		= ToClient_getCurrentGuildQuestRemainedTime()
		local strMinute			= math.floor(remainTime/60)

		if remainTime <= 0 then
			self._txtQuestLimitTime:SetText( PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_TIMEOUT") ) -- "시간 초과"
		else
			self._txtQuestLimitTime:SetText( PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_REMAINTIME", "time_minute", strMinute ) )
		end
		local passValue	= self._txtQuestLimitTime:GetText()

		GuildQuestInfoPage._txtProgressLimitTime:SetText( passValue )	-- Frame_Guild_Quest.lua 관련 변수
	
		if 37 < stringLen then
			stringLen = 37
		end	
	
		self._btnQuestNavi		:SetPosX(self._btnQuestNaviOriginPosX + (stringLen * 4.5))
		self._btnQuestGiveup	:SetPosX(self._btnQuestGiveupOriginPosX + (stringLen * 4.5))
		self._btnQuestReward	:SetPosX(self._btnQuestRewardOriginPosX + (stringLen * 4.5))
		self._RewardPosX		= self._btnQuestReward:GetPosX()
		
		local questConditionCount         = ToClient_getCurrentGuildQuestConditionCount()
		local questConditionDefaultPosY   = 40
		for index = 0, 4, 1 do
			if index < questConditionCount then
				local currentGuildQuestInfo = ToClient_getCurrentGuildQuestConditionAt( index )
				self._txtQuestCondition[index]:SetShow(true)
				self._txtQuestCondition[index]:SetText( "- " .. currentGuildQuestInfo._desc.." ( "..currentGuildQuestInfo._currentCount.." / "..currentGuildQuestInfo._destCount.." ) " )

				local conditonPosY = 0
				if 0 == index then	-- 첫번째가 아니라면, 앞 조건의 텍스트량을 기준으로 한다.
					conditonPosY = questConditionDefaultPosY + ( index * self._txtQuestCondition[index]:GetTextSizeY() )
				else
					conditonPosY = questConditionDefaultPosY + ( index * self._txtQuestCondition[index-1]:GetTextSizeY() )
				end
				self._txtQuestCondition[index]:SetPosY( conditonPosY )

				if currentGuildQuestInfo._currentCount == currentGuildQuestInfo._destCount then	-- 조건이 완료됐으면 회색으로!
					self._txtQuestCondition[index]:SetFontColor( UI_color.C_FF626262 )
				else
					self._txtQuestCondition[index]:SetFontColor( UI_color.C_FFC4BEBE )
				end
			end
		end
			
		self._txtQuestTitle       :SetShow(true)
		self._txtQuestLimitTime   :SetShow(true)

		self._btnQuestNavi:SetShow(false)	-- 아직 지원 안함
		if true == getSelfPlayer():get():isGuildMaster() then
			self._btnQuestGiveup:SetShow(true)	
			self._btnQuestReward:SetPosX( self._RewardPosX )
		else
			self._btnQuestGiveup:SetShow(false)
			self._btnQuestReward:SetPosX(self._btnQuestGiveup:GetPosX())
		end
		if ToClient_getCurrentGuildQuestBaseRewardCount() <= 0 and ToClient_getCurrentGuildQuestSelectRewardCount() <= 0 then
			self._btnQuestReward:SetShow(false)	
		else
			self._btnQuestReward:SetShow(true)
		end

		local guildQuestSizeY = 0
		-- if 1 < questConditionCount then -- 컨디션 갯수에 따라 크기를 정한다.
			guildQuestSizeY = self._txtQuestCondition[questConditionCount - 1]:GetPosY() + self._txtQuestCondition[questConditionCount - 1]:GetSizeY() + 10
		-- else
			-- guildQuestSizeY = self._questIcon:GetPosY() + self._questIcon:GetSizeY() + 10
		-- end
		Panel_Current_Guild_Quest   :SetSize( Panel_Current_Guild_Quest:GetSizeX(), guildQuestSizeY )
		self._questBG               :SetSize( Panel_Current_Guild_Quest:GetSizeX(), Panel_Current_Guild_Quest:GetSizeY() )

	else
		Panel_Current_Guild_Quest:SetShow(false)
	end	
end

function FGlobal_QuestConditionUpdateEffect(index)	-- 좌측 퀘스트 목표 업데이트시에 이펙트효과
	-- GuildProgressQuestInfoPage._completeEff1:SetPosX( GuildProgressQuestInfoPage._txtQuestCondition[index]:GetPosX() - 120)
	-- GuildProgressQuestInfoPage._completeEff1:SetPosY( GuildProgressQuestInfoPage._txtQuestCondition[index]:GetPosY() - 110)
					
	-- 퀘스트를 클리어했다!
	-- GuildProgressQuestInfoPage._completeEff1:SetShow(true)
	-- GuildProgressQuestInfoPage._completeEff1:AddEffect("UI_QuestList01", false, 50.0, 0.0)
	-- GuildProgressQuestInfoPage._completeEff1:AddEffect("UI_DarkSpiritQuestPanel", false, 103.0, 20.0)
end

function FGlobal_CurrentGuildQuestShow()	
	if false == Panel_Current_Guild_Quest:GetShow() and true == ToClient_isProgressingGuildQuest() then
		Panel_Current_Guild_Quest:SetShow(true)
	end			
end

function FGlobal_CurrentGuildQuestHide()
	if true == Panel_Current_Guild_Quest:GetShow() then
		Panel_Current_Guild_Quest:SetShow(false)
	end
end

function GuildQuest_Update()
	GuildProgressQuestInfoPage:UpdateData()
end

function guildQuestWidget_MouseOn( isShow )
	local self = GuildProgressQuestInfoPage
	if true == isShow then
		QuestInfoData.guildQuestDescShowWindow()
		-- self._btnQuestGiveup:SetSize( 25, 25 )
		-- self._btnQuestReward:SetSize( 25, 25 )
		self._questBG:SetShow( true )
	else
		-- self._btnQuestGiveup:SetSize( 18, 18 )
		-- self._btnQuestReward:SetSize( 18, 18 )
		QuestInfoData.questDescHideWindow()
		self._questBG:SetShow( false )
	end
end

Panel_Current_Guild_Quest:addInputEvent( "Mouse_On",    "guildQuestWidget_MouseOn( true )" )
Panel_Current_Guild_Quest:addInputEvent( "Mouse_Out",   "guildQuestWidget_MouseOn( false )" )

registerEvent("FromClient_UpdateProgressGuildQuestList", 					"GuildQuest_Update")
-----------------------------------------------------------------------------